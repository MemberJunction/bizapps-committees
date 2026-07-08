# Committees App: Vision, Friction Analysis, and What It Should Actually Do

**Last Updated:** March 11, 2026

---

## The Reality of Committee Work Today

Committees are the engine of every association, nonprofit, and standards body. They're where decisions get made, standards get written, events get planned, and policies get shaped. But the operational reality is brutal:

### Where Time Gets Wasted

- **31 hours/month** per employee spent in meetings, with **50% considered wasted**
- Staff spend disproportionate time on logistics: scheduling, distributing agendas, chasing RSVPs, compiling board books, tracking who said they'd do what
- Best practice says agendas should go out **72 hours before** meetings — in reality, they go out the night before (or not at all)
- Board books should be **10-20 pages max** — they regularly hit 50+ because nobody curates them
- Minutes approval is a multi-meeting ritual that consumes real governance time
- Action items from meetings disappear into email threads and are rediscovered (overdue) at the next meeting

### The Scattered Tool Problem

Right now, a typical association committee operates across:

| Function | Tool | Problem |
|----------|------|---------|
| Membership rosters | Spreadsheet or AMS | Out of date, no role history |
| Meeting scheduling | Email + Outlook/Google | Back-and-forth, timezone chaos |
| Agendas | Word doc emailed around | Version confusion, no structure |
| Documents | Google Drive / SharePoint / Box | Scattered across personal folders |
| Meeting notes | Someone's laptop | Never formally distributed |
| Action items | Email or verbal | No tracking, no accountability |
| Voting | Show of hands or email poll | No record, no audit trail |
| Attendance | Sign-in sheet or honor system | Can't calculate quorum automatically |
| Term tracking | Somebody remembers | Expired terms, governance gaps |

**No single system connects these.** The result is institutional knowledge loss, volunteer burnout, and governance gaps that create real legal and compliance risk.

### Why Volunteers Burn Out

Committees are run by **volunteers** — people with day jobs who donate their expertise. The top reasons committees fail:

1. **No clear goals or deliverables** — meetings feel pointless
2. **Too much admin overhead** — scheduling, note-taking, chasing people
3. **Communication gaps** — information trapped in email threads between meetings
4. **No visibility into progress** — "what did we decide last time?"
5. **Diffusion of responsibility** — nobody owns the action items

The friction isn't in the governance itself — it's in the **operational overhead around the governance**.

---

## What the Committees App Should Do

The app's job is simple: **make the operational overhead disappear so people can focus on the actual governance work.**

### Layer 1: The Foundation (BAC + Committees Schema)

This is what we've built. BAC provides the "who" (Person, Organization) and Committees adds the "what" (Committee, Meeting, Membership, etc.). This gives us:

- **Single source of truth** for people across all committees
- **Membership history** — who served where, as what role, during which term
- **Meeting records** — structured agendas, attendance, minutes, motions, votes
- **Action item lifecycle** — assigned, tracked, completed
- **Document linking** — connect to existing storage (Drive, SharePoint, Box) without migration

### Layer 2: Friction Elimination (What Phase 1 & 2 Should Deliver)

This is where the app earns its value. Each capability maps to a specific friction point:

#### Committee Setup & Membership Management
**Friction it kills:** Spreadsheet rosters, manual term tracking, "who's on this committee again?"

- Create a committee in minutes with type, charter, mission
- Add members by searching BAC Person records (no duplicate data entry)
- Assign roles (Chair, Secretary, Member, etc.) with automatic permissions
- Track terms with start/end dates — **automatic alerts when terms expire**
- Full membership history: who served, when, in what role
- Org hierarchy: parent committees, subcommittees, working groups

#### Meeting Lifecycle (Schedule → Agenda → Execute → Follow Up)
**Friction it kills:** Email scheduling hell, lost agendas, "wait, what did we decide?"

**Scheduling:**
- Create meeting with one click from committee context
- Auto-populate attendee list from active membership
- Video conferencing link generation (Zoom/Teams/Meet)
- Calendar sync (Google Calendar, Outlook)
- RSVP tracking with quorum calculation

**Agenda Building:**
- Structured, hierarchical agenda items (not a Word doc)
- Time allocations per item
- Presenter assignments (from BAC Person)
- Drag-and-drop reordering
- Attach documents from linked providers
- **Templates** — standing agendas for recurring meetings
- Publish to members with one click (72-hour reminder built in)

**Meeting Execution:**
- Real-time attendance tracking with quorum indicator
- Navigate through agenda items with timer
- Capture notes per agenda item
- Record motions with mover/seconder from membership
- Roll-call or quick voting with instant tallies
- Create action items inline during discussion

**Post-Meeting:**
- Auto-generate draft minutes from structured notes
- Minutes approval workflow (Draft → Pending → Approved)
- "Approved at next meeting" pattern tracked automatically
- Action items distributed to assignees with due dates
- Meeting recording/transcript linked as artifacts

#### Action Item Tracking
**Friction it kills:** "I thought you were handling that," items lost in email

- Every action item tied to a committee, meeting, and optionally an agenda item
- Assigned to a specific Person (from BAC) with due date and priority
- Status lifecycle: Open → InProgress → Blocked → Completed / Cancelled
- Cross-committee view: "show me all my action items across all committees"
- Overdue alerts and escalation
- Completion notes for accountability

#### Voting & Governance Records
**Friction it kills:** "Did we have quorum?", no audit trail on decisions

- Formal motion recording (who moved, who seconded)
- Individual vote tracking per member (Yes/No/Abstain/Absent)
- Automatic tally with pass/fail based on quorum rules
- Full voting history per member across all committees
- Exportable governance records for compliance/audit

#### Document Management (Link, Don't Store)
**Friction it kills:** "Which version is the right one?", scattered across personal drives

- Link documents from Google Drive, SharePoint, OneDrive, Box, Dropbox
- No file migration required — connect to existing infrastructure
- Organize by committee, meeting, or agenda item
- Artifact types for categorization (Minutes, Agenda, Presentation, etc.)
- Provider-aware browsing (show Drive icon, SharePoint icon, etc.)

### Layer 3: AI-Powered Intelligence (What Makes This Different)

This is where MJ's AI framework creates a **moat** that spreadsheets and basic board portals can't touch:

#### AI Meeting Minutes Generation
- Feed in meeting transcript (from Zoom/Teams recording)
- AI extracts: decisions made, action items with assignees, motions and votes, key discussion points
- Generates structured draft minutes matching the agenda
- Secretary reviews and approves rather than writing from scratch
- **Time saved: 2-4 hours per meeting → 15 minutes of review**

#### AI Proposal & Event Filtering
**This is your idea about filtering proposals.** Committees in associations often receive:
- Event proposals (speakers, sessions, workshops)
- Grant/funding proposals
- Policy change proposals
- Standards change requests
- Vendor proposals

An AI agent can:
- **Intake** proposals through a structured form or email
- **Score and categorize** against committee criteria and past decisions
- **Surface conflicts** (duplicate proposals, conflicting proposals, proposer conflicts of interest)
- **Prioritize** based on strategic alignment, urgency, and resource availability
- **Generate summary briefs** for committee review (not raw 50-page documents)
- **Route** to the right committee/subcommittee automatically

#### AI Agenda Suggestions
- Based on: pending action items, upcoming term expirations, overdue decisions, new proposals
- "You haven't discussed the budget in 3 meetings"
- "4 action items from last meeting are overdue — suggest adding a status review"

#### Committee Health & Engagement Analytics
- Attendance trends (who's consistently absent?)
- Action item completion rates per member
- Meeting frequency vs. charter requirements
- Engagement scoring: combine attendance + voting + action item completion
- **Early warning:** "Committee X hasn't met in 60 days and has 12 overdue items"

#### Smart Document Summarization
- Auto-summarize long documents attached to agenda items
- "Here's the 3-paragraph version of this 40-page policy draft"
- Members can ask questions about documents before the meeting

---

## How BAC and Committees Work Together

The relationship is **foundational, not optional**:

```
┌─────────────────────────────────────────────┐
│              Committees App                   │
│                                               │
│  "What governance work happens"               │
│  Committees, Meetings, Motions, Votes,        │
│  Action Items, Memberships, Terms             │
│                                               │
│  Every person reference → BAC.Person          │
│  Every org reference → BAC.Organization       │
├───────────────────────────────────────────────┤
│              BizApps Common                   │
│                                               │
│  "Who is involved and how to reach them"      │
│  People, Organizations, Addresses,            │
│  Contact Methods, Relationships               │
│                                               │
│  Person.LinkedUserID → MJ.User (auth)         │
├───────────────────────────────────────────────┤
│              MJ Core                          │
│                                               │
│  "Platform services"                          │
│  Auth, RBAC, Notifications, AI,               │
│  Record Changes, Scheduled Jobs               │
└───────────────────────────────────────────────┘
```

**Why this matters:**
- A Person in BAC might be on 5 committees — their profile, contact info, and org affiliation are managed once
- When someone's email changes in BAC, every committee they're on sees the update
- BAC's Relationship entity can express "John is the liaison between Committee A and Committee B"
- Organization hierarchy in BAC maps to "which org sponsors which committee"
- BAC's address system gives committees physical location data for in-person meetings without Committees having to manage addresses

---

## The Standards Development Angle

For standards bodies (ISO, ANSI, IEEE, etc.), committee work has additional complexity:

### How Standards Balloting Works
1. **New Work Item Proposal (NWIP)** — 3-month vote to accept work
2. **Working Draft (WD)** — experts draft in working groups
3. **Committee Draft (CD)** — circulated to P-members for comment and vote
4. **Draft International Standard (DIS)** — all members vote, 2/3 approval needed
5. **Final Draft (FDIS)** — 8-week final vote, same 2/3 threshold

Each stage involves:
- Document versioning (drafts can be 500+ pages)
- Comment collection (technical, editorial, general categories)
- Comment resolution (accept, reject, modify — each requires response)
- Ballot tallies with specific quorum/threshold rules
- Recirculation when changes are substantial

**This is Phase 3 territory**, but the Committees schema already has the Motion/Vote foundation to build toward it. The key insight: standards balloting is just a formalized, multi-stage version of the voting workflow that every committee needs.

---

## Competitive Positioning

| Feature | Spreadsheets | Boardable ($79/mo) | BoardEffect | Diligent (Enterprise) | **Committees App** |
|---------|-------------|---------------------|-------------|----------------------|-------------------|
| Committee CRUD | Manual | Yes | Yes | Yes | Yes |
| Meeting scheduling | No | Basic | Yes | Yes | Yes + calendar sync |
| Agenda building | Word doc | Basic | Yes | Yes | Hierarchical + templates |
| Minutes management | Word doc | Basic | Yes | Yes | AI-generated + approval workflow |
| Action tracking | No | Basic | Limited | Yes | Full lifecycle + cross-committee |
| Voting/motions | No | No | Limited | Yes | Full audit trail + roll call |
| Document management | Scattered | Basic upload | Yes (proprietary) | Yes (proprietary) | Link to existing providers |
| AI features | No | Emerging | No | Limited | Full AI framework (minutes, proposals, summaries) |
| Standards balloting | No | No | No | No | Phase 3 |
| Person/Org management | Spreadsheet | Separate | Separate | Separate | Shared via BAC |
| Extensible platform | No | No | No | API only | Full MJ platform (actions, entities, AI) |
| Pricing | Free (but costly in time) | $79-299/mo | $$$$ | $$$$$ | $199-999/mo |

**The moat:** Nobody else has AI-powered proposal filtering, meeting minutes generation, and committee health analytics built on a shared person/org data layer with a fully extensible platform underneath.

---

## Summary: The Three Jobs of the Committees App

1. **Eliminate operational friction** — scheduling, agendas, minutes, action tracking, document management all in one place with zero duplicate data entry

2. **Create an institutional memory** — full history of who served, what was decided, how people voted, what actions were taken — searchable and auditable forever

3. **Amplify committee effectiveness with AI** — auto-generate minutes, filter and prioritize proposals, surface what needs attention, predict governance risks before they happen

The goal isn't to change how committees govern. It's to **remove everything that gets in the way of governing.**

---

## Sources

- [BoardEffect: 2026 Nonprofit Governance Trends](https://www.boardeffect.com/blog/trends-mission-driven-organizations/)
- [Association Trends 2026: Boost Membership Growth & Retention](https://momentivesoftware.com/blog/whats-facing-nonprofits-and-associations-in-2025/)
- [Why Volunteer Committees Fail](https://pointapp.org/blog/why-committees-fail-and-how-to-make-sure-yours-doesnt/)
- [Volunteer Committees: Set Them Up for Success](https://www.cbi.org/article/volunteer-committees-set-them-up-for-success/)
- [What You Need to Know About Association Committees](https://sidecarglobal.com/intro-to-associations/what-you-need-to-know-about-association-committees/)
- [Beating Burnout: Taking Control of Volunteer Committees](https://www.thenonprofittimes.com/hr/beating-burnout-taking-control-of-volunteer-committees/)
- [Momentum: Creating New Efficiencies in Association Management](https://www.momentumamc.com/blog/creating-new-efficiencies-in-association-management)
- [Momentum: Board Governance Best Practices](https://www.momentumamc.com/blog/board-governance-best-practices)
- [YourMembership: Automate Your Association's Processes](https://www.yourmembership.com/blog/automate-associations-processes-increase-efficiency/)
- [Boardable: Top 5 Nonprofit Board Management Features](https://boardable.com/resources/top-5-boardable-features-for-nonprofit-board-management-software/)
- [Boardable: AI in the Boardroom](https://boardable.com/resources/ai-in-the-boardroom-transforming-nonprofit-strategy-for-greater-impact/)
- [BoardEffect: Board Management Software Not Just for Boards](https://www.boardeffect.com/blog/board-management-software-not-just-for-boards/)
- [Diligent: Governance for Nonprofit and Volunteer Boards](https://www.diligent.com/solutions/governance-for-nonprofit-and-volunteer-boards)
- [AI Agents for Nonprofits: Complete Guide](https://www.mindstudio.ai/blog/nonprofits/)
- [Time Wasted in Meetings: 36 Statistics](https://www.ambitionsaba.com/resources/time-wasted-in-meetings)
- [National Council of Nonprofits: Effective Board Meetings](https://www.councilofnonprofits.org/running-nonprofit/governance-leadership/effective-board-meetings-good-governance)
- [Boardable: Board Meeting Agendas Guide](https://boardable.com/resources/board-meeting-agendas/)
- [ISO: Ballot Types and Stages](https://helpdesk-docs.iso.org/article/228-ballot-types-and-stages)
- [ANSI: International Procedures for ISO Standards Development](https://www.ansi.org/iso/us-representation-in-iso/international-procedures)
- [ISO: Stages and Resources for Standards Development](https://www.iso.org/stages-and-resources-for-standards-development.html)
- [Best Board Governance Software of 2026](https://peoplemanagingpeople.com/tools/best-board-governance-software/)
- [Microsoft: Out-of-Control Meetings Waste Time](https://workplaceinsights.microsoft.com/collaboration/out-of-control-meetings-waste-time-undermine-work/)
