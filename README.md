# Committees App

A unified governance platform for managing committees, memberships, meetings, and action tracking. Built as an [OpenApp](https://github.com/MemberJunction/MJ) on the MemberJunction platform, layered on top of [BizApps Common (BAC)](https://github.com/MemberJunction/MJ) for shared People and Organization data.

## The Problem

Committee operations are fragmented across disconnected tools — spreadsheets for rosters, email threads for coordination, shared drives for documents, and calendar apps that don't sync with membership data. This leads to:

- **Administrative overhead**: Chairs spend 3+ hours per meeting on logistics instead of governance
- **Scattered data**: No single source of truth across a dozen different tools
- **Volunteer burnout**: Admin burden exhausts volunteers who have day jobs
- **Institutional knowledge loss**: Decisions, rationale, and history disappear when people rotate off
- **No intelligence**: Existing solutions offer zero AI capabilities for minutes, insights, or health monitoring

## What This App Does

### Core Features (Phase 1)

| Capability | Description |
|---|---|
| **Dashboard** | At-a-glance overview with summary cards, upcoming meetings, action items, and recent activity |
| **Committee Management** | Browse, search, and filter committees by status with member counts and organization info |
| **Meeting Tracking** | Upcoming and past meetings with date blocks, location types (Virtual/InPerson/Hybrid), and status |
| **Action Item Tracker** | Track tasks across all committees with priority levels, assignees, due dates, and overdue detection |
| **Document Browser** | Browse committee artifacts and files with type filtering and search |
| **Membership Management** | Track who serves, their roles, term dates, and historical membership |
| **Motions & Voting** | Record formal motions, individual votes, and results |
| **Document Linking** | Connect to Google Drive, SharePoint, OneDrive, Box, Dropbox — no migration needed |

### AI Features (Phase 2 — In Progress)

| Capability | Description |
|---|---|
| **AI Meeting Minutes** | Upload a transcript, AI extracts structured minutes with summaries, decisions, action items, and motions. Reduces 2-4 hours of manual work to 15 minutes of review |
| **Smart Agenda Suggestions** | AI flags overdue action items, expiring terms, recurring topics, and pending proposals to build better agendas |
| **Proposal Filtering & Scoring** | AI scores proposals against configurable criteria, detects conflicts, and generates executive summaries |
| **Committee Health Dashboard** | Composite health scoring (attendance, quorum, action completion, engagement) with predictive alerts |
| **Member Engagement Profiles** | Cross-committee search with engagement scores, skills, and committee history |
| **Onboarding Workflows** | Automated welcome sequences with document packages for new committee members |

## Form chrome

Committee, Meeting, Term, and Motion forms use MJ's **left-nav** layout. First-class sections:

- **Committee** — Terms, Meetings, child Committees. Artifacts and comments sit in More. Ballots are None (they belong on the Motion).
- **Meeting** — Agenda, Attendance, Minutes. Motions, artifacts, and comments sit in More. Minutes approved *by* this meeting (`ApprovedByMeetingID`) are None — that is the other end of the Minutes join.
- **Term** — Memberships.
- **Motion** — Votes and Ballots.

## Schema Overview

All tables live in the `Committees` SQL schema (14 tables):

**Structure** -- Type, Committee, Term
**People** -- Role, Membership
**Operations** -- Meeting, AgendaItem, Attendance
**Governance** -- Motion, Vote
**Outcomes** -- ActionItem, Artifact, ArtifactType, Minute

See [plans/committees-design.md](plans/committees-design.md) for the full design document with ERDs, sequence diagrams, and state machines.

## Prerequisites

- **MemberJunction** v4.x or higher (this is an MJ OpenApp)
- **Node.js** 22+
- **SQL Server** 2019+ or Azure SQL
- A configured MJ environment with database access

## Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Environment

Copy or edit `.env` with your database connection settings. See MemberJunction docs for required environment variables (DB_HOST, DB_DATABASE, DB_USERNAME, DB_PASSWORD, auth provider settings).

### 3. Run Migrations

```bash
npm run mj:migrate
```

This creates the `Committees` schema and all 14 tables.

### 4. Sync Metadata

```bash
npx mj-sync push --dir ./metadata
```

This loads seed data for committee types, roles, and artifact types.

### 5. Run Code Generation

```bash
npm run mj:codegen
```

Generates TypeScript entity classes, GraphQL resolvers, and Angular components.

### 6. Build & Run

```bash
npm run build
npm start
```

## Architecture

```
Committees OpenApp (this repo)                    @mj-biz-apps/committees-*
    ├── Angular/             → committees-ng       (dashboard components, 5 tabs)
    ├── Entities/            → committees-entities  (CodeGen entity classes)
    ├── Actions/             → committees-actions   (CodeGen action classes)
    ├── Core/                → committees-core      (business logic, AI agent)
    └── Server/              → committees-server    (bootstrap, resolvers)

Installs into ↓

BAC OpenApp (@mj-biz-apps/common-*)
    ├── Person, Organization, Address, etc.
    └── Shared entities committees FK to (never duplicated)

Runs on ↓

MemberJunction Core
    ├── Auth, RBAC, Notifications, AI Framework
    ├── Record Changes (version control)
    ├── Scheduled Jobs, Actions, Class Factory
    └── Angular Explorer shell + generated forms
```

## Directory Structure

```
.
├── apps/
│   ├── MJAPI/                 # GraphQL API server
│   └── MJExplorer/            # Angular UI
├── Demos/                     # Demo datasets (sample SQL data)
├── metadata/                  # Seed data (types, roles, artifact types)
│   ├── committee-types/
│   ├── roles/
│   └── artifact-types/
├── migrations/                # Flyway database migrations
├── packages/
│   ├── Entities/              # @mj-biz-apps/committees-entities (CodeGen entity classes)
│   ├── Actions/               # @mj-biz-apps/committees-actions (CodeGen action classes)
│   ├── Core/                  # @mj-biz-apps/committees-core (business logic, services)
│   ├── Server/                # @mj-biz-apps/committees-server (bootstrap, resolvers)
│   └── Angular/               # @mj-biz-apps/committees-ng (dashboard components)
├── plans/                     # Design documents and mockups
├── SQL Scripts/               # SQL views and stored procedures
├── mj.config.cjs              # MemberJunction configuration
└── turbo.json                 # Turbo build configuration
```

## Seed Data

Managed via the `metadata/` folder using `mj-sync`. Includes:

- **5 Committee Types**: Board of Directors, Standing Committee, Ad Hoc Committee, Workgroup, Standards Working Group
- **7 Roles**: Chair, Vice Chair, Secretary, Member, Non-Voting Member, Liaison, Advisor
- **9 Artifact Types**: Document, Spreadsheet, Presentation, Minutes, Agenda, Recording, Transcript, Image, Other

## Design

The full design document is at [plans/committees-design.md](plans/committees-design.md) and covers:

- Business overview and key personas
- Conceptual model and the "Membership Triangle" (Who + Where + As What + When)
- Complete ERD with all relationships
- Sequence diagrams for setting up committees, running meetings, action item lifecycle, and term transitions
- State diagrams for Committee, Meeting, Action Item, and Term lifecycles
- Phase roadmap (Core, Enhanced, Standards/Voting, AI)

## Development

### After Database Changes

```bash
npm run mj:migrate     # Run new migrations
npm run mj:codegen     # Regenerate TypeScript/GraphQL/Angular code
npm run build          # Rebuild all packages
```

### Updating MemberJunction Packages

```bash
./Update_MemberJunction_Packages_To_Latest.ps1
npm install
npm run build
```

## Roadmap

| Phase | Focus | Status |
|---|---|---|
| **Phase 1A** | Core schema (14 tables), CRUD, seed data, CodeGen, entity classes | Done |
| **Phase 1B** | Custom Angular UI — dashboard, committee list, meetings, action items, documents | Done |
| **Phase 2** | AI Intelligence Layer — minutes generation, smart agendas, proposal scoring, health dashboard | In Progress |
| **Phase 3** | Voting & balloting, notifications, calendar integration, reporting | Planned |
| **Phase 4** | OpenApp manifest, app store distribution, multi-tenant packaging | Planned |

## License

Business Source License 1.1 — see [LICENSE](./LICENSE) for details.
