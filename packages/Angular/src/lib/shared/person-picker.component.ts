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
        <select class="person-select"
            [ngModel]="SelectedPersonID"
            (ngModelChange)="OnValueChange($event)">
            <option [ngValue]="null">{{ Placeholder }}</option>
            @for (person of AllPeople; track person['ID']) {
                <option [ngValue]="person['ID']">{{ person['DisplayName'] }}</option>
            }
        </select>
    `,
    styles: [`
        .person-select {
            width: 100%;
            padding: 10px 14px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 500;
            color: #1e293b;
            background: #fff;
            outline: none;
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%2394a3b8' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            padding-right: 36px;
            box-sizing: border-box;
            transition: border-color 0.15s ease, box-shadow 0.15s ease;
        }
        .person-select:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.12);
        }
    `],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class PersonPickerComponent implements OnInit {
    @Input() SelectedPersonID: string | null = null;
    @Input() Placeholder = 'Select a person...';
    @Output() PersonSelected = new EventEmitter<PersonPickerSelection | null>();

    AllPeople: Record<string, unknown>[] = [];

    private cdr = inject(ChangeDetectorRef);

    async ngOnInit(): Promise<void> {
        await this.LoadPeople();
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
        }
    }
}
