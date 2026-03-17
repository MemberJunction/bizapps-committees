import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { Router } from '@angular/router';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { Metadata, RunView } from '@memberjunction/core';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';

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
    IsAnyOfficer = false;
    todayString = new Date().toISOString().split('T')[0];

    private cdr = inject(ChangeDetectorRef);
    private router = inject(Router);

    async ngOnInit(): Promise<void> {
        this.NotifyLoadStarted();
        await Promise.all([
            this.LoadDashboardData(),
            this.LoadPermissions()
        ]);
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

    private async LoadPermissions(): Promise<void> {
        this.IsAnyOfficer = await CommitteePermissionHelper.IsOfficerInAny();
    }

    private async LoadDashboardData(): Promise<void> {
        const myCommitteeIDs = await this.ResolveUserCommitteeIDs();

        if (myCommitteeIDs.length === 0) {
            // User is not a member of any committees
            return;
        }

        const committeeFilter = myCommitteeIDs.map(id => `'${id}'`).join(',');
        const rv = new RunView();
        const today = new Date().toISOString().split('T')[0];

        const [committees, upcoming, recent, actionItems] = await rv.RunViews([
            {
                EntityName: 'Committees',
                ExtraFilter: `Status='Active' AND ID IN (${committeeFilter})`,
                Fields: ['ID'],
                ResultType: 'simple'
            },
            {
                EntityName: 'Meetings',
                ExtraFilter: `StartDateTime >= '${today}' AND Status IN ('Scheduled', 'Draft') AND CommitteeID IN (${committeeFilter})`,
                Fields: ['ID', 'Title', 'StartDateTime', 'Committee', 'Status', 'LocationType', 'VideoJoinURL'],
                OrderBy: 'StartDateTime ASC',
                MaxRows: 10,
                ResultType: 'simple'
            },
            {
                EntityName: 'Meetings',
                ExtraFilter: `Status = 'Completed' AND CommitteeID IN (${committeeFilter})`,
                Fields: ['ID', 'Title', 'StartDateTime', 'Committee', 'Status'],
                OrderBy: 'StartDateTime DESC',
                MaxRows: 5,
                ResultType: 'simple'
            },
            {
                EntityName: 'Action Items',
                ExtraFilter: `Status IN ('Open', 'InProgress') AND CommitteeID IN (${committeeFilter})`,
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
        await this.LoadRecentDocuments(rv, myCommitteeIDs);
    }

    /**
     * Resolves the current user's committee IDs through:
     * User → Person (LinkedUserID) → Membership (active) → Term → Committee
     */
    private async ResolveUserCommitteeIDs(): Promise<string[]> {
        const md = new Metadata();
        const userID = md.CurrentUser?.ID;
        if (!userID) return [];

        const rv = new RunView();

        // User → Person
        const personResult = await rv.RunView<{ ID: string }>({
            EntityName: 'MJ.BizApps.Common: People',
            ExtraFilter: `LinkedUserID = '${userID}'`,
            Fields: ['ID'],
            MaxRows: 1,
            ResultType: 'simple'
        });
        if (!personResult.Success || !personResult.Results || personResult.Results.length === 0) return [];

        const personID = personResult.Results[0].ID;

        // Person → Active Memberships
        const memberResult = await rv.RunView<{ TermID: string }>({
            EntityName: 'Memberships',
            ExtraFilter: `PersonID = '${personID}' AND Status = 'Active'`,
            Fields: ['TermID'],
            ResultType: 'simple'
        });
        if (!memberResult.Success || !memberResult.Results || memberResult.Results.length === 0) return [];

        // Terms → Committees
        const termIDs = [...new Set(memberResult.Results.map(m => m.TermID))];
        const termIDsStr = termIDs.map(id => `'${id}'`).join(',');
        const termResult = await rv.RunView<{ CommitteeID: string }>({
            EntityName: 'Terms',
            ExtraFilter: `ID IN (${termIDsStr})`,
            Fields: ['CommitteeID'],
            ResultType: 'simple'
        });
        if (!termResult.Success || !termResult.Results) return [];

        return [...new Set(termResult.Results.map(t => t.CommitteeID))];
    }

    private async LoadRecentDocuments(rv: RunView, committeeIDs: string[]): Promise<void> {
        const md = new Metadata();
        const committeeEntity = md.Entities.find(e => e.Name === 'Committees');
        if (!committeeEntity) return;

        const committeeFilter = committeeIDs.map(id => `'${id}'`).join(',');

        // Get file IDs linked to the user's committees
        const linksResult = await rv.RunView<{ FileID: string }>({
            EntityName: 'MJ: File Entity Record Links',
            Fields: ['FileID'],
            ExtraFilter: `EntityID = '${committeeEntity.ID}' AND RecordID IN (${committeeFilter})`,
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
