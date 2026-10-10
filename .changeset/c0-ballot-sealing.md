---
"@mj-biz-apps/committees-core": patch
"@mj-biz-apps/committees-core-entities-server": patch
"@mj-biz-apps/committees-server": patch
"@mj-biz-apps/committees-ng": patch
"@mj-biz-apps/committees-entities": patch
"@mj-biz-apps/committees-integration-tests": patch
---

Ballot sealing is enforced on the server (C0). The UI role reads Votes through the new "Committees: Visible Votes" row filter: a member sees their own vote, roll-call votes on meeting motions, and every vote on a closed or cancelled ballot that is not sealed. Closing a ballot moves to the `CloseBallot` mutation, which tallies as the system user and stamps the motion; `BallotProgress` gives open ballots their participation counts. The custom Membership and Meeting entity classes now register under their entity names ("Committees: Memberships", "Committees: Meetings"), so their validation rules run.
