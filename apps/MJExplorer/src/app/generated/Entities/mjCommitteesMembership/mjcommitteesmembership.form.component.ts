import { Component } from '@angular/core';
import { mjCommitteesMembershipEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Memberships') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjcommitteesmembership-form',
    templateUrl: './mjcommitteesmembership.form.component.html'
})
export class mjCommitteesMembershipFormComponent extends BaseFormComponent {
    public record!: mjCommitteesMembershipEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'personAssignment', sectionName: 'Person Assignment', isExpanded: true },
            { sectionKey: 'roleAssignment', sectionName: 'Role Assignment', isExpanded: true },
            { sectionKey: 'termAssignment', sectionName: 'Term Assignment', isExpanded: true },
            { sectionKey: 'membershipTimeline', sectionName: 'Membership Timeline', isExpanded: true },
            { sectionKey: 'membershipStatus', sectionName: 'Membership Status', isExpanded: true },
            { sectionKey: 'additionalInformation', sectionName: 'Additional Information', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesMotionsMovedByMembershipID', sectionName: 'Motions (Moved By)', isExpanded: false },
            { sectionKey: 'committeesMotionsSecondedByMembershipID', sectionName: 'Motions (Seconded By)', isExpanded: false },
            { sectionKey: 'committeesVotes', sectionName: 'Votes', isExpanded: false }
        ]);
    }
}

