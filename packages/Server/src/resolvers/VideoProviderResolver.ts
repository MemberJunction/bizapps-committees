import { Arg, Ctx, Mutation, Resolver, Field, ObjectType } from '@memberjunction/server';
import { AppContext, ResolverBase } from '@memberjunction/server';
import { VideoProviderService } from '@mj-biz-apps/committees-core';

@ObjectType()
export class ProvisionVideoMeetingResponse {
    @Field()
    Success!: boolean;

    @Field({ nullable: true })
    ErrorMessage?: string;

    @Field({ nullable: true })
    JoinURL?: string;

    @Field({ nullable: true })
    ProviderMeetingID?: string;
}

@Resolver()
export class VideoProviderResolver extends ResolverBase {
    /**
     * Provisions a video meeting URL for the given meeting.
     * Loads the meeting's VideoProvider, resolves credentials via CredentialEngine,
     * calls the provider driver, and writes the JoinURL back to the meeting record.
     *
     * Safe to call multiple times — no-op if the meeting already has a VideoJoinURL.
     */
    @Mutation(() => ProvisionVideoMeetingResponse)
    async ProvisionVideoMeeting(
        @Arg('MeetingID') meetingID: string,
        @Ctx() { userPayload }: AppContext
    ): Promise<ProvisionVideoMeetingResponse> {
        const contextUser = this.GetUserFromPayload(userPayload);
        if (!contextUser) {
            return { Success: false, ErrorMessage: 'Unauthorized: could not resolve user from session' };
        }

        const service = new VideoProviderService();
        const result = await service.ProvisionVideoMeeting(meetingID, contextUser);

        return {
            Success: result.Success,
            ErrorMessage: result.ErrorMessage,
            JoinURL: result.JoinURL,
            ProviderMeetingID: result.ProviderMeetingID,
        };
    }
}
