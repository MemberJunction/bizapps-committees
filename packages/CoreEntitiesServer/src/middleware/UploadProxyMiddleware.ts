import type { Application, NextFunction, Request, RequestHandler, Response } from 'express';
import { LogError } from '@memberjunction/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseServerMiddleware } from '@memberjunction/server';
import { assertPublicHttpsTarget, pinnedHttpsRequest, type PinnedHttpsResponse } from '../security/ssrf-guard.js';
import {
    applyFallbackCorsHeaders,
    parseMaxUploadBytes,
    PayloadTooLargeError,
    readBoundedStream,
    validateUploadTarget,
    type UploadTargetCheckResult,
} from '../security/upload-proxy-policy.js';

const UPLOAD_PROXY_PATH = '/api/upload-proxy';

/**
 * Upload proxy middleware for storage providers that don't support CORS.
 *
 * Browsers can't upload directly to providers like Dropbox because their
 * pre-signed URLs don't allow cross-origin requests from arbitrary domains.
 * Authenticated clients POST/PUT to /api/upload-proxy with x-upload-url and
 * x-upload-method headers; the server forwards the body to the target URL.
 */
@RegisterClass(BaseServerMiddleware, 'mjcommittees:uploadProxy')
export class UploadProxyMiddleware extends BaseServerMiddleware {
    get Label(): string {
        return 'mjcommittees:uploadProxy';
    }

    ConfigureExpressApp(app: Application): void {
        console.log('[upload-proxy] Registering /api/upload-proxy preflight route (upload handlers mount post-auth)');

        // Only the credential-less OPTIONS preflight is registered pre-auth here. The PUT/POST
        // upload routes are handled in GetPostAuthMiddleware() — see the comment there.
        this.registerPreflightRoute(app);
    }

    /**
     * SECURITY (auth): the upload routes run in the POST-auth pipeline slot, not in
     * ConfigureExpressApp. MJServer's serve() calls ConfigureExpressApp BEFORE it mounts its
     * unified auth middleware, so a route registered there is reachable with no credentials at
     * all — which made this proxy an unauthenticated relay to arbitrary public HTTPS hosts.
     * Mounted post-auth, CreateUnifiedAuthMiddleware (JWT verified against the issuer's JWKS
     * with pinned algorithms, API keys, magic link) has already 401'd any unauthenticated
     * caller and stamped req.userPayload before this handler runs.
     */
    GetPostAuthMiddleware(): RequestHandler[] {
        return [
            (req: Request, res: Response, next: NextFunction): void => {
                if (!this.isUploadProxyRequest(req)) {
                    next();
                    return;
                }
                void this.handleUpload(req, res);
            },
        ];
    }

    /** Delegates to the shared pure upload-target allowlist validator. */
    public static ValidateUploadTarget(
        targetUrl: string,
        extraAllowedHostsEnv?: string,
    ): UploadTargetCheckResult {
        return validateUploadTarget(targetUrl, extraAllowedHostsEnv);
    }

    /**
     * True when the request is a PUT/POST to /api/upload-proxy (trailing slash tolerated,
     * matching Express's default non-strict routing that the old app.put/app.post gave us).
     */
    private isUploadProxyRequest(req: Request): boolean {
        const path = req.path.endsWith('/') ? req.path.slice(0, -1) : req.path;
        return path === UPLOAD_PROXY_PATH && (req.method === 'PUT' || req.method === 'POST');
    }

    /**
     * CORS preflight (pre-auth by design: preflight requests never carry
     * credentials, and the unified auth middleware skips OPTIONS anyway).
     */
    private registerPreflightRoute(app: Application): void {
        app.options(UPLOAD_PROXY_PATH, (_req: Request, res: Response) => {
            res.set({
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST, PUT, OPTIONS',
                'Access-Control-Allow-Headers': 'Authorization, Content-Type, x-upload-url, x-upload-method',
                'Access-Control-Max-Age': '86400',
            });
            res.status(204).end();
        });
    }

    /**
     * Handles a proxied upload: validates auth, upload target allowlist, and size cap,
     * reads the raw request body, vets DNS immediately before dispatch, and forwards
     * to the pinned IP.
     */
    private async handleUpload(req: Request, res: Response): Promise<void> {
        applyFallbackCorsHeaders(res);

        // SECURITY (auth): defense in depth — this handler must only ever run behind MJServer's
        // unified auth middleware (see GetPostAuthMiddleware), which sets req.userPayload.
        if (!req.userPayload) {
            res.status(401).json({ error: 'Authentication required' });
            return;
        }
        const validated = this.validateRequestHeaders(req, res);
        if (!validated) {
            return;
        }
        await this.bufferAndForwardUpload(req, res, validated.targetUrl, validated.method, validated.maxBytes);
    }

    /**
     * Validates x-upload-url, x-upload-method, storage-provider host allowlist, and declared
     * Content-Length before buffering any request bytes. Writes the 4xx response on failure.
     */
    private validateRequestHeaders(
        req: Request,
        res: Response,
    ): { targetUrl: string; method: 'POST' | 'PUT'; maxBytes: number } | null {
        const targetUrl = req.headers['x-upload-url'] as string;
        const method = ((req.headers['x-upload-method'] as string) || 'POST').toUpperCase();
        if (!targetUrl) {
            res.status(400).json({ error: 'Missing x-upload-url header' });
            return null;
        }
        if (method !== 'POST' && method !== 'PUT') {
            res.status(400).json({ error: 'Unsupported x-upload-method' });
            return null;
        }
        const targetCheck = validateUploadTarget(targetUrl);
        if (!targetCheck.Allowed) {
            if (targetCheck.Host) {
                LogError(`[upload-proxy] Blocked upload target host '${targetCheck.Host}' — not in the storage-provider allowlist`);
            }
            res.status(targetCheck.Status).json({ error: targetCheck.Error });
            return null;
        }
        const maxBytes = parseMaxUploadBytes();
        const declaredLength = Number(req.headers['content-length']);
        if (Number.isFinite(declaredLength) && declaredLength > maxBytes) {
            res.set('Connection', 'close');
            res.status(413).json({ error: `Request body exceeds the ${maxBytes}-byte upload limit` });
            return null;
        }
        return { targetUrl, method, maxBytes };
    }

    /**
     * Buffers the bounded request body, runs the SSRF DNS check immediately before
     * forwarding, and relays the upstream response via an IP-pinned HTTPS connection.
     */
    private async bufferAndForwardUpload(
        req: Request,
        res: Response,
        targetUrl: string,
        method: 'POST' | 'PUT',
        maxBytes: number,
    ): Promise<void> {
        try {
            const body = await readBoundedStream(req, maxBytes);
            console.log(`[upload-proxy] ${method} ${targetUrl.substring(0, 80)}... (${body.length} bytes)`);

            let vetted;
            try {
                vetted = await assertPublicHttpsTarget(targetUrl, 'x-upload-url');
            } catch (err: unknown) {
                res.status(403).json({ error: err instanceof Error ? err.message : 'Blocked upload target' });
                return;
            }

            const response = await pinnedHttpsRequest(vetted, {
                method,
                headers: { 'Content-Type': 'application/octet-stream' },
                body,
            });

            await this.relayProviderResponse(response, res);
        } catch (err: unknown) {
            if (err instanceof PayloadTooLargeError) {
                console.error(`[upload-proxy] Rejected: ${err.message}`);
                res.set('Connection', 'close');
                res.status(413).json({ error: err.message });
                return;
            }
            const message = err instanceof Error ? err.message : String(err);
            console.error(`[upload-proxy] Error: ${message}`);
            res.status(500).json({ error: message });
        }
    }

    /**
     * Relays the storage provider's response back to the client.
     */
    private async relayProviderResponse(providerResponse: PinnedHttpsResponse, res: Response): Promise<void> {
        if (providerResponse.ok) {
            const text = await providerResponse.text();
            console.log(`[upload-proxy] Success: ${providerResponse.status}`);
            res.status(200).json({ success: true, response: text });
        } else {
            const errorText = await providerResponse.text();
            console.error(`[upload-proxy] Failed: ${providerResponse.status} ${errorText}`);
            res.status(providerResponse.status).json({ error: errorText });
        }
    }
}
