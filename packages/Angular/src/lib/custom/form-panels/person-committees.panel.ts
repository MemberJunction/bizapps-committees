import { ChangeDetectionStrategy, Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RegisterClassEx } from '@memberjunction/global';
import { BaseFormPanel, BaseFormsModule } from '@memberjunction/ng-base-forms';
import type { mjBizAppsCommonPersonEntity } from '@mj-biz-apps/common-entities';
import { PersonCommitteesComponent } from './person-committees.component';

/**
 * The one Committees contribution on Person: seats grouped by committee,
 * each card showing term(s) and role. Replaces the raw Memberships grid.
 * contributionKey must equal SectionKey (contracts form-panel rule).
 */
@RegisterClassEx(BaseFormPanel, {
    key: 'form-panel:People:committees',
    metadata: {
        entity: 'MJ_BizApps_Common: People',
        slot: 'after-fields',
        sortKey: 80,
        contributionKey: 'committees',
        relatedEntity: 'Committees: Memberships',
        relatedJoinField: 'PersonID',
        inclusion: 'Primary',
    },
})
@Component({
    selector: 'bizapps-person-committees-panel',
    standalone: true,
    imports: [CommonModule, BaseFormsModule, PersonCommitteesComponent],
    changeDetection: ChangeDetectionStrategy.OnPush,
    template: `
        <mj-collapsible-panel
            SectionKey="committees"
            SectionName="Committees"
            Icon="fa-solid fa-landmark"
            Variant="related-entity"
            [Form]="FormComponent"
            [FormContext]="FormContext"
            [DefaultExpanded]="true">
            @if (Record.IsSaved) {
                <bizapps-person-committees
                    [PersonID]="Record.ID"
                    [Provider]="FormComponent.ProviderToUse"
                    (Navigate)="FormComponent.OnFormNavigate($event)">
                </bizapps-person-committees>
            }
        </mj-collapsible-panel>
    `,
})
export class PersonCommitteesPanel extends BaseFormPanel<mjBizAppsCommonPersonEntity> {}
