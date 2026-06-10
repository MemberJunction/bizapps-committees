import { Component } from '@angular/core';
import { mjCommitteesTypeEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Types') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjcommitteestype-form',
    templateUrl: './mjcommitteestype.form.component.html'
})
export class mjCommitteesTypeFormComponent extends BaseFormComponent {
    public record!: mjCommitteesTypeEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'committeeDefinition', sectionName: 'Committee Definition', isExpanded: true },
            { sectionKey: 'committeeAttributes', sectionName: 'Committee Attributes', isExpanded: true },
            { sectionKey: 'presentation', sectionName: 'Presentation', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesCommittees', sectionName: 'Committees', isExpanded: false }
        ]);
    }
}

