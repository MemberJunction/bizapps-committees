import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { Metadata, RunView } from '@memberjunction/core';
import { MeetingDialogResult } from './meeting-edit-dialog.component';

@RegisterClass(BaseResourceComponent, 'MeetingListComponent')
@Component({
    standalone: false,
    selector: 'committees-meeting-list',
    templateUrl: './meeting-list.component.html',
    styleUrls: ['./meeting-list.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class MeetingListComponent extends BaseResourceComponent implements OnInit {
    UpcomingMeetings: Record<string, unknown>[] = [];
    PastMeetings: Record<string, unknown>[] = [];
    IsLoading = true;
    ActiveTab: 'upcoming' | 'past' = 'upcoming';

    /** Dialog state */
    ShowEditDialog = false;
    EditingMeetingID: string | null = null;

    /** Permission state */
    IsAnyOfficer = false;

    private cdr = inject(ChangeDetectorRef);

    async ngOnInit(): Promise<void> {
        this.NotifyLoadStarted();
        await Promise.all([
            this.LoadMeetings(),
            this.LoadUserOfficerStatus()
        ]);
        this.IsLoading = false;
        this.NotifyLoadComplete();
        this.cdr.markForCheck();
    }

    async GetResourceDisplayName(_data: ResourceData): Promise<string> {
        return 'Meetings';
    }

    async GetResourceIconClass(_data: ResourceData): Promise<string> {
        return 'fa-solid fa-calendar';
    }

    OnTabChanged(tab: 'upcoming' | 'past'): void {
        this.ActiveTab = tab;
        this.cdr.markForCheck();
    }

    GetLocationIcon(locationType: string): string {
        switch (locationType) {
            case 'Virtual': return 'fa-solid fa-video';
            case 'InPerson': return 'fa-solid fa-location-dot';
            default: return 'fa-solid fa-arrows-split-up-and-left';
        }
    }

    OnJoinMeeting(event: Event, url: string): void {
        event.stopPropagation(); // Don't trigger card click (edit)
        window.open(url, '_blank', 'noopener');
    }

    OnCreateMeeting(): void {
        this.EditingMeetingID = null;
        this.ShowEditDialog = true;
        this.cdr.markForCheck();
    }

    OnEditMeeting(meetingID: string): void {
        this.EditingMeetingID = meetingID;
        this.ShowEditDialog = true;
        this.cdr.markForCheck();
    }

    async OnDialogClosed(result: MeetingDialogResult): Promise<void> {
        this.ShowEditDialog = false;
        if (result.Saved) {
            await this.LoadMeetings();
        }
        this.cdr.markForCheck();
    }

    private async LoadUserOfficerStatus(): Promise<void> {
        const md = new Metadata();
        const userID = md.CurrentUser?.ID;
        if (!userID) return;

        const rv = new RunView();
        const personResult = await rv.RunView<{ ID: string }>({
            EntityName: 'MJ.BizApps.Common: People',
            ExtraFilter: `LinkedUserID = '${userID}'`,
            Fields: ['ID'],
            MaxRows: 1,
            ResultType: 'simple'
        });
        if (!personResult.Success || !personResult.Results || personResult.Results.length === 0) return;

        const personID = personResult.Results[0].ID;
        const memberResult = await rv.RunView<{ RoleID: string }>({
            EntityName: 'Memberships',
            ExtraFilter: `PersonID = '${personID}' AND Status = 'Active'`,
            Fields: ['RoleID'],
            ResultType: 'simple'
        });
        if (!memberResult.Success || !memberResult.Results || memberResult.Results.length === 0) return;

        const roleIDs = [...new Set(memberResult.Results.map(m => m.RoleID))];
        const roleIDsStr = roleIDs.map(id => `'${id}'`).join(',');
        const roleResult = await rv.RunView<{ IsOfficer: boolean | number }>({
            EntityName: 'Roles',
            ExtraFilter: `ID IN (${roleIDsStr}) AND IsOfficer = 1`,
            Fields: ['ID'],
            MaxRows: 1,
            ResultType: 'simple'
        });

        this.IsAnyOfficer = roleResult.Success && roleResult.Results != null && roleResult.Results.length > 0;
    }

    private async LoadMeetings(): Promise<void> {
        const rv = new RunView();
        const today = new Date().toISOString().split('T')[0];

        const [upcoming, past] = await rv.RunViews([
            {
                EntityName: 'Meetings',
                ExtraFilter: `StartDateTime >= '${today}' AND Status NOT IN ('Cancelled', 'Completed')`,
                Fields: ['ID', 'Title', 'StartDateTime', 'EndDateTime', 'Committee', 'Status', 'LocationType', 'Location', 'VideoJoinURL'],
                OrderBy: 'StartDateTime ASC',
                MaxRows: 50,
                ResultType: 'simple'
            },
            {
                EntityName: 'Meetings',
                ExtraFilter: `StartDateTime < '${today}' OR Status IN ('Cancelled', 'Completed')`,
                Fields: ['ID', 'Title', 'StartDateTime', 'EndDateTime', 'Committee', 'Status', 'LocationType', 'Location', 'VideoJoinURL'],
                OrderBy: 'StartDateTime DESC',
                MaxRows: 50,
                ResultType: 'simple'
            }
        ]);

        if (upcoming.Success) {
            this.UpcomingMeetings = upcoming.Results;
        }
        if (past.Success) {
            this.PastMeetings = past.Results;
        }
    }
}

export function LoadMeetingList() { }
