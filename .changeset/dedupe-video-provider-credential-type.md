---
"@mj-biz-apps/committees-core": minor
"@mj-biz-apps/committees-entities": minor
"@mj-biz-apps/committees-core-entities-server": minor
"@mj-biz-apps/committees-actions": minor
"@mj-biz-apps/committees-server": minor
"@mj-biz-apps/committees-ng": minor
---

Consolidate fresh-install baseline (`B202611251200__v6.3__Committees_Baseline_Metadata_Sync.sql`) with an `IF NOT EXISTS` guard around the shared `"Video Provider OAuth"` credential type (`DAA02013-510D-41F4-BFAA-9250C7BC7D37`) owned by `bizapps-tasks`, and remove the duplicate `credential-types` metadata seed from `bizapps-committees`.
