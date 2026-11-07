/**
 * The upload proxy is mounted at the origin-absolute `/api/upload-proxy`, so resolve it against the
 * GraphQL URL's origin rather than its path (`https://host/api/graphql` must not become `/api/api/...`).
 * MJ 6.2 (MemberJunction/MJ#5677) replaces this with `ApiRoute()` server-side and an explicit MJAPI URL client-side.
 */
export function uploadProxyUrl(graphqlUrl: string): string {
    return new URL('/api/upload-proxy', graphqlUrl).toString();
}
