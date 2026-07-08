import { Component, ChangeDetectionStrategy, ChangeDetectorRef, EventEmitter, Input, OnInit, Output, inject } from '@angular/core';
import { Metadata, RunView } from '@memberjunction/core';
import { mjBizAppsCommitteesAgendaItemEntity } from '@mj-biz-apps/committees-entities';

/** One agenda row in the builder, flattened from the view for display + edit. */
interface BuilderRow {
    ID: string;
    Sequence: number;
    Name: string;
    Description: string | null;
    ItemType: mjBizAppsCommitteesAgendaItemEntity['ItemType'];
    DurationMinutes: number | null;
    PresenterPersonID: string | null;
    PresenterName: string | null;
    Notes: string | null;
    /** Sequence as last persisted — resequencing diffs against THIS, not the
     *  (optimistically renumbered) display value. */
    PersistedSequence: number;
    /** Row is expanded for in-place editing. */
    Editing: boolean;
    /** Row is asking "really delete?". */
    ConfirmingDelete: boolean;
}

interface MemberOption { PersonID: string; PersonName: string; }

// Typed against the entity union — a renamed/removed CHECK value fails compile here.
const ITEM_TYPES: ReadonlyArray<mjBizAppsCommitteesAgendaItemEntity['ItemType']> =
    ['Discussion', 'Vote', 'Report', 'Action', 'Information', 'Other'];

/**
 * Agenda Builder (Phase 4 feature 3) — the prep tense. Replaces the read-only
 * agenda list on meeting detail while the meeting is Scheduled. Inline add,
 * in-place edit, up/down reordering with contiguous resequencing, and a time
 * budget against the meeting window. The agenda is live as edited — Member
 * Home and Live Meeting read the same rows.
 */
@Component({
    standalone: false,
    selector: 'committees-agenda-builder',
    templateUrl: './agenda-builder.component.html',
    styleUrls: ['./agenda-builder.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class AgendaBuilderComponent implements OnInit {
    @Input() MeetingID!: string;
    @Input() CommitteeID: string | null = null;
    @Input() MeetingStart: Date | null = null;
    @Input() MeetingEnd: Date | null = null;
    /** Fires after any successful write so the parent can refresh its counts. */
    @Output() Changed = new EventEmitter<void>();

    Rows: BuilderRow[] = [];
    Members: MemberOption[] = [];
    IsLoading = true;
    IsSaving = false;
    ErrorMessage = '';

    // inline add
    NewName = '';
    NewType: mjBizAppsCommitteesAgendaItemEntity['ItemType'] = 'Discussion';

    readonly ItemTypes = ITEM_TYPES;

    private cdr = inject(ChangeDetectorRef);

    async ngOnInit(): Promise<void> {
        await this.Load();
    }

    // ── Load ────────────────────────────────────────────────────

    async Load(): Promise<void> {
        this.IsLoading = true;
        this.cdr.detectChanges();
        try {
            const rv = new RunView();
            const [itemsR, termsR, membersR] = await rv.RunViews([
                {
                    EntityName: 'Committees: Agenda Items',
                    ExtraFilter: `MeetingID = '${this.MeetingID}'`,
                    Fields: ['ID', 'Sequence', 'Name', 'Description', 'ItemType', 'DurationMinutes', 'PresenterPersonID', 'PresenterPerson', 'Notes'],
                    OrderBy: 'Sequence ASC',
                    ResultType: 'simple',
                    // The builder re-reads immediately after every write; the local
                    // RunView smart-cache can race its own invalidation and serve
                    // the pre-write rows. This list must always be true DB state.
                    BypassCache: true,
                },
                {
                    EntityName: 'Committees: Terms',
                    ExtraFilter: this.CommitteeID ? `CommitteeID = '${this.CommitteeID}' AND Status = 'Active'` : '1=0',
                    Fields: ['ID', 'CommitteeID', 'Status'],
                    ResultType: 'simple',
                },
                {
                    EntityName: 'Committees: Memberships',
                    ExtraFilter: this.CommitteeID ? "Status = 'Active'" : '1=0',
                    Fields: ['ID', 'TermID', 'PersonID', 'Person'],
                    OrderBy: 'Person ASC',
                    ResultType: 'simple',
                },
            ]);
            const items = (itemsR.Success ? itemsR.Results : []) as unknown as Array<{
                ID: string; Sequence: number; Name: string; Description: string | null; ItemType: mjBizAppsCommitteesAgendaItemEntity['ItemType'];
                DurationMinutes: number | null; PresenterPersonID: string | null; PresenterPerson: string | null; Notes: string | null;
            }>;
            this.Rows = items.map(i => ({
                ID: i.ID, Sequence: i.Sequence, Name: i.Name, Description: i.Description,
                ItemType: i.ItemType, DurationMinutes: i.DurationMinutes,
                PresenterPersonID: i.PresenterPersonID, PresenterName: i.PresenterPerson,
                Notes: i.Notes, PersistedSequence: i.Sequence, Editing: false, ConfirmingDelete: false,
            }));
            const termIDs = new Set(((termsR.Success ? termsR.Results : []) as unknown as Array<{ ID: string }>)
                .map(t => t.ID.toLowerCase()));
            const members = (membersR.Success ? membersR.Results : []) as unknown as Array<{ TermID: string; PersonID: string; Person: string }>;
            const seen = new Set<string>();
            this.Members = members
                .filter(m => termIDs.has(m.TermID.toLowerCase()))
                .filter(m => !seen.has(m.PersonID.toLowerCase()) && seen.add(m.PersonID.toLowerCase()) !== undefined)
                .map(m => ({ PersonID: m.PersonID, PersonName: m.Person }));
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to load agenda';
        }
        this.IsLoading = false;
        this.cdr.detectChanges();
    }

    // ── Time budget ─────────────────────────────────────────────

    get PlannedMinutes(): number {
        return this.Rows.reduce((sum, r) => sum + (r.DurationMinutes ?? 0), 0);
    }

    get WindowMinutes(): number | null {
        if (!this.MeetingStart || !this.MeetingEnd) return null;
        return Math.round((new Date(this.MeetingEnd).getTime() - new Date(this.MeetingStart).getTime()) / 60_000);
    }

    get BudgetDelta(): number | null {
        return this.WindowMinutes == null ? null : this.WindowMinutes - this.PlannedMinutes;
    }

    get VoteCount(): number {
        return this.Rows.filter(r => r.ItemType === 'Vote').length;
    }

    SharePct(row: BuilderRow): number {
        const window = this.WindowMinutes ?? Math.max(this.PlannedMinutes, 1);
        if (!row.DurationMinutes || window <= 0) return 0;
        return Math.min(100, (row.DurationMinutes / window) * 100);
    }

    // ── Inline add ──────────────────────────────────────────────

    async OnAdd(): Promise<void> {
        const name = this.NewName.trim();
        if (!name || this.IsSaving) return;
        await this.write(async (md) => {
            const item = await md.GetEntityObject<mjBizAppsCommitteesAgendaItemEntity>('Committees: Agenda Items');
            item.MeetingID = this.MeetingID;
            item.Name = name;
            item.ItemType = this.NewType;
            item.Sequence = (this.Rows[this.Rows.length - 1]?.Sequence ?? 0) + 1;
            item.Status = 'Pending';
            if (!await item.Save()) throw new Error(item.LatestResult?.CompleteMessage ?? 'Add failed');
            this.NewName = '';
        });
    }

    // ── In-place edit ───────────────────────────────────────────

    ToggleEdit(row: BuilderRow): void {
        this.Rows.forEach(r => { if (r !== row) r.Editing = false; });
        row.Editing = !row.Editing;
        row.ConfirmingDelete = false;
        this.cdr.markForCheck();
    }

    async OnSaveRow(row: BuilderRow): Promise<void> {
        if (!row.Name.trim() || this.IsSaving) return;
        await this.write(async (md) => {
            const item = await md.GetEntityObject<mjBizAppsCommitteesAgendaItemEntity>('Committees: Agenda Items');
            if (!await item.Load(row.ID)) throw new Error('Agenda item not found');
            item.Name = row.Name.trim();
            item.ItemType = row.ItemType;
            item.DurationMinutes = row.DurationMinutes || null;
            item.PresenterPersonID = row.PresenterPersonID || null;
            item.Notes = row.Notes?.trim() || null;
            if (!await item.Save()) throw new Error(item.LatestResult?.CompleteMessage ?? 'Save failed');
        });
    }

    // ── Reorder ─────────────────────────────────────────────────

    async Move(row: BuilderRow, direction: -1 | 1): Promise<void> {
        const index = this.Rows.indexOf(row);
        const target = index + direction;
        if (index < 0 || target < 0 || target >= this.Rows.length || this.IsSaving) return;
        [this.Rows[index], this.Rows[target]] = [this.Rows[target], this.Rows[index]];
        // Renumber optimistically so the visible order and the sequence
        // numbers never disagree while the saves are in flight.
        this.Rows.forEach((r, i) => r.Sequence = i + 1);
        this.cdr.markForCheck();
        await this.resequence();
    }

    // ── Delete ──────────────────────────────────────────────────

    async OnDelete(row: BuilderRow): Promise<void> {
        if (this.IsSaving) return;
        await this.write(async (md) => {
            const item = await md.GetEntityObject<mjBizAppsCommitteesAgendaItemEntity>('Committees: Agenda Items');
            if (!await item.Load(row.ID)) throw new Error('Agenda item not found');
            if (!await item.Delete()) throw new Error(item.LatestResult?.CompleteMessage ?? 'Delete failed');
            this.Rows = this.Rows.filter(r => r !== row);
            await this.saveSequences(new Metadata());
        });
    }

    // ── Write plumbing ──────────────────────────────────────────

    /** Renumbers Rows contiguously and saves every item whose Sequence moved. */
    private async resequence(): Promise<void> {
        await this.write(async (md) => this.saveSequences(md));
    }

    private async saveSequences(md: Metadata): Promise<void> {
        for (let i = 0; i < this.Rows.length; i++) {
            const wanted = i + 1;
            if (this.Rows[i].PersistedSequence === wanted) continue;
            const item = await md.GetEntityObject<mjBizAppsCommitteesAgendaItemEntity>('Committees: Agenda Items');
            if (!await item.Load(this.Rows[i].ID)) throw new Error('Agenda item not found');
            item.Sequence = wanted;
            if (!await item.Save()) throw new Error(item.LatestResult?.CompleteMessage ?? 'Reorder failed');
            this.Rows[i].Sequence = wanted;
            this.Rows[i].PersistedSequence = wanted;
        }
    }

    /** Shared write wrapper: busy flag, error banner, reload + Changed emit. */
    private async write(work: (md: Metadata) => Promise<void>): Promise<void> {
        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.detectChanges();
        try {
            await work(new Metadata());
            await this.Load();
            this.Changed.emit();
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Save failed';
        }
        this.IsSaving = false;
        this.cdr.detectChanges();
    }

    TypeIcon(type: string): string {
        switch (type) {
            case 'Vote': return 'fa-solid fa-gavel';
            case 'Report': return 'fa-solid fa-file-lines';
            case 'Action': return 'fa-solid fa-square-check';
            case 'Information': return 'fa-solid fa-circle-info';
            case 'Other': return 'fa-solid fa-ellipsis';
            default: return 'fa-solid fa-comments';
        }
    }
}
