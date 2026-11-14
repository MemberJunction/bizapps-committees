import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { OpenExternalUrl } from '../open-external-url';

interface OpenCall {
    url?: string | URL;
    target?: string;
    features?: string;
}

describe('OpenExternalUrl', () => {
    let opened: OpenCall[];

    beforeEach(() => {
        opened = [];
        // The vitest environment is node, so stub the one browser API the guard touches.
        vi.stubGlobal('window', {
            open: (url?: string | URL, target?: string, features?: string): null => {
                opened.push({ url, target, features });
                return null;
            },
        });
    });

    afterEach(() => {
        vi.unstubAllGlobals();
    });

    it('opens absolute http(s) URLs in a new tab with the opener severed', () => {
        expect(OpenExternalUrl('https://example.com/doc.pdf')).toBe(true);
        expect(OpenExternalUrl('http://example.com/join')).toBe(true);
        expect(opened).toHaveLength(2);
        for (const call of opened) {
            expect(call.target).toBe('_blank');
            expect(call.features).toBe('noopener,noreferrer');
        }
    });

    it('refuses javascript:, data:, and other non-http(s) schemes (stored XSS payloads)', () => {
        expect(OpenExternalUrl('javascript:alert(document.domain)')).toBe(false);
        expect(OpenExternalUrl('JaVaScRiPt:alert(1)')).toBe(false);
        expect(OpenExternalUrl('data:text/html,<script>alert(1)</script>')).toBe(false);
        expect(OpenExternalUrl('vbscript:msgbox(1)')).toBe(false);
        expect(OpenExternalUrl('file:///etc/passwd')).toBe(false);
        expect(opened).toHaveLength(0);
    });

    it('refuses empty, null, relative, and malformed values', () => {
        expect(OpenExternalUrl(null)).toBe(false);
        expect(OpenExternalUrl(undefined)).toBe(false);
        expect(OpenExternalUrl('')).toBe(false);
        expect(OpenExternalUrl('/relative/path')).toBe(false);
        expect(OpenExternalUrl('not a url')).toBe(false);
        expect(opened).toHaveLength(0);
    });
});
