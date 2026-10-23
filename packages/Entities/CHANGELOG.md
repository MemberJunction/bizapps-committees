# @mj-biz-apps/committees-entities

## 1.5.0

### Minor Changes

- b8218d6: Release seed for 1.5: `V202610231900__v1.5.x__Metadata_Sync.sql` and its PostgreSQL counterpart carry this release's metadata to hosts, which install by migration and never read `metadata/`: the "Committees: Visible Votes" row filter and the UI role's read-only permission on Votes through it (ballot sealing), and the Quorum Risk scoring set for Meetings (its record process, training pipeline, three Draft models and scoring binding). Every create is guarded and the permission is matched by entity, role and type, so a host that already pushed this metadata is unchanged.

### Patch Changes

- 22be655: Ballot sealing is enforced on the server (C0). The UI role reads Votes through the new "Committees: Visible Votes" row filter: a member sees their own vote, roll-call votes on meeting motions, and every vote on a closed or cancelled ballot that is not sealed. Closing a ballot moves to the `CloseBallot` mutation, which tallies as the system user and stamps the motion; `BallotProgress` gives open ballots their participation counts. The custom Membership and Meeting entity classes now register under their entity names ("Committees: Memberships", "Committees: Meetings"), so their validation rules run.
- 5296dc1: `mj-app.json` now lists `@mj-biz-apps/committees-core-entities-server`, `@mj-biz-apps/committees-actions` under `server` instead of `shared`. They use server-only code (Node built-ins, or MemberJunction's actions, AI engine, storage or server packages), and `shared` installs a package into MJExplorer too. The Open App client bootstrap imports every `shared` package, so Explorer's browser build failed on a host with this app installed (`Could not resolve "node:crypto"`, `"node:net"`, `"stream"`). The server still loads them exactly as before.
- 670f58a: `mj sync push --dir metadata` now succeeds on a fresh database.

  - `metadata/.mj-sync.json` lists every metadata folder in `directoryOrder`, ending with `record-processes`, `ml-training-pipelines`, `ml-models` and `ml-model-scoring-bindings`. Folders left out of the list are pushed afterwards in alphabetical order, so `ml-model-scoring-bindings` was pushed before the model and record process it references and the push rolled back on `FK_MLModelScoringBinding_MLModel`.
  - The shipped ML models no longer carry `"ArtifactFileID": null`. Push sets nulls too, so every push cleared the trained artifact link on the host that trained the models. A fresh database still gets null; a trained host keeps its value.

## 1.4.0

### Minor Changes

- 476e117: Add predictive meeting quorum risk outcome columns, layered base views (vwMeetingsGenerated and vwMeetings), and scoring binding write-back.

  - Materializes `PredictedQuorumRiskProbability`, `PredictedQuorumRiskBand`, and `PredictedQuorumRiskScoredAt` on `Meeting`.
  - Updates layered base view `vwMeetings` to compute engineered quorum features (`QuorumRiskOutcome`, `MeetingDurationMinutes`, `DaysUntilMeeting`, `IsVirtualFlag`, `IsHybridFlag`, `IsInPersonFlag`, `HasVideoLink`, `AgendaItemCount`, `TotalAttendees`, `ExpectedAttendees`, `PresentAttendees`, `AbsentAttendees`).
  - Configures ML training pipeline, model candidates (XGBoost, LightGBM, Random Forest), and scheduled scoring binding targeting `PredictedQuorumRiskProbability`.

## 1.3.0

### Minor Changes

- dbb0270: Add the SQL Server Metadata_Sync migration that v1.2.0 shipped without (`V202609181200__v1.3.x__Metadata_Sync.sql`). A fresh SQL Server install now gets the seed data and entity configuration from `metadata/`: committee types, roles, artifact types, the Video Provider OAuth credential type, the External URL file storage provider, the Committee Importer prompt and agent, and the entity / field / relationship form and search settings. It replaces `V202607080009`, removed in v1.2.0, and is a full capture rather than a delta on top of it.

  Raise the MemberJunction floor to `>=6.1.0-edge.6`. The migration's full-row core procedure calls need `spUpdateEntity @SubtypeSelector` and the restored `spCreateFileStorageProvider @SupportsSearch / @RequiresOAuth`, both first shipped in 6.1.0-edge.6.

  Fix the publish workflow so it no longer lowers a hand-set prerelease `mjVersionRange` floor back to the `@memberjunction/core` dependency's version.

## 1.2.0

### Minor Changes

- 9b25f7f: Person and Organization committee chrome: Memberships and sponsored Committees are Primary; attendance is More; comments, votes, presenter, and uploader are None.
- 0c121a3: Committee, Meeting, Term, and Motion forms use left-nav. Dual-FK Minutes.ApprovedByMeetingID and Committee-level Ballots are None. Meeting comments sit in More; Term memberships and Motion votes/ballots stay Primary.

### Patch Changes

- af1c6e6: License declarations now agree on BUSL-1.1 everywhere.

  The Open App manifest (`mj-app.json`) still declared `"license": "ISC"` while `LICENSE` and
  every `package.json` declared BUSL-1.1 — the manifest is what an MJ deployment reads when it
  installs the app, so it was the one declaration that shipped the wrong answer. The scaffold
  snippet in `plans/IMPLEMENTATION_PLAN.md` carried the same `ISC`, which is how the wrong
  value gets copied into the next repo; it is corrected too.

- 39a6718: Remove stale Metadata_Sync Flyway. It calls core SPs with a snapshot of argument lists from July 2026 and fails on current MJ (spCreateFileStorageProvider arity). Metadata lives in metadata/ and is applied with mj sync push.
- 5ca3bf8: Drop the Person→Votes form-chrome overlay. Vote has MembershipID, not PersonID, so that EntityRelationship never exists and mj sync push fails looking it up.

## 1.1.1

### Patch Changes

- 11cdbfd: Upgrade to MemberJunction 6.x, migrate the repo to pnpm, and remove the private
  MJAPI/MJExplorer dev harness.

  **Hosts must be on a MemberJunction 6.x environment.** No application source changed, so
  this is a `patch` — the convention reserves `minor` for migration and metadata changes and
  this branch carries neither. Every `@memberjunction/*` range moves to `^6.1.0-edge.2`, the
  estate-wide floor, and `mj-app.json`'s `mjVersionRange` becomes `>=6.1.0-edge.2 <7.0.0`.
  The prerelease-tagged lower bound is required: node-semver will not match a prerelease
  against a plain `>=6.1.0`. The ranges are carets rather than exact pins because an exact
  pin does not satisfy a local sibling's version under pnpm, so workspace links silently fall
  back to the registry — and `.npmrc`'s `save-exact=true` is dropped for the same reason.

  `@mj-biz-apps/common-*` moves to `^5.34.0` and `tasks-*` to `^1.2.3`. Neither is cosmetic:

  - common 5.33.x imports `UserCache` from `@memberjunction/sqlserver-dataprovider`, which MJ
    6.x moved to `@memberjunction/generic-database-provider`, so Open App bootstrap dies on a
    6.x host with `does not provide an export named 'UserCache'`. 5.34.0 is the first build
    that loads.
  - tasks 1.2.2 peer-declared `@memberjunction/ng-gantt` and `ng-kanban` at `^6.1.0-edge.1`.
    Peer ranges are part of a package's published contract, so consumers resolved an edge.1
    tree even after moving to edge.2 themselves; in a sibling repo that produced 244
    `@memberjunction` packages at edge.1 alongside the edge.2 set. 1.2.3 fixes the ranges.

  Also declares `@mj-biz-apps/committees-core-entities-server` in `mj-app.json`, which was
  published but absent from the manifest.

## 1.1.0

### Minor Changes

- ed6c569: PG migrations
- 4d8112b: MJ core floor raised to 5.45 (SS Metadata_Sync requires the v5.45 spCreateAIAgent signature); PostgreSQL one-shot install hardened against core 5.45 (core maintenance sproc calls stripped from baked migrations, EntityField.Type pinned to the SS-canonical vocabulary). Validated end-to-end on fresh SQL Server and PostgreSQL at core v5.45.0: migrate-only PG install, 25/25 functional suite, codegen no-op on both engines, MJAPI serving.
- fdc959f: Committees v1
