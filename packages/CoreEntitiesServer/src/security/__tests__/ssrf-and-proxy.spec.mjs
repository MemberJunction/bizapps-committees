import assert from 'node:assert/strict';
import { Readable } from 'node:stream';
import { describe, it } from 'node:test';
import {
    assertPublicHttpsTarget,
    createPinnedLookup,
    isBlockedIpAddress,
} from '../../../dist/security/ssrf-guard.js';
import {
    applyFallbackCorsHeaders,
    DEFAULT_MAX_UPLOAD_BYTES,
    parseMaxUploadBytes,
    PayloadTooLargeError,
    readBoundedStream,
    validateUploadTarget,
} from '../../../dist/security/upload-proxy-policy.js';

describe('ssrf-guard: isBlockedIpAddress', () => {
    it('blocks private, loopback, link-local, metadata, CGNAT, multicast, and reserved IPv4 addresses', () => {
        const blocked = [
            '0.0.0.0',
            '10.0.0.1',
            '100.64.0.1',
            '100.127.255.254',
            '127.0.0.1',
            '169.254.169.254',
            '172.16.0.1',
            '172.31.255.255',
            '192.168.1.1',
            '192.0.2.1',
            '224.0.0.1',
            '240.0.0.1',
            '255.255.255.255',
        ];
        for (const ip of blocked) {
            assert.equal(isBlockedIpAddress(ip), true, `expected ${ip} to be blocked`);
        }
    });

    it('blocks IPv6 loopback, unspecified, ULA, full fe80::/10 link-local, multicast, and dotted/hex IPv4-mapped forms', () => {
        const blocked = [
            '::',
            '::1',
            'fe80::1',
            'fe90::1',
            'febf::1',
            'fc00::1',
            'fd12:3456::1',
            'ff02::1',
            '::ffff:127.0.0.1',
            '::ffff:7f00:1',
            '::ffff:169.254.169.254',
            '::ffff:a9fe:a9fe',
            '::ffff:10.0.0.1',
            '::ffff:a00:1',
            'not-an-ip',
        ];
        for (const ip of blocked) {
            assert.equal(isBlockedIpAddress(ip), true, `expected ${ip} to be blocked`);
        }
    });

    it('allows genuinely public IPv4, IPv6, and public IPv4-mapped IPv6 addresses', () => {
        const allowed = [
            '93.184.216.34',
            '8.8.8.8',
            '1.1.1.1',
            '172.32.0.1',
            '100.128.0.1',
            '2606:2800:220:1:248:1893:25c8:1946',
            '::ffff:93.184.216.34',
            '::ffff:5db8:d822',
        ];
        for (const ip of allowed) {
            assert.equal(isBlockedIpAddress(ip), false, `expected ${ip} to be allowed`);
        }
    });
});

describe('ssrf-guard: assertPublicHttpsTarget & createPinnedLookup', () => {
    it('rejects non-https, invalid, private IPv4, and URL-normalized hex IPv4-mapped IPv6 targets', async () => {
        const rejected = [
            'http://93.184.216.34/doc',
            'not-a-url',
            'https://127.0.0.1/secret',
            'https://169.254.169.254/latest/meta-data/',
            'https://[::1]/secret',
            'https://[::ffff:127.0.0.1]/secret',
            'https://[::ffff:169.254.169.254]/latest/meta-data/',
            'https://[fe90::1]/secret',
        ];
        for (const target of rejected) {
            await assert.rejects(() => assertPublicHttpsTarget(target, 'test URL'), `expected ${target} to reject`);
        }
    });

    it('accepts a public HTTPS IP literal and returns its vetted address', async () => {
        const vetted = await assertPublicHttpsTarget('https://93.184.216.34/upload?sig=1', 'x-upload-url');
        assert.equal(vetted.hostname, '93.184.216.34');
        assert.deepEqual(vetted.addresses, [{ address: '93.184.216.34', family: 4 }]);
    });

    it('createPinnedLookup returns the vetted address in both single and all:true modes', () => {
        const lookupFn = createPinnedLookup([{ address: '93.184.216.34', family: 4 }]);
        let singleResult = null;
        lookupFn('evil.example', {}, (err, address, family) => {
            singleResult = { err, address, family };
        });
        assert.deepEqual(singleResult, { err: null, address: '93.184.216.34', family: 4 });

        let allResult = null;
        lookupFn('evil.example', { all: true }, (err, list) => {
            allResult = { err, list };
        });
        assert.deepEqual(allResult, { err: null, list: [{ address: '93.184.216.34', family: 4 }] });
    });
});

describe('upload-proxy-policy', () => {
    it('allows default MJStorage provider hosts and configured extra hosts', () => {
        const allowed = [
            'https://acct.blob.core.windows.net/container/file.pdf?sv=1',
            'https://mybucket.s3.us-east-1.amazonaws.com/key',
            'https://storage.googleapis.com/bucket/object',
            'https://content.dropboxapi.com/apitul/1/abc',
            'https://upload.box.com/api/2.0/files/content',
            'https://contoso.sharepoint.com/sites/docs/upload',
            'https://graph.microsoft.com/v1.0/drives/1/items/upload',
        ];
        for (const u of allowed) {
            const res = validateUploadTarget(u, '');
            assert.equal(res.Allowed, true, `expected ${u} to be allowed`);
        }
        const custom = validateUploadTarget(
            'https://files.internal-storage.example.org/upload',
            '.internal-storage.example.org, other.example.net',
        );
        assert.equal(custom.Allowed, true);
    });

    it('rejects non-allowlisted hosts, suffix lookalikes, non-https, and invalid URLs', () => {
        const disallowed = [
            ['not-a-url', 400],
            ['http://acct.blob.core.windows.net/file', 403],
            ['https://attacker.example.com/collect', 403],
            ['https://amazonaws.com.attacker.com/collect', 403],
            ['https://notamazonaws.com/collect', 403],
        ];
        for (const [u, expectedStatus] of disallowed) {
            const res = validateUploadTarget(u, '');
            assert.equal(res.Allowed, false, `expected ${u} to be blocked`);
            assert.equal(res.Status, expectedStatus);
        }
    });

    it('parses UPLOAD_PROXY_MAX_BYTES override and falls back to 100 MB default', () => {
        assert.equal(parseMaxUploadBytes(undefined), DEFAULT_MAX_UPLOAD_BYTES);
        assert.equal(parseMaxUploadBytes('not-a-number'), DEFAULT_MAX_UPLOAD_BYTES);
        assert.equal(parseMaxUploadBytes('0'), DEFAULT_MAX_UPLOAD_BYTES);
        assert.equal(parseMaxUploadBytes('-50'), DEFAULT_MAX_UPLOAD_BYTES);
        assert.equal(parseMaxUploadBytes('1048576'), 1048576);
    });

    it('readBoundedStream buffers bodies within cap and aborts with PayloadTooLargeError when exceeded', async () => {
        const ok = await readBoundedStream(Readable.from([Buffer.from('hello '), Buffer.from('world')]), 11);
        assert.equal(Buffer.from(ok).toString('utf8'), 'hello world');

        const oversized = Readable.from([Buffer.from('12345'), Buffer.from('67890')]);
        await assert.rejects(
            () => readBoundedStream(oversized, 8),
            (err) => err instanceof PayloadTooLargeError,
        );
    });

    it('applyFallbackCorsHeaders preserves existing host CORS origin and sets fallback when absent', () => {
        const makeTarget = (preset) => {
            const headers = new Map();
            if (preset) headers.set('access-control-allow-origin', preset);
            return {
                headers,
                get(name) { return headers.get(name.toLowerCase()); },
                set(map) {
                    for (const [k, v] of Object.entries(map)) headers.set(k.toLowerCase(), v);
                },
            };
        };

        const presetTarget = makeTarget('https://explorer.example.com');
        applyFallbackCorsHeaders(presetTarget);
        assert.equal(presetTarget.headers.get('access-control-allow-origin'), 'https://explorer.example.com');

        const emptyTarget = makeTarget(undefined);
        applyFallbackCorsHeaders(emptyTarget);
        assert.equal(emptyTarget.headers.get('access-control-allow-origin'), '*');
    });
});
