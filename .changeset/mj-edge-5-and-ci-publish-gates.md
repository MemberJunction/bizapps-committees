---
"@mj-biz-apps/committees-ng": patch
---

Raise every `@memberjunction/*` range to `^6.1.0-edge.5` (the estate-wide edge, matching
bizapps-tasks and bizapps-common) and move `mj-app.json`'s `mjVersionRange` to
`>=6.1.0-edge.5 <7.0.0`. Required because `@memberjunction/ng-hierarchy-tree` was pinned at
`6.1.0-edge.2`, a version that was never published (its first release is `edge.3`), and every
published version hard-pins MJ core at its own exact version, so it can only be installed
alongside a matching MJ. Restores `skipLibCheck` and drops the `paths` mapping to a local MJ
checkout from `tsconfig.angular.json` so the package resolves from npm inside the repo. No
application source changed. CI publish gates now skip `"private": true` packages.
