import { Component, Input, Output, EventEmitter, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { Metadata } from '@memberjunction/core';
import { mjBizAppsCommonPersonEntity } from '@mj-biz-apps/common-entities';

@Component({
    standalone: false,
    selector: 'person-detail-panel',
    templateUrl: './person-detail-panel.component.html',
    styleUrls: ['../shared/slide-panel.css', './person-detail-panel.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class PersonDetailPanelComponent implements OnInit {
    @Input() PersonID: string | null = null;
    @Input() CanEdit = false;
    @Output() PanelClosed = new EventEmitter<void>();

    Person: mjBizAppsCommonPersonEntity | null = null;
    IsLoading = true;
    IsEditMode = false;
    IsSaving = false;
    ErrorMessage = '';

    private cdr = inject(ChangeDetectorRef);

    async ngOnInit(): Promise<void> {
        await this.LoadPerson();
        this.IsLoading = false;
        this.cdr.markForCheck();
    }

    get DisplayName(): string {
        if (!this.Person) return '';
        const parts = [this.Person.Prefix, this.Person.FirstName, this.Person.MiddleName, this.Person.LastName, this.Person.Suffix];
        return parts.filter(Boolean).join(' ');
    }

    OnToggleEdit(): void {
        this.IsEditMode = !this.IsEditMode;
        this.ErrorMessage = '';
        this.cdr.markForCheck();
    }

    async OnSave(): Promise<void> {
        if (!this.Person) return;
        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.markForCheck();

        const success = await this.Person.Save();
        this.IsSaving = false;

        if (success) {
            this.IsEditMode = false;
        } else {
            this.ErrorMessage = 'Failed to save. Please try again.';
        }
        this.cdr.markForCheck();
    }

    OnCancelEdit(): void {
        this.IsEditMode = false;
        this.ErrorMessage = '';
        this.LoadPerson().then(() => this.cdr.markForCheck());
    }

    OnClose(): void {
        this.PanelClosed.emit();
    }

    private async LoadPerson(): Promise<void> {
        if (!this.PersonID) return;
        const md = new Metadata();
        const entity = await md.GetEntityObject<mjBizAppsCommonPersonEntity>('MJ_BizApps_Common: People');
        await entity.Load(this.PersonID);
        this.Person = entity;
    }
}

export function LoadPersonDetailPanel() {}
