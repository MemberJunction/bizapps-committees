import { Component, ChangeDetectionStrategy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RegisterClassEx } from '@memberjunction/global';
import { BaseFormPanel, BaseFormsModule } from '@memberjunction/ng-base-forms';
import { HierarchyTreeComponent, HierarchyTreeConfig } from '@memberjunction/ng-hierarchy-tree';
import { mjBizAppsCommitteesCommitteeEntity } from '@mj-biz-apps/committees-entities';

/**
 * Committee Governance Hierarchy Tree Panel.
 *
 * Attaches to `Committees: Committees` and renders an interactive governance tree
 * (Board -> Standing Committees -> Subcommittees -> Task Forces) powered by `@memberjunction/ng-hierarchy-tree`.
 */
@RegisterClassEx(BaseFormPanel, {
    key: 'form-panel:Committees:governanceTree',
    metadata: {
        entity: 'Committees: Committees',
        slot: 'after-related',
        sortKey: 45,
        relatedEntity: 'Committees: Committees',
        relatedJoinField: 'ParentCommitteeID'
    }
})
@Component({
    selector: 'bizapps-committee-governance-tree-panel',
    standalone: true,
    imports: [CommonModule, BaseFormsModule, HierarchyTreeComponent],
    changeDetection: ChangeDetectionStrategy.OnPush,
    template: `
        <mj-collapsible-panel
            SectionKey="governanceHierarchy"
            SectionName="Committee Governance Hierarchy"
            Icon="fa-solid fa-sitemap"
            Variant="related-entity"
            [Form]="FormComponent"
            [FormContext]="FormContext"
            [DefaultExpanded]="true">
            @if (Record.IsSaved) {
                <mj-hierarchy-tree
                    [Config]="treeConfig"
                    (Navigate)="FormComponent.OnFormNavigate($event)">
                </mj-hierarchy-tree>
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
export class CommitteeGovernanceTreePanel extends BaseFormPanel<mjBizAppsCommitteesCommitteeEntity> {
    public get treeConfig(): HierarchyTreeConfig {
        return {
            EntityName: 'Committees: Committees',
            ParentField: 'ParentCommitteeID',
            SubtitleField: 'Type',
            DefaultIcon: 'fa-solid fa-people-group',
            DefaultColor: '#0284c7',
            FocusRecordID: this.Record?.ID || undefined,
            Height: '440px',
            ShowSearch: true,
            ShowToolbar: true
        };
    }
}
