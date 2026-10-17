import type { Application, NextFunction, Request, RequestHandler, Response } from 'express';
import { LogError } from '@memberjunction/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseServerMiddleware } from '@memberjunction/server';
import { assertPublicHttpsTarget } from '../security/ssrf-guard.js';

const UPLOAD_PROXY_PATH = '/api/upload-proxy';

/**
 * Hostname suffixes the proxy may forward to by default. These are the storage
 * providers MJStorage issues pre-signed upload URLs for (the `UploadUrl` that
 * the CreateFile mutation returns, which is the only legitimate source of the
 * x-upload-url header):
 *  - Azure Blob Storage SAS URLs (`<account>.blob.core.windows.net`)
 *  - AWS S3 pre-signed URLs (`<bucket>.s3.<region>.amazonaws.com`)
 *  - Google Cloud Storage / Google Drive (`storage.googleapis.com`, `www.googleapis.com`)
 *  - Dropbox temporary upload links (`content.dropboxapi.com`)
 *  - Box (`upload.box.com`, `api.box.com`)
 *  - SharePoint / Microsoft Graph upload sessions (`<tenant>.sharepoint.com`, `graph.microsoft.com`)
 *
 * Hosts can be extended per deployment via COMMITTEES_UPLOAD_PROXY_ALLOWED_HOSTS
 * (comma-separated hostname suffixes), which is ORed with these defaults.
 */
const DEFAULT_ALLOWED_UPLOAD_HOST_SUFFIXES: readonly string[] = [
    'blob.core.windows.net',
    'amazonaws.com',
    'googleapis.com',
    'dropboxapi.com',
    'box.com',
    'sharepoint.com',
    'graph.microsoft.com',
];

/**
 * Upload proxy middleware for storage providers that don't support CORS.
 *
 * Browsers can't upload directly to providers like Dropbox because their
 * pre-signed URLs don't allow cross-origin requests from arbitrary domains.
 * Clients POST/PUT to /api/upload-proxy with x-upload-url and x-upload-method
 * headers; the server forwards the body to the target URL.
 *
 * SECURITY: the PUT/POST handlers are registered through GetPostAuthMiddleware(),
 * which MJServer mounts AFTER CreateUnifiedAuthMiddleware — so an unauthenticated
 * request is rejected with 401 before it ever reaches this proxy. Registering them
 * in ConfigureExpressApp (as this class originally did) would place them BEFORE
 * the auth middleware, leaving the proxy reachable as an unauthenticated open
 * outbound relay. Only the CORS preflight route stays pre-auth, because a
 * preflight request never carries credentials.
 */
@RegisterClass(BaseServerMiddleware, 'mjcommittees:uploadProxy')
export class UploadProxyMiddleware extends BaseServerMiddleware {
    get Label(): string {
        return 'mjcommittees:uploadProxy';
    }

    ConfigureExpressApp(app: Application): void {
        console.log('[upload-proxy] Registering /api/upload-proxy preflight route (upload handlers mount post-auth)');
        this.registerPreflightRoute(app);
    }

    /**
     * The actual PUT/POST handlers, mounted by MJServer AFTER the unified auth
     * middleware — every request reaching this handler has already presented a
     * valid MJ bearer token / API key (401 otherwise) and carries req.userPayload.
     */
    GetPostAuthMiddleware(): RequestHandler[] {
        return [
            (req: Request, res: Response, next: NextFunction): void => {
                const isProxyPath = req.path === UPLOAD_PROXY_PATH || req.path === `${UPLOAD_PROXY_PATH}/`;
                if (!isProxyPath || (req.method !== 'PUT' && req.method !== 'POST')) {
                    next();
                    return;
                }
                void this.handleUpload(req, res);
            },
        ];
    }

    /**
     * CORS preflight (pre-auth by design: preflight requests never carry
     * credentials, and the unified auth middleware skips OPTIONS anyway).
     */
    private registerPreflightRoute(app: Application): void {
        app.options(UPLOAD_PROXY_PATH, (_req: Request, res: Response) => {
            res.set({
                // NOTE: `*` should ideally be narrowed to the Explorer origin(s); the host's
                // cors config is not reachable from this package, and the preflight exposes
                // nothing beyond the endpoint's existence — the upload itself requires auth.
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
        // CORS: MJServer's global CORS middleware runs before this post-auth handler and
        // sets host-configured headers when a cors config exists; fall back to `*` only
        // when it did not. `*` is tolerable here solely because a valid bearer token is
        // required to reach this handler — CORS is not the auth boundary.
        if (!res.get('Access-Control-Allow-Origin')) {
            res.set({
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Authorization, Content-Type, x-upload-url, x-upload-method',
            });
        }

        // Defense in depth: the unified auth middleware 401s unauthenticated requests
        // before this handler runs, but never relay bytes without a resolved user.
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
        // SECURITY: x-upload-url is fully client-controlled and its response body is relayed
        // back to the caller. Restrict it to the storage-provider hosts MJStorage actually
        // issues pre-signed upload URLs for (plus any deployment-configured suffixes) —
        // even an authenticated user must not be able to relay bytes to arbitrary hosts.
        if (!this.isAllowedUploadTarget(targetUrl, res)) {
            return;
        }

        try {
            const body = await this.readRequestBody(req);
            console.log(`[upload-proxy] ${method} ${targetUrl.substring(0, 80)}... (${body.length} bytes)`);

            // SECURITY (SSRF): reject any host that resolves to a private/loopback/link-local
            // address (blocks cloud metadata, localhost, and internal services). Invoked AFTER
            // the body read so the DNS vet sits immediately before fetch — the guard double-
            // resolves to narrow the DNS-rebinding window (see ssrf-guard.ts).
            try {
                await assertPublicHttpsTarget(targetUrl, 'x-upload-url');
            } catch (err: unknown) {
                res.status(403).json({ error: err instanceof Error ? err.message : 'Blocked upload target' });
                return;
            }

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
            const message = err instanceof Error ? err.message : String(err);
            console.error(`[upload-proxy] Error: ${message}`);
            res.status(500).json({ error: message });
        }
    }

    /**
     * Validates the target URL's hostname against the storage-provider allowlist.
     * On rejection, logs and writes the 4xx response itself and returns false.
     */
    private isAllowedUploadTarget(targetUrl: string, res: Response): boolean {
        let url: URL;
        try {
            url = new URL(targetUrl);
        } catch {
            res.status(400).json({ error: 'Invalid x-upload-url' });
            return false;
        }
        if (url.protocol !== 'https:') {
            res.status(403).json({ error: 'x-upload-url must use https' });
            return false;
        }
        const host = url.hostname.toLowerCase();
        const configured = (process.env['COMMITTEES_UPLOAD_PROXY_ALLOWED_HOSTS'] ?? '')
            .split(',')
            .map((s) => s.trim().toLowerCase().replace(/^\./, ''))
            .filter((s) => s.length > 0);
        const allowed = [...DEFAULT_ALLOWED_UPLOAD_HOST_SUFFIXES, ...configured];
        const matches = allowed.some((suffix) => host === suffix || host.endsWith(`.${suffix}`));
        if (!matches) {
            LogError(`[upload-proxy] Blocked upload target host '${host}' — not in the storage-provider allowlist`);
            res.status(403).json({ error: 'x-upload-url host is not an allowed storage provider' });
            return false;
        }
        return true;
    }

    /**
     * Buffers the raw request stream into a single Uint8Array.
     */
    private async readRequestBody(req: Request): Promise<Uint8Array<ArrayBuffer>> {
        const chunks: Uint8Array[] = [];
        for await (const chunk of req) {
            chunks.push(typeof chunk === 'string' ? Buffer.from(chunk) : chunk);
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
