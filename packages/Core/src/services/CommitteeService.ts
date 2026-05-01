import { Metadata, RunView, UserInfo } from '@memberjunction/core';
import {
    mjCommitteesCommitteeEntity,
    mjCommitteesMembershipEntity,
    mjCommitteesMeetingEntity,
    mjCommitteesActionItemEntity,
} from '@mj-biz-apps/committees-entities';

/**
 * Summary of a single membership for a person, used in cross-committee views.
 */
export interface CommitteeMembershipSummary {
    MembershipID: string;
    CommitteeID: string;
    CommitteeName: string;
    RoleID: string;
    RoleName: string;
    Status: string;
    StartDate: Date;
    EndDate: Date | null;
}

/**
 * Full committee details including members, upcoming meetings, and recent action items.
 */
export interface CommitteeDetails {
    Committee: mjCommitteesCommitteeEntity;
    Members: mjCommitteesMembershipEntity[];
    UpcomingMeetings: mjCommitteesMeetingEntity[];
    RecentActionItems: mjCommitteesActionItemEntity[];
}

/**
 * Service class for committee-level operations including loading committee
 * details and finding committees for a given person.
 */
export class CommitteeService {
    /**
     * Loads a committee along with its active members, upcoming meetings, and
     * recent open/in-progress action items in a single batched query.
     */
    public async GetCommitteeWithDetails(
        committeeID: string,
        contextUser: UserInfo
    ): Promise<CommitteeDetails> {
        const committee = await this.loadCommittee(committeeID, contextUser);
        const [members, meetings, actionItems] = await this.loadRelatedData(committeeID, contextUser);

        return {
            Committee: committee,
            Members: members,
            UpcomingMeetings: meetings,
            RecentActionItems: actionItems,
        };
    }

    /**
     * Finds all committees a person belongs to, returning a lightweight summary
     * for each membership using a read-only simple query.
     */
    public async GetCommitteesForPerson(
        personID: string,
        contextUser: UserInfo
    ): Promise<CommitteeMembershipSummary[]> {
        const rv = new RunView();
        const result = await rv.RunView<{
            ID: string;
            CommitteeID: string;
            Committee: string;
            RoleID: string;
            Role: string;
            Status: string;
            StartDate: Date;
            EndDate: Date | null;
        }>({
            EntityName: 'Committees: Memberships',
            ExtraFilter: `PersonID='${personID}'`,
            Fields: ['ID', 'CommitteeID', 'Committee', 'RoleID', 'Role', 'Status', 'StartDate', 'EndDate'],
            OrderBy: 'Status, Committee',
            ResultType: 'simple',
        }, contextUser);

        if (!result.Success) {
            throw new Error(`Failed to load memberships for person ${personID}: ${result.ErrorMessage}`);
        }

        return (result.Results ?? []).map(r => this.mapToMembershipSummary(r));
    }

    /** Loads the committee entity object by ID. */
    private async loadCommittee(committeeID: string, contextUser: UserInfo): Promise<mjCommitteesCommitteeEntity> {
        const md = new Metadata();
        const committee = await md.GetEntityObject<mjCommitteesCommitteeEntity>('Committees: Committees', contextUser);
        const loaded = await committee.Load(committeeID);
        if (!loaded) {
            throw new Error(`Committee not found: ${committeeID}`);
        }
        return committee;
    }

    /**
     * Batch-loads members, upcoming meetings, and recent action items for a
     * committee using RunViews (plural) to minimize database round trips.
     */
    private async loadRelatedData(
        committeeID: string,
        contextUser: UserInfo
    ): Promise<[mjCommitteesMembershipEntity[], mjCommitteesMeetingEntity[], mjCommitteesActionItemEntity[]]> {
        const rv = new RunView();
        const now = new Date().toISOString();

        const [membersResult, meetingsResult, actionItemsResult] = await rv.RunViews([
            {
                EntityName: 'Committees: Memberships',
                ExtraFilter: `CommitteeID='${committeeID}' AND Status='Active'`,
                OrderBy: 'Role',
                ResultType: 'entity_object',
            },
            {
                EntityName: 'Committees: Meetings',
                ExtraFilter: `CommitteeID='${committeeID}' AND StartDateTime >= '${now}'`,
                OrderBy: 'StartDateTime ASC',
                MaxRows: 10,
                ResultType: 'entity_object',
            },
            {
                EntityName: 'Committees: Action Items',
                ExtraFilter: `CommitteeID='${committeeID}' AND Status IN ('Open', 'InProgress')`,
                OrderBy: 'DueDate ASC',
                MaxRows: 20,
                ResultType: 'entity_object',
            },
        ], contextUser);

        return [
            membersResult.Success ? (membersResult.Results ?? []) as mjCommitteesMembershipEntity[] : [],
            meetingsResult.Success ? (meetingsResult.Results ?? []) as mjCommitteesMeetingEntity[] : [],
            actionItemsResult.Success ? (actionItemsResult.Results ?? []) as mjCommitteesActionItemEntity[] : [],
        ];
    }

    /** Maps a raw membership row to a CommitteeMembershipSummary. */
    private mapToMembershipSummary(row: {
        ID: string;
        CommitteeID: string;
        Committee: string;
        RoleID: string;
        Role: string;
        Status: string;
        StartDate: Date;
        EndDate: Date | null;
    }): CommitteeMembershipSummary {
        return {
            MembershipID: row.ID,
            CommitteeID: row.CommitteeID,
            CommitteeName: row.Committee,
            RoleID: row.RoleID,
            RoleName: row.Role,
            Status: row.Status,
            StartDate: row.StartDate,
            EndDate: row.EndDate,
        };
    }
}
