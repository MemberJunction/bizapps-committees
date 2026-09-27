# Rebuilding Committees on Collaboration

**Status:** planned, not started. It's C4 in Collaboration's plan (`plans/plan.md` § 8, v0.5, in [bizapps-collaboration#8](https://github.com/MemberJunction/bizapps-collaboration/pull/8) until it merges): Committees is rebuilt in one major version, after Collaboration's PR #8 and bizapps-tasks' meetings (that plan's workstream T). Where C4 and this plan differ, C4 holds.

**Updated 2026-09-27:** meetings, agenda items, attendance and video providers move to bizapps-tasks, and Committees strips its own out (Collaboration's D33 and C4). Backward compatibility isn't a concern for them (Amith).

This plan builds on [the extensibility plan](https://github.com/MemberJunction/bizapps-collaboration/blob/next/docs/EXTENSIBILITY_PLAN.md)'s contracts and doesn't restate them. Read it first.

## Why

Committees becomes a plug-in for Collaboration rather than a workspace of its own.

- **Every committee and every term becomes a Collaboration space,** so members get everything a space gives:
  - the space's people, library, chats and tasks;
  - the Assistant, bounded to what everyone in a chat can see;
  - invites for people from outside;
  - Collaboration's new UI.
- **Committees adds governance:** terms, roles and voting rights, motions, votes and ballots, quorum, and minutes.
- **Meetings come from bizapps-tasks,** which every app shares: meetings, agendas, attendance, video providers and meeting notes. Committees' governance points at them.
- **Collaboration knows nothing about Committees.** Committees ships a space type, a subtype table, two plug-in classes and a few contributions. Collaboration finds them through its extension points.

## The mapping

**Committee IsA Space,** type `committee`. A sub-committee is a committee space under its parent committee.

| Committee column | Becomes |
|---|---|
| `Name`, `Description` | `Space.Name`, `Space.Description`. The columns go. |
| `ParentCommitteeID` | `Space.ParentID`. The column goes. |
| `FormationDate`, `DissolutionDate` | `Space.StartedAt`, `Space.ClosedAt`. The columns go. |
| `TypeID`, `OrganizationID`, `CharterDocumentURL`, `MissionStatement`, `Status`, `IsPublic` | Stay on `Committee` |

Every existing `CommitteeID` foreign key already holds the space's ID, because an IsA child shares its parent's primary key.

**Term IsA Space,** type `committee-term`, under its committee's space.

| Term column | Becomes |
|---|---|
| `Name` | `Space.Name`. The column goes. |
| `StartDate`, `EndDate` | `Space.StartedAt`, `Space.PlannedCloseAt`. The columns go. |
| `CommitteeID` | `Space.ParentID`. The column goes. |
| `Status` | Stays on `Term` |

**Why the columns go, not just fall out of use:** a subtype column with the same name as a `Space` column makes CodeGen log a field collision and skip the subtype's inherited fields altogether (the extensibility plan's § 7). `Name` and `Description` collide today. The others would leave two copies of one fact.

**Membership stays Committees' own record:** the person, the term, the role, the dates, the end reason and the renewal intent.
- The committee's server driver keeps seats in step through Collaboration's `SyncSeats`, with the source `committees:membership`:
  - the current term's members sit on the committee's space, so they reach every term below it;
  - each term's space keeps its members' seats, as the record of who sat on it;
  - a person whose `Person.LinkedUserID` is empty gets an email invite instead of a seat;
  - seats that people invite by hand, such as a staff liaison's, stay separate: a sync changes only its own seats.
- `Vote.MembershipID` and the motion and ballot references keep working unchanged.
- This avoids an IsA on `SpaceMember`, whose unique `(SpaceID, UserID)` and status don't fit a history of seats.

**Sub-committees keep their own membership.** A sub-committee is a committee space under its parent with `InheritsMembership` off, so a compensation sub-committee isn't open to the whole board. Terms keep it on. The committee's server driver sets both when the child space is created.

**Stays in Committees, filtered through Collaboration:**
- Tables: `Motion`, `Vote`, `Ballot`, `Minute` and the lookup tables.
- Each gets a read filter through Collaboration's `fnCollaborationAccess`, as metadata. Space Participant gets entity permissions, as metadata.

**Moves to bizapps-tasks, and is stripped out of Committees:**

| Committees today | In bizapps-tasks |
|---|---|
| `Meeting` | `MJ_BizApps_Tasks: Meetings`, with no committee column: a `MJ_BizApps_Tasks: Meeting Links` row ties a meeting to its committee |
| `AgendaItem` | `MJ_BizApps_Tasks: Meeting Agenda Items`. Its type is a lookup, `MJ_BizApps_Tasks: Meeting Agenda Item Types`, and Committees adds *Vote* to it, as metadata |
| `Attendance` | `MJ_BizApps_Tasks: Meeting Attendees`, with an RSVP and an attendance status |
| `VideoProvider`, and its drivers | `MJ_BizApps_Tasks: Video Providers`, with the drivers |

- **Committees drops these four tables,** and the code that serves only them, in its major version. Backward compatibility isn't a concern: no rows are copied, and no compatibility layer is kept.
- **The governance points at Tasks' meetings instead,** `MJ_BizApps_Tasks: Meetings` and `MJ_BizApps_Tasks: Meeting Agenda Items`:
  - the keys to a meeting, from `Minute` (both `MeetingID` and `ApprovedByMeetingID`), `Motion`, `Artifact` and `Comment`;
  - the keys to an agenda item, from `Motion`, `Artifact` and `Comment`. Votes and ballots follow through their motion;
  - existing values are cleared first, since no meetings are copied. The rows keep everything else, and every one of these keys allows NULL today.
- **Quorum** stays with the governance. It's computed in code today, as a majority of the voting members; `Meeting.PredictedQuorumRisk…`, the only stored quorum data, goes with the table.

**Moves to Collaboration's concepts:**
- **Documents** become space items (MJ Files) in the committee's library. Drafts sit on the Team side and approved papers on the Shared side, so approving minutes is a promotion.
- **Comments** become chats about a record: a Tasks meeting or agenda item, or a motion.
- **Action items,** already bizapps-tasks tasks, are filed in the committee's or the term's space.

## What Committees ships

**Subtype tables:** `Committee` and `Term`, declared as IsA children of `MJ_BizApps_Collaboration: Spaces` in Committees' own `codegen-schema-info.json`, with the migration's CodeGen output.

**Space types,** as metadata:
- `committee`:
  - `ServerDriverClass` `CommitteeSpaceServerDriver`, `UIDriverClass` `CommitteeSpaceUIDriver`, and `SpaceExtensionEntity` `Committees: Committees`;
  - `Configuration`: children `committee-term` and `committee`, admin role names for the Committee Management users, and the tab labels *Papers* and *Members* (frame 08 of Collaboration's storyboard).
- `committee-term`: its own drivers, and `SpaceExtensionEntity` `Committees: Terms`.

**Permissions for the subtypes,** as metadata: every role's read permission on Committees and Terms carries Collaboration's space-access filter, matching Space's. Collaboration refuses the type rows otherwise.

**The server drivers:**
- keep seats in step with memberships;
- refuse a hand-made seat for someone with a membership, since their seat comes from it. Other invites, such as a staff liaison or a guest presenter, work as in any space;
- allow one open term per committee;
- close a term's space when the term ends;
- give the Assistant a committee's roster, roles and next meeting (`BuildAgentContext`), the meeting read from Tasks through its link to the committee;
- enforce sealed ballots on the server. Today only the browser enforces them.

**The UI driver and contributions:**
- tabs: Meetings (bizapps-tasks' meeting components, showing the committee's meetings), Motions and a roster with roles;
- overview cards: the next meeting and open votes;
- header chips: the term, and the quorum risk if its scoring moves to Tasks' meetings (below);
- a settings section for the charter and mission;
- a new-committee step that shows Committees' own form through Collaboration's form host.

**Agents:** any committee agent, such as a minutes agent, goes on the committee type's allowed-agent list, as metadata. Until MJ core bounds every agent by everyone in a chat, only agents whose data access is bounded belong on it (the extensibility plan's § 8).

## Data migration and the version

Moving columns into `Space` removes columns from published tables, and the meeting tables go. Under the publish-then-no-breaking-changes policy that makes this Committees 2.0.0.
- **Meetings, agenda items, attendance and video providers aren't migrated.** Their tables are dropped with their rows. The ML pipeline, models and weekly scoring job that target `Committees: Meetings` move to Tasks' meetings or are dropped. Any `TaskLink` rows that point at a Committees meeting would point at nothing, so the upgrade removes them.
- **Existing committees and terms** get `Space` rows with the same IDs before the IsA declaration applies. Choose one while building, and record why:
  - a guarded data migration;
  - an upgrade action the installer runs.
- **Existing memberships** become seats through the first sync. People without MJ users get email invites.
- **Artifacts and file links** become space items.
- **Old comments** stay readable, or move into chats about their records.

## Dependencies

- `mj-app.json` adds `mj-bizapps-collaboration`, at the release that carries the extensibility work.
- The bizapps-common floor rises to 5.46.0, Collaboration's floor.
- The bizapps-tasks floor rises to the release that adds meetings (Collaboration's workstream T).
- The MJ floor rises to Collaboration's, which includes the `ng-conversations` and IsA pull requests (the extensibility plan's § 9).

## Fixes to carry along

- **The custom validation classes never bind.** They register under `'Meetings'` and `'Memberships'`, but the entities are named `'Committees: Meetings'` and `'Committees: Memberships'`. Collaboration's C0 fixes both first; the meetings class then goes with its table.
- **Staff means two things today:** Collaboration's staff roles, and access to the Committee Management app. The committee type's admin role names settle it.
- **New metadata goes in `metadata/` JSON.** Earlier migrations hand-wrote metadata; they've shipped, so they stay as they are.

## Tests

- **Integration checks** for:
  - the seat sync;
  - a hand-made seat refused for someone with a membership;
  - the one-open-term rule;
  - the sealed ballot;
  - a sub-committee's own membership;
  - the governance on Tasks' meetings: a motion on a meeting's agenda item, minutes approved at a later meeting, and the *Vote* agenda item type;
  - the read filters on every committee table through `fnCollaborationAccess`, and the subtype permissions Collaboration checks.
- **Playwright specs** for the committee space: its tabs, cards and chips, and a live screenshot of Collaboration's frame 08 drawn by the real plug-in, in light and dark.

## Questions to settle while building

- **The owner of a migrated space.** `Space.OwnerID` must be an MJ user: the chair's user when there is one, otherwise a service user.
- **`Committee.Status`:** Dissolved maps to `ClosedAt`. Decide what Inactive and Pending mean for the space.
- **`IsPublic`:** whether it becomes a space-level override of the type's discoverability.
