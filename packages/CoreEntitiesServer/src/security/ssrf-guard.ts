/**
 * Shared SSRF guard for any server-side fetch of a client-supplied URL.
 *
 * Used by the upload proxy (x-upload-url header) and the minutes service
 * (Meeting.TranscriptURL / TranscriptURL override). Callers must also pass
 * `redirect: 'error'` to fetch — a redirect to an internal address would
 * otherwise slip past this pre-flight check — and must call this guard
 * IMMEDIATELY before fetch() (no awaited work in between) to keep the
 * residual DNS-rebinding window as small as possible.
 */
import { lookup } from 'node:dns/promises';
import { isIP } from 'node:net';

/**
 * SSRF guard: ensures a client-supplied target is a public HTTPS endpoint and does not
 * resolve to a private/loopback/link-local/metadata address. Throws a descriptive error
 * if the target is disallowed. `label` names the offending input in error messages.
 *
 * SECURITY (DNS rebinding / TOCTOU): fetch() resolves the hostname AGAIN after this
 * guard approves it, so an attacker-controlled low-TTL record could answer with a
 * public address here and a private one for fetch's own lookup. undici is not a
 * declared dependency of this package, so the connection cannot be pinned to the
 * vetted IP via a custom Agent/dispatcher; instead the guard resolves TWICE and
 * requires the second answer set to be a subset of the first (and all public).
 * A residual window of up to one DNS TTL remains between the second resolve and
 * fetch's own lookup — which is why callers must fetch immediately after this guard.
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
    const host = url.hostname.replace(/^\[|\]$/g, ''); // strip IPv6 [brackets]
    if (isIP(host)) {
        // Literal IP — no DNS involved, so no rebinding window; a single check suffices.
        if (isPrivateAddress(host)) {
            throw new Error(`${label} resolves to a disallowed address`);
        }
        return;
    }
    const firstAnswer = await resolvePublicAddresses(host, label);
    // Second resolve: a rebinding server flip-flops its answers between queries, so any
    // address not present in the first (just-vetted) answer set is treated as hostile.
    const secondAnswer = await resolvePublicAddresses(host, label);
    const vetted = new Set(firstAnswer);
    for (const ip of secondAnswer) {
        if (!vetted.has(ip)) {
            throw new Error(`${label} DNS resolution is unstable (possible rebinding)`);
        }
    }
}

/**
 * Resolves every address for `host` and throws if the lookup is empty or ANY
 * resolved address is private/loopback/link-local/metadata.
 */
async function resolvePublicAddresses(host: string, label: string): Promise<string[]> {
    const addresses: string[] = (await lookup(host, { all: true })).map(r => r.address);
    if (addresses.length === 0) {
        throw new Error(`${label} host did not resolve`);
    }
    for (const ip of addresses) {
        if (isPrivateAddress(ip)) {
            throw new Error(`${label} resolves to a disallowed address`);
        }
    }
    return addresses;
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
