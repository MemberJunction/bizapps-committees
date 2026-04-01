import { Component } from '@angular/core';
import { mjCommitteesMotionEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Motions') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjcommitteesmotion-form',
    templateUrl: './mjcommitteesmotion.form.component.html'
})
export class mjCommitteesMotionFormComponent extends BaseFormComponent {
    public record!: mjCommitteesMotionEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'motionDetails', sectionName: 'Motion Details', isExpanded: true },
            { sectionKey: 'memberParticipation', sectionName: 'Member Participation', isExpanded: true },
            { sectionKey: 'votingOutcome', sectionName: 'Voting Outcome', isExpanded: false },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'votes', sectionName: 'Votes', isExpanded: false }
        ]);
    }
}

