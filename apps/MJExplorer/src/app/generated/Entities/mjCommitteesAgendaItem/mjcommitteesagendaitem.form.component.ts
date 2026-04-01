import { Component } from '@angular/core';
import { mjCommitteesAgendaItemEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Agenda Items') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjcommitteesagendaitem-form',
    templateUrl: './mjcommitteesagendaitem.form.component.html'
})
export class mjCommitteesAgendaItemFormComponent extends BaseFormComponent {
    public record!: mjCommitteesAgendaItemEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'agendaStructure', sectionName: 'Agenda Structure', isExpanded: true },
            { sectionKey: 'itemContent', sectionName: 'Item Content', isExpanded: true },
            { sectionKey: 'presentationTiming', sectionName: 'Presentation & Timing', isExpanded: false },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'artifacts', sectionName: 'Artifacts', isExpanded: false },
            { sectionKey: 'motions', sectionName: 'Motions', isExpanded: false },
            { sectionKey: 'actionItems', sectionName: 'Action Items', isExpanded: false },
            { sectionKey: 'agendaItems', sectionName: 'Agenda Items', isExpanded: false },
            { sectionKey: 'comments', sectionName: 'Comments', isExpanded: false }
        ]);
    }
}

