import { Arg, Ctx, Mutation, Resolver, Field, ObjectType, InputType } from '@memberjunction/server';
import { AppContext, ResolverBase } from '@memberjunction/server';
import { MinutesService } from '@mj-biz-apps/committees-core';

@ObjectType()
export class MinutesDraftResponse {
    @Field()
    Success!: boolean;

    @Field({ nullable: true })
    ErrorMessage?: string;

    @Field()
    MeetingID!: string;

    @Field()
    Content!: string;
}

@InputType()
export class GenerateMinutesInput {
    @Field()
    MeetingID!: string;

    @Field({ nullable: true })
    Transcript?: string;

    @Field({ nullable: true })
    TranscriptURL?: string;
}

@Resolver()
export class MinutesResolver extends ResolverBase {
    @Mutation(() => MinutesDraftResponse)
    async GenerateMeetingMinutes(
        @Arg('input', () => GenerateMinutesInput) input: GenerateMinutesInput,
        @Ctx() { userPayload }: AppContext
    ): Promise<MinutesDraftResponse> {
        const contextUser = this.GetUserFromPayload(userPayload);
        if (!contextUser) {
            return {
                Success: false,
                ErrorMessage: 'Unauthorized: could not resolve user from session',
                MeetingID: input.MeetingID,
                Content: '',
            };
        }

        const service = new MinutesService();
        const result = await service.GenerateDraftMinutes(
            input.MeetingID,
            input.Transcript ?? null,
            contextUser,
            input.TranscriptURL ?? null
        );

        return {
            Success: result.Success,
            ErrorMessage: result.ErrorMessage,
            MeetingID: result.MeetingID,
            Content: result.Content,
        };
    }
}
