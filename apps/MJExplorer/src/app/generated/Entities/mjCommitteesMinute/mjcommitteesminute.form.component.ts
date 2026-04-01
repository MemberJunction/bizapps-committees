import { Component } from '@angular/core';
import { mjCommitteesMinuteEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';

@RegisterClass(BaseFormComponent, 'Minutes') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjcommitteesminute-form',
    templateUrl: './mjcommitteesminute.form.component.html'
})
export class mjCommitteesMinuteFormComponent extends BaseFormComponent {
    public record!: mjCommitteesMinuteEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'generalInformation', sectionName: 'General Information', isExpanded: true },
            { sectionKey: 'approvalTracking', sectionName: 'Approval Tracking', isExpanded: true },
            { sectionKey: 'meetingDetails', sectionName: 'Meeting Details', isExpanded: false },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false }
        ]);
    }
}

