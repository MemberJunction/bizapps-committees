# `@mj-biz-apps/committees-core`

Shared browser- and server-safe domain engines and services for the MemberJunction Committees OpenApp.

## Exports

- **`CommitteesLookupEngine`** (`@mj-biz-apps/committees-core/lookup` or root) — Singleton `BaseEngine` caching slow-changing taxonomy/lookup entities (`Committees: Roles`, `Committees: Types`, `Committees: Artifact Types`, `Committees: Video Providers`).
- **`MinuteArtifactBridgeService`** — Dual-read resolution, batched `RunViews` loading, opt-in legacy migration, and immutable version pinning between `Committees: Minutes` / `Committees: Artifacts` and `MJ: Artifacts` / `MJ: Artifact Versions`.
- **`BallotService`**, **`MotionService`**, **`CommitteeHealthService`**, **`CommitteeTaskService`**, **`SuccessionService`**, **`TermRenewalService`** — Pure domain math and batched governance services.

## MJ Docs Dual-Read & Bridge Helpers (`MinuteArtifactBridgeService`)

### Minute Dual-Read Resolution

`MinuteArtifactBridgeService.ResolveMinuteDocument(minute, bundle)` and `LoadAndResolveMinutes(minutes, contextUser?, provider?)` return a strongly typed `ResolvedMinuteDocument` discriminated union:

1. **`'mj-doc-pinned'`** — `MJArtifactID` and `ApprovedArtifactVersionID` are both set and ownership-verified (`version.ArtifactID === minute.MJArtifactID`). Renders the immutable approved version even if newer drafts exist.
2. **`'mj-doc-latest'`** — `MJArtifactID` is set and `ApprovedArtifactVersionID` is `NULL`. Resolves the latest version (`VersionNumber DESC, __mj_CreatedAt DESC`).
3. **`'mj-doc-missing'`** — Surfaces explicit diagnostic reasons (`'artifact-not-found'`, `'pinned-version-not-found'`, `'pinned-version-artifact-mismatch'`, `'orphaned-pinned-version'`) while preserving `LegacyContent` metadata.
4. **`'legacy-content'`** — `MJArtifactID` is `NULL`. Renders legacy `Minute.Content` cleanly and sets `CanBridgeToMJDoc: true` when non-empty legacy text is present.

### Committees.Artifact Classification

`MinuteArtifactBridgeService.ClassifyCommitteeArtifact(artifact, bundle)` and `LoadAndResolveCommitteeArtifacts(artifacts, contextUser?, provider?)` return a `ResolvedCommitteeArtifact` discriminated union:

- **`'mj-doc'`** — `MJArtifactID` is non-null; includes the resolved `MJArtifactSummaryRow` and latest `MJArtifactVersionSummaryRow`.
- **`'external-url'`** — `MJArtifactID` is `NULL`; preserves external cloud-provider and URL fields (`Provider`, `ExternalID`, `URL`, `MimeType`, `FileSize`).

### Batched `RunViews` Loading

`LoadArtifactBundles(artifactIds, pinnedVersionIds, contextUser?, provider?)` validates and deduplicates UUIDs, chunks `IN (...)` filters at 400 IDs per batch, and executes all `MJ: Artifacts` and `MJ: Artifact Versions` queries in a **single** `rv.RunViews([...])` call with `ResultType: 'simple'`.

### Opt-In Bridge & Approval Version Pinning

- **`BridgeLegacyMinuteToMJDoc(options, contextUser?, provider?)`** — Creates an `MJ: Artifacts` record + initial `MJ: Artifact Versions` (`VersionNumber = 1`) from legacy `Minute.Content`, updates `Minute.MJArtifactID` (and optionally pins `ApprovedArtifactVersionID`), deduplicates concurrent in-flight calls per `MinuteID`, executes atomically via `TransactionGroup` when supported (with compensating rollback otherwise), and **never** deletes or alters `Minute.Content`.
- **`PinApprovedMinuteVersion(options, contextUser?, provider?)`** — Verifies `Minute.MJArtifactID` is populated and the target version belongs to that artifact before persisting `Minute.ApprovedArtifactVersionID` (and optional `ApprovalStatus = 'Approved'`).

## Scripts

```bash
pnpm --filter @mj-biz-apps/committees-core build
pnpm --filter @mj-biz-apps/committees-core test
```
