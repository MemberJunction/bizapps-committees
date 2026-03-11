import { Component } from '@angular/core';
import { mjCommitteesTermEntity } from 'mj_generatedentities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Terms') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjcommitteesterm-form',
    templateUrl: './mjcommitteesterm.form.component.html'
})
export class mjCommitteesTermFormComponent extends BaseFormComponent {
    public record!: mjCommitteesTermEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'termOverview', sectionName: 'Term Overview', isExpanded: true },
            { sectionKey: 'termSchedule', sectionName: 'Term Schedule', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'memberships', sectionName: 'Memberships', isExpanded: false }
        ]);
    }
}

