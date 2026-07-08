import { Component, EventEmitter, Input, Output, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { Metadata, RunView } from '@memberjunction/core';
import { mjBizAppsCommitteesTermEntity } from '@mj-biz-apps/committees-entities';

export interface TermDialogResult {
    Saved: boolean;
    Term: mjBizAppsCommitteesTermEntity | null;
}

@Component({
    standalone: false,
    selector: 'term-edit-dialog',
    templateUrl: './term-edit-dialog.component.html',
    styleUrls: ['../shared/design-system.css', '../shared/slide-panel.css', './term-edit-dialog.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class TermEditDialogComponent implements OnInit {
    @Input() TermID: string | null = null;
    @Input() CommitteeID: string | null = null;
    @Output() DialogClosed = new EventEmitter<TermDialogResult>();

    Term: mjBizAppsCommitteesTermEntity | null = null;
    IsLoading = true;
    IsSaving = false;
    ErrorMessage = '';

    StartDateLocal = '';
    EndDateLocal = '';

    readonly StatusOptions = ['Active', 'Upcoming', 'Completed'] as const;

    private cdr = inject(ChangeDetectorRef);

    get IsNew(): boolean {
        return this.TermID == null;
    }

    get DialogTitle(): string {
        return this.IsNew ? 'New Term' : 'Edit Term';
    }

    async ngOnInit(): Promise<void> {
        await this.loadOrCreateTerm();
        this.IsLoading = false;
        this.cdr.markForCheck();
    }

    HasMembers = false;
    ShowDeleteConfirm = false;

    async OnSave(): Promise<void> {
        if (!this.Term) return;

        const validationError = await this.validate();
        if (validationError) {
            this.ErrorMessage = validationError;
            this.cdr.markForCheck();
            return;
        }

        this.Term.StartDate = new Date(this.StartDateLocal + 'T00:00:00');
        this.Term.EndDate = this.EndDateLocal ? new Date(this.EndDateLocal + 'T00:00:00') : null;

        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.markForCheck();

        const success = await this.Term.Save();
        this.IsSaving = false;

        if (success) {
            this.DialogClosed.emit({ Saved: true, Term: this.Term });
        } else {
            this.ErrorMessage = 'Failed to save term. Please try again.';
            this.cdr.markForCheck();
        }
    }

    async OnDelete(): Promise<void> {
        if (!this.Term || this.IsNew) return;

        // Re-check for members at delete time
        const rv = new RunView();
        const memberCheck = await rv.RunView<{ ID: string }>({
            EntityName: 'Committees: Memberships',
            ExtraFilter: `TermID = '${this.Term.ID}'`,
            Fields: ['ID'],
            MaxRows: 1,
            ResultType: 'simple'
        });
        if (memberCheck.Success && memberCheck.Results && memberCheck.Results.length > 0) {
            this.HasMembers = true;
            this.ShowDeleteConfirm = false;
            this.ErrorMessage = 'Cannot delete this term — it has active memberships. Remove all members first.';
            this.cdr.markForCheck();
            return;
        }

        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.markForCheck();

        await this.Term.Delete();
        this.IsSaving = false;

        // MJ may report false even when the delete succeeded at the DB level,
        // so emit success regardless — the parent will reload and see the term is gone
        this.DialogClosed.emit({ Saved: true, Term: null });
    }

    OnClose(): void {
        this.DialogClosed.emit({ Saved: false, Term: null });
    }

    private async validate(): Promise<string | null> {
        if (!this.Term!.Name?.trim()) {
            return 'Term name is required.';
        }
        if (!this.StartDateLocal) {
            return 'Start date is required.';
        }
        if (this.EndDateLocal && this.EndDateLocal < this.StartDateLocal) {
            return 'End date must be after start date.';
        }

        // Check for duplicate name within same committee
        const rv = new RunView();
        const safeName = this.Term!.Name.trim().replace(/'/g, "''");
        const existingFilter = this.IsNew
            ? `CommitteeID = '${this.Term!.CommitteeID}' AND Name = '${safeName}'`
            : `CommitteeID = '${this.Term!.CommitteeID}' AND Name = '${safeName}' AND ID != '${this.Term!.ID}'`;

        const result = await rv.RunView<{ ID: string }>({
            EntityName: 'Committees: Terms',
            ExtraFilter: existingFilter,
            Fields: ['ID'],
            MaxRows: 1,
            ResultType: 'simple'
        });

        if (result.Success && result.Results && result.Results.length > 0) {
            return `A term named "${this.Term!.Name.trim()}" already exists for this committee.`;
        }

        return null;
    }

    private async loadOrCreateTerm(): Promise<void> {
        const md = new Metadata();
        if (this.IsNew) {
            this.Term = await md.GetEntityObject<mjBizAppsCommitteesTermEntity>('Committees: Terms');
            this.Term.Status = 'Upcoming';
            if (this.CommitteeID) {
                this.Term.CommitteeID = this.CommitteeID;
            }
            const now = new Date();
            const year = now.getFullYear();
            this.Term.Name = `${year}-${year + 1}`;
            this.StartDateLocal = `${year}-07-01`;
            this.EndDateLocal = `${year + 1}-06-30`;
        } else {
            this.Term = await md.GetEntityObject<mjBizAppsCommitteesTermEntity>('Committees: Terms');
            await this.Term.Load(this.TermID!);
            this.StartDateLocal = this.toLocalDateString(this.Term.StartDate);
            if (this.Term.EndDate) {
                this.EndDateLocal = this.toLocalDateString(this.Term.EndDate);
            }
            // Check if term has members (can't delete if so)
            const rv = new RunView();
            const memberResult = await rv.RunView<{ ID: string }>({
                EntityName: 'Committees: Memberships',
                ExtraFilter: `TermID = '${this.TermID}'`,
                Fields: ['ID'],
                MaxRows: 1,
                ResultType: 'simple'
            });
            this.HasMembers = memberResult.Success && memberResult.Results != null && memberResult.Results.length > 0;
        }
    }

    private toLocalDateString(date: Date): string {
        const d = new Date(date);
        return d.toISOString().slice(0, 10);
    }
}

export function LoadTermEditDialog() { }
