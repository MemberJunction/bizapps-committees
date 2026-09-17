---
"@mj-biz-apps/committees-ng": patch
---

Widen the five `@angular/*` `peerDependencies` from the exact pin `21.1.3` to `^21.1.3`.

The exact pin was unsatisfiable in any real install: every `@memberjunction/ng-*` package
at `6.1.0-edge.5` — all of which committees-ng depends on — requires `@angular/core`
`^21.2.22`, and the MJ Explorer host ships `21.2.22`. No single Angular installation could
satisfy both `=21.1.3` and `^21.2.22`, so consumers using npm hit a hard `ERESOLVE`
failure and consumers using pnpm installed on a suppressed peer warning.

`^21.1.3` matches `@mj-biz-apps/tasks-ng` and `@mj-biz-apps/common-ng`, which committees-ng
already depends on. The `@angular/compiler` and `@angular/compiler-cli` devDependencies
remain pinned at `21.1.3`; they are the build toolchain, not part of the published contract.
No application source changed and the lockfile is unaffected.
