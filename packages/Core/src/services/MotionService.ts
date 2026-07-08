import { RunView, UserInfo } from '@memberjunction/core';
import { BallotService, VoteTally } from './BallotService.js';

/**
 * Motion register + roll-call assembly for Phase 2 "Govern"
 * (UX v2 screen 04 register, screen 03 roll call, workspace Motions tab).
 *
 * The Motion view carries no denormalized names, so the register is
 * assembled from batched loads (Motions + Meetings + Committees +
 * Memberships + Votes) — never per-row queries. Assembly functions are
 * static and pure for testability, mirroring CommitteeHealthService.
 */

export interface MotionRow {
    ID: string;
    MeetingID: string | null;
    AgendaItemID: string | null;
    Name: string;
    Description: string | null;
    MovedByMembershipID: string | null;
    SecondedByMembershipID: string | null;
    Result: string;
    ResultSummary: string | null;
    YesCount: number | null;
    NoCount: number | null;
    AbstainCount: number | null;
    Notes: string | null;
    __mj_CreatedAt: Date;
}

export interface MeetingRefRow {
    ID: string;
    CommitteeID: string;
    Committee: string;
    Name: string;
    StartDateTime: Date;
}

export interface MembershipRefRow {
    ID: string;
    PersonID: string;
    Person: string;
    Role: string;
}

export interface VoteRow {
    ID: string;
    MotionID: string;
    MembershipID: string;
    VoteValue: string;
    Notes: string | null;
    /** When the vote was cast — drives ballot audit trails and "Voted Apr 4" chips. */
    __mj_CreatedAt?: Date;
}

/** One row of the cross-committee motion register (mockup: register table). */
export interface MotionRegisterRow {
    MotionID: string;
    Name: string;
    Description: string | null;
    CommitteeID: string | null;
    CommitteeName: string | null;
    MeetingID: string | null;
    MeetingTitle: string | null;
    /** Null for between-meeting (ballot) motions — register renders "Between meetings". */
    MeetingDate: Date | null;
    MovedByName: string | null;
    SecondedByName: string | null;
    Result: string;
    Tally: VoteTally | null;
    /** True when the motion has no meeting (decided by e-ballot). */
    IsBallotMotion: boolean;
    Notes: string | null;
}

/** One member line in a roll-call detail (mockup: expanded register row / live roll call). */
export interface RollCallEntry {
    MembershipID: string;
    PersonName: string;
    RoleName: string;
    VoteValue: string | null;
    VoteNotes: string | null;
}

export interface MotionRegisterData {
    Rows: MotionRegisterRow[];
    /** Votes grouped by MotionID for expandable roll-call details. */
    VotesByMotion: Map<string, VoteRow[]>;
    /** Membership lookup shared by roll-call rendering. */
    MembershipsByID: Map<string, MembershipRefRow>;
}

export class MotionService {
    /**
     * Load everything the register needs in two batched calls.
     * committeeID narrows to one committee (workspace Motions tab); omit for
     * the cross-committee register page.
     */
    public async GetRegister(committeeID?: string, contextUser?: UserInfo): Promise<MotionRegisterData> {
        const rv = new RunView();
        const [motions, meetings, memberships] = await rv.RunViews([
            { EntityName: 'Committees: Motions', OrderBy: '__mj_CreatedAt DESC', ResultType: 'simple' },
            { EntityName: 'Committees: Meetings', Fields: ['ID', 'CommitteeID', 'Committee', 'Name', 'StartDateTime'], ResultType: 'simple' },
            { EntityName: 'Committees: Memberships', Fields: ['ID', 'PersonID', 'Person', 'Role'], ResultType: 'simple' },
        ], contextUser);

        const motionRows = (motions.Success ? motions.Results : []) as unknown as MotionRow[];
        const meetingRows = (meetings.Success ? meetings.Results : []) as unknown as MeetingRefRow[];
        const membershipRows = (memberships.Success ? memberships.Results : []) as unknown as MembershipRefRow[];

        const votes = await this.loadVotes(motionRows.map(m => m.ID), contextUser);
        const data = MotionService.BuildRegister(motionRows, meetingRows, membershipRows, votes);

        if (committeeID) {
            data.Rows = data.Rows.filter(r => r.CommitteeID != null && r.CommitteeID.toLowerCase() === committeeID.toLowerCase());
        }
        return data;
    }

    private async loadVotes(motionIDs: string[], contextUser?: UserInfo): Promise<VoteRow[]> {
        if (motionIDs.length === 0) return [];
        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'Committees: Votes',
            ExtraFilter: `MotionID IN (${motionIDs.map(id => `'${id}'`).join(',')})`,
            Fields: ['ID', 'MotionID', 'MembershipID', 'VoteValue', 'Notes', '__mj_CreatedAt'],
            ResultType: 'simple',
        }, contextUser);
        return (result.Success ? result.Results : []) as unknown as VoteRow[];
    }

    /** Pure assembly: joins motions to meetings/committees/people and tallies votes. */
    public static BuildRegister(
        motions: MotionRow[],
        meetings: MeetingRefRow[],
        memberships: MembershipRefRow[],
        votes: VoteRow[]
    ): MotionRegisterData {
        const meetingsByID = new Map(meetings.map(m => [m.ID.toLowerCase(), m]));
        const membershipsByID = new Map(memberships.map(m => [m.ID.toLowerCase(), m]));
        const votesByMotion = new Map<string, VoteRow[]>();
        for (const v of votes) {
            const key = v.MotionID.toLowerCase();
            const list = votesByMotion.get(key) ?? [];
            list.push(v);
            votesByMotion.set(key, list);
        }

        const rows = motions.map(m => MotionService.buildRow(m, meetingsByID, membershipsByID, votesByMotion));
        return { Rows: rows, VotesByMotion: votesByMotion, MembershipsByID: membershipsByID };
    }

    private static buildRow(
        m: MotionRow,
        meetingsByID: Map<string, MeetingRefRow>,
        membershipsByID: Map<string, MembershipRefRow>,
        votesByMotion: Map<string, VoteRow[]>
    ): MotionRegisterRow {
        const meeting = m.MeetingID ? meetingsByID.get(m.MeetingID.toLowerCase()) ?? null : null;
        const motionVotes = votesByMotion.get(m.ID.toLowerCase()) ?? [];
        // Stamped counts (recorded result) win; live tallies come from Vote rows.
        const tally = MotionService.effectiveTally(m, motionVotes);
        return {
            MotionID: m.ID,
            Name: m.Name,
            Description: m.Description,
            CommitteeID: meeting?.CommitteeID ?? null,
            CommitteeName: meeting?.Committee ?? null,
            MeetingID: m.MeetingID,
            MeetingTitle: meeting?.Name ?? null,
            MeetingDate: meeting ? new Date(meeting.StartDateTime) : null,
            MovedByName: m.MovedByMembershipID ? membershipsByID.get(m.MovedByMembershipID.toLowerCase())?.Person ?? null : null,
            SecondedByName: m.SecondedByMembershipID ? membershipsByID.get(m.SecondedByMembershipID.toLowerCase())?.Person ?? null : null,
            Result: m.Result,
            Tally: tally,
            IsBallotMotion: m.MeetingID == null,
            Notes: m.Notes,
        };
    }

    /** Stamped Motion counts when recorded; otherwise tallied from Vote rows; null when neither. */
    private static effectiveTally(m: MotionRow, votes: VoteRow[]): VoteTally | null {
        if (m.YesCount != null || m.NoCount != null || m.AbstainCount != null) {
            const yes = m.YesCount ?? 0, no = m.NoCount ?? 0, abstain = m.AbstainCount ?? 0;
            return { Yes: yes, No: no, Abstain: abstain, Cast: yes + no + abstain, Outstanding: 0 };
        }
        if (votes.length > 0) return BallotService.ComputeTally(votes, votes.length);
        return null;
    }

    /**
     * Roll-call detail for one motion: every eligible voter with their vote
     * (or null while outstanding/sealed). Callers pass the eligible
     * memberships (the committee's active voting members at vote time — or,
     * for historical motions, everyone who has a Vote row).
     */
    public static BuildRollCall(
        eligible: MembershipRefRow[],
        votes: VoteRow[],
        sealed: boolean
    ): RollCallEntry[] {
        const votesByMembership = new Map(votes.map(v => [v.MembershipID.toLowerCase(), v]));
        return eligible.map(m => {
            const vote = votesByMembership.get(m.ID.toLowerCase()) ?? null;
            return {
                MembershipID: m.ID,
                PersonName: m.Person,
                RoleName: m.Role,
                VoteValue: sealed ? null : vote?.VoteValue ?? null,
                VoteNotes: sealed ? null : vote?.Notes ?? null,
            };
        });
    }
}
