import { Component } from '@angular/core';
import { mjBizAppsCommitteesMembershipEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Memberships') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommitteesmembership-form',
    templateUrl: './mjbizappscommitteesmembership.form.component.html'
})
export class mjBizAppsCommitteesMembershipFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommitteesMembershipEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'personAssignment', sectionName: 'Person Assignment', isExpanded: true },
            { sectionKey: 'membershipTimeline', sectionName: 'Membership Timeline', isExpanded: true },
            { sectionKey: 'membershipStatus', sectionName: 'Membership Status', isExpanded: true },
            { sectionKey: 'membershipDetails', sectionName: 'Membership Details', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesMotionsSecondedByMembershipID', sectionName: 'Motions (Seconded By)', isExpanded: false },
            { sectionKey: 'committeesMotionsMovedByMembershipID', sectionName: 'Motions (Moved By)', isExpanded: false },
            { sectionKey: 'committeesVotes', sectionName: 'Votes', isExpanded: false }
        ]);
    }
}

