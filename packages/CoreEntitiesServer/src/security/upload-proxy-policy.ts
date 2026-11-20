/**
 * Pure, framework-free security policy helpers for UploadProxyMiddleware:
 *  - Storage-provider hostname allowlist (`validateUploadTarget`)
 *  - Configurable upload body size cap (`parseMaxUploadBytes`, `readBoundedStream`)
 *  - Non-clobbering CORS fallback header helper (`applyFallbackCorsHeaders`)
 *
 * Kept free of `@memberjunction/server` imports so unit tests can exercise every
 * security boundary directly without triggering MJServer startup config validation.
 */
import type { Readable } from 'node:stream';

/** Default cap on a proxied upload body (100 MB). Override with UPLOAD_PROXY_MAX_BYTES. */
export const DEFAULT_MAX_UPLOAD_BYTES = 100 * 1024 * 1024;

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
export const DEFAULT_ALLOWED_UPLOAD_HOST_SUFFIXES: readonly string[] = [
    'blob.core.windows.net',
    'amazonaws.com',
    'googleapis.com',
    'dropboxapi.com',
    'box.com',
    'sharepoint.com',
    'graph.microsoft.com',
];

/** Thrown by readBoundedStream when the buffered body exceeds the configured cap; mapped to HTTP 413. */
export class PayloadTooLargeError extends Error {
    constructor(maxBytes: number) {
        super(`Request body exceeds the ${maxBytes}-byte upload limit`);
        this.name = 'PayloadTooLargeError';
    }
}

export interface UploadTargetCheckResult {
    Allowed: boolean;
    Status: number;
    Error?: string;
    Host?: string;
}

export interface CorsHeaderTarget {
    get(name: string): string | undefined;
    set(headers: Record<string, string>): unknown;
}

/**
 * Validates a target upload URL against the HTTPS scheme and storage-provider host
 * suffix allowlist (default MJStorage providers + optional deployment-configured suffixes).
 */
export function validateUploadTarget(
    targetUrl: string,
    extraAllowedHostsEnv: string = process.env['COMMITTEES_UPLOAD_PROXY_ALLOWED_HOSTS'] ?? '',
): UploadTargetCheckResult {
    let url: URL;
    try {
        url = new URL(targetUrl);
    } catch {
        return { Allowed: false, Status: 400, Error: 'Invalid x-upload-url' };
    }
    if (url.protocol !== 'https:') {
        return { Allowed: false, Status: 403, Error: 'x-upload-url must use https' };
    }
    const host = url.hostname.toLowerCase();
    const configured = extraAllowedHostsEnv
        .split(',')
        .map(s => s.trim().toLowerCase().replace(/^\./, ''))
        .filter(s => s.length > 0);
    const allowed = [...DEFAULT_ALLOWED_UPLOAD_HOST_SUFFIXES, ...configured];
    const matches = allowed.some(suffix => host === suffix || host.endsWith(`.${suffix}`));
    if (!matches) {
        return { Allowed: false, Status: 403, Error: 'x-upload-url host is not an allowed storage provider', Host: host };
    }
    return { Allowed: true, Status: 200, Host: host };
}

/**
 * Parses the maximum proxied body size in bytes: positive `UPLOAD_PROXY_MAX_BYTES`
 * env override when valid, otherwise `DEFAULT_MAX_UPLOAD_BYTES` (100 MB).
 */
export function parseMaxUploadBytes(rawEnv: string | undefined = process.env['UPLOAD_PROXY_MAX_BYTES']): number {
    const fromEnv = Number(rawEnv);
    return Number.isFinite(fromEnv) && fromEnv > 0 ? Math.floor(fromEnv) : DEFAULT_MAX_UPLOAD_BYTES;
}

/**
 * Buffers a Node Readable stream into a single Uint8Array, enforcing `maxBytes`.
 * Destroys the stream and throws `PayloadTooLargeError` the moment the body exceeds the cap.
 */
export async function readBoundedStream(stream: Readable, maxBytes: number): Promise<Uint8Array<ArrayBuffer>> {
    const chunks: Uint8Array[] = [];
    let totalBytes = 0;
    for await (const chunk of stream) {
        const buffer: Uint8Array = typeof chunk === 'string' ? Buffer.from(chunk) : (chunk as Uint8Array);
        totalBytes += buffer.length;
        if (totalBytes > maxBytes) {
            stream.destroy(); // stop reading immediately — never buffer an unbounded body
            throw new PayloadTooLargeError(maxBytes);
        }
        chunks.push(buffer);
    }
    return new Uint8Array(Buffer.concat(chunks));
}

/**
 * Respects host-configured CORS headers from MJServer's global CORS middleware when present,
 * falling back to `*` only when `Access-Control-Allow-Origin` is unset.
 */
export function applyFallbackCorsHeaders(res: CorsHeaderTarget): void {
    if (!res.get('Access-Control-Allow-Origin')) {
        res.set({
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': 'Authorization, Content-Type, x-upload-url, x-upload-method',
        });
    }
}
