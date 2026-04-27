import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { RunView } from '@memberjunction/core';
import { MeetingDialogResult } from './meeting-edit-dialog.component';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';

@RegisterClass(BaseResourceComponent, 'MeetingListComponent')
@Component({
    standalone: false,
    selector: 'committees-meeting-list',
    templateUrl: './meeting-list.component.html',
    styleUrls: ['../shared/design-system.css', './meeting-list.component.css'],
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

    /** View state */
    ActiveView: 'list' | 'live' | 'detail' = 'list';
    LiveMeetingID: string | null = null;
    DetailMeetingID: string | null = null;

    /** Permission state — staff users see "Schedule Meeting" button */
    IsStaff = false;

    private cdr = inject(ChangeDetectorRef);

    async ngOnInit(): Promise<void> {
        this.NotifyLoadStarted();
        await Promise.all([
            this.LoadMeetings(),
            this.LoadPermissions()
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
        event.stopPropagation();
        window.open(url, '_blank', 'noopener');
    }

    OnCreateMeeting(): void {
        this.EditingMeetingID = null;
        this.ShowEditDialog = true;
        this.cdr.markForCheck();
    }

    OnOpenMeeting(meetingID: string, isPast: boolean): void {
        if (isPast) {
            this.DetailMeetingID = meetingID;
            this.ActiveView = 'detail';
        } else {
            this.LiveMeetingID = meetingID;
            this.ActiveView = 'live';
        }
        this.cdr.markForCheck();
    }

    OnBackToList(): void {
        this.ActiveView = 'list';
        this.LiveMeetingID = null;
        this.DetailMeetingID = null;
        this.LoadMeetings();
        this.cdr.markForCheck();
    }

    async OnDialogClosed(result: MeetingDialogResult): Promise<void> {
        this.ShowEditDialog = false;
        if (result.Saved) {
            await this.LoadMeetings();
        }
        this.cdr.markForCheck();
    }

    private async LoadPermissions(): Promise<void> {
        this.IsStaff = await CommitteePermissionHelper.IsStaffUser();
    }

    private async LoadMeetings(): Promise<void> {
        const rv = new RunView();
        const now = new Date().toISOString();

        const [upcoming, past] = await rv.RunViews([
            {
                EntityName: 'Meetings',
                ExtraFilter: `StartDateTime >= '${now}' AND Status NOT IN ('Cancelled', 'Completed')`,
                Fields: ['ID', 'Title', 'StartDateTime', 'EndDateTime', 'Committee', 'Status', 'LocationType', 'Location', 'VideoJoinURL'],
                OrderBy: 'StartDateTime ASC',
                MaxRows: 50,
                ResultType: 'simple'
            },
            {
                EntityName: 'Meetings',
                ExtraFilter: `StartDateTime < '${now}' OR Status IN ('Cancelled', 'Completed')`,
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
