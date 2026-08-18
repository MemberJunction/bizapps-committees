import { Component, ChangeDetectionStrategy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RegisterClassEx } from '@memberjunction/global';
import { BaseFormPanel, BaseFormsModule } from '@memberjunction/ng-base-forms';
import { CommitteeRosterComponent } from '../../membership/committee-roster.component';
import { mjBizAppsCommitteesCommitteeEntity } from '@mj-biz-apps/committees-entities';

/**
 * Committee Roster & Term Tracker Form Panel.
 *
 * Attaches to `Committees: Committees` and provides real-time term tracking,
 * leadership officer segregation, and meeting attendance statistics.
 */
@RegisterClassEx(BaseFormPanel, {
    key: 'form-panel:Committees:rosterTracker',
    metadata: {
        entity: 'Committees: Committees',
        slot: 'after-related',
        sortKey: 30,
        relatedEntity: 'Committees: Committee Memberships'
    }
})
@Component({
    selector: 'bizapps-committee-roster-panel',
    standalone: true,
    imports: [CommonModule, BaseFormsModule, CommitteeRosterComponent],
    changeDetection: ChangeDetectionStrategy.OnPush,
    template: `
        <mj-collapsible-panel
            SectionKey="committeeRoster"
            SectionName="Committee Roster & Term Tracker"
            Icon="fa-solid fa-users"
            Variant="related-entity"
            [Form]="FormComponent"
            [FormContext]="FormContext"
            [DefaultExpanded]="true">
            @if (Record.IsSaved) {
                <bizapps-committee-roster
                    [CommitteeID]="Record.ID"
                    (Navigate)="FormComponent.OnFormNavigate($event)">
                </bizapps-committee-roster>
            }
        </mj-collapsible-panel>
    `,
    styles: [`
        :host {
            display: block;
            width: 100%;
            margin-bottom: 20px;
        }
    `]
})
export class CommitteeRosterPanel extends BaseFormPanel<mjBizAppsCommitteesCommitteeEntity> {}
