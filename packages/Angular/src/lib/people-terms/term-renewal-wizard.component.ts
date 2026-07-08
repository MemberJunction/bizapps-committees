import { Component, ChangeDetectionStrategy, ChangeDetectorRef, EventEmitter, Input, Output, inject } from '@angular/core';
import { Metadata, RunView } from '@memberjunction/core';
import {
    CarryRow, RenewalContext, TermRenewalService,
} from '@mj-biz-apps/committees-core';
import {
    mjBizAppsCommitteesMembershipEntity, mjBizAppsCommitteesTermEntity,
} from '@mj-biz-apps/committees-entities';
import { SuccessionSuggestion } from './succession-suggestions.component';

/** A carry-over row with the staff member's working decision. */
interface WizardRow extends CarryRow {
    Carry: boolean;
}

/** A person added to the new roster who was not on the previous term. */
interface AddedRow {
    PersonID: string;
    PersonName: string;
    RoleID: string;
    Source: 'search' | 'ai';
}

interface PersonSearchRow { ID: string; DisplayName: string; Email: string | null; }

/**
 * Term-Renewal Wizard (Phase 4 feature 1) — full-screen overlay, three steps:
 * new term → roster carry-over → review & create. Planning math comes from
 * TermRenewalService; this component owns the writes (sequential entity saves,
 * skip-existing guard so a failed run can be retried safely).
 */
@Component({
    standalone: false,
    selector: 'committees-term-renewal-wizard',
    templateUrl: './term-renewal-wizard.component.html',
    styleUrls: ['./term-renewal-wizard.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class TermRenewalWizardComponent {
    private _committeeID: string | null = null;
    @Input()
    set CommitteeID(value: string | null) {
        if (value && value !== this._committeeID) {
            this._committeeID = value;
            void this.Load();
        } else {
            this._committeeID = value;
        }
    }
    get CommitteeID(): string | null { return this._committeeID; }

    /** Emits true when a term was created (parent should reload), false on cancel. */
    @Output() Exited = new EventEmitter<boolean>();

    Step: 1 | 2 | 3 = 1;
    Context: RenewalContext | null = null;
    IsLoading = false;
    IsSaving = false;
    ErrorMessage = '';
    SaveProgress = '';

    // Step 1 form
    TermName = '';
    StartDateStr = '';
    EndDateStr = '';

    // Step 2 roster
    Rows: WizardRow[] = [];
    Added: AddedRow[] = [];
    SearchTerm = '';
    SearchResults: PersonSearchRow[] = [];
    IsSearching = false;

    private service = new TermRenewalService();
    private cdr = inject(ChangeDetectorRef);

    // ── Load ────────────────────────────────────────────────────

    async Load(): Promise<void> {
        if (!this._committeeID) return;
        this.IsLoading = true;
        this.ErrorMessage = '';
        this.Step = 1;
        this.Added = [];
        this.SearchTerm = '';
        this.SearchResults = [];
        this.cdr.detectChanges();
        try {
            const ctx = await this.service.GetRenewalContext(this._committeeID);
            this.Context = ctx;
            this.TermName = ctx.Suggestion.Name;
            this.StartDateStr = this.toDateStr(ctx.Suggestion.StartDate);
            this.EndDateStr = this.toDateStr(ctx.Suggestion.EndDate);
            this.Rows = ctx.Rows.map(r => ({ ...r, Carry: r.Decision !== 'drop' }));
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to load renewal context';
        }
        this.IsLoading = false;
        this.cdr.detectChanges();
    }

    // ── Derived state ───────────────────────────────────────────

    get DerivedStatus(): 'Active' | 'Upcoming' {
        return this.StartDateStr && new Date(this.StartDateStr + 'T00:00:00Z') <= new Date() ? 'Active' : 'Upcoming';
    }

    get IsDuplicateName(): boolean {
        const name = this.TermName.trim().toLowerCase();
        return !!name && (this.Context?.ExistingTermNames ?? []).some(n => n.trim().toLowerCase() === name);
    }

    get DatesValid(): boolean {
        return !!this.StartDateStr && !!this.EndDateStr && this.EndDateStr > this.StartDateStr;
    }

    get Step1Valid(): boolean {
        return this.TermName.trim().length > 0 && this.DatesValid;
    }

    get CarriedRows(): WizardRow[] { return this.Rows.filter(r => r.Carry); }
    get DroppedRows(): WizardRow[] { return this.Rows.filter(r => !r.Carry); }
    get NewRosterCount(): number { return this.CarriedRows.length + this.Added.length; }

    RoleName(roleID: string): string {
        return this.Context?.Roles.find(r => r.ID === roleID)?.Name ?? '';
    }

    get DefaultRoleID(): string {
        const roles = this.Context?.Roles ?? [];
        return (roles.find(r => r.Name === 'Member') ?? roles[roles.length - 1])?.ID ?? '';
    }

    Initials(name: string): string {
        return name.split(/\s+/).filter(Boolean).slice(0, 2).map(p => p[0]).join('').toUpperCase();
    }

    // ── Step 2 actions ──────────────────────────────────────────

    async OnSearch(): Promise<void> {
        const term = this.SearchTerm.trim().replace(/'/g, "''");
        if (term.length < 2 || this.IsSearching) return;
        this.IsSearching = true;
        this.cdr.detectChanges();
        try {
            const taken = new Set([
                ...this.Rows.map(r => r.PersonID.toLowerCase()),
                ...this.Added.map(a => a.PersonID.toLowerCase()),
            ]);
            const rv = new RunView();
            const result = await rv.RunView({
                EntityName: 'MJ_BizApps_Common: People',
                ExtraFilter: `Status = 'Active' AND DisplayName LIKE '%${term}%'`,
                Fields: ['ID', 'DisplayName', 'Email'],
                OrderBy: 'DisplayName ASC',
                MaxRows: 8,
                ResultType: 'simple',
            });
            const people = (result.Success ? result.Results : []) as unknown as PersonSearchRow[];
            this.SearchResults = people.filter(p => !taken.has(p.ID.toLowerCase()));
            this.HasSearched = true;
        } catch {
            this.SearchResults = [];
        }
        this.IsSearching = false;
        this.cdr.detectChanges();
    }

    // "No matches → create them" path
    ShowPersonCreate = false;

    OnPersonCreated(created: { PersonID: string; DisplayName: string }): void {
        this.ShowPersonCreate = false;
        this.Added.push({ PersonID: created.PersonID, PersonName: created.DisplayName, RoleID: this.DefaultRoleID, Source: 'search' });
        this.SearchTerm = '';
        this.SearchResults = [];
        this.HasSearched = false;
        this.cdr.markForCheck();
    }

    HasSearched = false;

    AddPerson(person: PersonSearchRow): void {
        this.Added.push({ PersonID: person.ID, PersonName: person.DisplayName, RoleID: this.DefaultRoleID, Source: 'search' });
        this.SearchResults = this.SearchResults.filter(p => p.ID !== person.ID);
        this.cdr.markForCheck();
    }

    OnSuggestionPicked(s: SuccessionSuggestion): void {
        if (this.Added.some(a => a.PersonID.toLowerCase() === s.PersonID.toLowerCase())) return;
        this.Added.push({ PersonID: s.PersonID, PersonName: s.PersonName, RoleID: this.DefaultRoleID, Source: 'ai' });
        this.cdr.markForCheck();
    }

    RemoveAdded(row: AddedRow): void {
        this.Added = this.Added.filter(a => a !== row);
        this.cdr.markForCheck();
    }

    // ── Create (step 3) ─────────────────────────────────────────

    async OnCreate(): Promise<void> {
        if (this.IsSaving || !this.Context || !this._committeeID) return;
        this.IsSaving = true;
        this.ErrorMessage = '';
        try {
            this.progress('Creating the term…');
            const termID = await this.findOrCreateTerm();
            this.progress('Building the roster…');
            await this.createMemberships(termID);
            if (this.Context.PreviousTerm && !this.Context.PreviousTermStillActive) {
                this.progress('Closing out the previous term…');
                await this.closePreviousTerm();
            }
            this.IsSaving = false;
            this.Exited.emit(true);
        } catch (err) {
            this.ErrorMessage = `${this.SaveProgress} failed — ${err instanceof Error ? err.message : err}. ` +
                'Completed steps were applied; running the wizard again skips them.';
            this.IsSaving = false;
            this.cdr.detectChanges();
        }
    }

    /** Reuses a term with the same name (partial-retry guard) or creates one. */
    private async findOrCreateTerm(): Promise<string> {
        const md = new Metadata();
        const rv = new RunView();
        const name = this.TermName.trim().replace(/'/g, "''");
        const existing = await rv.RunView<mjBizAppsCommitteesTermEntity>({
            EntityName: 'Committees: Terms',
            ExtraFilter: `CommitteeID = '${this._committeeID}' AND Name = '${name}'`,
            ResultType: 'entity_object',
        });
        const term = existing.Success && existing.Results && existing.Results.length > 0
            ? existing.Results[0]
            : await md.GetEntityObject<mjBizAppsCommitteesTermEntity>('Committees: Terms');
        term.CommitteeID = this._committeeID!;
        term.Name = this.TermName.trim();
        term.StartDate = new Date(this.StartDateStr + 'T00:00:00Z');
        term.EndDate = new Date(this.EndDateStr + 'T00:00:00Z');
        term.Status = this.DerivedStatus;
        if (!await term.Save()) throw new Error(term.LatestResult?.Message ?? 'term save failed');
        return term.ID;
    }

    private async createMemberships(termID: string): Promise<void> {
        const md = new Metadata();
        const rv = new RunView();
        const existing = await rv.RunView({
            EntityName: 'Committees: Memberships',
            ExtraFilter: `TermID = '${termID}'`,
            Fields: ['ID', 'PersonID'],
            ResultType: 'simple',
        });
        const already = new Set(((existing.Success ? existing.Results : []) as unknown as { PersonID: string }[])
            .map(r => r.PersonID.toLowerCase()));

        const wanted = [
            ...this.CarriedRows.map(r => ({ PersonID: r.PersonID, RoleID: r.RoleID })),
            ...this.Added.map(a => ({ PersonID: a.PersonID, RoleID: a.RoleID })),
        ];
        for (const w of wanted) {
            if (already.has(w.PersonID.toLowerCase())) continue;
            const m = await md.GetEntityObject<mjBizAppsCommitteesMembershipEntity>('Committees: Memberships');
            m.PersonID = w.PersonID;
            m.RoleID = w.RoleID;
            m.TermID = termID;
            m.StartDate = new Date(this.StartDateStr + 'T00:00:00Z');
            m.Status = 'Active';
            if (!await m.Save()) throw new Error(m.LatestResult?.Message ?? 'membership save failed');
            already.add(w.PersonID.toLowerCase());
        }
    }

    /** Ends still-active memberships on the lapsed previous term and completes it. */
    private async closePreviousTerm(): Promise<void> {
        const prev = this.Context!.PreviousTerm!;
        const md = new Metadata();
        const rv = new RunView();
        const endDate = prev.EndDate ? new Date(prev.EndDate) : new Date();
        const declined = new Set(this.Rows.filter(r => r.Intent === 'No').map(r => r.MembershipID.toLowerCase()));

        const open = await rv.RunView<mjBizAppsCommitteesMembershipEntity>({
            EntityName: 'Committees: Memberships',
            ExtraFilter: `TermID = '${prev.ID}' AND Status = 'Active'`,
            ResultType: 'entity_object',
        });
        for (const m of (open.Success ? open.Results ?? [] : [])) {
            m.Status = 'Ended';
            m.EndDate = endDate;
            m.EndReason = declined.has(m.ID.toLowerCase()) ? 'Declined renewal' : 'Term ended';
            if (!await m.Save()) throw new Error(m.LatestResult?.Message ?? 'membership close failed');
        }

        if (prev.Status !== 'Completed') {
            const term = await md.GetEntityObject<mjBizAppsCommitteesTermEntity>('Committees: Terms');
            if (!await term.Load(prev.ID)) throw new Error('previous term not found');
            term.Status = 'Completed';
            if (!await term.Save()) throw new Error(term.LatestResult?.Message ?? 'term completion failed');
        }
    }

    // ── Navigation ──────────────────────────────────────────────

    Next(): void {
        if (this.Step === 1 && !this.Step1Valid) return;
        if (this.Step < 3) this.Step = (this.Step + 1) as 2 | 3;
        this.cdr.markForCheck();
    }

    Back(): void {
        if (this.Step > 1) this.Step = (this.Step - 1) as 1 | 2;
        this.cdr.markForCheck();
    }

    Cancel(): void {
        if (!this.IsSaving) this.Exited.emit(false);
    }

    private progress(message: string): void {
        this.SaveProgress = message;
        this.cdr.detectChanges();
    }

    private toDateStr(d: Date): string {
        return d.toISOString().slice(0, 10);
    }
}
