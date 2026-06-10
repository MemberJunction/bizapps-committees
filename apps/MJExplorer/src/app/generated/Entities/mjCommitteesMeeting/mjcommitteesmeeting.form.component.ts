import { Component } from '@angular/core';
import { mjCommitteesMeetingEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Meetings') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjcommitteesmeeting-form',
    templateUrl: './mjcommitteesmeeting.form.component.html'
})
export class mjCommitteesMeetingFormComponent extends BaseFormComponent {
    public record!: mjCommitteesMeetingEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'committeeReference', sectionName: 'Committee Reference', isExpanded: true },
            { sectionKey: 'meetingDetails', sectionName: 'Meeting Details', isExpanded: true },
            { sectionKey: 'schedule', sectionName: 'Schedule', isExpanded: true },
            { sectionKey: 'location', sectionName: 'Location', isExpanded: true },
            { sectionKey: 'virtualMeeting', sectionName: 'Virtual Meeting', isExpanded: true },
            { sectionKey: 'meetingStatus', sectionName: 'Meeting Status', isExpanded: true },
            { sectionKey: 'details', sectionName: 'Details', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesComments', sectionName: 'Comments', isExpanded: false },
            { sectionKey: 'committeesActionItems', sectionName: 'Action Items', isExpanded: false },
            { sectionKey: 'committeesAttendances', sectionName: 'Attendances', isExpanded: false },
            { sectionKey: 'committeesMotions', sectionName: 'Motions', isExpanded: false },
            { sectionKey: 'committeesMinutesMeetingID', sectionName: 'Minutes (Meeting)', isExpanded: false },
            { sectionKey: 'committeesMinutesApprovedByMeetingID', sectionName: 'Minutes (Approved By Meeting)', isExpanded: false },
            { sectionKey: 'committeesAgendaItems', sectionName: 'Agenda Items', isExpanded: false },
            { sectionKey: 'committeesArtifacts', sectionName: 'Artifacts', isExpanded: false }
        ]);
    }
}

