# PRD — Committees UX v2, Phase 1 "Land"

> **Status:** Draft for review · **Source design:** PR #6 (`plans/ux-v2/`) — UX-SPEC.md + BUILD-PLAN.md
> **Scope:** Governance Command Center (screen 01) + Committee Workspace (screen 02)
> **Branch:** follows `ian-openapp-restructure` (MJ 5.44, `__mj_BizAppsCommittees` schema)

## 1. Problem & goal

Committees is the anchor listing for MJ Central. The entity layer is built; the current UI
(`management-dashboard`, `management-committee-list`, etc.) predates the UX v2 design. Phase 1
replaces the staff-side home experience with the two screens that make the product demoable:
a portfolio triage board (Command Center) and a single coherent per-committee surface
(Committee Workspace).

**Definition of demoable:** a Dana-persona user opens the Committee Management app, sees the
health grid at realistic density (40+ committees), drills into any committee, and can walk
roster/meetings/motions/actions/documents without leaving the workspace — in both themes.

## 2. App placement (two-app architecture)

Both Phase 1 screens belong to the **Committee Management** application (staff side). The
member-facing **Committees** app is untouched in Phase 1 except that shared components must
not regress it.

| Screen | App | Nav position |
|---|---|---|
| 01 Command Center | Committee Management | Home (default tab, replaces ManagementDashboardComponent) |
| 02 Committee Workspace | Committee Management | Drill-in from Committees directory (row click) |

The member-scoped variant of the Workspace (Sarah's view) is **Phase 3**, but Phase 1 components
must be permission-aware from day one (see §6).

## 3. Personas served

- **Dana — governance admin (daily):** portfolio health, term lapses, stuck minutes, quorum risk.
- **Patricia — exec/board (read-only lens):** scans posture; sees the same grid without admin verbs.

## 4. Screen requirements

### 4.1 Governance Command Center (01)

The home screen is a triage board, not a list. Requirements, all computed from real columns
(no shadow fields):

| Signal | Formula (existing entities only) |
|---|---|
| Quorum risk | Attendance history × `Membership` where `Role.IsVotingRole = 1`, per upcoming `Meeting` |
| Term hygiene | `Term.EndDate` / `Term.Status` — incl. the loud "no active term" lapse state |
| Minutes debt | `Minute.ApprovalStatus IN (Draft, PendingApproval)` age |
| Action aging | `ActionItem.DueDate < today AND Status IN (Open, InProgress)` |

Layout (per mockup `01-command-center.html`):
- Stat tiles: committees count, serving members, terms expiring ≤ 90 days, overdue actions
- Health grid: one row per committee — health chip, members, quorum risk, term, minutes, actions;
  sorted needs-attention-first; healthy committees compress quiet
- "This week" rail: upcoming meetings with quorum forecast per meeting
- "Needs your attention" rail: top risk items
- Designed states: **loading skeleton** (attendance panel), **permission-locked row** (private
  committee), empty state

### 4.2 Committee Workspace (02)

One surface per committee, left-tabbed interior: **Overview · Roster & Terms · Meetings ·
Motions · Actions · Documents**. Largely composition of existing lib features
(`membership-panel`, `meeting-list`, `motions`, `action-item-tracker`, `documents`) under a
new workspace shell with an interior header (committee name, type, chair, health chips).
Designed states: empty ("no motions this term"), read-only for non-admin viewers.

## 5. Engineering approach

**Components** (NgModule-declared per repo convention, `standalone: false`, `@if`/`@for` syntax,
PascalCase public members):
- `packages/Angular/src/lib/command-center/` — `CommandCenterComponent` (+ grid row, rails as
  child components; decomposed, ≤40-line functions)
- `packages/Angular/src/lib/committee-workspace/` — `CommitteeWorkspaceComponent` + tab panels
- Registered as `BaseResourceComponent` DriverClasses; added to `CommitteesModule` declarations
  and `public-api.ts`

**Signal computation** — `packages/Core/src/services/CommitteeHealthService.ts`:
- Single batched `RunViews` load (committees, active terms, upcoming meetings, memberships,
  pending minutes, open action items) — **no per-committee queries in loops**
- Pure functions per signal so they unit-test without a DB (vitest, per-package config)
- Server context: all `RunView`/`GetEntityObject` calls take `contextUser` when used server-side

**Nav wiring** — update `DefaultNavItems` for Committee Management in the baseline's
APPLICATION CONFIG section (pre-publish, so editing the baseline is still allowed):
`ManagementDashboardComponent` → `CommandCenterComponent` as default; add Workspace as a
non-nav drill-in resource.

**Chrome & theming** — `<mj-page-layout>` + `<mj-page-header>` + `<mj-page-body>` trio;
`[meta]` = max 3 read-only badges; `[actions]` = verbs, one primary rightmost ("+ New
Committee"); `[toolbar]` = search → Filters → view toggle. Semantic `--mj-*` tokens only —
zero hardcoded colors. Both themes screenshot-checked. `<mj-loading>` for spinners, Font
Awesome icons, confirm-left/cancel-right dialogs.

**Permissions** — reuse `shared/committee-permission-helper`; `IsPublic = 0` committees render
the locked-row state for users without membership/staff rights.

## 6. Explicitly out of scope (Phase 1)

- AI assist surfaces (minutes drafting, succession suggestions) — Phase 2+; the Command Center
  ships **without** the violet provisional grammar
- Sealed e-ballots (open v-next decision on PR #6)
- Member-app changes (Member Home, member-scoped workspace) — Phase 3
- Mobile/390px optimization — Phase 3 (Phase 1 targets desktop staff density)
- Old `management-dashboard`/`management-committee-list` removal — superseded but deleted only
  after Command Center is accepted

## 7. Acceptance criteria

1. Committee Management app opens to Command Center; grid renders 40+ committees from demo data
   (`Demos/02_Committees_Sample_Data.sql`) with correct signal math (spot-check quorum-risk and
   no-active-term cases against SQL)
2. Row click → Committee Workspace; all six tabs populated; back preserves grid scroll/filter
3. Loading skeleton, empty, and permission-locked states all reachable and styled
4. Both themes pass a visual pass; no hardcoded colors (`grep -r '#[0-9a-fA-F]\{3,6\}'` clean
   outside token definitions)
5. `CommitteeHealthService` signal functions covered by vitest unit tests
6. Full build green; MJAPI boots; member Committees app unaffected

## 8. Housekeeping folded into this phase

- Update `repository` URLs (`mj-app.json`, all package.jsons, `validate-package-repository.sh`,
  `PUBLISH_SETUP.md`) to the renamed repo `MemberJunction/bizapps-committees`
- Add `dbo` to `excludeSchemas` in `mj.config.cjs` (sibling parity)

## 9. Decisions (resolved 2026-07-06 with Ian)

1. **Build fresh**: new `CommandCenterComponent` per the UX v2 IA; `management-dashboard`
   stays until Command Center is accepted, then is deleted.
2. **Thresholds**: encode the mockup's implied defaults as named constants in
   `CommitteeHealthService`; tune after first demo.
3. **Directory**: existing `management-committee-list` remains the drill-in path for Phase 1;
   UX v2 treatment for the directory lands in Phase 2.
