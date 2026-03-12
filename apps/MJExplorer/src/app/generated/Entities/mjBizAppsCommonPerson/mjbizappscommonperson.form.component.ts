import { Component } from '@angular/core';
import { mjBizAppsCommonPersonEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'MJ.BizApps.Common: People') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommonperson-form',
    templateUrl: './mjbizappscommonperson.form.component.html'
})
export class mjBizAppsCommonPersonFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommonPersonEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'personalIdentity', sectionName: 'Personal Identity', isExpanded: true },
            { sectionKey: 'professionalAndProfile', sectionName: 'Professional and Profile', isExpanded: true },
            { sectionKey: 'accountAndStatus', sectionName: 'Account and Status', isExpanded: false },
            { sectionKey: 'primaryAddress', sectionName: 'Primary Address', isExpanded: false },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'attendances', sectionName: 'Attendances', isExpanded: false },
            { sectionKey: 'mJBizAppsCommonContactMethods', sectionName: 'MJ.BizApps.Common: Contact Methods', isExpanded: false },
            { sectionKey: 'agendaItems', sectionName: 'Agenda Items', isExpanded: false },
            { sectionKey: 'mJBizAppsCommonRelationshipsToPersonID', sectionName: 'MJ.BizApps.Common: Relationships', isExpanded: false },
            { sectionKey: 'memberships', sectionName: 'Memberships', isExpanded: false },
            { sectionKey: 'actionItemsAssignedToPersonID', sectionName: 'Action Items (Assigned To Person)', isExpanded: false },
            { sectionKey: 'mJBizAppsCommonRelationshipsFromPersonID', sectionName: 'MJ.BizApps.Common: Relationships', isExpanded: false },
            { sectionKey: 'artifacts', sectionName: 'Artifacts', isExpanded: false },
            { sectionKey: 'actionItemsAssignedByPersonID', sectionName: 'Action Items (Assigned By Person)', isExpanded: false }
        ]);
    }
}

