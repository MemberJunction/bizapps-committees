# `@mj-biz-apps/committees-integration-tests`

Cross-stack, dual-DBMS (SQL Server & PostgreSQL) integration check bundles and realistic multi-entity governance seed fixtures (`COM-WORLD`) for the **MemberJunction Committees OpenApp**.

## Check Bundles

| Bundle | Checks | Coverage |
|---|---|---|
| `committees-world` | `CW1`–`CW11` | Idempotently seeds `COM-WORLD` through `BaseEntity`: 1 organization, 9 committees (standing, board, ad hoc/dissolved, workgroup), 35 people, 5 sign-in personas (`marcus`, `priya`, `alex`, `ruth`, `jamie`), 4 committee types, 4 roles, 16 terms, 100+ memberships, 13 meetings, 4 legacy minutes, 2 MJ-Docs-backed minutes (pinned approved v1 with newer v2 addendum + unpinned live draft), 6 mixed external URL & native MJ Docs artifacts, 5 `MJ: Artifacts`, 7 `MJ: Artifact Versions`, 6 motions, 4 ballots, and 24 votes. |
| `ballot-sealing` | `BS1`–`BS8` | Sealed/unsealed ballot row-level security as sign-in personas, `BallotCloseService`, `CommitteeAuthorization`, `LinkedUserID` vs user-link binding, and ClassFactory registration. |
| `minute-artifact-dual-read` | `DR1`–`DR6` | Pinned approved MJ Docs minute resolution (`ApprovedArtifactVersionID`), live unpinned draft resolution, legacy `Minute.Content` fallback, opt-in idempotent `BridgeLegacyMinuteToMJDoc` (preserving `Minute.Content`), batched `RunViews` classification of external URL vs native MJ Docs `Committees: Artifacts`, and multi-entity seed density (`>=20` domain records). |
| `pg-parity-and-boundary` | `PB1`–`PB6` | Adversarial boundary checks rejecting orphan `ApprovedArtifactVersionID`, cross-artifact version mismatches, missing versions, and malformed UUIDs; Category C relational `Notes` invariants (`Motion`, `Vote`, `Attendance`); live SQL Server / PostgreSQL catalog parity (columns, nullability, `vwMinutes`/`vwArtifacts`, `NO ACTION` FKs, indexes); and non-owner UI persona RLS reads. |

## Running

```bash
# Build the integration test package
pnpm --filter @mj-biz-apps/committees-integration-tests build

# SQL Server (default)
node test-harnesses/integration.mjs
node scripts/seed-committees-mj-docs.mjs

# PostgreSQL
DB_PLATFORM=postgresql node test-harnesses/integration.mjs
DB_PLATFORM=postgresql node scripts/seed-committees-mj-docs.mjs
```
