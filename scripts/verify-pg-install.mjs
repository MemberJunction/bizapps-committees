#!/usr/bin/env node
/**
 * verify-pg-install.mjs — generic, config-driven PostgreSQL install-verification harness for
 * MemberJunction OpenApps.
 *
 * WHY THIS EXISTS
 * ---------------
 * OpenApps ship a hand-baked `migrations-pg/` set carrying CodeGen's native plpgsql, so a consumer
 * gets a fully-working schema from `mj migrate` alone — WITHOUT ever running `mj codegen`. If a
 * schema change regenerates a CRUD function / view / trigger and that new definition is NOT captured
 * back into the PG migration, the one-shot install silently ships an incomplete/stale schema. That
 * class of bug is exactly what has forced repeated "fix PG again" releases.
 *
 * This harness turns the manual PG_INSTALL_VERIFICATION runbook into ONE reproducible command that
 * FAITHFULLY mirrors what MJ core's `mj app install` does to a Postgres database
 * (packages/OpenApp/Engine/src/install/*), then runs three gates of increasing strength:
 *
 *   Gate 1 — Structural invariants (generic, derived from the DB + __mj metadata):
 *            schema under canonical name; CanonicalSchemaName set + mixed-case; every app entity has
 *            exactly its base view + 3 CRUD functions + 1 update trigger; no case-duplicate entities.
 *   Gate 2 — Functional suite (app-owned): runs the app's own scripts/pg-objectmodel-test.mjs.
 *   Gate 3 — CodeGen no-op (the regression gate): snapshots every app-schema function/view/trigger
 *            DEFINITION plus the app's __mj metadata rows, runs `mj codegen`, snapshots again, and
 *            asserts the diff is EMPTY. A non-empty diff means a migration is missing CodeGen output.
 *
 * Everything app-specific is read from the app's `mj-app.json` — the SAME file drops into any
 * OpenApp repo unchanged. Nothing here touches MJ core; it lives entirely in the app repo (the
 * manual analog of what `appendOutputCode` does automatically for T-SQL).
 *
 * USAGE
 *   node scripts/verify-pg-install.mjs [--app <dir>] [options]
 *
 * COMMON RUN (throwaway container spun + torn down by the harness):
 *   node scripts/verify-pg-install.mjs --docker --core-tag v5.44.0 \
 *     --dep mj-bizapps-common=../bizapps-common --dep mj-bizapps-tasks=../bizapps-tasks
 *
 * AGAINST AN EXISTING DB (exports/env provide the connection):
 *   PGHOST=localhost PGPORT=5439 PGUSER=mj_admin PGPASSWORD=... PGDATABASE=App_OneShot \
 *     node scripts/verify-pg-install.mjs --core-tag v5.44.0 --dep ...
 *
 * OPTIONS
 *   --app <dir>            App repo under test (default: cwd). Must contain mj-app.json.
 *   --dep <name>=<path>    Local path for a dependency app (repeatable). Deps without a local path
 *                          are cloned from their manifest `repository` at --deps-ref.
 *   --deps-ref <ref>       Git ref/tag to clone missing deps at (default: next).
 *   --core-tag <vX.Y.Z>    MJ core migration tag for `mj migrate --tag`. Default: lower bound of the
 *                          app's mjVersionRange (`>=5.45.0` -> v5.45.0). See CAVEAT in the docs.
 *   --docker               Spin a throwaway postgres:17 container on PGPORT and tear it down at end.
 *   --docker-image <img>   Image for --docker (default: postgres:17).
 *   --keep                 Do not tear down container/DB (for debugging a failure).
 *   --skip-codegen-check   Skip Gate 3 (NOT recommended — it is the regression gate).
 *   --skip-functional      Skip Gate 2 (app's pg-objectmodel-test.mjs).
 *   --verbose              Stream all sub-command output.
 *
 * CONNECTION ENV (used for both the CLI and direct queries; --docker sets sane defaults):
 *   PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE
 *
 * EXIT CODE: 0 = all gates passed; non-zero = a gate failed (details printed).
 */
import { spawn } from 'node:child_process';
import { existsSync, readFileSync, writeFileSync, mkdtempSync, rmSync } from 'node:fs';
import { join, resolve, isAbsolute } from 'node:path';
import { tmpdir } from 'node:os';
import { createRequire } from 'node:module';

// ── tiny logger ──────────────────────────────────────────────────────────────
const C = { dim: '\x1b[2m', red: '\x1b[31m', grn: '\x1b[32m', yel: '\x1b[33m', cyn: '\x1b[36m', bld: '\x1b[1m', rst: '\x1b[0m' };
const log = (m = '') => console.log(m);
const info = (m) => console.log(`${C.cyn}›${C.rst} ${m}`);
const good = (m) => console.log(`  ${C.grn}✓${C.rst} ${m}`);
const bad = (m) => console.log(`  ${C.red}✗${C.rst} ${m}`);
const warn = (m) => console.log(`  ${C.yel}!${C.rst} ${m}`);
const section = (m) => console.log(`\n${C.bld}${C.cyn}══ ${m} ══${C.rst}`);

// ── CLI parsing ──────────────────────────────────────────────────────────────
function parseArgs(argv) {
  const opts = { app: process.cwd(), deps: {}, depsRef: 'next', docker: false, dockerImage: 'postgres:17', keep: false, skipCodegen: false, skipFunctional: false, noSeed: false, verbose: false, coreTag: null };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    const next = () => argv[++i];
    if (a === '--app') opts.app = resolve(next());
    else if (a === '--dep') { const [n, p] = next().split('='); opts.deps[n] = resolve(p); }
    else if (a === '--deps-ref') opts.depsRef = next();
    else if (a === '--core-tag') opts.coreTag = next();
    else if (a === '--docker') opts.docker = true;
    else if (a === '--docker-image') opts.dockerImage = next();
    else if (a === '--keep') opts.keep = true;
    else if (a === '--skip-codegen-check') opts.skipCodegen = true;
    else if (a === '--skip-functional') opts.skipFunctional = true;
    else if (a === '--no-seed') opts.noSeed = true;
    else if (a === '--verbose') opts.verbose = true;
    else if (a === '--help' || a === '-h') { printHelp(); process.exit(0); }
    else throw new Error(`Unknown argument: ${a}`);
  }
  return opts;
}
function printHelp() { log(readFileSync(new URL(import.meta.url)).toString().split('\n').filter((l) => l.startsWith(' *')).map((l) => l.slice(3)).join('\n')); }

// ── manifest / config helpers ────────────────────────────────────────────────
function loadManifest(appDir) {
  const p = join(appDir, 'mj-app.json');
  if (!existsSync(p)) throw new Error(`No mj-app.json in ${appDir}`);
  return JSON.parse(readFileSync(p, 'utf8'));
}
/** PG canonical (physical) schema name — MJ folds unquoted DDL to lowercase. Mirrors Dialect.CanonicalSchemaName. */
const canonicalSchema = (name) => name.toLowerCase();
/** Lower bound of a semver range like ">=5.45.0 <6.0.0" -> "v5.45.0". */
function coreTagFromRange(range) {
  const m = /(>=?)\s*v?(\d+\.\d+\.\d+)/.exec(range ?? '');
  return m ? `v${m[2]}` : null;
}
/** The real installer hardcodes Skyway BaselineVersion='1' + BaselineOnMigrate=true (migration-runner
 *  BuildSkywayConfig). `mj migrate` instead reads these from the app's mj.config.cjs, so a divergent
 *  config makes the harness's migrate step unfaithful. Best-effort text scan → warn (don't fail). */
function checkBaselineConfig(appDir) {
  const p = join(appDir, 'mj.config.cjs');
  if (!existsSync(p)) return;
  const txt = readFileSync(p, 'utf8');
  const bv = /baselineVersion\s*:\s*['"]?([^,'"\s}]+)/.exec(txt);
  const bom = /baselineOnMigrate\s*:\s*(false)\b/.exec(txt);
  if (bv && bv[1] !== '1') warn(`${p}: baselineVersion='${bv[1]}' — installer hardcodes '1'; migrate fidelity may differ`);
  if (bom) warn(`${p}: baselineOnMigrate=false — installer hardcodes true; the B-baseline may not run`);
}
/** Directory the installer uses on PG: <migrations.directory>-pg if present, else the base dir. */
function pgMigrationsDir(appDir, manifest) {
  const base = manifest.migrations?.directory ?? 'migrations';
  const pg = `${base.replace(/\/+$/, '')}-pg`;
  return existsSync(join(appDir, pg)) ? pg : base;
}

// ── shell / SQL runners ──────────────────────────────────────────────────────
function run(cmd, args, { cwd, env, verbose, capture = false } = {}) {
  return new Promise((res, rej) => {
    const child = spawn(cmd, args, { cwd, env: { ...process.env, ...env }, stdio: capture ? ['ignore', 'pipe', 'pipe'] : (verbose ? 'inherit' : ['ignore', 'pipe', 'pipe']) });
    let out = '', err = '';
    if (child.stdout) child.stdout.on('data', (d) => { out += d; if (verbose && !capture) process.stdout.write(d); });
    if (child.stderr) child.stderr.on('data', (d) => { err += d; if (verbose && !capture) process.stderr.write(d); });
    child.on('error', rej);
    child.on('close', (code) => (code === 0 ? res({ code, out, err }) : rej(Object.assign(new Error(`${cmd} ${args.join(' ')} exited ${code}\n${err || out}`), { code, out, err }))));
  });
}

// pg Pool is resolved from the app repo's own node_modules (every OpenApp depends on `pg` for its
// functional suite), so the harness needs no dependencies of its own.
function loadPgPool(appDir) {
  const req = createRequire(join(appDir, 'package.json'));
  try { return req('pg').Pool; }
  catch { throw new Error(`Could not load 'pg' from ${appDir}. Run 'npm install' in the app repo first.`); }
}

// Resolve the app-under-test's PINNED `mj` binary and use it for ALL apps (incl. auto-cloned deps that
// have no node_modules) — otherwise `npx mj` in a dep dir would download a different CLI version and
// break fidelity. Falls back to `npx mj` if the binary isn't present.
let MJ = { cmd: 'npx', pre: ['mj'] };
function resolveMj(appDir) {
  const bin = join(appDir, 'node_modules', '.bin', 'mj');
  if (existsSync(bin)) MJ = { cmd: bin, pre: [] };
}
const mjArgs = (...a) => [...MJ.pre, ...a];

// ── docker lifecycle ─────────────────────────────────────────────────────────
async function startContainer(opts, conn) {
  const name = `mjpg-verify-${conn.database.toLowerCase()}`;
  info(`Starting throwaway ${opts.dockerImage} container '${name}' on :${conn.port}`);
  await run('docker', ['rm', '-f', name], { verbose: false }).catch(() => {});
  await run('docker', ['run', '-d', '--name', name,
    '-e', `POSTGRES_USER=${conn.user}`, '-e', `POSTGRES_PASSWORD=${conn.password}`,
    '-e', `POSTGRES_DB=${conn.database}`, '-p', `${conn.port}:5432`, opts.dockerImage], { verbose: opts.verbose });
  // wait for readiness
  for (let i = 0; i < 60; i++) {
    try { await run('docker', ['exec', name, 'pg_isready', '-U', conn.user, '-d', conn.database]); good('Postgres ready'); return name; }
    catch { await new Promise((r) => setTimeout(r, 1000)); }
  }
  throw new Error('Postgres container did not become ready in 60s');
}
async function stopContainer(name) { if (name) await run('docker', ['rm', '-f', name]).catch(() => {}); }

// ── connection + CLI env ─────────────────────────────────────────────────────
function resolveConnection(opts) {
  const c = {
    host: process.env.PGHOST ?? 'localhost',
    port: +(process.env.PGPORT ?? (opts.docker ? 5439 : 5432)),
    user: process.env.PGUSER ?? 'mj_admin',
    password: process.env.PGPASSWORD ?? 'Verify99',
    database: process.env.PGDATABASE ?? 'OpenApp_OneShot',
  };
  return c;
}
/** Env the MJ CLI needs — shell exports take precedence over the repo's .env. */
function cliEnv(conn) {
  return {
    DB_PLATFORM: 'postgresql', DB_HOST: conn.host, DB_PORT: String(conn.port),
    DB_DATABASE: conn.database, DB_USERNAME: conn.user, DB_PASSWORD: conn.password,
    CODEGEN_DB_USERNAME: conn.user, CODEGEN_DB_PASSWORD: conn.password, DB_ENCRYPT: 'false',
    // also mirror PG_* so a repo that reads those is covered
    PGHOST: conn.host, PGPORT: String(conn.port), PGUSER: conn.user, PGPASSWORD: conn.password, PGDATABASE: conn.database,
  };
}

/** Normalize a manifest's `dependencies` (which is a z.union) to a uniform array of
 *  {name, repository, versionRange, subpath}. Handles all three shapes the manifest schema accepts:
 *  array form, record→object form, and record→string (version-only) form. Mirrors manifest-schema.ts. */
function normalizeDependencies(manifest) {
  const deps = manifest.dependencies;
  if (!deps) return [];
  if (Array.isArray(deps)) return deps.map((d) => ({ name: d.name, repository: d.repository, versionRange: d.versionRange, subpath: d.subpath }));
  return Object.entries(deps).map(([name, v]) =>
    typeof v === 'string'
      ? { name, repository: undefined, versionRange: v, subpath: undefined }
      : { name, repository: v.repository, versionRange: v.version, subpath: v.subpath });
}

// ── dependency graph (transitive, leaf-first, deduped) ───────────────────────
/** Returns an ordered list of {name, dir, manifest} — dependencies before dependents, each once. */
async function resolveDependencyChain(appDir, manifest, opts) {
  const ordered = [];
  const seen = new Set();
  const tmpClones = [];
  async function visit(dir, mani) {
    for (const dep of normalizeDependencies(mani)) {
      if (seen.has(dep.name)) continue;
      seen.add(dep.name);
      let depDir = opts.deps[dep.name];
      if (!depDir) {
        if (!dep.repository) throw new Error(`Dependency '${dep.name}' has no repository in the manifest — pass --dep ${dep.name}=<local path>`);
        // clone the dep from its manifest repository at --deps-ref
        const tmp = mkdtempSync(join(tmpdir(), `mjdep-${dep.name}-`));
        tmpClones.push(tmp);
        info(`Cloning dependency ${dep.name} (${dep.repository}@${opts.depsRef})`);
        await run('gh', ['repo', 'clone', dep.repository.replace(/^https:\/\/github.com\//, ''), tmp, '--', '--depth', '1', '--branch', opts.depsRef], { verbose: opts.verbose })
          .catch(() => run('git', ['clone', '--depth', '1', '--branch', opts.depsRef, dep.repository, tmp], { verbose: opts.verbose }));
        depDir = tmp;
      }
      const depMani = loadManifest(depDir);
      await visit(depDir, depMani);            // deps of the dep first (leaf-first)
      ordered.push({ name: dep.name, dir: depDir, manifest: depMani });
    }
  }
  await visit(appDir, manifest);
  return { ordered, tmpClones };
}

// ── SQL utilities ────────────────────────────────────────────────────────────
function makeSql(pool) {
  return {
    q: (sql, params) => pool.query(sql, params),
    one: async (sql, params) => (await pool.query(sql, params)).rows[0],
    count: async (sql, params) => +(await pool.query(sql, params)).rows[0].c,
  };
}
const escLit = (s) => s.replace(/'/g, "''");

// ── install simulation (mirrors packages/OpenApp/Engine/src/install/*) ────────
/** [Schema] CreateAppSchema — CREATE SCHEMA under the canonical (lowercased) name, exactly as the
 *  installer does (schema-manager.ts CreateAppSchema). The installer does NOTHING else here — it does
 *  NOT write SchemaInfo.CanonicalSchemaName (verified: no such write in the engine). That column is
 *  set by the app's OWN migration (e.g. committees' CodeGen_Metadata_Backfill.pgonly) — so the harness
 *  must NOT set it, or it would mask a missing/incorrect backfill that Gate 1 exists to catch. */
async function installSchema(sql, manifest) {
  const phys = canonicalSchema(manifest.schema.name);
  await sql.q(`CREATE SCHEMA IF NOT EXISTS ${JSON.stringify(phys)}`);
}
/** [Migration] HandleMigrations — Skyway against the app schema, PG dir. */
async function runMigrations(appDir, manifest, conn, opts) {
  const dir = pgMigrationsDir(appDir, manifest);
  const phys = canonicalSchema(manifest.schema.name);
  info(`migrate ${manifest.name} → schema ${phys} (dir ${dir})`);
  await run(MJ.cmd, mjArgs('migrate', '--schema', phys, '--dir', join(appDir, dir)), { cwd: appDir, env: cliEnv(conn), verbose: opts.verbose });
}
/** [Record] RecordInstallationAtomically analog — the __mj.OpenApp row, Status=Active.
 *  Guarded: a fresh core-migrated DB with no __mj.User row would violate the NOT-NULL
 *  InstalledByUserID, so we skip the (gate-irrelevant) audit row with a warning instead of aborting. */
async function recordOpenApp(sql, manifest) {
  const existing = await sql.count(`SELECT count(*) c FROM __mj."OpenApp" WHERE "Name"=$1`, [manifest.name]);
  if (existing > 0) return;
  const hasUser = await sql.count(`SELECT count(*) c FROM (SELECT "ID" FROM __mj."User" LIMIT 1) u`);
  if (hasUser === 0) { warn(`no __mj.User row — skipping OpenApp audit record for ${manifest.name} (not read by any gate)`); return; }
  await sql.q(
    `INSERT INTO __mj."OpenApp" ("ID","Name","DisplayName","Version","Publisher","RepositoryURL","MJVersionRange","ManifestJSON","SchemaName","InstalledByUserID","Status")
     SELECT gen_random_uuid(),$1,$2,$3,$4,$5,$6,$7,$8,(SELECT "ID" FROM __mj."User" LIMIT 1),'Active'`,
    [manifest.name, manifest.displayName ?? manifest.name, manifest.version, manifest.publisher?.name ?? 'Unknown',
     manifest.repository ?? '', manifest.mjVersionRange ?? '', '{}', manifest.schema.name],
  );
}

/** INSTALL one app exactly as `mj app install` does the DB steps: schema → migrate → record OpenApp.
 *  DELIBERATELY does NOT seed — the real installer never runs `mj sync push` (verified: no such step
 *  in InstallApp; the app's migrations carry any metadata DML). Seeding is a separate, explicit phase. */
async function migrateApp(appDir, manifest, conn, sql, opts) {
  await installSchema(sql, manifest);
  await runMigrations(appDir, manifest, conn, opts);
  await recordOpenApp(sql, manifest);
}

/** SEED phase — `mj sync push` for one app. Kept OUT of the install-fidelity path on purpose: the real
 *  `mj app install` does not seed via sync-push, so an app that relies on it (rather than baking seed
 *  DML into its migrations) is a deviation the harness surfaces, not hides. Gates 1 & 3 do not depend
 *  on this; only the functional suite (Gate 2) does. Returns 'seeded' | 'skipped' | throws. */
async function seedApp(appDir, manifest, conn, opts, { fatal = true } = {}) {
  const metaDir = join(appDir, manifest.metadata?.directory ?? 'metadata');
  if (!existsSync(join(metaDir, '.mj-sync.json'))) { return 'skipped'; }
  info(`sync push ${manifest.name} (${manifest.metadata?.directory ?? 'metadata'})`);
  try {
    const res = await run(MJ.cmd, mjArgs('sync', 'push', '--ci'), { cwd: metaDir, env: cliEnv(conn), verbose: opts.verbose, capture: !opts.verbose });
    const errs = /Errors\s+(\d+)/i.exec(res.out || res.err || '');
    if (errs && +errs[1] > 0) throw new Error(`sync push reported ${errs[1]} errors:\n${res.out}`);
    return 'seeded';
  } catch (e) {
    if (fatal) throw e;
    warn(`${manifest.name} sync push: ${String(e.message).slice(0, 160)} (non-fatal for a dependency)`);
    return 'error';
  }
}

// ── Gate 1: structural invariants (generic, derived) ─────────────────────────
async function gateStructural(sql, manifest) {
  section('Gate 1 · Structural invariants');
  const phys = canonicalSchema(manifest.schema.name);
  let ok = true;
  const pass = (m) => good(m);
  const fail = (m) => { bad(m); ok = false; };

  // schema exists under canonical name
  const schemaN = await sql.count(`SELECT count(*) c FROM information_schema.schemata WHERE schema_name=$1`, [phys]);
  schemaN === 1 ? pass(`schema '${phys}' exists`) : fail(`schema '${phys}' missing (found ${schemaN})`);

  // CanonicalSchemaName set + equals the manifest's mixed-case name
  const canon = await sql.one(`SELECT "CanonicalSchemaName" c FROM __mj."SchemaInfo" WHERE LOWER("SchemaName")=$1`, [phys]);
  canon?.c === manifest.schema.name
    ? pass(`SchemaInfo.CanonicalSchemaName = '${manifest.schema.name}'`)
    : fail(`SchemaInfo.CanonicalSchemaName = '${canon?.c ?? '(null)'}' (expected '${manifest.schema.name}')`);

  // app entities in __mj.Entity for this schema. SELECT * (not a fixed column list) so the harness is
  // robust across MJ core versions — e.g. BaseTableCodeName does not exist before ~v5.45. Absent
  // columns read as undefined and are defaulted below (VirtualEntity→false, Allow*API→enabled,
  // BaseTableCodeName→BaseTable). We use the columns CodeGen uses to decide WHICH objects it emits
  // (mirrors PostgreSQLCodeGenProvider.getCRUDRoutineName + Allow*API / VirtualEntity gating).
  const entities = (await sql.q(
    `SELECT * FROM __mj."Entity" WHERE LOWER("SchemaName")=$1 ORDER BY "Name"`, [phys],
  )).rows;
  entities.length > 0 ? pass(`${entities.length} app entities registered in __mj.Entity`) : fail(`no app entities registered for '${phys}'`);
  const physicalEntities = entities.filter((e) => !e.VirtualEntity);   // virtual entities have no base table / CRUD / trigger

  // no case-duplicate entities (the "0 lowercase dup" check, generalized)
  const byLower = new Map();
  for (const e of entities) { const k = (e.Name ?? '').toLowerCase(); byLower.set(k, (byLower.get(k) ?? 0) + 1); }
  const dups = [...byLower.entries()].filter(([, n]) => n > 1);
  dups.length === 0 ? pass('no case-duplicate entities') : fail(`case-duplicate entities: ${dups.map(([k]) => k).join(', ')}`);

  // ClassName leak check — only for NON-EMPTY names (ClassName is populated by CodeGen, so it can be
  // legitimately empty right after a migrate-only install; empty ≠ a lowercase/dunder leak).
  const named = entities.filter((e) => (e.ClassName ?? '').trim() !== '');
  const badClass = named.filter((e) => /____mj_/i.test(e.ClassName) || (/[a-z]/.test(e.ClassName) && e.ClassName === e.ClassName.toLowerCase()));
  if (named.length === 0) info('entity ClassNames are empty (populated by CodeGen — expected after migrate-only)');
  else badClass.length === 0 ? pass(`entity ClassNames look correct (${named.length} populated)`) : fail(`suspect ClassNames: ${badClass.map((e) => e.ClassName).join(', ')}`);

  // per-entity: base view + the CRUD functions the entity's Allow*API flags actually enable + 1 update
  // trigger. Only physical (non-virtual) entities have a base table/CRUD/trigger. Function names match
  // CodeGen: custom override column (spCreate/spUpdate/spDelete) when set, else `sp<Verb><BaseTableCodeName>`.
  let missView = 0, missSp = 0, missTrg = 0, expectSp = 0;
  const fnExists = async (name) => (await sql.count(
    `SELECT count(*) c FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace WHERE n.nspname=$1 AND p.proname=$2`, [phys, name])) >= 1;
  for (const e of physicalEntities) {
    const code = e.BaseTableCodeName || (e.BaseTable ?? e.Name).replace(/\s+/g, '');
    if (e.BaseView) {
      const vN = await sql.count(`SELECT count(*) c FROM information_schema.views WHERE table_schema=$1 AND table_name=$2`, [phys, e.BaseView]);
      if (vN !== 1) { missView++; warn(`missing base view ${phys}.${e.BaseView} (entity ${e.Name})`); }
    }
    for (const [flag, verb, override] of [['AllowCreateAPI', 'spCreate', e.spCreate], ['AllowUpdateAPI', 'spUpdate', e.spUpdate], ['AllowDeleteAPI', 'spDelete', e.spDelete]]) {
      if (e[flag] === false || e[flag] === 0) continue;        // skip only when the flag EXPLICITLY disables it (absent column ⇒ enabled)
      expectSp++;
      const name = override || `${verb}${code}`;               // honor a custom SP-override column
      if (!(await fnExists(name))) { missSp++; warn(`missing function ${phys}.${name} (entity ${e.Name})`); }
    }
    const t = e.BaseTable || code;
    const trN = await sql.count(
      `SELECT count(*) c FROM pg_trigger tr JOIN pg_class c ON c.oid=tr.tgrelid JOIN pg_namespace n ON n.oid=c.relnamespace
       WHERE NOT tr.tgisinternal AND n.nspname=$1 AND c.relname=$2`, [phys, t]);
    if (trN < 1) { missTrg++; warn(`missing update trigger on ${phys}.${t}`); }
  }
  missView === 0 ? pass(`every physical entity has its base view (${physicalEntities.length})`) : fail(`${missView} entities missing a base view`);
  missSp === 0 ? pass(`every Allow*API-enabled entity has its CRUD function(s) (${expectSp} expected)`) : fail(`${missSp} of ${expectSp} CRUD functions missing`);
  missTrg === 0 ? pass(`every physical entity table has an update trigger`) : fail(`${missTrg} update triggers missing`);
  if (entities.length !== physicalEntities.length) info(`(${entities.length - physicalEntities.length} virtual entities skipped for CRUD/trigger checks)`);

  return ok;
}

// ── Gate 2: functional suite (app-owned) ─────────────────────────────────────
async function gateFunctional(appDir, conn, opts) {
  section('Gate 2 · Functional suite (pg-objectmodel-test.mjs)');
  const suite = join(appDir, 'scripts', 'pg-objectmodel-test.mjs');
  if (!existsSync(suite)) { warn('no scripts/pg-objectmodel-test.mjs — skipping'); return true; }
  // capture (not inherit) so we can parse the RESULT line; echo it when --verbose.
  const parseResult = (out) => {
    const m = /RESULT:\s+(\d+)\s+passed,\s+(\d+)\s+failed/i.exec(out || '');
    return m ? { passed: +m[1], failed: +m[2] } : null;
  };
  try {
    const res = await run('node', [suite], { cwd: appDir, env: cliEnv(conn), capture: true });
    if (opts.verbose) process.stdout.write(res.out);
    const r = parseResult(res.out);
    if (r && r.failed === 0) { good(`functional suite: ${r.passed} passed, 0 failed`); return true; }
    bad(`functional suite failed${r ? `: ${r.passed} passed, ${r.failed} failed` : ' (no RESULT line found)'}`); return false;
  } catch (e) {
    const r = parseResult(String(e.out ?? '') + String(e.err ?? ''));   // suite exits 1 on failure — still parse its RESULT
    bad(`functional suite failed${r ? `: ${r.passed} passed, ${r.failed} failed` : `: ${String(e.message).slice(0, 200)}`}`); return false;
  }
}

// ── Gate 3: CodeGen no-op (the regression gate) ──────────────────────────────
/** Snapshot every app-schema DDL object DEFINITION + the app's __mj metadata rows (volatile cols
 *  excluded). Covers what CodeGen emits: functions, views, triggers, table columns, constraints
 *  (CHECK/UNIQUE/FK/PK), indexes (incl. IDX_AUTO_MJ_FKEY_*), and GRANTs — so a bake that missed ANY of
 *  those is caught, not just functions/views/triggers. */
async function snapshotSchema(sql, phys) {
  const objects = (await sql.q(
    `SELECT 'function' kind, p.proname name, pg_get_functiondef(p.oid) def
       FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace WHERE n.nspname=$1
     UNION ALL
     SELECT 'view', c.relname, pg_get_viewdef(c.oid, true)
       FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname=$1 AND c.relkind='v'
     UNION ALL
     SELECT 'trigger', c.relname||'.'||tr.tgname, pg_get_triggerdef(tr.oid)
       FROM pg_trigger tr JOIN pg_class c ON c.oid=tr.tgrelid JOIN pg_namespace n ON n.oid=c.relnamespace
       WHERE NOT tr.tgisinternal AND n.nspname=$1
     UNION ALL
     SELECT 'column', table_name||'.'||column_name,
            data_type||' null='||is_nullable||' default='||COALESCE(column_default,'')||' len='||COALESCE(character_maximum_length::text,'')
       FROM information_schema.columns WHERE table_schema=$1
     UNION ALL
     SELECT 'constraint', c.conrelid::regclass::text||'.'||c.conname, pg_get_constraintdef(c.oid)
       FROM pg_constraint c JOIN pg_namespace n ON n.oid=c.connamespace WHERE n.nspname=$1
     UNION ALL
     SELECT 'index', indexname, indexdef FROM pg_indexes WHERE schemaname=$1
     UNION ALL
     SELECT 'grant', grantee||':'||privilege_type||':'||table_name, 'table'
       FROM information_schema.role_table_grants WHERE table_schema=$1
     UNION ALL
     SELECT 'grant', grantee||':'||privilege_type||':'||routine_name, 'routine'
       FROM information_schema.role_routine_grants WHERE routine_schema=$1
     ORDER BY 1,2`, [phys])).rows;

  // App __mj metadata rows — semantic columns only (exclude volatile timestamps), scoped to THIS
  // schema's entities so core __mj reconciliation noise is excluded. EntityPermission included
  // because CodeGen generates those rows too (a missing permission bake would otherwise be invisible).
  const meta = {};
  meta.Entity = (await sql.q(`SELECT * FROM __mj."Entity" WHERE LOWER("SchemaName")=$1 ORDER BY "Name"`, [phys])).rows.map(stripVolatile);
  for (const entity of ['EntityField', 'EntityRelationship', 'EntityPermission']) {
    meta[entity] = (await sql.q(
      `SELECT ef.* FROM __mj."${entity}" ef JOIN __mj."Entity" e ON e."ID"=ef."EntityID" WHERE LOWER(e."SchemaName")=$1 ORDER BY ef."ID"`, [phys])).rows.map(stripVolatile);
  }
  meta.EntityFieldValue = (await sql.q(
    `SELECT v.* FROM __mj."EntityFieldValue" v JOIN __mj."EntityField" f ON f."ID"=v."EntityFieldID"
       JOIN __mj."Entity" e ON e."ID"=f."EntityID" WHERE LOWER(e."SchemaName")=$1 ORDER BY v."ID"`, [phys])).rows.map(stripVolatile);
  return { objects, meta };
}
function stripVolatile(row) { const { __mj_CreatedAt, __mj_UpdatedAt, ...rest } = row; return rest; }

/** Temporarily flip `enableAdvancedGeneration: true` → false in the app's mj.config.cjs for the codegen
 *  run, returning a restore fn. No-op (returns a no-op restore) if the file/flag isn't present. */
function withAdvancedGenDisabled(appDir) {
  const p = join(appDir, 'mj.config.cjs');
  if (!existsSync(p)) return () => {};
  const orig = readFileSync(p, 'utf8');
  if (!/enableAdvancedGeneration\s*:\s*true/.test(orig)) return () => {};
  writeFileSync(p, orig.replace(/enableAdvancedGeneration\s*:\s*true/, 'enableAdvancedGeneration: false'));
  return () => writeFileSync(p, orig);
}

async function gateCodegenNoop(appDir, manifest, conn, sql, opts) {
  section('Gate 3 · CodeGen no-op (regression gate)');
  const phys = canonicalSchema(manifest.schema.name);
  const before = await snapshotSchema(sql, phys);
  // Vacuity guard — an empty snapshot means the app schema has no objects (e.g. it wasn't in
  // codegen's config scope), so an "empty diff" would be a false PASS. Refuse to certify.
  if (before.objects.length === 0) { bad(`no objects found in schema '${phys}' — cannot verify (is it in mj codegen's scope?)`); return false; }
  const dirtyBefore = await gitDirtySet(appDir);   // preserve pre-existing uncommitted work
  // Advanced generation is LLM-driven AI enrichment (entity-name prettifying, check-constraint
  // parsing). It is irrelevant to the DDL/metadata no-op contract and REQUIRES API credentials —
  // keyless it aborts codegen entirely (the connector-test convention: run codegen advancedGen-OFF).
  // Temporarily disable it for this run (backup/restore mj.config.cjs), so Gate 3 tests the bake, not AI.
  const restoreCfg = withAdvancedGenDisabled(appDir);
  info('running `mj codegen` (advancedGen disabled; must be a no-op for app-schema objects + app __mj metadata)…');
  let codegenError = null;
  try {
    await run(MJ.cmd, mjArgs('codegen'), { cwd: appDir, env: cliEnv(conn), capture: true });
  } catch (e) {
    codegenError = `${e.out ?? ''}\n${e.err ?? ''}\n${e.message ?? ''}`;
  } finally {
    restoreCfg();
  }
  // If codegen ABORTED, classify: does the failure implicate an APP object, or is it a pre-existing
  // CORE issue (e.g. entityFieldsSequenceCheck on MJ: * entities from core-version skew)? A core-only
  // abort is BLOCKED — the harness can't certify the no-op, but it is NOT an app regression.
  if (codegenError) {
    await cleanupCodegenArtifacts(appDir, dirtyBefore, opts);
    const appEntities = (await sql.q(`SELECT "Name" FROM __mj."Entity" WHERE LOWER("SchemaName")=$1`, [phys])).rows.map((r) => r.Name).filter(Boolean);
    // Classify on WHAT FAILED, not what's mentioned — codegen's normal output always names the app
    // schema (it processes it). Extract the entities named in integrity/error lines only.
    const errLines = codegenError.split('\n').map((l) => l.trim())
      .filter((l) => /(integrity|sequence number|FAILED|error|missing|duplicate|not assignable)/i.test(l) && !/Starting|Initializing|connection/i.test(l));
    const failingEntities = [...codegenError.matchAll(/Entity\s+(.+?)\s+has a missing sequence/gi)].map((m) => m[1].trim());
    const implicatesApp = failingEntities.length
      ? failingEntities.some((n) => appEntities.includes(n))                         // known failure shape → precise attribution
      : appEntities.some((n) => new RegExp(`\\b${n.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\b`).test(codegenError)) && errLines.some((l) => appEntities.some((n) => l.includes(n)));
    const excerpt = (errLines.length ? errLines : codegenError.split('\n').map((l) => l.trim()).filter(Boolean)).slice(0, 5).join('\n      ');
    if (implicatesApp) { bad(`mj codegen failed AND an app entity failed the integrity check — real regression:`); log(`      ${C.yel}${excerpt}${C.rst}`); return false; }
    const coreCount = failingEntities.length;
    warn(`mj codegen aborted on a CORE integrity issue unrelated to '${manifest.name}'${coreCount ? ` (${coreCount} core entities, 0 app entities)` : ''}:`);
    log(`      ${C.dim}${excerpt}${C.rst}`);
    warn(`Gate 3 BLOCKED — core-version skew (the runbook's "core reconciliation is outside this repo's control").`);
    warn(`To certify the no-op, align --core-tag / the app's @memberjunction/cli so core codegen runs clean.`);
    return 'blocked';
  }
  const after = await snapshotSchema(sql, phys);

  const diffs = diffSnapshots(before, after);
  // Restore ONLY the files CodeGen itself churned (TS doc-comments, run logs, temp_sql_scripts) —
  // never files the user had already modified before this run.
  await cleanupCodegenArtifacts(appDir, dirtyBefore, opts);

  if (diffs.length === 0) { good('CodeGen changed NOTHING in the app schema or app metadata — one-shot bake is complete'); return true; }
  bad(`CodeGen changed ${diffs.length} item(s) — a PG migration is MISSING codegen output:`);
  for (const d of diffs.slice(0, 40)) log(`      ${C.yel}${d}${C.rst}`);
  if (diffs.length > 40) log(`      … and ${diffs.length - 40} more`);
  return false;
}
function diffSnapshots(a, b) {
  const out = [];
  const objIndex = (s) => new Map(s.objects.map((o) => [`${o.kind}:${o.name}`, o.def]));
  const [ai, bi] = [objIndex(a), objIndex(b)];
  for (const [k, def] of bi) { if (!ai.has(k)) out.push(`+ object ${k} (added by codegen)`); else if (ai.get(k) !== def) out.push(`~ object ${k} (definition changed)`); }
  for (const k of ai.keys()) if (!bi.has(k)) out.push(`- object ${k} (removed by codegen)`);
  for (const ent of Object.keys(b.meta)) {
    const [as, bs] = [JSON.stringify(a.meta[ent] ?? []), JSON.stringify(b.meta[ent] ?? [])];
    if (as !== bs) {
      const [an, bn] = [(a.meta[ent] ?? []).length, (b.meta[ent] ?? []).length];
      out.push(bn !== an ? `~ __mj.${ent} row count ${an} → ${bn}` : `~ __mj.${ent} row content changed (${bn} rows)`);
    }
  }
  return out;
}
/** Parse `git status --porcelain` into a Map<path, statusCode>; {} when not a git repo. */
async function gitDirtySet(appDir) {
  if (!existsSync(join(appDir, '.git'))) return null;
  const res = await run('git', ['status', '--porcelain'], { cwd: appDir, capture: true }).catch(() => ({ out: '' }));
  const m = new Map();
  for (const line of res.out.split('\n')) { const s = line.slice(0, 2), p = line.slice(3).trim(); if (p) m.set(p, s); }
  return m;
}
/** Revert ONLY paths CodeGen dirtied this run (not in dirtyBefore). Tracked → git checkout; untracked → rm. */
async function cleanupCodegenArtifacts(appDir, dirtyBefore, opts) {
  if (dirtyBefore === null) { // not a git repo — best-effort scratch cleanup only
    rmSync(join(appDir, 'temp_sql_scripts'), { recursive: true, force: true });
    return;
  }
  // Only ever touch known CodeGen output — never an arbitrary file, even if codegen somehow dirtied it.
  const isCodegenOutput = (p) => /generated|temp_sql_scripts|codegen_run|schema\.graphql/i.test(p);
  const dirtyAfter = await gitDirtySet(appDir);
  const toCheckout = [], toRemove = [];
  for (const [p, code] of dirtyAfter) {
    if (dirtyBefore.has(p)) continue;         // user already had this dirty — leave it alone
    if (p.includes(' -> ')) continue;         // rename entry — never auto-revert (safety)
    if (!isCodegenOutput(p)) { warn(`codegen dirtied a non-generated file, leaving it: ${p}`); continue; }
    if (code.includes('?')) toRemove.push(p); // newly untracked (run logs, temp_sql_scripts)
    else toCheckout.push(p);                  // newly modified tracked file (generated TS)
  }
  if (toCheckout.length) await run('git', ['checkout', '--', ...toCheckout], { cwd: appDir }).catch(() => {});
  for (const p of toRemove) rmSync(isAbsolute(p) ? p : join(appDir, p), { recursive: true, force: true });
  if (opts.verbose) warn(`restored ${toCheckout.length} codegen-churned file(s), removed ${toRemove.length} scratch file(s)`);
}

// ── main ─────────────────────────────────────────────────────────────────────
async function main() {
  const opts = parseArgs(process.argv.slice(2));
  const manifest = loadManifest(opts.app);
  const coreTag = opts.coreTag ?? coreTagFromRange(manifest.mjVersionRange);
  if (!coreTag) throw new Error('Could not determine --core-tag (no lower bound in mjVersionRange).');

  section(`OpenApp PG install verification · ${manifest.name} v${manifest.version}`);
  info(`app dir      : ${opts.app}`);
  info(`schema       : ${manifest.schema.name} (physical: ${canonicalSchema(manifest.schema.name)})`);
  info(`MJ core tag  : ${coreTag}   (manifest floor: ${manifest.mjVersionRange})`);
  resolveMj(opts.app);
  info(`mj binary    : ${MJ.cmd === 'npx' ? 'npx mj (not pinned — run npm install in the app repo)' : MJ.cmd}`);
  checkBaselineConfig(opts.app);

  const conn = resolveConnection(opts);
  const Pool = loadPgPool(opts.app);
  let container = null, pool = null;
  const results = {};
  let tmpClones = [];

  try {
    if (opts.docker) container = await startContainer(opts, conn);
    pool = new Pool(conn);
    const sql = makeSql(pool);

    // Step 2 — Platform install (consumer's `mj migrate --tag`)
    section('MJ core platform install');
    info(`mj migrate --tag ${coreTag}`);
    await run(MJ.cmd, mjArgs('migrate', '--tag', coreTag), { cwd: opts.app, env: cliEnv(conn), verbose: opts.verbose });
    good('core migrations applied');

    // Steps 4-5 — transitive dependency chain, leaf-first (migrate-only, NO seed)
    section('Dependency chain (migrate-only)');
    const chain = await resolveDependencyChain(opts.app, manifest, opts);
    tmpClones = chain.tmpClones;
    if (chain.ordered.length === 0) info('(no dependencies)');
    for (const dep of chain.ordered) {
      section(`Dependency · ${dep.name}`);
      await migrateApp(dep.dir, dep.manifest, conn, sql, opts);
      good(`${dep.name} migrated`);
    }

    // Steps 6-9 — app-under-test one-shot install: schema → migrate → record. NO seed, NO codegen.
    // This is the pure `mj app install` DB state — exactly what a consumer gets.
    section(`App install · ${manifest.name} (one-shot: migrate only, no codegen, no sync-push)`);
    await migrateApp(opts.app, manifest, conn, sql, opts);
    good('app installed (migrate-only)');

    // Gate 1 — structural invariants on the PURE one-shot state (does not depend on seed data).
    results.structural = await gateStructural(sql, manifest);

    // Seed phase — EXPLICIT and separate from install. The real `mj app install` does NOT run
    // `mj sync push`; an app that needs it (rather than baking seed DML into its migrations) must
    // document that step. Only the functional suite depends on it.
    if (!opts.noSeed) {
      section('Reference-data seeding (mj sync push — NOT part of `mj app install`)');
      warn('The real `mj app install` does NOT sync-push. If a table is empty without this step,');
      warn('the app must bake seed DML into its migrations or document `mj sync push` post-install.');
      const seededApp = await seedApp(opts.app, manifest, conn, opts, { fatal: true });
      for (const dep of chain.ordered) await seedApp(dep.dir, dep.manifest, conn, opts, { fatal: false });
      results.seedSource = seededApp === 'seeded' ? 'sync-push (deviation from pure one-shot)' : 'migrations only (no metadata dir)';
      good(`app reference data: ${results.seedSource}`);
    } else {
      info('--no-seed: skipping sync-push; functional suite will reflect migration-only seed state');
    }

    // Gate 2 — functional suite (needs seed data). Run BEFORE Gate 3, which mutates via codegen.
    results.functional = opts.skipFunctional ? null : await gateFunctional(opts.app, conn, opts);

    // Gate 3 — codegen no-op (mutating; run last).
    results.codegen = opts.skipCodegen ? null : await gateCodegenNoop(opts.app, manifest, conn, sql, opts);
  } finally {
    if (pool) await pool.end().catch(() => {});
    for (const t of tmpClones) rmSync(t, { recursive: true, force: true });
    if (container && !opts.keep) await stopContainer(container);
    else if (container) warn(`container '${container}' left running (--keep)`);
  }

  // Summary
  section('Summary');
  const render = (v) => v === null ? `${C.dim}skipped${C.rst}` : v === 'blocked' ? `${C.yel}BLOCKED${C.rst}` : v ? `${C.grn}PASS${C.rst}` : `${C.red}FAIL${C.rst}`;
  const line = (name, v) => log(`  ${render(v)}  ${name}`);
  line('Gate 1 · structural invariants', results.structural);
  line('Gate 2 · functional suite', results.functional);
  line('Gate 3 · codegen no-op (regression)', results.codegen);
  const failed = Object.values(results).some((v) => v === false);
  const blocked = Object.values(results).some((v) => v === 'blocked');
  log('');
  if (failed) { log(`${C.red}${C.bld}VERIFICATION FAILED${C.rst}`); process.exit(1); }
  if (blocked) {
    log(`${C.yel}${C.bld}VERIFICATION INCOMPLETE${C.rst} — ${manifest.name} INSTALLS + RUNS on PostgreSQL, but the`);
    log(`codegen-no-op regression gate was BLOCKED by a core-version issue (see above). Not an app failure.`);
    process.exit(2);
  }
  log(`${C.grn}${C.bld}VERIFICATION PASSED${C.rst} — ${manifest.name} installs and runs on PostgreSQL with no codegen`);
}

main().catch((e) => { log(`\n${C.red}${C.bld}FATAL:${C.rst} ${e.message}`); process.exit(1); });
