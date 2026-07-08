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
            { sectionKey: 'details', sectionName: 'Details', isExpanded: true },
            { sectionKey: 'committeesMotionsSecondedByMembershipID', sectionName: 'Motions (Seconded By Membership ID)', isExpanded: false },
            { sectionKey: 'committeesMotionsMovedByMembershipID', sectionName: 'Motions (Moved By Membership ID)', isExpanded: false },
            { sectionKey: 'committeesVotes', sectionName: 'Votes', isExpanded: false },
            { sectionKey: 'committeesBallots', sectionName: 'Ballots', isExpanded: false }
        ]);
    }
}

