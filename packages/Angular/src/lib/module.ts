import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

// MJ shared modules
import { SharedGenericModule } from '@memberjunction/ng-shared-generic';

// BizAppsCommon reusable components
import { AddressEditorComponent, ContactMethodListComponent, RelationshipListComponent } from '@mj-biz-apps/common-ng';

// BizAppsTasks reusable components
import { BizAppsTasksModule, LoadBizAppsTasksClient } from '@mj-biz-apps/tasks-ng';

// Committees components
import { CommitteeDashboardComponent, LoadCommitteeDashboard } from './dashboard/committee-dashboard.component';
import { CommitteeListComponent, LoadCommitteeList } from './committee-list/committee-list.component';
import { CommitteeEditDialogComponent, LoadCommitteeEditDialog } from './committee-list/committee-edit-dialog.component';
import { MeetingListComponent, LoadMeetingList } from './meeting-list/meeting-list.component';
import { MeetingEditDialogComponent, LoadMeetingEditDialog } from './meeting-list/meeting-edit-dialog.component';
import { ActionItemTrackerComponent, LoadActionItemTracker } from './action-items/action-item-tracker.component';
import { ActionItemEditDialogComponent, LoadActionItemEditDialog } from './action-items/action-item-edit-dialog.component';
import { DocumentBrowserComponent, LoadDocumentBrowser } from './documents/document-browser.component';
import { DocumentEditDialogComponent, LoadDocumentEditDialog } from './documents/document-edit-dialog.component';
import { DocumentPreviewPanelComponent, LoadDocumentPreviewPanel } from './documents/document-preview-panel.component';
import { PersonPickerComponent } from './shared/person-picker.component';
import { CommentThreadComponent, LoadCommentThread } from './comments/comment-thread.component';
import { AgendaItemEditDialogComponent, LoadAgendaItemEditDialog } from './agenda/agenda-item-edit-dialog.component';
import { MotionEditDialogComponent, LoadMotionEditDialog } from './motions/motion-edit-dialog.component';
import { MeetingLiveViewComponent, LoadMeetingLiveView } from './meeting-live/meeting-live-view.component';
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
import { MemberHomeComponent, LoadMemberHome } from './member-home/member-home.component';

@NgModule({
    declarations: [
        CommitteeDashboardComponent,
        CommitteeListComponent,
        CommitteeEditDialogComponent,
        MeetingListComponent,
        MeetingEditDialogComponent,
        ActionItemTrackerComponent,
        ActionItemEditDialogComponent,
        DocumentBrowserComponent,
        DocumentEditDialogComponent,
        DocumentPreviewPanelComponent,
        PersonPickerComponent,
        CommentThreadComponent,
        AgendaItemEditDialogComponent,
        MotionEditDialogComponent,
        MeetingLiveViewComponent,
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
        MemberHomeComponent,
    ],
    imports: [
        CommonModule,
        FormsModule,
        SharedGenericModule,
        AddressEditorComponent,
        ContactMethodListComponent,
        RelationshipListComponent,
        BizAppsTasksModule,
    ],
    exports: [
        CommitteeDashboardComponent,
        CommitteeListComponent,
        CommitteeEditDialogComponent,
        MeetingListComponent,
        MeetingEditDialogComponent,
        ActionItemTrackerComponent,
        ActionItemEditDialogComponent,
        DocumentBrowserComponent,
        DocumentEditDialogComponent,
        DocumentPreviewPanelComponent,
        PersonPickerComponent,
        CommentThreadComponent,
        AgendaItemEditDialogComponent,
        MotionEditDialogComponent,
        MeetingLiveViewComponent,
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
    ]
})
export class CommitteesModule { }

/** Tree-shaking prevention — call from public-api.ts */
export function LoadCommitteesModule() {
    LoadBizAppsTasksClient();
    LoadCommitteeDashboard();
    LoadCommitteeList();
    LoadCommitteeEditDialog();
    LoadMeetingList();
    LoadMeetingEditDialog();
    LoadActionItemTracker();
    LoadActionItemEditDialog();
    LoadDocumentBrowser();
    LoadDocumentEditDialog();
    LoadDocumentPreviewPanel();
    LoadCommentThread();
    LoadAgendaItemEditDialog();
    LoadMotionEditDialog();
    LoadMeetingLiveView();
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
