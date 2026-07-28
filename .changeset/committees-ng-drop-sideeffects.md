---
"@mj-biz-apps/committees-ng": patch
---

Drop `"sideEffects": false` from `@mj-biz-apps/committees-ng`.

The flag told bundlers that no module in the package has side effects, which
licensed esbuild/Vite to elide the bare `import '@mj-biz-apps/committees-entities'`
in `public-api.ts` — the import whose only purpose is firing the `@RegisterClass`
decorators for the entity subclasses. Without it the class factory silently falls
back to the generated base classes.
