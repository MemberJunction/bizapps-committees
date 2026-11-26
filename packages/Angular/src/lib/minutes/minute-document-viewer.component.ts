import { CommonModule } from '@angular/common';
import {
    ChangeDetectionStrategy,
    ChangeDetectorRef,
    Component,
    EventEmitter,
    Input,
    OnChanges,
    OnDestroy,
    OnInit,
    Output,
    SecurityContext,
    SimpleChanges,
    inject,
} from '@angular/core';
import { DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { Metadata, UserInfo } from '@memberjunction/core';
import { ArtifactsModule, ArtifactVersionSavedEvent } from '@memberjunction/ng-artifacts';
import {
    BridgeLegacyMinuteResult,
    MinuteArtifactBridgeService,
    MinuteDualReadInput,
    PinApprovedMinuteVersionResult,
    ResolvedMinuteDocument,
} from '@mj-biz-apps/committees-core';
import { marked } from 'marked';
import {
    BuildMinuteDualReadViewState,
    MINUTE_VIEWER_SHOW_TABS_SETTING_KEY,
    MinuteDualReadViewState,
    ReadUserBooleanPreference,
    WriteUserBooleanPreference,
} from './minute-dual-read.model';

/**
 * Dual-read viewer for `Committees: Minutes`.
 *
 * - When `Minute.MJArtifactID` is populated: renders the linked MJ Doc through
 *   `<mj-artifact-viewer-panel>` from `@memberjunction/ng-artifacts`, strictly honoring
 *   `Minute.ApprovedArtifactVersionID` pinning when set (read-only pinned badge vs live draft).
 * - When `Minute.MJArtifactID` is null: cleanly renders legacy `Minute.Content` (or projected
 *   section-review content via `[minuteLegacyBody]`) with an opt-in "Bridge to MJ Docs" action
 *   that invokes `MinuteArtifactBridgeService` while leaving `Minute.Content` intact.
 */
@Component({
    standalone: true,
    selector: 'committees-minute-document-viewer',
    imports: [CommonModule, ArtifactsModule],
    templateUrl: './minute-document-viewer.component.html',
    styleUrls: ['./minute-document-viewer.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class MinuteDocumentViewerComponent implements OnInit, OnChanges, OnDestroy {
    @Input() Minute: MinuteDualReadInput | null = null;
    @Input() ResolvedMinute: ResolvedMinuteDocument | null = null;
    @Input() MeetingTitle = '';
    @Input() CanEdit = false;
    @Input() CurrentUser: UserInfo | null = null;
    @Input() EnvironmentId = '';
    /** When true, projects host legacy section editor (`[minuteLegacyBody]`) in legacy mode. */
    @Input() UseProjectedLegacyBody = false;

    @Output() MinuteBridged = new EventEmitter<BridgeLegacyMinuteResult>();
    @Output() VersionPinned = new EventEmitter<PinApprovedMinuteVersionResult>();
    @Output() VersionSaved = new EventEmitter<ArtifactVersionSavedEvent>();

    IsResolving = false;
    IsBridging = false;
    IsPinning = false;
    ShowViewerTabs = false;
    ActionError = '';
    ActionNotice = '';
    ViewState: MinuteDualReadViewState = BuildMinuteDualReadViewState(null, false);

    private readonly cdr = inject(ChangeDetectorRef);
    private readonly sanitizer = inject(DomSanitizer);
    private readonly bridgeService = new MinuteArtifactBridgeService();
    private loadToken = 0;
    private isDestroyed = false;

    get EffectiveCurrentUser(): UserInfo | null {
        if (this.CurrentUser) {
            return this.CurrentUser;
        }
        try {
            return Metadata.Provider?.CurrentUser ?? null;
        } catch {
            return null;
        }
    }

    get CanMountLiveArtifactPanel(): boolean {
        return Boolean(
            this.ViewState.CanRenderMJArtifactPanel &&
            this.ViewState.ArtifactID &&
            this.EffectiveCurrentUser
        );
    }

    get RenderedLegacyHtml(): SafeHtml {
        const raw = this.ViewState.Resolved?.LegacyContent ?? this.Minute?.Content ?? '';
        if (!raw.trim()) {
            return '';
        }
        const html = marked.parse(raw) as string;
        const safe = this.sanitizer.sanitize(SecurityContext.HTML, html) ?? '';
        return this.sanitizer.bypassSecurityTrustHtml(safe);
    }

    ngOnInit(): void {
        this.ShowViewerTabs = ReadUserBooleanPreference(MINUTE_VIEWER_SHOW_TABS_SETTING_KEY, false);
        this.syncFromInputs();
    }

    ngOnChanges(changes: SimpleChanges): void {
        if (changes['Minute'] || changes['ResolvedMinute'] || changes['CanEdit']) {
            this.syncFromInputs();
        }
    }

    ngOnDestroy(): void {
        this.isDestroyed = true;
        this.loadToken++;
    }

    OnToggleViewerTabs(): void {
        this.ShowViewerTabs = !this.ShowViewerTabs;
        WriteUserBooleanPreference(MINUTE_VIEWER_SHOW_TABS_SETTING_KEY, this.ShowViewerTabs);
        this.cdr.markForCheck();
    }

    async OnBridgeToMJDoc(): Promise<void> {
        if (!this.Minute || this.IsBridging || this.Minute.MJArtifactID) {
            return;
        }
        this.IsBridging = true;
        this.ActionError = '';
        this.ActionNotice = '';
        this.updateViewState(this.ViewState.Resolved);
        this.cdr.markForCheck();

        try {
            const artifactName = this.MeetingTitle
                ? `Minutes — ${this.MeetingTitle}`
                : 'Meeting Minutes';
            const result = await this.bridgeService.BridgeLegacyMinuteToMJDoc({
                MinuteID: this.Minute.ID,
                ArtifactName: artifactName,
                PinAsApprovedVersion: this.Minute.ApprovalStatus === 'Approved',
            });
            if (this.isDestroyed) return;
            if (!result.Success) {
                this.ActionError = result.ErrorMessage ?? 'Unable to bridge minutes to MJ Docs.';
            } else {
                this.ActionNotice = result.PinnedApprovedVersionID
                    ? 'Bridged to MJ Docs and pinned approved version. Legacy content preserved.'
                    : 'Bridged to MJ Docs. Legacy content preserved.';
                const updatedMinute: MinuteDualReadInput = {
                    ...this.Minute,
                    MJArtifactID: result.MJArtifactID,
                    ApprovedArtifactVersionID: result.PinnedApprovedVersionID ?? this.Minute.ApprovedArtifactVersionID,
                };
                this.Minute = updatedMinute;
                await this.resolveMinute(updatedMinute);
                this.MinuteBridged.emit(result);
            }
        } catch (error) {
            this.ActionError = error instanceof Error ? error.message : 'Unable to bridge minutes to MJ Docs.';
        } finally {
            this.IsBridging = false;
            this.updateViewState(this.ViewState.Resolved);
            this.cdr.markForCheck();
        }
    }

    async OnPinCurrentVersion(): Promise<void> {
        if (!this.Minute || this.IsPinning || !this.ViewState.ArtifactVersionID) {
            return;
        }
        this.IsPinning = true;
        this.ActionError = '';
        this.ActionNotice = '';
        this.cdr.markForCheck();

        try {
            const result = await this.bridgeService.PinApprovedMinuteVersion({
                MinuteID: this.Minute.ID,
                ArtifactVersionID: this.ViewState.ArtifactVersionID,
            });
            if (this.isDestroyed) return;
            if (!result.Success) {
                this.ActionError = result.ErrorMessage ?? 'Unable to pin approved artifact version.';
            } else {
                this.ActionNotice = result.VersionNumber != null
                    ? `Pinned approved version v${result.VersionNumber}.`
                    : 'Pinned approved artifact version.';
                const updatedMinute: MinuteDualReadInput = {
                    ...this.Minute,
                    ApprovedArtifactVersionID: result.ApprovedArtifactVersionID,
                };
                this.Minute = updatedMinute;
                await this.resolveMinute(updatedMinute);
                this.VersionPinned.emit(result);
            }
        } catch (error) {
            this.ActionError = error instanceof Error ? error.message : 'Unable to pin approved artifact version.';
        } finally {
            this.IsPinning = false;
            this.cdr.markForCheck();
        }
    }

    OnPanelVersionSaved(event: ArtifactVersionSavedEvent): void {
        this.VersionSaved.emit(event);
        if (this.Minute) {
            void this.resolveMinute(this.Minute);
        }
    }

    private syncFromInputs(): void {
        this.ActionError = '';
        if (this.ResolvedMinute) {
            this.IsResolving = false;
            this.updateViewState(this.ResolvedMinute);
            this.cdr.markForCheck();
            return;
        }
        if (!this.Minute) {
            this.IsResolving = false;
            this.updateViewState(null);
            this.cdr.markForCheck();
            return;
        }
        if (!this.Minute.MJArtifactID && !this.Minute.ApprovedArtifactVersionID) {
            this.IsResolving = false;
            const legacyResolved = MinuteArtifactBridgeService.ResolveMinuteDocument(this.Minute, {
                ArtifactsById: new Map(),
                VersionsByArtifactId: new Map(),
                VersionsById: new Map(),
                Errors: [],
            });
            this.updateViewState(legacyResolved);
            this.cdr.markForCheck();
            return;
        }
        void this.resolveMinute(this.Minute);
    }

    private async resolveMinute(minute: MinuteDualReadInput): Promise<void> {
        const token = ++this.loadToken;
        this.IsResolving = true;
        this.cdr.markForCheck();
        try {
            const [resolved] = await this.bridgeService.LoadAndResolveMinutes([minute]);
            if (this.isDestroyed || token !== this.loadToken) {
                return;
            }
            this.updateViewState(resolved ?? null);
        } catch (error) {
            if (this.isDestroyed || token !== this.loadToken) {
                return;
            }
            this.ActionError = error instanceof Error ? error.message : 'Failed to load linked MJ Doc.';
            this.updateViewState(null);
        } finally {
            if (!this.isDestroyed && token === this.loadToken) {
                this.IsResolving = false;
                this.cdr.markForCheck();
            }
        }
    }

    private updateViewState(resolved: ResolvedMinuteDocument | null): void {
        this.ViewState = BuildMinuteDualReadViewState(resolved, this.CanEdit, this.IsBridging);
    }
}
