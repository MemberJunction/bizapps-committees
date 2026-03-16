import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

// MJ shared modules
import { SharedGenericModule } from '@memberjunction/ng-shared-generic';

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
import { PersonPickerComponent } from './shared/person-picker.component';
import { CommentThreadComponent, LoadCommentThread } from './comments/comment-thread.component';

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
        PersonPickerComponent,
        CommentThreadComponent,
    ],
    imports: [
        CommonModule,
        FormsModule,
        SharedGenericModule,
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
        PersonPickerComponent,
        CommentThreadComponent,
    ]
})
export class CommitteesModule { }

/** Tree-shaking prevention — call from public-api.ts */
export function LoadCommitteesModule() {
    LoadCommitteeDashboard();
    LoadCommitteeList();
    LoadCommitteeEditDialog();
    LoadMeetingList();
    LoadMeetingEditDialog();
    LoadActionItemTracker();
    LoadActionItemEditDialog();
    LoadDocumentBrowser();
    LoadDocumentEditDialog();
    LoadCommentThread();
}
