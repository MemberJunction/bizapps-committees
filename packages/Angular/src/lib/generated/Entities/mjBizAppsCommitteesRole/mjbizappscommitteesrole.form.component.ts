import { Component } from '@angular/core';
import { mjBizAppsCommitteesRoleEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Roles') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommitteesrole-form',
    templateUrl: './mjbizappscommitteesrole.form.component.html'
})
export class mjBizAppsCommitteesRoleFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommitteesRoleEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'roleDetails', sectionName: 'Role Details', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesMemberships', sectionName: 'Memberships', isExpanded: false }
        ]);
    }
}

