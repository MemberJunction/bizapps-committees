import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { Router } from '@angular/router';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import {
    CommitteeHealthService,
    GovernancePortfolio,
    CommitteeHealthRow,
    AttentionItem
} from '@mj-biz-apps/committees-core';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';

/**
 * Governance Command Center — portfolio-wide health overview.
 *
 * Loads the full GovernancePortfolio once via CommitteeHealthService and
 * hands typed slices to presentational children (stats, health grid,
 * this-week rail, needs-attention rail). All signal computation lives in
 * the service; this component only owns load/refresh/search/navigation.
 */
@RegisterClass(BaseResourceComponent, 'CommandCenterComponent')
@Component({
    standalone: false,
    selector: 'command-center',
    templateUrl: './command-center.component.html',
    styleUrls: ['../shared/design-system.css', './command-center-shared.css', './command-center.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class CommandCenterComponent extends BaseResourceComponent implements OnInit {
    Portfolio: GovernancePortfolio | null = null;
    FilteredRows: CommitteeHealthRow[] = [];
    IsLoading = true;
    SearchText = '';
    Today = new Date();

    readonly SkeletonTiles = [0, 1, 2, 3];
    readonly SkeletonRows = [0, 1, 2, 3, 4, 5, 6, 7];
    readonly SkeletonRailItems = [0, 1, 2];

    private cdr = inject(ChangeDetectorRef);
    private router = inject(Router);

    async ngOnInit(): Promise<void> {
        this.NotifyLoadStarted();
        await this.loadPortfolio();
        this.IsLoading = false;
        this.NotifyLoadComplete();
        this.cdr.markForCheck();
    }

    async GetResourceDisplayName(_data: ResourceData): Promise<string> {
        return 'Command Center';
    }

    async GetResourceIconClass(_data: ResourceData): Promise<string> {
        return 'fa-solid fa-chart-simple';
    }

    async Refresh(): Promise<void> {
        this.IsLoading = true;
        this.cdr.markForCheck();
        await this.loadPortfolio();
        this.IsLoading = false;
        this.cdr.markForCheck();
    }

    OnSearchInput(event: Event): void {
        const input = event.target as HTMLInputElement;
        this.SearchText = input.value;
        this.applySearchFilter();
    }

    /** Mirrors ManagementDashboardComponent's tab navigation pattern. */
    NavigateToTab(tabName: string): void {
        this.router.navigate(['/app/mjcommitteemgmt', tabName]);
    }

    /** Opens the Committee Workspace for a specific committee. */
    OpenCommittee(committeeID: string): void {
        // Route segment must match the nav item Label exactly (case-sensitive)
        this.router.navigate(
            ['/app/mjcommitteemgmt', 'Committees'],
            { queryParams: { committeeId: committeeID } }
        );
    }

    OnRowSelected(row: CommitteeHealthRow): void {
        this.OpenCommittee(row.CommitteeID);
    }

    OnAttentionSelected(item: AttentionItem): void {
        this.OpenCommittee(item.CommitteeID);
    }

    get HasCommittees(): boolean {
        return (this.Portfolio?.Summary.TotalCommittees ?? 0) > 0;
    }

    private async loadPortfolio(): Promise<void> {
        const service = new CommitteeHealthService();
        const [portfolio, isStaff, memberCommitteeIDs] = await Promise.all([
            service.GetPortfolio(),
            CommitteePermissionHelper.IsStaffUser(),
            CommitteePermissionHelper.GetMemberCommitteeIDs()
        ]);
        this.applyLockState(portfolio.Rows, isStaff, memberCommitteeIDs);
        this.Portfolio = portfolio;
        this.Today = new Date();
        this.applySearchFilter();
    }

    /**
     * A row is locked when the committee is private and the current user is
     * neither staff (Committee Management app access) nor an active member.
     */
    private applyLockState(rows: CommitteeHealthRow[], isStaff: boolean, memberIDs: Set<string>): void {
        for (const row of rows) {
            row.IsLocked = !row.IsPublic && !isStaff && !memberIDs.has(row.CommitteeID);
        }
    }

    private applySearchFilter(): void {
        const rows = this.Portfolio?.Rows ?? [];
        const term = this.SearchText.trim().toLowerCase();
        this.FilteredRows = term.length === 0
            ? rows
            : rows.filter(r =>
                r.Name.toLowerCase().includes(term)
                || r.TypeName.toLowerCase().includes(term)
                || (r.ChairName ?? '').toLowerCase().includes(term));
        this.cdr.markForCheck();
    }
}

export function LoadCommandCenter(): void { }
