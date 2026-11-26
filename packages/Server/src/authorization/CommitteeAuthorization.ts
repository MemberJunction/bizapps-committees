import { RunView, UserInfo, LogError } from '@memberjunction/core';
import { CommitteesLookupEngine } from '@mj-biz-apps/committees-core';

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
            return await this.checkCommitteeAccess(committeeID, true, contextUser);
        } catch (error) {
            LogError(`[CommitteeAuthorization] CanActOnCommittee failed for committee ${committeeID}: ${errorMessage(error)}`);
            return false;
        }
    }

    /**
     * True if the user may look at the committee's ballots: staff, or an active member (any role) of that committee.
     * Participation on a ballot is visible to the whole committee; the choices never are. Fails closed.
     */
    public static async CanViewCommittee(committeeID: string | null, contextUser: UserInfo): Promise<boolean> {
        if (!committeeID || !UUID_RE.test(committeeID)) return false;
        try {
            return await this.checkCommitteeAccess(committeeID, false, contextUser);
        } catch (error) {
            LogError(`[CommitteeAuthorization] CanViewCommittee failed for committee ${committeeID}: ${errorMessage(error)}`);
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

    /**
     * Batches the three independent access prerequisites (staff app access, linked PersonID,
     * and committee TermIDs) into one `RunViews` round trip, then checks active membership
     * and (when required) officer role via `CommitteesLookupEngine`. Fails closed.
     */
    private static async checkCommitteeAccess(
        committeeID: string,
        requireOfficer: boolean,
        contextUser: UserInfo
    ): Promise<boolean> {
        const rv = new RunView();
        const [staffRes, personRes, termsRes] = await rv.RunViews([
            {
                EntityName: 'MJ: User Applications',
                ExtraFilter: `UserID = '${contextUser.ID}' AND Application = 'Committee Management'`,
                Fields: ['ID'],
                MaxRows: 1,
                ResultType: 'simple',
            },
            {
                EntityName: 'MJ_BizApps_Common: People',
                ExtraFilter: `LinkedUserID = '${contextUser.ID}'`,
                Fields: ['ID'],
                MaxRows: 1,
                ResultType: 'simple',
            },
            {
                EntityName: 'Committees: Terms',
                ExtraFilter: `CommitteeID = '${committeeID}'`,
                Fields: ['ID'],
                ResultType: 'simple',
            },
        ], contextUser);

        if (staffRes?.Success === true && Array.isArray(staffRes.Results) && staffRes.Results.length > 0) {
            return true;
        }

        const personRows = (personRes?.Success ? personRes.Results : []) as IdRow[];
        const personID = personRows[0]?.ID ?? null;
        if (!personID) return false;

        const termRows = (termsRes?.Success ? termsRes.Results : []) as IdRow[];
        const termIDs = termRows.map(r => r.ID).filter(id => !!id);
        if (termIDs.length === 0) return false;

        const roleIDs = await this.activeMembershipRoleIDs(rv, personID, termIDs, contextUser);
        if (roleIDs.length === 0) return false;
        if (!requireOfficer) return true;

        await CommitteesLookupEngine.Instance.Config(false, contextUser);
        return roleIDs.some(roleID => CommitteesLookupEngine.Instance.IsOfficerRole(roleID));
    }

    /** Returns the role IDs of the person's ACTIVE memberships within the given terms. */
    private static async activeMembershipRoleIDs(
        rv: RunView,
        personID: string,
        termIDs: string[],
        contextUser: UserInfo
    ): Promise<string[]> {
        const termList = termIDs.map(id => `'${id}'`).join(',');
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
}

/** Extracts a human-readable message from an unknown error value. */
function errorMessage(error: unknown): string {
    return error instanceof Error ? error.message : String(error);
}
