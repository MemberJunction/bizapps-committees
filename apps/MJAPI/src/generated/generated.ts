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
@ObjectType({ description: `Legacy action items assigned from committees or meetings (superseded by BizAppsTasks)` })
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
        
    @Field(() => [mjCommitteesActionItem_])
    mjCommitteesCommittees_ActionItems_AgendaItemIDArray: mjCommitteesActionItem_[]; // Link to mjCommitteesCommittees_ActionItems
    
    @Field(() => [mjCommitteesAgendaItem_])
    mjCommitteesCommittees_AgendaItems_ParentAgendaItemIDArray: mjCommitteesAgendaItem_[]; // Link to mjCommitteesCommittees_AgendaItems
    
    @Field(() => [mjCommitteesArtifact_])
    mjCommitteesCommittees_Artifacts_AgendaItemIDArray: mjCommitteesArtifact_[]; // Link to mjCommitteesCommittees_Artifacts
    
    @Field(() => [mjCommitteesMotion_])
    mjCommitteesCommittees_Motions_AgendaItemIDArray: mjCommitteesMotion_[]; // Link to mjCommitteesCommittees_Motions
    
    @Field(() => [mjCommitteesComment_])
    mjCommitteesCommittees_Comments_AgendaItemIDArray: mjCommitteesComment_[]; // Link to mjCommitteesCommittees_Comments
    
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
    
    @FieldResolver(() => [mjCommitteesActionItem_])
    async mjCommitteesCommittees_ActionItems_AgendaItemIDArray(@Root() mjcommitteesagendaitem_: mjCommitteesAgendaItem_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Action Items', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwActionItems')} WHERE ${provider.QuoteIdentifier('AgendaItemID')}='${mjcommitteesagendaitem_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Action Items', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Action Items', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesAgendaItem_])
    async mjCommitteesCommittees_AgendaItems_ParentAgendaItemIDArray(@Root() mjcommitteesagendaitem_: mjCommitteesAgendaItem_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Agenda Items', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwAgendaItems')} WHERE ${provider.QuoteIdentifier('ParentAgendaItemID')}='${mjcommitteesagendaitem_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Agenda Items', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Agenda Items', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesArtifact_])
    async mjCommitteesCommittees_Artifacts_AgendaItemIDArray(@Root() mjcommitteesagendaitem_: mjCommitteesAgendaItem_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Artifacts', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwArtifacts')} WHERE ${provider.QuoteIdentifier('AgendaItemID')}='${mjcommitteesagendaitem_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Artifacts', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Artifacts', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesMotion_])
    async mjCommitteesCommittees_Motions_AgendaItemIDArray(@Root() mjcommitteesagendaitem_: mjCommitteesAgendaItem_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Motions', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMotions')} WHERE ${provider.QuoteIdentifier('AgendaItemID')}='${mjcommitteesagendaitem_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Motions', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Motions', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesComment_])
    async mjCommitteesCommittees_Comments_AgendaItemIDArray(@Root() mjcommitteesagendaitem_: mjCommitteesAgendaItem_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
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
@ObjectType({ description: `Categories of committee artifacts with optional extension entity for type-specific fields` })
export class mjCommitteesArtifactType_ {
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
        
    @Field(() => [mjCommitteesArtifact_])
    mjCommitteesCommittees_Artifacts_ArtifactTypeIDArray: mjCommitteesArtifact_[]; // Link to mjCommitteesCommittees_Artifacts
    
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
    async mjCommitteesCommittees_Artifacts_ArtifactTypeIDArray(@Root() mjcommitteesartifacttype_: mjCommitteesArtifactType_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
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
@ObjectType({ description: `Links to external documents and files from various providers` })
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
        
    @Field(() => [mjCommitteesMinute_])
    mjCommitteesCommittees_Minutes_ArtifactIDArray: mjCommitteesMinute_[]; // Link to mjCommitteesCommittees_Minutes
    
    @Field(() => [mjCommitteesComment_])
    mjCommitteesCommittees_Comments_ArtifactIDArray: mjCommitteesComment_[]; // Link to mjCommitteesCommittees_Comments
    
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
    async mjCommitteesCommittees_Minutes_ArtifactIDArray(@Root() mjcommitteesartifact_: mjCommitteesArtifact_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Minutes', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMinutes')} WHERE ${provider.QuoteIdentifier('ArtifactID')}='${mjcommitteesartifact_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Minutes', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Minutes', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesComment_])
    async mjCommitteesCommittees_Comments_ArtifactIDArray(@Root() mjcommitteesartifact_: mjCommitteesArtifact_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
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
@ObjectType({ description: `Threaded discussion comments on committee meetings, agenda items, tasks, and documents` })
export class mjCommitteesComment_ {
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
        
    @Field(() => [mjCommitteesComment_])
    mjCommitteesCommittees_Comments_ParentCommentIDArray: mjCommitteesComment_[]; // Link to mjCommitteesCommittees_Comments
    
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
    async mjCommitteesCommittees_Comments_ParentCommentIDArray(@Root() mjcommitteescomment_: mjCommitteesComment_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
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
        
    @Field(() => [mjCommitteesActionItem_])
    mjCommitteesCommittees_ActionItems_CommitteeIDArray: mjCommitteesActionItem_[]; // Link to mjCommitteesCommittees_ActionItems
    
    @Field(() => [mjCommitteesCommittee_])
    mjCommitteesCommittees_Committees_ParentCommitteeIDArray: mjCommitteesCommittee_[]; // Link to mjCommitteesCommittees_Committees
    
    @Field(() => [mjCommitteesMeeting_])
    mjCommitteesCommittees_Meetings_CommitteeIDArray: mjCommitteesMeeting_[]; // Link to mjCommitteesCommittees_Meetings
    
    @Field(() => [mjCommitteesComment_])
    mjCommitteesCommittees_Comments_CommitteeIDArray: mjCommitteesComment_[]; // Link to mjCommitteesCommittees_Comments
    
    @Field(() => [mjCommitteesTerm_])
    mjCommitteesCommittees_Terms_CommitteeIDArray: mjCommitteesTerm_[]; // Link to mjCommitteesCommittees_Terms
    
    @Field(() => [mjCommitteesArtifact_])
    mjCommitteesCommittees_Artifacts_CommitteeIDArray: mjCommitteesArtifact_[]; // Link to mjCommitteesCommittees_Artifacts
    
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
    
    @FieldResolver(() => [mjCommitteesActionItem_])
    async mjCommitteesCommittees_ActionItems_CommitteeIDArray(@Root() mjcommitteescommittee_: mjCommitteesCommittee_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Action Items', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwActionItems')} WHERE ${provider.QuoteIdentifier('CommitteeID')}='${mjcommitteescommittee_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Action Items', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Action Items', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesCommittee_])
    async mjCommitteesCommittees_Committees_ParentCommitteeIDArray(@Root() mjcommitteescommittee_: mjCommitteesCommittee_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Committees', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwCommittees')} WHERE ${provider.QuoteIdentifier('ParentCommitteeID')}='${mjcommitteescommittee_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Committees', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Committees', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesMeeting_])
    async mjCommitteesCommittees_Meetings_CommitteeIDArray(@Root() mjcommitteescommittee_: mjCommitteesCommittee_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Meetings', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMeetings')} WHERE ${provider.QuoteIdentifier('CommitteeID')}='${mjcommitteescommittee_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Meetings', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Meetings', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesComment_])
    async mjCommitteesCommittees_Comments_CommitteeIDArray(@Root() mjcommitteescommittee_: mjCommitteesCommittee_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Comments', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwComments')} WHERE ${provider.QuoteIdentifier('CommitteeID')}='${mjcommitteescommittee_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Comments', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Comments', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesTerm_])
    async mjCommitteesCommittees_Terms_CommitteeIDArray(@Root() mjcommitteescommittee_: mjCommitteesCommittee_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Terms', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwTerms')} WHERE ${provider.QuoteIdentifier('CommitteeID')}='${mjcommitteescommittee_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Terms', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Terms', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesArtifact_])
    async mjCommitteesCommittees_Artifacts_CommitteeIDArray(@Root() mjcommitteescommittee_: mjCommitteesCommittee_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Artifacts', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwArtifacts')} WHERE ${provider.QuoteIdentifier('CommitteeID')}='${mjcommitteescommittee_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Artifacts', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Artifacts', rows, this.GetUserFromPayload(userPayload));
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
        
    @Field(() => Float, {nullable: true}) 
    _mj__Latitude?: number;
        
    @Field(() => Float, {nullable: true}) 
    _mj__Longitude?: number;
        
    @Field(() => [mjCommitteesComment_])
    mjCommitteesCommittees_Comments_MeetingIDArray: mjCommitteesComment_[]; // Link to mjCommitteesCommittees_Comments
    
    @Field(() => [mjCommitteesActionItem_])
    mjCommitteesCommittees_ActionItems_MeetingIDArray: mjCommitteesActionItem_[]; // Link to mjCommitteesCommittees_ActionItems
    
    @Field(() => [mjCommitteesAttendance_])
    mjCommitteesCommittees_Attendances_MeetingIDArray: mjCommitteesAttendance_[]; // Link to mjCommitteesCommittees_Attendances
    
    @Field(() => [mjCommitteesMotion_])
    mjCommitteesCommittees_Motions_MeetingIDArray: mjCommitteesMotion_[]; // Link to mjCommitteesCommittees_Motions
    
    @Field(() => [mjCommitteesMinute_])
    mjCommitteesCommittees_Minutes_MeetingIDArray: mjCommitteesMinute_[]; // Link to mjCommitteesCommittees_Minutes
    
    @Field(() => [mjCommitteesMinute_])
    mjCommitteesCommittees_Minutes_ApprovedByMeetingIDArray: mjCommitteesMinute_[]; // Link to mjCommitteesCommittees_Minutes
    
    @Field(() => [mjCommitteesAgendaItem_])
    mjCommitteesCommittees_AgendaItems_MeetingIDArray: mjCommitteesAgendaItem_[]; // Link to mjCommitteesCommittees_AgendaItems
    
    @Field(() => [mjCommitteesArtifact_])
    mjCommitteesCommittees_Artifacts_MeetingIDArray: mjCommitteesArtifact_[]; // Link to mjCommitteesCommittees_Artifacts
    
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
    
    @FieldResolver(() => [mjCommitteesComment_])
    async mjCommitteesCommittees_Comments_MeetingIDArray(@Root() mjcommitteesmeeting_: mjCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Comments', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwComments')} WHERE ${provider.QuoteIdentifier('MeetingID')}='${mjcommitteesmeeting_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Comments', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Comments', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesActionItem_])
    async mjCommitteesCommittees_ActionItems_MeetingIDArray(@Root() mjcommitteesmeeting_: mjCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Action Items', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwActionItems')} WHERE ${provider.QuoteIdentifier('MeetingID')}='${mjcommitteesmeeting_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Action Items', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Action Items', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesAttendance_])
    async mjCommitteesCommittees_Attendances_MeetingIDArray(@Root() mjcommitteesmeeting_: mjCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Attendances', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwAttendances')} WHERE ${provider.QuoteIdentifier('MeetingID')}='${mjcommitteesmeeting_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Attendances', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Attendances', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesMotion_])
    async mjCommitteesCommittees_Motions_MeetingIDArray(@Root() mjcommitteesmeeting_: mjCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Motions', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMotions')} WHERE ${provider.QuoteIdentifier('MeetingID')}='${mjcommitteesmeeting_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Motions', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Motions', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesMinute_])
    async mjCommitteesCommittees_Minutes_MeetingIDArray(@Root() mjcommitteesmeeting_: mjCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Minutes', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMinutes')} WHERE ${provider.QuoteIdentifier('MeetingID')}='${mjcommitteesmeeting_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Minutes', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Minutes', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesMinute_])
    async mjCommitteesCommittees_Minutes_ApprovedByMeetingIDArray(@Root() mjcommitteesmeeting_: mjCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Minutes', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMinutes')} WHERE ${provider.QuoteIdentifier('ApprovedByMeetingID')}='${mjcommitteesmeeting_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Minutes', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Minutes', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesAgendaItem_])
    async mjCommitteesCommittees_AgendaItems_MeetingIDArray(@Root() mjcommitteesmeeting_: mjCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Agenda Items', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwAgendaItems')} WHERE ${provider.QuoteIdentifier('MeetingID')}='${mjcommitteesmeeting_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Agenda Items', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Agenda Items', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesArtifact_])
    async mjCommitteesCommittees_Artifacts_MeetingIDArray(@Root() mjcommitteesmeeting_: mjCommitteesMeeting_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Artifacts', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwArtifacts')} WHERE ${provider.QuoteIdentifier('MeetingID')}='${mjcommitteesmeeting_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Artifacts', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Artifacts', rows, this.GetUserFromPayload(userPayload));
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
        
    @Field(() => [mjCommitteesMotion_])
    mjCommitteesCommittees_Motions_MovedByMembershipIDArray: mjCommitteesMotion_[]; // Link to mjCommitteesCommittees_Motions
    
    @Field(() => [mjCommitteesMotion_])
    mjCommitteesCommittees_Motions_SecondedByMembershipIDArray: mjCommitteesMotion_[]; // Link to mjCommitteesCommittees_Motions
    
    @Field(() => [mjCommitteesVote_])
    mjCommitteesCommittees_Votes_MembershipIDArray: mjCommitteesVote_[]; // Link to mjCommitteesCommittees_Votes
    
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
    
    @FieldResolver(() => [mjCommitteesMotion_])
    async mjCommitteesCommittees_Motions_MovedByMembershipIDArray(@Root() mjcommitteesmembership_: mjCommitteesMembership_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Motions', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMotions')} WHERE ${provider.QuoteIdentifier('MovedByMembershipID')}='${mjcommitteesmembership_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Motions', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Motions', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesMotion_])
    async mjCommitteesCommittees_Motions_SecondedByMembershipIDArray(@Root() mjcommitteesmembership_: mjCommitteesMembership_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Motions', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwMotions')} WHERE ${provider.QuoteIdentifier('SecondedByMembershipID')}='${mjcommitteesmembership_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Motions', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Motions', rows, this.GetUserFromPayload(userPayload));
        return result;
    }
        
    @FieldResolver(() => [mjCommitteesVote_])
    async mjCommitteesCommittees_Votes_MembershipIDArray(@Root() mjcommitteesmembership_: mjCommitteesMembership_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
        this.CheckUserReadPermissions('Committees: Votes', userPayload);
        const provider = GetReadOnlyProvider(providers, { allowFallbackToReadWrite: true });
        const sSQL = `SELECT * FROM ${provider.QuoteSchemaAndView('__mj_Committees', 'vwVotes')} WHERE ${provider.QuoteIdentifier('MembershipID')}='${mjcommitteesmembership_.ID}' ` + this.getRowLevelSecurityWhereClause(provider, 'Committees: Votes', userPayload, EntityPermissionType.Read, 'AND');
        const rows = await provider.ExecuteSQL(sSQL, undefined, undefined, this.GetUserFromPayload(userPayload));
        const result = await this.ArrayMapFieldNamesToCodeNames('Committees: Votes', rows, this.GetUserFromPayload(userPayload));
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
@ObjectType({ description: `Meeting minutes with approval tracking; stored as markdown Content or linked Artifact` })
export class mjCommitteesMinute_ {
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
export class CreatemjCommitteesMinuteInput {
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
export class UpdatemjCommitteesMinuteInput {
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
        
    @Field(() => [mjCommitteesVote_])
    mjCommitteesCommittees_Votes_MotionIDArray: mjCommitteesVote_[]; // Link to mjCommitteesCommittees_Votes
    
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
    async mjCommitteesCommittees_Votes_MotionIDArray(@Root() mjcommitteesmotion_: mjCommitteesMotion_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
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
        
    @Field(() => [mjCommitteesMembership_])
    mjCommitteesCommittees_Memberships_RoleIDArray: mjCommitteesMembership_[]; // Link to mjCommitteesCommittees_Memberships
    
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
    async mjCommitteesCommittees_Memberships_RoleIDArray(@Root() mjcommitteesrole_: mjCommitteesRole_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
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
        
    @Field(() => [mjCommitteesMembership_])
    mjCommitteesCommittees_Memberships_TermIDArray: mjCommitteesMembership_[]; // Link to mjCommitteesCommittees_Memberships
    
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
    async mjCommitteesCommittees_Memberships_TermIDArray(@Root() mjcommitteesterm_: mjCommitteesTerm_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
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
        
    @Field(() => [mjCommitteesCommittee_])
    mjCommitteesCommittees_Committees_TypeIDArray: mjCommitteesCommittee_[]; // Link to mjCommitteesCommittees_Committees
    
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
    async mjCommitteesCommittees_Committees_TypeIDArray(@Root() mjcommitteestype_: mjCommitteesType_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
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
@ObjectType({ description: `Configured video conferencing providers for auto-creating meeting URLs` })
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
    mjCommitteesCommittees_Meetings_VideoProviderIDArray: mjCommitteesMeeting_[]; // Link to mjCommitteesCommittees_Meetings
    
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
    async mjCommitteesCommittees_Meetings_VideoProviderIDArray(@Root() mjcommitteesvideoprovider_: mjCommitteesVideoProvider_, @Ctx() { userPayload, providers }: AppContext, @PubSub() pubSub: PubSubEngine) {
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