import { Component } from '@angular/core';
import { mjCommitteesMembershipEntity } from 'mj_generatedentities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Memberships') // Tell MemberJunction about this class
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
            { sectionKey: 'votes', sectionName: 'Votes', isExpanded: false },
            { sectionKey: 'motionsSecondedByMembershipID', sectionName: 'Motions (Seconded By)', isExpanded: false },
            { sectionKey: 'motionsMovedByMembershipID', sectionName: 'Motions (Moved By)', isExpanded: false }
        ]);
    }
}

