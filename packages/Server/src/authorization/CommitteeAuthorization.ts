import { RunView, UserInfo, LogError } from '@memberjunction/core';

/** Read-only shape for a single-column ID lookup. */
interface IdRow {
    ID: string;
}

/** Read-only shape for a CommitteeID lookup on an owning record. */
interface CommitteeIdRow {
    CommitteeID: string;
}

/** Read-only shape for an active-membership role lookup. */
interface MembershipRoleRow {
    RoleID: string;
}

/** Read-only shape for a committee role's officer flag. */
interface RoleOfficerRow {
    ID: string;
    IsOfficer: boolean;
}

const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/**
 * Committee-scoped authorization for privileged GraphQL mutations.
 *
 * SECURITY (broken access control / IDOR): the privileged mutations in this
 * package previously authorized only that a session resolved to *some* user —
 * any authenticated user could act on ANY meeting / ballot / committee. Every
 * such mutation must now confirm the caller is either staff (Committee
 * Management application access) or an active officer of the specific committee
 * the target record belongs to. All checks FAIL CLOSED: any lookup error, a
 * missing record, or an unresolved person yields "not authorized".
 *
 * The officer path mirrors the client-side CommitteePermissionHelper:
 * User -> Person (LinkedUserID) -> active Membership -> Term -> Committee, with
 * the membership Role's IsOfficer flag granting officer authority.
 */
export class CommitteeAuthorization {
    private constructor() { /* static-only utility */ }

    /** True if the user has "Committee Management" application access (staff). */
    public static async IsStaffUser(contextUser: UserInfo): Promise<boolean> {
        const rv = new RunView();
        const result = await rv.RunView<IdRow>({
            EntityName: 'MJ: User Applications',
            ExtraFilter: `UserID = '${contextUser.ID}' AND Application = 'Committee Management'`,
            Fields: ['ID'],
            MaxRows: 1,
            ResultType: 'simple',
        }, contextUser);
        return result.Success === true && Array.isArray(result.Results) && result.Results.length > 0;
    }

    /**
     * True if the user may perform officer/management-level actions on the committee:
     * staff, or an active officer of that specific committee. Fails closed.
     */
    public static async CanActOnCommittee(committeeID: string | null, contextUser: UserInfo): Promise<boolean> {
        if (!committeeID || !UUID_RE.test(committeeID)) return false;
        try {
            if (await this.IsStaffUser(contextUser)) return true;
            return await this.isActiveOfficer(committeeID, contextUser);
        } catch (error) {
            LogError(`[CommitteeAuthorization] CanActOnCommittee failed for committee ${committeeID}: ${errorMessage(error)}`);
            return false;
        }
    }

    /** Resolves the owning CommitteeID for a meeting, or null if not found. */
    public static async GetMeetingCommitteeID(meetingID: string, contextUser: UserInfo): Promise<string | null> {
        return this.lookupCommitteeID('Committees: Meetings', meetingID, contextUser);
    }

    /** Resolves the owning CommitteeID for a ballot, or null if not found. */
    public static async GetBallotCommitteeID(ballotID: string, contextUser: UserInfo): Promise<string | null> {
        return this.lookupCommitteeID('Committees: Ballots', ballotID, contextUser);
    }

    /** Single-record CommitteeID lookup by primary key; null if missing or invalid. */
    private static async lookupCommitteeID(entityName: string, id: string, contextUser: UserInfo): Promise<string | null> {
        if (!UUID_RE.test(id)) return null;
        const rv = new RunView();
        const result = await rv.RunView<CommitteeIdRow>({
            EntityName: entityName,
            ExtraFilter: `ID = '${id}'`,
            Fields: ['CommitteeID'],
            MaxRows: 1,
            ResultType: 'simple',
        }, contextUser);
        if (result.Success && result.Results && result.Results.length > 0) {
            return result.Results[0].CommitteeID ?? null;
        }
        return null;
    }

    /** True if the user is an active officer of the committee. */
    private static async isActiveOfficer(committeeID: string, contextUser: UserInfo): Promise<boolean> {
        const personID = await this.resolvePersonID(contextUser);
        if (!personID) return false;

        const termIDs = await this.committeeTermIDs(committeeID, contextUser);
        if (termIDs.length === 0) return false;

        const roleIDs = await this.activeMembershipRoleIDs(personID, termIDs, contextUser);
        if (roleIDs.length === 0) return false;

        return this.anyRoleIsOfficer(roleIDs, contextUser);
    }

    /** Resolves the Person linked to the current user via LinkedUserID, or null. */
    private static async resolvePersonID(contextUser: UserInfo): Promise<string | null> {
        const rv = new RunView();
        const result = await rv.RunView<IdRow>({
            EntityName: 'MJ_BizApps_Common: People',
            ExtraFilter: `LinkedUserID = '${contextUser.ID}'`,
            Fields: ['ID'],
            MaxRows: 1,
            ResultType: 'simple',
        }, contextUser);
        if (result.Success && result.Results && result.Results.length > 0) {
            return result.Results[0].ID;
        }
        return null;
    }

    /** Returns all Term IDs that belong to the given committee. */
    private static async committeeTermIDs(committeeID: string, contextUser: UserInfo): Promise<string[]> {
        const rv = new RunView();
        const result = await rv.RunView<IdRow>({
            EntityName: 'Committees: Terms',
            ExtraFilter: `CommitteeID = '${committeeID}'`,
            Fields: ['ID'],
            ResultType: 'simple',
        }, contextUser);
        if (result.Success && result.Results) {
            return result.Results.map(r => r.ID);
        }
        return [];
    }

    /** Returns the role IDs of the person's ACTIVE memberships within the given terms. */
    private static async activeMembershipRoleIDs(
        personID: string,
        termIDs: string[],
        contextUser: UserInfo
    ): Promise<string[]> {
        const termList = termIDs.map(id => `'${id}'`).join(',');
        const rv = new RunView();
        const result = await rv.RunView<MembershipRoleRow>({
            EntityName: 'Committees: Memberships',
            ExtraFilter: `PersonID = '${personID}' AND Status = 'Active' AND TermID IN (${termList})`,
            Fields: ['RoleID'],
            ResultType: 'simple',
        }, contextUser);
        if (result.Success && result.Results) {
            return result.Results.map(r => r.RoleID).filter(id => !!id);
        }
        return [];
    }

    /** True if any of the given role IDs is an officer role. */
    private static async anyRoleIsOfficer(roleIDs: string[], contextUser: UserInfo): Promise<boolean> {
        const roleList = [...new Set(roleIDs)].map(id => `'${id}'`).join(',');
        const rv = new RunView();
        const result = await rv.RunView<RoleOfficerRow>({
            EntityName: 'Committees: Roles',
            ExtraFilter: `ID IN (${roleList}) AND IsOfficer = 1`,
            Fields: ['ID', 'IsOfficer'],
            MaxRows: 1,
            ResultType: 'simple',
        }, contextUser);
        return result.Success === true && Array.isArray(result.Results) && result.Results.length > 0;
    }
}

/** Extracts a human-readable message from an unknown error value. */
function errorMessage(error: unknown): string {
    return error instanceof Error ? error.message : String(error);
}
