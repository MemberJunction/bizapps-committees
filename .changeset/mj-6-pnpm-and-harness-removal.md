---
'@mj-biz-apps/committees-entities': patch
---

Upgrade to MemberJunction 6.x, migrate the repo to pnpm, and remove the private
MJAPI/MJExplorer dev harness.

**Hosts must be on a MemberJunction 6.x environment.** No application source changed, so
this is a `patch` — the convention reserves `minor` for migration and metadata changes and
this branch carries neither. Every `@memberjunction/*` range moves to `^6.1.0-edge.2`, the
estate-wide floor, and `mj-app.json`'s `mjVersionRange` becomes `>=6.1.0-edge.2 <7.0.0`.
The prerelease-tagged lower bound is required: node-semver will not match a prerelease
against a plain `>=6.1.0`. The ranges are carets rather than exact pins because an exact
pin does not satisfy a local sibling's version under pnpm, so workspace links silently fall
back to the registry — and `.npmrc`'s `save-exact=true` is dropped for the same reason.

`@mj-biz-apps/common-*` moves to `^5.34.0` and `tasks-*` to `^1.2.3`. Neither is cosmetic:

- common 5.33.x imports `UserCache` from `@memberjunction/sqlserver-dataprovider`, which MJ
  6.x moved to `@memberjunction/generic-database-provider`, so Open App bootstrap dies on a
  6.x host with `does not provide an export named 'UserCache'`. 5.34.0 is the first build
  that loads.
- tasks 1.2.2 peer-declared `@memberjunction/ng-gantt` and `ng-kanban` at `^6.1.0-edge.1`.
  Peer ranges are part of a package's published contract, so consumers resolved an edge.1
  tree even after moving to edge.2 themselves; in a sibling repo that produced 244
  `@memberjunction` packages at edge.1 alongside the edge.2 set. 1.2.3 fixes the ranges.

Also declares `@mj-biz-apps/committees-core-entities-server` in `mj-app.json`, which was
published but absent from the manifest.
