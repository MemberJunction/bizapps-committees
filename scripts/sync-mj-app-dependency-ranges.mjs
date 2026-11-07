#!/usr/bin/env node
/**
 * Syncs each upstream Open App's `versionRange` in `mj-app.json` from the package dependency that
 * actually uses it.
 *
 * Runs in `version:prepare`, right after the shared ci/sync-mj-app-version.mjs, so the range
 * changes land inside the Version Packages PR. This is repo-specific (the shared script only syncs
 * `version` and `mjVersionRange`), and it replaces the step the old publish.yml ran before the
 * release-pipeline port. Each upstream app version-locks its packages as one fixed changesets
 * group, so its -entities version stands for the whole app.
 *
 * A missing source is an error, not a skip: a silent no-op leaves mj-app.json's ranges frozen at
 * whatever they last were while the release still goes green.
 */
import { readFileSync, writeFileSync } from 'node:fs';

const TARGET = 'mj-app.json';

// One row per upstream app: the mj-app.json dependency name, the package.json that declares the
// upstream, and the upstream package whose range is the source of truth.
const UPSTREAMS = [
  { app: 'mj-bizapps-tasks', source: 'packages/Angular/package.json', dep: '@mj-biz-apps/tasks-entities' },
  { app: 'mj-bizapps-common', source: 'packages/Core/package.json', dep: '@mj-biz-apps/common-entities' },
];

const escape = (v) => v.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
let raw = readFileSync(TARGET, 'utf8');
const manifest = JSON.parse(raw);

for (const { app, source, dep } of UPSTREAMS) {
  const pkg = JSON.parse(readFileSync(source, 'utf8'));
  const spec = pkg.dependencies?.[dep] ?? pkg.peerDependencies?.[dep];
  if (!spec) {
    console.error(`✗ could not derive the ${app} range: ${source} must declare ${dep}`);
    process.exit(1);
  }
  const min = spec.replace(/^[^0-9]*/, ''); // drop ^, ~, >=, … but keep any prerelease suffix
  const major = Number.parseInt(min.split('.')[0], 10);
  if (Number.isNaN(major)) {
    console.error(`✗ could not parse a major version from ${dep} "${spec}" in ${source}`);
    process.exit(1);
  }
  const next = `>=${min} <${major + 1}.0.0`;

  // Array-form dependencies: select the entry by name, never by object key.
  const entry = manifest.dependencies?.find((d) => d.name === app);
  if (!entry) {
    console.error(`✗ ${TARGET} has no dependency named "${app}"`);
    process.exit(1);
  }
  if (entry.versionRange === next) {
    console.log(`✓ ${TARGET} ${app} already "${next}"`);
    continue;
  }
  // Targeted rewrite inside that entry, so formatting and key order survive.
  const pattern = new RegExp(`("name"\\s*:\\s*"${escape(app)}"[^}]*?"versionRange"\\s*:\\s*)"${escape(entry.versionRange)}"`);
  if (!pattern.test(raw)) {
    console.error(`✗ could not locate ${app}'s "versionRange": "${entry.versionRange}" in ${TARGET}`);
    process.exit(1);
  }
  raw = raw.replace(pattern, `$1"${next}"`);
  console.log(`✓ ${TARGET} ${app} "${entry.versionRange}" -> "${next}"`);
}

writeFileSync(TARGET, raw);
