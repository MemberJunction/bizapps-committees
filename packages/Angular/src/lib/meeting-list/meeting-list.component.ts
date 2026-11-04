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
    ActiveView: 'list' | 'detail' = 'list';
    DetailMeetingID: string | null = null;

    /** Permission state — staff users see "Schedule Meeting" button */
    IsStaff = false;

    private cdr = inject(ChangeDetectorRef);

    async ngOnInit(): Promise<void> {
        this.NotifyLoadStarted();
        await Promise.all([
            this.loadMeetings(),
            this.loadPermissions()
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

    OnOpenMeeting(meetingID: string, _isPast: boolean): void {
        // Every meeting opens its detail view — prep (agenda builder) lives there,
        // and Start meeting launches the Live Meeting overlay from the same page.
        this.DetailMeetingID = meetingID;
        this.ActiveView = 'detail';
        this.cdr.markForCheck();
    }

    OnBackToList(): void {
        this.ActiveView = 'list';
        this.DetailMeetingID = null;
        this.loadMeetings();
        this.cdr.markForCheck();
    }

    async OnDialogClosed(result: MeetingDialogResult): Promise<void> {
        this.ShowEditDialog = false;
        if (result.Saved) {
            await this.loadMeetings();
        }
        this.cdr.markForCheck();
    }

    private async loadPermissions(): Promise<void> {
        this.IsStaff = await CommitteePermissionHelper.IsStaffUser();
    }

    private async loadMeetings(): Promise<void> {
        const rv = new RunView();
        const now = new Date().toISOString();

        const [upcoming, past] = await rv.RunViews([
            {
                EntityName: 'MJ_BizApps_Tasks: Meetings',
                ExtraFilter: `StartsAt >= '${now}' AND Status NOT IN ('Cancelled', 'Completed')`,
                Fields: ['ID', 'Name', 'StartsAt', 'EndsAt', 'Status', 'LocationType', 'Location', 'VideoJoinURL'],
                OrderBy: 'StartsAt ASC',
                MaxRows: 50,
                ResultType: 'simple'
            },
            {
                EntityName: 'MJ_BizApps_Tasks: Meetings',
                ExtraFilter: `StartsAt < '${now}' OR Status IN ('Cancelled', 'Completed')`,
                Fields: ['ID', 'Name', 'StartsAt', 'EndsAt', 'Status', 'LocationType', 'Location', 'VideoJoinURL'],
                OrderBy: 'StartsAt DESC',
                MaxRows: 50,
                ResultType: 'simple'
            }
        ]);

        if (upcoming.Success) {
            this.UpcomingMeetings = (upcoming.Results as Record<string, unknown>[]).map(r => ({
                ...r,
                StartDateTime: r['StartDateTime'] ?? r['StartsAt'],
                EndDateTime: r['EndDateTime'] ?? r['EndsAt'],
            }));
        }
        if (past.Success) {
            this.PastMeetings = (past.Results as Record<string, unknown>[]).map(r => ({
                ...r,
                StartDateTime: r['StartDateTime'] ?? r['StartsAt'],
                EndDateTime: r['EndDateTime'] ?? r['EndsAt'],
            }));
        }
    }
}

export function LoadMeetingList() { }
