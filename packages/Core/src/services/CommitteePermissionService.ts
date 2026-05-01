import { Metadata, RunView, UserInfo } from '@memberjunction/core';

/**
 * Resolved permissions for a user within a specific committee.
 */
export interface CommitteePermissions {
    /** Whether the user has an active membership in this committee */
    IsMember: boolean;
    /** Whether the user's role has IsOfficer = true (Chair, Vice Chair, Secretary) */
    IsOfficer: boolean;
    /** Whether the user's role is specifically 'Chair' */
    IsChair: boolean;
    /** The user's role name, or null if not a member */
    RoleName: string | null;
    /** Officers can add/remove/edit members */
    CanManageMembers: boolean;
    /** Officers can schedule/edit/cancel meetings */
    CanManageMeetings: boolean;
    /** Officers can edit committee details */
    CanEditCommittee: boolean;
    /** Any active member can view committee details */
    CanView: boolean;
}

const NO_PERMISSIONS: CommitteePermissions = {
    IsMember: false,
    IsOfficer: false,
    IsChair: false,
    RoleName: null,
    CanManageMembers: false,
    CanManageMeetings: false,
    CanEditCommittee: false,
    CanView: false,
};

/**
 * Resolves a user's permissions within a committee based on their membership role.
 *
 * Resolution chain: User (by ID) → Person (via LinkedUserID) → Membership (via Terms) → Role
 */
export class CommitteePermissionService {
    /**
     * Resolves the permissions for a given MJ User ID within a committee.
     * Returns NO_PERMISSIONS if the user is not a member.
     */
    public async GetUserPermissions(
        committeeID: string,
        userID: string,
        contextUser?: UserInfo
    ): Promise<CommitteePermissions> {
        const personID = await this.resolvePersonID(userID, contextUser);
        if (!personID) return NO_PERMISSIONS;

        return this.GetPersonPermissions(committeeID, personID, contextUser);
    }

    /**
     * Resolves permissions for a known Person ID within a committee.
     * Useful when the Person ID is already known (avoids the User → Person lookup).
     */
    public async GetPersonPermissions(
        committeeID: string,
        personID: string,
        contextUser?: UserInfo
    ): Promise<CommitteePermissions> {
        const membership = await this.findActiveMembership(committeeID, personID, contextUser);
        if (!membership) return NO_PERMISSIONS;

        const isOfficer = membership.IsOfficer === true || membership.IsOfficer === 1;
        const isChair = membership.Role === 'Chair';

        return {
            IsMember: true,
            IsOfficer: isOfficer,
            IsChair: isChair,
            RoleName: membership.Role,
            CanManageMembers: isOfficer,
            CanManageMeetings: isOfficer,
            CanEditCommittee: isOfficer,
            CanView: true,
        };
    }

    /**
     * Batch-resolves permissions for a user across multiple committees.
     * Returns a map of committeeID → permissions.
     */
    public async GetUserPermissionsForCommittees(
        committeeIDs: string[],
        userID: string,
        contextUser?: UserInfo
    ): Promise<Map<string, CommitteePermissions>> {
        const result = new Map<string, CommitteePermissions>();
        if (committeeIDs.length === 0) return result;

        const personID = await this.resolvePersonID(userID, contextUser);
        if (!personID) {
            for (const id of committeeIDs) result.set(id, NO_PERMISSIONS);
            return result;
        }

        const memberships = await this.findActiveMembershipsForPerson(personID, contextUser);

        for (const cid of committeeIDs) {
            const membership = memberships.find(m => m.CommitteeID === cid);
            if (!membership) {
                result.set(cid, NO_PERMISSIONS);
                continue;
            }
            const isOfficer = membership.IsOfficer === true || membership.IsOfficer === 1;
            const isChair = membership.Role === 'Chair';
            result.set(cid, {
                IsMember: true,
                IsOfficer: isOfficer,
                IsChair: isChair,
                RoleName: membership.Role,
                CanManageMembers: isOfficer,
                CanManageMeetings: isOfficer,
                CanEditCommittee: isOfficer,
                CanView: true,
            });
        }

        return result;
    }

    /** Resolves an MJ User ID to a Person ID via LinkedUserID. */
    private async resolvePersonID(userID: string, contextUser?: UserInfo): Promise<string | null> {
        const rv = new RunView();
        const result = await rv.RunView<{ ID: string }>({
            EntityName: 'MJ.BizApps.Common: People',
            ExtraFilter: `LinkedUserID = '${userID}'`,
            Fields: ['ID'],
            MaxRows: 1,
            ResultType: 'simple',
        }, contextUser);

        if (!result.Success || !result.Results || result.Results.length === 0) {
            return null;
        }
        return result.Results[0].ID;
    }

    /**
     * Finds the user's active membership in a specific committee.
     * Joins through Terms to find the committee relationship.
     */
    private async findActiveMembership(
        committeeID: string,
        personID: string,
        contextUser?: UserInfo
    ): Promise<MembershipRoleRow | null> {
        // Step 1: Get term IDs for this committee
        const rv = new RunView();
        const termsResult = await rv.RunView<{ ID: string }>({
            EntityName: 'Committees: Terms',
            ExtraFilter: `CommitteeID = '${committeeID}'`,
            Fields: ['ID'],
            ResultType: 'simple',
        }, contextUser);

        if (!termsResult.Success || !termsResult.Results || termsResult.Results.length === 0) {
            return null;
        }

        const termIDs = termsResult.Results.map(t => `'${t.ID}'`).join(',');

        // Step 2: Find active membership for this person in those terms
        const memberResult = await rv.RunView<MembershipRoleRow>({
            EntityName: 'Committees: Memberships',
            ExtraFilter: `PersonID = '${personID}' AND TermID IN (${termIDs}) AND Status = 'Active'`,
            Fields: ['ID', 'RoleID', 'Role', 'TermID'],
            MaxRows: 1,
            OrderBy: 'Role ASC',
            ResultType: 'simple',
        }, contextUser);

        if (!memberResult.Success || !memberResult.Results || memberResult.Results.length === 0) {
            return null;
        }

        // Step 3: Check if the role is an officer role
        const membership = memberResult.Results[0];
        const roleResult = await rv.RunView<{ IsOfficer: boolean | number }>({
            EntityName: 'Committees: Roles',
            ExtraFilter: `ID = '${membership.RoleID}'`,
            Fields: ['IsOfficer'],
            MaxRows: 1,
            ResultType: 'simple',
        }, contextUser);

        if (roleResult.Success && roleResult.Results && roleResult.Results.length > 0) {
            membership.IsOfficer = roleResult.Results[0].IsOfficer;
        }

        return membership;
    }

    /**
     * Finds all active memberships for a person across all committees.
     * Used for batch permission resolution.
     */
    private async findActiveMembershipsForPerson(
        personID: string,
        contextUser?: UserInfo
    ): Promise<MembershipWithCommitteeRow[]> {
        const rv = new RunView();

        // Load all active memberships with term info
        const memberResult = await rv.RunView<{ ID: string; RoleID: string; Role: string; TermID: string }>({
            EntityName: 'Committees: Memberships',
            ExtraFilter: `PersonID = '${personID}' AND Status = 'Active'`,
            Fields: ['ID', 'RoleID', 'Role', 'TermID'],
            ResultType: 'simple',
        }, contextUser);

        if (!memberResult.Success || !memberResult.Results || memberResult.Results.length === 0) {
            return [];
        }

        // Load terms to get committee IDs
        const termIDs = [...new Set(memberResult.Results.map(m => m.TermID))];
        const termIDsStr = termIDs.map(id => `'${id}'`).join(',');
        const termResult = await rv.RunView<{ ID: string; CommitteeID: string }>({
            EntityName: 'Committees: Terms',
            ExtraFilter: `ID IN (${termIDsStr})`,
            Fields: ['ID', 'CommitteeID'],
            ResultType: 'simple',
        }, contextUser);

        const termToCommittee = new Map<string, string>();
        if (termResult.Success && termResult.Results) {
            for (const t of termResult.Results) {
                termToCommittee.set(t.ID, t.CommitteeID);
            }
        }

        // Load roles to check IsOfficer
        const roleIDs = [...new Set(memberResult.Results.map(m => m.RoleID))];
        const roleIDsStr = roleIDs.map(id => `'${id}'`).join(',');
        const roleResult = await rv.RunView<{ ID: string; IsOfficer: boolean | number }>({
            EntityName: 'Committees: Roles',
            ExtraFilter: `ID IN (${roleIDsStr})`,
            Fields: ['ID', 'IsOfficer'],
            ResultType: 'simple',
        }, contextUser);

        const roleOfficerMap = new Map<string, boolean | number>();
        if (roleResult.Success && roleResult.Results) {
            for (const r of roleResult.Results) {
                roleOfficerMap.set(r.ID, r.IsOfficer);
            }
        }

        return memberResult.Results.map(m => ({
            ...m,
            CommitteeID: termToCommittee.get(m.TermID) ?? '',
            IsOfficer: roleOfficerMap.get(m.RoleID) ?? false,
        }));
    }
}

interface MembershipRoleRow {
    ID: string;
    RoleID: string;
    Role: string;
    TermID: string;
    IsOfficer?: boolean | number;
}

interface MembershipWithCommitteeRow extends MembershipRoleRow {
    CommitteeID: string;
}
