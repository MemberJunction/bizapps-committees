import { Component } from '@angular/core';
import { mjBizAppsCommitteesMeetingEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Meetings') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommitteesmeeting-form',
    templateUrl: './mjbizappscommitteesmeeting.form.component.html'
})
export class mjBizAppsCommitteesMeetingFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommitteesMeetingEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'details', sectionName: 'Details', isExpanded: true },
            { sectionKey: 'committeesArtifacts', sectionName: 'Artifacts', isExpanded: false },
            { sectionKey: 'committeesAgendaItems', sectionName: 'Agenda Items', isExpanded: false },
            { sectionKey: 'committeesMotions', sectionName: 'Motions', isExpanded: false },
            { sectionKey: 'committeesAttendances', sectionName: 'Attendances', isExpanded: false },
            { sectionKey: 'committeesActionItems', sectionName: 'Action Items', isExpanded: false },
            { sectionKey: 'committeesMinutesApprovedByMeetingID', sectionName: 'Minutes (Approved By Meeting ID)', isExpanded: false },
            { sectionKey: 'committeesMinutesMeetingID', sectionName: 'Minutes (Meeting ID)', isExpanded: false },
            { sectionKey: 'committeesComments', sectionName: 'Comments', isExpanded: false }
        ]);
    }
}

