/**
 * SSRF guard for server-side fetches of client-influenced URLs.
 *
 * Mirrors the proven host/IP allow policy already used by UploadProxyMiddleware, extracted here so
 * any code path that fetches a URL derived from stored/caller data (e.g. a meeting's TranscriptURL)
 * can reject targets that resolve to private/loopback/link-local/CGNAT/cloud-metadata addresses
 * before issuing the request.
 */
import { isIP } from 'net';
import { lookup as lookupCb } from 'dns';
import { promisify } from 'util';

const lookup = promisify(lookupCb);

/**
 * True for loopback / private / link-local / unspecified / CGNAT addresses that must never be
 * reachable via a server-side fetch (IPv4, IPv6, and IPv4-mapped IPv6).
 */
export function isPrivateAddress(ip: string): boolean {
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
 * Ensures a URL is an http(s) endpoint that does not resolve to a private/loopback/link-local/
 * metadata address. Throws if the target is disallowed. Callers should also pass
 * `redirect: 'error'` to fetch so an allowed host cannot 302 to an internal one.
 */
export async function assertPublicHttpTarget(rawUrl: string): Promise<void> {
    let url: URL;
    try {
        url = new URL(rawUrl);
    } catch {
        throw new Error('Invalid URL');
    }
    if (url.protocol !== 'https:' && url.protocol !== 'http:') {
        throw new Error('URL must use http or https');
    }
    const host = url.hostname.replace(/^\[|\]$/g, ''); // strip IPv6 [brackets]
    const addresses: string[] = isIP(host)
        ? [host]
        : (await lookup(host, { all: true })).map((r) => r.address);
    if (addresses.length === 0) {
        throw new Error('URL host did not resolve');
    }
    for (const ip of addresses) {
        if (isPrivateAddress(ip)) {
            throw new Error('URL resolves to a disallowed address');
        }
    }
}
