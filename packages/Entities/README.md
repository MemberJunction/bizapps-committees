# `@mj-biz-apps/committees-entities`

Strongly typed MemberJunction `BaseEntity` subclasses and Zod schemas for the `__mj_BizAppsCommittees` schema.

## Structure

- `src/generated/entity_subclasses.ts` — CodeGen-managed entity subclasses and Zod schemas (never edit by hand; regenerate via `mj codegen`).
- `src/custom/MeetingEntity.ts` — `MeetingEntityCustom` (`Committees: Meetings`) validating `EndDateTime > StartDateTime`.
- `src/custom/MembershipEntity.ts` — `MembershipEntityCustom` (`Committees: Memberships`) enforcing active-role, date-order, and duplicate-active-membership checks.
- `src/custom/MinuteEntity.ts` — `MinuteEntityCustom` (`Committees: Minutes`) enforcing MJ Docs artifact-version referential integrity.

## Additive MJ Docs Columns (v6.3.x)

To bridge Committee Minutes and Artifacts with native MemberJunction MJ Docs (`MJ: Artifacts` / `MJ: Artifact Versions`) without breaking existing consumers:

| Entity | Column | Type | Target | Semantics |
|---|---|---|---|---|
| `Committees: Minutes` | `MJArtifactID` | `UNIQUEIDENTIFIER NULL` | `__mj.Artifact(ID)` (`ON DELETE NO ACTION`) | Optional link to a native MJ Docs document. When `NULL`, legacy `Minute.Content` is rendered. |
| `Committees: Minutes` | `ApprovedArtifactVersionID` | `UNIQUEIDENTIFIER NULL` | `__mj.ArtifactVersion(ID)` (`ON DELETE NO ACTION`) | Optional immutable version pin captured upon minute approval. Must belong to `MJArtifactID` and cannot be set when `MJArtifactID` is `NULL`. |
| `Committees: Artifacts` | `MJArtifactID` | `UNIQUEIDENTIFIER NULL` | `__mj.Artifact(ID)` (`ON DELETE NO ACTION`) | Optional link to a native MJ Docs document. When `NULL`, the record represents an external URL or cloud-provider link. |

### Backward Compatibility

- `Minute.Content`, `Minute.ArtifactID`, `Artifact.URL`, `Artifact.Provider`, and `Artifact.ExternalID` remain intact and unmodified.
- Relational quick-note columns (`Motion.Notes`, `Vote.Notes`, `Attendance.Notes`) remain strictly relational (Category C).

## Scripts

```bash
pnpm --filter @mj-biz-apps/committees-entities build
pnpm --filter @mj-biz-apps/committees-entities test
```
