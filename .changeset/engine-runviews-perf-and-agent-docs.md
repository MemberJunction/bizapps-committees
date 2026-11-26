---
"@mj-biz-apps/committees-core": minor
"@mj-biz-apps/committees-core-entities-server": patch
"@mj-biz-apps/committees-server": patch
"@mj-biz-apps/committees-ng": patch
---

Harden `CommitteesLookupEngine` (active `ProviderToUse` override, user-switch invalidation, `CanRead` gating, `CacheLocal: false` for `Video Providers`, O(1) lookup maps, `@RegisterForStartup()`), collapse `RunView` waterfalls into batched `rv.RunViews([...])` calls across server and Angular packages, replace raw cross-view SQL subqueries with RLS-safe two-step reads, and document the 5-Rule BizApps Performance & Caching Standard in `CLAUDE.md` and `AGENTS.md`.
