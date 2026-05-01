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
            { sectionKey: 'generalInformation', sectionName: 'General Information', isExpanded: true },
            { sectionKey: 'scheduleTiming', sectionName: 'Schedule & Timing', isExpanded: true },
            { sectionKey: 'locationAccess', sectionName: 'Location & Access', isExpanded: false },
            { sectionKey: 'videoRecording', sectionName: 'Video & Recording', isExpanded: false },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesAttendances', sectionName: 'Committees: Attendances', isExpanded: false },
            { sectionKey: 'committeesMinutesMeetingID', sectionName: 'Committees: Minutes (Meeting)', isExpanded: false },
            { sectionKey: 'committeesAgendaItems', sectionName: 'Committees: Agenda Items', isExpanded: false },
            { sectionKey: 'committeesMinutesApprovedByMeetingID', sectionName: 'Committees: Minutes (Approved By Meeting)', isExpanded: false },
            { sectionKey: 'committeesMotions', sectionName: 'Committees: Motions', isExpanded: false },
            { sectionKey: 'committeesActionItems', sectionName: 'Committees: Action Items', isExpanded: false },
            { sectionKey: 'committeesArtifacts', sectionName: 'Committees: Artifacts', isExpanded: false },
            { sectionKey: 'committeesComments', sectionName: 'Committees: Comments', isExpanded: false }
        ]);
    }
}

