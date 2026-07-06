import { Component } from '@angular/core';
import { mjBizAppsCommitteesVoteEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';

@RegisterClass(BaseFormComponent, 'Committees: Votes') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommitteesvote-form',
    templateUrl: './mjbizappscommitteesvote.form.component.html'
})
export class mjBizAppsCommitteesVoteFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommitteesVoteEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'motionReference', sectionName: 'Motion Reference', isExpanded: true },
            { sectionKey: 'memberReference', sectionName: 'Member Reference', isExpanded: true },
            { sectionKey: 'voteDetails', sectionName: 'Vote Details', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false }
        ]);
    }
}

