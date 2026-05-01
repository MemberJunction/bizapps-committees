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
import { ManagementDashboardComponent, LoadManagementDashboard } from './management-dashboard/management-dashboard.component';
import { ManagementCommitteeListComponent, LoadManagementCommitteeList } from './management-committee-list/management-committee-list.component';
import { ManagementMembershipListComponent, LoadManagementMembershipList } from './management-membership-list/management-membership-list.component';
import { BulkImportPanelComponent, LoadBulkImportPanelComponent } from './bulk-import/bulk-import-panel.component';

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
        ManagementDashboardComponent,
        ManagementCommitteeListComponent,
        ManagementMembershipListComponent,
        BulkImportPanelComponent,
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
        ManagementDashboardComponent,
        ManagementCommitteeListComponent,
        ManagementMembershipListComponent,
        BulkImportPanelComponent,
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
    LoadManagementDashboard();
    LoadManagementCommitteeList();
    LoadManagementMembershipList();
    LoadBulkImportPanelComponent();
}

/** Alias matching the mj-app.json manifest startupExport convention */
export const LoadCommitteesClient = LoadCommitteesModule;
