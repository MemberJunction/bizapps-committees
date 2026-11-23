/**
 * Shared SSRF guard for any server-side HTTPS request to a client-supplied URL.
 *
 * Used by the upload proxy (x-upload-url header) and the minutes service
 * (Meeting.TranscriptURL / TranscriptURL override).
 *
 * SECURITY (DNS rebinding + redirect bypass):
 *  1. `assertPublicHttpsTarget` validates scheme (`https:`), resolves EVERY IP
 *     address via the OS resolver, and rejects any private, loopback, link-local,
 *     cloud-metadata, CGNAT, ULA, multicast, reserved, or IPv4-mapped/compatible
 *     IPv6 address (both dotted and hex forms such as `[::ffff:7f00:1]`).
 *  2. `pinnedHttpsRequest` connects strictly to the already-vetted IP via a
 *     pinned `lookup` callback on `node:https` (preserving TLS SNI and
 *     certificate verification against the original hostname), and refuses all
 *     3xx redirects. This closes the DNS-rebinding TOCTOU window without extra
 *     dependencies and without false positives on round-robin CDN DNS.
 */
import { lookup } from 'node:dns/promises';
import type { LookupAddress, LookupOneOptions } from 'node:dns';
import { request as httpsRequest } from 'node:https';
import type { IncomingMessage } from 'node:http';
import { isIP } from 'node:net';

export interface VettedAddress {
    address: string;
    family: 4 | 6;
}

export interface VettedHttpsTarget {
    url: URL;
    hostname: string;
    addresses: ReadonlyArray<VettedAddress>;
}

export interface PinnedHttpsRequestOptions {
    method: 'GET' | 'POST' | 'PUT';
    headers?: Record<string, string>;
    body?: Uint8Array;
    timeoutMs?: number;
}

export interface PinnedHttpsResponse {
    ok: boolean;
    status: number;
    text(): Promise<string>;
}

/** Blocked IPv4 CIDR ranges expressed as `[network, prefixLength]`. */
const BLOCKED_IPV4_CIDRS: ReadonlyArray<readonly [string, number]> = [
    ['0.0.0.0', 8],       // unspecified / "this" network
    ['10.0.0.0', 8],      // RFC 1918 private
    ['100.64.0.0', 10],   // CGNAT (RFC 6598)
    ['127.0.0.0', 8],     // loopback
    ['169.254.0.0', 16],  // link-local + cloud metadata (169.254.169.254)
    ['172.16.0.0', 12],   // RFC 1918 private
    ['192.0.0.0', 24],    // IETF protocol assignments
    ['192.0.2.0', 24],    // TEST-NET-1
    ['192.88.99.0', 24],  // 6to4 relay anycast
    ['192.168.0.0', 16],  // RFC 1918 private
    ['198.18.0.0', 15],   // benchmarking
    ['198.51.100.0', 24], // TEST-NET-2
    ['203.0.113.0', 24],  // TEST-NET-3
    ['224.0.0.0', 4],     // multicast
    ['240.0.0.0', 4],     // reserved (incl. 255.255.255.255)
];

const DEFAULT_TIMEOUT_MS = 60_000;

/**
 * SSRF guard: ensures a client-supplied target is a public HTTPS endpoint and does not
 * resolve to a private/loopback/link-local/metadata/reserved address. Returns the vetted
 * URL and resolved public addresses so callers can pin the outbound connection to them.
 */
export async function assertPublicHttpsTarget(rawUrl: string, label: string = 'URL'): Promise<VettedHttpsTarget> {
    let url: URL;
    try {
        url = new URL(rawUrl);
    } catch {
        throw new Error(`Invalid ${label}`);
    }
    if (url.protocol !== 'https:') {
        throw new Error(`${label} must use https`);
    }
    const hostname = url.hostname.replace(/^\[|\]$/g, ''); // strip IPv6 [brackets]
    if (!hostname) {
        throw new Error(`Invalid ${label}`);
    }
    const literalFamily = isIP(hostname);
    if (literalFamily === 4 || literalFamily === 6) {
        if (isBlockedIpAddress(hostname)) {
            throw new Error(`${label} resolves to a disallowed address`);
        }
        return { url, hostname, addresses: [{ address: hostname, family: literalFamily }] };
    }
    const addresses = await resolvePublicAddresses(hostname, label);
    return { url, hostname, addresses };
}

/**
 * Resolves every address for `hostname` and throws if the lookup is empty or ANY
 * resolved address is blocked.
 */
async function resolvePublicAddresses(hostname: string, label: string): Promise<VettedAddress[]> {
    const records = await lookup(hostname, { all: true });
    if (records.length === 0) {
        throw new Error(`${label} host did not resolve`);
    }
    const vetted: VettedAddress[] = [];
    for (const record of records) {
        if (isBlockedIpAddress(record.address) || (record.family !== 4 && record.family !== 6)) {
            throw new Error(`${label} resolves to a disallowed address`);
        }
        vetted.push({ address: record.address, family: record.family });
    }
    return vetted;
}

/**
 * Executes an HTTPS request pinned strictly to the already-vetted public IP address(es)
 * in `target`. TLS SNI and certificate hostname verification still validate against
 * `target.hostname`, and all 3xx redirects are refused.
 */
export function pinnedHttpsRequest(
    target: VettedHttpsTarget,
    options: PinnedHttpsRequestOptions,
): Promise<PinnedHttpsResponse> {
    if (target.addresses.length === 0) {
        return Promise.reject(new Error('No vetted addresses available for target'));
    }
    const pinned = target.addresses[0];
    const headers: Record<string, string> = { ...(options.headers ?? {}) };
    if (options.body) {
        headers['Content-Length'] = String(options.body.byteLength);
    }
    const timeoutMs = options.timeoutMs ?? DEFAULT_TIMEOUT_MS;

    return new Promise<PinnedHttpsResponse>((resolve, reject) => {
        const req = httpsRequest(
            target.url,
            {
                method: options.method,
                headers,
                agent: false,
                family: pinned.family,
                servername: isIP(target.hostname) ? undefined : target.hostname,
                lookup: createPinnedLookup(target.addresses),
                timeout: timeoutMs,
            },
            (res: IncomingMessage) => handlePinnedResponse(res, resolve, reject),
        );

        req.on('timeout', () => {
            req.destroy(new Error(`Upstream HTTPS request timed out after ${timeoutMs}ms`));
        });
        req.on('error', reject);

        if (options.body) {
            req.end(Buffer.from(options.body.buffer, options.body.byteOffset, options.body.byteLength));
        } else {
            req.end();
        }
    });
}

/**
 * Handles the upstream IncomingMessage, rejecting redirects and collecting the response body.
 */
function handlePinnedResponse(
    res: IncomingMessage,
    resolve: (response: PinnedHttpsResponse) => void,
    reject: (error: Error) => void,
): void {
    const status = res.statusCode ?? 0;
    if (status >= 300 && status < 400) {
        res.destroy();
        reject(new Error(`Unexpected redirect (HTTP ${status}) blocked by SSRF guard`));
        return;
    }
    const chunks: string[] = [];
    res.setEncoding('utf8');
    res.on('data', (chunk: string) => {
        chunks.push(chunk);
    });
    res.on('end', () => {
        const bodyText = chunks.join('');
        resolve({
            ok: status >= 200 && status < 300,
            status,
            text: () => Promise.resolve(bodyText),
        });
    });
    res.on('error', reject);
}

/**
 * Returns a `net.LookupFunction`-compatible callback that always resolves to the vetted
 * address(es) without consulting DNS again. Handles both single-address and `{ all: true }`
 * invocations used by Node 20+ autoSelectFamily.
 */
export function createPinnedLookup(
    addresses: ReadonlyArray<VettedAddress>,
): (
    hostname: string,
    options: Omit<LookupOneOptions, 'all'> & { all?: boolean },
    callback: (err: NodeJS.ErrnoException | null, address: string, family: number) => void,
) => void {
    const primary = addresses[0];
    return (_hostname, options, callback) => {
        if (options && options.all === true) {
            const list: LookupAddress[] = addresses.map(a => ({ address: a.address, family: a.family }));
            // Node's runtime expects (null, LookupAddress[]) when options.all === true;
            // @types/node 20.14.2's LookupFunction types only the single-address overload.
            (callback as unknown as (err: NodeJS.ErrnoException | null, list: LookupAddress[]) => void)(null, list);
            return;
        }
        callback(null, primary.address, primary.family);
    };
}

/**
 * True for loopback, private, link-local, metadata, unspecified, CGNAT, ULA, multicast,
 * reserved, or IPv4-mapped/compatible IPv6 addresses (both dotted and hex representations).
 * Fails closed on any unrecognized literal.
 */
export function isBlockedIpAddress(address: string): boolean {
    const family = isIP(address);
    if (family === 4) {
        const value = parseIPv4(address);
        return value === null ? true : isBlockedIPv4Value(value);
    }
    if (family === 6) {
        const groups = parseIPv6(address);
        return groups === null ? true : isBlockedIPv6Groups(groups);
    }
    return true;
}

/** Parses a dotted-quad IPv4 literal into an unsigned 32-bit integer, or null if malformed. */
function parseIPv4(ip: string): number | null {
    const octets = ip.split('.');
    if (octets.length !== 4) {
        return null;
    }
    let value = 0;
    for (const octet of octets) {
        if (!/^\d{1,3}$/.test(octet)) {
            return null;
        }
        const num = Number(octet);
        if (num > 255) {
            return null;
        }
        value = (value << 8) | num;
    }
    return value >>> 0;
}

/** True when an unsigned 32-bit IPv4 value falls inside any blocked CIDR. */
function isBlockedIPv4Value(value: number): boolean {
    for (const [network, prefix] of BLOCKED_IPV4_CIDRS) {
        const base = parseIPv4(network);
        if (base === null) continue;
        const mask = prefix === 0 ? 0 : (0xffffffff << (32 - prefix)) >>> 0;
        if ((value & mask) === (base & mask)) {
            return true;
        }
    }
    return false;
}

/** Expands an IPv6 literal (including `::` and dotted-IPv4 tails) into eight 16-bit groups. */
function parseIPv6(ip: string): number[] | null {
    const zoneIndex = ip.indexOf('%');
    const addr = zoneIndex === -1 ? ip : ip.slice(0, zoneIndex);
    const halves = addr.split('::');
    if (halves.length > 2) {
        return null;
    }
    const head = parseIPv6Groups(halves[0]);
    if (head === null) {
        return null;
    }
    if (halves.length === 1) {
        return head.length === 8 ? head : null;
    }
    const tail = parseIPv6Groups(halves[1]);
    if (tail === null) {
        return null;
    }
    const missing = 8 - head.length - tail.length;
    if (missing < 0) {
        return null;
    }
    return [...head, ...new Array<number>(missing).fill(0), ...tail];
}

/** Parses one half of an IPv6 address (before or after `::`) into 16-bit groups. */
function parseIPv6Groups(part: string): number[] | null {
    if (part === '') {
        return [];
    }
    const tokens = part.split(':');
    const groups: number[] = [];
    for (let i = 0; i < tokens.length; i++) {
        const token = tokens[i];
        if (token.includes('.')) {
            if (i !== tokens.length - 1) return null;
            const v4 = parseIPv4(token);
            if (v4 === null) return null;
            groups.push((v4 >>> 16) & 0xffff, v4 & 0xffff);
        } else {
            if (!/^[0-9a-fA-F]{1,4}$/.test(token)) return null;
            groups.push(parseInt(token, 16));
        }
    }
    return groups;
}

/** Evaluates expanded IPv6 groups against blocked IPv6 ranges and embedded IPv4 ranges. */
function isBlockedIPv6Groups(groups: number[]): boolean {
    if (groups.every(g => g === 0)) return true; // ::
    if (groups.slice(0, 7).every(g => g === 0) && groups[7] === 1) return true; // ::1

    // Unwrap IPv4-mapped (::ffff:0:0/96) and IPv4-compatible (::/96) — covers both
    // dotted (::ffff:127.0.0.1) and URL-normalized hex (::ffff:7f00:1) forms.
    const firstFiveZero = groups.slice(0, 5).every(g => g === 0);
    if (firstFiveZero && (groups[5] === 0xffff || groups[5] === 0)) {
        const embedded = (((groups[6] << 16) >>> 0) | groups[7]) >>> 0;
        if (isBlockedIPv4Value(embedded)) {
            return true;
        }
    }

    if ((groups[0] & 0xfe00) === 0xfc00) return true; // fc00::/7 (ULA)
    if ((groups[0] & 0xffc0) === 0xfe80) return true; // fe80::/10 (link-local)
    if ((groups[0] & 0xff00) === 0xff00) return true; // ff00::/8 (multicast)
    return false;
}
