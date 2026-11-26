import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { Router } from '@angular/router';
import { RegisterClass, UUIDsEqual } from '@memberjunction/global';
import { BaseResourceComponent, NavigationService } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { CompositeKey, Metadata, RunView } from '@memberjunction/core';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';
import { CommitteeTaskService, CommitteeTaskRow } from '@mj-biz-apps/committees-core';

interface DashboardIdRow {
    ID: string;
}

interface DashboardMeetingRow {
    ID: string;
    Name: string;
    StartDateTime: string | Date;
    Committee: string | null;
    Status: string;
    LocationType?: string | null;
    VideoJoinURL?: string | null;
}

interface DashboardFileLinkRow {
    FileID: string;
}

interface DashboardDocumentRow {
    ID: string;
    Name: string;
    Category: string | null;
    Provider: string | null;
    __mj_CreatedAt: string | Date | null;
}

interface TypedBatchResult<T> {
    Success: boolean;
    Results: T[];
}

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

    RecentMeetings: DashboardMeetingRow[] = [];
    UpcomingMeetings: DashboardMeetingRow[] = [];
    MyTasks: CommitteeTaskRow[] = [];
    RecentDocuments: DashboardDocumentRow[] = [];

    IsLoading = true;
    TodayString = new Date().toISOString().split('T')[0];

    private readonly cdr = inject(ChangeDetectorRef);
    private readonly router = inject(Router);
    private readonly navigation = inject(NavigationService);

    async ngOnInit(): Promise<void> {
        queueMicrotask(() => this.NotifyLoadStarted());
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

    OpenMeetingRecord(meetingID: string): void {
        this.navigation.OpenEntityRecord('Committees: Meetings', CompositeKey.FromID(meetingID));
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
            return;
        }

        const committeeFilter = myCommitteeIDs.map(id => `'${id}'`).join(',');
        const rv = new RunView();
        const today = new Date().toISOString().split('T')[0];
        const committeeEntityID = new Metadata().EntityByName('Committees: Committees')?.ID ?? null;

        const tasksPromise = new CommitteeTaskService().GetTasks({});
        const [committees, upcoming, recent, links] = await rv.RunViews(
            this.buildDashboardQueries(committeeFilter, today, committeeEntityID));

        const tasks = (await tasksPromise).filter(t =>
            t.CommitteeIDs.some(cid => myCommitteeIDs.some(mine => UUIDsEqual(mine, cid))));
        this.applyDashboardResults(
            committees as TypedBatchResult<DashboardIdRow>,
            upcoming as TypedBatchResult<DashboardMeetingRow>,
            recent as TypedBatchResult<DashboardMeetingRow>,
            tasks,
            today
        );
        await this.loadRecentDocuments(rv, links as TypedBatchResult<DashboardFileLinkRow>);
    }

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
        committees: TypedBatchResult<DashboardIdRow>,
        upcoming: TypedBatchResult<DashboardMeetingRow>,
        recent: TypedBatchResult<DashboardMeetingRow>,
        tasks: CommitteeTaskRow[],
        today: string
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

    private async resolveUserCommitteeIDs(): Promise<string[]> {
        const memberships = await CommitteePermissionHelper.GetCurrentUserMemberships();
        return [...new Set(memberships.map(m => m.CommitteeID).filter(Boolean))];
    }

    private async loadRecentDocuments(rv: RunView, linksResult: TypedBatchResult<DashboardFileLinkRow>): Promise<void> {
        if (!linksResult.Success || linksResult.Results.length === 0) {
            this.RecentDocuments = [];
            this.DocumentCount = 0;
            return;
        }

        const fileIDs = [...new Set(linksResult.Results.map(l => l.FileID))];
        const fileIDFilter = fileIDs.map(id => `'${id}'`).join(', ');

        const filesResult = await rv.RunView<DashboardDocumentRow>({
            EntityName: 'MJ: Files',
            Fields: ['ID', 'Name', 'Category', 'Provider', '__mj_CreatedAt'],
            ExtraFilter: `ID IN (${fileIDFilter}) AND Status != 'Deleted'`,
            OrderBy: '__mj_CreatedAt DESC',
            MaxRows: 5,
            ResultType: 'simple'
        });

        if (filesResult.Success) {
            this.RecentDocuments = filesResult.Results ?? [];
            this.DocumentCount = this.RecentDocuments.length;
        }
    }
}

export function LoadCommitteeDashboard() { }
