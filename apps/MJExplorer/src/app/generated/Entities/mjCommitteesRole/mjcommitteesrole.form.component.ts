import { Component } from '@angular/core';
import { mjCommitteesRoleEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Roles') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjcommitteesrole-form',
    templateUrl: './mjcommitteesrole.form.component.html'
})
export class mjCommitteesRoleFormComponent extends BaseFormComponent {
    public record!: mjCommitteesRoleEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'roleDefinition', sectionName: 'Role Definition', isExpanded: true },
            { sectionKey: 'rolePermissions', sectionName: 'Role Permissions', isExpanded: true },
            { sectionKey: 'displaySettings', sectionName: 'Display Settings', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesMemberships', sectionName: 'Memberships', isExpanded: false }
        ]);
    }
}

