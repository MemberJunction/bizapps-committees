import { Component } from '@angular/core';
import { mjCommitteesTermEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Terms') // Tell MemberJunction about this class
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
            { sectionKey: 'committeeRelationship', sectionName: 'Committee Relationship', isExpanded: true },
            { sectionKey: 'termDetails', sectionName: 'Term Details', isExpanded: true },
            { sectionKey: 'termTimeline', sectionName: 'Term Timeline', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesMemberships', sectionName: 'Memberships', isExpanded: false }
        ]);
    }
}

