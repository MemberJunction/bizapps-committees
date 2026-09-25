# BizApps Committees — UX v2 Specification

**The definitive UX for multi-committee governance on MemberJunction.**
Author: UX v2 design pass · Status: Reference standard · Mockups: this folder (`index.html` gallery)

---

## 1. What we're designing (and what we're not)

BizApps Committees is not a board portal. Board portals (OnBoard, BoardEffect, Boardable, Diligent)
optimize for *one* board with a paid administrator babysitting it. Associations don't look like that:
they run **20–200 committees simultaneously** — a board, a dozen standing committees, standards
working groups with sub-workgroups, ad hoc task forces that appear and dissolve every year.
The people on them are **volunteers who show up quarterly** and forget the software between visits.

So the product has two customers with opposite needs, and the UX must serve both without compromise:

| | Governance staff (daily) | Volunteers (quarterly) |
|---|---|---|
| Mental model | Portfolio of 40+ committees | "My two committees" |
| Tolerance for density | Wants density — triage view | Zero. One next action. |
| Learning curve | Will learn power features | Must need **no** learning |
| Killer feature | Cross-committee health signals | One-click everything |

Everything in this spec derives from that split.

---

## 2. Personas

1. **Dana — Association governance admin** (daily). Owns the whole committee portfolio at the
   Global Standards Alliance. Cares about: which committees are healthy, which terms lapse next
   quarter, which minutes are stuck unapproved, quorum risk for upcoming meetings. Lives in the
   **Command Center**.
2. **Thomas Anderson — Board Chair** (weekly around meetings). Runs meetings, wants the agenda,
   quorum, and motion capture handled without a second screen of admin work. Lives in
   **Committee Workspace → Live Meeting Mode**.
3. **Lisa Nakamura — Secretary** (around meetings). Owns minutes and their approval trail. The AI
   drafts; she confirms. Lives in **Minutes Review**.
4. **Sarah Chen — Volunteer member** (quarterly). Board + Finance & Audit member with a day job as
   CEO of Acme Technologies. Wants: next meeting, my open actions, anything waiting on my vote —
   and nothing else. Lives in **My Committees** (desktop + phone).
5. **Executive/board view** — Patricia Williams (Vice Chair) scanning governance posture before a
   board meeting: term pipeline, motion outcomes, attendance trends. Served by Command Center's
   read-only lens + Terms & Succession.

---

## 3. The five signature design moves

### Move 1 — The Governance Health Grid (portfolio-first IA)
The home screen is not a committee list; it is a **triage board**. Every committee is a row with
computed health signals derived 1:1 from real entities — *quorum risk* (Attendance history ×
Membership.IsVotingRole), *term hygiene* (Term.EndDate/Status — including the "no active term"
lapse state), *minutes debt* (Minute.ApprovalStatus = Draft/PendingApproval age), *action aging*
(ActionItem.DueDate < today AND Status ∈ Open/InProgress). Healthy committees compress to one
quiet row; unhealthy ones surface loudly. This is the screen that sells the product — no board
portal can render it because they don't model the portfolio.

### Move 2 — One meeting spine (agenda as the thread)
Prep, live execution, and minutes are not three features — they are **three tenses of the same
AgendaItem records**. The agenda built before the meeting *is* the running order during the
meeting *is* the skeleton of the minutes after it. Live Meeting Mode is therefore agenda-driven:
a persistent quorum bar (Attendance), the current item in focus, motions captured inline against
the item (Motion.AgendaItemID), and the AI minutes draft growing item-by-item on the right.
Nothing is transcribed twice.

### Move 3 — Assist-mode AI, provisional by design
AI never writes into the record. It writes **proposals** rendered in a visually distinct
provisional style — violet accent, dashed border, sparkle glyph — with three verbs (Accept ·
Edit · Dismiss) and a provenance line that survives acceptance ("Drafted by AI · Approved by
L. Nakamura, Secretary — Apr 15, 2026"). The paid AI tier (auto-minutes, agenda drafting,
e-ballots, succession analytics) is visible everywhere but *quiet*: one suggestion card per
context, never a takeover. Every acceptance maps to a real field write (AgendaItem.Notes,
Minute.ApprovalStatus, Membership) so the audit trail is the entity history, not a bolt-on.

### Move 4 — The term clock (time as a first-class axis)
Governance is time-based in a way task apps are not: terms expire, officers roll over, quorum
erodes as seats empty. Terms & Succession renders the roster as a **horizontal term timeline**
(Term.StartDate→EndDate bars per Membership), with a "next 90 days" countdown lens, a vacancy
pipeline, and AI succession suggestions grounded in observable evidence (attendance %, current
roles, cross-committee service). Expiring-term chips reuse the same visual grammar in the
Command Center and Committee Workspace, so the term clock is ambient across the app.

### Move 5 — Two-speed UX (dense for staff, effortless for volunteers)
Same token system, two tempos. Staff surfaces are dense: 40-row grids, compact type, keyboard-
friendly. The volunteer surface (My Committees) is a **"next thing" feed**: next meeting with
RSVP + join, open actions with a one-tap done, votes waiting with ballot buttons inline. Font
size up, density down, zero chrome to learn. It is mobile-first because volunteers live on phones.

---

## 4. Information architecture & navigation

BizApps Committees ships as an MJ Explorer application with six nav items (Application →
DefaultNavItems, each a `BaseResourceComponent` DriverClass):

```
BizApps Committees (app)
├── Command Center        ← default tab. Portfolio health grid + upcoming meetings + risk rails
├── Committees            ← directory (40+); row → Committee Workspace
│     └── Committee Workspace (per committee: Overview · Roster & Terms · Meetings · Motions ·
│           Actions · Documents) — one coherent surface, left-tabbed interior
│           └── Meeting detail → Live Meeting Mode (full-screen takeover, deliberate exception)
├── Meetings              ← cross-committee calendar/list
├── Motions & Ballots     ← cross-committee motion register + between-meeting e-ballots
├── People & Terms        ← roster timeline, expiring terms, succession pipeline
└── My Committees         ← the volunteer/member lens (every user has it; for most it's home)
```

**Chrome mapping (buildable in MJ Explorer without fighting it):**

- Every screen uses the `<mj-page-layout>` + `<mj-page-header>` + `<mj-page-body>` trio.
  Header icon renders in `--mj-brand-primary`. Subtitle carries the scope sentence.
- `[meta]` slot = read-only signal badges, max 3 (e.g. "6 need attention" warning callout,
  "38 of 42 active" stat badge). Never actionable.
- `[actions]` slot = right-aligned verbs, one primary rightmost ("+ New Committee",
  "Start Meeting", "Approve Minutes").
- `[toolbar]` slot = `search → Filters popover → view toggle`, in that order. No second
  control bar ever appears inside the body.
- Committee Workspace sub-pages use the **interior header** pattern (`<mj-page-header-interior>`)
  inside the workspace's left-tab shell — no doubled headers.
- **Live Meeting Mode is a documented chrome exception** (like AI Overview/Component Studio):
  a full-screen focus surface with its own top bar (quorum + elapsed + record state), because
  running a meeting is a mode, not a page. Entered explicitly, exited explicitly.

**Entity truthfulness:** every visible datum maps to a real column — Committee(.Name, .Status,
.TypeID→Type.IconClass, .ParentCommitteeID, .IsPublic), Term(.Name, .StartDate, .EndDate,
.Status), Role(.IsOfficer, .IsVotingRole), Membership(.Status, .EndReason, .Notes),
Meeting(.StartDateTime, .TimeZone, .LocationType, .VideoProvider, .VideoJoinURL, .Status),
AgendaItem(.Sequence, .ItemType, .DurationMinutes, .PresenterPersonID, .Status, .Notes,
.ParentAgendaItemID), Attendance(.AttendanceStatus, .JoinedAt), Motion(.MovedByMembershipID,
.SecondedByMembershipID, .Result, .ResultSummary, .Yes/No/AbstainCount), Vote(.VoteValue,
.Notes), ActionItem(.DueDate, .Priority, .Status, .AssignedToPersonID), Artifact(.Provider,
.URL, .ArtifactTypeID), Minute(.ApprovalStatus, .ApprovedAt, .ApprovedByMeetingID).
Derived signals (health, quorum %, attendance rate) are computations over those columns only.
Quorum *rules* are presented as committee policy (majority of voting members) — a deliberate
v-next schema candidate (`Committee.QuorumRule`), flagged as such in mockups rather than faked
as an existing field.

---

## 5. The screens (this folder)

| # | File | Persona | What it proves |
|---|------|---------|----------------|
| 1 | `01-command-center.html` | Dana | Portfolio health grid @ 42 committees, risk rails, skeleton loading state, restricted-committee row |
| 2 | `02-committee-workspace.html` | Dana/Chair | One coherent per-committee surface: roster+terms, meetings, motions, actions, documents; interior-header pattern; empty state |
| 3 | `03-live-meeting.html` | Thomas (Chair) | Agenda-driven execution: quorum bar, roll-call motion voting with live tally, AI minutes drafting in assist mode |
| 4 | `04-motions-voting.html` | Dana/members | Between-meeting e-ballot with threshold logic + defensible audit trail; cross-committee motion register |
| 5 | `05-terms-succession.html` | Dana/Patricia | Term timeline, 90-day expiry lens, vacancy pipeline, evidence-based AI succession suggestions |
| 6 | `06-member-home.html` | Sarah (volunteer) | The quarterly-visitor feed: next meeting, open actions, votes waiting — one click each; responsive to 390px + phone-frame preview toggle |
| 7 | `07-minutes-review.html` | Lisa (Secretary) | AI draft → human review → approval trail; side-by-side source evidence; permission-limited state |

**States shown across the set:** loading skeleton (01: attendance-trend panel), empty state
(02: no motions this term · 06: zero-inbox), permission-limited (01: private committee row locked;
07: member sees read-only banner), overdue/at-risk (01, 06), AI-provisional vs human-confirmed
(03, 05, 07).

---

## 6. Visual language

- **Tokens:** every color/space/type value is an `--mj-*` token copied verbatim from MJ's
  `_tokens.scss` (light + dark), inlined per page. Zero hardcoded colors outside the token block.
  Two app-scoped additions live *inside* the token block: `--cmt-ai-*` (AI provisional accents,
  derived from MJ violet primitives) and `--cmt-cat-*` (categorical avatar/chart hues —
  the sanctioned categorical-color exception).
- **Theme:** honors `prefers-color-scheme` on first load; visible sun/moon toggle stamps
  `data-theme` on `<html>`; both themes hold WCAG AA on text and interactive elements.
- **Type:** MJ token font stack (`Inter, -apple-system, …`) — resolves to the system UI face in
  the self-contained mockups, deliberately.
- **Icons:** inline SVG sprite (no CDN) mirroring the Font Awesome names the metadata already
  stores (`fa-landmark`, `fa-users`, `fa-clock`, …) so the build maps straight back to
  `Type.IconClass`/`ArtifactType.IconClass`.
- **Status grammar:** one badge system everywhere — success/warning/error/info tokens; motion
  results (Passed/Failed/Tabled/Withdrawn), meeting status, term status, approval status all
  speak it.
- **AI grammar:** violet + dashed + sparkle = provisional. Solid card = record. The moment a
  human accepts, the card re-renders in record style with a provenance caption. No exceptions.
- **Motion:** restrained and pedagogical only — tab underline slide, vote tally count-up,
  theme cross-fade, skeleton shimmer. Everything respects `prefers-reduced-motion`.
- **Accessibility:** semantic landmarks, real buttons/links, `:focus-visible` rings via
  `--mj-focus-ring`, `aria-live` on the vote tally, labeled toggles, AA contrast both themes.

---

## 7. Deliberate departures from the v1 mockups

The v1 set (plans/mockups/) is a *design-options catalog*: three alternative treatments per
journey, hardcoded `#667eea` purple (not MJ tokens), light-only, lorem-grade data, no states,
no mobile, and framed as documents about the product rather than the product. v2 replaces it with
**one opinionated product**: MJ tokens with real dark mode, the actual sample-data people and
committees, admin-grade density, explicit empty/loading/permission states, honest AI affordances,
and screens that map to Explorer chrome + entities closely enough to hand to engineering.

## 8. v-next schema candidates surfaced by this design (not faked in mockups)

- `Committee.QuorumRule` (+ per-motion threshold on Motion) — today presented as policy text.
- `Ballot` entity (between-meeting e-ballots: opens/closes, threshold, anonymity flag) — mocked
  as "E-Ballot" atop Motion/Vote with a callout noting the extension.
- `Attendance` RSVP state pre-meeting (today `Expected` covers it coarsely).
- AI provenance columns (`GeneratedByAI`, `ApprovedByPersonID`) on Minute/AgendaItem.Notes —
  today provenance is carried in Notes text + Record Changes.
