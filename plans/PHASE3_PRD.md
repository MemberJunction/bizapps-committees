# PRD — Committees UX v2, Phase 3 "Sustain"

> Source of truth: PR #6 UX v2 design package — screens `05-terms-succession.html`,
> `06-member-home.html`, `UX-SPEC.md` §3 (moves 4–5), §4 (IA), §8 (v-next).
> Predecessors: `PHASE1_PRD.md` (shipped), `PHASE2_PRD.md` (shipped).

## 1. Goal

Make time a first-class axis (the term clock) and give the quarterly volunteer a
zero-learning-curve home. Two screens, one per app:

| Screen | Mockup | Persona | App |
|---|---|---|---|
| People & Terms | 05 | Dana / Patricia (staff) | Committee Management — new top-level nav |
| Member Home ("My Committees") | 06 | Sarah (volunteer) | Committees (member) — **replaces Dashboard as default** |

## 2. Decisions (resolved 2026-07-07 with Ian)

1. **Schema: one column only.** `Membership.RenewalIntent` (Yes/No/Undecided,
   nullable) — migrated, codegen'd single-pass, drift 0. No SuccessionCandidate
   table: AI suggestions are generated on demand and never stored until a human
   acts on them.
2. **AI succession service ships this phase** — server-side, evidence-linked,
   riding the same MJ agent plumbing as minutes drafting.
3. **Member Home replaces the member app's Dashboard** as the default nav item.
4. **People & Terms** becomes a staff top-level nav item (same drill as
   Motions & Ballots).

## 3. Screen contracts

### 05 · People & Terms (staff)
- **Header:** timeline icon, "People & Terms", meta badges (N terms expire ≤90d,
  M committees without an active term — both from CommitteeHealthService).
  Actions: Export (defer) · "Start term renewal" (defer to Phase 4 wizard; button
  routes to the committee workspace roster for now).
- **90-day lens** (chip rail): one chip per committee with term state —
  `Lapsed` (error) / `<date> · Nd` (warning) / `Renewed ✓` (staged next term),
  each linking into the committee workspace.
- **Roster timeline (gantt)** for a selected committee (switcher): one row per
  member; bars = Term-anchored Memberships (Term.StartDate→EndDate) across a
  half-year-bucketed axis with a today line. Bar states: past / current /
  expiring (term ends ≤90d). Flags on rows: `not returning` (RenewalIntent=No),
  `at risk` (attendance < 50%), attendance % chip. ("term limit" is policy —
  not rendered in v1; no data.)
- **Vacancy pipeline** card for the selected committee's next cycle: one row per
  expiring seat — status derived, in precedence order:
  `Opening` (RenewalIntent=No) · `At risk` (attendance <50% or intent NULL and
  term ends ≤30d) · `Returning` (RenewalIntent=Yes) · `Awaiting answer`
  (intent NULL). Footer notes intent capture runs through Member Home.
- **AI succession suggestions** (assist grammar): on-demand generation for the
  selected committee's openings. Each card: person, evidence line with real
  numbers (attendance %, roles, cross-committee service — all computed
  server-side and handed to the LLM as facts), suggested fit. Verbs:
  "View profile" · "Not now" (dismisses client-side). "Add to pipeline" defers
  (no storage by design) — v1 verb is "Start membership" routing to the roster
  add-member flow.

### 06 · Member Home (member app default)
- **Header:** "My Committees" · "Welcome back, {first name} — here's what needs
  you before {next meeting day}." Meta: "N things need you."
- **Next meeting hero:** date block, title, when/where/join info, agenda-item +
  vote-expected counts. CTAs: **RSVP** (Attending → Attendance 'Expected',
  Can't make it → 'Absent'; upserts the pre-meeting Attendance row) ·
  Add to calendar (ICS download, client-generated) · Read the agenda (routes to
  meeting) · **Join** (VideoJoinURL; enabled ≤15 min before start).
- **Needs you** feed, one-tap each:
  - Overdue/open ActionItems assigned to me → "Mark complete" (Status write)
  - Open e-ballots where I'm a voting member who hasn't voted → inline
    Yes/No/Abstain (same seal semantics as screen 04)
  - PendingApproval minutes for my committees → "Read minutes" (opens Minutes
    Review, member lens)
  - Empty state: "You're all caught up… we'll email you if that changes."
- **Your committees:** one card per active membership — role badge, term end,
  my attendance % this term, chair name; **renewal-intent capture** when my
  term ends ≤120d: "Will you serve another term?" Yes/No/Undecided segmented
  buttons writing `Membership.RenewalIntent`.
- **Recent decisions I was part of:** last N motions where I have a Vote row —
  result + my vote.
- **Mobile:** single column ≤640px; touch-size CTAs; the mockup's 390px frame is
  the reference. No separate component — responsive CSS.

## 4. Services

- **`SuccessionService`** (committees-core, browser-safe):
  - `GetTermClock(committeeID?)`: gantt rows (member, bars with bucket
    positions), lens chips, pipeline seats — batched RunViews over
    Terms/Memberships/Roles/Attendance + health-service term hygiene. Pure
    assembly functions + injected `now`; vitest suite (bucket math, bar
    positioning, pipeline precedence, attendance rates).
  - `GetMemberHome(personID)`: next meeting, needs-you items, my committees
    with intent state, recent decisions — batched.
- **`SuccessionSuggestionService`** (CoreEntitiesServer) + resolver
  `SuggestSuccessors(committeeID)`: computes the evidence pack server-side
  (openings, per-candidate attendance/roles/service — deterministic SQL), hands
  facts to the LLM via AI Prompts (metadata-sync'd prompt, same pattern as
  committee-importer), returns suggestions with the evidence echoed back.
  AI proposes; nothing persists.

## 5. Nav & app config

- Staff DefaultNavItems: insert `People & Terms` (`fa-solid fa-timeline`,
  DriverClass `PeopleTermsComponent`) after Members. Baseline + live DB.
- Member DefaultNavItems: replace the Dashboard entry with `My Committees`
  (`fa-solid fa-user`, DriverClass `MemberHomeComponent`, isDefault) — old
  member dashboard component is superseded (delete after acceptance).

## 6. Non-goals

- Term-renewal wizard, nominations workflow, ballot-close ceremony,
  notification digests — Phase 4 (the "we'll email you" promise renders as copy
  only).
- Suggestion persistence / pipeline candidate records — deliberately none.
- `Committee.QuorumRule`, richer RSVP states — still v-next (RSVP maps onto
  existing Attendance statuses).
- Term-limit policy detection (no data).

## 7. Acceptance

1. SuccessionService vitest green (buckets, precedence, rates); harness suite
   stays green (metadata 23/23 with RenewalIntent registered).
2. People & Terms renders the demo Board: gantt with today line, lens chips
   match Command Center's term signals, pipeline derives correctly from
   RenewalIntent + attendance.
3. AI suggestions generate for a committee with openings, cite real evidence
   numbers, and survive the "no AI key" failure mode gracefully.
4. Member Home (as a member): RSVP writes Attendance, ballot vote writes Vote,
   intent buttons write RenewalIntent and reflect in People & Terms pipeline
   immediately; caught-up empty state; 390px pass.
5. Both themes, both screens; semantic tokens only.
6. Full build + 57+ unit tests + 43 harness checks green.

## 8. Build order

1. SuccessionService + tests
2. People & Terms page + staff nav (05)
3. SuccessionSuggestionService + resolver + prompt (AI cards)
4. Member Home + member nav swap (06) + mobile pass
5. Demo-data top-up (varied RenewalIntent answers, attendance spread) + visual pass
