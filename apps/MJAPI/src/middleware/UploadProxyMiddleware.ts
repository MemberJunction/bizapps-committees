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

        // CORS preflight (before auth middleware runs)
        app.options('/api/upload-proxy', (_req: Request, res: Response) => {
            res.set({
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST, PUT, OPTIONS',
                'Access-Control-Allow-Headers': 'Authorization, Content-Type, x-upload-url, x-upload-method',
                'Access-Control-Max-Age': '86400',
            });
            res.status(204).end();
        });

        const uploadHandler = async (req: Request, res: Response) => {
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
                const chunks: Buffer[] = [];
                for await (const chunk of req) {
                    chunks.push(typeof chunk === 'string' ? Buffer.from(chunk) : chunk);
                }
                const body = Buffer.concat(chunks);
                console.log(`[upload-proxy] ${method} ${targetUrl.substring(0, 80)}... (${body.length} bytes)`);

                const response = await fetch(targetUrl, {
                    method,
                    headers: { 'Content-Type': 'application/octet-stream' },
                    body,
                });

                if (response.ok) {
                    const text = await response.text();
                    console.log(`[upload-proxy] Success: ${response.status}`);
                    res.status(200).json({ success: true, response: text });
                } else {
                    const errorText = await response.text();
                    console.error(`[upload-proxy] Failed: ${response.status} ${errorText}`);
                    res.status(response.status).json({ error: errorText });
                }
            } catch (err: unknown) {
                const message = err instanceof Error ? err.message : String(err);
                console.error(`[upload-proxy] Error: ${message}`);
                res.status(500).json({ error: message });
            }
        };

        app.put('/api/upload-proxy', uploadHandler);
        app.post('/api/upload-proxy', uploadHandler);
    }
}
