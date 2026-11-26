import { describe, it, expect, vi, afterEach } from 'vitest';
import {
    IMetadataProvider,
    RunView,
    RunViewParams,
    RunViewResult,
    TransactionGroupBase,
    UserInfo,
} from '@memberjunction/core';
import {
    ArtifactBundleMap,
    CommitteeArtifactBridgeInput,
    MinuteArtifactBridgeService,
    MinuteDualReadInput,
    MJArtifactSummaryRow,
    MJArtifactVersionSummaryRow,
} from '../MinuteArtifactBridgeService.js';

const MINUTE_ID_1 = '10000000-0000-4000-8000-000000000001';
const MINUTE_ID_2 = '10000000-0000-4000-8000-000000000002';
const MINUTE_ID_3 = '10000000-0000-4000-8000-000000000003';
const MEETING_ID = '20000000-0000-4000-8000-000000000001';
const ARTIFACT_ID_1 = '30000000-0000-4000-8000-000000000001';
const ARTIFACT_ID_2 = '30000000-0000-4000-8000-000000000002';
const VERSION_ID_1 = '40000000-0000-4000-8000-000000000001';
const VERSION_ID_2 = '40000000-0000-4000-8000-000000000002';
const VERSION_ID_OTHER = '40000000-0000-4000-8000-000000000099';
const TYPE_ID_MD = '50000000-0000-4000-8000-000000000001';
const USER_ID = '60000000-0000-4000-8000-000000000001';
const COMM_ARTIFACT_ID_1 = '70000000-0000-4000-8000-000000000001';
const COMM_ARTIFACT_ID_2 = '70000000-0000-4000-8000-000000000002';

function makeArtifact(id: string, name: string): MJArtifactSummaryRow {
    return {
        ID: id,
        Name: name,
        Description: 'Committee minutes document',
        TypeID: TYPE_ID_MD,
        Type: 'Markdown',
        Visibility: 'Always',
        __mj_CreatedAt: '2026-11-01T10:00:00Z',
        __mj_UpdatedAt: '2026-11-02T10:00:00Z',
    };
}

function makeVersion(
    id: string,
    artifactId: string,
    versionNumber: number,
    content: string
): MJArtifactVersionSummaryRow {
    return {
        ID: id,
        ArtifactID: artifactId,
        VersionNumber: versionNumber,
        Name: `v${versionNumber}`,
        Description: null,
        Content: content,
        ContentMode: 'Text',
        MimeType: null,
        FileName: null,
        __mj_CreatedAt: `2026-11-0${versionNumber}T12:00:00Z`,
        __mj_UpdatedAt: `2026-11-0${versionNumber}T12:00:00Z`,
    };
}

function makeBundle(
    artifacts: MJArtifactSummaryRow[],
    versions: MJArtifactVersionSummaryRow[]
): ArtifactBundleMap {
    const bundle: ArtifactBundleMap = {
        ArtifactsById: new Map(),
        VersionsByArtifactId: new Map(),
        VersionsById: new Map(),
        Errors: [],
    };
    for (const a of artifacts) {
        bundle.ArtifactsById.set(a.ID.toLowerCase(), a);
    }
    for (const v of versions) {
        bundle.VersionsById.set(v.ID.toLowerCase(), v);
        const list = bundle.VersionsByArtifactId.get(v.ArtifactID.toLowerCase()) ?? [];
        list.push(v);
        bundle.VersionsByArtifactId.set(v.ArtifactID.toLowerCase(), list);
    }
    return bundle;
}

function makeMinuteInput(overrides: Partial<MinuteDualReadInput> = {}): MinuteDualReadInput {
    return {
        ID: MINUTE_ID_1,
        MeetingID: MEETING_ID,
        Content: '# Legacy Minutes Content',
        ApprovalStatus: 'Draft',
        ApprovedAt: null,
        ApprovedByMeetingID: null,
        MJArtifactID: null,
        ApprovedArtifactVersionID: null,
        ...overrides,
    };
}

function makeCommitteeArtifactInput(
    overrides: Partial<CommitteeArtifactBridgeInput> = {}
): CommitteeArtifactBridgeInput {
    return {
        ID: COMM_ARTIFACT_ID_1,
        Name: 'Q4 Charter Package',
        Description: 'Governance charter',
        CommitteeID: null,
        MeetingID: MEETING_ID,
        AgendaItemID: null,
        TaskID: null,
        ArtifactTypeID: TYPE_ID_MD,
        Provider: 'GoogleDrive',
        ExternalID: 'gdrive-123',
        URL: 'https://drive.google.com/file/d/gdrive-123/view',
        MimeType: 'application/pdf',
        FileSize: 4096,
        MJArtifactID: null,
        ...overrides,
    };
}

interface FakeEntityRecord {
    ID: string;
    Name?: string;
    Description?: string | null;
    TypeID?: string;
    UserID?: string;
    Visibility?: 'Always' | 'System Only';
    ArtifactID?: string;
    VersionNumber?: number;
    Content?: string | null;
    ContentMode?: 'File' | 'Text';
    Meeting?: string | null;
    MJArtifactID?: string | null;
    ApprovedArtifactVersionID?: string | null;
    ApprovalStatus?: 'Approved' | 'Draft' | 'PendingApproval' | 'Rejected';
    ApprovedAt?: Date | null;
    ApprovedByMeetingID?: string | null;
    TransactionGroup?: TransactionGroupBase | null;
    LatestResult?: { Message?: string };
    NewRecord: () => void;
    Load: (id: string) => Promise<boolean>;
    Save: () => Promise<boolean>;
    Delete: () => Promise<boolean>;
}

function createFakeEntity(initial: Partial<FakeEntityRecord>): FakeEntityRecord {
    return {
        ID: initial.ID ?? '',
        NewRecord: vi.fn(),
        Load: vi.fn().mockResolvedValue(true),
        Save: vi.fn().mockResolvedValue(true),
        Delete: vi.fn().mockResolvedValue(true),
        ...initial,
    };
}

describe('MinuteArtifactBridgeService — pure dual-read resolution', () => {
    it('resolves pinned ApprovedArtifactVersionID over newer draft versions', () => {
        const artifact = makeArtifact(ARTIFACT_ID_1, 'Board Minutes — Nov 2026');
        const v1 = makeVersion(VERSION_ID_1, ARTIFACT_ID_1, 1, '# Approved v1 minutes');
        const v2 = makeVersion(VERSION_ID_2, ARTIFACT_ID_1, 2, '# Post-approval scratch edit v2');
        const bundle = makeBundle([artifact], [v1, v2]);

        const resolved = MinuteArtifactBridgeService.ResolveMinuteDocument(
            makeMinuteInput({
                ApprovalStatus: 'Approved',
                MJArtifactID: ARTIFACT_ID_1,
                ApprovedArtifactVersionID: VERSION_ID_1,
            }),
            bundle
        );

        expect(resolved.Kind).toBe('mj-doc-pinned');
        if (resolved.Kind === 'mj-doc-pinned') {
            expect(resolved.IsPinnedApprovedVersion).toBe(true);
            expect(resolved.ArtifactVersionID).toBe(VERSION_ID_1);
            expect(resolved.VersionNumber).toBe(1);
            expect(resolved.Content).toBe('# Approved v1 minutes');
            expect(resolved.LegacyContent).toBe('# Legacy Minutes Content');
            expect(resolved.HasLegacyContent).toBe(true);
        }
    });

    it('resolves latest version when MJArtifactID is set and ApprovedArtifactVersionID is null', () => {
        const artifact = makeArtifact(ARTIFACT_ID_1, 'Draft Minutes');
        const v1 = makeVersion(VERSION_ID_1, ARTIFACT_ID_1, 1, '# Draft v1');
        const v2 = makeVersion(VERSION_ID_2, ARTIFACT_ID_1, 2, '# Draft v2');
        const bundle = makeBundle([artifact], [v1, v2]);

        const resolved = MinuteArtifactBridgeService.ResolveMinuteDocument(
            makeMinuteInput({
                ApprovalStatus: 'Draft',
                MJArtifactID: ARTIFACT_ID_1,
                ApprovedArtifactVersionID: null,
            }),
            bundle
        );

        expect(resolved.Kind).toBe('mj-doc-latest');
        if (resolved.Kind === 'mj-doc-latest') {
            expect(resolved.IsPinnedApprovedVersion).toBe(false);
            expect(resolved.ArtifactVersionID).toBe(VERSION_ID_2);
            expect(resolved.VersionNumber).toBe(2);
            expect(resolved.Content).toBe('# Draft v2');
        }
    });

    it('falls back cleanly to legacy Minute.Content when MJArtifactID is null', () => {
        const bundle = makeBundle([], []);
        const resolved = MinuteArtifactBridgeService.ResolveMinuteDocument(
            makeMinuteInput({
                MJArtifactID: null,
                ApprovedArtifactVersionID: null,
                Content: '# Legacy Board Minutes',
            }),
            bundle
        );

        expect(resolved.Kind).toBe('legacy-content');
        if (resolved.Kind === 'legacy-content') {
            expect(resolved.Source).toBe('legacy');
            expect(resolved.Content).toBe('# Legacy Board Minutes');
            expect(resolved.CanBridgeToMJDoc).toBe(true);
            expect(resolved.HasLegacyContent).toBe(true);
        }
    });

    it('handles empty legacy minute with CanBridgeToMJDoc=false', () => {
        const resolved = MinuteArtifactBridgeService.ResolveMinuteDocument(
            makeMinuteInput({ Content: '   ', MJArtifactID: null }),
            makeBundle([], [])
        );

        expect(resolved.Kind).toBe('legacy-content');
        if (resolved.Kind === 'legacy-content') {
            expect(resolved.HasLegacyContent).toBe(false);
            expect(resolved.CanBridgeToMJDoc).toBe(false);
        }
    });

    it('surfaces explicit missing states for missing artifact, missing pinned version, mismatched version, and orphaned pin', () => {
        const artifact = makeArtifact(ARTIFACT_ID_1, 'Minutes');
        const foreignVersion = makeVersion(VERSION_ID_OTHER, ARTIFACT_ID_2, 1, '# Other doc');
        const bundle = makeBundle([artifact], [foreignVersion]);

        const missingArtifact = MinuteArtifactBridgeService.ResolveMinuteDocument(
            makeMinuteInput({ MJArtifactID: ARTIFACT_ID_2 }),
            bundle
        );
        expect(missingArtifact.Kind).toBe('mj-doc-missing');
        if (missingArtifact.Kind === 'mj-doc-missing') {
            expect(missingArtifact.MissingReason).toBe('artifact-not-found');
        }

        const missingPinned = MinuteArtifactBridgeService.ResolveMinuteDocument(
            makeMinuteInput({ MJArtifactID: ARTIFACT_ID_1, ApprovedArtifactVersionID: VERSION_ID_1 }),
            bundle
        );
        expect(missingPinned.Kind).toBe('mj-doc-missing');
        if (missingPinned.Kind === 'mj-doc-missing') {
            expect(missingPinned.MissingReason).toBe('pinned-version-not-found');
        }

        const mismatchedPinned = MinuteArtifactBridgeService.ResolveMinuteDocument(
            makeMinuteInput({ MJArtifactID: ARTIFACT_ID_1, ApprovedArtifactVersionID: VERSION_ID_OTHER }),
            bundle
        );
        expect(mismatchedPinned.Kind).toBe('mj-doc-missing');
        if (mismatchedPinned.Kind === 'mj-doc-missing') {
            expect(mismatchedPinned.MissingReason).toBe('pinned-version-artifact-mismatch');
        }

        const orphanedPin = MinuteArtifactBridgeService.ResolveMinuteDocument(
            makeMinuteInput({ MJArtifactID: null, ApprovedArtifactVersionID: VERSION_ID_1 }),
            bundle
        );
        expect(orphanedPin.Kind).toBe('mj-doc-missing');
        if (orphanedPin.Kind === 'mj-doc-missing') {
            expect(orphanedPin.MissingReason).toBe('orphaned-pinned-version');
        }
    });
});

describe('MinuteArtifactBridgeService — Committees.Artifact classification & batched RunViews', () => {
    afterEach(() => {
        vi.restoreAllMocks();
    });

    it('distinguishes external URL artifacts from native MJ Docs artifacts via discriminated union', () => {
        const artifact = makeArtifact(ARTIFACT_ID_1, 'Bylaws v3');
        const v1 = makeVersion(VERSION_ID_1, ARTIFACT_ID_1, 1, '# Bylaws');
        const bundle = makeBundle([artifact], [v1]);

        const externalRes = MinuteArtifactBridgeService.ClassifyCommitteeArtifact(
            makeCommitteeArtifactInput({ ID: COMM_ARTIFACT_ID_1, MJArtifactID: null }),
            bundle
        );
        expect(externalRes.Kind).toBe('external-url');
        if (externalRes.Kind === 'external-url') {
            expect(externalRes.URL).toContain('drive.google.com');
            expect(externalRes.Provider).toBe('GoogleDrive');
            expect(externalRes.MJArtifactID).toBeNull();
        }

        const mjDocRes = MinuteArtifactBridgeService.ClassifyCommitteeArtifact(
            makeCommitteeArtifactInput({ ID: COMM_ARTIFACT_ID_2, MJArtifactID: ARTIFACT_ID_1 }),
            bundle
        );
        expect(mjDocRes.Kind).toBe('mj-doc');
        if (mjDocRes.Kind === 'mj-doc') {
            expect(mjDocRes.MJArtifactID).toBe(ARTIFACT_ID_1);
            expect(mjDocRes.Artifact?.Name).toBe('Bylaws v3');
            expect(mjDocRes.LatestVersion?.ID).toBe(VERSION_ID_1);
            expect(mjDocRes.IsArtifactMissing).toBe(false);
        }
    });

    it('batches artifact and version lookups into a single RunViews call (zero N+1 queries)', async () => {
        const artifact1 = makeArtifact(ARTIFACT_ID_1, 'Board Minutes');
        const v1 = makeVersion(VERSION_ID_1, ARTIFACT_ID_1, 1, '# Approved v1');
        const v2 = makeVersion(VERSION_ID_2, ARTIFACT_ID_1, 2, '# Draft v2');

        const runViewsSpy = vi.fn(
            async (params: RunViewParams[]): Promise<RunViewResult[]> =>
                params.map((p) => {
                    if (p.EntityName === 'MJ: Artifacts') {
                        return {
                            Success: true,
                            Results: [artifact1],
                            UserViewRunID: '',
                            RowCount: 1,
                            TotalRowCount: 1,
                            ExecutionTime: 1,
                            ErrorMessage: '',
                        };
                    }
                    return {
                        Success: true,
                        Results: [v2, v1],
                        UserViewRunID: '',
                        RowCount: 2,
                        TotalRowCount: 2,
                        ExecutionTime: 1,
                        ErrorMessage: '',
                    };
                })
        );

        const fakeRunView = { RunViews: runViewsSpy } as Partial<RunView> as RunView;
        vi.spyOn(RunView, 'FromMetadataProvider').mockReturnValue(fakeRunView);

        const provider = {} as IMetadataProvider;
        const service = new MinuteArtifactBridgeService();
        const resolved = await service.LoadAndResolveMinutes(
            [
                makeMinuteInput({
                    ID: MINUTE_ID_1,
                    MJArtifactID: ARTIFACT_ID_1,
                    ApprovedArtifactVersionID: VERSION_ID_1,
                    ApprovalStatus: 'Approved',
                }),
                makeMinuteInput({
                    ID: MINUTE_ID_2,
                    MJArtifactID: ARTIFACT_ID_1,
                    ApprovedArtifactVersionID: null,
                    ApprovalStatus: 'Draft',
                }),
                makeMinuteInput({
                    ID: MINUTE_ID_3,
                    MJArtifactID: null,
                    ApprovedArtifactVersionID: null,
                    Content: '# Legacy only',
                }),
            ],
            undefined,
            provider
        );

        expect(runViewsSpy).toHaveBeenCalledTimes(1);
        const batchArgs = runViewsSpy.mock.calls[0]?.[0] ?? [];
        expect(batchArgs.every((q) => q.ResultType === 'simple')).toBe(true);
        expect(batchArgs.map((q) => q.EntityName)).toEqual([
            'MJ: Artifacts',
            'MJ: Artifact Versions',
            'MJ: Artifact Versions',
        ]);

        expect(resolved.map((r) => r.Kind)).toEqual(['mj-doc-pinned', 'mj-doc-latest', 'legacy-content']);
    });

    it('issues zero RunViews queries when all inputs are legacy or external URLs', async () => {
        const runViewsSpy = vi.fn();
        vi.spyOn(RunView, 'FromMetadataProvider').mockReturnValue({
            RunViews: runViewsSpy,
        } as Partial<RunView> as RunView);

        const service = new MinuteArtifactBridgeService();
        const provider = {} as IMetadataProvider;
        const res = await service.LoadAndResolveCommitteeArtifacts(
            [makeCommitteeArtifactInput({ MJArtifactID: null })],
            undefined,
            provider
        );

        expect(runViewsSpy).not.toHaveBeenCalled();
        expect(res).toHaveLength(1);
        expect(res[0]?.Kind).toBe('external-url');
    });
});

describe('MinuteArtifactBridgeService — opt-in bridge & approval pinning', () => {
    afterEach(() => {
        vi.restoreAllMocks();
    });

    it('bridges a legacy minute to MJ Docs via TransactionGroup without modifying legacy Minute.Content', async () => {
        const minuteEntity = createFakeEntity({
            ID: MINUTE_ID_1,
            Meeting: 'Q4 Audit Committee',
            Content: '# Original Legacy Content',
            ApprovalStatus: 'Approved',
            MJArtifactID: null,
            ApprovedArtifactVersionID: null,
        });
        const artifactEntity = createFakeEntity({ ID: ARTIFACT_ID_1 });
        const versionEntity = createFakeEntity({ ID: VERSION_ID_1 });
        const submitMock = vi.fn().mockResolvedValue(true);
        const txGroup = { Submit: submitMock } as Partial<TransactionGroupBase> as TransactionGroupBase;

        const md = {
            CurrentUser: { ID: USER_ID } as UserInfo,
            CreateTransactionGroup: vi.fn().mockResolvedValue(txGroup),
            GetEntityObject: vi.fn(async (entityName: string) => {
                if (entityName === 'Committees: Minutes') return minuteEntity;
                if (entityName === 'MJ: Artifacts') return artifactEntity;
                if (entityName === 'MJ: Artifact Versions') return versionEntity;
                throw new Error(`Unexpected entity ${entityName}`);
            }),
        } as Partial<IMetadataProvider> as IMetadataProvider;

        const service = new MinuteArtifactBridgeService();
        const result = await service.BridgeLegacyMinuteToMJDoc(
            { MinuteID: MINUTE_ID_1, ArtifactTypeID: TYPE_ID_MD },
            { ID: USER_ID } as UserInfo,
            md
        );

        expect(result.Success).toBe(true);
        expect(result.AlreadyBridged).toBe(false);
        expect(result.MJArtifactID).toBe(ARTIFACT_ID_1);
        expect(result.ArtifactVersionID).toBe(VERSION_ID_1);
        expect(result.PinnedApprovedVersionID).toBe(VERSION_ID_1);
        expect(result.PreservedLegacyContent).toBe(true);

        expect(submitMock).toHaveBeenCalledTimes(1);
        expect(minuteEntity.Content).toBe('# Original Legacy Content');
        expect(minuteEntity.MJArtifactID).toBe(ARTIFACT_ID_1);
        expect(minuteEntity.ApprovedArtifactVersionID).toBe(VERSION_ID_1);
        expect(versionEntity.Content).toBe('# Original Legacy Content');
        expect(versionEntity.ArtifactID).toBe(ARTIFACT_ID_1);
    });

    it('is idempotent when Minute.MJArtifactID is already linked', async () => {
        const minuteEntity = createFakeEntity({
            ID: MINUTE_ID_1,
            Content: '# Existing Legacy Content',
            MJArtifactID: ARTIFACT_ID_1,
            ApprovedArtifactVersionID: VERSION_ID_1,
        });

        const getEntitySpy = vi.fn().mockResolvedValue(minuteEntity);
        const md = {
            CurrentUser: { ID: USER_ID } as UserInfo,
            GetEntityObject: getEntitySpy,
        } as Partial<IMetadataProvider> as IMetadataProvider;

        const service = new MinuteArtifactBridgeService();
        const result = await service.BridgeLegacyMinuteToMJDoc(
            { MinuteID: MINUTE_ID_1, ArtifactTypeID: TYPE_ID_MD },
            { ID: USER_ID } as UserInfo,
            md
        );

        expect(result.Success).toBe(true);
        expect(result.AlreadyBridged).toBe(true);
        expect(result.MJArtifactID).toBe(ARTIFACT_ID_1);
        expect(getEntitySpy).toHaveBeenCalledTimes(1);
    });

    it('rolls back created MJ Artifact and Version if Minute save fails in sequential fallback mode', async () => {
        const minuteEntity = createFakeEntity({
            ID: MINUTE_ID_1,
            Content: '# Legacy Content',
            ApprovalStatus: 'Draft',
            MJArtifactID: null,
            ApprovedArtifactVersionID: null,
            Save: vi.fn().mockResolvedValue(false),
            LatestResult: { Message: 'Minute save rejected' },
        });
        const artifactEntity = createFakeEntity({ ID: ARTIFACT_ID_1 });
        const versionEntity = createFakeEntity({ ID: VERSION_ID_1 });

        const md = {
            CurrentUser: { ID: USER_ID } as UserInfo,
            GetEntityObject: vi.fn(async (entityName: string) => {
                if (entityName === 'Committees: Minutes') return minuteEntity;
                if (entityName === 'MJ: Artifacts') return artifactEntity;
                if (entityName === 'MJ: Artifact Versions') return versionEntity;
                throw new Error(`Unexpected entity ${entityName}`);
            }),
        } as Partial<IMetadataProvider> as IMetadataProvider;

        const service = new MinuteArtifactBridgeService();
        const result = await service.BridgeLegacyMinuteToMJDoc(
            { MinuteID: MINUTE_ID_1, ArtifactTypeID: TYPE_ID_MD },
            { ID: USER_ID } as UserInfo,
            md
        );

        expect(result.Success).toBe(false);
        expect(result.ErrorMessage).toContain('Minute save rejected');
        expect(versionEntity.Delete).toHaveBeenCalledTimes(1);
        expect(artifactEntity.Delete).toHaveBeenCalledTimes(1);
        expect(minuteEntity.Content).toBe('# Legacy Content');
    });

    it('pins ApprovedArtifactVersionID and rejects cross-artifact version mismatches', async () => {
        const minuteEntity = createFakeEntity({
            ID: MINUTE_ID_1,
            MJArtifactID: ARTIFACT_ID_1,
            ApprovedArtifactVersionID: null,
            ApprovalStatus: 'PendingApproval',
            ApprovedAt: null,
        });
        const md = {
            GetEntityObject: vi.fn().mockResolvedValue(minuteEntity),
        } as Partial<IMetadataProvider> as IMetadataProvider;

        const service = new MinuteArtifactBridgeService();

        // Cross-artifact mismatch must fail without saving
        vi.spyOn(RunView, 'FromMetadataProvider').mockReturnValue({
            RunView: vi.fn().mockResolvedValue({
                Success: true,
                Results: [makeVersion(VERSION_ID_OTHER, ARTIFACT_ID_2, 1, '# Wrong artifact')],
            }),
        } as Partial<RunView> as RunView);

        const mismatch = await service.PinApprovedMinuteVersion(
            { MinuteID: MINUTE_ID_1, ArtifactVersionID: VERSION_ID_OTHER, MarkApproved: true },
            undefined,
            md
        );
        expect(mismatch.Success).toBe(false);
        expect(mismatch.ErrorMessage).toContain('does not belong');
        expect(minuteEntity.Save).not.toHaveBeenCalled();

        // Matching version pins cleanly and marks Approved
        vi.spyOn(RunView, 'FromMetadataProvider').mockReturnValue({
            RunView: vi.fn().mockResolvedValue({
                Success: true,
                Results: [makeVersion(VERSION_ID_2, ARTIFACT_ID_1, 2, '# Final approved v2')],
            }),
        } as Partial<RunView> as RunView);

        const ok = await service.PinApprovedMinuteVersion(
            {
                MinuteID: MINUTE_ID_1,
                ArtifactVersionID: VERSION_ID_2,
                MarkApproved: true,
                ApprovedByMeetingID: MEETING_ID,
            },
            undefined,
            md
        );

        expect(ok.Success).toBe(true);
        expect(ok.ApprovedArtifactVersionID).toBe(VERSION_ID_2);
        expect(ok.VersionNumber).toBe(2);
        expect(minuteEntity.ApprovedArtifactVersionID).toBe(VERSION_ID_2);
        expect(minuteEntity.ApprovalStatus).toBe('Approved');
        expect(minuteEntity.ApprovedByMeetingID).toBe(MEETING_ID);
        expect(minuteEntity.ApprovedAt).toBeInstanceOf(Date);
    });

    it('rejects pinning when Minute.MJArtifactID is null', async () => {
        const minuteEntity = createFakeEntity({
            ID: MINUTE_ID_1,
            MJArtifactID: null,
            ApprovedArtifactVersionID: null,
        });
        const md = {
            GetEntityObject: vi.fn().mockResolvedValue(minuteEntity),
        } as Partial<IMetadataProvider> as IMetadataProvider;

        const service = new MinuteArtifactBridgeService();
        const res = await service.PinApprovedMinuteVersion({ MinuteID: MINUTE_ID_1 }, undefined, md);

        expect(res.Success).toBe(false);
        expect(res.ErrorMessage).toContain('without MJArtifactID');
    });
});
