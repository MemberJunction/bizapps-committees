import type { Application, NextFunction, Request, RequestHandler, Response } from 'express';
import { RegisterClass } from '@memberjunction/global';
import { BaseServerMiddleware } from '@memberjunction/server';
import { assertPublicHttpsTarget } from '../security/ssrf-guard.js';

const UPLOAD_PROXY_PATH = '/api/upload-proxy';

/**
 * Upload proxy middleware for storage providers that don't support CORS.
 *
 * Browsers can't upload directly to providers like Dropbox because their
 * pre-signed URLs don't allow cross-origin requests from arbitrary domains.
 * Clients POST/PUT to /api/upload-proxy with x-upload-url and x-upload-method
 * headers; the server forwards the body to the target URL.
 *
 * SECURITY: the POST/PUT handler is registered via GetPostAuthMiddleware so it
 * mounts AFTER MJServer's unified auth middleware — routes registered through
 * ConfigureExpressApp match before that middleware and would run with no
 * authentication at all. Only the credential-less CORS preflight stays pre-auth.
 */
@RegisterClass(BaseServerMiddleware, 'mjcommittees:uploadProxy')
export class UploadProxyMiddleware extends BaseServerMiddleware {
    get Label(): string {
        return 'mjcommittees:uploadProxy';
    }

    ConfigureExpressApp(app: Application): void {
        console.log('[upload-proxy] Registering /api/upload-proxy preflight route');
        this.registerPreflightRoute(app);
    }

    /**
     * Registers the POST/PUT upload handler in the post-auth pipeline stage, where
     * the unified auth middleware has already resolved (or 401-rejected) the caller.
     */
    override GetPostAuthMiddleware(): RequestHandler[] {
        return [(req: Request, res: Response, next: NextFunction): void => {
            if (req.path === UPLOAD_PROXY_PATH && (req.method === 'POST' || req.method === 'PUT')) {
                void this.handleUpload(req, res);
                return;
            }
            next();
        }];
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
        // SECURITY (defense-in-depth): this handler mounts post-auth, so the unified auth
        // middleware has already attached req.userPayload (with the resolved MJ UserInfo in
        // userRecord). Verify the artifacts anyway — if a refactor ever moves this registration
        // back ahead of the auth middleware, requests would otherwise flow through unauthenticated.
        if (!req.userPayload?.userRecord) {
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

        try {
            const body = await this.readRequestBody(req);
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
            const message = err instanceof Error ? err.message : String(err);
            console.error(`[upload-proxy] Error: ${message}`);
            res.status(500).json({ error: message });
        }
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
