import { Component } from '@angular/core';
import { mjCommitteesAttendanceEntity } from 'mj_generatedentities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';

@RegisterClass(BaseFormComponent, 'Attendances') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjcommitteesattendance-form',
    templateUrl: './mjcommitteesattendance.form.component.html'
})
export class mjCommitteesAttendanceFormComponent extends BaseFormComponent {
    public record!: mjCommitteesAttendanceEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'attendeeMeeting', sectionName: 'Attendee & Meeting', isExpanded: true },
            { sectionKey: 'attendanceDetails', sectionName: 'Attendance Details', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false }
        ]);
    }
}

