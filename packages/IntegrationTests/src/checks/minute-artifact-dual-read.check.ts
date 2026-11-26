/**
 * minute-artifact-dual-read — cross-stack integration verification for the
 * Committees: Minutes & Committees: Artifacts MJ Docs dual-read bridge.
 *
 * Verifies:
 *   DR1 — Pinned MJ Docs minute (ApprovedArtifactVersionID) returns immutable v1 while v2 exists.
 *   DR2 — Unpinned live-draft MJ Docs minute resolves latest version (v2).
 *   DR3 — Legacy minute (MJArtifactID IS NULL) renders legacy Minute.Content with opt-in bridge flag.
 *   DR4 — Opt-in BridgeLegacyMinuteToMJDoc creates MJ: Artifacts + v1, preserves Minute.Content intact,
 *         is idempotent on repeat invocation, and supports PinApprovedMinuteVersion (self-cleaning).
 *   DR5 — Mixed Committees: Artifacts (external URL vs native MJ Docs) resolve in one batched RunViews call.
 *   DR6 — COM-WORLD multi-entity seed density spans >=20 realistic domain records across all governance entities.
 */
import {
    Assert,
    IntegrationCheckRegistry,
    type IntegrationCheckContext,
    type NamedCheck,
} from '@memberjunction/testing-integration/registry';
import {
    MinuteArtifactBridgeService,
    type CommitteeArtifactBridgeInput,
    type MinuteDualReadInput,
} from '@mj-biz-apps/committees-core';
import type { mjBizAppsCommitteesMinuteEntity } from '@mj-biz-apps/committees-entities';
import {
    DeleteRow,
    E_ARTIFACT,
    E_COMMITTEE,
    E_MEETING,
    E_MINUTE,
    E_MJ_ARTIFACT,
    E_MJ_ARTIFACT_VERSION,
    E_MOTION,
    E_ORGANIZATION,
    E_PERSON,
    E_ROLE,
    E_TERM,
    E_USER,
    FindRows,
    ProviderOf,
    RequireSave,
    WORLD_MARK,
} from '../fixture.js';
import { LoadWorld } from '../world/load-world.js';
import { World } from '../world/world.js';

const MINUTE_PROJECTION_FIELDS = [
    'ID',
    'MeetingID',
    'Content',
    'ApprovalStatus',
    'ApprovedAt',
    'ApprovedByMeetingID',
    'MJArtifactID',
    'ApprovedArtifactVersionID',
];

const ARTIFACT_PROJECTION_FIELDS = [
    'ID',
    'Name',
    'Description',
    'CommitteeID',
    'MeetingID',
    'AgendaItemID',
    'TaskID',
    'ArtifactTypeID',
    'Provider',
    'ExternalID',
    'URL',
    'MimeType',
    'FileSize',
    'MJArtifactID',
];

async function loadMinuteProjection(
    ctx: IntegrationCheckContext,
    minuteId: string,
): Promise<MinuteDualReadInput> {
    const rows = await FindRows<MinuteDualReadInput>(
        ctx,
        E_MINUTE,
        `ID = '${minuteId}'`,
        MINUTE_PROJECTION_FIELDS,
    );
    Assert(rows.length === 1, `Expected Minute '${minuteId}' in database, found ${rows.length}`);
    return rows[0];
}

export const MinuteArtifactDualReadChecks: NamedCheck[] = [
    {
        Id: 'minute-artifact-dual-read.DR1',
        Name: 'DR1 — pinned MJ Docs minute honors ApprovedArtifactVersionID (v1) even when newer v2 exists',
        RequiresMutation: false,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = World();
            const minute = await loadMinuteProjection(ctx, world.Minutes.boardApprovedPinned);
            Assert(
                minute.MJArtifactID?.toLowerCase() === world.MJArtifacts.boardMinutes.toLowerCase(),
                'Board minute links to its MJ: Artifacts document',
            );
            Assert(
                minute.ApprovedArtifactVersionID?.toLowerCase() === world.MJArtifactVersions.boardMinutesV1.toLowerCase(),
                'Board minute pins ApprovedArtifactVersionID to v1',
            );

            const service = new MinuteArtifactBridgeService();
            const [resolved] = await service.LoadAndResolveMinutes([minute], ctx.User, ProviderOf(ctx));
            Assert(resolved.Kind === 'mj-doc-pinned', `Expected mj-doc-pinned, got ${resolved.Kind}`);
            if (resolved.Kind !== 'mj-doc-pinned') return;

            Assert(resolved.IsPinnedApprovedVersion === true, 'Pinned flag must be true');
            Assert(resolved.VersionNumber === 1, `Expected pinned VersionNumber 1, got ${resolved.VersionNumber}`);
            Assert(
                resolved.ArtifactVersionID.toLowerCase() === world.MJArtifactVersions.boardMinutesV1.toLowerCase(),
                'Resolved version ID matches ApprovedArtifactVersionID',
            );
            Assert(
                (resolved.Content ?? '').includes('Adopted FY27 strategic plan'),
                'Pinned v1 approved content is returned instead of unapproved v2 addendum',
            );
            Assert(
                !(resolved.Content ?? '').includes('Post-approval secretary addendum'),
                'Newer v2 draft text must not leak into pinned approved resolution',
            );
            Assert(resolved.HasLegacyContent, 'Historical legacy summary in Minute.Content remains preserved');
        },
    },
    {
        Id: 'minute-artifact-dual-read.DR2',
        Name: 'DR2 — unpinned MJ Docs draft minute resolves latest version (v2) cleanly',
        RequiresMutation: false,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = World();
            const minute = await loadMinuteProjection(ctx, world.Minutes.financeLiveDraft);
            Assert(
                minute.MJArtifactID?.toLowerCase() === world.MJArtifacts.financeDraftMinutes.toLowerCase(),
                'Finance live draft minute links to MJ: Artifacts',
            );
            Assert(minute.ApprovedArtifactVersionID === null, 'Live draft has no pinned ApprovedArtifactVersionID');

            const service = new MinuteArtifactBridgeService();
            const [resolved] = await service.LoadAndResolveMinutes([minute], ctx.User, ProviderOf(ctx));
            Assert(resolved.Kind === 'mj-doc-latest', `Expected mj-doc-latest, got ${resolved.Kind}`);
            if (resolved.Kind !== 'mj-doc-latest') return;

            Assert(resolved.IsPinnedApprovedVersion === false, 'Unpinned draft must not be marked pinned');
            Assert(resolved.VersionNumber === 2, `Expected latest VersionNumber 2, got ${resolved.VersionNumber}`);
            Assert(
                resolved.ArtifactVersionID?.toLowerCase() === world.MJArtifactVersions.financeDraftV2.toLowerCase(),
                'Resolved latest version ID matches v2',
            );
            Assert(
                (resolved.Content ?? '').includes('Revision 2: Updated cash reserve floor'),
                'Latest v2 draft content is returned',
            );
        },
    },
    {
        Id: 'minute-artifact-dual-read.DR3',
        Name: 'DR3 — legacy minute (MJArtifactID IS NULL) falls back to Minute.Content with opt-in bridge flag',
        RequiresMutation: false,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = World();
            const minute = await loadMinuteProjection(ctx, world.Minutes.financePastLegacy);
            Assert(minute.MJArtifactID === null, 'Legacy minute has MJArtifactID IS NULL');
            Assert(minute.ApprovedArtifactVersionID === null, 'Legacy minute has ApprovedArtifactVersionID IS NULL');

            const service = new MinuteArtifactBridgeService();
            const [resolved] = await service.LoadAndResolveMinutes([minute], ctx.User, ProviderOf(ctx));
            Assert(resolved.Kind === 'legacy-content', `Expected legacy-content, got ${resolved.Kind}`);
            if (resolved.Kind !== 'legacy-content') return;

            Assert(resolved.Source === 'legacy', 'Resolved source is legacy');
            Assert(resolved.CanBridgeToMJDoc === true, 'Populated legacy minute advertises CanBridgeToMJDoc');
            Assert(
                (resolved.Content ?? '').includes('Finance Committee met to review Q1 close'),
                'Legacy Minute.Content is returned intact',
            );
        },
    },
    {
        Id: 'minute-artifact-dual-read.DR4',
        Name: 'DR4 — opt-in BridgeLegacyMinuteToMJDoc preserves Minute.Content, is idempotent, and supports version pinning',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = World();
            const md = ProviderOf(ctx);
            const originalContent = `${WORLD_MARK}:DR4 Legacy plain-text minutes for opt-in bridge verification.`;

            let createdMinuteId: string | null = null;
            let createdArtifactId: string | null = null;
            let createdVersionId: string | null = null;

            try {
                const tempMinute = await md.GetEntityObject<mjBizAppsCommitteesMinuteEntity>(E_MINUTE, ctx.User);
                tempMinute.NewRecord();
                tempMinute.MeetingID = world.Meetings.programPostponed;
                tempMinute.ApprovalStatus = 'Draft';
                tempMinute.Content = originalContent;
                tempMinute.MJArtifactID = null;
                tempMinute.ApprovedArtifactVersionID = null;
                await RequireSave(tempMinute, 'DR4 temporary legacy minute');
                createdMinuteId = tempMinute.ID;

                const service = new MinuteArtifactBridgeService();
                const bridged = await service.BridgeLegacyMinuteToMJDoc(
                    {
                        MinuteID: createdMinuteId,
                        ArtifactName: `${WORLD_MARK}:DR4 Bridged Program Minutes`,
                        OwnerUserID: ctx.User.ID,
                    },
                    ctx.User,
                    md,
                );
                Assert(bridged.Success, `BridgeLegacyMinuteToMJDoc failed: ${bridged.ErrorMessage ?? 'unknown error'}`);
                Assert(bridged.AlreadyBridged === false, 'First bridge creates a new MJ Doc');
                Assert(bridged.PreservedLegacyContent === true, 'PreservedLegacyContent must be true');
                Assert(!!bridged.MJArtifactID && !!bridged.ArtifactVersionID, 'Created MJArtifactID and v1 ID');
                createdArtifactId = bridged.MJArtifactID;
                createdVersionId = bridged.ArtifactVersionID;

                // Verify legacy Minute.Content is completely untouched in the database
                const afterBridge = await loadMinuteProjection(ctx, createdMinuteId);
                Assert(
                    afterBridge.Content === originalContent,
                    'Minute.Content must remain byte-for-byte intact after opt-in bridging',
                );
                Assert(
                    afterBridge.MJArtifactID?.toLowerCase() === createdArtifactId.toLowerCase(),
                    'Minute.MJArtifactID persisted in database',
                );
                Assert(
                    afterBridge.ApprovedArtifactVersionID === null,
                    'Draft bridged minute remains unpinned until formal approval',
                );

                // Repeat invocation must be idempotent and never create a duplicate MJ Artifact
                const repeat = await service.BridgeLegacyMinuteToMJDoc(
                    { MinuteID: createdMinuteId, OwnerUserID: ctx.User.ID },
                    ctx.User,
                    md,
                );
                Assert(repeat.Success && repeat.AlreadyBridged === true, 'Second bridge call must be idempotent');
                Assert(
                    repeat.MJArtifactID?.toLowerCase() === createdArtifactId.toLowerCase(),
                    'Idempotent call returns original MJArtifactID',
                );

                // Formal approval pins ApprovedArtifactVersionID to v1
                const pinned = await service.PinApprovedMinuteVersion(
                    {
                        MinuteID: createdMinuteId,
                        MarkApproved: true,
                        ApprovedByMeetingID: world.Meetings.financeThu,
                    },
                    ctx.User,
                    md,
                );
                Assert(pinned.Success, `PinApprovedMinuteVersion failed: ${pinned.ErrorMessage ?? 'unknown error'}`);
                Assert(
                    pinned.ApprovedArtifactVersionID?.toLowerCase() === createdVersionId.toLowerCase(),
                    'PinApprovedMinuteVersion pins v1',
                );
                Assert(pinned.VersionNumber === 1, `Expected pinned version 1, got ${pinned.VersionNumber}`);

                const [resolvedPinned] = await service.LoadAndResolveMinutes(
                    [await loadMinuteProjection(ctx, createdMinuteId)],
                    ctx.User,
                    md,
                );
                Assert(resolvedPinned.Kind === 'mj-doc-pinned', `Expected mj-doc-pinned after pinning, got ${resolvedPinned.Kind}`);
                if (resolvedPinned.Kind === 'mj-doc-pinned') {
                    Assert(resolvedPinned.Content === originalContent, 'Bridged MJ Doc v1 mirrors original legacy content');
                    Assert(resolvedPinned.LegacyContent === originalContent, 'LegacyContent remains preserved alongside MJ Doc');
                }
            } finally {
                if (createdMinuteId) {
                    await DeleteRow(ctx, E_MINUTE, createdMinuteId);
                }
                if (createdVersionId) {
                    await DeleteRow(ctx, E_MJ_ARTIFACT_VERSION, createdVersionId);
                }
                if (createdArtifactId) {
                    await DeleteRow(ctx, E_MJ_ARTIFACT, createdArtifactId);
                }
            }
        },
    },
    {
        Id: 'minute-artifact-dual-read.DR5',
        Name: 'DR5 — mixed Committees: Artifacts (external URL vs native MJ Docs) resolve cleanly in one batched RunViews call',
        RequiresMutation: false,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = World();
            const seededIds = Object.values(world.Artifacts);
            Assert(seededIds.length >= 6, `Expected >=6 seeded Committees: Artifacts, got ${seededIds.length}`);

            const idList = seededIds.map((id) => `'${id}'`).join(',');
            const rows = await FindRows<CommitteeArtifactBridgeInput>(
                ctx,
                E_ARTIFACT,
                `ID IN (${idList})`,
                ARTIFACT_PROJECTION_FIELDS,
            );
            Assert(rows.length === seededIds.length, `Expected ${seededIds.length} artifacts, got ${rows.length}`);

            const service = new MinuteArtifactBridgeService();
            const resolved = await service.LoadAndResolveCommitteeArtifacts(rows, ctx.User, ProviderOf(ctx));

            const external = resolved.filter((r) => r.Kind === 'external-url');
            const nativeDocs = resolved.filter((r) => r.Kind === 'mj-doc');
            Assert(external.length >= 3, `Expected >=3 external-url artifacts, got ${external.length}`);
            Assert(nativeDocs.length >= 3, `Expected >=3 native mj-doc artifacts, got ${nativeDocs.length}`);

            for (const ext of external) {
                Assert(ext.MJArtifactID === null, `External artifact ${ext.Name} must have null MJArtifactID`);
                Assert(ext.URL.startsWith('https://'), `External artifact ${ext.Name} keeps valid external URL`);
            }
            for (const doc of nativeDocs) {
                Assert(doc.IsArtifactMissing === false, `Native MJ Doc artifact ${doc.Name} resolved cleanly`);
                Assert(doc.Artifact !== null, `Native MJ Doc artifact ${doc.Name} carries MJ: Artifacts metadata`);
                Assert(
                    doc.LatestVersion !== null && (doc.LatestVersion.Content ?? '').length > 0,
                    `Native MJ Doc artifact ${doc.Name} carries latest version content`,
                );
            }
        },
    },
    {
        Id: 'minute-artifact-dual-read.DR6',
        Name: 'DR6 — multi-entity COM-WORLD seed density covers >=20 domain records across organizations, committees, people, roles, meetings, minutes, and artifacts',
        RequiresMutation: false,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = World();
            const [orgs, committees, people, users, roles, terms, meetings, minutes, artifacts, motions] =
                await Promise.all([
                    FindRows<{ ID: string }>(ctx, E_ORGANIZATION, `ID = '${world.OrganizationID}'`, ['ID']),
                    FindRows<{ ID: string }>(ctx, E_COMMITTEE, `Description LIKE '${WORLD_MARK}:%'`, ['ID']),
                    FindRows<{ ID: string }>(ctx, E_PERSON, `Email LIKE '%@com-world.test'`, ['ID']),
                    FindRows<{ ID: string }>(ctx, E_USER, `Email LIKE '%@com-world.test'`, ['ID']),
                    FindRows<{ ID: string }>(ctx, E_ROLE, '', ['ID']),
                    FindRows<{ ID: string }>(
                        ctx,
                        E_TERM,
                        `ID IN (${Object.values(world.Terms).map((id) => `'${id}'`).join(',')})`,
                        ['ID'],
                    ),
                    FindRows<{ ID: string }>(
                        ctx,
                        E_MEETING,
                        `ID IN (${Object.values(world.Meetings).map((id) => `'${id}'`).join(',')})`,
                        ['ID'],
                    ),
                    FindRows<{ ID: string; MJArtifactID: string | null; ApprovedArtifactVersionID: string | null }>(
                        ctx,
                        E_MINUTE,
                        `ID IN (${Object.values(world.Minutes).map((id) => `'${id}'`).join(',')})`,
                        ['ID', 'MJArtifactID', 'ApprovedArtifactVersionID'],
                    ),
                    FindRows<{ ID: string; MJArtifactID: string | null }>(
                        ctx,
                        E_ARTIFACT,
                        `ID IN (${Object.values(world.Artifacts).map((id) => `'${id}'`).join(',')})`,
                        ['ID', 'MJArtifactID'],
                    ),
                    FindRows<{ ID: string }>(ctx, E_MOTION, '', ['ID']),
                ]);

            const totalDomainRecords =
                orgs.length +
                committees.length +
                people.length +
                users.length +
                roles.length +
                terms.length +
                meetings.length +
                minutes.length +
                artifacts.length +
                motions.length;

            Assert(orgs.length >= 1, 'At least 1 organization seeded');
            Assert(committees.length >= 9, `Expected >=9 committees, got ${committees.length}`);
            Assert(people.length >= 30, `Expected >=30 people, got ${people.length}`);
            Assert(users.length >= 5, `Expected >=5 persona users, got ${users.length}`);
            Assert(roles.length >= 4, `Expected >=4 roles, got ${roles.length}`);
            Assert(meetings.length >= 13, `Expected >=13 meetings, got ${meetings.length}`);
            Assert(minutes.length >= 6, `Expected >=6 minutes (legacy + pinned + draft), got ${minutes.length}`);
            Assert(
                minutes.some((m) => m.MJArtifactID === null) &&
                    minutes.some((m) => m.MJArtifactID !== null && m.ApprovedArtifactVersionID !== null) &&
                    minutes.some((m) => m.MJArtifactID !== null && m.ApprovedArtifactVersionID === null),
                'Minutes span all three modes: legacy, pinned MJ Doc, and unpinned live draft MJ Doc',
            );
            Assert(
                artifacts.some((a) => a.MJArtifactID === null) && artifacts.some((a) => a.MJArtifactID !== null),
                'Artifacts span both external URL links and native MJ Docs',
            );
            Assert(totalDomainRecords >= 20, `Expected >=20 realistic domain records, got ${totalDomainRecords}`);
        },
    },
];

for (const check of MinuteArtifactDualReadChecks) {
    IntegrationCheckRegistry.Instance.Register(check);
}

IntegrationCheckRegistry.Instance.RegisterLifecycle('minute-artifact-dual-read', {
    Setup: async (ctx: IntegrationCheckContext) => {
        await LoadWorld(ctx);
    },
    Teardown: async () => undefined,
});
