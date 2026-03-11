import { Component } from '@angular/core';
import { mjCommitteesRoleEntity } from 'mj_generatedentities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Roles') // Tell MemberJunction about this class
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
            { sectionKey: 'coreRoleInformation', sectionName: 'Core Role Information', isExpanded: true },
            { sectionKey: 'roleSettings', sectionName: 'Role Settings', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'memberships', sectionName: 'Memberships', isExpanded: false }
        ]);
    }
}

