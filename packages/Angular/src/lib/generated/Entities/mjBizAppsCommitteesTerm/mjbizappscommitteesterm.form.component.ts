import { Component } from '@angular/core';
import { mjBizAppsCommitteesTermEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Terms') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommitteesterm-form',
    templateUrl: './mjbizappscommitteesterm.form.component.html'
})
export class mjBizAppsCommitteesTermFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommitteesTermEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'details', sectionName: 'Details', isExpanded: true },
            { sectionKey: 'committeesMemberships', sectionName: 'Memberships', isExpanded: false }
        ]);
    }
}

