import { Component, EventEmitter, Input, Output, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { Metadata, RunView } from '@memberjunction/core';
import { mjCommitteesActionItemEntity } from '@mj-biz-apps/committees-entities';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';

export interface ActionItemDialogResult {
    Saved: boolean;
    ActionItem: mjCommitteesActionItemEntity | null;
}

@Component({
    standalone: false,
    selector: 'action-item-edit-dialog',
    templateUrl: './action-item-edit-dialog.component.html',
    styleUrls: ['./action-item-edit-dialog.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class ActionItemEditDialogComponent implements OnInit {
    @Input() ActionItemID: string | null = null;
    @Output() DialogClosed = new EventEmitter<ActionItemDialogResult>();

    ActionItem: mjCommitteesActionItemEntity | null = null;
    IsLoading = true;
    IsSaving = false;
    ErrorMessage = '';
    ShowCancelConfirm = false;

    /** Lookup data */
    Committees: { ID: string; Name: string }[] = [];
    Meetings: { ID: string; Title: string }[] = [];
    AllPeople: { ID: string; DisplayName: string }[] = [];

    /** Bound as string for <input type="date"> */
    DueDateLocal = '';

    readonly PriorityOptions: ('Critical' | 'High' | 'Medium' | 'Low')[] = ['Critical', 'High', 'Medium', 'Low'];
    readonly StatusOptions: ('Open' | 'InProgress' | 'Completed' | 'Blocked' | 'Cancelled')[] =
        ['Open', 'InProgress', 'Completed', 'Blocked', 'Cancelled'];

    private cdr = inject(ChangeDetectorRef);

    get IsNew(): boolean {
        return this.ActionItemID == null;
    }

    get DialogTitle(): string {
        return this.IsNew ? 'New Action Item' : 'Edit Action Item';
    }

    async ngOnInit(): Promise<void> {
        await Promise.all([
            this.LoadLookups(),
            this.LoadOrCreateActionItem()
        ]);
        this.IsLoading = false;
        this.cdr.markForCheck();
    }

    async OnSave(): Promise<void> {
        if (!this.ActionItem) return;

        const validationError = this.Validate();
        if (validationError) {
            this.ErrorMessage = validationError;
            this.cdr.markForCheck();
            return;
        }

        this.ActionItem.DueDate = this.DueDateLocal ? new Date(this.DueDateLocal + 'T00:00:00') : null;

        // Auto-set CompletedAt when marking as Completed
        if (this.ActionItem.Status === 'Completed' && !this.ActionItem.CompletedAt) {
            this.ActionItem.CompletedAt = new Date();
        } else if (this.ActionItem.Status !== 'Completed') {
            this.ActionItem.CompletedAt = null;
        }

        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.markForCheck();

        const success = await this.ActionItem.Save();
        this.IsSaving = false;

        if (success) {
            this.DialogClosed.emit({ Saved: true, ActionItem: this.ActionItem });
        } else {
            this.ErrorMessage = 'Failed to save action item. Please try again.';
            this.cdr.markForCheck();
        }
    }

    async OnCancelItem(): Promise<void> {
        if (!this.ActionItem || this.IsNew) return;

        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.markForCheck();

        this.ActionItem.Status = 'Cancelled';
        const success = await this.ActionItem.Save();
        this.IsSaving = false;

        if (success) {
            this.DialogClosed.emit({ Saved: true, ActionItem: this.ActionItem });
        } else {
            this.ErrorMessage = 'Failed to cancel action item. Please try again.';
            this.cdr.markForCheck();
        }
    }

    OnClose(): void {
        this.DialogClosed.emit({ Saved: false, ActionItem: null });
    }

    private Validate(): string | null {
        if (!this.ActionItem!.Title?.trim()) {
            return 'Title is required.';
        }
        if (!this.ActionItem!.CommitteeID) {
            return 'Please select a committee.';
        }
        if (!this.ActionItem!.AssignedToPersonID) {
            return 'Please assign this item to someone.';
        }
        return null;
    }

    private async LoadOrCreateActionItem(): Promise<void> {
        const md = new Metadata();
        if (this.IsNew) {
            this.ActionItem = await md.GetEntityObject<mjCommitteesActionItemEntity>('Action Items');
            this.ActionItem.Priority = 'Medium';
            this.ActionItem.Status = 'Open';
        } else {
            this.ActionItem = await md.GetEntityObject<mjCommitteesActionItemEntity>('Action Items');
            await this.ActionItem.Load(this.ActionItemID!);
            if (this.ActionItem.DueDate) {
                this.DueDateLocal = this.ToLocalDateString(this.ActionItem.DueDate);
            }
        }
    }

    private async LoadLookups(): Promise<void> {
        const rv = new RunView();
        const [committeesResult, meetingsResult, peopleResult] = await rv.RunViews([
            {
                EntityName: 'Committees',
                Fields: ['ID', 'Name'],
                ExtraFilter: "Status = 'Active'",
                OrderBy: 'Name ASC',
                ResultType: 'simple'
            },
            {
                EntityName: 'Meetings',
                Fields: ['ID', 'Title'],
                ExtraFilter: "Status NOT IN ('Cancelled')",
                OrderBy: 'StartDateTime DESC',
                MaxRows: 100,
                ResultType: 'simple'
            },
            {
                EntityName: 'MJ.BizApps.Common: People',
                Fields: ['ID', 'DisplayName'],
                OrderBy: 'DisplayName ASC',
                MaxRows: 500,
                ResultType: 'simple'
            }
        ]);

        const allCommittees = committeesResult.Success
            ? committeesResult.Results as { ID: string; Name: string }[]
            : [];

        const officerCommitteeIDs = await CommitteePermissionHelper.GetOfficerCommitteeIDs();
        this.Committees = officerCommitteeIDs.size > 0
            ? allCommittees.filter(c => officerCommitteeIDs.has(c.ID))
            : allCommittees;

        if (meetingsResult.Success) {
            this.Meetings = meetingsResult.Results as { ID: string; Title: string }[];
        }
        if (peopleResult.Success) {
            this.AllPeople = peopleResult.Results as { ID: string; DisplayName: string }[];
        }
    }


    private ToLocalDateString(date: Date): string {
        const d = new Date(date);
        return d.toISOString().split('T')[0];
    }
}

export function LoadActionItemEditDialog() { }
