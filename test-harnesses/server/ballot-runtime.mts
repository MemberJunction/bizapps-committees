/**
 * ballot-runtime.ts — live validation of the between-meeting e-ballot
 * lifecycle (UX v2 screen 04) against a REAL SQL Server instance.
 *
 *   B1  Meeting-less motion: Motion.MeetingID NULL is accepted (the v1.0
 *       schema change that enables e-ballots)
 *   B2  Ballot open: 1:1 with the motion (UQ enforced — a second ballot on
 *       the same motion must FAIL), window CHECK (ClosesAt > OpensAt) enforced
 *   B3  Sealed voting: votes accumulate as ordinary Vote rows; seal-state
 *       logic (BallotService.AreChoicesSealed) hides choices while Open
 *   B4  Close: outcome computed (TwoThirds of voting members), Motion stamped,
 *       Ballot → Closed + ClosedAt + ResultNotes, choices unsealed
 *   B5  Threshold math cross-check: DB tally reproduces BallotService numbers
 *
 * Teardown in finally (raw SQL, child → parent). Read-only on demo
 * memberships — uses the Data Interoperability Workgroup's voting members,
 * mirroring the UX mockup's ballot scenario.
 *
 * USAGE (from repo root):  npx tsx test-harnesses/server/ballot-runtime.ts
 * Exit code: 0 = all passed, 1 = failures, 2 = bootstrap error.
 */
import { Metadata, RunView } from '@memberjunction/core';
import { BallotService } from '@mj-biz-apps/committees-core';
import type {
    mjBizAppsCommitteesMotionEntity, mjBizAppsCommitteesVoteEntity,
    mjBizAppsCommitteesBallotEntity,
} from '@mj-biz-apps/committees-entities';
import { bootstrap, test, assert, summary, count, SCHEMA, HarnessCtx } from './bootstrap.mjs';
import { finishAndExit } from './harness-exit.mjs';

const RUN_TAG = `BALLOT-${Date.now()}`;

async function main(): Promise<void> {
    let ctx: HarnessCtx;
    try {
        ctx = await bootstrap();
    } catch (e) {
        console.error('BOOTSTRAP ERROR:', e instanceof Error ? e.message : String(e));
        process.exit(2);
    }
    const { pool, user } = ctx;
    console.log(`\n══════ Ballot runtime — db=${process.env.DB_DATABASE} tag=${RUN_TAG} ══════\n`);

    const md = new Metadata();
    const rv = new RunView();
    let motionID = '';
    let ballotID = '';
    const voteIDs: string[] = [];

    try {
        // ── Resolve the demo workgroup + voting members ─────────
        const committee = await rv.RunView<{ ID: string }>({
            EntityName: 'Committees: Committees', ExtraFilter: "Name = 'Data Interoperability Workgroup'",
            Fields: ['ID'], MaxRows: 1, ResultType: 'simple',
        }, user);
        assert(committee.Success && committee.Results.length === 1, 'demo Data Interoperability Workgroup not found — seed Demos/ first');
        const wgID = committee.Results[0].ID;

        const [terms, roles] = await rv.RunViews([
            { EntityName: 'Committees: Terms', ExtraFilter: `CommitteeID = '${wgID}' AND Status = 'Active'`, Fields: ['ID'], ResultType: 'simple' },
            { EntityName: 'Committees: Roles', ExtraFilter: 'IsVotingRole = 1', Fields: ['ID'], ResultType: 'simple' },
        ], user);
        const termIDs = (terms.Results as { ID: string }[]).map(t => `'${t.ID}'`);
        const votingRoleIDs = (roles.Results as { ID: string }[]).map(r => `'${r.ID}'`);
        const members = await rv.RunView<{ ID: string }>({
            EntityName: 'Committees: Memberships',
            ExtraFilter: `TermID IN (${termIDs.join(',')}) AND RoleID IN (${votingRoleIDs.join(',')}) AND Status = 'Active'`,
            Fields: ['ID'], ResultType: 'simple',
        }, user);
        const voters = members.Results;
        assert(voters.length >= 4, `need >=4 voting members for the TwoThirds scenario, found ${voters.length}`);
        const votingCount = voters.length;

        // ── B1: meeting-less motion ─────────────────────────────
        await test('B1 motion with NULL MeetingID saves (e-ballot motion)', async () => {
            const mo = await md.GetEntityObject<mjBizAppsCommitteesMotionEntity>('Committees: Motions', user);
            mo.Name = `${RUN_TAG} Approve spec for public comment`;
            mo.Description = 'That the Workgroup approve the specification draft for a 60-day public comment period.';
            mo.Result = 'Pending';
            assert(await mo.Save(), `save failed: ${mo.LatestResult?.Message}`);
            motionID = mo.ID;
            const n = await count(pool, `SELECT COUNT(*) AS n FROM ${SCHEMA}.Motion WHERE ID = @id AND MeetingID IS NULL`, motionID);
            assert(n === 1, 'MeetingID is not NULL in the database');
        });

        // ── B2: ballot open + constraints ───────────────────────
        await test('B2.1 open a sealed TwoThirds ballot', async () => {
            const b = await md.GetEntityObject<mjBizAppsCommitteesBallotEntity>('Committees: Ballots', user);
            b.CommitteeID = wgID;
            b.MotionID = motionID;
            b.OpensAt = new Date();
            b.ClosesAt = new Date(Date.now() + 3 * 86400_000);
            b.ThresholdType = 'TwoThirds';
            b.IsSealed = true;
            b.Status = 'Open';
            b.CreatedByMembershipID = voters[0].ID;
            assert(await b.Save(), `save failed: ${b.LatestResult?.Message}`);
            ballotID = b.ID;
        });

        await test('B2.2 second ballot on the same motion is REJECTED (UQ)', async () => {
            const b = await md.GetEntityObject<mjBizAppsCommitteesBallotEntity>('Committees: Ballots', user);
            b.CommitteeID = wgID;
            b.MotionID = motionID;
            b.OpensAt = new Date();
            b.ClosesAt = new Date(Date.now() + 86400_000);
            b.ThresholdType = 'SimpleMajority';
            b.Status = 'Open';
            const saved = await b.Save();
            assert(!saved, 'duplicate ballot saved — UQ_Ballot_Motion is not enforcing');
        });

        await test('B2.3 inverted window is REJECTED (CK ClosesAt > OpensAt)', async () => {
            const mo2 = await md.GetEntityObject<mjBizAppsCommitteesMotionEntity>('Committees: Motions', user);
            mo2.Name = `${RUN_TAG} throwaway`;
            mo2.Result = 'Pending';
            assert(await mo2.Save(), 'throwaway motion save failed');
            const throwawayID = mo2.ID;
            try {
                const b = await md.GetEntityObject<mjBizAppsCommitteesBallotEntity>('Committees: Ballots', user);
                b.CommitteeID = wgID;
                b.MotionID = throwawayID;
                b.OpensAt = new Date();
                b.ClosesAt = new Date(Date.now() - 86400_000);   // closes before it opens
                b.ThresholdType = 'SimpleMajority';
                b.Status = 'Open';
                const saved = await b.Save();
                assert(!saved, 'inverted-window ballot saved — CK_Ballot_Window is not enforcing');
            } finally {
                await pool.request().input('id', throwawayID).query(`DELETE FROM ${SCHEMA}.Ballot WHERE MotionID = @id; DELETE FROM ${SCHEMA}.Motion WHERE ID = @id`);
            }
        });

        // ── B3: sealed voting ───────────────────────────────────
        await test('B3.1 votes accumulate while sealed (3 Yes, 1 No of ' + votingCount + ')', async () => {
            const values: Array<'Yes' | 'No'> = ['Yes', 'Yes', 'Yes', 'No'];
            for (let i = 0; i < 4; i++) {
                const v = await md.GetEntityObject<mjBizAppsCommitteesVoteEntity>('Committees: Votes', user);
                v.MotionID = motionID;
                v.MembershipID = voters[i].ID;
                v.VoteValue = values[i];
                assert(await v.Save(), `vote ${i} save failed: ${v.LatestResult?.Message}`);
                voteIDs.push(v.ID);
            }
            const n = await count(pool, `SELECT COUNT(*) AS n FROM ${SCHEMA}.Vote WHERE MotionID = @id`, motionID);
            assert(n === 4, `raw SQL sees ${n} votes, expected 4`);
        });

        await test('B3.2 seal-state logic hides choices while Open', async () => {
            assert(BallotService.AreChoicesSealed({ IsSealed: true, Status: 'Open' }) === true, 'open sealed ballot must hide choices');
            assert(BallotService.AreChoicesSealed({ IsSealed: true, Status: 'Closed' }) === false, 'closed ballot must reveal choices');
        });

        // ── B4/B5: close + stamp + math cross-check ─────────────
        await test('B4 close: outcome computed, Motion stamped, Ballot Closed', async () => {
            const votes = await rv.RunView<{ VoteValue: string }>({
                EntityName: 'Committees: Votes', ExtraFilter: `MotionID = '${motionID}'`,
                Fields: ['VoteValue'], ResultType: 'simple',
            }, user);
            const tally = BallotService.ComputeTally(votes.Results, votingCount);
            const outcome = BallotService.ForecastOutcome({ ...tally, Outstanding: 0 }, 'TwoThirds', 'VotingMembers', votingCount);
            // 3 Yes of votingCount voting members: TwoThirds(N) — with the demo WG's
            // 4 voting members RequiredYes = ceil(8/3) = 3 → Passed.
            const expected = tally.Yes >= BallotService.RequiredYes('TwoThirds', votingCount) ? 'Passed' : 'Failed';
            assert(outcome.Outcome === expected, `math mismatch: forecast ${outcome.Outcome}, direct ${expected}`);

            const mo = await md.GetEntityObject<mjBizAppsCommitteesMotionEntity>('Committees: Motions', user);
            assert(await mo.Load(motionID), 'motion load failed');
            mo.Result = expected;
            mo.YesCount = tally.Yes;
            mo.NoCount = tally.No;
            mo.AbstainCount = tally.Abstain;
            mo.ResultSummary = `E-ballot ${expected.toLowerCase()} ${tally.Yes}-${tally.No}-${tally.Abstain}`;
            assert(await mo.Save(), `motion stamp failed: ${mo.LatestResult?.Message}`);

            const b = await md.GetEntityObject<mjBizAppsCommitteesBallotEntity>('Committees: Ballots', user);
            assert(await b.Load(ballotID), 'ballot load failed');
            b.Status = 'Closed';
            b.ClosedAt = new Date();
            b.ResultNotes = mo.ResultSummary!;
            assert(await b.Save(), `ballot close failed: ${b.LatestResult?.Message}`);

            const n = await count(pool,
                `SELECT COUNT(*) AS n FROM ${SCHEMA}.Ballot WHERE ID = @id AND Status = 'Closed' AND ClosedAt IS NOT NULL`, ballotID);
            assert(n === 1, 'ballot close did not persist');
        });

        await test('B5 DB tally matches BallotService numbers', async () => {
            const r = await pool.request().input('id', motionID).query(`
                SELECT YesCount, NoCount, AbstainCount FROM ${SCHEMA}.Motion WHERE ID = @id`);
            const row = r.recordset[0];
            assert(row.YesCount === 3 && row.NoCount === 1 && row.AbstainCount === 0,
                `stamped ${row.YesCount}-${row.NoCount}-${row.AbstainCount}, expected 3-1-0`);
        });
    } finally {
        try {
            if (motionID) {
                await pool.request().input('id', motionID).query(`DELETE FROM ${SCHEMA}.Vote WHERE MotionID = @id`);
                await pool.request().input('id', motionID).query(`DELETE FROM ${SCHEMA}.Ballot WHERE MotionID = @id`);
                await pool.request().input('id', motionID).query(`DELETE FROM ${SCHEMA}.Motion WHERE ID = @id`);
            }
            console.log('\n  teardown complete — all harness rows removed');
        } catch (e) {
            console.error('  TEARDOWN ERROR (manual cleanup may be needed, tag=' + RUN_TAG + '):', e instanceof Error ? e.message : String(e));
        }
    }

    const { line, exitCode } = summary('Ballot runtime');
    finishAndExit(line, exitCode, pool);
}

void main();
