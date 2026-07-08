import { Component, EventEmitter, Input, Output, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { Metadata, RunView } from '@memberjunction/core';
import { mjBizAppsCommitteesAgendaItemEntity } from '@mj-biz-apps/committees-entities';

export interface AgendaItemDialogResult {
    Saved: boolean;
    AgendaItem: mjBizAppsCommitteesAgendaItemEntity | null;
}

@Component({
    standalone: false,
    selector: 'agenda-item-edit-dialog',
    templateUrl: './agenda-item-edit-dialog.component.html',
    styleUrls: ['../shared/design-system.css', '../shared/slide-panel.css', './agenda-item-edit-dialog.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class AgendaItemEditDialogComponent implements OnInit {
    @Input() AgendaItemID: string | null = null;
    @Input() MeetingID: string | null = null;
    @Input() NextSequence = 1;
    @Output() DialogClosed = new EventEmitter<AgendaItemDialogResult>();

    AgendaItem: mjBizAppsCommitteesAgendaItemEntity | null = null;
    IsLoading = true;
    IsSaving = false;
    ErrorMessage = '';
    ShowDeleteConfirm = false;

    People: { ID: string; DisplayName: string }[] = [];

    readonly ItemTypeOptions = ['Information', 'Discussion', 'Action', 'Vote', 'Report', 'Other'] as const;
    readonly StatusOptions = ['Pending', 'Discussed', 'Completed', 'Tabled', 'Skipped'] as const;

    private cdr = inject(ChangeDetectorRef);

    get IsNew(): boolean {
        return this.AgendaItemID == null;
    }

    get DialogTitle(): string {
        return this.IsNew ? 'Add Agenda Item' : 'Edit Agenda Item';
    }

    async ngOnInit(): Promise<void> {
        await Promise.all([
            this.loadLookups(),
            this.loadOrCreateItem()
        ]);
        this.IsLoading = false;
        this.cdr.markForCheck();
    }

    OnPresenterSelected(event: { PersonID: string; DisplayName: string } | null): void {
        if (this.AgendaItem) {
            this.AgendaItem.PresenterPersonID = event?.PersonID ?? null;
            this.cdr.markForCheck();
        }
    }

    async OnSave(): Promise<void> {
        if (!this.AgendaItem) return;

        const validationError = this.validate();
        if (validationError) {
            this.ErrorMessage = validationError;
            this.cdr.markForCheck();
            return;
        }

        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.markForCheck();

        const success = await this.AgendaItem.Save();
        this.IsSaving = false;

        if (success) {
            this.DialogClosed.emit({ Saved: true, AgendaItem: this.AgendaItem });
        } else {
            this.ErrorMessage = 'Failed to save agenda item. Please try again.';
            this.cdr.markForCheck();
        }
    }

    OnConfirmDelete(): void {
        this.ShowDeleteConfirm = true;
        this.cdr.markForCheck();
    }

    OnCancelDelete(): void {
        this.ShowDeleteConfirm = false;
        this.cdr.markForCheck();
    }

    async OnDelete(): Promise<void> {
        if (!this.AgendaItem || this.IsNew) return;

        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.markForCheck();

        try {
            await this.AgendaItem.Delete();
        } catch {
            // MJ may throw even on successful deletes
        }
        this.IsSaving = false;
        this.DialogClosed.emit({ Saved: true, AgendaItem: null });
    }

    OnClose(): void {
        this.DialogClosed.emit({ Saved: false, AgendaItem: null });
    }

    private validate(): string | null {
        if (!this.AgendaItem!.Name?.trim()) {
            return 'Title is required.';
        }
        if (this.AgendaItem!.DurationMinutes != null && this.AgendaItem!.DurationMinutes < 0) {
            return 'Duration cannot be negative.';
        }
        return null;
    }

    private async loadOrCreateItem(): Promise<void> {
        const md = new Metadata();
        if (this.IsNew) {
            this.AgendaItem = await md.GetEntityObject<mjBizAppsCommitteesAgendaItemEntity>('Committees: Agenda Items');
            this.AgendaItem.MeetingID = this.MeetingID!;
            this.AgendaItem.Sequence = this.NextSequence;
            this.AgendaItem.ItemType = 'Discussion';
            this.AgendaItem.Status = 'Pending';
        } else {
            this.AgendaItem = await md.GetEntityObject<mjBizAppsCommitteesAgendaItemEntity>('Committees: Agenda Items');
            await this.AgendaItem.Load(this.AgendaItemID!);
        }
    }

    private async loadLookups(): Promise<void> {
        const rv = new RunView();
        const result = await rv.RunView<{ ID: string; DisplayName: string }>({
            EntityName: 'MJ_BizApps_Common: People',
            Fields: ['ID', 'DisplayName'],
            OrderBy: 'DisplayName ASC',
            MaxRows: 500,
            ResultType: 'simple'
        });
        if (result.Success) {
            this.People = result.Results;
        }
    }
}

export function LoadAgendaItemEditDialog() { }
