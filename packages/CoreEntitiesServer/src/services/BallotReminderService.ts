import { Metadata, RunView, UserInfo, LogError } from '@memberjunction/core';
import { MJUserNotificationEntity } from '@memberjunction/core-entities';

/**
 * "Remind" for open e-ballots (Phase 4 feature 2): finds voting members who
 * have not yet cast a vote on the ballot's motion and creates an in-app
 * MJ User Notification for each one with a linked user account.
 *
 * Email delivery arrives with the notification-digest workstream — this
 * service isolates the non-voter computation so the digest can reuse it.
 */

export interface RemindResult {
    Success: boolean;
    ErrorMessage?: string;
    /** Voting members without a vote on the motion. */
    TotalNonVoters: number;
    /** Non-voters who received an in-app notification. */
    RemindedCount: number;
    /** Non-voters with no linked user account — unreachable in-app. */
    UnreachableNames: string[];
}

interface BallotRow {
    ID: string; CommitteeID: string; Committee: string; MotionID: string;
    Motion: string; ClosesAt: string; Status: string;
}
interface TermRow { ID: string; CommitteeID: string; Status: string; }
interface MembershipRow { ID: string; TermID: string; PersonID: string; Person: string; RoleID: string; }
interface RoleRow { ID: string; IsVotingRole: boolean; }
interface VoteRow { MembershipID: string; }
interface PersonRow { ID: string; LinkedUserID: string | null; }

export class BallotReminderService {
    public async RemindNonVoters(ballotID: string, contextUser: UserInfo): Promise<RemindResult> {
        try {
            const ballot = await this.loadBallot(ballotID, contextUser);
            if (!ballot) return this.fail('Ballot not found');
            if (ballot.Status !== 'Open') return this.fail('Only open ballots can send reminders');

            const nonVoters = await this.findNonVoters(ballot, contextUser);
            if (nonVoters.length === 0) {
                return { Success: true, TotalNonVoters: 0, RemindedCount: 0, UnreachableNames: [] };
            }

            const linked = await this.loadLinkedUsers(nonVoters.map(m => m.PersonID), contextUser);
            const reachable = nonVoters.filter(m => linked.get(m.PersonID.toLowerCase()));
            const unreachable = nonVoters.filter(m => !linked.get(m.PersonID.toLowerCase()));

            await this.notify(reachable.map(m => linked.get(m.PersonID.toLowerCase())!), ballot, contextUser);
            return {
                Success: true,
                TotalNonVoters: nonVoters.length,
                RemindedCount: reachable.length,
                UnreachableNames: unreachable.map(m => m.Person),
            };
        } catch (err) {
            const message = err instanceof Error ? err.message : String(err);
            LogError(`[BallotReminderService] ${message}`);
            return this.fail(message);
        }
    }

    // ── Non-voter computation (digest reuses this) ──────────────

    public async findNonVoters(ballot: BallotRow, contextUser: UserInfo): Promise<MembershipRow[]> {
        const rv = new RunView();
        const [termsR, membershipsR, rolesR, votesR] = await rv.RunViews([
            { EntityName: 'Committees: Terms', ExtraFilter: `CommitteeID = '${ballot.CommitteeID}' AND Status = 'Active'`, Fields: ['ID', 'CommitteeID', 'Status'], ResultType: 'simple' },
            { EntityName: 'Committees: Memberships', ExtraFilter: "Status = 'Active'", Fields: ['ID', 'TermID', 'PersonID', 'Person', 'RoleID'], ResultType: 'simple' },
            { EntityName: 'Committees: Roles', Fields: ['ID', 'IsVotingRole'], ResultType: 'simple' },
            { EntityName: 'Committees: Votes', ExtraFilter: `MotionID = '${ballot.MotionID}'`, Fields: ['MembershipID'], ResultType: 'simple' },
        ], contextUser);
        const terms = (termsR.Success ? termsR.Results : []) as unknown as TermRow[];
        const memberships = (membershipsR.Success ? membershipsR.Results : []) as unknown as MembershipRow[];
        const roles = (rolesR.Success ? rolesR.Results : []) as unknown as RoleRow[];
        const votes = (votesR.Success ? votesR.Results : []) as unknown as VoteRow[];

        const termIDs = new Set(terms.map(t => t.ID.toLowerCase()));
        const votingRoles = new Set(roles.filter(r => r.IsVotingRole).map(r => r.ID.toLowerCase()));
        const voted = new Set(votes.map(v => v.MembershipID.toLowerCase()));

        return memberships.filter(m =>
            termIDs.has(m.TermID.toLowerCase()) &&
            votingRoles.has(m.RoleID.toLowerCase()) &&
            !voted.has(m.ID.toLowerCase()));
    }

    // ── Plumbing ────────────────────────────────────────────────

    private async loadBallot(ballotID: string, contextUser: UserInfo): Promise<BallotRow | null> {
        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'Committees: Ballots',
            ExtraFilter: `ID = '${ballotID}'`,
            Fields: ['ID', 'CommitteeID', 'Committee', 'MotionID', 'Motion', 'ClosesAt', 'Status'],
            ResultType: 'simple',
        }, contextUser);
        const rows = (result.Success ? result.Results : []) as unknown as BallotRow[];
        return rows[0] ?? null;
    }

    private async loadLinkedUsers(personIDs: string[], contextUser: UserInfo): Promise<Map<string, string>> {
        if (personIDs.length === 0) return new Map();
        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'MJ_BizApps_Common: People',
            ExtraFilter: `ID IN (${personIDs.map(id => `'${id}'`).join(',')})`,
            Fields: ['ID', 'LinkedUserID'],
            ResultType: 'simple',
        }, contextUser);
        const people = (result.Success ? result.Results : []) as unknown as PersonRow[];
        return new Map(people.filter(p => p.LinkedUserID).map(p => [p.ID.toLowerCase(), p.LinkedUserID!]));
    }

    private async notify(userIDs: string[], ballot: BallotRow, contextUser: UserInfo): Promise<void> {
        const md = new Metadata();
        const closes = new Date(ballot.ClosesAt).toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
        for (const userID of userIDs) {
            const n = await md.GetEntityObject<MJUserNotificationEntity>('MJ: User Notifications', contextUser);
            n.UserID = userID;
            n.Title = `Your vote is needed: ${ballot.Motion}`;
            n.Message = `${ballot.Committee} has an open e-ballot that closes ${closes}. Cast your vote from My Committees.`;
            n.Unread = true;
            if (!await n.Save()) {
                LogError(`[BallotReminderService] notification save failed for user ${userID}: ${n.LatestResult?.Message}`);
            }
        }
    }

    private fail(message: string): RemindResult {
        return { Success: false, ErrorMessage: message, TotalNonVoters: 0, RemindedCount: 0, UnreachableNames: [] };
    }
}
