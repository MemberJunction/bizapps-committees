import { Metadata, RunView, UserInfo } from '@memberjunction/core';
import { MJGlobal } from '@memberjunction/global';
import { CredentialEngine } from '@memberjunction/credentials';
import { mjCommitteesMeetingEntity } from '@mj-biz-apps/committees-entities';
import { VideoProviderBase, VideoProviderCredentials, MeetingAttendee } from '../drivers/VideoProviderBase.js';

/**
 * Shape of a VideoProvider record returned by RunView (simple result).
 * Entity name: 'Committees: Video Providers' (after CodeGen is run).
 */
interface VideoProviderRecord {
    ID: string;
    Name: string;
    ServerDriverKey: string;
    IsActive: boolean;
    IsDefault: boolean;
    CredentialID: string | null;
}

/**
 * Result of ProvisionVideoMeeting.
 */
export interface ProvisionVideoMeetingResult {
    Success: boolean;
    JoinURL?: string;
    ProviderMeetingID?: string;
    ErrorMessage?: string;
}

/**
 * Service for managing video provider operations:
 * - Loading the configured default provider
 * - Provisioning (auto-creating) a video meeting URL for a given meeting
 */
export class VideoProviderService {
    private static readonly ENTITY_NAME = 'Committees: Video Providers';

    /**
     * Loads the default active VideoProvider record, or null if none is configured.
     */
    public async GetDefaultProvider(contextUser: UserInfo): Promise<VideoProviderRecord | null> {
        const rv = new RunView();
        const result = await rv.RunView<VideoProviderRecord>({
            EntityName: VideoProviderService.ENTITY_NAME,
            ExtraFilter: `IsDefault = 1 AND IsActive = 1`,
            MaxRows: 1,
            ResultType: 'simple',
        }, contextUser);

        if (!result.Success || !result.Results || result.Results.length === 0) {
            return null;
        }
        return result.Results[0];
    }

    /**
     * Loads all active VideoProvider records.
     */
    public async GetActiveProviders(contextUser: UserInfo): Promise<VideoProviderRecord[]> {
        const rv = new RunView();
        const result = await rv.RunView<VideoProviderRecord>({
            EntityName: VideoProviderService.ENTITY_NAME,
            ExtraFilter: `IsActive = 1`,
            OrderBy: 'Name ASC',
            ResultType: 'simple',
        }, contextUser);

        return result.Success ? (result.Results ?? []) : [];
    }

    /**
     * Provisions a video meeting for the given meeting ID:
     * 1. Loads the meeting and its VideoProvider
     * 2. Resolves credentials via CredentialEngine
     * 3. Instantiates the driver via ClassFactory
     * 4. Calls CreateMeeting() and writes the URL back to the meeting record
     *
     * Safe to call on already-provisioned meetings (no-op if VideoJoinURL exists).
     */
    public async ProvisionVideoMeeting(
        meetingID: string,
        contextUser: UserInfo
    ): Promise<ProvisionVideoMeetingResult> {
        const meeting = await this.loadMeeting(meetingID, contextUser);
        if (!meeting) {
            return { Success: false, ErrorMessage: `Meeting not found: ${meetingID}` };
        }

        if (meeting.VideoJoinURL) {
            return { Success: true, JoinURL: meeting.VideoJoinURL, ProviderMeetingID: meeting.VideoMeetingID ?? undefined };
        }

        const videoProviderID = meeting.Get('VideoProviderID') as string | null;
        if (!videoProviderID) {
            return { Success: false, ErrorMessage: 'Meeting has no VideoProviderID set' };
        }

        const provider = await this.loadProvider(videoProviderID, contextUser);
        if (!provider) {
            return { Success: false, ErrorMessage: `VideoProvider not found: ${videoProviderID}` };
        }

        const driver = this.instantiateDriver(provider.ServerDriverKey);
        if (!driver) {
            return { Success: false, ErrorMessage: `No driver registered for key: ${provider.ServerDriverKey}` };
        }

        const credentials = await this.resolveCredentials(provider, contextUser);
        if (!credentials) {
            return { Success: false, ErrorMessage: `No credentials configured for provider: ${provider.Name}` };
        }

        await driver.initialize(credentials);

        if (!driver.IsConfigured) {
            return { Success: false, ErrorMessage: `Driver for ${provider.Name} is not properly configured` };
        }

        const attendees = await this.loadAttendees(meeting.ID, contextUser);

        try {
            const result = await driver.CreateMeeting({
                Title: meeting.Title,
                StartDateTime: meeting.StartDateTime,
                EndDateTime: meeting.EndDateTime,
                TimeZone: meeting.TimeZone,
                Description: meeting.Description,
                Attendees: attendees,
            });

            meeting.VideoJoinURL = result.JoinURL;
            meeting.VideoMeetingID = result.ProviderMeetingID;
            meeting.VideoProvider = provider.Name;

            const saved = await meeting.Save();
            if (!saved) {
                return { Success: false, ErrorMessage: 'Meeting URL created but failed to save back to database' };
            }

            // Best-effort invite sending — don't fail the whole provision if invites fail
            if (attendees.length > 0) {
                driver.SendInvites(result.ProviderMeetingID, attendees).catch(err => {
                    console.error(`[VideoProviderService] SendInvites failed: ${err instanceof Error ? err.message : String(err)}`);
                });
            }

            return { Success: true, JoinURL: result.JoinURL, ProviderMeetingID: result.ProviderMeetingID };
        } catch (err) {
            const message = err instanceof Error ? err.message : String(err);
            return { Success: false, ErrorMessage: `Provider API error: ${message}` };
        }
    }

    private async loadMeeting(meetingID: string, contextUser: UserInfo): Promise<mjCommitteesMeetingEntity | null> {
        const md = new Metadata();
        const meeting = await md.GetEntityObject<mjCommitteesMeetingEntity>('Committees: Meetings', contextUser);
        const loaded = await meeting.Load(meetingID);
        return loaded ? meeting : null;
    }

    private async loadProvider(providerID: string, contextUser: UserInfo): Promise<VideoProviderRecord | null> {
        const rv = new RunView();
        const result = await rv.RunView<VideoProviderRecord>({
            EntityName: VideoProviderService.ENTITY_NAME,
            ExtraFilter: `ID = '${providerID}'`,
            MaxRows: 1,
            ResultType: 'simple',
        }, contextUser);

        return result.Success && result.Results?.length ? result.Results[0] : null;
    }

    private instantiateDriver(serverDriverKey: string): VideoProviderBase | null {
        return MJGlobal.Instance.ClassFactory.CreateInstance<VideoProviderBase>(
            VideoProviderBase,
            serverDriverKey
        );
    }

    private async loadAttendees(meetingID: string, contextUser: UserInfo): Promise<MeetingAttendee[]> {
        const rv = new RunView();
        const attendanceResult = await rv.RunView<{ PersonID: string }>(
            { EntityName: 'Committees: Attendances', ExtraFilter: `MeetingID = '${meetingID}'`, Fields: ['PersonID'], ResultType: 'simple' },
            contextUser
        );

        const personIDs = attendanceResult.Success ? (attendanceResult.Results ?? []).map(a => a.PersonID) : [];
        if (personIDs.length === 0) return [];

        const peopleResult = await rv.RunView<{ ID: string; Email: string; DisplayName: string }>(
            {
                EntityName: 'MJ_BizApps_Common: People',
                ExtraFilter: `ID IN (${personIDs.map(id => `'${id}'`).join(',')})`,
                Fields: ['ID', 'Email', 'DisplayName'],
                ResultType: 'simple',
            },
            contextUser
        );

        return (peopleResult.Success ? (peopleResult.Results ?? []) : [])
            .filter(p => !!p.Email)
            .map(p => ({ Email: p.Email, FullName: p.DisplayName || p.Email }));
    }

    private async resolveCredentials(
        provider: VideoProviderRecord,
        contextUser: UserInfo
    ): Promise<VideoProviderCredentials | null> {
        if (!provider.CredentialID) {
            return null;
        }

        await CredentialEngine.Instance.Config(false, contextUser);
        const resolved = await CredentialEngine.Instance.getCredential<VideoProviderCredentials>(
            provider.CredentialID,
            { credentialId: provider.CredentialID, contextUser, subsystem: 'VideoProvider' }
        );

        if (!resolved?.values?.client_id) {
            return null;
        }

        return resolved.values;
    }
}
