import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { RunView } from '@memberjunction/core';
import { CommitteeDialogResult } from './committee-edit-dialog.component';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';

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

    /** Permission state */
    OfficerCommitteeIDs = new Set<string>();
    MemberCommitteeIDs = new Set<string>();

    private cdr = inject(ChangeDetectorRef);

    async ngOnInit(): Promise<void> {
        this.NotifyLoadStarted();
        await Promise.all([
            this.LoadCommittees(),
            this.LoadUserMemberships()
        ]);
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

    IsOfficerOf(committeeID: string): boolean {
        return this.OfficerCommitteeIDs.has(committeeID);
    }

    IsMemberOf(committeeID: string): boolean {
        return this.MemberCommitteeIDs.has(committeeID);
    }

    OnCreateCommittee(): void {
        this.EditingCommitteeID = null;
        this.ShowEditDialog = true;
        this.cdr.markForCheck();
    }

    OnEditCommittee(committeeID: string): void {
        if (!this.IsMemberOf(committeeID)) return;
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
            // Build term → committee map
            const termToCommittee = new Map<string, string>();
            if (termsResult.Success) {
                for (const t of termsResult.Results as { ID: string; CommitteeID: string }[]) {
                    termToCommittee.set(t.ID, t.CommitteeID);
                }
            }

            // Count active memberships per committee
            const memberCounts = new Map<string, number>();
            if (membershipsResult.Success) {
                for (const m of membershipsResult.Results as { TermID: string }[]) {
                    const cid = termToCommittee.get(m.TermID);
                    if (cid) memberCounts.set(cid, (memberCounts.get(cid) ?? 0) + 1);
                }
            }

            // Attach count to each committee
            this.Committees = committeesResult.Results.map((c: Record<string, unknown>) => ({
                ...c,
                MemberCount: memberCounts.get(c['ID'] as string) ?? 0
            }));
            this.ApplyFilters();
        }
    }

    private async LoadUserMemberships(): Promise<void> {
        this.OfficerCommitteeIDs = await CommitteePermissionHelper.GetOfficerCommitteeIDs();
        this.MemberCommitteeIDs = await CommitteePermissionHelper.GetMemberCommitteeIDs();
    }
}

export function LoadCommitteeList() { }
