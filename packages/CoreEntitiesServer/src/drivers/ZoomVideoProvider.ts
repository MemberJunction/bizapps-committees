import { RegisterClass } from '@memberjunction/global';
import { VideoProviderBase, VideoMeetingInput, VideoMeetingResult, VideoProviderCredentials, MeetingAttendee } from './VideoProviderBase.js';

interface ZoomTokenResponse {
    access_token: string;
    token_type: string;
    expires_in: number;
}

interface ZoomCreateMeetingResponse {
    id: number;
    join_url: string;
    start_url: string;
}

/**
 * Zoom Server-to-Server OAuth driver.
 *
 * Credentials required (stored via CredentialEngine):
 *   client_id     — from Zoom Server-to-Server OAuth app
 *   client_secret — from Zoom Server-to-Server OAuth app
 *   account_id    — Zoom account ID
 *
 * No user OAuth redirect needed — uses client credentials flow.
 */
@RegisterClass(VideoProviderBase, 'ZoomVideoProvider')
export class ZoomVideoProvider extends VideoProviderBase {
    private clientId = '';
    private clientSecret = '';
    private accountId = '';
    private configured = false;

    async Initialize(credentials: VideoProviderCredentials): Promise<void> {
        this.clientId = credentials.client_id;
        this.clientSecret = credentials.client_secret;
        this.accountId = credentials.account_id;
        this.configured = !!(this.clientId && this.clientSecret && this.accountId);
    }

    get IsConfigured(): boolean {
        return this.configured;
    }

    async CreateMeeting(input: VideoMeetingInput): Promise<VideoMeetingResult> {
        const accessToken = await this.fetchAccessToken();
        return this.createZoomMeeting(accessToken, input);
    }

    async DeleteMeeting(providerMeetingID: string): Promise<void> {
        const accessToken = await this.fetchAccessToken();
        await fetch(`https://api.zoom.us/v2/meetings/${providerMeetingID}`, {
            method: 'DELETE',
            headers: { Authorization: `Bearer ${accessToken}` },
        });
    }

    private async fetchAccessToken(): Promise<string> {
        const credentials = Buffer.from(`${this.clientId}:${this.clientSecret}`).toString('base64');
        const url = `https://zoom.us/oauth/token?grant_type=account_credentials&account_id=${encodeURIComponent(this.accountId)}`;

        const response = await fetch(url, {
            method: 'POST',
            headers: {
                Authorization: `Basic ${credentials}`,
                'Content-Type': 'application/x-www-form-urlencoded',
            },
        });

        if (!response.ok) {
            const body = await response.text();
            throw new Error(`Zoom token request failed (${response.status}): ${body}`);
        }

        const data = await response.json() as ZoomTokenResponse;
        return data.access_token;
    }

    private async createZoomMeeting(accessToken: string, input: VideoMeetingInput): Promise<VideoMeetingResult> {
        const durationMinutes = input.EndDateTime
            ? Math.round((input.EndDateTime.getTime() - input.StartDateTime.getTime()) / 60000)
            : 60;

        const body = {
            topic: input.Title,
            type: 2, // Scheduled meeting
            start_time: input.StartDateTime.toISOString(),
            duration: durationMinutes,
            timezone: input.TimeZone ?? 'UTC',
            agenda: input.Description ?? '',
            settings: {
                join_before_host: true,
                waiting_room: false,
                approval_type: 0,       // Auto-approve registrants
                registration_type: 1,   // Required registration (enables invite emails)
            },
        };

        const response = await fetch('https://api.zoom.us/v2/users/me/meetings', {
            method: 'POST',
            headers: {
                Authorization: `Bearer ${accessToken}`,
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(body),
        });

        if (!response.ok) {
            const errorBody = await response.text();
            throw new Error(`Zoom create meeting failed (${response.status}): ${errorBody}`);
        }

        const data = await response.json() as ZoomCreateMeetingResponse;
        return {
            JoinURL: data.join_url,
            ProviderMeetingID: String(data.id),
        };
    }

    async SendInvites(providerMeetingID: string, attendees: MeetingAttendee[]): Promise<void> {
        if (attendees.length === 0) return;
        const accessToken = await this.fetchAccessToken();
        await Promise.all(attendees.map(a => this.addRegistrant(accessToken, providerMeetingID, a)));
    }

    private async addRegistrant(accessToken: string, meetingId: string, attendee: MeetingAttendee): Promise<void> {
        const spaceIdx = attendee.FullName.indexOf(' ');
        const firstName = spaceIdx > 0 ? attendee.FullName.slice(0, spaceIdx) : attendee.FullName;
        const lastName  = spaceIdx > 0 ? attendee.FullName.slice(spaceIdx + 1) : ' ';

        const response = await fetch(`https://api.zoom.us/v2/meetings/${meetingId}/registrants`, {
            method: 'POST',
            headers: {
                Authorization: `Bearer ${accessToken}`,
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ email: attendee.Email, first_name: firstName, last_name: lastName }),
        });

        if (!response.ok) {
            const text = await response.text();
            console.error(`[ZoomVideoProvider] Failed to add registrant ${attendee.Email} (${response.status}): ${text}`);
        }
    }
}

export function LoadZoomVideoProvider(): void {}
