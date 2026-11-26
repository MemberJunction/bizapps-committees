import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

// MJ shared modules
import { ArtifactsModule } from '@memberjunction/ng-artifacts';
import { SharedGenericModule } from '@memberjunction/ng-shared-generic';
import { MJPageLayoutComponent } from '@memberjunction/ng-ui-components';

// BizAppsCommon reusable components
import { AddressEditorComponent, ContactMethodListComponent, RelationshipListComponent } from '@mj-biz-apps/common-ng';

// BizAppsTasks reusable components
import { BizAppsTasksModule, LoadBizAppsTasksClient } from '@mj-biz-apps/tasks-ng';

// Generated entity forms & custom form panels (retained in startupExport against tree-shaking)
import { GeneratedFormsModule } from './generated/generated-forms.module';
import { mjBizAppsCommitteesAgendaItemFormComponent } from './generated/Entities/mjBizAppsCommitteesAgendaItem/mjbizappscommitteesagendaitem.form.component';
import { mjBizAppsCommitteesArtifactFormComponent } from './generated/Entities/mjBizAppsCommitteesArtifact/mjbizappscommitteesartifact.form.component';
import { mjBizAppsCommitteesArtifactTypeFormComponent } from './generated/Entities/mjBizAppsCommitteesArtifactType/mjbizappscommitteesartifacttype.form.component';
import { mjBizAppsCommitteesAttendanceFormComponent } from './generated/Entities/mjBizAppsCommitteesAttendance/mjbizappscommitteesattendance.form.component';
import { mjBizAppsCommitteesBallotFormComponent } from './generated/Entities/mjBizAppsCommitteesBallot/mjbizappscommitteesballot.form.component';
import { mjBizAppsCommitteesCommentFormComponent } from './generated/Entities/mjBizAppsCommitteesComment/mjbizappscommitteescomment.form.component';
import { mjBizAppsCommitteesCommitteeFormComponent } from './generated/Entities/mjBizAppsCommitteesCommittee/mjbizappscommitteescommittee.form.component';
import { mjBizAppsCommitteesMeetingFormComponent } from './generated/Entities/mjBizAppsCommitteesMeeting/mjbizappscommitteesmeeting.form.component';
import { mjBizAppsCommitteesMembershipFormComponent } from './generated/Entities/mjBizAppsCommitteesMembership/mjbizappscommitteesmembership.form.component';
import { mjBizAppsCommitteesMinuteFormComponent } from './generated/Entities/mjBizAppsCommitteesMinute/mjbizappscommitteesminute.form.component';
import { mjBizAppsCommitteesMotionFormComponent } from './generated/Entities/mjBizAppsCommitteesMotion/mjbizappscommitteesmotion.form.component';
import { mjBizAppsCommitteesRoleFormComponent } from './generated/Entities/mjBizAppsCommitteesRole/mjbizappscommitteesrole.form.component';
import { mjBizAppsCommitteesTermFormComponent } from './generated/Entities/mjBizAppsCommitteesTerm/mjbizappscommitteesterm.form.component';
import { mjBizAppsCommitteesTypeFormComponent } from './generated/Entities/mjBizAppsCommitteesType/mjbizappscommitteestype.form.component';
import { mjBizAppsCommitteesVideoProviderFormComponent } from './generated/Entities/mjBizAppsCommitteesVideoProvider/mjbizappscommitteesvideoprovider.form.component';
import { mjBizAppsCommitteesVoteFormComponent } from './generated/Entities/mjBizAppsCommitteesVote/mjbizappscommitteesvote.form.component';
import { CustomFormsModule, LoadCustomFormsModule } from './custom/custom-forms.module';

// Standalone dual-read MJ Docs viewer components
import { MinuteDocumentViewerComponent } from './minutes/minute-document-viewer.component';
import { CommitteeArtifactPreviewComponent } from './documents/committee-artifact-preview.component';

// Committees components
import { CommitteeDashboardComponent, LoadCommitteeDashboard } from './dashboard/committee-dashboard.component';
import { CommitteeListComponent, LoadCommitteeList } from './committee-list/committee-list.component';
import { CommitteeEditDialogComponent, LoadCommitteeEditDialog } from './committee-list/committee-edit-dialog.component';
import { MeetingListComponent, LoadMeetingList } from './meeting-list/meeting-list.component';
import { MeetingEditDialogComponent, LoadMeetingEditDialog } from './meeting-list/meeting-edit-dialog.component';
import { TaskTrackerComponent, LoadTaskTracker } from './tasks/task-tracker.component';
import { DocumentBrowserComponent, LoadDocumentBrowser } from './documents/document-browser.component';
import { DocumentEditDialogComponent, LoadDocumentEditDialog } from './documents/document-edit-dialog.component';
import { DocumentPreviewPanelComponent, LoadDocumentPreviewPanel } from './documents/document-preview-panel.component';
import { PersonPickerComponent } from './shared/person-picker.component';
import { CommentThreadComponent, LoadCommentThread } from './comments/comment-thread.component';
import { AgendaItemEditDialogComponent, LoadAgendaItemEditDialog } from './agenda/agenda-item-edit-dialog.component';
import { MotionEditDialogComponent, LoadMotionEditDialog } from './motions/motion-edit-dialog.component';
import { TermEditDialogComponent, LoadTermEditDialog } from './terms/term-edit-dialog.component';
import { MembershipListComponent, LoadMembershipList } from './membership/membership-list.component';
import { MembershipPanelComponent, LoadMembershipPanel } from './membership/membership-panel.component';
import { MembershipEditDialogComponent, LoadMembershipEditDialog } from './membership/membership-edit-dialog.component';
import { PersonDetailPanelComponent, LoadPersonDetailPanel } from './membership/person-detail-panel.component';
import { GenerateMinutesPanelComponent, LoadGenerateMinutesPanel } from './minutes/generate-minutes-panel.component';
import { MeetingDetailViewComponent, LoadMeetingDetailView } from './meeting-detail/meeting-detail-view.component';
import { ManagementCommitteeListComponent, LoadManagementCommitteeList } from './management-committee-list/management-committee-list.component';
import { ManagementMembershipListComponent, LoadManagementMembershipList } from './management-membership-list/management-membership-list.component';
import { BulkImportPanelComponent, LoadBulkImportPanelComponent } from './bulk-import/bulk-import-panel.component';
import { CommandCenterComponent, LoadCommandCenter } from './command-center/command-center.component';
import { CommandCenterStatsComponent } from './command-center/command-center-stats.component';
import { HealthGridComponent } from './command-center/health-grid.component';
import { WeekRailComponent } from './command-center/week-rail.component';
import { AttentionRailComponent } from './command-center/attention-rail.component';
import { CommitteeWorkspaceComponent, LoadCommitteeWorkspace } from './committee-workspace/committee-workspace.component';
import { MotionsBallotsComponent, LoadMotionsBallots } from './motions-ballots/motions-ballots.component';
import { EBallotDialogComponent } from './motions-ballots/e-ballot-dialog.component';
import { LiveMeetingComponent, LoadLiveMeeting } from './live-meeting/live-meeting.component';
import { MinutesReviewComponent, LoadMinutesReview } from './minutes-review/minutes-review.component';
import { PeopleTermsComponent, LoadPeopleTerms } from './people-terms/people-terms.component';
import { SuccessionSuggestionsComponent } from './people-terms/succession-suggestions.component';
import { TermRenewalWizardComponent } from './people-terms/term-renewal-wizard.component';
import { BallotCloseDialogComponent } from './motions-ballots/ballot-close-dialog.component';
import { AgendaBuilderComponent } from './meeting-detail/agenda-builder.component';
import { PersonCreateDialogComponent } from './shared/person-create-dialog.component';
import { MemberHomeComponent, LoadMemberHome } from './member-home/member-home.component';

const GENERATED_FORM_COMPONENTS = [
    mjBizAppsCommitteesAgendaItemFormComponent,
    mjBizAppsCommitteesArtifactFormComponent,
    mjBizAppsCommitteesArtifactTypeFormComponent,
    mjBizAppsCommitteesAttendanceFormComponent,
    mjBizAppsCommitteesBallotFormComponent,
    mjBizAppsCommitteesCommentFormComponent,
    mjBizAppsCommitteesCommitteeFormComponent,
    mjBizAppsCommitteesMeetingFormComponent,
    mjBizAppsCommitteesMembershipFormComponent,
    mjBizAppsCommitteesMinuteFormComponent,
    mjBizAppsCommitteesMotionFormComponent,
    mjBizAppsCommitteesRoleFormComponent,
    mjBizAppsCommitteesTermFormComponent,
    mjBizAppsCommitteesTypeFormComponent,
    mjBizAppsCommitteesVideoProviderFormComponent,
    mjBizAppsCommitteesVoteFormComponent,
];

@NgModule({
    declarations: [
        CommitteeDashboardComponent,
        CommitteeListComponent,
        CommitteeEditDialogComponent,
        MeetingListComponent,
        MeetingEditDialogComponent,
        TaskTrackerComponent,
        DocumentBrowserComponent,
        DocumentEditDialogComponent,
        DocumentPreviewPanelComponent,
        PersonPickerComponent,
        CommentThreadComponent,
        AgendaItemEditDialogComponent,
        MotionEditDialogComponent,
        TermEditDialogComponent,
        MembershipListComponent,
        MembershipPanelComponent,
        MembershipEditDialogComponent,
        PersonDetailPanelComponent,
        GenerateMinutesPanelComponent,
        MeetingDetailViewComponent,
        ManagementCommitteeListComponent,
        ManagementMembershipListComponent,
        BulkImportPanelComponent,
        CommandCenterComponent,
        CommandCenterStatsComponent,
        HealthGridComponent,
        WeekRailComponent,
        AttentionRailComponent,
        CommitteeWorkspaceComponent,
        MotionsBallotsComponent,
        EBallotDialogComponent,
        LiveMeetingComponent,
        MinutesReviewComponent,
        PeopleTermsComponent,
        SuccessionSuggestionsComponent,
        TermRenewalWizardComponent,
        BallotCloseDialogComponent,
        AgendaBuilderComponent,
        PersonCreateDialogComponent,
        MemberHomeComponent,
    ],
    imports: [
        CommonModule,
        FormsModule,
        ArtifactsModule,
        SharedGenericModule,
        MJPageLayoutComponent,
        AddressEditorComponent,
        ContactMethodListComponent,
        RelationshipListComponent,
        BizAppsTasksModule,
        MinuteDocumentViewerComponent,
        CommitteeArtifactPreviewComponent,
    ],
    exports: [
        CommitteeDashboardComponent,
        CommitteeListComponent,
        CommitteeEditDialogComponent,
        MeetingListComponent,
        MeetingEditDialogComponent,
        TaskTrackerComponent,
        DocumentBrowserComponent,
        DocumentEditDialogComponent,
        DocumentPreviewPanelComponent,
        PersonPickerComponent,
        CommentThreadComponent,
        AgendaItemEditDialogComponent,
        MotionEditDialogComponent,
        TermEditDialogComponent,
        MembershipListComponent,
        MembershipPanelComponent,
        MembershipEditDialogComponent,
        PersonDetailPanelComponent,
        GenerateMinutesPanelComponent,
        MeetingDetailViewComponent,
        ManagementCommitteeListComponent,
        ManagementMembershipListComponent,
        BulkImportPanelComponent,
        CommandCenterComponent,
        CommitteeWorkspaceComponent,
        MotionsBallotsComponent,
        LiveMeetingComponent,
        MinutesReviewComponent,
        PeopleTermsComponent,
        MemberHomeComponent,
        MinuteDocumentViewerComponent,
        CommitteeArtifactPreviewComponent,
    ]
})
export class CommitteesModule { }

/** Tree-shaking prevention — retains all resources, generated entity forms, and custom form panels. */
export function LoadCommitteesModule(): void {
    void GeneratedFormsModule;
    void GENERATED_FORM_COMPONENTS;
    void CustomFormsModule;
    void MinuteDocumentViewerComponent;
    void CommitteeArtifactPreviewComponent;
    LoadCustomFormsModule();
    LoadBizAppsTasksClient();
    LoadCommitteeDashboard();
    LoadCommitteeList();
    LoadCommitteeEditDialog();
    LoadMeetingList();
    LoadMeetingEditDialog();
    LoadTaskTracker();
    LoadDocumentBrowser();
    LoadDocumentEditDialog();
    LoadDocumentPreviewPanel();
    LoadCommentThread();
    LoadAgendaItemEditDialog();
    LoadMotionEditDialog();
    LoadTermEditDialog();
    LoadMembershipList();
    LoadMembershipPanel();
    LoadMembershipEditDialog();
    LoadPersonDetailPanel();
    LoadGenerateMinutesPanel();
    LoadMeetingDetailView();
    LoadManagementCommitteeList();
    LoadManagementMembershipList();
    LoadBulkImportPanelComponent();
    LoadCommandCenter();
    LoadCommitteeWorkspace();
    LoadMotionsBallots();
    LoadLiveMeeting();
    LoadMinutesReview();
    LoadPeopleTerms();
    LoadMemberHome();
}

/** Alias matching the mj-app.json manifest startupExport convention */
export const LoadCommitteesClient = LoadCommitteesModule;
