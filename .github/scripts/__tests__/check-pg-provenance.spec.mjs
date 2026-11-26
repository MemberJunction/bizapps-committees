import { test } from 'node:test';
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { mkdtempSync, mkdirSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { CheckAddedMigrations, ParseProvenanceLine, Sha256File } from '../check-pg-provenance.mjs';

const HERE = dirname(fileURLToPath(import.meta.url));
const SCRIPT = join(HERE, '..', 'check-pg-provenance.mjs');

test('ParseProvenanceLine parses valid baked and needs-hand-rebaked headers', () => {
  const sha = 'a'.repeat(64);
  const baked = ParseProvenanceLine(
    `-- @mj-pg-provenance: split-bake v1 source=V202611261400__v6.3.x__Test.sql source-sha256=${sha} mode=baked`,
  );
  assert.deepEqual(baked, {
    source: 'V202611261400__v6.3.x__Test.sql',
    sourceSha256: sha,
    mode: 'baked',
  });

  const rebaked = ParseProvenanceLine(
    `-- @mj-pg-provenance: split-bake v1 source=V202611261400__v6.3.x__Test.sql source-sha256=${sha} mode=needs-hand-rebaked\r`,
  );
  assert.equal(rebaked?.mode, 'needs-hand-rebaked');
  assert.equal(ParseProvenanceLine('-- random comment'), null);
});

test('CheckAddedMigrations enforces counterpart existence and exact SHA-256 provenance match', () => {
  const dir = mkdtempSync(join(tmpdir(), 'pg-prov-spec-'));
  try {
    mkdirSync(join(dir, 'migrations'), { recursive: true });
    mkdirSync(join(dir, 'migrations-pg'), { recursive: true });

    const sqlRel = 'migrations/V202611261400__v6.3.x__Demo.sql';
    const pgRel = 'migrations-pg/V202611261400__v6.3.x__Demo.pg.sql';
    writeFileSync(join(dir, sqlRel), 'SELECT 1;\n');
    const sha = Sha256File(join(dir, sqlRel));

    assert.equal(CheckAddedMigrations(dir, [sqlRel], []).length, 1);

    writeFileSync(
      join(dir, pgRel),
      `-- @mj-pg-provenance: split-bake v1 source=V202611261400__v6.3.x__Demo.sql source-sha256=${sha} mode=baked\nSELECT 1;\n`,
    );
    assert.deepEqual(CheckAddedMigrations(dir, [sqlRel], [pgRel]), []);

    writeFileSync(join(dir, sqlRel), 'SELECT 2;\n');
    const stale = CheckAddedMigrations(dir, [sqlRel], [pgRel]);
    assert.equal(stale.length, 1);
    assert.match(stale[0], /does not match/);
  } finally {
    rmSync(dir, { recursive: true, force: true });
  }
});

test('check-pg-provenance.mjs --self-test passes', () => {
  const res = spawnSync(process.execPath, [SCRIPT, '--self-test'], { encoding: 'utf8' });
  assert.equal(res.status, 0, res.stderr || res.stdout);
});
