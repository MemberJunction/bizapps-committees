import { Component, ChangeDetectionStrategy, Input, Output, EventEmitter } from '@angular/core';
import { AttentionItem, AttentionKind } from '@mj-biz-apps/committees-core';

/**
 * "Needs your attention" rail — actionable governance issues
 * (term lapses, pending minutes, overdue actions, quorum risk),
 * pre-sorted by severity by CommitteeHealthService. Pure presentation;
 * emits ItemSelected so the parent can navigate to the committee.
 */
@Component({
    standalone: false,
    selector: 'attention-rail',
    templateUrl: './attention-rail.component.html',
    styleUrls: ['../shared/design-system.css', './command-center-shared.css', './attention-rail.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class AttentionRailComponent {
    @Input({ required: true }) Items!: AttentionItem[];
    @Output() ItemSelected = new EventEmitter<AttentionItem>();

    IconClass(kind: AttentionKind): string {
        const map: Record<AttentionKind, string> = {
            TermLapse: 'fa-solid fa-timeline',
            MinutesPending: 'fa-solid fa-file-lines',
            OverdueAction: 'fa-solid fa-square-check',
            QuorumRisk: 'fa-solid fa-users'
        };
        return map[kind];
    }

    IconTone(kind: AttentionKind): string {
        const map: Record<AttentionKind, string> = {
            TermLapse: 'err',
            MinutesPending: 'warn',
            OverdueAction: 'warn',
            QuorumRisk: 'err'
        };
        return map[kind];
    }
}
