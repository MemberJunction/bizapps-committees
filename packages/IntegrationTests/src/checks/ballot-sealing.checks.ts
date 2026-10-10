/**
 * ballot-sealing — the Votes row filter and the server-side close (C0), driven as the sign-in personas.
 *
 * Reads run as the personas' UserInfo (UI role only), the way MJAPI runs them, so "Committees: Visible Votes" applies:
 * a member sees their own vote, every vote on a motion without a ballot, and every vote on a closed or cancelled
 * ballot that is not sealed. The close and cancel go through BallotCloseService after CommitteeAuthorization, in the
 * order BallotCloseResolver applies them. BS3, BS5, BS6 and BS8 create their own motions and ballots in Governance and remove them.
 */
import {
    Assert,
    IntegrationCheckRegistry,
    type IntegrationCheckContext,
    type NamedCheck,
} from '@memberjunction/testing-integration/registry';
import type { UserInfo } from '@memberjunction/core';
import { BallotCloseService } from '@mj-biz-apps/committees-core-entities-server';
import { CommitteeAuthorization } from '@mj-biz-apps/committees-server';
import { MeetingEntityCustom, MembershipEntityCustom } from '@mj-biz-apps/committees-entities';
import {
    DeleteRow,
    E_BALLOT,
    E_MEETING,
    E_MEMBERSHIP,
    E_MOTION,
    E_PERSON,
    E_ROLE,
    E_USER,
    E_VOTE,
    EntityOf,
    FindRows,
    FindRowsAs,
    PersonaUser,
    ProviderOf,
    Quote,
    RequireSave,
    UtcDay,
    WORLD_MARK,
} from '../fixture.js';
import { LoadWorld, WorldUserEmail } from '../world/load-world.js';
import { World } from '../world/world.js';

const GOVERNANCE_BALLOT_MOTION = 'Adopt revised conflict-of-interest policy';
const FINANCE_CLOSED_MOTION = 'Approve FY27 budget amendment';

type VoteKey = { MembershipID: string; VoteValue: string };
type Created = { motionID: string; ballotID: string | null; voteIDs: string[] };

async function persona(ctx: IntegrationCheckContext, key: string): Promise<UserInfo> {
    return PersonaUser(ctx, WorldUserEmail(key));
}

async function motionID(ctx: IntegrationCheckContext, name: string): Promise<string> {
    const [row] = await FindRows<{ ID: string }>(ctx, E_MOTION, `Name = '${Quote(name)}'`, ['ID']);
    Assert(!!row, `motion "${name}" is in COM-WORLD`);
    return row.ID;
}

/** How many active Governance seats vote: the world's eight, plus any seat a host account was given on this database. */
async function governanceVotingCount(ctx: IntegrationCheckContext): Promise<number> {
    const world = World();
    const seats = await FindRows<{ RoleID: string }>(ctx, E_MEMBERSHIP, `TermID = '${world.Terms.governance}' AND Status = 'Active'`, ['RoleID']);
    const voting = new Set((await FindRows<{ ID: string }>(ctx, E_ROLE, 'IsVotingRole = 1', ['ID'])).map((role) => role.ID.toLowerCase()));
    return seats.filter((seat) => voting.has(seat.RoleID.toLowerCase())).length;
}

/** Yes votes a simple majority of `count` needs: strictly more than half (BallotService.RequiredYes, pinned by Core's tests). */
const simpleMajority = (count: number): number => Math.floor(count / 2) + 1;

/** The persona's active Governance membership. */
async function governanceSeat(ctx: IntegrationCheckContext, key: string): Promise<string> {
    const world = World();
    const [row] = await FindRows<{ ID: string }>(ctx, E_MEMBERSHIP, `PersonID = '${world.People[key]}' AND TermID = '${world.Terms.governance}' AND Status = 'Active'`, ['ID']);
    Assert(!!row, `${key} sits on Governance`);
    return row.ID;
}

async function votesAs(ctx: IntegrationCheckContext, user: UserInfo, motion: string): Promise<VoteKey[]> {
    return FindRowsAs<VoteKey>(ctx, user, E_VOTE, `MotionID = '${motion}'`, ['MembershipID', 'VoteValue']);
}

/** A meeting-less motion in Governance with the given votes and no ballot (a roll call), written as the harness's user (the owner). */
async function governanceRollCall(ctx: IntegrationCheckContext, name: string, votes: Array<[string, 'Yes' | 'No' | 'Abstain']>): Promise<Created> {
    const marcus = await governanceSeat(ctx, 'marcus');
    const priya = await governanceSeat(ctx, 'priya');
    const motion = await EntityOf(ctx, E_MOTION);
    motion.NewRecord();
    motion.Set('Name', `${WORLD_MARK}:ballot-sealing ${name}`);
    motion.Set('Description', 'Created by the ballot-sealing bundle; removed by it.');
    motion.Set('MeetingID', null);
    motion.Set('Sequence', 1);
    motion.Set('MovedByMembershipID', marcus);
    motion.Set('SecondedByMembershipID', priya);
    motion.Set('Result', 'Pending');
    await RequireSave(motion, `motion ${name}`);
    const motionId = String(motion.Get('ID'));
    const voteIDs: string[] = [];
    for (const [key, value] of votes) {
        const vote = await EntityOf(ctx, E_VOTE);
        vote.NewRecord();
        vote.Set('MotionID', motionId);
        vote.Set('MembershipID', await governanceSeat(ctx, key));
        vote.Set('VoteValue', value);
        await RequireSave(vote, `${key}'s vote on ${name}`);
        voteIDs.push(String(vote.Get('ID')));
    }
    return { motionID: motionId, ballotID: null, voteIDs };
}

/** A motion with an open ballot in Governance and the given votes. */
async function openGovernanceBallot(ctx: IntegrationCheckContext, name: string, sealed: boolean, votes: Array<[string, 'Yes' | 'No' | 'Abstain']>): Promise<Created> {
    const created = await governanceRollCall(ctx, name, votes);
    const marcus = await governanceSeat(ctx, 'marcus');
    const ballot = await EntityOf(ctx, E_BALLOT);
    ballot.NewRecord();
    ballot.Set('MotionID', created.motionID);
    ballot.Set('CommitteeID', World().Committees.governance);
    ballot.Set('OpensAt', UtcDay(-1));
    ballot.Set('ClosesAt', UtcDay(7));
    ballot.Set('ThresholdType', 'SimpleMajority');
    ballot.Set('IsSealed', sealed);
    ballot.Set('Status', 'Open');
    ballot.Set('CreatedByMembershipID', marcus);
    await RequireSave(ballot, `ballot ${name}`);
    return { ...created, ballotID: String(ballot.Get('ID')) };
}

async function remove(ctx: IntegrationCheckContext, created: Created | null): Promise<void> {
    if (!created) return;
    for (const id of created.voteIDs) await DeleteRow(ctx, E_VOTE, id);
    if (created.ballotID) await DeleteRow(ctx, E_BALLOT, created.ballotID);
    await DeleteRow(ctx, E_MOTION, created.motionID);
}

export const BallotSealingChecks: NamedCheck[] = [
    {
        Id: 'ballot-sealing.BS1',
        Name: 'BS1 — an open sealed ballot: each member reads only their own vote; a member who has not voted, and one off the committee, read none; the owner reads them all',
        RequiresMutation: false,
        Fn: async (ctx: IntegrationCheckContext) => {
            const motion = await motionID(ctx, GOVERNANCE_BALLOT_MOTION);
            const all = await FindRows<VoteKey>(ctx, E_VOTE, `MotionID = '${motion}'`, ['MembershipID', 'VoteValue']);
            Assert(all.length === 2, `the owner reads both votes on the governance ballot (${all.length})`);
            const priya = await votesAs(ctx, await persona(ctx, 'priya'), motion);
            Assert(priya.length === 1 && priya[0].MembershipID.toLowerCase() === (await governanceSeat(ctx, 'priya')).toLowerCase(), `Priya reads her own vote and no other (${priya.length})`);
            const marcus = await votesAs(ctx, await persona(ctx, 'marcus'), motion);
            Assert(marcus.length === 1 && marcus[0].MembershipID.toLowerCase() === (await governanceSeat(ctx, 'marcus')).toLowerCase(), `Marcus, the chair, reads his own vote and no other (${marcus.length})`);
            Assert((await votesAs(ctx, await persona(ctx, 'alex'), motion)).length === 0, 'Alex, who has not voted, reads no vote');
            Assert((await votesAs(ctx, await persona(ctx, 'ruth'), motion)).length === 0, 'Ruth, off the committee, reads no vote');
        },
    },
    {
        Id: 'ballot-sealing.BS2',
        Name: 'BS2 — a closed ballot that is not sealed: every vote is readable, on and off the committee',
        RequiresMutation: false,
        Fn: async (ctx: IntegrationCheckContext) => {
            const motion = await motionID(ctx, FINANCE_CLOSED_MOTION);
            const all = await FindRows<VoteKey>(ctx, E_VOTE, `MotionID = '${motion}'`, ['MembershipID']);
            Assert(all.length === 7, `the finance amendment has seven votes (${all.length})`);
            Assert((await votesAs(ctx, await persona(ctx, 'priya'), motion)).length === 7, 'Priya, on Finance, reads all seven');
            Assert((await votesAs(ctx, await persona(ctx, 'ruth'), motion)).length === 7, 'Ruth, off Finance, reads all seven: an unsealed closed ballot is public');
        },
    },
    {
        Id: 'ballot-sealing.BS3',
        Name: 'BS3 — a roll call on a motion with no ballot stays readable in full, by a member who voted, one who did not, and an outsider',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            let created: Created | null = null;
            try {
                created = await governanceRollCall(ctx, 'BS3 roll call', [['marcus', 'Yes'], ['priya', 'No'], ['alex', 'Abstain']]);
                Assert((await FindRows<{ ID: string }>(ctx, E_BALLOT, `MotionID = '${created.motionID}'`, ['ID'])).length === 0, 'the motion has no ballot');
                const [priya, ruth] = await Promise.all([persona(ctx, 'priya'), persona(ctx, 'ruth')]);
                const asPriya = await votesAs(ctx, priya, created.motionID);
                Assert(asPriya.length === 3 && asPriya.some((v) => v.VoteValue === 'Yes'), `Priya reads the whole roll call, choices included (${asPriya.length})`);
                Assert((await votesAs(ctx, ruth, created.motionID)).length === 3, 'Ruth, off the committee, reads the whole roll call');
            } finally {
                await remove(ctx, created);
            }
        },
    },
    {
        Id: 'ballot-sealing.BS4',
        Name: 'BS4 — who may close and who may look: the chair closes, a member may not; a member sees participation (who voted, never how), an outsider is refused',
        RequiresMutation: false,
        Fn: async (ctx: IntegrationCheckContext) => {
            const governance = World().Committees.governance;
            const [marcus, priya, alex, ruth] = await Promise.all(['marcus', 'priya', 'alex', 'ruth'].map((key) => persona(ctx, key)));
            Assert(await CommitteeAuthorization.CanActOnCommittee(governance, marcus), 'Marcus, the chair, may close a Governance ballot');
            Assert(!(await CommitteeAuthorization.CanActOnCommittee(governance, priya)), 'Priya, a member, may not');
            Assert(!(await CommitteeAuthorization.CanActOnCommittee(governance, ruth)), 'Ruth, off the committee, may not');
            Assert(await CommitteeAuthorization.CanViewCommittee(governance, alex), 'Alex, a member, may look at participation');
            Assert(!(await CommitteeAuthorization.CanViewCommittee(governance, ruth)), 'Ruth may not');

            const [ballot] = await FindRows<{ ID: string }>(ctx, E_BALLOT, `MotionID = '${await motionID(ctx, GOVERNANCE_BALLOT_MOTION)}'`, ['ID']);
            const roster = await governanceVotingCount(ctx);
            const progress = await new BallotCloseService().Progress(ballot.ID, priya);
            Assert(progress.Success, `progress as Priya: ${progress.ErrorMessage ?? ''}`);
            Assert(progress.Cast === 2 && progress.VotingMemberCount === roster && progress.Outstanding === roster - 2, `2 of ${roster} voting members have cast (${progress.Cast}/${progress.VotingMemberCount}, ${progress.Outstanding} outstanding)`);
            const voted = progress.Voted.map((v) => v.MembershipID.toLowerCase()).sort();
            const expected = [await governanceSeat(ctx, 'marcus'), await governanceSeat(ctx, 'priya')].map((id) => id.toLowerCase()).sort();
            Assert(JSON.stringify(voted) === JSON.stringify(expected), 'the two voters are named, with no choice');
            Assert(!('VoteValue' in (progress.Voted[0] ?? {})), 'participation carries no vote value');
        },
    },
    {
        Id: 'ballot-sealing.BS5',
        Name: 'BS5 — the chair closes a sealed ballot: the server tallies every vote, stamps the motion, marks the ballot Closed, returns the tally; the choices stay sealed afterwards; a second close is refused',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            let created: Created | null = null;
            try {
                created = await openGovernanceBallot(ctx, 'BS5 sealed', true, [['marcus', 'Yes'], ['priya', 'Yes'], ['alex', 'No']]);
                const marcus = await persona(ctx, 'marcus');
                const priya = await persona(ctx, 'priya');
                const roster = await governanceVotingCount(ctx);
                Assert((await votesAs(ctx, priya, created.motionID)).length === 1, 'before the close Priya reads her vote only');

                const result = await new BallotCloseService().CloseBallot(created.ballotID, null, marcus);
                Assert(result.Success, `the chair closes the ballot: ${result.ErrorMessage ?? ''}`);
                Assert(result.Result === 'Failed' && result.Yes === 2 && result.No === 1 && result.Abstain === 0 && result.Cast === 3, `2-1-0 of 3 cast fails a simple majority of ${roster} (${result.Result} ${result.Yes}-${result.No}-${result.Abstain})`);
                Assert(result.VotingMemberCount === roster && result.RequiredYes === simpleMajority(roster), `${roster} voting members, ${simpleMajority(roster)} Yes needed (${result.VotingMemberCount}, ${result.RequiredYes})`);
                Assert(result.ResultNotes === `E-ballot failed 2-1-0 (simple majority, 3 of ${roster} voting members cast)`, `the summary is stamped when no notes are given: ${result.ResultNotes}`);

                const [motion] = await FindRows<{ Result: string; YesCount: number; NoCount: number; AbstainCount: number; ResultSummary: string }>(ctx, E_MOTION, `ID = '${created.motionID}'`, ['Result', 'YesCount', 'NoCount', 'AbstainCount', 'ResultSummary']);
                Assert(motion.Result === 'Failed' && motion.YesCount === 2 && motion.NoCount === 1 && motion.AbstainCount === 0, `the motion is stamped (${motion.Result} ${motion.YesCount}-${motion.NoCount}-${motion.AbstainCount})`);
                Assert(motion.ResultSummary === result.ResultNotes, 'the motion carries the summary');
                const [ballot] = await FindRows<{ Status: string; ClosedAt: Date | null; ResultNotes: string | null }>(ctx, E_BALLOT, `ID = '${created.ballotID}'`, ['Status', 'ClosedAt', 'ResultNotes']);
                Assert(ballot.Status === 'Closed' && !!ballot.ClosedAt && ballot.ResultNotes === result.ResultNotes, `the ballot is Closed with ClosedAt and the notes (${ballot.Status})`);

                Assert((await votesAs(ctx, priya, created.motionID)).length === 1, 'after the close Priya still reads her vote only: sealed is sealed');
                Assert((await votesAs(ctx, marcus, created.motionID)).length === 1, 'the chair too');
                Assert((await FindRows<{ ID: string }>(ctx, E_VOTE, `MotionID = '${created.motionID}'`, ['ID'])).length === 3, 'the owner reads all three');

                const again = await new BallotCloseService().CloseBallot(created.ballotID, null, marcus);
                Assert(!again.Success && /open ballot/i.test(again.ErrorMessage ?? ''), `a closed ballot cannot be closed again: ${again.ErrorMessage ?? ''}`);
            } finally {
                await remove(ctx, created);
            }
        },
    },
    {
        Id: 'ballot-sealing.BS6',
        Name: 'BS6 — an unsealed ballot opens its votes to everyone once closed, and keeps the chair\'s notes; a cancel needs a reason, stamps nothing and keeps the votes sealed',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            let open: Created | null = null;
            let cancelled: Created | null = null;
            try {
                const marcus = await persona(ctx, 'marcus');
                const priya = await persona(ctx, 'priya');
                const ruth = await persona(ctx, 'ruth');
                open = await openGovernanceBallot(ctx, 'BS6 open', false, [['marcus', 'Yes'], ['priya', 'No'], ['alex', 'Abstain']]);
                Assert((await votesAs(ctx, priya, open.motionID)).length === 1, 'while open, an unsealed ballot still shows Priya her vote only');
                const closed = await new BallotCloseService().CloseBallot(open.ballotID, 'Adopted by the board', marcus);
                Assert(closed.Success && closed.Result === 'Failed' && closed.ResultNotes === 'Adopted by the board', `closed with the chair's notes: ${closed.ErrorMessage ?? closed.ResultNotes}`);
                Assert((await votesAs(ctx, priya, open.motionID)).length === 3, 'closed and unsealed: Priya reads all three');
                Assert((await votesAs(ctx, ruth, open.motionID)).length === 3, 'Ruth, off the committee, reads all three');

                cancelled = await openGovernanceBallot(ctx, 'BS6 cancel', true, [['marcus', 'Yes'], ['priya', 'Yes']]);
                const noReason = await new BallotCloseService().CancelBallot(cancelled.ballotID, '  ', marcus);
                Assert(!noReason.Success && /reason/i.test(noReason.ErrorMessage ?? ''), `a cancel without a reason is refused: ${noReason.ErrorMessage ?? ''}`);
                const withReason = await new BallotCloseService().CancelBallot(cancelled.ballotID, 'Withdrawn by the mover', marcus);
                Assert(withReason.Success && withReason.Result === 'Cancelled', `cancelled: ${withReason.ErrorMessage ?? ''}`);
                const [ballot] = await FindRows<{ Status: string; ClosedAt: Date | null; ResultNotes: string | null }>(ctx, E_BALLOT, `ID = '${cancelled.ballotID}'`, ['Status', 'ClosedAt', 'ResultNotes']);
                Assert(ballot.Status === 'Cancelled' && !!ballot.ClosedAt && ballot.ResultNotes === 'Withdrawn by the mover', `the ballot is Cancelled with the reason (${ballot.Status})`);
                const [motion] = await FindRows<{ Result: string; YesCount: number | null }>(ctx, E_MOTION, `ID = '${cancelled.motionID}'`, ['Result', 'YesCount']);
                Assert(motion.Result === 'Pending' && !motion.YesCount, `the motion is not stamped (${motion.Result}, ${motion.YesCount})`);
                Assert((await votesAs(ctx, priya, cancelled.motionID)).length === 1, 'the cancelled sealed ballot keeps its votes sealed');
            } finally {
                await remove(ctx, open);
                await remove(ctx, cancelled);
            }
        },
    },
    {
        Id: 'ballot-sealing.BS8',
        Name: 'BS8 — a member whose user binds to their Person through the user\'s own People link (LinkedEntityID + LinkedEntityRecordID, People.LinkedUserID empty) reads their own vote on a sealed ballot; the others still read none',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = World();
            const [jamie] = await FindRows<{ ID: string; LinkedUserID: string | null }>(ctx, E_PERSON, `ID = '${world.People.jamie}'`, ['ID', 'LinkedUserID']);
            Assert(!jamie.LinkedUserID, 'Jamie\'s Person carries no LinkedUserID: the world binds her through the user record');
            const [user] = await FindRows<{ LinkedEntityID: string | null; LinkedEntityRecordID: string | null }>(ctx, E_USER, `ID = '${world.Users.jamie}'`, ['LinkedEntityID', 'LinkedEntityRecordID']);
            Assert(user.LinkedEntityRecordID?.toLowerCase() === jamie.ID.toLowerCase(), 'her user names her Person as its linked record');
            let created: Created | null = null;
            try {
                created = await openGovernanceBallot(ctx, 'BS8 user link', true, [['jamie', 'Yes'], ['priya', 'No']]);
                const asJamie = await votesAs(ctx, await persona(ctx, 'jamie'), created.motionID);
                Assert(asJamie.length === 1 && asJamie[0].MembershipID.toLowerCase() === (await governanceSeat(ctx, 'jamie')).toLowerCase(), `Jamie reads her own vote through the user link (${asJamie.length})`);
                Assert((await votesAs(ctx, await persona(ctx, 'alex'), created.motionID)).length === 0, 'Alex, who has not voted on it, reads none');
            } finally {
                await remove(ctx, created);
            }
        },
    },
    {
        Id: 'ballot-sealing.BS7',
        Name: 'BS7 — the custom Membership and Meeting classes answer to their entity names through the class factory',
        RequiresMutation: false,
        Fn: async (ctx: IntegrationCheckContext) => {
            const membership = await ProviderOf(ctx).GetEntityObject(E_MEMBERSHIP, ctx.User);
            Assert(membership instanceof MembershipEntityCustom, `Committees: Memberships gives MembershipEntityCustom (${membership.constructor.name})`);
            const meeting = await ProviderOf(ctx).GetEntityObject(E_MEETING, ctx.User);
            Assert(meeting instanceof MeetingEntityCustom, `Committees: Meetings gives MeetingEntityCustom (${meeting.constructor.name})`);
        },
    },
];

for (const check of BallotSealingChecks) {
    IntegrationCheckRegistry.Instance.Register(check);
}
IntegrationCheckRegistry.Instance.RegisterLifecycle('ballot-sealing', {
    Setup: async (ctx: IntegrationCheckContext) => { await LoadWorld(ctx); },
    Teardown: async () => undefined,
});
