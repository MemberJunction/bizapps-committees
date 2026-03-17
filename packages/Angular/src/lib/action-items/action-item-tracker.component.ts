import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { RunView } from '@memberjunction/core';
import { ActionItemDialogResult } from './action-item-edit-dialog.component';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';

@RegisterClass(BaseResourceComponent, 'ActionItemTrackerComponent')
@Component({
    standalone: false,
    selector: 'committees-action-items',
    templateUrl: './action-item-tracker.component.html',
    styleUrls: ['./action-item-tracker.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class ActionItemTrackerComponent extends BaseResourceComponent implements OnInit {
    ActionItems: Record<string, unknown>[] = [];
    FilteredItems: Record<string, unknown>[] = [];
    IsLoading = true;
    StatusFilter: 'All' | 'Open' | 'InProgress' | 'Completed' = 'Open';
    TodayString = new Date().toISOString().split('T')[0];

    /** Dialog state */
    ShowEditDialog = false;
    EditingActionItemID: string | null = null;

    /** Permission state */
    IsAnyOfficer = false;

    private cdr = inject(ChangeDetectorRef);

    async ngOnInit(): Promise<void> {
        this.NotifyLoadStarted();
        await Promise.all([
            this.LoadActionItems(),
            this.LoadPermissions()
        ]);
        this.IsLoading = false;
        this.NotifyLoadComplete();
        this.cdr.markForCheck();
    }

    async GetResourceDisplayName(_data: ResourceData): Promise<string> {
        return 'Action Items';
    }

    async GetResourceIconClass(_data: ResourceData): Promise<string> {
        return 'fa-solid fa-clipboard-list';
    }

    OnStatusFilterChanged(status: 'All' | 'Open' | 'InProgress' | 'Completed'): void {
        this.StatusFilter = status;
        this.ApplyFilters();
    }

    IsOverdue(item: Record<string, unknown>): boolean {
        const dueDate = item['DueDate'] as string | null;
        return dueDate != null && dueDate < this.TodayString && item['Status'] !== 'Completed';
    }

    GetPriorityClass(item: Record<string, unknown>): string {
        return 'priority-' + ((item['Priority'] as string || 'medium').toLowerCase());
    }

    OnCreateActionItem(): void {
        this.EditingActionItemID = null;
        this.ShowEditDialog = true;
        this.cdr.markForCheck();
    }

    OnEditActionItem(actionItemID: string): void {
        this.EditingActionItemID = actionItemID;
        this.ShowEditDialog = true;
        this.cdr.markForCheck();
    }

    async OnDialogClosed(result: ActionItemDialogResult): Promise<void> {
        this.ShowEditDialog = false;
        if (result.Saved) {
            await this.LoadActionItems();
        }
        this.cdr.markForCheck();
    }

    private async LoadPermissions(): Promise<void> {
        this.IsAnyOfficer = await CommitteePermissionHelper.IsOfficerInAny();
    }

    private ApplyFilters(): void {
        if (this.StatusFilter === 'All') {
            this.FilteredItems = this.ActionItems;
        } else {
            this.FilteredItems = this.ActionItems.filter(i => i['Status'] === this.StatusFilter);
        }
        this.cdr.markForCheck();
    }

    private async LoadActionItems(): Promise<void> {
        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'Action Items',
            ExtraFilter: '',
            Fields: ['ID', 'Title', 'Description', 'DueDate', 'Priority', 'Status', 'Committee', 'AssignedToPerson', 'Meeting'],
            OrderBy: 'DueDate ASC',
            MaxRows: 100,
            ResultType: 'simple'
        });
        if (result.Success) {
            this.ActionItems = result.Results;
            this.ApplyFilters();
        }
    }
}

export function LoadActionItemTracker() { }
