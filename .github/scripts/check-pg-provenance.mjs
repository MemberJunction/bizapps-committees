#!/usr/bin/env node
// ==============================================================================
// PostgreSQL migration counterpart & split-bake provenance guard
//
// Enforces two invariants on every PR that adds T-SQL or PostgreSQL migrations:
//   1. Every newly added `migrations/V<12digits>__*.sql` has a matching
//      `migrations-pg/<stem>.pg.sql` counterpart.
//   2. Every newly added `migrations-pg/V<12digits>__*.pg.sql` begins on line 1
//      with a valid deterministic provenance banner:
//        -- @mj-pg-provenance: split-bake v1 source=<file.sql> source-sha256=<64hex> mode=<baked|needs-hand-rebaked>
//      whose `source` matches `migrations/<file.sql>` and whose `source-sha256`
//      equals the exact SHA-256 of the T-SQL source file.
//
// Usage:
//   node .github/scripts/check-pg-provenance.mjs <base-ref> <head-ref>
//   node .github/scripts/check-pg-provenance.mjs --self-test
// ==============================================================================
import { execFileSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import { existsSync, mkdtempSync, mkdirSync, readFileSync, realpathSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { basename, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const PROVENANCE_RE =
  /^-- @mj-pg-provenance: split-bake v1 source=(V\d{12}__[^\s/]+\.sql) source-sha256=([0-9a-f]{64}) mode=(baked|needs-hand-rebaked)$/;
const TSQL_MIGRATION_RE = /^migrations\/(V\d{12}__[^/]+)\.sql$/;
const PG_MIGRATION_RE = /^migrations-pg\/(V\d{12}__[^/]+)\.pg\.sql$/;

export function Sha256File(filePath) {
  return createHash('sha256').update(readFileSync(filePath)).digest('hex');
}

export function ParseProvenanceLine(firstLine) {
  const clean = String(firstLine ?? '').replace(/^\uFEFF/, '').replace(/\r$/, '');
  const match = PROVENANCE_RE.exec(clean);
  if (!match) {
    return null;
  }
  return {
    source: match[1],
    sourceSha256: match[2],
    mode: match[3],
  };
}

/**
 * Pure repo validator operating on explicit lists of newly added T-SQL and PG migration paths
 * relative to `root`. Returns an array of error strings (empty when compliant).
 */
export function CheckAddedMigrations(root, addedTsqlPaths, addedPgPaths) {
  const problems = [];
  const checkedPg = new Set();

  for (const relTsql of addedTsqlPaths) {
    const m = TSQL_MIGRATION_RE.exec(relTsql);
    if (!m) continue;
    const stem = m[1];
    const expectedPg = `migrations-pg/${stem}.pg.sql`;
    const absPg = join(root, expectedPg);
    if (!existsSync(absPg)) {
      problems.push(`${relTsql}: missing PostgreSQL counterpart '${expectedPg}'. Generate via 'mj migrate convert --split --bake-codegen'.`);
      continue;
    }
    checkedPg.add(expectedPg);
  }

  for (const relPg of [...new Set([...addedPgPaths, ...checkedPg])]) {
    const m = PG_MIGRATION_RE.exec(relPg);
    if (!m) continue;
    const stem = m[1];
    const absPg = join(root, relPg);
    if (!existsSync(absPg)) {
      problems.push(`${relPg}: file not found on disk.`);
      continue;
    }
    const content = readFileSync(absPg, 'utf8');
    const firstLine = content.split('\n', 1)[0] ?? '';
    const parsed = ParseProvenanceLine(firstLine);
    if (!parsed) {
      problems.push(
        `${relPg}: line 1 must start with '-- @mj-pg-provenance: split-bake v1 source=<file.sql> source-sha256=<64hex> mode=<baked|needs-hand-rebaked>'.`,
      );
      continue;
    }
    const expectedSourceName = `${stem}.sql`;
    if (parsed.source !== expectedSourceName) {
      problems.push(
        `${relPg}: provenance source='${parsed.source}' does not match expected T-SQL file '${expectedSourceName}'.`,
      );
      continue;
    }
    const absTsql = join(root, 'migrations', expectedSourceName);
    if (!existsSync(absTsql)) {
      problems.push(`${relPg}: provenance source 'migrations/${expectedSourceName}' does not exist.`);
      continue;
    }
    const actualSha = Sha256File(absTsql);
    if (parsed.sourceSha256 !== actualSha) {
      problems.push(
        `${relPg}: provenance source-sha256=${parsed.sourceSha256} does not match migrations/${expectedSourceName} (${actualSha}). Re-run split-bake and re-stamp line 1.`,
      );
    }
  }

  return problems;
}

function gitAddedFiles(baseRef, headRef, pathspec, cwd) {
  const out = execFileSync(
    'git',
    ['diff', '--name-only', '--diff-filter=A', baseRef, headRef, '--', pathspec],
    { cwd, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] },
  );
  return out.split('\n').map((s) => s.trim()).filter(Boolean);
}

function runCheck(baseRef, headRef, cwd = process.cwd()) {
  const addedTsql = gitAddedFiles(baseRef, headRef, 'migrations/*.sql', cwd);
  const addedPg = gitAddedFiles(baseRef, headRef, 'migrations-pg/*.pg.sql', cwd);
  if (addedTsql.length === 0 && addedPg.length === 0) {
    console.log(`✓ No newly added migrations between ${baseRef} and ${headRef}`);
    return 0;
  }
  const problems = CheckAddedMigrations(cwd, addedTsql, addedPg);
  if (problems.length > 0) {
    for (const p of problems) {
      console.log(`::error::${p}`);
    }
    return 1;
  }
  console.log(
    `✓ Verified PostgreSQL counterpart & split-bake v1 provenance for ${Math.max(addedTsql.length, addedPg.length)} new migration(s)`,
  );
  return 0;
}

function selfTest() {
  const dir = mkdtempSync(join(tmpdir(), 'pg-provenance-'));
  let failed = 0;
  try {
    mkdirSync(join(dir, 'migrations'), { recursive: true });
    mkdirSync(join(dir, 'migrations-pg'), { recursive: true });

    const sqlRel = 'migrations/V202611260001__v6.3.x__Sample.sql';
    const pgRel = 'migrations-pg/V202611260001__v6.3.x__Sample.pg.sql';
    writeFileSync(join(dir, sqlRel), 'ALTER TABLE foo ADD bar INT NULL;\n');
    const sha = Sha256File(join(dir, sqlRel));

    const assertCase = (name, actualProblems, expectCount) => {
      const ok = actualProblems.length === expectCount;
      failed += ok ? 0 : 1;
      console.log(`${ok ? '✓' : '✗'} ${name}${ok ? '' : ` (got ${actualProblems.length}: ${actualProblems.join(' | ')})`}`);
    };

    // 1. Missing PG counterpart fails
    assertCase('missing .pg.sql counterpart fails', CheckAddedMigrations(dir, [sqlRel], []), 1);

    // 2. Valid provenance passes
    writeFileSync(
      join(dir, pgRel),
      `-- @mj-pg-provenance: split-bake v1 source=${basename(sqlRel)} source-sha256=${sha} mode=baked\nSELECT 1;\n`,
    );
    assertCase('matching counterpart with valid split-bake v1 SHA passes', CheckAddedMigrations(dir, [sqlRel], [pgRel]), 0);

    // 3. Stale SHA fails
    writeFileSync(
      join(dir, pgRel),
      `-- @mj-pg-provenance: split-bake v1 source=${basename(sqlRel)} source-sha256=${'0'.repeat(64)} mode=needs-hand-rebaked\nSELECT 1;\n`,
    );
    assertCase('mismatched source-sha256 fails', CheckAddedMigrations(dir, [sqlRel], [pgRel]), 1);

    // 4. Missing provenance header fails
    writeFileSync(join(dir, pgRel), '-- hand authored without provenance\nSELECT 1;\n');
    assertCase('missing split-bake provenance header fails', CheckAddedMigrations(dir, [sqlRel], [pgRel]), 1);
  } finally {
    rmSync(dir, { recursive: true, force: true });
  }
  console.log(failed === 0 ? '\ncheck-pg-provenance self-test passed' : `\ncheck-pg-provenance self-test FAILED (${failed})`);
  return failed === 0 ? 0 : 1;
}

if (process.argv[1] && realpathSync(process.argv[1]) === fileURLToPath(import.meta.url)) {
  const args = process.argv.slice(2);
  if (args[0] === '--self-test') {
    process.exit(selfTest());
  }
  if (args.length < 2) {
    console.error('usage: node .github/scripts/check-pg-provenance.mjs <base-ref> <head-ref>');
    process.exit(2);
  }
  process.exit(runCheck(args[0], args[1]));
}
