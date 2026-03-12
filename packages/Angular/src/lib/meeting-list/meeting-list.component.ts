import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { RunView } from '@memberjunction/core';

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

    private cdr = inject(ChangeDetectorRef);

    async ngOnInit(): Promise<void> {
        this.NotifyLoadStarted();
        await this.LoadMeetings();
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

    private async LoadMeetings(): Promise<void> {
        const rv = new RunView();
        const today = new Date().toISOString().split('T')[0];

        const [upcoming, past] = await rv.RunViews([
            {
                EntityName: 'Meetings',
                ExtraFilter: `StartDateTime >= '${today}'`,
                Fields: ['ID', 'Title', 'StartDateTime', 'EndDateTime', 'Committee', 'Status', 'LocationType', 'Location'],
                OrderBy: 'StartDateTime ASC',
                MaxRows: 50,
                ResultType: 'simple'
            },
            {
                EntityName: 'Meetings',
                ExtraFilter: `StartDateTime < '${today}'`,
                Fields: ['ID', 'Title', 'StartDateTime', 'EndDateTime', 'Committee', 'Status', 'LocationType', 'Location'],
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
