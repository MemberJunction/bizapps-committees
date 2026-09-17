---
"@mj-biz-apps/committees-ng": patch
---

feat(committees-ng): add CommitteeGovernanceTreePanel and interactive CommitteeRoster tracker

- Adds `CommitteeGovernanceTreePanel` to `Committees: Committees` using `@memberjunction/ng-hierarchy-tree` for multi-tier Board $\rightarrow$ Committees $\rightarrow$ Subcommittees hierarchy visualization.
- Adds `CommitteeRosterComponent` and `CommitteeRosterPanel` featuring:
  - **KPI Ribbon**: Total Active Members, Leadership Officers, Expiring Terms (< 60 days alert), Average Attendance %.
  - **Leadership Segregation**: Distinguishes Officers (Chair, Vice-Chair, Secretary, Treasurer) from general members.
  - **Term Health Tracking**: Live countdowns for active, upcoming, expiring soon (< 60d alert), and expired terms.
  - **Attendance Track Record**: Live attendance percentage and progress bar computed from `Committees: Meeting Attendance`.
  - **Navigation**: Direct links to Person and Membership records.
