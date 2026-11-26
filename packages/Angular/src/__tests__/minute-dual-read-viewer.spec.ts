import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { beforeEach, describe, expect, it, vi } from 'vitest';
import { UserInfoEngine } from '@memberjunction/core-entities';
import {
    ArtifactBundleMap,
    CommitteeArtifactBridgeInput,
    MJArtifactSummaryRow,
    MJArtifactVersionSummaryRow,
    MinuteArtifactBridgeService,
    MinuteDualReadInput,
} from '@mj-biz-apps/committees-core';
import {
    BuildCommitteeArtifactDisplayState,
    BuildMinuteDualReadViewState,
    MEMBER_HOME_VIEW_MODE_SETTING_KEY,
    MINUTE_VIEWER_SHOW_TABS_SETTING_KEY,
    NormalizeSafeExternalUrl,
    ReadUserBooleanPreference,
    ReadUserStringPreference,
    StripMarkdownToPlainText,
    WriteUserBooleanPreference,
    WriteUserStringPreference,
} from '../lib/minutes/minute-dual-read.model';

const ARTIFACT_ID = '11111111-1111-4111-8111-111111111111';
const OTHER_ARTIFACT_ID = '22222222-2222-4222-8222-222222222222';
const VERSION_1_ID = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1';
const VERSION_2_ID = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa2';
const OTHER_VERSION_ID = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbb1';
const MINUTE_ID = 'cccccccc-cccc-4ccc-8ccc-ccccccccccc1';
const MEETING_ID = 'dddddddd-dddd-4ddd-8ddd-ddddddddddd1';
const COMMITTEE_ARTIFACT_ID = 'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee1';
const ARTIFACT_TYPE_ID = 'ffffffff-ffff-4fff-8fff-fffffffffff1';

function makeBundle(): ArtifactBundleMap {
    const artifact: MJArtifactSummaryRow = {
        ID: ARTIFACT_ID,
        Name: 'Q4 Audit Committee Minutes',
        Description: 'Official board minutes document',
        TypeID: ARTIFACT_TYPE_ID,
        Type: 'Markdown',
        Visibility: 'Always',
        __mj_CreatedAt: '2026-11-01T10:00:00Z',
        __mj_UpdatedAt: '2026-11-15T10:00:00Z',
    };

    const v1: MJArtifactVersionSummaryRow = {
        ID: VERSION_1_ID,
        ArtifactID: ARTIFACT_ID,
        VersionNumber: 1,
        Name: 'v1 Approved',
        Description: 'Approved by motion 2026-11',
        Content: '## Call to Order\n**Quorum confirmed** at 9:00 AM.',
        ContentMode: 'Text',
        MimeType: 'text/markdown',
        FileName: 'minutes-v1.md',
        __mj_CreatedAt: '2026-11-01T10:00:00Z',
        __mj_UpdatedAt: '2026-11-01T10:00:00Z',
    };

    const v2: MJArtifactVersionSummaryRow = {
        ID: VERSION_2_ID,
        ArtifactID: ARTIFACT_ID,
        VersionNumber: 2,
        Name: 'v2 Post-Approval Edit',
        Description: 'Unapproved addendum',
        Content: '## Call to Order\nUpdated draft notes after approval.',
        ContentMode: 'Text',
        MimeType: 'text/markdown',
        FileName: 'minutes-v2.md',
        __mj_CreatedAt: '2026-11-15T10:00:00Z',
        __mj_UpdatedAt: '2026-11-15T10:00:00Z',
    };

    const foreignVersion: MJArtifactVersionSummaryRow = {
        ID: OTHER_VERSION_ID,
        ArtifactID: OTHER_ARTIFACT_ID,
        VersionNumber: 1,
        Name: 'Foreign doc v1',
        Description: null,
        Content: 'Belongs to another artifact',
        ContentMode: 'Text',
        MimeType: 'text/markdown',
        FileName: null,
        __mj_CreatedAt: '2026-11-02T10:00:00Z',
        __mj_UpdatedAt: '2026-11-02T10:00:00Z',
    };

    return {
        ArtifactsById: new Map([[ARTIFACT_ID.toLowerCase(), artifact]]),
        VersionsByArtifactId: new Map([[ARTIFACT_ID.toLowerCase(), [v2, v1]]]),
        VersionsById: new Map([
            [VERSION_1_ID.toLowerCase(), v1],
            [VERSION_2_ID.toLowerCase(), v2],
            [OTHER_VERSION_ID.toLowerCase(), foreignVersion],
        ]),
        Errors: [],
    };
}

describe('Minute dual-read viewer model & <mj-artifact-viewer-panel> bindings', () => {
    beforeEach(() => {
        vi.restoreAllMocks();
    });

    it('pins ApprovedArtifactVersionID immutably (read-only) even when newer versions exist', () => {
        const minute: MinuteDualReadInput = {
            ID: MINUTE_ID,
            MeetingID: MEETING_ID,
            Content: 'Legacy fallback text',
            ApprovalStatus: 'Approved',
            ApprovedAt: '2026-11-05T15:00:00Z',
            ApprovedByMeetingID: null,
            MJArtifactID: ARTIFACT_ID,
            ApprovedArtifactVersionID: VERSION_1_ID,
        };

        const resolved = MinuteArtifactBridgeService.ResolveMinuteDocument(minute, makeBundle());
        const state = BuildMinuteDualReadViewState(resolved, true);

        expect(state.Mode).toBe('mj-doc-pinned');
        expect(state.CanRenderMJArtifactPanel).toBe(true);
        expect(state.ArtifactID).toBe(ARTIFACT_ID);
        expect(state.PinnedVersionID).toBe(VERSION_1_ID);
        expect(state.VersionNumber).toBe(1);
        expect(state.IsPinnedApprovedVersion).toBe(true);
        expect(state.VersionBadgeLabel).toBe('Pinned Approved v1');
        expect(state.VersionBadgeTone).toBe('success');
        expect(state.CanEditInPanel).toBe(false);
        expect(state.CanPinVersion).toBe(false);
        expect(state.ShowLegacyFallback).toBe(false);
        expect(state.ShowBridgeToMJDocAction).toBe(false);
        expect(state.PlainExcerpt).toBe('Call to Order Quorum confirmed at 9:00 AM.');
        expect(state.PlainExcerpt).not.toContain('##');
        expect(state.PlainExcerpt).not.toContain('**');
    });

    it('renders unpinned MJ-Docs-backed draft on latest version with edit & pin actions for officers', () => {
        const minute: MinuteDualReadInput = {
            ID: MINUTE_ID,
            MeetingID: MEETING_ID,
            Content: null,
            ApprovalStatus: 'Draft',
            ApprovedAt: null,
            ApprovedByMeetingID: null,
            MJArtifactID: ARTIFACT_ID,
            ApprovedArtifactVersionID: null,
        };

        const resolved = MinuteArtifactBridgeService.ResolveMinuteDocument(minute, makeBundle());
        const officerState = BuildMinuteDualReadViewState(resolved, true);
        const memberState = BuildMinuteDualReadViewState(resolved, false);

        expect(officerState.Mode).toBe('mj-doc-latest');
        expect(officerState.CanRenderMJArtifactPanel).toBe(true);
        expect(officerState.VersionNumber).toBe(2);
        expect(officerState.IsPinnedApprovedVersion).toBe(false);
        expect(officerState.VersionBadgeLabel).toBe('Live Draft v2');
        expect(officerState.VersionBadgeTone).toBe('info');
        expect(officerState.CanEditInPanel).toBe(true);
        expect(officerState.CanPinVersion).toBe(true);

        expect(memberState.CanEditInPanel).toBe(false);
        expect(memberState.CanPinVersion).toBe(false);
    });

    it('renders legacy Minute.Content with opt-in Bridge to MJ Docs action when MJArtifactID is null', () => {
        const minute: MinuteDualReadInput = {
            ID: MINUTE_ID,
            MeetingID: MEETING_ID,
            Content: '## Attendance\nAll voting members present.',
            ApprovalStatus: 'Draft',
            ApprovedAt: null,
            ApprovedByMeetingID: null,
            MJArtifactID: null,
            ApprovedArtifactVersionID: null,
        };

        const resolved = MinuteArtifactBridgeService.ResolveMinuteDocument(minute, makeBundle());
        const editableState = BuildMinuteDualReadViewState(resolved, true, false);
        const bridgingState = BuildMinuteDualReadViewState(resolved, true, true);
        const readOnlyState = BuildMinuteDualReadViewState(resolved, false, false);

        expect(editableState.Mode).toBe('legacy-content');
        expect(editableState.CanRenderMJArtifactPanel).toBe(false);
        expect(editableState.ShowLegacyFallback).toBe(true);
        expect(editableState.ShowBridgeToMJDocAction).toBe(true);
        expect(editableState.VersionBadgeLabel).toBe('Legacy Minutes');

        // Double-click guard while bridging is in flight
        expect(bridgingState.ShowBridgeToMJDocAction).toBe(false);
        // Non-editors cannot trigger bridge mutation
        expect(readOnlyState.ShowBridgeToMJDocAction).toBe(false);
    });

    it('surfaces clear diagnostics and preserved legacy fallback for all missing/mismatch states', () => {
        const bundle = makeBundle();

        const artifactNotFound = MinuteArtifactBridgeService.ResolveMinuteDocument({
            ID: MINUTE_ID,
            MeetingID: MEETING_ID,
            Content: 'Preserved legacy minutes text',
            ApprovalStatus: 'PendingApproval',
            ApprovedAt: null,
            ApprovedByMeetingID: null,
            MJArtifactID: OTHER_ARTIFACT_ID,
            ApprovedArtifactVersionID: null,
        }, bundle);
        const notFoundState = BuildMinuteDualReadViewState(artifactNotFound, true);
        expect(notFoundState.Mode).toBe('mj-doc-missing');
        expect(notFoundState.MissingReason).toBe('artifact-not-found');
        expect(notFoundState.CanRenderMJArtifactPanel).toBe(false);
        expect(notFoundState.ShowLegacyFallback).toBe(true);
        expect(notFoundState.MissingHeadline).toContain('unavailable');

        const mismatch = MinuteArtifactBridgeService.ResolveMinuteDocument({
            ID: MINUTE_ID,
            MeetingID: MEETING_ID,
            Content: null,
            ApprovalStatus: 'Approved',
            ApprovedAt: '2026-11-05T15:00:00Z',
            ApprovedByMeetingID: null,
            MJArtifactID: ARTIFACT_ID,
            ApprovedArtifactVersionID: OTHER_VERSION_ID,
        }, bundle);
        const mismatchState = BuildMinuteDualReadViewState(mismatch, true);
        expect(mismatchState.Mode).toBe('mj-doc-missing');
        expect(mismatchState.MissingReason).toBe('pinned-version-artifact-mismatch');
        expect(mismatchState.ShowLegacyFallback).toBe(false);
        expect(mismatchState.MissingDetail).toContain('does not belong');

        const orphaned = MinuteArtifactBridgeService.ResolveMinuteDocument({
            ID: MINUTE_ID,
            MeetingID: MEETING_ID,
            Content: 'Old content',
            ApprovalStatus: 'Approved',
            ApprovedAt: null,
            ApprovedByMeetingID: null,
            MJArtifactID: null,
            ApprovedArtifactVersionID: VERSION_1_ID,
        }, bundle);
        const orphanedState = BuildMinuteDualReadViewState(orphaned, true);
        expect(orphanedState.Mode).toBe('mj-doc-missing');
        expect(orphanedState.MissingReason).toBe('orphaned-pinned-version');
        expect(orphanedState.ShowLegacyFallback).toBe(true);
    });

    it('returns safe empty state when resolved minute is null', () => {
        const state = BuildMinuteDualReadViewState(null, true);
        expect(state.Mode).toBe('empty');
        expect(state.CanRenderMJArtifactPanel).toBe(false);
        expect(state.ShowBridgeToMJDocAction).toBe(false);
        expect(state.VersionNumber).toBeUndefined();
    });
});

describe('Committees.Artifact external URL vs native MJ Docs display switching', () => {
    it('classifies MJArtifactID-backed records for inline <mj-artifact-viewer-panel> preview', () => {
        const input: CommitteeArtifactBridgeInput = {
            ID: COMMITTEE_ARTIFACT_ID,
            Name: 'Committee Charter',
            Description: '### Governance Charter\n**Approved** annually.',
            CommitteeID: null,
            MeetingID: MEETING_ID,
            AgendaItemID: null,
            TaskID: null,
            ArtifactTypeID: ARTIFACT_TYPE_ID,
            Provider: 'Other',
            ExternalID: null,
            URL: '',
            MimeType: 'text/markdown',
            FileSize: null,
            MJArtifactID: ARTIFACT_ID,
        };

        const resolved = MinuteArtifactBridgeService.ClassifyCommitteeArtifact(input, makeBundle());
        const display = BuildCommitteeArtifactDisplayState(resolved);

        expect(display.Kind).toBe('mj-doc');
        expect(display.CanPreviewInlineMJDoc).toBe(true);
        expect(display.MJArtifactID).toBe(ARTIFACT_ID);
        expect(display.LatestVersionNumber).toBe(2);
        expect(display.SourceBadgeLabel).toBe('MJ Doc · v2');
        expect(display.SourceBadgeTone).toBe('info');
        expect(display.IsArtifactMissing).toBe(false);
        expect(display.PlainSummary).not.toContain('###');
    });

    it('flags inaccessible MJ Docs artifact cleanly without crashing', () => {
        const input: CommitteeArtifactBridgeInput = {
            ID: COMMITTEE_ARTIFACT_ID,
            Name: 'Restricted Board Packet',
            Description: null,
            CommitteeID: null,
            MeetingID: MEETING_ID,
            AgendaItemID: null,
            TaskID: null,
            ArtifactTypeID: ARTIFACT_TYPE_ID,
            Provider: 'Other',
            ExternalID: null,
            URL: '',
            MimeType: null,
            FileSize: null,
            MJArtifactID: OTHER_ARTIFACT_ID,
        };

        const resolved = MinuteArtifactBridgeService.ClassifyCommitteeArtifact(input, makeBundle());
        const display = BuildCommitteeArtifactDisplayState(resolved);

        expect(display.Kind).toBe('mj-doc');
        expect(display.CanPreviewInlineMJDoc).toBe(false);
        expect(display.IsArtifactMissing).toBe(true);
        expect(display.SourceBadgeTone).toBe('warning');
        expect(display.MissingWarning).toContain('could not be loaded');
    });

    it('preserves external URL links identically and blocks non-http(s) XSS schemes', () => {
        const external: CommitteeArtifactBridgeInput = {
            ID: COMMITTEE_ARTIFACT_ID,
            Name: 'SharePoint Slide Deck',
            Description: 'Board review slides',
            CommitteeID: null,
            MeetingID: MEETING_ID,
            AgendaItemID: null,
            TaskID: null,
            ArtifactTypeID: ARTIFACT_TYPE_ID,
            Provider: 'SharePoint',
            ExternalID: 'sp-123',
            URL: 'https://contoso.sharepoint.com/sites/board/deck.pptx',
            MimeType: 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
            FileSize: 102400,
            MJArtifactID: null,
        };

        const resolved = MinuteArtifactBridgeService.ClassifyCommitteeArtifact(external, makeBundle());
        const display = BuildCommitteeArtifactDisplayState(resolved);

        expect(display.Kind).toBe('external-url');
        expect(display.CanPreviewInlineMJDoc).toBe(false);
        expect(display.MJArtifactID).toBeNull();
        expect(display.SourceBadgeLabel).toBe('SharePoint');
        expect(display.ExternalURL).toBe('https://contoso.sharepoint.com/sites/board/deck.pptx');

        expect(NormalizeSafeExternalUrl('javascript:alert(1)')).toBeNull();
        expect(NormalizeSafeExternalUrl('data:text/html,<script>x</script>')).toBeNull();
    });
});

describe('Markdown stripping, UserInfoEngine preferences & viewer template wiring', () => {
    it('strips headings, bold, code fences, and links without leaking raw Markdown syntax', () => {
        const raw = [
            '### Motion 1',
            '**Approved** unanimously — see [Budget Report](https://example.com/budget).',
            '```sql',
            'SELECT 1;',
            '```',
            '- Item one',
        ].join('\n');

        const plain = StripMarkdownToPlainText(raw, 200);
        expect(plain).toBe('Motion 1 Approved unanimously — see Budget Report. Item one');
        expect(plain).not.toMatch(/###|\*\*|```|\[.*\]\(.*\)/);
    });

    it('persists viewer preferences via UserInfoEngine.Instance (never localStorage)', () => {
        const store = new Map<string, string>();
        const getSpy = vi.spyOn(UserInfoEngine.Instance, 'GetSetting').mockImplementation((key) => store.get(key));
        const setSpy = vi.spyOn(UserInfoEngine.Instance, 'SetSettingDebounced').mockImplementation((key, value) => {
            store.set(key, value);
        });

        expect(ReadUserBooleanPreference(MINUTE_VIEWER_SHOW_TABS_SETTING_KEY, false)).toBe(false);
        WriteUserBooleanPreference(MINUTE_VIEWER_SHOW_TABS_SETTING_KEY, true);
        expect(ReadUserBooleanPreference(MINUTE_VIEWER_SHOW_TABS_SETTING_KEY, false)).toBe(true);

        expect(ReadUserStringPreference(MEMBER_HOME_VIEW_MODE_SETTING_KEY, ['home', 'dashboard'] as const, 'home')).toBe('home');
        WriteUserStringPreference(MEMBER_HOME_VIEW_MODE_SETTING_KEY, 'dashboard');
        expect(ReadUserStringPreference(MEMBER_HOME_VIEW_MODE_SETTING_KEY, ['home', 'dashboard'] as const, 'home')).toBe('dashboard');

        expect(getSpy).toHaveBeenCalled();
        expect(setSpy).toHaveBeenCalledWith(MINUTE_VIEWER_SHOW_TABS_SETTING_KEY, 'true');
        expect(setSpy).toHaveBeenCalledWith(MEMBER_HOME_VIEW_MODE_SETTING_KEY, 'dashboard');
    });

    it('wires <mj-artifact-viewer-panel> with [artifactId] and [VersionNumber] in viewer templates', () => {
        const minuteHtml = readFileSync(
            resolve(__dirname, '../lib/minutes/minute-document-viewer.component.html'),
            'utf8'
        );
        const artifactHtml = readFileSync(
            resolve(__dirname, '../lib/documents/committee-artifact-preview.component.html'),
            'utf8'
        );
        expect(minuteHtml).toContain('<mj-artifact-viewer-panel');
        expect(minuteHtml).toContain('[artifactId]="ViewState.ArtifactID"');
        expect(minuteHtml).toContain('[VersionNumber]="ViewState.VersionNumber"');
        expect(minuteHtml).toContain('Bridge to MJ Docs');

        expect(artifactHtml).toContain('<mj-artifact-viewer-panel');
        expect(artifactHtml).toContain('[artifactId]="state.MJArtifactID"');
        expect(artifactHtml).toContain('[VersionNumber]="state.LatestVersionNumber"');
    });
});
