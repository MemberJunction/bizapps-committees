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

> **Status: shipped** (`0f81e16`) — 7/7 end-to-end, 82 unit tests.
> Decisions taken: Undecided/never-asked carry flagged; Lapsed chips open the
> wizard; AI suggestions opt-in per opening.

---

## Feature 2 — Ballot-Close Ceremony + Remind

### Why now
Phase 2's close is one silent click: correct math, instant Motion stamp, no
moment of record. Closing a ballot is the governance act — the chair should
see participation, the threshold math, and the outcome that is about to be
stamped *before* committing, and non-voters should be nudgeable while the
ballot is still open. "Remind" was explicitly deferred to this phase.

### What exists (Phase 2)
- `BallotService`: RequiredYes / ForecastOutcome (decided-early detection),
  countdowns, seal semantics. `OnCloseBallot` in Motions & Ballots stamps
  Motion (Result/Summary/counts) and flips Ballot → Closed.
- Sealed ballots hide individual choices while Open.
- Server-side notification pattern: `CommitteeNotificationHandler` creates
  `MJ: User Notifications` (in-app bell) via Person.LinkedUserID.

### Ceremony (replaces the silent close)
Clicking **Close ballot** opens a confirm dialog:
- **Participation**: X of N voting members cast; outstanding members listed
  by name (they are known — sealed hides *choices*, not *who has voted*).
- **Threshold math**: required Yes for the threshold/basis vs. Yes so far,
  rendered as the same forecast members see, plus the outcome to be stamped.
- **Early-close warning** when ClosesAt is in the future and the outcome is
  not yet mathematically decided: "outstanding votes could change the result".
- **Result notes**: pre-filled with the stamp summary, editable — the chair's
  annotation lands in `Ballot.ResultNotes`.
- Confirm (left) → close+stamp (existing write path), then a **reveal state**
  in the dialog: outcome banner, final tally bar, participation line — the
  ceremonial beat before returning to the list.
- Secondary action: **Cancel ballot** (Status → Cancelled, no Motion stamp,
  notes required) for withdrawn motions.

### Remind (non-voters, while Open)
- **Remind** button on open ballots: server mutation `RemindBallotNonVoters`
  (committees-server resolver + CoreEntitiesServer service, mirroring
  SuggestSuccessors) — finds voting members without a Vote on the motion,
  creates an in-app `MJ: User Notifications` row per member with a linked
  user account ("Your vote is needed: <motion> — closes <date>").
- Result reported honestly: "Reminded 4 of 6 — 2 have no linked account"
  (email delivery arrives with workstream 4; the service is written so the
  digest can reuse the same non-voter computation).
- No spam guard column exists and none is invented — the button reports the
  last reminder in-session only.

### Not in this feature
- Email delivery (workstream 4 owns the channel).
- Per-voter breakdown of sealed ballots after close — sealed means the
  individual choices stay sealed; the ceremony reveals the tally.

### Build order
1. `BallotCloseService` math additions if needed (participation summary is
   already computable from BallotService) + non-voter computation shared
   client/server (committees-core, pure + tested).
2. Server: `BallotReminderService` (CoreEntitiesServer) + `RemindBallotNonVoters`
   mutation (Server resolver).
3. Ceremony dialog component in motions-ballots + Remind wiring; Playwright
   pass (remind → bell notification exists; close early with warning; reveal;
   cancel path).

> **Status: shipped** (`38eb724`) — remind/warning/reveal/cancel verified against
> the live DB. Decisions taken: early close allowed with warning; sealed ballots
> stay sealed permanently (tally only); Remind via in-app notifications.

---

## Feature 3 — Agenda Builder

### Why now
Meeting prep is the last tense with no first-class surface. Agendas today are
raw rows: the meeting-detail Agenda tab is read-only and the only editor is a
legacy per-item dialog buried in meeting-edit. Yet the agenda already drives
real product moments — Member Home's "6 agenda items · 2 votes expected" and
Live Meeting's item progression both read it. Building the agenda should feel
like planning the meeting, not doing data entry.

### Where it lives
The meeting-detail **Agenda tab becomes the builder** when the meeting is
`Scheduled` (staff view). Once the meeting is InProgress/Completed the tab
reverts to today's read-only record — Live Meeting owns the agenda during,
minutes own it after. No new nav item; prep happens where the meeting lives.

### The builder
- **Inline add**: type a title, pick a type (Discussion · Vote · Report ·
  Action · Information · Other), enter — item lands at the end, Sequence
  assigned. No dialog for the common case.
- **In-place edit** per row: title, type, duration (minutes), presenter
  (committee-member picker), notes. The legacy dialog stays untouched for
  meeting-edit; the builder writes the same entity.
- **Reorder**: up/down controls per row (keyboard-friendly, no new
  dependency); Sequence renumbers contiguously on every move.
- **Time budget rail**: running total of DurationMinutes vs. the meeting
  window (Start→End), with an over/under indicator and a per-item share bar —
  the "will this meeting fit" answer at a glance.
- **Vote-item awareness**: Vote rows get the gavel treatment and the header
  counts them ("2 votes expected" — the same number Member Home shows).
- Delete with inline confirm; items stay `Pending` status (Live Meeting owns
  status progression).

### Publishing
No publish step: the agenda is live the moment it's edited (Member Home's
hero already reads it). Announcing agenda changes to attendees is the
notification digest's job (workstream 4) — the builder stays a working
surface, not a broadcast tool.

### Not in this feature
- Nested items (`ParentAgendaItemID` exists but stays flat — nesting waits
  for a real need).
- Drag-and-drop (needs @angular/cdk — a new dependency for sugar the up/down
  controls already deliver; revisit if prep users ask).
- Agenda templates / copy-from-last-meeting (good v-next candidate).

### Build order
1. Builder component (`meeting-detail/agenda-builder.component`) + swap into
   the Agenda tab for Scheduled meetings; entity writes with contiguous
   resequencing.
2. Time-budget math (pure helpers, unit-tested in committees-core if it grows
   beyond trivial).
3. Playwright pass: add/edit/reorder/delete items on the Jul 13 meeting,
   verify Member Home's hero counts update.

> **Status: shipped** (`9ceae0c`) — 15/15 end-to-end. Decisions taken: builder in
> the Agenda tab (Scheduled only); up/down reorder, no CDK; agenda live as edited.

---

## Feature 4 — Notification Digest: DEFERRED (2026-07-07)

Decision: publish without email. In-app bell notifications remain the delivery
channel (ballot Remind and committee events already use them); Member Home's
copy now promises "a notification", not an email. The digest becomes the
flagship post-publish feature — its PRD starts with the email-infrastructure
choice (MJ Communication framework provider), and BallotReminderService's
non-voter computation was built to be reused by it.
