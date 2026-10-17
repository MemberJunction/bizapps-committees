---
"@mj-biz-apps/committees-core-entities-server": patch
"@mj-biz-apps/committees-entities": patch
---

Security hardening. The `/api/upload-proxy` PUT/POST handlers now mount through `GetPostAuthMiddleware()`, after MJServer's unified auth middleware, so an unauthenticated request gets a 401 instead of reaching an open outbound relay (only the credential-less CORS preflight stays pre-auth); the proxy also restricts `x-upload-url` to the storage-provider hosts MJStorage issues pre-signed upload URLs for (Azure Blob, S3, Google, Dropbox, Box, SharePoint/Graph), extensible per deployment via `COMMITTEES_UPLOAD_PROXY_ALLOWED_HOSTS`, and falls back to `Access-Control-Allow-Origin: *` only when the host's CORS middleware set nothing. The shared SSRF guard now resolves the target twice and rejects unstable or private answers, narrowing the DNS-rebinding window between vetting and `fetch()`'s own lookup. The Membership duplicate-active-membership check validates `PersonID`/`TermID`/`ID` as UUIDs before interpolating them into its `ExtraFilter`, reporting an ordinary validation error and skipping the query otherwise.
