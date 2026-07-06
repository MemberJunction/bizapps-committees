import { Component } from '@angular/core';
import { mjBizAppsCommitteesActionItemEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';

@RegisterClass(BaseFormComponent, 'Committees: Action Items') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommitteesactionitem-form',
    templateUrl: './mjbizappscommitteesactionitem.form.component.html'
})
export class mjBizAppsCommitteesActionItemFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommitteesActionItemEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'committeeContext', sectionName: 'Committee Context', isExpanded: true },
            { sectionKey: 'actionDetails', sectionName: 'Action Details', isExpanded: true },
            { sectionKey: 'assignment', sectionName: 'Assignment', isExpanded: true },
            { sectionKey: 'timeline', sectionName: 'Timeline', isExpanded: true },
            { sectionKey: 'statusPriority', sectionName: 'Status & Priority', isExpanded: true },
            { sectionKey: 'displayValues', sectionName: 'Display Values', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false }
        ]);
    }
}

