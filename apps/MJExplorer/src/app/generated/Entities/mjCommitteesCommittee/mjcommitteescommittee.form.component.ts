import { Component } from '@angular/core';
import { mjCommitteesCommitteeEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees') // Tell MemberJunction about this class
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
            { sectionKey: 'terms', sectionName: 'Terms', isExpanded: false },
            { sectionKey: 'meetings', sectionName: 'Meetings', isExpanded: false },
            { sectionKey: 'memberships', sectionName: 'Memberships', isExpanded: false },
            { sectionKey: 'artifacts', sectionName: 'Artifacts', isExpanded: false },
            { sectionKey: 'actionItems', sectionName: 'Action Items', isExpanded: false },
            { sectionKey: 'committees', sectionName: 'Committees', isExpanded: false },
            { sectionKey: 'comments', sectionName: 'Comments', isExpanded: false }
        ]);
    }
}

