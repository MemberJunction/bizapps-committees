# @mj-biz-apps/committees-ng

## 1.4.0

### Minor Changes

- 476e117: Add predictive meeting quorum risk outcome columns, layered base views (vwMeetingsGenerated and vwMeetings), and scoring binding write-back.

  - Materializes `PredictedQuorumRiskProbability`, `PredictedQuorumRiskBand`, and `PredictedQuorumRiskScoredAt` on `Meeting`.
  - Updates layered base view `vwMeetings` to compute engineered quorum features (`QuorumRiskOutcome`, `MeetingDurationMinutes`, `DaysUntilMeeting`, `IsVirtualFlag`, `IsHybridFlag`, `IsInPersonFlag`, `HasVideoLink`, `AgendaItemCount`, `TotalAttendees`, `ExpectedAttendees`, `PresentAttendees`, `AbsentAttendees`).
  - Configures ML training pipeline, model candidates (XGBoost, LightGBM, Random Forest), and scheduled scoring binding targeting `PredictedQuorumRiskProbability`.

### Patch Changes

- Updated dependencies [476e117]
  - @mj-biz-apps/committees-entities@1.4.0
  - @mj-biz-apps/committees-core@1.4.0

## 1.3.0

### Patch Changes

- Updated dependencies [dbb0270]
  - @mj-biz-apps/committees-entities@1.3.0
  - @mj-biz-apps/committees-core@1.3.0

## 1.2.0

### Minor Changes

- 59496d1: Add CommitteeHeaderPanel, CommitteeOverviewPanel, MeetingHeaderPanel, and MeetingOverviewPanel custom form panels for enhanced entity workspace experience.

### Patch Changes

- af1c6e6: License declarations now agree on BUSL-1.1 everywhere.

  The Open App manifest (`mj-app.json`) still declared `"license": "ISC"` while `LICENSE` and
  every `package.json` declared BUSL-1.1 — the manifest is what an MJ deployment reads when it
  installs the app, so it was the one declaration that shipped the wrong answer. The scaffold
  snippet in `plans/IMPLEMENTATION_PLAN.md` carried the same `ISC`, which is how the wrong
  value gets copied into the next repo; it is corrected too.

- fe56743: Widen the five `@angular/*` `peerDependencies` from the exact pin `21.1.3` to `^21.1.3`.

  The exact pin was unsatisfiable in any real install: every `@memberjunction/ng-*` package
  at `6.1.0-edge.5` — all of which committees-ng depends on — requires `@angular/core`
  `^21.2.22`, and the MJ Explorer host ships `21.2.22`. No single Angular installation could
  satisfy both `=21.1.3` and `^21.2.22`, so consumers using npm hit a hard `ERESOLVE`
  failure and consumers using pnpm installed on a suppressed peer warning.

  `^21.1.3` matches `@mj-biz-apps/tasks-ng` and `@mj-biz-apps/common-ng`, which committees-ng
  already depends on. The `@angular/compiler` and `@angular/compiler-cli` devDependencies
  remain pinned at `21.1.3`; they are the build toolchain, not part of the published contract.
  No application source changed and the lockfile is unaffected.

- e715a24: feat(committees-ng): add CommitteeGovernanceTreePanel and interactive CommitteeRoster tracker

  - Adds `CommitteeGovernanceTreePanel` to `Committees: Committees` using `@memberjunction/ng-hierarchy-tree` for multi-tier Board $\rightarrow$ Committees $\rightarrow$ Subcommittees hierarchy visualization.
  - Adds `CommitteeRosterComponent` and `CommitteeRosterPanel` featuring:
    - **KPI Ribbon**: Total Active Members, Leadership Officers, Expiring Terms (< 60 days alert), Average Attendance %.
    - **Leadership Segregation**: Distinguishes Officers (Chair, Vice-Chair, Secretary, Treasurer) from general members.
    - **Term Health Tracking**: Live countdowns for active, upcoming, expiring soon (< 60d alert), and expired terms.
    - **Attendance Track Record**: Live attendance percentage and progress bar computed from `Committees: Meeting Attendance`.
    - **Navigation**: Direct links to Person and Membership records.

- 4bab397: Raise every `@memberjunction/*` range to `^6.1.0-edge.5` (the estate-wide edge, matching
  bizapps-tasks and bizapps-common) and move `mj-app.json`'s `mjVersionRange` to
  `>=6.1.0-edge.5 <7.0.0`. Required because `@memberjunction/ng-hierarchy-tree` was pinned at
  `6.1.0-edge.2`, a version that was never published (its first release is `edge.3`), and every
  published version hard-pins MJ core at its own exact version, so it can only be installed
  alongside a matching MJ. Restores `skipLibCheck` and drops the `paths` mapping to a local MJ
  checkout from `tsconfig.angular.json` so the package resolves from npm inside the repo. No
  application source changed. CI publish gates now skip `"private": true` packages.
- Updated dependencies [af1c6e6]
- Updated dependencies [39a6718]
- Updated dependencies [5ca3bf8]
- Updated dependencies [9b25f7f]
- Updated dependencies [0c121a3]
  - @mj-biz-apps/committees-core@1.2.0
  - @mj-biz-apps/committees-entities@1.2.0

## 1.1.1

### Patch Changes

- Updated dependencies [11cdbfd]
  - @mj-biz-apps/committees-entities@1.1.1
  - @mj-biz-apps/committees-core@1.1.1

## 1.1.0

### Minor Changes

- ed6c569: PG migrations
- 4d8112b: MJ core floor raised to 5.45 (SS Metadata_Sync requires the v5.45 spCreateAIAgent signature); PostgreSQL one-shot install hardened against core 5.45 (core maintenance sproc calls stripped from baked migrations, EntityField.Type pinned to the SS-canonical vocabulary). Validated end-to-end on fresh SQL Server and PostgreSQL at core v5.45.0: migrate-only PG install, 25/25 functional suite, codegen no-op on both engines, MJAPI serving.
- fdc959f: Committees v1

### Patch Changes

- Updated dependencies [ed6c569]
- Updated dependencies [4d8112b]
- Updated dependencies [fdc959f]
  - @mj-biz-apps/committees-core@1.1.0
  - @mj-biz-apps/committees-entities@1.1.0
