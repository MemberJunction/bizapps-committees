/**
 * Seeds realistic MJ Docs (MJ: Artifacts + MJ: Artifact Versions), MJ-Docs-backed Minutes
 * (both pinned approved and live unpinned draft), and mixed external-URL vs native MJ-Docs
 * Committees: Artifacts records into COM-WORLD using strongly typed generated entities.
 */
import type { MJArtifactEntity, MJArtifactVersionEntity } from '@memberjunction/core-entities';
import type { IntegrationCheckContext } from '@memberjunction/testing-integration/registry';
import { Assert } from '@memberjunction/testing-integration/registry';
import type {
    mjBizAppsCommitteesArtifactEntity,
    mjBizAppsCommitteesMinuteEntity,
} from '@mj-biz-apps/committees-entities';
import {
    E_ARTIFACT,
    E_ARTIFACT_TYPE,
    E_MINUTE,
    E_MJ_ARTIFACT,
    E_MJ_ARTIFACT_TYPE,
    E_MJ_ARTIFACT_VERSION,
    FindId,
    FindRows,
    ProviderOf,
    Quote,
    RequireSave,
    UtcDay,
    WORLD_MARK,
} from '../fixture.js';

export interface MJDocsWorldSeedInput {
    Committees: Record<string, string>;
    Meetings: Record<string, string>;
    People: Record<string, string>;
    LegacyMinutes: Record<string, string>;
}

export interface MJDocsWorldSeedResult {
    Minutes: Record<string, string>;
    Artifacts: Record<string, string>;
    MJArtifacts: Record<string, string>;
    MJArtifactVersions: Record<string, string>;
}

interface MJArtifactTypeRow {
    ID: string;
    Name: string;
    ContentType: string;
    IsEnabled: boolean | number;
}

interface CommitteeArtifactTypeRow {
    ID: string;
    Name: string;
}

async function resolveMJArtifactTypeId(ctx: IntegrationCheckContext): Promise<string> {
    const rows = await FindRows<MJArtifactTypeRow>(
        ctx,
        E_MJ_ARTIFACT_TYPE,
        '',
        ['ID', 'Name', 'ContentType', 'IsEnabled'],
    );
    const enabled = rows.filter((r) => Boolean(r.IsEnabled));
    const preferred =
        enabled.find((r) => r.Name.toLowerCase() === 'markdown') ??
        enabled.find((r) => (r.ContentType ?? '').toLowerCase().includes('markdown')) ??
        enabled.find((r) => r.Name.toLowerCase() === 'document') ??
        enabled[0] ??
        rows[0];
    Assert(!!preferred, 'Expected at least one MJ: Artifact Types record in core metadata');
    return preferred.ID;
}

async function resolveCommitteeArtifactTypes(ctx: IntegrationCheckContext): Promise<Record<string, string>> {
    const rows = await FindRows<CommitteeArtifactTypeRow>(ctx, E_ARTIFACT_TYPE, '', ['ID', 'Name']);
    Assert(rows.length > 0, 'Expected seeded Committees: Artifact Types records');
    const byName = new Map(rows.map((r) => [r.Name.toLowerCase(), r.ID]));
    const fallback = rows[0].ID;
    return {
        document: byName.get('document') ?? fallback,
        minutes: byName.get('minutes') ?? fallback,
        presentation: byName.get('presentation') ?? fallback,
    };
}

async function upsertMJArtifact(
    ctx: IntegrationCheckContext,
    typeId: string,
    name: string,
    description: string,
): Promise<string> {
    const md = ProviderOf(ctx);
    const existing = await FindId(ctx, E_MJ_ARTIFACT, `Name = '${Quote(name)}'`);
    const artifact = await md.GetEntityObject<MJArtifactEntity>(E_MJ_ARTIFACT, ctx.User);
    if (existing) {
        Assert(await artifact.Load(existing), `load MJ: Artifacts ${name}`);
    } else {
        artifact.NewRecord();
    }
    artifact.Name = name;
    artifact.Description = description;
    artifact.TypeID = typeId;
    artifact.UserID = ctx.User.ID;
    artifact.Visibility = 'Always';
    await RequireSave(artifact, `MJ: Artifacts ${name}`);
    return artifact.ID;
}

async function upsertMJArtifactVersion(
    ctx: IntegrationCheckContext,
    artifactId: string,
    versionNumber: number,
    name: string,
    content: string,
): Promise<string> {
    const md = ProviderOf(ctx);
    const existing = await FindId(
        ctx,
        E_MJ_ARTIFACT_VERSION,
        `ArtifactID = '${artifactId}' AND VersionNumber = ${versionNumber}`,
    );
    const version = await md.GetEntityObject<MJArtifactVersionEntity>(E_MJ_ARTIFACT_VERSION, ctx.User);
    if (existing) {
        Assert(await version.Load(existing), `load MJ: Artifact Versions ${name} v${versionNumber}`);
    } else {
        version.NewRecord();
        version.ArtifactID = artifactId;
        version.VersionNumber = versionNumber;
    }
    version.Name = name;
    version.Description = `${WORLD_MARK} version ${versionNumber}`;
    version.Content = content;
    version.ContentMode = 'Text';
    version.UserID = ctx.User.ID;
    await RequireSave(version, `MJ: Artifact Versions ${name} v${versionNumber}`);
    return version.ID;
}

async function upsertMJDocMinute(
    ctx: IntegrationCheckContext,
    params: {
        meetingId: string;
        status: 'Approved' | 'Draft';
        content: string | null;
        mjArtifactId: string;
        approvedVersionId: string | null;
        approvedByMeetingId?: string | null;
    },
): Promise<string> {
    const md = ProviderOf(ctx);
    const existing = await FindId(ctx, E_MINUTE, `MeetingID = '${params.meetingId}'`);
    const minute = await md.GetEntityObject<mjBizAppsCommitteesMinuteEntity>(E_MINUTE, ctx.User);
    if (existing) {
        Assert(await minute.Load(existing), `load Minute for meeting ${params.meetingId}`);
    } else {
        minute.NewRecord();
        minute.MeetingID = params.meetingId;
    }
    minute.ApprovalStatus = params.status;
    minute.Content = params.content;
    minute.MJArtifactID = params.mjArtifactId;
    minute.ApprovedArtifactVersionID = params.approvedVersionId;
    if (params.status === 'Approved') {
        minute.ApprovedAt = UtcDay(-25);
        minute.ApprovedByMeetingID = params.approvedByMeetingId ?? null;
    } else {
        minute.ApprovedAt = null;
        minute.ApprovedByMeetingID = null;
    }
    await RequireSave(minute, `MJ Docs Minute (${params.status})`);
    return minute.ID;
}

async function upsertCommitteeArtifact(
    ctx: IntegrationCheckContext,
    params: {
        name: string;
        description: string;
        committeeId: string;
        meetingId: string | null;
        artifactTypeId: string;
        provider: mjBizAppsCommitteesArtifactEntity['Provider'];
        url: string;
        uploadedByPersonId: string;
        mjArtifactId: string | null;
    },
): Promise<string> {
    const md = ProviderOf(ctx);
    const existing = await FindId(
        ctx,
        E_ARTIFACT,
        `CommitteeID = '${params.committeeId}' AND Name = '${Quote(params.name)}'`,
    );
    const artifact = await md.GetEntityObject<mjBizAppsCommitteesArtifactEntity>(E_ARTIFACT, ctx.User);
    if (existing) {
        Assert(await artifact.Load(existing), `load Committees: Artifacts ${params.name}`);
    } else {
        artifact.NewRecord();
        artifact.CommitteeID = params.committeeId;
    }
    artifact.Name = params.name;
    artifact.Description = params.description;
    artifact.MeetingID = params.meetingId;
    artifact.ArtifactTypeID = params.artifactTypeId;
    artifact.Provider = params.provider;
    artifact.URL = params.url;
    artifact.UploadedByPersonID = params.uploadedByPersonId;
    artifact.MJArtifactID = params.mjArtifactId;
    await RequireSave(artifact, `Committees: Artifacts ${params.name}`);
    return artifact.ID;
}

export async function SeedMJDocsWorld(
    ctx: IntegrationCheckContext,
    input: MJDocsWorldSeedInput,
): Promise<MJDocsWorldSeedResult> {
    const mjTypeId = await resolveMJArtifactTypeId(ctx);
    const artTypes = await resolveCommitteeArtifactTypes(ctx);

    const boardMinutesDoc = await upsertMJArtifact(
        ctx,
        mjTypeId,
        `${WORLD_MARK}: Annual Board Meeting Minutes`,
        'Official board governance minutes backed by MJ Docs with pinned approved v1.',
    );
    const boardMinutesV1 = await upsertMJArtifactVersion(
        ctx,
        boardMinutesDoc,
        1,
        'Annual Board Meeting Minutes — Approved v1',
        '# Annual Board Meeting Minutes\n\nAdopted FY27 strategic plan and ratified officer slate unanimously.',
    );
    const boardMinutesV2 = await upsertMJArtifactVersion(
        ctx,
        boardMinutesDoc,
        2,
        'Annual Board Meeting Minutes — Working Addendum v2',
        '# Annual Board Meeting Minutes\n\nPost-approval secretary addendum with formatting cleanup.',
    );

    const financeDraftDoc = await upsertMJArtifact(
        ctx,
        mjTypeId,
        `${WORLD_MARK}: Finance Budget Amendment Draft Minutes`,
        'Active working draft minutes floating on the latest MJ Artifact Version.',
    );
    const financeDraftV1 = await upsertMJArtifactVersion(
        ctx,
        financeDraftDoc,
        1,
        'Finance Budget Amendment Draft — v1',
        '# Budget Amendment Working Session\n\nRevision 1: Initial draft notes from Q2 treasury review.',
    );
    const financeDraftV2 = await upsertMJArtifactVersion(
        ctx,
        financeDraftDoc,
        2,
        'Finance Budget Amendment Draft — v2',
        '# Budget Amendment Working Session\n\nRevision 2: Updated cash reserve floor and Q3 forecast.',
    );

    const boardCharterDoc = await upsertMJArtifact(
        ctx,
        mjTypeId,
        `${WORLD_MARK}: Board Governance Charter MJ Doc`,
        'Native MJ Docs charter document linked from Committees: Artifacts.',
    );
    const boardCharterV1 = await upsertMJArtifactVersion(
        ctx,
        boardCharterDoc,
        1,
        'Board Governance Charter v1',
        '# Board Governance Charter\n\nDefines quorum, fiduciary duties, and annual term cadence.',
    );

    const budgetNarrativeDoc = await upsertMJArtifact(
        ctx,
        mjTypeId,
        `${WORLD_MARK}: FY27 Budget Narrative MJ Doc`,
        'Native MJ Docs financial narrative for Finance Committee review.',
    );
    const budgetNarrativeV1 = await upsertMJArtifactVersion(
        ctx,
        budgetNarrativeDoc,
        1,
        'FY27 Budget Narrative v1',
        '# FY27 Budget Narrative\n\nOperating reserve targets and departmental allocations.',
    );

    const coiPolicyDoc = await upsertMJArtifact(
        ctx,
        mjTypeId,
        `${WORLD_MARK}: Revised Conflict-of-Interest Policy MJ Doc`,
        'Native MJ Docs policy document under Governance Committee e-ballot review.',
    );
    const coiPolicyV1 = await upsertMJArtifactVersion(
        ctx,
        coiPolicyDoc,
        1,
        'Conflict-of-Interest Policy v1',
        '# Conflict-of-Interest Policy\n\nAnnual disclosure obligations and recusal procedures.',
    );

    const boardApprovedPinned = await upsertMJDocMinute(ctx, {
        meetingId: input.Meetings.boardPast,
        status: 'Approved',
        content: 'Historical summary: Annual board meeting minutes approved and pinned to MJ Docs v1.',
        mjArtifactId: boardMinutesDoc,
        approvedVersionId: boardMinutesV1,
    });

    const financeLiveDraft = await upsertMJDocMinute(ctx, {
        meetingId: input.Meetings.financeLive,
        status: 'Draft',
        content: null,
        mjArtifactId: financeDraftDoc,
        approvedVersionId: null,
    });

    const financePacketUrl = await upsertCommitteeArtifact(ctx, {
        name: `${WORLD_MARK}: Q2 Financial Close Packet.pdf`,
        description: 'External Google Drive packet linked without MJArtifactID.',
        committeeId: input.Committees.finance,
        meetingId: input.Meetings.financeThu,
        artifactTypeId: artTypes.document,
        provider: 'GoogleDrive',
        url: 'https://drive.google.com/file/d/com-world-q2-close-packet/view',
        uploadedByPersonId: input.People.priya,
        mjArtifactId: null,
    });
    const bylawsRedlineUrl = await upsertCommitteeArtifact(ctx, {
        name: `${WORLD_MARK}: Bylaws Redline Comparison.docx`,
        description: 'External SharePoint document linked without MJArtifactID.',
        committeeId: input.Committees.governance,
        meetingId: input.Meetings.governancePast,
        artifactTypeId: artTypes.document,
        provider: 'SharePoint',
        url: 'https://contoso.sharepoint.com/sites/governance/bylaws-redline.docx',
        uploadedByPersonId: input.People.marcus,
        mjArtifactId: null,
    });
    const auditCharterUrl = await upsertCommitteeArtifact(ctx, {
        name: `${WORLD_MARK}: External Audit Charter.pdf`,
        description: 'External HTTPS URL artifact linked without MJArtifactID.',
        committeeId: input.Committees.audit,
        meetingId: input.Meetings.auditThu,
        artifactTypeId: artTypes.document,
        provider: 'URL',
        url: 'https://example.org/blue-cypress/audit-charter.pdf',
        uploadedByPersonId: input.People.dana,
        mjArtifactId: null,
    });

    const boardCharterArtifact = await upsertCommitteeArtifact(ctx, {
        name: `${WORLD_MARK}: Board Governance Charter (MJ Doc)`,
        description: 'Native MJ Docs governance charter artifact.',
        committeeId: input.Committees.board,
        meetingId: input.Meetings.boardPast,
        artifactTypeId: artTypes.document,
        provider: 'URL',
        url: `https://mj.local/artifacts/${boardCharterDoc}`,
        uploadedByPersonId: input.People.elena,
        mjArtifactId: boardCharterDoc,
    });
    const budgetNarrativeArtifact = await upsertCommitteeArtifact(ctx, {
        name: `${WORLD_MARK}: FY27 Budget Narrative (MJ Doc)`,
        description: 'Native MJ Docs budget narrative artifact.',
        committeeId: input.Committees.finance,
        meetingId: input.Meetings.financeLive,
        artifactTypeId: artTypes.presentation,
        provider: 'URL',
        url: `https://mj.local/artifacts/${budgetNarrativeDoc}`,
        uploadedByPersonId: input.People.alex,
        mjArtifactId: budgetNarrativeDoc,
    });
    const coiPolicyArtifact = await upsertCommitteeArtifact(ctx, {
        name: `${WORLD_MARK}: Conflict-of-Interest Policy (MJ Doc)`,
        description: 'Native MJ Docs policy artifact for Governance review.',
        committeeId: input.Committees.governance,
        meetingId: input.Meetings.governancePast,
        artifactTypeId: artTypes.document,
        provider: 'URL',
        url: `https://mj.local/artifacts/${coiPolicyDoc}`,
        uploadedByPersonId: input.People.marcus,
        mjArtifactId: coiPolicyDoc,
    });

    return {
        Minutes: {
            ...input.LegacyMinutes,
            boardApprovedPinned,
            financeLiveDraft,
        },
        Artifacts: {
            financePacketUrl,
            bylawsRedlineUrl,
            auditCharterUrl,
            boardCharterDoc: boardCharterArtifact,
            budgetNarrativeDoc: budgetNarrativeArtifact,
            coiPolicyDoc: coiPolicyArtifact,
        },
        MJArtifacts: {
            boardMinutes: boardMinutesDoc,
            financeDraftMinutes: financeDraftDoc,
            boardCharterDoc,
            budgetNarrativeDoc,
            coiPolicyDoc,
        },
        MJArtifactVersions: {
            boardMinutesV1,
            boardMinutesV2,
            financeDraftV1,
            financeDraftV2,
            boardCharterV1,
            budgetNarrativeV1,
            coiPolicyV1,
        },
    };
}
