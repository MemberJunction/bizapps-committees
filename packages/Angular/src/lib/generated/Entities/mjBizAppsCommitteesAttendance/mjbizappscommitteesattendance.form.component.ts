import { Component } from '@angular/core';
import { mjBizAppsCommitteesAttendanceEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';

@RegisterClass(BaseFormComponent, 'Committees: Attendances') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommitteesattendance-form',
    templateUrl: './mjbizappscommitteesattendance.form.component.html'
})
export class mjBizAppsCommitteesAttendanceFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommitteesAttendanceEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'details', sectionName: 'Details', isExpanded: true }
        ]);
    }
}

