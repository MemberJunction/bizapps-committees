import { Component } from '@angular/core';
import { mjBizAppsCommitteesCommentEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Comments') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommitteescomment-form',
    templateUrl: './mjbizappscommitteescomment.form.component.html'
})
export class mjBizAppsCommitteesCommentFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommitteesCommentEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'details', sectionName: 'Details', isExpanded: true },
            { sectionKey: 'committeesComments', sectionName: 'Comments', isExpanded: false }
        ]);
    }
}

