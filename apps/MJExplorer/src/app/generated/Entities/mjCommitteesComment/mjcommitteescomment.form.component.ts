import { Component } from '@angular/core';
import { mjCommitteesCommentEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Comments') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjcommitteescomment-form',
    templateUrl: './mjcommitteescomment.form.component.html'
})
export class mjCommitteesCommentFormComponent extends BaseFormComponent {
    public record!: mjCommitteesCommentEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'associations', sectionName: 'Associations', isExpanded: true },
            { sectionKey: 'discussionContent', sectionName: 'Discussion Content', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'comments', sectionName: 'Comments', isExpanded: false }
        ]);
    }
}

