import { BaseEntity, EntitySaveOptions, EntityDeleteOptions, CompositeKey, ValidationResult, ValidationErrorInfo, ValidationErrorType, Metadata, ProviderType, DatabaseProviderBase } from "@memberjunction/core";
import { RegisterClass } from "@memberjunction/global";
import { z } from "zod";

export const loadModule = () => {
  // no-op, only used to ensure this file is a valid module and to allow easy loading
}

     
 
/**
 * zod schema definition for the entity Committees: Agenda Items
 */
export const mjBizAppsCommitteesAgendaItemSchema = z.object({
    ID: z.string().describe(`
        * * Field Name: ID
        * * Display Name: ID
        * * SQL Data Type: uniqueidentifier
        * * Default Value: newsequentialid()`),
    MeetingID: z.string().describe(`
        * * Field Name: MeetingID
        * * Display Name: Meeting ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Meetings (vwMeetings.ID)`),
    ParentAgendaItemID: z.string().nullable().describe(`
        * * Field Name: ParentAgendaItemID
        * * Display Name: Parent Agenda Item ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Agenda Items (vwAgendaItems.ID)`),
    Sequence: z.number().describe(`
        * * Field Name: Sequence
        * * Display Name: Sequence
        * * SQL Data Type: int`),
    Name: z.string().describe(`
        * * Field Name: Name
        * * Display Name: Name
        * * SQL Data Type: nvarchar(255)`),
    Description: z.string().nullable().describe(`
        * * Field Name: Description
        * * Display Name: Description
        * * SQL Data Type: nvarchar(MAX)`),
    PresenterPersonID: z.string().nullable().describe(`
        * * Field Name: PresenterPersonID
        * * Display Name: Presenter Person ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Common: People (vwPeople.ID)`),
    DurationMinutes: z.number().nullable().describe(`
        * * Field Name: DurationMinutes
        * * Display Name: Duration Minutes
        * * SQL Data Type: int`),
    ItemType: z.union([z.literal('Action'), z.literal('Discussion'), z.literal('Information'), z.literal('Other'), z.literal('Report'), z.literal('Vote')]).describe(`
        * * Field Name: ItemType
        * * Display Name: Item Type
        * * SQL Data Type: nvarchar(50)
        * * Default Value: Discussion
    * * Value List Type: List
    * * Possible Values 
    *   * Action
    *   * Discussion
    *   * Information
    *   * Other
    *   * Report
    *   * Vote`),
    RelatedDocumentURL: z.string().nullable().describe(`
        * * Field Name: RelatedDocumentURL
        * * Display Name: Related Document URL
        * * SQL Data Type: nvarchar(1000)`),
    Status: z.union([z.literal('Completed'), z.literal('Discussed'), z.literal('Pending'), z.literal('Skipped'), z.literal('Tabled')]).describe(`
        * * Field Name: Status
        * * Display Name: Status
        * * SQL Data Type: nvarchar(50)
        * * Default Value: Pending
    * * Value List Type: List
    * * Possible Values 
    *   * Completed
    *   * Discussed
    *   * Pending
    *   * Skipped
    *   * Tabled`),
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
    Meeting: z.string().describe(`
        * * Field Name: Meeting
        * * Display Name: Meeting
        * * SQL Data Type: nvarchar(255)`),
    ParentAgendaItem: z.string().nullable().describe(`
        * * Field Name: ParentAgendaItem
        * * Display Name: Parent Agenda Item
        * * SQL Data Type: nvarchar(255)`),
    PresenterPerson: z.string().nullable().describe(`
        * * Field Name: PresenterPerson
        * * Display Name: Presenter Person
        * * SQL Data Type: nvarchar(201)`),
    RootParentAgendaItemID: z.string().nullable().describe(`
        * * Field Name: RootParentAgendaItemID
        * * Display Name: Root Parent Agenda Item ID
        * * SQL Data Type: uniqueidentifier`),
});

export type mjBizAppsCommitteesAgendaItemEntityType = z.infer<typeof mjBizAppsCommitteesAgendaItemSchema>;

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
        * * Related Entity/Foreign Key: Committees: Meetings (vwMeetings.ID)`),
    AgendaItemID: z.string().nullable().describe(`
        * * Field Name: AgendaItemID
        * * Display Name: Agenda Item ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Agenda Items (vwAgendaItems.ID)`),
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
        * * SQL Data Type: nvarchar(255)`),
    Meeting: z.string().nullable().describe(`
        * * Field Name: Meeting
        * * Display Name: Meeting
        * * SQL Data Type: nvarchar(255)`),
    AgendaItem: z.string().nullable().describe(`
        * * Field Name: AgendaItem
        * * Display Name: Agenda Item
        * * SQL Data Type: nvarchar(255)`),
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
 * zod schema definition for the entity Committees: Attendances
 */
export const mjBizAppsCommitteesAttendanceSchema = z.object({
    ID: z.string().describe(`
        * * Field Name: ID
        * * Display Name: ID
        * * SQL Data Type: uniqueidentifier
        * * Default Value: newsequentialid()`),
    MeetingID: z.string().describe(`
        * * Field Name: MeetingID
        * * Display Name: Meeting ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Meetings (vwMeetings.ID)`),
    PersonID: z.string().describe(`
        * * Field Name: PersonID
        * * Display Name: Person ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Common: People (vwPeople.ID)`),
    AttendanceStatus: z.union([z.literal('Absent'), z.literal('Excused'), z.literal('Expected'), z.literal('Partial'), z.literal('Present')]).describe(`
        * * Field Name: AttendanceStatus
        * * Display Name: Attendance Status
        * * SQL Data Type: nvarchar(50)
        * * Default Value: Expected
    * * Value List Type: List
    * * Possible Values 
    *   * Absent
    *   * Excused
    *   * Expected
    *   * Partial
    *   * Present`),
    JoinedAt: z.date().nullable().describe(`
        * * Field Name: JoinedAt
        * * Display Name: Joined At
        * * SQL Data Type: datetimeoffset`),
    LeftAt: z.date().nullable().describe(`
        * * Field Name: LeftAt
        * * Display Name: Left At
        * * SQL Data Type: datetimeoffset`),
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
    Meeting: z.string().describe(`
        * * Field Name: Meeting
        * * Display Name: Meeting
        * * SQL Data Type: nvarchar(255)`),
    Person: z.string().describe(`
        * * Field Name: Person
        * * Display Name: Person
        * * SQL Data Type: nvarchar(201)`),
});

export type mjBizAppsCommitteesAttendanceEntityType = z.infer<typeof mjBizAppsCommitteesAttendanceSchema>;

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
        * * SQL Data Type: nvarchar(255)`),
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
        * * Related Entity/Foreign Key: Committees: Meetings (vwMeetings.ID)`),
    AgendaItemID: z.string().nullable().describe(`
        * * Field Name: AgendaItemID
        * * Display Name: Agenda Item ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Agenda Items (vwAgendaItems.ID)`),
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
        * * SQL Data Type: nvarchar(255)`),
    Meeting: z.string().nullable().describe(`
        * * Field Name: Meeting
        * * Display Name: Meeting
        * * SQL Data Type: nvarchar(255)`),
    AgendaItem: z.string().nullable().describe(`
        * * Field Name: AgendaItem
        * * Display Name: Agenda Item
        * * SQL Data Type: nvarchar(255)`),
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
        * * Default Value: newsequentialid()`),
    Name: z.string().describe(`
        * * Field Name: Name
        * * Display Name: Name
        * * SQL Data Type: nvarchar(255)`),
    Description: z.string().nullable().describe(`
        * * Field Name: Description
        * * Display Name: Description
        * * SQL Data Type: nvarchar(MAX)`),
    TypeID: z.string().describe(`
        * * Field Name: TypeID
        * * Display Name: Type ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Types (vwTypes.ID)`),
    ParentCommitteeID: z.string().nullable().describe(`
        * * Field Name: ParentCommitteeID
        * * Display Name: Parent Committee ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Committees (vwCommittees.ID)`),
    OrganizationID: z.string().nullable().describe(`
        * * Field Name: OrganizationID
        * * Display Name: Organization ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ_BizApps_Common: Organizations (vwOrganizations.ID)`),
    CharterDocumentURL: z.string().nullable().describe(`
        * * Field Name: CharterDocumentURL
        * * Display Name: Charter Document URL
        * * SQL Data Type: nvarchar(1000)`),
    MissionStatement: z.string().nullable().describe(`
        * * Field Name: MissionStatement
        * * Display Name: Mission Statement
        * * SQL Data Type: nvarchar(MAX)`),
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
    *   * Pending`),
    IsPublic: z.boolean().describe(`
        * * Field Name: IsPublic
        * * Display Name: Is Public
        * * SQL Data Type: bit
        * * Default Value: 1`),
    FormationDate: z.date().nullable().describe(`
        * * Field Name: FormationDate
        * * Display Name: Formation Date
        * * SQL Data Type: date`),
    DissolutionDate: z.date().nullable().describe(`
        * * Field Name: DissolutionDate
        * * Display Name: Dissolution Date
        * * SQL Data Type: date`),
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
    Type: z.string().describe(`
        * * Field Name: Type
        * * Display Name: Type
        * * SQL Data Type: nvarchar(100)`),
    ParentCommittee: z.string().nullable().describe(`
        * * Field Name: ParentCommittee
        * * Display Name: Parent Committee
        * * SQL Data Type: nvarchar(255)`),
    Organization: z.string().nullable().describe(`
        * * Field Name: Organization
        * * Display Name: Organization
        * * SQL Data Type: nvarchar(255)`),
    RootParentCommitteeID: z.string().nullable().describe(`
        * * Field Name: RootParentCommitteeID
        * * Display Name: Root Parent Committee ID
        * * SQL Data Type: uniqueidentifier`),
});

export type mjBizAppsCommitteesCommitteeEntityType = z.infer<typeof mjBizAppsCommitteesCommitteeSchema>;

/**
 * zod schema definition for the entity Committees: Meetings
 */
export const mjBizAppsCommitteesMeetingSchema = z.object({
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
    Name: z.string().describe(`
        * * Field Name: Name
        * * Display Name: Name
        * * SQL Data Type: nvarchar(255)`),
    Description: z.string().nullable().describe(`
        * * Field Name: Description
        * * Display Name: Description
        * * SQL Data Type: nvarchar(MAX)`),
    StartDateTime: z.date().describe(`
        * * Field Name: StartDateTime
        * * Display Name: Start Date Time
        * * SQL Data Type: datetimeoffset`),
    EndDateTime: z.date().nullable().describe(`
        * * Field Name: EndDateTime
        * * Display Name: End Date Time
        * * SQL Data Type: datetimeoffset`),
    TimeZone: z.string().describe(`
        * * Field Name: TimeZone
        * * Display Name: Time Zone
        * * SQL Data Type: nvarchar(50)
        * * Default Value: America/New_York`),
    LocationType: z.union([z.literal('Hybrid'), z.literal('InPerson'), z.literal('Virtual')]).describe(`
        * * Field Name: LocationType
        * * Display Name: Location Type
        * * SQL Data Type: nvarchar(50)
        * * Default Value: Virtual
    * * Value List Type: List
    * * Possible Values 
    *   * Hybrid
    *   * InPerson
    *   * Virtual`),
    LocationText: z.string().nullable().describe(`
        * * Field Name: LocationText
        * * Display Name: Location Text
        * * SQL Data Type: nvarchar(500)`),
    VideoProvider: z.string().nullable().describe(`
        * * Field Name: VideoProvider
        * * Display Name: Video Provider
        * * SQL Data Type: nvarchar(50)`),
    VideoProviderID: z.string().nullable().describe(`
        * * Field Name: VideoProviderID
        * * Display Name: Video Provider ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Video Providers (vwVideoProviders.ID)`),
    VideoMeetingID: z.string().nullable().describe(`
        * * Field Name: VideoMeetingID
        * * Display Name: Video Meeting ID
        * * SQL Data Type: nvarchar(255)`),
    VideoJoinURL: z.string().nullable().describe(`
        * * Field Name: VideoJoinURL
        * * Display Name: Video Join URL
        * * SQL Data Type: nvarchar(1000)`),
    VideoRecordingURL: z.string().nullable().describe(`
        * * Field Name: VideoRecordingURL
        * * Display Name: Video Recording URL
        * * SQL Data Type: nvarchar(1000)`),
    TranscriptURL: z.string().nullable().describe(`
        * * Field Name: TranscriptURL
        * * Display Name: Transcript URL
        * * SQL Data Type: nvarchar(1000)`),
    Status: z.union([z.literal('Cancelled'), z.literal('Completed'), z.literal('Draft'), z.literal('InProgress'), z.literal('Postponed'), z.literal('Scheduled')]).describe(`
        * * Field Name: Status
        * * Display Name: Status
        * * SQL Data Type: nvarchar(50)
        * * Default Value: Scheduled
    * * Value List Type: List
    * * Possible Values 
    *   * Cancelled
    *   * Completed
    *   * Draft
    *   * InProgress
    *   * Postponed
    *   * Scheduled`),
    CalendarEventID: z.string().nullable().describe(`
        * * Field Name: CalendarEventID
        * * Display Name: Calendar Event ID
        * * SQL Data Type: nvarchar(255)`),
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
        * * SQL Data Type: nvarchar(255)`),
    VideoProvider_Virtual: z.string().nullable().describe(`
        * * Field Name: VideoProvider_Virtual
        * * Display Name: Video Provider Virtual
        * * SQL Data Type: nvarchar(100)`),
});

export type mjBizAppsCommitteesMeetingEntityType = z.infer<typeof mjBizAppsCommitteesMeetingSchema>;

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
        * * SQL Data Type: nvarchar(100)`),
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
        * * Related Entity/Foreign Key: Committees: Meetings (vwMeetings.ID)`),
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
        * * Related Entity/Foreign Key: Committees: Meetings (vwMeetings.ID)`),
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
        * * Related Entity/Foreign Key: Committees: Meetings (vwMeetings.ID)
        * * Description: Meeting where the motion was made; NULL for between-meeting e-ballot motions (see Ballot)`),
    AgendaItemID: z.string().nullable().describe(`
        * * Field Name: AgendaItemID
        * * Display Name: Agenda Item ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Agenda Items (vwAgendaItems.ID)`),
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
        * * SQL Data Type: nvarchar(255)`),
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
        * * Default Value: newsequentialid()`),
    CommitteeID: z.string().describe(`
        * * Field Name: CommitteeID
        * * Display Name: Committee ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: Committees: Committees (vwCommittees.ID)`),
    Name: z.string().describe(`
        * * Field Name: Name
        * * Display Name: Name
        * * SQL Data Type: nvarchar(100)`),
    StartDate: z.date().describe(`
        * * Field Name: StartDate
        * * Display Name: Start Date
        * * SQL Data Type: date`),
    EndDate: z.date().nullable().describe(`
        * * Field Name: EndDate
        * * Display Name: End Date
        * * SQL Data Type: date`),
    Status: z.union([z.literal('Active'), z.literal('Completed'), z.literal('Upcoming')]).describe(`
        * * Field Name: Status
        * * Display Name: Status
        * * SQL Data Type: nvarchar(50)
        * * Default Value: Active
    * * Value List Type: List
    * * Possible Values 
    *   * Active
    *   * Completed
    *   * Upcoming`),
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
        * * SQL Data Type: nvarchar(255)`),
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
 * zod schema definition for the entity Committees: Video Providers
 */
export const mjBizAppsCommitteesVideoProviderSchema = z.object({
    ID: z.string().describe(`
        * * Field Name: ID
        * * Display Name: ID
        * * SQL Data Type: uniqueidentifier
        * * Default Value: newsequentialid()`),
    Name: z.string().describe(`
        * * Field Name: Name
        * * Display Name: Name
        * * SQL Data Type: nvarchar(100)`),
    ServerDriverKey: z.string().describe(`
        * * Field Name: ServerDriverKey
        * * Display Name: Server Driver Key
        * * SQL Data Type: nvarchar(100)`),
    IsActive: z.boolean().describe(`
        * * Field Name: IsActive
        * * Display Name: Is Active
        * * SQL Data Type: bit
        * * Default Value: 1`),
    IsDefault: z.boolean().describe(`
        * * Field Name: IsDefault
        * * Display Name: Is Default
        * * SQL Data Type: bit
        * * Default Value: 0`),
    CredentialID: z.string().nullable().describe(`
        * * Field Name: CredentialID
        * * Display Name: Credential ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ: Credentials (vwCredentials.ID)`),
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
    Credential: z.string().nullable().describe(`
        * * Field Name: Credential
        * * Display Name: Credential
        * * SQL Data Type: nvarchar(200)`),
});

export type mjBizAppsCommitteesVideoProviderEntityType = z.infer<typeof mjBizAppsCommitteesVideoProviderSchema>;

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
 * Committees: Agenda Items - strongly typed entity sub-class
 * * Schema: __mj_BizAppsCommittees
 * * Base Table: AgendaItem
 * * Base View: vwAgendaItems
 * * @description Structured agenda items for meetings with hierarchy support
 * * Primary Key: ID
 * @extends {BaseEntity}
 * @class
 * @public
 */
@RegisterClass(BaseEntity, 'Committees: Agenda Items')
export class mjBizAppsCommitteesAgendaItemEntity extends BaseEntity<mjBizAppsCommitteesAgendaItemEntityType> {
    /**
    * Loads the Committees: Agenda Items record from the database
    * @param ID: string - primary key value to load the Committees: Agenda Items record.
    * @param EntityRelationshipsToLoad - (optional) the relationships to load
    * @returns {Promise<boolean>} - true if successful, false otherwise
    * @public
    * @async
    * @memberof mjBizAppsCommitteesAgendaItemEntity
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
    * * Related Entity/Foreign Key: Committees: Meetings (vwMeetings.ID)
    */
    get MeetingID(): string {
        return this.Get('MeetingID');
    }
    set MeetingID(value: string) {
        this.Set('MeetingID', value);
    }

    /**
    * * Field Name: ParentAgendaItemID
    * * Display Name: Parent Agenda Item ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Agenda Items (vwAgendaItems.ID)
    */
    get ParentAgendaItemID(): string | null {
        return this.Get('ParentAgendaItemID');
    }
    set ParentAgendaItemID(value: string | null) {
        this.Set('ParentAgendaItemID', value);
    }

    /**
    * * Field Name: Sequence
    * * Display Name: Sequence
    * * SQL Data Type: int
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
    * * Field Name: PresenterPersonID
    * * Display Name: Presenter Person ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Common: People (vwPeople.ID)
    */
    get PresenterPersonID(): string | null {
        return this.Get('PresenterPersonID');
    }
    set PresenterPersonID(value: string | null) {
        this.Set('PresenterPersonID', value);
    }

    /**
    * * Field Name: DurationMinutes
    * * Display Name: Duration Minutes
    * * SQL Data Type: int
    */
    get DurationMinutes(): number | null {
        return this.Get('DurationMinutes');
    }
    set DurationMinutes(value: number | null) {
        this.Set('DurationMinutes', value);
    }

    /**
    * * Field Name: ItemType
    * * Display Name: Item Type
    * * SQL Data Type: nvarchar(50)
    * * Default Value: Discussion
    * * Value List Type: List
    * * Possible Values 
    *   * Action
    *   * Discussion
    *   * Information
    *   * Other
    *   * Report
    *   * Vote
    */
    get ItemType(): 'Action' | 'Discussion' | 'Information' | 'Other' | 'Report' | 'Vote' {
        return this.Get('ItemType');
    }
    set ItemType(value: 'Action' | 'Discussion' | 'Information' | 'Other' | 'Report' | 'Vote') {
        this.Set('ItemType', value);
    }

    /**
    * * Field Name: RelatedDocumentURL
    * * Display Name: Related Document URL
    * * SQL Data Type: nvarchar(1000)
    */
    get RelatedDocumentURL(): string | null {
        return this.Get('RelatedDocumentURL');
    }
    set RelatedDocumentURL(value: string | null) {
        this.Set('RelatedDocumentURL', value);
    }

    /**
    * * Field Name: Status
    * * Display Name: Status
    * * SQL Data Type: nvarchar(50)
    * * Default Value: Pending
    * * Value List Type: List
    * * Possible Values 
    *   * Completed
    *   * Discussed
    *   * Pending
    *   * Skipped
    *   * Tabled
    */
    get Status(): 'Completed' | 'Discussed' | 'Pending' | 'Skipped' | 'Tabled' {
        return this.Get('Status');
    }
    set Status(value: 'Completed' | 'Discussed' | 'Pending' | 'Skipped' | 'Tabled') {
        this.Set('Status', value);
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
    get Meeting(): string {
        return this.Get('Meeting');
    }

    /**
    * * Field Name: ParentAgendaItem
    * * Display Name: Parent Agenda Item
    * * SQL Data Type: nvarchar(255)
    */
    get ParentAgendaItem(): string | null {
        return this.Get('ParentAgendaItem');
    }

    /**
    * * Field Name: PresenterPerson
    * * Display Name: Presenter Person
    * * SQL Data Type: nvarchar(201)
    */
    get PresenterPerson(): string | null {
        return this.Get('PresenterPerson');
    }

    /**
    * * Field Name: RootParentAgendaItemID
    * * Display Name: Root Parent Agenda Item ID
    * * SQL Data Type: uniqueidentifier
    */
    get RootParentAgendaItemID(): string | null {
        return this.Get('RootParentAgendaItemID');
    }
}


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
    * * Related Entity/Foreign Key: Committees: Meetings (vwMeetings.ID)
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
    * * Related Entity/Foreign Key: Committees: Agenda Items (vwAgendaItems.ID)
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
    * * SQL Data Type: nvarchar(255)
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
    * * SQL Data Type: nvarchar(255)
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
 * Committees: Attendances - strongly typed entity sub-class
 * * Schema: __mj_BizAppsCommittees
 * * Base Table: Attendance
 * * Base View: vwAttendances
 * * @description Meeting attendance records for committee members
 * * Primary Key: ID
 * @extends {BaseEntity}
 * @class
 * @public
 */
@RegisterClass(BaseEntity, 'Committees: Attendances')
export class mjBizAppsCommitteesAttendanceEntity extends BaseEntity<mjBizAppsCommitteesAttendanceEntityType> {
    /**
    * Loads the Committees: Attendances record from the database
    * @param ID: string - primary key value to load the Committees: Attendances record.
    * @param EntityRelationshipsToLoad - (optional) the relationships to load
    * @returns {Promise<boolean>} - true if successful, false otherwise
    * @public
    * @async
    * @memberof mjBizAppsCommitteesAttendanceEntity
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
    * * Related Entity/Foreign Key: Committees: Meetings (vwMeetings.ID)
    */
    get MeetingID(): string {
        return this.Get('MeetingID');
    }
    set MeetingID(value: string) {
        this.Set('MeetingID', value);
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
    * * Field Name: AttendanceStatus
    * * Display Name: Attendance Status
    * * SQL Data Type: nvarchar(50)
    * * Default Value: Expected
    * * Value List Type: List
    * * Possible Values 
    *   * Absent
    *   * Excused
    *   * Expected
    *   * Partial
    *   * Present
    */
    get AttendanceStatus(): 'Absent' | 'Excused' | 'Expected' | 'Partial' | 'Present' {
        return this.Get('AttendanceStatus');
    }
    set AttendanceStatus(value: 'Absent' | 'Excused' | 'Expected' | 'Partial' | 'Present') {
        this.Set('AttendanceStatus', value);
    }

    /**
    * * Field Name: JoinedAt
    * * Display Name: Joined At
    * * SQL Data Type: datetimeoffset
    */
    get JoinedAt(): Date | null {
        return this.Get('JoinedAt');
    }
    set JoinedAt(value: Date | null) {
        this.Set('JoinedAt', value);
    }

    /**
    * * Field Name: LeftAt
    * * Display Name: Left At
    * * SQL Data Type: datetimeoffset
    */
    get LeftAt(): Date | null {
        return this.Get('LeftAt');
    }
    set LeftAt(value: Date | null) {
        this.Set('LeftAt', value);
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
    * * Field Name: Meeting
    * * Display Name: Meeting
    * * SQL Data Type: nvarchar(255)
    */
    get Meeting(): string {
        return this.Get('Meeting');
    }

    /**
    * * Field Name: Person
    * * Display Name: Person
    * * SQL Data Type: nvarchar(201)
    */
    get Person(): string {
        return this.Get('Person');
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
    * * SQL Data Type: nvarchar(255)
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
    * * Related Entity/Foreign Key: Committees: Meetings (vwMeetings.ID)
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
    * * Related Entity/Foreign Key: Committees: Agenda Items (vwAgendaItems.ID)
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
    * * SQL Data Type: nvarchar(255)
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
    * * SQL Data Type: nvarchar(255)
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
}


/**
 * Committees: Committees - strongly typed entity sub-class
 * * Schema: __mj_BizAppsCommittees
 * * Base Table: Committee
 * * Base View: vwCommittees
 * * @description Core committee records with hierarchy support
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
    * * Field Name: TypeID
    * * Display Name: Type ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Types (vwTypes.ID)
    */
    get TypeID(): string {
        return this.Get('TypeID');
    }
    set TypeID(value: string) {
        this.Set('TypeID', value);
    }

    /**
    * * Field Name: ParentCommitteeID
    * * Display Name: Parent Committee ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Committees (vwCommittees.ID)
    */
    get ParentCommitteeID(): string | null {
        return this.Get('ParentCommitteeID');
    }
    set ParentCommitteeID(value: string | null) {
        this.Set('ParentCommitteeID', value);
    }

    /**
    * * Field Name: OrganizationID
    * * Display Name: Organization ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ_BizApps_Common: Organizations (vwOrganizations.ID)
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
    */
    get IsPublic(): boolean {
        return this.Get('IsPublic');
    }
    set IsPublic(value: boolean) {
        this.Set('IsPublic', value);
    }

    /**
    * * Field Name: FormationDate
    * * Display Name: Formation Date
    * * SQL Data Type: date
    */
    get FormationDate(): Date | null {
        return this.Get('FormationDate');
    }
    set FormationDate(value: Date | null) {
        this.Set('FormationDate', value);
    }

    /**
    * * Field Name: DissolutionDate
    * * Display Name: Dissolution Date
    * * SQL Data Type: date
    */
    get DissolutionDate(): Date | null {
        return this.Get('DissolutionDate');
    }
    set DissolutionDate(value: Date | null) {
        this.Set('DissolutionDate', value);
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
    * * Field Name: Type
    * * Display Name: Type
    * * SQL Data Type: nvarchar(100)
    */
    get Type(): string {
        return this.Get('Type');
    }

    /**
    * * Field Name: ParentCommittee
    * * Display Name: Parent Committee
    * * SQL Data Type: nvarchar(255)
    */
    get ParentCommittee(): string | null {
        return this.Get('ParentCommittee');
    }

    /**
    * * Field Name: Organization
    * * Display Name: Organization
    * * SQL Data Type: nvarchar(255)
    */
    get Organization(): string | null {
        return this.Get('Organization');
    }

    /**
    * * Field Name: RootParentCommitteeID
    * * Display Name: Root Parent Committee ID
    * * SQL Data Type: uniqueidentifier
    */
    get RootParentCommitteeID(): string | null {
        return this.Get('RootParentCommitteeID');
    }
}


/**
 * Committees: Meetings - strongly typed entity sub-class
 * * Schema: __mj_BizAppsCommittees
 * * Base Table: Meeting
 * * Base View: vwMeetings
 * * @description Committee meeting records with scheduling and video conferencing info
 * * Primary Key: ID
 * @extends {BaseEntity}
 * @class
 * @public
 */
@RegisterClass(BaseEntity, 'Committees: Meetings')
export class mjBizAppsCommitteesMeetingEntity extends BaseEntity<mjBizAppsCommitteesMeetingEntityType> {
    /**
    * Loads the Committees: Meetings record from the database
    * @param ID: string - primary key value to load the Committees: Meetings record.
    * @param EntityRelationshipsToLoad - (optional) the relationships to load
    * @returns {Promise<boolean>} - true if successful, false otherwise
    * @public
    * @async
    * @memberof mjBizAppsCommitteesMeetingEntity
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
    * * Field Name: StartDateTime
    * * Display Name: Start Date Time
    * * SQL Data Type: datetimeoffset
    */
    get StartDateTime(): Date {
        return this.Get('StartDateTime');
    }
    set StartDateTime(value: Date) {
        this.Set('StartDateTime', value);
    }

    /**
    * * Field Name: EndDateTime
    * * Display Name: End Date Time
    * * SQL Data Type: datetimeoffset
    */
    get EndDateTime(): Date | null {
        return this.Get('EndDateTime');
    }
    set EndDateTime(value: Date | null) {
        this.Set('EndDateTime', value);
    }

    /**
    * * Field Name: TimeZone
    * * Display Name: Time Zone
    * * SQL Data Type: nvarchar(50)
    * * Default Value: America/New_York
    */
    get TimeZone(): string {
        return this.Get('TimeZone');
    }
    set TimeZone(value: string) {
        this.Set('TimeZone', value);
    }

    /**
    * * Field Name: LocationType
    * * Display Name: Location Type
    * * SQL Data Type: nvarchar(50)
    * * Default Value: Virtual
    * * Value List Type: List
    * * Possible Values 
    *   * Hybrid
    *   * InPerson
    *   * Virtual
    */
    get LocationType(): 'Hybrid' | 'InPerson' | 'Virtual' {
        return this.Get('LocationType');
    }
    set LocationType(value: 'Hybrid' | 'InPerson' | 'Virtual') {
        this.Set('LocationType', value);
    }

    /**
    * * Field Name: LocationText
    * * Display Name: Location Text
    * * SQL Data Type: nvarchar(500)
    */
    get LocationText(): string | null {
        return this.Get('LocationText');
    }
    set LocationText(value: string | null) {
        this.Set('LocationText', value);
    }

    /**
    * * Field Name: VideoProvider
    * * Display Name: Video Provider
    * * SQL Data Type: nvarchar(50)
    */
    get VideoProvider(): string | null {
        return this.Get('VideoProvider');
    }
    set VideoProvider(value: string | null) {
        this.Set('VideoProvider', value);
    }

    /**
    * * Field Name: VideoProviderID
    * * Display Name: Video Provider ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: Committees: Video Providers (vwVideoProviders.ID)
    */
    get VideoProviderID(): string | null {
        return this.Get('VideoProviderID');
    }
    set VideoProviderID(value: string | null) {
        this.Set('VideoProviderID', value);
    }

    /**
    * * Field Name: VideoMeetingID
    * * Display Name: Video Meeting ID
    * * SQL Data Type: nvarchar(255)
    */
    get VideoMeetingID(): string | null {
        return this.Get('VideoMeetingID');
    }
    set VideoMeetingID(value: string | null) {
        this.Set('VideoMeetingID', value);
    }

    /**
    * * Field Name: VideoJoinURL
    * * Display Name: Video Join URL
    * * SQL Data Type: nvarchar(1000)
    */
    get VideoJoinURL(): string | null {
        return this.Get('VideoJoinURL');
    }
    set VideoJoinURL(value: string | null) {
        this.Set('VideoJoinURL', value);
    }

    /**
    * * Field Name: VideoRecordingURL
    * * Display Name: Video Recording URL
    * * SQL Data Type: nvarchar(1000)
    */
    get VideoRecordingURL(): string | null {
        return this.Get('VideoRecordingURL');
    }
    set VideoRecordingURL(value: string | null) {
        this.Set('VideoRecordingURL', value);
    }

    /**
    * * Field Name: TranscriptURL
    * * Display Name: Transcript URL
    * * SQL Data Type: nvarchar(1000)
    */
    get TranscriptURL(): string | null {
        return this.Get('TranscriptURL');
    }
    set TranscriptURL(value: string | null) {
        this.Set('TranscriptURL', value);
    }

    /**
    * * Field Name: Status
    * * Display Name: Status
    * * SQL Data Type: nvarchar(50)
    * * Default Value: Scheduled
    * * Value List Type: List
    * * Possible Values 
    *   * Cancelled
    *   * Completed
    *   * Draft
    *   * InProgress
    *   * Postponed
    *   * Scheduled
    */
    get Status(): 'Cancelled' | 'Completed' | 'Draft' | 'InProgress' | 'Postponed' | 'Scheduled' {
        return this.Get('Status');
    }
    set Status(value: 'Cancelled' | 'Completed' | 'Draft' | 'InProgress' | 'Postponed' | 'Scheduled') {
        this.Set('Status', value);
    }

    /**
    * * Field Name: CalendarEventID
    * * Display Name: Calendar Event ID
    * * SQL Data Type: nvarchar(255)
    */
    get CalendarEventID(): string | null {
        return this.Get('CalendarEventID');
    }
    set CalendarEventID(value: string | null) {
        this.Set('CalendarEventID', value);
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
    * * SQL Data Type: nvarchar(255)
    */
    get Committee(): string {
        return this.Get('Committee');
    }

    /**
    * * Field Name: VideoProvider_Virtual
    * * Display Name: Video Provider Virtual
    * * SQL Data Type: nvarchar(100)
    */
    get VideoProvider_Virtual(): string | null {
        return this.Get('VideoProvider_Virtual');
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
    * * SQL Data Type: nvarchar(100)
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
    * * Related Entity/Foreign Key: Committees: Meetings (vwMeetings.ID)
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
    * * Related Entity/Foreign Key: Committees: Meetings (vwMeetings.ID)
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
    * * Related Entity/Foreign Key: Committees: Meetings (vwMeetings.ID)
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
    * * Related Entity/Foreign Key: Committees: Agenda Items (vwAgendaItems.ID)
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
    * * SQL Data Type: nvarchar(255)
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
 * * @description Time periods for committee membership cycles
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
    *   * Completed
    *   * Upcoming
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
    * * Field Name: Committee
    * * Display Name: Committee
    * * SQL Data Type: nvarchar(255)
    */
    get Committee(): string {
        return this.Get('Committee');
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
 * Committees: Video Providers - strongly typed entity sub-class
 * * Schema: __mj_BizAppsCommittees
 * * Base Table: VideoProvider
 * * Base View: vwVideoProviders
 * * @description Configured video conferencing providers for auto-creating meeting URLs
 * * Primary Key: ID
 * @extends {BaseEntity}
 * @class
 * @public
 */
@RegisterClass(BaseEntity, 'Committees: Video Providers')
export class mjBizAppsCommitteesVideoProviderEntity extends BaseEntity<mjBizAppsCommitteesVideoProviderEntityType> {
    /**
    * Loads the Committees: Video Providers record from the database
    * @param ID: string - primary key value to load the Committees: Video Providers record.
    * @param EntityRelationshipsToLoad - (optional) the relationships to load
    * @returns {Promise<boolean>} - true if successful, false otherwise
    * @public
    * @async
    * @memberof mjBizAppsCommitteesVideoProviderEntity
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
    * * Field Name: ServerDriverKey
    * * Display Name: Server Driver Key
    * * SQL Data Type: nvarchar(100)
    */
    get ServerDriverKey(): string {
        return this.Get('ServerDriverKey');
    }
    set ServerDriverKey(value: string) {
        this.Set('ServerDriverKey', value);
    }

    /**
    * * Field Name: IsActive
    * * Display Name: Is Active
    * * SQL Data Type: bit
    * * Default Value: 1
    */
    get IsActive(): boolean {
        return this.Get('IsActive');
    }
    set IsActive(value: boolean) {
        this.Set('IsActive', value);
    }

    /**
    * * Field Name: IsDefault
    * * Display Name: Is Default
    * * SQL Data Type: bit
    * * Default Value: 0
    */
    get IsDefault(): boolean {
        return this.Get('IsDefault');
    }
    set IsDefault(value: boolean) {
        this.Set('IsDefault', value);
    }

    /**
    * * Field Name: CredentialID
    * * Display Name: Credential ID
    * * SQL Data Type: uniqueidentifier
    * * Related Entity/Foreign Key: MJ: Credentials (vwCredentials.ID)
    */
    get CredentialID(): string | null {
        return this.Get('CredentialID');
    }
    set CredentialID(value: string | null) {
        this.Set('CredentialID', value);
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
    * * Field Name: Credential
    * * Display Name: Credential
    * * SQL Data Type: nvarchar(200)
    */
    get Credential(): string | null {
        return this.Get('Credential');
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
