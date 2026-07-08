import { Component, ChangeDetectionStrategy, Input, Output, EventEmitter } from '@angular/core';
import {
    CommitteeHealthRow,
    HealthLevel,
    QuorumRiskLevel,
    ACTION_ERROR_THRESHOLD,
    MINUTES_AGE_CALLOUT_DAYS
} from '@mj-biz-apps/committees-core';
import { StatusBadge, FormatShortDate } from './status-badge';

/**
 * Governance health grid — one row per committee with health, quorum,
 * term-hygiene, minutes-debt, and action-aging signals. Rows arrive
 * pre-sorted (needs-attention first) from CommitteeHealthService.
 * Pure presentation: no data loading, emits RowSelected on name click.
 */
@Component({
    standalone: false,
    selector: 'health-grid',
    templateUrl: './health-grid.component.html',
    styleUrls: ['../shared/design-system.css', './command-center-shared.css', './health-grid.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class HealthGridComponent {
    @Input({ required: true }) Rows!: CommitteeHealthRow[];
    /** Unfiltered committee count, for the "Showing X of Y" footer. */
    @Input({ required: true }) TotalCount!: number;
    @Output() RowSelected = new EventEmitter<CommitteeHealthRow>();

    CommitteeIcon(row: CommitteeHealthRow): string {
        const type = row.TypeName.toLowerCase();
        if (type === 'board') return 'fa-solid fa-landmark';
        if (type === 'ad hoc') return 'fa-solid fa-clock';
        if (type.startsWith('standards')) return 'fa-solid fa-flag';
        return 'fa-solid fa-users';
    }

    HealthDotClass(health: HealthLevel): string {
        const map: Record<HealthLevel, string> = {
            AtRisk: 'risk', Watch: 'watch', Healthy: 'ok', Pending: 'off', Dissolved: 'off'
        };
        return map[health];
    }

    HealthLabel(health: HealthLevel): string {
        const map: Record<HealthLevel, string> = {
            AtRisk: 'At risk', Watch: 'Watch', Healthy: 'Healthy', Pending: 'Pending', Dissolved: 'Dissolved'
        };
        return map[health];
    }

    QuorumBadge(row: CommitteeHealthRow): StatusBadge {
        const map: Record<QuorumRiskLevel, StatusBadge> = {
            High: { Tone: 'error', Label: 'High' },
            Medium: { Tone: 'warning', Label: 'Medium' },
            Low: { Tone: 'success', Label: 'Low' },
            None: { Tone: 'neutral', Label: '—' }
        };
        return map[row.Quorum.Level];
    }

    TermBadge(row: CommitteeHealthRow): StatusBadge {
        const term = row.Term;
        switch (term.Kind) {
            case 'NoActiveTerm':
                return { Tone: 'error', Label: 'No term' };
            case 'EndingSoon':
                return { Tone: 'warning', Label: `${FormatShortDate(term.EndDate)} · ${term.DaysRemaining}d` };
            case 'Current':
                if (term.HasStagedNextTerm) return { Tone: 'success', Label: 'Staged ✓' };
                return { Tone: 'neutral', Label: term.EndDate ? FormatShortDate(term.EndDate) : 'Ongoing' };
            case 'NotStarted':
                return { Tone: 'neutral', Label: 'Not started' };
            case 'Completed':
                return { Tone: 'neutral', Label: 'Completed' };
        }
    }

    MinutesBadge(row: CommitteeHealthRow): StatusBadge {
        if (row.Health === 'Pending' || row.Health === 'Dissolved') {
            return { Tone: 'neutral', Label: '—' };
        }
        const minutes = row.Minutes;
        if (minutes.PendingCount === 0) return { Tone: 'neutral', Label: 'Current' };
        if (minutes.OldestPendingDays > MINUTES_AGE_CALLOUT_DAYS) {
            return { Tone: 'warning', Label: `Draft ${minutes.OldestPendingDays}d` };
        }
        return { Tone: 'warning', Label: `${minutes.PendingCount} pending` };
    }

    ActionsBadge(row: CommitteeHealthRow): StatusBadge {
        if (row.Health === 'Dissolved') return { Tone: 'neutral', Label: 'Closed' };
        if (row.Health === 'Pending') return { Tone: 'neutral', Label: '—' };
        const actions = row.Actions;
        if (actions.OverdueCount >= ACTION_ERROR_THRESHOLD) {
            return { Tone: 'error', Label: `${actions.OpenCount} open ⚠` };
        }
        if (actions.OverdueCount > 0) {
            return { Tone: 'warning', Label: `${actions.OpenCount} open ⚠` };
        }
        return { Tone: 'neutral', Label: `${actions.OpenCount} open` };
    }
}
