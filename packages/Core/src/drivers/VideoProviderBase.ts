/**
 * An attendee to be invited to a video meeting.
 */
export interface MeetingAttendee {
    Email: string;
    FullName: string;
}

/**
 * Input required to create a video meeting via a provider API.
 */
export interface VideoMeetingInput {
    Title: string;
    StartDateTime: Date;
    EndDateTime?: Date | null;
    TimeZone?: string | null;
    Description?: string | null;
    Attendees?: MeetingAttendee[];
}

/**
 * Result returned by a video provider after creating a meeting.
 */
export interface VideoMeetingResult {
    /** The URL attendees use to join the meeting. */
    JoinURL: string;
    /** The provider's native meeting ID (used for future update/delete). */
    ProviderMeetingID: string;
}

/**
 * Credential values expected in the MJ: Credentials record for video providers.
 * Stored encrypted via CredentialEngine.
 */
export interface VideoProviderCredentials extends Record<string, string> {
    client_id: string;
    client_secret: string;
    /**
     * Zoom: account_id
     * Teams: tenant_id
     * Google Meet: impersonated user email (domain-wide delegation)
     */
    account_id: string;
    /**
     * Teams only: AAD Object ID or UPN of the meeting organizer.
     * Required for Graph API app-only online meeting creation.
     */
    organizer_user_id?: string;
}

/**
 * Abstract base class for all video provider drivers.
 * Extend this and register via @RegisterClass(VideoProviderBase, '<DriverKey>').
 */
export abstract class VideoProviderBase {
    /**
     * Initialize the driver with decrypted credentials from CredentialEngine.
     * Must be called before CreateMeeting.
     */
    abstract initialize(credentials: VideoProviderCredentials): Promise<void>;

    /**
     * Returns true if the driver has been initialized with valid credentials.
     */
    abstract get IsConfigured(): boolean;

    /**
     * Creates a meeting with the provider and returns the join URL + provider meeting ID.
     */
    abstract CreateMeeting(input: VideoMeetingInput): Promise<VideoMeetingResult>;

    /**
     * Deletes a previously created meeting from the provider.
     * Best-effort — callers should not throw if this fails.
     */
    abstract DeleteMeeting(providerMeetingID: string): Promise<void>;

    /**
     * Sends meeting invites to the given attendees via the provider's native mechanism.
     * Best-effort — callers should not throw if this fails.
     */
    abstract SendInvites(providerMeetingID: string, attendees: MeetingAttendee[]): Promise<void>;
}
