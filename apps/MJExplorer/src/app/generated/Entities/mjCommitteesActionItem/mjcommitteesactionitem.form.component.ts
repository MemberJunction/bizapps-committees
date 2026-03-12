import { Component } from '@angular/core';
import { mjCommitteesActionItemEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Action Items') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjcommitteesactionitem-form',
    templateUrl: './mjcommitteesactionitem.form.component.html'
})
export class mjCommitteesActionItemFormComponent extends BaseFormComponent {
    public record!: mjCommitteesActionItemEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'context', sectionName: 'Context', isExpanded: true },
            { sectionKey: 'actionDetails', sectionName: 'Action Details', isExpanded: true },
            { sectionKey: 'responsibility', sectionName: 'Responsibility', isExpanded: false },
            { sectionKey: 'timelineCompletion', sectionName: 'Timeline & Completion', isExpanded: false },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'artifacts', sectionName: 'Artifacts', isExpanded: false }
        ]);
    }
}

