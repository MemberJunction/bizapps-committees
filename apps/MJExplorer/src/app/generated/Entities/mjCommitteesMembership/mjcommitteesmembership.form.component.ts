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
            { sectionKey: 'membershipAssignment', sectionName: 'Membership Assignment', isExpanded: true },
            { sectionKey: 'timelineStatus', sectionName: 'Timeline & Status', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesVotes', sectionName: 'Committees: Votes', isExpanded: false },
            { sectionKey: 'committeesMotionsSecondedByMembershipID', sectionName: 'Committees: Motions (Seconded By Membership)', isExpanded: false },
            { sectionKey: 'committeesMotionsMovedByMembershipID', sectionName: 'Committees: Motions (Moved By Membership)', isExpanded: false }
        ]);
    }
}

