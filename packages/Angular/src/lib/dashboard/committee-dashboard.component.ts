import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { Router } from '@angular/router';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { Metadata, RunView } from '@memberjunction/core';

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
    DocumentCount = 0;

    RecentMeetings: Record<string, unknown>[] = [];
    UpcomingMeetings: Record<string, unknown>[] = [];
    MyActionItems: Record<string, unknown>[] = [];
    RecentDocuments: Record<string, unknown>[] = [];

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
        this.router.navigate(['/app/mjcommittees', tabName]);
    }

    GetDocIcon(category: string | null | undefined): string {
        switch (category) {
            case 'Minutes': return 'fa-solid fa-file-lines';
            case 'Agenda': return 'fa-solid fa-list-check';
            case 'Recording': return 'fa-solid fa-video';
            case 'Transcript': return 'fa-solid fa-closed-captioning';
            case 'Presentation': return 'fa-solid fa-file-powerpoint';
            case 'Spreadsheet': return 'fa-solid fa-file-excel';
            case 'Image': return 'fa-solid fa-file-image';
            case 'Document': return 'fa-solid fa-file-word';
            default: return 'fa-solid fa-file';
        }
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
                Fields: ['ID', 'Title', 'StartDateTime', 'Committee', 'Status', 'LocationType', 'VideoJoinURL'],
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

        // Load recent documents via File Entity Record Links
        await this.LoadRecentDocuments(rv);
    }

    private async LoadRecentDocuments(rv: RunView): Promise<void> {
        const md = new Metadata();
        const committeeEntity = md.Entities.find(e => e.Name === 'Committees');
        if (!committeeEntity) return;

        // Get file IDs linked to any committee
        const linksResult = await rv.RunView<{ FileID: string }>({
            EntityName: 'MJ: File Entity Record Links',
            Fields: ['FileID'],
            ExtraFilter: `EntityID = '${committeeEntity.ID}'`,
            ResultType: 'simple'
        });

        if (!linksResult.Success || linksResult.Results.length === 0) {
            this.RecentDocuments = [];
            this.DocumentCount = 0;
            return;
        }

        const fileIDs = [...new Set(linksResult.Results.map(l => l.FileID))];
        const fileIDFilter = fileIDs.map(id => `'${id}'`).join(', ');

        const filesResult = await rv.RunView<Record<string, unknown>>({
            EntityName: 'MJ: Files',
            Fields: ['ID', 'Name', 'Category', 'Provider', '__mj_CreatedAt'],
            ExtraFilter: `ID IN (${fileIDFilter}) AND Status != 'Deleted'`,
            OrderBy: '__mj_CreatedAt DESC',
            MaxRows: 5,
            ResultType: 'simple'
        });

        if (filesResult.Success) {
            this.RecentDocuments = filesResult.Results;
            this.DocumentCount = filesResult.Results.length;
        }
    }
}

export function LoadCommitteeDashboard() { }
