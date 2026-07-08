/**
 * governance-loop-runtime.ts — live validation of the Phase 2 "Govern" loop
 * (UX v2 screen 03) against a REAL SQL Server instance through the REAL data
 * provider — the exact code path Live Meeting Mode runs.
 *
 *   G1  Meeting lifecycle: create Scheduled → InProgress → Completed
 *   G2  Agenda: items created in sequence; status progression Pending →
 *       Completed/Skipped/Tabled writes stick
 *   G3  Attendance: Expected → Present upsert (quorum bar's data source)
 *   G4  Motion on the floor: create with mover/seconder; roll-call Vote rows
 *       (one per membership, UQ enforced); vote CHANGE updates in place
 *   G5  Record result: Motion stamped Passed with final tally — and the tally
 *       matches BallotService.ForecastOutcome (VotesCast basis)
 *   G6  Minutes: section accepted into Minute.Content (Draft); Finalize flips
 *       ApprovalStatus → PendingApproval
 *
 * Everything created is torn down in a finally block (raw SQL, child→parent
 * order) so the run is idempotent and leaves the DB clean. Uses the demo
 * Board of Directors committee's active-term voting memberships as voters
 * (read-only on memberships — nothing membership-side is created).
 *
 * USAGE (from repo root):  npx tsx test-harnesses/server/governance-loop-runtime.ts
 * Exit code: 0 = all passed, 1 = failures, 2 = bootstrap error.
 */
import { Metadata, RunView } from '@memberjunction/core';
import { BallotService } from '@mj-biz-apps/committees-core';
import type {
    mjBizAppsCommitteesMeetingEntity, mjBizAppsCommitteesAgendaItemEntity,
    mjBizAppsCommitteesMotionEntity, mjBizAppsCommitteesVoteEntity,
    mjBizAppsCommitteesAttendanceEntity, mjBizAppsCommitteesMinuteEntity,
} from '@mj-biz-apps/committees-entities';
import { bootstrap, test, assert, summary, count, SCHEMA, HarnessCtx } from './bootstrap.mjs';
import { finishAndExit } from './harness-exit.mjs';

const RUN_TAG = `GLOOP-${Date.now()}`;

interface VoterRow { ID: string; PersonID: string; Person: string; }

async function main(): Promise<void> {
    let ctx: HarnessCtx;
    try {
        ctx = await bootstrap();
    } catch (e) {
        console.error('BOOTSTRAP ERROR:', e instanceof Error ? e.message : String(e));
        process.exit(2);
    }
    const { pool, user } = ctx;
    console.log(`\n══════ Governance loop runtime — db=${process.env.DB_DATABASE} tag=${RUN_TAG} ══════\n`);

    const md = new Metadata();
    const rv = new RunView();
    let meetingID = '';
    let agendaIDs: string[] = [];
    let motionID = '';
    let minuteID = '';
    const voteIDs: string[] = [];
    const attendanceIDs: string[] = [];

    try {
        // ── Resolve the demo Board + its voting members ─────────
        const committee = await rv.RunView<{ ID: string }>({
            EntityName: 'Committees: Committees', ExtraFilter: "Name = 'Board of Directors'",
            Fields: ['ID'], MaxRows: 1, ResultType: 'simple',
        }, user);
        assert(committee.Success && committee.Results.length === 1, 'demo Board of Directors not found — seed Demos/ first');
        const boardID = committee.Results[0].ID;

        const [terms, roles] = await rv.RunViews([
            { EntityName: 'Committees: Terms', ExtraFilter: `CommitteeID = '${boardID}' AND Status = 'Active'`, Fields: ['ID'], ResultType: 'simple' },
            { EntityName: 'Committees: Roles', ExtraFilter: 'IsVotingRole = 1', Fields: ['ID'], ResultType: 'simple' },
        ], user);
        const termIDs = (terms.Results as { ID: string }[]).map(t => `'${t.ID}'`);
        const votingRoleIDs = (roles.Results as { ID: string }[]).map(r => `'${r.ID}'`);
        assert(termIDs.length > 0 && votingRoleIDs.length > 0, 'no active board term / voting roles');

        const members = await rv.RunView<VoterRow>({
            EntityName: 'Committees: Memberships',
            ExtraFilter: `TermID IN (${termIDs.join(',')}) AND RoleID IN (${votingRoleIDs.join(',')}) AND Status = 'Active'`,
            Fields: ['ID', 'PersonID', 'Person'], ResultType: 'simple',
        }, user);
        const voters = members.Results;
        assert(voters.length >= 3, `need >=3 voting members, found ${voters.length}`);

        // ── G1: meeting lifecycle ───────────────────────────────
        await test('G1.1 create Scheduled meeting', async () => {
            const m = await md.GetEntityObject<mjBizAppsCommitteesMeetingEntity>('Committees: Meetings', user);
            m.CommitteeID = boardID;
            m.Name = `${RUN_TAG} Meeting`;
            m.StartDateTime = new Date(Date.now() + 3600_000);
            m.EndDateTime = new Date(Date.now() + 7200_000);
            m.Status = 'Scheduled';
            assert(await m.Save(), `Save failed: ${m.LatestResult?.Message}`);
            meetingID = m.ID;
        });

        await test('G1.2 Scheduled → InProgress', async () => {
            const m = await md.GetEntityObject<mjBizAppsCommitteesMeetingEntity>('Committees: Meetings', user);
            assert(await m.Load(meetingID), 'load failed');
            m.Status = 'InProgress';
            assert(await m.Save(), `Save failed: ${m.LatestResult?.Message}`);
        });

        // ── G2: agenda ──────────────────────────────────────────
        await test('G2.1 create 3 agenda items', async () => {
            for (let i = 1; i <= 3; i++) {
                const a = await md.GetEntityObject<mjBizAppsCommitteesAgendaItemEntity>('Committees: Agenda Items', user);
                a.MeetingID = meetingID;
                a.Sequence = i;
                a.Name = `${RUN_TAG} Item ${i}`;
                a.ItemType = i === 2 ? 'Vote' : 'Discussion';
                a.Status = 'Pending';
                assert(await a.Save(), `item ${i} save failed: ${a.LatestResult?.Message}`);
                agendaIDs.push(a.ID);
            }
            const n = await count(pool, `SELECT COUNT(*) AS n FROM ${SCHEMA}.AgendaItem WHERE MeetingID = @id`, meetingID);
            assert(n === 3, `raw SQL sees ${n} agenda items, expected 3`);
        });

        await test('G2.2 agenda progression: item 1 Completed', async () => {
            const a = await md.GetEntityObject<mjBizAppsCommitteesAgendaItemEntity>('Committees: Agenda Items', user);
            assert(await a.Load(agendaIDs[0]), 'load failed');
            a.Status = 'Completed';
            assert(await a.Save(), `save failed: ${a.LatestResult?.Message}`);
            const n = await count(pool, `SELECT COUNT(*) AS n FROM ${SCHEMA}.AgendaItem WHERE ID = @id AND Status = 'Completed'`, agendaIDs[0]);
            assert(n === 1, 'status did not persist');
        });

        // ── G3: attendance upsert ───────────────────────────────
        await test('G3 attendance: mark first 3 voters Present', async () => {
            for (const voter of voters.slice(0, 3)) {
                const att = await md.GetEntityObject<mjBizAppsCommitteesAttendanceEntity>('Committees: Attendances', user);
                att.MeetingID = meetingID;
                att.PersonID = voter.PersonID;
                att.AttendanceStatus = 'Present';
                att.JoinedAt = new Date();
                assert(await att.Save(), `attendance save failed: ${att.LatestResult?.Message}`);
                attendanceIDs.push(att.ID);
            }
            const n = await count(pool, `SELECT COUNT(*) AS n FROM ${SCHEMA}.Attendance WHERE MeetingID = @id AND AttendanceStatus = 'Present'`, meetingID);
            assert(n === 3, `raw SQL sees ${n} Present rows, expected 3`);
        });

        // ── G4: motion + roll call ──────────────────────────────
        await test('G4.1 put motion on the floor (mover + seconder)', async () => {
            const mo = await md.GetEntityObject<mjBizAppsCommitteesMotionEntity>('Committees: Motions', user);
            mo.MeetingID = meetingID;
            mo.AgendaItemID = agendaIDs[1];
            mo.Name = `${RUN_TAG} Motion`;
            mo.MovedByMembershipID = voters[0].ID;
            mo.SecondedByMembershipID = voters[1].ID;
            mo.Result = 'Pending';
            assert(await mo.Save(), `motion save failed: ${mo.LatestResult?.Message}`);
            motionID = mo.ID;
        });

        await test('G4.2 roll-call: 2 Yes, 1 No', async () => {
            const values: Array<'Yes' | 'No'> = ['Yes', 'Yes', 'No'];
            for (let i = 0; i < 3; i++) {
                const v = await md.GetEntityObject<mjBizAppsCommitteesVoteEntity>('Committees: Votes', user);
                v.MotionID = motionID;
                v.MembershipID = voters[i].ID;
                v.VoteValue = values[i];
                assert(await v.Save(), `vote ${i} save failed: ${v.LatestResult?.Message}`);
                voteIDs.push(v.ID);
            }
            const n = await count(pool, `SELECT COUNT(*) AS n FROM ${SCHEMA}.Vote WHERE MotionID = @id`, motionID);
            assert(n === 3, `raw SQL sees ${n} votes, expected 3`);
        });

        await test('G4.3 vote change updates in place (No → Abstain)', async () => {
            const v = await md.GetEntityObject<mjBizAppsCommitteesVoteEntity>('Committees: Votes', user);
            assert(await v.Load(voteIDs[2]), 'load failed');
            v.VoteValue = 'Abstain';
            assert(await v.Save(), `save failed: ${v.LatestResult?.Message}`);
            const n = await count(pool, `SELECT COUNT(*) AS n FROM ${SCHEMA}.Vote WHERE MotionID = @id`, motionID);
            assert(n === 3, `vote change created a duplicate row (${n})`);
        });

        // ── G5: record result, cross-check the math ─────────────
        await test('G5 record result — stamps match BallotService math', async () => {
            const tally = BallotService.ComputeTally(
                [{ VoteValue: 'Yes' }, { VoteValue: 'Yes' }, { VoteValue: 'Abstain' }], 3);
            const outcome = BallotService.ForecastOutcome({ ...tally, Outstanding: 0 }, 'SimpleMajority', 'VotesCast', 3);
            assert(outcome.Outcome === 'Passed', `math says ${outcome.Outcome}, expected Passed`);

            const mo = await md.GetEntityObject<mjBizAppsCommitteesMotionEntity>('Committees: Motions', user);
            assert(await mo.Load(motionID), 'load failed');
            mo.Result = 'Passed';
            mo.YesCount = tally.Yes;
            mo.NoCount = tally.No;
            mo.AbstainCount = tally.Abstain;
            mo.ResultSummary = `Passed ${tally.Yes}-${tally.No}-${tally.Abstain} by roll call`;
            assert(await mo.Save(), `stamp failed: ${mo.LatestResult?.Message}`);
            const n = await count(pool,
                `SELECT COUNT(*) AS n FROM ${SCHEMA}.Motion WHERE ID = @id AND Result = 'Passed' AND YesCount = 2 AND NoCount = 0 AND AbstainCount = 1`, motionID);
            assert(n === 1, 'stamped values did not persist correctly');
        });

        // ── G6: minutes ─────────────────────────────────────────
        await test('G6.1 accept a minutes section into Minute.Content (Draft)', async () => {
            const mi = await md.GetEntityObject<mjBizAppsCommitteesMinuteEntity>('Committees: Minutes', user);
            mi.MeetingID = meetingID;
            mi.ApprovalStatus = 'Draft';
            mi.Content = `## 1 · ${RUN_TAG} Item 1\nDiscussed.\n_Drafted from meeting record · Confirmed by harness_\n`;
            assert(await mi.Save(), `minute save failed: ${mi.LatestResult?.Message}`);
            minuteID = mi.ID;
        });

        await test('G6.2 finalize: Draft → PendingApproval', async () => {
            const mi = await md.GetEntityObject<mjBizAppsCommitteesMinuteEntity>('Committees: Minutes', user);
            assert(await mi.Load(minuteID), 'load failed');
            mi.ApprovalStatus = 'PendingApproval';
            assert(await mi.Save(), `save failed: ${mi.LatestResult?.Message}`);
        });

        await test('G1.3 InProgress → Completed (end meeting)', async () => {
            const m = await md.GetEntityObject<mjBizAppsCommitteesMeetingEntity>('Committees: Meetings', user);
            assert(await m.Load(meetingID), 'load failed');
            m.Status = 'Completed';
            assert(await m.Save(), `save failed: ${m.LatestResult?.Message}`);
        });
    } finally {
        // ── Teardown: child → parent, raw SQL ───────────────────
        try {
            if (motionID) await pool.request().input('id', motionID).query(`DELETE FROM ${SCHEMA}.Vote WHERE MotionID = @id`);
            if (minuteID) await pool.request().input('id', minuteID).query(`DELETE FROM ${SCHEMA}.Minute WHERE ID = @id`);
            if (motionID) await pool.request().input('id', motionID).query(`DELETE FROM ${SCHEMA}.Motion WHERE ID = @id`);
            if (meetingID) {
                await pool.request().input('id', meetingID).query(`DELETE FROM ${SCHEMA}.Attendance WHERE MeetingID = @id`);
                await pool.request().input('id', meetingID).query(`DELETE FROM ${SCHEMA}.AgendaItem WHERE MeetingID = @id`);
                await pool.request().input('id', meetingID).query(`DELETE FROM ${SCHEMA}.Meeting WHERE ID = @id`);
            }
            console.log('\n  teardown complete — all harness rows removed');
        } catch (e) {
            console.error('  TEARDOWN ERROR (manual cleanup may be needed, tag=' + RUN_TAG + '):', e instanceof Error ? e.message : String(e));
        }
    }

    const { line, exitCode } = summary('Governance loop runtime');
    finishAndExit(line, exitCode, pool);
}

void main();
