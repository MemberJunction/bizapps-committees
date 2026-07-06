import { Component } from '@angular/core';
import { mjBizAppsCommitteesMinuteEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';

@RegisterClass(BaseFormComponent, 'Committees: Minutes') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommitteesminute-form',
    templateUrl: './mjbizappscommitteesminute.form.component.html'
})
export class mjBizAppsCommitteesMinuteFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommitteesMinuteEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'relatedContent', sectionName: 'Related Content', isExpanded: true },
            { sectionKey: 'minutesContent', sectionName: 'Minutes Content', isExpanded: true },
            { sectionKey: 'approvalTracking', sectionName: 'Approval Tracking', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false }
        ]);
    }
}

