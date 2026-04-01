import { Component } from '@angular/core';
import { mjCommitteesMeetingEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Meetings') // Tell MemberJunction about this class
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
            { sectionKey: 'attendances', sectionName: 'Attendances', isExpanded: false },
            { sectionKey: 'minutesMeetingID', sectionName: 'Minutes (Meeting)', isExpanded: false },
            { sectionKey: 'agendaItems', sectionName: 'Agenda Items', isExpanded: false },
            { sectionKey: 'minutesApprovedByMeetingID', sectionName: 'Minutes (Approved By Meeting)', isExpanded: false },
            { sectionKey: 'motions', sectionName: 'Motions', isExpanded: false },
            { sectionKey: 'actionItems', sectionName: 'Action Items', isExpanded: false },
            { sectionKey: 'artifacts', sectionName: 'Artifacts', isExpanded: false },
            { sectionKey: 'comments', sectionName: 'Comments', isExpanded: false }
        ]);
    }
}

