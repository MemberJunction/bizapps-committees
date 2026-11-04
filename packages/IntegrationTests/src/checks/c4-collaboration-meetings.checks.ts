/**
 * c4-collaboration-meetings — C4 integration checks verifying Committees & Terms as
 * Collaboration Space subtypes, SyncSeats roster synchronization, driver guardrails,
 * and Tasks Meetings linkage.
 */
import {
    Assert,
    IntegrationCheckRegistry,
    type IntegrationCheckContext,
    type NamedCheck,
} from '@memberjunction/testing-integration/registry';
import { CommitteeEntityCustom, TermEntityCustom } from '@mj-biz-apps/committees-entities';
import { COMMITTEE_MEMBERSHIP_SYNC_SOURCE } from '@mj-biz-apps/committees-core-entities-server';
import {
    E_BALLOT,
    E_COMMITTEE,
    E_MEETING_LINK,
    E_MEMBERSHIP,
    E_MINUTE,
    E_MOTION,
    E_TERM,
    EntityOf,
    FindRows,
    FindRowsAs,
    LoadExisting,
    PersonaUser,
} from '../fixture.js';
import { LoadWorld, WorldUserEmail } from '../world/load-world.js';

const E_SPACE = 'MJ_BizApps_Collaboration: Spaces';
const E_SPACE_MEMBER = 'MJ_BizApps_Collaboration: Space Members';

export const C4CollaborationMeetingsChecks: NamedCheck[] = [
    {
        Id: 'c4-collaboration-meetings.C4_1',
        Name: 'C4.1 — Committees and Terms are Collaboration Space IsA subtypes with expected SpaceTypeID and inheritance',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = await LoadWorld(ctx);
            const financeSpaces = await FindRows<{
                ID: string;
                SpaceTypeID: string;
                InheritsMembership: boolean;
                ClosedAt: Date | null;
            }>(
                ctx,
                E_SPACE,
                `ID = '${world.Committees.finance}'`,
                ['ID', 'SpaceTypeID', 'InheritsMembership', 'ClosedAt'],
            );
            Assert(financeSpaces.length === 1, 'Finance Committee must exist in MJ_BizApps_Collaboration: Spaces');
            Assert(
                financeSpaces[0].SpaceTypeID.toUpperCase() === CommitteeEntityCustom.SPACE_TYPE_ID.toUpperCase(),
                `Finance SpaceTypeID ${financeSpaces[0].SpaceTypeID} != ${CommitteeEntityCustom.SPACE_TYPE_ID}`,
            );
            Assert(financeSpaces[0].InheritsMembership === false, 'Committee spaces must have InheritsMembership = false');
            Assert(financeSpaces[0].ClosedAt == null, 'Active committee space must be open (ClosedAt IS NULL)');

            const termSpaces = await FindRows<{
                ID: string;
                ParentID: string;
                SpaceTypeID: string;
                InheritsMembership: boolean;
                ClosedAt: Date | null;
            }>(
                ctx,
                E_SPACE,
                `ID = '${world.Terms.finance}'`,
                ['ID', 'ParentID', 'SpaceTypeID', 'InheritsMembership', 'ClosedAt'],
            );
            Assert(termSpaces.length === 1, 'Finance Term must exist in MJ_BizApps_Collaboration: Spaces');
            Assert(
                termSpaces[0].ParentID.toUpperCase() === world.Committees.finance.toUpperCase(),
                'Term space ParentID must point to parent Committee space ID',
            );
            Assert(
                termSpaces[0].SpaceTypeID.toUpperCase() === TermEntityCustom.SPACE_TYPE_ID.toUpperCase(),
                `Term SpaceTypeID ${termSpaces[0].SpaceTypeID} != ${TermEntityCustom.SPACE_TYPE_ID}`,
            );
            Assert(termSpaces[0].InheritsMembership === true, 'Term space must have InheritsMembership = true');

            const pandemicSpaces = await FindRows<{ ID: string; ClosedAt: Date | null }>(
                ctx,
                E_SPACE,
                `ID = '${world.Committees.pandemic}'`,
                ['ID', 'ClosedAt'],
            );
            Assert(pandemicSpaces[0]?.ClosedAt != null, 'Dissolved committee space must have ClosedAt set');
        },
    },
    {
        Id: 'c4-collaboration-meetings.C4_2',
        Name: 'C4.2 — SyncSeats populates Space Members from active Term Memberships with SyncSource = committees:membership',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = await LoadWorld(ctx);
            const syncedSeats = await FindRows<{
                ID: string;
                UserID: string;
                PersonID: string;
                SyncSource: string;
                Status: string;
            }>(
                ctx,
                E_SPACE_MEMBER,
                `SpaceID = '${world.Committees.finance}' AND SyncSource = '${COMMITTEE_MEMBERSHIP_SYNC_SOURCE}' AND Status = 'Active'`,
                ['ID', 'UserID', 'PersonID', 'SyncSource', 'Status'],
            );
            Assert(
                syncedSeats.length >= 2,
                `Expected >= 2 synced SpaceMember rows on Finance Committee for personas with User accounts, found ${syncedSeats.length}`,
            );
        },
    },
    {
        Id: 'c4-collaboration-meetings.C4_3',
        Name: 'C4.3 — CommitteeSpaceServerDriver refuses a second open Term space under the same Committee',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = await LoadWorld(ctx);
            const duplicateOpenTerm = await EntityOf(ctx, E_TERM);
            duplicateOpenTerm.NewRecord();
            duplicateOpenTerm.Set('ParentID', world.Committees.finance);
            duplicateOpenTerm.Set('Name', 'Duplicate Open Term Should Fail');
            duplicateOpenTerm.Set('StartedAt', new Date());
            duplicateOpenTerm.Set('Status', 'Active');
            const saved = await duplicateOpenTerm.Save();
            Assert(!saved, 'Second open Term under Finance Committee should be refused by CommitteeSpaceServerDriver');
            const msg = duplicateOpenTerm.LatestResult?.CompleteMessage ?? '';
            Assert(
                msg.includes('at most one open term space'),
                `Expected refusal message mentioning 'at most one open term space', got: ${msg}`,
            );
        },
    },
    {
        Id: 'c4-collaboration-meetings.C4_4',
        Name: 'C4.4 — CommitteeSpaceServerDriver refuses dissolving a Committee while an e-ballot is Open, and Tasks Meetings link to the Committee space',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = await LoadWorld(ctx);
            const gov = await EntityOf(ctx, E_COMMITTEE);
            Assert(await LoadExisting(gov, world.Committees.governance), 'load Governance Committee');
            gov.Set('Status', 'Dissolved');
            const saved = await gov.Save();
            Assert(!saved, 'Dissolving Governance Committee with an Open ballot must be refused');
            const msg = gov.LatestResult?.CompleteMessage ?? '';
            Assert(
                msg.includes('open for voting'),
                `Expected refusal message mentioning 'open for voting', got: ${msg}`,
            );

            // Also verify Tasks Meetings are linked to the Committee Space via MeetingLink
            const links = await FindRows<{ ID: string; MeetingID: string }>(
                ctx,
                E_MEETING_LINK,
                `RecordID = '${world.Committees.finance}' AND EntityID = '3648DC35-1DC4-4ED6-A1A6-5D87271A54DB'`,
                ['ID', 'MeetingID'],
            );
            Assert(links.length >= 2, `Expected >= 2 MeetingLink rows for Finance Committee Space, found ${links.length}`);
        },
    },
    {
        Id: 'c4-collaboration-meetings.C4_5',
        Name: 'C4.5 — Space Participant / UI persona reads Committees entities through fnCollaborationAccess / fnCollaborationMeetingAccess RLS filters, and saving a closed Committee preserves ClosedAt',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = await LoadWorld(ctx);
            const marcus = await PersonaUser(ctx, WorldUserEmail('marcus'));

            // Verify Space Participant / UI persona reads across all 8 RLS-filtered Committees entities
            const committees = await FindRowsAs<{ ID: string }>(ctx, marcus, E_COMMITTEE, `ID = '${world.Committees.governance}'`, ['ID']);
            Assert(committees.length === 1, 'Marcus (Governance Chair) reads Governance Committee through RLS filter');

            const terms = await FindRowsAs<{ ID: string }>(ctx, marcus, E_TERM, `ID = '${world.Terms.governance}'`, ['ID']);
            Assert(terms.length === 1, 'Marcus reads Governance Term through RLS filter');

            const memberships = await FindRowsAs<{ ID: string }>(ctx, marcus, E_MEMBERSHIP, `TermID = '${world.Terms.governance}'`, ['ID']);
            Assert(memberships.length >= 1, 'Marcus reads Governance Memberships through RLS filter');

            const ballots = await FindRowsAs<{ ID: string }>(ctx, marcus, E_BALLOT, `CommitteeID = '${world.Committees.governance}'`, ['ID']);
            Assert(ballots.length >= 1, 'Marcus reads Governance Ballots through RLS filter');

            await FindRowsAs<{ ID: string }>(ctx, marcus, E_MOTION, 'ID IS NOT NULL', ['ID']);
            await FindRowsAs<{ ID: string }>(ctx, marcus, E_MINUTE, 'ID IS NOT NULL', ['ID']);
            await FindRowsAs<{ ID: string }>(ctx, marcus, 'Committees: Artifacts', 'ID IS NOT NULL', ['ID']);
            await FindRowsAs<{ ID: string }>(ctx, marcus, 'Committees: Comments', 'ID IS NOT NULL', ['ID']);

            // Verify saving an already-closed Committee does not clear ClosedAt
            const pandemic = await EntityOf(ctx, E_COMMITTEE);
            Assert(await LoadExisting(pandemic, world.Committees.pandemic), 'load dissolved Pandemic Committee');
            const originalClosedAt = pandemic.Get('ClosedAt');
            Assert(originalClosedAt != null, 'Pandemic Committee has ClosedAt before update');
            pandemic.Set('MissionStatement', pandemic.Get('MissionStatement') ?? 'Archive mission');
            Assert(await pandemic.Save(), `Re-saving dissolved committee succeeds: ${pandemic.LatestResult?.CompleteMessage ?? ''}`);
            Assert(pandemic.Get('ClosedAt') != null, 'Re-saving dissolved committee preserves ClosedAt');
        },
    },
];

for (const check of C4CollaborationMeetingsChecks) {
    IntegrationCheckRegistry.Instance.Register(check);
}

IntegrationCheckRegistry.Instance.RegisterLifecycle('c4-collaboration-meetings', {
    Setup: async () => undefined,
    Teardown: async () => undefined,
});
