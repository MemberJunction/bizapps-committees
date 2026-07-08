# PRD — Committees UX v2, Phase 2 "Govern"

> Source of truth: PR #6 UX v2 design package (`plans/ux-v2/` on branch
> `claude/mj-bizapps-strategy-ga3831`) — screens `03-live-meeting.html`,
> `04-motions-voting.html`, `07-minutes-review.html`, plus `UX-SPEC.md` §3 (moves 2–3),
> §4 (chrome/IA), §8 (v-next schema).
> Predecessor: `PHASE1_PRD.md` (Command Center + Committee Workspace — shipped).

## 1. Goal

Ship the governance loop: run a meeting from its agenda, capture motions and roll-call
votes as records, run between-meeting e-ballots with a defensible audit trail, and take
AI-drafted minutes through human review to the approved record.

Three screens, all in the staff **Committee Management** app:

| Screen | Mockup | Persona | Surface |
|---|---|---|---|
| Live Meeting Mode | 03 | Thomas (Chair) | Full-screen takeover from a meeting |
| Motions & Ballots | 04 | Dana (admin) | New top-level nav item |
| Minutes Review | 07 | Lisa (Secretary) | Opened from a meeting / minutes record |

## 2. Decisions (resolved 2026-07-06 with Ian)

1. **Ballot entity ships now** — the v-next migration is approved (PR #6 open item #2).
2. **Build fresh** — new components to the v2 design; the pre-v2 `meeting-live-view`,
   `motion-edit-dialog`, and `generate-minutes-panel` stay untouched until acceptance,
   then are deleted (same pattern as Phase 1's dashboard).
3. **"Motions & Ballots" becomes a top-level nav item** in the staff app
   (DefaultNavItems update + live-DB sync).

## 3. Schema — the Ballot migration (v1.1)

New `V`-migration (`${flyway:defaultSchema}` placeholders, no `__mj_*` timestamps,
no FK indexes — CodeGen owns those):

**`Ballot`** — voting-window machinery for exactly one motion:

| Column | Type | Notes |
|---|---|---|
| ID | uniqueidentifier PK default newsequentialid() | |
| CommitteeID | uniqueidentifier FK → Committee, NOT NULL | ballot lives at committee scope |
| MotionID | uniqueidentifier FK → Motion, NOT NULL, UNIQUE | 1:1 with the motion being decided |
| OpensAt | datetimeoffset NOT NULL | |
| ClosesAt | datetimeoffset NOT NULL | scheduled close; UI countdown |
| ClosedAt | datetimeoffset NULL | actual close (early or scheduled) |
| ThresholdType | nvarchar(20) CHECK: SimpleMajority / TwoThirds / Unanimous | of voting members (mockup: "4 Yes = ⅔ of voting members") |
| IsSealed | bit NOT NULL default 1 | choices hidden until close |
| Status | nvarchar(20) CHECK: Open / Closed / Cancelled | |
| CreatedByMembershipID | uniqueidentifier FK → Membership NULL | who opened it |
| ResultNotes | nvarchar(max) NULL | certification text at close |

**`Motion.MeetingID` → nullable** — an e-ballot motion has no meeting. Register shows
"Between meetings" for those rows (mockup does exactly this).

Extended properties (MS_Description) on table + columns per MJ conventions. Entity name
gets the `Committees: ` prefix via existing NameRulesBySchema → "Committees: Ballots".

**Sealing semantics (v1):** `IsSealed` ballots withhold `Vote.VoteValue` in the UI and
in a resolver-level guard until `Status = 'Closed'` — votes are still normal Vote rows.
True cryptographic sealing is out of scope and documented as such (the audit trail shows
*that* someone voted, never *what*, until close).

## 4. Screen contracts (from the mockups, verbatim structure)

### 03 · Live Meeting Mode — full-screen chrome exception
- **Entered explicitly** (Start/Resume meeting from the workspace Meetings tab or meeting
  row), **exited explicitly** (Exit button → back to workspace). Implemented as a
  fixed-position full-viewport overlay (`position:fixed; inset:0`) — the documented
  exception to Explorer chrome.
- **Top bar:** Exit · meeting title + committee/date/time/location subtitle · LIVE pill
  with elapsed clock · quorum widget (met/not-met tone, "X of Y voting", per-member pips,
  "need N") · attendance toggle · End meeting (danger).
- **Three columns** (280px / flex / 330px; minutes rail hides < 1150px):
  - **Agenda rail:** items in sequence — done (check, completion time), current
    (`aria-current="step"`, brand tint), upcoming; sub-items indented; ItemType badges
    (Vote/Report/Discussion). Clicking advances/selects (Chair only).
  - **Center — current item:** now-card with ItemType badge, title, presenter +
    description, linked artifact; Table item / Skip controls; elapsed-vs-planned meter.
    **Motion block** when a motion is on the floor: title + text, Roll call badge,
    Moved by / Seconded by (member pickers), threshold caption, roll-call rows — one
    per voting member with Yes/No/Abstain segmented buttons, awaiting-vote highlight,
    Excused/Non-voting rows inert — live tally bar with threshold tick +
    "threshold met — passes even if remaining vote is No" style precomputation,
    Record result (stamps Motion.Result/counts; votes become immutable), Nudge member.
    Record-integrity callout under the card.
  - **Minutes rail (assist mode):** confirmed `min-entry` blocks per completed item with
    provenance lines ("Drafted by AI · Confirmed by L. Nakamura, 2:12 PM"); the current
    item's AI draft in provisional grammar (violet/dashed/sparkle + blinking caret) with
    Accept · Edit · Dismiss; "In the room" chips with join times from Attendance.
- **Writes:** Attendance (join/leave), AgendaItem.Status progression, Motion + Vote rows,
  Minute.Content accumulation on Accept. Everything is entity writes — the record callout
  says so on-screen.

### 04 · Motions & Ballots — top-level page
- **Header:** gavel icon, title, "Cross-committee motion register and between-meeting
  e-ballots" subtitle; meta badges (N ballots open / M motions decided this quarter);
  actions: Export · **+ New E-Ballot** (primary).
- **Toolbar:** search → Filters (committee, result, date range).
- **Ballot hero** (per open ballot): Open badge + committee chip + close countdown;
  motion title + opened-by + motion text + linked doc; participation meter ("3 of 5
  voted"); threshold badge ("Needs 4 Yes (⅔ of voting members)"); "Choices sealed until
  close" chip; voter chips (Voted <date> / Not yet voted + Remind / Observer);
  footer: seal note · Extend deadline · Close early.
- **Ballot audit trail card:** immutable event list (created w/ threshold+close,
  notifications sent, votes cast — choice sealed, reminders, scheduled close) sourced
  from Record Changes + ballot rows.
- **Motion register table:** expandable rows (chevron) → roll-call detail grid
  (per-member vote chips + vote Notes quotes); columns Motion / Committee·Meeting
  ("Between meetings" for ballots) / Moved-Seconded / Result badge / mini tally bar +
  Y-N-A / Date. Footer: counts + CSV export.
- **New E-Ballot flow:** dialog — committee → motion title/text → linked doc (optional)
  → threshold → close datetime → creates Motion (no meeting) + Ballot(Open) rows.

### 07 · Minutes Review
- **Header:** "Minutes — {meeting}" + subtitle; meta: ApprovalStatus badge + "Approval
  scheduled" badge (from the next meeting's approve-minutes agenda item when present);
  actions: **View as Secretary/Member** toggle · Export PDF · Re-send to members
  (sec-only) · Finalize draft (sec-only, primary).
- **Member view** = read-only banner; all `sec-only` tools hidden.
- **Document pane:** formal dochead (org, meeting, date, secretary); numbered sections —
  confirmed sections show text + provenance line + Edit (sec-only); unconfirmed sections
  render in AI-provisional grammar with evidence links (transcript range, cited docs)
  and Accept section · Edit · Rewrite from transcript (sec-only).
- **Right rail:** Approval workflow steps (Drafted → Distributed → Pending approval →
  Approved; approval stamps ApprovedAt + ApprovedByMeetingID and locks the document);
  Linked records (artifact, meeting, approval motion, attendance); History (Record
  Changes excerpts).
- **Storage model:** Minute.Content holds the section list as Markdown with an HTML
  comment sentinel per section carrying status + provenance (parseable, exportable,
  survives round-trips). AI provenance columns are v-next per spec §8 — provenance text
  lives in content/Notes now.

### Workspace Motions tab (screen 02 follow-through)
Replaces the Phase 1 empty state: committee-scoped motion list (same row grammar as the
register) + open-ballot card if one exists + **New e-ballot** button (enabled now).

## 5. Services & AI

- **`BallotService`** (committees-core, browser-safe): pure threshold math
  (`RequiredYes(thresholdType, votingMemberCount)`), tally computation, pass/fail
  precomputation ("passes even if remaining votes are No"), seal-state logic, countdown
  helpers. Vitest suite (mirrors CommitteeHealthService's injected-`now` style).
- **`MotionService`** (committees-core): register queries (batched RunViews), roll-call
  detail assembly, motion+vote writes, result stamping.
- **AI minutes** ride the existing `MinutesService` (CoreEntitiesServer) +
  `MinutesResolver` — per-item drafting during Live Meeting and per-section
  rewrite-from-transcript in Minutes Review. Assist-mode grammar via app-scoped
  `--cmt-ai-*` tokens (defined once in the shared stylesheet, derived from MJ violet
  primitives, per UX-SPEC §6). AI never writes the record; Accept does.
- **Seal guard**: ballot votes withheld while sealed — enforced in the components and in
  the vote-fetch path used by them.

## 6. Non-goals (Phase 2)

- `Committee.QuorumRule` column — quorum/threshold stays presented as policy text
  (constants in services), per spec §8.
- Cryptographic vote sealing; RSVP states; AI provenance columns (all spec §8 v-next).
- Terms & Succession (05), Member Home (06), mobile — Phase 3.
- Agenda *builder* (prep tense), term-renewal wizard, ballot-close ceremony,
  notification digests — Phase 4. (Ballot close in Phase 2 = status flip + unseal +
  Motion stamp; no ceremony UI.)
- Real transcript capture — the transcript toggle renders; drafting consumes agenda
  item context + recorded facts (motions, votes, attendance). Transcript ingestion is
  its own future work.

## 7. Acceptance

1. Migration applies on a fresh install (DDL → codegen → app config order holds) and on
   COMM_FIXING; codegen emits Ballot entity/views/API with `Committees: ` prefix.
2. `BallotService` threshold/tally suite green (incl. TwoThirds rounding, unanimous with
   abstentions, precomputed-outcome cases).
3. Live Meeting: full-screen overlay in/out; roll-call writes Vote rows; Record result
   stamps the Motion and freezes the block; quorum bar reflects Attendance; minutes rail
   Accept appends to Minute.Content with provenance.
4. Motions & Ballots nav item renders the register + open-ballot hero; New E-Ballot
   creates Motion+Ballot; Remind/Extend/Close early work; sealed choices stay hidden
   until close, then unseal.
5. Minutes Review: Secretary/Member views; Accept section flips provisional → record
   with provenance; Finalize sets PendingApproval; approval stamping locks edits.
6. Both themes pass (semantic tokens only; `--cmt-ai-*` defined in the token layer).
7. Full repo build green; old meeting-live/minutes/motion-dialog components untouched
   until acceptance sign-off.

## 8. Build order

1. Ballot migration → run on COMM_FIXING → codegen pass (entities/views/API)
2. BallotService + MotionService + tests
3. Motions & Ballots page + nav item + New E-Ballot dialog
4. Live Meeting Mode overlay
5. Minutes Review
6. Workspace Motions tab content
7. Demo-data top-up (an open sealed ballot mid-vote, per mockup) + visual pass
