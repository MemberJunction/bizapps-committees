import { Component, EventEmitter, Input, Output, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { Metadata, RunView } from '@memberjunction/core';
import { CommitteesLookupEngine } from '@mj-biz-apps/committees-core/lookup';
import { mjBizAppsCommitteesMembershipEntity } from '@mj-biz-apps/committees-entities';

export interface MembershipDialogResult {
    Saved: boolean;
    Membership: mjBizAppsCommitteesMembershipEntity | null;
}

interface TermLookup {
    ID: string;
    Name: string;
    Status: string;
    StartDate: string;
    EndDate: string | null;
}

@Component({
    standalone: false,
    selector: 'membership-edit-dialog',
    templateUrl: './membership-edit-dialog.component.html',
    styleUrls: ['../shared/design-system.css', '../shared/slide-panel.css', './membership-edit-dialog.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class MembershipEditDialogComponent implements OnInit {
    @Input() MembershipID: string | null = null;
    @Input() CommitteeID: string | null = null;
    @Output() DialogClosed = new EventEmitter<MembershipDialogResult>();

    Membership: mjBizAppsCommitteesMembershipEntity | null = null;
    IsLoading = true;
    IsSaving = false;
    ErrorMessage = '';
    ShowEndConfirm = false;
    SelectedPersonName = '';

    Roles: { ID: string; Name: string }[] = [];
    Terms: TermLookup[] = [];

    readonly StatusOptions = ['Active', 'Pending', 'Suspended', 'Ended'] as const;

    private cdr = inject(ChangeDetectorRef);

    get IsNew(): boolean {
        return this.MembershipID == null;
    }

    get DialogTitle(): string {
        return this.IsNew ? 'Add Member' : 'Edit Membership';
    }

    get ShowEndReason(): boolean {
        return this.Membership?.Status === 'Ended';
    }

    get SelectedTerm(): TermLookup | null {
        if (!this.Membership?.TermID) return null;
        return this.Terms.find(t => t.ID === this.Membership!.TermID) ?? null;
    }

    get TermDateRange(): string {
        const term = this.SelectedTerm;
        if (!term) return '';
        const start = new Date(term.StartDate).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
        const end = term.EndDate
            ? new Date(term.EndDate).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
            : 'Ongoing';
        return `${start} – ${end}`;
    }

    async ngOnInit(): Promise<void> {
        await this.loadLookups();
        await this.loadOrCreateMembership();
        this.IsLoading = false;
        this.cdr.markForCheck();
    }

    OnPersonSelected(event: { PersonID: string; DisplayName: string } | null): void {
        if (this.Membership && event) {
            this.Membership.PersonID = event.PersonID;
            this.SelectedPersonName = event.DisplayName;
            this.cdr.markForCheck();
        }
    }

    OnTermChanged(termID: string): void {
        if (!this.Membership) return;
        this.Membership.TermID = termID;
        this.applyTermDates();
        this.cdr.markForCheck();
    }

    async OnSave(): Promise<void> {
        if (!this.Membership) return;

        const validationError = this.validate();
        if (validationError) {
            this.ErrorMessage = validationError;
            this.cdr.markForCheck();
            return;
        }

        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.markForCheck();

        const success = await this.Membership.Save();
        this.IsSaving = false;

        if (success) {
            this.DialogClosed.emit({ Saved: true, Membership: this.Membership });
        } else {
            this.ErrorMessage = 'Failed to save membership. Please try again.';
            this.cdr.markForCheck();
        }
    }

    async OnEndMembership(): Promise<void> {
        if (!this.Membership || this.IsNew) return;

        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.markForCheck();

        this.Membership.Status = 'Ended';
        this.Membership.EndDate = new Date();
        const success = await this.Membership.Save();
        this.IsSaving = false;

        if (success) {
            this.DialogClosed.emit({ Saved: true, Membership: this.Membership });
        } else {
            this.ErrorMessage = 'Failed to end membership. Please try again.';
            this.cdr.markForCheck();
        }
    }

    OnClose(): void {
        this.DialogClosed.emit({ Saved: false, Membership: null });
    }

    private validate(): string | null {
        if (!this.Membership!.PersonID) {
            return 'Please select a person.';
        }
        if (!this.Membership!.RoleID) {
            return 'Please select a role.';
        }
        if (!this.Membership!.TermID) {
            return 'Please select a term.';
        }
        return null;
    }

    /** Sets membership start/end dates to match the selected term. */
    private applyTermDates(): void {
        const term = this.SelectedTerm;
        if (!term || !this.Membership) return;

        this.Membership.StartDate = new Date(term.StartDate);
        this.Membership.EndDate = term.EndDate ? new Date(term.EndDate) : null;
    }

    private async loadOrCreateMembership(): Promise<void> {
        const md = new Metadata();
        if (this.IsNew) {
            this.Membership = await md.GetEntityObject<mjBizAppsCommitteesMembershipEntity>('Committees: Memberships');
            this.Membership.Status = 'Active';
            // Pre-select active term and apply its dates
            const activeTerm = this.Terms.find(t => t.Status === 'Active');
            if (activeTerm) {
                this.Membership.TermID = activeTerm.ID;
                this.applyTermDates();
            }
        } else {
            this.Membership = await md.GetEntityObject<mjBizAppsCommitteesMembershipEntity>('Committees: Memberships');
            await this.Membership.Load(this.MembershipID!);
            await this.loadPersonName(this.Membership.PersonID);
        }
    }

    private async loadPersonName(personID: string | null): Promise<void> {
        if (!personID) return;
        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'MJ_BizApps_Common: People',
            ExtraFilter: `ID='${personID}'`,
            Fields: ['ID', 'DisplayName'],
            ResultType: 'simple',
        });
        if (result.Success && result.Results?.length) {
            this.SelectedPersonName = (result.Results[0] as { DisplayName: string }).DisplayName;
        }
    }

    private async loadLookups(): Promise<void> {
        // Roles come from the process-wide lookup engine — no per-open query.
        await CommitteesLookupEngine.Instance.Config();
        const rv = new RunView();
        const [termsResult] = await rv.RunViews([
            {
                EntityName: 'Committees: Terms',
                Fields: ['ID', 'Name', 'Status', 'StartDate', 'EndDate'],
                ExtraFilter: this.CommitteeID ? `CommitteeID = '${this.CommitteeID}'` : '',
                OrderBy: 'StartDate DESC',
                ResultType: 'simple'
            }
        ]);
        this.Roles = [...CommitteesLookupEngine.Instance.Roles]
            .sort((a, b) => (a.Sequence ?? 0) - (b.Sequence ?? 0))
            .map(r => ({ ID: r.ID, Name: r.Name }));
        if (termsResult.Success) {
            this.Terms = termsResult.Results as TermLookup[];
        }
    }
}

export function LoadMembershipEditDialog() { }
