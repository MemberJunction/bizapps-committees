---
"@mj-biz-apps/committees-core": patch
"@mj-biz-apps/committees-core-entities-server": patch
"@mj-biz-apps/committees-entities": patch
"@mj-biz-apps/committees-ng": patch
---

Consolidated security hardening:
- Guard all programmatic `window.open` calls of record-stored URLs (`MJ: Files.ProviderKey`, `Meeting.VideoJoinURL`) through `OpenExternalUrl`, enforcing `http:`/`https:` schemes and `noopener,noreferrer` to prevent stored XSS and reverse tabnabbing.
- UUID-validate `AssignedToPersonID` (and entity/assignee IDs) in `CommitteeTaskService` before SQL `ExtraFilter` interpolation.
- Centralize email literal escaping in `BulkImportService` through `@memberjunction/global`'s `EscapeSQLString`.
- Restrict `/api/upload-proxy` targets to known storage-provider host suffixes (extensible via `COMMITTEES_UPLOAD_PROXY_ALLOWED_HOSTS`), respect host-configured CORS headers instead of unconditionally overwriting with `*`, set `Connection: close` on 413 rejections, and close DNS-rebinding TOCTOU and hex IPv4-mapped IPv6 bypasses in `ssrf-guard` by pinning outbound HTTPS requests (`UploadProxyMiddleware`, `MinutesService`) to vetted public IPs.
- Allow empty `ID` on unsaved `MembershipEntity` records during UUID-guarded duplicate-membership validation while still rejecting any non-UUID `ID`, `PersonID`, or `TermID`.
