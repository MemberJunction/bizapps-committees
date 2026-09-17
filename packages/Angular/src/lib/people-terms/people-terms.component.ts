import { Component, ChangeDetectionStrategy, ChangeDetectorRef, OnInit, inject } from '@angular/core';
import { RegisterClass , UUIDsEqual } from '@memberjunction/global';
import { CompositeKey } from '@memberjunction/core';
import { BaseResourceComponent, NavigationService } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import {
    SuccessionService, TermClock, LensChip, PipelineSeat, GanttRow,
    EXPIRING_WINDOW_DAYS,
} from '@mj-biz-apps/committees-core';

export function LoadPeopleTerms(): void { }

/**
 * People & Terms — UX v2 screen 05, "the term clock".
 * Portfolio lens + per-committee roster timeline + vacancy pipeline +
 * (on-demand) AI succession suggestions.
 */
@Component({
    standalone: false,
    selector: 'committees-people-terms',
    templateUrl: './people-terms.component.html',
    styleUrls: ['../command-center/command-center-shared.css', './people-terms.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
})
@RegisterClass(BaseResourceComponent, 'PeopleTermsComponent')
export class PeopleTermsComponent extends BaseResourceComponent implements OnInit {
    IsLoading = true;
    ErrorMessage = '';

    Clock: TermClock | null = null;
    SelectedCommitteeID: string | null = null;

    readonly ExpiringWindowDays = EXPIRING_WINDOW_DAYS;

    private cdr = inject(ChangeDetectorRef);
    private navigation = inject(NavigationService);
    private service = new SuccessionService();

    async GetResourceDisplayName(_data: ResourceData): Promise<string> { return 'People & Terms'; }
    async GetResourceIconClass(_data: ResourceData): Promise<string> { return 'fa-solid fa-timeline'; }

    async ngOnInit(): Promise<void> {
        await this.Load();
        // Required by the shell: clears the app loading screen on direct URL loads.
        this.NotifyLoadComplete();
    }

    async Load(): Promise<void> {
        this.IsLoading = true;
        this.ErrorMessage = '';
        this.cdr.detectChanges();
        try {
            this.Clock = await this.service.GetTermClock(this.SelectedCommitteeID);
            this.SelectedCommitteeID ??= this.Clock.Committees[0]?.ID ?? null;
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to load term clock';
        }
        this.IsLoading = false;
        this.cdr.detectChanges();
    }

    OnCommitteeChange(committeeID: string): void {
        this.SelectedCommitteeID = committeeID;
        void this.Load();
    }

    // ── Derived ─────────────────────────────────────────────────

    get ExpiringCount(): number {
        return this.Clock?.Lens.filter(c => c.State === 'Expiring').length ?? 0;
    }

    get LapsedCount(): number {
        return this.Clock?.Lens.filter(c => c.State === 'Lapsed').length ?? 0;
    }

    get SelectedCommitteeName(): string {
        return this.Clock?.Committees.find(c => UUIDsEqual(c.ID, this.SelectedCommitteeID))?.Name ?? '';
    }

    get OpeningsCount(): number {
        return this.Clock?.Pipeline.filter(s => s.Status === 'Opening' || s.Status === 'AtRisk').length ?? 0;
    }

    LensTone(chip: LensChip): string {
        switch (chip.State) {
            case 'Lapsed': return 'err';
            case 'Expiring': return 'warn';
            case 'Renewed': return 'ok';
            default: return 'neutral';
        }
    }

    LensWhen(chip: LensChip): string {
        switch (chip.State) {
            case 'Lapsed': return 'Lapsed';
            case 'Renewed': return 'Renewed ✓';
            case 'Expiring': {
                const d = chip.EndDate ? chip.EndDate.toLocaleDateString([], { month: 'short', day: 'numeric', timeZone: 'UTC' }) : '';
                return `${d} · ${chip.DaysRemaining}d`;
            }
            default: return 'Current';
        }
    }

    SeatTone(seat: PipelineSeat): string {
        switch (seat.Status) {
            case 'Opening': return 'error';
            case 'AtRisk': return 'warning';
            case 'Returning': return 'success';
            default: return 'neutral';
        }
    }

    SeatLabel(seat: PipelineSeat): string {
        switch (seat.Status) {
            case 'Opening': return 'Opening';
            case 'AtRisk': return 'At risk';
            case 'Returning': return 'Returning';
            default: return 'Awaiting answer';
        }
    }

    RowFlag(row: GanttRow): { label: string; tone: string } | null {
        if (row.RenewalIntent === 'No') return { label: 'not returning', tone: 'neutral' };
        if (row.AttendanceRate != null && row.AttendanceRate < 0.5) {
            return { label: `${Math.round(row.AttendanceRate * 100)}% attendance`, tone: 'error' };
        }
        if (row.RenewalIntent === 'Yes') return { label: 'returning', tone: 'success' };
        return null;
    }

    Initials(name: string): string {
        return name.split(/\s+/).filter(Boolean).slice(0, 2).map(p => p[0]).join('').toUpperCase();
    }

    OpenCommittee(committeeID: string): void {
        this.navigation.OpenEntityRecord(
            'Committees: Committees',
            CompositeKey.FromID(committeeID),
        );
    }

    // ── Term-renewal wizard ─────────────────────────────────────

    RenewalCommitteeID: string | null = null;

    /** Lapsed chips say "renew now" — they open the wizard; the rest open the committee. */
    OnChipClick(chip: LensChip): void {
        if (chip.State === 'Lapsed') this.OpenRenewal(chip.CommitteeID);
        else this.OpenCommittee(chip.CommitteeID);
    }

    OpenRenewal(committeeID: string | null): void {
        if (!committeeID) return;
        this.RenewalCommitteeID = committeeID;
        this.cdr.detectChanges();
    }

    async OnRenewalExited(created: boolean): Promise<void> {
        const committeeID = this.RenewalCommitteeID;
        this.RenewalCommitteeID = null;
        this.cdr.detectChanges();
        if (created && committeeID) {
            this.SelectedCommitteeID = committeeID;
            await this.Load();
        }
    }
}
