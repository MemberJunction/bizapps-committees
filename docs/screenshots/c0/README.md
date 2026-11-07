# C0 browser pass: ballot sealing

The screens `take-screenshots.mjs` takes and asserts, as a signed-in Governance chair whose account holds the UI role only
(so the "Committees: Visible Votes" row filter governs what the browser reads) while the server closes the ballot.

| Screen | Shows |
|---|---|
| `c0-01-member-home-open-ballot` | My Committees: the open Governance ballot asks for the chair's vote. |
| `c0-02-ballot-participation` | The Motions page's open-ballot hero: participation from `BallotProgress` (2 of the roster, the signed-in chair's seat included), who has voted, "Choices sealed until close"; no choice of another member anywhere on the page. |
| `c0-03-close-dialog` | Close early: participation, "5 Yes needed", no projected outcome (the server counts), the secret-ballot note. |
| `c0-04-close-reveal` | After confirming: `CloseBallot` tallied 2-0-0 on the server, stamped the motion Failed, and the dialog reveals the tally; choices remain sealed. First theme only. |
| `c0-05-register-stamped` | The register row carries the stamped result and tally; no open ballot remains. First theme only. |

Run it against an Explorer on an MJAPI whose database holds COM-WORLD (`node test-harnesses/integration.mjs committees-world`).
The two closing screens change the world; reload it afterwards with the same command, which reopens the ballot.
