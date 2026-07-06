import { Component } from '@angular/core';
import { mjBizAppsCommitteesAgendaItemEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Agenda Items') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommitteesagendaitem-form',
    templateUrl: './mjbizappscommitteesagendaitem.form.component.html'
})
export class mjBizAppsCommitteesAgendaItemFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommitteesAgendaItemEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'meetingContext', sectionName: 'Meeting Context', isExpanded: true },
            { sectionKey: 'hierarchy', sectionName: 'Hierarchy', isExpanded: true },
            { sectionKey: 'agendaStructure', sectionName: 'Agenda Structure', isExpanded: true },
            { sectionKey: 'agendaContent', sectionName: 'Agenda Content', isExpanded: true },
            { sectionKey: 'presenterDetails', sectionName: 'Presenter Details', isExpanded: true },
            { sectionKey: 'timing', sectionName: 'Timing', isExpanded: true },
            { sectionKey: 'resources', sectionName: 'Resources', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesAgendaItems', sectionName: 'Agenda Items', isExpanded: false },
            { sectionKey: 'committeesActionItems', sectionName: 'Action Items', isExpanded: false },
            { sectionKey: 'committeesComments', sectionName: 'Comments', isExpanded: false },
            { sectionKey: 'committeesArtifacts', sectionName: 'Artifacts', isExpanded: false },
            { sectionKey: 'committeesMotions', sectionName: 'Motions', isExpanded: false }
        ]);
    }
}

