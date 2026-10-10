import { LogError, Metadata, RunView, UserInfo, WellKnownUserSource } from '@memberjunction/core';
import { BallotService, CommitteesLookupEngine, type VoteTally } from '@mj-biz-apps/committees-core';
import type { mjBizAppsCommitteesBallotEntity, mjBizAppsCommitteesMotionEntity } from '@mj-biz-apps/committees-entities';

/**
 * Closing and cancelling e-ballots on the server (C0, ballot sealing).
 *
 * Votes are read through the "Committees: Visible Votes" row filter, so a member sees only their own vote while a
 * ballot is open and never another member's choice on a sealed ballot. The tally therefore cannot be computed in the
 * browser: this service reads the votes as the system user, computes the outcome with BallotService, stamps the
 * Motion and marks the Ballot Closed, then returns the tally. `Progress` gives an open ballot its participation
 * (who has voted, never how) so the ballot page can show it without seeing the choices.
 *
 * Authorization is the resolver's: CommitteeAuthorization decides who may close, cancel or look; this service
 * assumes the decision was made and fails closed on anything it cannot read.
 */

export type BallotCloseMode = 'Close' | 'Cancel';
export type BallotCloseOutcome = 'Passed' | 'Failed' | 'Cancelled';

export interface BallotCloseResult {
    Success: boolean;
    ErrorMessage?: string;
    /** Passed or Failed for a close, Cancelled for a cancel; null when the request failed. */
    Result: BallotCloseOutcome | null;
    Yes: number;
    No: number;
    Abstain: number;
    Cast: number;
    VotingMemberCount: number;
    RequiredYes: number;
    ResultNotes: string | null;
}

export interface BallotVoterProgress {
    MembershipID: string;
    /** When the vote was recorded, ISO 8601; null when unknown. */
    VotedAt: string | null;
}

export interface BallotProgressResult {
    Success: boolean;
    ErrorMessage?: string;
    BallotID: string;
    Status: string;
    Cast: number;
    VotingMemberCount: number;
    Outstanding: number;
    /** The memberships that have voted. Participation only: no choice is ever returned. */
    Voted: BallotVoterProgress[];
}

interface BallotRow {
    ID: string; CommitteeID: string; MotionID: string; ThresholdType: mjBizAppsCommitteesBallotEntity['ThresholdType'];
    IsSealed: boolean; Status: string;
}
interface TermRow { ID: string; }
interface MembershipRow { ID: string; TermID: string; RoleID: string; }
interface VoteRow { MembershipID: string; VoteValue: string; __mj_CreatedAt: string | Date | null; }

const GUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

export class BallotCloseService {
    /** Closes an open ballot: tallies as the system user, stamps the motion, marks the ballot Closed. */
    public async CloseBallot(ballotID: string, notes: string | null, contextUser: UserInfo): Promise<BallotCloseResult> {
        return this.run(ballotID, 'Close', notes, contextUser);
    }

    /** Cancels an open ballot: withdraws it without stamping the motion. A reason is required. */
    public async CancelBallot(ballotID: string, reason: string | null, contextUser: UserInfo): Promise<BallotCloseResult> {
        return this.run(ballotID, 'Cancel', reason, contextUser);
    }

    /** Participation on a ballot in any status: counts and who has voted, never how. */
    public async Progress(ballotID: string, contextUser: UserInfo): Promise<BallotProgressResult> {
        try {
            if (!GUID.test(ballotID)) return this.progressFailure(ballotID, 'Invalid ballot ID');
            const ballot = await this.loadBallot(ballotID, contextUser);
            if (!ballot) return this.progressFailure(ballotID, 'Ballot not found');
            const system = await this.systemUser();
            if (!system) return this.progressFailure(ballotID, 'No system user is configured; the ballot cannot be read');
            const voters = await this.votingMembers(ballot, system);
            const votes = await this.loadVotes(ballot.MotionID, system);
            const tally = BallotService.ComputeTally(votes, voters.length);
            return {
                Success: true,
                BallotID: ballot.ID,
                Status: ballot.Status,
                Cast: tally.Cast,
                VotingMemberCount: voters.length,
                Outstanding: tally.Outstanding,
                Voted: votes.map((v) => ({ MembershipID: v.MembershipID, VotedAt: this.isoOf(v.__mj_CreatedAt) })),
            };
        } catch (err) {
            const message = err instanceof Error ? err.message : String(err);
            LogError(`[BallotCloseService] Progress ${ballotID}: ${message}`);
            return this.progressFailure(ballotID, message);
        }
    }

    // ── Close / cancel ──────────────────────────────────────────

    private async run(ballotID: string, mode: BallotCloseMode, notes: string | null, contextUser: UserInfo): Promise<BallotCloseResult> {
        try {
            if (!GUID.test(ballotID)) return this.failure('Invalid ballot ID');
            const trimmed = (notes ?? '').trim();
            if (mode === 'Cancel' && trimmed.length === 0) return this.failure('A reason is required to cancel a ballot');
            const ballot = await this.loadBallot(ballotID, contextUser);
            if (!ballot) return this.failure('Ballot not found');
            if (ballot.Status !== 'Open') return this.failure(`Only an open ballot can be ${mode === 'Close' ? 'closed' : 'cancelled'}; this one is ${ballot.Status}`);
            const system = await this.systemUser();
            if (!system) return this.failure('No system user is configured; the ballot cannot be tallied');

            const voters = await this.votingMembers(ballot, system);
            const votes = await this.loadVotes(ballot.MotionID, system);
            const tally = BallotService.ComputeTally(votes, voters.length);
            const requiredYes = BallotService.RequiredYes(ballot.ThresholdType, voters.length);

            if (mode === 'Cancel') {
                await this.writeBallot(ballot.ID, 'Cancelled', trimmed, system);
                return this.outcome('Cancelled', tally, voters.length, requiredYes, trimmed);
            }
            const result = this.decide(tally, ballot, voters.length);
            const summary = trimmed || this.summary(result, tally, ballot, voters.length);
            await this.stampMotion(ballot.MotionID, result, summary, tally, system);
            await this.writeBallot(ballot.ID, 'Closed', summary, system);
            return this.outcome(result, tally, voters.length, requiredYes, summary);
        } catch (err) {
            const message = err instanceof Error ? err.message : String(err);
            LogError(`[BallotCloseService] ${mode} ${ballotID}: ${message}`);
            return this.failure(message);
        }
    }

    /** The outcome the way the close dialog projected it: the recorded votes, no outstanding ones counted. */
    private decide(tally: VoteTally, ballot: BallotRow, votingMemberCount: number): 'Passed' | 'Failed' {
        const forecast = BallotService.ForecastOutcome({ ...tally, Outstanding: 0 }, ballot.ThresholdType, 'VotingMembers', votingMemberCount);
        return forecast.Outcome === 'Passed' ? 'Passed' : 'Failed';
    }

    private summary(result: 'Passed' | 'Failed', tally: VoteTally, ballot: BallotRow, votingMemberCount: number): string {
        return `E-ballot ${result.toLowerCase()} ${tally.Yes}-${tally.No}-${tally.Abstain}`
            + ` (${this.thresholdLabel(ballot.ThresholdType)}, ${tally.Cast} of ${votingMemberCount} voting members cast)`;
    }

    private thresholdLabel(threshold: BallotRow['ThresholdType']): string {
        switch (threshold) {
            case 'TwoThirds': return 'two-thirds';
            case 'Unanimous': return 'unanimous';
            default: return 'simple majority';
        }
    }

    private async stampMotion(motionID: string, result: 'Passed' | 'Failed', summary: string, tally: VoteTally, system: UserInfo): Promise<void> {
        const md = new Metadata();
        const motion = await md.GetEntityObject<mjBizAppsCommitteesMotionEntity>('Committees: Motions', system);
        if (!await motion.Load(motionID)) throw new Error('Motion not found');
        motion.Result = result;
        motion.ResultSummary = summary;
        motion.YesCount = tally.Yes;
        motion.NoCount = tally.No;
        motion.AbstainCount = tally.Abstain;
        if (!await motion.Save()) throw new Error(motion.LatestResult?.CompleteMessage ?? 'Motion stamp failed');
    }

    private async writeBallot(ballotID: string, status: 'Closed' | 'Cancelled', notes: string, system: UserInfo): Promise<void> {
        const md = new Metadata();
        const ballot = await md.GetEntityObject<mjBizAppsCommitteesBallotEntity>('Committees: Ballots', system);
        if (!await ballot.Load(ballotID)) throw new Error('Ballot not found');
        ballot.Status = status;
        ballot.ClosedAt = new Date();
        ballot.ResultNotes = notes.length > 0 ? notes : null;
        if (!await ballot.Save()) throw new Error(ballot.LatestResult?.CompleteMessage ?? 'Ballot save failed');
    }

    // ── Reads ───────────────────────────────────────────────────

    /** The ballot as the caller sees it: a caller who cannot reach it gets "not found". */
    private async loadBallot(ballotID: string, contextUser: UserInfo): Promise<BallotRow | null> {
        const rv = new RunView();
        const result = await rv.RunView<BallotRow>({
            EntityName: 'Committees: Ballots',
            ExtraFilter: `ID = '${ballotID}'`,
            Fields: ['ID', 'CommitteeID', 'MotionID', 'ThresholdType', 'IsSealed', 'Status'],
            MaxRows: 1,
            ResultType: 'simple',
        }, contextUser);
        if (!result.Success) throw new Error(result.ErrorMessage ?? 'The ballot could not be read');
        return result.Results?.[0] ?? null;
    }

    /** Active memberships in the committee's active terms whose role votes. */
    private async votingMembers(ballot: BallotRow, system: UserInfo): Promise<MembershipRow[]> {
        await CommitteesLookupEngine.Instance.Config(false, system);
        const rv = new RunView();
        const terms = await rv.RunView<TermRow>({
            EntityName: 'Committees: Terms',
            ExtraFilter: `CommitteeID = '${ballot.CommitteeID}' AND Status = 'Active'`,
            Fields: ['ID'],
            ResultType: 'simple',
        }, system);
        if (!terms.Success) throw new Error(terms.ErrorMessage ?? 'The committee terms could not be read');
        const termIDs = (terms.Results ?? []).map((t) => t.ID);
        if (termIDs.length === 0) return [];
        const memberships = await rv.RunView<MembershipRow>({
            EntityName: 'Committees: Memberships',
            ExtraFilter: `Status = 'Active' AND TermID IN (${termIDs.map((id) => `'${id}'`).join(',')})`,
            Fields: ['ID', 'TermID', 'RoleID'],
            ResultType: 'simple',
        }, system);
        if (!memberships.Success) throw new Error(memberships.ErrorMessage ?? 'The memberships could not be read');
        const votingRoles = new Set(CommitteesLookupEngine.Instance.Roles.filter((r) => r.IsVotingRole).map((r) => r.ID.toLowerCase()));
        return (memberships.Results ?? []).filter((m) => votingRoles.has(m.RoleID.toLowerCase()));
    }

    private async loadVotes(motionID: string, system: UserInfo): Promise<VoteRow[]> {
        const rv = new RunView();
        const result = await rv.RunView<VoteRow>({
            EntityName: 'Committees: Votes',
            ExtraFilter: `MotionID = '${motionID}'`,
            Fields: ['MembershipID', 'VoteValue', '__mj_CreatedAt'],
            ResultType: 'simple',
        }, system);
        if (!result.Success) throw new Error(result.ErrorMessage ?? 'The votes could not be read');
        return result.Results ?? [];
    }

    private async systemUser(): Promise<UserInfo | null> {
        return (await WellKnownUserSource.Instance.GetSystemUser(Metadata.Provider)) ?? null;
    }

    // ── Shapes ──────────────────────────────────────────────────

    private isoOf(value: string | Date | null): string | null {
        if (!value) return null;
        const date = value instanceof Date ? value : new Date(value);
        return Number.isNaN(date.getTime()) ? null : date.toISOString();
    }

    private outcome(result: BallotCloseOutcome, tally: VoteTally, votingMemberCount: number, requiredYes: number, notes: string): BallotCloseResult {
        return {
            Success: true, Result: result, Yes: tally.Yes, No: tally.No, Abstain: tally.Abstain, Cast: tally.Cast,
            VotingMemberCount: votingMemberCount, RequiredYes: requiredYes, ResultNotes: notes.length > 0 ? notes : null,
        };
    }

    private failure(message: string): BallotCloseResult {
        return { Success: false, ErrorMessage: message, Result: null, Yes: 0, No: 0, Abstain: 0, Cast: 0, VotingMemberCount: 0, RequiredYes: 0, ResultNotes: null };
    }

    private progressFailure(ballotID: string, message: string): BallotProgressResult {
        return { Success: false, ErrorMessage: message, BallotID: ballotID, Status: '', Cast: 0, VotingMemberCount: 0, Outstanding: 0, Voted: [] };
    }
}
