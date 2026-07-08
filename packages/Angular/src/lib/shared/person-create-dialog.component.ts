import { Component, ChangeDetectionStrategy, ChangeDetectorRef, EventEmitter, Input, Output, inject } from '@angular/core';
import { Metadata } from '@memberjunction/core';
import { mjBizAppsCommonPersonEntity } from '@mj-biz-apps/common-entities';

export interface PersonCreated {
    PersonID: string;
    DisplayName: string;
}

/**
 * Minimal "New person" dialog — the one place in the UI a Person record gets
 * created outside bulk import. Creates the MJ_BizApps_Common Person and hands
 * back the ID so callers (Members screen, term-renewal wizard) can continue
 * their own flow (add membership, add to roster).
 */
@Component({
    standalone: false,
    selector: 'committees-person-create-dialog',
    templateUrl: './person-create-dialog.component.html',
    styleUrls: ['./person-create-dialog.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class PersonCreateDialogComponent {
    /** Optional prefill, e.g. the search text that found no matches. */
    @Input()
    set PrefillName(value: string | null) {
        if (!value) return;
        const parts = value.trim().split(/\s+/);
        this.FirstName ||= parts[0] ?? '';
        this.LastName ||= parts.slice(1).join(' ');
    }

    @Output() Created = new EventEmitter<PersonCreated>();
    @Output() Cancelled = new EventEmitter<void>();

    FirstName = '';
    LastName = '';
    Email = '';
    Phone = '';
    Title = '';
    IsSaving = false;
    ErrorMessage = '';

    private cdr = inject(ChangeDetectorRef);

    get Valid(): boolean {
        return this.FirstName.trim().length > 0 && this.LastName.trim().length > 0;
    }

    async OnCreate(): Promise<void> {
        if (!this.Valid || this.IsSaving) return;
        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.detectChanges();
        try {
            const md = new Metadata();
            const person = await md.GetEntityObject<mjBizAppsCommonPersonEntity>('MJ_BizApps_Common: People');
            person.FirstName = this.FirstName.trim();
            person.LastName = this.LastName.trim();
            person.Email = this.Email.trim() || null;
            person.Phone = this.Phone.trim() || null;
            person.Title = this.Title.trim() || null;
            person.Status = 'Active';
            if (!await person.Save()) throw new Error(person.LatestResult?.Message ?? 'Person save failed');
            this.Created.emit({ PersonID: person.ID, DisplayName: `${person.FirstName} ${person.LastName}` });
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to create person';
            this.IsSaving = false;
            this.cdr.detectChanges();
        }
    }

    OnCancel(): void {
        if (!this.IsSaving) this.Cancelled.emit();
    }
}
