---
"@mj-biz-apps/committees-ng": patch
---

Document upload now resolves the server's upload proxy against the GraphQL URL's origin, so it reaches `/api/upload-proxy` when GraphQL is served under a path such as `/api/graphql` instead of requesting `/api/api/upload-proxy`.
