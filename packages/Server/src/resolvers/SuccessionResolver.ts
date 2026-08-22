import { Arg, Ctx, Field, InputType, Mutation, ObjectType, Resolver, Float, Int } from '@memberjunction/server';
import { AppContext, ResolverBase } from '@memberjunction/server';
import { SuccessionSuggestionService } from '@mj-biz-apps/committees-core-entities-server';
import { CommitteeAuthorization } from '../authorization/CommitteeAuthorization.js';

@ObjectType()
export class SuccessorSuggestionType {
    @Field() PersonID!: string;
    @Field() PersonName!: string;
    @Field() CurrentRoles!: string;
    @Field(() => Float, { nullable: true }) AttendanceRate?: number;
    @Field(() => Int) CommitteeCount!: number;
    @Field() Fit!: string;
    @Field() Rationale!: string;
}

@ObjectType()
export class SuggestSuccessorsResponse {
    @Field() Success!: boolean;
    @Field({ nullable: true }) ErrorMessage?: string;
    @Field(() => [SuccessorSuggestionType]) Suggestions!: SuccessorSuggestionType[];
}

@InputType()
export class SuggestSuccessorsInput {
    @Field() CommitteeID!: string;
}

@Resolver()
export class SuccessionResolver extends ResolverBase {
    /**
     * AI succession suggestions for a committee's upcoming vacancies.
     * Evidence is computed server-side from the record; the LLM contributes
     * only fit + rationale and may only pick from the provided pool.
     * Nothing is persisted.
     */
    @Mutation(() => SuggestSuccessorsResponse)
    async SuggestSuccessors(
        @Arg('input', () => SuggestSuccessorsInput) input: SuggestSuccessorsInput,
        @Ctx() { userPayload }: AppContext
    ): Promise<SuggestSuccessorsResponse> {
        const contextUser = this.GetUserFromPayload(userPayload);
        if (!contextUser) {
            return { Success: false, ErrorMessage: 'Unauthorized: could not resolve user from session', Suggestions: [] };
        }
        if (!await CommitteeAuthorization.CanActOnCommittee(input.CommitteeID, contextUser)) {
            return { Success: false, ErrorMessage: 'Forbidden: you are not authorized to manage this committee', Suggestions: [] };
        }
        const service = new SuccessionSuggestionService();
        const result = await service.GetSuggestions(input.CommitteeID, contextUser);
        return {
            Success: result.Success,
            ErrorMessage: result.ErrorMessage,
            Suggestions: result.Suggestions.map(s => ({ ...s, AttendanceRate: s.AttendanceRate ?? undefined })),
        };
    }
}
