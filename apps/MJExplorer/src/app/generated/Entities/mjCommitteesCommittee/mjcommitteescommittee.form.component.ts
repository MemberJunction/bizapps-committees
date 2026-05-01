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
            { sectionKey: 'committeeOverview', sectionName: 'Committee Overview', isExpanded: true },
            { sectionKey: 'classification', sectionName: 'Classification', isExpanded: true },
            { sectionKey: 'hierarchy', sectionName: 'Hierarchy', isExpanded: false },
            { sectionKey: 'governanceStatus', sectionName: 'Governance & Status', isExpanded: false },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesTerms', sectionName: 'Committees: Terms', isExpanded: false },
            { sectionKey: 'committeesMeetings', sectionName: 'Committees: Meetings', isExpanded: false },
            { sectionKey: 'committeesMemberships', sectionName: 'Committees: Memberships', isExpanded: false },
            { sectionKey: 'committeesArtifacts', sectionName: 'Committees: Artifacts', isExpanded: false },
            { sectionKey: 'committeesActionItems', sectionName: 'Committees: Action Items', isExpanded: false },
            { sectionKey: 'committeesCommittees', sectionName: 'Committees: Committees', isExpanded: false },
            { sectionKey: 'committeesComments', sectionName: 'Committees: Comments', isExpanded: false }
        ]);
    }
}

