import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { Metadata, RunView } from '@memberjunction/core';
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

    /** Permission state: committee IDs where the user is an officer */
    OfficerCommitteeIDs = new Set<string>();
    /** Committee IDs where the user is a member (any role) */
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

    private async LoadUserMemberships(): Promise<void> {
        const md = new Metadata();
        const userID = md.CurrentUser?.ID;
        if (!userID) return;

        const rv = new RunView();

        // Resolve User → Person
        const personResult = await rv.RunView<{ ID: string }>({
            EntityName: 'MJ.BizApps.Common: People',
            ExtraFilter: `LinkedUserID = '${userID}'`,
            Fields: ['ID'],
            MaxRows: 1,
            ResultType: 'simple'
        });

        if (!personResult.Success || !personResult.Results || personResult.Results.length === 0) return;
        const personID = personResult.Results[0].ID;

        // Get all active memberships for this person
        const memberResult = await rv.RunView<{ RoleID: string; TermID: string }>({
            EntityName: 'Memberships',
            ExtraFilter: `PersonID = '${personID}' AND Status = 'Active'`,
            Fields: ['RoleID', 'TermID'],
            ResultType: 'simple'
        });

        if (!memberResult.Success || !memberResult.Results || memberResult.Results.length === 0) return;

        // Resolve Term → Committee
        const termIDs = [...new Set(memberResult.Results.map(m => m.TermID))];
        const termIDsStr = termIDs.map(id => `'${id}'`).join(',');
        const termResult = await rv.RunView<{ ID: string; CommitteeID: string }>({
            EntityName: 'Terms',
            ExtraFilter: `ID IN (${termIDsStr})`,
            Fields: ['ID', 'CommitteeID'],
            ResultType: 'simple'
        });

        const termToCommittee = new Map<string, string>();
        if (termResult.Success && termResult.Results) {
            for (const t of termResult.Results) {
                termToCommittee.set(t.ID, t.CommitteeID);
            }
        }

        // Resolve which roles are officer roles
        const roleIDs = [...new Set(memberResult.Results.map(m => m.RoleID))];
        const roleIDsStr = roleIDs.map(id => `'${id}'`).join(',');
        const roleResult = await rv.RunView<{ ID: string; IsOfficer: boolean | number }>({
            EntityName: 'Roles',
            ExtraFilter: `ID IN (${roleIDsStr})`,
            Fields: ['ID', 'IsOfficer'],
            ResultType: 'simple'
        });

        const officerRoleIDs = new Set<string>();
        if (roleResult.Success && roleResult.Results) {
            for (const r of roleResult.Results) {
                if (r.IsOfficer === true || r.IsOfficer === 1) {
                    officerRoleIDs.add(r.ID);
                }
            }
        }

        // Build permission sets
        for (const m of memberResult.Results) {
            const committeeID = termToCommittee.get(m.TermID);
            if (!committeeID) continue;
            this.MemberCommitteeIDs.add(committeeID);
            if (officerRoleIDs.has(m.RoleID)) {
                this.OfficerCommitteeIDs.add(committeeID);
            }
        }
    }
}

export function LoadCommitteeList() { }
