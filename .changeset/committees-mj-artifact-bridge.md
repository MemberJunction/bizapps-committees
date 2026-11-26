---
"@mj-biz-apps/committees-entities": minor
"@mj-biz-apps/committees-core": minor
"@mj-biz-apps/committees-server": minor
"@mj-biz-apps/committees-ng": minor
---

Add strictly additive `MJArtifactID` and `ApprovedArtifactVersionID` foreign keys to `Committees: Minutes` and `MJArtifactID` to `Committees: Artifacts` (with deterministic PostgreSQL `split-bake v1` parity), regenerate CodeGen entities/resolvers/forms with `MinuteEntityCustom` ownership validation, implement `MinuteArtifactBridgeService` dual-read/pinning/opt-in bridging helpers, integrate `@memberjunction/ng-artifacts` (`<mj-artifact-viewer-panel>`) into Minutes viewing/review and Artifact previews while preserving legacy `Minute.Content` and external URL links, and add dual-DBMS integration checks and the MJ Docs vs. Comments vs. Quick Notes architectural rubric.
