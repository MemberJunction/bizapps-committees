import { Metadata, RunView, UserInfo } from '@memberjunction/core';
import {
    mjCommitteesMembershipEntity,
    mjCommitteesAttendanceEntity,
} from '@mj-biz-apps/committees-entities';

/**
 * A membership record enriched with role and person details for display.
 */
export interface ActiveMemberInfo {
    MembershipID: string;
    PersonID: string;
    PersonName: string | null;
    RoleID: string;
    RoleName: string;
    StartDate: Date;
    Status: string;
}

/**
 * Quorum calculation result for a specific meeting.
 */
export interface QuorumResult {
    MeetingID: string;
    TotalVotingMembers: number;
    PresentVotingMembers: number;
    QuorumReached: boolean;
    QuorumThreshold: number;
}

/**
 * Service class for membership operations: adding members, listing active members,
 * and calculating quorum for meetings.
 */
export class MembershipService {
    /**
     * Creates a new Membership record linking a person to a committee via a term
     * with a specific role.
     */
    public async AddMemberToCommittee(
        personID: string,
        roleID: string,
        termID: string,
        contextUser: UserInfo
    ): Promise<mjCommitteesMembershipEntity> {
        const md = new Metadata();
        const membership = await md.GetEntityObject<mjCommitteesMembershipEntity>('Memberships', contextUser);
        membership.NewRecord();

        membership.PersonID = personID;
        membership.RoleID = roleID;
        membership.TermID = termID;
        membership.StartDate = new Date();
        membership.Status = 'Active';

        const saved = await membership.Save();
        if (!saved) {
            throw new Error(`Failed to add person ${personID} to term ${termID}`);
        }

        return membership;
    }

    /**
     * Returns all active members for a committee with their role and person
     * details using a read-only simple query. Resolves through Terms.
     */
    public async GetActiveMembers(
        committeeID: string,
        contextUser: UserInfo
    ): Promise<ActiveMemberInfo[]> {
        const rv = new RunView();

        // Step 1: Get term IDs for this committee
        const termsResult = await rv.RunView<{ ID: string }>({
            EntityName: 'Terms',
            ExtraFilter: `CommitteeID='${committeeID}'`,
            Fields: ['ID'],
            ResultType: 'simple',
        }, contextUser);

        if (!termsResult.Success || !termsResult.Results || termsResult.Results.length === 0) {
            return [];
        }

        const termIDs = termsResult.Results.map(t => `'${t.ID}'`).join(',');

        // Step 2: Get active memberships for those terms
        const result = await rv.RunView<{
            ID: string;
            PersonID: string;
            Person: string | null;
            RoleID: string;
            Role: string;
            StartDate: Date;
            Status: string;
        }>({
            EntityName: 'Memberships',
            ExtraFilter: `TermID IN (${termIDs}) AND Status='Active'`,
            Fields: ['ID', 'PersonID', 'Person', 'RoleID', 'Role', 'StartDate', 'Status'],
            OrderBy: 'Role, Person',
            ResultType: 'simple',
        }, contextUser);

        if (!result.Success) {
            throw new Error(`Failed to load active members for committee ${committeeID}: ${result.ErrorMessage}`);
        }

        return (result.Results ?? []).map(r => this.mapToActiveMemberInfo(r));
    }

    /**
     * Calculates quorum for a meeting by comparing the number of present voting
     * members to the total number of active voting members in the committee.
     * Uses a simple majority (> 50%) as the quorum threshold.
     */
    public async CalculateQuorum(
        meetingID: string,
        contextUser: UserInfo
    ): Promise<QuorumResult> {
        const committeeID = await this.getCommitteeIDForMeeting(meetingID, contextUser);
        const [votingMembers, presentAttendances] = await this.loadQuorumData(meetingID, committeeID, contextUser);

        const presentPersonIDs = new Set(
            presentAttendances
                .filter(a => a.AttendanceStatus === 'Present' || a.AttendanceStatus === 'Partial')
                .map(a => a.PersonID)
        );

        const votingMemberPersonIDs = votingMembers.map(m => m.PersonID);
        const presentVotingCount = votingMemberPersonIDs.filter(pid => presentPersonIDs.has(pid)).length;
        const totalVotingCount = votingMemberPersonIDs.length;
        const threshold = Math.floor(totalVotingCount / 2) + 1;

        return {
            MeetingID: meetingID,
            TotalVotingMembers: totalVotingCount,
            PresentVotingMembers: presentVotingCount,
            QuorumReached: presentVotingCount >= threshold,
            QuorumThreshold: threshold,
        };
    }

    /** Looks up the committee ID for a given meeting. */
    private async getCommitteeIDForMeeting(meetingID: string, contextUser: UserInfo): Promise<string> {
        const rv = new RunView();
        const result = await rv.RunView<{ CommitteeID: string }>({
            EntityName: 'Meetings',
            ExtraFilter: `ID='${meetingID}'`,
            Fields: ['CommitteeID'],
            ResultType: 'simple',
            MaxRows: 1,
        }, contextUser);

        if (!result.Success || !result.Results || result.Results.length === 0) {
            throw new Error(`Meeting not found: ${meetingID}`);
        }

        return result.Results[0].CommitteeID;
    }

    /**
     * Batch-loads voting members for the committee and attendance records for the
     * meeting using RunViews (plural). Resolves memberships through Terms.
     */
    private async loadQuorumData(
        meetingID: string,
        committeeID: string,
        contextUser: UserInfo
    ): Promise<[{ PersonID: string; IsVotingRole: boolean }[], { PersonID: string; AttendanceStatus: string }[]]> {
        const rv = new RunView();

        // First get term IDs for the committee
        const termsResult = await rv.RunView<{ ID: string }>({
            EntityName: 'Terms',
            ExtraFilter: `CommitteeID='${committeeID}'`,
            Fields: ['ID'],
            ResultType: 'simple',
        }, contextUser);

        if (!termsResult.Success || !termsResult.Results || termsResult.Results.length === 0) {
            return [[], []];
        }

        const termIDs = termsResult.Results.map(t => `'${t.ID}'`).join(',');

        const [membersResult, attendanceResult] = await rv.RunViews([
            {
                EntityName: 'Memberships',
                ExtraFilter: `TermID IN (${termIDs}) AND Status='Active'`,
                Fields: ['PersonID', 'RoleID'],
                ResultType: 'simple',
            },
            {
                EntityName: 'Attendances',
                ExtraFilter: `MeetingID='${meetingID}'`,
                Fields: ['PersonID', 'AttendanceStatus'],
                ResultType: 'simple',
            },
        ], contextUser);

        if (!membersResult.Success) {
            throw new Error(`Failed to load members for quorum calculation: ${membersResult.ErrorMessage}`);
        }
        if (!attendanceResult.Success) {
            throw new Error(`Failed to load attendances for quorum calculation: ${attendanceResult.ErrorMessage}`);
        }

        // Load roles to determine which are voting roles
        const votingRoleIDs = await this.getVotingRoleIDs(contextUser);
        const members = (membersResult.Results ?? []) as { PersonID: string; RoleID: string }[];
        const votingMembers = members
            .filter(m => votingRoleIDs.has(m.RoleID))
            .map(m => ({ PersonID: m.PersonID, IsVotingRole: true }));

        const attendances = (attendanceResult.Results ?? []) as { PersonID: string; AttendanceStatus: string }[];

        return [votingMembers, attendances];
    }

    /** Loads all role IDs that are designated as voting roles. */
    private async getVotingRoleIDs(contextUser: UserInfo): Promise<Set<string>> {
        const rv = new RunView();
        const result = await rv.RunView<{ ID: string }>({
            EntityName: 'Roles',
            ExtraFilter: `IsVotingRole=1`,
            Fields: ['ID'],
            ResultType: 'simple',
        }, contextUser);

        if (!result.Success) {
            throw new Error(`Failed to load voting roles: ${result.ErrorMessage}`);
        }

        return new Set((result.Results ?? []).map(r => r.ID));
    }

    /** Maps a raw membership row to an ActiveMemberInfo. */
    private mapToActiveMemberInfo(row: {
        ID: string;
        PersonID: string;
        Person: string | null;
        RoleID: string;
        Role: string;
        StartDate: Date;
        Status: string;
    }): ActiveMemberInfo {
        return {
            MembershipID: row.ID,
            PersonID: row.PersonID,
            PersonName: row.Person,
            RoleID: row.RoleID,
            RoleName: row.Role,
            StartDate: row.StartDate,
            Status: row.Status,
        };
    }
}
