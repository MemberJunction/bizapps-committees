/**
 * harness-exit.ts — shared, non-blocking end-of-run for every server harness.
 * (Pattern from bizapps-accounting's harness of the same name.)
 *
 * WHY: the MJ SQLServerDataProvider pool's `await pool.close()` can hang
 * indefinitely (lingering socket handles), so a harness that ends with
 * `await pool.close(); process.exit()` may print its summary and then NEVER
 * exit. The rule: never await a pool close before exiting — fire it off
 * non-blocking and force-exit; dropped sockets are harmless for a harness.
 */
import type sql from 'mssql';

/**
 * Print the summary line, fire-and-forget close every pool, force-exit.
 * @param exitCode 0 = all passed, 1 = test failures, 2 = bootstrap error.
 */
export function finishAndExit(summaryLine: string, exitCode: number, ...pools: Array<sql.ConnectionPool | undefined>): never {
    console.log(summaryLine);
    const seen = new Set<sql.ConnectionPool>();
    for (const pool of pools) {
        if (!pool || seen.has(pool)) continue;
        seen.add(pool);
        void pool.close().catch(() => { /* dropped sockets are fine for a test harness */ });
    }
    process.exit(exitCode);
}
