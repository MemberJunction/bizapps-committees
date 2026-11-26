#!/usr/bin/env node
/**
 * Dual-DBMS Seed & Density Audit script for BizApps Committees (COM-WORLD + MJ Docs).
 *
 * Usage:
 *   node scripts/seed-committees-mj-docs.mjs                  # SQL Server (default)
 *   DB_PLATFORM=postgresql node scripts/seed-committees-mj-docs.mjs
 *
 * Idempotently loads COM-WORLD (organizations, committees, people, roles, personas, terms,
 * memberships, meetings, legacy + pinned/draft MJ Docs minutes, external + native MJ Docs
 * artifacts, motions, ballots, votes) via BaseEntity and emits an `sf-readiness/v3` JSON
 * SeedDensityReport verifying >=20 realistic multi-entity domain records.
 */
import { mkdirSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import sql from 'mssql';
import { loadEnvFrom } from '../test-harnesses/load-env.mjs';

const args = process.argv.slice(2);
const summaryDirIdx = args.indexOf('--summary-dir');
const summaryDir = summaryDirIdx >= 0 ? args[summaryDirIdx + 1] : null;

if (!process.env.DB_DATABASE && !process.env.PG_DATABASE) {
    loadEnvFrom(import.meta.url);
}

const platform = (process.env.DB_PLATFORM ?? 'sqlserver').trim().toLowerCase();
const isPostgres = platform === 'postgresql' || platform === 'postgres' || platform === 'pg';
const coreSchema = process.env.MJ_CORE_SCHEMA || '__mj';

async function connect() {
    if (isPostgres) {
        const { PostgreSQLDataProvider, PostgreSQLProviderConfigData } = await import(
            '@memberjunction/postgresql-dataprovider'
        );
        const { SetProvider, StartupManager } = await import('@memberjunction/core');
        const { GetServerPrincipal, UserCache } = await import('@memberjunction/generic-database-provider');
        const provider = new PostgreSQLDataProvider();
        await provider.Config(
            new PostgreSQLProviderConfigData(
                {
                    Host: process.env.DB_HOST ?? process.env.PG_HOST ?? process.env.PGHOST ?? 'localhost',
                    Port: Number(process.env.DB_PORT ?? process.env.PG_PORT ?? process.env.PGPORT ?? 5432),
                    Database: process.env.DB_DATABASE ?? process.env.PG_DATABASE ?? process.env.PGDATABASE,
                    User: process.env.DB_USERNAME ?? process.env.PG_USERNAME ?? process.env.PGUSER,
                    Password: process.env.DB_PASSWORD ?? process.env.PG_PASSWORD ?? process.env.PGPASSWORD,
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
            close: () => provider.Dispose(),
        };
    }

    const pool = await new sql.ConnectionPool({
        server: process.env.DB_HOST ?? 'localhost',
        port: Number(process.env.DB_PORT ?? 1433),
        database: process.env.DB_DATABASE,
        user: process.env.DB_USERNAME,
        password: process.env.DB_PASSWORD,
        options: { trustServerCertificate: true, encrypt: false },
        pool: { max: 10, min: 1 },
        requestTimeout: 60_000,
    }).connect();
    const { setupSQLServerClient, SQLServerProviderConfigData, UserCache } = await import(
        '@memberjunction/sqlserver-dataprovider'
    );
    const provider = await setupSQLServerClient(new SQLServerProviderConfigData(pool, coreSchema));
    await UserCache.Instance.Refresh(provider);
    return {
        provider,
        pool,
        users: UserCache.Users,
        close: () => pool.close(),
    };
}

const runtime = await connect();
try {
    const user = runtime.users.find((u) => u?.Type?.trim().toLowerCase() === 'owner') ?? runtime.users[0];
    if (!user) {
        throw new Error('No context user in UserCache');
    }

    const { LoadWorld } = await import('@mj-biz-apps/committees-integration-tests');
    const ctx = {
        User: user,
        Provider: runtime.provider,
        Pool: runtime.pool,
        Schema: coreSchema,
        Storage: undefined,
    };

    const world = await LoadWorld(ctx);
    const counts = {
        organizations: world.OrganizationID ? 1 : 0,
        committees: Object.keys(world.Committees).length,
        people: Object.keys(world.People).length,
        personaUsers: Object.keys(world.Users).length,
        roles: Object.keys(world.Roles).length,
        committeeTypes: Object.keys(world.Types).length,
        terms: Object.keys(world.Terms).length,
        meetings: Object.keys(world.Meetings).length,
        minutes: Object.keys(world.Minutes).length,
        committeeArtifacts: Object.keys(world.Artifacts).length,
        mjArtifacts: Object.keys(world.MJArtifacts).length,
        mjArtifactVersions: Object.keys(world.MJArtifactVersions).length,
    };
    const totalDomainRecords = Object.values(counts).reduce((sum, n) => sum + n, 0);
    const violations = [];
    if (totalDomainRecords < 20) {
        violations.push(`Expected >=20 domain records, found ${totalDomainRecords}`);
    }
    if (counts.minutes < 6) {
        violations.push(`Expected >=6 minutes (legacy + pinned + draft), found ${counts.minutes}`);
    }
    if (counts.committeeArtifacts < 6) {
        violations.push(`Expected >=6 committees artifacts (external URL + native MJ Docs), found ${counts.committeeArtifacts}`);
    }

    const report = {
        schemaVersion: 'sf-readiness/v3',
        platform: isPostgres ? 'postgresql' : 'sqlserver',
        overallPassed: violations.length === 0,
        counts,
        pillars: {
            seedDensity: {
                passed: violations.length === 0,
                summary: `${totalDomainRecords} realistic multi-entity domain records seeded on ${isPostgres ? 'PostgreSQL' : 'SQL Server'} (${counts.organizations} org, ${counts.committees} committees, ${counts.people} people, ${counts.personaUsers} personas, ${counts.terms} terms, ${counts.meetings} meetings, ${counts.minutes} minutes across legacy/pinned/draft modes, ${counts.committeeArtifacts} external+MJ-Docs artifacts, ${counts.mjArtifacts} MJ Artifacts, ${counts.mjArtifactVersions} MJ Artifact Versions)`,
                checkedCount: totalDomainRecords,
                violationCount: violations.length,
                violations,
            },
        },
    };
    if (summaryDir) {
        mkdirSync(summaryDir, { recursive: true });
        writeFileSync(
            join(summaryDir, `seed-density-${report.platform}.json`),
            JSON.stringify(report, null, 2),
        );
    }
    console.log(JSON.stringify(report, null, 2));
    if (!report.overallPassed) {
        process.exitCode = 1;
    }
} finally {
    await runtime.close();
}
