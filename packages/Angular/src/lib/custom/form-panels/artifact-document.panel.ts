import { CommonModule } from '@angular/common';
import { ChangeDetectionStrategy, ChangeDetectorRef, Component, OnInit, inject } from '@angular/core';
import { RegisterClassEx } from '@memberjunction/global';
import { BaseFormPanel } from '@memberjunction/ng-base-forms';
import { mjBizAppsCommitteesArtifactEntity } from '@mj-biz-apps/committees-entities';
import {
    CommitteeArtifactBridgeInput,
    MinuteArtifactBridgeService,
    ResolvedCommitteeArtifact,
} from '@mj-biz-apps/committees-core';
import { CommitteeArtifactPreviewComponent } from '../../documents/committee-artifact-preview.component';

/**
 * Form panel mounting `<committees-artifact-preview Mode="inline">` inside the generated
 * `Committees: Artifacts` host form (`slot: 'after-fields'`).
 * Never replaces `@RegisterClass(BaseFormComponent, 'Committees: Artifacts')`.
 */
@RegisterClassEx(BaseFormPanel, {
    key: 'form-panel:Artifacts:mj-doc',
    metadata: {
        entity: 'Committees: Artifacts',
        slot: 'after-fields',
        sortKey: 10,
    },
})
@Component({
    selector: 'committees-artifact-document-form-panel',
    standalone: true,
    imports: [CommonModule, CommitteeArtifactPreviewComponent],
    changeDetection: ChangeDetectionStrategy.OnPush,
    template: `
        @if (ResolvedArtifact; as resolved) {
            <section class="cadp-section" aria-label="Committee artifact preview">
                <committees-artifact-preview
                    [Artifact]="resolved"
                    Mode="inline"
                ></committees-artifact-preview>
            </section>
        }
    `,
    styles: [`
        :host {
            display: block;
            width: 100%;
            margin-top: var(--mj-space-4, 16px);
        }
        .cadp-section {
            display: block;
        }
    `],
})
export class ArtifactDocumentFormPanel extends BaseFormPanel<mjBizAppsCommitteesArtifactEntity> implements OnInit {
    public ResolvedArtifact: ResolvedCommitteeArtifact | null = null;

    private readonly cdr = inject(ChangeDetectorRef);
    private readonly bridgeService = new MinuteArtifactBridgeService();

    public ngOnInit(): void {
        void this.loadResolvedArtifact();
    }

    private async loadResolvedArtifact(): Promise<void> {
        const record = this.Record;
        if (!record || !record.IsSaved) {
            this.ResolvedArtifact = null;
            this.cdr.markForCheck();
            return;
        }
        const input: CommitteeArtifactBridgeInput = {
            ID: record.ID,
            Name: record.Name,
            Description: record.Description,
            CommitteeID: record.CommitteeID,
            MeetingID: record.MeetingID,
            AgendaItemID: record.AgendaItemID,
            TaskID: record.TaskID,
            ArtifactTypeID: record.ArtifactTypeID,
            Provider: record.Provider,
            ExternalID: record.ExternalID,
            URL: record.URL,
            MimeType: record.MimeType,
            FileSize: record.FileSize,
            MJArtifactID: record.MJArtifactID,
        };
        const [resolved] = await this.bridgeService.LoadAndResolveCommitteeArtifacts([input]);
        this.ResolvedArtifact = resolved ?? null;
        this.cdr.markForCheck();
    }
}
