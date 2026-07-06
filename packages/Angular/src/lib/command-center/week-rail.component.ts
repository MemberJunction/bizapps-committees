import { Component, ChangeDetectionStrategy, Input } from '@angular/core';
import { UpcomingMeetingForecast } from '@mj-biz-apps/committees-core';
import { StatusBadge } from './status-badge';

/**
 * "This week" rail — meetings scheduled in the next 7 days with a
 * quorum-forecast or agenda-readiness badge. Pure presentation.
 */
@Component({
    standalone: false,
    selector: 'week-rail',
    templateUrl: './week-rail.component.html',
    styleUrls: ['../shared/design-system.css', './command-center-shared.css', './week-rail.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class WeekRailComponent {
    @Input({ required: true }) Meetings!: UpcomingMeetingForecast[];

    PlatformLabel(meeting: UpcomingMeetingForecast): string {
        if (meeting.VideoProviderName) return meeting.VideoProviderName;
        if (meeting.LocationText) return meeting.LocationText;
        return meeting.LocationType ?? 'Location TBD';
    }

    PlatformIcon(meeting: UpcomingMeetingForecast): string {
        return meeting.VideoProviderName ? 'fa-solid fa-video' : 'fa-solid fa-location-dot';
    }

    ForecastBadge(meeting: UpcomingMeetingForecast): StatusBadge {
        const quorum = meeting.Quorum;
        if (quorum.Level === 'High' || quorum.Level === 'Medium') {
            return { Tone: 'warning', Label: `Quorum at risk ${quorum.ExpectedAttendees}/${quorum.Required}` };
        }
        if (quorum.Level === 'Low') {
            return { Tone: 'success', Label: `Quorum forecast ${Math.ceil(quorum.ExpectedAttendees)}/${quorum.Required}` };
        }
        if (meeting.AgendaItemCount > 0) {
            return { Tone: 'neutral', Label: 'Agenda drafted' };
        }
        return { Tone: 'neutral', Label: `${meeting.AgendaItemCount} agenda items` };
    }
}
