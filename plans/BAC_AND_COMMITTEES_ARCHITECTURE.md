# BizApps Common & Committees: Architecture Deep Dive

**Last Updated:** March 11, 2026

---

## How BAC and Committees Relate

Committees is built **on top of** BizApps Common. BAC provides the foundational "who" and "where" layer (people, organizations, addresses, contacts, relationships), while Committees adds the governance layer (committees, meetings, memberships, voting, action items).

```
┌─────────────────────────────────────────────────────┐
│                  Committees App                      │
│   Committee ─ Meeting ─ Motion ─ Vote               │
│   Membership ─ Attendance ─ ActionItem              │
│   Term ─ AgendaItem ─ Artifact ─ Minute             │
│                                                     │
│         ┌──────────┐     ┌───────────────┐          │
│         │ 6 FKs to │     │ 1 FK to       │          │
│         │ Person   │     │ Organization  │          │
│         └────┬─────┘     └──────┬────────┘          │
├──────────────┼──────────────────┼───────────────────┤
│              ▼                  ▼                    │
│              BizApps Common (BAC)                    │
│   Person ─ Organization ─ Address ─ Relationship    │
│   ContactMethod ─ AddressLink                       │
│   + 4 Type/Lookup tables                            │
│                                                     │
│         ┌──────────┐     ┌───────────────┐          │
│         │ 1 FK to  │     │ 2 FKs to      │          │
│         │ User     │     │ Entity        │          │
│         └────┬─────┘     └──────┬────────┘          │
├──────────────┼──────────────────┼───────────────────┤
│              ▼                  ▼                    │
│              MJ Core (__mj)                          │
│   User ─ Entity ─ EntityField ─ ...                 │
└─────────────────────────────────────────────────────┘
```

The key insight: **Committees never manages its own people or organizations.** Every person reference (members, presenters, assignees, uploaders) points to `__mj_BizAppsCommon.Person`, and every org reference points to `__mj_BizAppsCommon.Organization`. This means:

- No duplicate contact data between apps
- BAC's address, contact method, and relationship infrastructure is automatically available for committee members
- A Person's `LinkedUserID` connects to MJ's auth system, giving committee members system logins
- Organization hierarchy in BAC supports parent company → subsidiary committee structures

---

## BizApps Common (BAC) — The Foundation Layer

### Schema: `__mj_BizAppsCommon` (10 tables)

BAC provides a **shared people/organization platform** that any business app can build on. It's the MJ equivalent of a CRM contact layer.

### Core Entities

#### Person
The central "who" entity. Individual people with rich profile data.

| Column | Type | Notes |
|--------|------|-------|
| ID | uniqueidentifier | PK |
| FirstName | nvarchar(100) | Required |
| LastName | nvarchar(100) | Required |
| MiddleName | nvarchar(100) | |
| Prefix | nvarchar(20) | Dr., Mr., Ms., Rev. |
| Suffix | nvarchar(20) | Jr., III, PhD, Esq. |
| PreferredName | nvarchar(100) | Nickname |
| Title | nvarchar(200) | Job title |
| Email | nvarchar(255) | Primary email |
| Phone | nvarchar(50) | Primary phone |
| DateOfBirth | date | |
| Gender | nvarchar(50) | |
| PhotoURL | nvarchar(1000) | |
| Bio | nvarchar(MAX) | |
| LinkedUserID | uniqueidentifier | FK to `__mj.User` — connects to MJ auth |
| Status | nvarchar(50) | Active / Inactive / Deceased |

**View-computed fields:** DisplayName, PrimaryAddress (full breakdown), PrimaryEmail, PrimaryPhone, CurrentOrganizationID/Name/JobTitle

#### Organization
Companies, associations, government bodies with hierarchy support.

| Column | Type | Notes |
|--------|------|-------|
| ID | uniqueidentifier | PK |
| Name | nvarchar(255) | Display name |
| LegalName | nvarchar(255) | |
| OrganizationTypeID | uniqueidentifier | FK to OrganizationType |
| ParentID | uniqueidentifier | Self-referencing FK (hierarchy) |
| Website | nvarchar(1000) | |
| LogoURL | nvarchar(1000) | |
| Description | nvarchar(MAX) | |
| Email / Phone | nvarchar | Primary contact |
| FoundedDate | date | |
| TaxID | nvarchar(50) | EIN |
| Status | nvarchar(50) | Active / Inactive / Dissolved |

**View-computed fields:** OrganizationType, Parent, RootParentID, PrimaryAddress, PrimaryEmail, PrimaryPhone, ActivePersonCount, ChildOrgCount

### Supporting Entities

#### Address + AddressLink (Polymorphic Address System)
Addresses are standalone records linked to **any entity** via `AddressLink` using MJ's polymorphic `EntityID + RecordID` pattern. A single address can be shared across multiple Person/Organization records.

- **Address**: Line1-3, City, StateProvince, PostalCode, Country, Latitude/Longitude
- **AddressLink**: AddressID + EntityID + RecordID + AddressTypeID + IsPrimary + Rank

#### ContactMethod
Additional contact info (beyond primary email/phone) for people OR organizations.

| Column | Type | Notes |
|--------|------|-------|
| PersonID | uniqueidentifier | FK to Person (XOR with OrganizationID) |
| OrganizationID | uniqueidentifier | FK to Organization (XOR with PersonID) |
| ContactTypeID | uniqueidentifier | FK to ContactType |
| Value | nvarchar(500) | The phone, email, URL, handle, etc. |
| Label | nvarchar(100) | e.g., "Work cell", "Personal Gmail" |
| IsPrimary | bit | |

**CHECK constraint:** Exactly one of PersonID or OrganizationID must be set (XOR).

#### Relationship
Typed, directional links between people and organizations.

| Column | Type | Notes |
|--------|------|-------|
| RelationshipTypeID | uniqueidentifier | FK to RelationshipType |
| FromPersonID / FromOrganizationID | uniqueidentifier | Source (XOR) |
| ToPersonID / ToOrganizationID | uniqueidentifier | Target (XOR) |
| Title | nvarchar(255) | e.g., "CEO", "Primary Contact" |
| StartDate / EndDate | date | |
| Status | nvarchar(50) | Active / Inactive / Ended |

Supports Person↔Person, Person↔Organization, and Organization↔Organization relationships.

### Lookup Tables

| Table | Seed Data | Key Fields |
|-------|-----------|------------|
| **OrganizationType** | Company, Non-Profit, Association, Government | Name, IconClass, DisplayRank, IsActive |
| **AddressType** | Home, Work, Mailing, Billing | Name, DefaultRank, IsActive |
| **ContactType** | Phone, Mobile, Email, LinkedIn, Website | Name, IconClass, DisplayRank, IsActive |
| **RelationshipType** | (configurable) | Name, Category (P2P/P2O/O2O), IsDirectional, ForwardLabel, ReverseLabel |

### Entity Names in MJ Metadata

All BAC entities use the `MJ.BizApps.Common:` prefix:
- `MJ.BizApps.Common: People`
- `MJ.BizApps.Common: Organizations`
- `MJ.BizApps.Common: Addresses`
- `MJ.BizApps.Common: Address Links`
- `MJ.BizApps.Common: Address Types`
- `MJ.BizApps.Common: Contact Methods`
- `MJ.BizApps.Common: Contact Types`
- `MJ.BizApps.Common: Organization Types`
- `MJ.BizApps.Common: Relationship Types`
- `MJ.BizApps.Common: Relationships`

### BAC Package Architecture

BAC ships as three npm packages in the `@mj-biz-apps` scope (separate repo: `github.com/MemberJunction/bizapps-common`):

| Package | Purpose |
|---------|---------|
| `@mj-biz-apps/common-entities` | Entity subclasses for the 10 BAC entities |
| `@mj-biz-apps/common-actions` | Action classes for BAC business logic |
| `@mj-biz-apps/common-server` | Server bootstrap — GraphQL resolvers + class registration manifest |

**No Angular components exist for BAC** — it relies on MJ's auto-generated CRUD forms.

### BAC Domain Action Packages (in MJ monorepo)

The MJ monorepo also includes 5 domain-specific action packages that build on BAC concepts:

| Package | Providers | Action Count |
|---------|-----------|--------------|
| `@memberjunction/actions-bizapps-accounting` | QuickBooks, Business Central | 8 |
| `@memberjunction/actions-bizapps-crm` | HubSpot | 22 |
| `@memberjunction/actions-bizapps-formbuilders` | Typeform, Google Forms, Jotform, SurveyMonkey | 30 |
| `@memberjunction/actions-bizapps-lms` | LearnWorlds | 19 |
| `@memberjunction/actions-bizapps-social` | Twitter, LinkedIn, Facebook, Instagram, TikTok, YouTube, HootSuite, Buffer | 65 |

**Total: 144 action classes** across 5 domain packages, all registered in ServerBootstrap's manifest.

---

## Committees — The Governance Layer

### Schema: `__mj_Committees` (14 tables)

### Structure Entities

#### Committee
The core entity. Supports hierarchy via self-referencing ParentCommitteeID.

| Column | Type | Notes |
|--------|------|-------|
| ID | uniqueidentifier | PK |
| Name | nvarchar(255) | Required |
| Description | nvarchar(MAX) | |
| TypeID | uniqueidentifier | FK to Type |
| **ParentCommitteeID** | uniqueidentifier | Self-referencing FK (subcommittees) |
| **OrganizationID** | uniqueidentifier | **FK to `__mj_BizAppsCommon.Organization`** |
| CharterDocumentURL | nvarchar(1000) | |
| MissionStatement | nvarchar(MAX) | |
| Status | nvarchar(50) | Active / Inactive / Pending / Dissolved |
| IsPublic | bit | Default 1 |
| FormationDate / DissolutionDate | date | |

**View fields:** Type, ParentCommittee, Organization, RootParentCommitteeID

#### Type (Committee Types)
| Seed Data | IsStandards | DefaultTermMonths |
|-----------|-------------|-------------------|
| Board of Directors | No | 12 |
| Standing Committee | No | 12 |
| Ad Hoc Committee | No | NULL |
| Workgroup | No | NULL |
| Standards Working Group | Yes | NULL |

#### Term
Defines service periods within committees.

| Column | Type | Notes |
|--------|------|-------|
| CommitteeID | uniqueidentifier | FK to Committee |
| Name | nvarchar(100) | e.g., "2026-2027 Term" |
| StartDate / EndDate | date | |
| Status | nvarchar(50) | Active / Upcoming / Completed |

### People Entities

#### Role (Committee Roles)
| Seed Data | IsOfficer | IsVotingRole | Sequence |
|-----------|-----------|--------------|----------|
| Chair | Yes | Yes | 10 |
| Vice Chair | Yes | Yes | 20 |
| Secretary | Yes | Yes | 30 |
| Member | No | Yes | 100 |
| Non-Voting Member | No | No | 110 |
| Liaison | No | No | 120 |
| Advisor | No | No | 130 |

#### Membership
The "who serves where as what and when" entity — the heart of committee governance.

| Column | Type | Notes |
|--------|------|-------|
| CommitteeID | uniqueidentifier | FK to Committee |
| **PersonID** | uniqueidentifier | **FK to `__mj_BizAppsCommon.Person`** |
| RoleID | uniqueidentifier | FK to Role |
| TermID | uniqueidentifier | FK to Term (nullable) |
| StartDate / EndDate | date | |
| Status | nvarchar(50) | Active / Pending / Ended / Suspended |
| EndReason | nvarchar(100) | |

### Operations Entities

#### Meeting
| Column | Type | Notes |
|--------|------|-------|
| CommitteeID | uniqueidentifier | FK to Committee |
| Title | nvarchar(255) | |
| StartDateTime / EndDateTime | datetimeoffset | Timezone-aware |
| TimeZone | nvarchar(100) | Default 'America/New_York' |
| LocationType | nvarchar(50) | Virtual / InPerson / Hybrid |
| LocationText | nvarchar(500) | Physical location |
| VideoProvider / VideoMeetingID / VideoJoinURL | nvarchar | Video conferencing |
| VideoRecordingURL / TranscriptURL | nvarchar | Post-meeting assets |
| Status | nvarchar(50) | Draft / Scheduled / InProgress / Completed / Cancelled / Postponed |
| CalendarEventID | nvarchar(500) | External calendar sync |

#### AgendaItem
Hierarchical agenda structure with presenter assignments.

| Column | Type | Notes |
|--------|------|-------|
| MeetingID | uniqueidentifier | FK to Meeting |
| ParentAgendaItemID | uniqueidentifier | Self-referencing FK (nested items) |
| Sequence | int | Display order |
| Title / Description | nvarchar | |
| **PresenterPersonID** | uniqueidentifier | **FK to `__mj_BizAppsCommon.Person`** |
| DurationMinutes | int | |
| ItemType | nvarchar(50) | Information / Discussion / Action / Vote / Report / Other |
| Status | nvarchar(50) | Pending / Discussed / Tabled / Completed / Skipped |

#### Attendance
| Column | Type | Notes |
|--------|------|-------|
| MeetingID | uniqueidentifier | FK to Meeting |
| **PersonID** | uniqueidentifier | **FK to `__mj_BizAppsCommon.Person`** |
| AttendanceStatus | nvarchar(50) | Expected / Present / Absent / Excused / Partial |
| JoinedAt / LeftAt | datetimeoffset | |

**UNIQUE constraint** on (MeetingID, PersonID)

### Governance Entities

#### Motion
Formal motions during meetings with vote tracking.

| Column | Type | Notes |
|--------|------|-------|
| MeetingID | uniqueidentifier | FK to Meeting |
| AgendaItemID | uniqueidentifier | FK to AgendaItem (nullable) |
| Sequence | int | |
| MovedByMembershipID | uniqueidentifier | FK to Membership |
| SecondedByMembershipID | uniqueidentifier | FK to Membership |
| Result | nvarchar(50) | Pending / Passed / Failed / Tabled / Withdrawn |
| YesCount / NoCount / AbstainCount | int | |

#### Vote
Individual vote records per motion.

| Column | Type | Notes |
|--------|------|-------|
| MotionID | uniqueidentifier | FK to Motion |
| MembershipID | uniqueidentifier | FK to Membership |
| VoteValue | nvarchar(20) | Yes / No / Abstain / Absent |

**UNIQUE constraint** on (MotionID, MembershipID)

### Outcomes Entities

#### ActionItem
Tasks assigned from meetings with full lifecycle tracking.

| Column | Type | Notes |
|--------|------|-------|
| CommitteeID | uniqueidentifier | FK to Committee |
| MeetingID | uniqueidentifier | FK to Meeting (nullable) |
| AgendaItemID | uniqueidentifier | FK to AgendaItem (nullable) |
| **AssignedToPersonID** | uniqueidentifier | **FK to `__mj_BizAppsCommon.Person`** (required) |
| **AssignedByPersonID** | uniqueidentifier | **FK to `__mj_BizAppsCommon.Person`** (nullable) |
| DueDate | date | |
| Priority | nvarchar(20) | Low / Medium / High / Critical |
| Status | nvarchar(50) | Open / InProgress / Blocked / Completed / Cancelled |
| CompletedAt | datetimeoffset | |

#### Artifact
Links to external documents — no proprietary storage, connects to existing providers.

| Column | Type | Notes |
|--------|------|-------|
| CommitteeID / MeetingID / AgendaItemID / ActionItemID | uniqueidentifier | Context FKs (all nullable) |
| ArtifactTypeID | uniqueidentifier | FK to ArtifactType |
| Provider | nvarchar(50) | GoogleDrive / SharePoint / Box / OneDrive / Dropbox / URL |
| ExternalID | nvarchar(500) | Provider's ID for the file |
| URL | nvarchar(2000) | Direct link |
| MimeType | nvarchar(100) | |
| FileSize | bigint | |
| **UploadedByPersonID** | uniqueidentifier | **FK to `__mj_BizAppsCommon.Person`** |

#### ArtifactType
| Seed Data | Icon |
|-----------|------|
| Document | fa-solid fa-file |
| Spreadsheet | fa-solid fa-file-excel |
| Presentation | fa-solid fa-file-powerpoint |
| Minutes | fa-solid fa-clipboard-check |
| Agenda | fa-solid fa-list-check |
| Recording | fa-solid fa-video |
| Transcript | fa-solid fa-closed-captioning |
| Image | fa-solid fa-image |
| Other | fa-solid fa-file-lines |

#### Minute
Extension entity for Minutes artifacts — 1:1 relationship with Artifact.

| Column | Type | Notes |
|--------|------|-------|
| ArtifactID | uniqueidentifier | FK to Artifact (UNIQUE — 1:1) |
| ApprovalStatus | nvarchar(50) | Draft / PendingApproval / Approved / Rejected |
| ApprovedAt | datetimeoffset | |
| ApprovedByMeetingID | uniqueidentifier | FK to Meeting ("approved at next meeting" pattern) |

---

## All Cross-Schema Foreign Keys

### Committees → BAC (7 FKs)

| Committees Entity | Field | BAC Entity |
|-------------------|-------|------------|
| **Committee** | OrganizationID | Organization |
| **Membership** | PersonID | Person |
| **AgendaItem** | PresenterPersonID | Person |
| **Attendance** | PersonID | Person |
| **ActionItem** | AssignedToPersonID | Person |
| **ActionItem** | AssignedByPersonID | Person |
| **Artifact** | UploadedByPersonID | Person |

### Committees → MJ Core (1 FK)

| Committees Entity | Field | MJ Entity |
|-------------------|-------|-----------|
| **ArtifactType** | ExtendedEntityID | Entity |

### BAC → MJ Core (2 FKs)

| BAC Entity | Field | MJ Entity |
|------------|-------|-----------|
| **Person** | LinkedUserID | User |
| **AddressLink** | EntityID | Entity |

**Total dependency chain:** Committees → BAC → MJ Core

---

## Generated Entity Classes

File: `committees/packages/GeneratedEntities/src/generated/entity_subclasses.ts`

This file contains **24 entity classes total** — 14 Committees + 10 BAC (since both schemas are in the same database):

### Committees Classes (prefix: `mjCommittees`)
| Class | Registered Name | Validation |
|-------|----------------|------------|
| `mjCommitteesTypeEntity` | Types | — |
| `mjCommitteesCommitteeEntity` | Committees | — |
| `mjCommitteesTermEntity` | Terms | — |
| `mjCommitteesRoleEntity` | Roles | — |
| `mjCommitteesMembershipEntity` | Memberships | — |
| `mjCommitteesMeetingEntity` | Meetings | — |
| `mjCommitteesAgendaItemEntity` | Agenda Items | — |
| `mjCommitteesAttendanceEntity` | Attendances | — |
| `mjCommitteesActionItemEntity` | Action Items | — |
| `mjCommitteesArtifactTypeEntity` | Artifact Types | — |
| `mjCommitteesArtifactEntity` | Artifacts | — |
| `mjCommitteesMinuteEntity` | Minutes | — |
| `mjCommitteesMotionEntity` | Motions | — |
| `mjCommitteesVoteEntity` | Votes | — |

### BAC Classes (prefix: `mjBizAppsCommon`)
| Class | Registered Name | Validation |
|-------|----------------|------------|
| `mjBizAppsCommonPersonEntity` | MJ.BizApps.Common: People | — |
| `mjBizAppsCommonOrganizationEntity` | MJ.BizApps.Common: Organizations | — |
| `mjBizAppsCommonAddressEntity` | MJ.BizApps.Common: Addresses | — |
| `mjBizAppsCommonAddressLinkEntity` | MJ.BizApps.Common: Address Links | — |
| `mjBizAppsCommonAddressTypeEntity` | MJ.BizApps.Common: Address Types | — |
| `mjBizAppsCommonContactMethodEntity` | MJ.BizApps.Common: Contact Methods | XOR: PersonID or OrganizationID |
| `mjBizAppsCommonContactTypeEntity` | MJ.BizApps.Common: Contact Types | — |
| `mjBizAppsCommonOrganizationTypeEntity` | MJ.BizApps.Common: Organization Types | — |
| `mjBizAppsCommonRelationshipTypeEntity` | MJ.BizApps.Common: Relationship Types | — |
| `mjBizAppsCommonRelationshipEntity` | MJ.BizApps.Common: Relationships | XOR: From Person/Org, To Person/Org |

All classes include Zod schemas with union types for CHECK constraint values, strongly-typed getters/setters, and view-derived computed fields.

---

## Implementation Status vs. Roadmap

### Phase 1A: Core Foundation — **In Progress**

| Item | Status |
|------|--------|
| 14-table schema in DB | Done |
| CodeGen (entities, fields, permissions, views, stored procs) | Done |
| Seed data (5 types, 7 roles, 9 artifact types) | Done |
| Generated TypeScript entity classes | Done (with CodeGen validator duplication bug) |
| MJAPI serving 309 entities including all 14 Committees | Done |
| MJExplorer showing all 14 entities | Done |
| Custom Application registration (icon, nav items, color) | Not started |
| Custom Angular UI components | Not started |
| Committee/Meeting/Membership CRUD workflows | Not started (auto-generated forms only) |
| Document provider linking (Drive/SharePoint/Box) | Not started |

### Phase 1B: Table Stakes — Planned

- Comment/Discussion threading (new Comment entity needed)
- Notification system (MJ NotificationEngine)
- Calendar integration (Google/Outlook)
- Video conferencing (Zoom/Teams/Meet)
- Basic reporting (attendance, action items)
- Mobile-responsive design

### Phase 2: Enhanced Core & Intelligence — Planned

- AI-powered meeting minutes from transcripts
- Board book summarization
- Smart agenda suggestions
- Engagement scoring
- Committee health dashboards
- Member directory with skills/expertise
- Onboarding workflows

### Phase 3: Association Excellence — Planned

- Election management (nomination → ballot → voting → results)
- Standards development ballots (comment periods, resolution, recirculation)
- Succession planning
- Committee charter management
- Conflict of interest tracking
- Deep AMS integration

### Phase 4: Enterprise & Vision — Planned

- Multi-entity (chapter/subsidiary) support
- No-code workflow builder
- Live meeting mode with real-time collaboration
- Predictive analytics
- Public REST API, Webhooks, Zapier

---

## UX Mockups (10 User Journeys)

All mockups live in `committees/plans/mockups/` with 3 design options each (Minimal, Functional, Modern):

| # | Journey | Key Capabilities |
|---|---------|-----------------|
| 01 | Committee Setup | Wizard/card-based creation, charter upload, member assignment with roles |
| 02 | Meeting Scheduling | <90 second scheduling, calendar integration, video link generation, RSVP |
| 03 | Agenda Building | Hierarchical items, drag-and-drop, time allocations, presenter assignment, templates |
| 04 | Meeting Execution | Live attendance/quorum, agenda navigation with timers, notes, motions, voting, minutes export |
| 05 | Action Tracking | Cross-committee filtering, Kanban/list/timeline views, progress tracking |
| 06 | Elections | Full lifecycle: nomination → ballot config → voting → results |
| 07 | Standards Ballot | Document versioning, inline commenting, comment resolution, approval voting, recirculation |
| 08 | Committee Dashboard | Health scores, engagement metrics, action item completion, attendance trends |
| 09 | Document Collaboration | Provider-aware browsing, preview, inline comments, version history |
| 10 | Member Profile | All committees/roles, consolidated action items, personal calendar, engagement score |

---

## Known Issues

1. **CodeGen validator duplication bug** — CHECK constraints with identical descriptions generate triplicate validation methods and calls. Affects `ContactMethod` (PersonID/OrganizationID XOR) and `Relationship` (From/To XOR). Must be manually de-duped after each `mj codegen` run until the bug is fixed.

2. **BAC package version gap** — `@mj-biz-apps/common-*` packages are at 5.4.0 while MJ core is at 5.10.1. No known compatibility issues, but version should be aligned.

3. **Auto-generated application** — The `__mj_Committees` application was auto-created by CodeGen with generic metadata (no icon, no color, no nav items). Needs to be upgraded to a proper application with custom UI.

4. **No Angular components** — Neither BAC nor Committees has custom Angular components. Both rely on MJ's auto-generated CRUD forms.
