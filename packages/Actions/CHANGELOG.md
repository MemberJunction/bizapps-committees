# @mj-biz-apps/committees-actions

## 1.3.0

## 1.2.0

### Patch Changes

- af1c6e6: License declarations now agree on BUSL-1.1 everywhere.

  The Open App manifest (`mj-app.json`) still declared `"license": "ISC"` while `LICENSE` and
  every `package.json` declared BUSL-1.1 — the manifest is what an MJ deployment reads when it
  installs the app, so it was the one declaration that shipped the wrong answer. The scaffold
  snippet in `plans/IMPLEMENTATION_PLAN.md` carried the same `ISC`, which is how the wrong
  value gets copied into the next repo; it is corrected too.

## 1.1.1

## 1.1.0

### Minor Changes

- ed6c569: PG migrations
- 4d8112b: MJ core floor raised to 5.45 (SS Metadata_Sync requires the v5.45 spCreateAIAgent signature); PostgreSQL one-shot install hardened against core 5.45 (core maintenance sproc calls stripped from baked migrations, EntityField.Type pinned to the SS-canonical vocabulary). Validated end-to-end on fresh SQL Server and PostgreSQL at core v5.45.0: migrate-only PG install, 25/25 functional suite, codegen no-op on both engines, MJAPI serving.
- fdc959f: Committees v1
