# Verifying BizApps Committees on PostgreSQL (one-shot install, no CodeGen)

> **STATUS: VALIDATED 2026-07-22** — executed end-to-end on a fresh postgres:17
> container (MJ core v5.44.0 + bizapps-common + bizapps-tasks + committees). A
> **migrate-only** install (no `mj codegen`) produced the full working schema
> (48 CRUD functions, 16 base views, 16 update triggers, RenewalIntent present,
> ActionItem dropped, 16 entities, **0 duplicate entities**), passed the
> functional suite **25/25**, and a subsequent `mj codegen` was a **no-op**
> (zero committees object/metadata drift). The SQL Server path is validated
> separately on a fresh DB at core **v5.45.0** (the manifest floor — see below).

This runbook simulates what `mj app install` does to a PostgreSQL database and
verifies the app is **fully functional without ever running `mj codegen`**. It
is the committees analog of bizapps-tasks' and bizapps-common's one-shot
runbooks.

Why simulate instead of running the real command? `mj app install` downloads an
app's migrations from its latest GitHub release. To test unreleased changes to
`migrations-pg/`, run the same database steps the installer performs but point
the migration step at your local branch. Once a release ships, the app steps
collapse back to the real `mj app install`.

## How the one-shot install works (background)

On SQL Server, CodeGen's DDL (CRUD sprocs, views, triggers) is appended into
the migrations at authoring time, so an install is complete on its own. The
PG conversion pipeline **cannot** translate T-SQL procedures/triggers
(`-- SKIPPED: procedure (auto-conversion not supported)`), so a purely-converted
PG install would be incomplete until a consumer ran `mj codegen`.

The committees `migrations-pg/` files now carry **CodeGen's own native
PostgreSQL plpgsql**, captured verbatim from a post-codegen v5.44 database and
appended into each migration below a banner:

```
-- CodeGen native PostgreSQL objects (baked from `mj codegen` v5.44 …)
```

This is what makes the one-shot install work and makes a subsequent codegen run
a no-op. It is the same approach bizapps-common and bizapps-tasks use — the
manual PG analog of what `appendOutputCode` does automatically for T-SQL.
(The rule-based `mj migrate convert --split --bake-codegen` command does **not**
work on committees' migrations — it drops CREATE TABLE, parse-errors on the
app-registration block, and applies `${mjSchema}` unresolved — so the plpgsql
was captured by hand, per the Maintenance contract below.)

Committees depends on bizapps-common and bizapps-tasks, so the install is
**four** layers: MJ core → bizapps-common (≥ v5.32.0, whose PG migrations are
one-shot) → bizapps-tasks (≥ v1.1.1) → bizapps-committees.

Post-drop state note: the baseline creates 17 tables including the legacy
`ActionItem`; `Replace_ActionItems_With_Tasks` drops it. Final state is
**16 tables / 16 entities**.

## 0. Fresh PostgreSQL (throwaway container)

```bash
docker run -d --name committees-pg-test \
  -e POSTGRES_USER=mj_admin -e POSTGRES_PASSWORD=<pw> \
  -e POSTGRES_DB=Committees_OneShot -p 5439:5432 postgres:17
```

## 1. Point the MJ CLI at it

Shell exports take precedence over `.env`, so nothing in the repo needs editing.
(Watch for a profile-level `DB_DATABASE` export overriding these — this machine's
profile is known to set one.)

```bash
export DB_PLATFORM=postgresql DB_HOST=localhost DB_PORT=5439 \
  DB_DATABASE=Committees_OneShot DB_USERNAME=mj_admin DB_PASSWORD=<pw> \
  CODEGEN_DB_USERNAME=mj_admin CODEGEN_DB_PASSWORD=<pw>
```

`CODEGEN_DB_*` is required even for migrate — the CLI opens its admin connection
with those credentials.

## 2. Platform install (the consumer's `mj migrate`)

```bash
npx mj migrate --tag v5.44.0        # expect: 61 applied on a virgin DB
```

Do **not** run plain `npx mj migrate` — without `--tag` it uses this repo's
local migrations directory (the app's own), not MJ core's. (The manifest floor
is `>=5.45.0` because the **SQL Server** Metadata_Sync calls a v5.45 core sproc;
the PG path validates on v5.44.0, which is what these files were baked against.)

## 3. Install both dependencies, in manifest order

```bash
PSQL="docker exec committees-pg-test psql -U mj_admin -d Committees_OneShot"

# --- bizapps-common (>= v5.32.0) ---
$PSQL -c 'CREATE SCHEMA IF NOT EXISTS __mj_bizappscommon;'
npx mj migrate --schema __mj_bizappscommon --dir <bizapps-common>/migrations-pg   # expect: 7 applied

# --- bizapps-tasks (>= v1.1.1) ---
$PSQL -c 'CREATE SCHEMA IF NOT EXISTS __mj_bizappstasks;'
$PSQL -c "UPDATE __mj.\"SchemaInfo\" SET \"CanonicalSchemaName\"='__mj_BizAppsTasks'
   WHERE LOWER(\"SchemaName\")=LOWER('__mj_bizappstasks');"   # expect UPDATE 0 on fresh
npx mj migrate --schema __mj_bizappstasks --dir <bizapps-tasks>/migrations-pg     # expect: 5 applied
```

(Those two are one-shot — do not run codegen for them.)

## 4. Committees — the one-shot install (`mj migrate` only)

```bash
# [Schema] HandleSchemaCreation
$PSQL -c 'CREATE SCHEMA IF NOT EXISTS __mj_bizappscommittees;'

# [Schema] PersistCanonicalSchemaName — expect "UPDATE 0" on a fresh install
# (the installer fires this before migrations create the SchemaInfo row; the
# CodeGen_Metadata_Backfill .pgonly migration sets CanonicalSchemaName itself)
$PSQL -c "UPDATE __mj.\"SchemaInfo\" SET \"CanonicalSchemaName\"='__mj_BizAppsCommittees'
   WHERE LOWER(\"SchemaName\")=LOWER('__mj_bizappscommittees');"

# [Migration] HandleMigrations — this repo's PG migrations from YOUR branch
npx mj migrate --schema __mj_bizappscommittees --dir ./migrations-pg
# expect: 5 applied — Baseline, Membership_RenewalIntent, Replace_ActionItems_With_Tasks,
# Metadata_Sync, and the CodeGen_Metadata_Backfill.pgonly supplement last
```

**Do not run codegen.** That is the point of the one-shot install.

## 5. Seed reference data (`mj sync push`)

Seed/lookup data ships in `metadata/`, not the migrations. Run from the
`metadata/` directory (the repo root fails with "no .mj-sync.json"; bare
`sync push` waits on a hidden prompt in non-TTY shells — use `--ci`):

```bash
cd metadata && npx mj sync push --ci     # expect: Created 27, Errors 0
```

| Directory | Target entity | Rows |
|---|---|---|
| committee-types | Committees: Types (app schema) | 5 |
| roles | Committees: Roles (app schema) | 8 |
| artifact-types | Committees: Artifact Types (app schema) | 9 |
| credential-types | MJ: Credential Types (`__mj`) | 1 (`Video Provider OAuth`) |
| file-storage-providers | MJ: File Storage Providers (`__mj`) | 1 (`External URL`) |
| prompts / agents | MJ core AI entities (`__mj`) | 1 prompt + 2 agent records (Committee Importer) |

## 6. Verify everything is there (validated 2026-07-22)

```sql
SELECT count(*) FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
 WHERE n.nspname = '__mj_bizappscommittees' AND p.proname LIKE 'sp%';          -- 48 (16 entities x create/update/delete)

SELECT count(*) FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
 WHERE n.nspname = '__mj_bizappscommittees' AND p.proname ILIKE 'fn%getrootid'; -- 3

SELECT count(*) FROM information_schema.views
 WHERE table_schema = '__mj_bizappscommittees';                                -- 16 (vw*)

SELECT count(*) FROM pg_trigger t JOIN pg_class c ON c.oid = t.tgrelid
 JOIN pg_namespace n ON n.oid = c.relnamespace
 WHERE NOT t.tgisinternal AND n.nspname = '__mj_bizappscommittees';            -- 16

SELECT count(*) FROM information_schema.tables
 WHERE table_schema='__mj_bizappscommittees' AND table_name='ActionItem';      -- 0 (dropped by Replace)

SELECT "CanonicalSchemaName" FROM __mj."SchemaInfo"
 WHERE LOWER("SchemaName") = '__mj_bizappscommittees';                         -- __mj_BizAppsCommittees

SELECT count(*) FROM __mj."Entity" WHERE "SchemaName" ILIKE '%committees%';    -- 16 (and 0 named '%____mj_%')

SELECT (SELECT count(*) FROM __mj_bizappscommittees."Type"),                   -- 5
       (SELECT count(*) FROM __mj_bizappscommittees."Role"),                   -- 8
       (SELECT count(*) FROM __mj_bizappscommittees."ArtifactType");           -- 9

-- CRUD round-trip through a baked function (psql spot-check)
SELECT "ID", "Name" FROM __mj_bizappscommittees."spCreateRole"(
  p_name := 'RunbookProbe', p_sequence := 999);
DELETE FROM __mj_bizappscommittees."Role" WHERE "Name" = 'RunbookProbe';
```

Then the two live proofs:

```bash
# Functional suite — seeded reference data, baked CRUD functions, FK-join views,
# the three recursive root-parent hierarchies, CHECK enforcement, cross-schema
# joins into bizapps-common (Person/Organization) and bizapps-tasks (Task), full
# CRUD round-trips. Self-cleaning. Connection via PGHOST/PGPORT/PGDATABASE/PGUSER/
# PGPASSWORD (defaults match this runbook's container).
node scripts/pg-objectmodel-test.mjs      # expect: RESULT: 25 passed, 0 failed

# MJAPI against it (same shell, exports still set)
npm run start:api                         # expect: PostgreSQL · Ready :4101
```

## 7. Prove codegen is a no-op (regression check)

This is the acceptance test for the bake — it confirms the migrations carry
exactly what CodeGen would generate.

```bash
# snapshot committees objects + __mj metadata, run codegen, snapshot again — diff must be empty
npx mj codegen        # (or --skipfiles to skip TS/build; only DB objects matter here)
```

CodeGen will rewrite this repo's generated TypeScript with PG-flavored doc
comments and drop run logs — restore/remove them; they are not part of the
install:

```bash
git checkout -- packages/GeneratedEntities packages/GeneratedActions
rm -rf temp_sql_scripts migrations/codegen/CodeGen_Run_<today>*.sql
```

Acceptance criterion: **no `__mj_bizappscommittees` object and no committees
`__mj` metadata row changes.** (First codegen on a virgin MJ core reconciles a
handful of *core* `__mj` rows — MJ core not shipping its own codegen metadata;
outside this repo's control, same as the siblings.)

## Recovery / retry

- **Preferred**: throw the container away and start over (`docker rm -f
  committees-pg-test`). Stage-1 migrations write app-entity metadata into `__mj`
  (Entity/EntityField/EntityRelationship rows), so dropping only the app schema
  leaves orphaned `__mj` rows that make a re-migrate fail (`duplicate key … PK_Entity`).
- Fast reset between test runs: `pg_dump -Fc` the core+deps base once, then
  `DROP DATABASE "Committees_OneShot"; CREATE DATABASE "Committees_OneShot";
  pg_restore` it (quote the mixed-case DB name).

## Things that look wrong but aren't

- **`sp*` count is 48, not 51**: the baseline bakes 17 entities (51 sprocs)
  including ActionItem; `Replace_ActionItems_With_Tasks` drops ActionItem's 3.
- **Objects are created twice across baseline + RenewalIntent**: RenewalIntent's
  baked section regenerates all entities (Membership now carrying RenewalIntent)
  via `CREATE OR REPLACE` — idempotent; the final definitions are what matter.
- **Flyway history schema casing**: pass the lowercase physical schema to
  `--schema`; a mixed-case value creates a quoted mixed-case history schema.

## Maintenance contract

The PG set is produced by a three-part pipeline; a schema change re-runs all of it:

1. **Converter + finalize** — `npm run mj:migrate:convert` runs
   `mj migrate convert` (legacy rule pipeline) over any *new* `migrations/*.sql`,
   then `node scripts/pg-finalize.mjs`. `pg-finalize` **skips files that already
   carry the baked marker** (it must never run over native CodeGen plpgsql — its
   FK-join-alias quoting corrupts native views). Existing `.pg.sql` files are
   never regenerated by convert.
2. **Bake CodeGen's native plpgsql** into each schema-affecting migration (this
   is what makes the install one-shot). The `--bake-codegen` command does not
   work for committees, so capture by hand:
   - Seed a live PG DB to the state **just before** the migration you're baking
     (for the baseline: core + deps, then migrate the baseline's hand-DDL only).
   - `mj codegen --skipfiles` — writes CodeGen's PG emission to
     `migrations/codegen/CodeGen_Run_<ts>.sql`.
   - Append that run-log verbatim, below the baked banner, into the migration's
     `.pg.sql`. (The baseline captures all entities; RenewalIntent is captured
     against a DB advanced by the RenewalIntent ADD COLUMN so Membership carries
     the new field.)
   - `V202607072300__…Replace_ActionItems_With_Tasks.pg.sql` is **hand-authored**
     (the converter mangles its DECLARE/THROW/CROSS APPLY/DELETE-JOIN and drops
     the DROP TABLE) — never delete it to reconvert; it drops ActionItem's baked
     objects, which is why the final sproc count is 48 not 51.
3. **`.pgonly` supplement** — `V202607211300__…CodeGen_Metadata_Backfill.pgonly.sql`
   pins `__mj` metadata baking does not cover (SchemaInfo `CanonicalSchemaName`,
   EntityField Sequence/width/name-map, the Ballots validator). Never regenerated,
   never touched by pg-finalize.

The **step-7 codegen no-op check is the regression test**: if codegen changes any
committees object or metadata row after a fresh install, a migration's baked
section is stale — re-bake it.

## Cleanup

```bash
docker rm -f committees-pg-test
```
