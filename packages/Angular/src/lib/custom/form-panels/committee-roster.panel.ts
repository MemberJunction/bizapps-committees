import { ChangeDetectionStrategy, Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RegisterClassEx } from '@memberjunction/global';
import { BaseFormPanel, BaseFormsModule } from '@memberjunction/ng-base-forms';
import { mjBizAppsCommitteesCommitteeEntity } from '@mj-biz-apps/committees-entities';
import { CommitteeMembersComponent } from './committee-members.component';

/**
 * Members of this committee, walked through Terms (membership has no CommitteeID).
 * contributionKey must equal SectionKey.
 */
@RegisterClassEx(BaseFormPanel, {
    key: 'form-panel:Committees:members',
    metadata: {
        entity: 'Committees: Committees',
        slot: 'after-fields',
        sortKey: 90,
        contributionKey: 'members',
        inclusion: 'Primary',
    },
})
@Component({
    selector: 'bizapps-committee-roster-panel',
    standalone: true,
    imports: [CommonModule, BaseFormsModule, CommitteeMembersComponent],
    changeDetection: ChangeDetectionStrategy.OnPush,
    template: `
        <mj-collapsible-panel
            SectionKey="members"
            SectionName="Members"
            Icon="fa-solid fa-users"
            Variant="related-entity"
            [Form]="FormComponent"
            [FormContext]="FormContext"
            [DefaultExpanded]="true">
            @if (Record.IsSaved) {
                <bizapps-committee-members
                    [CommitteeID]="Record.ID"
                    [Provider]="FormComponent.ProviderToUse"
                    (Navigate)="FormComponent.OnFormNavigate($event)">
                </bizapps-committee-members>
            }
        </mj-collapsible-panel>
    `,
})
export class CommitteeRosterPanel extends BaseFormPanel<mjBizAppsCommitteesCommitteeEntity> {}
