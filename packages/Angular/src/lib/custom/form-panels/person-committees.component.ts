import { ChangeDetectionStrategy, ChangeDetectorRef, Component, EventEmitter, Input, OnChanges, Output, SimpleChanges, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CompositeKey, type IMetadataProvider } from '@memberjunction/core';
import type { FormNavigationEvent, RecordNavigationEvent } from '@memberjunction/ng-base-forms';
import {
    ActiveSeat,
    DaysLeft,
    FormatRange,
    Initials,
    LoadCommitteesForPerson,
    type PersonCommitteeCard,
    type SeatTerm,
} from './committee-seat-data';

@Component({
    selector: 'bizapps-person-committees',
    standalone: true,
    imports: [CommonModule],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: './person-committees.component.html',
    styleUrls: ['./committee-seats.css'],
})
export class PersonCommitteesComponent implements OnChanges {
    private readonly cdr = inject(ChangeDetectorRef);

    @Input() public PersonID: string | null = null;
    @Input() public Provider: IMetadataProvider | null = null;
    @Output() public Navigate = new EventEmitter<FormNavigationEvent>();

    public Loading = false;
    public ErrorMessage: string | null = null;
    public Cards: PersonCommitteeCard[] = [];

    public ngOnChanges(changes: SimpleChanges): void {
        if (changes['PersonID'] || changes['Provider']) {
            void this.Load();
        }
    }

    public get ActiveCount(): number {
        return this.Cards.filter((c) => c.Terms.some((t) => t.MembershipStatus === 'Active')).length;
    }

    public get OfficerCount(): number {
        return this.Cards.filter((c) =>
            c.Terms.some((t) => t.IsOfficer && t.MembershipStatus === 'Active'),
        ).length;
    }

    public PrimaryRole(card: PersonCommitteeCard): SeatTerm | undefined {
        return ActiveSeat(card.Terms);
    }

    public Initials = Initials;
    public FormatRange = FormatRange;

    public TermHint(term: SeatTerm): string {
        const days = DaysLeft(term.End);
        if (term.MembershipStatus !== 'Active') return term.MembershipStatus;
        if (days != null && days < 0) return 'Ended';
        if (days != null && days <= 60) return `${days}d left`;
        return FormatRange(term.Start, term.End);
    }

    public PillClass(term: SeatTerm): string {
        const days = DaysLeft(term.End);
        if (term.MembershipStatus !== 'Active') return 'ended';
        if (days != null && days <= 60 && days >= 0) return 'warn';
        return 'active';
    }

    public OpenCommittee(card: PersonCommitteeCard, event: MouseEvent): void {
        event.stopPropagation();
        const nav: RecordNavigationEvent = {
            Kind: 'record',
            EntityName: 'Committees: Committees',
            PrimaryKey: CompositeKey.FromKeyValuePair('ID', card.CommitteeID),
            OpenInNewTab: event.ctrlKey || event.metaKey,
        };
        this.Navigate.emit(nav);
    }

    private async Load(): Promise<void> {
        if (!this.PersonID) {
            this.Cards = [];
            return;
        }
        this.Loading = true;
        this.ErrorMessage = null;
        this.cdr.markForCheck();
        try {
            this.Cards = await LoadCommitteesForPerson(this.PersonID, this.Provider ?? undefined);
        } catch (e) {
            this.ErrorMessage = e instanceof Error ? e.message : 'Could not load committees.';
            this.Cards = [];
        } finally {
            this.Loading = false;
            this.cdr.markForCheck();
        }
    }
}
