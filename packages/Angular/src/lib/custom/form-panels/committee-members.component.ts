import { ChangeDetectionStrategy, ChangeDetectorRef, Component, EventEmitter, Input, OnChanges, Output, SimpleChanges, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CompositeKey, type IMetadataProvider } from '@memberjunction/core';
import type { FormNavigationEvent, RecordNavigationEvent } from '@memberjunction/ng-base-forms';
import {
    ActiveSeat,
    DaysLeft,
    FormatRange,
    Initials,
    LoadMembersForCommittee,
    type CommitteeMemberCard,
    type SeatTerm,
} from './committee-seat-data';

@Component({
    selector: 'bizapps-committee-members',
    standalone: true,
    imports: [CommonModule],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: './committee-members.component.html',
    styleUrls: ['./committee-seats.css'],
})
export class CommitteeMembersComponent implements OnChanges {
    private readonly cdr = inject(ChangeDetectorRef);

    @Input() public CommitteeID: string | null = null;
    @Input() public Provider: IMetadataProvider | null = null;
    @Output() public Navigate = new EventEmitter<FormNavigationEvent>();

    public Loading = false;
    public ErrorMessage: string | null = null;
    public Cards: CommitteeMemberCard[] = [];
    public Filter: 'active' | 'officers' | 'all' = 'active';

    public ngOnChanges(changes: SimpleChanges): void {
        if (changes['CommitteeID'] || changes['Provider']) {
            void this.Load();
        }
    }

    public get Visible(): CommitteeMemberCard[] {
        if (this.Filter === 'all') return this.Cards;
        if (this.Filter === 'officers') {
            return this.Cards.filter((c) => c.Terms.some((t) => t.IsOfficer && t.MembershipStatus === 'Active'));
        }
        return this.Cards.filter((c) => c.Terms.some((t) => t.MembershipStatus === 'Active'));
    }

    public get ActiveCount(): number {
        return this.Cards.filter((c) => c.Terms.some((t) => t.MembershipStatus === 'Active')).length;
    }

    public get OfficerCount(): number {
        return this.Cards.filter((c) =>
            c.Terms.some((t) => t.IsOfficer && t.MembershipStatus === 'Active'),
        ).length;
    }

    public PrimaryRole(card: CommitteeMemberCard): SeatTerm | undefined {
        return ActiveSeat(card.Terms);
    }

    public Initials = Initials;
    private readonly BrokenPhotos = new Set<string>();

    public ShowPhoto(card: CommitteeMemberCard): boolean {
        return !!card.PhotoURL && !this.BrokenPhotos.has(card.PersonID);
    }

    public OnPhotoError(personID: string): void {
        this.BrokenPhotos.add(personID);
        this.cdr.markForCheck();
    }

    public TermHint(term: SeatTerm): string {
        const days = DaysLeft(term.End);
        if (term.MembershipStatus !== 'Active') return term.MembershipStatus;
        if (days != null && days <= 60 && days >= 0) return `${days}d left · ${FormatRange(term.Start, term.End)}`;
        return FormatRange(term.Start, term.End);
    }

    public PillClass(term: SeatTerm): string {
        const days = DaysLeft(term.End);
        if (term.MembershipStatus !== 'Active') return 'ended';
        if (days != null && days <= 60 && days >= 0) return 'warn';
        return 'active';
    }

    public SetFilter(filter: 'active' | 'officers' | 'all'): void {
        this.Filter = filter;
        this.cdr.markForCheck();
    }

    public OpenPerson(card: CommitteeMemberCard, event: MouseEvent): void {
        event.stopPropagation();
        const nav: RecordNavigationEvent = {
            Kind: 'record',
            EntityName: 'MJ_BizApps_Common: People',
            PrimaryKey: CompositeKey.FromKeyValuePair('ID', card.PersonID),
            OpenInNewTab: event.ctrlKey || event.metaKey,
        };
        this.Navigate.emit(nav);
    }

    private async Load(): Promise<void> {
        if (!this.CommitteeID) {
            this.Cards = [];
            return;
        }
        this.Loading = true;
        this.ErrorMessage = null;
        this.cdr.markForCheck();
        try {
            this.Cards = await LoadMembersForCommittee(this.CommitteeID, this.Provider ?? undefined);
        } catch (e) {
            this.ErrorMessage = e instanceof Error ? e.message : 'Could not load members.';
            this.Cards = [];
        } finally {
            this.Loading = false;
            this.cdr.markForCheck();
        }
    }
}
