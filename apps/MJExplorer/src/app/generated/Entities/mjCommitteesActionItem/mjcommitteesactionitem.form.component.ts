import { Component } from '@angular/core';
import { mjCommitteesActionItemEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';

@RegisterClass(BaseFormComponent, 'Committees: Action Items') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjcommitteesactionitem-form',
    templateUrl: './mjcommitteesactionitem.form.component.html'
})
export class mjCommitteesActionItemFormComponent extends BaseFormComponent {
    public record!: mjCommitteesActionItemEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'committeeContext', sectionName: 'Committee Context', isExpanded: true },
            { sectionKey: 'actionItemDetails', sectionName: 'Action Item Details', isExpanded: true },
            { sectionKey: 'assignment', sectionName: 'Assignment', isExpanded: true },
            { sectionKey: 'schedule', sectionName: 'Schedule', isExpanded: true },
            { sectionKey: 'progress', sectionName: 'Progress', isExpanded: true },
            { sectionKey: 'displayValues', sectionName: 'Display Values', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false }
        ]);
    }
}

