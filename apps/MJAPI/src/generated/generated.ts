/********************************************************************************
* ALL ENTITIES - TypeGraphQL Type Class Definition - AUTO GENERATED FILE
* Generated Entities and Resolvers for Server
*
*   >>> DO NOT MODIFY THIS FILE!!!!!!!!!!!!
*   >>> YOUR CHANGES WILL BE OVERWRITTEN
*   >>> THE NEXT TIME THIS FILE IS GENERATED
*
**********************************************************************************/
import { Arg, Ctx, Int, Query, Resolver, Field, Float, ObjectType, FieldResolver, Root, InputType, Mutation,
            PubSub, PubSubEngine, ResolverBase, RunViewByIDInput, RunViewByNameInput, RunDynamicViewInput,
            AppContext, KeyValuePairInput, DeleteOptionsInput, GraphQLTimestamp as Timestamp,
            GetReadOnlyProvider, GetReadWriteProvider, RestoreContextInput } from '@memberjunction/server';
import { Metadata, EntityPermissionType, CompositeKey, UserInfo } from '@memberjunction/core'

import { MaxLength } from 'class-validator';
import * as mj_core_schema_server_object_types from '@memberjunction/server'


import { mjCommitteesActionItemEntity, mjCommitteesAgendaItemEntity, mjCommitteesArtifactTypeEntity, mjCommitteesArtifactEntity, mjCommitteesAttendanceEntity, mjCommitteesCommentEntity, mjCommitteesCommitteeEntity, mjCommitteesMeetingEntity, mjCommitteesMembershipEntity, mjCommitteesMinuteEntity, mjCommitteesMotionEntity, mjCommitteesRoleEntity, mjCommitteesTermEntity, mjCommitteesTypeEntity, mjCommitteesVideoProviderEntity, mjCommitteesVoteEntity } from '@mj-biz-apps/committees-entities';
    

//****************************************************************************
// ENTITY CLASS for Committees: Action Items
//****************************************************************************
@ObjectType({ description: `Tasks and action items assigned from committees or meetings` })
export class mjCommitteesActionItem_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field() 
    @MaxLength(36)
    CommitteeID: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    MeetingID?: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    AgendaItemID?: string;
        
    @Field({description: `Title of the action item`}) 
    @MaxLength(255)
    Title: string;
        
    @Field({nullable: true, description: `Detailed description of what needs to be done`}) 
    Description?: string;
        
    @Field() 
    @MaxLength(36)
    AssignedToPersonID: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    AssignedByPersonID?: string;
        
    @Field({nullable: true, description: `Due date for completion`}) 
    DueDate?: Date;
        
    @Field({description: `Priority level: Low, Medium, High, Critical`}) 
    @MaxLength(20)
    Priority: string;
        
    @Field({description: `Current status: Open, InProgress, Blocked, Completed, Cancelled`}) 
    @MaxLength(50)
    Status: string;
        
    @Field({nullable: true, description: `Timestamp when the action item was completed`}) 
    CompletedAt?: Date;
        
    @Field({nullable: true, description: `Notes about how the item was completed`}) 
    CompletionNotes?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field() 
    @MaxLength(255)
    Committee: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    Meeting?: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    AgendaItem?: string;
        
    @Field({nullable: true}) 
    @MaxLength(244)
    AssignedToPerson?: string;
        
    @Field({nullable: true}) 
    @MaxLength(244)
    AssignedByPerson?: string;
        
    @Field(() => [mjCommitteesArtifact_])
    mjCommitteesArtifacts_ActionItemIDArray: mjCommitteesArtifact_[]; // Link to mjCommitteesArtifacts
    
    @Field(() => [mjCommitteesComment_])
    mjCommitteesComments_ActionItemIDArray: mjCommitteesComment_[]; // Link to mjCommitteesComments
    
}

//****************************************************************************
// INPUT TYPE for Committees: Action Items
//****************************************************************************
@InputType()
export class CreatemjCommitteesActionItemInput {
    @Field({ nullable: true })
    ID?: string;

    @Field({ nullable: true })
    CommitteeID?: string;

    @Field({ nullable: true })
    MeetingID: string | null;

    @Field({ nullable: true })
    AgendaItemID: string | null;

    @Field({ nullable: true })
    Title?: string;

    @Field({ nullable: true })
    Description: string | null;

    @Field({ nullable: true })
    AssignedToPersonID?: string;

    @Field({ nullable: true })
    AssignedByPersonID: string | null;

    @Field({ nullable: true })
    DueDate: Date | null;

    @Field({ nullable: true })
    Priority?: string;

    @Field({ nullable: true })
    Status?: string;

    @Field({ nullable: true })
    CompletedAt: Date | null;

    @Field({ nullable: true })
    CompletionNotes: string | null;

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Action Items
//****************************************************************************
@InputType()
export class UpdatemjCommitteesActionItemInput {
    @Field()
    ID: string;

    @Field({ nullable: true })
    CommitteeID?: string;

    @Field({ nullable: true })
    MeetingID?: string | null;

    @Field({ nullable: true })
    AgendaItemID?: string | null;

    @Field({ nullable: true })
    Title?: string;

    @Field({ nullable: true })
    Description?: string | null;

    @Field({ nullable: true })
    AssignedToPersonID?: string;

    @Field({ nullable: true })
    AssignedByPersonID?: string | null;

    @Field({ nullable: true })
    DueDate?: Date | null;

    @Field({ nullable: true })
    Priority?: string;

    @Field({ nullable: true })
    Status?: string;

    @Field({ nullable: true })
    CompletedAt?: Date | null;

    @Field({ nullable: true })
    CompletionNotes?: string | null;

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Action Items
//****************************************************************************
@ObjectType()
export class RunmjCommitteesActionItemViewResult {
    @Field(() => [mjCommitteesActionItem_])
    Results: mjCommitteesActionItem_[];

    @Field(() => String, {nullable: true})
    UserViewRunID?: string;

    @Field(() => Int, {nullable: true})
    RowCount: number;

    @Field(() => Int, {nullable: true})
    TotalRowCount: number;

    @Field(() => Int, {nullable: true})
    ExecutionTime: number;

    @Field({nullable: true})
    ErrorMessage?: string;

    @Field(() => Boolean, {nullable: false})
    Success: boolean;
}

@Resolver(mjCommitteesActionItem_)
export class mjCommitteesActionItemResolver extends ResolverBase {
    @Query(() => RunmjCommitteesActionItemViewResult)
    async RunmjCommitteesActionItemViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesActionItemViewResult)
    async RunmjCommitteesActionItemViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesActionItemViewResult)
    async RunmjCommitteesActionItemDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Action Items';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjCommitteesActionItem_, { nullable: true })
    async mjCommitteesActionItem(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjCommitteesActionItem_ | null> {
        this.CheckUserReadPermissions('Committees: Action Items', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwActionItems')} WHERE ${provider.QuoteIdentifier('ID')}='${ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Action Items', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Action Items', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjCommitteesArtifact_])
    async mjCommitteesArtifacts_ActionItemIDArray(@Root() mjcommitteesactionitem_: mjCommitteesActionItem_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Artifacts', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwArtifacts')} WHERE ${provider.QuoteIdentifier('ActionItemID')}='${mjcommitteesactionitem_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Artifacts', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Artifacts', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesComment_])
    async mjCommitteesComments_ActionItemIDArray(@Root() mjcommitteesactionitem_: mjCommitteesActionItem_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Comments', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwComments')} WHERE ${provider.QuoteIdentifier('ActionItemID')}='${mjcommitteesactionitem_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Comments', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Comments', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjCommitteesActionItem_)
    async CreatemjCommitteesActionItem(
        @Arg('input', () => CreatemjCommitteesActionItemInput) input: CreatemjCommitteesActionItemInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Action Items', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjCommitteesActionItem_)
    async UpdatemjCommitteesActionItem(
        @Arg('input', () => UpdatemjCommitteesActionItemInput) input: UpdatemjCommitteesActionItemInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Action Items', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjCommitteesActionItem_)
    async DeletemjCommitteesActionItem(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Action Items', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Agenda Items
//****************************************************************************
@ObjectType({ description: `Structured agenda items for meetings with hierarchy support` })
export class mjCommitteesAgendaItem_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field() 
    @MaxLength(36)
    MeetingID: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    ParentAgendaItemID?: string;
        
    @Field(() => Int, {description: `Display order within the meeting agenda`}) 
    Sequence: number;
        
    @Field({description: `Title of the agenda item`}) 
    @MaxLength(255)
    Title: string;
        
    @Field({nullable: true, description: `Detailed description of the agenda item`}) 
    Description?: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    PresenterPersonID?: string;
        
    @Field(() => Int, {nullable: true, description: `Estimated duration in minutes`}) 
    DurationMinutes?: number;
        
    @Field({description: `Type of item: Information, Discussion, Action, Vote, Report, Other`}) 
    @MaxLength(50)
    ItemType: string;
        
    @Field({nullable: true, description: `URL to related document for this item`}) 
    @MaxLength(1000)
    RelatedDocumentURL?: string;
        
    @Field({description: `Current status: Pending, Discussed, Tabled, Completed, Skipped`}) 
    @MaxLength(50)
    Status: string;
        
    @Field({nullable: true, description: `Discussion notes and outcomes captured during the meeting`}) 
    Notes?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field() 
    @MaxLength(255)
    Meeting: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    ParentAgendaItem?: string;
        
    @Field({nullable: true}) 
    @MaxLength(244)
    PresenterPerson?: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    RootParentAgendaItemID?: string;
        
    @Field(() => [mjCommitteesArtifact_])
    mjCommitteesArtifacts_AgendaItemIDArray: mjCommitteesArtifact_[]; // Link to mjCommitteesArtifacts
    
    @Field(() => [mjCommitteesMotion_])
    mjCommitteesMotions_AgendaItemIDArray: mjCommitteesMotion_[]; // Link to mjCommitteesMotions
    
    @Field(() => [mjCommitteesActionItem_])
    mjCommitteesActionItems_AgendaItemIDArray: mjCommitteesActionItem_[]; // Link to mjCommitteesActionItems
    
    @Field(() => [mjCommitteesAgendaItem_])
    mjCommitteesAgendaItems_ParentAgendaItemIDArray: mjCommitteesAgendaItem_[]; // Link to mjCommitteesAgendaItems
    
    @Field(() => [mjCommitteesComment_])
    mjCommitteesComments_AgendaItemIDArray: mjCommitteesComment_[]; // Link to mjCommitteesComments
    
}

//****************************************************************************
// INPUT TYPE for Committees: Agenda Items
//****************************************************************************
@InputType()
export class CreatemjCommitteesAgendaItemInput {
    @Field({ nullable: true })
    ID?: string;

    @Field({ nullable: true })
    MeetingID?: string;

    @Field({ nullable: true })
    ParentAgendaItemID: string | null;

    @Field(() => Int, { nullable: true })
    Sequence?: number;

    @Field({ nullable: true })
    Title?: string;

    @Field({ nullable: true })
    Description: string | null;

    @Field({ nullable: true })
    PresenterPersonID: string | null;

    @Field(() => Int, { nullable: true })
    DurationMinutes: number | null;

    @Field({ nullable: true })
    ItemType?: string;

    @Field({ nullable: true })
    RelatedDocumentURL: string | null;

    @Field({ nullable: true })
    Status?: string;

    @Field({ nullable: true })
    Notes: string | null;

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Agenda Items
//****************************************************************************
@InputType()
export class UpdatemjCommitteesAgendaItemInput {
    @Field()
    ID: string;

    @Field({ nullable: true })
    MeetingID?: string;

    @Field({ nullable: true })
    ParentAgendaItemID?: string | null;

    @Field(() => Int, { nullable: true })
    Sequence?: number;

    @Field({ nullable: true })
    Title?: string;

    @Field({ nullable: true })
    Description?: string | null;

    @Field({ nullable: true })
    PresenterPersonID?: string | null;

    @Field(() => Int, { nullable: true })
    DurationMinutes?: number | null;

    @Field({ nullable: true })
    ItemType?: string;

    @Field({ nullable: true })
    RelatedDocumentURL?: string | null;

    @Field({ nullable: true })
    Status?: string;

    @Field({ nullable: true })
    Notes?: string | null;

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Agenda Items
//****************************************************************************
@ObjectType()
export class RunmjCommitteesAgendaItemViewResult {
    @Field(() => [mjCommitteesAgendaItem_])
    Results: mjCommitteesAgendaItem_[];

    @Field(() => String, {nullable: true})
    UserViewRunID?: string;

    @Field(() => Int, {nullable: true})
    RowCount: number;

    @Field(() => Int, {nullable: true})
    TotalRowCount: number;

    @Field(() => Int, {nullable: true})
    ExecutionTime: number;

    @Field({nullable: true})
    ErrorMessage?: string;

    @Field(() => Boolean, {nullable: false})
    Success: boolean;
}

@Resolver(mjCommitteesAgendaItem_)
export class mjCommitteesAgendaItemResolver extends ResolverBase {
    @Query(() => RunmjCommitteesAgendaItemViewResult)
    async RunmjCommitteesAgendaItemViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesAgendaItemViewResult)
    async RunmjCommitteesAgendaItemViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesAgendaItemViewResult)
    async RunmjCommitteesAgendaItemDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Agenda Items';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjCommitteesAgendaItem_, { nullable: true })
    async mjCommitteesAgendaItem(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjCommitteesAgendaItem_ | null> {
        this.CheckUserReadPermissions('Committees: Agenda Items', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwAgendaItems')} WHERE ${provider.QuoteIdentifier('ID')}='${ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Agenda Items', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Agenda Items', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjCommitteesArtifact_])
    async mjCommitteesArtifacts_AgendaItemIDArray(@Root() mjcommitteesagendaitem_: mjCommitteesAgendaItem_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Artifacts', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwArtifacts')} WHERE ${provider.QuoteIdentifier('AgendaItemID')}='${mjcommitteesagendaitem_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Artifacts', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Artifacts', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesMotion_])
    async mjCommitteesMotions_AgendaItemIDArray(@Root() mjcommitteesagendaitem_: mjCommitteesAgendaItem_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Motions', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMotions')} WHERE ${provider.QuoteIdentifier('AgendaItemID')}='${mjcommitteesagendaitem_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Motions', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Motions', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesActionItem_])
    async mjCommitteesActionItems_AgendaItemIDArray(@Root() mjcommitteesagendaitem_: mjCommitteesAgendaItem_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Action Items', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwActionItems')} WHERE ${provider.QuoteIdentifier('AgendaItemID')}='${mjcommitteesagendaitem_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Action Items', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Action Items', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesAgendaItem_])
    async mjCommitteesAgendaItems_ParentAgendaItemIDArray(@Root() mjcommitteesagendaitem_: mjCommitteesAgendaItem_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Agenda Items', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwAgendaItems')} WHERE ${provider.QuoteIdentifier('ParentAgendaItemID')}='${mjcommitteesagendaitem_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Agenda Items', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Agenda Items', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesComment_])
    async mjCommitteesComments_AgendaItemIDArray(@Root() mjcommitteesagendaitem_: mjCommitteesAgendaItem_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Comments', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwComments')} WHERE ${provider.QuoteIdentifier('AgendaItemID')}='${mjcommitteesagendaitem_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Comments', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Comments', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjCommitteesAgendaItem_)
    async CreatemjCommitteesAgendaItem(
        @Arg('input', () => CreatemjCommitteesAgendaItemInput) input: CreatemjCommitteesAgendaItemInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Agenda Items', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjCommitteesAgendaItem_)
    async UpdatemjCommitteesAgendaItem(
        @Arg('input', () => UpdatemjCommitteesAgendaItemInput) input: UpdatemjCommitteesAgendaItemInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Agenda Items', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjCommitteesAgendaItem_)
    async DeletemjCommitteesAgendaItem(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Agenda Items', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Artifact Types
//****************************************************************************
@ObjectType({ description: `DEPRECATED: Migrated to MJ: File Categories. Will be dropped in a future migration.` })
export class mjCommitteesArtifactType_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field({description: `Display name for the artifact type`}) 
    @MaxLength(100)
    Name: string;
        
    @Field({nullable: true, description: `Detailed description of this artifact type`}) 
    Description?: string;
        
    @Field({nullable: true, description: `Optional reference to an MJ Entity that provides additional fields for this artifact type via a 1:1 extension table`}) 
    @MaxLength(36)
    ExtendedEntityID?: string;
        
    @Field({nullable: true, description: `Font Awesome icon class for UI display`}) 
    @MaxLength(100)
    IconClass?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    ExtendedEntity?: string;
        
    @Field(() => [mjCommitteesArtifact_])
    mjCommitteesArtifacts_ArtifactTypeIDArray: mjCommitteesArtifact_[]; // Link to mjCommitteesArtifacts
    
}

//****************************************************************************
// INPUT TYPE for Committees: Artifact Types
//****************************************************************************
@InputType()
export class CreatemjCommitteesArtifactTypeInput {
    @Field({ nullable: true })
    ID?: string;

    @Field({ nullable: true })
    Name?: string;

    @Field({ nullable: true })
    Description: string | null;

    @Field({ nullable: true })
    ExtendedEntityID: string | null;

    @Field({ nullable: true })
    IconClass: string | null;

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Artifact Types
//****************************************************************************
@InputType()
export class UpdatemjCommitteesArtifactTypeInput {
    @Field()
    ID: string;

    @Field({ nullable: true })
    Name?: string;

    @Field({ nullable: true })
    Description?: string | null;

    @Field({ nullable: true })
    ExtendedEntityID?: string | null;

    @Field({ nullable: true })
    IconClass?: string | null;

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Artifact Types
//****************************************************************************
@ObjectType()
export class RunmjCommitteesArtifactTypeViewResult {
    @Field(() => [mjCommitteesArtifactType_])
    Results: mjCommitteesArtifactType_[];

    @Field(() => String, {nullable: true})
    UserViewRunID?: string;

    @Field(() => Int, {nullable: true})
    RowCount: number;

    @Field(() => Int, {nullable: true})
    TotalRowCount: number;

    @Field(() => Int, {nullable: true})
    ExecutionTime: number;

    @Field({nullable: true})
    ErrorMessage?: string;

    @Field(() => Boolean, {nullable: false})
    Success: boolean;
}

@Resolver(mjCommitteesArtifactType_)
export class mjCommitteesArtifactTypeResolver extends ResolverBase {
    @Query(() => RunmjCommitteesArtifactTypeViewResult)
    async RunmjCommitteesArtifactTypeViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesArtifactTypeViewResult)
    async RunmjCommitteesArtifactTypeViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesArtifactTypeViewResult)
    async RunmjCommitteesArtifactTypeDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Artifact Types';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjCommitteesArtifactType_, { nullable: true })
    async mjCommitteesArtifactType(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjCommitteesArtifactType_ | null> {
        this.CheckUserReadPermissions('Committees: Artifact Types', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwArtifactTypes')} WHERE ${provider.QuoteIdentifier('ID')}='${ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Artifact Types', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Artifact Types', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjCommitteesArtifact_])
    async mjCommitteesArtifacts_ArtifactTypeIDArray(@Root() mjcommitteesartifacttype_: mjCommitteesArtifactType_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Artifacts', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwArtifacts')} WHERE ${provider.QuoteIdentifier('ArtifactTypeID')}='${mjcommitteesartifacttype_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Artifacts', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Artifacts', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjCommitteesArtifactType_)
    async CreatemjCommitteesArtifactType(
        @Arg('input', () => CreatemjCommitteesArtifactTypeInput) input: CreatemjCommitteesArtifactTypeInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Artifact Types', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjCommitteesArtifactType_)
    async UpdatemjCommitteesArtifactType(
        @Arg('input', () => UpdatemjCommitteesArtifactTypeInput) input: UpdatemjCommitteesArtifactTypeInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Artifact Types', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjCommitteesArtifactType_)
    async DeletemjCommitteesArtifactType(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Artifact Types', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Artifacts
//****************************************************************************
@ObjectType({ description: `DEPRECATED: Migrated to MJ: Files + File Entity Record Links. Will be dropped in a future migration.` })
export class mjCommitteesArtifact_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    CommitteeID?: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    MeetingID?: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    AgendaItemID?: string;
        
    @Field({description: `Display title for the artifact`}) 
    @MaxLength(255)
    Title: string;
        
    @Field({nullable: true, description: `Description of the artifact contents`}) 
    Description?: string;
        
    @Field() 
    @MaxLength(36)
    ArtifactTypeID: string;
        
    @Field({description: `Storage provider: GoogleDrive, SharePoint, Box, OneDrive, Dropbox, URL`}) 
    @MaxLength(50)
    Provider: string;
        
    @Field({nullable: true, description: `Provider-specific document or file ID`}) 
    @MaxLength(500)
    ExternalID?: string;
        
    @Field({description: `Direct URL to access the artifact`}) 
    @MaxLength(2000)
    URL: string;
        
    @Field({nullable: true, description: `MIME type of the file`}) 
    @MaxLength(100)
    MimeType?: string;
        
    @Field(() => Int, {nullable: true, description: `File size in bytes`}) 
    FileSize?: number;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    UploadedByPersonID?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    TaskID?: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    Committee?: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    Meeting?: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    AgendaItem?: string;
        
    @Field() 
    @MaxLength(100)
    ArtifactType: string;
        
    @Field({nullable: true}) 
    @MaxLength(244)
    UploadedByPerson?: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    Task?: string;
        
    @Field(() => [mjCommitteesMinute_])
    mjCommitteesMinutes_ArtifactIDArray: mjCommitteesMinute_[]; // Link to mjCommitteesMinutes
    
    @Field(() => [mjCommitteesComment_])
    mjCommitteesComments_ArtifactIDArray: mjCommitteesComment_[]; // Link to mjCommitteesComments
    
}

//****************************************************************************
// INPUT TYPE for Committees: Artifacts
//****************************************************************************
@InputType()
export class CreatemjCommitteesArtifactInput {
    @Field({ nullable: true })
    ID?: string;

    @Field({ nullable: true })
    CommitteeID: string | null;

    @Field({ nullable: true })
    MeetingID: string | null;

    @Field({ nullable: true })
    AgendaItemID: string | null;

    @Field({ nullable: true })
    Title?: string;

    @Field({ nullable: true })
    Description: string | null;

    @Field({ nullable: true })
    ArtifactTypeID?: string;

    @Field({ nullable: true })
    Provider?: string;

    @Field({ nullable: true })
    ExternalID: string | null;

    @Field({ nullable: true })
    URL?: string;

    @Field({ nullable: true })
    MimeType: string | null;

    @Field(() => Int, { nullable: true })
    FileSize: number | null;

    @Field({ nullable: true })
    UploadedByPersonID: string | null;

    @Field({ nullable: true })
    TaskID: string | null;

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Artifacts
//****************************************************************************
@InputType()
export class UpdatemjCommitteesArtifactInput {
    @Field()
    ID: string;

    @Field({ nullable: true })
    CommitteeID?: string | null;

    @Field({ nullable: true })
    MeetingID?: string | null;

    @Field({ nullable: true })
    AgendaItemID?: string | null;

    @Field({ nullable: true })
    Title?: string;

    @Field({ nullable: true })
    Description?: string | null;

    @Field({ nullable: true })
    ArtifactTypeID?: string;

    @Field({ nullable: true })
    Provider?: string;

    @Field({ nullable: true })
    ExternalID?: string | null;

    @Field({ nullable: true })
    URL?: string;

    @Field({ nullable: true })
    MimeType?: string | null;

    @Field(() => Int, { nullable: true })
    FileSize?: number | null;

    @Field({ nullable: true })
    UploadedByPersonID?: string | null;

    @Field({ nullable: true })
    TaskID?: string | null;

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Artifacts
//****************************************************************************
@ObjectType()
export class RunmjCommitteesArtifactViewResult {
    @Field(() => [mjCommitteesArtifact_])
    Results: mjCommitteesArtifact_[];

    @Field(() => String, {nullable: true})
    UserViewRunID?: string;

    @Field(() => Int, {nullable: true})
    RowCount: number;

    @Field(() => Int, {nullable: true})
    TotalRowCount: number;

    @Field(() => Int, {nullable: true})
    ExecutionTime: number;

    @Field({nullable: true})
    ErrorMessage?: string;

    @Field(() => Boolean, {nullable: false})
    Success: boolean;
}

@Resolver(mjCommitteesArtifact_)
export class mjCommitteesArtifactResolver extends ResolverBase {
    @Query(() => RunmjCommitteesArtifactViewResult)
    async RunmjCommitteesArtifactViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesArtifactViewResult)
    async RunmjCommitteesArtifactViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesArtifactViewResult)
    async RunmjCommitteesArtifactDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Artifacts';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjCommitteesArtifact_, { nullable: true })
    async mjCommitteesArtifact(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjCommitteesArtifact_ | null> {
        this.CheckUserReadPermissions('Committees: Artifacts', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwArtifacts')} WHERE ${provider.QuoteIdentifier('ID')}='${ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Artifacts', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Artifacts', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjCommitteesMinute_])
    async mjCommitteesMinutes_ArtifactIDArray(@Root() mjcommitteesartifact_: mjCommitteesArtifact_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Minutes', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMinutes')} WHERE ${provider.QuoteIdentifier('ArtifactID')}='${mjcommitteesartifact_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Minutes', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Minutes', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesComment_])
    async mjCommitteesComments_ArtifactIDArray(@Root() mjcommitteesartifact_: mjCommitteesArtifact_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Comments', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwComments')} WHERE ${provider.QuoteIdentifier('ArtifactID')}='${mjcommitteesartifact_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Comments', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Comments', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjCommitteesArtifact_)
    async CreatemjCommitteesArtifact(
        @Arg('input', () => CreatemjCommitteesArtifactInput) input: CreatemjCommitteesArtifactInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Artifacts', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjCommitteesArtifact_)
    async UpdatemjCommitteesArtifact(
        @Arg('input', () => UpdatemjCommitteesArtifactInput) input: UpdatemjCommitteesArtifactInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Artifacts', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjCommitteesArtifact_)
    async DeletemjCommitteesArtifact(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Artifacts', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Attendances
//****************************************************************************
@ObjectType({ description: `Meeting attendance records for committee members` })
export class mjCommitteesAttendance_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field() 
    @MaxLength(36)
    MeetingID: string;
        
    @Field() 
    @MaxLength(36)
    PersonID: string;
        
    @Field({description: `Attendance status: Expected, Present, Absent, Excused, Partial`}) 
    @MaxLength(50)
    AttendanceStatus: string;
        
    @Field({nullable: true, description: `Timestamp when the attendee joined the meeting`}) 
    JoinedAt?: Date;
        
    @Field({nullable: true, description: `Timestamp when the attendee left the meeting`}) 
    LeftAt?: Date;
        
    @Field({nullable: true, description: `Additional notes about attendance`}) 
    @MaxLength(500)
    Notes?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field() 
    @MaxLength(255)
    Meeting: string;
        
    @Field({nullable: true}) 
    @MaxLength(244)
    Person?: string;
        
}

//****************************************************************************
// INPUT TYPE for Committees: Attendances
//****************************************************************************
@InputType()
export class CreatemjCommitteesAttendanceInput {
    @Field({ nullable: true })
    ID?: string;

    @Field({ nullable: true })
    MeetingID?: string;

    @Field({ nullable: true })
    PersonID?: string;

    @Field({ nullable: true })
    AttendanceStatus?: string;

    @Field({ nullable: true })
    JoinedAt: Date | null;

    @Field({ nullable: true })
    LeftAt: Date | null;

    @Field({ nullable: true })
    Notes: string | null;

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Attendances
//****************************************************************************
@InputType()
export class UpdatemjCommitteesAttendanceInput {
    @Field()
    ID: string;

    @Field({ nullable: true })
    MeetingID?: string;

    @Field({ nullable: true })
    PersonID?: string;

    @Field({ nullable: true })
    AttendanceStatus?: string;

    @Field({ nullable: true })
    JoinedAt?: Date | null;

    @Field({ nullable: true })
    LeftAt?: Date | null;

    @Field({ nullable: true })
    Notes?: string | null;

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Attendances
//****************************************************************************
@ObjectType()
export class RunmjCommitteesAttendanceViewResult {
    @Field(() => [mjCommitteesAttendance_])
    Results: mjCommitteesAttendance_[];

    @Field(() => String, {nullable: true})
    UserViewRunID?: string;

    @Field(() => Int, {nullable: true})
    RowCount: number;

    @Field(() => Int, {nullable: true})
    TotalRowCount: number;

    @Field(() => Int, {nullable: true})
    ExecutionTime: number;

    @Field({nullable: true})
    ErrorMessage?: string;

    @Field(() => Boolean, {nullable: false})
    Success: boolean;
}

@Resolver(mjCommitteesAttendance_)
export class mjCommitteesAttendanceResolver extends ResolverBase {
    @Query(() => RunmjCommitteesAttendanceViewResult)
    async RunmjCommitteesAttendanceViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesAttendanceViewResult)
    async RunmjCommitteesAttendanceViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesAttendanceViewResult)
    async RunmjCommitteesAttendanceDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Attendances';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjCommitteesAttendance_, { nullable: true })
    async mjCommitteesAttendance(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjCommitteesAttendance_ | null> {
        this.CheckUserReadPermissions('Committees: Attendances', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwAttendances')} WHERE ${provider.QuoteIdentifier('ID')}='${ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Attendances', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Attendances', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @Mutation(() => mjCommitteesAttendance_)
    async CreatemjCommitteesAttendance(
        @Arg('input', () => CreatemjCommitteesAttendanceInput) input: CreatemjCommitteesAttendanceInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Attendances', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjCommitteesAttendance_)
    async UpdatemjCommitteesAttendance(
        @Arg('input', () => UpdatemjCommitteesAttendanceInput) input: UpdatemjCommitteesAttendanceInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Attendances', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjCommitteesAttendance_)
    async DeletemjCommitteesAttendance(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Attendances', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Comments
//****************************************************************************
@ObjectType({ description: `Threaded discussion comments on committee meetings, agenda items, action items, and documents` })
export class mjCommitteesComment_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field({description: `Committee this comment belongs to (always set for easy filtering)`}) 
    @MaxLength(36)
    CommitteeID: string;
        
    @Field({nullable: true, description: `Optional meeting this comment is attached to`}) 
    @MaxLength(36)
    MeetingID?: string;
        
    @Field({nullable: true, description: `Optional agenda item this comment is attached to`}) 
    @MaxLength(36)
    AgendaItemID?: string;
        
    @Field({nullable: true, description: `Optional artifact/document this comment is attached to`}) 
    @MaxLength(36)
    ArtifactID?: string;
        
    @Field({nullable: true, description: `Parent comment for threading; NULL for top-level comments`}) 
    @MaxLength(36)
    ParentCommentID?: string;
        
    @Field({description: `Person who wrote the comment`}) 
    @MaxLength(36)
    PersonID: string;
        
    @Field({description: `Comment body text`}) 
    CommentText: string;
        
    @Field({nullable: true, description: `JSON array of PersonIDs mentioned via @mentions`}) 
    MentionedPersonIDs?: string;
        
    @Field(() => Boolean, {description: `Whether this comment thread has been resolved`}) 
    IsResolved: boolean;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    TaskID?: string;
        
    @Field() 
    @MaxLength(255)
    Committee: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    Meeting?: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    AgendaItem?: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    Artifact?: string;
        
    @Field({nullable: true}) 
    ParentComment?: string;
        
    @Field({nullable: true}) 
    @MaxLength(244)
    Person?: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    Task?: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    RootParentCommentID?: string;
        
    @Field(() => [mjCommitteesComment_])
    mjCommitteesComments_ParentCommentIDArray: mjCommitteesComment_[]; // Link to mjCommitteesComments
    
}

//****************************************************************************
// INPUT TYPE for Committees: Comments
//****************************************************************************
@InputType()
export class CreatemjCommitteesCommentInput {
    @Field({ nullable: true })
    ID?: string;

    @Field({ nullable: true })
    CommitteeID?: string;

    @Field({ nullable: true })
    MeetingID: string | null;

    @Field({ nullable: true })
    AgendaItemID: string | null;

    @Field({ nullable: true })
    ArtifactID: string | null;

    @Field({ nullable: true })
    ParentCommentID: string | null;

    @Field({ nullable: true })
    PersonID?: string;

    @Field({ nullable: true })
    CommentText?: string;

    @Field({ nullable: true })
    MentionedPersonIDs: string | null;

    @Field(() => Boolean, { nullable: true })
    IsResolved?: boolean;

    @Field({ nullable: true })
    TaskID: string | null;

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Comments
//****************************************************************************
@InputType()
export class UpdatemjCommitteesCommentInput {
    @Field()
    ID: string;

    @Field({ nullable: true })
    CommitteeID?: string;

    @Field({ nullable: true })
    MeetingID?: string | null;

    @Field({ nullable: true })
    AgendaItemID?: string | null;

    @Field({ nullable: true })
    ArtifactID?: string | null;

    @Field({ nullable: true })
    ParentCommentID?: string | null;

    @Field({ nullable: true })
    PersonID?: string;

    @Field({ nullable: true })
    CommentText?: string;

    @Field({ nullable: true })
    MentionedPersonIDs?: string | null;

    @Field(() => Boolean, { nullable: true })
    IsResolved?: boolean;

    @Field({ nullable: true })
    TaskID?: string | null;

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Comments
//****************************************************************************
@ObjectType()
export class RunmjCommitteesCommentViewResult {
    @Field(() => [mjCommitteesComment_])
    Results: mjCommitteesComment_[];

    @Field(() => String, {nullable: true})
    UserViewRunID?: string;

    @Field(() => Int, {nullable: true})
    RowCount: number;

    @Field(() => Int, {nullable: true})
    TotalRowCount: number;

    @Field(() => Int, {nullable: true})
    ExecutionTime: number;

    @Field({nullable: true})
    ErrorMessage?: string;

    @Field(() => Boolean, {nullable: false})
    Success: boolean;
}

@Resolver(mjCommitteesComment_)
export class mjCommitteesCommentResolver extends ResolverBase {
    @Query(() => RunmjCommitteesCommentViewResult)
    async RunmjCommitteesCommentViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesCommentViewResult)
    async RunmjCommitteesCommentViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesCommentViewResult)
    async RunmjCommitteesCommentDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Comments';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjCommitteesComment_, { nullable: true })
    async mjCommitteesComment(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjCommitteesComment_ | null> {
        this.CheckUserReadPermissions('Committees: Comments', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwComments')} WHERE ${provider.QuoteIdentifier('ID')}='${ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Comments', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Comments', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjCommitteesComment_])
    async mjCommitteesComments_ParentCommentIDArray(@Root() mjcommitteescomment_: mjCommitteesComment_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Comments', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwComments')} WHERE ${provider.QuoteIdentifier('ParentCommentID')}='${mjcommitteescomment_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Comments', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Comments', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjCommitteesComment_)
    async CreatemjCommitteesComment(
        @Arg('input', () => CreatemjCommitteesCommentInput) input: CreatemjCommitteesCommentInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Comments', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjCommitteesComment_)
    async UpdatemjCommitteesComment(
        @Arg('input', () => UpdatemjCommitteesCommentInput) input: UpdatemjCommitteesCommentInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Comments', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjCommitteesComment_)
    async DeletemjCommitteesComment(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Comments', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Committees
//****************************************************************************
@ObjectType({ description: `Core committee records with hierarchy support` })
export class mjCommitteesCommittee_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field({description: `Official name of the committee`}) 
    @MaxLength(255)
    Name: string;
        
    @Field({nullable: true, description: `Detailed description of the committee purpose and scope`}) 
    Description?: string;
        
    @Field() 
    @MaxLength(36)
    TypeID: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    ParentCommitteeID?: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    OrganizationID?: string;
        
    @Field({nullable: true, description: `URL to the committee charter document`}) 
    @MaxLength(1000)
    CharterDocumentURL?: string;
        
    @Field({nullable: true, description: `Brief statement of the committee mission`}) 
    MissionStatement?: string;
        
    @Field({description: `Current status: Active, Inactive, Pending, or Dissolved`}) 
    @MaxLength(50)
    Status: string;
        
    @Field(() => Boolean, {description: `Whether the committee is visible to all users`}) 
    IsPublic: boolean;
        
    @Field({nullable: true, description: `Date the committee was formed`}) 
    FormationDate?: Date;
        
    @Field({nullable: true, description: `Date the committee was dissolved, if applicable`}) 
    DissolutionDate?: Date;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field() 
    @MaxLength(100)
    Type: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    ParentCommittee?: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    Organization?: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    RootParentCommitteeID?: string;
        
    @Field(() => [mjCommitteesTerm_])
    mjCommitteesTerms_CommitteeIDArray: mjCommitteesTerm_[]; // Link to mjCommitteesTerms
    
    @Field(() => [mjCommitteesMeeting_])
    mjCommitteesMeetings_CommitteeIDArray: mjCommitteesMeeting_[]; // Link to mjCommitteesMeetings
    
    @Field(() => [mjCommitteesMembership_])
    mjCommitteesMemberships_CommitteeIDArray: mjCommitteesMembership_[]; // Link to mjCommitteesMemberships
    
    @Field(() => [mjCommitteesArtifact_])
    mjCommitteesArtifacts_CommitteeIDArray: mjCommitteesArtifact_[]; // Link to mjCommitteesArtifacts
    
    @Field(() => [mjCommitteesActionItem_])
    mjCommitteesActionItems_CommitteeIDArray: mjCommitteesActionItem_[]; // Link to mjCommitteesActionItems
    
    @Field(() => [mjCommitteesCommittee_])
    mjCommitteesCommittees_ParentCommitteeIDArray: mjCommitteesCommittee_[]; // Link to mjCommitteesCommittees
    
    @Field(() => [mjCommitteesComment_])
    mjCommitteesComments_CommitteeIDArray: mjCommitteesComment_[]; // Link to mjCommitteesComments
    
}

//****************************************************************************
// INPUT TYPE for Committees: Committees
//****************************************************************************
@InputType()
export class CreatemjCommitteesCommitteeInput {
    @Field({ nullable: true })
    ID?: string;

    @Field({ nullable: true })
    Name?: string;

    @Field({ nullable: true })
    Description: string | null;

    @Field({ nullable: true })
    TypeID?: string;

    @Field({ nullable: true })
    ParentCommitteeID: string | null;

    @Field({ nullable: true })
    OrganizationID: string | null;

    @Field({ nullable: true })
    CharterDocumentURL: string | null;

    @Field({ nullable: true })
    MissionStatement: string | null;

    @Field({ nullable: true })
    Status?: string;

    @Field(() => Boolean, { nullable: true })
    IsPublic?: boolean;

    @Field({ nullable: true })
    FormationDate: Date | null;

    @Field({ nullable: true })
    DissolutionDate: Date | null;

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Committees
//****************************************************************************
@InputType()
export class UpdatemjCommitteesCommitteeInput {
    @Field()
    ID: string;

    @Field({ nullable: true })
    Name?: string;

    @Field({ nullable: true })
    Description?: string | null;

    @Field({ nullable: true })
    TypeID?: string;

    @Field({ nullable: true })
    ParentCommitteeID?: string | null;

    @Field({ nullable: true })
    OrganizationID?: string | null;

    @Field({ nullable: true })
    CharterDocumentURL?: string | null;

    @Field({ nullable: true })
    MissionStatement?: string | null;

    @Field({ nullable: true })
    Status?: string;

    @Field(() => Boolean, { nullable: true })
    IsPublic?: boolean;

    @Field({ nullable: true })
    FormationDate?: Date | null;

    @Field({ nullable: true })
    DissolutionDate?: Date | null;

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Committees
//****************************************************************************
@ObjectType()
export class RunmjCommitteesCommitteeViewResult {
    @Field(() => [mjCommitteesCommittee_])
    Results: mjCommitteesCommittee_[];

    @Field(() => String, {nullable: true})
    UserViewRunID?: string;

    @Field(() => Int, {nullable: true})
    RowCount: number;

    @Field(() => Int, {nullable: true})
    TotalRowCount: number;

    @Field(() => Int, {nullable: true})
    ExecutionTime: number;

    @Field({nullable: true})
    ErrorMessage?: string;

    @Field(() => Boolean, {nullable: false})
    Success: boolean;
}

@Resolver(mjCommitteesCommittee_)
export class mjCommitteesCommitteeResolver extends ResolverBase {
    @Query(() => RunmjCommitteesCommitteeViewResult)
    async RunmjCommitteesCommitteeViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesCommitteeViewResult)
    async RunmjCommitteesCommitteeViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesCommitteeViewResult)
    async RunmjCommitteesCommitteeDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Committees';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjCommitteesCommittee_, { nullable: true })
    async mjCommitteesCommittee(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjCommitteesCommittee_ | null> {
        this.CheckUserReadPermissions('Committees: Committees', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwCommittees')} WHERE ${provider.QuoteIdentifier('ID')}='${ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Committees', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Committees', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjCommitteesTerm_])
    async mjCommitteesTerms_CommitteeIDArray(@Root() mjcommitteescommittee_: mjCommitteesCommittee_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Terms', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwTerms')} WHERE ${provider.QuoteIdentifier('CommitteeID')}='${mjcommitteescommittee_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Terms', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Terms', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesMeeting_])
    async mjCommitteesMeetings_CommitteeIDArray(@Root() mjcommitteescommittee_: mjCommitteesCommittee_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Meetings', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMeetings')} WHERE ${provider.QuoteIdentifier('CommitteeID')}='${mjcommitteescommittee_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Meetings', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Meetings', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesMembership_])
    async mjCommitteesMemberships_CommitteeIDArray(@Root() mjcommitteescommittee_: mjCommitteesCommittee_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Memberships', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMemberships')} WHERE ${provider.QuoteIdentifier('CommitteeID')}='${mjcommitteescommittee_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Memberships', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Memberships', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesArtifact_])
    async mjCommitteesArtifacts_CommitteeIDArray(@Root() mjcommitteescommittee_: mjCommitteesCommittee_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Artifacts', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwArtifacts')} WHERE ${provider.QuoteIdentifier('CommitteeID')}='${mjcommitteescommittee_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Artifacts', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Artifacts', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesActionItem_])
    async mjCommitteesActionItems_CommitteeIDArray(@Root() mjcommitteescommittee_: mjCommitteesCommittee_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Action Items', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwActionItems')} WHERE ${provider.QuoteIdentifier('CommitteeID')}='${mjcommitteescommittee_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Action Items', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Action Items', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesCommittee_])
    async mjCommitteesCommittees_ParentCommitteeIDArray(@Root() mjcommitteescommittee_: mjCommitteesCommittee_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Committees', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwCommittees')} WHERE ${provider.QuoteIdentifier('ParentCommitteeID')}='${mjcommitteescommittee_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Committees', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Committees', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesComment_])
    async mjCommitteesComments_CommitteeIDArray(@Root() mjcommitteescommittee_: mjCommitteesCommittee_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Comments', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwComments')} WHERE ${provider.QuoteIdentifier('CommitteeID')}='${mjcommitteescommittee_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Comments', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Comments', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjCommitteesCommittee_)
    async CreatemjCommitteesCommittee(
        @Arg('input', () => CreatemjCommitteesCommitteeInput) input: CreatemjCommitteesCommitteeInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Committees', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjCommitteesCommittee_)
    async UpdatemjCommitteesCommittee(
        @Arg('input', () => UpdatemjCommitteesCommitteeInput) input: UpdatemjCommitteesCommitteeInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Committees', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjCommitteesCommittee_)
    async DeletemjCommitteesCommittee(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Committees', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Meetings
//****************************************************************************
@ObjectType({ description: `Committee meeting records with scheduling and video conferencing info` })
export class mjCommitteesMeeting_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field() 
    @MaxLength(36)
    CommitteeID: string;
        
    @Field({description: `Title of the meeting`}) 
    @MaxLength(255)
    Title: string;
        
    @Field({nullable: true, description: `Detailed description or purpose of the meeting`}) 
    Description?: string;
        
    @Field({description: `Scheduled start date and time with timezone offset`}) 
    StartDateTime: Date;
        
    @Field({nullable: true, description: `Scheduled end date and time with timezone offset`}) 
    EndDateTime?: Date;
        
    @Field({description: `IANA timezone identifier for the meeting`}) 
    @MaxLength(50)
    TimeZone: string;
        
    @Field({description: `Meeting format: Virtual, InPerson, or Hybrid`}) 
    @MaxLength(50)
    LocationType: string;
        
    @Field({nullable: true, description: `Physical address or room name for in-person meetings`}) 
    @MaxLength(500)
    LocationText?: string;
        
    @Field({nullable: true, description: `Video conferencing provider: Zoom, Teams, Meet, etc.`}) 
    @MaxLength(50)
    VideoProvider?: string;
        
    @Field({nullable: true, description: `External meeting ID from the video provider`}) 
    @MaxLength(255)
    VideoMeetingID?: string;
        
    @Field({nullable: true, description: `URL to join the video meeting`}) 
    @MaxLength(1000)
    VideoJoinURL?: string;
        
    @Field({nullable: true, description: `URL to the meeting recording after completion`}) 
    @MaxLength(1000)
    VideoRecordingURL?: string;
        
    @Field({nullable: true, description: `URL to the meeting transcript`}) 
    @MaxLength(1000)
    TranscriptURL?: string;
        
    @Field({description: `Current status: Draft, Scheduled, InProgress, Completed, Cancelled, Postponed`}) 
    @MaxLength(50)
    Status: string;
        
    @Field({nullable: true, description: `External calendar event ID for sync purposes`}) 
    @MaxLength(255)
    CalendarEventID?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field({nullable: true, description: `FK to VideoProvider — when set, video meeting URL is auto-created on save`}) 
    @MaxLength(36)
    VideoProviderID?: string;
        
    @Field() 
    @MaxLength(255)
    Committee: string;
        
    @Field({nullable: true}) 
    @MaxLength(100)
    VideoProvider_Virtual?: string;
        
    @Field(() => [mjCommitteesAttendance_])
    mjCommitteesAttendances_MeetingIDArray: mjCommitteesAttendance_[]; // Link to mjCommitteesAttendances
    
    @Field(() => [mjCommitteesMinute_])
    mjCommitteesMinutes_MeetingIDArray: mjCommitteesMinute_[]; // Link to mjCommitteesMinutes
    
    @Field(() => [mjCommitteesAgendaItem_])
    mjCommitteesAgendaItems_MeetingIDArray: mjCommitteesAgendaItem_[]; // Link to mjCommitteesAgendaItems
    
    @Field(() => [mjCommitteesMinute_])
    mjCommitteesMinutes_ApprovedByMeetingIDArray: mjCommitteesMinute_[]; // Link to mjCommitteesMinutes
    
    @Field(() => [mjCommitteesMotion_])
    mjCommitteesMotions_MeetingIDArray: mjCommitteesMotion_[]; // Link to mjCommitteesMotions
    
    @Field(() => [mjCommitteesActionItem_])
    mjCommitteesActionItems_MeetingIDArray: mjCommitteesActionItem_[]; // Link to mjCommitteesActionItems
    
    @Field(() => [mjCommitteesArtifact_])
    mjCommitteesArtifacts_MeetingIDArray: mjCommitteesArtifact_[]; // Link to mjCommitteesArtifacts
    
    @Field(() => [mjCommitteesComment_])
    mjCommitteesComments_MeetingIDArray: mjCommitteesComment_[]; // Link to mjCommitteesComments
    
}

//****************************************************************************
// INPUT TYPE for Committees: Meetings
//****************************************************************************
@InputType()
export class CreatemjCommitteesMeetingInput {
    @Field({ nullable: true })
    ID?: string;

    @Field({ nullable: true })
    CommitteeID?: string;

    @Field({ nullable: true })
    Title?: string;

    @Field({ nullable: true })
    Description: string | null;

    @Field({ nullable: true })
    StartDateTime?: Date;

    @Field({ nullable: true })
    EndDateTime: Date | null;

    @Field({ nullable: true })
    TimeZone?: string;

    @Field({ nullable: true })
    LocationType?: string;

    @Field({ nullable: true })
    LocationText: string | null;

    @Field({ nullable: true })
    VideoProvider: string | null;

    @Field({ nullable: true })
    VideoMeetingID: string | null;

    @Field({ nullable: true })
    VideoJoinURL: string | null;

    @Field({ nullable: true })
    VideoRecordingURL: string | null;

    @Field({ nullable: true })
    TranscriptURL: string | null;

    @Field({ nullable: true })
    Status?: string;

    @Field({ nullable: true })
    CalendarEventID: string | null;

    @Field({ nullable: true })
    VideoProviderID: string | null;

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Meetings
//****************************************************************************
@InputType()
export class UpdatemjCommitteesMeetingInput {
    @Field()
    ID: string;

    @Field({ nullable: true })
    CommitteeID?: string;

    @Field({ nullable: true })
    Title?: string;

    @Field({ nullable: true })
    Description?: string | null;

    @Field({ nullable: true })
    StartDateTime?: Date;

    @Field({ nullable: true })
    EndDateTime?: Date | null;

    @Field({ nullable: true })
    TimeZone?: string;

    @Field({ nullable: true })
    LocationType?: string;

    @Field({ nullable: true })
    LocationText?: string | null;

    @Field({ nullable: true })
    VideoProvider?: string | null;

    @Field({ nullable: true })
    VideoMeetingID?: string | null;

    @Field({ nullable: true })
    VideoJoinURL?: string | null;

    @Field({ nullable: true })
    VideoRecordingURL?: string | null;

    @Field({ nullable: true })
    TranscriptURL?: string | null;

    @Field({ nullable: true })
    Status?: string;

    @Field({ nullable: true })
    CalendarEventID?: string | null;

    @Field({ nullable: true })
    VideoProviderID?: string | null;

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Meetings
//****************************************************************************
@ObjectType()
export class RunmjCommitteesMeetingViewResult {
    @Field(() => [mjCommitteesMeeting_])
    Results: mjCommitteesMeeting_[];

    @Field(() => String, {nullable: true})
    UserViewRunID?: string;

    @Field(() => Int, {nullable: true})
    RowCount: number;

    @Field(() => Int, {nullable: true})
    TotalRowCount: number;

    @Field(() => Int, {nullable: true})
    ExecutionTime: number;

    @Field({nullable: true})
    ErrorMessage?: string;

    @Field(() => Boolean, {nullable: false})
    Success: boolean;
}

@Resolver(mjCommitteesMeeting_)
export class mjCommitteesMeetingResolver extends ResolverBase {
    @Query(() => RunmjCommitteesMeetingViewResult)
    async RunmjCommitteesMeetingViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesMeetingViewResult)
    async RunmjCommitteesMeetingViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesMeetingViewResult)
    async RunmjCommitteesMeetingDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Meetings';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjCommitteesMeeting_, { nullable: true })
    async mjCommitteesMeeting(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjCommitteesMeeting_ | null> {
        this.CheckUserReadPermissions('Committees: Meetings', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMeetings')} WHERE ${provider.QuoteIdentifier('ID')}='${ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Meetings', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Meetings', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjCommitteesAttendance_])
    async mjCommitteesAttendances_MeetingIDArray(@Root() mjcommitteesmeeting_: mjCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Attendances', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwAttendances')} WHERE ${provider.QuoteIdentifier('MeetingID')}='${mjcommitteesmeeting_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Attendances', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Attendances', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesMinute_])
    async mjCommitteesMinutes_MeetingIDArray(@Root() mjcommitteesmeeting_: mjCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Minutes', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMinutes')} WHERE ${provider.QuoteIdentifier('MeetingID')}='${mjcommitteesmeeting_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Minutes', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Minutes', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesAgendaItem_])
    async mjCommitteesAgendaItems_MeetingIDArray(@Root() mjcommitteesmeeting_: mjCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Agenda Items', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwAgendaItems')} WHERE ${provider.QuoteIdentifier('MeetingID')}='${mjcommitteesmeeting_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Agenda Items', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Agenda Items', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesMinute_])
    async mjCommitteesMinutes_ApprovedByMeetingIDArray(@Root() mjcommitteesmeeting_: mjCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Minutes', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMinutes')} WHERE ${provider.QuoteIdentifier('ApprovedByMeetingID')}='${mjcommitteesmeeting_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Minutes', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Minutes', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesMotion_])
    async mjCommitteesMotions_MeetingIDArray(@Root() mjcommitteesmeeting_: mjCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Motions', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMotions')} WHERE ${provider.QuoteIdentifier('MeetingID')}='${mjcommitteesmeeting_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Motions', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Motions', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesActionItem_])
    async mjCommitteesActionItems_MeetingIDArray(@Root() mjcommitteesmeeting_: mjCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Action Items', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwActionItems')} WHERE ${provider.QuoteIdentifier('MeetingID')}='${mjcommitteesmeeting_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Action Items', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Action Items', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesArtifact_])
    async mjCommitteesArtifacts_MeetingIDArray(@Root() mjcommitteesmeeting_: mjCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Artifacts', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwArtifacts')} WHERE ${provider.QuoteIdentifier('MeetingID')}='${mjcommitteesmeeting_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Artifacts', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Artifacts', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesComment_])
    async mjCommitteesComments_MeetingIDArray(@Root() mjcommitteesmeeting_: mjCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Comments', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwComments')} WHERE ${provider.QuoteIdentifier('MeetingID')}='${mjcommitteesmeeting_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Comments', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Comments', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjCommitteesMeeting_)
    async CreatemjCommitteesMeeting(
        @Arg('input', () => CreatemjCommitteesMeetingInput) input: CreatemjCommitteesMeetingInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Meetings', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjCommitteesMeeting_)
    async UpdatemjCommitteesMeeting(
        @Arg('input', () => UpdatemjCommitteesMeetingInput) input: UpdatemjCommitteesMeetingInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Meetings', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjCommitteesMeeting_)
    async DeletemjCommitteesMeeting(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Meetings', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Memberships
//****************************************************************************
@ObjectType({ description: `Person assignments to committees with roles and terms` })
export class mjCommitteesMembership_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field() 
    @MaxLength(36)
    PersonID: string;
        
    @Field() 
    @MaxLength(36)
    RoleID: string;
        
    @Field() 
    @MaxLength(36)
    TermID: string;
        
    @Field({description: `Date the membership started`}) 
    StartDate: Date;
        
    @Field({nullable: true, description: `Date the membership ended, if applicable`}) 
    EndDate?: Date;
        
    @Field({description: `Current status: Active, Pending, Ended, or Suspended`}) 
    @MaxLength(50)
    Status: string;
        
    @Field({nullable: true, description: `Reason the membership ended: Term ended, Resigned, Removed, etc.`}) 
    @MaxLength(100)
    EndReason?: string;
        
    @Field({nullable: true, description: `Additional notes about this membership`}) 
    Notes?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field({nullable: true}) 
    @MaxLength(244)
    Person?: string;
        
    @Field() 
    @MaxLength(100)
    Role: string;
        
    @Field() 
    @MaxLength(100)
    Term: string;
        
    @Field(() => [mjCommitteesVote_])
    mjCommitteesVotes_MembershipIDArray: mjCommitteesVote_[]; // Link to mjCommitteesVotes
    
    @Field(() => [mjCommitteesMotion_])
    mjCommitteesMotions_SecondedByMembershipIDArray: mjCommitteesMotion_[]; // Link to mjCommitteesMotions
    
    @Field(() => [mjCommitteesMotion_])
    mjCommitteesMotions_MovedByMembershipIDArray: mjCommitteesMotion_[]; // Link to mjCommitteesMotions
    
}

//****************************************************************************
// INPUT TYPE for Committees: Memberships
//****************************************************************************
@InputType()
export class CreatemjCommitteesMembershipInput {
    @Field({ nullable: true })
    ID?: string;

    @Field({ nullable: true })
    PersonID?: string;

    @Field({ nullable: true })
    RoleID?: string;

    @Field({ nullable: true })
    TermID?: string;

    @Field({ nullable: true })
    StartDate?: Date;

    @Field({ nullable: true })
    EndDate: Date | null;

    @Field({ nullable: true })
    Status?: string;

    @Field({ nullable: true })
    EndReason: string | null;

    @Field({ nullable: true })
    Notes: string | null;

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Memberships
//****************************************************************************
@InputType()
export class UpdatemjCommitteesMembershipInput {
    @Field()
    ID: string;

    @Field({ nullable: true })
    PersonID?: string;

    @Field({ nullable: true })
    RoleID?: string;

    @Field({ nullable: true })
    TermID?: string;

    @Field({ nullable: true })
    StartDate?: Date;

    @Field({ nullable: true })
    EndDate?: Date | null;

    @Field({ nullable: true })
    Status?: string;

    @Field({ nullable: true })
    EndReason?: string | null;

    @Field({ nullable: true })
    Notes?: string | null;

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Memberships
//****************************************************************************
@ObjectType()
export class RunmjCommitteesMembershipViewResult {
    @Field(() => [mjCommitteesMembership_])
    Results: mjCommitteesMembership_[];

    @Field(() => String, {nullable: true})
    UserViewRunID?: string;

    @Field(() => Int, {nullable: true})
    RowCount: number;

    @Field(() => Int, {nullable: true})
    TotalRowCount: number;

    @Field(() => Int, {nullable: true})
    ExecutionTime: number;

    @Field({nullable: true})
    ErrorMessage?: string;

    @Field(() => Boolean, {nullable: false})
    Success: boolean;
}

@Resolver(mjCommitteesMembership_)
export class mjCommitteesMembershipResolver extends ResolverBase {
    @Query(() => RunmjCommitteesMembershipViewResult)
    async RunmjCommitteesMembershipViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesMembershipViewResult)
    async RunmjCommitteesMembershipViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesMembershipViewResult)
    async RunmjCommitteesMembershipDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Memberships';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjCommitteesMembership_, { nullable: true })
    async mjCommitteesMembership(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjCommitteesMembership_ | null> {
        this.CheckUserReadPermissions('Committees: Memberships', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMemberships')} WHERE ${provider.QuoteIdentifier('ID')}='${ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Memberships', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Memberships', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjCommitteesVote_])
    async mjCommitteesVotes_MembershipIDArray(@Root() mjcommitteesmembership_: mjCommitteesMembership_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Votes', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwVotes')} WHERE ${provider.QuoteIdentifier('MembershipID')}='${mjcommitteesmembership_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Votes', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Votes', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesMotion_])
    async mjCommitteesMotions_SecondedByMembershipIDArray(@Root() mjcommitteesmembership_: mjCommitteesMembership_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Motions', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMotions')} WHERE ${provider.QuoteIdentifier('SecondedByMembershipID')}='${mjcommitteesmembership_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Motions', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Motions', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesMotion_])
    async mjCommitteesMotions_MovedByMembershipIDArray(@Root() mjcommitteesmembership_: mjCommitteesMembership_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Motions', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMotions')} WHERE ${provider.QuoteIdentifier('MovedByMembershipID')}='${mjcommitteesmembership_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Motions', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Motions', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjCommitteesMembership_)
    async CreatemjCommitteesMembership(
        @Arg('input', () => CreatemjCommitteesMembershipInput) input: CreatemjCommitteesMembershipInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Memberships', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjCommitteesMembership_)
    async UpdatemjCommitteesMembership(
        @Arg('input', () => UpdatemjCommitteesMembershipInput) input: UpdatemjCommitteesMembershipInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Memberships', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjCommitteesMembership_)
    async DeletemjCommitteesMembership(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Memberships', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Minutes
//****************************************************************************
@ObjectType({ description: `Extension entity for Minutes artifacts with approval tracking` })
export class mjCommitteesMinute_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    ArtifactID?: string;
        
    @Field({description: `Current approval status: Draft, PendingApproval, Approved, Rejected`}) 
    @MaxLength(50)
    ApprovalStatus: string;
        
    @Field({nullable: true, description: `Timestamp when the minutes were approved`}) 
    ApprovedAt?: Date;
        
    @Field({nullable: true, description: `Reference to the meeting at which these minutes were approved (typically the next meeting)`}) 
    @MaxLength(36)
    ApprovedByMeetingID?: string;
        
    @Field({nullable: true, description: `Additional notes about the minutes`}) 
    Notes?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    FileID?: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    MeetingID?: string;
        
    @Field({nullable: true}) 
    Content?: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    ApprovedByMeeting?: string;
        
    @Field({nullable: true}) 
    @MaxLength(500)
    File?: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    Meeting?: string;
        
}

//****************************************************************************
// INPUT TYPE for Committees: Minutes
//****************************************************************************
@InputType()
export class CreatemjCommitteesMinuteInput {
    @Field({ nullable: true })
    ID?: string;

    @Field({ nullable: true })
    ArtifactID: string | null;

    @Field({ nullable: true })
    ApprovalStatus?: string;

    @Field({ nullable: true })
    ApprovedAt: Date | null;

    @Field({ nullable: true })
    ApprovedByMeetingID: string | null;

    @Field({ nullable: true })
    Notes: string | null;

    @Field({ nullable: true })
    FileID: string | null;

    @Field({ nullable: true })
    MeetingID: string | null;

    @Field({ nullable: true })
    Content: string | null;

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Minutes
//****************************************************************************
@InputType()
export class UpdatemjCommitteesMinuteInput {
    @Field()
    ID: string;

    @Field({ nullable: true })
    ArtifactID?: string | null;

    @Field({ nullable: true })
    ApprovalStatus?: string;

    @Field({ nullable: true })
    ApprovedAt?: Date | null;

    @Field({ nullable: true })
    ApprovedByMeetingID?: string | null;

    @Field({ nullable: true })
    Notes?: string | null;

    @Field({ nullable: true })
    FileID?: string | null;

    @Field({ nullable: true })
    MeetingID?: string | null;

    @Field({ nullable: true })
    Content?: string | null;

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Minutes
//****************************************************************************
@ObjectType()
export class RunmjCommitteesMinuteViewResult {
    @Field(() => [mjCommitteesMinute_])
    Results: mjCommitteesMinute_[];

    @Field(() => String, {nullable: true})
    UserViewRunID?: string;

    @Field(() => Int, {nullable: true})
    RowCount: number;

    @Field(() => Int, {nullable: true})
    TotalRowCount: number;

    @Field(() => Int, {nullable: true})
    ExecutionTime: number;

    @Field({nullable: true})
    ErrorMessage?: string;

    @Field(() => Boolean, {nullable: false})
    Success: boolean;
}

@Resolver(mjCommitteesMinute_)
export class mjCommitteesMinuteResolver extends ResolverBase {
    @Query(() => RunmjCommitteesMinuteViewResult)
    async RunmjCommitteesMinuteViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesMinuteViewResult)
    async RunmjCommitteesMinuteViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesMinuteViewResult)
    async RunmjCommitteesMinuteDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Minutes';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjCommitteesMinute_, { nullable: true })
    async mjCommitteesMinute(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjCommitteesMinute_ | null> {
        this.CheckUserReadPermissions('Committees: Minutes', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMinutes')} WHERE ${provider.QuoteIdentifier('ID')}='${ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Minutes', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Minutes', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @Mutation(() => mjCommitteesMinute_)
    async CreatemjCommitteesMinute(
        @Arg('input', () => CreatemjCommitteesMinuteInput) input: CreatemjCommitteesMinuteInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Minutes', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjCommitteesMinute_)
    async UpdatemjCommitteesMinute(
        @Arg('input', () => UpdatemjCommitteesMinuteInput) input: UpdatemjCommitteesMinuteInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Minutes', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjCommitteesMinute_)
    async DeletemjCommitteesMinute(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Minutes', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Motions
//****************************************************************************
@ObjectType({ description: `Formal motions put to vote during committee meetings` })
export class mjCommitteesMotion_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field() 
    @MaxLength(36)
    MeetingID: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    AgendaItemID?: string;
        
    @Field(() => Int, {description: `Display order when multiple motions exist for the same agenda item`}) 
    Sequence: number;
        
    @Field({description: `Title of the motion`}) 
    @MaxLength(255)
    Title: string;
        
    @Field({nullable: true, description: `Full text or description of the motion`}) 
    Description?: string;
        
    @Field({nullable: true, description: `The committee member who made the motion`}) 
    @MaxLength(36)
    MovedByMembershipID?: string;
        
    @Field({nullable: true, description: `The committee member who seconded the motion`}) 
    @MaxLength(36)
    SecondedByMembershipID?: string;
        
    @Field({description: `Outcome of the vote: Pending, Passed, Failed, Tabled, Withdrawn`}) 
    @MaxLength(50)
    Result: string;
        
    @Field({nullable: true, description: `Human-readable vote tally, e.g. 7-2-1 or Passed unanimously`}) 
    @MaxLength(255)
    ResultSummary?: string;
        
    @Field(() => Int, {nullable: true, description: `Number of Yes votes`}) 
    YesCount?: number;
        
    @Field(() => Int, {nullable: true, description: `Number of No votes`}) 
    NoCount?: number;
        
    @Field(() => Int, {nullable: true, description: `Number of Abstain votes`}) 
    AbstainCount?: number;
        
    @Field({nullable: true, description: `Additional notes about the motion or vote`}) 
    Notes?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field() 
    @MaxLength(255)
    Meeting: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    AgendaItem?: string;
        
    @Field({nullable: true}) 
    @MaxLength(50)
    MovedByMembership?: string;
        
    @Field({nullable: true}) 
    @MaxLength(50)
    SecondedByMembership?: string;
        
    @Field(() => [mjCommitteesVote_])
    mjCommitteesVotes_MotionIDArray: mjCommitteesVote_[]; // Link to mjCommitteesVotes
    
}

//****************************************************************************
// INPUT TYPE for Committees: Motions
//****************************************************************************
@InputType()
export class CreatemjCommitteesMotionInput {
    @Field({ nullable: true })
    ID?: string;

    @Field({ nullable: true })
    MeetingID?: string;

    @Field({ nullable: true })
    AgendaItemID: string | null;

    @Field(() => Int, { nullable: true })
    Sequence?: number;

    @Field({ nullable: true })
    Title?: string;

    @Field({ nullable: true })
    Description: string | null;

    @Field({ nullable: true })
    MovedByMembershipID: string | null;

    @Field({ nullable: true })
    SecondedByMembershipID: string | null;

    @Field({ nullable: true })
    Result?: string;

    @Field({ nullable: true })
    ResultSummary: string | null;

    @Field(() => Int, { nullable: true })
    YesCount: number | null;

    @Field(() => Int, { nullable: true })
    NoCount: number | null;

    @Field(() => Int, { nullable: true })
    AbstainCount: number | null;

    @Field({ nullable: true })
    Notes: string | null;

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Motions
//****************************************************************************
@InputType()
export class UpdatemjCommitteesMotionInput {
    @Field()
    ID: string;

    @Field({ nullable: true })
    MeetingID?: string;

    @Field({ nullable: true })
    AgendaItemID?: string | null;

    @Field(() => Int, { nullable: true })
    Sequence?: number;

    @Field({ nullable: true })
    Title?: string;

    @Field({ nullable: true })
    Description?: string | null;

    @Field({ nullable: true })
    MovedByMembershipID?: string | null;

    @Field({ nullable: true })
    SecondedByMembershipID?: string | null;

    @Field({ nullable: true })
    Result?: string;

    @Field({ nullable: true })
    ResultSummary?: string | null;

    @Field(() => Int, { nullable: true })
    YesCount?: number | null;

    @Field(() => Int, { nullable: true })
    NoCount?: number | null;

    @Field(() => Int, { nullable: true })
    AbstainCount?: number | null;

    @Field({ nullable: true })
    Notes?: string | null;

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Motions
//****************************************************************************
@ObjectType()
export class RunmjCommitteesMotionViewResult {
    @Field(() => [mjCommitteesMotion_])
    Results: mjCommitteesMotion_[];

    @Field(() => String, {nullable: true})
    UserViewRunID?: string;

    @Field(() => Int, {nullable: true})
    RowCount: number;

    @Field(() => Int, {nullable: true})
    TotalRowCount: number;

    @Field(() => Int, {nullable: true})
    ExecutionTime: number;

    @Field({nullable: true})
    ErrorMessage?: string;

    @Field(() => Boolean, {nullable: false})
    Success: boolean;
}

@Resolver(mjCommitteesMotion_)
export class mjCommitteesMotionResolver extends ResolverBase {
    @Query(() => RunmjCommitteesMotionViewResult)
    async RunmjCommitteesMotionViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesMotionViewResult)
    async RunmjCommitteesMotionViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesMotionViewResult)
    async RunmjCommitteesMotionDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Motions';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjCommitteesMotion_, { nullable: true })
    async mjCommitteesMotion(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjCommitteesMotion_ | null> {
        this.CheckUserReadPermissions('Committees: Motions', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMotions')} WHERE ${provider.QuoteIdentifier('ID')}='${ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Motions', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Motions', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjCommitteesVote_])
    async mjCommitteesVotes_MotionIDArray(@Root() mjcommitteesmotion_: mjCommitteesMotion_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Votes', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwVotes')} WHERE ${provider.QuoteIdentifier('MotionID')}='${mjcommitteesmotion_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Votes', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Votes', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjCommitteesMotion_)
    async CreatemjCommitteesMotion(
        @Arg('input', () => CreatemjCommitteesMotionInput) input: CreatemjCommitteesMotionInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Motions', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjCommitteesMotion_)
    async UpdatemjCommitteesMotion(
        @Arg('input', () => UpdatemjCommitteesMotionInput) input: UpdatemjCommitteesMotionInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Motions', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjCommitteesMotion_)
    async DeletemjCommitteesMotion(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Motions', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Roles
//****************************************************************************
@ObjectType({ description: `Roles that members can hold on committees` })
export class mjCommitteesRole_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field({description: `Display name for the role`}) 
    @MaxLength(100)
    Name: string;
        
    @Field({nullable: true, description: `Detailed description of role responsibilities`}) 
    Description?: string;
        
    @Field(() => Boolean, {description: `Whether this is an officer role like Chair or Secretary`}) 
    IsOfficer: boolean;
        
    @Field(() => Boolean, {description: `Whether members in this role can vote`}) 
    IsVotingRole: boolean;
        
    @Field({nullable: true, description: `JSON object defining default permissions for this role`}) 
    DefaultPermissionsJSON?: string;
        
    @Field(() => Int, {description: `Display order for sorting roles`}) 
    Sequence: number;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field(() => [mjCommitteesMembership_])
    mjCommitteesMemberships_RoleIDArray: mjCommitteesMembership_[]; // Link to mjCommitteesMemberships
    
}

//****************************************************************************
// INPUT TYPE for Committees: Roles
//****************************************************************************
@InputType()
export class CreatemjCommitteesRoleInput {
    @Field({ nullable: true })
    ID?: string;

    @Field({ nullable: true })
    Name?: string;

    @Field({ nullable: true })
    Description: string | null;

    @Field(() => Boolean, { nullable: true })
    IsOfficer?: boolean;

    @Field(() => Boolean, { nullable: true })
    IsVotingRole?: boolean;

    @Field({ nullable: true })
    DefaultPermissionsJSON: string | null;

    @Field(() => Int, { nullable: true })
    Sequence?: number;

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Roles
//****************************************************************************
@InputType()
export class UpdatemjCommitteesRoleInput {
    @Field()
    ID: string;

    @Field({ nullable: true })
    Name?: string;

    @Field({ nullable: true })
    Description?: string | null;

    @Field(() => Boolean, { nullable: true })
    IsOfficer?: boolean;

    @Field(() => Boolean, { nullable: true })
    IsVotingRole?: boolean;

    @Field({ nullable: true })
    DefaultPermissionsJSON?: string | null;

    @Field(() => Int, { nullable: true })
    Sequence?: number;

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Roles
//****************************************************************************
@ObjectType()
export class RunmjCommitteesRoleViewResult {
    @Field(() => [mjCommitteesRole_])
    Results: mjCommitteesRole_[];

    @Field(() => String, {nullable: true})
    UserViewRunID?: string;

    @Field(() => Int, {nullable: true})
    RowCount: number;

    @Field(() => Int, {nullable: true})
    TotalRowCount: number;

    @Field(() => Int, {nullable: true})
    ExecutionTime: number;

    @Field({nullable: true})
    ErrorMessage?: string;

    @Field(() => Boolean, {nullable: false})
    Success: boolean;
}

@Resolver(mjCommitteesRole_)
export class mjCommitteesRoleResolver extends ResolverBase {
    @Query(() => RunmjCommitteesRoleViewResult)
    async RunmjCommitteesRoleViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesRoleViewResult)
    async RunmjCommitteesRoleViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesRoleViewResult)
    async RunmjCommitteesRoleDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Roles';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjCommitteesRole_, { nullable: true })
    async mjCommitteesRole(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjCommitteesRole_ | null> {
        this.CheckUserReadPermissions('Committees: Roles', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwRoles')} WHERE ${provider.QuoteIdentifier('ID')}='${ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Roles', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Roles', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjCommitteesMembership_])
    async mjCommitteesMemberships_RoleIDArray(@Root() mjcommitteesrole_: mjCommitteesRole_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Memberships', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMemberships')} WHERE ${provider.QuoteIdentifier('RoleID')}='${mjcommitteesrole_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Memberships', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Memberships', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjCommitteesRole_)
    async CreatemjCommitteesRole(
        @Arg('input', () => CreatemjCommitteesRoleInput) input: CreatemjCommitteesRoleInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Roles', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjCommitteesRole_)
    async UpdatemjCommitteesRole(
        @Arg('input', () => UpdatemjCommitteesRoleInput) input: UpdatemjCommitteesRoleInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Roles', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjCommitteesRole_)
    async DeletemjCommitteesRole(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Roles', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Terms
//****************************************************************************
@ObjectType({ description: `Time periods for committee membership cycles` })
export class mjCommitteesTerm_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field() 
    @MaxLength(36)
    CommitteeID: string;
        
    @Field({description: `Display name for the term, e.g. 2025-2026`}) 
    @MaxLength(100)
    Name: string;
        
    @Field({description: `Start date of the term`}) 
    StartDate: Date;
        
    @Field({nullable: true, description: `End date of the term`}) 
    EndDate?: Date;
        
    @Field({description: `Current status: Active, Upcoming, or Completed`}) 
    @MaxLength(50)
    Status: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field() 
    @MaxLength(255)
    Committee: string;
        
    @Field(() => [mjCommitteesMembership_])
    mjCommitteesMemberships_TermIDArray: mjCommitteesMembership_[]; // Link to mjCommitteesMemberships
    
}

//****************************************************************************
// INPUT TYPE for Committees: Terms
//****************************************************************************
@InputType()
export class CreatemjCommitteesTermInput {
    @Field({ nullable: true })
    ID?: string;

    @Field({ nullable: true })
    CommitteeID?: string;

    @Field({ nullable: true })
    Name?: string;

    @Field({ nullable: true })
    StartDate?: Date;

    @Field({ nullable: true })
    EndDate: Date | null;

    @Field({ nullable: true })
    Status?: string;

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Terms
//****************************************************************************
@InputType()
export class UpdatemjCommitteesTermInput {
    @Field()
    ID: string;

    @Field({ nullable: true })
    CommitteeID?: string;

    @Field({ nullable: true })
    Name?: string;

    @Field({ nullable: true })
    StartDate?: Date;

    @Field({ nullable: true })
    EndDate?: Date | null;

    @Field({ nullable: true })
    Status?: string;

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Terms
//****************************************************************************
@ObjectType()
export class RunmjCommitteesTermViewResult {
    @Field(() => [mjCommitteesTerm_])
    Results: mjCommitteesTerm_[];

    @Field(() => String, {nullable: true})
    UserViewRunID?: string;

    @Field(() => Int, {nullable: true})
    RowCount: number;

    @Field(() => Int, {nullable: true})
    TotalRowCount: number;

    @Field(() => Int, {nullable: true})
    ExecutionTime: number;

    @Field({nullable: true})
    ErrorMessage?: string;

    @Field(() => Boolean, {nullable: false})
    Success: boolean;
}

@Resolver(mjCommitteesTerm_)
export class mjCommitteesTermResolver extends ResolverBase {
    @Query(() => RunmjCommitteesTermViewResult)
    async RunmjCommitteesTermViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesTermViewResult)
    async RunmjCommitteesTermViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesTermViewResult)
    async RunmjCommitteesTermDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Terms';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjCommitteesTerm_, { nullable: true })
    async mjCommitteesTerm(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjCommitteesTerm_ | null> {
        this.CheckUserReadPermissions('Committees: Terms', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwTerms')} WHERE ${provider.QuoteIdentifier('ID')}='${ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Terms', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Terms', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjCommitteesMembership_])
    async mjCommitteesMemberships_TermIDArray(@Root() mjcommitteesterm_: mjCommitteesTerm_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Memberships', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMemberships')} WHERE ${provider.QuoteIdentifier('TermID')}='${mjcommitteesterm_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Memberships', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Memberships', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjCommitteesTerm_)
    async CreatemjCommitteesTerm(
        @Arg('input', () => CreatemjCommitteesTermInput) input: CreatemjCommitteesTermInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Terms', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjCommitteesTerm_)
    async UpdatemjCommitteesTerm(
        @Arg('input', () => UpdatemjCommitteesTermInput) input: UpdatemjCommitteesTermInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Terms', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjCommitteesTerm_)
    async DeletemjCommitteesTerm(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Terms', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Types
//****************************************************************************
@ObjectType({ description: `Categories of committees such as Board, Standing, Ad Hoc, Workgroup` })
export class mjCommitteesType_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field({description: `Display name for the committee type`}) 
    @MaxLength(100)
    Name: string;
        
    @Field({nullable: true, description: `Detailed description of this committee type`}) 
    Description?: string;
        
    @Field(() => Boolean, {description: `Whether this type is for standards development committees`}) 
    IsStandards: boolean;
        
    @Field(() => Int, {nullable: true, description: `Default term length in months for committees of this type`}) 
    DefaultTermMonths?: number;
        
    @Field({nullable: true, description: `Font Awesome icon class for UI display`}) 
    @MaxLength(100)
    IconClass?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field(() => [mjCommitteesCommittee_])
    mjCommitteesCommittees_TypeIDArray: mjCommitteesCommittee_[]; // Link to mjCommitteesCommittees
    
}

//****************************************************************************
// INPUT TYPE for Committees: Types
//****************************************************************************
@InputType()
export class CreatemjCommitteesTypeInput {
    @Field({ nullable: true })
    ID?: string;

    @Field({ nullable: true })
    Name?: string;

    @Field({ nullable: true })
    Description: string | null;

    @Field(() => Boolean, { nullable: true })
    IsStandards?: boolean;

    @Field(() => Int, { nullable: true })
    DefaultTermMonths: number | null;

    @Field({ nullable: true })
    IconClass: string | null;

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Types
//****************************************************************************
@InputType()
export class UpdatemjCommitteesTypeInput {
    @Field()
    ID: string;

    @Field({ nullable: true })
    Name?: string;

    @Field({ nullable: true })
    Description?: string | null;

    @Field(() => Boolean, { nullable: true })
    IsStandards?: boolean;

    @Field(() => Int, { nullable: true })
    DefaultTermMonths?: number | null;

    @Field({ nullable: true })
    IconClass?: string | null;

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Types
//****************************************************************************
@ObjectType()
export class RunmjCommitteesTypeViewResult {
    @Field(() => [mjCommitteesType_])
    Results: mjCommitteesType_[];

    @Field(() => String, {nullable: true})
    UserViewRunID?: string;

    @Field(() => Int, {nullable: true})
    RowCount: number;

    @Field(() => Int, {nullable: true})
    TotalRowCount: number;

    @Field(() => Int, {nullable: true})
    ExecutionTime: number;

    @Field({nullable: true})
    ErrorMessage?: string;

    @Field(() => Boolean, {nullable: false})
    Success: boolean;
}

@Resolver(mjCommitteesType_)
export class mjCommitteesTypeResolver extends ResolverBase {
    @Query(() => RunmjCommitteesTypeViewResult)
    async RunmjCommitteesTypeViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesTypeViewResult)
    async RunmjCommitteesTypeViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesTypeViewResult)
    async RunmjCommitteesTypeDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Types';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjCommitteesType_, { nullable: true })
    async mjCommitteesType(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjCommitteesType_ | null> {
        this.CheckUserReadPermissions('Committees: Types', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwTypes')} WHERE ${provider.QuoteIdentifier('ID')}='${ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Types', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Types', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjCommitteesCommittee_])
    async mjCommitteesCommittees_TypeIDArray(@Root() mjcommitteestype_: mjCommitteesType_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Committees', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwCommittees')} WHERE ${provider.QuoteIdentifier('TypeID')}='${mjcommitteestype_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Committees', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Committees', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjCommitteesType_)
    async CreatemjCommitteesType(
        @Arg('input', () => CreatemjCommitteesTypeInput) input: CreatemjCommitteesTypeInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Types', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjCommitteesType_)
    async UpdatemjCommitteesType(
        @Arg('input', () => UpdatemjCommitteesTypeInput) input: UpdatemjCommitteesTypeInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Types', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjCommitteesType_)
    async DeletemjCommitteesType(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Types', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Video Providers
//****************************************************************************
@ObjectType()
export class mjCommitteesVideoProvider_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field() 
    @MaxLength(100)
    Name: string;
        
    @Field() 
    @MaxLength(100)
    ServerDriverKey: string;
        
    @Field(() => Boolean) 
    IsActive: boolean;
        
    @Field(() => Boolean) 
    IsDefault: boolean;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    CredentialID?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field({nullable: true}) 
    @MaxLength(200)
    Credential?: string;
        
    @Field(() => [mjCommitteesMeeting_])
    mjCommitteesMeetings_VideoProviderIDArray: mjCommitteesMeeting_[]; // Link to mjCommitteesMeetings
    
}

//****************************************************************************
// INPUT TYPE for Committees: Video Providers
//****************************************************************************
@InputType()
export class CreatemjCommitteesVideoProviderInput {
    @Field({ nullable: true })
    ID?: string;

    @Field({ nullable: true })
    Name?: string;

    @Field({ nullable: true })
    ServerDriverKey?: string;

    @Field(() => Boolean, { nullable: true })
    IsActive?: boolean;

    @Field(() => Boolean, { nullable: true })
    IsDefault?: boolean;

    @Field({ nullable: true })
    CredentialID: string | null;

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Video Providers
//****************************************************************************
@InputType()
export class UpdatemjCommitteesVideoProviderInput {
    @Field()
    ID: string;

    @Field({ nullable: true })
    Name?: string;

    @Field({ nullable: true })
    ServerDriverKey?: string;

    @Field(() => Boolean, { nullable: true })
    IsActive?: boolean;

    @Field(() => Boolean, { nullable: true })
    IsDefault?: boolean;

    @Field({ nullable: true })
    CredentialID?: string | null;

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Video Providers
//****************************************************************************
@ObjectType()
export class RunmjCommitteesVideoProviderViewResult {
    @Field(() => [mjCommitteesVideoProvider_])
    Results: mjCommitteesVideoProvider_[];

    @Field(() => String, {nullable: true})
    UserViewRunID?: string;

    @Field(() => Int, {nullable: true})
    RowCount: number;

    @Field(() => Int, {nullable: true})
    TotalRowCount: number;

    @Field(() => Int, {nullable: true})
    ExecutionTime: number;

    @Field({nullable: true})
    ErrorMessage?: string;

    @Field(() => Boolean, {nullable: false})
    Success: boolean;
}

@Resolver(mjCommitteesVideoProvider_)
export class mjCommitteesVideoProviderResolver extends ResolverBase {
    @Query(() => RunmjCommitteesVideoProviderViewResult)
    async RunmjCommitteesVideoProviderViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesVideoProviderViewResult)
    async RunmjCommitteesVideoProviderViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesVideoProviderViewResult)
    async RunmjCommitteesVideoProviderDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Video Providers';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjCommitteesVideoProvider_, { nullable: true })
    async mjCommitteesVideoProvider(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjCommitteesVideoProvider_ | null> {
        this.CheckUserReadPermissions('Committees: Video Providers', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwVideoProviders')} WHERE ${provider.QuoteIdentifier('ID')}='${ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Video Providers', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Video Providers', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjCommitteesMeeting_])
    async mjCommitteesMeetings_VideoProviderIDArray(@Root() mjcommitteesvideoprovider_: mjCommitteesVideoProvider_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Meetings', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMeetings')} WHERE ${provider.QuoteIdentifier('VideoProviderID')}='${mjcommitteesvideoprovider_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Meetings', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Meetings', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjCommitteesVideoProvider_)
    async CreatemjCommitteesVideoProvider(
        @Arg('input', () => CreatemjCommitteesVideoProviderInput) input: CreatemjCommitteesVideoProviderInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Video Providers', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjCommitteesVideoProvider_)
    async UpdatemjCommitteesVideoProvider(
        @Arg('input', () => UpdatemjCommitteesVideoProviderInput) input: UpdatemjCommitteesVideoProviderInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Video Providers', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjCommitteesVideoProvider_)
    async DeletemjCommitteesVideoProvider(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Video Providers', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Votes
//****************************************************************************
@ObjectType({ description: `Individual vote records for committee motions` })
export class mjCommitteesVote_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field() 
    @MaxLength(36)
    MotionID: string;
        
    @Field() 
    @MaxLength(36)
    MembershipID: string;
        
    @Field({description: `The vote cast: Yes, No, Abstain, or Absent`}) 
    @MaxLength(20)
    VoteValue: string;
        
    @Field({nullable: true, description: `Optional notes explaining the vote`}) 
    @MaxLength(500)
    Notes?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field() 
    @MaxLength(255)
    Motion: string;
        
    @Field() 
    @MaxLength(50)
    Membership: string;
        
}

//****************************************************************************
// INPUT TYPE for Committees: Votes
//****************************************************************************
@InputType()
export class CreatemjCommitteesVoteInput {
    @Field({ nullable: true })
    ID?: string;

    @Field({ nullable: true })
    MotionID?: string;

    @Field({ nullable: true })
    MembershipID?: string;

    @Field({ nullable: true })
    VoteValue?: string;

    @Field({ nullable: true })
    Notes: string | null;

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Votes
//****************************************************************************
@InputType()
export class UpdatemjCommitteesVoteInput {
    @Field()
    ID: string;

    @Field({ nullable: true })
    MotionID?: string;

    @Field({ nullable: true })
    MembershipID?: string;

    @Field({ nullable: true })
    VoteValue?: string;

    @Field({ nullable: true })
    Notes?: string | null;

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Votes
//****************************************************************************
@ObjectType()
export class RunmjCommitteesVoteViewResult {
    @Field(() => [mjCommitteesVote_])
    Results: mjCommitteesVote_[];

    @Field(() => String, {nullable: true})
    UserViewRunID?: string;

    @Field(() => Int, {nullable: true})
    RowCount: number;

    @Field(() => Int, {nullable: true})
    TotalRowCount: number;

    @Field(() => Int, {nullable: true})
    ExecutionTime: number;

    @Field({nullable: true})
    ErrorMessage?: string;

    @Field(() => Boolean, {nullable: false})
    Success: boolean;
}

@Resolver(mjCommitteesVote_)
export class mjCommitteesVoteResolver extends ResolverBase {
    @Query(() => RunmjCommitteesVoteViewResult)
    async RunmjCommitteesVoteViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesVoteViewResult)
    async RunmjCommitteesVoteViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjCommitteesVoteViewResult)
    async RunmjCommitteesVoteDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Votes';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjCommitteesVote_, { nullable: true })
    async mjCommitteesVote(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjCommitteesVote_ | null> {
        this.CheckUserReadPermissions('Committees: Votes', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwVotes')} WHERE ${provider.QuoteIdentifier('ID')}='${ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Votes', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Votes', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @Mutation(() => mjCommitteesVote_)
    async CreatemjCommitteesVote(
        @Arg('input', () => CreatemjCommitteesVoteInput) input: CreatemjCommitteesVoteInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Votes', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjCommitteesVote_)
    async UpdatemjCommitteesVote(
        @Arg('input', () => UpdatemjCommitteesVoteInput) input: UpdatemjCommitteesVoteInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Votes', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjCommitteesVote_)
    async DeletemjCommitteesVote(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Votes', key, options, provider, userPayload, pubSub);
    }
    
}