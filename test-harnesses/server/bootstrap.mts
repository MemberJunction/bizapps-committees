/**
 * bootstrap.ts — shared provider boot + tiny test runner for the committees
 * server harnesses (accounting-fleet pattern).
 *
 * Boots the REAL SQL Server data provider from the repo root .env, registers
 * the REAL committees entity subclasses + server services — the exact code
 * path MJAPI runs — and resolves an Owner context user.
 */
import sql from 'mssql';
import dotenv from 'dotenv';
import path from 'path';
import { UserInfo } from '@memberjunction/core';
import { setupSQLServerClient, SQLServerProviderConfigData, UserCache } from '@memberjunction/sqlserver-dataprovider';

// Register core + committees entity subclasses on the ClassFactory so
// GetEntityObject returns the real classes (matches MJAPI boot).
import '@memberjunction/server-bootstrap-lite';
import '@mj-biz-apps/common-entities';
import '@mj-biz-apps/committees-entities';
import '@mj-biz-apps/committees-core-entities-server';

export const SCHEMA = '__mj_BizAppsCommittees';

export interface HarnessCtx {
    pool: sql.ConnectionPool;
    user: UserInfo;
}

export async function bootstrap(): Promise<HarnessCtx> {
    // override: the repo .env is the source of truth for harnesses — without it,
    // a stale DB_DATABASE exported in the user's shell profile silently wins
    // (dotenv never overwrites pre-existing env vars) and the harness reads a
    // different database than sqlcmd/MJAPI. Bitten once; never again.
    dotenv.config({ path: path.resolve(process.cwd(), '.env'), quiet: true, override: true });
    const host = process.env.DB_HOST;
    const database = process.env.DB_DATABASE;
    const user = process.env.DB_USERNAME;
    const password = process.env.DB_PASSWORD;
    const coreSchema = process.env.MJ_CORE_SCHEMA || '__mj';
    if (!host || !database || !user || !password) {
        throw new Error('Missing DB settings in .env (DB_HOST, DB_DATABASE, DB_USERNAME, DB_PASSWORD). Run from the repo root.');
    }
    const pool = await new sql.ConnectionPool({
        server: host, port: Number(process.env.DB_PORT ?? 1433), user, password, database,
        options: { encrypt: false, trustServerCertificate: true },
    }).connect();

    await setupSQLServerClient(new SQLServerProviderConfigData(pool, coreSchema));
    await UserCache.Instance.Refresh(pool);
    const ctxUser = UserCache.Users.find(u => u?.Type?.trim().toLowerCase() === 'owner') ?? UserCache.Users[0];
    if (!ctxUser) throw new Error('No context user found in UserCache.');
    return { pool, user: ctxUser };
}

// ─── Tiny test runner (accounting pattern) ─────────────────────────────────
export interface Outcome { Name: string; Passed: boolean; Ms: number; Error?: string }
export const outcomes: Outcome[] = [];

export async function test(name: string, fn: () => Promise<void>): Promise<void> {
    const start = Date.now();
    try {
        await fn();
        outcomes.push({ Name: name, Passed: true, Ms: Date.now() - start });
        console.log(`  ✓ ${name} (${Date.now() - start}ms)`);
    } catch (e) {
        const msg = e instanceof Error ? (e.stack ?? e.message) : String(e);
        outcomes.push({ Name: name, Passed: false, Ms: Date.now() - start, Error: msg });
        console.log(`  ✗ ${name} (${Date.now() - start}ms)\n      ${msg}`);
    }
}

export function assert(cond: boolean, message: string): void {
    if (!cond) throw new Error(message);
}

export function summary(label: string): { line: string; exitCode: number } {
    const passed = outcomes.filter(o => o.Passed).length;
    const line = `\n────── ${label}: ${passed}/${outcomes.length} passed ──────`;
    return { line, exitCode: passed === outcomes.length ? 0 : 1 };
}

/** Scalar count helper — verification via raw SQL so a wrong count is caught
 *  even if the entity layer reports success. */
export async function count(pool: sql.ConnectionPool, query: string, id?: string): Promise<number> {
    const req = pool.request();
    if (id !== undefined) req.input('id', sql.UniqueIdentifier, id);
    const r = await req.query(query);
    return r.recordset[0].n as number;
}
