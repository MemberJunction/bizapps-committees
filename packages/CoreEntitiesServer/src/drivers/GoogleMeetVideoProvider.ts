import { createSign } from 'node:crypto';
import { RegisterClass } from '@memberjunction/global';
import { VideoProviderBase, VideoMeetingInput, VideoMeetingResult, VideoProviderCredentials, MeetingAttendee } from './VideoProviderBase.js';

interface GoogleTokenResponse {
    access_token: string;
    token_type: string;
    expires_in: number;
}

interface GoogleMeetSpaceResponse {
    name: string;       // e.g. "spaces/abc123"
    meetingUri: string; // the join URL
    meetingCode: string;
}

/**
 * Google Meet video provider driver.
 *
 * Uses a Google service account with domain-wide delegation (DWD) to create
 * Meet spaces on behalf of a user via the Google Meet REST API v2.
 *
 * Credentials required (stored via CredentialEngine):
 *   client_id     — Service account email (e.g. my-sa@project.iam.gserviceaccount.com)
 *   client_secret — Service account RSA private key in PEM format
 *   account_id    — Email of the user to impersonate via DWD
 *
 * Google Cloud setup required:
 *   - Enable Google Meet API on the project
 *   - Grant domain-wide delegation to the service account
 *   - Authorize scope: https://www.googleapis.com/auth/meetings.space.created
 */
@RegisterClass(VideoProviderBase, 'GoogleMeetVideoProvider')
export class GoogleMeetVideoProvider extends VideoProviderBase {
    private serviceAccountEmail = '';
    private privateKeyPem = '';
    private impersonatedUser = '';
    private configured = false;

    async Initialize(credentials: VideoProviderCredentials): Promise<void> {
        this.serviceAccountEmail = credentials.client_id;
        this.privateKeyPem = credentials.client_secret;
        this.impersonatedUser = credentials.account_id;
        this.configured = !!(this.serviceAccountEmail && this.privateKeyPem && this.impersonatedUser);
    }

    get IsConfigured(): boolean {
        return this.configured;
    }

    async CreateMeeting(_input: VideoMeetingInput): Promise<VideoMeetingResult> {
        const accessToken = await this.fetchAccessToken();
        return this.createMeetSpace(accessToken);
    }

    async DeleteMeeting(providerMeetingID: string): Promise<void> {
        // Google Meet spaces created via the API do not support deletion via REST.
        // Spaces expire automatically when unused. Log and no-op.
        console.info(`[GoogleMeetVideoProvider] DeleteMeeting: spaces cannot be deleted via API (spaceID: ${providerMeetingID})`);
    }

    async SendInvites(_providerMeetingID: string, _attendees: MeetingAttendee[]): Promise<void> {
        // Google Meet invite emails require the Calendar API, not the Meet API.
        // Not implemented — attendees receive the join URL via other means.
        console.info('[GoogleMeetVideoProvider] SendInvites: not yet implemented (requires Google Calendar API)');
    }

    private async fetchAccessToken(): Promise<string> {
        const jwt = this.buildJwt();

        const response = await fetch('https://oauth2.googleapis.com/token', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({
                grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
                assertion: jwt,
            }).toString(),
        });

        if (!response.ok) {
            const text = await response.text();
            throw new Error(`Google Meet token request failed (${response.status}): ${text}`);
        }

        const data = await response.json() as GoogleTokenResponse;
        return data.access_token;
    }

    private buildJwt(): string {
        const now = Math.floor(Date.now() / 1000);

        const header = Buffer.from(JSON.stringify({ alg: 'RS256', typ: 'JWT' })).toString('base64url');
        const payload = Buffer.from(JSON.stringify({
            iss: this.serviceAccountEmail,
            sub: this.impersonatedUser,
            scope: 'https://www.googleapis.com/auth/meetings.space.created',
            aud: 'https://oauth2.googleapis.com/token',
            iat: now,
            exp: now + 3600,
        })).toString('base64url');

        const signingInput = `${header}.${payload}`;
        const sign = createSign('RSA-SHA256');
        sign.update(signingInput);
        const signature = sign.sign(this.privateKeyPem, 'base64url');

        return `${signingInput}.${signature}`;
    }

    private async createMeetSpace(accessToken: string): Promise<VideoMeetingResult> {
        const response = await fetch('https://meet.googleapis.com/v2/spaces', {
            method: 'POST',
            headers: {
                Authorization: `Bearer ${accessToken}`,
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({}),
        });

        if (!response.ok) {
            const text = await response.text();
            throw new Error(`Google Meet create space failed (${response.status}): ${text}`);
        }

        const data = await response.json() as GoogleMeetSpaceResponse;
        return {
            JoinURL: data.meetingUri,
            ProviderMeetingID: data.name, // e.g. "spaces/abc123"
        };
    }
}

export function LoadGoogleMeetVideoProvider(): void {}
