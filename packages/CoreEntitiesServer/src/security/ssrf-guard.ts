/**
 * Shared SSRF guard for any server-side fetch of a client-supplied URL.
 *
 * Used by the upload proxy (x-upload-url header) and the minutes service
 * (Meeting.TranscriptURL / TranscriptURL override). Callers must also pass
 * `redirect: 'error'` to fetch — a redirect to an internal address would
 * otherwise slip past this pre-flight check.
 */
import { lookup } from 'node:dns/promises';
import { isIP } from 'node:net';

/**
 * SSRF guard: ensures a client-supplied target is a public HTTPS endpoint on the default
 * port (443) and does not resolve to a private/loopback/link-local/metadata address.
 * Throws a descriptive error if the target is disallowed. `label` names the offending
 * input in error messages.
 *
 * Known limitation (TOCTOU / DNS rebinding): the hostname is resolved HERE, before the
 * caller's fetch performs its own resolution — a DNS record that changes between this
 * check and the connection can still point the request at an internal address. Fully
 * closing that gap requires pinning the resolved IP on the socket/agent the fetch uses,
 * which is deliberately not implemented yet.
 */
export async function assertPublicHttpsTarget(rawUrl: string, label: string = 'URL'): Promise<void> {
    let url: URL;
    try {
        url = new URL(rawUrl);
    } catch {
        throw new Error(`Invalid ${label}`);
    }
    if (url.protocol !== 'https:') {
        throw new Error(`${label} must use https`);
    }
    // Pin the target to the default HTTPS port. Legitimate storage providers serve
    // pre-signed URLs on 443; a caller-chosen port would let the proxy reach arbitrary
    // services on otherwise-allowed hosts.
    if (url.port !== '' && url.port !== '443') {
        throw new Error(`${label} must use the default https port (443)`);
    }
    const host = url.hostname.replace(/^\[|\]$/g, ''); // strip IPv6 [brackets]
    const addresses: string[] = isIP(host)
        ? [host]
        : (await lookup(host, { all: true })).map(r => r.address);
    if (addresses.length === 0) {
        throw new Error(`${label} host did not resolve`);
    }
    for (const ip of addresses) {
        if (isPrivateAddress(ip)) {
            throw new Error(`${label} resolves to a disallowed address`);
        }
    }
}

/**
 * True for loopback / private / link-local / unspecified / CGNAT addresses that must never be
 * reachable through a server-side fetch of a client-supplied URL (IPv4, IPv6, and
 * IPv4-mapped IPv6).
 */
function isPrivateAddress(ip: string): boolean {
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
