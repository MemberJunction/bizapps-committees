import { UserInfoEngine } from '@memberjunction/core-entities';
import type {
    CommitteeArtifactProvider,
    MinuteApprovalStatus,
    MinuteMissingReason,
    ResolvedCommitteeArtifact,
    ResolvedMinuteDocument,
} from '@mj-biz-apps/committees-core';

export const MINUTE_VIEWER_SHOW_TABS_SETTING_KEY = 'mj.committees.minuteViewer.showTabs';
export const MEMBER_HOME_VIEW_MODE_SETTING_KEY = 'mj.committees.memberHome.viewMode';

export type MinuteDualReadViewMode =
    | 'mj-doc-pinned'
    | 'mj-doc-latest'
    | 'mj-doc-missing'
    | 'legacy-content'
    | 'empty';

export type MinuteBadgeTone = 'success' | 'info' | 'warning' | 'neutral';

/** View-model projection driving `<committees-minute-document-viewer>`. */
export interface MinuteDualReadViewState {
    Mode: MinuteDualReadViewMode;
    Resolved: ResolvedMinuteDocument | null;
    MinuteID: string | null;
    ApprovalStatus: MinuteApprovalStatus | null;
    ArtifactID: string | null;
    ArtifactName: string | null;
    PinnedVersionID: string | null;
    ArtifactVersionID: string | null;
    /** Passed directly to `<mj-artifact-viewer-panel [VersionNumber]="...">`. */
    VersionNumber: number | undefined;
    IsPinnedApprovedVersion: boolean;
    VersionBadgeLabel: string | null;
    VersionBadgeTone: MinuteBadgeTone;
    CanRenderMJArtifactPanel: boolean;
    CanEditInPanel: boolean;
    CanPinVersion: boolean;
    ShowLegacyFallback: boolean;
    ShowBridgeToMJDocAction: boolean;
    MissingReason: MinuteMissingReason | null;
    MissingHeadline: string | null;
    MissingDetail: string | null;
    PlainExcerpt: string;
}

/** View-model projection distinguishing native MJ Docs from external URL Committee Artifacts. */
export interface CommitteeArtifactDisplayState {
    Kind: 'mj-doc' | 'external-url';
    CommitteeArtifactID: string;
    Name: string;
    Description: string | null;
    Provider: CommitteeArtifactProvider;
    SourceBadgeLabel: string;
    SourceBadgeTone: MinuteBadgeTone;
    CanPreviewInlineMJDoc: boolean;
    MJArtifactID: string | null;
    LatestVersionNumber: number | undefined;
    ExternalURL: string | null;
    IsArtifactMissing: boolean;
    MissingWarning: string | null;
    PlainSummary: string;
}

interface MissingCopy {
    headline: string;
    detail: string;
}

const MISSING_REASON_COPY: Record<MinuteMissingReason, MissingCopy> = {
    'artifact-not-found': {
        headline: 'Linked MJ Doc is unavailable',
        detail: 'The linked MJ Artifact could not be loaded or is not accessible to your account.',
    },
    'pinned-version-not-found': {
        headline: 'Pinned approved version not found',
        detail: 'ApprovedArtifactVersionID points to an artifact version that could not be resolved.',
    },
    'pinned-version-artifact-mismatch': {
        headline: 'Pinned version mismatch detected',
        detail: 'ApprovedArtifactVersionID does not belong to the linked MJ Artifact. Contact an administrator to repair the pin.',
    },
    'orphaned-pinned-version': {
        headline: 'Orphaned approved version link',
        detail: 'ApprovedArtifactVersionID is populated while MJArtifactID is empty.',
    },
};

/**
 * Strips raw Markdown syntax (`###`, `**`, fences, links, list markers) so feed cards,
 * excerpts, and offline summaries never leak unformatted Markdown tokens.
 */
export function StripMarkdownToPlainText(
    markdown: string | null | undefined,
    maxLength = 360
): string {
    if (!markdown) {
        return '';
    }
    const stripped = markdown
        .replace(/```[\s\S]*?```/g, ' ')
        .replace(/`([^`]+)`/g, '$1')
        .replace(/!\[([^\]]*)\]\([^)]*\)/g, '$1')
        .replace(/\[([^\]]+)\]\([^)]*\)/g, '$1')
        .replace(/^#{1,6}\s+/gm, '')
        .replace(/^\s*[-*+>]\s+/gm, '')
        .replace(/(\*\*|__|\*|_)(.*?)\1/g, '$2')
        .replace(/\r?\n+/g, ' ')
        .replace(/\s+/g, ' ')
        .trim();

    if (maxLength <= 0 || stripped.length <= maxLength) {
        return stripped;
    }
    return `${stripped.slice(0, Math.max(0, maxLength - 1)).trimEnd()}…`;
}

/** Validates that a record-supplied external URL is an absolute http(s) URL. */
export function NormalizeSafeExternalUrl(url: string | null | undefined): string | null {
    if (!url) {
        return null;
    }
    try {
        const parsed = new URL(url.trim());
        if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') {
            return null;
        }
        return parsed.href;
    } catch {
        return null;
    }
}

/**
 * Pure builder mapping a `ResolvedMinuteDocument` into UI bindings for
 * `<committees-minute-document-viewer>` and `<mj-artifact-viewer-panel>`.
 */
export function BuildMinuteDualReadViewState(
    resolved: ResolvedMinuteDocument | null,
    canEdit: boolean,
    isBridging = false
): MinuteDualReadViewState {
    if (!resolved) {
        return {
            Mode: 'empty',
            Resolved: null,
            MinuteID: null,
            ApprovalStatus: null,
            ArtifactID: null,
            ArtifactName: null,
            PinnedVersionID: null,
            ArtifactVersionID: null,
            VersionNumber: undefined,
            IsPinnedApprovedVersion: false,
            VersionBadgeLabel: null,
            VersionBadgeTone: 'neutral',
            CanRenderMJArtifactPanel: false,
            CanEditInPanel: false,
            CanPinVersion: false,
            ShowLegacyFallback: false,
            ShowBridgeToMJDocAction: false,
            MissingReason: null,
            MissingHeadline: null,
            MissingDetail: null,
            PlainExcerpt: '',
        };
    }

    switch (resolved.Kind) {
        case 'mj-doc-pinned':
            return {
                Mode: 'mj-doc-pinned',
                Resolved: resolved,
                MinuteID: resolved.MinuteID,
                ApprovalStatus: resolved.ApprovalStatus,
                ArtifactID: resolved.MJArtifactID,
                ArtifactName: resolved.Artifact.Name,
                PinnedVersionID: resolved.ArtifactVersionID,
                ArtifactVersionID: resolved.ArtifactVersionID,
                VersionNumber: resolved.VersionNumber,
                IsPinnedApprovedVersion: true,
                VersionBadgeLabel: `Pinned Approved v${resolved.VersionNumber}`,
                VersionBadgeTone: 'success',
                CanRenderMJArtifactPanel: true,
                CanEditInPanel: false,
                CanPinVersion: false,
                ShowLegacyFallback: false,
                ShowBridgeToMJDocAction: false,
                MissingReason: null,
                MissingHeadline: null,
                MissingDetail: null,
                PlainExcerpt: StripMarkdownToPlainText(resolved.Content ?? resolved.LegacyContent),
            };

        case 'mj-doc-latest': {
            const isApproved = resolved.ApprovalStatus === 'Approved';
            const versionNumber = resolved.VersionNumber ?? undefined;
            return {
                Mode: 'mj-doc-latest',
                Resolved: resolved,
                MinuteID: resolved.MinuteID,
                ApprovalStatus: resolved.ApprovalStatus,
                ArtifactID: resolved.MJArtifactID,
                ArtifactName: resolved.Artifact.Name,
                PinnedVersionID: null,
                ArtifactVersionID: resolved.ArtifactVersionID,
                VersionNumber: versionNumber,
                IsPinnedApprovedVersion: false,
                VersionBadgeLabel: versionNumber != null ? `Live Draft v${versionNumber}` : 'Live MJ Doc',
                VersionBadgeTone: 'info',
                CanRenderMJArtifactPanel: true,
                CanEditInPanel: canEdit && !isApproved,
                CanPinVersion: canEdit && resolved.ArtifactVersionID !== null,
                ShowLegacyFallback: false,
                ShowBridgeToMJDocAction: false,
                MissingReason: null,
                MissingHeadline: null,
                MissingDetail: null,
                PlainExcerpt: StripMarkdownToPlainText(resolved.Content ?? resolved.LegacyContent),
            };
        }

        case 'mj-doc-missing': {
            const copy = MISSING_REASON_COPY[resolved.MissingReason];
            return {
                Mode: 'mj-doc-missing',
                Resolved: resolved,
                MinuteID: resolved.MinuteID,
                ApprovalStatus: resolved.ApprovalStatus,
                ArtifactID: resolved.MJArtifactID,
                ArtifactName: resolved.Artifact?.Name ?? null,
                PinnedVersionID: resolved.ApprovedArtifactVersionID,
                ArtifactVersionID: null,
                VersionNumber: undefined,
                IsPinnedApprovedVersion: false,
                VersionBadgeLabel: 'MJ Doc Unavailable',
                VersionBadgeTone: 'warning',
                CanRenderMJArtifactPanel: false,
                CanEditInPanel: false,
                CanPinVersion: false,
                ShowLegacyFallback: resolved.HasLegacyContent,
                ShowBridgeToMJDocAction: false,
                MissingReason: resolved.MissingReason,
                MissingHeadline: copy.headline,
                MissingDetail: copy.detail,
                PlainExcerpt: StripMarkdownToPlainText(resolved.LegacyContent),
            };
        }

        case 'legacy-content':
            return {
                Mode: 'legacy-content',
                Resolved: resolved,
                MinuteID: resolved.MinuteID,
                ApprovalStatus: resolved.ApprovalStatus,
                ArtifactID: null,
                ArtifactName: null,
                PinnedVersionID: null,
                ArtifactVersionID: null,
                VersionNumber: undefined,
                IsPinnedApprovedVersion: false,
                VersionBadgeLabel: 'Legacy Minutes',
                VersionBadgeTone: 'neutral',
                CanRenderMJArtifactPanel: false,
                CanEditInPanel: false,
                CanPinVersion: false,
                ShowLegacyFallback: true,
                ShowBridgeToMJDocAction: canEdit && resolved.CanBridgeToMJDoc && !isBridging,
                MissingReason: null,
                MissingHeadline: null,
                MissingDetail: null,
                PlainExcerpt: StripMarkdownToPlainText(resolved.Content),
            };
    }
}

/**
 * Pure builder mapping a `ResolvedCommitteeArtifact` into UI display metadata
 * distinguishing native MJ Docs (`MJArtifactID`) from external URL links.
 */
export function BuildCommitteeArtifactDisplayState(
    resolved: ResolvedCommitteeArtifact
): CommitteeArtifactDisplayState {
    if (resolved.Kind === 'mj-doc') {
        const versionNum = resolved.LatestVersion?.VersionNumber;
        return {
            Kind: 'mj-doc',
            CommitteeArtifactID: resolved.CommitteeArtifactID,
            Name: resolved.Name || resolved.Artifact?.Name || 'MJ Document',
            Description: resolved.Description ?? resolved.Artifact?.Description ?? null,
            Provider: resolved.Provider,
            SourceBadgeLabel: versionNum != null ? `MJ Doc · v${versionNum}` : 'MJ Doc',
            SourceBadgeTone: resolved.IsArtifactMissing ? 'warning' : 'info',
            CanPreviewInlineMJDoc: !resolved.IsArtifactMissing,
            MJArtifactID: resolved.MJArtifactID,
            LatestVersionNumber: versionNum,
            ExternalURL: NormalizeSafeExternalUrl(resolved.ExternalURL),
            IsArtifactMissing: resolved.IsArtifactMissing,
            MissingWarning: resolved.IsArtifactMissing
                ? 'The linked MJ Artifact could not be loaded or is not accessible.'
                : null,
            PlainSummary: StripMarkdownToPlainText(
                resolved.LatestVersion?.Content ?? resolved.Description ?? resolved.Artifact?.Description
            ),
        };
    }

    return {
        Kind: 'external-url',
        CommitteeArtifactID: resolved.CommitteeArtifactID,
        Name: resolved.Name,
        Description: resolved.Description,
        Provider: resolved.Provider,
        SourceBadgeLabel: resolved.Provider || 'External Link',
        SourceBadgeTone: 'neutral',
        CanPreviewInlineMJDoc: false,
        MJArtifactID: null,
        LatestVersionNumber: undefined,
        ExternalURL: NormalizeSafeExternalUrl(resolved.URL),
        IsArtifactMissing: false,
        MissingWarning: null,
        PlainSummary: StripMarkdownToPlainText(resolved.Description),
    };
}

/** Reads a boolean user preference via `UserInfoEngine.Instance`. */
export function ReadUserBooleanPreference(settingKey: string, defaultValue: boolean): boolean {
    try {
        const raw = UserInfoEngine.Instance.GetSetting(settingKey);
        if (raw === 'true') return true;
        if (raw === 'false') return false;
        return defaultValue;
    } catch {
        return defaultValue;
    }
}

/** Persists a boolean user preference via `UserInfoEngine.Instance`. */
export function WriteUserBooleanPreference(settingKey: string, value: boolean): void {
    try {
        UserInfoEngine.Instance.SetSettingDebounced(settingKey, String(value));
    } catch {
        // Non-fatal in offline/unit contexts without initialized UserInfoEngine
    }
}

/** Reads a string user preference via `UserInfoEngine.Instance`. */
export function ReadUserStringPreference<T extends string>(
    settingKey: string,
    allowedValues: ReadonlyArray<T>,
    defaultValue: T
): T {
    try {
        const raw = UserInfoEngine.Instance.GetSetting(settingKey);
        if (raw && (allowedValues as ReadonlyArray<string>).includes(raw)) {
            return raw as T;
        }
        return defaultValue;
    } catch {
        return defaultValue;
    }
}

/** Persists a string user preference via `UserInfoEngine.Instance`. */
export function WriteUserStringPreference(settingKey: string, value: string): void {
    try {
        UserInfoEngine.Instance.SetSettingDebounced(settingKey, value);
    } catch {
        // Non-fatal in offline/unit contexts without initialized UserInfoEngine
    }
}
