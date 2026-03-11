/**********************************************************************************
* GENERATED FILE - This file is automatically managed by the MJ CodeGen tool, 
* 
* DO NOT MODIFY THIS FILE - any changes you make will be wiped out the next time the file is
* generated
* 
**********************************************************************************/
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

// MemberJunction Imports
import { BaseFormsModule } from '@memberjunction/ng-base-forms';
import { EntityViewerModule } from '@memberjunction/ng-entity-viewer';
import { LinkDirectivesModule } from '@memberjunction/ng-link-directives';
import { LayoutModule } from '@progress/kendo-angular-layout';

// Import Generated Components
import { mjCommitteesActionItemFormComponent } from "./Entities/mjCommitteesActionItem/mjcommitteesactionitem.form.component";
import { mjCommitteesAgendaItemFormComponent } from "./Entities/mjCommitteesAgendaItem/mjcommitteesagendaitem.form.component";
import { mjCommitteesArtifactTypeFormComponent } from "./Entities/mjCommitteesArtifactType/mjcommitteesartifacttype.form.component";
import { mjCommitteesArtifactFormComponent } from "./Entities/mjCommitteesArtifact/mjcommitteesartifact.form.component";
import { mjCommitteesAttendanceFormComponent } from "./Entities/mjCommitteesAttendance/mjcommitteesattendance.form.component";
import { mjCommitteesCommitteeFormComponent } from "./Entities/mjCommitteesCommittee/mjcommitteescommittee.form.component";
import { mjCommitteesMeetingFormComponent } from "./Entities/mjCommitteesMeeting/mjcommitteesmeeting.form.component";
import { mjCommitteesMembershipFormComponent } from "./Entities/mjCommitteesMembership/mjcommitteesmembership.form.component";
import { mjCommitteesMinuteFormComponent } from "./Entities/mjCommitteesMinute/mjcommitteesminute.form.component";
import { mjBizAppsCommonAddressLinkFormComponent } from "./Entities/mjBizAppsCommonAddressLink/mjbizappscommonaddresslink.form.component";
import { mjBizAppsCommonAddressTypeFormComponent } from "./Entities/mjBizAppsCommonAddressType/mjbizappscommonaddresstype.form.component";
import { mjBizAppsCommonAddressFormComponent } from "./Entities/mjBizAppsCommonAddress/mjbizappscommonaddress.form.component";
import { mjBizAppsCommonContactMethodFormComponent } from "./Entities/mjBizAppsCommonContactMethod/mjbizappscommoncontactmethod.form.component";
import { mjBizAppsCommonContactTypeFormComponent } from "./Entities/mjBizAppsCommonContactType/mjbizappscommoncontacttype.form.component";
import { mjBizAppsCommonOrganizationTypeFormComponent } from "./Entities/mjBizAppsCommonOrganizationType/mjbizappscommonorganizationtype.form.component";
import { mjBizAppsCommonOrganizationFormComponent } from "./Entities/mjBizAppsCommonOrganization/mjbizappscommonorganization.form.component";
import { mjBizAppsCommonPersonFormComponent } from "./Entities/mjBizAppsCommonPerson/mjbizappscommonperson.form.component";
import { mjBizAppsCommonRelationshipTypeFormComponent } from "./Entities/mjBizAppsCommonRelationshipType/mjbizappscommonrelationshiptype.form.component";
import { mjBizAppsCommonRelationshipFormComponent } from "./Entities/mjBizAppsCommonRelationship/mjbizappscommonrelationship.form.component";
import { mjCommitteesMotionFormComponent } from "./Entities/mjCommitteesMotion/mjcommitteesmotion.form.component";
import { mjCommitteesRoleFormComponent } from "./Entities/mjCommitteesRole/mjcommitteesrole.form.component";
import { mjCommitteesTermFormComponent } from "./Entities/mjCommitteesTerm/mjcommitteesterm.form.component";
import { mjCommitteesTypeFormComponent } from "./Entities/mjCommitteesType/mjcommitteestype.form.component";
import { mjCommitteesVoteFormComponent } from "./Entities/mjCommitteesVote/mjcommitteesvote.form.component";
   

@NgModule({
declarations: [
    mjCommitteesActionItemFormComponent,
    mjCommitteesAgendaItemFormComponent,
    mjCommitteesArtifactTypeFormComponent,
    mjCommitteesArtifactFormComponent,
    mjCommitteesAttendanceFormComponent,
    mjCommitteesCommitteeFormComponent,
    mjCommitteesMeetingFormComponent,
    mjCommitteesMembershipFormComponent,
    mjCommitteesMinuteFormComponent,
    mjBizAppsCommonAddressLinkFormComponent,
    mjBizAppsCommonAddressTypeFormComponent,
    mjBizAppsCommonAddressFormComponent,
    mjBizAppsCommonContactMethodFormComponent,
    mjBizAppsCommonContactTypeFormComponent,
    mjBizAppsCommonOrganizationTypeFormComponent,
    mjBizAppsCommonOrganizationFormComponent,
    mjBizAppsCommonPersonFormComponent,
    mjBizAppsCommonRelationshipTypeFormComponent,
    mjBizAppsCommonRelationshipFormComponent,
    mjCommitteesMotionFormComponent],
imports: [
    CommonModule,
    FormsModule,
    LayoutModule,
    BaseFormsModule,
    EntityViewerModule,
    LinkDirectivesModule
],
exports: [
]
})
export class GeneratedForms_SubModule_0 { }
    


@NgModule({
declarations: [
    mjCommitteesRoleFormComponent,
    mjCommitteesTermFormComponent,
    mjCommitteesTypeFormComponent,
    mjCommitteesVoteFormComponent],
imports: [
    CommonModule,
    FormsModule,
    LayoutModule,
    BaseFormsModule,
    EntityViewerModule,
    LinkDirectivesModule
],
exports: [
]
})
export class GeneratedForms_SubModule_1 { }
    


@NgModule({
declarations: [
],
imports: [
    GeneratedForms_SubModule_0,
    GeneratedForms_SubModule_1
]
})
export class GeneratedFormsModule { }
    
// Note: LoadXXXGeneratedForms() functions have been removed. Tree-shaking prevention
// is now handled by the pre-built class registration manifest system.
// See packages/CodeGenLib/CLASS_MANIFEST_GUIDE.md for details.
    