import { Arg, Ctx, Field, InputType, Mutation, ObjectType, Resolver, Int } from '@memberjunction/server';
import { AppContext, ResolverBase } from '@memberjunction/server';
import { BallotReminderService } from '@mj-biz-apps/committees-core-entities-server';
import { CommitteeAuthorization } from '../authorization/CommitteeAuthorization.js';

@ObjectType()
export class RemindBallotNonVotersResponse {
    @Field() Success!: boolean;
    @Field({ nullable: true }) ErrorMessage?: string;
    @Field(() => Int) TotalNonVoters!: number;
    @Field(() => Int) RemindedCount!: number;
    @Field(() => [String]) UnreachableNames!: string[];
}

@InputType()
export class RemindBallotNonVotersInput {
    @Field() BallotID!: string;
}

@Resolver()
export class BallotReminderResolver extends ResolverBase {
    /**
     * Creates an in-app notification for every voting member who has not yet
     * cast a vote on the ballot's motion. Reports reachability honestly —
     * members without a linked user account are named, not silently skipped.
     */
    @Mutation(() => RemindBallotNonVotersResponse)
    async RemindBallotNonVoters(
        @Arg('input', () => RemindBallotNonVotersInput) input: RemindBallotNonVotersInput,
        @Ctx() { userPayload }: AppContext
    ): Promise<RemindBallotNonVotersResponse> {
        const contextUser = this.GetUserFromPayload(userPayload);
        if (!contextUser) {
            return { Success: false, ErrorMessage: 'Unauthorized: could not resolve user from session', TotalNonVoters: 0, RemindedCount: 0, UnreachableNames: [] };
        }
        const committeeID = await CommitteeAuthorization.GetBallotCommitteeID(input.BallotID, contextUser);
        if (!await CommitteeAuthorization.CanActOnCommittee(committeeID, contextUser)) {
            return { Success: false, ErrorMessage: 'Forbidden: you are not authorized to manage this ballot', TotalNonVoters: 0, RemindedCount: 0, UnreachableNames: [] };
        }
        const service = new BallotReminderService();
        return service.RemindNonVoters(input.BallotID, contextUser);
    }
}
