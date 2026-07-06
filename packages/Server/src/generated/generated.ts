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


import { mjBizAppsCommitteesActionItemEntity, mjBizAppsCommitteesAgendaItemEntity, mjBizAppsCommitteesArtifactTypeEntity, mjBizAppsCommitteesArtifactEntity, mjBizAppsCommitteesAttendanceEntity, mjBizAppsCommitteesCommentEntity, mjBizAppsCommitteesCommitteeEntity, mjBizAppsCommitteesMeetingEntity, mjBizAppsCommitteesMembershipEntity, mjBizAppsCommitteesMinuteEntity, mjBizAppsCommitteesMotionEntity, mjBizAppsCommitteesRoleEntity, mjBizAppsCommitteesTermEntity, mjBizAppsCommitteesTypeEntity, mjBizAppsCommitteesVideoProviderEntity, mjBizAppsCommitteesVoteEntity } from '@mj-biz-apps/committees-entities';
    

//****************************************************************************
// ENTITY CLASS for Committees: Action Items
//****************************************************************************
@ObjectType({ description: `Legacy action items assigned from committees or meetings (superseded by BizAppsTasks)` })
export class mjBizAppsCommitteesActionItem_ {
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
        
    @Field() 
    @MaxLength(255)
    Title: string;
        
    @Field({nullable: true}) 
    Description?: string;
        
    @Field() 
    @MaxLength(36)
    AssignedToPersonID: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    AssignedByPersonID?: string;
        
    @Field({nullable: true}) 
    DueDate?: Date;
        
    @Field() 
    @MaxLength(20)
    Priority: string;
        
    @Field() 
    @MaxLength(50)
    Status: string;
        
    @Field({nullable: true}) 
    CompletedAt?: Date;
        
    @Field({nullable: true}) 
    CompletionNotes?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field() 
    @MaxLength(255)
    Committee: string;
        
    @Field() 
    @MaxLength(201)
    AssignedToPerson: string;
        
    @Field({nullable: true}) 
    @MaxLength(201)
    AssignedByPerson?: string;
        
}

//****************************************************************************
// INPUT TYPE for Committees: Action Items
//****************************************************************************
@InputType()
export class CreatemjBizAppsCommitteesActionItemInput {
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
export class UpdatemjBizAppsCommitteesActionItemInput {
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
export class RunmjBizAppsCommitteesActionItemViewResult {
    @Field(() => [mjBizAppsCommitteesActionItem_])
    Results: mjBizAppsCommitteesActionItem_[];

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

@Resolver(mjBizAppsCommitteesActionItem_)
export class mjBizAppsCommitteesActionItemResolver extends ResolverBase {
    @Query(() => RunmjBizAppsCommitteesActionItemViewResult)
    async RunmjBizAppsCommitteesActionItemViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesActionItemViewResult)
    async RunmjBizAppsCommitteesActionItemViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesActionItemViewResult)
    async RunmjBizAppsCommitteesActionItemDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Action Items';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjBizAppsCommitteesActionItem_, { nullable: true })
    async mjBizAppsCommitteesActionItem(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjBizAppsCommitteesActionItem_ | null> {
        this.CheckUserReadPermissions('Committees: Action Items', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwActionItems')} WHERE ${provider.QuoteIdentifier('ID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Action Items', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Action Items', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @Mutation(() => mjBizAppsCommitteesActionItem_)
    async CreatemjBizAppsCommitteesActionItem(
        @Arg('input', () => CreatemjBizAppsCommitteesActionItemInput) input: CreatemjBizAppsCommitteesActionItemInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Action Items', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjBizAppsCommitteesActionItem_)
    async UpdatemjBizAppsCommitteesActionItem(
        @Arg('input', () => UpdatemjBizAppsCommitteesActionItemInput) input: UpdatemjBizAppsCommitteesActionItemInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Action Items', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjBizAppsCommitteesActionItem_)
    async DeletemjBizAppsCommitteesActionItem(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Action Items', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Agenda Items
//****************************************************************************
@ObjectType({ description: `Structured agenda items for meetings with hierarchy support` })
export class mjBizAppsCommitteesAgendaItem_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field() 
    @MaxLength(36)
    MeetingID: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    ParentAgendaItemID?: string;
        
    @Field(() => Int) 
    Sequence: number;
        
    @Field() 
    @MaxLength(255)
    Title: string;
        
    @Field({nullable: true}) 
    Description?: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    PresenterPersonID?: string;
        
    @Field(() => Int, {nullable: true}) 
    DurationMinutes?: number;
        
    @Field() 
    @MaxLength(50)
    ItemType: string;
        
    @Field({nullable: true}) 
    @MaxLength(1000)
    RelatedDocumentURL?: string;
        
    @Field() 
    @MaxLength(50)
    Status: string;
        
    @Field({nullable: true}) 
    Notes?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field({nullable: true}) 
    @MaxLength(201)
    PresenterPerson?: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    RootParentAgendaItemID?: string;
        
    @Field(() => [mjBizAppsCommitteesAgendaItem_])
    mjBizAppsCommitteesCommittees_AgendaItems_ParentAgendaItemIDArray: mjBizAppsCommitteesAgendaItem_[]; // Link to mjBizAppsCommitteesCommittees_AgendaItems
    
    @Field(() => [mjBizAppsCommitteesActionItem_])
    mjBizAppsCommitteesCommittees_ActionItems_AgendaItemIDArray: mjBizAppsCommitteesActionItem_[]; // Link to mjBizAppsCommitteesCommittees_ActionItems
    
    @Field(() => [mjBizAppsCommitteesComment_])
    mjBizAppsCommitteesCommittees_Comments_AgendaItemIDArray: mjBizAppsCommitteesComment_[]; // Link to mjBizAppsCommitteesCommittees_Comments
    
    @Field(() => [mjBizAppsCommitteesArtifact_])
    mjBizAppsCommitteesCommittees_Artifacts_AgendaItemIDArray: mjBizAppsCommitteesArtifact_[]; // Link to mjBizAppsCommitteesCommittees_Artifacts
    
    @Field(() => [mjBizAppsCommitteesMotion_])
    mjBizAppsCommitteesCommittees_Motions_AgendaItemIDArray: mjBizAppsCommitteesMotion_[]; // Link to mjBizAppsCommitteesCommittees_Motions
    
}

//****************************************************************************
// INPUT TYPE for Committees: Agenda Items
//****************************************************************************
@InputType()
export class CreatemjBizAppsCommitteesAgendaItemInput {
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
export class UpdatemjBizAppsCommitteesAgendaItemInput {
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
export class RunmjBizAppsCommitteesAgendaItemViewResult {
    @Field(() => [mjBizAppsCommitteesAgendaItem_])
    Results: mjBizAppsCommitteesAgendaItem_[];

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

@Resolver(mjBizAppsCommitteesAgendaItem_)
export class mjBizAppsCommitteesAgendaItemResolver extends ResolverBase {
    @Query(() => RunmjBizAppsCommitteesAgendaItemViewResult)
    async RunmjBizAppsCommitteesAgendaItemViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesAgendaItemViewResult)
    async RunmjBizAppsCommitteesAgendaItemViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesAgendaItemViewResult)
    async RunmjBizAppsCommitteesAgendaItemDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Agenda Items';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjBizAppsCommitteesAgendaItem_, { nullable: true })
    async mjBizAppsCommitteesAgendaItem(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjBizAppsCommitteesAgendaItem_ | null> {
        this.CheckUserReadPermissions('Committees: Agenda Items', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwAgendaItems')} WHERE ${provider.QuoteIdentifier('ID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Agenda Items', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Agenda Items', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjBizAppsCommitteesAgendaItem_])
    async mjBizAppsCommitteesCommittees_AgendaItems_ParentAgendaItemIDArray(@Root() mjbizappscommitteesagendaitem_: mjBizAppsCommitteesAgendaItem_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Agenda Items', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwAgendaItems')} WHERE ${provider.QuoteIdentifier('ParentAgendaItemID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Agenda Items', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesagendaitem_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Agenda Items', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjBizAppsCommitteesActionItem_])
    async mjBizAppsCommitteesCommittees_ActionItems_AgendaItemIDArray(@Root() mjbizappscommitteesagendaitem_: mjBizAppsCommitteesAgendaItem_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Action Items', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwActionItems')} WHERE ${provider.QuoteIdentifier('AgendaItemID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Action Items', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesagendaitem_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Action Items', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjBizAppsCommitteesComment_])
    async mjBizAppsCommitteesCommittees_Comments_AgendaItemIDArray(@Root() mjbizappscommitteesagendaitem_: mjBizAppsCommitteesAgendaItem_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Comments', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwComments')} WHERE ${provider.QuoteIdentifier('AgendaItemID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Comments', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesagendaitem_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Comments', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjBizAppsCommitteesArtifact_])
    async mjBizAppsCommitteesCommittees_Artifacts_AgendaItemIDArray(@Root() mjbizappscommitteesagendaitem_: mjBizAppsCommitteesAgendaItem_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Artifacts', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwArtifacts')} WHERE ${provider.QuoteIdentifier('AgendaItemID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Artifacts', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesagendaitem_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Artifacts', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjBizAppsCommitteesMotion_])
    async mjBizAppsCommitteesCommittees_Motions_AgendaItemIDArray(@Root() mjbizappscommitteesagendaitem_: mjBizAppsCommitteesAgendaItem_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Motions', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwMotions')} WHERE ${provider.QuoteIdentifier('AgendaItemID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Motions', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesagendaitem_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Motions', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjBizAppsCommitteesAgendaItem_)
    async CreatemjBizAppsCommitteesAgendaItem(
        @Arg('input', () => CreatemjBizAppsCommitteesAgendaItemInput) input: CreatemjBizAppsCommitteesAgendaItemInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Agenda Items', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjBizAppsCommitteesAgendaItem_)
    async UpdatemjBizAppsCommitteesAgendaItem(
        @Arg('input', () => UpdatemjBizAppsCommitteesAgendaItemInput) input: UpdatemjBizAppsCommitteesAgendaItemInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Agenda Items', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjBizAppsCommitteesAgendaItem_)
    async DeletemjBizAppsCommitteesAgendaItem(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Agenda Items', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Artifact Types
//****************************************************************************
@ObjectType({ description: `Categories of committee artifacts with optional extension entity for type-specific fields` })
export class mjBizAppsCommitteesArtifactType_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field() 
    @MaxLength(100)
    Name: string;
        
    @Field({nullable: true}) 
    Description?: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    ExtendedEntityID?: string;
        
    @Field({nullable: true}) 
    @MaxLength(100)
    IconClass?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    ExtendedEntity?: string;
        
    @Field(() => [mjBizAppsCommitteesArtifact_])
    mjBizAppsCommitteesCommittees_Artifacts_ArtifactTypeIDArray: mjBizAppsCommitteesArtifact_[]; // Link to mjBizAppsCommitteesCommittees_Artifacts
    
}

//****************************************************************************
// INPUT TYPE for Committees: Artifact Types
//****************************************************************************
@InputType()
export class CreatemjBizAppsCommitteesArtifactTypeInput {
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
export class UpdatemjBizAppsCommitteesArtifactTypeInput {
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
export class RunmjBizAppsCommitteesArtifactTypeViewResult {
    @Field(() => [mjBizAppsCommitteesArtifactType_])
    Results: mjBizAppsCommitteesArtifactType_[];

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

@Resolver(mjBizAppsCommitteesArtifactType_)
export class mjBizAppsCommitteesArtifactTypeResolver extends ResolverBase {
    @Query(() => RunmjBizAppsCommitteesArtifactTypeViewResult)
    async RunmjBizAppsCommitteesArtifactTypeViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesArtifactTypeViewResult)
    async RunmjBizAppsCommitteesArtifactTypeViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesArtifactTypeViewResult)
    async RunmjBizAppsCommitteesArtifactTypeDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Artifact Types';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjBizAppsCommitteesArtifactType_, { nullable: true })
    async mjBizAppsCommitteesArtifactType(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjBizAppsCommitteesArtifactType_ | null> {
        this.CheckUserReadPermissions('Committees: Artifact Types', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwArtifactTypes')} WHERE ${provider.QuoteIdentifier('ID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Artifact Types', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Artifact Types', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjBizAppsCommitteesArtifact_])
    async mjBizAppsCommitteesCommittees_Artifacts_ArtifactTypeIDArray(@Root() mjbizappscommitteesartifacttype_: mjBizAppsCommitteesArtifactType_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Artifacts', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwArtifacts')} WHERE ${provider.QuoteIdentifier('ArtifactTypeID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Artifacts', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesartifacttype_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Artifacts', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjBizAppsCommitteesArtifactType_)
    async CreatemjBizAppsCommitteesArtifactType(
        @Arg('input', () => CreatemjBizAppsCommitteesArtifactTypeInput) input: CreatemjBizAppsCommitteesArtifactTypeInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Artifact Types', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjBizAppsCommitteesArtifactType_)
    async UpdatemjBizAppsCommitteesArtifactType(
        @Arg('input', () => UpdatemjBizAppsCommitteesArtifactTypeInput) input: UpdatemjBizAppsCommitteesArtifactTypeInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Artifact Types', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjBizAppsCommitteesArtifactType_)
    async DeletemjBizAppsCommitteesArtifactType(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Artifact Types', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Artifacts
//****************************************************************************
@ObjectType({ description: `Links to external documents and files from various providers` })
export class mjBizAppsCommitteesArtifact_ {
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
        
    @Field({nullable: true}) 
    @MaxLength(36)
    TaskID?: string;
        
    @Field() 
    @MaxLength(255)
    Title: string;
        
    @Field({nullable: true}) 
    Description?: string;
        
    @Field() 
    @MaxLength(36)
    ArtifactTypeID: string;
        
    @Field() 
    @MaxLength(50)
    Provider: string;
        
    @Field({nullable: true}) 
    @MaxLength(500)
    ExternalID?: string;
        
    @Field() 
    @MaxLength(2000)
    URL: string;
        
    @Field({nullable: true}) 
    @MaxLength(100)
    MimeType?: string;
        
    @Field(() => Int, {nullable: true}) 
    FileSize?: number;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    UploadedByPersonID?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    Committee?: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    Task?: string;
        
    @Field() 
    @MaxLength(100)
    ArtifactType: string;
        
    @Field({nullable: true}) 
    @MaxLength(201)
    UploadedByPerson?: string;
        
    @Field(() => [mjBizAppsCommitteesComment_])
    mjBizAppsCommitteesCommittees_Comments_ArtifactIDArray: mjBizAppsCommitteesComment_[]; // Link to mjBizAppsCommitteesCommittees_Comments
    
    @Field(() => [mjBizAppsCommitteesMinute_])
    mjBizAppsCommitteesCommittees_Minutes_ArtifactIDArray: mjBizAppsCommitteesMinute_[]; // Link to mjBizAppsCommitteesCommittees_Minutes
    
}

//****************************************************************************
// INPUT TYPE for Committees: Artifacts
//****************************************************************************
@InputType()
export class CreatemjBizAppsCommitteesArtifactInput {
    @Field({ nullable: true })
    ID?: string;

    @Field({ nullable: true })
    CommitteeID: string | null;

    @Field({ nullable: true })
    MeetingID: string | null;

    @Field({ nullable: true })
    AgendaItemID: string | null;

    @Field({ nullable: true })
    TaskID: string | null;

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

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Artifacts
//****************************************************************************
@InputType()
export class UpdatemjBizAppsCommitteesArtifactInput {
    @Field()
    ID: string;

    @Field({ nullable: true })
    CommitteeID?: string | null;

    @Field({ nullable: true })
    MeetingID?: string | null;

    @Field({ nullable: true })
    AgendaItemID?: string | null;

    @Field({ nullable: true })
    TaskID?: string | null;

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

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Artifacts
//****************************************************************************
@ObjectType()
export class RunmjBizAppsCommitteesArtifactViewResult {
    @Field(() => [mjBizAppsCommitteesArtifact_])
    Results: mjBizAppsCommitteesArtifact_[];

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

@Resolver(mjBizAppsCommitteesArtifact_)
export class mjBizAppsCommitteesArtifactResolver extends ResolverBase {
    @Query(() => RunmjBizAppsCommitteesArtifactViewResult)
    async RunmjBizAppsCommitteesArtifactViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesArtifactViewResult)
    async RunmjBizAppsCommitteesArtifactViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesArtifactViewResult)
    async RunmjBizAppsCommitteesArtifactDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Artifacts';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjBizAppsCommitteesArtifact_, { nullable: true })
    async mjBizAppsCommitteesArtifact(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjBizAppsCommitteesArtifact_ | null> {
        this.CheckUserReadPermissions('Committees: Artifacts', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwArtifacts')} WHERE ${provider.QuoteIdentifier('ID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Artifacts', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Artifacts', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjBizAppsCommitteesComment_])
    async mjBizAppsCommitteesCommittees_Comments_ArtifactIDArray(@Root() mjbizappscommitteesartifact_: mjBizAppsCommitteesArtifact_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Comments', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwComments')} WHERE ${provider.QuoteIdentifier('ArtifactID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Comments', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesartifact_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Comments', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjBizAppsCommitteesMinute_])
    async mjBizAppsCommitteesCommittees_Minutes_ArtifactIDArray(@Root() mjbizappscommitteesartifact_: mjBizAppsCommitteesArtifact_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Minutes', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwMinutes')} WHERE ${provider.QuoteIdentifier('ArtifactID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Minutes', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesartifact_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Minutes', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjBizAppsCommitteesArtifact_)
    async CreatemjBizAppsCommitteesArtifact(
        @Arg('input', () => CreatemjBizAppsCommitteesArtifactInput) input: CreatemjBizAppsCommitteesArtifactInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Artifacts', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjBizAppsCommitteesArtifact_)
    async UpdatemjBizAppsCommitteesArtifact(
        @Arg('input', () => UpdatemjBizAppsCommitteesArtifactInput) input: UpdatemjBizAppsCommitteesArtifactInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Artifacts', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjBizAppsCommitteesArtifact_)
    async DeletemjBizAppsCommitteesArtifact(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Artifacts', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Attendances
//****************************************************************************
@ObjectType({ description: `Meeting attendance records for committee members` })
export class mjBizAppsCommitteesAttendance_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field() 
    @MaxLength(36)
    MeetingID: string;
        
    @Field() 
    @MaxLength(36)
    PersonID: string;
        
    @Field() 
    @MaxLength(50)
    AttendanceStatus: string;
        
    @Field({nullable: true}) 
    JoinedAt?: Date;
        
    @Field({nullable: true}) 
    LeftAt?: Date;
        
    @Field({nullable: true}) 
    @MaxLength(500)
    Notes?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field() 
    @MaxLength(201)
    Person: string;
        
}

//****************************************************************************
// INPUT TYPE for Committees: Attendances
//****************************************************************************
@InputType()
export class CreatemjBizAppsCommitteesAttendanceInput {
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
export class UpdatemjBizAppsCommitteesAttendanceInput {
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
export class RunmjBizAppsCommitteesAttendanceViewResult {
    @Field(() => [mjBizAppsCommitteesAttendance_])
    Results: mjBizAppsCommitteesAttendance_[];

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

@Resolver(mjBizAppsCommitteesAttendance_)
export class mjBizAppsCommitteesAttendanceResolver extends ResolverBase {
    @Query(() => RunmjBizAppsCommitteesAttendanceViewResult)
    async RunmjBizAppsCommitteesAttendanceViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesAttendanceViewResult)
    async RunmjBizAppsCommitteesAttendanceViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesAttendanceViewResult)
    async RunmjBizAppsCommitteesAttendanceDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Attendances';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjBizAppsCommitteesAttendance_, { nullable: true })
    async mjBizAppsCommitteesAttendance(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjBizAppsCommitteesAttendance_ | null> {
        this.CheckUserReadPermissions('Committees: Attendances', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwAttendances')} WHERE ${provider.QuoteIdentifier('ID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Attendances', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Attendances', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @Mutation(() => mjBizAppsCommitteesAttendance_)
    async CreatemjBizAppsCommitteesAttendance(
        @Arg('input', () => CreatemjBizAppsCommitteesAttendanceInput) input: CreatemjBizAppsCommitteesAttendanceInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Attendances', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjBizAppsCommitteesAttendance_)
    async UpdatemjBizAppsCommitteesAttendance(
        @Arg('input', () => UpdatemjBizAppsCommitteesAttendanceInput) input: UpdatemjBizAppsCommitteesAttendanceInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Attendances', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjBizAppsCommitteesAttendance_)
    async DeletemjBizAppsCommitteesAttendance(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Attendances', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Comments
//****************************************************************************
@ObjectType({ description: `Threaded discussion comments on committee meetings, agenda items, tasks, and documents` })
export class mjBizAppsCommitteesComment_ {
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
        
    @Field({nullable: true}) 
    @MaxLength(36)
    TaskID?: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    ArtifactID?: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    ParentCommentID?: string;
        
    @Field() 
    @MaxLength(36)
    PersonID: string;
        
    @Field() 
    CommentText: string;
        
    @Field({nullable: true}) 
    MentionedPersonIDs?: string;
        
    @Field(() => Boolean) 
    IsResolved: boolean;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field() 
    @MaxLength(255)
    Committee: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    Task?: string;
        
    @Field() 
    @MaxLength(201)
    Person: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    RootParentCommentID?: string;
        
    @Field(() => [mjBizAppsCommitteesComment_])
    mjBizAppsCommitteesCommittees_Comments_ParentCommentIDArray: mjBizAppsCommitteesComment_[]; // Link to mjBizAppsCommitteesCommittees_Comments
    
}

//****************************************************************************
// INPUT TYPE for Committees: Comments
//****************************************************************************
@InputType()
export class CreatemjBizAppsCommitteesCommentInput {
    @Field({ nullable: true })
    ID?: string;

    @Field({ nullable: true })
    CommitteeID?: string;

    @Field({ nullable: true })
    MeetingID: string | null;

    @Field({ nullable: true })
    AgendaItemID: string | null;

    @Field({ nullable: true })
    TaskID: string | null;

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

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Comments
//****************************************************************************
@InputType()
export class UpdatemjBizAppsCommitteesCommentInput {
    @Field()
    ID: string;

    @Field({ nullable: true })
    CommitteeID?: string;

    @Field({ nullable: true })
    MeetingID?: string | null;

    @Field({ nullable: true })
    AgendaItemID?: string | null;

    @Field({ nullable: true })
    TaskID?: string | null;

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

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Comments
//****************************************************************************
@ObjectType()
export class RunmjBizAppsCommitteesCommentViewResult {
    @Field(() => [mjBizAppsCommitteesComment_])
    Results: mjBizAppsCommitteesComment_[];

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

@Resolver(mjBizAppsCommitteesComment_)
export class mjBizAppsCommitteesCommentResolver extends ResolverBase {
    @Query(() => RunmjBizAppsCommitteesCommentViewResult)
    async RunmjBizAppsCommitteesCommentViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesCommentViewResult)
    async RunmjBizAppsCommitteesCommentViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesCommentViewResult)
    async RunmjBizAppsCommitteesCommentDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Comments';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjBizAppsCommitteesComment_, { nullable: true })
    async mjBizAppsCommitteesComment(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjBizAppsCommitteesComment_ | null> {
        this.CheckUserReadPermissions('Committees: Comments', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwComments')} WHERE ${provider.QuoteIdentifier('ID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Comments', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Comments', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjBizAppsCommitteesComment_])
    async mjBizAppsCommitteesCommittees_Comments_ParentCommentIDArray(@Root() mjbizappscommitteescomment_: mjBizAppsCommitteesComment_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Comments', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwComments')} WHERE ${provider.QuoteIdentifier('ParentCommentID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Comments', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteescomment_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Comments', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjBizAppsCommitteesComment_)
    async CreatemjBizAppsCommitteesComment(
        @Arg('input', () => CreatemjBizAppsCommitteesCommentInput) input: CreatemjBizAppsCommitteesCommentInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Comments', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjBizAppsCommitteesComment_)
    async UpdatemjBizAppsCommitteesComment(
        @Arg('input', () => UpdatemjBizAppsCommitteesCommentInput) input: UpdatemjBizAppsCommitteesCommentInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Comments', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjBizAppsCommitteesComment_)
    async DeletemjBizAppsCommitteesComment(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Comments', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Committees
//****************************************************************************
@ObjectType({ description: `Core committee records with hierarchy support` })
export class mjBizAppsCommitteesCommittee_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field() 
    @MaxLength(255)
    Name: string;
        
    @Field({nullable: true}) 
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
        
    @Field({nullable: true}) 
    @MaxLength(1000)
    CharterDocumentURL?: string;
        
    @Field({nullable: true}) 
    MissionStatement?: string;
        
    @Field() 
    @MaxLength(50)
    Status: string;
        
    @Field(() => Boolean) 
    IsPublic: boolean;
        
    @Field({nullable: true}) 
    FormationDate?: Date;
        
    @Field({nullable: true}) 
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
        
    @Field(() => [mjBizAppsCommitteesActionItem_])
    mjBizAppsCommitteesCommittees_ActionItems_CommitteeIDArray: mjBizAppsCommitteesActionItem_[]; // Link to mjBizAppsCommitteesCommittees_ActionItems
    
    @Field(() => [mjBizAppsCommitteesMeeting_])
    mjBizAppsCommitteesCommittees_Meetings_CommitteeIDArray: mjBizAppsCommitteesMeeting_[]; // Link to mjBizAppsCommitteesCommittees_Meetings
    
    @Field(() => [mjBizAppsCommitteesComment_])
    mjBizAppsCommitteesCommittees_Comments_CommitteeIDArray: mjBizAppsCommitteesComment_[]; // Link to mjBizAppsCommitteesCommittees_Comments
    
    @Field(() => [mjBizAppsCommitteesCommittee_])
    mjBizAppsCommitteesCommittees_Committees_ParentCommitteeIDArray: mjBizAppsCommitteesCommittee_[]; // Link to mjBizAppsCommitteesCommittees_Committees
    
    @Field(() => [mjBizAppsCommitteesArtifact_])
    mjBizAppsCommitteesCommittees_Artifacts_CommitteeIDArray: mjBizAppsCommitteesArtifact_[]; // Link to mjBizAppsCommitteesCommittees_Artifacts
    
    @Field(() => [mjBizAppsCommitteesTerm_])
    mjBizAppsCommitteesCommittees_Terms_CommitteeIDArray: mjBizAppsCommitteesTerm_[]; // Link to mjBizAppsCommitteesCommittees_Terms
    
}

//****************************************************************************
// INPUT TYPE for Committees: Committees
//****************************************************************************
@InputType()
export class CreatemjBizAppsCommitteesCommitteeInput {
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
export class UpdatemjBizAppsCommitteesCommitteeInput {
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
export class RunmjBizAppsCommitteesCommitteeViewResult {
    @Field(() => [mjBizAppsCommitteesCommittee_])
    Results: mjBizAppsCommitteesCommittee_[];

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

@Resolver(mjBizAppsCommitteesCommittee_)
export class mjBizAppsCommitteesCommitteeResolver extends ResolverBase {
    @Query(() => RunmjBizAppsCommitteesCommitteeViewResult)
    async RunmjBizAppsCommitteesCommitteeViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesCommitteeViewResult)
    async RunmjBizAppsCommitteesCommitteeViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesCommitteeViewResult)
    async RunmjBizAppsCommitteesCommitteeDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Committees';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjBizAppsCommitteesCommittee_, { nullable: true })
    async mjBizAppsCommitteesCommittee(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjBizAppsCommitteesCommittee_ | null> {
        this.CheckUserReadPermissions('Committees: Committees', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwCommittees')} WHERE ${provider.QuoteIdentifier('ID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Committees', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Committees', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjBizAppsCommitteesActionItem_])
    async mjBizAppsCommitteesCommittees_ActionItems_CommitteeIDArray(@Root() mjbizappscommitteescommittee_: mjBizAppsCommitteesCommittee_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Action Items', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwActionItems')} WHERE ${provider.QuoteIdentifier('CommitteeID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Action Items', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteescommittee_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Action Items', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjBizAppsCommitteesMeeting_])
    async mjBizAppsCommitteesCommittees_Meetings_CommitteeIDArray(@Root() mjbizappscommitteescommittee_: mjBizAppsCommitteesCommittee_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Meetings', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwMeetings')} WHERE ${provider.QuoteIdentifier('CommitteeID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Meetings', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteescommittee_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Meetings', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjBizAppsCommitteesComment_])
    async mjBizAppsCommitteesCommittees_Comments_CommitteeIDArray(@Root() mjbizappscommitteescommittee_: mjBizAppsCommitteesCommittee_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Comments', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwComments')} WHERE ${provider.QuoteIdentifier('CommitteeID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Comments', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteescommittee_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Comments', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjBizAppsCommitteesCommittee_])
    async mjBizAppsCommitteesCommittees_Committees_ParentCommitteeIDArray(@Root() mjbizappscommitteescommittee_: mjBizAppsCommitteesCommittee_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Committees', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwCommittees')} WHERE ${provider.QuoteIdentifier('ParentCommitteeID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Committees', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteescommittee_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Committees', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjBizAppsCommitteesArtifact_])
    async mjBizAppsCommitteesCommittees_Artifacts_CommitteeIDArray(@Root() mjbizappscommitteescommittee_: mjBizAppsCommitteesCommittee_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Artifacts', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwArtifacts')} WHERE ${provider.QuoteIdentifier('CommitteeID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Artifacts', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteescommittee_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Artifacts', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjBizAppsCommitteesTerm_])
    async mjBizAppsCommitteesCommittees_Terms_CommitteeIDArray(@Root() mjbizappscommitteescommittee_: mjBizAppsCommitteesCommittee_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Terms', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwTerms')} WHERE ${provider.QuoteIdentifier('CommitteeID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Terms', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteescommittee_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Terms', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjBizAppsCommitteesCommittee_)
    async CreatemjBizAppsCommitteesCommittee(
        @Arg('input', () => CreatemjBizAppsCommitteesCommitteeInput) input: CreatemjBizAppsCommitteesCommitteeInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Committees', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjBizAppsCommitteesCommittee_)
    async UpdatemjBizAppsCommitteesCommittee(
        @Arg('input', () => UpdatemjBizAppsCommitteesCommitteeInput) input: UpdatemjBizAppsCommitteesCommitteeInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Committees', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjBizAppsCommitteesCommittee_)
    async DeletemjBizAppsCommitteesCommittee(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Committees', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Meetings
//****************************************************************************
@ObjectType({ description: `Committee meeting records with scheduling and video conferencing info` })
export class mjBizAppsCommitteesMeeting_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field() 
    @MaxLength(36)
    CommitteeID: string;
        
    @Field() 
    @MaxLength(255)
    Title: string;
        
    @Field({nullable: true}) 
    Description?: string;
        
    @Field() 
    StartDateTime: Date;
        
    @Field({nullable: true}) 
    EndDateTime?: Date;
        
    @Field() 
    @MaxLength(50)
    TimeZone: string;
        
    @Field() 
    @MaxLength(50)
    LocationType: string;
        
    @Field({nullable: true}) 
    @MaxLength(500)
    LocationText?: string;
        
    @Field({nullable: true}) 
    @MaxLength(50)
    VideoProvider?: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    VideoProviderID?: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    VideoMeetingID?: string;
        
    @Field({nullable: true}) 
    @MaxLength(1000)
    VideoJoinURL?: string;
        
    @Field({nullable: true}) 
    @MaxLength(1000)
    VideoRecordingURL?: string;
        
    @Field({nullable: true}) 
    @MaxLength(1000)
    TranscriptURL?: string;
        
    @Field() 
    @MaxLength(50)
    Status: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    CalendarEventID?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field() 
    @MaxLength(255)
    Committee: string;
        
    @Field({nullable: true}) 
    @MaxLength(100)
    VideoProvider_Virtual?: string;
        
    @Field(() => [mjBizAppsCommitteesAttendance_])
    mjBizAppsCommitteesCommittees_Attendances_MeetingIDArray: mjBizAppsCommitteesAttendance_[]; // Link to mjBizAppsCommitteesCommittees_Attendances
    
    @Field(() => [mjBizAppsCommitteesMinute_])
    mjBizAppsCommitteesCommittees_Minutes_MeetingIDArray: mjBizAppsCommitteesMinute_[]; // Link to mjBizAppsCommitteesCommittees_Minutes
    
    @Field(() => [mjBizAppsCommitteesMinute_])
    mjBizAppsCommitteesCommittees_Minutes_ApprovedByMeetingIDArray: mjBizAppsCommitteesMinute_[]; // Link to mjBizAppsCommitteesCommittees_Minutes
    
    @Field(() => [mjBizAppsCommitteesArtifact_])
    mjBizAppsCommitteesCommittees_Artifacts_MeetingIDArray: mjBizAppsCommitteesArtifact_[]; // Link to mjBizAppsCommitteesCommittees_Artifacts
    
    @Field(() => [mjBizAppsCommitteesMotion_])
    mjBizAppsCommitteesCommittees_Motions_MeetingIDArray: mjBizAppsCommitteesMotion_[]; // Link to mjBizAppsCommitteesCommittees_Motions
    
    @Field(() => [mjBizAppsCommitteesActionItem_])
    mjBizAppsCommitteesCommittees_ActionItems_MeetingIDArray: mjBizAppsCommitteesActionItem_[]; // Link to mjBizAppsCommitteesCommittees_ActionItems
    
    @Field(() => [mjBizAppsCommitteesComment_])
    mjBizAppsCommitteesCommittees_Comments_MeetingIDArray: mjBizAppsCommitteesComment_[]; // Link to mjBizAppsCommitteesCommittees_Comments
    
    @Field(() => [mjBizAppsCommitteesAgendaItem_])
    mjBizAppsCommitteesCommittees_AgendaItems_MeetingIDArray: mjBizAppsCommitteesAgendaItem_[]; // Link to mjBizAppsCommitteesCommittees_AgendaItems
    
}

//****************************************************************************
// INPUT TYPE for Committees: Meetings
//****************************************************************************
@InputType()
export class CreatemjBizAppsCommitteesMeetingInput {
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
    VideoProviderID: string | null;

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

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Meetings
//****************************************************************************
@InputType()
export class UpdatemjBizAppsCommitteesMeetingInput {
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
    VideoProviderID?: string | null;

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

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Meetings
//****************************************************************************
@ObjectType()
export class RunmjBizAppsCommitteesMeetingViewResult {
    @Field(() => [mjBizAppsCommitteesMeeting_])
    Results: mjBizAppsCommitteesMeeting_[];

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

@Resolver(mjBizAppsCommitteesMeeting_)
export class mjBizAppsCommitteesMeetingResolver extends ResolverBase {
    @Query(() => RunmjBizAppsCommitteesMeetingViewResult)
    async RunmjBizAppsCommitteesMeetingViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesMeetingViewResult)
    async RunmjBizAppsCommitteesMeetingViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesMeetingViewResult)
    async RunmjBizAppsCommitteesMeetingDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Meetings';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjBizAppsCommitteesMeeting_, { nullable: true })
    async mjBizAppsCommitteesMeeting(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjBizAppsCommitteesMeeting_ | null> {
        this.CheckUserReadPermissions('Committees: Meetings', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwMeetings')} WHERE ${provider.QuoteIdentifier('ID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Meetings', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Meetings', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjBizAppsCommitteesAttendance_])
    async mjBizAppsCommitteesCommittees_Attendances_MeetingIDArray(@Root() mjbizappscommitteesmeeting_: mjBizAppsCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Attendances', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwAttendances')} WHERE ${provider.QuoteIdentifier('MeetingID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Attendances', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesmeeting_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Attendances', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjBizAppsCommitteesMinute_])
    async mjBizAppsCommitteesCommittees_Minutes_MeetingIDArray(@Root() mjbizappscommitteesmeeting_: mjBizAppsCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Minutes', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwMinutes')} WHERE ${provider.QuoteIdentifier('MeetingID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Minutes', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesmeeting_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Minutes', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjBizAppsCommitteesMinute_])
    async mjBizAppsCommitteesCommittees_Minutes_ApprovedByMeetingIDArray(@Root() mjbizappscommitteesmeeting_: mjBizAppsCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Minutes', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwMinutes')} WHERE ${provider.QuoteIdentifier('ApprovedByMeetingID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Minutes', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesmeeting_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Minutes', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjBizAppsCommitteesArtifact_])
    async mjBizAppsCommitteesCommittees_Artifacts_MeetingIDArray(@Root() mjbizappscommitteesmeeting_: mjBizAppsCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Artifacts', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwArtifacts')} WHERE ${provider.QuoteIdentifier('MeetingID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Artifacts', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesmeeting_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Artifacts', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjBizAppsCommitteesMotion_])
    async mjBizAppsCommitteesCommittees_Motions_MeetingIDArray(@Root() mjbizappscommitteesmeeting_: mjBizAppsCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Motions', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwMotions')} WHERE ${provider.QuoteIdentifier('MeetingID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Motions', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesmeeting_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Motions', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjBizAppsCommitteesActionItem_])
    async mjBizAppsCommitteesCommittees_ActionItems_MeetingIDArray(@Root() mjbizappscommitteesmeeting_: mjBizAppsCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Action Items', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwActionItems')} WHERE ${provider.QuoteIdentifier('MeetingID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Action Items', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesmeeting_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Action Items', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjBizAppsCommitteesComment_])
    async mjBizAppsCommitteesCommittees_Comments_MeetingIDArray(@Root() mjbizappscommitteesmeeting_: mjBizAppsCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Comments', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwComments')} WHERE ${provider.QuoteIdentifier('MeetingID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Comments', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesmeeting_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Comments', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjBizAppsCommitteesAgendaItem_])
    async mjBizAppsCommitteesCommittees_AgendaItems_MeetingIDArray(@Root() mjbizappscommitteesmeeting_: mjBizAppsCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Agenda Items', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwAgendaItems')} WHERE ${provider.QuoteIdentifier('MeetingID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Agenda Items', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesmeeting_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Agenda Items', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjBizAppsCommitteesMeeting_)
    async CreatemjBizAppsCommitteesMeeting(
        @Arg('input', () => CreatemjBizAppsCommitteesMeetingInput) input: CreatemjBizAppsCommitteesMeetingInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Meetings', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjBizAppsCommitteesMeeting_)
    async UpdatemjBizAppsCommitteesMeeting(
        @Arg('input', () => UpdatemjBizAppsCommitteesMeetingInput) input: UpdatemjBizAppsCommitteesMeetingInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Meetings', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjBizAppsCommitteesMeeting_)
    async DeletemjBizAppsCommitteesMeeting(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Meetings', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Memberships
//****************************************************************************
@ObjectType({ description: `Person assignments to committees with roles and terms` })
export class mjBizAppsCommitteesMembership_ {
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
        
    @Field() 
    StartDate: Date;
        
    @Field({nullable: true}) 
    EndDate?: Date;
        
    @Field() 
    @MaxLength(50)
    Status: string;
        
    @Field({nullable: true}) 
    @MaxLength(100)
    EndReason?: string;
        
    @Field({nullable: true}) 
    Notes?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field() 
    @MaxLength(201)
    Person: string;
        
    @Field() 
    @MaxLength(100)
    Role: string;
        
    @Field() 
    @MaxLength(100)
    Term: string;
        
    @Field(() => [mjBizAppsCommitteesMotion_])
    mjBizAppsCommitteesCommittees_Motions_SecondedByMembershipIDArray: mjBizAppsCommitteesMotion_[]; // Link to mjBizAppsCommitteesCommittees_Motions
    
    @Field(() => [mjBizAppsCommitteesMotion_])
    mjBizAppsCommitteesCommittees_Motions_MovedByMembershipIDArray: mjBizAppsCommitteesMotion_[]; // Link to mjBizAppsCommitteesCommittees_Motions
    
    @Field(() => [mjBizAppsCommitteesVote_])
    mjBizAppsCommitteesCommittees_Votes_MembershipIDArray: mjBizAppsCommitteesVote_[]; // Link to mjBizAppsCommitteesCommittees_Votes
    
}

//****************************************************************************
// INPUT TYPE for Committees: Memberships
//****************************************************************************
@InputType()
export class CreatemjBizAppsCommitteesMembershipInput {
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
export class UpdatemjBizAppsCommitteesMembershipInput {
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
export class RunmjBizAppsCommitteesMembershipViewResult {
    @Field(() => [mjBizAppsCommitteesMembership_])
    Results: mjBizAppsCommitteesMembership_[];

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

@Resolver(mjBizAppsCommitteesMembership_)
export class mjBizAppsCommitteesMembershipResolver extends ResolverBase {
    @Query(() => RunmjBizAppsCommitteesMembershipViewResult)
    async RunmjBizAppsCommitteesMembershipViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesMembershipViewResult)
    async RunmjBizAppsCommitteesMembershipViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesMembershipViewResult)
    async RunmjBizAppsCommitteesMembershipDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Memberships';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjBizAppsCommitteesMembership_, { nullable: true })
    async mjBizAppsCommitteesMembership(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjBizAppsCommitteesMembership_ | null> {
        this.CheckUserReadPermissions('Committees: Memberships', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwMemberships')} WHERE ${provider.QuoteIdentifier('ID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Memberships', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Memberships', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjBizAppsCommitteesMotion_])
    async mjBizAppsCommitteesCommittees_Motions_SecondedByMembershipIDArray(@Root() mjbizappscommitteesmembership_: mjBizAppsCommitteesMembership_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Motions', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwMotions')} WHERE ${provider.QuoteIdentifier('SecondedByMembershipID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Motions', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesmembership_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Motions', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjBizAppsCommitteesMotion_])
    async mjBizAppsCommitteesCommittees_Motions_MovedByMembershipIDArray(@Root() mjbizappscommitteesmembership_: mjBizAppsCommitteesMembership_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Motions', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwMotions')} WHERE ${provider.QuoteIdentifier('MovedByMembershipID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Motions', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesmembership_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Motions', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjBizAppsCommitteesVote_])
    async mjBizAppsCommitteesCommittees_Votes_MembershipIDArray(@Root() mjbizappscommitteesmembership_: mjBizAppsCommitteesMembership_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Votes', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwVotes')} WHERE ${provider.QuoteIdentifier('MembershipID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Votes', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesmembership_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Votes', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjBizAppsCommitteesMembership_)
    async CreatemjBizAppsCommitteesMembership(
        @Arg('input', () => CreatemjBizAppsCommitteesMembershipInput) input: CreatemjBizAppsCommitteesMembershipInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Memberships', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjBizAppsCommitteesMembership_)
    async UpdatemjBizAppsCommitteesMembership(
        @Arg('input', () => UpdatemjBizAppsCommitteesMembershipInput) input: UpdatemjBizAppsCommitteesMembershipInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Memberships', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjBizAppsCommitteesMembership_)
    async DeletemjBizAppsCommitteesMembership(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Memberships', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Minutes
//****************************************************************************
@ObjectType({ description: `Meeting minutes with approval tracking; stored as markdown Content or linked Artifact` })
export class mjBizAppsCommitteesMinute_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    ArtifactID?: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    MeetingID?: string;
        
    @Field({nullable: true}) 
    Content?: string;
        
    @Field() 
    @MaxLength(50)
    ApprovalStatus: string;
        
    @Field({nullable: true}) 
    ApprovedAt?: Date;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    ApprovedByMeetingID?: string;
        
    @Field({nullable: true}) 
    Notes?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
}

//****************************************************************************
// INPUT TYPE for Committees: Minutes
//****************************************************************************
@InputType()
export class CreatemjBizAppsCommitteesMinuteInput {
    @Field({ nullable: true })
    ID?: string;

    @Field({ nullable: true })
    ArtifactID: string | null;

    @Field({ nullable: true })
    MeetingID: string | null;

    @Field({ nullable: true })
    Content: string | null;

    @Field({ nullable: true })
    ApprovalStatus?: string;

    @Field({ nullable: true })
    ApprovedAt: Date | null;

    @Field({ nullable: true })
    ApprovedByMeetingID: string | null;

    @Field({ nullable: true })
    Notes: string | null;

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    

//****************************************************************************
// INPUT TYPE for Committees: Minutes
//****************************************************************************
@InputType()
export class UpdatemjBizAppsCommitteesMinuteInput {
    @Field()
    ID: string;

    @Field({ nullable: true })
    ArtifactID?: string | null;

    @Field({ nullable: true })
    MeetingID?: string | null;

    @Field({ nullable: true })
    Content?: string | null;

    @Field({ nullable: true })
    ApprovalStatus?: string;

    @Field({ nullable: true })
    ApprovedAt?: Date | null;

    @Field({ nullable: true })
    ApprovedByMeetingID?: string | null;

    @Field({ nullable: true })
    Notes?: string | null;

    @Field(() => [KeyValuePairInput], { nullable: true })
    OldValues___?: KeyValuePairInput[];

    @Field(() => RestoreContextInput, { nullable: true })
    RestoreContext___?: RestoreContextInput;
}
    
//****************************************************************************
// RESOLVER for Committees: Minutes
//****************************************************************************
@ObjectType()
export class RunmjBizAppsCommitteesMinuteViewResult {
    @Field(() => [mjBizAppsCommitteesMinute_])
    Results: mjBizAppsCommitteesMinute_[];

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

@Resolver(mjBizAppsCommitteesMinute_)
export class mjBizAppsCommitteesMinuteResolver extends ResolverBase {
    @Query(() => RunmjBizAppsCommitteesMinuteViewResult)
    async RunmjBizAppsCommitteesMinuteViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesMinuteViewResult)
    async RunmjBizAppsCommitteesMinuteViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesMinuteViewResult)
    async RunmjBizAppsCommitteesMinuteDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Minutes';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjBizAppsCommitteesMinute_, { nullable: true })
    async mjBizAppsCommitteesMinute(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjBizAppsCommitteesMinute_ | null> {
        this.CheckUserReadPermissions('Committees: Minutes', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwMinutes')} WHERE ${provider.QuoteIdentifier('ID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Minutes', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Minutes', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @Mutation(() => mjBizAppsCommitteesMinute_)
    async CreatemjBizAppsCommitteesMinute(
        @Arg('input', () => CreatemjBizAppsCommitteesMinuteInput) input: CreatemjBizAppsCommitteesMinuteInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Minutes', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjBizAppsCommitteesMinute_)
    async UpdatemjBizAppsCommitteesMinute(
        @Arg('input', () => UpdatemjBizAppsCommitteesMinuteInput) input: UpdatemjBizAppsCommitteesMinuteInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Minutes', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjBizAppsCommitteesMinute_)
    async DeletemjBizAppsCommitteesMinute(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Minutes', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Motions
//****************************************************************************
@ObjectType({ description: `Formal motions put to vote during committee meetings` })
export class mjBizAppsCommitteesMotion_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field() 
    @MaxLength(36)
    MeetingID: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    AgendaItemID?: string;
        
    @Field(() => Int) 
    Sequence: number;
        
    @Field() 
    @MaxLength(255)
    Title: string;
        
    @Field({nullable: true}) 
    Description?: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    MovedByMembershipID?: string;
        
    @Field({nullable: true}) 
    @MaxLength(36)
    SecondedByMembershipID?: string;
        
    @Field() 
    @MaxLength(50)
    Result: string;
        
    @Field({nullable: true}) 
    @MaxLength(255)
    ResultSummary?: string;
        
    @Field(() => Int, {nullable: true}) 
    YesCount?: number;
        
    @Field(() => Int, {nullable: true}) 
    NoCount?: number;
        
    @Field(() => Int, {nullable: true}) 
    AbstainCount?: number;
        
    @Field({nullable: true}) 
    Notes?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field(() => [mjBizAppsCommitteesVote_])
    mjBizAppsCommitteesCommittees_Votes_MotionIDArray: mjBizAppsCommitteesVote_[]; // Link to mjBizAppsCommitteesCommittees_Votes
    
}

//****************************************************************************
// INPUT TYPE for Committees: Motions
//****************************************************************************
@InputType()
export class CreatemjBizAppsCommitteesMotionInput {
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
export class UpdatemjBizAppsCommitteesMotionInput {
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
export class RunmjBizAppsCommitteesMotionViewResult {
    @Field(() => [mjBizAppsCommitteesMotion_])
    Results: mjBizAppsCommitteesMotion_[];

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

@Resolver(mjBizAppsCommitteesMotion_)
export class mjBizAppsCommitteesMotionResolver extends ResolverBase {
    @Query(() => RunmjBizAppsCommitteesMotionViewResult)
    async RunmjBizAppsCommitteesMotionViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesMotionViewResult)
    async RunmjBizAppsCommitteesMotionViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesMotionViewResult)
    async RunmjBizAppsCommitteesMotionDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Motions';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjBizAppsCommitteesMotion_, { nullable: true })
    async mjBizAppsCommitteesMotion(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjBizAppsCommitteesMotion_ | null> {
        this.CheckUserReadPermissions('Committees: Motions', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwMotions')} WHERE ${provider.QuoteIdentifier('ID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Motions', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Motions', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjBizAppsCommitteesVote_])
    async mjBizAppsCommitteesCommittees_Votes_MotionIDArray(@Root() mjbizappscommitteesmotion_: mjBizAppsCommitteesMotion_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Votes', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwVotes')} WHERE ${provider.QuoteIdentifier('MotionID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Votes', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesmotion_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Votes', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjBizAppsCommitteesMotion_)
    async CreatemjBizAppsCommitteesMotion(
        @Arg('input', () => CreatemjBizAppsCommitteesMotionInput) input: CreatemjBizAppsCommitteesMotionInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Motions', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjBizAppsCommitteesMotion_)
    async UpdatemjBizAppsCommitteesMotion(
        @Arg('input', () => UpdatemjBizAppsCommitteesMotionInput) input: UpdatemjBizAppsCommitteesMotionInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Motions', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjBizAppsCommitteesMotion_)
    async DeletemjBizAppsCommitteesMotion(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Motions', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Roles
//****************************************************************************
@ObjectType({ description: `Roles that members can hold on committees` })
export class mjBizAppsCommitteesRole_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field() 
    @MaxLength(100)
    Name: string;
        
    @Field({nullable: true}) 
    Description?: string;
        
    @Field(() => Boolean) 
    IsOfficer: boolean;
        
    @Field(() => Boolean) 
    IsVotingRole: boolean;
        
    @Field({nullable: true}) 
    DefaultPermissionsJSON?: string;
        
    @Field(() => Int) 
    Sequence: number;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field(() => [mjBizAppsCommitteesMembership_])
    mjBizAppsCommitteesCommittees_Memberships_RoleIDArray: mjBizAppsCommitteesMembership_[]; // Link to mjBizAppsCommitteesCommittees_Memberships
    
}

//****************************************************************************
// INPUT TYPE for Committees: Roles
//****************************************************************************
@InputType()
export class CreatemjBizAppsCommitteesRoleInput {
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
export class UpdatemjBizAppsCommitteesRoleInput {
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
export class RunmjBizAppsCommitteesRoleViewResult {
    @Field(() => [mjBizAppsCommitteesRole_])
    Results: mjBizAppsCommitteesRole_[];

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

@Resolver(mjBizAppsCommitteesRole_)
export class mjBizAppsCommitteesRoleResolver extends ResolverBase {
    @Query(() => RunmjBizAppsCommitteesRoleViewResult)
    async RunmjBizAppsCommitteesRoleViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesRoleViewResult)
    async RunmjBizAppsCommitteesRoleViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesRoleViewResult)
    async RunmjBizAppsCommitteesRoleDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Roles';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjBizAppsCommitteesRole_, { nullable: true })
    async mjBizAppsCommitteesRole(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjBizAppsCommitteesRole_ | null> {
        this.CheckUserReadPermissions('Committees: Roles', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwRoles')} WHERE ${provider.QuoteIdentifier('ID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Roles', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Roles', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjBizAppsCommitteesMembership_])
    async mjBizAppsCommitteesCommittees_Memberships_RoleIDArray(@Root() mjbizappscommitteesrole_: mjBizAppsCommitteesRole_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Memberships', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwMemberships')} WHERE ${provider.QuoteIdentifier('RoleID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Memberships', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesrole_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Memberships', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjBizAppsCommitteesRole_)
    async CreatemjBizAppsCommitteesRole(
        @Arg('input', () => CreatemjBizAppsCommitteesRoleInput) input: CreatemjBizAppsCommitteesRoleInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Roles', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjBizAppsCommitteesRole_)
    async UpdatemjBizAppsCommitteesRole(
        @Arg('input', () => UpdatemjBizAppsCommitteesRoleInput) input: UpdatemjBizAppsCommitteesRoleInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Roles', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjBizAppsCommitteesRole_)
    async DeletemjBizAppsCommitteesRole(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Roles', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Terms
//****************************************************************************
@ObjectType({ description: `Time periods for committee membership cycles` })
export class mjBizAppsCommitteesTerm_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field() 
    @MaxLength(36)
    CommitteeID: string;
        
    @Field() 
    @MaxLength(100)
    Name: string;
        
    @Field() 
    StartDate: Date;
        
    @Field({nullable: true}) 
    EndDate?: Date;
        
    @Field() 
    @MaxLength(50)
    Status: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field() 
    @MaxLength(255)
    Committee: string;
        
    @Field(() => [mjBizAppsCommitteesMembership_])
    mjBizAppsCommitteesCommittees_Memberships_TermIDArray: mjBizAppsCommitteesMembership_[]; // Link to mjBizAppsCommitteesCommittees_Memberships
    
}

//****************************************************************************
// INPUT TYPE for Committees: Terms
//****************************************************************************
@InputType()
export class CreatemjBizAppsCommitteesTermInput {
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
export class UpdatemjBizAppsCommitteesTermInput {
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
export class RunmjBizAppsCommitteesTermViewResult {
    @Field(() => [mjBizAppsCommitteesTerm_])
    Results: mjBizAppsCommitteesTerm_[];

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

@Resolver(mjBizAppsCommitteesTerm_)
export class mjBizAppsCommitteesTermResolver extends ResolverBase {
    @Query(() => RunmjBizAppsCommitteesTermViewResult)
    async RunmjBizAppsCommitteesTermViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesTermViewResult)
    async RunmjBizAppsCommitteesTermViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesTermViewResult)
    async RunmjBizAppsCommitteesTermDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Terms';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjBizAppsCommitteesTerm_, { nullable: true })
    async mjBizAppsCommitteesTerm(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjBizAppsCommitteesTerm_ | null> {
        this.CheckUserReadPermissions('Committees: Terms', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwTerms')} WHERE ${provider.QuoteIdentifier('ID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Terms', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Terms', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjBizAppsCommitteesMembership_])
    async mjBizAppsCommitteesCommittees_Memberships_TermIDArray(@Root() mjbizappscommitteesterm_: mjBizAppsCommitteesTerm_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Memberships', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwMemberships')} WHERE ${provider.QuoteIdentifier('TermID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Memberships', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesterm_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Memberships', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjBizAppsCommitteesTerm_)
    async CreatemjBizAppsCommitteesTerm(
        @Arg('input', () => CreatemjBizAppsCommitteesTermInput) input: CreatemjBizAppsCommitteesTermInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Terms', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjBizAppsCommitteesTerm_)
    async UpdatemjBizAppsCommitteesTerm(
        @Arg('input', () => UpdatemjBizAppsCommitteesTermInput) input: UpdatemjBizAppsCommitteesTermInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Terms', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjBizAppsCommitteesTerm_)
    async DeletemjBizAppsCommitteesTerm(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Terms', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Types
//****************************************************************************
@ObjectType({ description: `Categories of committees such as Board, Standing, Ad Hoc, Workgroup` })
export class mjBizAppsCommitteesType_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field() 
    @MaxLength(100)
    Name: string;
        
    @Field({nullable: true}) 
    Description?: string;
        
    @Field(() => Boolean) 
    IsStandards: boolean;
        
    @Field(() => Int, {nullable: true}) 
    DefaultTermMonths?: number;
        
    @Field({nullable: true}) 
    @MaxLength(100)
    IconClass?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
    @Field(() => [mjBizAppsCommitteesCommittee_])
    mjBizAppsCommitteesCommittees_Committees_TypeIDArray: mjBizAppsCommitteesCommittee_[]; // Link to mjBizAppsCommitteesCommittees_Committees
    
}

//****************************************************************************
// INPUT TYPE for Committees: Types
//****************************************************************************
@InputType()
export class CreatemjBizAppsCommitteesTypeInput {
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
export class UpdatemjBizAppsCommitteesTypeInput {
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
export class RunmjBizAppsCommitteesTypeViewResult {
    @Field(() => [mjBizAppsCommitteesType_])
    Results: mjBizAppsCommitteesType_[];

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

@Resolver(mjBizAppsCommitteesType_)
export class mjBizAppsCommitteesTypeResolver extends ResolverBase {
    @Query(() => RunmjBizAppsCommitteesTypeViewResult)
    async RunmjBizAppsCommitteesTypeViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesTypeViewResult)
    async RunmjBizAppsCommitteesTypeViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesTypeViewResult)
    async RunmjBizAppsCommitteesTypeDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Types';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjBizAppsCommitteesType_, { nullable: true })
    async mjBizAppsCommitteesType(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjBizAppsCommitteesType_ | null> {
        this.CheckUserReadPermissions('Committees: Types', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwTypes')} WHERE ${provider.QuoteIdentifier('ID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Types', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Types', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjBizAppsCommitteesCommittee_])
    async mjBizAppsCommitteesCommittees_Committees_TypeIDArray(@Root() mjbizappscommitteestype_: mjBizAppsCommitteesType_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Committees', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwCommittees')} WHERE ${provider.QuoteIdentifier('TypeID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Committees', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteestype_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Committees', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjBizAppsCommitteesType_)
    async CreatemjBizAppsCommitteesType(
        @Arg('input', () => CreatemjBizAppsCommitteesTypeInput) input: CreatemjBizAppsCommitteesTypeInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Types', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjBizAppsCommitteesType_)
    async UpdatemjBizAppsCommitteesType(
        @Arg('input', () => UpdatemjBizAppsCommitteesTypeInput) input: UpdatemjBizAppsCommitteesTypeInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Types', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjBizAppsCommitteesType_)
    async DeletemjBizAppsCommitteesType(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Types', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Video Providers
//****************************************************************************
@ObjectType({ description: `Configured video conferencing providers for auto-creating meeting URLs` })
export class mjBizAppsCommitteesVideoProvider_ {
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
        
    @Field(() => [mjBizAppsCommitteesMeeting_])
    mjBizAppsCommitteesCommittees_Meetings_VideoProviderIDArray: mjBizAppsCommitteesMeeting_[]; // Link to mjBizAppsCommitteesCommittees_Meetings
    
}

//****************************************************************************
// INPUT TYPE for Committees: Video Providers
//****************************************************************************
@InputType()
export class CreatemjBizAppsCommitteesVideoProviderInput {
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
export class UpdatemjBizAppsCommitteesVideoProviderInput {
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
export class RunmjBizAppsCommitteesVideoProviderViewResult {
    @Field(() => [mjBizAppsCommitteesVideoProvider_])
    Results: mjBizAppsCommitteesVideoProvider_[];

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

@Resolver(mjBizAppsCommitteesVideoProvider_)
export class mjBizAppsCommitteesVideoProviderResolver extends ResolverBase {
    @Query(() => RunmjBizAppsCommitteesVideoProviderViewResult)
    async RunmjBizAppsCommitteesVideoProviderViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesVideoProviderViewResult)
    async RunmjBizAppsCommitteesVideoProviderViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesVideoProviderViewResult)
    async RunmjBizAppsCommitteesVideoProviderDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Video Providers';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjBizAppsCommitteesVideoProvider_, { nullable: true })
    async mjBizAppsCommitteesVideoProvider(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjBizAppsCommitteesVideoProvider_ | null> {
        this.CheckUserReadPermissions('Committees: Video Providers', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwVideoProviders')} WHERE ${provider.QuoteIdentifier('ID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Video Providers', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Video Providers', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @FieldResolver(() => [mjBizAppsCommitteesMeeting_])
    async mjBizAppsCommitteesCommittees_Meetings_VideoProviderIDArray(@Root() mjbizappscommitteesvideoprovider_: mjBizAppsCommitteesVideoProvider_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Meetings', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwMeetings')} WHERE ${provider.QuoteIdentifier('VideoProviderID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Meetings', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [mjbizappscommitteesvideoprovider_.ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Meetings', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @Mutation(() => mjBizAppsCommitteesVideoProvider_)
    async CreatemjBizAppsCommitteesVideoProvider(
        @Arg('input', () => CreatemjBizAppsCommitteesVideoProviderInput) input: CreatemjBizAppsCommitteesVideoProviderInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Video Providers', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjBizAppsCommitteesVideoProvider_)
    async UpdatemjBizAppsCommitteesVideoProvider(
        @Arg('input', () => UpdatemjBizAppsCommitteesVideoProviderInput) input: UpdatemjBizAppsCommitteesVideoProviderInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Video Providers', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjBizAppsCommitteesVideoProvider_)
    async DeletemjBizAppsCommitteesVideoProvider(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Video Providers', key, options, provider, userPayload, pubSub);
    }
    
}

//****************************************************************************
// ENTITY CLASS for Committees: Votes
//****************************************************************************
@ObjectType({ description: `Individual vote records for committee motions` })
export class mjBizAppsCommitteesVote_ {
    @Field() 
    @MaxLength(36)
    ID: string;
        
    @Field() 
    @MaxLength(36)
    MotionID: string;
        
    @Field() 
    @MaxLength(36)
    MembershipID: string;
        
    @Field() 
    @MaxLength(20)
    VoteValue: string;
        
    @Field({nullable: true}) 
    @MaxLength(500)
    Notes?: string;
        
    @Field() 
    _mj__CreatedAt: Date;
        
    @Field() 
    _mj__UpdatedAt: Date;
        
}

//****************************************************************************
// INPUT TYPE for Committees: Votes
//****************************************************************************
@InputType()
export class CreatemjBizAppsCommitteesVoteInput {
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
export class UpdatemjBizAppsCommitteesVoteInput {
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
export class RunmjBizAppsCommitteesVoteViewResult {
    @Field(() => [mjBizAppsCommitteesVote_])
    Results: mjBizAppsCommitteesVote_[];

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

@Resolver(mjBizAppsCommitteesVote_)
export class mjBizAppsCommitteesVoteResolver extends ResolverBase {
    @Query(() => RunmjBizAppsCommitteesVoteViewResult)
    async RunmjBizAppsCommitteesVoteViewByID(@Arg('input', () => RunViewByIDInput) input: RunViewByIDInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByIDGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesVoteViewResult)
    async RunmjBizAppsCommitteesVoteViewByName(@Arg('input', () => RunViewByNameInput) input: RunViewByNameInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        return super.RunViewByNameGeneric(input, provider, userPayload, pubSub);
    }

    @Query(() => RunmjBizAppsCommitteesVoteViewResult)
    async RunmjBizAppsCommitteesVoteDynamicView(@Arg('input', () => RunDynamicViewInput) input: RunDynamicViewInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        input.EntityName = 'Committees: Votes';
        return super.RunDynamicViewGeneric(input, provider, userPayload, pubSub);
    }
    @Query(() => mjBizAppsCommitteesVote_, { nullable: true })
    async mjBizAppsCommitteesVote(@Arg('ID', () => String) ID: string, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine): Promise<mjBizAppsCommitteesVote_ | null> {
        this.CheckUserReadPermissions('Committees: Votes', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_BizAppsCommittees', 'vwVotes')} WHERE ${provider.QuoteIdentifier('ID')}=${provider.BuildParameterPlaceholder(0)} ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Votes', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, [ID], undefined, this.GetUserFromPayload(userPayload));
        const result = await this.MapFieldNamesToCodeNames('Committees: Votes', rows && rows.length > 0 ? rows[0] : null, this.GetUserFromPayload(userPayload));
        return result;
    }
    
    @Mutation(() => mjBizAppsCommitteesVote_)
    async CreatemjBizAppsCommitteesVote(
        @Arg('input', () => CreatemjBizAppsCommitteesVoteInput) input: CreatemjBizAppsCommitteesVoteInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.CreateRecord('Committees: Votes', input, provider, userPayload, pubSub)
    }
        
    @Mutation(() => mjBizAppsCommitteesVote_)
    async UpdatemjBizAppsCommitteesVote(
        @Arg('input', () => UpdatemjBizAppsCommitteesVoteInput) input: UpdatemjBizAppsCommitteesVoteInput,
        @Ctx() { providers, userPayload }: AppContext,
        @PubSub() pubSub: PubSubEngine
    ) {
        const provider = GetReadWriteProvider(providers);
        return this.UpdateRecord('Committees: Votes', input, provider, userPayload, pubSub);
    }
    
    @Mutation(() => mjBizAppsCommitteesVote_)
    async DeletemjBizAppsCommitteesVote(@Arg('ID', () => String) ID: string, @Arg('options___', () => DeleteOptionsInput) options: DeleteOptionsInput, @Ctx() { providers, userPayload }: AppContext, @PubSub() pubSub: PubSubEngine) {
        const provider = GetReadWriteProvider(providers);
        const key = new CompositeKey([{FieldName: 'ID', Value: ID}]);
        return this.DeleteRecord('Committees: Votes', key, options, provider, userPayload, pubSub);
    }
    
}