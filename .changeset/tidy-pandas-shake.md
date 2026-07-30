---
"@mj-biz-apps/committees-actions": minor
"@mj-biz-apps/committees-ng": minor
"@mj-biz-apps/committees-core": minor
"@mj-biz-apps/committees-core-entities-server": minor
"@mj-biz-apps/committees-entities": minor
"@mj-biz-apps/committees-server": minor
---

MJ core floor raised to 5.45 (SS Metadata_Sync requires the v5.45 spCreateAIAgent signature); PostgreSQL one-shot install hardened against core 5.45 (core maintenance sproc calls stripped from baked migrations, EntityField.Type pinned to the SS-canonical vocabulary). Validated end-to-end on fresh SQL Server and PostgreSQL at core v5.45.0: migrate-only PG install, 25/25 functional suite, codegen no-op on both engines, MJAPI serving.
