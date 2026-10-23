import { Arg, Ctx, Field, InputType, Int, Mutation, ObjectType, Query, Resolver } from '@memberjunction/server';
import { AppContext, ResolverBase } from '@memberjunction/server';
import { BallotCloseService, type BallotCloseResult, type BallotProgressResult } from '@mj-biz-apps/committees-core-entities-server';
import { CommitteeAuthorization } from '../authorization/CommitteeAuthorization.js';

@ObjectType()
export class CloseBallotResponse {
    @Field() Success!: boolean;
    @Field({ nullable: true }) ErrorMessage?: string;
    /** Passed, Failed or Cancelled; null when the request failed. */
    @Field(() => String, { nullable: true }) Result!: string | null;
    @Field(() => Int) Yes!: number;
    @Field(() => Int) No!: number;
    @Field(() => Int) Abstain!: number;
    @Field(() => Int) Cast!: number;
    @Field(() => Int) VotingMemberCount!: number;
    @Field(() => Int) RequiredYes!: number;
    @Field(() => String, { nullable: true }) ResultNotes!: string | null;
}

@InputType()
export class CloseBallotInput {
    @Field() BallotID!: string;
    /** 'Close' tallies and stamps the motion; 'Cancel' withdraws the ballot (Notes required). */
    @Field() Mode!: string;
    @Field({ nullable: true }) Notes?: string;
}

@ObjectType()
export class BallotVoterProgressType {
    @Field() MembershipID!: string;
    @Field(() => String, { nullable: true }) VotedAt!: string | null;
}

@ObjectType()
export class BallotProgressResponse {
    @Field() Success!: boolean;
    @Field({ nullable: true }) ErrorMessage?: string;
    @Field() BallotID!: string;
    @Field() Status!: string;
    @Field(() => Int) Cast!: number;
    @Field(() => Int) VotingMemberCount!: number;
    @Field(() => Int) Outstanding!: number;
    @Field(() => [BallotVoterProgressType]) Voted!: BallotVoterProgressType[];
}

/**
 * Ballot sealing (C0). The browser cannot tally a ballot any more: the Votes row filter shows a member only their own
 * vote while a ballot is open. Closing therefore happens here, as the system user, for staff or an active officer of
 * the ballot's committee. Progress (participation, never choices) is open to staff and the committee's active members.
 */
@Resolver()
export class BallotCloseResolver extends ResolverBase {
    @Mutation(() => CloseBallotResponse)
    async CloseBallot(
        @Arg('input', () => CloseBallotInput) input: CloseBallotInput,
        @Ctx() { userPayload }: AppContext
    ): Promise<CloseBallotResponse> {
        const contextUser = this.GetUserFromPayload(userPayload);
        if (!contextUser) return this.refuseClose('Unauthorized: could not resolve user from session');
        if (input.Mode !== 'Close' && input.Mode !== 'Cancel') return this.refuseClose(`Unknown mode "${input.Mode}": use Close or Cancel`);
        const committeeID = await CommitteeAuthorization.GetBallotCommitteeID(input.BallotID, contextUser);
        if (!await CommitteeAuthorization.CanActOnCommittee(committeeID, contextUser)) {
            return this.refuseClose('Forbidden: you are not authorized to close this ballot');
        }
        const service = new BallotCloseService();
        const result: BallotCloseResult = input.Mode === 'Close'
            ? await service.CloseBallot(input.BallotID, input.Notes ?? null, contextUser)
            : await service.CancelBallot(input.BallotID, input.Notes ?? null, contextUser);
        return result;
    }

    @Query(() => BallotProgressResponse)
    async BallotProgress(
        @Arg('BallotID', () => String) ballotID: string,
        @Ctx() { userPayload }: AppContext
    ): Promise<BallotProgressResponse> {
        const contextUser = this.GetUserFromPayload(userPayload);
        if (!contextUser) return this.refuseProgress(ballotID, 'Unauthorized: could not resolve user from session');
        const committeeID = await CommitteeAuthorization.GetBallotCommitteeID(ballotID, contextUser);
        if (!await CommitteeAuthorization.CanViewCommittee(committeeID, contextUser)) {
            return this.refuseProgress(ballotID, 'Forbidden: you are not a member of this ballot\'s committee');
        }
        const result: BallotProgressResult = await new BallotCloseService().Progress(ballotID, contextUser);
        return result;
    }

    private refuseClose(message: string): CloseBallotResponse {
        return { Success: false, ErrorMessage: message, Result: null, Yes: 0, No: 0, Abstain: 0, Cast: 0, VotingMemberCount: 0, RequiredYes: 0, ResultNotes: null };
    }

    private refuseProgress(ballotID: string, message: string): BallotProgressResponse {
        return { Success: false, ErrorMessage: message, BallotID: ballotID, Status: '', Cast: 0, VotingMemberCount: 0, Outstanding: 0, Voted: [] };
    }
}
