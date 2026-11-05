# C4 browser pass: Committees on Collaboration and Tasks Meetings

Screens captured and asserted in MJ Explorer (light and dark) against the unified workspace (`MJ_LOCAL_APPS=common,tasks,collab,committees`) on a fresh database (`COLLAB_DEMO_FRESH`), signed in as committee members whose accounts hold the `UI` role only:

| Screen | Persona | Shows |
|---|---|---|
| `c4-01-my-committees` | `elena.voss@com-world.test` (`UI` role, Governance & Ethics Chair) | `My Committees` (`MemberHomeComponent`) rendering `Governance & Ethics Committee`, the `2026-2027 Term` badge, the open e-ballot banner (`Cast your vote`), upcoming Tasks-backed meetings (`Q1 Governance Review`), and assigned committee tasks (`Draft conflict-of-interest attestation form`). |
| `c4-02-ballot-participation` | `marcus.lee@com-world.test` (`UI` role, Voting Member) | `Motions & Voting` (`MotionRegisterComponent`) rendering the open secret e-ballot hero (`Adopt Revised Charter Section 4`), live participation from `BallotProgress` (`2 of 7 voted · 29%`), `Choices sealed until close`, and the voter's own ballot receipt with no other member's choice exposed. |
