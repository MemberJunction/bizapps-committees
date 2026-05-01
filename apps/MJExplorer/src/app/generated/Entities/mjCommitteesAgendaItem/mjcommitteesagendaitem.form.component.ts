import { Component } from '@angular/core';
import { mjCommitteesAgendaItemEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Agenda Items') // Tell MemberJunction about this class
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
            { sectionKey: 'committeesArtifacts', sectionName: 'Committees: Artifacts', isExpanded: false },
            { sectionKey: 'committeesMotions', sectionName: 'Committees: Motions', isExpanded: false },
            { sectionKey: 'committeesActionItems', sectionName: 'Committees: Action Items', isExpanded: false },
            { sectionKey: 'committeesAgendaItems', sectionName: 'Committees: Agenda Items', isExpanded: false },
            { sectionKey: 'committeesComments', sectionName: 'Committees: Comments', isExpanded: false }
        ]);
    }
}

