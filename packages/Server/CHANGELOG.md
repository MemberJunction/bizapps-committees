# @mj-biz-apps/committees-server

## 1.1.1

### Patch Changes

- Updated dependencies [11cdbfd]
  - @mj-biz-apps/committees-entities@1.1.1
  - @mj-biz-apps/committees-core@1.1.1
  - @mj-biz-apps/committees-core-entities-server@1.1.1
  - @mj-biz-apps/committees-actions@1.1.1

## 1.1.0

### Minor Changes

- ed6c569: PG migrations
- 4d8112b: MJ core floor raised to 5.45 (SS Metadata_Sync requires the v5.45 spCreateAIAgent signature); PostgreSQL one-shot install hardened against core 5.45 (core maintenance sproc calls stripped from baked migrations, EntityField.Type pinned to the SS-canonical vocabulary). Validated end-to-end on fresh SQL Server and PostgreSQL at core v5.45.0: migrate-only PG install, 25/25 functional suite, codegen no-op on both engines, MJAPI serving.
- fdc959f: Committees v1

### Patch Changes

- Updated dependencies [ed6c569]
- Updated dependencies [4d8112b]
- Updated dependencies [fdc959f]
  - @mj-biz-apps/committees-actions@1.1.0
  - @mj-biz-apps/committees-core@1.1.0
  - @mj-biz-apps/committees-core-entities-server@1.1.0
  - @mj-biz-apps/committees-entities@1.1.0
