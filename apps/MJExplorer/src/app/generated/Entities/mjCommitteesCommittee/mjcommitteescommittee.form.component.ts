import { Component } from '@angular/core';
import { mjCommitteesCommitteeEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Committees') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjcommitteescommittee-form',
    templateUrl: './mjcommitteescommittee.form.component.html'
})
export class mjCommitteesCommitteeFormComponent extends BaseFormComponent {
    public record!: mjCommitteesCommitteeEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'committeeProfile', sectionName: 'Committee Profile', isExpanded: true },
            { sectionKey: 'hierarchy', sectionName: 'Hierarchy', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesActionItems', sectionName: 'Action Items', isExpanded: false },
            { sectionKey: 'committeesCommittees', sectionName: 'Committees', isExpanded: false },
            { sectionKey: 'committeesMeetings', sectionName: 'Meetings', isExpanded: false },
            { sectionKey: 'committeesComments', sectionName: 'Comments', isExpanded: false },
            { sectionKey: 'committeesTerms', sectionName: 'Terms', isExpanded: false },
            { sectionKey: 'committeesArtifacts', sectionName: 'Artifacts', isExpanded: false }
        ]);
    }
}

