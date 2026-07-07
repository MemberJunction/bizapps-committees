# Phase 4 "Polish" — PRD

> Feature-at-a-time cadence: PRD → decisions → build → verify. This document grows
> a section per workstream as each one starts. Queue (from BUILD-PLAN §4):
> **1. Term-renewal wizard** (this section) · 2. Ballot-close ceremony + Remind ·
> 3. Agenda builder · 4. Notification digest (needs email-infra decision).

---

## Feature 1 — Term-Renewal Wizard

### Why now
Phase 3 shipped the alarm: People & Terms opens on "5 committees without an active
term" and every Lapsed chip says *renew now* — but there is no flow behind the
words. Staff currently have to hand-create a Term row and re-add every membership.
The wizard turns the renewal-intent capture (Member Home → pipeline) into a
one-screen administrative act.

### Entry points
1. **Lapsed lens chip** — "renew now" becomes the wizard trigger for that committee
   (chips currently route to the committee workspace; Lapsed chips route to the
   wizard instead).
2. **People & Terms timeline card** — a `Start term renewal` button in the card
   header, always available for the selected committee (renew early, before lapse).
3. **Vacancy pipeline footer** — same button when the pipeline shows seats to watch.

### Flow (full-screen overlay, 3 steps — same overlay pattern as Minutes Review)

**Step 1 · New term.**
- Name: suggested from the previous term's naming shape ("2025-2026" → "2026-2027";
  "2026 H2" → "2027 H1"); editable.
- Dates: suggested start = day after previous term's EndDate (or today if long
  lapsed); suggested end = start + previous term's duration (default 1 year).
- Status derived, not asked: spans today → `Active`; starts in the future →
  `Upcoming`.
- Guard: warn if a term with the same name already exists for the committee
  (no DB unique constraint — the wizard is the guard).

**Step 2 · Roster carry-over.**
One row per membership on the previous term, grouped by role, showing the
renewal-intent answer as evidence:
- Intent **Yes** → pre-checked *carry*.
- Intent **Undecided / unanswered** → pre-checked *carry*, flagged "unconfirmed".
- Intent **No** → unchecked, listed under **Openings** with the vacated role.
- Every row overridable; role reassignable per row (officer seats change hands here).
- **Add person**: search People not on the roster (active members of other
  committees first), pick role.
- **AI assist (reuse, not new)**: for each opening, the existing
  `SuccessionSuggestionService` cards render inline under that opening — same
  violet grammar, same honesty contract, "Add to roster" pre-fills an add-person
  row. No new AI surface.

**Step 3 · Review & create.**
- Summary: term name/dates · N carried (of M) · N dropped (with names) ·
  openings by role · N added.
- Confirm (left) / Back / Cancel (right).
- Writes, in order:
  1. Create Term (`Active`/`Upcoming`).
  2. Create Memberships on the new term — StartDate = term start, Status
     `Active`, **RenewalIntent NULL** (clean slate for the next cycle's ask).
  3. End prior-term memberships still `Active`: Status `Ended`,
     EndDate = old term EndDate (or today if renewing early), EndReason
     `Term ended` / `Declined renewal` per intent.
  4. Prior term → `Completed`.
- All writes through entity objects (`GetEntityObject` + `Save()`), sequential,
  with a failure banner naming exactly which step failed (no fake atomicity —
  MJ has no client transaction; the review step states writes are applied in order).

**Exit.** Land back on People & Terms with the committee selected: lens chip now
Current/Renewed, gantt shows the new bars, pipeline resets to AwaitingAnswer rows.

### Edge cases
- **No prior term** (brand-new committee): step 2 starts empty with add-person +
  AI suggestions against "all seats open" (service already handles empty rosters).
- **Renew while a term is still active** (early renewal): new term starts the day
  after the active term ends → `Upcoming`; current memberships untouched until the
  new term starts. No double-active terms for a committee.
- **Person already added manually** to the new term (partial retry after a failed
  run): create-membership step skips existing (PersonID, TermID) pairs.
- **Permissions**: staff only (`IsStaffUser`); entry points hidden otherwise.

### Not in this feature (stays deferred)
- Bulk "renew all five committees" — one committee per run keeps the review step
  honest; the lens rail makes running it five times cheap.
- Emailing the new roster (waits for workstream 4, the digest).
- Term-limit rules (no column exists; not invented here).

### Build order
1. `TermRenewalService` (committees-core): pure planning math — suggestNextTerm
   (name/date inference), buildCarryPlan (intent → carry/drop/flag), no I/O;
   unit tests alongside SuccessionService's.
2. Wizard component (`people-terms/term-renewal-wizard.component`, standalone,
   overlay) + entry-point wiring in People & Terms.
3. Write path + partial-retry guard; Playwright pass (renew a lapsed committee
   end-to-end, verify lens flips and pipeline resets); demo-data reset note.
