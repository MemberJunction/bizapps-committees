# Specification — Committees MJ Docs (`MJ: Artifacts`) Dual-Read Bridge

## 1. Overview & Motivation

`MemberJunction/bizapps-committees` manages committee governance artifacts—most importantly formal meeting minutes (`Committees: Minutes`) and committee/meeting documents (`Committees: Artifacts`). Historically, minutes lived in a plain-text/Markdown `Minute.Content` column and artifacts pointed only to external URLs (`Provider`, `URL`, `ExternalID`).

This specification defines the strictly additive bridge connecting `Committees: Minutes` and `Committees: Artifacts` to MemberJunction's native **MJ Docs** (`MJ: Artifacts` and `MJ: Artifact Versions`) while preserving 100% backward compatibility with legacy rows (`PUBLISH_NO_BREAK_POLICY.md`) and keeping Category C relational notes (`Motion.Notes`, `Vote.Notes`, `Attendance.Notes`) strictly relational.

## 2. Architectural Rubric: MJ Docs vs. MJ: Comments vs. Quick Notes

- **Category A (MJ Docs — `MJ: Artifacts` + `MJ: Artifact Versions`)**: Rich, versioned, or formally approved governance documents (`Committees: Minutes` with `MJArtifactID` + `ApprovedArtifactVersionID` pinning; native `Committees: Artifacts` with `MJArtifactID`).
- **Category B (`MJ: Comments` / `Committees: Comments`)**: Threaded discussions and review commentary.
- **Category C (Relational Columns)**: Short, atomic, row-scoped annotations (`Motion.Notes`, `Vote.Notes`, `Attendance.Notes`) that stay strictly relational.

## 3. Additive Dual-DBMS Schema Contract

- **T-SQL Migration**: `migrations/V202611261400__v6.3.x__Minute_And_Artifact_MJArtifactID.sql` (4-part structure with >=50-line blank separator and single-pass `mj codegen` Part 4).
- **Deterministic PostgreSQL Counterpart**: `migrations-pg/V202611261400__v6.3.x__Minute_And_Artifact_MJArtifactID.pg.sql` generated via `mj migrate convert --split --bake-codegen` + `mj migrate rebake --capture-only` and stamped on line 1 with `-- @mj-pg-provenance: split-bake v1`.
- **Additive Columns & Constraints**:
  - `Committees.Minute.MJArtifactID` (`UNIQUEIDENTIFIER` / `UUID` `NULL`) -> `FK_Minute_MJArtifact` (`__mj.Artifact(ID) ON DELETE NO ACTION`) + supporting index.
  - `Committees.Minute.ApprovedArtifactVersionID` (`UNIQUEIDENTIFIER` / `UUID` `NULL`) -> `FK_Minute_ApprovedArtifactVersion` (`__mj.ArtifactVersion(ID) ON DELETE NO ACTION`) + supporting index.
  - `Committees.Artifact.MJArtifactID` (`UNIQUEIDENTIFIER` / `UUID` `NULL`) -> `FK_Artifact_MJArtifact` (`__mj.Artifact(ID) ON DELETE NO ACTION`) + supporting index.
- **Preserved Legacy Columns**: `Minute.Content`, `Minute.ArtifactID`, `Artifact.URL`, `Artifact.Provider`, `Artifact.ExternalID`, `Motion.Notes`, `Vote.Notes`, and `Attendance.Notes` are never dropped or renamed.

## 4. Entity Validation & Dual-Read Core Service

- **`MinuteEntityCustom`** (`packages/Entities/src/custom/MinuteEntity.ts`, `@RegisterClass(BaseEntity, 'Committees: Minutes')`):
  - `Validate()`: rejects setting `ApprovedArtifactVersionID` when `MJArtifactID` is `null`; validates UUID formatting on both columns.
  - `ValidateAsync()`: verifies via `RunView.FromMetadataProvider(this.ProviderToUse)` that `ApprovedArtifactVersionID` exists and its `ArtifactID` matches `Minute.MJArtifactID`.
- **`MinuteArtifactBridgeService`** (`packages/Core/src/services/MinuteArtifactBridgeService.ts`):
  - Pure discriminated resolvers: `ResolveMinuteDocument` (`'mj-doc-pinned' | 'mj-doc-latest' | 'mj-doc-missing' | 'legacy-content'`), `ResolveMinutesBatch`, and `ClassifyCommitteeArtifact` (`'mj-doc' | 'external-url'`).
  - Single-batch chunked `rv.RunViews([...])` loader (`LoadArtifactBundles`, `ResultType: 'simple'`).
  - Idempotent, concurrency-deduplicated `BridgeLegacyMinuteToMJDoc` creating `MJ: Artifacts` + v1 `MJ: Artifact Versions` and linking `Minute.MJArtifactID` without modifying `Minute.Content`.
  - `PinApprovedMinuteVersion` atomically pinning `ApprovedArtifactVersionID` with cross-entity ownership validation.

## 5. Angular `@memberjunction/ng-artifacts` UI & OpenApp Readiness

- **`MinuteDocumentViewerComponent`** (`<committees-minute-document-viewer>`): renders `<mj-artifact-viewer-panel [artifactId] [VersionNumber]>` for MJ Docs minutes (locking read-only on `ApprovedArtifactVersionID` when pinned, floating on latest draft otherwise), cleanly renders legacy `Minute.Content` when `MJArtifactID IS NULL` with an opt-in **Bridge to MJ Docs** action, and handles missing/inaccessible artifact links gracefully.
- **`CommitteeArtifactPreviewComponent`** (`<committees-artifact-preview>`): previews native MJ Docs inline via `<mj-artifact-viewer-panel>` while preserving external URL actions for cloud/URL links.
- **OpenApp Parity**: `MinuteDocumentFormPanel` and `ArtifactDocumentFormPanel` (`@RegisterClassEx(BaseFormPanel, ...)`) mount inline alongside all 16 retained `@RegisterClass(BaseFormComponent, ...)` generated forms; top-level views extend `BaseResourceComponent` with `<mj-page-layout>`, `OnPush`, `UserInfoEngine.Instance` preferences, and `--mj-*` design tokens exclusively.

## 6. Verification & CI Gates

- **Unit Tests (`pnpm run test`)**: Entities, Core, Angular, and CoreEntitiesServer Vitest/node:test suites.
- **Dual-DBMS Integration Suite (`packages/IntegrationTests`, `test-harnesses/integration.mjs`, `scripts/seed-committees-mj-docs.mjs`)**: Runs `committees-world`, `ballot-sealing`, `minute-artifact-dual-read` (`DR1`–`DR6`), and `pg-parity-and-boundary` (`PB1`–`PB6`) across both SQL Server and PostgreSQL scratch databases via `sf-workspace-db-broker.mjs rehearse-dual-db`.
- **CI Guards**: `.github/workflows/repo-checks.yml` enforces `.github/scripts/check-pg-provenance.mjs` (PG counterpart + `split-bake v1` SHA-256 provenance) alongside dependency model, metadata order, and migration changeset checks.
