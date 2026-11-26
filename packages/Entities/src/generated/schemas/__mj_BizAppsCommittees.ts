import { z } from "zod";


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
    Meeting: z.string().nullable().describe(`
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
        * * SQL Data Type: nvarchar(250)`),
    RootParentAgendaItemID: z.string().nullable().describe(`
        * * Field Name: RootParentAgendaItemID
        * * Display Name: Root Parent Agenda Item ID
        * * SQL Data Type: uniqueidentifier`),
    ParentAgendaItemIDDepth: z.number().nullable().describe(`
        * * Field Name: ParentAgendaItemIDDepth
        * * Display Name: Parent Agenda Item ID Depth
        * * SQL Data Type: int`),
    ParentAgendaItemIDPath: z.string().nullable().describe(`
        * * Field Name: ParentAgendaItemIDPath
        * * Display Name: Parent Agenda Item ID Path
        * * SQL Data Type: nvarchar(MAX)`),
    ParentAgendaItemIDIsLeaf: z.boolean().nullable().describe(`
        * * Field Name: ParentAgendaItemIDIsLeaf
        * * Display Name: Parent Agenda Item ID Is Leaf
        * * SQL Data Type: bit`),
    ParentAgendaItemIDChildCount: z.number().nullable().describe(`
        * * Field Name: ParentAgendaItemIDChildCount
        * * Display Name: Parent Agenda Item ID Child Count
        * * SQL Data Type: int`),
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
    MJArtifactID: z.string().nullable().describe(`
        * * Field Name: MJArtifactID
        * * Display Name: MJ Artifact ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ: Artifacts (vwArtifacts.ID)
        * * Description: Optional foreign key to MJ: Artifacts linking this committee artifact to a native MJ Docs document. When NULL, the artifact is an external URL or cloud-provider link.`),
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
    ArtifactType: z.string().nullable().describe(`
        * * Field Name: ArtifactType
        * * Display Name: Artifact Type
        * * SQL Data Type: nvarchar(100)`),
    UploadedByPerson: z.string().nullable().describe(`
        * * Field Name: UploadedByPerson
        * * Display Name: Uploaded By Person
        * * SQL Data Type: nvarchar(250)`),
    MJArtifact: z.string().nullable().describe(`
        * * Field Name: MJArtifact
        * * Display Name: MJ Artifact
        * * SQL Data Type: nvarchar(255)`),
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
    Meeting: z.string().nullable().describe(`
        * * Field Name: Meeting
        * * Display Name: Meeting
        * * SQL Data Type: nvarchar(255)`),
    Person: z.string().nullable().describe(`
        * * Field Name: Person
        * * Display Name: Person
        * * SQL Data Type: nvarchar(250)`),
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
    Committee: z.string().nullable().describe(`
        * * Field Name: Committee
        * * Display Name: Committee
        * * SQL Data Type: nvarchar(255)`),
    Motion: z.string().nullable().describe(`
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
    Artifact: z.string().nullable().describe(`
        * * Field Name: Artifact
        * * Display Name: Artifact
        * * SQL Data Type: nvarchar(255)`),
    Person: z.string().nullable().describe(`
        * * Field Name: Person
        * * Display Name: Person
        * * SQL Data Type: nvarchar(250)`),
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
    Type: z.string().nullable().describe(`
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
    ParentCommitteeIDDepth: z.number().nullable().describe(`
        * * Field Name: ParentCommitteeIDDepth
        * * Display Name: Parent Committee ID Depth
        * * SQL Data Type: int`),
    ParentCommitteeIDPath: z.string().nullable().describe(`
        * * Field Name: ParentCommitteeIDPath
        * * Display Name: Parent Committee ID Path
        * * SQL Data Type: nvarchar(MAX)`),
    ParentCommitteeIDIsLeaf: z.boolean().nullable().describe(`
        * * Field Name: ParentCommitteeIDIsLeaf
        * * Display Name: Parent Committee ID Is Leaf
        * * SQL Data Type: bit`),
    ParentCommitteeIDChildCount: z.number().nullable().describe(`
        * * Field Name: ParentCommitteeIDChildCount
        * * Display Name: Parent Committee ID Child Count
        * * SQL Data Type: int`),
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
    PredictedQuorumRiskProbability: z.number().nullable().describe(`
        * * Field Name: PredictedQuorumRiskProbability
        * * Display Name: Predicted Quorum Risk Probability
        * * SQL Data Type: decimal(5, 4)
        * * Description: Predicted probability (0.0000 to 1.0000) that this committee meeting will fail to achieve a quorum of voting members.`),
    PredictedQuorumRiskBand: z.union([z.literal('Critical'), z.literal('High'), z.literal('Low'), z.literal('Medium')]).nullable().describe(`
        * * Field Name: PredictedQuorumRiskBand
        * * Display Name: Predicted Quorum Risk Band
        * * SQL Data Type: nvarchar(20)
    * * Value List Type: List
    * * Possible Values 
    *   * Critical
    *   * High
    *   * Low
    *   * Medium
        * * Description: Operational quorum risk band classifying quorum risk: Low (<40%), Medium (40-70%), High (>70%), or Critical.`),
    PredictedQuorumRiskScoredAt: z.date().nullable().describe(`
        * * Field Name: PredictedQuorumRiskScoredAt
        * * Display Name: Predicted Quorum Risk Scored At
        * * SQL Data Type: datetimeoffset
        * * Description: Timestamp when this meeting was last scored by the predictive quorum risk model.`),
    Committee: z.string().nullable().describe(`
        * * Field Name: Committee
        * * Display Name: Committee
        * * SQL Data Type: nvarchar(255)`),
    VideoProvider_Virtual: z.string().nullable().describe(`
        * * Field Name: VideoProvider_Virtual
        * * Display Name: Video Provider Virtual
        * * SQL Data Type: nvarchar(100)`),
    MeetingDurationMinutes: z.number().nullable().describe(`
        * * Field Name: MeetingDurationMinutes
        * * Display Name: Meeting Duration Minutes
        * * SQL Data Type: int`),
    DaysUntilMeeting: z.number().nullable().describe(`
        * * Field Name: DaysUntilMeeting
        * * Display Name: Days Until Meeting
        * * SQL Data Type: int`),
    IsVirtualFlag: z.number().describe(`
        * * Field Name: IsVirtualFlag
        * * Display Name: Is Virtual Flag
        * * SQL Data Type: int`),
    IsHybridFlag: z.number().describe(`
        * * Field Name: IsHybridFlag
        * * Display Name: Is Hybrid Flag
        * * SQL Data Type: int`),
    IsInPersonFlag: z.number().describe(`
        * * Field Name: IsInPersonFlag
        * * Display Name: Is In-Person Flag
        * * SQL Data Type: int`),
    HasVideoLink: z.number().describe(`
        * * Field Name: HasVideoLink
        * * Display Name: Has Video Link
        * * SQL Data Type: int`),
    AgendaItemCount: z.number().describe(`
        * * Field Name: AgendaItemCount
        * * Display Name: Agenda Item Count
        * * SQL Data Type: int`),
    TotalAttendees: z.number().describe(`
        * * Field Name: TotalAttendees
        * * Display Name: Total Attendees
        * * SQL Data Type: int`),
    ExpectedAttendees: z.number().describe(`
        * * Field Name: ExpectedAttendees
        * * Display Name: Expected Attendees
        * * SQL Data Type: int`),
    PresentAttendees: z.number().describe(`
        * * Field Name: PresentAttendees
        * * Display Name: Present Attendees
        * * SQL Data Type: int`),
    AbsentAttendees: z.number().describe(`
        * * Field Name: AbsentAttendees
        * * Display Name: Absent Attendees
        * * SQL Data Type: int`),
    QuorumRiskOutcome: z.number().nullable().describe(`
        * * Field Name: QuorumRiskOutcome
        * * Display Name: Quorum Risk Outcome
        * * SQL Data Type: int`),
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
    Person: z.string().nullable().describe(`
        * * Field Name: Person
        * * Display Name: Person
        * * SQL Data Type: nvarchar(250)`),
    Role: z.string().nullable().describe(`
        * * Field Name: Role
        * * Display Name: Role
        * * SQL Data Type: nvarchar(100)`),
    Term: z.string().nullable().describe(`
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
    MJArtifactID: z.string().nullable().describe(`
        * * Field Name: MJArtifactID
        * * Display Name: MJ Artifact ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ: Artifacts (vwArtifacts.ID)
        * * Description: Optional foreign key to MJ: Artifacts linking this meeting minute to a native MJ Docs document. When NULL, legacy Minute.Content is used.`),
    ApprovedArtifactVersionID: z.string().nullable().describe(`
        * * Field Name: ApprovedArtifactVersionID
        * * Display Name: Approved Artifact Version ID
        * * SQL Data Type: uniqueidentifier
        * * Related Entity/Foreign Key: MJ: Artifact Versions (vwArtifactVersions.ID)
        * * Description: Optional foreign key to MJ: Artifact Versions pinning this minute to an immutable approved version of the linked MJArtifactID document. Must belong to MJArtifactID and must be NULL when MJArtifactID is NULL.`),
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
    MJArtifact: z.string().nullable().describe(`
        * * Field Name: MJArtifact
        * * Display Name: MJ Artifact
        * * SQL Data Type: nvarchar(255)`),
    ApprovedArtifactVersion: z.string().nullable().describe(`
        * * Field Name: ApprovedArtifactVersion
        * * Display Name: Approved Artifact Version
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
    Committee: z.string().nullable().describe(`
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
    Motion: z.string().nullable().describe(`
        * * Field Name: Motion
        * * Display Name: Motion
        * * SQL Data Type: nvarchar(255)`),
});

export type mjBizAppsCommitteesVoteEntityType = z.infer<typeof mjBizAppsCommitteesVoteSchema>;
