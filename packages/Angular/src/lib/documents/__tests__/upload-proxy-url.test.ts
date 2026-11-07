import { describe, expect, it } from 'vitest';
import { uploadProxyUrl } from '../upload-proxy-url';

describe('uploadProxyUrl', () => {
    it('resolves the proxy against the GraphQL origin', () => {
        expect(uploadProxyUrl('http://localhost:4000/')).toBe('http://localhost:4000/api/upload-proxy');
        expect(uploadProxyUrl('http://localhost:4000/graphql')).toBe('http://localhost:4000/api/upload-proxy');
        expect(uploadProxyUrl('https://host/api/graphql')).toBe('https://host/api/upload-proxy');
    });
});
