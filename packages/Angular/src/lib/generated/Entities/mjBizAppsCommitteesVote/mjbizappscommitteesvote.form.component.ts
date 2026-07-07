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
            { sectionKey: 'details', sectionName: 'Details', isExpanded: true }
        ]);
    }
}

