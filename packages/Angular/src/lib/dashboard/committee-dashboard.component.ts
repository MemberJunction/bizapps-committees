import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { Router } from '@angular/router';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { Metadata, RunView } from '@memberjunction/core';
import { UUIDsEqual } from '@memberjunction/global';
import { CommitteeTaskService, CommitteeTaskRow } from '@mj-biz-apps/committees-core';

interface RunViewBatchResult { Success: boolean; Results: Record<string, unknown>[]; }

@RegisterClass(BaseResourceComponent, 'CommitteeDashboardComponent')
@Component({
    standalone: false,
    selector: 'committees-dashboard',
    templateUrl: './committee-dashboard.component.html',
    styleUrls: ['../shared/design-system.css', './committee-dashboard.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class CommitteeDashboardComponent extends BaseResourceComponent implements OnInit {
    CommitteeCount = 0;
    ActiveMeetingCount = 0;
    OpenTaskCount = 0;
    OverdueTaskCount = 0;
    DocumentCount = 0;

    RecentMeetings: Record<string, unknown>[] = [];
    UpcomingMeetings: Record<string, unknown>[] = [];
    MyTasks: CommitteeTaskRow[] = [];
    RecentDocuments: Record<string, unknown>[] = [];

    IsLoading = true;
    TodayString = new Date().toISOString().split('T')[0];

    private cdr = inject(ChangeDetectorRef);
    private router = inject(Router);

    async ngOnInit(): Promise<void> {
        this.NotifyLoadStarted();
        await this.loadDashboardData();
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

    FormatStatus(status: string): string {
        if (!status) return '';
        return status.replace(/([a-z])([A-Z])/g, '$1 $2');
    }

    private async loadDashboardData(): Promise<void> {
        const myCommitteeIDs = await this.resolveUserCommitteeIDs();
        if (myCommitteeIDs.length === 0) {
            // User is not a member of any committees
            return;
        }

        const committeeFilter = myCommitteeIDs.map(id => `'${id}'`).join(',');
        const rv = new RunView();
        const today = new Date().toISOString().split('T')[0];
        const committeeEntityID = new Metadata().EntityByName('Committees: Committees')?.ID ?? null;

        // Open tasks come from BizAppsTasks, concurrently with the batch below.
        const tasksPromise = new CommitteeTaskService().GetTasks({});
        const [committees, upcoming, recent, links] = await rv.RunViews(
            this.buildDashboardQueries(committeeFilter, today, committeeEntityID));

        const tasks = (await tasksPromise).filter(t =>
            t.CommitteeIDs.some(cid => myCommitteeIDs.some(mine => UUIDsEqual(mine, cid))));
        this.applyDashboardResults(committees, upcoming, recent, tasks, today);
        await this.loadRecentDocuments(rv, links);
    }

    /** The dashboard's five independent reads — one batch, one round trip. */
    private buildDashboardQueries(committeeFilter: string, today: string, committeeEntityID: string | null): Parameters<RunView['RunViews']>[0] {
        return [
            {
                EntityName: 'Committees: Committees',
                ExtraFilter: `Status='Active' AND ID IN (${committeeFilter})`,
                Fields: ['ID'],
                ResultType: 'simple'
            },
            {
                EntityName: 'Committees: Meetings',
                ExtraFilter: `StartDateTime >= '${today}' AND Status IN ('Scheduled', 'Draft') AND CommitteeID IN (${committeeFilter})`,
                Fields: ['ID', 'Name', 'StartDateTime', 'Committee', 'Status', 'LocationType', 'VideoJoinURL'],
                OrderBy: 'StartDateTime ASC',
                MaxRows: 10,
                ResultType: 'simple'
            },
            {
                EntityName: 'Committees: Meetings',
                ExtraFilter: `Status = 'Completed' AND CommitteeID IN (${committeeFilter})`,
                Fields: ['ID', 'Name', 'StartDateTime', 'Committee', 'Status'],
                OrderBy: 'StartDateTime DESC',
                MaxRows: 5,
                ResultType: 'simple'
            },
            {
                EntityName: 'MJ: File Entity Record Links',
                Fields: ['FileID'],
                ExtraFilter: committeeEntityID
                    ? `EntityID = '${committeeEntityID}' AND RecordID IN (${committeeFilter})`
                    : '1=0',
                ResultType: 'simple'
            }
        ];
    }

    private applyDashboardResults(
        committees: RunViewBatchResult, upcoming: RunViewBatchResult,
        recent: RunViewBatchResult, tasks: CommitteeTaskRow[], today: string
    ): void {
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
        this.MyTasks = tasks.slice(0, 20);
        this.OpenTaskCount = tasks.length;
        this.OverdueTaskCount = tasks.filter(t => t.DueAt != null && t.DueAt < today).length;
    }

    /**
     * Resolves the current user's committee IDs through:
     * User → Person (LinkedUserID) → Membership (active) → Term → Committee
     */
    private async resolveUserCommitteeIDs(): Promise<string[]> {
        const md = new Metadata();
        const userID = md.CurrentUser?.ID;
        if (!userID) return [];

        const rv = new RunView();

        // User → Person
        const personResult = await rv.RunView<{ ID: string }>({
            EntityName: 'MJ_BizApps_Common: People',
            ExtraFilter: `LinkedUserID = '${userID}'`,
            Fields: ['ID'],
            MaxRows: 1,
            ResultType: 'simple'
        });
        if (!personResult.Success || !personResult.Results || personResult.Results.length === 0) return [];

        const personID = personResult.Results[0].ID;

        // Person → Active Memberships
        const memberResult = await rv.RunView<{ TermID: string }>({
            EntityName: 'Committees: Memberships',
            ExtraFilter: `PersonID = '${personID}' AND Status = 'Active'`,
            Fields: ['TermID'],
            ResultType: 'simple'
        });
        if (!memberResult.Success || !memberResult.Results || memberResult.Results.length === 0) return [];

        // Terms → Committees
        const termIDs = [...new Set(memberResult.Results.map(m => m.TermID))];
        const termIDsStr = termIDs.map(id => `'${id}'`).join(',');
        const termResult = await rv.RunView<{ CommitteeID: string }>({
            EntityName: 'Committees: Terms',
            ExtraFilter: `ID IN (${termIDsStr})`,
            Fields: ['CommitteeID'],
            ResultType: 'simple'
        });
        if (!termResult.Success || !termResult.Results) return [];

        return [...new Set(termResult.Results.map(t => t.CommitteeID))];
    }

    private async loadRecentDocuments(rv: RunView, linksResult: RunViewBatchResult): Promise<void> {
        if (!linksResult.Success || linksResult.Results.length === 0) {
            this.RecentDocuments = [];
            this.DocumentCount = 0;
            return;
        }

        const fileIDs = [...new Set((linksResult.Results as { FileID: string }[]).map(l => l.FileID))];
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
