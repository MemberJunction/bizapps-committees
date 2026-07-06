import { Component } from '@angular/core';
import { mjBizAppsCommitteesCommitteeEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Committees') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommitteescommittee-form',
    templateUrl: './mjbizappscommitteescommittee.form.component.html'
})
export class mjBizAppsCommitteesCommitteeFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommitteesCommitteeEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'committeeCore', sectionName: 'Committee Core', isExpanded: true },
            { sectionKey: 'committeeClassification', sectionName: 'Committee Classification', isExpanded: true },
            { sectionKey: 'hierarchy', sectionName: 'Hierarchy', isExpanded: true },
            { sectionKey: 'organizationAssociation', sectionName: 'Organization Association', isExpanded: true },
            { sectionKey: 'documents', sectionName: 'Documents', isExpanded: true },
            { sectionKey: 'committeeStatus', sectionName: 'Committee Status', isExpanded: true },
            { sectionKey: 'timeline', sectionName: 'Timeline', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesActionItems', sectionName: 'Action Items', isExpanded: false },
            { sectionKey: 'committeesMeetings', sectionName: 'Meetings', isExpanded: false },
            { sectionKey: 'committeesComments', sectionName: 'Comments', isExpanded: false },
            { sectionKey: 'committeesCommittees', sectionName: 'Committees', isExpanded: false },
            { sectionKey: 'committeesArtifacts', sectionName: 'Artifacts', isExpanded: false },
            { sectionKey: 'committeesTerms', sectionName: 'Terms', isExpanded: false }
        ]);
    }
}

