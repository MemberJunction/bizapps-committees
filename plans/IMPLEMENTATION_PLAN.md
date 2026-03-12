# Committees App: Implementation Plan

**Version:** 1.0
**Date:** March 11, 2026
**Architecture:** OpenApp layer on BizApps Common (BAC) on MemberJunction

---

## Architecture Principle

Every piece of this app follows one rule: **Committees is a layer, not a monolith.**

```
Committees OpenApp (this repo)
    ├── committees-core          → Business logic, services, actions
    ├── committees-server        → GraphQL resolvers, server bootstrap
    ├── ng-committees            → Angular components, dashboards
    ├── GeneratedEntities        → CodeGen entity classes (BAC + Committees)
    └── GeneratedActions         → CodeGen action classes

Installs into ↓

BAC OpenApp (@mj-biz-apps/common-*)
    ├── common-entities          → Person, Organization, Address, etc.
    ├── common-server            → GraphQL resolvers for BAC entities
    └── (no Angular yet)

Runs on ↓

MemberJunction Core
    ├── Auth, RBAC, Notifications, AI Framework
    ├── Record Changes (version control)
    ├── Scheduled Jobs, Actions, Class Factory
    └── Angular Explorer shell + generated forms
```

**What this means in practice:**
- Committees never creates its own Person/Org tables — always FK to BAC
- Committees never builds its own auth — uses MJ's auth providers
- Committees never builds its own notification system — uses MJ NotificationEngine
- Committees never stores documents — links to external providers via Artifact
- Committees registers as an OpenApp via `mj-app.json` manifest for install/upgrade

---

## Current State (as of March 11, 2026)

| Item | Status |
|------|--------|
| BAC schema (10 tables in `__mj_BizAppsCommon`) | Done |
| Committees schema (14 tables in `__mj_Committees`) | Done |
| CodeGen metadata (entities, fields, permissions, views, stored procs) | Done |
| Seed data (5 types, 7 roles, 9 artifact types) | Done |
| GeneratedEntities builds (24 entity classes: 14 Committees + 10 BAC) | Done |
| GeneratedActions builds | Done |
| MJAPI serving all entities | Done |
| MJExplorer showing all 14 Committees entities with auto-generated forms | Done |
| `committees-core` package (business logic) | Not started |
| `committees-server` package (resolvers + bootstrap) | Not started |
| `ng-committees` package (Angular UI) | Not started |
| Application registration (icon, nav items, color) | Not started |
| OpenApp manifest (`mj-app.json`) | Not started |

---

## Phase 1A: Core Foundation

**Goal:** Committee CRUD workflows that actually work, not just auto-generated forms. A chair should be able to create a committee, add members, schedule a meeting, and track action items without leaving the app.

### 1A.1 — Package Scaffolding

Create the package structure that mirrors BAC's architecture:

```
packages/
├── committees-core/              # Business logic (no Angular dependency)
│   ├── src/
│   │   ├── services/
│   │   │   ├── CommitteeService.ts
│   │   │   ├── MeetingService.ts
│   │   │   ├── MembershipService.ts
│   │   │   └── ActionItemService.ts
│   │   ├── actions/
│   │   │   ├── CreateCommitteeAction.ts
│   │   │   ├── ScheduleMeetingAction.ts
│   │   │   └── AssignActionItemAction.ts
│   │   └── index.ts
│   ├── package.json
│   └── tsconfig.json
│
├── committees-server/            # Server-side bootstrap
│   ├── src/
│   │   ├── generated/            # CodeGen GraphQL resolvers
│   │   ├── resolvers/            # Custom resolvers (beyond CRUD)
│   │   └── index.ts              # LoadCommitteesServer() + RESOLVER_PATHS
│   ├── package.json
│   └── tsconfig.json
│
├── ng-committees/                # Angular UI components
│   ├── src/lib/
│   │   ├── committee-dashboard/
│   │   ├── committee-detail/
│   │   ├── meeting-planner/
│   │   ├── action-item-tracker/
│   │   ├── membership-manager/
│   │   └── committees.module.ts
│   ├── package.json
│   └── tsconfig.json
│
├── GeneratedEntities/            # Already exists
└── GeneratedActions/             # Already exists
```

**Why this mirrors BAC:** BAC has `common-entities`, `common-actions`, `common-server`. Committees will have `committees-core` (entities+logic), `committees-server` (resolvers+bootstrap), and `ng-committees` (UI). Same pattern, easy for anyone who knows one to understand the other.

### 1A.2 — Application Registration

Update the auto-generated `__mj_Committees` application in the database:

```sql
UPDATE __mj.Application
SET Name = 'Committees',
    Description = 'Committee governance platform for managing memberships, meetings, agendas, voting, action items, and documents.',
    Icon = 'fa-solid fa-users-rectangle',
    Color = '#2196F3',
    DefaultForNewUser = 0,
    DefaultNavItems = '[
        {"Label": "Dashboard", "Icon": "fa-solid fa-gauge", "ResourceType": "Custom", "DriverClass": "CommitteeDashboardComponent", "isDefault": true},
        {"Label": "Committees", "Icon": "fa-solid fa-users-rectangle", "ResourceType": "Custom", "DriverClass": "CommitteeListComponent"},
        {"Label": "Meetings", "Icon": "fa-solid fa-calendar-check", "ResourceType": "Custom", "DriverClass": "MeetingListComponent"},
        {"Label": "Action Items", "Icon": "fa-solid fa-clipboard-list", "ResourceType": "Custom", "DriverClass": "ActionItemTrackerComponent"},
        {"Label": "Documents", "Icon": "fa-solid fa-folder-open", "ResourceType": "Custom", "DriverClass": "DocumentBrowserComponent"}
    ]'
WHERE Name = '__mj_Committees';
```

### 1A.3 — Committee Management UI

**Components:**

| Component | What It Does |
|-----------|-------------|
| `CommitteeListComponent` | Grid/card view of all committees, filterable by type/status. Create new committee button. |
| `CommitteeDetailComponent` | Single committee view with tabs: Overview, Members, Meetings, Action Items, Documents |
| `CommitteeFormComponent` | Create/edit committee. Type selector, org lookup (BAC Organization), parent committee hierarchy picker, charter upload, mission statement. |

**Key interactions with BAC:**
- Organization field → dropdown/search against `MJ.BizApps.Common: Organizations`
- All person references throughout → search against `MJ.BizApps.Common: People`

### 1A.4 — Membership Management

**Components:**

| Component | What It Does |
|-----------|-------------|
| `MembershipManagerComponent` | Add/remove/edit members for a committee. Shows current roster with roles and term info. |
| `MembershipHistoryComponent` | Full history: who served, when, in what role, across which terms. |
| `PersonPickerComponent` | Shared component: search BAC People by name/email, show photo + title + org. Reused everywhere a person is referenced. |

**Business logic (`MembershipService`):**
- Validate: can't add same person to same committee with same role in same term
- Auto-set EndDate when status changes to Ended
- Check: committee must have at least one Chair
- Term expiration awareness: flag memberships where term has ended but status is still Active

### 1A.5 — Meeting Lifecycle

**Components:**

| Component | What It Does |
|-----------|-------------|
| `MeetingListComponent` | Upcoming/past meetings for a committee or across all committees. Calendar and list views. |
| `MeetingDetailComponent` | Single meeting: agenda, attendance, notes, motions, action items — all in one view. |
| `MeetingSchedulerComponent` | Create meeting: title, date/time with timezone, location type (Virtual/InPerson/Hybrid), video link, auto-populate attendees from active membership. |
| `AgendaBuilderComponent` | Hierarchical agenda editor: add/reorder/nest items, assign presenters (BAC Person), set duration, attach documents. Drag-and-drop. |
| `AttendanceTrackerComponent` | Check off who's present. Auto-calculate quorum based on voting members. Show Expected/Present/Absent/Excused. |

**Business logic (`MeetingService`):**
- Auto-create Attendance records for all active committee members when meeting is created (status: Expected)
- Quorum calculation: count of Present voting members vs. total voting members
- Meeting status state machine: Draft → Scheduled → InProgress → Completed / Cancelled / Postponed

### 1A.6 — Action Item Tracking

**Components:**

| Component | What It Does |
|-----------|-------------|
| `ActionItemTrackerComponent` | Cross-committee view of all action items. Filter by status, committee, assignee, priority, due date. |
| `ActionItemFormComponent` | Create/edit: title, description, assign to (BAC Person), assigned by (BAC Person), due date, priority, link to meeting/agenda item. |
| `ActionItemInlineComponent` | Quick-create during meeting execution — minimal form that captures title, assignee, due date. |

**Business logic (`ActionItemService`):**
- Status lifecycle: Open → InProgress → Blocked → Completed / Cancelled
- Auto-set CompletedAt when status changes to Completed
- Overdue detection: items past DueDate with status Open or InProgress

### 1A.7 — Voting & Motions (Basic)

**Components:**

| Component | What It Does |
|-----------|-------------|
| `MotionRecorderComponent` | During meeting: record motion text, who moved (from membership), who seconded. |
| `VotingComponent` | Roll-call vote: iterate through voting members, record Yes/No/Abstain/Absent. Auto-tally. |
| `VotingHistoryComponent` | View all motions/votes for a meeting, or all votes by a specific member across committees. |

**Business logic:**
- Only voting members (Role.IsVotingRole = true) are eligible
- Auto-calculate Result: Passed if Yes > No (simple majority by default)
- YesCount/NoCount/AbstainCount auto-populated from individual Vote records

### 1A.8 — Document Linking (Basic)

**Components:**

| Component | What It Does |
|-----------|-------------|
| `ArtifactListComponent` | Documents for a committee/meeting/agenda item. Shows provider icon, type icon, file size. |
| `ArtifactFormComponent` | Add document: paste URL, select provider, select type, optionally link to committee/meeting/agenda item/action item. |

**No provider API integration yet** — Phase 1A is URL-based linking only. Users paste URLs from their existing cloud storage. Provider-specific browsing comes in Phase 1B.

### 1A.9 — OpenApp Manifest

Create `mj-app.json` at repo root:

```json
{
  "name": "committees",
  "displayName": "Committees",
  "version": "1.0.0",
  "description": "Committee governance platform for managing memberships, meetings, agendas, voting, action items, and documents.",
  "author": "MemberJunction",
  "license": "ISC",
  "dependencies": {
    "bizapps-common": ">=1.0.0"
  },
  "schemas": ["__mj_Committees"],
  "migrations": "migrations/",
  "metadata": "metadata/",
  "packages": {
    "server": "packages/committees-server",
    "entities": "packages/GeneratedEntities",
    "actions": "packages/GeneratedActions",
    "angular": "packages/ng-committees"
  }
}
```

### Phase 1A Deliverable

A working committee management app where a user can:
1. Create a committee with type, org, charter, mission
2. Add members from BAC People with roles and terms
3. Schedule a meeting with agenda items
4. Run a meeting: take attendance, work through agenda, record motions and votes
5. Create action items during or after a meeting
6. Link documents to committees/meetings
7. View their personal dashboard: my committees, my action items, upcoming meetings

---

## Phase 1B: Table Stakes

**Goal:** Features that every competitor already has. Without these, we can't go to market.

### 1B.1 — Notifications (MJ NotificationEngine)

| Trigger | Notification | Channel |
|---------|-------------|---------|
| Meeting created/updated | "New meeting scheduled: {title} on {date}" | Email + In-app |
| 7 days before meeting | "Reminder: {title} in 7 days" | Email |
| 1 day before meeting | "Tomorrow: {title} at {time}" | Email + In-app |
| Action item assigned | "{assigner} assigned you: {title} (due {date})" | Email + In-app |
| Action item overdue | "Overdue: {title} was due {date}" | Email |
| Term expiring (30 days) | "Your term on {committee} expires {date}" | Email |
| Minutes pending approval | "Minutes from {meeting} ready for review" | Email |

**Implementation:** Create notification templates as MJ Notification entities. Scheduled job checks for triggers. Uses MJ's existing email infrastructure (SendGrid).

### 1B.2 — Calendar Integration

- **Google Calendar:** Create events via Google Calendar API. Include video link, agenda summary, attendee list.
- **Outlook/Exchange:** Create events via Microsoft Graph API.
- Bidirectional: when meeting is updated in Committees app, calendar event updates.
- Store `CalendarEventID` on Meeting entity (column already exists).

### 1B.3 — Video Conferencing Links

- **Zoom:** Create meeting via Zoom API, store join URL on Meeting entity.
- **Microsoft Teams:** Create online meeting via Graph API.
- **Google Meet:** Create via Calendar API (Meet link auto-generated).
- `VideoProvider`, `VideoMeetingID`, `VideoJoinURL` columns already exist on Meeting.

### 1B.4 — Document Provider Browsing

Upgrade from "paste URL" to actual provider integration:

- **Google Drive:** Browse folders, select files via Google Picker API
- **SharePoint/OneDrive:** Browse via Microsoft Graph API
- **Box:** Browse via Box UI Elements
- **Dropbox:** Browse via Dropbox Chooser

Store `Provider`, `ExternalID`, `URL`, `MimeType`, `FileSize` on Artifact (columns already exist).

### 1B.5 — Mobile Responsive

- All Angular components must work on tablet and phone
- Priority: meeting attendance, action item status updates, document viewing
- Touch-optimized: larger tap targets, swipe gestures for action items
- Offline: cache current meeting agenda and documents for in-meeting use without connectivity

### 1B.6 — Basic Reporting

| Report | Who Uses It | What It Shows |
|--------|------------|---------------|
| Attendance Report | Chair, Admin | Per-meeting and aggregate attendance rates by member |
| Action Item Dashboard | Chair, Member | Open/overdue/completed counts, aging chart, by committee |
| Meeting Frequency | Admin | Meetings per committee per month, gap detection |
| Member Engagement | Admin | Composite: attendance + voting + action completion |

### Phase 1B Deliverable

A competitive MVP. Users get notifications, calendar sync, video links, provider-aware document browsing, mobile access, and basic reporting. This is the minimum to charge $199/month.

---

## Phase 2: Intelligence Layer

**Goal:** AI-powered features that create the competitive moat. This is what Boardable, BoardEffect, and Diligent don't have.

### 2.1 — AI Meeting Minutes Generation

**Input:** Meeting transcript (from Zoom/Teams/Meet recording) or structured notes from agenda items.

**AI Pipeline:**
1. Upload transcript → link as Artifact (type: Transcript)
2. AI agent processes transcript against structured agenda
3. Extracts per-agenda-item: summary, decisions, action items, motions
4. Generates draft Minute record linked to Artifact
5. Secretary reviews, edits, approves

**MJ Integration:** Uses MJ AI Framework with AI Prompts. Create prompt templates:
- `Committees: Extract Minutes from Transcript`
- `Committees: Summarize Agenda Item Discussion`
- `Committees: Extract Action Items from Discussion`

**Time saved:** 2-4 hours per meeting → 15 minutes of review.

### 2.2 — AI Proposal Filtering & Scoring

**The workflow:**
1. Proposals submitted via structured form (or email → AI extraction)
2. AI agent scores against configurable criteria:
   - Strategic alignment with committee charter/mission
   - Resource requirements vs. available budget
   - Overlap/conflict with existing proposals or past decisions
   - Proposer track record and qualifications
3. AI generates summary brief (not raw 50-page document)
4. Ranked list presented to committee with AI rationale
5. Committee reviews AI-filtered list, not the raw firehose

**New entities needed:**
- `Proposal` — title, description, submitter (BAC Person), committee, status, AI score
- `ProposalCriteria` — configurable scoring rubric per committee
- `ProposalReview` — committee member's assessment of a proposal

**MJ Integration:** MJ Actions for intake/scoring. AI Prompts for summarization. Scheduled job for batch processing.

### 2.3 — Smart Agenda Suggestions

AI agent analyzes and suggests agenda items based on:
- Overdue action items ("4 items from last meeting still open")
- Upcoming term expirations ("3 member terms expire next month")
- Time since last discussion of recurring topics ("Budget hasn't been reviewed in 3 meetings")
- New proposals awaiting review
- Minutes pending approval from previous meeting
- Standing agenda items from committee charter

### 2.4 — Committee Health Dashboard

| Metric | What It Measures | Why It Matters |
|--------|-----------------|----------------|
| Meeting Cadence | Meetings per month vs. charter requirement | Committees that stop meeting are dying |
| Attendance Rate | % of members attending | Low attendance = disengagement |
| Quorum Success | % of meetings achieving quorum | Can't make decisions without quorum |
| Action Completion | % of action items completed on time | Accountability indicator |
| Voting Participation | % of eligible members voting | Governance health |
| Engagement Score | Weighted composite of above | Single health number per committee |

**AI Enhancement:** Predictive alerts — "Committee X engagement has declined 20% over 3 months. Recommend: check-in with Chair."

### 2.5 — Member Directory & Profiles

- Search across all BAC People who are committee members
- View: all committees served on (current + historical), roles, terms
- Skills/expertise tags (new field on Membership or Person extension)
- Engagement score per person
- Contact info pulled from BAC (email, phone, address)

### 2.6 — Onboarding Workflows

When a new member is added to a committee:
1. Welcome notification with committee overview
2. Link to charter document
3. List of current members with roles
4. Upcoming meeting schedule
5. Recent meeting minutes (last 3)
6. Pending action items for context
7. Contact info for Chair and Secretary

**Implementation:** MJ Action triggered by Membership create event.

### Phase 2 Deliverable

The "wow" features. AI minutes generation alone is worth the subscription. Proposal filtering addresses the association-specific workflow that no competitor touches. Health dashboards give administrators visibility they've never had.

---

## Phase 3: Association Excellence

**Goal:** Features specific to professional associations and standards bodies that make us best-in-class for the target market.

### 3.1 — Election Management

**New entities:**
- `Election` — committee, positions, timeline, voting method
- `Nomination` — candidate (BAC Person), position, nominator, status
- `Ballot` — election, voter (Membership), rankings/choices
- `ElectionResult` — position, winner, vote counts

**Workflow:**
1. Admin creates election for committee positions
2. Nomination period opens (self-nominate or nominate others)
3. Candidates submit profiles/statements
4. Ballot configured (single choice, ranked choice, approval voting)
5. Voting period with integrity controls
6. Results calculated and announced
7. Automatic term transitions for winners

### 3.2 — Standards Development Balloting

**New entities:**
- `StandardsBallot` — document, committee, stage (CD/DIS/FDIS), threshold
- `BallotComment` — commenter, category (technical/editorial/general), disposition
- `CommentResolution` — response, status (accepted/rejected/modified)

**Workflow (mirrors ISO/ANSI process):**
1. Working group prepares draft
2. Chair creates ballot with comment period (e.g., 60 days)
3. Members submit comments with line-by-line annotations
4. Comment resolution: accept, reject, or modify each
5. Revised draft recirculated if substantial changes
6. Approval vote with configurable threshold (2/3 P-member, max 1/4 negative)

### 3.3 — Charter Management

- Charter templates per committee type
- Version-controlled charter documents
- Annual review scheduling with reminders
- Approval workflow (draft → review → approved by parent committee/board)

### 3.4 — Conflict of Interest

- Annual COI disclosure forms
- Mid-cycle updates when new conflicts arise
- Per-meeting recusal tracking (linked to agenda items where member recuses)
- COI register viewable by authorized administrators

### 3.5 — Succession Planning

- Leadership pipeline visualization: Member → Officer → Vice Chair → Chair
- Engagement-based candidate identification
- Mentorship program tracking
- Term staggering recommendations to avoid mass turnover

### 3.6 — Deep AMS Integration

- Bidirectional member sync (Fonteva, Nimble AMS, YourMembership, MemberClicks)
- Committee participation reflected in AMS engagement scores
- Event integration (committee meetings appear in AMS event calendar)

### Phase 3 Deliverable

Best-in-class for associations and standards bodies. This is where we beat Diligent and BoardEffect in the association segment.

---

## Phase 4: Enterprise & Ecosystem

**Goal:** Platform play — make Committees extensible and embeddable.

### 4.1 — Multi-Entity Support
- Chapter/subsidiary management (org hierarchy from BAC)
- Rolled-up reporting across all orgs
- Shared templates and policies across entities

### 4.2 — Workflow Builder
- No-code workflow configuration for custom approval chains
- Conditional routing based on committee type, member count, etc.
- Custom triggers and actions via MJ Actions framework

### 4.3 — Live Meeting Mode
- Real-time collaborative note-taking
- Live quorum indicator
- In-meeting voting with instant results
- Timer management for agenda items
- Presenter mode with screen sharing integration

### 4.4 — Public API & Webhooks
- REST API for external integrations
- Webhooks for real-time event notifications
- Zapier/Make connector for no-code automation

### 4.5 — Analytics & Predictions
- Predictive engagement modeling
- Committee effectiveness benchmarking
- Automated governance risk scoring
- Board-level analytics across all committees

---

## Technical Decisions

### What We Build vs. What MJ Provides

| Capability | Source | Notes |
|------------|--------|-------|
| Authentication | MJ Core | Azure AD, Okta, Google via MJ auth providers |
| RBAC | MJ Core | Entity permissions, row-level security |
| Notifications | MJ Core | NotificationEngine + SendGrid |
| Audit Logging | MJ Core | Record Changes (built-in version control) |
| AI Framework | MJ Core | AI Prompts, AI Models, multi-LLM |
| Scheduled Jobs | MJ Core | Reminder jobs, overdue detection, term expiration |
| Encryption | MJ Core | Field-level encryption (AES-256-GCM) |
| GraphQL API | MJ Core | TypeGraphQL resolvers via CodeGen |
| Entity CRUD | MJ Core + CodeGen | Auto-generated, custom forms override |
| Person/Org data | BAC | Never duplicate, always FK |
| Committee logic | **Committees** | Services, actions, custom resolvers |
| Committee UI | **Committees** | Angular components, dashboards |
| Proposal filtering | **Committees** | AI actions + new entities |
| Standards balloting | **Committees** | New entities + workflows |

### Package Dependencies

```
ng-committees
  └── @memberjunction/ng-base-forms
  └── @memberjunction/ng-explorer-core
  └── committees-core

committees-server
  └── committees-core
  └── GeneratedEntities
  └── GeneratedActions
  └── @memberjunction/server

committees-core
  └── @memberjunction/core
  └── @memberjunction/ai-prompts (Phase 2)
  └── @mj-biz-apps/common-entities
```

### Database Schema Evolution

| Phase | New Tables | Modified Tables |
|-------|-----------|----------------|
| 1A | None (14 tables exist) | Application (update metadata) |
| 1B | NotificationTemplate (or use MJ's) | None |
| 2 | Proposal, ProposalCriteria, ProposalReview | Committee (add health score fields?) |
| 3 | Election, Nomination, Ballot, ElectionResult, StandardsBallot, BallotComment, CommentResolution, Charter, ConflictOfInterest | Membership (add skills/expertise?) |
| 4 | WorkflowConfig, WorkflowStep | None |

---

## Immediate Next Steps

1. **Scaffold `committees-core` package** — CommitteeService, MeetingService, MembershipService, ActionItemService
2. **Scaffold `committees-server` package** — LoadCommitteesServer(), RESOLVER_PATHS, wire into MJAPI
3. **Scaffold `ng-committees` package** — Module, basic components
4. **Update Application record** — name, icon, color, nav items
5. **Build CommitteeListComponent** — first real UI component
6. **Build PersonPickerComponent** — shared BAC Person search, reused everywhere
7. **Build MeetingSchedulerComponent** — the highest-friction workflow to solve first
