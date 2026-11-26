# Agents Guide — `MemberJunction/bizapps-committees`

This repository extends MemberJunction with committee governance, memberships, terms, meetings, minutes, motions, and e-ballots. Read [`CLAUDE.md`](CLAUDE.md) alongside this file before making changes.

## Core Coding Invariants

- **Zero `any` or lazy `unknown`** in TypeScript — always define explicit row/projection interfaces or use generated entity types (`@mj-biz-apps/committees-entities`).
- **Zero `.Get()` / `.Set()`** on generated entities — use strongly typed entity properties.
- **`BaseSingleton` for all singletons** — extend `BaseEngine<T>` / `BaseSingleton<T>` from `@memberjunction/core` / `@memberjunction/global` (`protected constructor() { super(); }`).
- **Modern Angular syntax** — `@if` / `@for` / `@switch` and `inject()`.
- **Zero cross-package re-exports** — consumers import directly from the defining package (`@mj-biz-apps/committees-core/lookup` in Angular/browser packages, `@mj-biz-apps/committees-core` on server).
- **Never touch `ci/` or `.github/` protected scripts** unless explicitly tasked with CI infrastructure work.
- **Never commit host artifacts** (`packages/GeneratedEntities/**`, `mj.config.cjs`, `.env*`).
- **Add a `.changeset/<slug>.md`** whenever modifying publishable `@mj-biz-apps/committees-*` packages.
- **Never squash-merge PRs** — always preserve commit history (`gh pr merge --merge`).

## 5-Rule BizApps Performance & Caching Standard

Every `RunView` is a network + SQL round trip. Follow all five rules across `packages/Core`, `packages/CoreEntitiesServer`, `packages/Server`, `packages/Entities`, and `packages/Angular`:

### Rule 1 — `BaseEngine` Taxonomy & Lookup Caching
- Bounded, slow-changing reference entities live in **`CommitteesLookupEngine`** (`packages/Core/src/engines/CommitteesLookupEngine.ts`):
  - `Committees: Roles` (`CacheLocal: true`)
  - `Committees: Types` (`CacheLocal: true`)
  - `Committees: Artifact Types` (`CacheLocal: true`)
  - `Committees: Video Providers` (`CacheLocal: false`, `CanRead`-gated)
- Always call `await CommitteesLookupEngine.Instance.Config(false, contextUser, provider)` and read via O(1) lookup helpers (`RoleById`, `RoleByName`, `IsOfficerRole`, `IsVotingRole`, `CommitteeTypeById`, `CommitteeTypeByName`, `ArtifactTypeById`, `VideoProviderById`, `DefaultVideoProvider`, `ActiveVideoProviders`).
- Never issue ad-hoc `RunView` queries against `Committees: Roles`, `Committees: Types`, `Committees: Artifact Types`, or `Committees: Video Providers` from UI components or server services.

### Rule 2 — Multi-Provider, Impersonation & RLS `CacheLocal` Safety
- Override `public override get ProviderToUse(): IMetadataProvider` on every `BaseEngine` subclass to return `this._activeProvider ?? Metadata.Provider` (avoiding first-wins `_provider` latching across persona switches or multi-provider server requests).
- Track `_loadedForUserId` and auto-force refresh when the active user changes; provide `InvalidateCache()` for mutation and persona-switch hooks.
- Gate restricted/optional entities with `md.EntityByName(name)?.GetUserPermisions(effectiveUser)?.CanRead` so restricted roles never break engine startup.
- Use `CacheLocal: true` **only** on shared non-RLS reference tables; use **`CacheLocal: false`** on any RLS-scoped or role-restricted entity.
- Client session caches (`CommitteePermissionHelper`) must reset on user change and deduplicate concurrent in-flight promises.

### Rule 3 — Collapse Waterfalls with `rv.RunViews([...])`
- Never call `Promise.all([rv.RunView(...), rv.RunView(...)])` or await independent `rv.RunView(...)` calls sequentially — batch them into a single **`rv.RunViews([...])`** call.
- Inside `BaseEntity` subclasses and engines, construct `RunView` via **`RunView.FromMetadataProvider(this.ProviderToUse)`** instead of bare `new RunView()` or `as unknown as IRunViewProvider`.
- Prefer `ResultType: 'simple'` with explicit `Fields: [...]` for read-only projections; use `ResultType: 'entity_object'` only when mutating/saving records.
- Never call `RunView` inside a loop.

### Rule 4 — `ConversationEngine`-Style Bounded Container Caching vs. No Arbitrary List Caches
- When a UI repeatedly reads a bounded parent container (for example, a single committee/form/meeting definition bundle across tabs), cache per container ID with an explicit LRU size cap, in-flight promise deduplication, user-switch clearing, and automatic invalidation on `BaseEntity` save/delete events.
- Never globally cache unbounded transactional tables (`Meetings`, `Votes`, `Comments`, `Attendances`, `Ballots`, `Memberships`) in a `BaseEngine`, and never cache arbitrary filtered list queries.

### Rule 5 — RLS-Safe Two-Step Entity Reads
- Never use raw cross-view SQL subqueries inside `ExtraFilter` (e.g., `IN (SELECT ID FROM [__mj_BizAppsCommittees].[vwMeetings] ...)` or `[__mj_BizAppsTasks].[vwTaskAssignments]`), which bypass entity-level RLS and break cross-dialect portability.
- Resolve accessible parent IDs via a first-class `RunView` (returning early when empty), validate UUIDs, chunk `ID IN (...)` clauses (e.g., 400 IDs per batch via `rv.RunViews`), and check `result.Success`.

## MJ Docs (`MJ: Artifacts`) vs. `MJ: Comments` vs. Quick Notes

- **Category A — MJ Docs (`MJ: Artifacts` + `MJ: Artifact Versions`)**: Use for rich, multi-revision, or formally approved governance documents (`Committees: Minutes` via nullable `MJArtifactID` + immutable `ApprovedArtifactVersionID`, and native `Committees: Artifacts` via nullable `MJArtifactID`). Render with `<mj-artifact-viewer-panel>` from `@memberjunction/ng-artifacts`, batch loads via `MinuteArtifactBridgeService`, and preserve legacy `Minute.Content` and external URL columns (`PUBLISH_NO_BREAK_POLICY.md`).
- **Category B — `MJ: Comments` (`Committees: Comments`)**: Use for threaded review discussions and conversational feedback attached to committees, meetings, artifacts, or tasks.
- **Category C — Relational Quick Notes**: Keep `Motion.Notes`, `Vote.Notes`, and `Attendance.Notes` as strictly relational columns — never migrate them to `MJ: Artifacts`.

## Build & Verification

```bash
pnpm run build:packages
pnpm run test
```
