import { Component } from '@angular/core';
import { mjBizAppsCommitteesMotionEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Motions') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommitteesmotion-form',
    templateUrl: './mjbizappscommitteesmotion.form.component.html'
})
export class mjBizAppsCommitteesMotionFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommitteesMotionEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'details', sectionName: 'Details', isExpanded: true },
            { sectionKey: 'committeesVotes', sectionName: 'Votes', isExpanded: false },
            { sectionKey: 'committeesBallots', sectionName: 'Ballots', isExpanded: false }
        ]);
    }
}

