# OpenApp PostgreSQL install verification — analysis + harness

_Analysis of `MemberJunction/bizapps-committees` PR #10's PG testing, and a reusable harness so PG
regressions get caught **before** release instead of forcing another "fix PG again" version._

---

## 1. What the committees PR does today (and it's largely right)

The PR already establishes the correct **conceptual model** for OpenApps on PostgreSQL:

- **The one-shot install is the contract.** On SQL Server, CodeGen's DDL (CRUD sprocs, views,
  triggers) is appended into the migrations at authoring time (`appendOutputCode`), so an install is
  complete on its own. The SS→PG converter **cannot** translate T-SQL procedures/triggers, so a
  purely-converted PG install would be incomplete until a consumer ran `mj codegen`. Consumers of an
  OpenApp don't run codegen — so `migrations-pg/` carries **CodeGen's own native plpgsql, baked in by
  hand**. That is what makes a fresh `mj migrate` produce a fully-working schema.
- **The acceptance test for that bake is: `mj codegen` must be a no-op.** If codegen changes anything
  after a fresh install, a migration is missing codegen output. The PR's runbook states this in §7.
- Concrete artifacts already in the PR: `scripts/pg-objectmodel-test.mjs` (25-check functional suite
  exercising CRUD functions, FK-join views, the 3 recursive root-parent hierarchies, CHECK
  enforcement, cross-schema joins), `scripts/pg-finalize.mjs` (converter patch layer), and
  `migrations-pg/docs/PG_INSTALL_VERIFICATION.md` (the manual runbook).

**This is a solid foundation.** The gaps below aren't about the model being wrong — they're about the
_verification_ being manual and soft.

## 2. Gaps that let a bad PG release slip through

| # | Gap | Why it forces a re-release |
|---|-----|----------------------------|
| G1 | **The codegen-no-op proof is eyeballed counts.** §6/§7 compare sproc/view/trigger _counts_ and "identical numbers". A migration can carry a **stale** function/view body (right count, wrong definition) and pass a count check. | A regenerated view/CRUD-function whose new body wasn't re-baked ships broken; counts still match. |
| G2 | **It's a long manual procedure, re-done per app, per release, by hand.** ~7 stages with subtle ordering (canonical-name UPDATE before migrate, deps in manifest order, `--tag` vs bare migrate, `--ci` for sync push in non-TTY). | Any skipped/mis-ordered step gives a false result; humans skip steps under release pressure. |
| G3 | **Expected numbers are hand-maintained per app** (48 sprocs, 16 views, …). When the schema grows, the numbers are stale until someone updates the runbook. | Verification drifts from reality silently. |
| G4 | **No structural per-entity check.** "48 sprocs" doesn't prove _entity X_ has all 3 of its functions — one entity could be missing a function while another has a duplicate, netting the same total. | A single entity's missing CRUD function isn't localized. |
| G5 | **No single pass/fail gate for CI.** Nothing a release pipeline can run and block on. | Regressions are found by users, post-release. |

## 3. The harness — `scripts/verify-pg-install.mjs`

One config-driven command that **faithfully mirrors what MJ core's `mj app install` does to a
Postgres DB** (`packages/OpenApp/Engine/src/install/*`), then runs three gates of increasing strength.
Everything app-specific is read from `mj-app.json`, so the **same file drops into any OpenApp repo
unchanged** — the way `pg-finalize.mjs` already does. Nothing touches MJ core.

### Faithful install simulation (mirrors `InstallApp` — verified against the engine source)

1. `mj migrate --tag <core>` — the consumer's platform install (MJ core migrations).
2. **Transitive dependency chain, leaf-first, deduped** — resolved from `mj-app.json` `dependencies`
   (recursively). Each dep: `CREATE SCHEMA` (canonical/lowercased name, as `CreateAppSchema` does) →
   `mj migrate --schema … --dir <dep>/migrations-pg` → record `OpenApp` row. Deps without a local
   `--dep path=…` are cloned from their manifest `repository`.
3. **App under test, one-shot** — same steps, `NO codegen`, `NO sync-push`. PG migrations dir resolved
   exactly as the installer does: `<migrations.directory>-pg` when present, else the base dir
   (`install-orchestrator.ts:1216`).

That is the **complete DB state a real `mj app install` produces** — nothing more. Two things the
harness deliberately does NOT fold into the install (both verified against the engine):
- **It does not write `SchemaInfo.CanonicalSchemaName`.** The installer never does — that column is set
  by the app's OWN migration (committees' `CodeGen_Metadata_Backfill.pgonly`). Writing it here would
  mask a missing backfill, which Gate 1 exists to catch.
- **It does not `mj sync push` during install.** The installer never seeds via sync-push; migrations
  carry any metadata DML. Seeding is a separate, explicitly-labeled phase (below).

### The three gates (run in this order)

- **Gate 1 · Structural invariants** — run on the **pure migrate-only state**, so it needs no seed
  data. _(generic, derived from the DB — no hand-maintained numbers; closes G3, G4.)_ Schema under the
  canonical name; `SchemaInfo.CanonicalSchemaName` set and equal to the manifest's mixed-case name;
  **for each physical entity** (virtual entities skipped) — base view + only the CRUD functions its
  `AllowCreateAPI/UpdateAPI/DeleteAPI` flags enable (honoring custom `spCreate/…` overrides and
  `BaseTableCodeName`) + one update trigger; no case-duplicate entities; PascalCase ClassNames.

- **Reference-data seeding** — an **explicit, labeled, opt-out (`--no-seed`)** phase between Gate 1 and
  Gate 2, clearly flagged as *"NOT part of `mj app install`"*. Reports whether the app's data came from
  migrations or from sync-push (a sync-push dependency is surfaced as a deviation from the pure
  one-shot, not hidden). Only Gate 2 depends on it.

- **Gate 2 · Functional suite** _(app-owned)_ — runs the app's own `scripts/pg-objectmodel-test.mjs`
  and asserts `RESULT: N passed, 0 failed`. Runs before Gate 3 (which mutates via codegen).

- **Gate 3 · CodeGen no-op — the regression gate** _(closes G1, the release-breaker.)_ Snapshots every
  app-schema **DDL definition** — functions, views, triggers, **table columns, constraints
  (CHECK/UNIQUE/FK/PK), indexes (incl. `IDX_AUTO_MJ_FKEY_*`), and GRANTs** — plus the app's `__mj`
  metadata rows (Entity, EntityField, EntityRelationship, **EntityPermission**, EntityFieldValue —
  scoped by `SchemaName` so core reconciliation noise is excluded, volatile timestamps stripped). Runs
  `mj codegen`. Snapshots again. **Asserts the diff is empty**, and refuses to certify a vacuous run
  (empty snapshot ⇒ schema not in codegen scope ⇒ FAIL, not a silent pass). Any changed/added/removed
  definition or metadata row = "a migration is missing codegen output" — printed explicitly.

### One pass/fail exit code (closes G5)

Exit 0 iff all (non-skipped) gates pass. Drop it into CI on a fresh Postgres and block the release on it.

### First live result (committees, fresh postgres:17, MJ core v5.44.0)

Ran end-to-end against the actual committees `next` branch:

- **Install pipeline — GREEN.** MJ core migrate → both deps (common, tasks) migrate → committees
  one-shot migrate all succeed on a virgin Postgres.
- **Gate 1 — PASS.** 16 entities, no case-dups, all 16 base views, all 48 CRUD functions, all update
  triggers present. (ClassName is empty after migrate-only — expected; CodeGen populates it.)
- **Gate 2 — PASS.** The committees functional suite runs 25/25.
- **Gate 3 — BLOCKED (not a committees failure), across every run.** `mj codegen` never completes in a
  local keyless environment against a fresh MJ core **v5.44.0**, for two environmental reasons — both
  affecting only **CORE `__mj` entities** (`MJ: AI Agents`, `MJ: AI Skills`, …, up to ~1560 entities)
  and **zero committees entities**:
  1. Core metadata `entityFieldsSequenceCheck` inconsistencies (the runbook's "core reconciliation is
     outside this repo's control", here a hard abort rather than a benign reconcile), and
  2. CodeGen's LLM-driven "AFTER commands" (e.g. `Check Constraint Parser`) require API credentials.
     The harness now runs codegen with **advancedGeneration disabled** (backup/restore `mj.config.cjs`)
     to remove reason 2 — but reason 1 (and a residual "AFTER commands" failure) still block it at v5.44.
  The harness **correctly classifies this as BLOCKED** (yellow, exit 2) — never a false app-FAIL —
  because it attributes the failure to the *entities that actually failed the integrity check*, all of
  which are core. **To get a GREEN Gate 3, run against a core build whose own codegen completes clean**
  (the environment the committees team used to validate their no-op). The app itself installing + running
  is already proven by Gates 1–2; Gate 3 is the *bake-freshness* check, which needs a working core codegen
  to have anything to diff against.

This first run also flushed out and fixed real harness bugs (manifest `dependencies` accepts both an
array and a map form; `__mj.Entity` column set differs across core versions; the functional suite's
stdout must be captured to parse its RESULT; the codegen-abort classifier must attribute failures to
the *entities that actually failed the integrity check*, not to any entity merely named in the output).

### Fidelity review

The harness was adversarially reviewed against the installer source (`packages/OpenApp/Engine/src/install/*`,
the PG dialect, the CLI migrate path, and `PostgreSQLCodeGenProvider`). Two HIGH findings — an injected
`mj sync push` at install time and a fabricated `SchemaInfo.CanonicalSchemaName` write, both of which
could have turned the headline regression into a *false green* — were confirmed against the code and
fixed (seeding is now a separate labeled phase; the canonical-name write is gone). Also fixed: Gate 1
now honors `Allow*API`/virtual/custom-SP nuances (no false-fails on read-only or virtual entities);
Gate 3 snapshot widened to columns/constraints/indexes/grants/EntityPermission with a vacuity guard;
the OpenApp insert guards a missing `User` row; and Gate-3 cleanup is allowlisted to codegen output
only. One documented residual: `mj migrate --schema` reads baseline semantics from the app's
`mj.config.cjs` whereas the installer hardcodes `BaselineVersion='1'` — the harness warns on a
divergent config.

## 4. How to run it

```bash
# In the app repo (npm install first so `pg` + `mj` resolve). Harness spins & tears down PG itself.
node scripts/verify-pg-install.mjs \
  --docker --core-tag v5.44.0 \
  --dep mj-bizapps-common=../bizapps-common \
  --dep mj-bizapps-tasks=../bizapps-tasks
```

- Omit `--dep …` for a dependency and it's cloned from its manifest `repository` at `--deps-ref`
  (default `next`).
- Omit `--docker` to run against an existing DB via `PGHOST/PGPORT/PGUSER/PGPASSWORD/PGDATABASE`.
- `--keep` leaves the container up for post-mortem; `--skip-codegen-check` / `--skip-functional` for
  partial runs (not for CI).

**Committees caveat:** its manifest floor is `>=5.45.0`, but the PG plpgsql was **baked against
v5.44.0** (the SS Metadata_Sync calls a v5.45 core sproc; the PG path validates on 5.44). Pass
`--core-tag v5.44.0` explicitly — the harness's default (lower bound of `mjVersionRange`) would pick
v5.45.0, which is the SS floor, not the PG bake target.

## 5. What the harness deliberately does NOT do

- **Phase-2 file operations** (npm package install, server/angular config edits). The real installer
  runs these only inside a live MJ host project and they're irrelevant to DB correctness — which is
  exactly why the real `mj app install … --dangerously-ignore-dbl-underscore-schema-rule` completes
  the DB steps regardless. The harness verifies the DB contract, which is where PG breaks.
- **Always use a throwaway DB.** Gate 3 runs `mj codegen`, which must only ever run against a fresh DB
  (codegen against a non-fresh DB is unsafe). `--docker` guarantees this.

## 6. Suggested home

Ship it as `scripts/verify-pg-install.mjs` vendored into each OpenApp repo (the existing
`pg-finalize.mjs` pattern) — immediate, and it lands in this PR. Because it's fully config-driven off
`mj-app.json`, promoting it later into MJ core as an `mj app verify-pg` CLI verb is a lift-and-shift
with zero logic change.
