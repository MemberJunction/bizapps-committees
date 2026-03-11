import { Component } from '@angular/core';
import { mjCommitteesTypeEntity } from 'mj_generatedentities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Types') // Tell MemberJunction about this class
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
            { sectionKey: 'identification', sectionName: 'Identification', isExpanded: true },
            { sectionKey: 'definition', sectionName: 'Definition', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committees', sectionName: 'Committees', isExpanded: false }
        ]);
    }
}

