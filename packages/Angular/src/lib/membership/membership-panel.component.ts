import { Component, Input, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { Metadata, RunView } from '@memberjunction/core';
import { MembershipDialogResult } from './membership-edit-dialog.component';

export interface CommitteePermissions {
    IsMember: boolean;
    IsOfficer: boolean;
    CanManageMembers: boolean;
    CanView: boolean;
}

@Component({
    standalone: false,
    selector: 'committees-membership-panel',
    templateUrl: './membership-panel.component.html',
    styleUrls: ['./membership-panel.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class MembershipPanelComponent {
    Memberships: Record<string, unknown>[] = [];
    Terms: { ID: string; Name: string; Status: string }[] = [];
    SelectedTermID: string | null = null;
    IsLoading = true;
    Permissions: CommitteePermissions = { IsMember: false, IsOfficer: false, CanManageMembers: false, CanView: false };

    ShowEditDialog = false;
    EditingMembershipID: string | null = null;

    private cdr = inject(ChangeDetectorRef);

    private _CommitteeID: string | null = null;

    @Input()
    set CommitteeID(value: string | null) {
        const prev = this._CommitteeID;
        this._CommitteeID = value;
        if (value && value !== prev) this.OnCommitteeChanged();
    }
    get CommitteeID(): string | null { return this._CommitteeID; }

    get FilteredMemberships(): Record<string, unknown>[] {
        if (!this.SelectedTermID) return this.Memberships;
        return this.Memberships.filter(m => m['TermID'] === this.SelectedTermID);
    }

    get ActiveCount(): number {
        return this.FilteredMemberships.filter(m => m['Status'] === 'Active').length;
    }

    OnTermFilterChanged(termID: string | null): void {
        this.SelectedTermID = termID;
        this.cdr.markForCheck();
    }

    OnCreateMembership(): void {
        if (!this.Permissions.CanManageMembers) return;
        this.EditingMembershipID = null;
        this.ShowEditDialog = true;
        this.cdr.markForCheck();
    }

    OnEditMembership(membershipID: string): void {
        if (!this.Permissions.CanManageMembers) return;
        this.EditingMembershipID = membershipID;
        this.ShowEditDialog = true;
        this.cdr.markForCheck();
    }

    async OnDialogClosed(result: MembershipDialogResult): Promise<void> {
        this.ShowEditDialog = false;
        if (result.Saved) {
            await this.LoadMemberships();
        }
        this.cdr.markForCheck();
    }

    GetStatusClass(status: string): string {
        return 'status-badge status-' + (status || '').toLowerCase();
    }

    GetRoleIcon(role: string): string {
        switch (role) {
            case 'Chair': return 'fa-solid fa-crown';
            case 'Vice Chair': return 'fa-solid fa-star';
            case 'Secretary': return 'fa-solid fa-pen-nib';
            default: return 'fa-solid fa-user';
        }
    }

    private async OnCommitteeChanged(): Promise<void> {
        this.IsLoading = true;
        this.SelectedTermID = null;
        this.cdr.markForCheck();

        await this.LoadTerms();
        await Promise.all([
            this.LoadMemberships(),
            this.LoadUserPermissions()
        ]);

        this.IsLoading = false;
        this.cdr.markForCheck();
    }

    private async LoadUserPermissions(): Promise<void> {
        const md = new Metadata();
        const userID = md.CurrentUser?.ID;
        if (!userID || !this.CommitteeID) {
            this.Permissions = { IsMember: false, IsOfficer: false, CanManageMembers: false, CanView: false };
            return;
        }

        // Resolve User → Person
        const rv = new RunView();
        const personResult = await rv.RunView<{ ID: string }>({
            EntityName: 'MJ.BizApps.Common: People',
            ExtraFilter: `LinkedUserID = '${userID}'`,
            Fields: ['ID'],
            MaxRows: 1,
            ResultType: 'simple'
        });

        if (!personResult.Success || !personResult.Results || personResult.Results.length === 0) {
            this.Permissions = { IsMember: false, IsOfficer: false, CanManageMembers: false, CanView: false };
            return;
        }

        const personID = personResult.Results[0].ID;

        // Find active membership for this person in this committee's terms
        // (Terms are already loaded or loading in parallel)
        // We need the terms loaded first, so this runs after LoadTerms via Promise.all
        await this.resolvePermissionsForPerson(personID);
    }

    private async resolvePermissionsForPerson(personID: string): Promise<void> {
        if (this.Terms.length === 0) {
            this.Permissions = { IsMember: false, IsOfficer: false, CanManageMembers: false, CanView: false };
            return;
        }

        const termIDs = this.Terms.map(t => `'${t.ID}'`).join(',');
        const rv = new RunView();

        // Get ALL active memberships for this person in this committee's terms
        const memberResult = await rv.RunView<{ RoleID: string }>({
            EntityName: 'Memberships',
            ExtraFilter: `PersonID = '${personID}' AND TermID IN (${termIDs}) AND Status = 'Active'`,
            Fields: ['RoleID'],
            ResultType: 'simple'
        });

        if (!memberResult.Success || !memberResult.Results || memberResult.Results.length === 0) {
            this.Permissions = { IsMember: false, IsOfficer: false, CanManageMembers: false, CanView: false };
            return;
        }

        // Get all unique role IDs and check if any are officer roles
        const roleIDs = [...new Set(memberResult.Results.map(m => m.RoleID))];
        const roleIDsStr = roleIDs.map(id => `'${id}'`).join(',');

        const roleResult = await rv.RunView<{ ID: string; IsOfficer: boolean | number }>({
            EntityName: 'Roles',
            ExtraFilter: `ID IN (${roleIDsStr})`,
            Fields: ['ID', 'IsOfficer'],
            ResultType: 'simple'
        });

        const isOfficer = roleResult.Success && roleResult.Results
            ? roleResult.Results.some(r => r.IsOfficer === true || r.IsOfficer === 1)
            : false;

        this.Permissions = {
            IsMember: true,
            IsOfficer: isOfficer,
            CanManageMembers: isOfficer,
            CanView: true,
        };
    }

    private async LoadTerms(): Promise<void> {
        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'Terms',
            Fields: ['ID', 'Name', 'Status'],
            ExtraFilter: `CommitteeID = '${this.CommitteeID}'`,
            OrderBy: 'StartDate DESC',
            ResultType: 'simple'
        });
        if (result.Success) {
            this.Terms = result.Results as { ID: string; Name: string; Status: string }[];
        }
    }

    private RoleSequenceMap = new Map<string, number>();

    private async LoadMemberships(): Promise<void> {
        if (this.Terms.length === 0) {
            this.Memberships = [];
            return;
        }

        const termIDs = this.Terms.map(t => `'${t.ID}'`).join(',');
        const rv = new RunView();
        const [membershipsResult, rolesResult] = await rv.RunViews([
            {
                EntityName: 'Memberships',
                Fields: ['ID', 'PersonID', 'Person', 'RoleID', 'Role', 'TermID', 'Term', 'StartDate', 'EndDate', 'Status'],
                ExtraFilter: `TermID IN (${termIDs})`,
                OrderBy: 'Person ASC',
                ResultType: 'simple'
            },
            {
                EntityName: 'Roles',
                Fields: ['ID', 'Sequence'],
                OrderBy: 'Sequence ASC',
                ResultType: 'simple'
            }
        ]);

        if (rolesResult.Success) {
            this.RoleSequenceMap.clear();
            for (const r of rolesResult.Results as { ID: string; Sequence: number }[]) {
                this.RoleSequenceMap.set(r.ID, r.Sequence);
            }
        }

        if (membershipsResult.Success) {
            this.Memberships = membershipsResult.Results.sort((a: Record<string, unknown>, b: Record<string, unknown>) => {
                const seqA = this.RoleSequenceMap.get(a['RoleID'] as string) ?? 999;
                const seqB = this.RoleSequenceMap.get(b['RoleID'] as string) ?? 999;
                if (seqA !== seqB) return seqA - seqB;
                return ((a['Person'] as string) || '').localeCompare((b['Person'] as string) || '');
            });
        }
    }
}

export function LoadMembershipPanel() { }
