import { RegisterClass } from '@memberjunction/global';
import { VideoProviderBase, VideoMeetingInput, VideoMeetingResult, VideoProviderCredentials, MeetingAttendee } from './VideoProviderBase.js';

interface TeamsTokenResponse {
    access_token: string;
    token_type: string;
    expires_in: number;
}

interface TeamsOnlineMeetingResponse {
    id: string;
    joinWebUrl: string;
    subject: string;
}

/**
 * Microsoft Teams video provider driver.
 *
 * Uses the Microsoft Graph API with client credentials (app-only) flow.
 *
 * Credentials required (stored via CredentialEngine):
 *   client_id           — Azure AD app client ID
 *   client_secret       — Azure AD app client secret
 *   account_id          — Azure AD tenant ID
 *   organizer_user_id   — AAD Object ID or UPN of the meeting organizer
 *                         (required for app-only online meeting creation)
 *
 * Azure AD app permissions required: OnlineMeetings.ReadWrite.All (application)
 */
@RegisterClass(VideoProviderBase, 'TeamsVideoProvider')
export class TeamsVideoProvider extends VideoProviderBase {
    private clientId = '';
    private clientSecret = '';
    private tenantId = '';
    private organizerUserId = '';
    private configured = false;

    async initialize(credentials: VideoProviderCredentials): Promise<void> {
        this.clientId = credentials.client_id;
        this.clientSecret = credentials.client_secret;
        this.tenantId = credentials.account_id;
        this.organizerUserId = credentials['organizer_user_id'] ?? '';
        this.configured = !!(this.clientId && this.clientSecret && this.tenantId && this.organizerUserId);
    }

    get IsConfigured(): boolean {
        return this.configured;
    }

    async CreateMeeting(input: VideoMeetingInput): Promise<VideoMeetingResult> {
        const accessToken = await this.fetchAccessToken();
        return this.createOnlineMeeting(accessToken, input);
    }

    async DeleteMeeting(providerMeetingID: string): Promise<void> {
        const accessToken = await this.fetchAccessToken();
        await fetch(
            `https://graph.microsoft.com/v1.0/users/${encodeURIComponent(this.organizerUserId)}/onlineMeetings/${providerMeetingID}`,
            { method: 'DELETE', headers: { Authorization: `Bearer ${accessToken}` } }
        );
    }

    private async fetchAccessToken(): Promise<string> {
        const url = `https://login.microsoftonline.com/${encodeURIComponent(this.tenantId)}/oauth2/v2.0/token`;
        const body = new URLSearchParams({
            grant_type: 'client_credentials',
            client_id: this.clientId,
            client_secret: this.clientSecret,
            scope: 'https://graph.microsoft.com/.default',
        });

        const response = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: body.toString(),
        });

        if (!response.ok) {
            const text = await response.text();
            throw new Error(`Teams token request failed (${response.status}): ${text}`);
        }

        const data = await response.json() as TeamsTokenResponse;
        return data.access_token;
    }

    private async createOnlineMeeting(accessToken: string, input: VideoMeetingInput): Promise<VideoMeetingResult> {
        const body = {
            subject: input.Title,
            startDateTime: input.StartDateTime.toISOString(),
            endDateTime: (input.EndDateTime ?? new Date(input.StartDateTime.getTime() + 3600000)).toISOString(),
        };

        const response = await fetch(
            `https://graph.microsoft.com/v1.0/users/${encodeURIComponent(this.organizerUserId)}/onlineMeetings`,
            {
                method: 'POST',
                headers: {
                    Authorization: `Bearer ${accessToken}`,
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(body),
            }
        );

        if (!response.ok) {
            const text = await response.text();
            throw new Error(`Teams create meeting failed (${response.status}): ${text}`);
        }

        const data = await response.json() as TeamsOnlineMeetingResponse;
        return {
            JoinURL: data.joinWebUrl,
            ProviderMeetingID: data.id,
        };
    }

    async SendInvites(_providerMeetingID: string, _attendees: MeetingAttendee[]): Promise<void> {
        // Teams calendar invites require Calendars.ReadWrite app permission via Graph API.
        // Invites are sent by adding attendees to a calendar event linked to the online meeting.
        // Not implemented — attendees receive the join URL via other means.
        console.info('[TeamsVideoProvider] SendInvites: not yet implemented (requires Calendars.ReadWrite permission)');
    }
}

export function LoadTeamsVideoProvider(): void {}

