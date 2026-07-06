import { Component, ChangeDetectionStrategy, Input } from '@angular/core';
import { PortfolioSummary } from '@mj-biz-apps/committees-core';

/**
 * Command Center stat tiles: committees, serving members,
 * terms expiring within 90 days, and overdue actions.
 * Pure presentation — all numbers come from PortfolioSummary.
 */
@Component({
    standalone: false,
    selector: 'command-center-stats',
    templateUrl: './command-center-stats.component.html',
    styleUrls: ['../shared/design-system.css', './command-center-shared.css', './command-center-stats.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class CommandCenterStatsComponent {
    @Input({ required: true }) Summary!: PortfolioSummary;
}
