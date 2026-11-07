import type { Application, NextFunction, Request, RequestHandler, Response } from 'express';
import { RegisterClass } from '@memberjunction/global';
import { BaseServerMiddleware } from '@memberjunction/server';
import { assertPublicHttpsTarget } from '../security/ssrf-guard.js';

/** Default cap on a proxied upload body (100 MB). Override with UPLOAD_PROXY_MAX_BYTES. */
const DEFAULT_MAX_UPLOAD_BYTES = 100 * 1024 * 1024;

/** Thrown by readRequestBody when the buffered body exceeds the cap; mapped to HTTP 413. */
class PayloadTooLargeError extends Error {
    constructor(maxBytes: number) {
        super(`Request body exceeds the ${maxBytes}-byte upload limit`);
        this.name = 'PayloadTooLargeError';
    }
}

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
        console.log('[upload-proxy] Registering /api/upload-proxy preflight route');

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

    /**
     * True when the request is a PUT/POST to /api/upload-proxy (trailing slash tolerated,
     * matching Express's default non-strict routing that the old app.put/app.post gave us).
     */
    private isUploadProxyRequest(req: Request): boolean {
        const path = req.path.endsWith('/') ? req.path.slice(0, -1) : req.path;
        return path === '/api/upload-proxy' && (req.method === 'PUT' || req.method === 'POST');
    }

    /**
     * CORS preflight (before auth middleware runs).
     */
    private registerPreflightRoute(app: Application): void {
        app.options('/api/upload-proxy', (_req: Request, res: Response) => {
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
     * Handles a proxied upload: reads the raw request body and forwards it to
     * the target URL specified in the x-upload-url header.
     */
    private async handleUpload(req: Request, res: Response): Promise<void> {
        res.set({
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': 'Authorization, Content-Type, x-upload-url, x-upload-method',
        });
        // SECURITY (auth): defense in depth — this handler must only ever run behind MJServer's
        // unified auth middleware (see GetPostAuthMiddleware), which sets req.userPayload. If a
        // future refactor re-registers it pre-auth, the payload is absent and we refuse rather
        // than relay for an anonymous caller.
        if (!req.userPayload) {
            res.status(401).json({ error: 'Authentication required' });
            return;
        }
        const targetUrl = req.headers['x-upload-url'] as string;
        const method = ((req.headers['x-upload-method'] as string) || 'POST').toUpperCase();
        if (!targetUrl) {
            res.status(400).json({ error: 'Missing x-upload-url header' });
            return;
        }
        // SECURITY: only upload verbs — never allow this proxy to be used as a GET reader.
        if (method !== 'POST' && method !== 'PUT') {
            res.status(400).json({ error: 'Unsupported x-upload-method' });
            return;
        }
        // SECURITY (SSRF): x-upload-url is fully client-controlled and its response body is relayed
        // back to the caller. Restrict it to public HTTPS storage endpoints and reject any host that
        // resolves to a private/loopback/link-local address (blocks cloud metadata, localhost, and
        // internal services). Without this the endpoint is an authenticated read-SSRF / open proxy.
        try {
            await assertPublicHttpsTarget(targetUrl, 'x-upload-url');
        } catch (err: unknown) {
            res.status(403).json({ error: err instanceof Error ? err.message : 'Blocked upload target' });
            return;
        }

        // SECURITY (DoS): never buffer an unbounded body. Reject an oversized declared
        // Content-Length up front; readRequestBody enforces the same cap while streaming,
        // for chunked requests and clients whose declared length lies.
        const maxBytes = this.maxUploadBytes();
        const declaredLength = Number(req.headers['content-length']);
        if (Number.isFinite(declaredLength) && declaredLength > maxBytes) {
            res.status(413).json({ error: `Request body exceeds the ${maxBytes}-byte upload limit` });
            return;
        }

        try {
            const body = await this.readRequestBody(req, maxBytes);
            console.log(`[upload-proxy] ${method} ${targetUrl.substring(0, 80)}... (${body.length} bytes)`);

            const response = await fetch(targetUrl, {
                method,
                headers: { 'Content-Type': 'application/octet-stream' },
                body,
                // SECURITY: do not follow redirects — a redirect to an internal address would
                // otherwise slip past the pre-flight SSRF check above.
                redirect: 'error',
            });

            await this.relayProviderResponse(response, res);
        } catch (err: unknown) {
            if (err instanceof PayloadTooLargeError) {
                console.error(`[upload-proxy] Rejected: ${err.message}`);
                res.status(413).json({ error: err.message });
                return;
            }
            const message = err instanceof Error ? err.message : String(err);
            console.error(`[upload-proxy] Error: ${message}`);
            res.status(500).json({ error: message });
        }
    }

    /**
     * The maximum proxied body size in bytes: UPLOAD_PROXY_MAX_BYTES when set to a positive
     * number, otherwise DEFAULT_MAX_UPLOAD_BYTES (100 MB).
     */
    private maxUploadBytes(): number {
        const fromEnv = Number(process.env.UPLOAD_PROXY_MAX_BYTES);
        return Number.isFinite(fromEnv) && fromEnv > 0 ? Math.floor(fromEnv) : DEFAULT_MAX_UPLOAD_BYTES;
    }

    /**
     * Buffers the raw request stream into a single Uint8Array, enforcing `maxBytes`. Aborts the
     * stream and throws PayloadTooLargeError the moment the buffered body exceeds the cap.
     */
    private async readRequestBody(req: Request, maxBytes: number): Promise<Uint8Array<ArrayBuffer>> {
        const chunks: Uint8Array[] = [];
        let totalBytes = 0;
        for await (const chunk of req) {
            const buffer: Uint8Array = typeof chunk === 'string' ? Buffer.from(chunk) : chunk;
            totalBytes += buffer.length;
            if (totalBytes > maxBytes) {
                req.destroy(); // stop the client stream — don't keep buffering an oversized body
                throw new PayloadTooLargeError(maxBytes);
            }
            chunks.push(buffer);
        }
        // Use Uint8Array (not Buffer) so the body satisfies fetch's BodyInit type
        // under @types/node 20+, which models Buffer's backing store as ArrayBufferLike.
        return new Uint8Array(Buffer.concat(chunks));
    }

    /**
     * Relays the storage provider's response back to the client.
     */
    private async relayProviderResponse(providerResponse: globalThis.Response, res: Response): Promise<void> {
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
