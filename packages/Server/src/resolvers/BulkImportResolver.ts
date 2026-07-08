import { Arg, Ctx, Field, InputType, Int, Mutation, ObjectType, Resolver } from '@memberjunction/server';
import { AppContext, ResolverBase } from '@memberjunction/server';
import { RunView, UserInfo } from '@memberjunction/core';
import {
    BulkImportService,
    ImportPlan,
    ImportProblem,
    ImportCommitteeRow,
    ImportTermRow,
    ImportPersonRow,
    ImportMembershipRow,
    ImportRowError,
} from '@mj-biz-apps/committees-core-entities-server';

// =============================================================================
// GraphQL types — outputs
// =============================================================================

@ObjectType()
class ImportProblemType implements ImportProblem {
    @Field() field!: string;
    @Field() severity!: 'error' | 'warning';
    @Field() message!: string;
    @Field(() => String, { nullable: true }) suggestedValue?: string | number | null;
}

@ObjectType()
class ImportCommitteeRowType implements ImportCommitteeRow {
    @Field() Name!: string;
    @Field({ nullable: true }) Description?: string | null;
    @Field() CommitteeType!: string;
    @Field(() => [ImportProblemType], { nullable: true }) _problems?: ImportProblemType[];
}

@ObjectType()
class ImportTermRowType implements ImportTermRow {
    @Field() CommitteeRef!: string;
    @Field(() => Int, { nullable: true }) Year!: number | null;
    @Field({ nullable: true }) StartDate!: string | null;
    @Field({ nullable: true }) EndDate!: string | null;
    @Field(() => [ImportProblemType], { nullable: true }) _problems?: ImportProblemType[];
}

@ObjectType()
class ImportPersonRowType implements ImportPersonRow {
    @Field() FirstName!: string;
    @Field() LastName!: string;
    @Field() Email!: string;
    @Field(() => [ImportProblemType], { nullable: true }) _problems?: ImportProblemType[];
}

@ObjectType()
class ImportMembershipRowType implements ImportMembershipRow {
    @Field() CommitteeRef!: string;
    @Field() PersonRef!: string;
    @Field() Role!: string;
    @Field() Status!: string;
    @Field(() => [ImportProblemType], { nullable: true }) _problems?: ImportProblemType[];
}

@ObjectType()
class ImportPlanType implements ImportPlan {
    @Field(() => [ImportCommitteeRowType]) committees!: ImportCommitteeRowType[];
    @Field(() => [ImportTermRowType]) terms!: ImportTermRowType[];
    @Field(() => [ImportPersonRowType]) people!: ImportPersonRowType[];
    @Field(() => [ImportMembershipRowType]) memberships!: ImportMembershipRowType[];
}

@ObjectType()
class AnalyzeCommitteeImportResponse {
    @Field() Success!: boolean;
    @Field({ nullable: true }) ErrorMessage?: string;
    @Field(() => ImportPlanType, { nullable: true }) Plan?: ImportPlanType;
}

@ObjectType()
class ImportRowErrorType implements ImportRowError {
    @Field() Entity!: 'Committee' | 'Term' | 'Person' | 'Membership';
    @Field() Identifier!: string;
    @Field() Message!: string;
}

@ObjectType()
class ConfirmCommitteeImportResponse {
    @Field() Success!: boolean;
    @Field({ nullable: true }) ErrorMessage?: string;
    @Field(() => Int) CommitteesCreated!: number;
    @Field(() => Int) TermsCreated!: number;
    @Field(() => Int) PeopleCreated!: number;
    @Field(() => Int) MembershipsCreated!: number;
    @Field(() => [ImportRowErrorType]) Errors!: ImportRowErrorType[];
}

// =============================================================================
// GraphQL types — inputs (mirror the output types but as InputType)
// =============================================================================

@InputType()
class ImportProblemInput {
    @Field() field!: string;
    @Field() severity!: 'error' | 'warning';
    @Field() message!: string;
    @Field(() => String, { nullable: true }) suggestedValue?: string | number | null;
}

@InputType()
class ImportCommitteeRowInput {
    @Field() Name!: string;
    @Field({ nullable: true }) Description?: string | null;
    @Field() CommitteeType!: string;
    @Field(() => [ImportProblemInput], { nullable: true }) _problems?: ImportProblemInput[];
}

@InputType()
class ImportTermRowInput {
    @Field() CommitteeRef!: string;
    @Field(() => Int, { nullable: true }) Year!: number | null;
    @Field({ nullable: true }) StartDate!: string | null;
    @Field({ nullable: true }) EndDate!: string | null;
    @Field(() => [ImportProblemInput], { nullable: true }) _problems?: ImportProblemInput[];
}

@InputType()
class ImportPersonRowInput {
    @Field() FirstName!: string;
    @Field() LastName!: string;
    @Field() Email!: string;
    @Field(() => [ImportProblemInput], { nullable: true }) _problems?: ImportProblemInput[];
}

@InputType()
class ImportMembershipRowInput {
    @Field() CommitteeRef!: string;
    @Field() PersonRef!: string;
    @Field() Role!: string;
    @Field() Status!: string;
    @Field(() => [ImportProblemInput], { nullable: true }) _problems?: ImportProblemInput[];
}

@InputType()
class ImportPlanInput {
    @Field(() => [ImportCommitteeRowInput]) committees!: ImportCommitteeRowInput[];
    @Field(() => [ImportTermRowInput]) terms!: ImportTermRowInput[];
    @Field(() => [ImportPersonRowInput]) people!: ImportPersonRowInput[];
    @Field(() => [ImportMembershipRowInput]) memberships!: ImportMembershipRowInput[];
}

// =============================================================================
// Resolver
// =============================================================================

@Resolver()
export class BulkImportResolver extends ResolverBase {
    @Mutation(() => AnalyzeCommitteeImportResponse)
    async AnalyzeCommitteeImport(
        @Arg('fileBase64') fileBase64: string,
        @Arg('fileName') fileName: string,
        @Arg('mimeType') mimeType: string,
        @Ctx() { userPayload }: AppContext
    ): Promise<AnalyzeCommitteeImportResponse> {
        const contextUser = this.GetUserFromPayload(userPayload);
        if (!contextUser) {
            return { Success: false, ErrorMessage: 'Unauthorized: could not resolve user from session' };
        }
        const isStaff = await this.isStaffUser(contextUser);
        if (!isStaff) {
            return { Success: false, ErrorMessage: 'Forbidden: bulk import requires Committee Management access' };
        }

        const service = new BulkImportService();
        return service.AnalyzeSpreadsheet(fileBase64, fileName, mimeType, contextUser);
    }

    @Mutation(() => ConfirmCommitteeImportResponse)
    async ConfirmCommitteeImport(
        @Arg('plan', () => ImportPlanInput) plan: ImportPlanInput,
        @Ctx() { userPayload }: AppContext
    ): Promise<ConfirmCommitteeImportResponse> {
        const contextUser = this.GetUserFromPayload(userPayload);
        if (!contextUser) {
            return this.unauthorizedConfirmResponse('Unauthorized: could not resolve user from session');
        }
        const isStaff = await this.isStaffUser(contextUser);
        if (!isStaff) {
            return this.unauthorizedConfirmResponse('Forbidden: bulk import requires Committee Management access');
        }

        const service = new BulkImportService();
        const result = await service.ConfirmImport(plan as ImportPlan, contextUser);
        return {
            Success: result.Success,
            ErrorMessage: result.ErrorMessage,
            CommitteesCreated: result.CommitteesCreated,
            TermsCreated: result.TermsCreated,
            PeopleCreated: result.PeopleCreated,
            MembershipsCreated: result.MembershipsCreated,
            Errors: result.Errors,
        };
    }

    private async isStaffUser(contextUser: UserInfo): Promise<boolean> {
        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'MJ: User Applications',
            ExtraFilter: `UserID = '${contextUser.ID}' AND Application = 'Committee Management'`,
            Fields: ['ID'],
            MaxRows: 1,
            ResultType: 'simple',
        }, contextUser);
        return result.Success === true && Array.isArray(result.Results) && result.Results.length > 0;
    }

    private unauthorizedConfirmResponse(message: string): ConfirmCommitteeImportResponse {
        return {
            Success: false,
            ErrorMessage: message,
            CommitteesCreated: 0,
            TermsCreated: 0,
            PeopleCreated: 0,
            MembershipsCreated: 0,
            Errors: [],
        };
    }
}
