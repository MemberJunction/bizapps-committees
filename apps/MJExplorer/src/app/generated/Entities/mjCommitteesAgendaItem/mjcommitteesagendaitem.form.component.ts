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
            { sectionKey: 'agendaDetails', sectionName: 'Agenda Details', isExpanded: true },
            { sectionKey: 'presenterInformation', sectionName: 'Presenter Information', isExpanded: true },
            { sectionKey: 'timing', sectionName: 'Timing', isExpanded: true },
            { sectionKey: 'resources', sectionName: 'Resources', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesActionItems', sectionName: 'Action Items', isExpanded: false },
            { sectionKey: 'committeesAgendaItems', sectionName: 'Agenda Items', isExpanded: false },
            { sectionKey: 'committeesArtifacts', sectionName: 'Artifacts', isExpanded: false },
            { sectionKey: 'committeesMotions', sectionName: 'Motions', isExpanded: false },
            { sectionKey: 'committeesComments', sectionName: 'Comments', isExpanded: false }
        ]);
    }
}

