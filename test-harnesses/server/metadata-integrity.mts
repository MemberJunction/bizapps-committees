/**
 * metadata-integrity.ts — the CodeGen guard. Run after EVERY codegen pass.
 *
 * Exists because of the 2026-07-06 incident: a codegen run regenerated views
 * with new denormalized name columns but failed to register the matching
 * EntityField rows, so every entity Load() threw "Field X does not exist"
 * (BaseEntity.SetMany). Three codegen runs to converge; a full day lost.
 * This harness turns that entire failure class into a 10-second check.
 *
 *   M1  View↔metadata drift: every column of every committees base view has an
 *       EntityField row (the exact query from the baseline's splice-point note)
 *   M2  Entity loads survive: for each committees entity that has rows, load
 *       the first record through the REAL entity class — SetMany validates
 *       every returned view column against metadata
 *   M3  Applications: exactly the two pre-created apps (Committees /
 *       Committee Management), no schema-named app, 16 entities attached each
 *   M4  Permissions: every committees entity has EntityPermission rows
 *       (codegen creates them; missing rows = broken API access)
 *
 * Read-only — creates nothing, tears down nothing.
 *
 * USAGE (from repo root):  npx tsx test-harnesses/server/metadata-integrity.ts
 * Exit code: 0 = all passed, 1 = failures, 2 = bootstrap error.
 */
import { Metadata, RunView } from '@memberjunction/core';
import { bootstrap, test, assert, summary, SCHEMA, HarnessCtx } from './bootstrap.mjs';
import { finishAndExit } from './harness-exit.mjs';

const EXPECTED_ENTITY_COUNT = 16;
const APP_MEMBER = 'Committees';
const APP_STAFF = 'Committee Management';

async function main(): Promise<void> {
    let ctx: HarnessCtx;
    try {
        ctx = await bootstrap();
    } catch (e) {
        console.error('BOOTSTRAP ERROR:', e instanceof Error ? e.message : String(e));
        process.exit(2);
    }
    const { pool, user } = ctx;
    console.log(`\n══════ Metadata integrity — db=${process.env.DB_DATABASE} user=${user.Email} ══════\n`);

    // ─── M1: view ↔ metadata drift ──────────────────────────────
    await test('M1 zero view↔EntityField drift across all committees entities', async () => {
        const r = await pool.request().query(`
            SELECT e.Name AS EntityName, c.COLUMN_NAME AS ColumnName
            FROM __mj.Entity e
            JOIN INFORMATION_SCHEMA.COLUMNS c ON c.TABLE_NAME = e.BaseView AND c.TABLE_SCHEMA = e.SchemaName
            LEFT JOIN __mj.EntityField ef ON ef.EntityID = e.ID AND ef.Name = c.COLUMN_NAME
            WHERE e.SchemaName = '${SCHEMA}' AND ef.ID IS NULL`);
        const drift = r.recordset.map(x => `${x.EntityName}.${x.ColumnName}`);
        assert(drift.length === 0, `Unregistered view columns (codegen drift): ${drift.join(', ')}`);
    });

    // ─── M2: every entity with data survives a real Load() ─────
    const md = new Metadata();
    const committeeEntities = md.Entities.filter(e => e.SchemaName === SCHEMA);
    await test(`M2.0 metadata knows ${EXPECTED_ENTITY_COUNT} committees entities`, async () => {
        assert(committeeEntities.length === EXPECTED_ENTITY_COUNT,
            `expected ${EXPECTED_ENTITY_COUNT}, metadata has ${committeeEntities.length}: ${committeeEntities.map(e => e.Name).join(', ')}`);
    });

    for (const entityInfo of committeeEntities) {
        await test(`M2 Load() survives: ${entityInfo.Name}`, async () => {
            const rv = new RunView();
            const first = await rv.RunView<{ ID: string }>({
                EntityName: entityInfo.Name, Fields: ['ID'], MaxRows: 1, ResultType: 'simple',
            }, user);
            assert(first.Success, `RunView failed: ${first.ErrorMessage}`);
            if (first.Results.length === 0) return; // empty table: nothing to load, still a pass
            const entity = await md.GetEntityObject(entityInfo.Name, user);
            const ok = await entity.Load(first.Results[0].ID);
            // A drift failure throws inside SetMany before Load returns — but check the flag too.
            assert(ok, `Load() returned false: ${entity.LatestResult?.Message ?? 'unknown'}`);
        });
    }

    // ─── M3: applications ───────────────────────────────────────
    await test('M3.1 exactly the two pre-created apps claim the schema', async () => {
        const r = await pool.request().query(`
            SELECT Name FROM __mj.Application
            WHERE SchemaAutoAddNewEntities LIKE '%${SCHEMA}%'`);
        const names = new Set<string>(r.recordset.map(x => x.Name));
        assert(names.size === 2 && names.has(APP_MEMBER) && names.has(APP_STAFF),
            `expected {${APP_MEMBER}, ${APP_STAFF}}, got {${[...names].join(', ')}}`);
    });

    await test('M3.2 no schema-named app exists', async () => {
        const r = await pool.request().query(`
            SELECT COUNT(*) AS n FROM __mj.Application WHERE Name = '${SCHEMA}'`);
        assert(r.recordset[0].n === 0, 'codegen auto-created a schema-named app — pre-created apps did not claim the schema');
    });

    await test(`M3.3 both apps hold all ${EXPECTED_ENTITY_COUNT} entities`, async () => {
        const r = await pool.request().query(`
            SELECT a.Name, COUNT(ae.EntityID) AS n
            FROM __mj.Application a
            LEFT JOIN __mj.ApplicationEntity ae ON ae.ApplicationID = a.ID
            WHERE a.Name IN ('${APP_MEMBER}', '${APP_STAFF}')
            GROUP BY a.Name`);
        for (const row of r.recordset) {
            assert(row.n === EXPECTED_ENTITY_COUNT, `${row.Name} has ${row.n} entities, expected ${EXPECTED_ENTITY_COUNT}`);
        }
        assert(r.recordset.length === 2, 'one of the two apps is missing entirely');
    });

    // ─── M4: permissions ────────────────────────────────────────
    await test('M4 every committees entity has EntityPermission rows', async () => {
        const r = await pool.request().query(`
            SELECT e.Name FROM __mj.Entity e
            WHERE e.SchemaName = '${SCHEMA}'
              AND NOT EXISTS (SELECT 1 FROM __mj.EntityPermission p WHERE p.EntityID = e.ID)`);
        const missing = r.recordset.map(x => x.Name);
        assert(missing.length === 0, `entities with NO permission rows: ${missing.join(', ')}`);
    });

    const { line, exitCode } = summary('Metadata integrity');
    finishAndExit(line, exitCode, pool);
}

void main();
