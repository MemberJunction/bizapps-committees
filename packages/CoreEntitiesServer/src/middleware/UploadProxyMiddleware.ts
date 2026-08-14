import type { Application, Request, Response } from 'express';
import { lookup } from 'node:dns/promises';
import { isIP } from 'node:net';
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
            await this.assertPublicHttpsTarget(targetUrl);
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
     * SSRF guard: ensures a client-supplied upload target is a public HTTPS endpoint and does not
     * resolve to a private/loopback/link-local/metadata address. Throws if the target is disallowed.
     */
    private async assertPublicHttpsTarget(rawUrl: string): Promise<void> {
        let url: URL;
        try {
            url = new URL(rawUrl);
        } catch {
            throw new Error('Invalid x-upload-url');
        }
        if (url.protocol !== 'https:') {
            throw new Error('x-upload-url must use https');
        }
        const host = url.hostname.replace(/^\[|\]$/g, ''); // strip IPv6 [brackets]
        const addresses: string[] = isIP(host)
            ? [host]
            : (await lookup(host, { all: true })).map(r => r.address);
        if (addresses.length === 0) {
            throw new Error('x-upload-url host did not resolve');
        }
        for (const ip of addresses) {
            if (this.isPrivateAddress(ip)) {
                throw new Error('x-upload-url resolves to a disallowed address');
            }
        }
    }

    /**
     * True for loopback / private / link-local / unspecified / CGNAT addresses that must never be
     * reachable through the upload proxy (IPv4, IPv6, and IPv4-mapped IPv6).
     */
    private isPrivateAddress(ip: string): boolean {
        const mapped = ip.match(/^::ffff:(\d{1,3}(?:\.\d{1,3}){3})$/i);
        const addr = mapped ? mapped[1] : ip;
        if (isIP(addr) === 4) {
            const [a, b] = addr.split('.').map(Number);
            if (a === 0 || a === 10 || a === 127) return true;
            if (a === 169 && b === 254) return true;              // link-local + cloud metadata
            if (a === 172 && b >= 16 && b <= 31) return true;
            if (a === 192 && b === 168) return true;
            if (a === 100 && b >= 64 && b <= 127) return true;    // CGNAT
            return false;
        }
        const lower = ip.toLowerCase();
        if (lower === '::' || lower === '::1') return true;       // unspecified / loopback
        if (lower.startsWith('fe80')) return true;               // link-local
        if (lower.startsWith('fc') || lower.startsWith('fd')) return true; // unique local (fc00::/7)
        return false;
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
