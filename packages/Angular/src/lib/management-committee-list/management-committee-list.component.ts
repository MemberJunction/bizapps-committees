import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { RunView } from '@memberjunction/core';
import { CommitteeDialogResult } from '../committee-list/committee-edit-dialog.component';

@RegisterClass(BaseResourceComponent, 'ManagementCommitteeListComponent')
@Component({
    standalone: false,
    selector: 'management-committee-list',
    templateUrl: './management-committee-list.component.html',
    styleUrls: ['../shared/design-system.css', '../committee-list/committee-list.component.css', './management-committee-list.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class ManagementCommitteeListComponent extends BaseResourceComponent implements OnInit {
    Committees: Record<string, unknown>[] = [];
    FilteredCommittees: Record<string, unknown>[] = [];
    IsLoading = true;
    SearchText = '';
    StatusFilter: 'All' | 'Active' | 'Inactive' | 'Dissolved' = 'Active';

    /** Dialog state */
    ShowEditDialog = false;
    EditingCommitteeID: string | null = null;

    /** Expanded committee for inline membership panel */
    ExpandedCommitteeID: string | null = null;

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

    OnStatusFilterChanged(status: 'All' | 'Active' | 'Inactive' | 'Dissolved'): void {
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

    OnToggleExpand(committeeID: string): void {
        this.ExpandedCommitteeID = this.ExpandedCommitteeID === committeeID ? null : committeeID;
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
        const [committeesResult, termsResult, membershipsResult] = await rv.RunViews([
            {
                EntityName: 'Committees',
                ExtraFilter: '',
                Fields: ['ID', 'Name', 'Description', 'Type', 'Status', 'ParentCommittee', 'Organization'],
                OrderBy: 'Name ASC',
                ResultType: 'simple'
            },
            {
                EntityName: 'Terms',
                Fields: ['ID', 'CommitteeID'],
                ResultType: 'simple'
            },
            {
                EntityName: 'Memberships',
                ExtraFilter: "Status = 'Active'",
                Fields: ['TermID'],
                ResultType: 'simple'
            }
        ]);

        if (committeesResult.Success) {
            const termToCommittee = new Map<string, string>();
            if (termsResult.Success) {
                for (const t of termsResult.Results as { ID: string; CommitteeID: string }[]) {
                    termToCommittee.set(t.ID, t.CommitteeID);
                }
            }

            const memberCounts = new Map<string, number>();
            if (membershipsResult.Success) {
                for (const m of membershipsResult.Results as { TermID: string }[]) {
                    const cid = termToCommittee.get(m.TermID);
                    if (cid) memberCounts.set(cid, (memberCounts.get(cid) ?? 0) + 1);
                }
            }

            this.Committees = committeesResult.Results.map((c: Record<string, unknown>) => ({
                ...c,
                MemberCount: memberCounts.get(c['ID'] as string) ?? 0
            }));
            this.ApplyFilters();
        }
    }
}

export function LoadManagementCommitteeList() { }
