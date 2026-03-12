import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

// Kendo UI modules
import { ButtonsModule } from '@progress/kendo-angular-buttons';
import { GridModule } from '@progress/kendo-angular-grid';
import { DropDownsModule } from '@progress/kendo-angular-dropdowns';
import { DateInputsModule } from '@progress/kendo-angular-dateinputs';
import { DialogsModule } from '@progress/kendo-angular-dialog';
import { InputsModule } from '@progress/kendo-angular-inputs';
import { LayoutModule } from '@progress/kendo-angular-layout';
import { LabelModule } from '@progress/kendo-angular-label';

// MJ shared modules
import { SharedGenericModule } from '@memberjunction/ng-shared-generic';

// Committees components
import { CommitteeDashboardComponent, LoadCommitteeDashboard } from './dashboard/committee-dashboard.component';
import { CommitteeListComponent, LoadCommitteeList } from './committee-list/committee-list.component';
import { MeetingListComponent, LoadMeetingList } from './meeting-list/meeting-list.component';
import { ActionItemTrackerComponent, LoadActionItemTracker } from './action-items/action-item-tracker.component';
import { DocumentBrowserComponent, LoadDocumentBrowser } from './documents/document-browser.component';
import { PersonPickerComponent } from './shared/person-picker.component';

@NgModule({
    declarations: [
        CommitteeDashboardComponent,
        CommitteeListComponent,
        MeetingListComponent,
        ActionItemTrackerComponent,
        DocumentBrowserComponent,
        PersonPickerComponent,
    ],
    imports: [
        CommonModule,
        FormsModule,
        ButtonsModule,
        GridModule,
        DropDownsModule,
        DateInputsModule,
        DialogsModule,
        InputsModule,
        LayoutModule,
        LabelModule,
        SharedGenericModule,
    ],
    exports: [
        CommitteeDashboardComponent,
        CommitteeListComponent,
        MeetingListComponent,
        ActionItemTrackerComponent,
        DocumentBrowserComponent,
        PersonPickerComponent,
    ]
})
export class CommitteesModule { }

/** Tree-shaking prevention — call from public-api.ts */
export function LoadCommitteesModule() {
    LoadCommitteeDashboard();
    LoadCommitteeList();
    LoadMeetingList();
    LoadActionItemTracker();
    LoadDocumentBrowser();
}
