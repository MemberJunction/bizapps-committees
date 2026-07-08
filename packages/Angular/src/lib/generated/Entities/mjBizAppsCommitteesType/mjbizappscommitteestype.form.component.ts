import { Component } from '@angular/core';
import { mjBizAppsCommitteesTypeEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Types') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommitteestype-form',
    templateUrl: './mjbizappscommitteestype.form.component.html'
})
export class mjBizAppsCommitteesTypeFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommitteesTypeEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'details', sectionName: 'Details', isExpanded: true },
            { sectionKey: 'committeesCommittees', sectionName: 'Committees', isExpanded: false }
        ]);
    }
}

