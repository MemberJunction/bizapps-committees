import {
    IMetadataProvider,
    Metadata,
    RunView,
    RunViewParams,
    RunViewResult,
    TransactionGroupBase,
    UserInfo,
} from '@memberjunction/core';
import type {
    MJArtifactEntity,
    MJArtifactVersionEntity,
} from '@memberjunction/core-entities';
import type {
    mjBizAppsCommitteesArtifactEntity,
    mjBizAppsCommitteesMinuteEntity,
} from '@mj-biz-apps/committees-entities';

const UUID_PATTERN = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
const IN_CLAUSE_CHUNK_SIZE = 400;

const ARTIFACT_SUMMARY_FIELDS: string[] = [
    'ID',
    'Name',
    'Description',
    'TypeID',
    'Type',
    'Visibility',
    '__mj_CreatedAt',
    '__mj_UpdatedAt',
];

const ARTIFACT_VERSION_SUMMARY_FIELDS: string[] = [
    'ID',
    'ArtifactID',
    'VersionNumber',
    'Name',
    'Description',
    'Content',
    'ContentMode',
    'MimeType',
    'FileName',
    '__mj_CreatedAt',
    '__mj_UpdatedAt',
];

/** Derived from generated entity so CHECK-constraint updates flow through CodeGen. */
export type MinuteApprovalStatus = mjBizAppsCommitteesMinuteEntity['ApprovalStatus'];

/** Derived from generated entity so CHECK-constraint updates flow through CodeGen. */
export type CommitteeArtifactProvider = mjBizAppsCommitteesArtifactEntity['Provider'];

/** Derived from MJ: Artifacts so Visibility values stay synchronized with core. */
export type MJArtifactVisibility = MJArtifactEntity['Visibility'];

/** Derived from MJ: Artifact Versions so ContentMode values stay synchronized with core. */
export type MJArtifactVersionContentMode = MJArtifactVersionEntity['ContentMode'];

/** Read-only projection of an MJ: Artifacts row loaded via ResultType: 'simple'. */
export interface MJArtifactSummaryRow {
    ID: string;
    Name: string;
    Description: string | null;
    TypeID: string;
    Type: string | null;
    Visibility: MJArtifactVisibility;
    __mj_CreatedAt: Date | string;
    __mj_UpdatedAt: Date | string;
}

/** Read-only projection of an MJ: Artifact Versions row loaded via ResultType: 'simple'. */
export interface MJArtifactVersionSummaryRow {
    ID: string;
    ArtifactID: string;
    VersionNumber: number;
    Name: string | null;
    Description: string | null;
    Content: string | null;
    ContentMode: MJArtifactVersionContentMode;
    MimeType: string | null;
    FileName: string | null;
    __mj_CreatedAt: Date | string;
    __mj_UpdatedAt: Date | string;
}

/** Projection accepted by Minute dual-read resolvers (works with entities or simple rows). */
export interface MinuteDualReadInput {
    ID: string;
    MeetingID: string | null;
    Content: string | null;
    ApprovalStatus: MinuteApprovalStatus;
    ApprovedAt: Date | string | null;
    ApprovedByMeetingID: string | null;
    MJArtifactID: string | null;
    ApprovedArtifactVersionID: string | null;
}

/** Projection accepted by Committees.Artifact bridge resolvers (entities or simple rows). */
export interface CommitteeArtifactBridgeInput {
    ID: string;
    Name: string;
    Description: string | null;
    CommitteeID: string | null;
    MeetingID: string | null;
    AgendaItemID: string | null;
    TaskID: string | null;
    ArtifactTypeID: string;
    Provider: CommitteeArtifactProvider;
    ExternalID: string | null;
    URL: string;
    MimeType: string | null;
    FileSize: number | null;
    MJArtifactID: string | null;
}

/** Batched lookup maps populated by a single RunViews call. */
export interface ArtifactBundleMap {
    ArtifactsById: Map<string, MJArtifactSummaryRow>;
    VersionsByArtifactId: Map<string, MJArtifactVersionSummaryRow[]>;
    VersionsById: Map<string, MJArtifactVersionSummaryRow>;
    Errors: string[];
}

export type MinuteMissingReason =
    | 'artifact-not-found'
    | 'pinned-version-not-found'
    | 'pinned-version-artifact-mismatch'
    | 'orphaned-pinned-version';

/** Minute backed by MJ Docs and immutably pinned to ApprovedArtifactVersionID. */
export interface ResolvedMinuteMJDocPinned {
    Kind: 'mj-doc-pinned';
    Source: 'mj-doc';
    MinuteID: string;
    MeetingID: string | null;
    ApprovalStatus: MinuteApprovalStatus;
    MJArtifactID: string;
    Artifact: MJArtifactSummaryRow;
    ArtifactVersionID: string;
    Version: MJArtifactVersionSummaryRow;
    VersionNumber: number;
    IsPinnedApprovedVersion: true;
    Content: string | null;
    ContentMode: MJArtifactVersionContentMode;
    LegacyContent: string | null;
    HasLegacyContent: boolean;
}

/** Minute backed by MJ Docs floating on the latest version (unpinned draft/review). */
export interface ResolvedMinuteMJDocLatest {
    Kind: 'mj-doc-latest';
    Source: 'mj-doc';
    MinuteID: string;
    MeetingID: string | null;
    ApprovalStatus: MinuteApprovalStatus;
    MJArtifactID: string;
    Artifact: MJArtifactSummaryRow;
    ArtifactVersionID: string | null;
    Version: MJArtifactVersionSummaryRow | null;
    VersionNumber: number | null;
    IsPinnedApprovedVersion: false;
    Content: string | null;
    ContentMode: MJArtifactVersionContentMode | null;
    LegacyContent: string | null;
    HasLegacyContent: boolean;
}

/** Minute with an MJ Docs link whose artifact or pinned version is missing/inconsistent. */
export interface ResolvedMinuteMJDocMissing {
    Kind: 'mj-doc-missing';
    Source: 'mj-doc';
    MinuteID: string;
    MeetingID: string | null;
    ApprovalStatus: MinuteApprovalStatus;
    MJArtifactID: string | null;
    ApprovedArtifactVersionID: string | null;
    Artifact: MJArtifactSummaryRow | null;
    MissingReason: MinuteMissingReason;
    LegacyContent: string | null;
    HasLegacyContent: boolean;
}

/** Legacy Minute (MJArtifactID IS NULL) backed by Committees.Minute.Content. */
export interface ResolvedMinuteLegacyContent {
    Kind: 'legacy-content';
    Source: 'legacy';
    MinuteID: string;
    MeetingID: string | null;
    ApprovalStatus: MinuteApprovalStatus;
    MJArtifactID: null;
    Artifact: null;
    ArtifactVersionID: null;
    VersionNumber: null;
    IsPinnedApprovedVersion: false;
    Content: string | null;
    LegacyContent: string | null;
    HasLegacyContent: boolean;
    CanBridgeToMJDoc: boolean;
}

/** Discriminated union representing the resolved dual-read state of a meeting Minute. */
export type ResolvedMinuteDocument =
    | ResolvedMinuteMJDocPinned
    | ResolvedMinuteMJDocLatest
    | ResolvedMinuteMJDocMissing
    | ResolvedMinuteLegacyContent;

/** Committees.Artifact backed by a native MJ Docs artifact (MJArtifactID non-null). */
export interface ResolvedCommitteeArtifactMJDoc {
    Kind: 'mj-doc';
    CommitteeArtifactID: string;
    Name: string;
    Description: string | null;
    CommitteeID: string | null;
    MeetingID: string | null;
    AgendaItemID: string | null;
    TaskID: string | null;
    ArtifactTypeID: string;
    Provider: CommitteeArtifactProvider;
    ExternalURL: string;
    MJArtifactID: string;
    Artifact: MJArtifactSummaryRow | null;
    LatestVersion: MJArtifactVersionSummaryRow | null;
    IsArtifactMissing: boolean;
}

/** Committees.Artifact pointing to an external URL or cloud storage provider (MJArtifactID null). */
export interface ResolvedCommitteeArtifactExternalUrl {
    Kind: 'external-url';
    CommitteeArtifactID: string;
    Name: string;
    Description: string | null;
    CommitteeID: string | null;
    MeetingID: string | null;
    AgendaItemID: string | null;
    TaskID: string | null;
    ArtifactTypeID: string;
    Provider: CommitteeArtifactProvider;
    ExternalID: string | null;
    URL: string;
    MimeType: string | null;
    FileSize: number | null;
    MJArtifactID: null;
}

/** Discriminated union distinguishing native MJ Docs from external URL Committee Artifacts. */
export type ResolvedCommitteeArtifact =
    | ResolvedCommitteeArtifactMJDoc
    | ResolvedCommitteeArtifactExternalUrl;

export interface BridgeLegacyMinuteOptions {
    MinuteID: string;
    /** Optional display name for the created MJ: Artifacts record. */
    ArtifactName?: string;
    /** Optional description for the created MJ: Artifacts record. */
    ArtifactDescription?: string | null;
    /** Optional MJ: Artifact Types ID; defaults to Markdown/Document if omitted. */
    ArtifactTypeID?: string;
    /** Optional explicit owner UserID; falls back to contextUser.ID or provider CurrentUser. */
    OwnerUserID?: string;
    /** Optional override text if minute.Content is empty; legacy minute.Content is never modified. */
    FallbackContent?: string;
    /** When true (or when Minute.ApprovalStatus === 'Approved'), pins ApprovedArtifactVersionID to v1. */
    PinAsApprovedVersion?: boolean;
}

export interface BridgeLegacyMinuteResult {
    Success: boolean;
    AlreadyBridged: boolean;
    MinuteID: string;
    MJArtifactID: string | null;
    ArtifactVersionID: string | null;
    PinnedApprovedVersionID: string | null;
    PreservedLegacyContent: boolean;
    ErrorMessage?: string;
}

export interface PinApprovedMinuteVersionOptions {
    MinuteID: string;
    /** Optional specific version ID; when omitted, pins the latest version of Minute.MJArtifactID. */
    ArtifactVersionID?: string;
    /** When true, also sets ApprovalStatus='Approved' and ApprovedAt=now (if unset). */
    MarkApproved?: boolean;
    /** Optional approving meeting ID written to Minute.ApprovedByMeetingID. */
    ApprovedByMeetingID?: string | null;
}

export interface PinApprovedMinuteVersionResult {
    Success: boolean;
    MinuteID: string;
    MJArtifactID: string | null;
    ApprovedArtifactVersionID: string | null;
    VersionNumber: number | null;
    ErrorMessage?: string;
}

interface ArtifactTypeLookupRow {
    ID: string;
    Name: string;
    ContentType: string;
    IsEnabled: boolean;
}

function normalizeId(id: string | null | undefined): string | null {
    const trimmed = id?.trim() ?? '';
    return trimmed.length > 0 ? trimmed.toLowerCase() : null;
}

function assertValidUuid(id: string, label: string): string {
    const trimmed = id.trim();
    if (!UUID_PATTERN.test(trimmed)) {
        throw new Error(`Invalid ${label} UUID: '${id}'.`);
    }
    return trimmed;
}

function dedupeValidUuids(ids: ReadonlyArray<string | null | undefined>): string[] {
    const seen = new Set<string>();
    const out: string[] = [];
    for (const raw of ids) {
        const trimmed = raw?.trim() ?? '';
        if (!trimmed || !UUID_PATTERN.test(trimmed)) {
            continue;
        }
        const key = trimmed.toLowerCase();
        if (!seen.has(key)) {
            seen.add(key);
            out.push(trimmed);
        }
    }
    return out;
}

function chunkArray<T>(items: ReadonlyArray<T>, size: number): T[][] {
    const chunks: T[][] = [];
    for (let i = 0; i < items.length; i += size) {
        chunks.push(items.slice(i, i + size));
    }
    return chunks;
}

function toTimestampMs(value: Date | string): number {
    return value instanceof Date ? value.getTime() : Date.parse(value);
}

function sortVersionsDesc(versions: ReadonlyArray<MJArtifactVersionSummaryRow>): MJArtifactVersionSummaryRow[] {
    return [...versions].sort((a, b) => {
        if (b.VersionNumber !== a.VersionNumber) {
            return b.VersionNumber - a.VersionNumber;
        }
        return toTimestampMs(b.__mj_CreatedAt) - toTimestampMs(a.__mj_CreatedAt);
    });
}

function hasNonEmptyText(value: string | null | undefined): boolean {
    return (value ?? '').trim().length > 0;
}

function createEmptyBundle(): ArtifactBundleMap {
    return {
        ArtifactsById: new Map(),
        VersionsByArtifactId: new Map(),
        VersionsById: new Map(),
        Errors: [],
    };
}

function createRunView(provider?: IMetadataProvider): RunView {
    return provider ? RunView.FromMetadataProvider(provider) : new RunView();
}

function resolveMetadataProvider(provider?: IMetadataProvider): IMetadataProvider {
    return provider ?? Metadata.Provider;
}

/**
 * Dual-read, version-pinning, and opt-in MJ Docs bridge service for
 * Committees: Minutes and Committees: Artifacts.
 *
 * Design guarantees:
 * - Pure static resolvers (`ResolveMinuteDocument`, `ResolveMinutesBatch`,
 *   `ClassifyCommitteeArtifact`) require zero database calls for fast testing.
 * - All read queries collapse into a single chunked `rv.RunViews([...])` call
 *   using `ResultType: 'simple'` with explicit field lists (zero N+1 waterfalls).
 * - Opt-in legacy migration (`BridgeLegacyMinuteToMJDoc`) is idempotent, deduplicates
 *   concurrent calls per MinuteID, preserves `Minute.Content` intact, and uses
 *   `TransactionGroup` when available (with compensating rollback otherwise).
 */
export class MinuteArtifactBridgeService {
    private static readonly inFlightBridges = new Map<string, Promise<BridgeLegacyMinuteResult>>();

    /**
     * Pure dual-read resolver for a single Minute record against a preloaded artifact bundle.
     * Precedence:
     * 1. `MJArtifactID` non-null + `ApprovedArtifactVersionID` non-null -> pinned version (ownership-verified).
     * 2. `MJArtifactID` non-null + `ApprovedArtifactVersionID` null -> latest version of artifact.
     * 3. `MJArtifactID` null + `ApprovedArtifactVersionID` non-null -> `'mj-doc-missing'` (`orphaned-pinned-version`).
     * 4. `MJArtifactID` null + `ApprovedArtifactVersionID` null -> legacy `Minute.Content`.
     */
    public static ResolveMinuteDocument(
        minute: MinuteDualReadInput,
        bundle: ArtifactBundleMap
    ): ResolvedMinuteDocument {
        const artifactKey = normalizeId(minute.MJArtifactID);
        const pinnedVersionKey = normalizeId(minute.ApprovedArtifactVersionID);
        const hasLegacy = hasNonEmptyText(minute.Content);

        if (!artifactKey) {
            if (pinnedVersionKey) {
                return MinuteArtifactBridgeService.buildMissingMinute(
                    minute,
                    null,
                    'orphaned-pinned-version',
                    hasLegacy
                );
            }
            return {
                Kind: 'legacy-content',
                Source: 'legacy',
                MinuteID: minute.ID,
                MeetingID: minute.MeetingID,
                ApprovalStatus: minute.ApprovalStatus,
                MJArtifactID: null,
                Artifact: null,
                ArtifactVersionID: null,
                VersionNumber: null,
                IsPinnedApprovedVersion: false,
                Content: minute.Content,
                LegacyContent: minute.Content,
                HasLegacyContent: hasLegacy,
                CanBridgeToMJDoc: hasLegacy,
            };
        }

        const artifact = bundle.ArtifactsById.get(artifactKey) ?? null;
        if (!artifact) {
            return MinuteArtifactBridgeService.buildMissingMinute(
                minute,
                null,
                'artifact-not-found',
                hasLegacy
            );
        }

        if (pinnedVersionKey) {
            return MinuteArtifactBridgeService.resolvePinnedMinute(
                minute,
                artifact,
                pinnedVersionKey,
                bundle,
                hasLegacy
            );
        }

        const versions = sortVersionsDesc(bundle.VersionsByArtifactId.get(artifactKey) ?? []);
        const latest = versions[0] ?? null;

        return {
            Kind: 'mj-doc-latest',
            Source: 'mj-doc',
            MinuteID: minute.ID,
            MeetingID: minute.MeetingID,
            ApprovalStatus: minute.ApprovalStatus,
            MJArtifactID: artifact.ID,
            Artifact: artifact,
            ArtifactVersionID: latest?.ID ?? null,
            Version: latest,
            VersionNumber: latest?.VersionNumber ?? null,
            IsPinnedApprovedVersion: false,
            Content: latest?.Content ?? null,
            ContentMode: latest?.ContentMode ?? null,
            LegacyContent: minute.Content,
            HasLegacyContent: hasLegacy,
        };
    }

    /** Pure batch resolver for an array of Minutes using a preloaded artifact bundle. */
    public static ResolveMinutesBatch(
        minutes: ReadonlyArray<MinuteDualReadInput>,
        bundle: ArtifactBundleMap
    ): ResolvedMinuteDocument[] {
        return minutes.map((minute) => MinuteArtifactBridgeService.ResolveMinuteDocument(minute, bundle));
    }

    /**
     * Pure classifier distinguishing native MJ Docs (`MJArtifactID` non-null) from
     * external URL/cloud-provider `Committees: Artifacts` records.
     */
    public static ClassifyCommitteeArtifact(
        artifact: CommitteeArtifactBridgeInput,
        bundle?: ArtifactBundleMap
    ): ResolvedCommitteeArtifact {
        const mjArtifactKey = normalizeId(artifact.MJArtifactID);
        if (!mjArtifactKey) {
            return {
                Kind: 'external-url',
                CommitteeArtifactID: artifact.ID,
                Name: artifact.Name,
                Description: artifact.Description,
                CommitteeID: artifact.CommitteeID,
                MeetingID: artifact.MeetingID,
                AgendaItemID: artifact.AgendaItemID,
                TaskID: artifact.TaskID,
                ArtifactTypeID: artifact.ArtifactTypeID,
                Provider: artifact.Provider,
                ExternalID: artifact.ExternalID,
                URL: artifact.URL,
                MimeType: artifact.MimeType,
                FileSize: artifact.FileSize,
                MJArtifactID: null,
            };
        }

        const mjArtifact = bundle?.ArtifactsById.get(mjArtifactKey) ?? null;
        const latestVersion = sortVersionsDesc(bundle?.VersionsByArtifactId.get(mjArtifactKey) ?? [])[0] ?? null;

        return {
            Kind: 'mj-doc',
            CommitteeArtifactID: artifact.ID,
            Name: artifact.Name,
            Description: artifact.Description,
            CommitteeID: artifact.CommitteeID,
            MeetingID: artifact.MeetingID,
            AgendaItemID: artifact.AgendaItemID,
            TaskID: artifact.TaskID,
            ArtifactTypeID: artifact.ArtifactTypeID,
            Provider: artifact.Provider,
            ExternalURL: artifact.URL,
            MJArtifactID: artifact.MJArtifactID as string,
            Artifact: mjArtifact,
            LatestVersion: latestVersion,
            IsArtifactMissing: bundle != null && mjArtifact === null,
        };
    }

    /**
     * Batched loader fetching `MJ: Artifacts` and `MJ: Artifact Versions` in a single
     * chunked `rv.RunViews([...])` call with `ResultType: 'simple'`.
     */
    public async LoadArtifactBundles(
        artifactIds: ReadonlyArray<string | null | undefined>,
        pinnedVersionIds: ReadonlyArray<string | null | undefined> = [],
        contextUser?: UserInfo,
        provider?: IMetadataProvider
    ): Promise<ArtifactBundleMap> {
        const cleanArtifactIds = dedupeValidUuids(artifactIds);
        const cleanPinnedIds = dedupeValidUuids(pinnedVersionIds);
        if (cleanArtifactIds.length === 0 && cleanPinnedIds.length === 0) {
            return createEmptyBundle();
        }

        const { params, tags } = this.buildBundleQueries(cleanArtifactIds, cleanPinnedIds);
        const rv = createRunView(provider);
        const results = await rv.RunViews(params, contextUser);

        return this.assembleBundleResults(results, tags);
    }

    /** Loads artifact/version metadata in one batched `RunViews` call and resolves all minutes. */
    public async LoadAndResolveMinutes(
        minutes: ReadonlyArray<MinuteDualReadInput>,
        contextUser?: UserInfo,
        provider?: IMetadataProvider
    ): Promise<ResolvedMinuteDocument[]> {
        if (minutes.length === 0) {
            return [];
        }
        const artifactIds = minutes.map((m) => m.MJArtifactID);
        const pinnedIds = minutes.map((m) => m.ApprovedArtifactVersionID);
        const bundle = await this.LoadArtifactBundles(artifactIds, pinnedIds, contextUser, provider);
        return MinuteArtifactBridgeService.ResolveMinutesBatch(minutes, bundle);
    }

    /** Loads artifact/version metadata in one batched `RunViews` call and classifies all artifacts. */
    public async LoadAndResolveCommitteeArtifacts(
        artifacts: ReadonlyArray<CommitteeArtifactBridgeInput>,
        contextUser?: UserInfo,
        provider?: IMetadataProvider
    ): Promise<ResolvedCommitteeArtifact[]> {
        if (artifacts.length === 0) {
            return [];
        }
        const mjArtifactIds = artifacts.map((a) => a.MJArtifactID);
        const bundle = await this.LoadArtifactBundles(mjArtifactIds, [], contextUser, provider);
        return artifacts.map((item) => MinuteArtifactBridgeService.ClassifyCommitteeArtifact(item, bundle));
    }

    /**
     * Opt-in bridge creating an `MJ: Artifacts` record + initial `MJ: Artifact Versions` (v1)
     * from a legacy `Committees: Minutes` record and linking `Minute.MJArtifactID`.
     *
     * Guarantees:
     * - Legacy `Minute.Content` is NEVER cleared, overwritten, or deleted.
     * - Idempotent when `Minute.MJArtifactID` is already linked.
     * - Concurrent invocations for the same `MinuteID` share one in-flight promise.
     */
    public async BridgeLegacyMinuteToMJDoc(
        options: BridgeLegacyMinuteOptions,
        contextUser?: UserInfo,
        provider?: IMetadataProvider
    ): Promise<BridgeLegacyMinuteResult> {
        let minuteId: string;
        try {
            minuteId = assertValidUuid(options.MinuteID, 'MinuteID');
        } catch (error) {
            return this.buildBridgeFailure(
                options.MinuteID,
                error instanceof Error ? error.message : String(error)
            );
        }

        const key = minuteId.toLowerCase();
        const existing = MinuteArtifactBridgeService.inFlightBridges.get(key);
        if (existing) {
            return existing;
        }

        const task = this.executeBridgeLegacyMinute({ ...options, MinuteID: minuteId }, contextUser, provider)
            .finally(() => {
                MinuteArtifactBridgeService.inFlightBridges.delete(key);
            });
        MinuteArtifactBridgeService.inFlightBridges.set(key, task);
        return task;
    }

    /**
     * Pins `Committees: Minutes.ApprovedArtifactVersionID` to an immutable version of the
     * linked `MJArtifactID`, verifying cross-entity ownership before saving.
     */
    public async PinApprovedMinuteVersion(
        options: PinApprovedMinuteVersionOptions,
        contextUser?: UserInfo,
        provider?: IMetadataProvider
    ): Promise<PinApprovedMinuteVersionResult> {
        try {
            const minuteId = assertValidUuid(options.MinuteID, 'MinuteID');
            const explicitVersionId = options.ArtifactVersionID
                ? assertValidUuid(options.ArtifactVersionID, 'ArtifactVersionID')
                : null;
            const approvedMeetingId = options.ApprovedByMeetingID
                ? assertValidUuid(options.ApprovedByMeetingID, 'ApprovedByMeetingID')
                : null;

            const md = resolveMetadataProvider(provider);
            const minute = await md.GetEntityObject<mjBizAppsCommitteesMinuteEntity>(
                'Committees: Minutes',
                contextUser
            );
            const loaded = await minute.Load(minuteId);
            if (!loaded) {
                return this.buildPinFailure(minuteId, null, `Minute '${minuteId}' not found.`);
            }

            if (!minute.MJArtifactID) {
                return this.buildPinFailure(
                    minuteId,
                    null,
                    'Cannot pin ApprovedArtifactVersionID on a legacy minute without MJArtifactID.'
                );
            }

            const targetVersion = await this.resolveVersionForPinning(
                minute.MJArtifactID,
                explicitVersionId,
                contextUser,
                provider
            );
            if (!targetVersion.version) {
                return this.buildPinFailure(minuteId, minute.MJArtifactID, targetVersion.error);
            }

            minute.ApprovedArtifactVersionID = targetVersion.version.ID;
            if (options.MarkApproved) {
                minute.ApprovalStatus = 'Approved';
                if (!minute.ApprovedAt) {
                    minute.ApprovedAt = new Date();
                }
            }
            if (approvedMeetingId) {
                minute.ApprovedByMeetingID = approvedMeetingId;
            }

            const saved = await minute.Save();
            if (!saved) {
                return this.buildPinFailure(
                    minuteId,
                    minute.MJArtifactID,
                    minute.LatestResult?.Message ?? 'Failed to save pinned minute version.'
                );
            }

            return {
                Success: true,
                MinuteID: minute.ID,
                MJArtifactID: minute.MJArtifactID,
                ApprovedArtifactVersionID: targetVersion.version.ID,
                VersionNumber: targetVersion.version.VersionNumber,
            };
        } catch (error) {
            return this.buildPinFailure(
                options.MinuteID,
                null,
                error instanceof Error ? error.message : String(error)
            );
        }
    }

    // -------------------------------------------------------------------------
    // Private helpers
    // -------------------------------------------------------------------------

    private static resolvePinnedMinute(
        minute: MinuteDualReadInput,
        artifact: MJArtifactSummaryRow,
        pinnedVersionKey: string,
        bundle: ArtifactBundleMap,
        hasLegacy: boolean
    ): ResolvedMinuteDocument {
        const pinned = bundle.VersionsById.get(pinnedVersionKey) ?? null;
        if (!pinned) {
            return MinuteArtifactBridgeService.buildMissingMinute(
                minute,
                artifact,
                'pinned-version-not-found',
                hasLegacy
            );
        }
        if (pinned.ArtifactID.toLowerCase() !== artifact.ID.toLowerCase()) {
            return MinuteArtifactBridgeService.buildMissingMinute(
                minute,
                artifact,
                'pinned-version-artifact-mismatch',
                hasLegacy
            );
        }
        return {
            Kind: 'mj-doc-pinned',
            Source: 'mj-doc',
            MinuteID: minute.ID,
            MeetingID: minute.MeetingID,
            ApprovalStatus: minute.ApprovalStatus,
            MJArtifactID: artifact.ID,
            Artifact: artifact,
            ArtifactVersionID: pinned.ID,
            Version: pinned,
            VersionNumber: pinned.VersionNumber,
            IsPinnedApprovedVersion: true,
            Content: pinned.Content,
            ContentMode: pinned.ContentMode,
            LegacyContent: minute.Content,
            HasLegacyContent: hasLegacy,
        };
    }

    private static buildMissingMinute(
        minute: MinuteDualReadInput,
        artifact: MJArtifactSummaryRow | null,
        reason: MinuteMissingReason,
        hasLegacy: boolean
    ): ResolvedMinuteMJDocMissing {
        return {
            Kind: 'mj-doc-missing',
            Source: 'mj-doc',
            MinuteID: minute.ID,
            MeetingID: minute.MeetingID,
            ApprovalStatus: minute.ApprovalStatus,
            MJArtifactID: minute.MJArtifactID,
            ApprovedArtifactVersionID: minute.ApprovedArtifactVersionID,
            Artifact: artifact,
            MissingReason: reason,
            LegacyContent: minute.Content,
            HasLegacyContent: hasLegacy,
        };
    }

    private buildBundleQueries(
        artifactIds: string[],
        pinnedIds: string[]
    ): { params: RunViewParams[]; tags: Array<'artifact' | 'version'> } {
        const params: RunViewParams[] = [];
        const tags: Array<'artifact' | 'version'> = [];

        for (const chunk of chunkArray(artifactIds, IN_CLAUSE_CHUNK_SIZE)) {
            const list = chunk.map((id) => `'${id}'`).join(',');
            params.push({
                EntityName: 'MJ: Artifacts',
                ExtraFilter: `ID IN (${list})`,
                Fields: ARTIFACT_SUMMARY_FIELDS,
                ResultType: 'simple',
            });
            tags.push('artifact');

            params.push({
                EntityName: 'MJ: Artifact Versions',
                ExtraFilter: `ArtifactID IN (${list})`,
                OrderBy: 'VersionNumber DESC, __mj_CreatedAt DESC',
                Fields: ARTIFACT_VERSION_SUMMARY_FIELDS,
                ResultType: 'simple',
            });
            tags.push('version');
        }

        for (const chunk of chunkArray(pinnedIds, IN_CLAUSE_CHUNK_SIZE)) {
            const list = chunk.map((id) => `'${id}'`).join(',');
            params.push({
                EntityName: 'MJ: Artifact Versions',
                ExtraFilter: `ID IN (${list})`,
                Fields: ARTIFACT_VERSION_SUMMARY_FIELDS,
                ResultType: 'simple',
            });
            tags.push('version');
        }

        return { params, tags };
    }

    private assembleBundleResults(
        results: RunViewResult<MJArtifactSummaryRow | MJArtifactVersionSummaryRow>[],
        tags: Array<'artifact' | 'version'>
    ): ArtifactBundleMap {
        const bundle = createEmptyBundle();
        for (let i = 0; i < results.length; i++) {
            const res = results[i];
            const tag = tags[i];
            if (!res.Success) {
                bundle.Errors.push(res.ErrorMessage ?? `Failed loading ${tag} batch ${i}`);
                continue;
            }
            if (tag === 'artifact') {
                for (const row of res.Results) {
                    if (!('VersionNumber' in row)) {
                        bundle.ArtifactsById.set(row.ID.toLowerCase(), row);
                    }
                }
            } else {
                const versionRows: MJArtifactVersionSummaryRow[] = [];
                for (const row of res.Results) {
                    if ('VersionNumber' in row) {
                        versionRows.push(row);
                    }
                }
                this.indexVersionRows(versionRows, bundle);
            }
        }
        return bundle;
    }

    private indexVersionRows(
        rows: ReadonlyArray<MJArtifactVersionSummaryRow>,
        bundle: ArtifactBundleMap
    ): void {
        for (const row of rows) {
            const versionKey = row.ID.toLowerCase();
            if (bundle.VersionsById.has(versionKey)) {
                continue;
            }
            bundle.VersionsById.set(versionKey, row);
            const artifactKey = row.ArtifactID.toLowerCase();
            const list = bundle.VersionsByArtifactId.get(artifactKey) ?? [];
            list.push(row);
            bundle.VersionsByArtifactId.set(artifactKey, list);
        }
    }

    private async executeBridgeLegacyMinute(
        options: BridgeLegacyMinuteOptions,
        contextUser?: UserInfo,
        provider?: IMetadataProvider
    ): Promise<BridgeLegacyMinuteResult> {
        try {
            const md = resolveMetadataProvider(provider);
            const minute = await md.GetEntityObject<mjBizAppsCommitteesMinuteEntity>(
                'Committees: Minutes',
                contextUser
            );
            const loaded = await minute.Load(options.MinuteID);
            if (!loaded) {
                return this.buildBridgeFailure(options.MinuteID, `Minute '${options.MinuteID}' not found.`);
            }

            if (minute.MJArtifactID) {
                return {
                    Success: true,
                    AlreadyBridged: true,
                    MinuteID: minute.ID,
                    MJArtifactID: minute.MJArtifactID,
                    ArtifactVersionID: minute.ApprovedArtifactVersionID,
                    PinnedApprovedVersionID: minute.ApprovedArtifactVersionID,
                    PreservedLegacyContent: true,
                };
            }

            const contentToSeed = minute.Content ?? options.FallbackContent ?? '';
            const ownerUserId = this.resolveOwnerUserId(options.OwnerUserID, contextUser, md);
            if (!ownerUserId) {
                return this.buildBridgeFailure(
                    minute.ID,
                    'Unable to resolve owner UserID for MJ: Artifacts creation.'
                );
            }

            const artifactTypeId = await this.resolveDefaultArtifactTypeId(
                options.ArtifactTypeID,
                contextUser,
                provider
            );
            if (!artifactTypeId) {
                return this.buildBridgeFailure(
                    minute.ID,
                    'Unable to resolve an enabled MJ: Artifact Types record.'
                );
            }

            return await this.persistBridgedArtifactAndMinute(
                {
                    md,
                    minute,
                    contentToSeed,
                    artifactTypeId,
                    ownerUserId,
                    artifactName: options.ArtifactName ?? this.buildDefaultArtifactName(minute),
                    artifactDescription: options.ArtifactDescription ?? 'Bridged from Committees: Minutes legacy content.',
                    shouldPinApproved: Boolean(options.PinAsApprovedVersion || minute.ApprovalStatus === 'Approved'),
                },
                contextUser
            );
        } catch (error) {
            return this.buildBridgeFailure(
                options.MinuteID,
                error instanceof Error ? error.message : String(error)
            );
        }
    }

    private async persistBridgedArtifactAndMinute(
        params: {
            md: IMetadataProvider;
            minute: mjBizAppsCommitteesMinuteEntity;
            contentToSeed: string;
            artifactTypeId: string;
            ownerUserId: string;
            artifactName: string;
            artifactDescription: string | null;
            shouldPinApproved: boolean;
        },
        contextUser?: UserInfo
    ): Promise<BridgeLegacyMinuteResult> {
        const { md, minute, contentToSeed, artifactTypeId, ownerUserId, artifactName, artifactDescription, shouldPinApproved } = params;

        const artifact = await md.GetEntityObject<MJArtifactEntity>('MJ: Artifacts', contextUser);
        artifact.NewRecord();
        artifact.Name = artifactName;
        artifact.Description = artifactDescription;
        artifact.TypeID = artifactTypeId;
        artifact.UserID = ownerUserId;
        artifact.Visibility = 'Always';

        const version = await md.GetEntityObject<MJArtifactVersionEntity>('MJ: Artifact Versions', contextUser);
        version.NewRecord();
        version.VersionNumber = 1;
        version.Name = artifactName;
        version.Description = artifactDescription;
        version.Content = contentToSeed;
        version.ContentMode = 'Text';
        version.UserID = ownerUserId;

        const txGroup = await this.tryCreateTransactionGroup(md);
        if (txGroup && artifact.ID && version.ID) {
            return this.commitBridgeTransactionGroup(txGroup, artifact, version, minute, shouldPinApproved);
        }

        return this.commitBridgeSequentialWithRollback(artifact, version, minute, shouldPinApproved);
    }

    private async tryCreateTransactionGroup(md: IMetadataProvider): Promise<TransactionGroupBase | null> {
        if (typeof md.CreateTransactionGroup !== 'function') {
            return null;
        }
        try {
            const tx = await md.CreateTransactionGroup();
            return tx && typeof tx.Submit === 'function' ? tx : null;
        } catch {
            return null;
        }
    }

    private async commitBridgeTransactionGroup(
        txGroup: TransactionGroupBase,
        artifact: MJArtifactEntity,
        version: MJArtifactVersionEntity,
        minute: mjBizAppsCommitteesMinuteEntity,
        shouldPinApproved: boolean
    ): Promise<BridgeLegacyMinuteResult> {
        version.ArtifactID = artifact.ID;
        minute.MJArtifactID = artifact.ID;
        if (shouldPinApproved) {
            minute.ApprovedArtifactVersionID = version.ID;
        }

        artifact.TransactionGroup = txGroup;
        version.TransactionGroup = txGroup;
        minute.TransactionGroup = txGroup;

        await artifact.Save();
        await version.Save();
        await minute.Save();

        const submitted = await txGroup.Submit();
        if (!submitted) {
            return this.buildBridgeFailure(
                minute.ID,
                minute.LatestResult?.Message ?? 'TransactionGroup failed while bridging minute to MJ Docs.'
            );
        }

        return {
            Success: true,
            AlreadyBridged: false,
            MinuteID: minute.ID,
            MJArtifactID: artifact.ID,
            ArtifactVersionID: version.ID,
            PinnedApprovedVersionID: shouldPinApproved ? version.ID : null,
            PreservedLegacyContent: true,
        };
    }

    private async commitBridgeSequentialWithRollback(
        artifact: MJArtifactEntity,
        version: MJArtifactVersionEntity,
        minute: mjBizAppsCommitteesMinuteEntity,
        shouldPinApproved: boolean
    ): Promise<BridgeLegacyMinuteResult> {
        const artifactSaved = await artifact.Save();
        if (!artifactSaved) {
            return this.buildBridgeFailure(
                minute.ID,
                artifact.LatestResult?.Message ?? 'Failed to save MJ: Artifacts record.'
            );
        }

        version.ArtifactID = artifact.ID;
        const versionSaved = await version.Save();
        if (!versionSaved) {
            await this.safeDeleteEntity(artifact);
            return this.buildBridgeFailure(
                minute.ID,
                version.LatestResult?.Message ?? 'Failed to save initial MJ: Artifact Versions record.'
            );
        }

        minute.MJArtifactID = artifact.ID;
        if (shouldPinApproved) {
            minute.ApprovedArtifactVersionID = version.ID;
        }

        const minuteSaved = await minute.Save();
        if (!minuteSaved) {
            await this.safeDeleteEntity(version);
            await this.safeDeleteEntity(artifact);
            return this.buildBridgeFailure(
                minute.ID,
                minute.LatestResult?.Message ?? 'Failed to link MJArtifactID on Committees: Minutes.'
            );
        }

        return {
            Success: true,
            AlreadyBridged: false,
            MinuteID: minute.ID,
            MJArtifactID: artifact.ID,
            ArtifactVersionID: version.ID,
            PinnedApprovedVersionID: shouldPinApproved ? version.ID : null,
            PreservedLegacyContent: true,
        };
    }

    private async safeDeleteEntity(entity: { Delete: () => Promise<boolean> }): Promise<void> {
        try {
            await entity.Delete();
        } catch {
            // Best-effort compensating cleanup when TransactionGroup is unavailable.
        }
    }

    private resolveOwnerUserId(
        explicitOwnerId: string | undefined,
        contextUser: UserInfo | undefined,
        md: IMetadataProvider
    ): string | null {
        const candidate = explicitOwnerId ?? contextUser?.ID ?? md.CurrentUser?.ID ?? '';
        const trimmed = candidate.trim();
        return trimmed.length > 0 ? trimmed : null;
    }

    private buildDefaultArtifactName(minute: mjBizAppsCommitteesMinuteEntity): string {
        const meetingLabel = minute.Meeting?.trim();
        return meetingLabel ? `${meetingLabel} — Minutes` : `Meeting Minutes (${minute.ID.slice(0, 8)})`;
    }

    private async resolveDefaultArtifactTypeId(
        explicitTypeId: string | undefined,
        contextUser?: UserInfo,
        provider?: IMetadataProvider
    ): Promise<string | null> {
        if (explicitTypeId) {
            return assertValidUuid(explicitTypeId, 'ArtifactTypeID');
        }
        const rv = createRunView(provider);
        const result = await rv.RunView<ArtifactTypeLookupRow>(
            {
                EntityName: 'MJ: Artifact Types',
                Fields: ['ID', 'Name', 'ContentType', 'IsEnabled'],
                ResultType: 'simple',
            },
            contextUser
        );
        if (!result.Success || result.Results.length === 0) {
            return null;
        }
        const enabled = result.Results.filter((t) => Boolean(t.IsEnabled));
        if (enabled.length === 0) {
            return null;
        }
        const preferred =
            enabled.find((t) => t.Name.toLowerCase() === 'markdown') ??
            enabled.find((t) => t.ContentType.toLowerCase().includes('markdown')) ??
            enabled.find((t) => t.Name.toLowerCase() === 'document') ??
            enabled[0];
        return preferred?.ID ?? null;
    }

    private async resolveVersionForPinning(
        mjArtifactId: string,
        explicitVersionId: string | null,
        contextUser?: UserInfo,
        provider?: IMetadataProvider
    ): Promise<{ version: MJArtifactVersionSummaryRow | null; error: string }> {
        const validArtifactId = assertValidUuid(mjArtifactId, 'MJArtifactID');
        const rv = createRunView(provider);
        const filter = explicitVersionId
            ? `ID='${explicitVersionId}'`
            : `ArtifactID='${validArtifactId}'`;
        const res = await rv.RunView<MJArtifactVersionSummaryRow>(
            {
                EntityName: 'MJ: Artifact Versions',
                ExtraFilter: filter,
                OrderBy: 'VersionNumber DESC, __mj_CreatedAt DESC',
                Fields: ARTIFACT_VERSION_SUMMARY_FIELDS,
                MaxRows: 1,
                ResultType: 'simple',
            },
            contextUser
        );

        if (!res.Success) {
            return {
                version: null,
                error: res.ErrorMessage ?? 'Failed to query MJ: Artifact Versions.',
            };
        }
        const version = res.Results[0] ?? null;
        if (!version) {
            return {
                version: null,
                error: explicitVersionId
                    ? `Artifact version '${explicitVersionId}' not found.`
                    : `No versions found for MJ Artifact '${validArtifactId}'.`,
            };
        }
        if (version.ArtifactID.toLowerCase() !== validArtifactId.toLowerCase()) {
            return {
                version: null,
                error: `Artifact version '${version.ID}' does not belong to MJ Artifact '${validArtifactId}'.`,
            };
        }
        return { version, error: '' };
    }

    private buildBridgeFailure(minuteId: string, message: string): BridgeLegacyMinuteResult {
        return {
            Success: false,
            AlreadyBridged: false,
            MinuteID: minuteId,
            MJArtifactID: null,
            ArtifactVersionID: null,
            PinnedApprovedVersionID: null,
            PreservedLegacyContent: true,
            ErrorMessage: message,
        };
    }

    private buildPinFailure(
        minuteId: string,
        mjArtifactId: string | null,
        message: string
    ): PinApprovedMinuteVersionResult {
        return {
            Success: false,
            MinuteID: minuteId,
            MJArtifactID: mjArtifactId,
            ApprovedArtifactVersionID: null,
            VersionNumber: null,
            ErrorMessage: message,
        };
    }
}
