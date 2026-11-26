import { CommonModule } from '@angular/common';
import {
    ChangeDetectionStrategy,
    Component,
    EventEmitter,
    HostListener,
    Input,
    OnChanges,
    Output,
    SimpleChanges,
    inject,
    ChangeDetectorRef,
} from '@angular/core';
import { Metadata, UserInfo } from '@memberjunction/core';
import { ArtifactsModule } from '@memberjunction/ng-artifacts';
import type { ResolvedCommitteeArtifact } from '@mj-biz-apps/committees-core';
import {
    BuildCommitteeArtifactDisplayState,
    CommitteeArtifactDisplayState,
} from '../minutes/minute-dual-read.model';
import { OpenExternalUrl } from '../shared/open-external-url';

/**
 * Dual-mode preview surface for `Committees: Artifacts`.
 *
 * - Native MJ Docs (`MJArtifactID` populated): mounts `<mj-artifact-viewer-panel>` inline
 *   or in a slide-over drawer.
 * - External URL artifacts (`MJArtifactID` null): renders provider metadata and opens the
 *   validated http(s) URL via `OpenExternalUrl`.
 */
@Component({
    standalone: true,
    selector: 'committees-artifact-preview',
    imports: [CommonModule, ArtifactsModule],
    templateUrl: './committee-artifact-preview.component.html',
    styleUrls: ['./committee-artifact-preview.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class CommitteeArtifactPreviewComponent implements OnChanges {
    @Input() Artifact: ResolvedCommitteeArtifact | null = null;
    @Input() Mode: 'drawer' | 'inline' = 'drawer';
    @Input() CurrentUser: UserInfo | null = null;
    @Input() EnvironmentId = '';

    @Output() Closed = new EventEmitter<void>();

    DisplayState: CommitteeArtifactDisplayState | null = null;

    private readonly cdr = inject(ChangeDetectorRef);

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

    get CanMountLivePanel(): boolean {
        return Boolean(
            this.DisplayState?.CanPreviewInlineMJDoc &&
            this.DisplayState.MJArtifactID &&
            this.EffectiveCurrentUser
        );
    }

    ngOnChanges(changes: SimpleChanges): void {
        if (changes['Artifact']) {
            this.DisplayState = this.Artifact
                ? BuildCommitteeArtifactDisplayState(this.Artifact)
                : null;
            this.cdr.markForCheck();
        }
    }

    @HostListener('document:keydown.escape')
    OnEscapeKey(): void {
        if (this.Mode === 'drawer' && this.Artifact) {
            this.OnClose();
        }
    }

    OnClose(): void {
        this.Closed.emit();
    }

    OnOpenExternalUrl(): void {
        OpenExternalUrl(this.DisplayState?.ExternalURL);
    }
}
