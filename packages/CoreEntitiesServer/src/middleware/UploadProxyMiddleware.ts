import type { Application, Request, Response } from 'express';
import { RegisterClass } from '@memberjunction/global';
import { BaseServerMiddleware } from '@memberjunction/server';

/**
 * Upload proxy middleware for storage providers that don't support CORS.
 *
 * Browsers can't upload directly to providers like Dropbox because their
 * pre-signed URLs don't allow cross-origin requests from arbitrary domains.
 * Clients POST/PUT to /api/upload-proxy with x-upload-url and x-upload-method
 * headers; the server forwards the body to the target URL.
 */
@RegisterClass(BaseServerMiddleware, 'mjcommittees:uploadProxy')
export class UploadProxyMiddleware extends BaseServerMiddleware {
    get Label(): string {
        return 'mjcommittees:uploadProxy';
    }

    ConfigureExpressApp(app: Application): void {
        console.log('[upload-proxy] Registering /api/upload-proxy routes');

        this.registerPreflightRoute(app);

        const uploadHandler = (req: Request, res: Response) => this.handleUpload(req, res);
        app.put('/api/upload-proxy', uploadHandler);
        app.post('/api/upload-proxy', uploadHandler);
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
        const targetUrl = req.headers['x-upload-url'] as string;
        const method = (req.headers['x-upload-method'] as string) || 'POST';
        if (!targetUrl) {
            res.status(400).json({ error: 'Missing x-upload-url header' });
            return;
        }

        try {
            const body = await this.readRequestBody(req);
            console.log(`[upload-proxy] ${method} ${targetUrl.substring(0, 80)}... (${body.length} bytes)`);

            const response = await fetch(targetUrl, {
                method,
                headers: { 'Content-Type': 'application/octet-stream' },
                body,
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
