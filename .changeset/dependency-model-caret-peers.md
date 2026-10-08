---
"@mj-biz-apps/committees-actions": patch
"@mj-biz-apps/committees-core": patch
"@mj-biz-apps/committees-core-entities-server": patch
"@mj-biz-apps/committees-entities": patch
"@mj-biz-apps/committees-ng": patch
"@mj-biz-apps/committees-server": patch
---

MemberJunction and other BizApps packages are peer dependencies with caret ranges (nothing in `dependencies`), so a host keeps one copy of each. The common and tasks packages and `@memberjunction/ng-hierarchy-tree` moved from `dependencies` to `peerDependencies`; every such peer has an exact `devDependencies` anchor for local builds. Adds `check-dependency-model` to CI.
