import { CommonModule } from '@angular/common';
import { ChangeDetectionStrategy, ChangeDetectorRef, Component, inject } from '@angular/core';
import { RegisterClassEx } from '@memberjunction/global';
import { BaseFormPanel } from '@memberjunction/ng-base-forms';
import { mjBizAppsCommitteesMinuteEntity } from '@mj-biz-apps/committees-entities';
import type {
    BridgeLegacyMinuteResult,
    MinuteDualReadInput,
    PinApprovedMinuteVersionResult,
} from '@mj-biz-apps/committees-core';
import { MinuteDocumentViewerComponent } from '../../minutes/minute-document-viewer.component';

/**
 * Form panel mounting the dual-read `<committees-minute-document-viewer>` inside the
 * generated `Committees: Minutes` host form (`slot: 'after-fields'`).
 * Never replaces `@RegisterClass(BaseFormComponent, 'Committees: Minutes')`.
 */
@RegisterClassEx(BaseFormPanel, {
    key: 'form-panel:Minutes:mj-doc',
    metadata: {
        entity: 'Committees: Minutes',
        slot: 'after-fields',
        sortKey: 10,
    },
})
@Component({
    selector: 'committees-minute-document-form-panel',
    standalone: true,
    imports: [CommonModule, MinuteDocumentViewerComponent],
    changeDetection: ChangeDetectionStrategy.OnPush,
    template: `
        @if (MinuteInput; as minuteInput) {
            <section class="cmdp-section" aria-label="Minutes document preview">
                <committees-minute-document-viewer
                    [Minute]="minuteInput"
                    [MeetingTitle]="Record.Meeting ?? ''"
                    [CanEdit]="CanBridgeOrPin"
                    (MinuteBridged)="OnMinuteMutated($event)"
                    (VersionPinned)="OnVersionPinned($event)"
                ></committees-minute-document-viewer>
            </section>
        }
    `,
    styles: [`
        :host {
            display: block;
            width: 100%;
            margin-top: var(--mj-space-4, 16px);
        }
        .cmdp-section {
            display: block;
        }
    `],
})
export class MinuteDocumentFormPanel extends BaseFormPanel<mjBizAppsCommitteesMinuteEntity> {
    private readonly cdr = inject(ChangeDetectorRef);

    public get MinuteInput(): MinuteDualReadInput | null {
        const record = this.Record;
        if (!record || !record.IsSaved) {
            return null;
        }
        return {
            ID: record.ID,
            MeetingID: record.MeetingID,
            Content: record.Content,
            ApprovalStatus: record.ApprovalStatus,
            ApprovedAt: record.ApprovedAt,
            ApprovedByMeetingID: record.ApprovedByMeetingID,
            MJArtifactID: record.MJArtifactID,
            ApprovedArtifactVersionID: record.ApprovedArtifactVersionID,
        };
    }

    public get CanBridgeOrPin(): boolean {
        return Boolean(this.Record?.IsSaved && this.Record.ApprovalStatus !== 'Approved');
    }

    public async OnMinuteMutated(result: BridgeLegacyMinuteResult): Promise<void> {
        if (result.Success && this.Record?.ID) {
            await this.Record.Load(this.Record.ID);
            this.cdr.markForCheck();
        }
    }

    public async OnVersionPinned(result: PinApprovedMinuteVersionResult): Promise<void> {
        if (result.Success && this.Record?.ID) {
            await this.Record.Load(this.Record.ID);
            this.cdr.markForCheck();
        }
    }
}
