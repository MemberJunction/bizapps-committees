import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { RunView } from '@memberjunction/core';

@RegisterClass(BaseResourceComponent, 'CommitteeDashboardComponent')
@Component({
    standalone: false,
    selector: 'committees-dashboard',
    templateUrl: './committee-dashboard.component.html',
    styleUrls: ['./committee-dashboard.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class CommitteeDashboardComponent extends BaseResourceComponent implements OnInit {
    CommitteeCount = 0;
    ActiveMeetingCount = 0;
    OpenActionItemCount = 0;
    OverdueActionItemCount = 0;

    RecentMeetings: Record<string, unknown>[] = [];
    UpcomingMeetings: Record<string, unknown>[] = [];
    MyActionItems: Record<string, unknown>[] = [];

    IsLoading = true;
    todayString = new Date().toISOString().split('T')[0];

    private cdr = inject(ChangeDetectorRef);

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

    private async LoadDashboardData(): Promise<void> {
        const rv = new RunView();
        const today = new Date().toISOString().split('T')[0];

        const [committees, upcoming, recent, actionItems] = await rv.RunViews([
            {
                EntityName: 'Committees',
                ExtraFilter: "Status='Active'",
                Fields: ['ID'],
                ResultType: 'simple'
            },
            {
                EntityName: 'Meetings',
                ExtraFilter: `StartDateTime >= '${today}' AND Status IN ('Scheduled', 'Draft')`,
                Fields: ['ID', 'Title', 'StartDateTime', 'Committee', 'Status', 'LocationType'],
                OrderBy: 'StartDateTime ASC',
                MaxRows: 10,
                ResultType: 'simple'
            },
            {
                EntityName: 'Meetings',
                ExtraFilter: `Status = 'Completed'`,
                Fields: ['ID', 'Title', 'StartDateTime', 'Committee', 'Status'],
                OrderBy: 'StartDateTime DESC',
                MaxRows: 5,
                ResultType: 'simple'
            },
            {
                EntityName: 'Action Items',
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
            this.MyActionItems = actionItems.Results;
            this.OpenActionItemCount = actionItems.Results.length;
            this.OverdueActionItemCount = actionItems.Results.filter(
                (item: Record<string, unknown>) => {
                    const dueDate = item['DueDate'] as string | null;
                    return dueDate != null && dueDate < today;
                }
            ).length;
        }
    }
}

export function LoadCommitteeDashboard() { }
