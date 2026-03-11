import { Component, Input, Output, EventEmitter, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { RunView } from '@memberjunction/core';

export interface PersonPickerSelection {
    PersonID: string;
    DisplayName: string;
}

@Component({
    standalone: false,
    selector: 'committees-person-picker',
    template: `
        <kendo-dropdownlist
            [data]="FilteredPeople"
            [textField]="'DisplayName'"
            [valueField]="'ID'"
            [filterable]="true"
            [value]="SelectedPersonID"
            [valuePrimitive]="true"
            [defaultItem]="DefaultItem"
            (filterChange)="OnFilterChange($event)"
            (valueChange)="OnValueChange($event)">
        </kendo-dropdownlist>
    `,
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class PersonPickerComponent implements OnInit {
    @Input() SelectedPersonID: string | null = null;
    @Input() Placeholder = 'Select a person...';
    @Output() PersonSelected = new EventEmitter<PersonPickerSelection | null>();

    DefaultItem: Record<string, unknown> = { ID: null, DisplayName: 'Select a person...' };
    AllPeople: Record<string, unknown>[] = [];
    FilteredPeople: Record<string, unknown>[] = [];

    private cdr = inject(ChangeDetectorRef);

    async ngOnInit(): Promise<void> {
        await this.LoadPeople();
        this.cdr.markForCheck();
    }

    OnFilterChange(filter: string): void {
        if (!filter || filter.length < 2) {
            this.FilteredPeople = this.AllPeople.slice(0, 50);
        } else {
            const term = filter.toLowerCase();
            this.FilteredPeople = this.AllPeople.filter(p =>
                (p['DisplayName'] as string || '').toLowerCase().includes(term)
            );
        }
        this.cdr.markForCheck();
    }

    OnValueChange(personID: string | null): void {
        if (personID) {
            const person = this.AllPeople.find(p => p['ID'] === personID);
            this.PersonSelected.emit({
                PersonID: personID,
                DisplayName: (person?.['DisplayName'] as string) || ''
            });
        } else {
            this.PersonSelected.emit(null);
        }
    }

    private async LoadPeople(): Promise<void> {
        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'MJ.BizApps.Common: People',
            ExtraFilter: '',
            Fields: ['ID', 'DisplayName', 'Email'],
            OrderBy: 'DisplayName ASC',
            MaxRows: 500,
            ResultType: 'simple'
        });
        if (result.Success) {
            this.AllPeople = result.Results;
            this.FilteredPeople = this.AllPeople.slice(0, 50);
        }
    }
}
