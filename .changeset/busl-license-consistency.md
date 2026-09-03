---
"@mj-biz-apps/committees-actions": patch
"@mj-biz-apps/committees-ng": patch
"@mj-biz-apps/committees-core": patch
"@mj-biz-apps/committees-core-entities-server": patch
"@mj-biz-apps/committees-entities": patch
"@mj-biz-apps/committees-server": patch
---

License declarations now agree on BUSL-1.1 everywhere.

The Open App manifest (`mj-app.json`) still declared `"license": "ISC"` while `LICENSE` and
every `package.json` declared BUSL-1.1 — the manifest is what an MJ deployment reads when it
installs the app, so it was the one declaration that shipped the wrong answer. The scaffold
snippet in `plans/IMPLEMENTATION_PLAN.md` carried the same `ISC`, which is how the wrong
value gets copied into the next repo; it is corrected too.
