# `@mj-biz-apps/committees-ng`

Angular UI components, entity forms, custom form panels, and MJ Explorer resources for the **MemberJunction Committees OpenApp**.

## Dependency Model (`@memberjunction/ng-artifacts`)

This package consumes `@memberjunction/ng-artifacts` (`<mj-artifact-viewer-panel>`) and `@memberjunction/ng-ui-components` (`<mj-page-layout>`) following the BizApps bounded peer-dependency standard:

- `peerDependencies`: `"@memberjunction/ng-artifacts": "^6.3.0-edge.1"` and `"@memberjunction/ng-ui-components": "^6.3.0-edge.1"`
- `devDependencies`: `"@memberjunction/ng-artifacts": "6.3.0-edge.1"` and `"@memberjunction/ng-ui-components": "6.3.0-edge.1"` (anchors local builds; never ships in published `dependencies`)

## Dual-Read Minutes & `<mj-artifact-viewer-panel>` Integration

### `MinuteDocumentViewerComponent` (`<committees-minute-document-viewer>`)

Wired into `MinutesReviewComponent`, `MeetingDetailViewComponent`, and the `MinuteDocumentFormPanel` (`slot: 'after-fields'` on `Committees: Minutes`):

- **Pinned MJ Docs (`MJArtifactID` + `ApprovedArtifactVersionID` populated)**: Renders the linked MJ Doc via `<mj-artifact-viewer-panel [artifactId]="..." [VersionNumber]="...">` strictly locked to the approved artifact version number (`CanEdit = false`), displaying a **Pinned Approved vN** badge.
- **Live Draft MJ Docs (`MJArtifactID` populated, `ApprovedArtifactVersionID IS NULL`)**: Renders the latest version via `<mj-artifact-viewer-panel>` with a **Live Draft vN** badge and optional officer **Pin Version** action (and auto-pins on formal approval in `MinutesReviewComponent`).
- **Legacy Minutes (`MJArtifactID IS NULL`)**: Cleanly renders `Minute.Content` (or projects the section-by-section editor in `MinutesReviewComponent`) with zero regression alongside an opt-in **Bridge to MJ Docs** button invoking `MinuteArtifactBridgeService.BridgeLegacyMinuteToMJDoc` (preserving `Minute.Content` intact and deduplicating concurrent clicks).
- **Missing / Inconsistent Link (`mj-doc-missing`)**: Displays clear diagnostics (`artifact-not-found`, `pinned-version-not-found`, `pinned-version-artifact-mismatch`, `orphaned-pinned-version`) and falls back to preserved `Minute.Content` when available.

### `CommitteeArtifactPreviewComponent` (`<committees-artifact-preview>`)

Wired into `CommitteeWorkspaceComponent`, `MeetingDetailViewComponent`, and `ArtifactDocumentFormPanel` (`slot: 'after-fields'` on `Committees: Artifacts`):

- **Native MJ Docs (`MJArtifactID` populated)**: Surfaces an **MJ Doc** badge and opens `<mj-artifact-viewer-panel>` inline or in a slide-over drawer.
- **External URL Artifacts (`MJArtifactID IS NULL`)**: Preserves external URL link behavior identically via `OpenExternalUrl` (validating `http:` / `https:` schemes only).

## OpenApp v3 Readiness & UI Hygiene

- **Dual Form Registration Parity**: `LoadCommitteesClient` (`mj-app.json` `startupExport`) retains `GeneratedFormsModule`, all 16 generated `@RegisterClass(BaseFormComponent, 'Committees: ...')` form classes, and `CustomFormsModule` (`@RegisterClassEx(BaseFormPanel, ...)` panels).
- **Navigation & Resource Parity**: Every `BaseResourceComponent` is either wired in application `DefaultNavItems` or mounted in a wired parent template (`<committees-dashboard>` in `MemberHomeComponent`, `<committee-workspace>` in `ManagementCommitteeListComponent`), using `<mj-page-layout>`, `queueMicrotask(() => this.NotifyLoadStarted())`, and `NotifyLoadComplete()`.
- **Tokens & Preferences**: Uses semantic `--mj-*` CSS custom properties exclusively (zero hardcoded `#hex`/`rgb()`/`rgba()`/`hsl()` color literals, zero `window.print()`), `ChangeDetectionStrategy.OnPush`, and `UserInfoEngine.Instance` for user preferences (`mj.committees.minuteViewer.showTabs`, `mj.committees.memberHome.viewMode`).

## Build & Test

```bash
pnpm --filter @mj-biz-apps/committees-ng build
pnpm --filter @mj-biz-apps/committees-ng test
```
