/**
 * Opens a record-stored URL in a new tab, but only when it parses as an
 * absolute http(s) URL. Returns true when the URL was opened.
 *
 * SECURITY (stored XSS): values like a document's ProviderKey ("external URL"
 * documents) and a meeting's VideoJoinURL are user-editable record fields, and
 * `window.open` performs NO sanitization. Angular's template sanitizer protects
 * `[href]` bindings, but a programmatic `window.open('javascript:…')` — opened
 * without `noopener` — executes in a same-origin about:blank window whose
 * `window.opener` points back at the app, i.e. full XSS in the app's origin.
 * Every `window.open` of record data must therefore go through this guard,
 * which refuses non-http(s) schemes (`javascript:`, `data:`, `vbscript:`, …)
 * and always severs the opener relationship.
 */
export function OpenExternalUrl(url: string | null | undefined): boolean {
    if (!url) {
        return false;
    }
    let parsed: URL;
    try {
        parsed = new URL(url);
    } catch {
        return false; // relative or malformed — not an external document/meeting link
    }
    if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') {
        return false;
    }
    window.open(url, '_blank', 'noopener,noreferrer');
    return true;
}
