/**
 * CommitteeSpaceServerDriver
 * Server driver for the 'committee' SpaceType (C4 rebuild on Collaboration).
 */
import { RegisterClass, UUIDsEqual } from '@memberjunction/global';
import { type IMetadataProvider, RunView, type UserInfo } from '@memberjunction/core';
import { ResolvePersonIDForUser } from '@mj-biz-apps/common-entities';
import { CommitteesLookupEngine } from '@mj-biz-apps/committees-core';
import {
    CommitteeEntityCustom,
    TermEntityCustom,
    type mjBizAppsCommitteesCommitteeEntity,
} from '@mj-biz-apps/committees-entities';
import {
    type mjBizAppsCollaborationSpaceEntity,
    type mjBizAppsCollaborationSpaceMemberEntity,
} from '@mj-biz-apps/collaboration-entities';
import {
    BaseSpaceTypeServerDriver,
    CollaborationEngine,
    type AgentContextParams,
    type AgentContextResult,
    type ChildSpaceChangeContext,
    type DriverValidationResult,
    type MemberChangeContext,
    type PersonSeatInput,
    type SpaceChangeContext,
    type SyncSeatsResult,
} from '@mj-biz-apps/collaboration-core-entities-server';

const GUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
const COMMITTEES_ENTITY_ID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE';
export const COMMITTEE_MEMBERSHIP_SYNC_SOURCE = 'committees:membership';

@RegisterClass(BaseSpaceTypeServerDriver, 'CommitteeSpaceServerDriver')
@RegisterClass(BaseSpaceTypeServerDriver, 'committee')
export class CommitteeSpaceServerDriver extends BaseSpaceTypeServerDriver {
    /**
     * Validates changes to a Committee space:
     * - Refuses deleting an open committee (ClosedAt must be set first).
     * - Refuses closing a committee while an e-ballot is still Open.
     * - Decision A3: syncs Committee.Status === 'Dissolved' -> Space.ClosedAt (Inactive/Pending stay open).
     */
    public override async ValidateSpaceChange(ctx: SpaceChangeContext): Promise<DriverValidationResult> {
        if (ctx.kind === 'Delete' && ctx.space.ClosedAt == null) {
            return {
                ok: false,
                message: 'Cannot delete an active Committee space. Dissolve or close it first.',
            };
        }

        const leaf = ctx.space.LeafEntity as mjBizAppsCommitteesCommitteeEntity | null;
        if (leaf) {
            if (ctx.kind !== 'Create' && leaf.Status === 'Dissolved' && ctx.space.ClosedAt == null) {
                ctx.space.ClosedAt = new Date();
            }
        }

        if ((ctx.kind === 'Close' || leaf?.Status === 'Dissolved') && GUID_RE.test(ctx.space.ID)) {
            const view = RunView.FromMetadataProvider(ctx.provider as IMetadataProvider);
            const openBallots = await view.RunView<{ ID: string }>(
                {
                    EntityName: 'Committees: Ballots',
                    ExtraFilter: `CommitteeID = '${ctx.space.ID}' AND Status = 'Open'`,
                    Fields: ['ID'],
                    MaxRows: 1,
                    ResultType: 'simple',
                },
                ctx.actingUser
            );
            if (openBallots.Success && (openBallots.Results?.length ?? 0) > 0) {
                return {
                    ok: false,
                    message: 'Cannot close or dissolve a Committee space while an e-ballot is open for voting.',
                };
            }
        }

        return { ok: true };
    }

    /**
     * When a new Committee space is created, ensures its OwnerID holds an active Owner seat on the space.
     */
    public override async OnSpaceChanged(ctx: SpaceChangeContext): Promise<void> {
        if (ctx.kind !== 'Create') {
            return;
        }
        if (!GUID_RE.test(ctx.space.ID) || !GUID_RE.test(ctx.space.OwnerID)) {
            return;
        }
        const md = ctx.provider as IMetadataProvider;
        if (!md || typeof md.GetEntityObject !== 'function') {
            return;
        }
        await CollaborationEngine.Instance.EnsureLoaded(ctx.actingUser, md);
        const ownerRole = CollaborationEngine.Instance.SpaceRoleTypeByCode('owner');
        if (!ownerRole) {
            return;
        }
        const view = RunView.FromMetadataProvider(md);
        const existing = await view.RunView<{ ID: string }>(
            {
                EntityName: 'MJ_BizApps_Collaboration: Space Members',
                ExtraFilter: `SpaceID = '${ctx.space.ID}' AND UserID = '${ctx.space.OwnerID}' AND Status = 'Active'`,
                Fields: ['ID'],
                MaxRows: 1,
                ResultType: 'simple',
            },
            ctx.actingUser
        );
        if (existing.Success && (existing.Results?.length ?? 0) > 0) {
            return;
        }
        const seat = await md.GetEntityObject<mjBizAppsCollaborationSpaceMemberEntity>(
            'MJ_BizApps_Collaboration: Space Members',
            ctx.actingUser
        );
        seat.NewRecord();
        seat.SpaceID = ctx.space.ID;
        seat.UserID = ctx.space.OwnerID;
        seat.SpaceRoleTypeID = ownerRole.ID;
        seat.Band = 'Team';
        seat.Status = 'Active';
        await seat.Save();
    }

    /**
     * Decision A4 — Validates child spaces under a Committee space:
     * - Only 'committee-term' (Term) and 'committee' (sub-committee) child spaces are permitted.
     * - At most one open 'committee-term' child space (ClosedAt IS NULL) may exist under a committee at a time.
     * - 'committee-term' child spaces must inherit membership (InheritsMembership = true).
     * - 'committee' sub-committee child spaces have their own roster (InheritsMembership = false).
     */
    public override async ValidateChildSpaceChange(ctx: ChildSpaceChangeContext): Promise<DriverValidationResult> {
        if (
            ctx.kind !== 'CreateChild' &&
            ctx.kind !== 'MoveChildIn' &&
            ctx.kind !== 'ReopenChild' &&
            ctx.kind !== 'UpdateChild'
        ) {
            return { ok: true };
        }

        const childTypeId = ctx.childSpace.SpaceTypeID;
        const isTermChild = UUIDsEqual(childTypeId, TermEntityCustom.SPACE_TYPE_ID);
        const isSubCommitteeChild = UUIDsEqual(childTypeId, CommitteeEntityCustom.SPACE_TYPE_ID);

        if (!isTermChild && !isSubCommitteeChild) {
            return {
                ok: false,
                message: 'Only Committee Term spaces and Sub-Committee spaces may be placed under a Committee.',
                field: 'SpaceTypeID',
            };
        }

        if (isTermChild) {
            if (!ctx.childSpace.InheritsMembership) {
                return {
                    ok: false,
                    message: 'Committee term spaces must inherit membership from their parent committee.',
                    field: 'InheritsMembership',
                };
            }

            // Enforce at most one open term space per committee
            if (ctx.childSpace.ClosedAt == null && GUID_RE.test(ctx.space.ID)) {
                const excludeSelf = GUID_RE.test(ctx.childSpace.ID) ? ` AND ID <> '${ctx.childSpace.ID}'` : '';
                const view = RunView.FromMetadataProvider(ctx.provider as IMetadataProvider);
                const openTerms = await view.RunView<{ ID: string }>(
                    {
                        EntityName: 'MJ_BizApps_Collaboration: Spaces',
                        ExtraFilter: `ParentID = '${ctx.space.ID}' AND SpaceTypeID = '${TermEntityCustom.SPACE_TYPE_ID}' AND ClosedAt IS NULL${excludeSelf}`,
                        Fields: ['ID'],
                        MaxRows: 1,
                        ResultType: 'simple',
                    },
                    ctx.actingUser
                );
                if (openTerms.Success && (openTerms.Results?.length ?? 0) > 0) {
                    return {
                        ok: false,
                        message: 'A committee may have at most one open term space at a time. Close the current term before opening another.',
                    };
                }
            }
        }

        if (isSubCommitteeChild && ctx.childSpace.InheritsMembership) {
            return {
                ok: false,
                message: 'Sub-committees manage their own roster and must not inherit membership from the parent committee.',
                field: 'InheritsMembership',
            };
        }

        return { ok: true };
    }

    /**
     * Validates member changes:
     * Refuses manual SpaceMember additions/modifications when the user holds an active
     * committee membership in an open term of this committee (their seat belongs to 'committees:membership').
     */
    public override async ValidateMemberChange(ctx: MemberChangeContext): Promise<DriverValidationResult> {
        if (ctx.kind === 'Remove') {
            return { ok: true };
        }
        const syncSource = (ctx.member.SyncSource ?? '').trim();
        if (syncSource === COMMITTEE_MEMBERSHIP_SYNC_SOURCE) {
            return { ok: true };
        }
        if (!GUID_RE.test(ctx.space.ID)) {
            return { ok: true };
        }

        const view = RunView.FromMetadataProvider(ctx.provider as IMetadataProvider);
        let personId = ctx.member.PersonID && GUID_RE.test(ctx.member.PersonID) ? ctx.member.PersonID : null;
        if (!personId && ctx.member.UserID && GUID_RE.test(ctx.member.UserID)) {
            try {
                const userEntity = await (ctx.provider as IMetadataProvider).GetEntityObject('MJ: Users', ctx.actingUser) as unknown as {
                    Load?: (id: string) => Promise<boolean>;
                };
                if (userEntity && typeof userEntity.Load === 'function' && (await userEntity.Load(ctx.member.UserID))) {
                    personId = await ResolvePersonIDForUser(userEntity as never, ctx.provider as IMetadataProvider, ctx.actingUser);
                }
            } catch {
                // Fallback to direct People lookup
            }
            if (!personId) {
                const peopleRes = await view.RunView<{ ID: string }>(
                    {
                        EntityName: 'MJ_BizApps_Common: People',
                        ExtraFilter: `LinkedUserID = '${ctx.member.UserID}'`,
                        Fields: ['ID'],
                        MaxRows: 1,
                        ResultType: 'simple',
                    },
                    ctx.actingUser
                );
                personId = peopleRes.Success ? peopleRes.Results?.[0]?.ID ?? null : null;
            }
        }

        if (!personId || !GUID_RE.test(personId)) {
            return { ok: true };
        }

        const openTerms = await view.RunView<{ ID: string }>(
            {
                EntityName: 'Committees: Terms',
                ExtraFilter: `ParentID = '${ctx.space.ID}' AND ClosedAt IS NULL`,
                Fields: ['ID'],
                ResultType: 'simple',
            },
            ctx.actingUser
        );
        const termIds = (openTerms.Success ? openTerms.Results ?? [] : [])
            .map((t) => t.ID)
            .filter((id) => GUID_RE.test(id));
        if (termIds.length === 0) {
            return { ok: true };
        }

        const activeMembership = await view.RunView<{ ID: string }>(
            {
                EntityName: 'Committees: Memberships',
                ExtraFilter: `PersonID = '${personId}' AND Status = 'Active' AND TermID IN (${termIds.map((id) => `'${id}'`).join(',')})`,
                Fields: ['ID'],
                MaxRows: 1,
                ResultType: 'simple',
            },
            ctx.actingUser
        );
        if (activeMembership.Success && (activeMembership.Results?.length ?? 0) > 0) {
            return {
                ok: false,
                message: 'Committee member seats are managed by committee membership and cannot be added or modified manually.',
                field: 'UserID',
            };
        }

        return { ok: true };
    }

    /**
     * Syncs SpaceMember rows for a committee from its active Memberships in open Terms.
     */
    public async SyncCommitteeSeats(
        committeeId: string,
        actingUser: UserInfo,
        provider: IMetadataProvider
    ): Promise<SyncSeatsResult> {
        if (!GUID_RE.test(committeeId)) {
            return { added: 0, updated: 0, removed: 0, invited: 0, errors: ['Invalid committee ID'] };
        }
        const space = await provider.GetEntityObject<mjBizAppsCollaborationSpaceEntity>(
            'MJ_BizApps_Collaboration: Spaces',
            actingUser
        );
        if (!(await space.Load(committeeId))) {
            return { added: 0, updated: 0, removed: 0, invited: 0, errors: [`Committee space ${committeeId} not found`] };
        }

        await CommitteesLookupEngine.Instance.Config(false, actingUser, provider);
        const rolesById = new Map(
            CommitteesLookupEngine.Instance.Roles.map((r) => [r.ID.toLowerCase(), r])
        );

        const view = RunView.FromMetadataProvider(provider);
        const termsRes = await view.RunView<{ ID: string }>(
            {
                EntityName: 'Committees: Terms',
                ExtraFilter: `ParentID = '${committeeId}' AND ClosedAt IS NULL`,
                Fields: ['ID'],
                ResultType: 'simple',
            },
            actingUser
        );
        const termIds = (termsRes.Success ? termsRes.Results ?? [] : [])
            .map((t) => t.ID)
            .filter((id) => GUID_RE.test(id));

        const seats: PersonSeatInput[] = [];
        if (termIds.length > 0) {
            const membershipsRes = await view.RunView<{ PersonID: string; RoleID: string; Role: string }>(
                {
                    EntityName: 'Committees: Memberships',
                    ExtraFilter: `Status = 'Active' AND TermID IN (${termIds.map((id) => `'${id}'`).join(',')})`,
                    Fields: ['PersonID', 'RoleID', 'Role'],
                    ResultType: 'simple',
                },
                actingUser
            );
            for (const m of membershipsRes.Success ? membershipsRes.Results ?? [] : []) {
                const role = rolesById.get((m.RoleID ?? '').toLowerCase());
                const roleName = (role?.Name ?? m.Role ?? '').toLowerCase();
                let spaceRoleName = 'Member';
                if (roleName === 'chair' || roleName === 'co-chair') {
                    spaceRoleName = 'Owner';
                } else if (role?.IsOfficer) {
                    spaceRoleName = 'Admin';
                }
                seats.push({
                    PersonID: m.PersonID,
                    RoleTypeName: spaceRoleName,
                });
            }
        }

        return this.SyncSeats(space, COMMITTEE_MEMBERSHIP_SYNC_SOURCE, seats, actingUser, provider);
    }

    /**
     * Injects committee governance context (current term, roster & roles, quorum, and next meeting) into agent turns.
     */
    public override async BuildAgentContext(ctx: AgentContextParams): Promise<AgentContextResult> {
        if (!GUID_RE.test(ctx.space.ID)) {
            return { instructions: [], contextData: {} };
        }
        await CommitteesLookupEngine.Instance.Config(false, ctx.actingUser, ctx.provider as IMetadataProvider);
        const votingRoleIds = new Set(
            CommitteesLookupEngine.Instance.Roles.filter((r) => r.IsVotingRole).map((r) => r.ID.toLowerCase())
        );

        const view = RunView.FromMetadataProvider(ctx.provider as IMetadataProvider);
        const [termsRes, linksRes] = await view.RunViews(
            [
                {
                    EntityName: 'Committees: Terms',
                    ExtraFilter: `ParentID = '${ctx.space.ID}' AND ClosedAt IS NULL`,
                    Fields: ['ID', 'Name', 'StartedAt', 'PlannedCloseAt'],
                    ResultType: 'simple',
                },
                {
                    EntityName: 'MJ_BizApps_Tasks: Meeting Links',
                    ExtraFilter: `EntityID = '${COMMITTEES_ENTITY_ID}' AND RecordID = '${ctx.space.ID}'`,
                    Fields: ['MeetingID'],
                    ResultType: 'simple',
                },
            ],
            ctx.actingUser
        );

        const openTerms = (termsRes.Success ? termsRes.Results ?? [] : []) as Array<{
            ID: string;
            Name: string;
            StartedAt: string | null;
            PlannedCloseAt: string | null;
        }>;
        const currentTerm = openTerms[0] ?? null;

        let roster: Array<{ Person: string; Role: string; RoleID: string }> = [];
        if (currentTerm && GUID_RE.test(currentTerm.ID)) {
            const memRes = await view.RunView<{ Person: string; Role: string; RoleID: string }>(
                {
                    EntityName: 'Committees: Memberships',
                    ExtraFilter: `TermID = '${currentTerm.ID}' AND Status = 'Active'`,
                    Fields: ['Person', 'Role', 'RoleID'],
                    ResultType: 'simple',
                },
                ctx.actingUser
            );
            if (memRes.Success) {
                roster = memRes.Results ?? [];
            }
        }

        const votingCount = roster.filter((m) => votingRoleIds.has((m.RoleID ?? '').toLowerCase())).length;
        const quorumRequired = votingCount > 0 ? Math.floor(votingCount * 0.5) + 1 : 0;

        const meetingIds = ((linksRes.Success ? linksRes.Results ?? [] : []) as Array<{ MeetingID: string }>)
            .map((l) => l.MeetingID)
            .filter((id) => GUID_RE.test(id));
        let nextMeeting: { ID: string; Name: string; StartsAt: string } | null = null;
        if (meetingIds.length > 0) {
            const nowIso = new Date().toISOString();
            const mtgRes = await view.RunView<{ ID: string; Name: string; StartsAt: string }>(
                {
                    EntityName: 'MJ_BizApps_Tasks: Meetings',
                    ExtraFilter: `ID IN (${meetingIds.map((id) => `'${id}'`).join(',')}) AND StartsAt >= '${nowIso}' AND Status IN ('Draft', 'Scheduled')`,
                    OrderBy: 'StartsAt ASC',
                    MaxRows: 1,
                    Fields: ['ID', 'Name', 'StartsAt'],
                    ResultType: 'simple',
                },
                ctx.actingUser
            );
            if (mtgRes.Success && mtgRes.Results?.[0]) {
                nextMeeting = mtgRes.Results[0];
            }
        }

        const instructions: string[] = [
            `This space is the "${ctx.space.Name}" committee space governed by formal committee rules of order.`,
            currentTerm
                ? `Current active term: ${currentTerm.Name}.`
                : 'No active term is currently open for this committee.',
            `Active members: ${roster.length} (${votingCount} voting; quorum requires ${quorumRequired}).`,
        ];
        if (nextMeeting) {
            instructions.push(`Next scheduled meeting: "${nextMeeting.Name}" at ${nextMeeting.StartsAt}.`);
        }

        return {
            instructions,
            contextData: {
                committeeId: ctx.space.ID,
                committeeName: ctx.space.Name,
                currentTerm: currentTerm?.Name ?? null,
                memberCount: roster.length,
                votingMemberCount: votingCount,
                quorumRequired,
                roster: roster.map((r) => ({ name: r.Person, role: r.Role })),
                nextMeeting: nextMeeting
                    ? { id: nextMeeting.ID, name: nextMeeting.Name, startedAt: nextMeeting.StartsAt }
                    : null,
            },
        };
    }
}
