---
"@mj-biz-apps/committees-entities": patch
---

Remove stale Metadata_Sync Flyway. It calls core SPs with a snapshot of argument lists from July 2026 and fails on current MJ (spCreateFileStorageProvider arity). Metadata lives in metadata/ and is applied with mj sync push.
