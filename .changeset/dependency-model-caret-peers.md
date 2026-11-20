---
"@mj-biz-apps/committees-core": patch
"@mj-biz-apps/committees-core-entities-server": patch
"@mj-biz-apps/committees-ng": patch
---

Move `@memberjunction/*` and sibling `@mj-biz-apps/*` packages (`@memberjunction/ng-hierarchy-tree`, `@mj-biz-apps/common-entities`, `@mj-biz-apps/common-ng`, `@mj-biz-apps/tasks-core`, `@mj-biz-apps/tasks-entities`, `@mj-biz-apps/tasks-ng`) out of `dependencies` into `peerDependencies` with caret ranges across published packages so hosts keep a single copy of MemberJunction and each Open App, and enable full repo enforcement of `check-dependency-model.mjs` in `repo-checks.yml`.
