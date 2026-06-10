import { Metadata, RunView } from '@memberjunction/core';

/**
 * Resolved permissions for a user within a specific committee.
 */
export interface CommitteePermissions {
    IsMember: boolean;
    IsOfficer: boolean;
    IsStaff: boolean;
    CanManageMembers: boolean;
    CanManageMeetings: boolean;
    CanEditCommittee: boolean;
    CanView: boolean;
}

const NO_PERMISSIONS: CommitteePermissions = {
    IsMember: false,
    IsOfficer: false,
    IsStaff: false,
    CanManageMembers: false,
    CanManageMeetings: false,
    CanEditCommittee: false,
    CanView: false,
};

/**
 * Client-side permission helper for committee role-based access control.
 * Resolves: User → Person (LinkedUserID) → Membership (active) → Term → Committee → Role
 *
 * Caches results per user session to avoid redundant queries.
 */
export class CommitteePermissionHelper {
    private static personID: string | null | undefined = undefined;
    private static membershipCache: MembershipRoleRow[] | null = null;
    private static lastUserID: string | null = null;
    private static staffCache: boolean | undefined = undefined;

    /**
     * Returns the current user's PersonID, resolved via LinkedUserID.
     * Cached after first call.
     */
    static async GetCurrentPersonID(): Promise<string | null> {
        const md = new Metadata();
        const userID = md.CurrentUser?.ID ?? null;

        if (userID !== this.lastUserID) {
            this.ClearCache();
            this.lastUserID = userID;
        }

        if (this.personID !== undefined) return this.personID;

        if (!userID) {
            this.personID = null;
            return null;
        }

        const rv = new RunView();
        const result = await rv.RunView<{ ID: string }>({
            EntityName: 'MJ_BizApps_Common: People',
            ExtraFilter: `LinkedUserID = '${userID}'`,
            Fields: ['ID'],
            MaxRows: 1,
            ResultType: 'simple'
        });

        this.personID = result.Success && result.Results && result.Results.length > 0
            ? result.Results[0].ID
            : null;

        return this.personID;
    }

    /**
     * Returns all active memberships for the current user with role and committee info.
     * Cached after first call.
     */
    static async GetCurrentUserMemberships(): Promise<MembershipRoleRow[]> {
        if (this.membershipCache !== null) return this.membershipCache;

        const personID = await this.GetCurrentPersonID();
        if (!personID) {
            this.membershipCache = [];
            return [];
        }

        const rv = new RunView();
        const memberResult = await rv.RunView<{ RoleID: string; TermID: string }>({
            EntityName: 'Committees: Memberships',
            ExtraFilter: `PersonID = '${personID}' AND Status = 'Active'`,
            Fields: ['RoleID', 'TermID'],
            ResultType: 'simple'
        });

        if (!memberResult.Success || !memberResult.Results || memberResult.Results.length === 0) {
            this.membershipCache = [];
            return [];
        }

        // Batch-load roles and terms
        const roleIDs = [...new Set(memberResult.Results.map(m => m.RoleID))];
        const termIDs = [...new Set(memberResult.Results.map(m => m.TermID))];

        const [roleResult, termResult] = await rv.RunViews([
            {
                EntityName: 'Committees: Roles',
                ExtraFilter: `ID IN (${roleIDs.map(id => `'${id}'`).join(',')})`,
                Fields: ['ID', 'IsOfficer'],
                ResultType: 'simple'
            },
            {
                EntityName: 'Committees: Terms',
                ExtraFilter: `ID IN (${termIDs.map(id => `'${id}'`).join(',')})`,
                Fields: ['ID', 'CommitteeID'],
                ResultType: 'simple'
            }
        ]);

        const officerMap = new Map<string, boolean>();
        if (roleResult.Success && roleResult.Results) {
            for (const r of roleResult.Results as { ID: string; IsOfficer: boolean | number }[]) {
                officerMap.set(r.ID, r.IsOfficer === true || r.IsOfficer === 1);
            }
        }

        const termToCommittee = new Map<string, string>();
        if (termResult.Success && termResult.Results) {
            for (const t of termResult.Results as { ID: string; CommitteeID: string }[]) {
                termToCommittee.set(t.ID, t.CommitteeID);
            }
        }

        this.membershipCache = memberResult.Results.map(m => ({
            RoleID: m.RoleID,
            TermID: m.TermID,
            CommitteeID: termToCommittee.get(m.TermID) ?? '',
            IsOfficer: officerMap.get(m.RoleID) ?? false,
        }));

        return this.membershipCache;
    }

    /**
     * Returns whether the current user is a staff member (has access to the
     * "Committee Management" application). Cached after first call.
     */
    static async IsStaffUser(): Promise<boolean> {
        if (this.staffCache !== undefined) return this.staffCache;

        const md = new Metadata();
        const userID = md.CurrentUser?.ID ?? null;
        if (!userID) {
            this.staffCache = false;
            return false;
        }

        const rv = new RunView();
        const result = await rv.RunView<{ ID: string }>({
            EntityName: 'MJ: User Applications',
            ExtraFilter: `UserID = '${userID}' AND Application = 'Committee Management'`,
            Fields: ['ID'],
            MaxRows: 1,
            ResultType: 'simple'
        });

        this.staffCache = result.Success && result.Results != null && result.Results.length > 0;
        return this.staffCache;
    }

    /**
     * Returns permissions for the current user in a specific committee.
     *
     * Permission model:
     * - Staff (Committee Management app access): full management — Can* permissions for everything
     * - Officer (Role.IsOfficer in active membership): IsOfficer flag only, used to gate
     *   in-meeting authority (chair live meeting, mark complete, generate minutes).
     *   Officers do NOT get Can* management permissions — those are staff-only.
     * - Member: IsMember + CanView only.
     */
    static async GetPermissionsForCommittee(committeeID: string): Promise<CommitteePermissions> {
        const isStaff = await this.IsStaffUser();
        if (isStaff) {
            return {
                IsMember: true,
                IsOfficer: true,
                IsStaff: true,
                CanManageMembers: true,
                CanManageMeetings: true,
                CanEditCommittee: true,
                CanView: true,
            };
        }

        const memberships = await this.GetCurrentUserMemberships();
        const forCommittee = memberships.filter(m => m.CommitteeID === committeeID);

        if (forCommittee.length === 0) return NO_PERMISSIONS;

        const isOfficer = forCommittee.some(m => m.IsOfficer);
        return {
            IsMember: true,
            IsOfficer: isOfficer,
            IsStaff: false,
            // Management permissions are staff-only. Officers retain IsOfficer for
            // in-meeting authority (live chairing, mark complete, generate minutes)
            // but cannot manage committee structure (members, terms, meetings, docs).
            CanManageMembers: false,
            CanManageMeetings: false,
            CanEditCommittee: false,
            CanView: true,
        };
    }

    /**
     * Returns the set of committee IDs where the current user is an officer.
     */
    static async GetOfficerCommitteeIDs(): Promise<Set<string>> {
        const memberships = await this.GetCurrentUserMemberships();
        const result = new Set<string>();
        for (const m of memberships) {
            if (m.IsOfficer && m.CommitteeID) result.add(m.CommitteeID);
        }
        return result;
    }

    /**
     * Returns the set of committee IDs where the current user is a member (any role).
     */
    static async GetMemberCommitteeIDs(): Promise<Set<string>> {
        const memberships = await this.GetCurrentUserMemberships();
        const result = new Set<string>();
        for (const m of memberships) {
            if (m.CommitteeID) result.add(m.CommitteeID);
        }
        return result;
    }

    /**
     * Returns whether the current user is an officer in any committee.
     */
    static async IsOfficerInAny(): Promise<boolean> {
        const memberships = await this.GetCurrentUserMemberships();
        return memberships.some(m => m.IsOfficer);
    }

    /**
     * Clears the cache. Call when memberships change (e.g. after adding/removing members).
     */
    static ClearCache(): void {
        this.personID = undefined;
        this.membershipCache = null;
        this.staffCache = undefined;
    }
}

interface MembershipRoleRow {
    RoleID: string;
    TermID: string;
    CommitteeID: string;
    IsOfficer: boolean;
}
