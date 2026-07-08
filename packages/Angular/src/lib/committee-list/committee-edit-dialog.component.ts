import { UUIDsEqual } from '@memberjunction/global';
import { Component, EventEmitter, Input, Output, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { Metadata, RunView } from '@memberjunction/core';
import { CommitteesLookupEngine } from '@mj-biz-apps/committees-core/lookup';
import { mjBizAppsCommitteesCommitteeEntity } from '@mj-biz-apps/committees-entities';

export interface CommitteeDialogResult {
    Saved: boolean;
    Committee: mjBizAppsCommitteesCommitteeEntity | null;
}

@Component({
    standalone: false,
    selector: 'committee-edit-dialog',
    templateUrl: './committee-edit-dialog.component.html',
    styleUrls: ['../shared/design-system.css', '../shared/slide-panel.css', './committee-edit-dialog.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class CommitteeEditDialogComponent implements OnInit {
    @Input() CommitteeID: string | null = null;
    @Input() ReadOnly = false;
    @Output() DialogClosed = new EventEmitter<CommitteeDialogResult>();

    Committee: mjBizAppsCommitteesCommitteeEntity | null = null;
    IsLoading = true;
    IsSaving = false;
    ErrorMessage = '';

    /** Lookup data for dropdowns */
    Types: { ID: string; Name: string }[] = [];
    Organizations: { ID: string; Name: string }[] = [];
    ParentCommittees: { ID: string; Name: string }[] = [];

    readonly StatusOptions: ('Active' | 'Inactive' | 'Pending' | 'Dissolved')[] = ['Active', 'Inactive', 'Pending', 'Dissolved'];

    private cdr = inject(ChangeDetectorRef);

    get IsNew(): boolean {
        return this.CommitteeID == null;
    }

    get DialogTitle(): string {
        return this.IsNew ? 'New Committee' : 'Edit Committee';
    }

    async ngOnInit(): Promise<void> {
        await Promise.all([
            this.loadLookups(),
            this.loadOrCreateCommittee()
        ]);
        this.IsLoading = false;
        this.cdr.markForCheck();
    }

    async OnSave(): Promise<void> {
        if (!this.Committee) return;

        if (!this.Committee.Name?.trim()) {
            this.ErrorMessage = 'Committee name is required.';
            this.cdr.markForCheck();
            return;
        }

        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.markForCheck();

        const success = await this.Committee.Save();
        this.IsSaving = false;

        if (success) {
            this.DialogClosed.emit({ Saved: true, Committee: this.Committee });
        } else {
            this.ErrorMessage = 'Failed to save committee. Please try again.';
            this.cdr.markForCheck();
        }
    }

    async OnDissolve(): Promise<void> {
        if (!this.Committee || this.IsNew) return;

        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.markForCheck();

        this.Committee.Status = 'Dissolved';
        const success = await this.Committee.Save();
        this.IsSaving = false;

        if (success) {
            this.DialogClosed.emit({ Saved: true, Committee: this.Committee });
        } else {
            this.ErrorMessage = 'Failed to dissolve committee. Please try again.';
            this.cdr.markForCheck();
        }
    }

    ShowDissolveConfirm = false;

    OnCancel(): void {
        this.DialogClosed.emit({ Saved: false, Committee: null });
    }

    OnTypeChanged(typeID: string | null): void {
        if (this.Committee) {
            this.Committee.TypeID = typeID!;
        }
    }

    OnOrganizationChanged(orgID: string | null): void {
        if (this.Committee) {
            this.Committee.OrganizationID = orgID ?? null;
        }
    }

    OnParentCommitteeChanged(parentID: string | null): void {
        if (this.Committee) {
            this.Committee.ParentCommitteeID = parentID ?? null;
        }
    }

    private async loadOrCreateCommittee(): Promise<void> {
        const md = new Metadata();
        if (this.IsNew) {
            this.Committee = await md.GetEntityObject<mjBizAppsCommitteesCommitteeEntity>('Committees: Committees');
            this.Committee.Status = 'Active';
            this.Committee.IsPublic = true;
        } else {
            this.Committee = await md.GetEntityObject<mjBizAppsCommitteesCommitteeEntity>('Committees: Committees');
            await this.Committee.Load(this.CommitteeID!);
        }
    }

    private async loadLookups(): Promise<void> {
        // Types come from the process-wide lookup engine — no per-open query.
        await CommitteesLookupEngine.Instance.Config();
        const rv = new RunView();
        const [orgsResult, committeesResult] = await rv.RunViews([
            {
                EntityName: 'MJ_BizApps_Common: Organizations',
                Fields: ['ID', 'Name'],
                OrderBy: 'Name ASC',
                ResultType: 'simple'
            },
            {
                EntityName: 'Committees: Committees',
                Fields: ['ID', 'Name'],
                OrderBy: 'Name ASC',
                ResultType: 'simple'
            }
        ]);

        {
            this.Types = [...CommitteesLookupEngine.Instance.CommitteeTypes]
                .sort((a, b) => a.Name.localeCompare(b.Name))
                .map(t => ({ ID: t.ID, Name: t.Name }));
        }
        if (orgsResult.Success) {
            this.Organizations = orgsResult.Results as { ID: string; Name: string }[];
        }
        if (committeesResult.Success) {
            // Filter out the current committee (can't be its own parent)
            this.ParentCommittees = (committeesResult.Results as { ID: string; Name: string }[])
                .filter(c => !UUIDsEqual(c.ID, this.CommitteeID));
        }
    }
}

export function LoadCommitteeEditDialog() { }
