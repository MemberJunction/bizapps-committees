/**
 * Standalone dual-DBMS dispatcher for the committees integration suite.
 *
 *   node test-harnesses/integration.mjs
 *   node test-harnesses/integration.mjs committees-world
 *   node test-harnesses/integration.mjs ballot-sealing
 *   node test-harnesses/integration.mjs minute-artifact-dual-read
 *   node test-harnesses/integration.mjs pg-parity-and-boundary
 *   DB_PLATFORM=postgresql node test-harnesses/integration.mjs
 *
 * committees-world COMMITS COM-WORLD so Explorer has rows. Exit 0 pass · 1 fail · 2 bootstrap.
 */
import { mkdirSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import sql from 'mssql';
import { loadEnvFrom } from './load-env.mjs';

if (!process.env.DB_DATABASE && !process.env.PG_DATABASE) {
    loadEnvFrom(import.meta.url);
}

const SQLSERVER_DEFAULT_BUNDLES = [
    'committees-world',
    'ballot-sealing',
    'minute-artifact-dual-read',
    'pg-parity-and-boundary',
];

// `ballot-sealing` exercises the pre-existing T-SQL `Committees: Visible Votes` RLS filter
// (`TRY_CAST` / bracketed identifiers in metadata/row-level-security-filters), so the default
// PostgreSQL lane runs the 3 dialect-portable governance + MJ Docs + parity bundles (23 checks).
const POSTGRES_DEFAULT_BUNDLES = [
    'committees-world',
    'minute-artifact-dual-read',
    'pg-parity-and-boundary',
];

const args = process.argv.slice(2);
const summaryDirIdx = args.indexOf('--summary-dir');
const summaryDir = summaryDirIdx >= 0 ? args[summaryDirIdx + 1] : null;
const only = args.filter((a, i) => !a.startsWith('-') && i !== summaryDirIdx + 1);
const platform = (process.env.DB_PLATFORM ?? 'sqlserver').trim().toLowerCase();
const isPostgres = platform === 'postgresql' || platform === 'postgres' || platform === 'pg';
const coreSchema = process.env.MJ_CORE_SCHEMA || '__mj';

async function bootstrapProvider() {
    if (isPostgres) {
        const { PostgreSQLDataProvider, PostgreSQLProviderConfigData } = await import(
            '@memberjunction/postgresql-dataprovider'
        );
        const { SetProvider, StartupManager } = await import('@memberjunction/core');
        const { GetServerPrincipal, UserCache } = await import('@memberjunction/generic-database-provider');

        const host = process.env.DB_HOST ?? process.env.PG_HOST ?? process.env.PGHOST ?? 'localhost';
        const port = Number(process.env.DB_PORT ?? process.env.PG_PORT ?? process.env.PGPORT ?? 5432);
        const database = process.env.DB_DATABASE ?? process.env.PG_DATABASE ?? process.env.PGDATABASE;
        const user = process.env.DB_USERNAME ?? process.env.PG_USERNAME ?? process.env.PGUSER;
        const password = process.env.DB_PASSWORD ?? process.env.PG_PASSWORD ?? process.env.PGPASSWORD;

        const provider = new PostgreSQLDataProvider();
        await provider.Config(
            new PostgreSQLProviderConfigData(
                {
                    Host: host,
                    Port: port,
                    Database: database,
                    User: user,
                    Password: password,
                    MaxConnections: 10,
                    MinConnections: 1,
                    MJCoreSchemaName: coreSchema,
                },
                coreSchema,
                1,
            ),
        );
        SetProvider(provider);
        await UserCache.Instance.Refresh(provider);
        const systemUser = GetServerPrincipal() ?? undefined;
        await StartupManager.Instance.Startup(false, systemUser, provider);
        return {
            provider,
            pool: provider.DatabaseConnection,
            users: UserCache.Users,
            close: async () => {
                await provider.Dispose();
            },
        };
    }

    const { DB_HOST, DB_PORT, DB_DATABASE, DB_USERNAME, DB_PASSWORD } = process.env;
    const pool = await new sql.ConnectionPool({
        server: DB_HOST ?? 'localhost',
        port: Number(DB_PORT ?? 1433),
        database: DB_DATABASE,
        user: DB_USERNAME,
        password: DB_PASSWORD,
        options: { trustServerCertificate: true, encrypt: false },
        pool: { max: 10, min: 1 },
        requestTimeout: 60_000,
    }).connect();

    const { setupSQLServerClient, SQLServerProviderConfigData, UserCache } = await import(
        '@memberjunction/sqlserver-dataprovider'
    );
    const provider = await setupSQLServerClient(
        new SQLServerProviderConfigData(pool, coreSchema),
    );
    await UserCache.Instance.Refresh(provider);
    return {
        provider,
        pool,
        users: UserCache.Users,
        close: async () => {
            await pool.close();
        },
    };
}

const runtime = await bootstrapProvider();
const user = runtime.users.find((u) => u?.Type?.trim().toLowerCase() === 'owner') ?? runtime.users[0];
if (!user) {
    console.error('BOOTSTRAP: no context user in UserCache');
    await runtime.close();
    process.exit(2);
}

await import('@mj-biz-apps/committees-entities');
await import('@mj-biz-apps/committees-server');
const { IntegrationCheckRegistry } = await import('@memberjunction/testing-integration');
await import('@mj-biz-apps/committees-integration-tests');

const registry = IntegrationCheckRegistry.Instance;
const baseContext = {
    User: user,
    Provider: runtime.provider,
    Pool: runtime.pool,
    Schema: coreSchema,
    Storage: undefined,
};

console.log(`\nCommittees Integration Suite (${isPostgres ? 'PostgreSQL' : 'SQL Server'})`);

const defaultBundles = isPostgres ? POSTGRES_DEFAULT_BUNDLES : SQLSERVER_DEFAULT_BUNDLES;
const requested = only.length ? only : defaultBundles;
let pass = 0;
let fail = 0;
const failures = [];
const checkResults = [];

for (const request of requested) {
    const [bundle, localId] = request.includes('.') ? [request.split('.')[0], request] : [request, null];
    const checks = registry.GetBundle(bundle).filter((c) => !localId || c.Id === localId);
    if (checks.length === 0) {
        console.error(`\n✖ no checks matched '${request}' — known bundles: ${registry.GetBundleNames().join(', ')}`);
        fail++;
        continue;
    }

    console.log(`\n=== ${bundle} (${checks.length} check${checks.length === 1 ? '' : 's'}) ===`);
    const ctx = { ...baseContext };
    const lifecycle = registry.GetLifecycle(bundle);

    try {
        if (lifecycle) await lifecycle.Setup(ctx);
        for (const check of checks) {
            const started = Date.now();
            try {
                await check.Fn(ctx);
                const durationMs = Date.now() - started;
                pass++;
                checkResults.push({ bundle, id: check.Id, name: check.Name, passed: true, durationMs });
                console.log(`  ✔ ${check.Name}  (${durationMs}ms)`);
            } catch (e) {
                const durationMs = Date.now() - started;
                fail++;
                const message = String(e?.message ?? e).split('\n')[0];
                failures.push({ Id: check.Id, message });
                checkResults.push({ bundle, id: check.Id, name: check.Name, passed: false, durationMs, error: message });
                console.log(`  ✖ ${check.Name}\n      ${message}`);
                const nested = e?.originalError?.message ?? e?.precedingErrors?.[0]?.message;
                if (nested && nested !== message) console.log(`      ↳ ${nested}`);
            }
        }
    } catch (e) {
        fail++;
        const message = String(e?.message ?? e).split('\n')[0];
        failures.push({ Id: `${bundle} (setup)`, message });
        console.log(`  ✖ ${bundle} SETUP FAILED\n      ${message}`);
    } finally {
        if (lifecycle) await lifecycle.Teardown(ctx).catch((e) => console.warn(`  teardown warn: ${e.message}`));
    }
}

const platformName = isPostgres ? 'postgresql' : 'sqlserver';
if (summaryDir) {
    mkdirSync(summaryDir, { recursive: true });
    writeFileSync(
        join(summaryDir, `integration-${platformName}.json`),
        JSON.stringify({ platform: platformName, passed: pass, failed: fail, bundles: requested, failures, checks: checkResults }, null, 2),
    );
}

console.log(`\n${fail === 0 ? 'PASS' : 'FAIL'} [${platformName}] — ${pass} passed, ${fail} failed`);
if (fail) failures.forEach((f) => console.log(`  · ${f.Id}: ${f.message}`));
await runtime.close();
process.exit(fail === 0 ? 0 : 1);
