import { BaseEntity, EntitySaveOptions, EntityDeleteOptions, CompositeKey, ValidationResult, ValidationErrorInfo, ValidationErrorType, Metadata, ProviderType, DatabaseProviderBase, RunView } from "@memberjunction/core";
import { RegisterClass } from "@memberjunction/global";
import { z } from "zod";

     
 
/**
 * zod schema definition for the entity Committees: Artifact Types
 */
export const mjBizAppsCommitteesArtifactTypeSchema = z.object({
    ID: z.string().describe(`
        * * Field Name: ID
        * * Display Name: ID
        * * SQL Data Type: uniqueidentifier
        * * Default Value: newsequentialid()`),
    Name: z.string().describe(`
        * * Field Name: Name
        * * Display Name: Name
        * * SQL Data Type: nvarchar(100)`),
    Description: z.string().nullable().describe(`
        * * Field Name: Description
        * * Display Name: Description
        * * SQL Data Type: nvarchar(MAX)`),
    ExtendedEntityID: z.string().nullable().describe(`
        * * Field Name: ExtendedEntityID
        * * Display Name: Extended Entity ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ: Entities (vwEntities.ID)`),
    IconClass: z.string().nullable().describe(`
        * * Field Name: IconClass
        * * Display Name: Icon Class
        * * SQL Data Type: nvarchar(100)`),
    __mj_CreatedAt: z.date().describe(`
        * * Field Name: __mj_CreatedAt
        * * Display Name: Created At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    __mj_UpdatedAt: z.date().describe(`
        * * Field Name: __mj_UpdatedAt
        * * Display Name: Updated At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    ExtendedEntity: z.string().nullable().describe(`
        * * Field Name: ExtendedEntity
        * * Display Name: Extended Entity
        * * SQL Data Type: nvarchar(255)`),
});

export type mjBizAppsCommitteesArtifactTypeEntityType = z.infer<typeof mjBizAppsCommitteesArtifactTypeSchema>;

/**
 * zod schema definition for the entity Committees: Artifacts
 */
export const mjBizAppsCommitteesArtifactSchema = z.object({
    ID: z.string().describe(`
        * * Field Name: ID
        * * Display Name: ID
        * * SQL Data Type: uniqueidentifier
        * * Default Value: newsequentialid()`),
    CommitteeID: z.string().nullable().describe(`
        * * Field Name: CommitteeID
        * * Display Name: Committee ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Committees (vwCommittees.ID)`),
    MeetingID: z.string().nullable().describe(`
        * * Field Name: MeetingID
        * * Display Name: Meeting ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Meetings (vwMeetings.ID)`),
    AgendaItemID: z.string().nullable().describe(`
        * * Field Name: AgendaItemID
        * * Display Name: Agenda Item ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Meeting Agenda Items (vwMeetingAgendaItems.ID)`),
    TaskID: z.string().nullable().describe(`
        * * Field Name: TaskID
        * * Display Name: Task ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Tasks (vwTasks.ID)`),
    Name: z.string().describe(`
        * * Field Name: Name
        * * Display Name: Name
        * * SQL Data Type: nvarchar(255)`),
    Description: z.string().nullable().describe(`
        * * Field Name: Description
        * * Display Name: Description
        * * SQL Data Type: nvarchar(MAX)`),
    ArtifactTypeID: z.string().describe(`
        * * Field Name: ArtifactTypeID
        * * Display Name: Artifact Type ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Artifact Types (vwArtifactTypes.ID)`),
    Provider: z.union([z.literal('Box'), z.literal('Dropbox'), z.literal('GoogleDrive'), z.literal('OneDrive'), z.literal('SharePoint'), z.literal('URL')]).describe(`
        * * Field Name: Provider
        * * Display Name: Provider
        * * SQL Data Type: nvarchar(50)
    * * Value List Type: List
    * * Possible Values 
    *   * Box
    *   * Dropbox
    *   * GoogleDrive
    *   * OneDrive
    *   * SharePoint
    *   * URL`),
    ExternalID: z.string().nullable().describe(`
        * * Field Name: ExternalID
        * * Display Name: External ID
        * * SQL Data Type: nvarchar(500)`),
    URL: z.string().describe(`
        * * Field Name: URL
        * * Display Name: URL
        * * SQL Data Type: nvarchar(2000)`),
    MimeType: z.string().nullable().describe(`
        * * Field Name: MimeType
        * * Display Name: Mime Type
        * * SQL Data Type: nvarchar(100)`),
    FileSize: z.number().nullable().describe(`
        * * Field Name: FileSize
        * * Display Name: File Size
        * * SQL Data Type: bigint`),
    UploadedByPersonID: z.string().nullable().describe(`
        * * Field Name: UploadedByPersonID
        * * Display Name: Uploaded By Person ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Common: People (vwPeople.ID)`),
    __mj_CreatedAt: z.date().describe(`
        * * Field Name: __mj_CreatedAt
        * * Display Name: Created At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    __mj_UpdatedAt: z.date().describe(`
        * * Field Name: __mj_UpdatedAt
        * * Display Name: Updated At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    Committee: z.string().nullable().describe(`
        * * Field Name: Committee
        * * Display Name: Committee
        * * SQL Data Type: nvarchar(200)`),
    Meeting: z.string().nullable().describe(`
        * * Field Name: Meeting
        * * Display Name: Meeting
        * * SQL Data Type: nvarchar(255)`),
    AgendaItem: z.string().nullable().describe(`
        * * Field Name: AgendaItem
        * * Display Name: Agenda Item
        * * SQL Data Type: nvarchar(500)`),
    Task: z.string().nullable().describe(`
        * * Field Name: Task
        * * Display Name: Task
        * * SQL Data Type: nvarchar(255)`),
    ArtifactType: z.string().describe(`
        * * Field Name: ArtifactType
        * * Display Name: Artifact Type
        * * SQL Data Type: nvarchar(100)`),
    UploadedByPerson: z.string().nullable().describe(`
        * * Field Name: UploadedByPerson
        * * Display Name: Uploaded By Person
        * * SQL Data Type: nvarchar(201)`),
});

export type mjBizAppsCommitteesArtifactEntityType = z.infer<typeof mjBizAppsCommitteesArtifactSchema>;

/**
 * zod schema definition for the entity Committees: Ballots
 */
export const mjBizAppsCommitteesBallotSchema = z.object({
    ID: z.string().describe(`
        * * Field Name: ID
        * * Display Name: ID
        * * SQL Data Type: uniqueidentifier
        * * Default Value: newsequentialid()`),
    CommitteeID: z.string().describe(`
        * * Field Name: CommitteeID
        * * Display Name: Committee ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Committees (vwCommittees.ID)
        * * Description: Committee this ballot belongs to; also the committee scope for the ballot's meeting-less Motion`),
    MotionID: z.string().describe(`
        * * Field Name: MotionID
        * * Display Name: Motion ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Motions (vwMotions.ID)
        * * Description: The Motion this ballot decides — exactly one ballot per motion (unique)`),
    OpensAt: z.date().describe(`
        * * Field Name: OpensAt
        * * Display Name: Opens At
        * * SQL Data Type: datetimeoffset
        * * Description: When voting opens`),
    ClosesAt: z.date().describe(`
        * * Field Name: ClosesAt
        * * Display Name: Closes At
        * * SQL Data Type: datetimeoffset
        * * Description: Scheduled close of the voting window (UI countdown target)`),
    ClosedAt: z.date().nullable().describe(`
        * * Field Name: ClosedAt
        * * Display Name: Closed At
        * * SQL Data Type: datetimeoffset
        * * Description: When the ballot actually closed (early close or scheduled); NULL while open`),
    ThresholdType: z.union([z.literal('SimpleMajority'), z.literal('TwoThirds'), z.literal('Unanimous')]).describe(`
        * * Field Name: ThresholdType
        * * Display Name: Threshold Type
        * * SQL Data Type: nvarchar(20)
        * * Default Value: SimpleMajority
    * * Value List Type: List
    * * Possible Values 
    *   * SimpleMajority
    *   * TwoThirds
    *   * Unanimous
        * * Description: Pass threshold measured against the committee's voting members: SimpleMajority, TwoThirds, or Unanimous`),
    IsSealed: z.boolean().describe(`
        * * Field Name: IsSealed
        * * Display Name: Is Sealed
        * * SQL Data Type: bit
        * * Default Value: 1
        * * Description: When 1, individual vote choices are withheld from all consumers (including admins) until the ballot closes; participation (who has voted) remains visible`),
    Status: z.union([z.literal('Cancelled'), z.literal('Closed'), z.literal('Open')]).describe(`
        * * Field Name: Status
        * * Display Name: Status
        * * SQL Data Type: nvarchar(20)
        * * Default Value: Open
    * * Value List Type: List
    * * Possible Values 
    *   * Cancelled
    *   * Closed
    *   * Open
        * * Description: Ballot lifecycle: Open (accepting votes), Closed (result computed, votes unsealed, Motion stamped), Cancelled`),
    CreatedByMembershipID: z.string().nullable().describe(`
        * * Field Name: CreatedByMembershipID
        * * Display Name: Created By Membership ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Memberships (vwMemberships.ID)
        * * Description: Membership of the member who opened the ballot (typically the Chair)`),
    ResultNotes: z.string().nullable().describe(`
        * * Field Name: ResultNotes
        * * Display Name: Result Notes
        * * SQL Data Type: nvarchar(MAX)
        * * Description: Certification text recorded at close (result summary, any procedural notes)`),
    __mj_CreatedAt: z.date().describe(`
        * * Field Name: __mj_CreatedAt
        * * Display Name: Created At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    __mj_UpdatedAt: z.date().describe(`
        * * Field Name: __mj_UpdatedAt
        * * Display Name: Updated At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    Committee: z.string().describe(`
        * * Field Name: Committee
        * * Display Name: Committee
        * * SQL Data Type: nvarchar(200)`),
    Motion: z.string().describe(`
        * * Field Name: Motion
        * * Display Name: Motion
        * * SQL Data Type: nvarchar(255)`),
});

export type mjBizAppsCommitteesBallotEntityType = z.infer<typeof mjBizAppsCommitteesBallotSchema>;

/**
 * zod schema definition for the entity Committees: Comments
 */
export const mjBizAppsCommitteesCommentSchema = z.object({
    ID: z.string().describe(`
        * * Field Name: ID
        * * Display Name: ID
        * * SQL Data Type: uniqueidentifier
        * * Default Value: newsequentialid()`),
    CommitteeID: z.string().describe(`
        * * Field Name: CommitteeID
        * * Display Name: Committee ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Committees (vwCommittees.ID)`),
    MeetingID: z.string().nullable().describe(`
        * * Field Name: MeetingID
        * * Display Name: Meeting ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Meetings (vwMeetings.ID)`),
    AgendaItemID: z.string().nullable().describe(`
        * * Field Name: AgendaItemID
        * * Display Name: Agenda Item ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Meeting Agenda Items (vwMeetingAgendaItems.ID)`),
    TaskID: z.string().nullable().describe(`
        * * Field Name: TaskID
        * * Display Name: Task ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Tasks (vwTasks.ID)`),
    ArtifactID: z.string().nullable().describe(`
        * * Field Name: ArtifactID
        * * Display Name: Artifact ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Artifacts (vwArtifacts.ID)`),
    ParentCommentID: z.string().nullable().describe(`
        * * Field Name: ParentCommentID
        * * Display Name: Parent Comment ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Comments (vwComments.ID)`),
    PersonID: z.string().describe(`
        * * Field Name: PersonID
        * * Display Name: Person ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Common: People (vwPeople.ID)`),
    CommentText: z.string().describe(`
        * * Field Name: CommentText
        * * Display Name: Comment Text
        * * SQL Data Type: nvarchar(MAX)`),
    MentionedPersonIDs: z.string().nullable().describe(`
        * * Field Name: MentionedPersonIDs
        * * Display Name: Mentioned Person I Ds
        * * SQL Data Type: nvarchar(MAX)`),
    IsResolved: z.boolean().describe(`
        * * Field Name: IsResolved
        * * Display Name: Is Resolved
        * * SQL Data Type: bit
        * * Default Value: 0`),
    __mj_CreatedAt: z.date().describe(`
        * * Field Name: __mj_CreatedAt
        * * Display Name: Created At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    __mj_UpdatedAt: z.date().describe(`
        * * Field Name: __mj_UpdatedAt
        * * Display Name: Updated At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    Committee: z.string().describe(`
        * * Field Name: Committee
        * * Display Name: Committee
        * * SQL Data Type: nvarchar(200)`),
    Meeting: z.string().nullable().describe(`
        * * Field Name: Meeting
        * * Display Name: Meeting
        * * SQL Data Type: nvarchar(255)`),
    AgendaItem: z.string().nullable().describe(`
        * * Field Name: AgendaItem
        * * Display Name: Agenda Item
        * * SQL Data Type: nvarchar(500)`),
    Task: z.string().nullable().describe(`
        * * Field Name: Task
        * * Display Name: Task
        * * SQL Data Type: nvarchar(255)`),
    Artifact: z.string().nullable().describe(`
        * * Field Name: Artifact
        * * Display Name: Artifact
        * * SQL Data Type: nvarchar(255)`),
    Person: z.string().describe(`
        * * Field Name: Person
        * * Display Name: Person
        * * SQL Data Type: nvarchar(201)`),
    RootParentCommentID: z.string().nullable().describe(`
        * * Field Name: RootParentCommentID
        * * Display Name: Root Parent Comment ID
        * * SQL Data Type: uniqueidentifier`),
    ParentCommentIDDepth: z.number().nullable().describe(`
        * * Field Name: ParentCommentIDDepth
        * * Display Name: Parent Comment ID Depth
        * * SQL Data Type: int`),
    ParentCommentIDPath: z.string().nullable().describe(`
        * * Field Name: ParentCommentIDPath
        * * Display Name: Parent Comment ID Path
        * * SQL Data Type: nvarchar(MAX)`),
    ParentCommentIDIsLeaf: z.boolean().nullable().describe(`
        * * Field Name: ParentCommentIDIsLeaf
        * * Display Name: Parent Comment ID Is Leaf
        * * SQL Data Type: bit`),
    ParentCommentIDChildCount: z.number().nullable().describe(`
        * * Field Name: ParentCommentIDChildCount
        * * Display Name: Parent Comment ID Child Count
        * * SQL Data Type: int`),
});

export type mjBizAppsCommitteesCommentEntityType = z.infer<typeof mjBizAppsCommitteesCommentSchema>;

/**
 * zod schema definition for the entity Committees: Committees
 */
export const mjBizAppsCommitteesCommitteeSchema = z.object({
    ID: z.string().describe(`
        * * Field Name: ID
        * * Display Name: ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Collaboration: Spaces (vwSpaces.ID)
        * * Description: The Collaboration Space this committee specializes (same value as Space.ID).`),
    TypeID: z.string().describe(`
        * * Field Name: TypeID
        * * Display Name: Type ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Types (vwTypes.ID)
        * * Description: Foreign key to committee type classification.`),
    OrganizationID: z.string().nullable().describe(`
        * * Field Name: OrganizationID
        * * Display Name: Organization ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Common: Organizations (vwOrganizations.ID)
        * * Description: Foreign key to the sponsoring organization in BizAppsCommon.`),
    CharterDocumentURL: z.string().nullable().describe(`
        * * Field Name: CharterDocumentURL
        * * Display Name: Charter Document URL
        * * SQL Data Type: nvarchar(1000)
        * * Description: URL to the committee charter document.`),
    MissionStatement: z.string().nullable().describe(`
        * * Field Name: MissionStatement
        * * Display Name: Mission Statement
        * * SQL Data Type: nvarchar(MAX)
        * * Description: Formal mission statement of the committee.`),
    Status: z.union([z.literal('Active'), z.literal('Dissolved'), z.literal('Inactive'), z.literal('Pending')]).describe(`
        * * Field Name: Status
        * * Display Name: Status
        * * SQL Data Type: nvarchar(50)
        * * Default Value: Active
    * * Value List Type: List
    * * Possible Values 
    *   * Active
    *   * Dissolved
    *   * Inactive
    *   * Pending
        * * Description: Lifecycle status: Active, Inactive, Pending, Dissolved.`),
    IsPublic: z.boolean().describe(`
        * * Field Name: IsPublic
        * * Display Name: Is Public
        * * SQL Data Type: bit
        * * Default Value: 1
        * * Description: Whether the committee is publicly visible (maps to Space.Discoverability Listed vs Hidden).`),
    __mj_CreatedAt: z.date().describe(`
        * * Field Name: __mj_CreatedAt
        * * Display Name: Created At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    __mj_UpdatedAt: z.date().describe(`
        * * Field Name: __mj_UpdatedAt
        * * Display Name: Updated At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    SpaceTypeID: z.string().describe(`
        * * Field Name: SpaceTypeID
        * * Display Name: Space Type ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Collaboration: Space Types (vwSpaceTypes.ID)`),
    ParentID: z.string().nullable().describe(`
        * * Field Name: ParentID
        * * Display Name: Parent ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Collaboration: Spaces (vwSpaces.ID)`),
    Name: z.string().describe(`
        * * Field Name: Name
        * * Display Name: Name
        * * SQL Data Type: nvarchar(200)`),
    Description: z.string().nullable().describe(`
        * * Field Name: Description
        * * Display Name: Description
        * * SQL Data Type: nvarchar(MAX)`),
    OwnerID: z.string().describe(`
        * * Field Name: OwnerID
        * * Display Name: Owner ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ: Users (vwUsers.ID)`),
    InheritsMembership: z.boolean().describe(`
        * * Field Name: InheritsMembership
        * * Display Name: Inherits Membership
        * * SQL Data Type: bit`),
    AgentRetrieval: z.string().describe(`
        * * Field Name: AgentRetrieval
        * * Display Name: Agent Retrieval
        * * SQL Data Type: nvarchar(30)`),
    StartedAt: z.date().nullable().describe(`
        * * Field Name: StartedAt
        * * Display Name: Started At
        * * SQL Data Type: datetimeoffset`),
    ClosedAt: z.date().nullable().describe(`
        * * Field Name: ClosedAt
        * * Display Name: Closed At
        * * SQL Data Type: datetimeoffset`),
    AllowParentAssignees: z.boolean().describe(`
        * * Field Name: AllowParentAssignees
        * * Display Name: Allow Parent Assignees
        * * SQL Data Type: bit`),
    PlannedCloseAt: z.date().nullable().describe(`
        * * Field Name: PlannedCloseAt
        * * Display Name: Planned Close At
        * * SQL Data Type: datetimeoffset`),
    IconClass: z.string().nullable().describe(`
        * * Field Name: IconClass
        * * Display Name: Icon Class
        * * SQL Data Type: nvarchar(100)`),
    Color: z.string().nullable().describe(`
        * * Field Name: Color
        * * Display Name: Color
        * * SQL Data Type: nvarchar(50)`),
    BackgroundImageURL: z.string().nullable().describe(`
        * * Field Name: BackgroundImageURL
        * * Display Name: Background Image URL
        * * SQL Data Type: nvarchar(1000)`),
    Configuration: z.string().nullable().describe(`
        * * Field Name: Configuration
        * * Display Name: Configuration
        * * SQL Data Type: nvarchar(MAX)`),
    StatusID: z.string().nullable().describe(`
        * * Field Name: StatusID
        * * Display Name: Status ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Collaboration: Space Type Status (vwSpaceTypeStatus.ID)`),
    Type: z.string().describe(`
        * * Field Name: Type
        * * Display Name: Type
        * * SQL Data Type: nvarchar(100)`),
    Organization: z.string().nullable().describe(`
        * * Field Name: Organization
        * * Display Name: Organization
        * * SQL Data Type: nvarchar(255)`),
});

export type mjBizAppsCommitteesCommitteeEntityType = z.infer<typeof mjBizAppsCommitteesCommitteeSchema>;

/**
 * zod schema definition for the entity Committees: Memberships
 */
export const mjBizAppsCommitteesMembershipSchema = z.object({
    ID: z.string().describe(`
        * * Field Name: ID
        * * Display Name: ID
        * * SQL Data Type: uniqueidentifier
        * * Default Value: newsequentialid()`),
    PersonID: z.string().describe(`
        * * Field Name: PersonID
        * * Display Name: Person ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Common: People (vwPeople.ID)`),
    RoleID: z.string().describe(`
        * * Field Name: RoleID
        * * Display Name: Role ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Roles (vwRoles.ID)`),
    TermID: z.string().describe(`
        * * Field Name: TermID
        * * Display Name: Term ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Terms (vwTerms.ID)`),
    StartDate: z.date().describe(`
        * * Field Name: StartDate
        * * Display Name: Start Date
        * * SQL Data Type: date`),
    EndDate: z.date().nullable().describe(`
        * * Field Name: EndDate
        * * Display Name: End Date
        * * SQL Data Type: date`),
    Status: z.union([z.literal('Active'), z.literal('Ended'), z.literal('Pending'), z.literal('Suspended')]).describe(`
        * * Field Name: Status
        * * Display Name: Status
        * * SQL Data Type: nvarchar(50)
        * * Default Value: Active
    * * Value List Type: List
    * * Possible Values 
    *   * Active
    *   * Ended
    *   * Pending
    *   * Suspended`),
    EndReason: z.string().nullable().describe(`
        * * Field Name: EndReason
        * * Display Name: End Reason
        * * SQL Data Type: nvarchar(100)`),
    Notes: z.string().nullable().describe(`
        * * Field Name: Notes
        * * Display Name: Notes
        * * SQL Data Type: nvarchar(MAX)`),
    __mj_CreatedAt: z.date().describe(`
        * * Field Name: __mj_CreatedAt
        * * Display Name: Created At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    __mj_UpdatedAt: z.date().describe(`
        * * Field Name: __mj_UpdatedAt
        * * Display Name: Updated At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    RenewalIntent: z.union([z.literal('No'), z.literal('Undecided'), z.literal('Yes')]).nullable().describe(`
        * * Field Name: RenewalIntent
        * * Display Name: Renewal Intent
        * * SQL Data Type: nvarchar(20)
    * * Value List Type: List
    * * Possible Values 
    *   * No
    *   * Undecided
    *   * Yes
        * * Description: The member's stated intent to serve another term (Yes, No, Undecided), captured via Member Home self-service; NULL = not yet answered. Feeds the People & Terms succession pipeline.`),
    Person: z.string().describe(`
        * * Field Name: Person
        * * Display Name: Person
        * * SQL Data Type: nvarchar(201)`),
    Role: z.string().describe(`
        * * Field Name: Role
        * * Display Name: Role
        * * SQL Data Type: nvarchar(100)`),
    Term: z.string().describe(`
        * * Field Name: Term
        * * Display Name: Term
        * * SQL Data Type: nvarchar(200)`),
});

export type mjBizAppsCommitteesMembershipEntityType = z.infer<typeof mjBizAppsCommitteesMembershipSchema>;

/**
 * zod schema definition for the entity Committees: Minutes
 */
export const mjBizAppsCommitteesMinuteSchema = z.object({
    ID: z.string().describe(`
        * * Field Name: ID
        * * Display Name: ID
        * * SQL Data Type: uniqueidentifier
        * * Default Value: newsequentialid()`),
    ArtifactID: z.string().nullable().describe(`
        * * Field Name: ArtifactID
        * * Display Name: Artifact ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Artifacts (vwArtifacts.ID)`),
    MeetingID: z.string().nullable().describe(`
        * * Field Name: MeetingID
        * * Display Name: Meeting ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Meetings (vwMeetings.ID)`),
    Content: z.string().nullable().describe(`
        * * Field Name: Content
        * * Display Name: Content
        * * SQL Data Type: nvarchar(MAX)`),
    ApprovalStatus: z.union([z.literal('Approved'), z.literal('Draft'), z.literal('PendingApproval'), z.literal('Rejected')]).describe(`
        * * Field Name: ApprovalStatus
        * * Display Name: Approval Status
        * * SQL Data Type: nvarchar(50)
        * * Default Value: Draft
    * * Value List Type: List
    * * Possible Values 
    *   * Approved
    *   * Draft
    *   * PendingApproval
    *   * Rejected`),
    ApprovedAt: z.date().nullable().describe(`
        * * Field Name: ApprovedAt
        * * Display Name: Approved At
        * * SQL Data Type: datetimeoffset`),
    ApprovedByMeetingID: z.string().nullable().describe(`
        * * Field Name: ApprovedByMeetingID
        * * Display Name: Approved By Meeting ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Meetings (vwMeetings.ID)`),
    Notes: z.string().nullable().describe(`
        * * Field Name: Notes
        * * Display Name: Notes
        * * SQL Data Type: nvarchar(MAX)`),
    __mj_CreatedAt: z.date().describe(`
        * * Field Name: __mj_CreatedAt
        * * Display Name: Created At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    __mj_UpdatedAt: z.date().describe(`
        * * Field Name: __mj_UpdatedAt
        * * Display Name: Updated At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    Artifact: z.string().nullable().describe(`
        * * Field Name: Artifact
        * * Display Name: Artifact
        * * SQL Data Type: nvarchar(255)`),
    Meeting: z.string().nullable().describe(`
        * * Field Name: Meeting
        * * Display Name: Meeting
        * * SQL Data Type: nvarchar(255)`),
    ApprovedByMeeting: z.string().nullable().describe(`
        * * Field Name: ApprovedByMeeting
        * * Display Name: Approved By Meeting
        * * SQL Data Type: nvarchar(255)`),
});

export type mjBizAppsCommitteesMinuteEntityType = z.infer<typeof mjBizAppsCommitteesMinuteSchema>;

/**
 * zod schema definition for the entity Committees: Motions
 */
export const mjBizAppsCommitteesMotionSchema = z.object({
    ID: z.string().describe(`
        * * Field Name: ID
        * * Display Name: ID
        * * SQL Data Type: uniqueidentifier
        * * Default Value: newsequentialid()`),
    MeetingID: z.string().nullable().describe(`
        * * Field Name: MeetingID
        * * Display Name: Meeting ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Meetings (vwMeetings.ID)
        * * Description: Meeting where the motion was made; NULL for between-meeting e-ballot motions (see Ballot)`),
    AgendaItemID: z.string().nullable().describe(`
        * * Field Name: AgendaItemID
        * * Display Name: Agenda Item ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Meeting Agenda Items (vwMeetingAgendaItems.ID)`),
    Sequence: z.number().describe(`
        * * Field Name: Sequence
        * * Display Name: Sequence
        * * SQL Data Type: int
        * * Default Value: 1`),
    Name: z.string().describe(`
        * * Field Name: Name
        * * Display Name: Name
        * * SQL Data Type: nvarchar(255)`),
    Description: z.string().nullable().describe(`
        * * Field Name: Description
        * * Display Name: Description
        * * SQL Data Type: nvarchar(MAX)`),
    MovedByMembershipID: z.string().nullable().describe(`
        * * Field Name: MovedByMembershipID
        * * Display Name: Moved By Membership ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Memberships (vwMemberships.ID)`),
    SecondedByMembershipID: z.string().nullable().describe(`
        * * Field Name: SecondedByMembershipID
        * * Display Name: Seconded By Membership ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Memberships (vwMemberships.ID)`),
    Result: z.union([z.literal('Failed'), z.literal('Passed'), z.literal('Pending'), z.literal('Tabled'), z.literal('Withdrawn')]).describe(`
        * * Field Name: Result
        * * Display Name: Result
        * * SQL Data Type: nvarchar(50)
        * * Default Value: Pending
    * * Value List Type: List
    * * Possible Values 
    *   * Failed
    *   * Passed
    *   * Pending
    *   * Tabled
    *   * Withdrawn`),
    ResultSummary: z.string().nullable().describe(`
        * * Field Name: ResultSummary
        * * Display Name: Result Summary
        * * SQL Data Type: nvarchar(255)`),
    YesCount: z.number().nullable().describe(`
        * * Field Name: YesCount
        * * Display Name: Yes Count
        * * SQL Data Type: int`),
    NoCount: z.number().nullable().describe(`
        * * Field Name: NoCount
        * * Display Name: No Count
        * * SQL Data Type: int`),
    AbstainCount: z.number().nullable().describe(`
        * * Field Name: AbstainCount
        * * Display Name: Abstain Count
        * * SQL Data Type: int`),
    Notes: z.string().nullable().describe(`
        * * Field Name: Notes
        * * Display Name: Notes
        * * SQL Data Type: nvarchar(MAX)`),
    __mj_CreatedAt: z.date().describe(`
        * * Field Name: __mj_CreatedAt
        * * Display Name: Created At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    __mj_UpdatedAt: z.date().describe(`
        * * Field Name: __mj_UpdatedAt
        * * Display Name: Updated At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    Meeting: z.string().nullable().describe(`
        * * Field Name: Meeting
        * * Display Name: Meeting
        * * SQL Data Type: nvarchar(255)`),
    AgendaItem: z.string().nullable().describe(`
        * * Field Name: AgendaItem
        * * Display Name: Agenda Item
        * * SQL Data Type: nvarchar(500)`),
});

export type mjBizAppsCommitteesMotionEntityType = z.infer<typeof mjBizAppsCommitteesMotionSchema>;

/**
 * zod schema definition for the entity Committees: Roles
 */
export const mjBizAppsCommitteesRoleSchema = z.object({
    ID: z.string().describe(`
        * * Field Name: ID
        * * Display Name: ID
        * * SQL Data Type: uniqueidentifier
        * * Default Value: newsequentialid()`),
    Name: z.string().describe(`
        * * Field Name: Name
        * * Display Name: Name
        * * SQL Data Type: nvarchar(100)`),
    Description: z.string().nullable().describe(`
        * * Field Name: Description
        * * Display Name: Description
        * * SQL Data Type: nvarchar(MAX)`),
    IsOfficer: z.boolean().describe(`
        * * Field Name: IsOfficer
        * * Display Name: Is Officer
        * * SQL Data Type: bit
        * * Default Value: 0`),
    IsVotingRole: z.boolean().describe(`
        * * Field Name: IsVotingRole
        * * Display Name: Is Voting Role
        * * SQL Data Type: bit
        * * Default Value: 1`),
    DefaultPermissionsJSON: z.string().nullable().describe(`
        * * Field Name: DefaultPermissionsJSON
        * * Display Name: Default Permissions JSON
        * * SQL Data Type: nvarchar(MAX)`),
    Sequence: z.number().describe(`
        * * Field Name: Sequence
        * * Display Name: Sequence
        * * SQL Data Type: int
        * * Default Value: 100`),
    __mj_CreatedAt: z.date().describe(`
        * * Field Name: __mj_CreatedAt
        * * Display Name: Created At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    __mj_UpdatedAt: z.date().describe(`
        * * Field Name: __mj_UpdatedAt
        * * Display Name: Updated At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
});

export type mjBizAppsCommitteesRoleEntityType = z.infer<typeof mjBizAppsCommitteesRoleSchema>;

/**
 * zod schema definition for the entity Committees: Terms
 */
export const mjBizAppsCommitteesTermSchema = z.object({
    ID: z.string().describe(`
        * * Field Name: ID
        * * Display Name: ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Collaboration: Spaces (vwSpaces.ID)
        * * Description: The Collaboration Space this term specializes (same value as Space.ID).`),
    Status: z.union([z.literal('Active'), z.literal('Completed'), z.literal('Upcoming')]).describe(`
        * * Field Name: Status
        * * Display Name: Status
        * * SQL Data Type: nvarchar(50)
        * * Default Value: Active
    * * Value List Type: List
    * * Possible Values 
    *   * Active
    *   * Completed
    *   * Upcoming
        * * Description: Term status: Active, Upcoming, Completed.`),
    __mj_CreatedAt: z.date().describe(`
        * * Field Name: __mj_CreatedAt
        * * Display Name: Created At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    __mj_UpdatedAt: z.date().describe(`
        * * Field Name: __mj_UpdatedAt
        * * Display Name: Updated At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    SpaceTypeID: z.string().describe(`
        * * Field Name: SpaceTypeID
        * * Display Name: Space Type ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Collaboration: Space Types (vwSpaceTypes.ID)`),
    ParentID: z.string().nullable().describe(`
        * * Field Name: ParentID
        * * Display Name: Parent ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Collaboration: Spaces (vwSpaces.ID)`),
    Name: z.string().describe(`
        * * Field Name: Name
        * * Display Name: Name
        * * SQL Data Type: nvarchar(200)`),
    Description: z.string().nullable().describe(`
        * * Field Name: Description
        * * Display Name: Description
        * * SQL Data Type: nvarchar(MAX)`),
    OwnerID: z.string().describe(`
        * * Field Name: OwnerID
        * * Display Name: Owner ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ: Users (vwUsers.ID)`),
    InheritsMembership: z.boolean().describe(`
        * * Field Name: InheritsMembership
        * * Display Name: Inherits Membership
        * * SQL Data Type: bit`),
    AgentRetrieval: z.string().describe(`
        * * Field Name: AgentRetrieval
        * * Display Name: Agent Retrieval
        * * SQL Data Type: nvarchar(30)`),
    StartedAt: z.date().nullable().describe(`
        * * Field Name: StartedAt
        * * Display Name: Started At
        * * SQL Data Type: datetimeoffset`),
    ClosedAt: z.date().nullable().describe(`
        * * Field Name: ClosedAt
        * * Display Name: Closed At
        * * SQL Data Type: datetimeoffset`),
    AllowParentAssignees: z.boolean().describe(`
        * * Field Name: AllowParentAssignees
        * * Display Name: Allow Parent Assignees
        * * SQL Data Type: bit`),
    PlannedCloseAt: z.date().nullable().describe(`
        * * Field Name: PlannedCloseAt
        * * Display Name: Planned Close At
        * * SQL Data Type: datetimeoffset`),
    IconClass: z.string().nullable().describe(`
        * * Field Name: IconClass
        * * Display Name: Icon Class
        * * SQL Data Type: nvarchar(100)`),
    Color: z.string().nullable().describe(`
        * * Field Name: Color
        * * Display Name: Color
        * * SQL Data Type: nvarchar(50)`),
    BackgroundImageURL: z.string().nullable().describe(`
        * * Field Name: BackgroundImageURL
        * * Display Name: Background Image URL
        * * SQL Data Type: nvarchar(1000)`),
    Configuration: z.string().nullable().describe(`
        * * Field Name: Configuration
        * * Display Name: Configuration
        * * SQL Data Type: nvarchar(MAX)`),
    StatusID: z.string().nullable().describe(`
        * * Field Name: StatusID
        * * Display Name: Status ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Collaboration: Space Type Status (vwSpaceTypeStatus.ID)`),
});

export type mjBizAppsCommitteesTermEntityType = z.infer<typeof mjBizAppsCommitteesTermSchema>;

/**
 * zod schema definition for the entity Committees: Types
 */
export const mjBizAppsCommitteesTypeSchema = z.object({
    ID: z.string().describe(`
        * * Field Name: ID
        * * Display Name: ID
        * * SQL Data Type: uniqueidentifier
        * * Default Value: newsequentialid()`),
    Name: z.string().describe(`
        * * Field Name: Name
        * * Display Name: Name
        * * SQL Data Type: nvarchar(100)`),
    Description: z.string().nullable().describe(`
        * * Field Name: Description
        * * Display Name: Description
        * * SQL Data Type: nvarchar(MAX)`),
    IsStandards: z.boolean().describe(`
        * * Field Name: IsStandards
        * * Display Name: Is Standards
        * * SQL Data Type: bit
        * * Default Value: 0`),
    DefaultTermMonths: z.number().nullable().describe(`
        * * Field Name: DefaultTermMonths
        * * Display Name: Default Term Months
        * * SQL Data Type: int`),
    IconClass: z.string().nullable().describe(`
        * * Field Name: IconClass
        * * Display Name: Icon Class
        * * SQL Data Type: nvarchar(100)`),
    __mj_CreatedAt: z.date().describe(`
        * * Field Name: __mj_CreatedAt
        * * Display Name: Created At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    __mj_UpdatedAt: z.date().describe(`
        * * Field Name: __mj_UpdatedAt
        * * Display Name: Updated At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
});

export type mjBizAppsCommitteesTypeEntityType = z.infer<typeof mjBizAppsCommitteesTypeSchema>;

/**
 * zod schema definition for the entity Committees: Votes
 */
export const mjBizAppsCommitteesVoteSchema = z.object({
    ID: z.string().describe(`
        * * Field Name: ID
        * * Display Name: ID
        * * SQL Data Type: uniqueidentifier
        * * Default Value: newsequentialid()`),
    MotionID: z.string().describe(`
        * * Field Name: MotionID
        * * Display Name: Motion ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Motions (vwMotions.ID)`),
    MembershipID: z.string().describe(`
        * * Field Name: MembershipID
        * * Display Name: Membership ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Memberships (vwMemberships.ID)`),
    VoteValue: z.union([z.literal('Absent'), z.literal('Abstain'), z.literal('No'), z.literal('Yes')]).describe(`
        * * Field Name: VoteValue
        * * Display Name: Vote Value
        * * SQL Data Type: nvarchar(20)
    * * Value List Type: List
    * * Possible Values 
    *   * Absent
    *   * Abstain
    *   * No
    *   * Yes`),
    Notes: z.string().nullable().describe(`
        * * Field Name: Notes
        * * Display Name: Notes
        * * SQL Data Type: nvarchar(500)`),
    __mj_CreatedAt: z.date().describe(`
        * * Field Name: __mj_CreatedAt
        * * Display Name: Created At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    __mj_UpdatedAt: z.date().describe(`
        * * Field Name: __mj_UpdatedAt
        * * Display Name: Updated At
        * * SQL Data Type: datetimeoffset
        * * Default Value: getutcdate()`),
    Motion: z.string().describe(`
        * * Field Name: Motion
        * * Display Name: Motion
        * * SQL Data Type: nvarchar(255)`),
});

export type mjBizAppsCommitteesVoteEntityType = z.infer<typeof mjBizAppsCommitteesVoteSchema>;
 
 

/**
 * Committees: Artifact Types - strongly typed entity sub-class
 * * Schema: __mj_BizAppsCommittees
 * * Base Table: ArtifactType
 * * Base View: vwArtifactTypes
 * * @description Categories of committee artifacts with optional extension entity for type-specific fields
 * * Primary Key: ID
 * @extends {BaseEntity}
 * @class
 * @public
 */
@RegisterClass(BaseEntity, 'Committees: Artifact Types')
export class mjBizAppsCommitteesArtifactTypeEntity extends BaseEntity<mjBizAppsCommitteesArtifactTypeEntityType> {
    /**
    * Loads the Committees: Artifact Types record from the database
    * @param ID: string - primary key value to load the Committees: Artifact Types record.
    * @param EntityRelationshipsToLoad - (optional) the relationships to load
    * @returns {Promise<boolean>} - true if successful, false otherwise
    * @public
    * @async
    * @memberof mjBizAppsCommitteesArtifactTypeEntity
    * @method
    * @override
    */
    public async Load(ID: string, EntityRelationshipsToLoad?: string[]) : Promise<boolean> {
        const compositeKey: CompositeKey = new CompositeKey();
        compositeKey.KeyValuePairs.push({ FieldName: 'ID', Value: ID });
        return await super.InnerLoad(compositeKey, EntityRelationshipsToLoad);
    }

    /**
    * * Field Name: ID
    * * Display Name: ID
    * * SQL Data Type: uniqueidentifier
    * * Default Value: newsequentialid()
    */
    get ID(): string {
        return this.Get('ID');
    }
    set ID(value: string) {
        this.Set('ID', value);
    }

    /**
    * * Field Name: Name
    * * Display Name: Name
    * * SQL Data Type: nvarchar(100)
    */
    get Name(): string {
        return this.Get('Name');
    }
    set Name(value: string) {
        this.Set('Name', value);
    }

    /**
    * * Field Name: Description
    * * Display Name: Description
    * * SQL Data Type: nvarchar(MAX)
    */
    get Description(): string | null {
        return this.Get('Description');
    }
    set Description(value: string | null) {
        this.Set('Description', value);
    }

    /**
    * * Field Name: ExtendedEntityID
    * * Display Name: Extended Entity ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ: Entities (vwEntities.ID)
    */
    get ExtendedEntityID(): string | null {
        return this.Get('ExtendedEntityID');
    }
    set ExtendedEntityID(value: string | null) {
        this.Set('ExtendedEntityID', value);
    }

    /**
    * * Field Name: IconClass
    * * Display Name: Icon Class
    * * SQL Data Type: nvarchar(100)
    */
    get IconClass(): string | null {
        return this.Get('IconClass');
    }
    set IconClass(value: string | null) {
        this.Set('IconClass', value);
    }

    /**
    * * Field Name: __mj_CreatedAt
    * * Display Name: Created At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_CreatedAt(): Date {
        return this.Get('__mj_CreatedAt');
    }

    /**
    * * Field Name: __mj_UpdatedAt
    * * Display Name: Updated At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_UpdatedAt(): Date {
        return this.Get('__mj_UpdatedAt');
    }

    /**
    * * Field Name: ExtendedEntity
    * * Display Name: Extended Entity
    * * SQL Data Type: nvarchar(255)
    */
    get ExtendedEntity(): string | null {
        return this.Get('ExtendedEntity');
    }
}


/**
 * Committees: Artifacts - strongly typed entity sub-class
 * * Schema: __mj_BizAppsCommittees
 * * Base Table: Artifact
 * * Base View: vwArtifacts
 * * @description Links to external documents and files from various providers
 * * Primary Key: ID
 * @extends {BaseEntity}
 * @class
 * @public
 */
@RegisterClass(BaseEntity, 'Committees: Artifacts')
export class mjBizAppsCommitteesArtifactEntity extends BaseEntity<mjBizAppsCommitteesArtifactEntityType> {
    /**
    * Loads the Committees: Artifacts record from the database
    * @param ID: string - primary key value to load the Committees: Artifacts record.
    * @param EntityRelationshipsToLoad - (optional) the relationships to load
    * @returns {Promise<boolean>} - true if successful, false otherwise
    * @public
    * @async
    * @memberof mjBizAppsCommitteesArtifactEntity
    * @method
    * @override
    */
    public async Load(ID: string, EntityRelationshipsToLoad?: string[]) : Promise<boolean> {
        const compositeKey: CompositeKey = new CompositeKey();
        compositeKey.KeyValuePairs.push({ FieldName: 'ID', Value: ID });
        return await super.InnerLoad(compositeKey, EntityRelationshipsToLoad);
    }

    /**
    * * Field Name: ID
    * * Display Name: ID
    * * SQL Data Type: uniqueidentifier
    * * Default Value: newsequentialid()
    */
    get ID(): string {
        return this.Get('ID');
    }
    set ID(value: string) {
        this.Set('ID', value);
    }

    /**
    * * Field Name: CommitteeID
    * * Display Name: Committee ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Committees (vwCommittees.ID)
    */
    get CommitteeID(): string | null {
        return this.Get('CommitteeID');
    }
    set CommitteeID(value: string | null) {
        this.Set('CommitteeID', value);
    }

    /**
    * * Field Name: MeetingID
    * * Display Name: Meeting ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Meetings (vwMeetings.ID)
    */
    get MeetingID(): string | null {
        return this.Get('MeetingID');
    }
    set MeetingID(value: string | null) {
        this.Set('MeetingID', value);
    }

    /**
    * * Field Name: AgendaItemID
    * * Display Name: Agenda Item ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Meeting Agenda Items (vwMeetingAgendaItems.ID)
    */
    get AgendaItemID(): string | null {
        return this.Get('AgendaItemID');
    }
    set AgendaItemID(value: string | null) {
        this.Set('AgendaItemID', value);
    }

    /**
    * * Field Name: TaskID
    * * Display Name: Task ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Tasks (vwTasks.ID)
    */
    get TaskID(): string | null {
        return this.Get('TaskID');
    }
    set TaskID(value: string | null) {
        this.Set('TaskID', value);
    }

    /**
    * * Field Name: Name
    * * Display Name: Name
    * * SQL Data Type: nvarchar(255)
    */
    get Name(): string {
        return this.Get('Name');
    }
    set Name(value: string) {
        this.Set('Name', value);
    }

    /**
    * * Field Name: Description
    * * Display Name: Description
    * * SQL Data Type: nvarchar(MAX)
    */
    get Description(): string | null {
        return this.Get('Description');
    }
    set Description(value: string | null) {
        this.Set('Description', value);
    }

    /**
    * * Field Name: ArtifactTypeID
    * * Display Name: Artifact Type ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Artifact Types (vwArtifactTypes.ID)
    */
    get ArtifactTypeID(): string {
        return this.Get('ArtifactTypeID');
    }
    set ArtifactTypeID(value: string) {
        this.Set('ArtifactTypeID', value);
    }

    /**
    * * Field Name: Provider
    * * Display Name: Provider
    * * SQL Data Type: nvarchar(50)
    * * Value List Type: List
    * * Possible Values 
    *   * Box
    *   * Dropbox
    *   * GoogleDrive
    *   * OneDrive
    *   * SharePoint
    *   * URL
    */
    get Provider(): 'Box' | 'Dropbox' | 'GoogleDrive' | 'OneDrive' | 'SharePoint' | 'URL' {
        return this.Get('Provider');
    }
    set Provider(value: 'Box' | 'Dropbox' | 'GoogleDrive' | 'OneDrive' | 'SharePoint' | 'URL') {
        this.Set('Provider', value);
    }

    /**
    * * Field Name: ExternalID
    * * Display Name: External ID
    * * SQL Data Type: nvarchar(500)
    */
    get ExternalID(): string | null {
        return this.Get('ExternalID');
    }
    set ExternalID(value: string | null) {
        this.Set('ExternalID', value);
    }

    /**
    * * Field Name: URL
    * * Display Name: URL
    * * SQL Data Type: nvarchar(2000)
    */
    get URL(): string {
        return this.Get('URL');
    }
    set URL(value: string) {
        this.Set('URL', value);
    }

    /**
    * * Field Name: MimeType
    * * Display Name: Mime Type
    * * SQL Data Type: nvarchar(100)
    */
    get MimeType(): string | null {
        return this.Get('MimeType');
    }
    set MimeType(value: string | null) {
        this.Set('MimeType', value);
    }

    /**
    * * Field Name: FileSize
    * * Display Name: File Size
    * * SQL Data Type: bigint
    */
    get FileSize(): number | null {
        return this.Get('FileSize');
    }
    set FileSize(value: number | null) {
        this.Set('FileSize', value);
    }

    /**
    * * Field Name: UploadedByPersonID
    * * Display Name: Uploaded By Person ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Common: People (vwPeople.ID)
    */
    get UploadedByPersonID(): string | null {
        return this.Get('UploadedByPersonID');
    }
    set UploadedByPersonID(value: string | null) {
        this.Set('UploadedByPersonID', value);
    }

    /**
    * * Field Name: __mj_CreatedAt
    * * Display Name: Created At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_CreatedAt(): Date {
        return this.Get('__mj_CreatedAt');
    }

    /**
    * * Field Name: __mj_UpdatedAt
    * * Display Name: Updated At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_UpdatedAt(): Date {
        return this.Get('__mj_UpdatedAt');
    }

    /**
    * * Field Name: Committee
    * * Display Name: Committee
    * * SQL Data Type: nvarchar(200)
    */
    get Committee(): string | null {
        return this.Get('Committee');
    }

    /**
    * * Field Name: Meeting
    * * Display Name: Meeting
    * * SQL Data Type: nvarchar(255)
    */
    get Meeting(): string | null {
        return this.Get('Meeting');
    }

    /**
    * * Field Name: AgendaItem
    * * Display Name: Agenda Item
    * * SQL Data Type: nvarchar(500)
    */
    get AgendaItem(): string | null {
        return this.Get('AgendaItem');
    }

    /**
    * * Field Name: Task
    * * Display Name: Task
    * * SQL Data Type: nvarchar(255)
    */
    get Task(): string | null {
        return this.Get('Task');
    }

    /**
    * * Field Name: ArtifactType
    * * Display Name: Artifact Type
    * * SQL Data Type: nvarchar(100)
    */
    get ArtifactType(): string {
        return this.Get('ArtifactType');
    }

    /**
    * * Field Name: UploadedByPerson
    * * Display Name: Uploaded By Person
    * * SQL Data Type: nvarchar(201)
    */
    get UploadedByPerson(): string | null {
        return this.Get('UploadedByPerson');
    }
}


/**
 * Committees: Ballots - strongly typed entity sub-class
 * * Schema: __mj_BizAppsCommittees
 * * Base Table: Ballot
 * * Base View: vwBallots
 * * @description Between-meeting e-ballot: the voting window for exactly one Motion, with pass threshold and sealed-choice flag. Votes attach to the Motion as ordinary Vote records; while sealed, vote choices are withheld from all consumers until the ballot closes.
 * * Primary Key: ID
 * @extends {BaseEntity}
 * @class
 * @public
 */
@RegisterClass(BaseEntity, 'Committees: Ballots')
export class mjBizAppsCommitteesBallotEntity extends BaseEntity<mjBizAppsCommitteesBallotEntityType> {
    /**
    * Loads the Committees: Ballots record from the database
    * @param ID: string - primary key value to load the Committees: Ballots record.
    * @param EntityRelationshipsToLoad - (optional) the relationships to load
    * @returns {Promise<boolean>} - true if successful, false otherwise
    * @public
    * @async
    * @memberof mjBizAppsCommitteesBallotEntity
    * @method
    * @override
    */
    public async Load(ID: string, EntityRelationshipsToLoad?: string[]) : Promise<boolean> {
        const compositeKey: CompositeKey = new CompositeKey();
        compositeKey.KeyValuePairs.push({ FieldName: 'ID', Value: ID });
        return await super.InnerLoad(compositeKey, EntityRelationshipsToLoad);
    }

    /**
    * Validate() method override for Committees: Ballots entity. This is an auto-generated method that invokes the generated validators for this entity for the following fields:
    * * Table-Level: The closing time must be later than the opening time, ensuring that a voting period cannot end before it starts.
    * @public
    * @method
    * @override
    */
    public override Validate(): ValidationResult {
        const result = super.Validate();
        this.ValidateClosesAtAfterOpensAt(result);
        result.Success = result.Success && (result.Errors.length === 0);

        return result;
    }

    /**
    * The closing time must be later than the opening time, ensuring that a voting period cannot end before it starts.
    * @param result - the ValidationResult object to add any errors or warnings to
    * @public
    * @method
    */
    public ValidateClosesAtAfterOpensAt(result: ValidationResult) {
    	// Both OpensAt and ClosesAt are required fields, but we still guard against unexpected nulls
    	if (this.OpensAt != null && this.ClosesAt != null && !(this.ClosesAt > this.OpensAt)) {
    		result.Errors.push(new ValidationErrorInfo(
    			"ClosesAt",
    			"Closing time must be after opening time.",
    			this.ClosesAt,
    			ValidationErrorType.Failure
    		));
    	}
    }

    /**
    * * Field Name: ID
    * * Display Name: ID
    * * SQL Data Type: uniqueidentifier
    * * Default Value: newsequentialid()
    */
    get ID(): string {
        return this.Get('ID');
    }
    set ID(value: string) {
        this.Set('ID', value);
    }

    /**
    * * Field Name: CommitteeID
    * * Display Name: Committee ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Committees (vwCommittees.ID)
    * * Description: Committee this ballot belongs to; also the committee scope for the ballot's meeting-less Motion
    */
    get CommitteeID(): string {
        return this.Get('CommitteeID');
    }
    set CommitteeID(value: string) {
        this.Set('CommitteeID', value);
    }

    /**
    * * Field Name: MotionID
    * * Display Name: Motion ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Motions (vwMotions.ID)
    * * Description: The Motion this ballot decides — exactly one ballot per motion (unique)
    */
    get MotionID(): string {
        return this.Get('MotionID');
    }
    set MotionID(value: string) {
        this.Set('MotionID', value);
    }

    /**
    * * Field Name: OpensAt
    * * Display Name: Opens At
    * * SQL Data Type: datetimeoffset
    * * Description: When voting opens
    */
    get OpensAt(): Date {
        return this.Get('OpensAt');
    }
    set OpensAt(value: Date) {
        this.Set('OpensAt', value);
    }

    /**
    * * Field Name: ClosesAt
    * * Display Name: Closes At
    * * SQL Data Type: datetimeoffset
    * * Description: Scheduled close of the voting window (UI countdown target)
    */
    get ClosesAt(): Date {
        return this.Get('ClosesAt');
    }
    set ClosesAt(value: Date) {
        this.Set('ClosesAt', value);
    }

    /**
    * * Field Name: ClosedAt
    * * Display Name: Closed At
    * * SQL Data Type: datetimeoffset
    * * Description: When the ballot actually closed (early close or scheduled); NULL while open
    */
    get ClosedAt(): Date | null {
        return this.Get('ClosedAt');
    }
    set ClosedAt(value: Date | null) {
        this.Set('ClosedAt', value);
    }

    /**
    * * Field Name: ThresholdType
    * * Display Name: Threshold Type
    * * SQL Data Type: nvarchar(20)
    * * Default Value: SimpleMajority
    * * Value List Type: List
    * * Possible Values 
    *   * SimpleMajority
    *   * TwoThirds
    *   * Unanimous
    * * Description: Pass threshold measured against the committee's voting members: SimpleMajority, TwoThirds, or Unanimous
    */
    get ThresholdType(): 'SimpleMajority' | 'TwoThirds' | 'Unanimous' {
        return this.Get('ThresholdType');
    }
    set ThresholdType(value: 'SimpleMajority' | 'TwoThirds' | 'Unanimous') {
        this.Set('ThresholdType', value);
    }

    /**
    * * Field Name: IsSealed
    * * Display Name: Is Sealed
    * * SQL Data Type: bit
    * * Default Value: 1
    * * Description: When 1, individual vote choices are withheld from all consumers (including admins) until the ballot closes; participation (who has voted) remains visible
    */
    get IsSealed(): boolean {
        return this.Get('IsSealed');
    }
    set IsSealed(value: boolean) {
        this.Set('IsSealed', value);
    }

    /**
    * * Field Name: Status
    * * Display Name: Status
    * * SQL Data Type: nvarchar(20)
    * * Default Value: Open
    * * Value List Type: List
    * * Possible Values 
    *   * Cancelled
    *   * Closed
    *   * Open
    * * Description: Ballot lifecycle: Open (accepting votes), Closed (result computed, votes unsealed, Motion stamped), Cancelled
    */
    get Status(): 'Cancelled' | 'Closed' | 'Open' {
        return this.Get('Status');
    }
    set Status(value: 'Cancelled' | 'Closed' | 'Open') {
        this.Set('Status', value);
    }

    /**
    * * Field Name: CreatedByMembershipID
    * * Display Name: Created By Membership ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Memberships (vwMemberships.ID)
    * * Description: Membership of the member who opened the ballot (typically the Chair)
    */
    get CreatedByMembershipID(): string | null {
        return this.Get('CreatedByMembershipID');
    }
    set CreatedByMembershipID(value: string | null) {
        this.Set('CreatedByMembershipID', value);
    }

    /**
    * * Field Name: ResultNotes
    * * Display Name: Result Notes
    * * SQL Data Type: nvarchar(MAX)
    * * Description: Certification text recorded at close (result summary, any procedural notes)
    */
    get ResultNotes(): string | null {
        return this.Get('ResultNotes');
    }
    set ResultNotes(value: string | null) {
        this.Set('ResultNotes', value);
    }

    /**
    * * Field Name: __mj_CreatedAt
    * * Display Name: Created At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_CreatedAt(): Date {
        return this.Get('__mj_CreatedAt');
    }

    /**
    * * Field Name: __mj_UpdatedAt
    * * Display Name: Updated At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_UpdatedAt(): Date {
        return this.Get('__mj_UpdatedAt');
    }

    /**
    * * Field Name: Committee
    * * Display Name: Committee
    * * SQL Data Type: nvarchar(200)
    */
    get Committee(): string {
        return this.Get('Committee');
    }

    /**
    * * Field Name: Motion
    * * Display Name: Motion
    * * SQL Data Type: nvarchar(255)
    */
    get Motion(): string {
        return this.Get('Motion');
    }
}


/**
 * Committees: Comments - strongly typed entity sub-class
 * * Schema: __mj_BizAppsCommittees
 * * Base Table: Comment
 * * Base View: vwComments
 * * @description Threaded discussion comments on committee meetings, agenda items, tasks, and documents
 * * Primary Key: ID
 * @extends {BaseEntity}
 * @class
 * @public
 */
@RegisterClass(BaseEntity, 'Committees: Comments')
export class mjBizAppsCommitteesCommentEntity extends BaseEntity<mjBizAppsCommitteesCommentEntityType> {
    /**
    * Loads the Committees: Comments record from the database
    * @param ID: string - primary key value to load the Committees: Comments record.
    * @param EntityRelationshipsToLoad - (optional) the relationships to load
    * @returns {Promise<boolean>} - true if successful, false otherwise
    * @public
    * @async
    * @memberof mjBizAppsCommitteesCommentEntity
    * @method
    * @override
    */
    public async Load(ID: string, EntityRelationshipsToLoad?: string[]) : Promise<boolean> {
        const compositeKey: CompositeKey = new CompositeKey();
        compositeKey.KeyValuePairs.push({ FieldName: 'ID', Value: ID });
        return await super.InnerLoad(compositeKey, EntityRelationshipsToLoad);
    }

    /**
    * * Field Name: ID
    * * Display Name: ID
    * * SQL Data Type: uniqueidentifier
    * * Default Value: newsequentialid()
    */
    get ID(): string {
        return this.Get('ID');
    }
    set ID(value: string) {
        this.Set('ID', value);
    }

    /**
    * * Field Name: CommitteeID
    * * Display Name: Committee ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Committees (vwCommittees.ID)
    */
    get CommitteeID(): string {
        return this.Get('CommitteeID');
    }
    set CommitteeID(value: string) {
        this.Set('CommitteeID', value);
    }

    /**
    * * Field Name: MeetingID
    * * Display Name: Meeting ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Meetings (vwMeetings.ID)
    */
    get MeetingID(): string | null {
        return this.Get('MeetingID');
    }
    set MeetingID(value: string | null) {
        this.Set('MeetingID', value);
    }

    /**
    * * Field Name: AgendaItemID
    * * Display Name: Agenda Item ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Meeting Agenda Items (vwMeetingAgendaItems.ID)
    */
    get AgendaItemID(): string | null {
        return this.Get('AgendaItemID');
    }
    set AgendaItemID(value: string | null) {
        this.Set('AgendaItemID', value);
    }

    /**
    * * Field Name: TaskID
    * * Display Name: Task ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Tasks (vwTasks.ID)
    */
    get TaskID(): string | null {
        return this.Get('TaskID');
    }
    set TaskID(value: string | null) {
        this.Set('TaskID', value);
    }

    /**
    * * Field Name: ArtifactID
    * * Display Name: Artifact ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Artifacts (vwArtifacts.ID)
    */
    get ArtifactID(): string | null {
        return this.Get('ArtifactID');
    }
    set ArtifactID(value: string | null) {
        this.Set('ArtifactID', value);
    }

    /**
    * * Field Name: ParentCommentID
    * * Display Name: Parent Comment ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Comments (vwComments.ID)
    */
    get ParentCommentID(): string | null {
        return this.Get('ParentCommentID');
    }
    set ParentCommentID(value: string | null) {
        this.Set('ParentCommentID', value);
    }

    /**
    * * Field Name: PersonID
    * * Display Name: Person ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Common: People (vwPeople.ID)
    */
    get PersonID(): string {
        return this.Get('PersonID');
    }
    set PersonID(value: string) {
        this.Set('PersonID', value);
    }

    /**
    * * Field Name: CommentText
    * * Display Name: Comment Text
    * * SQL Data Type: nvarchar(MAX)
    */
    get CommentText(): string {
        return this.Get('CommentText');
    }
    set CommentText(value: string) {
        this.Set('CommentText', value);
    }

    /**
    * * Field Name: MentionedPersonIDs
    * * Display Name: Mentioned Person I Ds
    * * SQL Data Type: nvarchar(MAX)
    */
    get MentionedPersonIDs(): string | null {
        return this.Get('MentionedPersonIDs');
    }
    set MentionedPersonIDs(value: string | null) {
        this.Set('MentionedPersonIDs', value);
    }

    /**
    * * Field Name: IsResolved
    * * Display Name: Is Resolved
    * * SQL Data Type: bit
    * * Default Value: 0
    */
    get IsResolved(): boolean {
        return this.Get('IsResolved');
    }
    set IsResolved(value: boolean) {
        this.Set('IsResolved', value);
    }

    /**
    * * Field Name: __mj_CreatedAt
    * * Display Name: Created At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_CreatedAt(): Date {
        return this.Get('__mj_CreatedAt');
    }

    /**
    * * Field Name: __mj_UpdatedAt
    * * Display Name: Updated At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_UpdatedAt(): Date {
        return this.Get('__mj_UpdatedAt');
    }

    /**
    * * Field Name: Committee
    * * Display Name: Committee
    * * SQL Data Type: nvarchar(200)
    */
    get Committee(): string {
        return this.Get('Committee');
    }

    /**
    * * Field Name: Meeting
    * * Display Name: Meeting
    * * SQL Data Type: nvarchar(255)
    */
    get Meeting(): string | null {
        return this.Get('Meeting');
    }

    /**
    * * Field Name: AgendaItem
    * * Display Name: Agenda Item
    * * SQL Data Type: nvarchar(500)
    */
    get AgendaItem(): string | null {
        return this.Get('AgendaItem');
    }

    /**
    * * Field Name: Task
    * * Display Name: Task
    * * SQL Data Type: nvarchar(255)
    */
    get Task(): string | null {
        return this.Get('Task');
    }

    /**
    * * Field Name: Artifact
    * * Display Name: Artifact
    * * SQL Data Type: nvarchar(255)
    */
    get Artifact(): string | null {
        return this.Get('Artifact');
    }

    /**
    * * Field Name: Person
    * * Display Name: Person
    * * SQL Data Type: nvarchar(201)
    */
    get Person(): string {
        return this.Get('Person');
    }

    /**
    * * Field Name: RootParentCommentID
    * * Display Name: Root Parent Comment ID
    * * SQL Data Type: uniqueidentifier
    */
    get RootParentCommentID(): string | null {
        return this.Get('RootParentCommentID');
    }

    /**
    * * Field Name: ParentCommentIDDepth
    * * Display Name: Parent Comment ID Depth
    * * SQL Data Type: int
    */
    get ParentCommentIDDepth(): number | null {
        return this.Get('ParentCommentIDDepth');
    }

    /**
    * * Field Name: ParentCommentIDPath
    * * Display Name: Parent Comment ID Path
    * * SQL Data Type: nvarchar(MAX)
    */
    get ParentCommentIDPath(): string | null {
        return this.Get('ParentCommentIDPath');
    }

    /**
    * * Field Name: ParentCommentIDIsLeaf
    * * Display Name: Parent Comment ID Is Leaf
    * * SQL Data Type: bit
    */
    get ParentCommentIDIsLeaf(): boolean | null {
        return this.Get('ParentCommentIDIsLeaf');
    }

    /**
    * * Field Name: ParentCommentIDChildCount
    * * Display Name: Parent Comment ID Child Count
    * * SQL Data Type: int
    */
    get ParentCommentIDChildCount(): number | null {
        return this.Get('ParentCommentIDChildCount');
    }
}


/**
 * Committees: Committees - strongly typed entity sub-class
 * * Schema: __mj_BizAppsCommittees
 * * Base Table: Committee
 * * Base View: vwCommittees
 * * @description Core committee governance record: an IsA subtype of __mj_BizAppsCollaboration.Space sharing Space.ID.
 * * Primary Key: ID
 * @extends {BaseEntity}
 * @class
 * @public
 */
@RegisterClass(BaseEntity, 'Committees: Committees')
export class mjBizAppsCommitteesCommitteeEntity extends BaseEntity<mjBizAppsCommitteesCommitteeEntityType> {
    /**
    * Loads the Committees: Committees record from the database
    * @param ID: string - primary key value to load the Committees: Committees record.
    * @param EntityRelationshipsToLoad - (optional) the relationships to load
    * @returns {Promise<boolean>} - true if successful, false otherwise
    * @public
    * @async
    * @memberof mjBizAppsCommitteesCommitteeEntity
    * @method
    * @override
    */
    public async Load(ID: string, EntityRelationshipsToLoad?: string[]) : Promise<boolean> {
        const compositeKey: CompositeKey = new CompositeKey();
        compositeKey.KeyValuePairs.push({ FieldName: 'ID', Value: ID });
        return await super.InnerLoad(compositeKey, EntityRelationshipsToLoad);
    }

    /**
    * * Field Name: ID
    * * Display Name: ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Collaboration: Spaces (vwSpaces.ID)
    * * Description: The Collaboration Space this committee specializes (same value as Space.ID).
    */
    get ID(): string {
        return this.Get('ID');
    }
    set ID(value: string) {
        this.Set('ID', value);
    }

    /**
    * * Field Name: TypeID
    * * Display Name: Type ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Types (vwTypes.ID)
    * * Description: Foreign key to committee type classification.
    */
    get TypeID(): string {
        return this.Get('TypeID');
    }
    set TypeID(value: string) {
        this.Set('TypeID', value);
    }

    /**
    * * Field Name: OrganizationID
    * * Display Name: Organization ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Common: Organizations (vwOrganizations.ID)
    * * Description: Foreign key to the sponsoring organization in BizAppsCommon.
    */
    get OrganizationID(): string | null {
        return this.Get('OrganizationID');
    }
    set OrganizationID(value: string | null) {
        this.Set('OrganizationID', value);
    }

    /**
    * * Field Name: CharterDocumentURL
    * * Display Name: Charter Document URL
    * * SQL Data Type: nvarchar(1000)
    * * Description: URL to the committee charter document.
    */
    get CharterDocumentURL(): string | null {
        return this.Get('CharterDocumentURL');
    }
    set CharterDocumentURL(value: string | null) {
        this.Set('CharterDocumentURL', value);
    }

    /**
    * * Field Name: MissionStatement
    * * Display Name: Mission Statement
    * * SQL Data Type: nvarchar(MAX)
    * * Description: Formal mission statement of the committee.
    */
    get MissionStatement(): string | null {
        return this.Get('MissionStatement');
    }
    set MissionStatement(value: string | null) {
        this.Set('MissionStatement', value);
    }

    /**
    * * Field Name: Status
    * * Display Name: Status
    * * SQL Data Type: nvarchar(50)
    * * Default Value: Active
    * * Value List Type: List
    * * Possible Values 
    *   * Active
    *   * Dissolved
    *   * Inactive
    *   * Pending
    * * Description: Lifecycle status: Active, Inactive, Pending, Dissolved.
    */
    get Status(): 'Active' | 'Dissolved' | 'Inactive' | 'Pending' {
        return this.Get('Status');
    }
    set Status(value: 'Active' | 'Dissolved' | 'Inactive' | 'Pending') {
        this.Set('Status', value);
    }

    /**
    * * Field Name: IsPublic
    * * Display Name: Is Public
    * * SQL Data Type: bit
    * * Default Value: 1
    * * Description: Whether the committee is publicly visible (maps to Space.Discoverability Listed vs Hidden).
    */
    get IsPublic(): boolean {
        return this.Get('IsPublic');
    }
    set IsPublic(value: boolean) {
        this.Set('IsPublic', value);
    }

    /**
    * * Field Name: __mj_CreatedAt
    * * Display Name: Created At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_CreatedAt(): Date {
        return this.Get('__mj_CreatedAt');
    }

    /**
    * * Field Name: __mj_UpdatedAt
    * * Display Name: Updated At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_UpdatedAt(): Date {
        return this.Get('__mj_UpdatedAt');
    }

    /**
    * * Field Name: SpaceTypeID
    * * Display Name: Space Type ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Collaboration: Space Types (vwSpaceTypes.ID)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get SpaceTypeID(): string {
        return this.Get('SpaceTypeID');
    }
    set SpaceTypeID(value: string) {
        this.Set('SpaceTypeID', value);
    }

    /**
    * * Field Name: ParentID
    * * Display Name: Parent ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Collaboration: Spaces (vwSpaces.ID)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get ParentID(): string | null {
        return this.Get('ParentID');
    }
    set ParentID(value: string | null) {
        this.Set('ParentID', value);
    }

    /**
    * * Field Name: Name
    * * Display Name: Name
    * * SQL Data Type: nvarchar(200)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get Name(): string {
        return this.Get('Name');
    }
    set Name(value: string) {
        this.Set('Name', value);
    }

    /**
    * * Field Name: Description
    * * Display Name: Description
    * * SQL Data Type: nvarchar(MAX)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get Description(): string | null {
        return this.Get('Description');
    }
    set Description(value: string | null) {
        this.Set('Description', value);
    }

    /**
    * * Field Name: OwnerID
    * * Display Name: Owner ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ: Users (vwUsers.ID)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get OwnerID(): string {
        return this.Get('OwnerID');
    }
    set OwnerID(value: string) {
        this.Set('OwnerID', value);
    }

    /**
    * * Field Name: InheritsMembership
    * * Display Name: Inherits Membership
    * * SQL Data Type: bit
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get InheritsMembership(): boolean {
        return this.Get('InheritsMembership');
    }
    set InheritsMembership(value: boolean) {
        this.Set('InheritsMembership', value);
    }

    /**
    * * Field Name: AgentRetrieval
    * * Display Name: Agent Retrieval
    * * SQL Data Type: nvarchar(30)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get AgentRetrieval(): string {
        return this.Get('AgentRetrieval');
    }
    set AgentRetrieval(value: string) {
        this.Set('AgentRetrieval', value);
    }

    /**
    * * Field Name: StartedAt
    * * Display Name: Started At
    * * SQL Data Type: datetimeoffset
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get StartedAt(): Date | null {
        return this.Get('StartedAt');
    }
    set StartedAt(value: Date | null) {
        this.Set('StartedAt', value);
    }

    /**
    * * Field Name: ClosedAt
    * * Display Name: Closed At
    * * SQL Data Type: datetimeoffset
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get ClosedAt(): Date | null {
        return this.Get('ClosedAt');
    }
    set ClosedAt(value: Date | null) {
        this.Set('ClosedAt', value);
    }

    /**
    * * Field Name: AllowParentAssignees
    * * Display Name: Allow Parent Assignees
    * * SQL Data Type: bit
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get AllowParentAssignees(): boolean {
        return this.Get('AllowParentAssignees');
    }
    set AllowParentAssignees(value: boolean) {
        this.Set('AllowParentAssignees', value);
    }

    /**
    * * Field Name: PlannedCloseAt
    * * Display Name: Planned Close At
    * * SQL Data Type: datetimeoffset
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get PlannedCloseAt(): Date | null {
        return this.Get('PlannedCloseAt');
    }
    set PlannedCloseAt(value: Date | null) {
        this.Set('PlannedCloseAt', value);
    }

    /**
    * * Field Name: IconClass
    * * Display Name: Icon Class
    * * SQL Data Type: nvarchar(100)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get IconClass(): string | null {
        return this.Get('IconClass');
    }
    set IconClass(value: string | null) {
        this.Set('IconClass', value);
    }

    /**
    * * Field Name: Color
    * * Display Name: Color
    * * SQL Data Type: nvarchar(50)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get Color(): string | null {
        return this.Get('Color');
    }
    set Color(value: string | null) {
        this.Set('Color', value);
    }

    /**
    * * Field Name: BackgroundImageURL
    * * Display Name: Background Image URL
    * * SQL Data Type: nvarchar(1000)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get BackgroundImageURL(): string | null {
        return this.Get('BackgroundImageURL');
    }
    set BackgroundImageURL(value: string | null) {
        this.Set('BackgroundImageURL', value);
    }

    /**
    * * Field Name: Configuration
    * * Display Name: Configuration
    * * SQL Data Type: nvarchar(MAX)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get Configuration(): string | null {
        return this.Get('Configuration');
    }
    set Configuration(value: string | null) {
        this.Set('Configuration', value);
    }

    /**
    * * Field Name: StatusID
    * * Display Name: Status ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Collaboration: Space Type Status (vwSpaceTypeStatus.ID)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get StatusID(): string | null {
        return this.Get('StatusID');
    }
    set StatusID(value: string | null) {
        this.Set('StatusID', value);
    }

    /**
    * * Field Name: Type
    * * Display Name: Type
    * * SQL Data Type: nvarchar(100)
    */
    get Type(): string {
        return this.Get('Type');
    }

    /**
    * * Field Name: Organization
    * * Display Name: Organization
    * * SQL Data Type: nvarchar(255)
    */
    get Organization(): string | null {
        return this.Get('Organization');
    }
}


/**
 * Committees: Memberships - strongly typed entity sub-class
 * * Schema: __mj_BizAppsCommittees
 * * Base Table: Membership
 * * Base View: vwMemberships
 * * @description Person assignments to committees with roles and terms
 * * Primary Key: ID
 * @extends {BaseEntity}
 * @class
 * @public
 */
@RegisterClass(BaseEntity, 'Committees: Memberships')
export class mjBizAppsCommitteesMembershipEntity extends BaseEntity<mjBizAppsCommitteesMembershipEntityType> {
    /**
    * Loads the Committees: Memberships record from the database
    * @param ID: string - primary key value to load the Committees: Memberships record.
    * @param EntityRelationshipsToLoad - (optional) the relationships to load
    * @returns {Promise<boolean>} - true if successful, false otherwise
    * @public
    * @async
    * @memberof mjBizAppsCommitteesMembershipEntity
    * @method
    * @override
    */
    public async Load(ID: string, EntityRelationshipsToLoad?: string[]) : Promise<boolean> {
        const compositeKey: CompositeKey = new CompositeKey();
        compositeKey.KeyValuePairs.push({ FieldName: 'ID', Value: ID });
        return await super.InnerLoad(compositeKey, EntityRelationshipsToLoad);
    }

    /**
    * * Field Name: ID
    * * Display Name: ID
    * * SQL Data Type: uniqueidentifier
    * * Default Value: newsequentialid()
    */
    get ID(): string {
        return this.Get('ID');
    }
    set ID(value: string) {
        this.Set('ID', value);
    }

    /**
    * * Field Name: PersonID
    * * Display Name: Person ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Common: People (vwPeople.ID)
    */
    get PersonID(): string {
        return this.Get('PersonID');
    }
    set PersonID(value: string) {
        this.Set('PersonID', value);
    }

    /**
    * * Field Name: RoleID
    * * Display Name: Role ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Roles (vwRoles.ID)
    */
    get RoleID(): string {
        return this.Get('RoleID');
    }
    set RoleID(value: string) {
        this.Set('RoleID', value);
    }

    /**
    * * Field Name: TermID
    * * Display Name: Term ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Terms (vwTerms.ID)
    */
    get TermID(): string {
        return this.Get('TermID');
    }
    set TermID(value: string) {
        this.Set('TermID', value);
    }

    /**
    * * Field Name: StartDate
    * * Display Name: Start Date
    * * SQL Data Type: date
    */
    get StartDate(): Date {
        return this.Get('StartDate');
    }
    set StartDate(value: Date) {
        this.Set('StartDate', value);
    }

    /**
    * * Field Name: EndDate
    * * Display Name: End Date
    * * SQL Data Type: date
    */
    get EndDate(): Date | null {
        return this.Get('EndDate');
    }
    set EndDate(value: Date | null) {
        this.Set('EndDate', value);
    }

    /**
    * * Field Name: Status
    * * Display Name: Status
    * * SQL Data Type: nvarchar(50)
    * * Default Value: Active
    * * Value List Type: List
    * * Possible Values 
    *   * Active
    *   * Ended
    *   * Pending
    *   * Suspended
    */
    get Status(): 'Active' | 'Ended' | 'Pending' | 'Suspended' {
        return this.Get('Status');
    }
    set Status(value: 'Active' | 'Ended' | 'Pending' | 'Suspended') {
        this.Set('Status', value);
    }

    /**
    * * Field Name: EndReason
    * * Display Name: End Reason
    * * SQL Data Type: nvarchar(100)
    */
    get EndReason(): string | null {
        return this.Get('EndReason');
    }
    set EndReason(value: string | null) {
        this.Set('EndReason', value);
    }

    /**
    * * Field Name: Notes
    * * Display Name: Notes
    * * SQL Data Type: nvarchar(MAX)
    */
    get Notes(): string | null {
        return this.Get('Notes');
    }
    set Notes(value: string | null) {
        this.Set('Notes', value);
    }

    /**
    * * Field Name: __mj_CreatedAt
    * * Display Name: Created At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_CreatedAt(): Date {
        return this.Get('__mj_CreatedAt');
    }

    /**
    * * Field Name: __mj_UpdatedAt
    * * Display Name: Updated At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_UpdatedAt(): Date {
        return this.Get('__mj_UpdatedAt');
    }

    /**
    * * Field Name: RenewalIntent
    * * Display Name: Renewal Intent
    * * SQL Data Type: nvarchar(20)
    * * Value List Type: List
    * * Possible Values 
    *   * No
    *   * Undecided
    *   * Yes
    * * Description: The member's stated intent to serve another term (Yes, No, Undecided), captured via Member Home self-service; NULL = not yet answered. Feeds the People & Terms succession pipeline.
    */
    get RenewalIntent(): 'No' | 'Undecided' | 'Yes' | null {
        return this.Get('RenewalIntent');
    }
    set RenewalIntent(value: 'No' | 'Undecided' | 'Yes' | null) {
        this.Set('RenewalIntent', value);
    }

    /**
    * * Field Name: Person
    * * Display Name: Person
    * * SQL Data Type: nvarchar(201)
    */
    get Person(): string {
        return this.Get('Person');
    }

    /**
    * * Field Name: Role
    * * Display Name: Role
    * * SQL Data Type: nvarchar(100)
    */
    get Role(): string {
        return this.Get('Role');
    }

    /**
    * * Field Name: Term
    * * Display Name: Term
    * * SQL Data Type: nvarchar(200)
    */
    get Term(): string {
        return this.Get('Term');
    }
}


/**
 * Committees: Minutes - strongly typed entity sub-class
 * * Schema: __mj_BizAppsCommittees
 * * Base Table: Minute
 * * Base View: vwMinutes
 * * @description Meeting minutes with approval tracking; stored as markdown Content or linked Artifact
 * * Primary Key: ID
 * @extends {BaseEntity}
 * @class
 * @public
 */
@RegisterClass(BaseEntity, 'Committees: Minutes')
export class mjBizAppsCommitteesMinuteEntity extends BaseEntity<mjBizAppsCommitteesMinuteEntityType> {
    /**
    * Loads the Committees: Minutes record from the database
    * @param ID: string - primary key value to load the Committees: Minutes record.
    * @param EntityRelationshipsToLoad - (optional) the relationships to load
    * @returns {Promise<boolean>} - true if successful, false otherwise
    * @public
    * @async
    * @memberof mjBizAppsCommitteesMinuteEntity
    * @method
    * @override
    */
    public async Load(ID: string, EntityRelationshipsToLoad?: string[]) : Promise<boolean> {
        const compositeKey: CompositeKey = new CompositeKey();
        compositeKey.KeyValuePairs.push({ FieldName: 'ID', Value: ID });
        return await super.InnerLoad(compositeKey, EntityRelationshipsToLoad);
    }

    /**
    * * Field Name: ID
    * * Display Name: ID
    * * SQL Data Type: uniqueidentifier
    * * Default Value: newsequentialid()
    */
    get ID(): string {
        return this.Get('ID');
    }
    set ID(value: string) {
        this.Set('ID', value);
    }

    /**
    * * Field Name: ArtifactID
    * * Display Name: Artifact ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Artifacts (vwArtifacts.ID)
    */
    get ArtifactID(): string | null {
        return this.Get('ArtifactID');
    }
    set ArtifactID(value: string | null) {
        this.Set('ArtifactID', value);
    }

    /**
    * * Field Name: MeetingID
    * * Display Name: Meeting ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Meetings (vwMeetings.ID)
    */
    get MeetingID(): string | null {
        return this.Get('MeetingID');
    }
    set MeetingID(value: string | null) {
        this.Set('MeetingID', value);
    }

    /**
    * * Field Name: Content
    * * Display Name: Content
    * * SQL Data Type: nvarchar(MAX)
    */
    get Content(): string | null {
        return this.Get('Content');
    }
    set Content(value: string | null) {
        this.Set('Content', value);
    }

    /**
    * * Field Name: ApprovalStatus
    * * Display Name: Approval Status
    * * SQL Data Type: nvarchar(50)
    * * Default Value: Draft
    * * Value List Type: List
    * * Possible Values 
    *   * Approved
    *   * Draft
    *   * PendingApproval
    *   * Rejected
    */
    get ApprovalStatus(): 'Approved' | 'Draft' | 'PendingApproval' | 'Rejected' {
        return this.Get('ApprovalStatus');
    }
    set ApprovalStatus(value: 'Approved' | 'Draft' | 'PendingApproval' | 'Rejected') {
        this.Set('ApprovalStatus', value);
    }

    /**
    * * Field Name: ApprovedAt
    * * Display Name: Approved At
    * * SQL Data Type: datetimeoffset
    */
    get ApprovedAt(): Date | null {
        return this.Get('ApprovedAt');
    }
    set ApprovedAt(value: Date | null) {
        this.Set('ApprovedAt', value);
    }

    /**
    * * Field Name: ApprovedByMeetingID
    * * Display Name: Approved By Meeting ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Meetings (vwMeetings.ID)
    */
    get ApprovedByMeetingID(): string | null {
        return this.Get('ApprovedByMeetingID');
    }
    set ApprovedByMeetingID(value: string | null) {
        this.Set('ApprovedByMeetingID', value);
    }

    /**
    * * Field Name: Notes
    * * Display Name: Notes
    * * SQL Data Type: nvarchar(MAX)
    */
    get Notes(): string | null {
        return this.Get('Notes');
    }
    set Notes(value: string | null) {
        this.Set('Notes', value);
    }

    /**
    * * Field Name: __mj_CreatedAt
    * * Display Name: Created At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_CreatedAt(): Date {
        return this.Get('__mj_CreatedAt');
    }

    /**
    * * Field Name: __mj_UpdatedAt
    * * Display Name: Updated At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_UpdatedAt(): Date {
        return this.Get('__mj_UpdatedAt');
    }

    /**
    * * Field Name: Artifact
    * * Display Name: Artifact
    * * SQL Data Type: nvarchar(255)
    */
    get Artifact(): string | null {
        return this.Get('Artifact');
    }

    /**
    * * Field Name: Meeting
    * * Display Name: Meeting
    * * SQL Data Type: nvarchar(255)
    */
    get Meeting(): string | null {
        return this.Get('Meeting');
    }

    /**
    * * Field Name: ApprovedByMeeting
    * * Display Name: Approved By Meeting
    * * SQL Data Type: nvarchar(255)
    */
    get ApprovedByMeeting(): string | null {
        return this.Get('ApprovedByMeeting');
    }
}


/**
 * Committees: Motions - strongly typed entity sub-class
 * * Schema: __mj_BizAppsCommittees
 * * Base Table: Motion
 * * Base View: vwMotions
 * * @description Formal motions put to vote during committee meetings
 * * Primary Key: ID
 * @extends {BaseEntity}
 * @class
 * @public
 */
@RegisterClass(BaseEntity, 'Committees: Motions')
export class mjBizAppsCommitteesMotionEntity extends BaseEntity<mjBizAppsCommitteesMotionEntityType> {
    /**
    * Loads the Committees: Motions record from the database
    * @param ID: string - primary key value to load the Committees: Motions record.
    * @param EntityRelationshipsToLoad - (optional) the relationships to load
    * @returns {Promise<boolean>} - true if successful, false otherwise
    * @public
    * @async
    * @memberof mjBizAppsCommitteesMotionEntity
    * @method
    * @override
    */
    public async Load(ID: string, EntityRelationshipsToLoad?: string[]) : Promise<boolean> {
        const compositeKey: CompositeKey = new CompositeKey();
        compositeKey.KeyValuePairs.push({ FieldName: 'ID', Value: ID });
        return await super.InnerLoad(compositeKey, EntityRelationshipsToLoad);
    }

    /**
    * * Field Name: ID
    * * Display Name: ID
    * * SQL Data Type: uniqueidentifier
    * * Default Value: newsequentialid()
    */
    get ID(): string {
        return this.Get('ID');
    }
    set ID(value: string) {
        this.Set('ID', value);
    }

    /**
    * * Field Name: MeetingID
    * * Display Name: Meeting ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Meetings (vwMeetings.ID)
    * * Description: Meeting where the motion was made; NULL for between-meeting e-ballot motions (see Ballot)
    */
    get MeetingID(): string | null {
        return this.Get('MeetingID');
    }
    set MeetingID(value: string | null) {
        this.Set('MeetingID', value);
    }

    /**
    * * Field Name: AgendaItemID
    * * Display Name: Agenda Item ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Tasks: Meeting Agenda Items (vwMeetingAgendaItems.ID)
    */
    get AgendaItemID(): string | null {
        return this.Get('AgendaItemID');
    }
    set AgendaItemID(value: string | null) {
        this.Set('AgendaItemID', value);
    }

    /**
    * * Field Name: Sequence
    * * Display Name: Sequence
    * * SQL Data Type: int
    * * Default Value: 1
    */
    get Sequence(): number {
        return this.Get('Sequence');
    }
    set Sequence(value: number) {
        this.Set('Sequence', value);
    }

    /**
    * * Field Name: Name
    * * Display Name: Name
    * * SQL Data Type: nvarchar(255)
    */
    get Name(): string {
        return this.Get('Name');
    }
    set Name(value: string) {
        this.Set('Name', value);
    }

    /**
    * * Field Name: Description
    * * Display Name: Description
    * * SQL Data Type: nvarchar(MAX)
    */
    get Description(): string | null {
        return this.Get('Description');
    }
    set Description(value: string | null) {
        this.Set('Description', value);
    }

    /**
    * * Field Name: MovedByMembershipID
    * * Display Name: Moved By Membership ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Memberships (vwMemberships.ID)
    */
    get MovedByMembershipID(): string | null {
        return this.Get('MovedByMembershipID');
    }
    set MovedByMembershipID(value: string | null) {
        this.Set('MovedByMembershipID', value);
    }

    /**
    * * Field Name: SecondedByMembershipID
    * * Display Name: Seconded By Membership ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Memberships (vwMemberships.ID)
    */
    get SecondedByMembershipID(): string | null {
        return this.Get('SecondedByMembershipID');
    }
    set SecondedByMembershipID(value: string | null) {
        this.Set('SecondedByMembershipID', value);
    }

    /**
    * * Field Name: Result
    * * Display Name: Result
    * * SQL Data Type: nvarchar(50)
    * * Default Value: Pending
    * * Value List Type: List
    * * Possible Values 
    *   * Failed
    *   * Passed
    *   * Pending
    *   * Tabled
    *   * Withdrawn
    */
    get Result(): 'Failed' | 'Passed' | 'Pending' | 'Tabled' | 'Withdrawn' {
        return this.Get('Result');
    }
    set Result(value: 'Failed' | 'Passed' | 'Pending' | 'Tabled' | 'Withdrawn') {
        this.Set('Result', value);
    }

    /**
    * * Field Name: ResultSummary
    * * Display Name: Result Summary
    * * SQL Data Type: nvarchar(255)
    */
    get ResultSummary(): string | null {
        return this.Get('ResultSummary');
    }
    set ResultSummary(value: string | null) {
        this.Set('ResultSummary', value);
    }

    /**
    * * Field Name: YesCount
    * * Display Name: Yes Count
    * * SQL Data Type: int
    */
    get YesCount(): number | null {
        return this.Get('YesCount');
    }
    set YesCount(value: number | null) {
        this.Set('YesCount', value);
    }

    /**
    * * Field Name: NoCount
    * * Display Name: No Count
    * * SQL Data Type: int
    */
    get NoCount(): number | null {
        return this.Get('NoCount');
    }
    set NoCount(value: number | null) {
        this.Set('NoCount', value);
    }

    /**
    * * Field Name: AbstainCount
    * * Display Name: Abstain Count
    * * SQL Data Type: int
    */
    get AbstainCount(): number | null {
        return this.Get('AbstainCount');
    }
    set AbstainCount(value: number | null) {
        this.Set('AbstainCount', value);
    }

    /**
    * * Field Name: Notes
    * * Display Name: Notes
    * * SQL Data Type: nvarchar(MAX)
    */
    get Notes(): string | null {
        return this.Get('Notes');
    }
    set Notes(value: string | null) {
        this.Set('Notes', value);
    }

    /**
    * * Field Name: __mj_CreatedAt
    * * Display Name: Created At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_CreatedAt(): Date {
        return this.Get('__mj_CreatedAt');
    }

    /**
    * * Field Name: __mj_UpdatedAt
    * * Display Name: Updated At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_UpdatedAt(): Date {
        return this.Get('__mj_UpdatedAt');
    }

    /**
    * * Field Name: Meeting
    * * Display Name: Meeting
    * * SQL Data Type: nvarchar(255)
    */
    get Meeting(): string | null {
        return this.Get('Meeting');
    }

    /**
    * * Field Name: AgendaItem
    * * Display Name: Agenda Item
    * * SQL Data Type: nvarchar(500)
    */
    get AgendaItem(): string | null {
        return this.Get('AgendaItem');
    }
}


/**
 * Committees: Roles - strongly typed entity sub-class
 * * Schema: __mj_BizAppsCommittees
 * * Base Table: Role
 * * Base View: vwRoles
 * * @description Roles that members can hold on committees
 * * Primary Key: ID
 * @extends {BaseEntity}
 * @class
 * @public
 */
@RegisterClass(BaseEntity, 'Committees: Roles')
export class mjBizAppsCommitteesRoleEntity extends BaseEntity<mjBizAppsCommitteesRoleEntityType> {
    /**
    * Loads the Committees: Roles record from the database
    * @param ID: string - primary key value to load the Committees: Roles record.
    * @param EntityRelationshipsToLoad - (optional) the relationships to load
    * @returns {Promise<boolean>} - true if successful, false otherwise
    * @public
    * @async
    * @memberof mjBizAppsCommitteesRoleEntity
    * @method
    * @override
    */
    public async Load(ID: string, EntityRelationshipsToLoad?: string[]) : Promise<boolean> {
        const compositeKey: CompositeKey = new CompositeKey();
        compositeKey.KeyValuePairs.push({ FieldName: 'ID', Value: ID });
        return await super.InnerLoad(compositeKey, EntityRelationshipsToLoad);
    }

    /**
    * * Field Name: ID
    * * Display Name: ID
    * * SQL Data Type: uniqueidentifier
    * * Default Value: newsequentialid()
    */
    get ID(): string {
        return this.Get('ID');
    }
    set ID(value: string) {
        this.Set('ID', value);
    }

    /**
    * * Field Name: Name
    * * Display Name: Name
    * * SQL Data Type: nvarchar(100)
    */
    get Name(): string {
        return this.Get('Name');
    }
    set Name(value: string) {
        this.Set('Name', value);
    }

    /**
    * * Field Name: Description
    * * Display Name: Description
    * * SQL Data Type: nvarchar(MAX)
    */
    get Description(): string | null {
        return this.Get('Description');
    }
    set Description(value: string | null) {
        this.Set('Description', value);
    }

    /**
    * * Field Name: IsOfficer
    * * Display Name: Is Officer
    * * SQL Data Type: bit
    * * Default Value: 0
    */
    get IsOfficer(): boolean {
        return this.Get('IsOfficer');
    }
    set IsOfficer(value: boolean) {
        this.Set('IsOfficer', value);
    }

    /**
    * * Field Name: IsVotingRole
    * * Display Name: Is Voting Role
    * * SQL Data Type: bit
    * * Default Value: 1
    */
    get IsVotingRole(): boolean {
        return this.Get('IsVotingRole');
    }
    set IsVotingRole(value: boolean) {
        this.Set('IsVotingRole', value);
    }

    /**
    * * Field Name: DefaultPermissionsJSON
    * * Display Name: Default Permissions JSON
    * * SQL Data Type: nvarchar(MAX)
    */
    get DefaultPermissionsJSON(): string | null {
        return this.Get('DefaultPermissionsJSON');
    }
    set DefaultPermissionsJSON(value: string | null) {
        this.Set('DefaultPermissionsJSON', value);
    }

    /**
    * * Field Name: Sequence
    * * Display Name: Sequence
    * * SQL Data Type: int
    * * Default Value: 100
    */
    get Sequence(): number {
        return this.Get('Sequence');
    }
    set Sequence(value: number) {
        this.Set('Sequence', value);
    }

    /**
    * * Field Name: __mj_CreatedAt
    * * Display Name: Created At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_CreatedAt(): Date {
        return this.Get('__mj_CreatedAt');
    }

    /**
    * * Field Name: __mj_UpdatedAt
    * * Display Name: Updated At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_UpdatedAt(): Date {
        return this.Get('__mj_UpdatedAt');
    }
}


/**
 * Committees: Terms - strongly typed entity sub-class
 * * Schema: __mj_BizAppsCommittees
 * * Base Table: Term
 * * Base View: vwTerms
 * * @description Committee term cycle: an IsA subtype of __mj_BizAppsCollaboration.Space sharing Space.ID, parented under the Committee Space via Space.ParentID.
 * * Primary Key: ID
 * @extends {BaseEntity}
 * @class
 * @public
 */
@RegisterClass(BaseEntity, 'Committees: Terms')
export class mjBizAppsCommitteesTermEntity extends BaseEntity<mjBizAppsCommitteesTermEntityType> {
    /**
    * Loads the Committees: Terms record from the database
    * @param ID: string - primary key value to load the Committees: Terms record.
    * @param EntityRelationshipsToLoad - (optional) the relationships to load
    * @returns {Promise<boolean>} - true if successful, false otherwise
    * @public
    * @async
    * @memberof mjBizAppsCommitteesTermEntity
    * @method
    * @override
    */
    public async Load(ID: string, EntityRelationshipsToLoad?: string[]) : Promise<boolean> {
        const compositeKey: CompositeKey = new CompositeKey();
        compositeKey.KeyValuePairs.push({ FieldName: 'ID', Value: ID });
        return await super.InnerLoad(compositeKey, EntityRelationshipsToLoad);
    }

    /**
    * * Field Name: ID
    * * Display Name: ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Collaboration: Spaces (vwSpaces.ID)
    * * Description: The Collaboration Space this term specializes (same value as Space.ID).
    */
    get ID(): string {
        return this.Get('ID');
    }
    set ID(value: string) {
        this.Set('ID', value);
    }

    /**
    * * Field Name: Status
    * * Display Name: Status
    * * SQL Data Type: nvarchar(50)
    * * Default Value: Active
    * * Value List Type: List
    * * Possible Values 
    *   * Active
    *   * Completed
    *   * Upcoming
    * * Description: Term status: Active, Upcoming, Completed.
    */
    get Status(): 'Active' | 'Completed' | 'Upcoming' {
        return this.Get('Status');
    }
    set Status(value: 'Active' | 'Completed' | 'Upcoming') {
        this.Set('Status', value);
    }

    /**
    * * Field Name: __mj_CreatedAt
    * * Display Name: Created At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_CreatedAt(): Date {
        return this.Get('__mj_CreatedAt');
    }

    /**
    * * Field Name: __mj_UpdatedAt
    * * Display Name: Updated At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_UpdatedAt(): Date {
        return this.Get('__mj_UpdatedAt');
    }

    /**
    * * Field Name: SpaceTypeID
    * * Display Name: Space Type ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Collaboration: Space Types (vwSpaceTypes.ID)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get SpaceTypeID(): string {
        return this.Get('SpaceTypeID');
    }
    set SpaceTypeID(value: string) {
        this.Set('SpaceTypeID', value);
    }

    /**
    * * Field Name: ParentID
    * * Display Name: Parent ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Collaboration: Spaces (vwSpaces.ID)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get ParentID(): string | null {
        return this.Get('ParentID');
    }
    set ParentID(value: string | null) {
        this.Set('ParentID', value);
    }

    /**
    * * Field Name: Name
    * * Display Name: Name
    * * SQL Data Type: nvarchar(200)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get Name(): string {
        return this.Get('Name');
    }
    set Name(value: string) {
        this.Set('Name', value);
    }

    /**
    * * Field Name: Description
    * * Display Name: Description
    * * SQL Data Type: nvarchar(MAX)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get Description(): string | null {
        return this.Get('Description');
    }
    set Description(value: string | null) {
        this.Set('Description', value);
    }

    /**
    * * Field Name: OwnerID
    * * Display Name: Owner ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ: Users (vwUsers.ID)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get OwnerID(): string {
        return this.Get('OwnerID');
    }
    set OwnerID(value: string) {
        this.Set('OwnerID', value);
    }

    /**
    * * Field Name: InheritsMembership
    * * Display Name: Inherits Membership
    * * SQL Data Type: bit
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get InheritsMembership(): boolean {
        return this.Get('InheritsMembership');
    }
    set InheritsMembership(value: boolean) {
        this.Set('InheritsMembership', value);
    }

    /**
    * * Field Name: AgentRetrieval
    * * Display Name: Agent Retrieval
    * * SQL Data Type: nvarchar(30)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get AgentRetrieval(): string {
        return this.Get('AgentRetrieval');
    }
    set AgentRetrieval(value: string) {
        this.Set('AgentRetrieval', value);
    }

    /**
    * * Field Name: StartedAt
    * * Display Name: Started At
    * * SQL Data Type: datetimeoffset
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get StartedAt(): Date | null {
        return this.Get('StartedAt');
    }
    set StartedAt(value: Date | null) {
        this.Set('StartedAt', value);
    }

    /**
    * * Field Name: ClosedAt
    * * Display Name: Closed At
    * * SQL Data Type: datetimeoffset
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get ClosedAt(): Date | null {
        return this.Get('ClosedAt');
    }
    set ClosedAt(value: Date | null) {
        this.Set('ClosedAt', value);
    }

    /**
    * * Field Name: AllowParentAssignees
    * * Display Name: Allow Parent Assignees
    * * SQL Data Type: bit
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get AllowParentAssignees(): boolean {
        return this.Get('AllowParentAssignees');
    }
    set AllowParentAssignees(value: boolean) {
        this.Set('AllowParentAssignees', value);
    }

    /**
    * * Field Name: PlannedCloseAt
    * * Display Name: Planned Close At
    * * SQL Data Type: datetimeoffset
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get PlannedCloseAt(): Date | null {
        return this.Get('PlannedCloseAt');
    }
    set PlannedCloseAt(value: Date | null) {
        this.Set('PlannedCloseAt', value);
    }

    /**
    * * Field Name: IconClass
    * * Display Name: Icon Class
    * * SQL Data Type: nvarchar(100)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get IconClass(): string | null {
        return this.Get('IconClass');
    }
    set IconClass(value: string | null) {
        this.Set('IconClass', value);
    }

    /**
    * * Field Name: Color
    * * Display Name: Color
    * * SQL Data Type: nvarchar(50)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get Color(): string | null {
        return this.Get('Color');
    }
    set Color(value: string | null) {
        this.Set('Color', value);
    }

    /**
    * * Field Name: BackgroundImageURL
    * * Display Name: Background Image URL
    * * SQL Data Type: nvarchar(1000)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get BackgroundImageURL(): string | null {
        return this.Get('BackgroundImageURL');
    }
    set BackgroundImageURL(value: string | null) {
        this.Set('BackgroundImageURL', value);
    }

    /**
    * * Field Name: Configuration
    * * Display Name: Configuration
    * * SQL Data Type: nvarchar(MAX)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get Configuration(): string | null {
        return this.Get('Configuration');
    }
    set Configuration(value: string | null) {
        this.Set('Configuration', value);
    }

    /**
    * * Field Name: StatusID
    * * Display Name: Status ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Collaboration: Space Type Status (vwSpaceTypeStatus.ID)
    * * IS-A Source: Inherited from MJ_BizApps_Collaboration: Spaces
    */
    get StatusID(): string | null {
        return this.Get('StatusID');
    }
    set StatusID(value: string | null) {
        this.Set('StatusID', value);
    }
}


/**
 * Committees: Types - strongly typed entity sub-class
 * * Schema: __mj_BizAppsCommittees
 * * Base Table: Type
 * * Base View: vwTypes
 * * @description Categories of committees such as Board, Standing, Ad Hoc, Workgroup
 * * Primary Key: ID
 * @extends {BaseEntity}
 * @class
 * @public
 */
@RegisterClass(BaseEntity, 'Committees: Types')
export class mjBizAppsCommitteesTypeEntity extends BaseEntity<mjBizAppsCommitteesTypeEntityType> {
    /**
    * Loads the Committees: Types record from the database
    * @param ID: string - primary key value to load the Committees: Types record.
    * @param EntityRelationshipsToLoad - (optional) the relationships to load
    * @returns {Promise<boolean>} - true if successful, false otherwise
    * @public
    * @async
    * @memberof mjBizAppsCommitteesTypeEntity
    * @method
    * @override
    */
    public async Load(ID: string, EntityRelationshipsToLoad?: string[]) : Promise<boolean> {
        const compositeKey: CompositeKey = new CompositeKey();
        compositeKey.KeyValuePairs.push({ FieldName: 'ID', Value: ID });
        return await super.InnerLoad(compositeKey, EntityRelationshipsToLoad);
    }

    /**
    * * Field Name: ID
    * * Display Name: ID
    * * SQL Data Type: uniqueidentifier
    * * Default Value: newsequentialid()
    */
    get ID(): string {
        return this.Get('ID');
    }
    set ID(value: string) {
        this.Set('ID', value);
    }

    /**
    * * Field Name: Name
    * * Display Name: Name
    * * SQL Data Type: nvarchar(100)
    */
    get Name(): string {
        return this.Get('Name');
    }
    set Name(value: string) {
        this.Set('Name', value);
    }

    /**
    * * Field Name: Description
    * * Display Name: Description
    * * SQL Data Type: nvarchar(MAX)
    */
    get Description(): string | null {
        return this.Get('Description');
    }
    set Description(value: string | null) {
        this.Set('Description', value);
    }

    /**
    * * Field Name: IsStandards
    * * Display Name: Is Standards
    * * SQL Data Type: bit
    * * Default Value: 0
    */
    get IsStandards(): boolean {
        return this.Get('IsStandards');
    }
    set IsStandards(value: boolean) {
        this.Set('IsStandards', value);
    }

    /**
    * * Field Name: DefaultTermMonths
    * * Display Name: Default Term Months
    * * SQL Data Type: int
    */
    get DefaultTermMonths(): number | null {
        return this.Get('DefaultTermMonths');
    }
    set DefaultTermMonths(value: number | null) {
        this.Set('DefaultTermMonths', value);
    }

    /**
    * * Field Name: IconClass
    * * Display Name: Icon Class
    * * SQL Data Type: nvarchar(100)
    */
    get IconClass(): string | null {
        return this.Get('IconClass');
    }
    set IconClass(value: string | null) {
        this.Set('IconClass', value);
    }

    /**
    * * Field Name: __mj_CreatedAt
    * * Display Name: Created At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_CreatedAt(): Date {
        return this.Get('__mj_CreatedAt');
    }

    /**
    * * Field Name: __mj_UpdatedAt
    * * Display Name: Updated At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_UpdatedAt(): Date {
        return this.Get('__mj_UpdatedAt');
    }
}


/**
 * Committees: Votes - strongly typed entity sub-class
 * * Schema: __mj_BizAppsCommittees
 * * Base Table: Vote
 * * Base View: vwVotes
 * * @description Individual vote records for committee motions
 * * Primary Key: ID
 * @extends {BaseEntity}
 * @class
 * @public
 */
@RegisterClass(BaseEntity, 'Committees: Votes')
export class mjBizAppsCommitteesVoteEntity extends BaseEntity<mjBizAppsCommitteesVoteEntityType> {
    /**
    * Loads the Committees: Votes record from the database
    * @param ID: string - primary key value to load the Committees: Votes record.
    * @param EntityRelationshipsToLoad - (optional) the relationships to load
    * @returns {Promise<boolean>} - true if successful, false otherwise
    * @public
    * @async
    * @memberof mjBizAppsCommitteesVoteEntity
    * @method
    * @override
    */
    public async Load(ID: string, EntityRelationshipsToLoad?: string[]) : Promise<boolean> {
        const compositeKey: CompositeKey = new CompositeKey();
        compositeKey.KeyValuePairs.push({ FieldName: 'ID', Value: ID });
        return await super.InnerLoad(compositeKey, EntityRelationshipsToLoad);
    }

    /**
    * * Field Name: ID
    * * Display Name: ID
    * * SQL Data Type: uniqueidentifier
    * * Default Value: newsequentialid()
    */
    get ID(): string {
        return this.Get('ID');
    }
    set ID(value: string) {
        this.Set('ID', value);
    }

    /**
    * * Field Name: MotionID
    * * Display Name: Motion ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Motions (vwMotions.ID)
    */
    get MotionID(): string {
        return this.Get('MotionID');
    }
    set MotionID(value: string) {
        this.Set('MotionID', value);
    }

    /**
    * * Field Name: MembershipID
    * * Display Name: Membership ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Memberships (vwMemberships.ID)
    */
    get MembershipID(): string {
        return this.Get('MembershipID');
    }
    set MembershipID(value: string) {
        this.Set('MembershipID', value);
    }

    /**
    * * Field Name: VoteValue
    * * Display Name: Vote Value
    * * SQL Data Type: nvarchar(20)
    * * Value List Type: List
    * * Possible Values 
    *   * Absent
    *   * Abstain
    *   * No
    *   * Yes
    */
    get VoteValue(): 'Absent' | 'Abstain' | 'No' | 'Yes' {
        return this.Get('VoteValue');
    }
    set VoteValue(value: 'Absent' | 'Abstain' | 'No' | 'Yes') {
        this.Set('VoteValue', value);
    }

    /**
    * * Field Name: Notes
    * * Display Name: Notes
    * * SQL Data Type: nvarchar(500)
    */
    get Notes(): string | null {
        return this.Get('Notes');
    }
    set Notes(value: string | null) {
        this.Set('Notes', value);
    }

    /**
    * * Field Name: __mj_CreatedAt
    * * Display Name: Created At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_CreatedAt(): Date {
        return this.Get('__mj_CreatedAt');
    }

    /**
    * * Field Name: __mj_UpdatedAt
    * * Display Name: Updated At
    * * SQL Data Type: datetimeoffset
    * * Default Value: getutcdate()
    */
    get __mj_UpdatedAt(): Date {
        return this.Get('__mj_UpdatedAt');
    }

    /**
    * * Field Name: Motion
    * * Display Name: Motion
    * * SQL Data Type: nvarchar(255)
    */
    get Motion(): string {
        return this.Get('Motion');
    }
}
