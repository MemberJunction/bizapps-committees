import { Component } from '@angular/core';
import { mjCommitteesCommentEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Comments') // Tell MemberJunction about this class
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
            { sectionKey: 'contextReferences', sectionName: 'Context References', isExpanded: true },
            { sectionKey: 'threading', sectionName: 'Threading', isExpanded: true },
            { sectionKey: 'authorInformation', sectionName: 'Author Information', isExpanded: true },
            { sectionKey: 'commentContent', sectionName: 'Comment Content', isExpanded: true },
            { sectionKey: 'commentStatus', sectionName: 'Comment Status', isExpanded: true },
            { sectionKey: 'displayValues', sectionName: 'Display Values', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesComments', sectionName: 'Comments', isExpanded: false }
        ]);
    }
}

