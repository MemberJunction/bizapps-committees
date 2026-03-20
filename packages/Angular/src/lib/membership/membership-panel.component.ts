import { Component, Input, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { RunView } from '@memberjunction/core';
import { MembershipDialogResult } from './membership-edit-dialog.component';
import { TermDialogResult } from '../terms/term-edit-dialog.component';
import { CommitteePermissionHelper, CommitteePermissions } from '../shared/committee-permission-helper';

@Component({
    standalone: false,
    selector: 'committees-membership-panel',
    templateUrl: './membership-panel.component.html',
    styleUrls: ['../shared/design-system.css', './membership-panel.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class MembershipPanelComponent {
    Memberships: Record<string, unknown>[] = [];
    Terms: { ID: string; Name: string; Status: string }[] = [];
    SelectedTermID: string | null = null;
    IsLoading = true;
    Permissions: CommitteePermissions = { IsMember: false, IsOfficer: false, CanManageMembers: false, CanManageMeetings: false, CanEditCommittee: false, CanView: false };

    ShowEditDialog = false;
    EditingMembershipID: string | null = null;

    ShowTermDialog = false;
    EditingTermID: string | null = null;

    ShowPersonPanel = false;
    ViewingPersonID: string | null = null;
    CurrentUserPersonID: string | null = null;

    private cdr = inject(ChangeDetectorRef);
    private RoleSequenceMap = new Map<string, number>();

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

    OnEditMembership(membershipID: string, event: Event): void {
        event.stopPropagation();
        if (!this.Permissions.CanManageMembers) return;
        this.EditingMembershipID = membershipID;
        this.ShowEditDialog = true;
        this.cdr.markForCheck();
    }

    OnViewPerson(personID: string): void {
        this.ViewingPersonID = personID;
        this.ShowPersonPanel = true;
        this.cdr.markForCheck();
    }

    OnPersonPanelClosed(): void {
        this.ShowPersonPanel = false;
        this.ViewingPersonID = null;
        this.cdr.markForCheck();
    }

    async OnDialogClosed(result: MembershipDialogResult): Promise<void> {
        this.ShowEditDialog = false;
        if (result.Saved) {
            CommitteePermissionHelper.ClearCache();
            await this.LoadMemberships();
            this.SuccessMessage = this.EditingMembershipID ? 'Membership updated.' : 'Member added.';
            this.ClearSuccessAfterDelay();
        }
        this.cdr.markForCheck();
    }

    OnCreateTerm(): void {
        if (!this.Permissions.IsOfficer) return;
        this.EditingTermID = null;
        this.ShowTermDialog = true;
        this.cdr.markForCheck();
    }

    OnEditTerm(termID: string): void {
        if (!this.Permissions.IsOfficer) return;
        this.EditingTermID = termID;
        this.ShowTermDialog = true;
        this.cdr.markForCheck();
    }

    SuccessMessage = '';

    async OnTermDialogClosed(result: TermDialogResult): Promise<void> {
        this.ShowTermDialog = false;
        if (result.Saved) {
            const isDelete = result.Term == null;
            await this.LoadTerms();
            await this.LoadMemberships();

            if (isDelete) {
                this.SelectedTermID = null;
                this.SuccessMessage = 'Term deleted.';
            } else {
                this.SelectedTermID = result.Term!.ID;
                this.SuccessMessage = this.EditingTermID ? 'Term updated.' : 'Term created.';
            }
            this.ClearSuccessAfterDelay();
        }
        this.cdr.markForCheck();
    }

    private ClearSuccessAfterDelay(): void {
        setTimeout(() => {
            this.SuccessMessage = '';
            this.cdr.markForCheck();
        }, 3000);
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
            this.LoadUserPermissions(),
            this.LoadCurrentUserPersonID()
        ]);

        this.IsLoading = false;
        this.cdr.markForCheck();
    }

    private async LoadCurrentUserPersonID(): Promise<void> {
        this.CurrentUserPersonID = await CommitteePermissionHelper.GetCurrentPersonID();
    }

    private async LoadUserPermissions(): Promise<void> {
        if (!this.CommitteeID) {
            this.Permissions = { IsMember: false, IsOfficer: false, CanManageMembers: false, CanManageMeetings: false, CanEditCommittee: false, CanView: false };
            return;
        }
        this.Permissions = await CommitteePermissionHelper.GetPermissionsForCommittee(this.CommitteeID);
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
                ExtraFilter: `TermID IN (${termIDs}) AND Status != 'Ended'`,
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
            await this.LoadPersonContactData();
        }
    }

    /** Batch-loads primary Email and Phone from Contact Methods and merges onto membership records. */
    private async LoadPersonContactData(): Promise<void> {
        const personIDs = [...new Set(
            this.Memberships.map(m => m['PersonID'] as string).filter(Boolean)
        )];
        if (personIDs.length === 0) return;

        const rv = new RunView();
        const result = await rv.RunView<{ PersonID: string; Value: string; ContactType: string; IsPrimary: boolean }>({
            EntityName: 'MJ.BizApps.Common: Contact Methods',
            ExtraFilter: `PersonID IN (${personIDs.map(id => `'${id}'`).join(',')}) AND IsPrimary = 1`,
            Fields: ['PersonID', 'Value', 'ContactType', 'IsPrimary'],
            ResultType: 'simple'
        });

        if (!result.Success) return;

        const contactMap = new Map<string, { Email: string | null; Phone: string | null }>();
        for (const cm of result.Results) {
            const type = (cm.ContactType || '').toLowerCase();
            if (!contactMap.has(cm.PersonID)) {
                contactMap.set(cm.PersonID, { Email: null, Phone: null });
            }
            const entry = contactMap.get(cm.PersonID)!;
            if (type === 'email' && !entry.Email) entry.Email = cm.Value;
            else if ((type === 'phone' || type === 'mobile' || type === 'work phone') && !entry.Phone) entry.Phone = cm.Value;
        }

        this.Memberships = this.Memberships.map(m => ({
            ...m,
            PersonEmail: contactMap.get(m['PersonID'] as string)?.Email ?? null,
            PersonPhone: contactMap.get(m['PersonID'] as string)?.Phone ?? null,
        }));
    }
}

export function LoadMembershipPanel() { }
