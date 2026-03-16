import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { RunView } from '@memberjunction/core';
import { CommitteeDialogResult } from './committee-edit-dialog.component';

@RegisterClass(BaseResourceComponent, 'CommitteeListComponent')
@Component({
    standalone: false,
    selector: 'committees-list',
    templateUrl: './committee-list.component.html',
    styleUrls: ['./committee-list.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class CommitteeListComponent extends BaseResourceComponent implements OnInit {
    Committees: Record<string, unknown>[] = [];
    FilteredCommittees: Record<string, unknown>[] = [];
    IsLoading = true;
    SearchText = '';
    StatusFilter: 'All' | 'Active' | 'Inactive' = 'Active';

    /** Dialog state */
    ShowEditDialog = false;
    EditingCommitteeID: string | null = null;

    private cdr = inject(ChangeDetectorRef);

    async ngOnInit(): Promise<void> {
        this.NotifyLoadStarted();
        await this.LoadCommittees();
        this.IsLoading = false;
        this.NotifyLoadComplete();
        this.cdr.markForCheck();
    }

    async GetResourceDisplayName(_data: ResourceData): Promise<string> {
        return 'Committees';
    }

    async GetResourceIconClass(_data: ResourceData): Promise<string> {
        return 'fa-solid fa-users-rectangle';
    }

    OnSearchChanged(text: string): void {
        this.SearchText = text;
        this.ApplyFilters();
    }

    OnStatusFilterChanged(status: 'All' | 'Active' | 'Inactive'): void {
        this.StatusFilter = status;
        this.ApplyFilters();
    }

    OnCreateCommittee(): void {
        this.EditingCommitteeID = null;
        this.ShowEditDialog = true;
        this.cdr.markForCheck();
    }

    OnEditCommittee(committeeID: string): void {
        this.EditingCommitteeID = committeeID;
        this.ShowEditDialog = true;
        this.cdr.markForCheck();
    }

    async OnDialogClosed(result: CommitteeDialogResult): Promise<void> {
        this.ShowEditDialog = false;
        if (result.Saved) {
            await this.LoadCommittees();
        }
        this.cdr.markForCheck();
    }

    private ApplyFilters(): void {
        let result = this.Committees;
        if (this.StatusFilter !== 'All') {
            result = result.filter(c => c['Status'] === this.StatusFilter);
        }
        if (this.SearchText.trim()) {
            const term = this.SearchText.toLowerCase();
            result = result.filter(c =>
                (c['Name'] as string || '').toLowerCase().includes(term) ||
                (c['Description'] as string || '').toLowerCase().includes(term)
            );
        }
        this.FilteredCommittees = result;
        this.cdr.markForCheck();
    }

    private async LoadCommittees(): Promise<void> {
        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'Committees',
            ExtraFilter: '',
            Fields: ['ID', 'Name', 'Description', 'Type', 'Status', 'ParentCommittee', 'Organization', 'MemberCount'],
            OrderBy: 'Name ASC',
            ResultType: 'simple'
        });
        if (result.Success) {
            this.Committees = result.Results;
            this.ApplyFilters();
        }
    }
}

export function LoadCommitteeList() { }
