import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { Router } from '@angular/router';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { RunView } from '@memberjunction/core';

@RegisterClass(BaseResourceComponent, 'ManagementDashboardComponent')
@Component({
    standalone: false,
    selector: 'management-dashboard',
    templateUrl: './management-dashboard.component.html',
    styleUrls: ['../shared/design-system.css', '../dashboard/committee-dashboard.component.css', './management-dashboard.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class ManagementDashboardComponent extends BaseResourceComponent implements OnInit {
    CommitteeCount = 0;
    ActiveMeetingCount = 0;
    OpenActionItemCount = 0;
    OverdueActionItemCount = 0;
    MissingOfficerCount = 0;

    UpcomingMeetings: Record<string, unknown>[] = [];
    RecentMeetings: Record<string, unknown>[] = [];
    OverdueItems: Record<string, unknown>[] = [];

    IsLoading = true;
    todayString = new Date().toISOString().split('T')[0];

    private cdr = inject(ChangeDetectorRef);
    private router = inject(Router);

    async ngOnInit(): Promise<void> {
        this.NotifyLoadStarted();
        await this.LoadDashboardData();
        this.IsLoading = false;
        this.NotifyLoadComplete();
        this.cdr.markForCheck();
    }

    async GetResourceDisplayName(_data: ResourceData): Promise<string> {
        return 'Dashboard';
    }

    async GetResourceIconClass(_data: ResourceData): Promise<string> {
        return 'fa-solid fa-gauge';
    }

    NavigateToTab(tabName: string): void {
        this.router.navigate(['/app/mjcommitteemgmt', tabName]);
    }

    FormatStatus(status: string): string {
        if (!status) return '';
        return status.replace(/([a-z])([A-Z])/g, '$1 $2');
    }

    private async LoadDashboardData(): Promise<void> {
        const rv = new RunView();
        const today = new Date().toISOString().split('T')[0];

        const [committees, upcoming, recent, actionItems] = await rv.RunViews([
            {
                EntityName: 'Committees: Committees',
                ExtraFilter: "Status = 'Active'",
                Fields: ['ID'],
                ResultType: 'simple'
            },
            {
                EntityName: 'Committees: Meetings',
                ExtraFilter: `StartDateTime >= '${today}' AND Status IN ('Scheduled', 'Draft')`,
                Fields: ['ID', 'Title', 'StartDateTime', 'Committee', 'Status', 'LocationType', 'VideoJoinURL'],
                OrderBy: 'StartDateTime ASC',
                MaxRows: 10,
                ResultType: 'simple'
            },
            {
                EntityName: 'Committees: Meetings',
                ExtraFilter: "Status = 'Completed'",
                Fields: ['ID', 'Title', 'StartDateTime', 'Committee', 'Status'],
                OrderBy: 'StartDateTime DESC',
                MaxRows: 5,
                ResultType: 'simple'
            },
            {
                EntityName: 'Committees: Action Items',
                ExtraFilter: "Status IN ('Open', 'InProgress')",
                Fields: ['ID', 'Title', 'DueDate', 'Priority', 'Status', 'Committee', 'AssignedToPerson'],
                OrderBy: 'DueDate ASC',
                MaxRows: 20,
                ResultType: 'simple'
            }
        ]);

        if (committees.Success) {
            this.CommitteeCount = committees.Results.length;
        }
        if (upcoming.Success) {
            this.UpcomingMeetings = upcoming.Results;
            this.ActiveMeetingCount = upcoming.Results.length;
        }
        if (recent.Success) {
            this.RecentMeetings = recent.Results;
        }
        if (actionItems.Success) {
            this.OverdueItems = actionItems.Results.filter(
                (item: Record<string, unknown>) => {
                    const dueDate = item['DueDate'] as string | null;
                    return dueDate != null && dueDate < today;
                }
            );
            this.OpenActionItemCount = actionItems.Results.length;
            this.OverdueActionItemCount = this.OverdueItems.length;
        }
    }
}

export function LoadManagementDashboard() { }
