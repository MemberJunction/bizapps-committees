-- =========================================================================
-- Committees App — Consolidated Schema Baseline (v1.0)
-- =========================================================================
-- Single baseline for the ${flyway:defaultSchema} application schema. Supersedes the
-- original incremental migrations (Committees schema, Comment, Membership-via-
-- Terms, Minute MeetingID/Content, Video Provider, ActionItem→Task FK rework).
--
-- STRUCTURE (order matters — later sections depend on earlier ones):
--   1. Schema DDL         — tables, FKs, check constraints, extended properties
--   2. CODEGEN section    — `mj codegen` output: entity registrations, the
--                           auto-created Application, audit columns, FK indexes,
--                           field maps, base views, CRUD procs, triggers, permissions
--   3. APPLICATION CONFIG — renames the auto-created app to 'Committees' and
--                           creates the 'Committee Management' app
-- Seed/lookup data is NOT here — it lives in metadata/ via `mj sync push`.
-- On schema changes: edit the DDL, re-run CodeGen, replace the CODEGEN section.
--
-- CROSS-SCHEMA PREREQUISITES (must be migrated BEFORE this baseline runs):
--   __mj_BizAppsCommon  (sibling repo: bizapps-common) — Person, Organization
--   __mj_BizAppsTasks   (sibling repo: bizapps-tasks)  — Task
--   __mj                (MemberJunction core)          — Entity, Credential
--
-- Idempotent: every object is guarded so the baseline is safe to re-run.
-- =========================================================================

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = '${flyway:defaultSchema}')
    EXEC('CREATE SCHEMA ${flyway:defaultSchema}');
GO

---------------------------------------------------------------------------
-- Committee Types: Board, Standing, Ad Hoc, Workgroup, Standards WG
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '${flyway:defaultSchema}' AND TABLE_NAME = 'Type')
CREATE TABLE ${flyway:defaultSchema}.Type (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    IsStandards BIT NOT NULL DEFAULT 0,
    DefaultTermMonths INT,
    IconClass NVARCHAR(100),
    CONSTRAINT PK_Type PRIMARY KEY (ID),
    CONSTRAINT UQ_Type_Name UNIQUE (Name)
);
GO

---------------------------------------------------------------------------
-- Core Committee entity
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '${flyway:defaultSchema}' AND TABLE_NAME = 'Committee')
CREATE TABLE ${flyway:defaultSchema}.Committee (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    Name NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    TypeID UNIQUEIDENTIFIER NOT NULL,
    ParentCommitteeID UNIQUEIDENTIFIER,
    OrganizationID UNIQUEIDENTIFIER,
    CharterDocumentURL NVARCHAR(1000),
    MissionStatement NVARCHAR(MAX),
    Status NVARCHAR(50) NOT NULL DEFAULT 'Active',
    IsPublic BIT NOT NULL DEFAULT 1,
    FormationDate DATE,
    DissolutionDate DATE,
    CONSTRAINT PK_Committee PRIMARY KEY (ID),
    CONSTRAINT FK_Committee_Type FOREIGN KEY (TypeID) REFERENCES ${flyway:defaultSchema}.Type(ID),
    CONSTRAINT FK_Committee_Parent FOREIGN KEY (ParentCommitteeID) REFERENCES ${flyway:defaultSchema}.Committee(ID),
    CONSTRAINT FK_Committee_Organization FOREIGN KEY (OrganizationID) REFERENCES __mj_BizAppsCommon.Organization(ID),
    CONSTRAINT CK_Committee_Status CHECK (Status IN ('Active', 'Inactive', 'Pending', 'Dissolved'))
);
GO

---------------------------------------------------------------------------
-- Committee Terms (annual or custom periods)
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '${flyway:defaultSchema}' AND TABLE_NAME = 'Term')
CREATE TABLE ${flyway:defaultSchema}.Term (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    CommitteeID UNIQUEIDENTIFIER NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE,
    Status NVARCHAR(50) NOT NULL DEFAULT 'Active',
    CONSTRAINT PK_Term PRIMARY KEY (ID),
    CONSTRAINT FK_Term_Committee FOREIGN KEY (CommitteeID) REFERENCES ${flyway:defaultSchema}.Committee(ID),
    CONSTRAINT CK_Term_Status CHECK (Status IN ('Active', 'Upcoming', 'Completed'))
);
GO

---------------------------------------------------------------------------
-- Role definitions (Chair, Vice Chair, Secretary, Member, Liaison, etc.)
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '${flyway:defaultSchema}' AND TABLE_NAME = 'Role')
CREATE TABLE ${flyway:defaultSchema}.Role (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    IsOfficer BIT NOT NULL DEFAULT 0,
    IsVotingRole BIT NOT NULL DEFAULT 1,
    DefaultPermissionsJSON NVARCHAR(MAX),
    Sequence INT NOT NULL DEFAULT 100,
    CONSTRAINT PK_Role PRIMARY KEY (ID),
    CONSTRAINT UQ_Role_Name UNIQUE (Name)
);
GO

---------------------------------------------------------------------------
-- Committee membership (links to BizAppsCommon Person, scoped via Term)
-- NOTE: No CommitteeID — membership is scoped through Term.CommitteeID.
--       TermID is required.
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '${flyway:defaultSchema}' AND TABLE_NAME = 'Membership')
CREATE TABLE ${flyway:defaultSchema}.Membership (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    PersonID UNIQUEIDENTIFIER NOT NULL,
    RoleID UNIQUEIDENTIFIER NOT NULL,
    TermID UNIQUEIDENTIFIER NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE,
    Status NVARCHAR(50) NOT NULL DEFAULT 'Active',
    EndReason NVARCHAR(100),
    Notes NVARCHAR(MAX),
    CONSTRAINT PK_Membership PRIMARY KEY (ID),
    CONSTRAINT FK_Membership_Person FOREIGN KEY (PersonID) REFERENCES __mj_BizAppsCommon.Person(ID),
    CONSTRAINT FK_Membership_Role FOREIGN KEY (RoleID) REFERENCES ${flyway:defaultSchema}.Role(ID),
    CONSTRAINT FK_Membership_Term FOREIGN KEY (TermID) REFERENCES ${flyway:defaultSchema}.Term(ID),
    CONSTRAINT CK_Membership_Status CHECK (Status IN ('Active', 'Pending', 'Ended', 'Suspended'))
);
GO

---------------------------------------------------------------------------
-- Video conferencing providers (Zoom, Teams, Meet) keyed to a driver
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '${flyway:defaultSchema}' AND TABLE_NAME = 'VideoProvider')
CREATE TABLE ${flyway:defaultSchema}.VideoProvider (
    ID              UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    Name            NVARCHAR(100)    NOT NULL,
    ServerDriverKey NVARCHAR(100)    NOT NULL,
    IsActive        BIT              NOT NULL DEFAULT 1,
    IsDefault       BIT              NOT NULL DEFAULT 0,
    CredentialID    UNIQUEIDENTIFIER NULL,
    CONSTRAINT PK_VideoProvider PRIMARY KEY (ID),
    CONSTRAINT UQ_VideoProvider_Name UNIQUE (Name),
    CONSTRAINT FK_VideoProvider_Credential FOREIGN KEY (CredentialID) REFERENCES __mj.[Credential](ID)
);
GO

---------------------------------------------------------------------------
-- Meeting records (VideoProviderID FK + legacy free-text VideoProvider)
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '${flyway:defaultSchema}' AND TABLE_NAME = 'Meeting')
CREATE TABLE ${flyway:defaultSchema}.Meeting (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    CommitteeID UNIQUEIDENTIFIER NOT NULL,
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    StartDateTime DATETIMEOFFSET NOT NULL,
    EndDateTime DATETIMEOFFSET,
    TimeZone NVARCHAR(50) NOT NULL DEFAULT 'America/New_York',
    LocationType NVARCHAR(50) NOT NULL DEFAULT 'Virtual',
    LocationText NVARCHAR(500),
    VideoProvider NVARCHAR(50),
    VideoProviderID UNIQUEIDENTIFIER,
    VideoMeetingID NVARCHAR(255),
    VideoJoinURL NVARCHAR(1000),
    VideoRecordingURL NVARCHAR(1000),
    TranscriptURL NVARCHAR(1000),
    Status NVARCHAR(50) NOT NULL DEFAULT 'Scheduled',
    CalendarEventID NVARCHAR(255),
    CONSTRAINT PK_Meeting PRIMARY KEY (ID),
    CONSTRAINT FK_Meeting_Committee FOREIGN KEY (CommitteeID) REFERENCES ${flyway:defaultSchema}.Committee(ID),
    CONSTRAINT FK_Meeting_VideoProvider FOREIGN KEY (VideoProviderID) REFERENCES ${flyway:defaultSchema}.VideoProvider(ID),
    CONSTRAINT CK_Meeting_Status CHECK (Status IN ('Draft', 'Scheduled', 'InProgress', 'Completed', 'Cancelled', 'Postponed')),
    CONSTRAINT CK_Meeting_LocationType CHECK (LocationType IN ('Virtual', 'InPerson', 'Hybrid'))
);
GO

---------------------------------------------------------------------------
-- Meeting agenda items
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '${flyway:defaultSchema}' AND TABLE_NAME = 'AgendaItem')
CREATE TABLE ${flyway:defaultSchema}.AgendaItem (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    MeetingID UNIQUEIDENTIFIER NOT NULL,
    ParentAgendaItemID UNIQUEIDENTIFIER,
    Sequence INT NOT NULL,
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    PresenterPersonID UNIQUEIDENTIFIER,
    DurationMinutes INT,
    ItemType NVARCHAR(50) NOT NULL DEFAULT 'Discussion',
    RelatedDocumentURL NVARCHAR(1000),
    Status NVARCHAR(50) NOT NULL DEFAULT 'Pending',
    Notes NVARCHAR(MAX),
    CONSTRAINT PK_AgendaItem PRIMARY KEY (ID),
    CONSTRAINT FK_AgendaItem_Meeting FOREIGN KEY (MeetingID) REFERENCES ${flyway:defaultSchema}.Meeting(ID),
    CONSTRAINT FK_AgendaItem_Parent FOREIGN KEY (ParentAgendaItemID) REFERENCES ${flyway:defaultSchema}.AgendaItem(ID),
    CONSTRAINT FK_AgendaItem_Presenter FOREIGN KEY (PresenterPersonID) REFERENCES __mj_BizAppsCommon.Person(ID),
    CONSTRAINT CK_AgendaItem_Type CHECK (ItemType IN ('Information', 'Discussion', 'Action', 'Vote', 'Report', 'Other')),
    CONSTRAINT CK_AgendaItem_Status CHECK (Status IN ('Pending', 'Discussed', 'Tabled', 'Completed', 'Skipped'))
);
GO

---------------------------------------------------------------------------
-- Meeting attendance
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '${flyway:defaultSchema}' AND TABLE_NAME = 'Attendance')
CREATE TABLE ${flyway:defaultSchema}.Attendance (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    MeetingID UNIQUEIDENTIFIER NOT NULL,
    PersonID UNIQUEIDENTIFIER NOT NULL,
    AttendanceStatus NVARCHAR(50) NOT NULL DEFAULT 'Expected',
    JoinedAt DATETIMEOFFSET,
    LeftAt DATETIMEOFFSET,
    Notes NVARCHAR(500),
    CONSTRAINT PK_Attendance PRIMARY KEY (ID),
    CONSTRAINT FK_Attendance_Meeting FOREIGN KEY (MeetingID) REFERENCES ${flyway:defaultSchema}.Meeting(ID),
    CONSTRAINT FK_Attendance_Person FOREIGN KEY (PersonID) REFERENCES __mj_BizAppsCommon.Person(ID),
    CONSTRAINT CK_Attendance_Status CHECK (AttendanceStatus IN ('Expected', 'Present', 'Absent', 'Excused', 'Partial')),
    CONSTRAINT UQ_Attendance UNIQUE (MeetingID, PersonID)
);
GO

---------------------------------------------------------------------------
-- Action items (legacy task tracking; coexists with BizAppsTasks.Task)
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '${flyway:defaultSchema}' AND TABLE_NAME = 'ActionItem')
CREATE TABLE ${flyway:defaultSchema}.ActionItem (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    CommitteeID UNIQUEIDENTIFIER NOT NULL,
    MeetingID UNIQUEIDENTIFIER,
    AgendaItemID UNIQUEIDENTIFIER,
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    AssignedToPersonID UNIQUEIDENTIFIER NOT NULL,
    AssignedByPersonID UNIQUEIDENTIFIER,
    DueDate DATE,
    Priority NVARCHAR(20) NOT NULL DEFAULT 'Medium',
    Status NVARCHAR(50) NOT NULL DEFAULT 'Open',
    CompletedAt DATETIMEOFFSET,
    CompletionNotes NVARCHAR(MAX),
    CONSTRAINT PK_ActionItem PRIMARY KEY (ID),
    CONSTRAINT FK_ActionItem_Committee FOREIGN KEY (CommitteeID) REFERENCES ${flyway:defaultSchema}.Committee(ID),
    CONSTRAINT FK_ActionItem_Meeting FOREIGN KEY (MeetingID) REFERENCES ${flyway:defaultSchema}.Meeting(ID),
    CONSTRAINT FK_ActionItem_AgendaItem FOREIGN KEY (AgendaItemID) REFERENCES ${flyway:defaultSchema}.AgendaItem(ID),
    CONSTRAINT FK_ActionItem_AssignedTo FOREIGN KEY (AssignedToPersonID) REFERENCES __mj_BizAppsCommon.Person(ID),
    CONSTRAINT FK_ActionItem_AssignedBy FOREIGN KEY (AssignedByPersonID) REFERENCES __mj_BizAppsCommon.Person(ID),
    CONSTRAINT CK_ActionItem_Priority CHECK (Priority IN ('Low', 'Medium', 'High', 'Critical')),
    CONSTRAINT CK_ActionItem_Status CHECK (Status IN ('Open', 'InProgress', 'Blocked', 'Completed', 'Cancelled'))
);
GO

---------------------------------------------------------------------------
-- Artifact types with optional extension entity support
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '${flyway:defaultSchema}' AND TABLE_NAME = 'ArtifactType')
CREATE TABLE ${flyway:defaultSchema}.ArtifactType (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    ExtendedEntityID UNIQUEIDENTIFIER,
    IconClass NVARCHAR(100),
    CONSTRAINT PK_ArtifactType PRIMARY KEY (ID),
    CONSTRAINT UQ_ArtifactType_Name UNIQUE (Name),
    CONSTRAINT FK_ArtifactType_Entity FOREIGN KEY (ExtendedEntityID) REFERENCES __mj.[Entity](ID)
);
GO

---------------------------------------------------------------------------
-- Artifact links (documents, files, etc.)
-- TaskID FK to BizAppsTasks.Task (replaced the legacy ActionItemID).
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '${flyway:defaultSchema}' AND TABLE_NAME = 'Artifact')
CREATE TABLE ${flyway:defaultSchema}.Artifact (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    CommitteeID UNIQUEIDENTIFIER,
    MeetingID UNIQUEIDENTIFIER,
    AgendaItemID UNIQUEIDENTIFIER,
    TaskID UNIQUEIDENTIFIER,
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    ArtifactTypeID UNIQUEIDENTIFIER NOT NULL,
    Provider NVARCHAR(50) NOT NULL,
    ExternalID NVARCHAR(500),
    URL NVARCHAR(2000) NOT NULL,
    MimeType NVARCHAR(100),
    FileSize BIGINT,
    UploadedByPersonID UNIQUEIDENTIFIER,
    CONSTRAINT PK_Artifact PRIMARY KEY (ID),
    CONSTRAINT FK_Artifact_Committee FOREIGN KEY (CommitteeID) REFERENCES ${flyway:defaultSchema}.Committee(ID),
    CONSTRAINT FK_Artifact_Meeting FOREIGN KEY (MeetingID) REFERENCES ${flyway:defaultSchema}.Meeting(ID),
    CONSTRAINT FK_Artifact_AgendaItem FOREIGN KEY (AgendaItemID) REFERENCES ${flyway:defaultSchema}.AgendaItem(ID),
    CONSTRAINT FK_Artifact_Task FOREIGN KEY (TaskID) REFERENCES __mj_BizAppsTasks.Task(ID),
    CONSTRAINT FK_Artifact_ArtifactType FOREIGN KEY (ArtifactTypeID) REFERENCES ${flyway:defaultSchema}.ArtifactType(ID),
    CONSTRAINT FK_Artifact_UploadedBy FOREIGN KEY (UploadedByPersonID) REFERENCES __mj_BizAppsCommon.Person(ID),
    CONSTRAINT CK_Artifact_Provider CHECK (Provider IN ('GoogleDrive', 'SharePoint', 'Box', 'OneDrive', 'Dropbox', 'URL'))
);
GO

---------------------------------------------------------------------------
-- Minutes extension. ArtifactID is nullable (Artifact system deprecated;
-- minutes may instead be stored as markdown Content on the record).
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '${flyway:defaultSchema}' AND TABLE_NAME = 'Minute')
CREATE TABLE ${flyway:defaultSchema}.Minute (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    ArtifactID UNIQUEIDENTIFIER,
    MeetingID UNIQUEIDENTIFIER,
    Content NVARCHAR(MAX),
    ApprovalStatus NVARCHAR(50) NOT NULL DEFAULT 'Draft',
    ApprovedAt DATETIMEOFFSET,
    ApprovedByMeetingID UNIQUEIDENTIFIER,
    Notes NVARCHAR(MAX),
    CONSTRAINT PK_Minute PRIMARY KEY (ID),
    CONSTRAINT FK_Minute_Artifact FOREIGN KEY (ArtifactID) REFERENCES ${flyway:defaultSchema}.Artifact(ID),
    CONSTRAINT FK_Minute_Meeting FOREIGN KEY (MeetingID) REFERENCES ${flyway:defaultSchema}.Meeting(ID),
    CONSTRAINT FK_Minute_ApprovedByMeeting FOREIGN KEY (ApprovedByMeetingID) REFERENCES ${flyway:defaultSchema}.Meeting(ID),
    CONSTRAINT CK_Minute_ApprovalStatus CHECK (ApprovalStatus IN ('Draft', 'PendingApproval', 'Approved', 'Rejected'))
);
GO

---------------------------------------------------------------------------
-- Motions put to vote during meetings
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '${flyway:defaultSchema}' AND TABLE_NAME = 'Motion')
CREATE TABLE ${flyway:defaultSchema}.Motion (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    MeetingID UNIQUEIDENTIFIER NOT NULL,
    AgendaItemID UNIQUEIDENTIFIER,
    Sequence INT NOT NULL DEFAULT 1,
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    MovedByMembershipID UNIQUEIDENTIFIER,
    SecondedByMembershipID UNIQUEIDENTIFIER,
    Result NVARCHAR(50) NOT NULL DEFAULT 'Pending',
    ResultSummary NVARCHAR(255),
    YesCount INT,
    NoCount INT,
    AbstainCount INT,
    Notes NVARCHAR(MAX),
    CONSTRAINT PK_Motion PRIMARY KEY (ID),
    CONSTRAINT FK_Motion_Meeting FOREIGN KEY (MeetingID) REFERENCES ${flyway:defaultSchema}.Meeting(ID),
    CONSTRAINT FK_Motion_AgendaItem FOREIGN KEY (AgendaItemID) REFERENCES ${flyway:defaultSchema}.AgendaItem(ID),
    CONSTRAINT FK_Motion_MovedBy FOREIGN KEY (MovedByMembershipID) REFERENCES ${flyway:defaultSchema}.Membership(ID),
    CONSTRAINT FK_Motion_SecondedBy FOREIGN KEY (SecondedByMembershipID) REFERENCES ${flyway:defaultSchema}.Membership(ID),
    CONSTRAINT CK_Motion_Result CHECK (Result IN ('Pending', 'Passed', 'Failed', 'Tabled', 'Withdrawn'))
);
GO

---------------------------------------------------------------------------
-- Individual vote records per motion
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '${flyway:defaultSchema}' AND TABLE_NAME = 'Vote')
CREATE TABLE ${flyway:defaultSchema}.Vote (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    MotionID UNIQUEIDENTIFIER NOT NULL,
    MembershipID UNIQUEIDENTIFIER NOT NULL,
    VoteValue NVARCHAR(20) NOT NULL,
    Notes NVARCHAR(500),
    CONSTRAINT PK_Vote PRIMARY KEY (ID),
    CONSTRAINT FK_Vote_Motion FOREIGN KEY (MotionID) REFERENCES ${flyway:defaultSchema}.Motion(ID),
    CONSTRAINT FK_Vote_Membership FOREIGN KEY (MembershipID) REFERENCES ${flyway:defaultSchema}.Membership(ID),
    CONSTRAINT CK_Vote_Value CHECK (VoteValue IN ('Yes', 'No', 'Abstain', 'Absent')),
    CONSTRAINT UQ_Vote UNIQUE (MotionID, MembershipID)
);
GO

---------------------------------------------------------------------------
-- Threaded comments on committee entities.
-- TaskID FK to BizAppsTasks.Task (replaced the legacy ActionItemID).
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '${flyway:defaultSchema}' AND TABLE_NAME = 'Comment')
CREATE TABLE ${flyway:defaultSchema}.Comment (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    CommitteeID UNIQUEIDENTIFIER NOT NULL,
    MeetingID UNIQUEIDENTIFIER,
    AgendaItemID UNIQUEIDENTIFIER,
    TaskID UNIQUEIDENTIFIER,
    ArtifactID UNIQUEIDENTIFIER,
    ParentCommentID UNIQUEIDENTIFIER,
    PersonID UNIQUEIDENTIFIER NOT NULL,
    CommentText NVARCHAR(MAX) NOT NULL,
    MentionedPersonIDs NVARCHAR(MAX),
    IsResolved BIT NOT NULL DEFAULT 0,
    CONSTRAINT PK_Comment PRIMARY KEY (ID),
    CONSTRAINT FK_Comment_Committee FOREIGN KEY (CommitteeID) REFERENCES ${flyway:defaultSchema}.Committee(ID),
    CONSTRAINT FK_Comment_Meeting FOREIGN KEY (MeetingID) REFERENCES ${flyway:defaultSchema}.Meeting(ID),
    CONSTRAINT FK_Comment_AgendaItem FOREIGN KEY (AgendaItemID) REFERENCES ${flyway:defaultSchema}.AgendaItem(ID),
    CONSTRAINT FK_Comment_Task FOREIGN KEY (TaskID) REFERENCES __mj_BizAppsTasks.Task(ID),
    CONSTRAINT FK_Comment_Artifact FOREIGN KEY (ArtifactID) REFERENCES ${flyway:defaultSchema}.Artifact(ID),
    CONSTRAINT FK_Comment_Parent FOREIGN KEY (ParentCommentID) REFERENCES ${flyway:defaultSchema}.Comment(ID),
    CONSTRAINT FK_Comment_Person FOREIGN KEY (PersonID) REFERENCES __mj_BizAppsCommon.Person(ID)
);
GO

---------------------------------------------------------------------------
-- EXTENDED PROPERTIES: Schema + table/column descriptions
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep INNER JOIN sys.schemas s ON ep.major_id = s.schema_id WHERE s.name = '${flyway:defaultSchema}' AND ep.minor_id = 0 AND ep.name = 'MS_Description' AND ep.class = 3)
    EXEC sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Committee management app for governance, meetings, and action tracking',
        @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('${flyway:defaultSchema}.Type') AND minor_id = 0 AND name = 'MS_Description')
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Categories of committees such as Board, Standing, Ad Hoc, Workgroup', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Type';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('${flyway:defaultSchema}.Committee') AND minor_id = 0 AND name = 'MS_Description')
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Core committee records with hierarchy support', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Committee';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('${flyway:defaultSchema}.Term') AND minor_id = 0 AND name = 'MS_Description')
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Time periods for committee membership cycles', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Term';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('${flyway:defaultSchema}.Role') AND minor_id = 0 AND name = 'MS_Description')
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Roles that members can hold on committees', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Role';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('${flyway:defaultSchema}.Membership') AND minor_id = 0 AND name = 'MS_Description')
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Person assignments to committees with roles and terms', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Membership';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('${flyway:defaultSchema}.VideoProvider') AND minor_id = 0 AND name = 'MS_Description')
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Configured video conferencing providers for auto-creating meeting URLs', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'VideoProvider';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('${flyway:defaultSchema}.Meeting') AND minor_id = 0 AND name = 'MS_Description')
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Committee meeting records with scheduling and video conferencing info', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Meeting';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('${flyway:defaultSchema}.AgendaItem') AND minor_id = 0 AND name = 'MS_Description')
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Structured agenda items for meetings with hierarchy support', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'AgendaItem';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('${flyway:defaultSchema}.Attendance') AND minor_id = 0 AND name = 'MS_Description')
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Meeting attendance records for committee members', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Attendance';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('${flyway:defaultSchema}.ActionItem') AND minor_id = 0 AND name = 'MS_Description')
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Legacy action items assigned from committees or meetings (superseded by BizAppsTasks)', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'ActionItem';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('${flyway:defaultSchema}.ArtifactType') AND minor_id = 0 AND name = 'MS_Description')
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Categories of committee artifacts with optional extension entity for type-specific fields', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'ArtifactType';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('${flyway:defaultSchema}.Artifact') AND minor_id = 0 AND name = 'MS_Description')
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Links to external documents and files from various providers', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Artifact';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('${flyway:defaultSchema}.Minute') AND minor_id = 0 AND name = 'MS_Description')
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Meeting minutes with approval tracking; stored as markdown Content or linked Artifact', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Minute';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('${flyway:defaultSchema}.Motion') AND minor_id = 0 AND name = 'MS_Description')
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Formal motions put to vote during committee meetings', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Motion';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('${flyway:defaultSchema}.Vote') AND minor_id = 0 AND name = 'MS_Description')
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Individual vote records for committee motions', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Vote';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('${flyway:defaultSchema}.Comment') AND minor_id = 0 AND name = 'MS_Description')
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Threaded discussion comments on committee meetings, agenda items, tasks, and documents', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Comment';
GO






























































/*==================================================================================*/
/*  CODEGEN — output of `mj codegen` (@memberjunction/cli 5.44.0), single pass,      */
/*  run 2026-07-06 against the schema DDL above. Registers the 16 entities,          */
/*  creates the auto-named Application, and adds audit columns, FK indexes,          */
/*  field maps, base views, CRUD procs, triggers, and permissions.                   */
/*  On schema changes: edit the DDL above, re-run CodeGen, replace this section.     */
/*==================================================================================*/

/* SQL generated to create new entity Committees: Minutes */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
         , [TrackRecordChanges]
         , [AuditRecordAccess]
         , [AuditViewRuns]
         , [AllowAllRowsAPI]
         , [AllowCreateAPI]
         , [AllowUpdateAPI]
         , [AllowDeleteAPI]
         , [UserViewMaxRows]
         , [__mj_CreatedAt]
         , [__mj_UpdatedAt]
      )
      VALUES (
         'a70dab39-da59-4f4b-a2f0-dfac15c8d29a',
         'Committees: Minutes',
         'Minutes',
         'Meeting minutes with approval tracking; stored as markdown Content or linked Artifact',
         NULL,
         'Minute',
         'vwMinutes',
         '${flyway:defaultSchema}',
         1,
         1,
         0
         , 1
         , 0
         , 0
         , 0
         , 1
         , 1
         , 1
         , 1000
         , GETUTCDATE()
         , GETUTCDATE()
      );

/* SQL generated to create new application ${flyway:defaultSchema} */
INSERT INTO [${mjSchema}].[Application] (ID, Name, Description, SchemaAutoAddNewEntities, Path, AutoUpdatePath)
                       VALUES ('0ca71325-df26-47be-a114-cedeb0ddf185', '${flyway:defaultSchema}', 'Generated for schema', '${flyway:defaultSchema}', 'mjbizappscommittees', 1);

/* Adding role UI to application ${flyway:defaultSchema} */
INSERT INTO [${mjSchema}].[ApplicationRole]
                                 ([ApplicationID], [RoleID], [CanAccess], [CanAdmin]) VALUES
                                 ('0ca71325-df26-47be-a114-cedeb0ddf185', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0);

/* Adding role Developer to application ${flyway:defaultSchema} */
INSERT INTO [${mjSchema}].[ApplicationRole]
                                 ([ApplicationID], [RoleID], [CanAccess], [CanAdmin]) VALUES
                                 ('0ca71325-df26-47be-a114-cedeb0ddf185', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1);

/* Adding role Integration to application ${flyway:defaultSchema} */
INSERT INTO [${mjSchema}].[ApplicationRole]
                                 ([ApplicationID], [RoleID], [CanAccess], [CanAdmin]) VALUES
                                 ('0ca71325-df26-47be-a114-cedeb0ddf185', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0);

/* SQL generated to add new entity Committees: Minutes to application ID: '0ca71325-df26-47be-a114-cedeb0ddf185' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('0ca71325-df26-47be-a114-cedeb0ddf185', 'a70dab39-da59-4f4b-a2f0-dfac15c8d29a', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '0ca71325-df26-47be-a114-cedeb0ddf185'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Minutes for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('a70dab39-da59-4f4b-a2f0-dfac15c8d29a', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Minutes for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('a70dab39-da59-4f4b-a2f0-dfac15c8d29a', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Minutes for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('a70dab39-da59-4f4b-a2f0-dfac15c8d29a', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Motions */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
         , [TrackRecordChanges]
         , [AuditRecordAccess]
         , [AuditViewRuns]
         , [AllowAllRowsAPI]
         , [AllowCreateAPI]
         , [AllowUpdateAPI]
         , [AllowDeleteAPI]
         , [UserViewMaxRows]
         , [__mj_CreatedAt]
         , [__mj_UpdatedAt]
      )
      VALUES (
         'ac908a89-225c-48cf-8852-40e612096d6c',
         'Committees: Motions',
         'Motions',
         'Formal motions put to vote during committee meetings',
         NULL,
         'Motion',
         'vwMotions',
         '${flyway:defaultSchema}',
         1,
         1,
         0
         , 1
         , 0
         , 0
         , 0
         , 1
         , 1
         , 1
         , 1000
         , GETUTCDATE()
         , GETUTCDATE()
      );

/* SQL generated to add new entity Committees: Motions to application ID: '0CA71325-DF26-47BE-A114-CEDEB0DDF185' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('0CA71325-DF26-47BE-A114-CEDEB0DDF185', 'ac908a89-225c-48cf-8852-40e612096d6c', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '0CA71325-DF26-47BE-A114-CEDEB0DDF185'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Motions for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('ac908a89-225c-48cf-8852-40e612096d6c', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Motions for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('ac908a89-225c-48cf-8852-40e612096d6c', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Motions for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('ac908a89-225c-48cf-8852-40e612096d6c', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Votes */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
         , [TrackRecordChanges]
         , [AuditRecordAccess]
         , [AuditViewRuns]
         , [AllowAllRowsAPI]
         , [AllowCreateAPI]
         , [AllowUpdateAPI]
         , [AllowDeleteAPI]
         , [UserViewMaxRows]
         , [__mj_CreatedAt]
         , [__mj_UpdatedAt]
      )
      VALUES (
         'baca039c-8d23-4aef-9a03-2e1ad2426edf',
         'Committees: Votes',
         'Votes',
         'Individual vote records for committee motions',
         NULL,
         'Vote',
         'vwVotes',
         '${flyway:defaultSchema}',
         1,
         1,
         0
         , 1
         , 0
         , 0
         , 0
         , 1
         , 1
         , 1
         , 1000
         , GETUTCDATE()
         , GETUTCDATE()
      );

/* SQL generated to add new entity Committees: Votes to application ID: '0CA71325-DF26-47BE-A114-CEDEB0DDF185' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('0CA71325-DF26-47BE-A114-CEDEB0DDF185', 'baca039c-8d23-4aef-9a03-2e1ad2426edf', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '0CA71325-DF26-47BE-A114-CEDEB0DDF185'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Votes for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('baca039c-8d23-4aef-9a03-2e1ad2426edf', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Votes for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('baca039c-8d23-4aef-9a03-2e1ad2426edf', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Votes for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('baca039c-8d23-4aef-9a03-2e1ad2426edf', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Comments */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
         , [TrackRecordChanges]
         , [AuditRecordAccess]
         , [AuditViewRuns]
         , [AllowAllRowsAPI]
         , [AllowCreateAPI]
         , [AllowUpdateAPI]
         , [AllowDeleteAPI]
         , [UserViewMaxRows]
         , [__mj_CreatedAt]
         , [__mj_UpdatedAt]
      )
      VALUES (
         '6a65eebd-8436-4ffc-9874-22d43fb91c37',
         'Committees: Comments',
         'Comments',
         'Threaded discussion comments on committee meetings, agenda items, tasks, and documents',
         NULL,
         'Comment',
         'vwComments',
         '${flyway:defaultSchema}',
         1,
         1,
         0
         , 1
         , 0
         , 0
         , 0
         , 1
         , 1
         , 1
         , 1000
         , GETUTCDATE()
         , GETUTCDATE()
      );

/* SQL generated to add new entity Committees: Comments to application ID: '0CA71325-DF26-47BE-A114-CEDEB0DDF185' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('0CA71325-DF26-47BE-A114-CEDEB0DDF185', '6a65eebd-8436-4ffc-9874-22d43fb91c37', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '0CA71325-DF26-47BE-A114-CEDEB0DDF185'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Comments for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('6a65eebd-8436-4ffc-9874-22d43fb91c37', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Comments for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('6a65eebd-8436-4ffc-9874-22d43fb91c37', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Comments for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('6a65eebd-8436-4ffc-9874-22d43fb91c37', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Types */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
         , [TrackRecordChanges]
         , [AuditRecordAccess]
         , [AuditViewRuns]
         , [AllowAllRowsAPI]
         , [AllowCreateAPI]
         , [AllowUpdateAPI]
         , [AllowDeleteAPI]
         , [UserViewMaxRows]
         , [__mj_CreatedAt]
         , [__mj_UpdatedAt]
      )
      VALUES (
         'd49bdeb5-8d19-4e8e-b130-5fec6e80c36e',
         'Committees: Types',
         'Types',
         'Categories of committees such as Board, Standing, Ad Hoc, Workgroup',
         NULL,
         'Type',
         'vwTypes',
         '${flyway:defaultSchema}',
         1,
         1,
         0
         , 1
         , 0
         , 0
         , 0
         , 1
         , 1
         , 1
         , 1000
         , GETUTCDATE()
         , GETUTCDATE()
      );

/* SQL generated to add new entity Committees: Types to application ID: '0CA71325-DF26-47BE-A114-CEDEB0DDF185' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('0CA71325-DF26-47BE-A114-CEDEB0DDF185', 'd49bdeb5-8d19-4e8e-b130-5fec6e80c36e', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '0CA71325-DF26-47BE-A114-CEDEB0DDF185'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Types for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('d49bdeb5-8d19-4e8e-b130-5fec6e80c36e', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Types for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('d49bdeb5-8d19-4e8e-b130-5fec6e80c36e', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Types for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('d49bdeb5-8d19-4e8e-b130-5fec6e80c36e', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Committees */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
         , [TrackRecordChanges]
         , [AuditRecordAccess]
         , [AuditViewRuns]
         , [AllowAllRowsAPI]
         , [AllowCreateAPI]
         , [AllowUpdateAPI]
         , [AllowDeleteAPI]
         , [UserViewMaxRows]
         , [__mj_CreatedAt]
         , [__mj_UpdatedAt]
      )
      VALUES (
         '49f660ed-b5b1-4a4e-b2cd-bf048d2b0e78',
         'Committees: Committees',
         'Committees',
         'Core committee records with hierarchy support',
         NULL,
         'Committee',
         'vwCommittees',
         '${flyway:defaultSchema}',
         1,
         1,
         0
         , 1
         , 0
         , 0
         , 0
         , 1
         , 1
         , 1
         , 1000
         , GETUTCDATE()
         , GETUTCDATE()
      );

/* SQL generated to add new entity Committees: Committees to application ID: '0CA71325-DF26-47BE-A114-CEDEB0DDF185' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('0CA71325-DF26-47BE-A114-CEDEB0DDF185', '49f660ed-b5b1-4a4e-b2cd-bf048d2b0e78', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '0CA71325-DF26-47BE-A114-CEDEB0DDF185'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Committees for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('49f660ed-b5b1-4a4e-b2cd-bf048d2b0e78', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Committees for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('49f660ed-b5b1-4a4e-b2cd-bf048d2b0e78', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Committees for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('49f660ed-b5b1-4a4e-b2cd-bf048d2b0e78', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Terms */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
         , [TrackRecordChanges]
         , [AuditRecordAccess]
         , [AuditViewRuns]
         , [AllowAllRowsAPI]
         , [AllowCreateAPI]
         , [AllowUpdateAPI]
         , [AllowDeleteAPI]
         , [UserViewMaxRows]
         , [__mj_CreatedAt]
         , [__mj_UpdatedAt]
      )
      VALUES (
         '04e6285a-7cc3-4baa-9dfc-955385b3daf2',
         'Committees: Terms',
         'Terms',
         'Time periods for committee membership cycles',
         NULL,
         'Term',
         'vwTerms',
         '${flyway:defaultSchema}',
         1,
         1,
         0
         , 1
         , 0
         , 0
         , 0
         , 1
         , 1
         , 1
         , 1000
         , GETUTCDATE()
         , GETUTCDATE()
      );

/* SQL generated to add new entity Committees: Terms to application ID: '0CA71325-DF26-47BE-A114-CEDEB0DDF185' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('0CA71325-DF26-47BE-A114-CEDEB0DDF185', '04e6285a-7cc3-4baa-9dfc-955385b3daf2', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '0CA71325-DF26-47BE-A114-CEDEB0DDF185'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Terms for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('04e6285a-7cc3-4baa-9dfc-955385b3daf2', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Terms for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('04e6285a-7cc3-4baa-9dfc-955385b3daf2', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Terms for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('04e6285a-7cc3-4baa-9dfc-955385b3daf2', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Roles */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
         , [TrackRecordChanges]
         , [AuditRecordAccess]
         , [AuditViewRuns]
         , [AllowAllRowsAPI]
         , [AllowCreateAPI]
         , [AllowUpdateAPI]
         , [AllowDeleteAPI]
         , [UserViewMaxRows]
         , [__mj_CreatedAt]
         , [__mj_UpdatedAt]
      )
      VALUES (
         '0608d034-ae4b-484e-97ac-65c4c7640d36',
         'Committees: Roles',
         'Roles',
         'Roles that members can hold on committees',
         NULL,
         'Role',
         'vwRoles',
         '${flyway:defaultSchema}',
         1,
         1,
         0
         , 1
         , 0
         , 0
         , 0
         , 1
         , 1
         , 1
         , 1000
         , GETUTCDATE()
         , GETUTCDATE()
      );

/* SQL generated to add new entity Committees: Roles to application ID: '0CA71325-DF26-47BE-A114-CEDEB0DDF185' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('0CA71325-DF26-47BE-A114-CEDEB0DDF185', '0608d034-ae4b-484e-97ac-65c4c7640d36', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '0CA71325-DF26-47BE-A114-CEDEB0DDF185'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Roles for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('0608d034-ae4b-484e-97ac-65c4c7640d36', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Roles for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('0608d034-ae4b-484e-97ac-65c4c7640d36', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Roles for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('0608d034-ae4b-484e-97ac-65c4c7640d36', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Memberships */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
         , [TrackRecordChanges]
         , [AuditRecordAccess]
         , [AuditViewRuns]
         , [AllowAllRowsAPI]
         , [AllowCreateAPI]
         , [AllowUpdateAPI]
         , [AllowDeleteAPI]
         , [UserViewMaxRows]
         , [__mj_CreatedAt]
         , [__mj_UpdatedAt]
      )
      VALUES (
         '79fed512-86ca-438c-9476-efdb091c2e3c',
         'Committees: Memberships',
         'Memberships',
         'Person assignments to committees with roles and terms',
         NULL,
         'Membership',
         'vwMemberships',
         '${flyway:defaultSchema}',
         1,
         1,
         0
         , 1
         , 0
         , 0
         , 0
         , 1
         , 1
         , 1
         , 1000
         , GETUTCDATE()
         , GETUTCDATE()
      );

/* SQL generated to add new entity Committees: Memberships to application ID: '0CA71325-DF26-47BE-A114-CEDEB0DDF185' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('0CA71325-DF26-47BE-A114-CEDEB0DDF185', '79fed512-86ca-438c-9476-efdb091c2e3c', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '0CA71325-DF26-47BE-A114-CEDEB0DDF185'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Memberships for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('79fed512-86ca-438c-9476-efdb091c2e3c', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Memberships for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('79fed512-86ca-438c-9476-efdb091c2e3c', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Memberships for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('79fed512-86ca-438c-9476-efdb091c2e3c', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Video Providers */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
         , [TrackRecordChanges]
         , [AuditRecordAccess]
         , [AuditViewRuns]
         , [AllowAllRowsAPI]
         , [AllowCreateAPI]
         , [AllowUpdateAPI]
         , [AllowDeleteAPI]
         , [UserViewMaxRows]
         , [__mj_CreatedAt]
         , [__mj_UpdatedAt]
      )
      VALUES (
         '870b0b2c-29a9-4b4f-96a8-68354d969562',
         'Committees: Video Providers',
         'Video Providers',
         'Configured video conferencing providers for auto-creating meeting URLs',
         NULL,
         'VideoProvider',
         'vwVideoProviders',
         '${flyway:defaultSchema}',
         1,
         1,
         0
         , 1
         , 0
         , 0
         , 0
         , 1
         , 1
         , 1
         , 1000
         , GETUTCDATE()
         , GETUTCDATE()
      );

/* SQL generated to add new entity Committees: Video Providers to application ID: '0CA71325-DF26-47BE-A114-CEDEB0DDF185' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('0CA71325-DF26-47BE-A114-CEDEB0DDF185', '870b0b2c-29a9-4b4f-96a8-68354d969562', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '0CA71325-DF26-47BE-A114-CEDEB0DDF185'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Video Providers for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('870b0b2c-29a9-4b4f-96a8-68354d969562', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Video Providers for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('870b0b2c-29a9-4b4f-96a8-68354d969562', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Video Providers for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('870b0b2c-29a9-4b4f-96a8-68354d969562', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Meetings */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
         , [TrackRecordChanges]
         , [AuditRecordAccess]
         , [AuditViewRuns]
         , [AllowAllRowsAPI]
         , [AllowCreateAPI]
         , [AllowUpdateAPI]
         , [AllowDeleteAPI]
         , [UserViewMaxRows]
         , [__mj_CreatedAt]
         , [__mj_UpdatedAt]
      )
      VALUES (
         '543addc1-debc-4324-a23f-6a20d2924881',
         'Committees: Meetings',
         'Meetings',
         'Committee meeting records with scheduling and video conferencing info',
         NULL,
         'Meeting',
         'vwMeetings',
         '${flyway:defaultSchema}',
         1,
         1,
         0
         , 1
         , 0
         , 0
         , 0
         , 1
         , 1
         , 1
         , 1000
         , GETUTCDATE()
         , GETUTCDATE()
      );

/* SQL generated to add new entity Committees: Meetings to application ID: '0CA71325-DF26-47BE-A114-CEDEB0DDF185' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('0CA71325-DF26-47BE-A114-CEDEB0DDF185', '543addc1-debc-4324-a23f-6a20d2924881', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '0CA71325-DF26-47BE-A114-CEDEB0DDF185'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Meetings for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('543addc1-debc-4324-a23f-6a20d2924881', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Meetings for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('543addc1-debc-4324-a23f-6a20d2924881', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Meetings for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('543addc1-debc-4324-a23f-6a20d2924881', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Agenda Items */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
         , [TrackRecordChanges]
         , [AuditRecordAccess]
         , [AuditViewRuns]
         , [AllowAllRowsAPI]
         , [AllowCreateAPI]
         , [AllowUpdateAPI]
         , [AllowDeleteAPI]
         , [UserViewMaxRows]
         , [__mj_CreatedAt]
         , [__mj_UpdatedAt]
      )
      VALUES (
         '85d13f7f-f507-44b4-bfac-a7de94aa75bf',
         'Committees: Agenda Items',
         'Agenda Items',
         'Structured agenda items for meetings with hierarchy support',
         NULL,
         'AgendaItem',
         'vwAgendaItems',
         '${flyway:defaultSchema}',
         1,
         1,
         0
         , 1
         , 0
         , 0
         , 0
         , 1
         , 1
         , 1
         , 1000
         , GETUTCDATE()
         , GETUTCDATE()
      );

/* SQL generated to add new entity Committees: Agenda Items to application ID: '0CA71325-DF26-47BE-A114-CEDEB0DDF185' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('0CA71325-DF26-47BE-A114-CEDEB0DDF185', '85d13f7f-f507-44b4-bfac-a7de94aa75bf', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '0CA71325-DF26-47BE-A114-CEDEB0DDF185'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Agenda Items for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('85d13f7f-f507-44b4-bfac-a7de94aa75bf', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Agenda Items for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('85d13f7f-f507-44b4-bfac-a7de94aa75bf', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Agenda Items for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('85d13f7f-f507-44b4-bfac-a7de94aa75bf', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Attendances */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
         , [TrackRecordChanges]
         , [AuditRecordAccess]
         , [AuditViewRuns]
         , [AllowAllRowsAPI]
         , [AllowCreateAPI]
         , [AllowUpdateAPI]
         , [AllowDeleteAPI]
         , [UserViewMaxRows]
         , [__mj_CreatedAt]
         , [__mj_UpdatedAt]
      )
      VALUES (
         '7684366d-44d2-4553-a1a9-a23ac11cb8ff',
         'Committees: Attendances',
         'Attendances',
         'Meeting attendance records for committee members',
         NULL,
         'Attendance',
         'vwAttendances',
         '${flyway:defaultSchema}',
         1,
         1,
         0
         , 1
         , 0
         , 0
         , 0
         , 1
         , 1
         , 1
         , 1000
         , GETUTCDATE()
         , GETUTCDATE()
      );

/* SQL generated to add new entity Committees: Attendances to application ID: '0CA71325-DF26-47BE-A114-CEDEB0DDF185' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('0CA71325-DF26-47BE-A114-CEDEB0DDF185', '7684366d-44d2-4553-a1a9-a23ac11cb8ff', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '0CA71325-DF26-47BE-A114-CEDEB0DDF185'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Attendances for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('7684366d-44d2-4553-a1a9-a23ac11cb8ff', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Attendances for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('7684366d-44d2-4553-a1a9-a23ac11cb8ff', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Attendances for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('7684366d-44d2-4553-a1a9-a23ac11cb8ff', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Action Items */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
         , [TrackRecordChanges]
         , [AuditRecordAccess]
         , [AuditViewRuns]
         , [AllowAllRowsAPI]
         , [AllowCreateAPI]
         , [AllowUpdateAPI]
         , [AllowDeleteAPI]
         , [UserViewMaxRows]
         , [__mj_CreatedAt]
         , [__mj_UpdatedAt]
      )
      VALUES (
         '60f3019b-62e3-432f-a12c-f007cd73479c',
         'Committees: Action Items',
         'Action Items',
         'Legacy action items assigned from committees or meetings (superseded by BizAppsTasks)',
         NULL,
         'ActionItem',
         'vwActionItems',
         '${flyway:defaultSchema}',
         1,
         1,
         0
         , 1
         , 0
         , 0
         , 0
         , 1
         , 1
         , 1
         , 1000
         , GETUTCDATE()
         , GETUTCDATE()
      );

/* SQL generated to add new entity Committees: Action Items to application ID: '0CA71325-DF26-47BE-A114-CEDEB0DDF185' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('0CA71325-DF26-47BE-A114-CEDEB0DDF185', '60f3019b-62e3-432f-a12c-f007cd73479c', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '0CA71325-DF26-47BE-A114-CEDEB0DDF185'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Action Items for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('60f3019b-62e3-432f-a12c-f007cd73479c', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Action Items for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('60f3019b-62e3-432f-a12c-f007cd73479c', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Action Items for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('60f3019b-62e3-432f-a12c-f007cd73479c', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Artifact Types */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
         , [TrackRecordChanges]
         , [AuditRecordAccess]
         , [AuditViewRuns]
         , [AllowAllRowsAPI]
         , [AllowCreateAPI]
         , [AllowUpdateAPI]
         , [AllowDeleteAPI]
         , [UserViewMaxRows]
         , [__mj_CreatedAt]
         , [__mj_UpdatedAt]
      )
      VALUES (
         '47692233-8c18-4309-a466-6ad04cac4f66',
         'Committees: Artifact Types',
         'Artifact Types',
         'Categories of committee artifacts with optional extension entity for type-specific fields',
         NULL,
         'ArtifactType',
         'vwArtifactTypes',
         '${flyway:defaultSchema}',
         1,
         1,
         0
         , 1
         , 0
         , 0
         , 0
         , 1
         , 1
         , 1
         , 1000
         , GETUTCDATE()
         , GETUTCDATE()
      );

/* SQL generated to add new entity Committees: Artifact Types to application ID: '0CA71325-DF26-47BE-A114-CEDEB0DDF185' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('0CA71325-DF26-47BE-A114-CEDEB0DDF185', '47692233-8c18-4309-a466-6ad04cac4f66', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '0CA71325-DF26-47BE-A114-CEDEB0DDF185'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Artifact Types for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('47692233-8c18-4309-a466-6ad04cac4f66', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Artifact Types for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('47692233-8c18-4309-a466-6ad04cac4f66', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Artifact Types for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('47692233-8c18-4309-a466-6ad04cac4f66', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Artifacts */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
         , [TrackRecordChanges]
         , [AuditRecordAccess]
         , [AuditViewRuns]
         , [AllowAllRowsAPI]
         , [AllowCreateAPI]
         , [AllowUpdateAPI]
         , [AllowDeleteAPI]
         , [UserViewMaxRows]
         , [__mj_CreatedAt]
         , [__mj_UpdatedAt]
      )
      VALUES (
         '92933713-351a-4135-b55e-83b025c8a569',
         'Committees: Artifacts',
         'Artifacts',
         'Links to external documents and files from various providers',
         NULL,
         'Artifact',
         'vwArtifacts',
         '${flyway:defaultSchema}',
         1,
         1,
         0
         , 1
         , 0
         , 0
         , 0
         , 1
         , 1
         , 1
         , 1000
         , GETUTCDATE()
         , GETUTCDATE()
      );

/* SQL generated to add new entity Committees: Artifacts to application ID: '0CA71325-DF26-47BE-A114-CEDEB0DDF185' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('0CA71325-DF26-47BE-A114-CEDEB0DDF185', '92933713-351a-4135-b55e-83b025c8a569', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '0CA71325-DF26-47BE-A114-CEDEB0DDF185'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Artifacts for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('92933713-351a-4135-b55e-83b025c8a569', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Artifacts for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('92933713-351a-4135-b55e-83b025c8a569', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Artifacts for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('92933713-351a-4135-b55e-83b025c8a569', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL text to update existing entities from schema */
EXEC [${mjSchema}].[spUpdateExistingEntitiesFromSchema] @ExcludedSchemaNames='sys,staging,${mjSchema},${mjBACSchema},${mjSchema}_BizAppsTasks';

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Comment */
ALTER TABLE [${flyway:defaultSchema}].[Comment] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Comment */
UPDATE [${flyway:defaultSchema}].[Comment] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Comment */
ALTER TABLE [${flyway:defaultSchema}].[Comment] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Comment */
ALTER TABLE [${flyway:defaultSchema}].[Comment] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Comment___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Comment */
ALTER TABLE [${flyway:defaultSchema}].[Comment] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Comment */
UPDATE [${flyway:defaultSchema}].[Comment] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Comment */
ALTER TABLE [${flyway:defaultSchema}].[Comment] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Comment */
ALTER TABLE [${flyway:defaultSchema}].[Comment] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Comment___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Vote */
ALTER TABLE [${flyway:defaultSchema}].[Vote] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Vote */
UPDATE [${flyway:defaultSchema}].[Vote] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Vote */
ALTER TABLE [${flyway:defaultSchema}].[Vote] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Vote */
ALTER TABLE [${flyway:defaultSchema}].[Vote] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Vote___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Vote */
ALTER TABLE [${flyway:defaultSchema}].[Vote] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Vote */
UPDATE [${flyway:defaultSchema}].[Vote] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Vote */
ALTER TABLE [${flyway:defaultSchema}].[Vote] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Vote */
ALTER TABLE [${flyway:defaultSchema}].[Vote] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Vote___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Motion */
ALTER TABLE [${flyway:defaultSchema}].[Motion] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Motion */
UPDATE [${flyway:defaultSchema}].[Motion] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Motion */
ALTER TABLE [${flyway:defaultSchema}].[Motion] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Motion */
ALTER TABLE [${flyway:defaultSchema}].[Motion] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Motion___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Motion */
ALTER TABLE [${flyway:defaultSchema}].[Motion] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Motion */
UPDATE [${flyway:defaultSchema}].[Motion] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Motion */
ALTER TABLE [${flyway:defaultSchema}].[Motion] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Motion */
ALTER TABLE [${flyway:defaultSchema}].[Motion] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Motion___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Type */
ALTER TABLE [${flyway:defaultSchema}].[Type] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Type */
UPDATE [${flyway:defaultSchema}].[Type] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Type */
ALTER TABLE [${flyway:defaultSchema}].[Type] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Type */
ALTER TABLE [${flyway:defaultSchema}].[Type] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Type___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Type */
ALTER TABLE [${flyway:defaultSchema}].[Type] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Type */
UPDATE [${flyway:defaultSchema}].[Type] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Type */
ALTER TABLE [${flyway:defaultSchema}].[Type] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Type */
ALTER TABLE [${flyway:defaultSchema}].[Type] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Type___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Role */
ALTER TABLE [${flyway:defaultSchema}].[Role] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Role */
UPDATE [${flyway:defaultSchema}].[Role] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Role */
ALTER TABLE [${flyway:defaultSchema}].[Role] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Role */
ALTER TABLE [${flyway:defaultSchema}].[Role] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Role___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Role */
ALTER TABLE [${flyway:defaultSchema}].[Role] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Role */
UPDATE [${flyway:defaultSchema}].[Role] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Role */
ALTER TABLE [${flyway:defaultSchema}].[Role] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Role */
ALTER TABLE [${flyway:defaultSchema}].[Role] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Role___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.VideoProvider */
ALTER TABLE [${flyway:defaultSchema}].[VideoProvider] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.VideoProvider */
UPDATE [${flyway:defaultSchema}].[VideoProvider] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.VideoProvider */
ALTER TABLE [${flyway:defaultSchema}].[VideoProvider] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.VideoProvider */
ALTER TABLE [${flyway:defaultSchema}].[VideoProvider] ADD CONSTRAINT [DF___mj_BizAppsCommittees_VideoProvider___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.VideoProvider */
ALTER TABLE [${flyway:defaultSchema}].[VideoProvider] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.VideoProvider */
UPDATE [${flyway:defaultSchema}].[VideoProvider] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.VideoProvider */
ALTER TABLE [${flyway:defaultSchema}].[VideoProvider] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.VideoProvider */
ALTER TABLE [${flyway:defaultSchema}].[VideoProvider] ADD CONSTRAINT [DF___mj_BizAppsCommittees_VideoProvider___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Meeting */
ALTER TABLE [${flyway:defaultSchema}].[Meeting] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Meeting */
UPDATE [${flyway:defaultSchema}].[Meeting] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Meeting */
ALTER TABLE [${flyway:defaultSchema}].[Meeting] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Meeting */
ALTER TABLE [${flyway:defaultSchema}].[Meeting] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Meeting___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Meeting */
ALTER TABLE [${flyway:defaultSchema}].[Meeting] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Meeting */
UPDATE [${flyway:defaultSchema}].[Meeting] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Meeting */
ALTER TABLE [${flyway:defaultSchema}].[Meeting] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Meeting */
ALTER TABLE [${flyway:defaultSchema}].[Meeting] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Meeting___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.ArtifactType */
ALTER TABLE [${flyway:defaultSchema}].[ArtifactType] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.ArtifactType */
UPDATE [${flyway:defaultSchema}].[ArtifactType] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.ArtifactType */
ALTER TABLE [${flyway:defaultSchema}].[ArtifactType] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.ArtifactType */
ALTER TABLE [${flyway:defaultSchema}].[ArtifactType] ADD CONSTRAINT [DF___mj_BizAppsCommittees_ArtifactType___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.ArtifactType */
ALTER TABLE [${flyway:defaultSchema}].[ArtifactType] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.ArtifactType */
UPDATE [${flyway:defaultSchema}].[ArtifactType] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.ArtifactType */
ALTER TABLE [${flyway:defaultSchema}].[ArtifactType] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.ArtifactType */
ALTER TABLE [${flyway:defaultSchema}].[ArtifactType] ADD CONSTRAINT [DF___mj_BizAppsCommittees_ArtifactType___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Artifact */
ALTER TABLE [${flyway:defaultSchema}].[Artifact] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Artifact */
UPDATE [${flyway:defaultSchema}].[Artifact] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Artifact */
ALTER TABLE [${flyway:defaultSchema}].[Artifact] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Artifact */
ALTER TABLE [${flyway:defaultSchema}].[Artifact] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Artifact___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Artifact */
ALTER TABLE [${flyway:defaultSchema}].[Artifact] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Artifact */
UPDATE [${flyway:defaultSchema}].[Artifact] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Artifact */
ALTER TABLE [${flyway:defaultSchema}].[Artifact] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Artifact */
ALTER TABLE [${flyway:defaultSchema}].[Artifact] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Artifact___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Term */
ALTER TABLE [${flyway:defaultSchema}].[Term] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Term */
UPDATE [${flyway:defaultSchema}].[Term] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Term */
ALTER TABLE [${flyway:defaultSchema}].[Term] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Term */
ALTER TABLE [${flyway:defaultSchema}].[Term] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Term___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Term */
ALTER TABLE [${flyway:defaultSchema}].[Term] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Term */
UPDATE [${flyway:defaultSchema}].[Term] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Term */
ALTER TABLE [${flyway:defaultSchema}].[Term] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Term */
ALTER TABLE [${flyway:defaultSchema}].[Term] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Term___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Attendance */
ALTER TABLE [${flyway:defaultSchema}].[Attendance] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Attendance */
UPDATE [${flyway:defaultSchema}].[Attendance] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Attendance */
ALTER TABLE [${flyway:defaultSchema}].[Attendance] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Attendance */
ALTER TABLE [${flyway:defaultSchema}].[Attendance] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Attendance___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Attendance */
ALTER TABLE [${flyway:defaultSchema}].[Attendance] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Attendance */
UPDATE [${flyway:defaultSchema}].[Attendance] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Attendance */
ALTER TABLE [${flyway:defaultSchema}].[Attendance] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Attendance */
ALTER TABLE [${flyway:defaultSchema}].[Attendance] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Attendance___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.AgendaItem */
ALTER TABLE [${flyway:defaultSchema}].[AgendaItem] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.AgendaItem */
UPDATE [${flyway:defaultSchema}].[AgendaItem] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.AgendaItem */
ALTER TABLE [${flyway:defaultSchema}].[AgendaItem] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.AgendaItem */
ALTER TABLE [${flyway:defaultSchema}].[AgendaItem] ADD CONSTRAINT [DF___mj_BizAppsCommittees_AgendaItem___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.AgendaItem */
ALTER TABLE [${flyway:defaultSchema}].[AgendaItem] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.AgendaItem */
UPDATE [${flyway:defaultSchema}].[AgendaItem] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.AgendaItem */
ALTER TABLE [${flyway:defaultSchema}].[AgendaItem] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.AgendaItem */
ALTER TABLE [${flyway:defaultSchema}].[AgendaItem] ADD CONSTRAINT [DF___mj_BizAppsCommittees_AgendaItem___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Committee */
ALTER TABLE [${flyway:defaultSchema}].[Committee] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Committee */
UPDATE [${flyway:defaultSchema}].[Committee] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Committee */
ALTER TABLE [${flyway:defaultSchema}].[Committee] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Committee */
ALTER TABLE [${flyway:defaultSchema}].[Committee] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Committee___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Committee */
ALTER TABLE [${flyway:defaultSchema}].[Committee] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Committee */
UPDATE [${flyway:defaultSchema}].[Committee] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Committee */
ALTER TABLE [${flyway:defaultSchema}].[Committee] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Committee */
ALTER TABLE [${flyway:defaultSchema}].[Committee] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Committee___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Minute */
ALTER TABLE [${flyway:defaultSchema}].[Minute] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Minute */
UPDATE [${flyway:defaultSchema}].[Minute] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Minute */
ALTER TABLE [${flyway:defaultSchema}].[Minute] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Minute */
ALTER TABLE [${flyway:defaultSchema}].[Minute] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Minute___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Minute */
ALTER TABLE [${flyway:defaultSchema}].[Minute] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Minute */
UPDATE [${flyway:defaultSchema}].[Minute] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Minute */
ALTER TABLE [${flyway:defaultSchema}].[Minute] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Minute */
ALTER TABLE [${flyway:defaultSchema}].[Minute] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Minute___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Membership */
ALTER TABLE [${flyway:defaultSchema}].[Membership] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Membership */
UPDATE [${flyway:defaultSchema}].[Membership] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Membership */
ALTER TABLE [${flyway:defaultSchema}].[Membership] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.Membership */
ALTER TABLE [${flyway:defaultSchema}].[Membership] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Membership___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Membership */
ALTER TABLE [${flyway:defaultSchema}].[Membership] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Membership */
UPDATE [${flyway:defaultSchema}].[Membership] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Membership */
ALTER TABLE [${flyway:defaultSchema}].[Membership] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.Membership */
ALTER TABLE [${flyway:defaultSchema}].[Membership] ADD CONSTRAINT [DF___mj_BizAppsCommittees_Membership___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.ActionItem */
ALTER TABLE [${flyway:defaultSchema}].[ActionItem] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.ActionItem */
UPDATE [${flyway:defaultSchema}].[ActionItem] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.ActionItem */
ALTER TABLE [${flyway:defaultSchema}].[ActionItem] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}.ActionItem */
ALTER TABLE [${flyway:defaultSchema}].[ActionItem] ADD CONSTRAINT [DF___mj_BizAppsCommittees_ActionItem___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.ActionItem */
ALTER TABLE [${flyway:defaultSchema}].[ActionItem] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.ActionItem */
UPDATE [${flyway:defaultSchema}].[ActionItem] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.ActionItem */
ALTER TABLE [${flyway:defaultSchema}].[ActionItem] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}.ActionItem */
ALTER TABLE [${flyway:defaultSchema}].[ActionItem] ADD CONSTRAINT [DF___mj_BizAppsCommittees_ActionItem___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '42fdcdec-3fb4-4f66-a2b4-913b35d6f122' OR (EntityID = '6A65EEBD-8436-4FFC-9874-22D43FB91C37' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '42fdcdec-3fb4-4f66-a2b4-913b35d6f122',
            '6A65EEBD-8436-4FFC-9874-22D43FB91C37', -- Entity: Committees: Comments
            100001,
            'ID',
            'ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            'newsequentialid()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            1,
            0,
            0,
            1,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'ccb8ce89-810e-4229-acb9-4ccdcc344a55' OR (EntityID = '6A65EEBD-8436-4FFC-9874-22D43FB91C37' AND Name = 'CommitteeID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'ccb8ce89-810e-4229-acb9-4ccdcc344a55',
            '6A65EEBD-8436-4FFC-9874-22D43FB91C37', -- Entity: Committees: Comments
            100002,
            'CommitteeID',
            'Committee ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '9f4a371c-55a0-4313-bbb1-486fd7a9139a' OR (EntityID = '6A65EEBD-8436-4FFC-9874-22D43FB91C37' AND Name = 'MeetingID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '9f4a371c-55a0-4313-bbb1-486fd7a9139a',
            '6A65EEBD-8436-4FFC-9874-22D43FB91C37', -- Entity: Committees: Comments
            100003,
            'MeetingID',
            'Meeting ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '543ADDC1-DEBC-4324-A23F-6A20D2924881',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'ad388098-e601-4a13-9e1d-255965fb3ce2' OR (EntityID = '6A65EEBD-8436-4FFC-9874-22D43FB91C37' AND Name = 'AgendaItemID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'ad388098-e601-4a13-9e1d-255965fb3ce2',
            '6A65EEBD-8436-4FFC-9874-22D43FB91C37', -- Entity: Committees: Comments
            100004,
            'AgendaItemID',
            'Agenda Item ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0033110b-cab3-4ff9-a7fd-4f0023a2f9e2' OR (EntityID = '6A65EEBD-8436-4FFC-9874-22D43FB91C37' AND Name = 'TaskID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0033110b-cab3-4ff9-a7fd-4f0023a2f9e2',
            '6A65EEBD-8436-4FFC-9874-22D43FB91C37', -- Entity: Committees: Comments
            100005,
            'TaskID',
            'Task ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            'B348FFA2-B1A7-4AC2-B6FD-F4E0C0697466',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '05bdf584-1937-4031-8cda-94874707938b' OR (EntityID = '6A65EEBD-8436-4FFC-9874-22D43FB91C37' AND Name = 'ArtifactID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '05bdf584-1937-4031-8cda-94874707938b',
            '6A65EEBD-8436-4FFC-9874-22D43FB91C37', -- Entity: Committees: Comments
            100006,
            'ArtifactID',
            'Artifact ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '92933713-351A-4135-B55E-83B025C8A569',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '8505c899-7ed2-4255-a848-e8a21802712a' OR (EntityID = '6A65EEBD-8436-4FFC-9874-22D43FB91C37' AND Name = 'ParentCommentID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '8505c899-7ed2-4255-a848-e8a21802712a',
            '6A65EEBD-8436-4FFC-9874-22D43FB91C37', -- Entity: Committees: Comments
            100007,
            'ParentCommentID',
            'Parent Comment ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '6A65EEBD-8436-4FFC-9874-22D43FB91C37',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'baec348e-80ec-4097-9229-9e663c113b4f' OR (EntityID = '6A65EEBD-8436-4FFC-9874-22D43FB91C37' AND Name = 'PersonID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'baec348e-80ec-4097-9229-9e663c113b4f',
            '6A65EEBD-8436-4FFC-9874-22D43FB91C37', -- Entity: Committees: Comments
            100008,
            'PersonID',
            'Person ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '689f7267-b564-4ce9-a0c1-5c3205358a92' OR (EntityID = '6A65EEBD-8436-4FFC-9874-22D43FB91C37' AND Name = 'CommentText')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '689f7267-b564-4ce9-a0c1-5c3205358a92',
            '6A65EEBD-8436-4FFC-9874-22D43FB91C37', -- Entity: Committees: Comments
            100009,
            'CommentText',
            'Comment Text',
            NULL,
            'nvarchar',
            -1,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '30f7bf18-7e44-4788-ba56-9733967ecd26' OR (EntityID = '6A65EEBD-8436-4FFC-9874-22D43FB91C37' AND Name = 'MentionedPersonIDs')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '30f7bf18-7e44-4788-ba56-9733967ecd26',
            '6A65EEBD-8436-4FFC-9874-22D43FB91C37', -- Entity: Committees: Comments
            100010,
            'MentionedPersonIDs',
            'Mentioned Person I Ds',
            NULL,
            'nvarchar',
            -1,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'b09558f1-2e25-4754-accf-c6158b3317f9' OR (EntityID = '6A65EEBD-8436-4FFC-9874-22D43FB91C37' AND Name = 'IsResolved')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'b09558f1-2e25-4754-accf-c6158b3317f9',
            '6A65EEBD-8436-4FFC-9874-22D43FB91C37', -- Entity: Committees: Comments
            100011,
            'IsResolved',
            'Is Resolved',
            NULL,
            'bit',
            1,
            1,
            0,
            0,
            '(0)',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '84420538-722f-45ff-9d90-7d73f89c048f' OR (EntityID = '6A65EEBD-8436-4FFC-9874-22D43FB91C37' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '84420538-722f-45ff-9d90-7d73f89c048f',
            '6A65EEBD-8436-4FFC-9874-22D43FB91C37', -- Entity: Committees: Comments
            100012,
            '__mj_CreatedAt',
            'Created At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'efae4490-c553-41d2-92b5-e14706819bdc' OR (EntityID = '6A65EEBD-8436-4FFC-9874-22D43FB91C37' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'efae4490-c553-41d2-92b5-e14706819bdc',
            '6A65EEBD-8436-4FFC-9874-22D43FB91C37', -- Entity: Committees: Comments
            100013,
            '__mj_UpdatedAt',
            'Updated At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'f4634031-0baa-4766-a7d4-8e9d13d11c66' OR (EntityID = 'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'f4634031-0baa-4766-a7d4-8e9d13d11c66',
            'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF', -- Entity: Committees: Votes
            100001,
            'ID',
            'ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            'newsequentialid()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            1,
            0,
            0,
            1,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '28400d79-0525-4e81-a11d-a90e3871371b' OR (EntityID = 'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF' AND Name = 'MotionID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '28400d79-0525-4e81-a11d-a90e3871371b',
            'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF', -- Entity: Committees: Votes
            100002,
            'MotionID',
            'Motion ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            'AC908A89-225C-48CF-8852-40E612096D6C',
            'ID',
            0,
            0,
            1,
            0,
            0,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0d489164-45aa-4fcf-aec5-760203bf6f87' OR (EntityID = 'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF' AND Name = 'MembershipID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0d489164-45aa-4fcf-aec5-760203bf6f87',
            'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF', -- Entity: Committees: Votes
            100003,
            'MembershipID',
            'Membership ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            '79FED512-86CA-438C-9476-EFDB091C2E3C',
            'ID',
            0,
            0,
            1,
            0,
            0,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '96ec7fcc-85b6-418a-8fbf-05753fe85248' OR (EntityID = 'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF' AND Name = 'VoteValue')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '96ec7fcc-85b6-418a-8fbf-05753fe85248',
            'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF', -- Entity: Committees: Votes
            100004,
            'VoteValue',
            'Vote Value',
            NULL,
            'nvarchar',
            40,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'aaea3ee4-4b20-4c19-bf9a-b586364a2627' OR (EntityID = 'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF' AND Name = 'Notes')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'aaea3ee4-4b20-4c19-bf9a-b586364a2627',
            'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF', -- Entity: Committees: Votes
            100005,
            'Notes',
            'Notes',
            NULL,
            'nvarchar',
            1000,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '8211c314-3d36-40cf-b830-25e4a389ac29' OR (EntityID = 'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '8211c314-3d36-40cf-b830-25e4a389ac29',
            'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF', -- Entity: Committees: Votes
            100006,
            '__mj_CreatedAt',
            'Created At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'd0af7fc9-2ec3-40fd-84f8-4cda2cb7f558' OR (EntityID = 'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'd0af7fc9-2ec3-40fd-84f8-4cda2cb7f558',
            'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF', -- Entity: Committees: Votes
            100007,
            '__mj_UpdatedAt',
            'Updated At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '1b716203-4895-436f-9a11-7747a11bcdff' OR (EntityID = 'AC908A89-225C-48CF-8852-40E612096D6C' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '1b716203-4895-436f-9a11-7747a11bcdff',
            'AC908A89-225C-48CF-8852-40E612096D6C', -- Entity: Committees: Motions
            100001,
            'ID',
            'ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            'newsequentialid()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            1,
            0,
            0,
            1,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '79917e09-4f24-4c05-8a92-586a5bfd9dfe' OR (EntityID = 'AC908A89-225C-48CF-8852-40E612096D6C' AND Name = 'MeetingID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '79917e09-4f24-4c05-8a92-586a5bfd9dfe',
            'AC908A89-225C-48CF-8852-40E612096D6C', -- Entity: Committees: Motions
            100002,
            'MeetingID',
            'Meeting ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            '543ADDC1-DEBC-4324-A23F-6A20D2924881',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '9c796b76-96f7-4c73-9706-a5d925e246fc' OR (EntityID = 'AC908A89-225C-48CF-8852-40E612096D6C' AND Name = 'AgendaItemID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '9c796b76-96f7-4c73-9706-a5d925e246fc',
            'AC908A89-225C-48CF-8852-40E612096D6C', -- Entity: Committees: Motions
            100003,
            'AgendaItemID',
            'Agenda Item ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'edd1c2a0-6d0b-4e09-921e-e9b70cd877f9' OR (EntityID = 'AC908A89-225C-48CF-8852-40E612096D6C' AND Name = 'Sequence')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'edd1c2a0-6d0b-4e09-921e-e9b70cd877f9',
            'AC908A89-225C-48CF-8852-40E612096D6C', -- Entity: Committees: Motions
            100004,
            'Sequence',
            'Sequence',
            NULL,
            'int',
            4,
            10,
            0,
            0,
            '(1)',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '78e957ba-01e2-40e1-aba3-5b71dacb7b51' OR (EntityID = 'AC908A89-225C-48CF-8852-40E612096D6C' AND Name = 'Title')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '78e957ba-01e2-40e1-aba3-5b71dacb7b51',
            'AC908A89-225C-48CF-8852-40E612096D6C', -- Entity: Committees: Motions
            100005,
            'Title',
            'Title',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '798fc86a-3fc8-4a29-9c40-ebb3c1ce451b' OR (EntityID = 'AC908A89-225C-48CF-8852-40E612096D6C' AND Name = 'Description')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '798fc86a-3fc8-4a29-9c40-ebb3c1ce451b',
            'AC908A89-225C-48CF-8852-40E612096D6C', -- Entity: Committees: Motions
            100006,
            'Description',
            'Description',
            NULL,
            'nvarchar',
            -1,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '37309305-908c-442e-9711-e284583a37ff' OR (EntityID = 'AC908A89-225C-48CF-8852-40E612096D6C' AND Name = 'MovedByMembershipID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '37309305-908c-442e-9711-e284583a37ff',
            'AC908A89-225C-48CF-8852-40E612096D6C', -- Entity: Committees: Motions
            100007,
            'MovedByMembershipID',
            'Moved By Membership ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '79FED512-86CA-438C-9476-EFDB091C2E3C',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '4e45c0bb-83a6-49ae-9a6d-041502e27c30' OR (EntityID = 'AC908A89-225C-48CF-8852-40E612096D6C' AND Name = 'SecondedByMembershipID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '4e45c0bb-83a6-49ae-9a6d-041502e27c30',
            'AC908A89-225C-48CF-8852-40E612096D6C', -- Entity: Committees: Motions
            100008,
            'SecondedByMembershipID',
            'Seconded By Membership ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '79FED512-86CA-438C-9476-EFDB091C2E3C',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'fcd4998a-eafc-4b5a-bb25-96f7ee9b91c4' OR (EntityID = 'AC908A89-225C-48CF-8852-40E612096D6C' AND Name = 'Result')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'fcd4998a-eafc-4b5a-bb25-96f7ee9b91c4',
            'AC908A89-225C-48CF-8852-40E612096D6C', -- Entity: Committees: Motions
            100009,
            'Result',
            'Result',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Pending',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '259e7dd8-a15a-46c2-ae0e-d16dac41c0dc' OR (EntityID = 'AC908A89-225C-48CF-8852-40E612096D6C' AND Name = 'ResultSummary')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '259e7dd8-a15a-46c2-ae0e-d16dac41c0dc',
            'AC908A89-225C-48CF-8852-40E612096D6C', -- Entity: Committees: Motions
            100010,
            'ResultSummary',
            'Result Summary',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'b2af60f6-3714-414a-b333-1852edaad08e' OR (EntityID = 'AC908A89-225C-48CF-8852-40E612096D6C' AND Name = 'YesCount')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'b2af60f6-3714-414a-b333-1852edaad08e',
            'AC908A89-225C-48CF-8852-40E612096D6C', -- Entity: Committees: Motions
            100011,
            'YesCount',
            'Yes Count',
            NULL,
            'int',
            4,
            10,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'f32d9d70-40bd-48f0-a543-342632a97584' OR (EntityID = 'AC908A89-225C-48CF-8852-40E612096D6C' AND Name = 'NoCount')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'f32d9d70-40bd-48f0-a543-342632a97584',
            'AC908A89-225C-48CF-8852-40E612096D6C', -- Entity: Committees: Motions
            100012,
            'NoCount',
            'No Count',
            NULL,
            'int',
            4,
            10,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '9ebc1d34-03dd-4056-a2af-b70456673a2e' OR (EntityID = 'AC908A89-225C-48CF-8852-40E612096D6C' AND Name = 'AbstainCount')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '9ebc1d34-03dd-4056-a2af-b70456673a2e',
            'AC908A89-225C-48CF-8852-40E612096D6C', -- Entity: Committees: Motions
            100013,
            'AbstainCount',
            'Abstain Count',
            NULL,
            'int',
            4,
            10,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '4b0af217-58e9-4e5d-9d51-c05e69afce76' OR (EntityID = 'AC908A89-225C-48CF-8852-40E612096D6C' AND Name = 'Notes')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '4b0af217-58e9-4e5d-9d51-c05e69afce76',
            'AC908A89-225C-48CF-8852-40E612096D6C', -- Entity: Committees: Motions
            100014,
            'Notes',
            'Notes',
            NULL,
            'nvarchar',
            -1,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '8ae862fa-5a74-4990-b6c9-92ede5c962ec' OR (EntityID = 'AC908A89-225C-48CF-8852-40E612096D6C' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '8ae862fa-5a74-4990-b6c9-92ede5c962ec',
            'AC908A89-225C-48CF-8852-40E612096D6C', -- Entity: Committees: Motions
            100015,
            '__mj_CreatedAt',
            'Created At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '98c6d8ab-1a76-459d-8a23-1a97720e4ca1' OR (EntityID = 'AC908A89-225C-48CF-8852-40E612096D6C' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '98c6d8ab-1a76-459d-8a23-1a97720e4ca1',
            'AC908A89-225C-48CF-8852-40E612096D6C', -- Entity: Committees: Motions
            100016,
            '__mj_UpdatedAt',
            'Updated At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'e0e4adeb-0743-47f0-8377-9221f9ec0306' OR (EntityID = 'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'e0e4adeb-0743-47f0-8377-9221f9ec0306',
            'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E', -- Entity: Committees: Types
            100001,
            'ID',
            'ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            'newsequentialid()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            1,
            0,
            0,
            1,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'b9b3b6fe-3198-48ab-97b1-f3615879365e' OR (EntityID = 'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E' AND Name = 'Name')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'b9b3b6fe-3198-48ab-97b1-f3615879365e',
            'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E', -- Entity: Committees: Types
            100002,
            'Name',
            'Name',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            1,
            1,
            0,
            1,
            0,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'cdae1488-eb19-45d2-a3e6-f956984eecf1' OR (EntityID = 'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E' AND Name = 'Description')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'cdae1488-eb19-45d2-a3e6-f956984eecf1',
            'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E', -- Entity: Committees: Types
            100003,
            'Description',
            'Description',
            NULL,
            'nvarchar',
            -1,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'a0173bc7-d780-44bd-a801-4615aece1b60' OR (EntityID = 'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E' AND Name = 'IsStandards')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'a0173bc7-d780-44bd-a801-4615aece1b60',
            'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E', -- Entity: Committees: Types
            100004,
            'IsStandards',
            'Is Standards',
            NULL,
            'bit',
            1,
            1,
            0,
            0,
            '(0)',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '1a06ddea-17dc-4669-91d0-bc9ba455eb17' OR (EntityID = 'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E' AND Name = 'DefaultTermMonths')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '1a06ddea-17dc-4669-91d0-bc9ba455eb17',
            'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E', -- Entity: Committees: Types
            100005,
            'DefaultTermMonths',
            'Default Term Months',
            NULL,
            'int',
            4,
            10,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '91932706-b5a2-447c-b217-9c549cb37965' OR (EntityID = 'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E' AND Name = 'IconClass')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '91932706-b5a2-447c-b217-9c549cb37965',
            'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E', -- Entity: Committees: Types
            100006,
            'IconClass',
            'Icon Class',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '51ea257e-cf4b-4c79-a2ff-70d1545dd804' OR (EntityID = 'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '51ea257e-cf4b-4c79-a2ff-70d1545dd804',
            'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E', -- Entity: Committees: Types
            100007,
            '__mj_CreatedAt',
            'Created At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0dfe55c7-0a73-4263-8064-dfb998f64c45' OR (EntityID = 'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0dfe55c7-0a73-4263-8064-dfb998f64c45',
            'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E', -- Entity: Committees: Types
            100008,
            '__mj_UpdatedAt',
            'Updated At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2f951811-a07c-4ffe-9c2e-62d7b3261434' OR (EntityID = '0608D034-AE4B-484E-97AC-65C4C7640D36' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '2f951811-a07c-4ffe-9c2e-62d7b3261434',
            '0608D034-AE4B-484E-97AC-65C4C7640D36', -- Entity: Committees: Roles
            100001,
            'ID',
            'ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            'newsequentialid()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            1,
            0,
            0,
            1,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'beda2769-cab2-452e-969d-cee776bf5772' OR (EntityID = '0608D034-AE4B-484E-97AC-65C4C7640D36' AND Name = 'Name')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'beda2769-cab2-452e-969d-cee776bf5772',
            '0608D034-AE4B-484E-97AC-65C4C7640D36', -- Entity: Committees: Roles
            100002,
            'Name',
            'Name',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            1,
            1,
            0,
            1,
            0,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'a8e942bc-d720-49d9-a005-8f4b5bda0a28' OR (EntityID = '0608D034-AE4B-484E-97AC-65C4C7640D36' AND Name = 'Description')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'a8e942bc-d720-49d9-a005-8f4b5bda0a28',
            '0608D034-AE4B-484E-97AC-65C4C7640D36', -- Entity: Committees: Roles
            100003,
            'Description',
            'Description',
            NULL,
            'nvarchar',
            -1,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '83eb8cc1-905e-4d91-80cf-207cc15fd4c9' OR (EntityID = '0608D034-AE4B-484E-97AC-65C4C7640D36' AND Name = 'IsOfficer')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '83eb8cc1-905e-4d91-80cf-207cc15fd4c9',
            '0608D034-AE4B-484E-97AC-65C4C7640D36', -- Entity: Committees: Roles
            100004,
            'IsOfficer',
            'Is Officer',
            NULL,
            'bit',
            1,
            1,
            0,
            0,
            '(0)',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'c683fcff-c6e5-499d-b44f-6ba41a994ba4' OR (EntityID = '0608D034-AE4B-484E-97AC-65C4C7640D36' AND Name = 'IsVotingRole')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'c683fcff-c6e5-499d-b44f-6ba41a994ba4',
            '0608D034-AE4B-484E-97AC-65C4C7640D36', -- Entity: Committees: Roles
            100005,
            'IsVotingRole',
            'Is Voting Role',
            NULL,
            'bit',
            1,
            1,
            0,
            0,
            '(1)',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '6ae8d517-09b2-44e1-8b03-9c8542375dc8' OR (EntityID = '0608D034-AE4B-484E-97AC-65C4C7640D36' AND Name = 'DefaultPermissionsJSON')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '6ae8d517-09b2-44e1-8b03-9c8542375dc8',
            '0608D034-AE4B-484E-97AC-65C4C7640D36', -- Entity: Committees: Roles
            100006,
            'DefaultPermissionsJSON',
            'Default Permissions JSON',
            NULL,
            'nvarchar',
            -1,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2b83b174-5d89-4c25-8609-760959e382df' OR (EntityID = '0608D034-AE4B-484E-97AC-65C4C7640D36' AND Name = 'Sequence')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '2b83b174-5d89-4c25-8609-760959e382df',
            '0608D034-AE4B-484E-97AC-65C4C7640D36', -- Entity: Committees: Roles
            100007,
            'Sequence',
            'Sequence',
            NULL,
            'int',
            4,
            10,
            0,
            0,
            '(100)',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '9d34d099-2e9a-4577-877e-77eff3abd75d' OR (EntityID = '0608D034-AE4B-484E-97AC-65C4C7640D36' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '9d34d099-2e9a-4577-877e-77eff3abd75d',
            '0608D034-AE4B-484E-97AC-65C4C7640D36', -- Entity: Committees: Roles
            100008,
            '__mj_CreatedAt',
            'Created At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '71bf42b9-f0f5-4a60-b83d-4d31455b06d0' OR (EntityID = '0608D034-AE4B-484E-97AC-65C4C7640D36' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '71bf42b9-f0f5-4a60-b83d-4d31455b06d0',
            '0608D034-AE4B-484E-97AC-65C4C7640D36', -- Entity: Committees: Roles
            100009,
            '__mj_UpdatedAt',
            'Updated At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '797d8972-7a34-438a-9dd3-9eb6cf1221eb' OR (EntityID = '870B0B2C-29A9-4B4F-96A8-68354D969562' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '797d8972-7a34-438a-9dd3-9eb6cf1221eb',
            '870B0B2C-29A9-4B4F-96A8-68354D969562', -- Entity: Committees: Video Providers
            100001,
            'ID',
            'ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            'newsequentialid()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            1,
            0,
            0,
            1,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'e62d7d15-c19b-476c-903f-695972e18e9d' OR (EntityID = '870B0B2C-29A9-4B4F-96A8-68354D969562' AND Name = 'Name')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'e62d7d15-c19b-476c-903f-695972e18e9d',
            '870B0B2C-29A9-4B4F-96A8-68354D969562', -- Entity: Committees: Video Providers
            100002,
            'Name',
            'Name',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            1,
            1,
            0,
            1,
            0,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'b02621a0-f2c7-48a9-91a4-e6a60a55a415' OR (EntityID = '870B0B2C-29A9-4B4F-96A8-68354D969562' AND Name = 'ServerDriverKey')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'b02621a0-f2c7-48a9-91a4-e6a60a55a415',
            '870B0B2C-29A9-4B4F-96A8-68354D969562', -- Entity: Committees: Video Providers
            100003,
            'ServerDriverKey',
            'Server Driver Key',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'b2bdd117-ea30-45a8-a220-90fc3f2f53d1' OR (EntityID = '870B0B2C-29A9-4B4F-96A8-68354D969562' AND Name = 'IsActive')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'b2bdd117-ea30-45a8-a220-90fc3f2f53d1',
            '870B0B2C-29A9-4B4F-96A8-68354D969562', -- Entity: Committees: Video Providers
            100004,
            'IsActive',
            'Is Active',
            NULL,
            'bit',
            1,
            1,
            0,
            0,
            '(1)',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '4f8c7c38-1c18-4090-9158-9be475b0d6a2' OR (EntityID = '870B0B2C-29A9-4B4F-96A8-68354D969562' AND Name = 'IsDefault')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '4f8c7c38-1c18-4090-9158-9be475b0d6a2',
            '870B0B2C-29A9-4B4F-96A8-68354D969562', -- Entity: Committees: Video Providers
            100005,
            'IsDefault',
            'Is Default',
            NULL,
            'bit',
            1,
            1,
            0,
            0,
            '(0)',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'bc5b9497-6cf7-4079-a9e1-f63cf2b370cf' OR (EntityID = '870B0B2C-29A9-4B4F-96A8-68354D969562' AND Name = 'CredentialID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'bc5b9497-6cf7-4079-a9e1-f63cf2b370cf',
            '870B0B2C-29A9-4B4F-96A8-68354D969562', -- Entity: Committees: Video Providers
            100006,
            'CredentialID',
            'Credential ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '7E023DDF-82C6-4B0C-9650-8D35699B9FD0',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '69184033-68f6-4d81-a7d6-ec5b3dceb652' OR (EntityID = '870B0B2C-29A9-4B4F-96A8-68354D969562' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '69184033-68f6-4d81-a7d6-ec5b3dceb652',
            '870B0B2C-29A9-4B4F-96A8-68354D969562', -- Entity: Committees: Video Providers
            100007,
            '__mj_CreatedAt',
            'Created At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '3ed97a4d-77e9-4e4f-bcba-54dd57219571' OR (EntityID = '870B0B2C-29A9-4B4F-96A8-68354D969562' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '3ed97a4d-77e9-4e4f-bcba-54dd57219571',
            '870B0B2C-29A9-4B4F-96A8-68354D969562', -- Entity: Committees: Video Providers
            100008,
            '__mj_UpdatedAt',
            'Updated At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '1eaeb956-e81e-4bc0-9eae-645711001260' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '1eaeb956-e81e-4bc0-9eae-645711001260',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100001,
            'ID',
            'ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            'newsequentialid()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            1,
            0,
            0,
            1,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0920b300-e269-4ee4-976a-582cf49136c4' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = 'CommitteeID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0920b300-e269-4ee4-976a-582cf49136c4',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100002,
            'CommitteeID',
            'Committee ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'cca255a7-816a-4b49-b1e8-1274bb5950d2' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = 'Title')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'cca255a7-816a-4b49-b1e8-1274bb5950d2',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100003,
            'Title',
            'Title',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '896bb776-b9d6-4fc2-9fa8-515a81ea7786' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = 'Description')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '896bb776-b9d6-4fc2-9fa8-515a81ea7786',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100004,
            'Description',
            'Description',
            NULL,
            'nvarchar',
            -1,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'e57b2946-85ac-4813-bdd8-72b4ff7fc4f6' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = 'StartDateTime')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'e57b2946-85ac-4813-bdd8-72b4ff7fc4f6',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100005,
            'StartDateTime',
            'Start Date Time',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '833d0dbd-1f81-496e-9607-1a237a4171b8' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = 'EndDateTime')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '833d0dbd-1f81-496e-9607-1a237a4171b8',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100006,
            'EndDateTime',
            'End Date Time',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2cc32fd2-39cc-4f0f-8773-cb785a0d53da' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = 'TimeZone')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '2cc32fd2-39cc-4f0f-8773-cb785a0d53da',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100007,
            'TimeZone',
            'Time Zone',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'America/New_York',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'de630981-4687-41c2-9c18-27b14ccac871' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = 'LocationType')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'de630981-4687-41c2-9c18-27b14ccac871',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100008,
            'LocationType',
            'Location Type',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Virtual',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '5ec945b4-44aa-4683-a7fe-a911faa8de57' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = 'LocationText')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '5ec945b4-44aa-4683-a7fe-a911faa8de57',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100009,
            'LocationText',
            'Location Text',
            NULL,
            'nvarchar',
            1000,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '1e7fcd57-9d6d-4d56-ab57-6b1064630adc' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = 'VideoProvider')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '1e7fcd57-9d6d-4d56-ab57-6b1064630adc',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100010,
            'VideoProvider',
            'Video Provider',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'cbc39996-e357-41af-9210-8c38ca72503a' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = 'VideoProviderID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'cbc39996-e357-41af-9210-8c38ca72503a',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100011,
            'VideoProviderID',
            'Video Provider ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '870B0B2C-29A9-4B4F-96A8-68354D969562',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '8db4c439-bd8d-41f7-a739-9ac066440774' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = 'VideoMeetingID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '8db4c439-bd8d-41f7-a739-9ac066440774',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100012,
            'VideoMeetingID',
            'Video Meeting ID',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2be797fe-bdf2-4dbd-aaec-05b2fca6f9f7' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = 'VideoJoinURL')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '2be797fe-bdf2-4dbd-aaec-05b2fca6f9f7',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100013,
            'VideoJoinURL',
            'Video Join URL',
            NULL,
            'nvarchar',
            2000,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2faaab3a-8936-4c77-9976-2a7e8b66fae5' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = 'VideoRecordingURL')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '2faaab3a-8936-4c77-9976-2a7e8b66fae5',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100014,
            'VideoRecordingURL',
            'Video Recording URL',
            NULL,
            'nvarchar',
            2000,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '6db445cd-86bb-4a6b-b722-51dd1ec3cca0' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = 'TranscriptURL')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '6db445cd-86bb-4a6b-b722-51dd1ec3cca0',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100015,
            'TranscriptURL',
            'Transcript URL',
            NULL,
            'nvarchar',
            2000,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '957a9d0e-65b1-4381-8138-6b79be00ceb5' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = 'Status')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '957a9d0e-65b1-4381-8138-6b79be00ceb5',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100016,
            'Status',
            'Status',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Scheduled',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '9ec76fbe-cb3a-4074-8f67-32c9399334f6' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = 'CalendarEventID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '9ec76fbe-cb3a-4074-8f67-32c9399334f6',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100017,
            'CalendarEventID',
            'Calendar Event ID',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '66788412-6c0c-4ae8-afae-5d78efff24ce' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '66788412-6c0c-4ae8-afae-5d78efff24ce',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100018,
            '__mj_CreatedAt',
            'Created At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'faf90298-5976-420b-b0d7-088e840cb173' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'faf90298-5976-420b-b0d7-088e840cb173',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100019,
            '__mj_UpdatedAt',
            'Updated At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '36463b65-6fca-446f-afde-ecc07790d1c7' OR (EntityID = '47692233-8C18-4309-A466-6AD04CAC4F66' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '36463b65-6fca-446f-afde-ecc07790d1c7',
            '47692233-8C18-4309-A466-6AD04CAC4F66', -- Entity: Committees: Artifact Types
            100001,
            'ID',
            'ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            'newsequentialid()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            1,
            0,
            0,
            1,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '15e25d52-6fe6-4d16-995b-4ebd7a33664e' OR (EntityID = '47692233-8C18-4309-A466-6AD04CAC4F66' AND Name = 'Name')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '15e25d52-6fe6-4d16-995b-4ebd7a33664e',
            '47692233-8C18-4309-A466-6AD04CAC4F66', -- Entity: Committees: Artifact Types
            100002,
            'Name',
            'Name',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            1,
            1,
            0,
            1,
            0,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '63f2f542-0bc7-4d7b-99a3-fc82d2f3d1eb' OR (EntityID = '47692233-8C18-4309-A466-6AD04CAC4F66' AND Name = 'Description')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '63f2f542-0bc7-4d7b-99a3-fc82d2f3d1eb',
            '47692233-8C18-4309-A466-6AD04CAC4F66', -- Entity: Committees: Artifact Types
            100003,
            'Description',
            'Description',
            NULL,
            'nvarchar',
            -1,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '9e2b6b03-0583-41b1-a8c8-d93e843a0b7d' OR (EntityID = '47692233-8C18-4309-A466-6AD04CAC4F66' AND Name = 'ExtendedEntityID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '9e2b6b03-0583-41b1-a8c8-d93e843a0b7d',
            '47692233-8C18-4309-A466-6AD04CAC4F66', -- Entity: Committees: Artifact Types
            100004,
            'ExtendedEntityID',
            'Extended Entity ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            'E0238F34-2837-EF11-86D4-6045BDEE16E6',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'a821c5c7-975c-4917-9a59-efd719545090' OR (EntityID = '47692233-8C18-4309-A466-6AD04CAC4F66' AND Name = 'IconClass')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'a821c5c7-975c-4917-9a59-efd719545090',
            '47692233-8C18-4309-A466-6AD04CAC4F66', -- Entity: Committees: Artifact Types
            100005,
            'IconClass',
            'Icon Class',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '17f6be54-6e73-4efe-af93-c5a86a3bdad8' OR (EntityID = '47692233-8C18-4309-A466-6AD04CAC4F66' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '17f6be54-6e73-4efe-af93-c5a86a3bdad8',
            '47692233-8C18-4309-A466-6AD04CAC4F66', -- Entity: Committees: Artifact Types
            100006,
            '__mj_CreatedAt',
            'Created At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '1274180b-2c9c-4e1b-9002-1cba51416e97' OR (EntityID = '47692233-8C18-4309-A466-6AD04CAC4F66' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '1274180b-2c9c-4e1b-9002-1cba51416e97',
            '47692233-8C18-4309-A466-6AD04CAC4F66', -- Entity: Committees: Artifact Types
            100007,
            '__mj_UpdatedAt',
            'Updated At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '97d05e82-9860-4efa-9f37-72d4aad69e3b' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '97d05e82-9860-4efa-9f37-72d4aad69e3b',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100001,
            'ID',
            'ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            'newsequentialid()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            1,
            0,
            0,
            1,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'bf94b523-4284-498d-adbd-d7949cbf6429' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = 'CommitteeID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'bf94b523-4284-498d-adbd-d7949cbf6429',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100002,
            'CommitteeID',
            'Committee ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '3264eb1e-95dc-4c02-851b-d2bdfc3ed05a' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = 'MeetingID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '3264eb1e-95dc-4c02-851b-d2bdfc3ed05a',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100003,
            'MeetingID',
            'Meeting ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '543ADDC1-DEBC-4324-A23F-6A20D2924881',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'f9b4e369-c0bc-42b2-bf8a-ff00a890f3fc' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = 'AgendaItemID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'f9b4e369-c0bc-42b2-bf8a-ff00a890f3fc',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100004,
            'AgendaItemID',
            'Agenda Item ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '8f561bca-07f9-4b75-b3a5-cffefc8a0bc2' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = 'TaskID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '8f561bca-07f9-4b75-b3a5-cffefc8a0bc2',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100005,
            'TaskID',
            'Task ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            'B348FFA2-B1A7-4AC2-B6FD-F4E0C0697466',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'fceaffd3-dff9-4b44-85ad-ebd7cc20c7a5' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = 'Title')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'fceaffd3-dff9-4b44-85ad-ebd7cc20c7a5',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100006,
            'Title',
            'Title',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '134c712a-651f-4f87-ab31-7dc066bb2eaf' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = 'Description')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '134c712a-651f-4f87-ab31-7dc066bb2eaf',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100007,
            'Description',
            'Description',
            NULL,
            'nvarchar',
            -1,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '145e51f5-f522-46f5-8aba-487183ac31bc' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = 'ArtifactTypeID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '145e51f5-f522-46f5-8aba-487183ac31bc',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100008,
            'ArtifactTypeID',
            'Artifact Type ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            '47692233-8C18-4309-A466-6AD04CAC4F66',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '67ce1fd6-7483-463b-84ce-249070f9c93b' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = 'Provider')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '67ce1fd6-7483-463b-84ce-249070f9c93b',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100009,
            'Provider',
            'Provider',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'c9b656ea-e472-4fc3-8f41-9e2f73a07cad' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = 'ExternalID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'c9b656ea-e472-4fc3-8f41-9e2f73a07cad',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100010,
            'ExternalID',
            'External ID',
            NULL,
            'nvarchar',
            1000,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '943799a2-edc9-43fb-ad0f-27fba8849c28' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = 'URL')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '943799a2-edc9-43fb-ad0f-27fba8849c28',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100011,
            'URL',
            'URL',
            NULL,
            'nvarchar',
            4000,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'dc884038-624a-48c0-8923-8c01ec4b5667' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = 'MimeType')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'dc884038-624a-48c0-8923-8c01ec4b5667',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100012,
            'MimeType',
            'Mime Type',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'b512062a-2bc1-4089-9256-4a067a451c58' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = 'FileSize')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'b512062a-2bc1-4089-9256-4a067a451c58',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100013,
            'FileSize',
            'File Size',
            NULL,
            'bigint',
            8,
            19,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '7781b7d4-f59d-4999-ba79-66f5960a04be' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = 'UploadedByPersonID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '7781b7d4-f59d-4999-ba79-66f5960a04be',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100014,
            'UploadedByPersonID',
            'Uploaded By Person ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'a4005aac-0b28-430b-a00f-7e971d81cff7' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'a4005aac-0b28-430b-a00f-7e971d81cff7',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100015,
            '__mj_CreatedAt',
            'Created At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'a5a1f1bf-b567-4378-8e56-d7c59e1108d7' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'a5a1f1bf-b567-4378-8e56-d7c59e1108d7',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100016,
            '__mj_UpdatedAt',
            'Updated At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '261da650-dfa8-4071-a8e3-2f1c7ae9710b' OR (EntityID = '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '261da650-dfa8-4071-a8e3-2f1c7ae9710b',
            '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2', -- Entity: Committees: Terms
            100001,
            'ID',
            'ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            'newsequentialid()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            1,
            0,
            0,
            1,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'c5a5a349-5501-4316-8d6f-8380d68ae0d3' OR (EntityID = '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2' AND Name = 'CommitteeID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'c5a5a349-5501-4316-8d6f-8380d68ae0d3',
            '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2', -- Entity: Committees: Terms
            100002,
            'CommitteeID',
            'Committee ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '46312b97-3598-4fb0-a2e7-56f3a96405a3' OR (EntityID = '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2' AND Name = 'Name')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '46312b97-3598-4fb0-a2e7-56f3a96405a3',
            '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2', -- Entity: Committees: Terms
            100003,
            'Name',
            'Name',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            1,
            1,
            0,
            1,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0bc33639-5f59-4991-aa18-416f7bef0cf4' OR (EntityID = '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2' AND Name = 'StartDate')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0bc33639-5f59-4991-aa18-416f7bef0cf4',
            '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2', -- Entity: Committees: Terms
            100004,
            'StartDate',
            'Start Date',
            NULL,
            'date',
            3,
            10,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'e7833565-23c6-4fcc-8b8e-660d7563652e' OR (EntityID = '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2' AND Name = 'EndDate')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'e7833565-23c6-4fcc-8b8e-660d7563652e',
            '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2', -- Entity: Committees: Terms
            100005,
            'EndDate',
            'End Date',
            NULL,
            'date',
            3,
            10,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0d129acc-b43b-4c00-9ae6-93c01cf2c629' OR (EntityID = '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2' AND Name = 'Status')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0d129acc-b43b-4c00-9ae6-93c01cf2c629',
            '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2', -- Entity: Committees: Terms
            100006,
            'Status',
            'Status',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Active',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'ed11c41d-fdc6-4189-9067-692a6d2fc4e9' OR (EntityID = '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'ed11c41d-fdc6-4189-9067-692a6d2fc4e9',
            '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2', -- Entity: Committees: Terms
            100007,
            '__mj_CreatedAt',
            'Created At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '44713532-93d6-4add-abae-adee85338586' OR (EntityID = '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '44713532-93d6-4add-abae-adee85338586',
            '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2', -- Entity: Committees: Terms
            100008,
            '__mj_UpdatedAt',
            'Updated At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '486ff82c-33c2-469c-b85e-3f47ea36d5e3' OR (EntityID = '7684366D-44D2-4553-A1A9-A23AC11CB8FF' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '486ff82c-33c2-469c-b85e-3f47ea36d5e3',
            '7684366D-44D2-4553-A1A9-A23AC11CB8FF', -- Entity: Committees: Attendances
            100001,
            'ID',
            'ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            'newsequentialid()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            1,
            0,
            0,
            1,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '5244d975-f60e-49c2-840f-c8c056907b8f' OR (EntityID = '7684366D-44D2-4553-A1A9-A23AC11CB8FF' AND Name = 'MeetingID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '5244d975-f60e-49c2-840f-c8c056907b8f',
            '7684366D-44D2-4553-A1A9-A23AC11CB8FF', -- Entity: Committees: Attendances
            100002,
            'MeetingID',
            'Meeting ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            '543ADDC1-DEBC-4324-A23F-6A20D2924881',
            'ID',
            0,
            0,
            1,
            0,
            0,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'dd046d10-db26-4d33-8ac8-4b883fb10f8a' OR (EntityID = '7684366D-44D2-4553-A1A9-A23AC11CB8FF' AND Name = 'PersonID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'dd046d10-db26-4d33-8ac8-4b883fb10f8a',
            '7684366D-44D2-4553-A1A9-A23AC11CB8FF', -- Entity: Committees: Attendances
            100003,
            'PersonID',
            'Person ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F',
            'ID',
            0,
            0,
            1,
            0,
            0,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '4c3db2c0-9702-4b7b-8a7f-8f5326798758' OR (EntityID = '7684366D-44D2-4553-A1A9-A23AC11CB8FF' AND Name = 'AttendanceStatus')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '4c3db2c0-9702-4b7b-8a7f-8f5326798758',
            '7684366D-44D2-4553-A1A9-A23AC11CB8FF', -- Entity: Committees: Attendances
            100004,
            'AttendanceStatus',
            'Attendance Status',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Expected',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2638961a-f4c5-4c49-b988-bfe3278564db' OR (EntityID = '7684366D-44D2-4553-A1A9-A23AC11CB8FF' AND Name = 'JoinedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '2638961a-f4c5-4c49-b988-bfe3278564db',
            '7684366D-44D2-4553-A1A9-A23AC11CB8FF', -- Entity: Committees: Attendances
            100005,
            'JoinedAt',
            'Joined At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '1e2cd4e6-db2c-4199-8457-945661cef2fe' OR (EntityID = '7684366D-44D2-4553-A1A9-A23AC11CB8FF' AND Name = 'LeftAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '1e2cd4e6-db2c-4199-8457-945661cef2fe',
            '7684366D-44D2-4553-A1A9-A23AC11CB8FF', -- Entity: Committees: Attendances
            100006,
            'LeftAt',
            'Left At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'e3310356-1d40-4bcb-840d-87b55fc45a23' OR (EntityID = '7684366D-44D2-4553-A1A9-A23AC11CB8FF' AND Name = 'Notes')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'e3310356-1d40-4bcb-840d-87b55fc45a23',
            '7684366D-44D2-4553-A1A9-A23AC11CB8FF', -- Entity: Committees: Attendances
            100007,
            'Notes',
            'Notes',
            NULL,
            'nvarchar',
            1000,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'a0a50ea6-d1bc-4b1c-a23b-5905a7cdbe60' OR (EntityID = '7684366D-44D2-4553-A1A9-A23AC11CB8FF' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'a0a50ea6-d1bc-4b1c-a23b-5905a7cdbe60',
            '7684366D-44D2-4553-A1A9-A23AC11CB8FF', -- Entity: Committees: Attendances
            100008,
            '__mj_CreatedAt',
            'Created At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0e8651c9-4389-489d-b912-3ceb18b7de6e' OR (EntityID = '7684366D-44D2-4553-A1A9-A23AC11CB8FF' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0e8651c9-4389-489d-b912-3ceb18b7de6e',
            '7684366D-44D2-4553-A1A9-A23AC11CB8FF', -- Entity: Committees: Attendances
            100009,
            '__mj_UpdatedAt',
            'Updated At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'fcb4465d-ace3-417a-a462-e7dbcc028f38' OR (EntityID = '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'fcb4465d-ace3-417a-a462-e7dbcc028f38',
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', -- Entity: Committees: Agenda Items
            100001,
            'ID',
            'ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            'newsequentialid()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            1,
            0,
            0,
            1,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '78faf628-4a9a-4764-8dc3-ddfea1081cae' OR (EntityID = '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF' AND Name = 'MeetingID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '78faf628-4a9a-4764-8dc3-ddfea1081cae',
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', -- Entity: Committees: Agenda Items
            100002,
            'MeetingID',
            'Meeting ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            '543ADDC1-DEBC-4324-A23F-6A20D2924881',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '9cce488c-02ce-4585-95d1-b1d45aa32b0c' OR (EntityID = '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF' AND Name = 'ParentAgendaItemID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '9cce488c-02ce-4585-95d1-b1d45aa32b0c',
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', -- Entity: Committees: Agenda Items
            100003,
            'ParentAgendaItemID',
            'Parent Agenda Item ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'aa486ee4-8b3b-475e-8e19-b1dc60730b45' OR (EntityID = '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF' AND Name = 'Sequence')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'aa486ee4-8b3b-475e-8e19-b1dc60730b45',
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', -- Entity: Committees: Agenda Items
            100004,
            'Sequence',
            'Sequence',
            NULL,
            'int',
            4,
            10,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '9cf904de-d835-4663-8091-ada2d85bb439' OR (EntityID = '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF' AND Name = 'Title')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '9cf904de-d835-4663-8091-ada2d85bb439',
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', -- Entity: Committees: Agenda Items
            100005,
            'Title',
            'Title',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'ef6bf9f0-d97c-4526-a485-91ca78f8154d' OR (EntityID = '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF' AND Name = 'Description')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'ef6bf9f0-d97c-4526-a485-91ca78f8154d',
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', -- Entity: Committees: Agenda Items
            100006,
            'Description',
            'Description',
            NULL,
            'nvarchar',
            -1,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'f22704c8-75f3-4a4d-834f-c279e5966d65' OR (EntityID = '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF' AND Name = 'PresenterPersonID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'f22704c8-75f3-4a4d-834f-c279e5966d65',
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', -- Entity: Committees: Agenda Items
            100007,
            'PresenterPersonID',
            'Presenter Person ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '58a4f1ad-c397-4eb2-9dec-0da1f429485b' OR (EntityID = '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF' AND Name = 'DurationMinutes')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '58a4f1ad-c397-4eb2-9dec-0da1f429485b',
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', -- Entity: Committees: Agenda Items
            100008,
            'DurationMinutes',
            'Duration Minutes',
            NULL,
            'int',
            4,
            10,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'b139c1a4-9d27-4b30-90d0-611af18fff59' OR (EntityID = '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF' AND Name = 'ItemType')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'b139c1a4-9d27-4b30-90d0-611af18fff59',
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', -- Entity: Committees: Agenda Items
            100009,
            'ItemType',
            'Item Type',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Discussion',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'e53dc59b-72e9-403f-8dbb-53d85d7366fb' OR (EntityID = '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF' AND Name = 'RelatedDocumentURL')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'e53dc59b-72e9-403f-8dbb-53d85d7366fb',
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', -- Entity: Committees: Agenda Items
            100010,
            'RelatedDocumentURL',
            'Related Document URL',
            NULL,
            'nvarchar',
            2000,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '901ac105-906c-4a00-b54e-101140b50c0f' OR (EntityID = '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF' AND Name = 'Status')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '901ac105-906c-4a00-b54e-101140b50c0f',
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', -- Entity: Committees: Agenda Items
            100011,
            'Status',
            'Status',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Pending',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '23367b7e-5e21-441e-9eb3-d4c639dd54df' OR (EntityID = '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF' AND Name = 'Notes')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '23367b7e-5e21-441e-9eb3-d4c639dd54df',
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', -- Entity: Committees: Agenda Items
            100012,
            'Notes',
            'Notes',
            NULL,
            'nvarchar',
            -1,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '5d0c2498-4b22-4721-839b-34e3798d2090' OR (EntityID = '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '5d0c2498-4b22-4721-839b-34e3798d2090',
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', -- Entity: Committees: Agenda Items
            100013,
            '__mj_CreatedAt',
            'Created At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '9942df7f-1325-46ac-bd1f-023c5fbfd47c' OR (EntityID = '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '9942df7f-1325-46ac-bd1f-023c5fbfd47c',
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', -- Entity: Committees: Agenda Items
            100014,
            '__mj_UpdatedAt',
            'Updated At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'f509e494-9b8b-4788-95f5-b9ec7ac5cbc2' OR (EntityID = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'f509e494-9b8b-4788-95f5-b9ec7ac5cbc2',
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', -- Entity: Committees: Committees
            100001,
            'ID',
            'ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            'newsequentialid()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            1,
            0,
            0,
            1,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '5d1a0e9c-c403-4d7a-967c-47e36e241de2' OR (EntityID = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78' AND Name = 'Name')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '5d1a0e9c-c403-4d7a-967c-47e36e241de2',
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', -- Entity: Committees: Committees
            100002,
            'Name',
            'Name',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            1,
            1,
            0,
            1,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0e7251f3-04ec-4f3a-a526-5e1a5176f36c' OR (EntityID = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78' AND Name = 'Description')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0e7251f3-04ec-4f3a-a526-5e1a5176f36c',
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', -- Entity: Committees: Committees
            100003,
            'Description',
            'Description',
            NULL,
            'nvarchar',
            -1,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'b791235e-ed08-4169-8c97-60d292c3dd31' OR (EntityID = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78' AND Name = 'TypeID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'b791235e-ed08-4169-8c97-60d292c3dd31',
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', -- Entity: Committees: Committees
            100004,
            'TypeID',
            'Type ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '688dfeb5-e302-4237-af4c-c9b6c1e661d9' OR (EntityID = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78' AND Name = 'ParentCommitteeID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '688dfeb5-e302-4237-af4c-c9b6c1e661d9',
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', -- Entity: Committees: Committees
            100005,
            'ParentCommitteeID',
            'Parent Committee ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'b3ae4a14-d2fe-467d-80d0-8d91fd7fd105' OR (EntityID = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78' AND Name = 'OrganizationID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'b3ae4a14-d2fe-467d-80d0-8d91fd7fd105',
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', -- Entity: Committees: Committees
            100006,
            'OrganizationID',
            'Organization ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            'C70448F9-9792-41D7-A82C-784B66429D54',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '1f05ea9d-0f19-40a9-a4d2-12bc987b6a62' OR (EntityID = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78' AND Name = 'CharterDocumentURL')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '1f05ea9d-0f19-40a9-a4d2-12bc987b6a62',
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', -- Entity: Committees: Committees
            100007,
            'CharterDocumentURL',
            'Charter Document URL',
            NULL,
            'nvarchar',
            2000,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '1614627f-17d0-47b1-babf-7bda4b8a4b23' OR (EntityID = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78' AND Name = 'MissionStatement')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '1614627f-17d0-47b1-babf-7bda4b8a4b23',
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', -- Entity: Committees: Committees
            100008,
            'MissionStatement',
            'Mission Statement',
            NULL,
            'nvarchar',
            -1,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '8fa3cb95-d411-4061-8898-9060716fd2c1' OR (EntityID = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78' AND Name = 'Status')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '8fa3cb95-d411-4061-8898-9060716fd2c1',
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', -- Entity: Committees: Committees
            100009,
            'Status',
            'Status',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Active',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2f2d3c21-4439-4e6a-8388-a1d7be908db1' OR (EntityID = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78' AND Name = 'IsPublic')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '2f2d3c21-4439-4e6a-8388-a1d7be908db1',
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', -- Entity: Committees: Committees
            100010,
            'IsPublic',
            'Is Public',
            NULL,
            'bit',
            1,
            1,
            0,
            0,
            '(1)',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'a3820ef4-91f6-47f8-bc2a-d4ba42958bc4' OR (EntityID = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78' AND Name = 'FormationDate')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'a3820ef4-91f6-47f8-bc2a-d4ba42958bc4',
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', -- Entity: Committees: Committees
            100011,
            'FormationDate',
            'Formation Date',
            NULL,
            'date',
            3,
            10,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'eab38918-456c-4e20-b96b-57b6f26f7c3b' OR (EntityID = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78' AND Name = 'DissolutionDate')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'eab38918-456c-4e20-b96b-57b6f26f7c3b',
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', -- Entity: Committees: Committees
            100012,
            'DissolutionDate',
            'Dissolution Date',
            NULL,
            'date',
            3,
            10,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0fb1f3a0-eb7f-4e53-ae15-0ad6327bfd53' OR (EntityID = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0fb1f3a0-eb7f-4e53-ae15-0ad6327bfd53',
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', -- Entity: Committees: Committees
            100013,
            '__mj_CreatedAt',
            'Created At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '200543d6-3117-4aab-9e63-0474f9ca4222' OR (EntityID = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '200543d6-3117-4aab-9e63-0474f9ca4222',
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', -- Entity: Committees: Committees
            100014,
            '__mj_UpdatedAt',
            'Updated At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '990ad624-694d-4184-bcd3-891380f7e408' OR (EntityID = 'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '990ad624-694d-4184-bcd3-891380f7e408',
            'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A', -- Entity: Committees: Minutes
            100001,
            'ID',
            'ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            'newsequentialid()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            1,
            0,
            0,
            1,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'ee5964a2-1dee-4142-a788-f39690cedd20' OR (EntityID = 'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A' AND Name = 'ArtifactID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'ee5964a2-1dee-4142-a788-f39690cedd20',
            'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A', -- Entity: Committees: Minutes
            100002,
            'ArtifactID',
            'Artifact ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '92933713-351A-4135-B55E-83B025C8A569',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '85c8c511-22e4-40fa-baea-cc18d232d6f9' OR (EntityID = 'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A' AND Name = 'MeetingID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '85c8c511-22e4-40fa-baea-cc18d232d6f9',
            'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A', -- Entity: Committees: Minutes
            100003,
            'MeetingID',
            'Meeting ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '543ADDC1-DEBC-4324-A23F-6A20D2924881',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'fe5e695b-4c84-4ac9-92b6-93a853f064cf' OR (EntityID = 'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A' AND Name = 'Content')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'fe5e695b-4c84-4ac9-92b6-93a853f064cf',
            'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A', -- Entity: Committees: Minutes
            100004,
            'Content',
            'Content',
            NULL,
            'nvarchar',
            -1,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'a14d9204-694d-4bdc-9a63-6c0b1237630b' OR (EntityID = 'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A' AND Name = 'ApprovalStatus')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'a14d9204-694d-4bdc-9a63-6c0b1237630b',
            'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A', -- Entity: Committees: Minutes
            100005,
            'ApprovalStatus',
            'Approval Status',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Draft',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'bddff128-30b7-40a9-989f-d248fd049629' OR (EntityID = 'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A' AND Name = 'ApprovedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'bddff128-30b7-40a9-989f-d248fd049629',
            'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A', -- Entity: Committees: Minutes
            100006,
            'ApprovedAt',
            'Approved At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '78dc61d2-672f-480d-afba-1971953074b7' OR (EntityID = 'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A' AND Name = 'ApprovedByMeetingID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '78dc61d2-672f-480d-afba-1971953074b7',
            'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A', -- Entity: Committees: Minutes
            100007,
            'ApprovedByMeetingID',
            'Approved By Meeting ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '543ADDC1-DEBC-4324-A23F-6A20D2924881',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0d852446-bb08-419a-be62-b8db0bb372f4' OR (EntityID = 'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A' AND Name = 'Notes')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0d852446-bb08-419a-be62-b8db0bb372f4',
            'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A', -- Entity: Committees: Minutes
            100008,
            'Notes',
            'Notes',
            NULL,
            'nvarchar',
            -1,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'ab08bcc4-f374-4807-a6f1-29a92c973a6b' OR (EntityID = 'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'ab08bcc4-f374-4807-a6f1-29a92c973a6b',
            'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A', -- Entity: Committees: Minutes
            100009,
            '__mj_CreatedAt',
            'Created At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '793948a8-e1c7-4b55-9ff9-d0f2bb2e753f' OR (EntityID = 'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '793948a8-e1c7-4b55-9ff9-d0f2bb2e753f',
            'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A', -- Entity: Committees: Minutes
            100010,
            '__mj_UpdatedAt',
            'Updated At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '32b3bd38-6183-4634-aa15-bf655ac824ca' OR (EntityID = '79FED512-86CA-438C-9476-EFDB091C2E3C' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '32b3bd38-6183-4634-aa15-bf655ac824ca',
            '79FED512-86CA-438C-9476-EFDB091C2E3C', -- Entity: Committees: Memberships
            100001,
            'ID',
            'ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            'newsequentialid()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            1,
            0,
            0,
            1,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '5626bf59-b910-4ae3-aa51-a9cabf3102a9' OR (EntityID = '79FED512-86CA-438C-9476-EFDB091C2E3C' AND Name = 'PersonID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '5626bf59-b910-4ae3-aa51-a9cabf3102a9',
            '79FED512-86CA-438C-9476-EFDB091C2E3C', -- Entity: Committees: Memberships
            100002,
            'PersonID',
            'Person ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'f6c680f8-c4d0-4860-8763-603d9d2cf9e7' OR (EntityID = '79FED512-86CA-438C-9476-EFDB091C2E3C' AND Name = 'RoleID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'f6c680f8-c4d0-4860-8763-603d9d2cf9e7',
            '79FED512-86CA-438C-9476-EFDB091C2E3C', -- Entity: Committees: Memberships
            100003,
            'RoleID',
            'Role ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            '0608D034-AE4B-484E-97AC-65C4C7640D36',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0b9a63ea-3e56-4174-aa54-94e843e063fb' OR (EntityID = '79FED512-86CA-438C-9476-EFDB091C2E3C' AND Name = 'TermID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0b9a63ea-3e56-4174-aa54-94e843e063fb',
            '79FED512-86CA-438C-9476-EFDB091C2E3C', -- Entity: Committees: Memberships
            100004,
            'TermID',
            'Term ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '916666d0-56c9-4813-ad57-33df9605fa74' OR (EntityID = '79FED512-86CA-438C-9476-EFDB091C2E3C' AND Name = 'StartDate')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '916666d0-56c9-4813-ad57-33df9605fa74',
            '79FED512-86CA-438C-9476-EFDB091C2E3C', -- Entity: Committees: Memberships
            100005,
            'StartDate',
            'Start Date',
            NULL,
            'date',
            3,
            10,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '39f4cf52-fe6b-4aff-850f-4dc0cdf13ada' OR (EntityID = '79FED512-86CA-438C-9476-EFDB091C2E3C' AND Name = 'EndDate')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '39f4cf52-fe6b-4aff-850f-4dc0cdf13ada',
            '79FED512-86CA-438C-9476-EFDB091C2E3C', -- Entity: Committees: Memberships
            100006,
            'EndDate',
            'End Date',
            NULL,
            'date',
            3,
            10,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '29693c42-aca2-4be7-a44c-a6d8637f7752' OR (EntityID = '79FED512-86CA-438C-9476-EFDB091C2E3C' AND Name = 'Status')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '29693c42-aca2-4be7-a44c-a6d8637f7752',
            '79FED512-86CA-438C-9476-EFDB091C2E3C', -- Entity: Committees: Memberships
            100007,
            'Status',
            'Status',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Active',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '94a75681-58b7-421a-aa84-ebbdb044342b' OR (EntityID = '79FED512-86CA-438C-9476-EFDB091C2E3C' AND Name = 'EndReason')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '94a75681-58b7-421a-aa84-ebbdb044342b',
            '79FED512-86CA-438C-9476-EFDB091C2E3C', -- Entity: Committees: Memberships
            100008,
            'EndReason',
            'End Reason',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'ff271a4e-95ea-4bd8-80f4-cbbfafbde00b' OR (EntityID = '79FED512-86CA-438C-9476-EFDB091C2E3C' AND Name = 'Notes')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'ff271a4e-95ea-4bd8-80f4-cbbfafbde00b',
            '79FED512-86CA-438C-9476-EFDB091C2E3C', -- Entity: Committees: Memberships
            100009,
            'Notes',
            'Notes',
            NULL,
            'nvarchar',
            -1,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '3d4dca98-d415-42c6-a50b-5e2bed79df33' OR (EntityID = '79FED512-86CA-438C-9476-EFDB091C2E3C' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '3d4dca98-d415-42c6-a50b-5e2bed79df33',
            '79FED512-86CA-438C-9476-EFDB091C2E3C', -- Entity: Committees: Memberships
            100010,
            '__mj_CreatedAt',
            'Created At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '4101723b-48d2-4136-9bb1-a591357bbaf9' OR (EntityID = '79FED512-86CA-438C-9476-EFDB091C2E3C' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '4101723b-48d2-4136-9bb1-a591357bbaf9',
            '79FED512-86CA-438C-9476-EFDB091C2E3C', -- Entity: Committees: Memberships
            100011,
            '__mj_UpdatedAt',
            'Updated At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '079b8549-91f7-4f26-9d50-958858443921' OR (EntityID = '60F3019B-62E3-432F-A12C-F007CD73479C' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '079b8549-91f7-4f26-9d50-958858443921',
            '60F3019B-62E3-432F-A12C-F007CD73479C', -- Entity: Committees: Action Items
            100001,
            'ID',
            'ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            'newsequentialid()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            1,
            0,
            0,
            1,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2e17e5b8-a39e-45f3-8bfb-369193f614f6' OR (EntityID = '60F3019B-62E3-432F-A12C-F007CD73479C' AND Name = 'CommitteeID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '2e17e5b8-a39e-45f3-8bfb-369193f614f6',
            '60F3019B-62E3-432F-A12C-F007CD73479C', -- Entity: Committees: Action Items
            100002,
            'CommitteeID',
            'Committee ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '1f413a48-f658-450a-898e-1f6b3cdb1cd0' OR (EntityID = '60F3019B-62E3-432F-A12C-F007CD73479C' AND Name = 'MeetingID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '1f413a48-f658-450a-898e-1f6b3cdb1cd0',
            '60F3019B-62E3-432F-A12C-F007CD73479C', -- Entity: Committees: Action Items
            100003,
            'MeetingID',
            'Meeting ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '543ADDC1-DEBC-4324-A23F-6A20D2924881',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '61b73f48-b965-44e6-b6d1-0521c2a68ad1' OR (EntityID = '60F3019B-62E3-432F-A12C-F007CD73479C' AND Name = 'AgendaItemID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '61b73f48-b965-44e6-b6d1-0521c2a68ad1',
            '60F3019B-62E3-432F-A12C-F007CD73479C', -- Entity: Committees: Action Items
            100004,
            'AgendaItemID',
            'Agenda Item ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '3c23769a-da86-404e-9e37-975e98ebf073' OR (EntityID = '60F3019B-62E3-432F-A12C-F007CD73479C' AND Name = 'Title')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '3c23769a-da86-404e-9e37-975e98ebf073',
            '60F3019B-62E3-432F-A12C-F007CD73479C', -- Entity: Committees: Action Items
            100005,
            'Title',
            'Title',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '98ea9ee1-9a69-4312-8536-d8cb43e55797' OR (EntityID = '60F3019B-62E3-432F-A12C-F007CD73479C' AND Name = 'Description')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '98ea9ee1-9a69-4312-8536-d8cb43e55797',
            '60F3019B-62E3-432F-A12C-F007CD73479C', -- Entity: Committees: Action Items
            100006,
            'Description',
            'Description',
            NULL,
            'nvarchar',
            -1,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '4fb2faa6-11bf-43e5-ba39-77d5629c06c9' OR (EntityID = '60F3019B-62E3-432F-A12C-F007CD73479C' AND Name = 'AssignedToPersonID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '4fb2faa6-11bf-43e5-ba39-77d5629c06c9',
            '60F3019B-62E3-432F-A12C-F007CD73479C', -- Entity: Committees: Action Items
            100007,
            'AssignedToPersonID',
            'Assigned To Person ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            0,
            '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'ae66b201-ba27-43e5-b297-7b4a19e45d50' OR (EntityID = '60F3019B-62E3-432F-A12C-F007CD73479C' AND Name = 'AssignedByPersonID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'ae66b201-ba27-43e5-b297-7b4a19e45d50',
            '60F3019B-62E3-432F-A12C-F007CD73479C', -- Entity: Committees: Action Items
            100008,
            'AssignedByPersonID',
            'Assigned By Person ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '66556560-5fb1-4876-b152-8972776f9042' OR (EntityID = '60F3019B-62E3-432F-A12C-F007CD73479C' AND Name = 'DueDate')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '66556560-5fb1-4876-b152-8972776f9042',
            '60F3019B-62E3-432F-A12C-F007CD73479C', -- Entity: Committees: Action Items
            100009,
            'DueDate',
            'Due Date',
            NULL,
            'date',
            3,
            10,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '25eba2be-3d67-4c3d-82ba-4131f30c0c4a' OR (EntityID = '60F3019B-62E3-432F-A12C-F007CD73479C' AND Name = 'Priority')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '25eba2be-3d67-4c3d-82ba-4131f30c0c4a',
            '60F3019B-62E3-432F-A12C-F007CD73479C', -- Entity: Committees: Action Items
            100010,
            'Priority',
            'Priority',
            NULL,
            'nvarchar',
            40,
            0,
            0,
            0,
            'Medium',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '24ff726c-18a7-4369-97e9-9d19f3c08dd7' OR (EntityID = '60F3019B-62E3-432F-A12C-F007CD73479C' AND Name = 'Status')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '24ff726c-18a7-4369-97e9-9d19f3c08dd7',
            '60F3019B-62E3-432F-A12C-F007CD73479C', -- Entity: Committees: Action Items
            100011,
            'Status',
            'Status',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Open',
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '51e51318-e47a-43d9-bdc2-a9dc4674b593' OR (EntityID = '60F3019B-62E3-432F-A12C-F007CD73479C' AND Name = 'CompletedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '51e51318-e47a-43d9-bdc2-a9dc4674b593',
            '60F3019B-62E3-432F-A12C-F007CD73479C', -- Entity: Committees: Action Items
            100012,
            'CompletedAt',
            'Completed At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '9e40bb0f-dc6e-490c-b7d1-0c9c85b93865' OR (EntityID = '60F3019B-62E3-432F-A12C-F007CD73479C' AND Name = 'CompletionNotes')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '9e40bb0f-dc6e-490c-b7d1-0c9c85b93865',
            '60F3019B-62E3-432F-A12C-F007CD73479C', -- Entity: Committees: Action Items
            100013,
            'CompletionNotes',
            'Completion Notes',
            NULL,
            'nvarchar',
            -1,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'f7d22428-454b-40b0-8063-9c25e5f28477' OR (EntityID = '60F3019B-62E3-432F-A12C-F007CD73479C' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'f7d22428-454b-40b0-8063-9c25e5f28477',
            '60F3019B-62E3-432F-A12C-F007CD73479C', -- Entity: Committees: Action Items
            100014,
            '__mj_CreatedAt',
            'Created At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '1ab681f0-accc-4c8b-be7f-1279bf9aa941' OR (EntityID = '60F3019B-62E3-432F-A12C-F007CD73479C' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '1ab681f0-accc-4c8b-be7f-1279bf9aa941',
            '60F3019B-62E3-432F-A12C-F007CD73479C', -- Entity: Committees: Action Items
            100015,
            '__mj_UpdatedAt',
            'Updated At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to update existing entity fields from schema */
EXEC [${mjSchema}].[spUpdateExistingEntityFieldsFromSchema] @ExcludedSchemaNames='sys,staging,${mjSchema},${mjBACSchema},${mjSchema}_BizAppsTasks';

/* SQL text to set default column width where needed */
EXEC [${mjSchema}].[spSetDefaultColumnWidthWhereNeeded] @ExcludedSchemaNames='sys,staging,${mjSchema},${mjBACSchema},${mjSchema}_BizAppsTasks';

/* SQL text to insert entity field value with ID fe8167e1-7a4d-4a3f-899c-b55554655556 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('fe8167e1-7a4d-4a3f-899c-b55554655556', '67CE1FD6-7483-463B-84CE-249070F9C93B', 1, 'Box', 'Box', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID b28d61ab-2cae-4aff-8337-b290e31ce3f7 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('b28d61ab-2cae-4aff-8337-b290e31ce3f7', '67CE1FD6-7483-463B-84CE-249070F9C93B', 2, 'Dropbox', 'Dropbox', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID bfb400ca-43ef-4149-ad05-5b69a7b5e8c3 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('bfb400ca-43ef-4149-ad05-5b69a7b5e8c3', '67CE1FD6-7483-463B-84CE-249070F9C93B', 3, 'GoogleDrive', 'GoogleDrive', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 297d6b7d-e3e5-4239-afd3-2976e770ef31 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('297d6b7d-e3e5-4239-afd3-2976e770ef31', '67CE1FD6-7483-463B-84CE-249070F9C93B', 4, 'OneDrive', 'OneDrive', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 869b152b-7aa4-4114-9009-387bfc6bedfd */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('869b152b-7aa4-4114-9009-387bfc6bedfd', '67CE1FD6-7483-463B-84CE-249070F9C93B', 5, 'SharePoint', 'SharePoint', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 59d6e1d4-a677-4304-b2e4-663fee74c1ed */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('59d6e1d4-a677-4304-b2e4-663fee74c1ed', '67CE1FD6-7483-463B-84CE-249070F9C93B', 6, 'URL', 'URL', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 67CE1FD6-7483-463B-84CE-249070F9C93B */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='67CE1FD6-7483-463B-84CE-249070F9C93B';

/* SQL text to insert entity field value with ID e1661f25-2825-4979-a412-bdf5dd3e513a */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('e1661f25-2825-4979-a412-bdf5dd3e513a', 'A14D9204-694D-4BDC-9A63-6C0B1237630B', 1, 'Approved', 'Approved', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 2cda0026-c58c-4d3c-a15b-019e8e2a6451 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('2cda0026-c58c-4d3c-a15b-019e8e2a6451', 'A14D9204-694D-4BDC-9A63-6C0B1237630B', 2, 'Draft', 'Draft', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 2846abfc-0c9a-4861-bc1e-08cddc254308 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('2846abfc-0c9a-4861-bc1e-08cddc254308', 'A14D9204-694D-4BDC-9A63-6C0B1237630B', 3, 'PendingApproval', 'PendingApproval', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID b2035ec3-5c59-42e0-84aa-08026b1f0d64 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('b2035ec3-5c59-42e0-84aa-08026b1f0d64', 'A14D9204-694D-4BDC-9A63-6C0B1237630B', 4, 'Rejected', 'Rejected', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID A14D9204-694D-4BDC-9A63-6C0B1237630B */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='A14D9204-694D-4BDC-9A63-6C0B1237630B';

/* SQL text to insert entity field value with ID f8bd3513-c9d1-440c-8987-f7ad878228dd */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('f8bd3513-c9d1-440c-8987-f7ad878228dd', 'FCD4998A-EAFC-4B5A-BB25-96F7EE9B91C4', 1, 'Failed', 'Failed', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID abedb29a-a209-4f63-baf7-ef1b41828cfd */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('abedb29a-a209-4f63-baf7-ef1b41828cfd', 'FCD4998A-EAFC-4B5A-BB25-96F7EE9B91C4', 2, 'Passed', 'Passed', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID ccc2fb66-f7db-4431-a921-2911e738812e */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('ccc2fb66-f7db-4431-a921-2911e738812e', 'FCD4998A-EAFC-4B5A-BB25-96F7EE9B91C4', 3, 'Pending', 'Pending', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID a8ad4beb-0256-446a-8121-be90b29e4a0c */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('a8ad4beb-0256-446a-8121-be90b29e4a0c', 'FCD4998A-EAFC-4B5A-BB25-96F7EE9B91C4', 4, 'Tabled', 'Tabled', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 2a489cbf-02ad-43d2-aa62-76b2ff142e41 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('2a489cbf-02ad-43d2-aa62-76b2ff142e41', 'FCD4998A-EAFC-4B5A-BB25-96F7EE9B91C4', 5, 'Withdrawn', 'Withdrawn', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID FCD4998A-EAFC-4B5A-BB25-96F7EE9B91C4 */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='FCD4998A-EAFC-4B5A-BB25-96F7EE9B91C4';

/* SQL text to insert entity field value with ID 54f84bcf-2307-432e-aaf5-a968259233b4 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('54f84bcf-2307-432e-aaf5-a968259233b4', '96EC7FCC-85B6-418A-8FBF-05753FE85248', 1, 'Absent', 'Absent', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 4cd0d6ad-6d3f-43bd-bc16-c79a584e58a5 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('4cd0d6ad-6d3f-43bd-bc16-c79a584e58a5', '96EC7FCC-85B6-418A-8FBF-05753FE85248', 2, 'Abstain', 'Abstain', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 0fe1c05d-c25b-4772-8e58-6bf8f6256203 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('0fe1c05d-c25b-4772-8e58-6bf8f6256203', '96EC7FCC-85B6-418A-8FBF-05753FE85248', 3, 'No', 'No', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID db041809-6476-4f3f-8d05-c7aeb05372b2 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('db041809-6476-4f3f-8d05-c7aeb05372b2', '96EC7FCC-85B6-418A-8FBF-05753FE85248', 4, 'Yes', 'Yes', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 96EC7FCC-85B6-418A-8FBF-05753FE85248 */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='96EC7FCC-85B6-418A-8FBF-05753FE85248';

/* SQL text to insert entity field value with ID 2c87e2ae-94cb-49c5-b703-6361c3989d21 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('2c87e2ae-94cb-49c5-b703-6361c3989d21', '8FA3CB95-D411-4061-8898-9060716FD2C1', 1, 'Active', 'Active', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID f12e912c-92e8-4916-86bb-d444c240836f */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('f12e912c-92e8-4916-86bb-d444c240836f', '8FA3CB95-D411-4061-8898-9060716FD2C1', 2, 'Dissolved', 'Dissolved', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID aec4aec6-fcf9-4d29-b651-9c5f29a41967 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('aec4aec6-fcf9-4d29-b651-9c5f29a41967', '8FA3CB95-D411-4061-8898-9060716FD2C1', 3, 'Inactive', 'Inactive', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID f79b806f-aa87-4308-b3a5-3ef5e8723dfe */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('f79b806f-aa87-4308-b3a5-3ef5e8723dfe', '8FA3CB95-D411-4061-8898-9060716FD2C1', 4, 'Pending', 'Pending', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 8FA3CB95-D411-4061-8898-9060716FD2C1 */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='8FA3CB95-D411-4061-8898-9060716FD2C1';

/* SQL text to insert entity field value with ID 72132669-ef91-4529-a7dc-2e4f065a07ba */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('72132669-ef91-4529-a7dc-2e4f065a07ba', '0D129ACC-B43B-4C00-9AE6-93C01CF2C629', 1, 'Active', 'Active', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 3df245ad-9cde-4920-9c43-ca5dbd203238 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('3df245ad-9cde-4920-9c43-ca5dbd203238', '0D129ACC-B43B-4C00-9AE6-93C01CF2C629', 2, 'Completed', 'Completed', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 978de45b-0d46-423b-b985-73f1de685aa2 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('978de45b-0d46-423b-b985-73f1de685aa2', '0D129ACC-B43B-4C00-9AE6-93C01CF2C629', 3, 'Upcoming', 'Upcoming', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 0D129ACC-B43B-4C00-9AE6-93C01CF2C629 */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='0D129ACC-B43B-4C00-9AE6-93C01CF2C629';

/* SQL text to insert entity field value with ID 60b4ba7b-4c3f-4823-9670-bfc985118b38 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('60b4ba7b-4c3f-4823-9670-bfc985118b38', '29693C42-ACA2-4BE7-A44C-A6D8637F7752', 1, 'Active', 'Active', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 53c37944-b00f-4c11-8857-9adc66fab566 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('53c37944-b00f-4c11-8857-9adc66fab566', '29693C42-ACA2-4BE7-A44C-A6D8637F7752', 2, 'Ended', 'Ended', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID cf6c1bf0-b3c8-484a-9068-a4735c70cf3d */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('cf6c1bf0-b3c8-484a-9068-a4735c70cf3d', '29693C42-ACA2-4BE7-A44C-A6D8637F7752', 3, 'Pending', 'Pending', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 0d5b90b0-a78a-4fe4-b4d3-62668e56d630 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('0d5b90b0-a78a-4fe4-b4d3-62668e56d630', '29693C42-ACA2-4BE7-A44C-A6D8637F7752', 4, 'Suspended', 'Suspended', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 29693C42-ACA2-4BE7-A44C-A6D8637F7752 */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='29693C42-ACA2-4BE7-A44C-A6D8637F7752';

/* SQL text to insert entity field value with ID a6587e29-b429-485c-bd93-7019107fd2e0 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('a6587e29-b429-485c-bd93-7019107fd2e0', '957A9D0E-65B1-4381-8138-6B79BE00CEB5', 1, 'Cancelled', 'Cancelled', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID d773c4f8-d883-4603-89ee-eae62c25758d */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('d773c4f8-d883-4603-89ee-eae62c25758d', '957A9D0E-65B1-4381-8138-6B79BE00CEB5', 2, 'Completed', 'Completed', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID ea8ee9a0-0231-438e-8b06-2f1cf012d210 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('ea8ee9a0-0231-438e-8b06-2f1cf012d210', '957A9D0E-65B1-4381-8138-6B79BE00CEB5', 3, 'Draft', 'Draft', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 3c5e95b7-d006-4725-aea2-bcb091fdd9ef */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('3c5e95b7-d006-4725-aea2-bcb091fdd9ef', '957A9D0E-65B1-4381-8138-6B79BE00CEB5', 4, 'InProgress', 'InProgress', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID da8cfd7f-eb8f-45ec-ab40-7a179ec61d63 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('da8cfd7f-eb8f-45ec-ab40-7a179ec61d63', '957A9D0E-65B1-4381-8138-6B79BE00CEB5', 5, 'Postponed', 'Postponed', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 1b62d90d-3ff4-408d-b8da-d65bea2597a2 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('1b62d90d-3ff4-408d-b8da-d65bea2597a2', '957A9D0E-65B1-4381-8138-6B79BE00CEB5', 6, 'Scheduled', 'Scheduled', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 957A9D0E-65B1-4381-8138-6B79BE00CEB5 */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='957A9D0E-65B1-4381-8138-6B79BE00CEB5';

/* SQL text to insert entity field value with ID 9c393a55-2bb2-4923-a8f0-b7fd6e7674dc */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('9c393a55-2bb2-4923-a8f0-b7fd6e7674dc', 'DE630981-4687-41C2-9C18-27B14CCAC871', 1, 'Hybrid', 'Hybrid', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 510552a7-ca0b-43d1-a9f0-66e86c39040b */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('510552a7-ca0b-43d1-a9f0-66e86c39040b', 'DE630981-4687-41C2-9C18-27B14CCAC871', 2, 'InPerson', 'InPerson', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID ea34bba5-f55c-4e62-89e9-2f0d6b7a2211 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('ea34bba5-f55c-4e62-89e9-2f0d6b7a2211', 'DE630981-4687-41C2-9C18-27B14CCAC871', 3, 'Virtual', 'Virtual', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID DE630981-4687-41C2-9C18-27B14CCAC871 */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='DE630981-4687-41C2-9C18-27B14CCAC871';

/* SQL text to insert entity field value with ID cdc8ab11-7013-4207-9467-c5e310c15f73 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('cdc8ab11-7013-4207-9467-c5e310c15f73', 'B139C1A4-9D27-4B30-90D0-611AF18FFF59', 1, 'Action', 'Action', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID f9ffacd9-d561-4266-af02-ef1be797da51 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('f9ffacd9-d561-4266-af02-ef1be797da51', 'B139C1A4-9D27-4B30-90D0-611AF18FFF59', 2, 'Discussion', 'Discussion', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 49c97e41-9e8f-4f3a-b90a-f8fc4e57774e */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('49c97e41-9e8f-4f3a-b90a-f8fc4e57774e', 'B139C1A4-9D27-4B30-90D0-611AF18FFF59', 3, 'Information', 'Information', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID d0350fa5-1fa9-4002-ba8b-bf7660a08609 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('d0350fa5-1fa9-4002-ba8b-bf7660a08609', 'B139C1A4-9D27-4B30-90D0-611AF18FFF59', 4, 'Other', 'Other', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID e62f8d05-7240-40ff-bd4c-f10c868f6972 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('e62f8d05-7240-40ff-bd4c-f10c868f6972', 'B139C1A4-9D27-4B30-90D0-611AF18FFF59', 5, 'Report', 'Report', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 0ad5c76b-b6a0-4b2f-95a9-8a7d4cbfec41 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('0ad5c76b-b6a0-4b2f-95a9-8a7d4cbfec41', 'B139C1A4-9D27-4B30-90D0-611AF18FFF59', 6, 'Vote', 'Vote', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID B139C1A4-9D27-4B30-90D0-611AF18FFF59 */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='B139C1A4-9D27-4B30-90D0-611AF18FFF59';

/* SQL text to insert entity field value with ID 8bf6fb17-52fa-498a-b877-145578de90d0 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('8bf6fb17-52fa-498a-b877-145578de90d0', '901AC105-906C-4A00-B54E-101140B50C0F', 1, 'Completed', 'Completed', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 7235088b-1df4-4f2c-a5ee-311345ac35bf */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('7235088b-1df4-4f2c-a5ee-311345ac35bf', '901AC105-906C-4A00-B54E-101140B50C0F', 2, 'Discussed', 'Discussed', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID dac91d50-c622-40ae-8389-79e4720975b9 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('dac91d50-c622-40ae-8389-79e4720975b9', '901AC105-906C-4A00-B54E-101140B50C0F', 3, 'Pending', 'Pending', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID cdeb74b8-0c47-46c4-978a-ed4ad53ccc95 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('cdeb74b8-0c47-46c4-978a-ed4ad53ccc95', '901AC105-906C-4A00-B54E-101140B50C0F', 4, 'Skipped', 'Skipped', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 8d557478-24ef-4c69-8572-ab39989ec200 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('8d557478-24ef-4c69-8572-ab39989ec200', '901AC105-906C-4A00-B54E-101140B50C0F', 5, 'Tabled', 'Tabled', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 901AC105-906C-4A00-B54E-101140B50C0F */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='901AC105-906C-4A00-B54E-101140B50C0F';

/* SQL text to insert entity field value with ID 04b58f86-8f0d-43d6-8123-bb4405a65d4e */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('04b58f86-8f0d-43d6-8123-bb4405a65d4e', '4C3DB2C0-9702-4B7B-8A7F-8F5326798758', 1, 'Absent', 'Absent', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 06b9e624-2297-4187-a87d-e48248d94932 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('06b9e624-2297-4187-a87d-e48248d94932', '4C3DB2C0-9702-4B7B-8A7F-8F5326798758', 2, 'Excused', 'Excused', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 3fe3cd7e-a8df-40ca-860a-0f0de9d97613 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('3fe3cd7e-a8df-40ca-860a-0f0de9d97613', '4C3DB2C0-9702-4B7B-8A7F-8F5326798758', 3, 'Expected', 'Expected', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 2a830387-a476-4245-8a61-e3717841635d */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('2a830387-a476-4245-8a61-e3717841635d', '4C3DB2C0-9702-4B7B-8A7F-8F5326798758', 4, 'Partial', 'Partial', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 2a775d7a-43d2-405b-9c2e-e90473b2e24e */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('2a775d7a-43d2-405b-9c2e-e90473b2e24e', '4C3DB2C0-9702-4B7B-8A7F-8F5326798758', 5, 'Present', 'Present', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 4C3DB2C0-9702-4B7B-8A7F-8F5326798758 */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='4C3DB2C0-9702-4B7B-8A7F-8F5326798758';

/* SQL text to insert entity field value with ID ab6234ca-7807-467b-844a-171399d7fca1 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('ab6234ca-7807-467b-844a-171399d7fca1', '25EBA2BE-3D67-4C3D-82BA-4131F30C0C4A', 1, 'Critical', 'Critical', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 7a838398-ee5e-4001-88dd-e73f3e76e79b */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('7a838398-ee5e-4001-88dd-e73f3e76e79b', '25EBA2BE-3D67-4C3D-82BA-4131F30C0C4A', 2, 'High', 'High', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID fc1c5333-3c12-429c-adc8-de60096fcfd0 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('fc1c5333-3c12-429c-adc8-de60096fcfd0', '25EBA2BE-3D67-4C3D-82BA-4131F30C0C4A', 3, 'Low', 'Low', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID b731626b-f3f5-4fc5-a37c-2ba81608929f */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('b731626b-f3f5-4fc5-a37c-2ba81608929f', '25EBA2BE-3D67-4C3D-82BA-4131F30C0C4A', 4, 'Medium', 'Medium', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 25EBA2BE-3D67-4C3D-82BA-4131F30C0C4A */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='25EBA2BE-3D67-4C3D-82BA-4131F30C0C4A';

/* SQL text to insert entity field value with ID af95e834-0cc7-4cc8-97ad-3349191a078b */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('af95e834-0cc7-4cc8-97ad-3349191a078b', '24FF726C-18A7-4369-97E9-9D19F3C08DD7', 1, 'Blocked', 'Blocked', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID d91592c0-d55d-4b28-ad65-498a44ac5edc */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('d91592c0-d55d-4b28-ad65-498a44ac5edc', '24FF726C-18A7-4369-97E9-9D19F3C08DD7', 2, 'Cancelled', 'Cancelled', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 0653d0ec-eed9-41a1-ab73-cb4ded69c8d4 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('0653d0ec-eed9-41a1-ab73-cb4ded69c8d4', '24FF726C-18A7-4369-97E9-9D19F3C08DD7', 3, 'Completed', 'Completed', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 2453727b-f4c6-457d-8e49-3ffd5bc15fc9 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('2453727b-f4c6-457d-8e49-3ffd5bc15fc9', '24FF726C-18A7-4369-97E9-9D19F3C08DD7', 4, 'InProgress', 'InProgress', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 27e84aba-b42c-45be-8644-1c855970e346 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('27e84aba-b42c-45be-8644-1c855970e346', '24FF726C-18A7-4369-97E9-9D19F3C08DD7', 5, 'Open', 'Open', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 24FF726C-18A7-4369-97E9-9D19F3C08DD7 */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='24FF726C-18A7-4369-97E9-9D19F3C08DD7';


/* Create Entity Relationship: Committees: Comments -> Committees: Comments (One To Many via ParentCommentID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'd1f1f35f-1b43-4514-8bd5-a38511f577fc'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('d1f1f35f-1b43-4514-8bd5-a38511f577fc', '6A65EEBD-8436-4FFC-9874-22D43FB91C37', '6A65EEBD-8436-4FFC-9874-22D43FB91C37', 'ParentCommentID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Motions -> Committees: Votes (One To Many via MotionID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'd2c8f8eb-c295-4b98-87b1-3873cf26c3b1'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('d2c8f8eb-c295-4b98-87b1-3873cf26c3b1', 'AC908A89-225C-48CF-8852-40E612096D6C', 'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF', 'MotionID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Types -> Committees: Committees (One To Many via TypeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '7eb19b9a-a1d3-418c-b8c4-fc4330f36646'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('7eb19b9a-a1d3-418c-b8c4-fc4330f36646', 'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E', '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', 'TypeID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ: Entities -> Committees: Artifact Types (One To Many via ExtendedEntityID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'a7e56b63-f60c-4024-822b-77b28e1229e2'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('a7e56b63-f60c-4024-822b-77b28e1229e2', 'E0238F34-2837-EF11-86D4-6045BDEE16E6', '47692233-8C18-4309-A466-6AD04CAC4F66', 'ExtendedEntityID', 'One To Many', 1, 1, 73, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Roles -> Committees: Memberships (One To Many via RoleID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '69e240f6-10c4-4f8d-883b-843d00bde598'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('69e240f6-10c4-4f8d-883b-843d00bde598', '0608D034-AE4B-484E-97AC-65C4C7640D36', '79FED512-86CA-438C-9476-EFDB091C2E3C', 'RoleID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;


/* Create Entity Relationship: Committees: Video Providers -> Committees: Meetings (One To Many via VideoProviderID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'b82b2203-49ce-4bd4-bec1-5c13ecbe2f18'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('b82b2203-49ce-4bd4-bec1-5c13ecbe2f18', '870B0B2C-29A9-4B4F-96A8-68354D969562', '543ADDC1-DEBC-4324-A23F-6A20D2924881', 'VideoProviderID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Meetings -> Committees: Attendances (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '2937d545-7c4b-4c2e-aadb-18133a794f55'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('2937d545-7c4b-4c2e-aadb-18133a794f55', '543ADDC1-DEBC-4324-A23F-6A20D2924881', '7684366D-44D2-4553-A1A9-A23AC11CB8FF', 'MeetingID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Meetings -> Committees: Minutes (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'bbefaf60-1b30-4d03-aa95-713c5409797e'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('bbefaf60-1b30-4d03-aa95-713c5409797e', '543ADDC1-DEBC-4324-A23F-6A20D2924881', 'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A', 'MeetingID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Meetings -> Committees: Minutes (One To Many via ApprovedByMeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '4a2f771c-318e-450c-b9a9-686bead9619d'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('4a2f771c-318e-450c-b9a9-686bead9619d', '543ADDC1-DEBC-4324-A23F-6A20D2924881', 'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A', 'ApprovedByMeetingID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Meetings -> Committees: Artifacts (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '91010728-38d0-4998-8581-a5468b5b4922'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('91010728-38d0-4998-8581-a5468b5b4922', '543ADDC1-DEBC-4324-A23F-6A20D2924881', '92933713-351A-4135-B55E-83B025C8A569', 'MeetingID', 'One To Many', 1, 1, 4, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Meetings -> Committees: Motions (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '0ea34be4-c14a-478b-9953-651ecece4bcb'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('0ea34be4-c14a-478b-9953-651ecece4bcb', '543ADDC1-DEBC-4324-A23F-6A20D2924881', 'AC908A89-225C-48CF-8852-40E612096D6C', 'MeetingID', 'One To Many', 1, 1, 5, GETUTCDATE(), GETUTCDATE())
   END;


/* Create Entity Relationship: Committees: Meetings -> Committees: Action Items (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '4d573cc5-2c89-483f-8834-a8f06e334e53'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('4d573cc5-2c89-483f-8834-a8f06e334e53', '543ADDC1-DEBC-4324-A23F-6A20D2924881', '60F3019B-62E3-432F-A12C-F007CD73479C', 'MeetingID', 'One To Many', 1, 1, 6, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Meetings -> Committees: Comments (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '686f7b2a-cdca-4f41-8fd7-2731d7fdd259'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('686f7b2a-cdca-4f41-8fd7-2731d7fdd259', '543ADDC1-DEBC-4324-A23F-6A20D2924881', '6A65EEBD-8436-4FFC-9874-22D43FB91C37', 'MeetingID', 'One To Many', 1, 1, 7, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Meetings -> Committees: Agenda Items (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '16bd68db-2dec-4cc3-b473-ea7dc446e60d'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('16bd68db-2dec-4cc3-b473-ea7dc446e60d', '543ADDC1-DEBC-4324-A23F-6A20D2924881', '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', 'MeetingID', 'One To Many', 1, 1, 8, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Artifact Types -> Committees: Artifacts (One To Many via ArtifactTypeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '4bac1c52-9337-4c4e-99d1-b2e6ef9ba001'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('4bac1c52-9337-4c4e-99d1-b2e6ef9ba001', '47692233-8C18-4309-A466-6AD04CAC4F66', '92933713-351A-4135-B55E-83B025C8A569', 'ArtifactTypeID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Common: Organizations -> Committees: Committees (One To Many via OrganizationID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '51bc658b-a0e6-444f-8128-5613d0c727ce'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('51bc658b-a0e6-444f-8128-5613d0c727ce', 'C70448F9-9792-41D7-A82C-784B66429D54', '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', 'OrganizationID', 'One To Many', 1, 1, 5, GETUTCDATE(), GETUTCDATE())
   END;


/* Create Entity Relationship: Committees: Artifacts -> Committees: Comments (One To Many via ArtifactID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '4410408b-e1c3-49c5-be74-6bd04dd889ce'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('4410408b-e1c3-49c5-be74-6bd04dd889ce', '92933713-351A-4135-B55E-83B025C8A569', '6A65EEBD-8436-4FFC-9874-22D43FB91C37', 'ArtifactID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Artifacts -> Committees: Minutes (One To Many via ArtifactID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '12ecaf42-5905-4ffa-8f6a-6504f6401ae8'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('12ecaf42-5905-4ffa-8f6a-6504f6401ae8', '92933713-351A-4135-B55E-83B025C8A569', 'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A', 'ArtifactID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ: Credentials -> Committees: Video Providers (One To Many via CredentialID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'd4cd4835-8013-48e5-85bf-186ea68fa151'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('d4cd4835-8013-48e5-85bf-186ea68fa151', '7E023DDF-82C6-4B0C-9650-8D35699B9FD0', '870B0B2C-29A9-4B4F-96A8-68354D969562', 'CredentialID', 'One To Many', 1, 1, 9, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Terms -> Committees: Memberships (One To Many via TermID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '7d8519fa-0afa-4220-9663-2a087e06ee33'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('7d8519fa-0afa-4220-9663-2a087e06ee33', '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2', '79FED512-86CA-438C-9476-EFDB091C2E3C', 'TermID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Agenda Items -> Committees: Agenda Items (One To Many via ParentAgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'b6f5e6cb-2fe3-4706-9f1c-cbdf2f72b400'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('b6f5e6cb-2fe3-4706-9f1c-cbdf2f72b400', '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', 'ParentAgendaItemID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;


/* Create Entity Relationship: Committees: Agenda Items -> Committees: Action Items (One To Many via AgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '1d7e4bdc-d98f-49ca-b2b2-4923b2393742'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('1d7e4bdc-d98f-49ca-b2b2-4923b2393742', '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', '60F3019B-62E3-432F-A12C-F007CD73479C', 'AgendaItemID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Agenda Items -> Committees: Comments (One To Many via AgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '17756b02-0a36-4435-ae16-0cdaddfb7c50'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('17756b02-0a36-4435-ae16-0cdaddfb7c50', '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', '6A65EEBD-8436-4FFC-9874-22D43FB91C37', 'AgendaItemID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Agenda Items -> Committees: Artifacts (One To Many via AgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '1d2d2a19-7968-4d66-8f0f-91e273b4172c'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('1d2d2a19-7968-4d66-8f0f-91e273b4172c', '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', '92933713-351A-4135-B55E-83B025C8A569', 'AgendaItemID', 'One To Many', 1, 1, 4, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Agenda Items -> Committees: Motions (One To Many via AgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '2fda5856-d687-4678-a118-b10c492a07c9'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('2fda5856-d687-4678-a118-b10c492a07c9', '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', 'AC908A89-225C-48CF-8852-40E612096D6C', 'AgendaItemID', 'One To Many', 1, 1, 5, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Committees -> Committees: Action Items (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'deb8313b-3749-4a00-b530-15e18eda13db'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('deb8313b-3749-4a00-b530-15e18eda13db', '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', '60F3019B-62E3-432F-A12C-F007CD73479C', 'CommitteeID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;


/* Create Entity Relationship: Committees: Committees -> Committees: Meetings (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '3bef3091-0736-44a5-a666-3466e1ca5b11'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('3bef3091-0736-44a5-a666-3466e1ca5b11', '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', '543ADDC1-DEBC-4324-A23F-6A20D2924881', 'CommitteeID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Committees -> Committees: Comments (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '8e3dc261-8753-4fc4-8662-4cf6ee4f6fcf'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('8e3dc261-8753-4fc4-8662-4cf6ee4f6fcf', '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', '6A65EEBD-8436-4FFC-9874-22D43FB91C37', 'CommitteeID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Committees -> Committees: Committees (One To Many via ParentCommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'c3a7d7bd-8400-448d-9125-0be22e335f62'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('c3a7d7bd-8400-448d-9125-0be22e335f62', '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', 'ParentCommitteeID', 'One To Many', 1, 1, 4, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Committees -> Committees: Artifacts (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '4b11fb23-8d13-4ab7-a5d0-97fb3eb96cd9'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('4b11fb23-8d13-4ab7-a5d0-97fb3eb96cd9', '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', '92933713-351A-4135-B55E-83B025C8A569', 'CommitteeID', 'One To Many', 1, 1, 5, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Committees -> Committees: Terms (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '4997d879-da3d-444b-8299-2983b144ddcb'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('4997d879-da3d-444b-8299-2983b144ddcb', '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2', 'CommitteeID', 'One To Many', 1, 1, 6, GETUTCDATE(), GETUTCDATE())
   END;


/* Create Entity Relationship: MJ_BizApps_Common: People -> Committees: Memberships (One To Many via PersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'f671e841-42cb-44d8-945b-671ab3788c2e'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('f671e841-42cb-44d8-945b-671ab3788c2e', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '79FED512-86CA-438C-9476-EFDB091C2E3C', 'PersonID', 'One To Many', 1, 1, 9, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Common: People -> Committees: Comments (One To Many via PersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '821f9954-1ee0-40c8-8102-4cfe654715d1'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('821f9954-1ee0-40c8-8102-4cfe654715d1', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '6A65EEBD-8436-4FFC-9874-22D43FB91C37', 'PersonID', 'One To Many', 1, 1, 10, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Common: People -> Committees: Agenda Items (One To Many via PresenterPersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '379f5656-96ca-4cf4-b9f5-184db3c134dc'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('379f5656-96ca-4cf4-b9f5-184db3c134dc', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', 'PresenterPersonID', 'One To Many', 1, 1, 11, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Common: People -> Committees: Artifacts (One To Many via UploadedByPersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'd039e7cd-b507-4d91-92dc-a9a03d1b07f0'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('d039e7cd-b507-4d91-92dc-a9a03d1b07f0', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '92933713-351A-4135-B55E-83B025C8A569', 'UploadedByPersonID', 'One To Many', 1, 1, 12, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Common: People -> Committees: Action Items (One To Many via AssignedToPersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '78d33b24-fc51-4971-8d40-9cb4e319fbfa'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('78d33b24-fc51-4971-8d40-9cb4e319fbfa', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '60F3019B-62E3-432F-A12C-F007CD73479C', 'AssignedToPersonID', 'One To Many', 1, 1, 13, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Common: People -> Committees: Action Items (One To Many via AssignedByPersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '9f5a918a-9bca-41ff-b220-a1289b7f9ad3'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('9f5a918a-9bca-41ff-b220-a1289b7f9ad3', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '60F3019B-62E3-432F-A12C-F007CD73479C', 'AssignedByPersonID', 'One To Many', 1, 1, 14, GETUTCDATE(), GETUTCDATE())
   END;


/* Create Entity Relationship: MJ_BizApps_Common: People -> Committees: Attendances (One To Many via PersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '5a20ce42-3076-478f-a5d5-94653e701878'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('5a20ce42-3076-478f-a5d5-94653e701878', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '7684366D-44D2-4553-A1A9-A23AC11CB8FF', 'PersonID', 'One To Many', 1, 1, 15, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Memberships -> Committees: Motions (One To Many via SecondedByMembershipID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '48218780-37e2-463f-9fdd-82698a69d7c0'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('48218780-37e2-463f-9fdd-82698a69d7c0', '79FED512-86CA-438C-9476-EFDB091C2E3C', 'AC908A89-225C-48CF-8852-40E612096D6C', 'SecondedByMembershipID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Memberships -> Committees: Motions (One To Many via MovedByMembershipID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'bc91ecc6-89c9-4c47-af0d-11f37ff7253e'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('bc91ecc6-89c9-4c47-af0d-11f37ff7253e', '79FED512-86CA-438C-9476-EFDB091C2E3C', 'AC908A89-225C-48CF-8852-40E612096D6C', 'MovedByMembershipID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Memberships -> Committees: Votes (One To Many via MembershipID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '3aee10bd-a95f-4744-93f6-6d4ba1ac2c0a'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('3aee10bd-a95f-4744-93f6-6d4ba1ac2c0a', '79FED512-86CA-438C-9476-EFDB091C2E3C', 'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF', 'MembershipID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Tasks: Tasks -> Committees: Comments (One To Many via TaskID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'f714dc1b-3e0a-4ce7-88f8-84867d685ece'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('f714dc1b-3e0a-4ce7-88f8-84867d685ece', 'B348FFA2-B1A7-4AC2-B6FD-F4E0C0697466', '6A65EEBD-8436-4FFC-9874-22D43FB91C37', 'TaskID', 'One To Many', 1, 1, 11, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Tasks: Tasks -> Committees: Artifacts (One To Many via TaskID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'b20ea041-e62e-48ae-9ac4-75000fc2fdbf'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('b20ea041-e62e-48ae-9ac4-75000fc2fdbf', 'B348FFA2-B1A7-4AC2-B6FD-F4E0C0697466', '92933713-351A-4135-B55E-83B025C8A569', 'TaskID', 'One To Many', 1, 1, 12, GETUTCDATE(), GETUTCDATE())
   END;

/* SQL text to sync schema info from database schemas */
EXEC [${mjSchema}].[spUpdateSchemaInfoFromDatabase] @ExcludedSchemaNames='sys,staging,${mjSchema},${mjBACSchema},${mjSchema}_BizAppsTasks';

/* Index for Foreign Keys for ActionItem */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Action Items
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key CommitteeID in table ActionItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_ActionItem_CommitteeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[ActionItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ActionItem_CommitteeID ON [${flyway:defaultSchema}].[ActionItem] ([CommitteeID]);

-- Index for foreign key MeetingID in table ActionItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_ActionItem_MeetingID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[ActionItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ActionItem_MeetingID ON [${flyway:defaultSchema}].[ActionItem] ([MeetingID]);

-- Index for foreign key AgendaItemID in table ActionItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_ActionItem_AgendaItemID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[ActionItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ActionItem_AgendaItemID ON [${flyway:defaultSchema}].[ActionItem] ([AgendaItemID]);

-- Index for foreign key AssignedToPersonID in table ActionItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_ActionItem_AssignedToPersonID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[ActionItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ActionItem_AssignedToPersonID ON [${flyway:defaultSchema}].[ActionItem] ([AssignedToPersonID]);

-- Index for foreign key AssignedByPersonID in table ActionItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_ActionItem_AssignedByPersonID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[ActionItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ActionItem_AssignedByPersonID ON [${flyway:defaultSchema}].[ActionItem] ([AssignedByPersonID]);

/* SQL text to update entity field related entity name field map for entity field ID 2E17E5B8-A39E-45F3-8BFB-369193F614F6 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='2E17E5B8-A39E-45F3-8BFB-369193F614F6', @RelatedEntityNameFieldMap='Committee';

/* Index for Foreign Keys for AgendaItem */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Agenda Items
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key MeetingID in table AgendaItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_AgendaItem_MeetingID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[AgendaItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_AgendaItem_MeetingID ON [${flyway:defaultSchema}].[AgendaItem] ([MeetingID]);

-- Index for foreign key ParentAgendaItemID in table AgendaItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_AgendaItem_ParentAgendaItemID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[AgendaItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_AgendaItem_ParentAgendaItemID ON [${flyway:defaultSchema}].[AgendaItem] ([ParentAgendaItemID]);

-- Index for foreign key PresenterPersonID in table AgendaItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_AgendaItem_PresenterPersonID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[AgendaItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_AgendaItem_PresenterPersonID ON [${flyway:defaultSchema}].[AgendaItem] ([PresenterPersonID]);

/* SQL text to update entity field related entity name field map for entity field ID F22704C8-75F3-4A4D-834F-C279E5966D65 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='F22704C8-75F3-4A4D-834F-C279E5966D65', @RelatedEntityNameFieldMap='PresenterPerson';

/* Index for Foreign Keys for ArtifactType */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifact Types
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key ExtendedEntityID in table ArtifactType
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_ArtifactType_ExtendedEntityID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[ArtifactType]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ArtifactType_ExtendedEntityID ON [${flyway:defaultSchema}].[ArtifactType] ([ExtendedEntityID]);

/* SQL text to update entity field related entity name field map for entity field ID 9E2B6B03-0583-41B1-A8C8-D93E843A0B7D */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='9E2B6B03-0583-41B1-A8C8-D93E843A0B7D', @RelatedEntityNameFieldMap='ExtendedEntity';

/* Index for Foreign Keys for Artifact */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifacts
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key CommitteeID in table Artifact
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_CommitteeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_CommitteeID ON [${flyway:defaultSchema}].[Artifact] ([CommitteeID]);

-- Index for foreign key MeetingID in table Artifact
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_MeetingID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_MeetingID ON [${flyway:defaultSchema}].[Artifact] ([MeetingID]);

-- Index for foreign key AgendaItemID in table Artifact
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_AgendaItemID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_AgendaItemID ON [${flyway:defaultSchema}].[Artifact] ([AgendaItemID]);

-- Index for foreign key TaskID in table Artifact
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_TaskID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_TaskID ON [${flyway:defaultSchema}].[Artifact] ([TaskID]);

-- Index for foreign key ArtifactTypeID in table Artifact
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_ArtifactTypeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_ArtifactTypeID ON [${flyway:defaultSchema}].[Artifact] ([ArtifactTypeID]);

-- Index for foreign key UploadedByPersonID in table Artifact
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_UploadedByPersonID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_UploadedByPersonID ON [${flyway:defaultSchema}].[Artifact] ([UploadedByPersonID]);

/* SQL text to update entity field related entity name field map for entity field ID BF94B523-4284-498D-ADBD-D7949CBF6429 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='BF94B523-4284-498D-ADBD-D7949CBF6429', @RelatedEntityNameFieldMap='Committee';

/* Index for Foreign Keys for Attendance */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Attendances
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key MeetingID in table Attendance
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Attendance_MeetingID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Attendance]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Attendance_MeetingID ON [${flyway:defaultSchema}].[Attendance] ([MeetingID]);

-- Index for foreign key PersonID in table Attendance
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Attendance_PersonID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Attendance]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Attendance_PersonID ON [${flyway:defaultSchema}].[Attendance] ([PersonID]);

/* SQL text to update entity field related entity name field map for entity field ID DD046D10-DB26-4D33-8AC8-4B883FB10F8A */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='DD046D10-DB26-4D33-8AC8-4B883FB10F8A', @RelatedEntityNameFieldMap='Person';

/* SQL text to update entity field related entity name field map for entity field ID 4FB2FAA6-11BF-43E5-BA39-77D5629C06C9 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='4FB2FAA6-11BF-43E5-BA39-77D5629C06C9', @RelatedEntityNameFieldMap='AssignedToPerson';

/* Root ID Function SQL for Committees: Agenda Items.ParentAgendaItemID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Agenda Items
-- Item: fnAgendaItemParentAgendaItemID_GetRootID
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- ROOT ID FUNCTION FOR: [AgendaItem].[ParentAgendaItemID]
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[fnAgendaItemParentAgendaItemID_GetRootID]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}].[fnAgendaItemParentAgendaItemID_GetRootID];
GO

CREATE FUNCTION [${flyway:defaultSchema}].[fnAgendaItemParentAgendaItemID_GetRootID]
(
    @RecordID uniqueidentifier,
    @ParentID uniqueidentifier
)
RETURNS TABLE
AS
RETURN
(
    WITH CTE_RootParent AS (
        SELECT
            [ID],
            [ParentAgendaItemID],
            [ID] AS [RootParentID],
            0 AS [Depth]
        FROM
            [${flyway:defaultSchema}].[AgendaItem]
        WHERE
            [ID] = COALESCE(@ParentID, @RecordID)

        UNION ALL

        SELECT
            c.[ID],
            c.[ParentAgendaItemID],
            c.[ID] AS [RootParentID],
            p.[Depth] + 1 AS [Depth]
        FROM
            [${flyway:defaultSchema}].[AgendaItem] c
        INNER JOIN
            CTE_RootParent p ON c.[ID] = p.[ParentAgendaItemID]
        WHERE
            p.[Depth] < 100
    )
    SELECT TOP 1
        [RootParentID] AS RootID
    FROM
        CTE_RootParent
    WHERE
        [ParentAgendaItemID] IS NULL
    ORDER BY
        [RootParentID]
);
GO

/* Base View SQL for Committees: Agenda Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Agenda Items
-- Item: vwAgendaItems
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Agenda Items
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  AgendaItem
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwAgendaItems]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwAgendaItems];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwAgendaItems]
AS
SELECT
    a.*,
    mjBizAppsCommonPerson_PresenterPersonID.[DisplayName] AS [PresenterPerson],
    root_ParentAgendaItemID.RootID AS [RootParentAgendaItemID]
FROM
    [${flyway:defaultSchema}].[AgendaItem] AS a
LEFT OUTER JOIN
    [${mjBACSchema}].[Person] AS mjBizAppsCommonPerson_PresenterPersonID
  ON
    [a].[PresenterPersonID] = mjBizAppsCommonPerson_PresenterPersonID.[ID]
OUTER APPLY
    [${flyway:defaultSchema}].[fnAgendaItemParentAgendaItemID_GetRootID]([a].[ID], [a].[ParentAgendaItemID]) AS root_ParentAgendaItemID
GO
GRANT SELECT ON [${flyway:defaultSchema}].[vwAgendaItems] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Agenda Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Agenda Items
-- Item: Permissions for vwAgendaItems
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}].[vwAgendaItems] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Agenda Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Agenda Items
-- Item: spCreateAgendaItem
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR AgendaItem
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateAgendaItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateAgendaItem];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateAgendaItem]
    @ID uniqueidentifier = NULL,
    @MeetingID uniqueidentifier,
    @ParentAgendaItemID_Clear bit = 0,
    @ParentAgendaItemID uniqueidentifier = NULL,
    @Sequence int,
    @Title nvarchar(255),
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @PresenterPersonID_Clear bit = 0,
    @PresenterPersonID uniqueidentifier = NULL,
    @DurationMinutes_Clear bit = 0,
    @DurationMinutes int = NULL,
    @ItemType nvarchar(50) = NULL,
    @RelatedDocumentURL_Clear bit = 0,
    @RelatedDocumentURL nvarchar(1000) = NULL,
    @Status nvarchar(50) = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[AgendaItem]
            (
                [ID],
                [MeetingID],
                [ParentAgendaItemID],
                [Sequence],
                [Title],
                [Description],
                [PresenterPersonID],
                [DurationMinutes],
                [ItemType],
                [RelatedDocumentURL],
                [Status],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @MeetingID,
                CASE WHEN @ParentAgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@ParentAgendaItemID, NULL) END,
                @Sequence,
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                CASE WHEN @PresenterPersonID_Clear = 1 THEN NULL ELSE ISNULL(@PresenterPersonID, NULL) END,
                CASE WHEN @DurationMinutes_Clear = 1 THEN NULL ELSE ISNULL(@DurationMinutes, NULL) END,
                ISNULL(@ItemType, 'Discussion'),
                CASE WHEN @RelatedDocumentURL_Clear = 1 THEN NULL ELSE ISNULL(@RelatedDocumentURL, NULL) END,
                ISNULL(@Status, 'Pending'),
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[AgendaItem]
            (
                [MeetingID],
                [ParentAgendaItemID],
                [Sequence],
                [Title],
                [Description],
                [PresenterPersonID],
                [DurationMinutes],
                [ItemType],
                [RelatedDocumentURL],
                [Status],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @MeetingID,
                CASE WHEN @ParentAgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@ParentAgendaItemID, NULL) END,
                @Sequence,
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                CASE WHEN @PresenterPersonID_Clear = 1 THEN NULL ELSE ISNULL(@PresenterPersonID, NULL) END,
                CASE WHEN @DurationMinutes_Clear = 1 THEN NULL ELSE ISNULL(@DurationMinutes, NULL) END,
                ISNULL(@ItemType, 'Discussion'),
                CASE WHEN @RelatedDocumentURL_Clear = 1 THEN NULL ELSE ISNULL(@RelatedDocumentURL, NULL) END,
                ISNULL(@Status, 'Pending'),
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwAgendaItems] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateAgendaItem] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Agenda Items */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateAgendaItem] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Agenda Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Agenda Items
-- Item: spUpdateAgendaItem
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR AgendaItem
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateAgendaItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateAgendaItem];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateAgendaItem]
    @ID uniqueidentifier,
    @MeetingID uniqueidentifier = NULL,
    @ParentAgendaItemID_Clear bit = 0,
    @ParentAgendaItemID uniqueidentifier = NULL,
    @Sequence int = NULL,
    @Title nvarchar(255) = NULL,
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @PresenterPersonID_Clear bit = 0,
    @PresenterPersonID uniqueidentifier = NULL,
    @DurationMinutes_Clear bit = 0,
    @DurationMinutes int = NULL,
    @ItemType nvarchar(50) = NULL,
    @RelatedDocumentURL_Clear bit = 0,
    @RelatedDocumentURL nvarchar(1000) = NULL,
    @Status nvarchar(50) = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[AgendaItem]
    SET
        [MeetingID] = ISNULL(@MeetingID, [MeetingID]),
        [ParentAgendaItemID] = CASE WHEN @ParentAgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@ParentAgendaItemID, [ParentAgendaItemID]) END,
        [Sequence] = ISNULL(@Sequence, [Sequence]),
        [Title] = ISNULL(@Title, [Title]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [PresenterPersonID] = CASE WHEN @PresenterPersonID_Clear = 1 THEN NULL ELSE ISNULL(@PresenterPersonID, [PresenterPersonID]) END,
        [DurationMinutes] = CASE WHEN @DurationMinutes_Clear = 1 THEN NULL ELSE ISNULL(@DurationMinutes, [DurationMinutes]) END,
        [ItemType] = ISNULL(@ItemType, [ItemType]),
        [RelatedDocumentURL] = CASE WHEN @RelatedDocumentURL_Clear = 1 THEN NULL ELSE ISNULL(@RelatedDocumentURL, [RelatedDocumentURL]) END,
        [Status] = ISNULL(@Status, [Status]),
        [Notes] = CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, [Notes]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwAgendaItems] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwAgendaItems]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateAgendaItem] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the AgendaItem table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateAgendaItem]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateAgendaItem];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateAgendaItem
ON [${flyway:defaultSchema}].[AgendaItem]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[AgendaItem]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}].[AgendaItem] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Agenda Items */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateAgendaItem] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Agenda Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Agenda Items
-- Item: spDeleteAgendaItem
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR AgendaItem
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteAgendaItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteAgendaItem];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteAgendaItem]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[AgendaItem]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteAgendaItem] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Agenda Items */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteAgendaItem] TO [cdp_Developer], [cdp_Integration];

/* SQL text to update entity field related entity name field map for entity field ID 8F561BCA-07F9-4B75-B3A5-CFFEFC8A0BC2 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='8F561BCA-07F9-4B75-B3A5-CFFEFC8A0BC2', @RelatedEntityNameFieldMap='Task';

/* Base View SQL for Committees: Artifact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifact Types
-- Item: vwArtifactTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Artifact Types
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  ArtifactType
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwArtifactTypes]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwArtifactTypes];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwArtifactTypes]
AS
SELECT
    a.*,
    MJEntity_ExtendedEntityID.[Name] AS [ExtendedEntity]
FROM
    [${flyway:defaultSchema}].[ArtifactType] AS a
LEFT OUTER JOIN
    [${mjSchema}].[Entity] AS MJEntity_ExtendedEntityID
  ON
    [a].[ExtendedEntityID] = MJEntity_ExtendedEntityID.[ID]
GO
GRANT SELECT ON [${flyway:defaultSchema}].[vwArtifactTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Artifact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifact Types
-- Item: Permissions for vwArtifactTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}].[vwArtifactTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Artifact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifact Types
-- Item: spCreateArtifactType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR ArtifactType
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateArtifactType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateArtifactType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateArtifactType]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(100),
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @ExtendedEntityID_Clear bit = 0,
    @ExtendedEntityID uniqueidentifier = NULL,
    @IconClass_Clear bit = 0,
    @IconClass nvarchar(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[ArtifactType]
            (
                [ID],
                [Name],
                [Description],
                [ExtendedEntityID],
                [IconClass]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @Name,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                CASE WHEN @ExtendedEntityID_Clear = 1 THEN NULL ELSE ISNULL(@ExtendedEntityID, NULL) END,
                CASE WHEN @IconClass_Clear = 1 THEN NULL ELSE ISNULL(@IconClass, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[ArtifactType]
            (
                [Name],
                [Description],
                [ExtendedEntityID],
                [IconClass]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @Name,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                CASE WHEN @ExtendedEntityID_Clear = 1 THEN NULL ELSE ISNULL(@ExtendedEntityID, NULL) END,
                CASE WHEN @IconClass_Clear = 1 THEN NULL ELSE ISNULL(@IconClass, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwArtifactTypes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateArtifactType] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Artifact Types */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateArtifactType] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Artifact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifact Types
-- Item: spUpdateArtifactType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR ArtifactType
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateArtifactType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateArtifactType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateArtifactType]
    @ID uniqueidentifier,
    @Name nvarchar(100) = NULL,
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @ExtendedEntityID_Clear bit = 0,
    @ExtendedEntityID uniqueidentifier = NULL,
    @IconClass_Clear bit = 0,
    @IconClass nvarchar(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[ArtifactType]
    SET
        [Name] = ISNULL(@Name, [Name]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [ExtendedEntityID] = CASE WHEN @ExtendedEntityID_Clear = 1 THEN NULL ELSE ISNULL(@ExtendedEntityID, [ExtendedEntityID]) END,
        [IconClass] = CASE WHEN @IconClass_Clear = 1 THEN NULL ELSE ISNULL(@IconClass, [IconClass]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwArtifactTypes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwArtifactTypes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifactType] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the ArtifactType table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateArtifactType]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateArtifactType];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateArtifactType
ON [${flyway:defaultSchema}].[ArtifactType]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[ArtifactType]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}].[ArtifactType] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Artifact Types */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifactType] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Artifact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifact Types
-- Item: spDeleteArtifactType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR ArtifactType
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteArtifactType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteArtifactType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteArtifactType]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[ArtifactType]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteArtifactType] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Artifact Types */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteArtifactType] TO [cdp_Developer], [cdp_Integration];

/* SQL text to update entity field related entity name field map for entity field ID AE66B201-BA27-43E5-B297-7B4A19E45D50 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='AE66B201-BA27-43E5-B297-7B4A19E45D50', @RelatedEntityNameFieldMap='AssignedByPerson';

/* Base View SQL for Committees: Attendances */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Attendances
-- Item: vwAttendances
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Attendances
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Attendance
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwAttendances]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwAttendances];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwAttendances]
AS
SELECT
    a.*,
    mjBizAppsCommonPerson_PersonID.[DisplayName] AS [Person]
FROM
    [${flyway:defaultSchema}].[Attendance] AS a
INNER JOIN
    [${mjBACSchema}].[Person] AS mjBizAppsCommonPerson_PersonID
  ON
    [a].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
GO
GRANT SELECT ON [${flyway:defaultSchema}].[vwAttendances] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Attendances */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Attendances
-- Item: Permissions for vwAttendances
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}].[vwAttendances] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Attendances */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Attendances
-- Item: spCreateAttendance
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Attendance
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateAttendance]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateAttendance];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateAttendance]
    @ID uniqueidentifier = NULL,
    @MeetingID uniqueidentifier,
    @PersonID uniqueidentifier,
    @AttendanceStatus nvarchar(50) = NULL,
    @JoinedAt_Clear bit = 0,
    @JoinedAt datetimeoffset = NULL,
    @LeftAt_Clear bit = 0,
    @LeftAt datetimeoffset = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[Attendance]
            (
                [ID],
                [MeetingID],
                [PersonID],
                [AttendanceStatus],
                [JoinedAt],
                [LeftAt],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @MeetingID,
                @PersonID,
                ISNULL(@AttendanceStatus, 'Expected'),
                CASE WHEN @JoinedAt_Clear = 1 THEN NULL ELSE ISNULL(@JoinedAt, NULL) END,
                CASE WHEN @LeftAt_Clear = 1 THEN NULL ELSE ISNULL(@LeftAt, NULL) END,
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[Attendance]
            (
                [MeetingID],
                [PersonID],
                [AttendanceStatus],
                [JoinedAt],
                [LeftAt],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @MeetingID,
                @PersonID,
                ISNULL(@AttendanceStatus, 'Expected'),
                CASE WHEN @JoinedAt_Clear = 1 THEN NULL ELSE ISNULL(@JoinedAt, NULL) END,
                CASE WHEN @LeftAt_Clear = 1 THEN NULL ELSE ISNULL(@LeftAt, NULL) END,
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwAttendances] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateAttendance] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Attendances */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateAttendance] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Attendances */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Attendances
-- Item: spUpdateAttendance
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Attendance
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateAttendance]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateAttendance];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateAttendance]
    @ID uniqueidentifier,
    @MeetingID uniqueidentifier = NULL,
    @PersonID uniqueidentifier = NULL,
    @AttendanceStatus nvarchar(50) = NULL,
    @JoinedAt_Clear bit = 0,
    @JoinedAt datetimeoffset = NULL,
    @LeftAt_Clear bit = 0,
    @LeftAt datetimeoffset = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Attendance]
    SET
        [MeetingID] = ISNULL(@MeetingID, [MeetingID]),
        [PersonID] = ISNULL(@PersonID, [PersonID]),
        [AttendanceStatus] = ISNULL(@AttendanceStatus, [AttendanceStatus]),
        [JoinedAt] = CASE WHEN @JoinedAt_Clear = 1 THEN NULL ELSE ISNULL(@JoinedAt, [JoinedAt]) END,
        [LeftAt] = CASE WHEN @LeftAt_Clear = 1 THEN NULL ELSE ISNULL(@LeftAt, [LeftAt]) END,
        [Notes] = CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, [Notes]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwAttendances] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwAttendances]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateAttendance] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Attendance table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateAttendance]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateAttendance];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateAttendance
ON [${flyway:defaultSchema}].[Attendance]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Attendance]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}].[Attendance] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Attendances */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateAttendance] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Attendances */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Attendances
-- Item: spDeleteAttendance
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Attendance
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteAttendance]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteAttendance];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteAttendance]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Attendance]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteAttendance] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Attendances */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteAttendance] TO [cdp_Developer], [cdp_Integration];

/* Base View SQL for Committees: Action Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Action Items
-- Item: vwActionItems
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Action Items
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  ActionItem
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwActionItems]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwActionItems];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwActionItems]
AS
SELECT
    a.*,
    mjBizAppsCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjBizAppsCommonPerson_AssignedToPersonID.[DisplayName] AS [AssignedToPerson],
    mjBizAppsCommonPerson_AssignedByPersonID.[DisplayName] AS [AssignedByPerson]
FROM
    [${flyway:defaultSchema}].[ActionItem] AS a
INNER JOIN
    [${flyway:defaultSchema}].[Committee] AS mjBizAppsCommitteesCommittee_CommitteeID
  ON
    [a].[CommitteeID] = mjBizAppsCommitteesCommittee_CommitteeID.[ID]
INNER JOIN
    [${mjBACSchema}].[Person] AS mjBizAppsCommonPerson_AssignedToPersonID
  ON
    [a].[AssignedToPersonID] = mjBizAppsCommonPerson_AssignedToPersonID.[ID]
LEFT OUTER JOIN
    [${mjBACSchema}].[Person] AS mjBizAppsCommonPerson_AssignedByPersonID
  ON
    [a].[AssignedByPersonID] = mjBizAppsCommonPerson_AssignedByPersonID.[ID]
GO
GRANT SELECT ON [${flyway:defaultSchema}].[vwActionItems] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Action Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Action Items
-- Item: Permissions for vwActionItems
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}].[vwActionItems] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Action Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Action Items
-- Item: spCreateActionItem
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR ActionItem
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateActionItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateActionItem];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateActionItem]
    @ID uniqueidentifier = NULL,
    @CommitteeID uniqueidentifier,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @Title nvarchar(255),
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @AssignedToPersonID uniqueidentifier,
    @AssignedByPersonID_Clear bit = 0,
    @AssignedByPersonID uniqueidentifier = NULL,
    @DueDate_Clear bit = 0,
    @DueDate date = NULL,
    @Priority nvarchar(20) = NULL,
    @Status nvarchar(50) = NULL,
    @CompletedAt_Clear bit = 0,
    @CompletedAt datetimeoffset = NULL,
    @CompletionNotes_Clear bit = 0,
    @CompletionNotes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[ActionItem]
            (
                [ID],
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [Title],
                [Description],
                [AssignedToPersonID],
                [AssignedByPersonID],
                [DueDate],
                [Priority],
                [Status],
                [CompletedAt],
                [CompletionNotes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @CommitteeID,
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @AssignedToPersonID,
                CASE WHEN @AssignedByPersonID_Clear = 1 THEN NULL ELSE ISNULL(@AssignedByPersonID, NULL) END,
                CASE WHEN @DueDate_Clear = 1 THEN NULL ELSE ISNULL(@DueDate, NULL) END,
                ISNULL(@Priority, 'Medium'),
                ISNULL(@Status, 'Open'),
                CASE WHEN @CompletedAt_Clear = 1 THEN NULL ELSE ISNULL(@CompletedAt, NULL) END,
                CASE WHEN @CompletionNotes_Clear = 1 THEN NULL ELSE ISNULL(@CompletionNotes, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[ActionItem]
            (
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [Title],
                [Description],
                [AssignedToPersonID],
                [AssignedByPersonID],
                [DueDate],
                [Priority],
                [Status],
                [CompletedAt],
                [CompletionNotes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @CommitteeID,
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @AssignedToPersonID,
                CASE WHEN @AssignedByPersonID_Clear = 1 THEN NULL ELSE ISNULL(@AssignedByPersonID, NULL) END,
                CASE WHEN @DueDate_Clear = 1 THEN NULL ELSE ISNULL(@DueDate, NULL) END,
                ISNULL(@Priority, 'Medium'),
                ISNULL(@Status, 'Open'),
                CASE WHEN @CompletedAt_Clear = 1 THEN NULL ELSE ISNULL(@CompletedAt, NULL) END,
                CASE WHEN @CompletionNotes_Clear = 1 THEN NULL ELSE ISNULL(@CompletionNotes, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwActionItems] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateActionItem] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Action Items */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateActionItem] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Action Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Action Items
-- Item: spUpdateActionItem
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR ActionItem
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateActionItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateActionItem];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateActionItem]
    @ID uniqueidentifier,
    @CommitteeID uniqueidentifier = NULL,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @Title nvarchar(255) = NULL,
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @AssignedToPersonID uniqueidentifier = NULL,
    @AssignedByPersonID_Clear bit = 0,
    @AssignedByPersonID uniqueidentifier = NULL,
    @DueDate_Clear bit = 0,
    @DueDate date = NULL,
    @Priority nvarchar(20) = NULL,
    @Status nvarchar(50) = NULL,
    @CompletedAt_Clear bit = 0,
    @CompletedAt datetimeoffset = NULL,
    @CompletionNotes_Clear bit = 0,
    @CompletionNotes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[ActionItem]
    SET
        [CommitteeID] = ISNULL(@CommitteeID, [CommitteeID]),
        [MeetingID] = CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, [MeetingID]) END,
        [AgendaItemID] = CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, [AgendaItemID]) END,
        [Title] = ISNULL(@Title, [Title]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [AssignedToPersonID] = ISNULL(@AssignedToPersonID, [AssignedToPersonID]),
        [AssignedByPersonID] = CASE WHEN @AssignedByPersonID_Clear = 1 THEN NULL ELSE ISNULL(@AssignedByPersonID, [AssignedByPersonID]) END,
        [DueDate] = CASE WHEN @DueDate_Clear = 1 THEN NULL ELSE ISNULL(@DueDate, [DueDate]) END,
        [Priority] = ISNULL(@Priority, [Priority]),
        [Status] = ISNULL(@Status, [Status]),
        [CompletedAt] = CASE WHEN @CompletedAt_Clear = 1 THEN NULL ELSE ISNULL(@CompletedAt, [CompletedAt]) END,
        [CompletionNotes] = CASE WHEN @CompletionNotes_Clear = 1 THEN NULL ELSE ISNULL(@CompletionNotes, [CompletionNotes]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwActionItems] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwActionItems]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateActionItem] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the ActionItem table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateActionItem]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateActionItem];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateActionItem
ON [${flyway:defaultSchema}].[ActionItem]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[ActionItem]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}].[ActionItem] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Action Items */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateActionItem] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Action Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Action Items
-- Item: spDeleteActionItem
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR ActionItem
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteActionItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteActionItem];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteActionItem]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[ActionItem]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteActionItem] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Action Items */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteActionItem] TO [cdp_Developer], [cdp_Integration];

/* SQL text to update entity field related entity name field map for entity field ID 145E51F5-F522-46F5-8ABA-487183AC31BC */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='145E51F5-F522-46F5-8ABA-487183AC31BC', @RelatedEntityNameFieldMap='ArtifactType';

/* SQL text to update entity field related entity name field map for entity field ID 7781B7D4-F59D-4999-BA79-66F5960A04BE */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='7781B7D4-F59D-4999-BA79-66F5960A04BE', @RelatedEntityNameFieldMap='UploadedByPerson';

/* Base View SQL for Committees: Artifacts */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifacts
-- Item: vwArtifacts
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Artifacts
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Artifact
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwArtifacts]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwArtifacts];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwArtifacts]
AS
SELECT
    a.*,
    mjBizAppsCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjBizAppsTasksTask_TaskID.[Name] AS [Task],
    mjBizAppsCommitteesArtifactType_ArtifactTypeID.[Name] AS [ArtifactType],
    mjBizAppsCommonPerson_UploadedByPersonID.[DisplayName] AS [UploadedByPerson]
FROM
    [${flyway:defaultSchema}].[Artifact] AS a
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Committee] AS mjBizAppsCommitteesCommittee_CommitteeID
  ON
    [a].[CommitteeID] = mjBizAppsCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [${mjSchema}_BizAppsTasks].[Task] AS mjBizAppsTasksTask_TaskID
  ON
    [a].[TaskID] = mjBizAppsTasksTask_TaskID.[ID]
INNER JOIN
    [${flyway:defaultSchema}].[ArtifactType] AS mjBizAppsCommitteesArtifactType_ArtifactTypeID
  ON
    [a].[ArtifactTypeID] = mjBizAppsCommitteesArtifactType_ArtifactTypeID.[ID]
LEFT OUTER JOIN
    [${mjBACSchema}].[Person] AS mjBizAppsCommonPerson_UploadedByPersonID
  ON
    [a].[UploadedByPersonID] = mjBizAppsCommonPerson_UploadedByPersonID.[ID]
GO
GRANT SELECT ON [${flyway:defaultSchema}].[vwArtifacts] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Artifacts */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifacts
-- Item: Permissions for vwArtifacts
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}].[vwArtifacts] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Artifacts */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifacts
-- Item: spCreateArtifact
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Artifact
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateArtifact]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateArtifact];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateArtifact]
    @ID uniqueidentifier = NULL,
    @CommitteeID_Clear bit = 0,
    @CommitteeID uniqueidentifier = NULL,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @TaskID_Clear bit = 0,
    @TaskID uniqueidentifier = NULL,
    @Title nvarchar(255),
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @ArtifactTypeID uniqueidentifier,
    @Provider nvarchar(50),
    @ExternalID_Clear bit = 0,
    @ExternalID nvarchar(500) = NULL,
    @URL nvarchar(2000),
    @MimeType_Clear bit = 0,
    @MimeType nvarchar(100) = NULL,
    @FileSize_Clear bit = 0,
    @FileSize bigint = NULL,
    @UploadedByPersonID_Clear bit = 0,
    @UploadedByPersonID uniqueidentifier = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[Artifact]
            (
                [ID],
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [TaskID],
                [Title],
                [Description],
                [ArtifactTypeID],
                [Provider],
                [ExternalID],
                [URL],
                [MimeType],
                [FileSize],
                [UploadedByPersonID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                CASE WHEN @CommitteeID_Clear = 1 THEN NULL ELSE ISNULL(@CommitteeID, NULL) END,
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                CASE WHEN @TaskID_Clear = 1 THEN NULL ELSE ISNULL(@TaskID, NULL) END,
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @ArtifactTypeID,
                @Provider,
                CASE WHEN @ExternalID_Clear = 1 THEN NULL ELSE ISNULL(@ExternalID, NULL) END,
                @URL,
                CASE WHEN @MimeType_Clear = 1 THEN NULL ELSE ISNULL(@MimeType, NULL) END,
                CASE WHEN @FileSize_Clear = 1 THEN NULL ELSE ISNULL(@FileSize, NULL) END,
                CASE WHEN @UploadedByPersonID_Clear = 1 THEN NULL ELSE ISNULL(@UploadedByPersonID, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[Artifact]
            (
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [TaskID],
                [Title],
                [Description],
                [ArtifactTypeID],
                [Provider],
                [ExternalID],
                [URL],
                [MimeType],
                [FileSize],
                [UploadedByPersonID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                CASE WHEN @CommitteeID_Clear = 1 THEN NULL ELSE ISNULL(@CommitteeID, NULL) END,
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                CASE WHEN @TaskID_Clear = 1 THEN NULL ELSE ISNULL(@TaskID, NULL) END,
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @ArtifactTypeID,
                @Provider,
                CASE WHEN @ExternalID_Clear = 1 THEN NULL ELSE ISNULL(@ExternalID, NULL) END,
                @URL,
                CASE WHEN @MimeType_Clear = 1 THEN NULL ELSE ISNULL(@MimeType, NULL) END,
                CASE WHEN @FileSize_Clear = 1 THEN NULL ELSE ISNULL(@FileSize, NULL) END,
                CASE WHEN @UploadedByPersonID_Clear = 1 THEN NULL ELSE ISNULL(@UploadedByPersonID, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwArtifacts] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateArtifact] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Artifacts */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateArtifact] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Artifacts */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifacts
-- Item: spUpdateArtifact
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Artifact
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateArtifact]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateArtifact];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateArtifact]
    @ID uniqueidentifier,
    @CommitteeID_Clear bit = 0,
    @CommitteeID uniqueidentifier = NULL,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @TaskID_Clear bit = 0,
    @TaskID uniqueidentifier = NULL,
    @Title nvarchar(255) = NULL,
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @ArtifactTypeID uniqueidentifier = NULL,
    @Provider nvarchar(50) = NULL,
    @ExternalID_Clear bit = 0,
    @ExternalID nvarchar(500) = NULL,
    @URL nvarchar(2000) = NULL,
    @MimeType_Clear bit = 0,
    @MimeType nvarchar(100) = NULL,
    @FileSize_Clear bit = 0,
    @FileSize bigint = NULL,
    @UploadedByPersonID_Clear bit = 0,
    @UploadedByPersonID uniqueidentifier = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Artifact]
    SET
        [CommitteeID] = CASE WHEN @CommitteeID_Clear = 1 THEN NULL ELSE ISNULL(@CommitteeID, [CommitteeID]) END,
        [MeetingID] = CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, [MeetingID]) END,
        [AgendaItemID] = CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, [AgendaItemID]) END,
        [TaskID] = CASE WHEN @TaskID_Clear = 1 THEN NULL ELSE ISNULL(@TaskID, [TaskID]) END,
        [Title] = ISNULL(@Title, [Title]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [ArtifactTypeID] = ISNULL(@ArtifactTypeID, [ArtifactTypeID]),
        [Provider] = ISNULL(@Provider, [Provider]),
        [ExternalID] = CASE WHEN @ExternalID_Clear = 1 THEN NULL ELSE ISNULL(@ExternalID, [ExternalID]) END,
        [URL] = ISNULL(@URL, [URL]),
        [MimeType] = CASE WHEN @MimeType_Clear = 1 THEN NULL ELSE ISNULL(@MimeType, [MimeType]) END,
        [FileSize] = CASE WHEN @FileSize_Clear = 1 THEN NULL ELSE ISNULL(@FileSize, [FileSize]) END,
        [UploadedByPersonID] = CASE WHEN @UploadedByPersonID_Clear = 1 THEN NULL ELSE ISNULL(@UploadedByPersonID, [UploadedByPersonID]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwArtifacts] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwArtifacts]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifact] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Artifact table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateArtifact]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateArtifact];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateArtifact
ON [${flyway:defaultSchema}].[Artifact]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Artifact]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}].[Artifact] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Artifacts */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifact] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Artifacts */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifacts
-- Item: spDeleteArtifact
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Artifact
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteArtifact]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteArtifact];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteArtifact]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Artifact]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteArtifact] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Artifacts */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteArtifact] TO [cdp_Developer], [cdp_Integration];

/* Index for Foreign Keys for Comment */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key CommitteeID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_CommitteeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_CommitteeID ON [${flyway:defaultSchema}].[Comment] ([CommitteeID]);

-- Index for foreign key MeetingID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_MeetingID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_MeetingID ON [${flyway:defaultSchema}].[Comment] ([MeetingID]);

-- Index for foreign key AgendaItemID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_AgendaItemID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_AgendaItemID ON [${flyway:defaultSchema}].[Comment] ([AgendaItemID]);

-- Index for foreign key TaskID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_TaskID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_TaskID ON [${flyway:defaultSchema}].[Comment] ([TaskID]);

-- Index for foreign key ArtifactID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_ArtifactID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_ArtifactID ON [${flyway:defaultSchema}].[Comment] ([ArtifactID]);

-- Index for foreign key ParentCommentID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_ParentCommentID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_ParentCommentID ON [${flyway:defaultSchema}].[Comment] ([ParentCommentID]);

-- Index for foreign key PersonID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_PersonID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_PersonID ON [${flyway:defaultSchema}].[Comment] ([PersonID]);

/* SQL text to update entity field related entity name field map for entity field ID CCB8CE89-810E-4229-ACB9-4CCDCC344A55 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='CCB8CE89-810E-4229-ACB9-4CCDCC344A55', @RelatedEntityNameFieldMap='Committee';

/* Index for Foreign Keys for Committee */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Committees
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key TypeID in table Committee
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Committee_TypeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Committee]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Committee_TypeID ON [${flyway:defaultSchema}].[Committee] ([TypeID]);

-- Index for foreign key ParentCommitteeID in table Committee
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Committee_ParentCommitteeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Committee]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Committee_ParentCommitteeID ON [${flyway:defaultSchema}].[Committee] ([ParentCommitteeID]);

-- Index for foreign key OrganizationID in table Committee
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Committee_OrganizationID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Committee]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Committee_OrganizationID ON [${flyway:defaultSchema}].[Committee] ([OrganizationID]);

/* SQL text to update entity field related entity name field map for entity field ID B791235E-ED08-4169-8C97-60D292C3DD31 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='B791235E-ED08-4169-8C97-60D292C3DD31', @RelatedEntityNameFieldMap='Type';

/* Index for Foreign Keys for Meeting */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key CommitteeID in table Meeting
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Meeting_CommitteeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Meeting]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Meeting_CommitteeID ON [${flyway:defaultSchema}].[Meeting] ([CommitteeID]);

-- Index for foreign key VideoProviderID in table Meeting
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Meeting_VideoProviderID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Meeting]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Meeting_VideoProviderID ON [${flyway:defaultSchema}].[Meeting] ([VideoProviderID]);

/* SQL text to update entity field related entity name field map for entity field ID 0920B300-E269-4EE4-976A-582CF49136C4 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='0920B300-E269-4EE4-976A-582CF49136C4', @RelatedEntityNameFieldMap='Committee';

/* Index for Foreign Keys for Membership */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Memberships
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key PersonID in table Membership
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Membership_PersonID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Membership]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Membership_PersonID ON [${flyway:defaultSchema}].[Membership] ([PersonID]);

-- Index for foreign key RoleID in table Membership
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Membership_RoleID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Membership]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Membership_RoleID ON [${flyway:defaultSchema}].[Membership] ([RoleID]);

-- Index for foreign key TermID in table Membership
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Membership_TermID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Membership]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Membership_TermID ON [${flyway:defaultSchema}].[Membership] ([TermID]);

/* SQL text to update entity field related entity name field map for entity field ID 5626BF59-B910-4AE3-AA51-A9CABF3102A9 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='5626BF59-B910-4AE3-AA51-A9CABF3102A9', @RelatedEntityNameFieldMap='Person';

/* Index for Foreign Keys for Minute */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Minutes
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key ArtifactID in table Minute
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Minute_ArtifactID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Minute]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Minute_ArtifactID ON [${flyway:defaultSchema}].[Minute] ([ArtifactID]);

-- Index for foreign key MeetingID in table Minute
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Minute_MeetingID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Minute]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Minute_MeetingID ON [${flyway:defaultSchema}].[Minute] ([MeetingID]);

-- Index for foreign key ApprovedByMeetingID in table Minute
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Minute_ApprovedByMeetingID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Minute]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Minute_ApprovedByMeetingID ON [${flyway:defaultSchema}].[Minute] ([ApprovedByMeetingID]);

/* Base View SQL for Committees: Minutes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Minutes
-- Item: vwMinutes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Minutes
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Minute
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwMinutes]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwMinutes];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwMinutes]
AS
SELECT
    m.*
FROM
    [${flyway:defaultSchema}].[Minute] AS m
GO
GRANT SELECT ON [${flyway:defaultSchema}].[vwMinutes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Minutes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Minutes
-- Item: Permissions for vwMinutes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}].[vwMinutes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Minutes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Minutes
-- Item: spCreateMinute
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Minute
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateMinute]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateMinute];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateMinute]
    @ID uniqueidentifier = NULL,
    @ArtifactID_Clear bit = 0,
    @ArtifactID uniqueidentifier = NULL,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @Content_Clear bit = 0,
    @Content nvarchar(MAX) = NULL,
    @ApprovalStatus nvarchar(50) = NULL,
    @ApprovedAt_Clear bit = 0,
    @ApprovedAt datetimeoffset = NULL,
    @ApprovedByMeetingID_Clear bit = 0,
    @ApprovedByMeetingID uniqueidentifier = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[Minute]
            (
                [ID],
                [ArtifactID],
                [MeetingID],
                [Content],
                [ApprovalStatus],
                [ApprovedAt],
                [ApprovedByMeetingID],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                CASE WHEN @ArtifactID_Clear = 1 THEN NULL ELSE ISNULL(@ArtifactID, NULL) END,
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @Content_Clear = 1 THEN NULL ELSE ISNULL(@Content, NULL) END,
                ISNULL(@ApprovalStatus, 'Draft'),
                CASE WHEN @ApprovedAt_Clear = 1 THEN NULL ELSE ISNULL(@ApprovedAt, NULL) END,
                CASE WHEN @ApprovedByMeetingID_Clear = 1 THEN NULL ELSE ISNULL(@ApprovedByMeetingID, NULL) END,
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[Minute]
            (
                [ArtifactID],
                [MeetingID],
                [Content],
                [ApprovalStatus],
                [ApprovedAt],
                [ApprovedByMeetingID],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                CASE WHEN @ArtifactID_Clear = 1 THEN NULL ELSE ISNULL(@ArtifactID, NULL) END,
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @Content_Clear = 1 THEN NULL ELSE ISNULL(@Content, NULL) END,
                ISNULL(@ApprovalStatus, 'Draft'),
                CASE WHEN @ApprovedAt_Clear = 1 THEN NULL ELSE ISNULL(@ApprovedAt, NULL) END,
                CASE WHEN @ApprovedByMeetingID_Clear = 1 THEN NULL ELSE ISNULL(@ApprovedByMeetingID, NULL) END,
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwMinutes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMinute] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Minutes */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMinute] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Minutes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Minutes
-- Item: spUpdateMinute
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Minute
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateMinute]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateMinute];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateMinute]
    @ID uniqueidentifier,
    @ArtifactID_Clear bit = 0,
    @ArtifactID uniqueidentifier = NULL,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @Content_Clear bit = 0,
    @Content nvarchar(MAX) = NULL,
    @ApprovalStatus nvarchar(50) = NULL,
    @ApprovedAt_Clear bit = 0,
    @ApprovedAt datetimeoffset = NULL,
    @ApprovedByMeetingID_Clear bit = 0,
    @ApprovedByMeetingID uniqueidentifier = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Minute]
    SET
        [ArtifactID] = CASE WHEN @ArtifactID_Clear = 1 THEN NULL ELSE ISNULL(@ArtifactID, [ArtifactID]) END,
        [MeetingID] = CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, [MeetingID]) END,
        [Content] = CASE WHEN @Content_Clear = 1 THEN NULL ELSE ISNULL(@Content, [Content]) END,
        [ApprovalStatus] = ISNULL(@ApprovalStatus, [ApprovalStatus]),
        [ApprovedAt] = CASE WHEN @ApprovedAt_Clear = 1 THEN NULL ELSE ISNULL(@ApprovedAt, [ApprovedAt]) END,
        [ApprovedByMeetingID] = CASE WHEN @ApprovedByMeetingID_Clear = 1 THEN NULL ELSE ISNULL(@ApprovedByMeetingID, [ApprovedByMeetingID]) END,
        [Notes] = CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, [Notes]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwMinutes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwMinutes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMinute] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Minute table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateMinute]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateMinute];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateMinute
ON [${flyway:defaultSchema}].[Minute]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Minute]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}].[Minute] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Minutes */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMinute] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Minutes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Minutes
-- Item: spDeleteMinute
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Minute
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteMinute]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteMinute];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteMinute]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Minute]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMinute] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Minutes */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMinute] TO [cdp_Developer], [cdp_Integration];

/* SQL text to update entity field related entity name field map for entity field ID CBC39996-E357-41AF-9210-8C38CA72503A */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='CBC39996-E357-41AF-9210-8C38CA72503A', @RelatedEntityNameFieldMap='VideoProvider_Virtual';

/* SQL text to update entity field related entity name field map for entity field ID 0033110B-CAB3-4FF9-A7FD-4F0023A2F9E2 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='0033110B-CAB3-4FF9-A7FD-4F0023A2F9E2', @RelatedEntityNameFieldMap='Task';

/* SQL text to update entity field related entity name field map for entity field ID 688DFEB5-E302-4237-AF4C-C9B6C1E661D9 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='688DFEB5-E302-4237-AF4C-C9B6C1E661D9', @RelatedEntityNameFieldMap='ParentCommittee';

/* SQL text to update entity field related entity name field map for entity field ID F6C680F8-C4D0-4860-8763-603D9D2CF9E7 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='F6C680F8-C4D0-4860-8763-603D9D2CF9E7', @RelatedEntityNameFieldMap='Role';

/* Base View SQL for Committees: Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
-- Item: vwMeetings
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Meetings
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Meeting
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwMeetings]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwMeetings];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwMeetings]
AS
SELECT
    m.*,
    mjBizAppsCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjBizAppsCommitteesVideoProvider_VideoProviderID.[Name] AS [VideoProvider_Virtual]
FROM
    [${flyway:defaultSchema}].[Meeting] AS m
INNER JOIN
    [${flyway:defaultSchema}].[Committee] AS mjBizAppsCommitteesCommittee_CommitteeID
  ON
    [m].[CommitteeID] = mjBizAppsCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[VideoProvider] AS mjBizAppsCommitteesVideoProvider_VideoProviderID
  ON
    [m].[VideoProviderID] = mjBizAppsCommitteesVideoProvider_VideoProviderID.[ID]
GO
GRANT SELECT ON [${flyway:defaultSchema}].[vwMeetings] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
-- Item: Permissions for vwMeetings
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}].[vwMeetings] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
-- Item: spCreateMeeting
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Meeting
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateMeeting]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateMeeting];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateMeeting]
    @ID uniqueidentifier = NULL,
    @CommitteeID uniqueidentifier,
    @Title nvarchar(255),
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @StartDateTime datetimeoffset,
    @EndDateTime_Clear bit = 0,
    @EndDateTime datetimeoffset = NULL,
    @TimeZone nvarchar(50) = NULL,
    @LocationType nvarchar(50) = NULL,
    @LocationText_Clear bit = 0,
    @LocationText nvarchar(500) = NULL,
    @VideoProvider_Clear bit = 0,
    @VideoProvider nvarchar(50) = NULL,
    @VideoProviderID_Clear bit = 0,
    @VideoProviderID uniqueidentifier = NULL,
    @VideoMeetingID_Clear bit = 0,
    @VideoMeetingID nvarchar(255) = NULL,
    @VideoJoinURL_Clear bit = 0,
    @VideoJoinURL nvarchar(1000) = NULL,
    @VideoRecordingURL_Clear bit = 0,
    @VideoRecordingURL nvarchar(1000) = NULL,
    @TranscriptURL_Clear bit = 0,
    @TranscriptURL nvarchar(1000) = NULL,
    @Status nvarchar(50) = NULL,
    @CalendarEventID_Clear bit = 0,
    @CalendarEventID nvarchar(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[Meeting]
            (
                [ID],
                [CommitteeID],
                [Title],
                [Description],
                [StartDateTime],
                [EndDateTime],
                [TimeZone],
                [LocationType],
                [LocationText],
                [VideoProvider],
                [VideoProviderID],
                [VideoMeetingID],
                [VideoJoinURL],
                [VideoRecordingURL],
                [TranscriptURL],
                [Status],
                [CalendarEventID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @CommitteeID,
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @StartDateTime,
                CASE WHEN @EndDateTime_Clear = 1 THEN NULL ELSE ISNULL(@EndDateTime, NULL) END,
                ISNULL(@TimeZone, 'America/New_York'),
                ISNULL(@LocationType, 'Virtual'),
                CASE WHEN @LocationText_Clear = 1 THEN NULL ELSE ISNULL(@LocationText, NULL) END,
                CASE WHEN @VideoProvider_Clear = 1 THEN NULL ELSE ISNULL(@VideoProvider, NULL) END,
                CASE WHEN @VideoProviderID_Clear = 1 THEN NULL ELSE ISNULL(@VideoProviderID, NULL) END,
                CASE WHEN @VideoMeetingID_Clear = 1 THEN NULL ELSE ISNULL(@VideoMeetingID, NULL) END,
                CASE WHEN @VideoJoinURL_Clear = 1 THEN NULL ELSE ISNULL(@VideoJoinURL, NULL) END,
                CASE WHEN @VideoRecordingURL_Clear = 1 THEN NULL ELSE ISNULL(@VideoRecordingURL, NULL) END,
                CASE WHEN @TranscriptURL_Clear = 1 THEN NULL ELSE ISNULL(@TranscriptURL, NULL) END,
                ISNULL(@Status, 'Scheduled'),
                CASE WHEN @CalendarEventID_Clear = 1 THEN NULL ELSE ISNULL(@CalendarEventID, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[Meeting]
            (
                [CommitteeID],
                [Title],
                [Description],
                [StartDateTime],
                [EndDateTime],
                [TimeZone],
                [LocationType],
                [LocationText],
                [VideoProvider],
                [VideoProviderID],
                [VideoMeetingID],
                [VideoJoinURL],
                [VideoRecordingURL],
                [TranscriptURL],
                [Status],
                [CalendarEventID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @CommitteeID,
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @StartDateTime,
                CASE WHEN @EndDateTime_Clear = 1 THEN NULL ELSE ISNULL(@EndDateTime, NULL) END,
                ISNULL(@TimeZone, 'America/New_York'),
                ISNULL(@LocationType, 'Virtual'),
                CASE WHEN @LocationText_Clear = 1 THEN NULL ELSE ISNULL(@LocationText, NULL) END,
                CASE WHEN @VideoProvider_Clear = 1 THEN NULL ELSE ISNULL(@VideoProvider, NULL) END,
                CASE WHEN @VideoProviderID_Clear = 1 THEN NULL ELSE ISNULL(@VideoProviderID, NULL) END,
                CASE WHEN @VideoMeetingID_Clear = 1 THEN NULL ELSE ISNULL(@VideoMeetingID, NULL) END,
                CASE WHEN @VideoJoinURL_Clear = 1 THEN NULL ELSE ISNULL(@VideoJoinURL, NULL) END,
                CASE WHEN @VideoRecordingURL_Clear = 1 THEN NULL ELSE ISNULL(@VideoRecordingURL, NULL) END,
                CASE WHEN @TranscriptURL_Clear = 1 THEN NULL ELSE ISNULL(@TranscriptURL, NULL) END,
                ISNULL(@Status, 'Scheduled'),
                CASE WHEN @CalendarEventID_Clear = 1 THEN NULL ELSE ISNULL(@CalendarEventID, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwMeetings] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMeeting] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Meetings */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMeeting] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
-- Item: spUpdateMeeting
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Meeting
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateMeeting]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateMeeting];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateMeeting]
    @ID uniqueidentifier,
    @CommitteeID uniqueidentifier = NULL,
    @Title nvarchar(255) = NULL,
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @StartDateTime datetimeoffset = NULL,
    @EndDateTime_Clear bit = 0,
    @EndDateTime datetimeoffset = NULL,
    @TimeZone nvarchar(50) = NULL,
    @LocationType nvarchar(50) = NULL,
    @LocationText_Clear bit = 0,
    @LocationText nvarchar(500) = NULL,
    @VideoProvider_Clear bit = 0,
    @VideoProvider nvarchar(50) = NULL,
    @VideoProviderID_Clear bit = 0,
    @VideoProviderID uniqueidentifier = NULL,
    @VideoMeetingID_Clear bit = 0,
    @VideoMeetingID nvarchar(255) = NULL,
    @VideoJoinURL_Clear bit = 0,
    @VideoJoinURL nvarchar(1000) = NULL,
    @VideoRecordingURL_Clear bit = 0,
    @VideoRecordingURL nvarchar(1000) = NULL,
    @TranscriptURL_Clear bit = 0,
    @TranscriptURL nvarchar(1000) = NULL,
    @Status nvarchar(50) = NULL,
    @CalendarEventID_Clear bit = 0,
    @CalendarEventID nvarchar(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Meeting]
    SET
        [CommitteeID] = ISNULL(@CommitteeID, [CommitteeID]),
        [Title] = ISNULL(@Title, [Title]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [StartDateTime] = ISNULL(@StartDateTime, [StartDateTime]),
        [EndDateTime] = CASE WHEN @EndDateTime_Clear = 1 THEN NULL ELSE ISNULL(@EndDateTime, [EndDateTime]) END,
        [TimeZone] = ISNULL(@TimeZone, [TimeZone]),
        [LocationType] = ISNULL(@LocationType, [LocationType]),
        [LocationText] = CASE WHEN @LocationText_Clear = 1 THEN NULL ELSE ISNULL(@LocationText, [LocationText]) END,
        [VideoProvider] = CASE WHEN @VideoProvider_Clear = 1 THEN NULL ELSE ISNULL(@VideoProvider, [VideoProvider]) END,
        [VideoProviderID] = CASE WHEN @VideoProviderID_Clear = 1 THEN NULL ELSE ISNULL(@VideoProviderID, [VideoProviderID]) END,
        [VideoMeetingID] = CASE WHEN @VideoMeetingID_Clear = 1 THEN NULL ELSE ISNULL(@VideoMeetingID, [VideoMeetingID]) END,
        [VideoJoinURL] = CASE WHEN @VideoJoinURL_Clear = 1 THEN NULL ELSE ISNULL(@VideoJoinURL, [VideoJoinURL]) END,
        [VideoRecordingURL] = CASE WHEN @VideoRecordingURL_Clear = 1 THEN NULL ELSE ISNULL(@VideoRecordingURL, [VideoRecordingURL]) END,
        [TranscriptURL] = CASE WHEN @TranscriptURL_Clear = 1 THEN NULL ELSE ISNULL(@TranscriptURL, [TranscriptURL]) END,
        [Status] = ISNULL(@Status, [Status]),
        [CalendarEventID] = CASE WHEN @CalendarEventID_Clear = 1 THEN NULL ELSE ISNULL(@CalendarEventID, [CalendarEventID]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwMeetings] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwMeetings]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMeeting] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Meeting table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateMeeting]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateMeeting];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateMeeting
ON [${flyway:defaultSchema}].[Meeting]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Meeting]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}].[Meeting] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Meetings */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMeeting] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
-- Item: spDeleteMeeting
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Meeting
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteMeeting]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteMeeting];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteMeeting]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Meeting]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMeeting] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Meetings */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMeeting] TO [cdp_Developer], [cdp_Integration];

/* SQL text to update entity field related entity name field map for entity field ID 0B9A63EA-3E56-4174-AA54-94E843E063FB */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='0B9A63EA-3E56-4174-AA54-94E843E063FB', @RelatedEntityNameFieldMap='Term';

/* SQL text to update entity field related entity name field map for entity field ID BAEC348E-80EC-4097-9229-9E663C113B4F */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='BAEC348E-80EC-4097-9229-9E663C113B4F', @RelatedEntityNameFieldMap='Person';

/* SQL text to update entity field related entity name field map for entity field ID B3AE4A14-D2FE-467D-80D0-8D91FD7FD105 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='B3AE4A14-D2FE-467D-80D0-8D91FD7FD105', @RelatedEntityNameFieldMap='Organization';

/* Root ID Function SQL for Committees: Committees.ParentCommitteeID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Committees
-- Item: fnCommitteeParentCommitteeID_GetRootID
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- ROOT ID FUNCTION FOR: [Committee].[ParentCommitteeID]
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[fnCommitteeParentCommitteeID_GetRootID]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}].[fnCommitteeParentCommitteeID_GetRootID];
GO

CREATE FUNCTION [${flyway:defaultSchema}].[fnCommitteeParentCommitteeID_GetRootID]
(
    @RecordID uniqueidentifier,
    @ParentID uniqueidentifier
)
RETURNS TABLE
AS
RETURN
(
    WITH CTE_RootParent AS (
        SELECT
            [ID],
            [ParentCommitteeID],
            [ID] AS [RootParentID],
            0 AS [Depth]
        FROM
            [${flyway:defaultSchema}].[Committee]
        WHERE
            [ID] = COALESCE(@ParentID, @RecordID)

        UNION ALL

        SELECT
            c.[ID],
            c.[ParentCommitteeID],
            c.[ID] AS [RootParentID],
            p.[Depth] + 1 AS [Depth]
        FROM
            [${flyway:defaultSchema}].[Committee] c
        INNER JOIN
            CTE_RootParent p ON c.[ID] = p.[ParentCommitteeID]
        WHERE
            p.[Depth] < 100
    )
    SELECT TOP 1
        [RootParentID] AS RootID
    FROM
        CTE_RootParent
    WHERE
        [ParentCommitteeID] IS NULL
    ORDER BY
        [RootParentID]
);
GO

/* Base View SQL for Committees: Committees */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Committees
-- Item: vwCommittees
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Committees
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Committee
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwCommittees]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwCommittees];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwCommittees]
AS
SELECT
    c.*,
    mjBizAppsCommitteesType_TypeID.[Name] AS [Type],
    mjBizAppsCommitteesCommittee_ParentCommitteeID.[Name] AS [ParentCommittee],
    mjBizAppsCommonOrganization_OrganizationID.[Name] AS [Organization],
    root_ParentCommitteeID.RootID AS [RootParentCommitteeID]
FROM
    [${flyway:defaultSchema}].[Committee] AS c
INNER JOIN
    [${flyway:defaultSchema}].[Type] AS mjBizAppsCommitteesType_TypeID
  ON
    [c].[TypeID] = mjBizAppsCommitteesType_TypeID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Committee] AS mjBizAppsCommitteesCommittee_ParentCommitteeID
  ON
    [c].[ParentCommitteeID] = mjBizAppsCommitteesCommittee_ParentCommitteeID.[ID]
LEFT OUTER JOIN
    [${mjBACSchema}].[Organization] AS mjBizAppsCommonOrganization_OrganizationID
  ON
    [c].[OrganizationID] = mjBizAppsCommonOrganization_OrganizationID.[ID]
OUTER APPLY
    [${flyway:defaultSchema}].[fnCommitteeParentCommitteeID_GetRootID]([c].[ID], [c].[ParentCommitteeID]) AS root_ParentCommitteeID
GO
GRANT SELECT ON [${flyway:defaultSchema}].[vwCommittees] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Committees */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Committees
-- Item: Permissions for vwCommittees
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}].[vwCommittees] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Committees */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Committees
-- Item: spCreateCommittee
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Committee
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateCommittee]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateCommittee];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateCommittee]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(255),
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @TypeID uniqueidentifier,
    @ParentCommitteeID_Clear bit = 0,
    @ParentCommitteeID uniqueidentifier = NULL,
    @OrganizationID_Clear bit = 0,
    @OrganizationID uniqueidentifier = NULL,
    @CharterDocumentURL_Clear bit = 0,
    @CharterDocumentURL nvarchar(1000) = NULL,
    @MissionStatement_Clear bit = 0,
    @MissionStatement nvarchar(MAX) = NULL,
    @Status nvarchar(50) = NULL,
    @IsPublic bit = NULL,
    @FormationDate_Clear bit = 0,
    @FormationDate date = NULL,
    @DissolutionDate_Clear bit = 0,
    @DissolutionDate date = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[Committee]
            (
                [ID],
                [Name],
                [Description],
                [TypeID],
                [ParentCommitteeID],
                [OrganizationID],
                [CharterDocumentURL],
                [MissionStatement],
                [Status],
                [IsPublic],
                [FormationDate],
                [DissolutionDate]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @Name,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @TypeID,
                CASE WHEN @ParentCommitteeID_Clear = 1 THEN NULL ELSE ISNULL(@ParentCommitteeID, NULL) END,
                CASE WHEN @OrganizationID_Clear = 1 THEN NULL ELSE ISNULL(@OrganizationID, NULL) END,
                CASE WHEN @CharterDocumentURL_Clear = 1 THEN NULL ELSE ISNULL(@CharterDocumentURL, NULL) END,
                CASE WHEN @MissionStatement_Clear = 1 THEN NULL ELSE ISNULL(@MissionStatement, NULL) END,
                ISNULL(@Status, 'Active'),
                ISNULL(@IsPublic, 1),
                CASE WHEN @FormationDate_Clear = 1 THEN NULL ELSE ISNULL(@FormationDate, NULL) END,
                CASE WHEN @DissolutionDate_Clear = 1 THEN NULL ELSE ISNULL(@DissolutionDate, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[Committee]
            (
                [Name],
                [Description],
                [TypeID],
                [ParentCommitteeID],
                [OrganizationID],
                [CharterDocumentURL],
                [MissionStatement],
                [Status],
                [IsPublic],
                [FormationDate],
                [DissolutionDate]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @Name,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @TypeID,
                CASE WHEN @ParentCommitteeID_Clear = 1 THEN NULL ELSE ISNULL(@ParentCommitteeID, NULL) END,
                CASE WHEN @OrganizationID_Clear = 1 THEN NULL ELSE ISNULL(@OrganizationID, NULL) END,
                CASE WHEN @CharterDocumentURL_Clear = 1 THEN NULL ELSE ISNULL(@CharterDocumentURL, NULL) END,
                CASE WHEN @MissionStatement_Clear = 1 THEN NULL ELSE ISNULL(@MissionStatement, NULL) END,
                ISNULL(@Status, 'Active'),
                ISNULL(@IsPublic, 1),
                CASE WHEN @FormationDate_Clear = 1 THEN NULL ELSE ISNULL(@FormationDate, NULL) END,
                CASE WHEN @DissolutionDate_Clear = 1 THEN NULL ELSE ISNULL(@DissolutionDate, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwCommittees] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateCommittee] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Committees */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateCommittee] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Committees */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Committees
-- Item: spUpdateCommittee
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Committee
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateCommittee]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateCommittee];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateCommittee]
    @ID uniqueidentifier,
    @Name nvarchar(255) = NULL,
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @TypeID uniqueidentifier = NULL,
    @ParentCommitteeID_Clear bit = 0,
    @ParentCommitteeID uniqueidentifier = NULL,
    @OrganizationID_Clear bit = 0,
    @OrganizationID uniqueidentifier = NULL,
    @CharterDocumentURL_Clear bit = 0,
    @CharterDocumentURL nvarchar(1000) = NULL,
    @MissionStatement_Clear bit = 0,
    @MissionStatement nvarchar(MAX) = NULL,
    @Status nvarchar(50) = NULL,
    @IsPublic bit = NULL,
    @FormationDate_Clear bit = 0,
    @FormationDate date = NULL,
    @DissolutionDate_Clear bit = 0,
    @DissolutionDate date = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Committee]
    SET
        [Name] = ISNULL(@Name, [Name]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [TypeID] = ISNULL(@TypeID, [TypeID]),
        [ParentCommitteeID] = CASE WHEN @ParentCommitteeID_Clear = 1 THEN NULL ELSE ISNULL(@ParentCommitteeID, [ParentCommitteeID]) END,
        [OrganizationID] = CASE WHEN @OrganizationID_Clear = 1 THEN NULL ELSE ISNULL(@OrganizationID, [OrganizationID]) END,
        [CharterDocumentURL] = CASE WHEN @CharterDocumentURL_Clear = 1 THEN NULL ELSE ISNULL(@CharterDocumentURL, [CharterDocumentURL]) END,
        [MissionStatement] = CASE WHEN @MissionStatement_Clear = 1 THEN NULL ELSE ISNULL(@MissionStatement, [MissionStatement]) END,
        [Status] = ISNULL(@Status, [Status]),
        [IsPublic] = ISNULL(@IsPublic, [IsPublic]),
        [FormationDate] = CASE WHEN @FormationDate_Clear = 1 THEN NULL ELSE ISNULL(@FormationDate, [FormationDate]) END,
        [DissolutionDate] = CASE WHEN @DissolutionDate_Clear = 1 THEN NULL ELSE ISNULL(@DissolutionDate, [DissolutionDate]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwCommittees] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwCommittees]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateCommittee] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Committee table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateCommittee]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateCommittee];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateCommittee
ON [${flyway:defaultSchema}].[Committee]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Committee]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}].[Committee] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Committees */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateCommittee] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Committees */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Committees
-- Item: spDeleteCommittee
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Committee
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteCommittee]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteCommittee];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteCommittee]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Committee]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteCommittee] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Committees */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteCommittee] TO [cdp_Developer], [cdp_Integration];

/* Root ID Function SQL for Committees: Comments.ParentCommentID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: fnCommentParentCommentID_GetRootID
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- ROOT ID FUNCTION FOR: [Comment].[ParentCommentID]
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[fnCommentParentCommentID_GetRootID]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}].[fnCommentParentCommentID_GetRootID];
GO

CREATE FUNCTION [${flyway:defaultSchema}].[fnCommentParentCommentID_GetRootID]
(
    @RecordID uniqueidentifier,
    @ParentID uniqueidentifier
)
RETURNS TABLE
AS
RETURN
(
    WITH CTE_RootParent AS (
        SELECT
            [ID],
            [ParentCommentID],
            [ID] AS [RootParentID],
            0 AS [Depth]
        FROM
            [${flyway:defaultSchema}].[Comment]
        WHERE
            [ID] = COALESCE(@ParentID, @RecordID)

        UNION ALL

        SELECT
            c.[ID],
            c.[ParentCommentID],
            c.[ID] AS [RootParentID],
            p.[Depth] + 1 AS [Depth]
        FROM
            [${flyway:defaultSchema}].[Comment] c
        INNER JOIN
            CTE_RootParent p ON c.[ID] = p.[ParentCommentID]
        WHERE
            p.[Depth] < 100
    )
    SELECT TOP 1
        [RootParentID] AS RootID
    FROM
        CTE_RootParent
    WHERE
        [ParentCommentID] IS NULL
    ORDER BY
        [RootParentID]
);
GO

/* Base View SQL for Committees: Comments */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: vwComments
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Comments
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Comment
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwComments]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwComments];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwComments]
AS
SELECT
    c.*,
    mjBizAppsCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjBizAppsTasksTask_TaskID.[Name] AS [Task],
    mjBizAppsCommonPerson_PersonID.[DisplayName] AS [Person],
    root_ParentCommentID.RootID AS [RootParentCommentID]
FROM
    [${flyway:defaultSchema}].[Comment] AS c
INNER JOIN
    [${flyway:defaultSchema}].[Committee] AS mjBizAppsCommitteesCommittee_CommitteeID
  ON
    [c].[CommitteeID] = mjBizAppsCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [${mjSchema}_BizAppsTasks].[Task] AS mjBizAppsTasksTask_TaskID
  ON
    [c].[TaskID] = mjBizAppsTasksTask_TaskID.[ID]
INNER JOIN
    [${mjBACSchema}].[Person] AS mjBizAppsCommonPerson_PersonID
  ON
    [c].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
OUTER APPLY
    [${flyway:defaultSchema}].[fnCommentParentCommentID_GetRootID]([c].[ID], [c].[ParentCommentID]) AS root_ParentCommentID
GO
GRANT SELECT ON [${flyway:defaultSchema}].[vwComments] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Comments */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: Permissions for vwComments
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}].[vwComments] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Comments */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: spCreateComment
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Comment
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateComment]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateComment];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateComment]
    @ID uniqueidentifier = NULL,
    @CommitteeID uniqueidentifier,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @TaskID_Clear bit = 0,
    @TaskID uniqueidentifier = NULL,
    @ArtifactID_Clear bit = 0,
    @ArtifactID uniqueidentifier = NULL,
    @ParentCommentID_Clear bit = 0,
    @ParentCommentID uniqueidentifier = NULL,
    @PersonID uniqueidentifier,
    @CommentText nvarchar(MAX),
    @MentionedPersonIDs_Clear bit = 0,
    @MentionedPersonIDs nvarchar(MAX) = NULL,
    @IsResolved bit = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[Comment]
            (
                [ID],
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [TaskID],
                [ArtifactID],
                [ParentCommentID],
                [PersonID],
                [CommentText],
                [MentionedPersonIDs],
                [IsResolved]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @CommitteeID,
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                CASE WHEN @TaskID_Clear = 1 THEN NULL ELSE ISNULL(@TaskID, NULL) END,
                CASE WHEN @ArtifactID_Clear = 1 THEN NULL ELSE ISNULL(@ArtifactID, NULL) END,
                CASE WHEN @ParentCommentID_Clear = 1 THEN NULL ELSE ISNULL(@ParentCommentID, NULL) END,
                @PersonID,
                @CommentText,
                CASE WHEN @MentionedPersonIDs_Clear = 1 THEN NULL ELSE ISNULL(@MentionedPersonIDs, NULL) END,
                ISNULL(@IsResolved, 0)
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[Comment]
            (
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [TaskID],
                [ArtifactID],
                [ParentCommentID],
                [PersonID],
                [CommentText],
                [MentionedPersonIDs],
                [IsResolved]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @CommitteeID,
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                CASE WHEN @TaskID_Clear = 1 THEN NULL ELSE ISNULL(@TaskID, NULL) END,
                CASE WHEN @ArtifactID_Clear = 1 THEN NULL ELSE ISNULL(@ArtifactID, NULL) END,
                CASE WHEN @ParentCommentID_Clear = 1 THEN NULL ELSE ISNULL(@ParentCommentID, NULL) END,
                @PersonID,
                @CommentText,
                CASE WHEN @MentionedPersonIDs_Clear = 1 THEN NULL ELSE ISNULL(@MentionedPersonIDs, NULL) END,
                ISNULL(@IsResolved, 0)
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwComments] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateComment] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Comments */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateComment] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Comments */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: spUpdateComment
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Comment
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateComment]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateComment];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateComment]
    @ID uniqueidentifier,
    @CommitteeID uniqueidentifier = NULL,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @TaskID_Clear bit = 0,
    @TaskID uniqueidentifier = NULL,
    @ArtifactID_Clear bit = 0,
    @ArtifactID uniqueidentifier = NULL,
    @ParentCommentID_Clear bit = 0,
    @ParentCommentID uniqueidentifier = NULL,
    @PersonID uniqueidentifier = NULL,
    @CommentText nvarchar(MAX) = NULL,
    @MentionedPersonIDs_Clear bit = 0,
    @MentionedPersonIDs nvarchar(MAX) = NULL,
    @IsResolved bit = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Comment]
    SET
        [CommitteeID] = ISNULL(@CommitteeID, [CommitteeID]),
        [MeetingID] = CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, [MeetingID]) END,
        [AgendaItemID] = CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, [AgendaItemID]) END,
        [TaskID] = CASE WHEN @TaskID_Clear = 1 THEN NULL ELSE ISNULL(@TaskID, [TaskID]) END,
        [ArtifactID] = CASE WHEN @ArtifactID_Clear = 1 THEN NULL ELSE ISNULL(@ArtifactID, [ArtifactID]) END,
        [ParentCommentID] = CASE WHEN @ParentCommentID_Clear = 1 THEN NULL ELSE ISNULL(@ParentCommentID, [ParentCommentID]) END,
        [PersonID] = ISNULL(@PersonID, [PersonID]),
        [CommentText] = ISNULL(@CommentText, [CommentText]),
        [MentionedPersonIDs] = CASE WHEN @MentionedPersonIDs_Clear = 1 THEN NULL ELSE ISNULL(@MentionedPersonIDs, [MentionedPersonIDs]) END,
        [IsResolved] = ISNULL(@IsResolved, [IsResolved])
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwComments] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwComments]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateComment] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Comment table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateComment]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateComment];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateComment
ON [${flyway:defaultSchema}].[Comment]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Comment]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}].[Comment] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Comments */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateComment] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Comments */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: spDeleteComment
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Comment
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteComment]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteComment];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteComment]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Comment]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteComment] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Comments */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteComment] TO [cdp_Developer], [cdp_Integration];

/* Base View SQL for Committees: Memberships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Memberships
-- Item: vwMemberships
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Memberships
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Membership
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwMemberships]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwMemberships];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwMemberships]
AS
SELECT
    m.*,
    mjBizAppsCommonPerson_PersonID.[DisplayName] AS [Person],
    mjBizAppsCommitteesRole_RoleID.[Name] AS [Role],
    mjBizAppsCommitteesTerm_TermID.[Name] AS [Term]
FROM
    [${flyway:defaultSchema}].[Membership] AS m
INNER JOIN
    [${mjBACSchema}].[Person] AS mjBizAppsCommonPerson_PersonID
  ON
    [m].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
INNER JOIN
    [${flyway:defaultSchema}].[Role] AS mjBizAppsCommitteesRole_RoleID
  ON
    [m].[RoleID] = mjBizAppsCommitteesRole_RoleID.[ID]
INNER JOIN
    [${flyway:defaultSchema}].[Term] AS mjBizAppsCommitteesTerm_TermID
  ON
    [m].[TermID] = mjBizAppsCommitteesTerm_TermID.[ID]
GO
GRANT SELECT ON [${flyway:defaultSchema}].[vwMemberships] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Memberships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Memberships
-- Item: Permissions for vwMemberships
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}].[vwMemberships] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Memberships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Memberships
-- Item: spCreateMembership
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Membership
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateMembership]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateMembership];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateMembership]
    @ID uniqueidentifier = NULL,
    @PersonID uniqueidentifier,
    @RoleID uniqueidentifier,
    @TermID uniqueidentifier,
    @StartDate date,
    @EndDate_Clear bit = 0,
    @EndDate date = NULL,
    @Status nvarchar(50) = NULL,
    @EndReason_Clear bit = 0,
    @EndReason nvarchar(100) = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[Membership]
            (
                [ID],
                [PersonID],
                [RoleID],
                [TermID],
                [StartDate],
                [EndDate],
                [Status],
                [EndReason],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @PersonID,
                @RoleID,
                @TermID,
                @StartDate,
                CASE WHEN @EndDate_Clear = 1 THEN NULL ELSE ISNULL(@EndDate, NULL) END,
                ISNULL(@Status, 'Active'),
                CASE WHEN @EndReason_Clear = 1 THEN NULL ELSE ISNULL(@EndReason, NULL) END,
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[Membership]
            (
                [PersonID],
                [RoleID],
                [TermID],
                [StartDate],
                [EndDate],
                [Status],
                [EndReason],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @PersonID,
                @RoleID,
                @TermID,
                @StartDate,
                CASE WHEN @EndDate_Clear = 1 THEN NULL ELSE ISNULL(@EndDate, NULL) END,
                ISNULL(@Status, 'Active'),
                CASE WHEN @EndReason_Clear = 1 THEN NULL ELSE ISNULL(@EndReason, NULL) END,
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwMemberships] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMembership] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Memberships */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMembership] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Memberships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Memberships
-- Item: spUpdateMembership
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Membership
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateMembership]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateMembership];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateMembership]
    @ID uniqueidentifier,
    @PersonID uniqueidentifier = NULL,
    @RoleID uniqueidentifier = NULL,
    @TermID uniqueidentifier = NULL,
    @StartDate date = NULL,
    @EndDate_Clear bit = 0,
    @EndDate date = NULL,
    @Status nvarchar(50) = NULL,
    @EndReason_Clear bit = 0,
    @EndReason nvarchar(100) = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Membership]
    SET
        [PersonID] = ISNULL(@PersonID, [PersonID]),
        [RoleID] = ISNULL(@RoleID, [RoleID]),
        [TermID] = ISNULL(@TermID, [TermID]),
        [StartDate] = ISNULL(@StartDate, [StartDate]),
        [EndDate] = CASE WHEN @EndDate_Clear = 1 THEN NULL ELSE ISNULL(@EndDate, [EndDate]) END,
        [Status] = ISNULL(@Status, [Status]),
        [EndReason] = CASE WHEN @EndReason_Clear = 1 THEN NULL ELSE ISNULL(@EndReason, [EndReason]) END,
        [Notes] = CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, [Notes]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwMemberships] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwMemberships]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMembership] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Membership table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateMembership]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateMembership];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateMembership
ON [${flyway:defaultSchema}].[Membership]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Membership]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}].[Membership] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Memberships */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMembership] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Memberships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Memberships
-- Item: spDeleteMembership
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Membership
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteMembership]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteMembership];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteMembership]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Membership]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMembership] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Memberships */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMembership] TO [cdp_Developer], [cdp_Integration];

/* Index for Foreign Keys for Motion */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Motions
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key MeetingID in table Motion
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Motion_MeetingID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Motion]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Motion_MeetingID ON [${flyway:defaultSchema}].[Motion] ([MeetingID]);

-- Index for foreign key AgendaItemID in table Motion
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Motion_AgendaItemID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Motion]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Motion_AgendaItemID ON [${flyway:defaultSchema}].[Motion] ([AgendaItemID]);

-- Index for foreign key MovedByMembershipID in table Motion
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Motion_MovedByMembershipID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Motion]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Motion_MovedByMembershipID ON [${flyway:defaultSchema}].[Motion] ([MovedByMembershipID]);

-- Index for foreign key SecondedByMembershipID in table Motion
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Motion_SecondedByMembershipID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Motion]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Motion_SecondedByMembershipID ON [${flyway:defaultSchema}].[Motion] ([SecondedByMembershipID]);

/* Index for Foreign Keys for Role */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Roles
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------;

/* Index for Foreign Keys for Term */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Terms
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key CommitteeID in table Term
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Term_CommitteeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Term]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Term_CommitteeID ON [${flyway:defaultSchema}].[Term] ([CommitteeID]);

/* SQL text to update entity field related entity name field map for entity field ID C5A5A349-5501-4316-8D6F-8380D68AE0D3 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='C5A5A349-5501-4316-8D6F-8380D68AE0D3', @RelatedEntityNameFieldMap='Committee';

/* Index for Foreign Keys for Type */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Types
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------;

/* Index for Foreign Keys for VideoProvider */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Video Providers
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key CredentialID in table VideoProvider
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_VideoProvider_CredentialID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[VideoProvider]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_VideoProvider_CredentialID ON [${flyway:defaultSchema}].[VideoProvider] ([CredentialID]);

/* SQL text to update entity field related entity name field map for entity field ID BC5B9497-6CF7-4079-A9E1-F63CF2B370CF */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='BC5B9497-6CF7-4079-A9E1-F63CF2B370CF', @RelatedEntityNameFieldMap='Credential';

/* Base View SQL for Committees: Motions */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Motions
-- Item: vwMotions
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Motions
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Motion
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwMotions]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwMotions];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwMotions]
AS
SELECT
    m.*
FROM
    [${flyway:defaultSchema}].[Motion] AS m
GO
GRANT SELECT ON [${flyway:defaultSchema}].[vwMotions] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Motions */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Motions
-- Item: Permissions for vwMotions
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}].[vwMotions] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Motions */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Motions
-- Item: spCreateMotion
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Motion
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateMotion]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateMotion];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateMotion]
    @ID uniqueidentifier = NULL,
    @MeetingID uniqueidentifier,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @Sequence int = NULL,
    @Title nvarchar(255),
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @MovedByMembershipID_Clear bit = 0,
    @MovedByMembershipID uniqueidentifier = NULL,
    @SecondedByMembershipID_Clear bit = 0,
    @SecondedByMembershipID uniqueidentifier = NULL,
    @Result nvarchar(50) = NULL,
    @ResultSummary_Clear bit = 0,
    @ResultSummary nvarchar(255) = NULL,
    @YesCount_Clear bit = 0,
    @YesCount int = NULL,
    @NoCount_Clear bit = 0,
    @NoCount int = NULL,
    @AbstainCount_Clear bit = 0,
    @AbstainCount int = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[Motion]
            (
                [ID],
                [MeetingID],
                [AgendaItemID],
                [Sequence],
                [Title],
                [Description],
                [MovedByMembershipID],
                [SecondedByMembershipID],
                [Result],
                [ResultSummary],
                [YesCount],
                [NoCount],
                [AbstainCount],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @MeetingID,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                ISNULL(@Sequence, 1),
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                CASE WHEN @MovedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@MovedByMembershipID, NULL) END,
                CASE WHEN @SecondedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@SecondedByMembershipID, NULL) END,
                ISNULL(@Result, 'Pending'),
                CASE WHEN @ResultSummary_Clear = 1 THEN NULL ELSE ISNULL(@ResultSummary, NULL) END,
                CASE WHEN @YesCount_Clear = 1 THEN NULL ELSE ISNULL(@YesCount, NULL) END,
                CASE WHEN @NoCount_Clear = 1 THEN NULL ELSE ISNULL(@NoCount, NULL) END,
                CASE WHEN @AbstainCount_Clear = 1 THEN NULL ELSE ISNULL(@AbstainCount, NULL) END,
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[Motion]
            (
                [MeetingID],
                [AgendaItemID],
                [Sequence],
                [Title],
                [Description],
                [MovedByMembershipID],
                [SecondedByMembershipID],
                [Result],
                [ResultSummary],
                [YesCount],
                [NoCount],
                [AbstainCount],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @MeetingID,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                ISNULL(@Sequence, 1),
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                CASE WHEN @MovedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@MovedByMembershipID, NULL) END,
                CASE WHEN @SecondedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@SecondedByMembershipID, NULL) END,
                ISNULL(@Result, 'Pending'),
                CASE WHEN @ResultSummary_Clear = 1 THEN NULL ELSE ISNULL(@ResultSummary, NULL) END,
                CASE WHEN @YesCount_Clear = 1 THEN NULL ELSE ISNULL(@YesCount, NULL) END,
                CASE WHEN @NoCount_Clear = 1 THEN NULL ELSE ISNULL(@NoCount, NULL) END,
                CASE WHEN @AbstainCount_Clear = 1 THEN NULL ELSE ISNULL(@AbstainCount, NULL) END,
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwMotions] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMotion] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Motions */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMotion] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Motions */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Motions
-- Item: spUpdateMotion
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Motion
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateMotion]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateMotion];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateMotion]
    @ID uniqueidentifier,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @Sequence int = NULL,
    @Title nvarchar(255) = NULL,
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @MovedByMembershipID_Clear bit = 0,
    @MovedByMembershipID uniqueidentifier = NULL,
    @SecondedByMembershipID_Clear bit = 0,
    @SecondedByMembershipID uniqueidentifier = NULL,
    @Result nvarchar(50) = NULL,
    @ResultSummary_Clear bit = 0,
    @ResultSummary nvarchar(255) = NULL,
    @YesCount_Clear bit = 0,
    @YesCount int = NULL,
    @NoCount_Clear bit = 0,
    @NoCount int = NULL,
    @AbstainCount_Clear bit = 0,
    @AbstainCount int = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Motion]
    SET
        [MeetingID] = ISNULL(@MeetingID, [MeetingID]),
        [AgendaItemID] = CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, [AgendaItemID]) END,
        [Sequence] = ISNULL(@Sequence, [Sequence]),
        [Title] = ISNULL(@Title, [Title]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [MovedByMembershipID] = CASE WHEN @MovedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@MovedByMembershipID, [MovedByMembershipID]) END,
        [SecondedByMembershipID] = CASE WHEN @SecondedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@SecondedByMembershipID, [SecondedByMembershipID]) END,
        [Result] = ISNULL(@Result, [Result]),
        [ResultSummary] = CASE WHEN @ResultSummary_Clear = 1 THEN NULL ELSE ISNULL(@ResultSummary, [ResultSummary]) END,
        [YesCount] = CASE WHEN @YesCount_Clear = 1 THEN NULL ELSE ISNULL(@YesCount, [YesCount]) END,
        [NoCount] = CASE WHEN @NoCount_Clear = 1 THEN NULL ELSE ISNULL(@NoCount, [NoCount]) END,
        [AbstainCount] = CASE WHEN @AbstainCount_Clear = 1 THEN NULL ELSE ISNULL(@AbstainCount, [AbstainCount]) END,
        [Notes] = CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, [Notes]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwMotions] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwMotions]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMotion] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Motion table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateMotion]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateMotion];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateMotion
ON [${flyway:defaultSchema}].[Motion]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Motion]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}].[Motion] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Motions */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMotion] TO [cdp_Developer], [cdp_Integration];

/* Base View SQL for Committees: Roles */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Roles
-- Item: vwRoles
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Roles
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Role
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwRoles]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwRoles];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwRoles]
AS
SELECT
    r.*
FROM
    [${flyway:defaultSchema}].[Role] AS r
GO
GRANT SELECT ON [${flyway:defaultSchema}].[vwRoles] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Roles */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Roles
-- Item: Permissions for vwRoles
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}].[vwRoles] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Roles */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Roles
-- Item: spCreateRole
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Role
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateRole]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateRole];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateRole]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(100),
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @IsOfficer bit = NULL,
    @IsVotingRole bit = NULL,
    @DefaultPermissionsJSON_Clear bit = 0,
    @DefaultPermissionsJSON nvarchar(MAX) = NULL,
    @Sequence int = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[Role]
            (
                [ID],
                [Name],
                [Description],
                [IsOfficer],
                [IsVotingRole],
                [DefaultPermissionsJSON],
                [Sequence]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @Name,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                ISNULL(@IsOfficer, 0),
                ISNULL(@IsVotingRole, 1),
                CASE WHEN @DefaultPermissionsJSON_Clear = 1 THEN NULL ELSE ISNULL(@DefaultPermissionsJSON, NULL) END,
                ISNULL(@Sequence, 100)
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[Role]
            (
                [Name],
                [Description],
                [IsOfficer],
                [IsVotingRole],
                [DefaultPermissionsJSON],
                [Sequence]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @Name,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                ISNULL(@IsOfficer, 0),
                ISNULL(@IsVotingRole, 1),
                CASE WHEN @DefaultPermissionsJSON_Clear = 1 THEN NULL ELSE ISNULL(@DefaultPermissionsJSON, NULL) END,
                ISNULL(@Sequence, 100)
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwRoles] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateRole] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Roles */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateRole] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Roles */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Roles
-- Item: spUpdateRole
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Role
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateRole]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateRole];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateRole]
    @ID uniqueidentifier,
    @Name nvarchar(100) = NULL,
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @IsOfficer bit = NULL,
    @IsVotingRole bit = NULL,
    @DefaultPermissionsJSON_Clear bit = 0,
    @DefaultPermissionsJSON nvarchar(MAX) = NULL,
    @Sequence int = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Role]
    SET
        [Name] = ISNULL(@Name, [Name]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [IsOfficer] = ISNULL(@IsOfficer, [IsOfficer]),
        [IsVotingRole] = ISNULL(@IsVotingRole, [IsVotingRole]),
        [DefaultPermissionsJSON] = CASE WHEN @DefaultPermissionsJSON_Clear = 1 THEN NULL ELSE ISNULL(@DefaultPermissionsJSON, [DefaultPermissionsJSON]) END,
        [Sequence] = ISNULL(@Sequence, [Sequence])
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwRoles] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwRoles]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateRole] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Role table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateRole]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateRole];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateRole
ON [${flyway:defaultSchema}].[Role]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Role]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}].[Role] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Roles */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateRole] TO [cdp_Developer], [cdp_Integration];

/* Base View SQL for Committees: Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Types
-- Item: vwTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Types
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Type
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwTypes]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwTypes];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwTypes]
AS
SELECT
    t.*
FROM
    [${flyway:defaultSchema}].[Type] AS t
GO
GRANT SELECT ON [${flyway:defaultSchema}].[vwTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Types
-- Item: Permissions for vwTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}].[vwTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Types
-- Item: spCreateType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Type
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateType]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(100),
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @IsStandards bit = NULL,
    @DefaultTermMonths_Clear bit = 0,
    @DefaultTermMonths int = NULL,
    @IconClass_Clear bit = 0,
    @IconClass nvarchar(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[Type]
            (
                [ID],
                [Name],
                [Description],
                [IsStandards],
                [DefaultTermMonths],
                [IconClass]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @Name,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                ISNULL(@IsStandards, 0),
                CASE WHEN @DefaultTermMonths_Clear = 1 THEN NULL ELSE ISNULL(@DefaultTermMonths, NULL) END,
                CASE WHEN @IconClass_Clear = 1 THEN NULL ELSE ISNULL(@IconClass, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[Type]
            (
                [Name],
                [Description],
                [IsStandards],
                [DefaultTermMonths],
                [IconClass]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @Name,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                ISNULL(@IsStandards, 0),
                CASE WHEN @DefaultTermMonths_Clear = 1 THEN NULL ELSE ISNULL(@DefaultTermMonths, NULL) END,
                CASE WHEN @IconClass_Clear = 1 THEN NULL ELSE ISNULL(@IconClass, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwTypes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateType] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Types */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateType] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Types
-- Item: spUpdateType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Type
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateType]
    @ID uniqueidentifier,
    @Name nvarchar(100) = NULL,
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @IsStandards bit = NULL,
    @DefaultTermMonths_Clear bit = 0,
    @DefaultTermMonths int = NULL,
    @IconClass_Clear bit = 0,
    @IconClass nvarchar(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Type]
    SET
        [Name] = ISNULL(@Name, [Name]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [IsStandards] = ISNULL(@IsStandards, [IsStandards]),
        [DefaultTermMonths] = CASE WHEN @DefaultTermMonths_Clear = 1 THEN NULL ELSE ISNULL(@DefaultTermMonths, [DefaultTermMonths]) END,
        [IconClass] = CASE WHEN @IconClass_Clear = 1 THEN NULL ELSE ISNULL(@IconClass, [IconClass]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwTypes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwTypes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateType] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Type table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateType]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateType];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateType
ON [${flyway:defaultSchema}].[Type]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Type]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}].[Type] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Types */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateType] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Motions */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Motions
-- Item: spDeleteMotion
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Motion
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteMotion]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteMotion];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteMotion]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Motion]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMotion] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Motions */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMotion] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Roles */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Roles
-- Item: spDeleteRole
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Role
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteRole]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteRole];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteRole]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Role]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteRole] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Roles */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteRole] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Types
-- Item: spDeleteType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Type
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteType]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Type]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteType] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Types */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteType] TO [cdp_Developer], [cdp_Integration];

/* Base View SQL for Committees: Video Providers */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Video Providers
-- Item: vwVideoProviders
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Video Providers
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  VideoProvider
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwVideoProviders]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwVideoProviders];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwVideoProviders]
AS
SELECT
    v.*,
    MJCredential_CredentialID.[Name] AS [Credential]
FROM
    [${flyway:defaultSchema}].[VideoProvider] AS v
LEFT OUTER JOIN
    [${mjSchema}].[Credential] AS MJCredential_CredentialID
  ON
    [v].[CredentialID] = MJCredential_CredentialID.[ID]
GO
GRANT SELECT ON [${flyway:defaultSchema}].[vwVideoProviders] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Video Providers */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Video Providers
-- Item: Permissions for vwVideoProviders
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}].[vwVideoProviders] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Video Providers */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Video Providers
-- Item: spCreateVideoProvider
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR VideoProvider
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateVideoProvider]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateVideoProvider];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateVideoProvider]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(100),
    @ServerDriverKey nvarchar(100),
    @IsActive bit = NULL,
    @IsDefault bit = NULL,
    @CredentialID_Clear bit = 0,
    @CredentialID uniqueidentifier = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[VideoProvider]
            (
                [ID],
                [Name],
                [ServerDriverKey],
                [IsActive],
                [IsDefault],
                [CredentialID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @Name,
                @ServerDriverKey,
                ISNULL(@IsActive, 1),
                ISNULL(@IsDefault, 0),
                CASE WHEN @CredentialID_Clear = 1 THEN NULL ELSE ISNULL(@CredentialID, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[VideoProvider]
            (
                [Name],
                [ServerDriverKey],
                [IsActive],
                [IsDefault],
                [CredentialID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @Name,
                @ServerDriverKey,
                ISNULL(@IsActive, 1),
                ISNULL(@IsDefault, 0),
                CASE WHEN @CredentialID_Clear = 1 THEN NULL ELSE ISNULL(@CredentialID, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwVideoProviders] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateVideoProvider] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Video Providers */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateVideoProvider] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Video Providers */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Video Providers
-- Item: spUpdateVideoProvider
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR VideoProvider
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateVideoProvider]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateVideoProvider];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateVideoProvider]
    @ID uniqueidentifier,
    @Name nvarchar(100) = NULL,
    @ServerDriverKey nvarchar(100) = NULL,
    @IsActive bit = NULL,
    @IsDefault bit = NULL,
    @CredentialID_Clear bit = 0,
    @CredentialID uniqueidentifier = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[VideoProvider]
    SET
        [Name] = ISNULL(@Name, [Name]),
        [ServerDriverKey] = ISNULL(@ServerDriverKey, [ServerDriverKey]),
        [IsActive] = ISNULL(@IsActive, [IsActive]),
        [IsDefault] = ISNULL(@IsDefault, [IsDefault]),
        [CredentialID] = CASE WHEN @CredentialID_Clear = 1 THEN NULL ELSE ISNULL(@CredentialID, [CredentialID]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwVideoProviders] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwVideoProviders]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateVideoProvider] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the VideoProvider table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateVideoProvider]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateVideoProvider];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateVideoProvider
ON [${flyway:defaultSchema}].[VideoProvider]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[VideoProvider]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}].[VideoProvider] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Video Providers */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateVideoProvider] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Video Providers */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Video Providers
-- Item: spDeleteVideoProvider
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR VideoProvider
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteVideoProvider]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteVideoProvider];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteVideoProvider]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[VideoProvider]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteVideoProvider] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Video Providers */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteVideoProvider] TO [cdp_Developer], [cdp_Integration];

/* Base View SQL for Committees: Terms */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Terms
-- Item: vwTerms
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Terms
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Term
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwTerms]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwTerms];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwTerms]
AS
SELECT
    t.*,
    mjBizAppsCommitteesCommittee_CommitteeID.[Name] AS [Committee]
FROM
    [${flyway:defaultSchema}].[Term] AS t
INNER JOIN
    [${flyway:defaultSchema}].[Committee] AS mjBizAppsCommitteesCommittee_CommitteeID
  ON
    [t].[CommitteeID] = mjBizAppsCommitteesCommittee_CommitteeID.[ID]
GO
GRANT SELECT ON [${flyway:defaultSchema}].[vwTerms] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Terms */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Terms
-- Item: Permissions for vwTerms
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}].[vwTerms] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Terms */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Terms
-- Item: spCreateTerm
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Term
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateTerm]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateTerm];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateTerm]
    @ID uniqueidentifier = NULL,
    @CommitteeID uniqueidentifier,
    @Name nvarchar(100),
    @StartDate date,
    @EndDate_Clear bit = 0,
    @EndDate date = NULL,
    @Status nvarchar(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[Term]
            (
                [ID],
                [CommitteeID],
                [Name],
                [StartDate],
                [EndDate],
                [Status]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @CommitteeID,
                @Name,
                @StartDate,
                CASE WHEN @EndDate_Clear = 1 THEN NULL ELSE ISNULL(@EndDate, NULL) END,
                ISNULL(@Status, 'Active')
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[Term]
            (
                [CommitteeID],
                [Name],
                [StartDate],
                [EndDate],
                [Status]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @CommitteeID,
                @Name,
                @StartDate,
                CASE WHEN @EndDate_Clear = 1 THEN NULL ELSE ISNULL(@EndDate, NULL) END,
                ISNULL(@Status, 'Active')
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwTerms] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateTerm] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Terms */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateTerm] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Terms */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Terms
-- Item: spUpdateTerm
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Term
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateTerm]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateTerm];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateTerm]
    @ID uniqueidentifier,
    @CommitteeID uniqueidentifier = NULL,
    @Name nvarchar(100) = NULL,
    @StartDate date = NULL,
    @EndDate_Clear bit = 0,
    @EndDate date = NULL,
    @Status nvarchar(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Term]
    SET
        [CommitteeID] = ISNULL(@CommitteeID, [CommitteeID]),
        [Name] = ISNULL(@Name, [Name]),
        [StartDate] = ISNULL(@StartDate, [StartDate]),
        [EndDate] = CASE WHEN @EndDate_Clear = 1 THEN NULL ELSE ISNULL(@EndDate, [EndDate]) END,
        [Status] = ISNULL(@Status, [Status])
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwTerms] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwTerms]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateTerm] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Term table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateTerm]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateTerm];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateTerm
ON [${flyway:defaultSchema}].[Term]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Term]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}].[Term] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Terms */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateTerm] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Terms */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Terms
-- Item: spDeleteTerm
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Term
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteTerm]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteTerm];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteTerm]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Term]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteTerm] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Terms */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteTerm] TO [cdp_Developer], [cdp_Integration];

/* Index for Foreign Keys for Vote */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Votes
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key MotionID in table Vote
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Vote_MotionID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Vote]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Vote_MotionID ON [${flyway:defaultSchema}].[Vote] ([MotionID]);

-- Index for foreign key MembershipID in table Vote
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Vote_MembershipID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Vote]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Vote_MembershipID ON [${flyway:defaultSchema}].[Vote] ([MembershipID]);

/* Base View SQL for Committees: Votes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Votes
-- Item: vwVotes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Votes
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Vote
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwVotes]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwVotes];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwVotes]
AS
SELECT
    v.*
FROM
    [${flyway:defaultSchema}].[Vote] AS v
GO
GRANT SELECT ON [${flyway:defaultSchema}].[vwVotes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Votes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Votes
-- Item: Permissions for vwVotes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}].[vwVotes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Votes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Votes
-- Item: spCreateVote
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Vote
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateVote]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateVote];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateVote]
    @ID uniqueidentifier = NULL,
    @MotionID uniqueidentifier,
    @MembershipID uniqueidentifier,
    @VoteValue nvarchar(20),
    @Notes_Clear bit = 0,
    @Notes nvarchar(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[Vote]
            (
                [ID],
                [MotionID],
                [MembershipID],
                [VoteValue],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @MotionID,
                @MembershipID,
                @VoteValue,
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[Vote]
            (
                [MotionID],
                [MembershipID],
                [VoteValue],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @MotionID,
                @MembershipID,
                @VoteValue,
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwVotes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateVote] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Votes */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateVote] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Votes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Votes
-- Item: spUpdateVote
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Vote
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateVote]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateVote];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateVote]
    @ID uniqueidentifier,
    @MotionID uniqueidentifier = NULL,
    @MembershipID uniqueidentifier = NULL,
    @VoteValue nvarchar(20) = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Vote]
    SET
        [MotionID] = ISNULL(@MotionID, [MotionID]),
        [MembershipID] = ISNULL(@MembershipID, [MembershipID]),
        [VoteValue] = ISNULL(@VoteValue, [VoteValue]),
        [Notes] = CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, [Notes]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwVotes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwVotes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateVote] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Vote table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateVote]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateVote];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateVote
ON [${flyway:defaultSchema}].[Vote]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Vote]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}].[Vote] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Votes */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateVote] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Votes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Votes
-- Item: spDeleteVote
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Vote
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteVote]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteVote];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteVote]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Vote]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteVote] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Votes */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteVote] TO [cdp_Developer], [cdp_Integration];

/* SQL text to delete unneeded entity fields (16 scoped entities) */
EXEC [${mjSchema}].[spDeleteUnneededEntityFields] @ExcludedSchemaNames='sys,staging,${mjSchema},${mjBACSchema},${mjSchema}_BizAppsTasks', @EntityIDs='A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A,AC908A89-225C-48CF-8852-40E612096D6C,BACA039C-8D23-4AEF-9A03-2E1AD2426EDF,6A65EEBD-8436-4FFC-9874-22D43FB91C37,D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E,49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78,04E6285A-7CC3-4BAA-9DFC-955385B3DAF2,0608D034-AE4B-484E-97AC-65C4C7640D36,79FED512-86CA-438C-9476-EFDB091C2E3C,870B0B2C-29A9-4B4F-96A8-68354D969562,543ADDC1-DEBC-4324-A23F-6A20D2924881,85D13F7F-F507-44B4-BFAC-A7DE94AA75BF,7684366D-44D2-4553-A1A9-A23AC11CB8FF,60F3019B-62E3-432F-A12C-F007CD73479C,47692233-8C18-4309-A466-6AD04CAC4F66,92933713-351A-4135-B55E-83B025C8A569';

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '9b455f76-be34-4baf-9e94-a1cba3c68c31' OR (EntityID = '6A65EEBD-8436-4FFC-9874-22D43FB91C37' AND Name = 'Committee')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '9b455f76-be34-4baf-9e94-a1cba3c68c31',
            '6A65EEBD-8436-4FFC-9874-22D43FB91C37', -- Entity: Committees: Comments
            100027,
            'Committee',
            'Committee',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            0,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '73fa7fbf-8e31-4684-88ab-525beced87d2' OR (EntityID = '6A65EEBD-8436-4FFC-9874-22D43FB91C37' AND Name = 'Task')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '73fa7fbf-8e31-4684-88ab-525beced87d2',
            '6A65EEBD-8436-4FFC-9874-22D43FB91C37', -- Entity: Committees: Comments
            100028,
            'Task',
            'Task',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            1,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '4c81ff2d-d549-4f57-94de-cd45f2adc313' OR (EntityID = '6A65EEBD-8436-4FFC-9874-22D43FB91C37' AND Name = 'Person')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '4c81ff2d-d549-4f57-94de-cd45f2adc313',
            '6A65EEBD-8436-4FFC-9874-22D43FB91C37', -- Entity: Committees: Comments
            100029,
            'Person',
            'Person',
            NULL,
            'nvarchar',
            402,
            0,
            0,
            0,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '4d8ce519-9896-49a5-8563-36a6ed34e58f' OR (EntityID = '6A65EEBD-8436-4FFC-9874-22D43FB91C37' AND Name = 'RootParentCommentID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '4d8ce519-9896-49a5-8563-36a6ed34e58f',
            '6A65EEBD-8436-4FFC-9874-22D43FB91C37', -- Entity: Committees: Comments
            100030,
            'RootParentCommentID',
            'Root Parent Comment ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'd255ff99-a489-4822-805d-e9ad138177aa' OR (EntityID = '870B0B2C-29A9-4B4F-96A8-68354D969562' AND Name = 'Credential')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'd255ff99-a489-4822-805d-e9ad138177aa',
            '870B0B2C-29A9-4B4F-96A8-68354D969562', -- Entity: Committees: Video Providers
            100017,
            'Credential',
            'Credential',
            NULL,
            'nvarchar',
            400,
            0,
            0,
            1,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '45f0d5f2-f527-40e8-8dee-ffa03c5651b0' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = 'Committee')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '45f0d5f2-f527-40e8-8dee-ffa03c5651b0',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100039,
            'Committee',
            'Committee',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            0,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '7dbf9576-6a75-4112-828b-bedf63be05c7' OR (EntityID = '543ADDC1-DEBC-4324-A23F-6A20D2924881' AND Name = 'VideoProvider_Virtual')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '7dbf9576-6a75-4112-828b-bedf63be05c7',
            '543ADDC1-DEBC-4324-A23F-6A20D2924881', -- Entity: Committees: Meetings
            100040,
            'VideoProvider_Virtual',
            'Video Provider Virtual',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            1,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '96dc308b-7174-410c-82e4-2a69d70e8ce7' OR (EntityID = '47692233-8C18-4309-A466-6AD04CAC4F66' AND Name = 'ExtendedEntity')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '96dc308b-7174-410c-82e4-2a69d70e8ce7',
            '47692233-8C18-4309-A466-6AD04CAC4F66', -- Entity: Committees: Artifact Types
            100015,
            'ExtendedEntity',
            'Extended Entity',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            1,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'ab7af39b-da02-44f7-8920-8f57da52d611' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = 'Committee')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'ab7af39b-da02-44f7-8920-8f57da52d611',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100033,
            'Committee',
            'Committee',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            1,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'adaaef9b-7ac4-4efa-a961-17ffd7c579f5' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = 'Task')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'adaaef9b-7ac4-4efa-a961-17ffd7c579f5',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100034,
            'Task',
            'Task',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            1,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'acae4afa-e166-4969-81fd-404edb94e9c9' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = 'ArtifactType')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'acae4afa-e166-4969-81fd-404edb94e9c9',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100035,
            'ArtifactType',
            'Artifact Type',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            0,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '99d5dbf9-1fd6-46e1-a336-46140301b86a' OR (EntityID = '92933713-351A-4135-B55E-83B025C8A569' AND Name = 'UploadedByPerson')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '99d5dbf9-1fd6-46e1-a336-46140301b86a',
            '92933713-351A-4135-B55E-83B025C8A569', -- Entity: Committees: Artifacts
            100036,
            'UploadedByPerson',
            'Uploaded By Person',
            NULL,
            'nvarchar',
            402,
            0,
            0,
            1,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '1725021b-ac12-4a64-babe-5206c298d8e6' OR (EntityID = '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2' AND Name = 'Committee')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '1725021b-ac12-4a64-babe-5206c298d8e6',
            '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2', -- Entity: Committees: Terms
            100017,
            'Committee',
            'Committee',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            0,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'dc2b2da6-4e91-402d-a0bf-6d9f689bc966' OR (EntityID = '7684366D-44D2-4553-A1A9-A23AC11CB8FF' AND Name = 'Person')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'dc2b2da6-4e91-402d-a0bf-6d9f689bc966',
            '7684366D-44D2-4553-A1A9-A23AC11CB8FF', -- Entity: Committees: Attendances
            100019,
            'Person',
            'Person',
            NULL,
            'nvarchar',
            402,
            0,
            0,
            0,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'f8d238e7-4e5c-4290-9964-587fa94a23f3' OR (EntityID = '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF' AND Name = 'PresenterPerson')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'f8d238e7-4e5c-4290-9964-587fa94a23f3',
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', -- Entity: Committees: Agenda Items
            100029,
            'PresenterPerson',
            'Presenter Person',
            NULL,
            'nvarchar',
            402,
            0,
            0,
            1,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '4e203c4e-2e9e-4e46-bc89-c57c2f4bad67' OR (EntityID = '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF' AND Name = 'RootParentAgendaItemID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '4e203c4e-2e9e-4e46-bc89-c57c2f4bad67',
            '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', -- Entity: Committees: Agenda Items
            100030,
            'RootParentAgendaItemID',
            'Root Parent Agenda Item ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'a6914849-1298-4c75-b47f-a209c77f632f' OR (EntityID = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78' AND Name = 'Type')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'a6914849-1298-4c75-b47f-a209c77f632f',
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', -- Entity: Committees: Committees
            100029,
            'Type',
            'Type',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            0,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '3aeded12-68f6-4db6-8cf0-23f88f35cf54' OR (EntityID = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78' AND Name = 'ParentCommittee')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '3aeded12-68f6-4db6-8cf0-23f88f35cf54',
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', -- Entity: Committees: Committees
            100030,
            'ParentCommittee',
            'Parent Committee',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            1,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '73e6d7dc-74f2-4bcc-9d81-32ae76eb988e' OR (EntityID = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78' AND Name = 'Organization')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '73e6d7dc-74f2-4bcc-9d81-32ae76eb988e',
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', -- Entity: Committees: Committees
            100031,
            'Organization',
            'Organization',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            1,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '98e2d638-ed56-4212-a9e2-019a95ef65e9' OR (EntityID = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78' AND Name = 'RootParentCommitteeID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '98e2d638-ed56-4212-a9e2-019a95ef65e9',
            '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', -- Entity: Committees: Committees
            100032,
            'RootParentCommitteeID',
            'Root Parent Committee ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '8b0bfd64-adfc-4c2a-b409-adcb3d1582f7' OR (EntityID = '79FED512-86CA-438C-9476-EFDB091C2E3C' AND Name = 'Person')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '8b0bfd64-adfc-4c2a-b409-adcb3d1582f7',
            '79FED512-86CA-438C-9476-EFDB091C2E3C', -- Entity: Committees: Memberships
            100023,
            'Person',
            'Person',
            NULL,
            'nvarchar',
            402,
            0,
            0,
            0,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '3e7bbd00-d7a3-4c46-924f-9f26a33ec0b0' OR (EntityID = '79FED512-86CA-438C-9476-EFDB091C2E3C' AND Name = 'Role')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '3e7bbd00-d7a3-4c46-924f-9f26a33ec0b0',
            '79FED512-86CA-438C-9476-EFDB091C2E3C', -- Entity: Committees: Memberships
            100024,
            'Role',
            'Role',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            0,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '85fa28e3-4249-43d6-ab34-11bb861b5e33' OR (EntityID = '79FED512-86CA-438C-9476-EFDB091C2E3C' AND Name = 'Term')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '85fa28e3-4249-43d6-ab34-11bb861b5e33',
            '79FED512-86CA-438C-9476-EFDB091C2E3C', -- Entity: Committees: Memberships
            100025,
            'Term',
            'Term',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            0,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'f44ca8bf-26d9-43ec-868b-ee7635daebe2' OR (EntityID = '60F3019B-62E3-432F-A12C-F007CD73479C' AND Name = 'Committee')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'f44ca8bf-26d9-43ec-868b-ee7635daebe2',
            '60F3019B-62E3-432F-A12C-F007CD73479C', -- Entity: Committees: Action Items
            100031,
            'Committee',
            'Committee',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            0,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'c30dcc6b-d7c1-4dec-bc54-d7b25eba37e8' OR (EntityID = '60F3019B-62E3-432F-A12C-F007CD73479C' AND Name = 'AssignedToPerson')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'c30dcc6b-d7c1-4dec-bc54-d7b25eba37e8',
            '60F3019B-62E3-432F-A12C-F007CD73479C', -- Entity: Committees: Action Items
            100032,
            'AssignedToPerson',
            'Assigned To Person',
            NULL,
            'nvarchar',
            402,
            0,
            0,
            0,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '735286db-c0ad-460e-af02-40df8eeaf743' OR (EntityID = '60F3019B-62E3-432F-A12C-F007CD73479C' AND Name = 'AssignedByPerson')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '735286db-c0ad-460e-af02-40df8eeaf743',
            '60F3019B-62E3-432F-A12C-F007CD73479C', -- Entity: Committees: Action Items
            100033,
            'AssignedByPerson',
            'Assigned By Person',
            NULL,
            'nvarchar',
            402,
            0,
            0,
            1,
            NULL,
            0,
            0,
            1,
            0,
            NULL,
            NULL,
            0,
            0,
            0,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

/* SQL text to update existing entity fields from schema (16 scoped entities) */
EXEC [${mjSchema}].[spUpdateExistingEntityFieldsFromSchema] @ExcludedSchemaNames='sys,staging,${mjSchema},${mjBACSchema},${mjSchema}_BizAppsTasks', @EntityIDs='A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A,AC908A89-225C-48CF-8852-40E612096D6C,BACA039C-8D23-4AEF-9A03-2E1AD2426EDF,6A65EEBD-8436-4FFC-9874-22D43FB91C37,D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E,49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78,04E6285A-7CC3-4BAA-9DFC-955385B3DAF2,0608D034-AE4B-484E-97AC-65C4C7640D36,79FED512-86CA-438C-9476-EFDB091C2E3C,870B0B2C-29A9-4B4F-96A8-68354D969562,543ADDC1-DEBC-4324-A23F-6A20D2924881,85D13F7F-F507-44B4-BFAC-A7DE94AA75BF,7684366D-44D2-4553-A1A9-A23AC11CB8FF,60F3019B-62E3-432F-A12C-F007CD73479C,47692233-8C18-4309-A466-6AD04CAC4F66,92933713-351A-4135-B55E-83B025C8A569';

/* SQL text to set default column width where needed */
EXEC [${mjSchema}].[spSetDefaultColumnWidthWhereNeeded] @ExcludedSchemaNames='sys,staging,${mjSchema},${mjBACSchema},${mjSchema}_BizAppsTasks';

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '63F2F542-0BC7-4D7B-99A3-FC82D2F3D1EB'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'A821C5C7-975C-4917-9A59-EFD719545090'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '63F2F542-0BC7-4D7B-99A3-FC82D2F3D1EB'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'A821C5C7-975C-4917-9A59-EFD719545090'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '15E25D52-6FE6-4D16-995B-4EBD7A33664E'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'A821C5C7-975C-4917-9A59-EFD719545090'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '4C3DB2C0-9702-4B7B-8A7F-8F5326798758'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '2638961A-F4C5-4C49-B988-BFE3278564DB'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '1E2CD4E6-DB2C-4199-8457-945661CEF2FE'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'DC2B2DA6-4E91-402D-A0BF-6D9F689BC966'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '4C3DB2C0-9702-4B7B-8A7F-8F5326798758'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'E3310356-1D40-4BCB-840D-87B55FC45A23'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'DC2B2DA6-4E91-402D-A0BF-6D9F689BC966'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'DC2B2DA6-4E91-402D-A0BF-6D9F689BC966'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '4C3DB2C0-9702-4B7B-8A7F-8F5326798758'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET IsNameField = 1
               WHERE ID = '3C23769A-DA86-404E-9E37-975E98EBF073'
               AND AutoUpdateIsNameField = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '3C23769A-DA86-404E-9E37-975E98EBF073'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '66556560-5FB1-4876-B152-8972776F9042'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '25EBA2BE-3D67-4C3D-82BA-4131F30C0C4A'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '24FF726C-18A7-4369-97E9-9D19F3C08DD7'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'F44CA8BF-26D9-43EC-868B-EE7635DAEBE2'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'C30DCC6B-D7C1-4DEC-BC54-D7B25EBA37E8'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '3C23769A-DA86-404E-9E37-975E98EBF073'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '25EBA2BE-3D67-4C3D-82BA-4131F30C0C4A'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '24FF726C-18A7-4369-97E9-9D19F3C08DD7'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'F44CA8BF-26D9-43EC-868B-EE7635DAEBE2'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'C30DCC6B-D7C1-4DEC-BC54-D7B25EBA37E8'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '735286DB-C0AD-460E-AF02-40DF8EEAF743'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '3C23769A-DA86-404E-9E37-975E98EBF073'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'F44CA8BF-26D9-43EC-868B-EE7635DAEBE2'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'C30DCC6B-D7C1-4DEC-BC54-D7B25EBA37E8'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '735286DB-C0AD-460E-AF02-40DF8EEAF743'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '25EBA2BE-3D67-4C3D-82BA-4131F30C0C4A'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '24FF726C-18A7-4369-97E9-9D19F3C08DD7'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET IsNameField = 1
               WHERE ID = '9CF904DE-D835-4663-8091-ADA2D85BB439'
               AND AutoUpdateIsNameField = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'AA486EE4-8B3B-475E-8E19-B1DC60730B45'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '9CF904DE-D835-4663-8091-ADA2D85BB439'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '58A4F1AD-C397-4EB2-9DEC-0DA1F429485B'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'B139C1A4-9D27-4B30-90D0-611AF18FFF59'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '901AC105-906C-4A00-B54E-101140B50C0F'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '9CF904DE-D835-4663-8091-ADA2D85BB439'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'B139C1A4-9D27-4B30-90D0-611AF18FFF59'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '901AC105-906C-4A00-B54E-101140B50C0F'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'F8D238E7-4E5C-4290-9964-587FA94A23F3'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '9CF904DE-D835-4663-8091-ADA2D85BB439'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'B139C1A4-9D27-4B30-90D0-611AF18FFF59'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '901AC105-906C-4A00-B54E-101140B50C0F'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'F8D238E7-4E5C-4290-9964-587FA94A23F3'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET IsNameField = 1
               WHERE ID = 'FCEAFFD3-DFF9-4B44-85AD-EBD7CC20C7A5'
               AND AutoUpdateIsNameField = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'FCEAFFD3-DFF9-4B44-85AD-EBD7CC20C7A5'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '67CE1FD6-7483-463B-84CE-249070F9C93B'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'A4005AAC-0B28-430B-A00F-7E971D81CFF7'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'ACAE4AFA-E166-4969-81FD-404EDB94E9C9'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '99D5DBF9-1FD6-46E1-A336-46140301B86A'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'FCEAFFD3-DFF9-4B44-85AD-EBD7CC20C7A5'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '67CE1FD6-7483-463B-84CE-249070F9C93B'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'C9B656EA-E472-4FC3-8F41-9E2F73A07CAD'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '943799A2-EDC9-43FB-AD0F-27FBA8849C28'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '99D5DBF9-1FD6-46E1-A336-46140301B86A'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'FCEAFFD3-DFF9-4B44-85AD-EBD7CC20C7A5'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '67CE1FD6-7483-463B-84CE-249070F9C93B'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '99D5DBF9-1FD6-46E1-A336-46140301B86A'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set categories for 8 fields */

-- UPDATE Entity Field Category Info Committees: Artifact Types.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '36463B65-6FCA-446F-AFDE-ECC07790D1C7' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifact Types.Name 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Artifact Definition',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '15E25D52-6FE6-4D16-995B-4EBD7A33664E' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifact Types.Description 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Artifact Definition',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '63F2F542-0BC7-4D7B-99A3-FC82D2F3D1EB' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifact Types.ExtendedEntityID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Extended Configuration',
   GeneratedFormSection = 'Category',
   DisplayName = 'Extended Entity',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9E2B6B03-0583-41B1-A8C8-D93E843A0B7D' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifact Types.ExtendedEntity 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Extended Configuration',
   GeneratedFormSection = 'Category',
   DisplayName = 'Extended Entity Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '96DC308B-7174-410C-82E4-2A69D70E8CE7' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifact Types.IconClass 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Visual Appearance',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A821C5C7-975C-4917-9A59-EFD719545090' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifact Types.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '17F6BE54-6E73-4EFE-AF93-C5A86A3BDAD8' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifact Types.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1274180B-2C9C-4E1B-9002-1CBA51416E97' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-folder-open */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-folder-open', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '47692233-8C18-4309-A466-6AD04CAC4F66';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('c959d6b8-fd80-4000-91e0-31abfd36a7bc', '47692233-8C18-4309-A466-6AD04CAC4F66', 'FieldCategoryInfo', '{"Artifact Definition":{"icon":"fa fa-file-alt","description":"Core descriptive fields for the committee artifact type"},"Extended Configuration":{"icon":"fa fa-sliders-h","description":"Settings that allow linking to an optional extended entity for custom fields"},"Visual Appearance":{"icon":"fa fa-palette","description":"Icon and styling information for visual representation"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit and technical fields"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('762304fe-b235-4510-baf9-571accda6005', '47692233-8C18-4309-A466-6AD04CAC4F66', 'FieldCategoryIcons', '{"Artifact Definition":"fa fa-file-alt","Extended Configuration":"fa fa-sliders-h","Visual Appearance":"fa fa-palette","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=false for NEW entity (category: reference, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 0, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '47692233-8C18-4309-A466-6AD04CAC4F66';

/* Set categories for 10 fields */

-- UPDATE Entity Field Category Info Committees: Attendances.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '486FF82C-33C2-469C-B85E-3F47EA36D5E3' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Attendances.MeetingID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Meeting Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5244D975-F60E-49C2-840F-C8C056907B8F' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Attendances.PersonID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Participant Information',
   GeneratedFormSection = 'Category',
   DisplayName = 'Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'DD046D10-DB26-4D33-8AC8-4B883FB10F8A' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Attendances.AttendanceStatus 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Attendance Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4C3DB2C0-9702-4B7B-8A7F-8F5326798758' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Attendances.JoinedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Attendance Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2638961A-F4C5-4C49-B988-BFE3278564DB' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Attendances.LeftAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Attendance Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1E2CD4E6-DB2C-4199-8457-945661CEF2FE' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Attendances.Notes 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Attendance Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E3310356-1D40-4BCB-840D-87B55FC45A23' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Attendances.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A0A50EA6-D1BC-4B1C-A23B-5905A7CDBE60' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Attendances.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0E8651C9-4389-489D-B912-3CEB18B7DE6E' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Attendances.Person 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Participant Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'DC2B2DA6-4E91-402D-A0BF-6D9F689BC966' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-users */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-users', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '7684366D-44D2-4553-A1A9-A23AC11CB8FF';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('a3a16d90-26d9-44b8-b51a-2a0091210f85', '7684366D-44D2-4553-A1A9-A23AC11CB8FF', 'FieldCategoryInfo', '{"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"},"Meeting Details":{"icon":"fa fa-calendar-alt","description":"Core information identifying the meeting associated with the attendance record"},"Participant Information":{"icon":"fa fa-user","description":"Details about the person or committee member attending the meeting"},"Attendance Details":{"icon":"fa fa-check-circle","description":"Status, notes and other specifics about the attendance"},"Attendance Timeline":{"icon":"fa fa-clock","description":"Timestamps indicating when the participant joined and left the meeting"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('4ab0095b-1d28-4885-9e19-c5e557fbed7e', '7684366D-44D2-4553-A1A9-A23AC11CB8FF', 'FieldCategoryIcons', '{"System Metadata":"fa fa-cog","Meeting Details":"fa fa-calendar-alt","Participant Information":"fa fa-user","Attendance Details":"fa fa-check-circle","Attendance Timeline":"fa fa-clock"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=true for NEW entity (category: primary, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 1, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '7684366D-44D2-4553-A1A9-A23AC11CB8FF';

/* Set categories for 16 fields */

-- UPDATE Entity Field Category Info Committees: Agenda Items.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FCB4465D-ACE3-417A-A462-E7DBCC028F38' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.MeetingID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Meeting Context',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '78FAF628-4A9A-4764-8DC3-DDFEA1081CAE' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.ParentAgendaItemID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Hierarchy',
   GeneratedFormSection = 'Category',
   DisplayName = 'Parent Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9CCE488C-02CE-4585-95D1-B1D45AA32B0C' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.RootParentAgendaItemID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Hierarchy',
   GeneratedFormSection = 'Category',
   DisplayName = 'Root Parent Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4E203C4E-2E9E-4E46-BC89-C57C2F4BAD67' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.Sequence 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Agenda Structure',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AA486EE4-8B3B-475E-8E19-B1DC60730B45' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.Title 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Agenda Content',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9CF904DE-D835-4663-8091-ADA2D85BB439' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.Description 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Agenda Content',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'EF6BF9F0-D97C-4526-A485-91CA78F8154D' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.ItemType 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Agenda Content',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B139C1A4-9D27-4B30-90D0-611AF18FFF59' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.Status 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Agenda Content',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '901AC105-906C-4A00-B54E-101140B50C0F' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.PresenterPersonID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Presenter Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Presenter',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F22704C8-75F3-4A4D-834F-C279E5966D65' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.PresenterPerson 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Presenter Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Presenter Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F8D238E7-4E5C-4290-9964-587FA94A23F3' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.DurationMinutes 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Timing',
   GeneratedFormSection = 'Category',
   DisplayName = 'Duration (Minutes)',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '58A4F1AD-C397-4EB2-9DEC-0DA1F429485B' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.RelatedDocumentURL 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Resources',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = 'E53DC59B-72E9-403F-8DBB-53D85D7366FB' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.Notes 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Resources',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '23367B7E-5E21-441E-9EB3-D4C639DD54DF' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5D0C2498-4B22-4721-839B-34E3798D2090' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9942DF7F-1325-46AC-BD1F-023C5FBFD47C' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-list-alt */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-list-alt', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('a786c11b-b7a6-4c0b-8e93-16465b6cb826', '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', 'FieldCategoryInfo', '{"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"},"Meeting Context":{"icon":"fa fa-calendar-alt","description":"Information linking the agenda item to its meeting"},"Hierarchy":{"icon":"fa fa-sitemap","description":"Fields that define parent‑child relationships among agenda items"},"Agenda Structure":{"icon":"fa fa-sort-numeric-up","description":"Ordering and sequencing of agenda items within a meeting"},"Agenda Content":{"icon":"fa fa-align-left","description":"Core descriptive fields of the agenda item such as title, type, and status"},"Presenter Details":{"icon":"fa fa-user","description":"Information about the person presenting or leading the agenda item"},"Timing":{"icon":"fa fa-clock","description":"Planned duration and timing related to the agenda item"},"Resources":{"icon":"fa fa-file","description":"Supporting documents, URLs, and free‑form notes for the agenda item"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('deab8646-4afd-4b3c-a0f2-fae576d4d6ce', '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF', 'FieldCategoryIcons', '{"System Metadata":"fa fa-cog","Meeting Context":"fa fa-calendar-alt","Hierarchy":"fa fa-sitemap","Agenda Structure":"fa fa-sort-numeric-up","Agenda Content":"fa fa-align-left","Presenter Details":"fa fa-user","Timing":"fa fa-clock","Resources":"fa fa-file"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=true for NEW entity (category: primary, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 1, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '85D13F7F-F507-44B4-BFAC-A7DE94AA75BF';

/* Set categories for 18 fields */

-- UPDATE Entity Field Category Info Committees: Action Items.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '079B8549-91F7-4F26-9D50-958858443921' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.CommitteeID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Context',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2E17E5B8-A39E-45F3-8BFB-369193F614F6' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.MeetingID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Context',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1F413A48-F658-450A-898E-1F6B3CDB1CD0' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.AgendaItemID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Context',
   GeneratedFormSection = 'Category',
   DisplayName = 'Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '61B73F48-B965-44E6-B6D1-0521C2A68AD1' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.Title 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Action Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3C23769A-DA86-404E-9E37-975E98EBF073' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.Description 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Action Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '98EA9EE1-9A69-4312-8536-D8CB43E55797' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.AssignedToPersonID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Assignment',
   GeneratedFormSection = 'Category',
   DisplayName = 'Assigned To',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4FB2FAA6-11BF-43E5-BA39-77D5629C06C9' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.AssignedByPersonID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Assignment',
   GeneratedFormSection = 'Category',
   DisplayName = 'Assigned By',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AE66B201-BA27-43E5-B297-7B4A19E45D50' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.DueDate 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '66556560-5FB1-4876-B152-8972776F9042' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.Priority 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Status & Priority',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '25EBA2BE-3D67-4C3D-82BA-4131F30C0C4A' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.Status 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Status & Priority',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '24FF726C-18A7-4369-97E9-9D19F3C08DD7' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.CompletedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '51E51318-E47A-43D9-BDC2-A9DC4674B593' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.CompletionNotes 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Action Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9E40BB0F-DC6E-490C-B7D1-0C9C85B93865' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F7D22428-454B-40B0-8063-9C25E5F28477' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1AB681F0-ACCC-4C8B-BE7F-1279BF9AA941' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.Committee 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Display Values',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F44CA8BF-26D9-43EC-868B-EE7635DAEBE2' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.AssignedToPerson 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Display Values',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C30DCC6B-D7C1-4DEC-BC54-D7B25EBA37E8' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.AssignedByPerson 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Display Values',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '735286DB-C0AD-460E-AF02-40DF8EEAF743' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-tasks */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-tasks', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '60F3019B-62E3-432F-A12C-F007CD73479C';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('d289d92d-4fc0-4b60-9d15-27ef39c9fa27', '60F3019B-62E3-432F-A12C-F007CD73479C', 'FieldCategoryInfo', '{"Committee Context":{"icon":"fa fa-building","description":"References to the committee, meeting, and agenda that originated the action item"},"Action Details":{"icon":"fa fa-align-left","description":"Core description fields that define what the action item is and any completion notes"},"Assignment":{"icon":"fa fa-user-check","description":"Information about who is responsible for the action and who assigned it"},"Timeline":{"icon":"fa fa-calendar","description":"Dates related to due, completion, and overall scheduling of the action item"},"Status & Priority":{"icon":"fa fa-flag-checkered","description":"Current status and importance level of the action item"},"Display Values":{"icon":"fa fa-id-card","description":"Denormalized text values for quick UI rendering of related entities"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit fields such as IDs and timestamps"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('f27e7ef1-c3ea-46a1-bbe8-9759f55b11eb', '60F3019B-62E3-432F-A12C-F007CD73479C', 'FieldCategoryIcons', '{"Committee Context":"fa fa-building","Action Details":"fa fa-align-left","Assignment":"fa fa-user-check","Timeline":"fa fa-calendar","Status & Priority":"fa fa-flag-checkered","Display Values":"fa fa-id-card","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=true for NEW entity (category: primary, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 1, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '60F3019B-62E3-432F-A12C-F007CD73479C';

/* Set categories for 20 fields */

-- UPDATE Entity Field Category Info Committees: Artifacts.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '97D05E82-9860-4EFA-9F37-72D4AAD69E3B' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.CommitteeID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Relationships',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BF94B523-4284-498D-ADBD-D7949CBF6429' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.MeetingID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Relationships',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3264EB1E-95DC-4C02-851B-D2BDFC3ED05A' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.AgendaItemID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Relationships',
   GeneratedFormSection = 'Category',
   DisplayName = 'Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F9B4E369-C0BC-42B2-BF8A-FF00A890F3FC' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.TaskID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Relationships',
   GeneratedFormSection = 'Category',
   DisplayName = 'Task',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8F561BCA-07F9-4B75-B3A5-CFFEFC8A0BC2' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.Title 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Artifact Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FCEAFFD3-DFF9-4B44-85AD-EBD7CC20C7A5' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.Description 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Artifact Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '134C712A-651F-4F87-AB31-7DC066BB2EAF' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.ArtifactTypeID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Artifact Classification',
   GeneratedFormSection = 'Category',
   DisplayName = 'Artifact Type',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '145E51F5-F522-46F5-8ABA-487183AC31BC' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.Provider 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Source Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '67CE1FD6-7483-463B-84CE-249070F9C93B' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.ExternalID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Source Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C9B656EA-E472-4FC3-8F41-9E2F73A07CAD' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.URL 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Source Information',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '943799A2-EDC9-43FB-AD0F-27FBA8849C28' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.MimeType 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Technical Metadata',
   GeneratedFormSection = 'Category',
   DisplayName = 'MIME Type',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'DC884038-624A-48C0-8923-8C01EC4B5667' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.FileSize 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Technical Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B512062A-2BC1-4089-9256-4A067A451C58' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.UploadedByPersonID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Technical Metadata',
   GeneratedFormSection = 'Category',
   DisplayName = 'Uploaded By Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7781B7D4-F59D-4999-BA79-66F5960A04BE' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A4005AAC-0B28-430B-A00F-7E971D81CFF7' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A5A1F1BF-B567-4378-8E56-D7C59E1108D7' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.Committee 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Relationships',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AB7AF39B-DA02-44F7-8920-8F57DA52D611' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.Task 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Relationships',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'ADAAEF9B-7AC4-4EFA-A961-17FFD7C579F5' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.ArtifactType 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Artifact Classification',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'ACAE4AFA-E166-4969-81FD-404EDB94E9C9' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.UploadedByPerson 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Technical Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '99D5DBF9-1FD6-46E1-A336-46140301B86A' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-file */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-file', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '92933713-351A-4135-B55E-83B025C8A569';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('a2cc3247-def4-49af-938b-ebca2192bbd3', '92933713-351A-4135-B55E-83B025C8A569', 'FieldCategoryInfo', '{"Relationships":{"icon":"fa fa-link","description":"Links to related committee, meeting, agenda item, and task entities"},"Artifact Details":{"icon":"fa fa-file-alt","description":"Core descriptive information about the artifact"},"Artifact Classification":{"icon":"fa fa-tag","description":"Categorization of the artifact by type"},"Source Information":{"icon":"fa fa-cloud-download-alt","description":"External provider details and access link for the artifact"},"Technical Metadata":{"icon":"fa fa-cog","description":"System‑managed technical properties such as MIME type, size, and uploader"},"System Metadata":{"icon":"fa fa-clock","description":"Audit timestamps for creation and last update"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('f8aa46dc-c6e4-49be-9608-145bb01ec48e', '92933713-351A-4135-B55E-83B025C8A569', 'FieldCategoryIcons', '{"Relationships":"fa fa-link","Artifact Details":"fa fa-file-alt","Artifact Classification":"fa fa-tag","Source Information":"fa fa-cloud-download-alt","Technical Metadata":"fa fa-cog","System Metadata":"fa fa-clock"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=true for NEW entity (category: primary, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 1, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '92933713-351A-4135-B55E-83B025C8A569';

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '85C8C511-22E4-40FA-BAEA-CC18D232D6F9'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'A14D9204-694D-4BDC-9A63-6C0B1237630B'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'BDDFF128-30B7-40A9-989F-D248FD049629'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '78DC61D2-672F-480D-AFBA-1971953074B7'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'A14D9204-694D-4BDC-9A63-6C0B1237630B'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '0D852446-BB08-419A-BE62-B8DB0BB372F4'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '85C8C511-22E4-40FA-BAEA-CC18D232D6F9'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'A14D9204-694D-4BDC-9A63-6C0B1237630B'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET IsNameField = 1
               WHERE ID = 'CCA255A7-816A-4B49-B1E8-1274BB5950D2'
               AND AutoUpdateIsNameField = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'CCA255A7-816A-4B49-B1E8-1274BB5950D2'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'E57B2946-85AC-4813-BDD8-72B4FF7FC4F6'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '833D0DBD-1F81-496E-9607-1A237A4171B8'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '5EC945B4-44AA-4683-A7FE-A911FAA8DE57'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '957A9D0E-65B1-4381-8138-6B79BE00CEB5'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'CCA255A7-816A-4B49-B1E8-1274BB5950D2'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '5EC945B4-44AA-4683-A7FE-A911FAA8DE57'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '1E7FCD57-9D6D-4D56-AB57-6B1064630ADC'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '957A9D0E-65B1-4381-8138-6B79BE00CEB5'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'CCA255A7-816A-4B49-B1E8-1274BB5950D2'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '1E7FCD57-9D6D-4D56-AB57-6B1064630ADC'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '957A9D0E-65B1-4381-8138-6B79BE00CEB5'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '8FA3CB95-D411-4061-8898-9060716FD2C1'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '2F2D3C21-4439-4E6A-8388-A1D7BE908DB1'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'A3820EF4-91F6-47F8-BC2A-D4BA42958BC4'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'EAB38918-456C-4E20-B96B-57B6F26F7C3B'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '8FA3CB95-D411-4061-8898-9060716FD2C1'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '3AEDED12-68F6-4DB6-8CF0-23F88F35CF54'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '73E6D7DC-74F2-4BCC-9D81-32AE76EB988E'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '5D1A0E9C-C403-4D7A-967C-47E36E241DE2'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '8FA3CB95-D411-4061-8898-9060716FD2C1'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '73E6D7DC-74F2-4BCC-9D81-32AE76EB988E'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '3AEDED12-68F6-4DB6-8CF0-23F88F35CF54'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '689F7267-B564-4CE9-A0C1-5C3205358A92'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'B09558F1-2E25-4754-ACCF-C6158B3317F9'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '84420538-722F-45FF-9D90-7D73F89C048F'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '4C81FF2D-D549-4F57-94DE-CD45F2ADC313'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '689F7267-B564-4CE9-A0C1-5C3205358A92'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '4C81FF2D-D549-4F57-94DE-CD45F2ADC313'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '4C81FF2D-D549-4F57-94DE-CD45F2ADC313'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '916666D0-56C9-4813-AD57-33DF9605FA74'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '39F4CF52-FE6B-4AFF-850F-4DC0CDF13ADA'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '29693C42-ACA2-4BE7-A44C-A6D8637F7752'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '8B0BFD64-ADFC-4C2A-B409-ADCB3D1582F7'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '3E7BBD00-D7A3-4C46-924F-9F26A33EC0B0'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '85FA28E3-4249-43D6-AB34-11BB861B5E33'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '29693C42-ACA2-4BE7-A44C-A6D8637F7752'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '94A75681-58B7-421A-AA84-EBBDB044342B'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'FF271A4E-95EA-4BD8-80F4-CBBFAFBDE00B'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '8B0BFD64-ADFC-4C2A-B409-ADCB3D1582F7'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '3E7BBD00-D7A3-4C46-924F-9F26A33EC0B0'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '85FA28E3-4249-43D6-AB34-11BB861B5E33'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '8B0BFD64-ADFC-4C2A-B409-ADCB3D1582F7'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '3E7BBD00-D7A3-4C46-924F-9F26A33EC0B0'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '85FA28E3-4249-43D6-AB34-11BB861B5E33'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '29693C42-ACA2-4BE7-A44C-A6D8637F7752'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set categories for 10 fields */

-- UPDATE Entity Field Category Info Committees: Minutes.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '990AD624-694D-4184-BCD3-891380F7E408' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Minutes.ArtifactID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Related Content',
   GeneratedFormSection = 'Category',
   DisplayName = 'Artifact',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'EE5964A2-1DEE-4142-A788-F39690CEDD20' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Minutes.MeetingID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Related Content',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '85C8C511-22E4-40FA-BAEA-CC18D232D6F9' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Minutes.Content 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Minutes Content',
   GeneratedFormSection = 'Category',
   ExtendedType = 'Code',
   CodeType = 'Other'
WHERE 
   ID = 'FE5E695B-4C84-4AC9-92B6-93A853F064CF' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Minutes.ApprovalStatus 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Approval Tracking',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A14D9204-694D-4BDC-9A63-6C0B1237630B' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Minutes.ApprovedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Approval Tracking',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BDDFF128-30B7-40A9-989F-D248FD049629' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Minutes.ApprovedByMeetingID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Approval Tracking',
   GeneratedFormSection = 'Category',
   DisplayName = 'Approved By Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '78DC61D2-672F-480D-AFBA-1971953074B7' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Minutes.Notes 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Minutes Content',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0D852446-BB08-419A-BE62-B8DB0BB372F4' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Minutes.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AB08BCC4-F374-4807-A6F1-29A92C973A6B' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Minutes.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '793948A8-E1C7-4B55-9FF9-D0F2BB2E753F' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-file-alt */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-file-alt', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = 'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('a26efca7-39a0-40e5-a054-b10cbd8e6ae7', 'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A', 'FieldCategoryInfo', '{"Related Content":{"icon":"fa fa-link","description":"References to other entities such as the source artifact and the parent meeting"},"Minutes Content":{"icon":"fa fa-align-left","description":"Main textual minutes, notes and any markdown content"},"Approval Tracking":{"icon":"fa fa-check-circle","description":"Fields that capture the approval status, timestamps and approving meeting"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit fields"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('8fb1a0a7-db17-4637-9872-8d4769c4ab41', 'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A', 'FieldCategoryIcons', '{"Related Content":"fa fa-link","Minutes Content":"fa fa-align-left","Approval Tracking":"fa fa-check-circle","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=true for NEW entity (category: primary, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 1, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = 'A70DAB39-DA59-4F4B-A2F0-DFAC15C8D29A';

/* Set categories for 18 fields */

-- UPDATE Entity Field Category Info Committees: Committees.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F509E494-9B8B-4788-95F5-B9EC7AC5CBC2' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.Name 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Core',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5D1A0E9C-C403-4D7A-967C-47E36E241DE2' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.Description 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Core',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0E7251F3-04EC-4F3A-A526-5E1A5176F36C' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.TypeID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Classification',
   GeneratedFormSection = 'Category',
   DisplayName = 'Type',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B791235E-ED08-4169-8C97-60D292C3DD31' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.ParentCommitteeID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Hierarchy',
   GeneratedFormSection = 'Category',
   DisplayName = 'Parent Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '688DFEB5-E302-4237-AF4C-C9B6C1E661D9' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.OrganizationID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Organization Association',
   GeneratedFormSection = 'Category',
   DisplayName = 'Organization',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B3AE4A14-D2FE-467D-80D0-8D91FD7FD105' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.CharterDocumentURL 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Documents',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '1F05EA9D-0F19-40A9-A4D2-12BC987B6A62' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.MissionStatement 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Core',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1614627F-17D0-47B1-BABF-7BDA4B8A4B23' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.Status 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8FA3CB95-D411-4061-8898-9060716FD2C1' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.IsPublic 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2F2D3C21-4439-4E6A-8388-A1D7BE908DB1' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.FormationDate 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A3820EF4-91F6-47F8-BC2A-D4BA42958BC4' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.DissolutionDate 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'EAB38918-456C-4E20-B96B-57B6F26F7C3B' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0FB1F3A0-EB7F-4E53-AE15-0AD6327BFD53' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '200543D6-3117-4AAB-9E63-0474F9CA4222' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.Type 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Classification',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A6914849-1298-4C75-B47F-A209C77F632F' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.ParentCommittee 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Hierarchy',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3AEDED12-68F6-4DB6-8CF0-23F88F35CF54' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.Organization 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Organization Association',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '73E6D7DC-74F2-4BCC-9D81-32AE76EB988E' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.RootParentCommitteeID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Hierarchy',
   GeneratedFormSection = 'Category',
   DisplayName = 'Root Parent Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '98E2D638-ED56-4212-A9E2-019A95EF65E9' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-building */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-building', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('4c00e364-12a2-4a7c-acb5-6a1c0eaf3509', '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', 'FieldCategoryInfo', '{"Committee Core":{"icon":"fa fa-user-friends","description":"Key identifying and descriptive information about the committee"},"Committee Classification":{"icon":"fa fa-tags","description":"Type and categorization details linking to reference data"},"Hierarchy":{"icon":"fa fa-sitemap","description":"Parent‑child relationships that define the committee hierarchy"},"Organization Association":{"icon":"fa fa-building","description":"Linkage of the committee to its parent organization"},"Documents":{"icon":"fa fa-file","description":"Links to related documents such as the charter"},"Committee Status":{"icon":"fa fa-flag-checkered","description":"Current operational state and visibility of the committee"},"Timeline":{"icon":"fa fa-calendar-alt","description":"Important dates in the committee''s lifecycle"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit and technical fields"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('45263a29-8177-4a87-a217-53d4125546f2', '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78', 'FieldCategoryIcons', '{"Committee Core":"fa fa-user-friends","Committee Classification":"fa fa-tags","Hierarchy":"fa fa-sitemap","Organization Association":"fa fa-building","Documents":"fa fa-file","Committee Status":"fa fa-flag-checkered","Timeline":"fa fa-calendar-alt","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=true for NEW entity (category: primary, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 1, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '49F660ED-B5B1-4A4E-B2CD-BF048D2B0E78';

/* Set categories for 14 fields */

-- UPDATE Entity Field Category Info Committees: Memberships.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '32B3BD38-6183-4634-AA15-BF655AC824CA' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.PersonID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Person Assignment',
   GeneratedFormSection = 'Category',
   DisplayName = 'Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5626BF59-B910-4AE3-AA51-A9CABF3102A9' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.RoleID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Person Assignment',
   GeneratedFormSection = 'Category',
   DisplayName = 'Role',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F6C680F8-C4D0-4860-8763-603D9D2CF9E7' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.TermID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Person Assignment',
   GeneratedFormSection = 'Category',
   DisplayName = 'Term',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0B9A63EA-3E56-4174-AA54-94E843E063FB' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.StartDate 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Membership Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '916666D0-56C9-4813-AD57-33DF9605FA74' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.EndDate 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Membership Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '39F4CF52-FE6B-4AFF-850F-4DC0CDF13ADA' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.Status 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Membership Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '29693C42-ACA2-4BE7-A44C-A6D8637F7752' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.EndReason 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Membership Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '94A75681-58B7-421A-AA84-EBBDB044342B' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.Notes 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Membership Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FF271A4E-95EA-4BD8-80F4-CBBFAFBDE00B' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3D4DCA98-D415-42C6-A50B-5E2BED79DF33' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4101723B-48D2-4136-9BB1-A591357BBAF9' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.Person 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Person Assignment',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8B0BFD64-ADFC-4C2A-B409-ADCB3D1582F7' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.Role 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Person Assignment',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3E7BBD00-D7A3-4C46-924F-9F26A33EC0B0' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.Term 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Person Assignment',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '85FA28E3-4249-43D6-AB34-11BB861B5E33' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-users */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-users', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '79FED512-86CA-438C-9476-EFDB091C2E3C';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('cf4a38d4-e735-44f5-8827-b99dfee3d46f', '79FED512-86CA-438C-9476-EFDB091C2E3C', 'FieldCategoryInfo', '{"System Metadata":{"icon":"fa fa-cog","description":"Audit and technical fields managed by the system"},"Person Assignment":{"icon":"fa fa-id-card","description":"Links a person to a committee role and term"},"Membership Timeline":{"icon":"fa fa-calendar","description":"Start and end dates defining the period of membership"},"Membership Status":{"icon":"fa fa-flag","description":"Current status and end reason of the membership"},"Membership Details":{"icon":"fa fa-align-left","description":"Additional notes and free‑form details about the membership"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('53f5d06f-e73c-4b18-b91d-ea6c55376c08', '79FED512-86CA-438C-9476-EFDB091C2E3C', 'FieldCategoryIcons', '{"System Metadata":"fa fa-cog","Person Assignment":"fa fa-id-card","Membership Timeline":"fa fa-calendar","Membership Status":"fa fa-flag","Membership Details":"fa fa-align-left"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=true for NEW entity (category: primary, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 1, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '79FED512-86CA-438C-9476-EFDB091C2E3C';

/* Set categories for 21 fields */

-- UPDATE Entity Field Category Info Committees: Meetings.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1EAEB956-E81E-4BC0-9EAE-645711001260' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '66788412-6C0C-4AE8-AFAE-5D78EFFF24CE' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FAF90298-5976-420B-B0D7-088E840CB173' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.CommitteeID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Meeting Info',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0920B300-E269-4EE4-976A-582CF49136C4' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.Committee 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Meeting Info',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '45F0D5F2-F527-40E8-8DEE-FFA03C5651B0' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.Title 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Meeting Info',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CCA255A7-816A-4B49-B1E8-1274BB5950D2' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.Description 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Meeting Info',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '896BB776-B9D6-4FC2-9FA8-515A81EA7786' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.Status 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Meeting Info',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '957A9D0E-65B1-4381-8138-6B79BE00CEB5' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.StartDateTime 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Timing',
   GeneratedFormSection = 'Category',
   DisplayName = 'Start Date & Time',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E57B2946-85AC-4813-BDD8-72B4FF7FC4F6' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.EndDateTime 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Timing',
   GeneratedFormSection = 'Category',
   DisplayName = 'End Date & Time',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '833D0DBD-1F81-496E-9607-1A237A4171B8' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.TimeZone 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Timing',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2CC32FD2-39CC-4F0F-8773-CB785A0D53DA' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.CalendarEventID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Timing',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9EC76FBE-CB3A-4074-8F67-32C9399334F6' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.LocationType 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Location & Video',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'DE630981-4687-41C2-9C18-27B14CCAC871' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.LocationText 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Location & Video',
   GeneratedFormSection = 'Category',
   DisplayName = 'Location Details',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5EC945B4-44AA-4683-A7FE-A911FAA8DE57' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.VideoProvider 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Location & Video',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1E7FCD57-9D6D-4D56-AB57-6B1064630ADC' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.VideoProviderID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Location & Video',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CBC39996-E357-41AF-9210-8C38CA72503A' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.VideoMeetingID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Location & Video',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8DB4C439-BD8D-41F7-A739-9AC066440774' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.VideoJoinURL 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Location & Video',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '2BE797FE-BDF2-4DBD-AAEC-05B2FCA6F9F7' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.VideoRecordingURL 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Location & Video',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '2FAAAB3A-8936-4C77-9976-2A7E8B66FAE5' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.TranscriptURL 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Location & Video',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '6DB445CD-86BB-4A6B-B722-51DD1EC3CCA0' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.VideoProvider_Virtual 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Location & Video',
   GeneratedFormSection = 'Category',
   DisplayName = 'Video Provider (Virtual)',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7DBF9576-6A75-4112-828B-BEDF63BE05C7' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-calendar */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-calendar', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '543ADDC1-DEBC-4324-A23F-6A20D2924881';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('f0d5e41d-e8ea-4b92-9f1c-bd4b536df00f', '543ADDC1-DEBC-4324-A23F-6A20D2924881', 'FieldCategoryInfo', '{"Meeting Info":{"icon":"fa fa-info-circle","description":"Core identifiers, title, description, committee reference and current status of the meeting"},"Timing":{"icon":"fa fa-clock","description":"Start/end times, time zone and calendar integration details"},"Location & Video":{"icon":"fa fa-video","description":"Physical or virtual location details and all video‑conference connection information"},"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('4fd6d6a9-4808-42c6-b665-a2f91a3a8c41', '543ADDC1-DEBC-4324-A23F-6A20D2924881', 'FieldCategoryIcons', '{"Meeting Info":"fa fa-info-circle","Timing":"fa fa-clock","Location & Video":"fa fa-video","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=true for NEW entity (category: primary, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 1, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '543ADDC1-DEBC-4324-A23F-6A20D2924881';

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '83EB8CC1-905E-4D91-80CF-207CC15FD4C9'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'C683FCFF-C6E5-499D-B44F-6BA41A994BA4'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '2B83B174-5D89-4C25-8609-760959E382DF'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'A8E942BC-D720-49D9-A005-8F4B5BDA0A28'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'BEDA2769-CAB2-452E-969D-CEE776BF5772'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'CDAE1488-EB19-45D2-A3E6-F956984EECF1'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '91932706-B5A2-447C-B217-9C549CB37965'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'CDAE1488-EB19-45D2-A3E6-F956984EECF1'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'B9B3B6FE-3198-48AB-97B1-F3615879365E'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'B02621A0-F2C7-48A9-91A4-E6A60A55A415'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'B2BDD117-EA30-45A8-A220-90FC3F2F53D1'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '4F8C7C38-1C18-4090-9158-9BE475B0D6A2'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'B02621A0-F2C7-48A9-91A4-E6A60A55A415'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'E62D7D15-C19B-476C-903F-695972E18E9D'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET IsNameField = 1
               WHERE ID = '78E957BA-01E2-40E1-ABA3-5B71DACB7B51'
               AND AutoUpdateIsNameField = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '78E957BA-01E2-40E1-ABA3-5B71DACB7B51'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'FCD4998A-EAFC-4B5A-BB25-96F7EE9B91C4'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'B2AF60F6-3714-414A-B333-1852EDAAD08E'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'F32D9D70-40BD-48F0-A543-342632A97584'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '9EBC1D34-03DD-4056-A2AF-B70456673A2E'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '78E957BA-01E2-40E1-ABA3-5B71DACB7B51'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '798FC86A-3FC8-4A29-9C40-EBB3C1CE451B'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'FCD4998A-EAFC-4B5A-BB25-96F7EE9B91C4'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '259E7DD8-A15A-46C2-AE0E-D16DAC41C0DC'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '78E957BA-01E2-40E1-ABA3-5B71DACB7B51'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'FCD4998A-EAFC-4B5A-BB25-96F7EE9B91C4'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '0BC33639-5F59-4991-AA18-416F7BEF0CF4'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'E7833565-23C6-4FCC-8B8E-660D7563652E'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '0D129ACC-B43B-4C00-9AE6-93C01CF2C629'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '0D129ACC-B43B-4C00-9AE6-93C01CF2C629'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '46312B97-3598-4FB0-A2E7-56F3A96405A3'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '0D129ACC-B43B-4C00-9AE6-93C01CF2C629'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set categories for 8 fields */

-- UPDATE Entity Field Category Info Committees: Types.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E0E4ADEB-0743-47F0-8377-9221F9EC0306' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Types.Name 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Definition',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B9B3B6FE-3198-48AB-97B1-F3615879365E' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Types.Description 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Definition',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CDAE1488-EB19-45D2-A3E6-F956984EECF1' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Types.IsStandards 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Settings',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A0173BC7-D780-44BD-A801-4615AECE1B60' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Types.DefaultTermMonths 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Settings',
   GeneratedFormSection = 'Category',
   DisplayName = 'Default Term (Months)',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1A06DDEA-17DC-4669-91D0-BC9BA455EB17' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Types.IconClass 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Presentation',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '91932706-B5A2-447C-B217-9C549CB37965' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Types.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '51EA257E-CF4B-4C79-A2FF-70D1545DD804' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Types.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0DFE55C7-0A73-4263-8064-DFB998F64C45' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-list-alt */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-list-alt', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = 'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('f33f0be2-0e36-4247-a68e-265dd4d87077', 'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E', 'FieldCategoryInfo', '{"Committee Definition":{"icon":"fa fa-file-alt","description":"Core identifying information for each committee type"},"Committee Settings":{"icon":"fa fa-sliders-h","description":"Configuration flags and default term settings for committees"},"Presentation":{"icon":"fa fa-palette","description":"Visual representation details such as icons"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit fields"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('5308827c-dbe6-4545-89de-9fb8ed9a12b6', 'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E', 'FieldCategoryIcons', '{"Committee Definition":"fa fa-file-alt","Committee Settings":"fa fa-sliders-h","Presentation":"fa fa-palette","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=false for NEW entity (category: reference, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 0, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = 'D49BDEB5-8D19-4E8E-B130-5FEC6E80C36E';

/* Set categories for 9 fields */

-- UPDATE Entity Field Category Info Committees: Video Providers.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '797D8972-7A34-438A-9DD3-9EB6CF1221EB' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Video Providers.Name 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Provider Settings',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E62D7D15-C19B-476C-903F-695972E18E9D' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Video Providers.ServerDriverKey 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Provider Settings',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B02621A0-F2C7-48A9-91A4-E6A60A55A415' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Video Providers.IsActive 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Provider Status',
   GeneratedFormSection = 'Category',
   DisplayName = 'Active',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B2BDD117-EA30-45A8-A220-90FC3F2F53D1' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Video Providers.IsDefault 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Provider Status',
   GeneratedFormSection = 'Category',
   DisplayName = 'Default',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4F8C7C38-1C18-4090-9158-9BE475B0D6A2' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Video Providers.CredentialID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Credentials',
   GeneratedFormSection = 'Category',
   DisplayName = 'Credential',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BC5B9497-6CF7-4079-A9E1-F63CF2B370CF' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Video Providers.Credential 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Credentials',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D255FF99-A489-4822-805D-E9AD138177AA' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Video Providers.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '69184033-68F6-4D81-A7D6-EC5B3DCEB652' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Video Providers.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3ED97A4D-77E9-4E4F-BCBA-54DD57219571' AND AutoUpdateCategory = 1;

/* Set categories for 9 fields */

-- UPDATE Entity Field Category Info Committees: Roles.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2F951811-A07C-4FFE-9C2E-62D7B3261434' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Roles.Name 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Role Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BEDA2769-CAB2-452E-969D-CEE776BF5772' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Roles.Description 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Role Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A8E942BC-D720-49D9-A005-8F4B5BDA0A28' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Roles.IsOfficer 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Role Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '83EB8CC1-905E-4D91-80CF-207CC15FD4C9' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Roles.IsVotingRole 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Role Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C683FCFF-C6E5-499D-B44F-6BA41A994BA4' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Roles.DefaultPermissionsJSON 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Role Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Default Permissions',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6AE8D517-09B2-44E1-8B03-9C8542375DC8' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Roles.Sequence 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Role Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2B83B174-5D89-4C25-8609-760959E382DF' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Roles.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9D34D099-2E9A-4577-877E-77EFF3ABD75D' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Roles.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '71BF42B9-F0F5-4A60-B83D-4D31455B06D0' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-video */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-video', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '870B0B2C-29A9-4B4F-96A8-68354D969562';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('60c68224-aad8-4bdd-ae01-97187258456e', '870B0B2C-29A9-4B4F-96A8-68354D969562', 'FieldCategoryInfo', '{"Provider Settings":{"icon":"fa fa-cog","description":"Configuration details for the video provider such as name and driver key"},"Provider Status":{"icon":"fa fa-flag-checkered","description":"Flags indicating whether the provider is active and/or set as default"},"Credentials":{"icon":"fa fa-key","description":"Reference to authentication credentials used by the provider"},"System Metadata":{"icon":"fa fa-database","description":"System‑managed audit fields"}}', GETUTCDATE(), GETUTCDATE());

/* Set entity icon to fa fa-clipboard-list */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-clipboard-list', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '0608D034-AE4B-484E-97AC-65C4C7640D36';

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('c4d49e3f-d6a5-48c9-a40b-dd6c6daf0683', '870B0B2C-29A9-4B4F-96A8-68354D969562', 'FieldCategoryIcons', '{"Provider Settings":"fa fa-cog","Provider Status":"fa fa-flag-checkered","Credentials":"fa fa-key","System Metadata":"fa fa-database"}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('950dc555-77f7-4f27-85f4-eb14056e8a48', '0608D034-AE4B-484E-97AC-65C4C7640D36', 'FieldCategoryInfo', '{"Role Details":{"icon":"fa fa-id-badge","description":"Core information defining a committee role, its purpose, authority and default permissions"},"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed automatically by the system"}}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=false for NEW entity (category: reference, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 0, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '870B0B2C-29A9-4B4F-96A8-68354D969562';

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('b9a5d2e8-f2ad-45fe-8aa9-2009a8f74e68', '0608D034-AE4B-484E-97AC-65C4C7640D36', 'FieldCategoryIcons', '{"Role Details":"fa fa-id-badge","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=false for NEW entity (category: reference, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 0, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '0608D034-AE4B-484E-97AC-65C4C7640D36';

/* Set categories for 9 fields */

-- UPDATE Entity Field Category Info Committees: Terms.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '261DA650-DFA8-4071-A8E3-2F1C7AE9710B' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Terms.CommitteeID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Reference',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C5A5A349-5501-4316-8D6F-8380D68AE0D3' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Terms.Name 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Term Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '46312B97-3598-4FB0-A2E7-56F3A96405A3' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Terms.StartDate 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Term Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0BC33639-5F59-4991-AA18-416F7BEF0CF4' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Terms.EndDate 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Term Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E7833565-23C6-4FCC-8B8E-660D7563652E' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Terms.Status 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Term Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0D129ACC-B43B-4C00-9AE6-93C01CF2C629' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Terms.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'ED11C41D-FDC6-4189-9067-692A6D2FC4E9' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Terms.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '44713532-93D6-4ADD-ABAE-ADEE85338586' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Terms.Committee 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Reference',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1725021B-AC12-4A64-BABE-5206C298D8E6' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-calendar-alt */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-calendar-alt', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('55f4253b-809b-41c3-be21-f14acdda54ee', '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2', 'FieldCategoryInfo', '{"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields automatically managed by the system"},"Committee Reference":{"icon":"fa fa-users","description":"Fields that identify and link the term to its parent committee"},"Term Details":{"icon":"fa fa-info-circle","description":"Core descriptive information about the committee term"},"Term Timeline":{"icon":"fa fa-calendar","description":"Start and end dates defining the membership period"},"Term Status":{"icon":"fa fa-flag-checkered","description":"Current operational status of the term"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('87d129fc-333d-4e76-ae5f-c03e05f8e587', '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2', 'FieldCategoryIcons', '{"System Metadata":"fa fa-cog","Committee Reference":"fa fa-users","Term Details":"fa fa-info-circle","Term Timeline":"fa fa-calendar","Term Status":"fa fa-flag-checkered"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=false for NEW entity (category: reference, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 0, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '04E6285A-7CC3-4BAA-9DFC-955385B3DAF2';

/* Set categories for 16 fields */

-- UPDATE Entity Field Category Info Committees: Motions.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1B716203-4895-436F-9A11-7747A11BCDFF' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.MeetingID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Meeting Context',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '79917E09-4F24-4C05-8A92-586A5BFD9DFE' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.AgendaItemID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Meeting Context',
   GeneratedFormSection = 'Category',
   DisplayName = 'Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9C796B76-96F7-4C73-9706-A5D925E246FC' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.Sequence 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Meeting Context',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'EDD1C2A0-6D0B-4E09-921E-E9B70CD877F9' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.Title 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Motion Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '78E957BA-01E2-40E1-ABA3-5B71DACB7B51' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.Description 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Motion Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '798FC86A-3FC8-4A29-9C40-EBB3C1CE451B' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.MovedByMembershipID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Participation',
   GeneratedFormSection = 'Category',
   DisplayName = 'Moved By',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '37309305-908C-442E-9711-E284583A37FF' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.SecondedByMembershipID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Participation',
   GeneratedFormSection = 'Category',
   DisplayName = 'Seconded By',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4E45C0BB-83A6-49AE-9A6D-041502E27C30' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.Result 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Outcome',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FCD4998A-EAFC-4B5A-BB25-96F7EE9B91C4' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.ResultSummary 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Outcome',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '259E7DD8-A15A-46C2-AE0E-D16DAC41C0DC' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.YesCount 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Outcome',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B2AF60F6-3714-414A-B333-1852EDAAD08E' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.NoCount 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Outcome',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F32D9D70-40BD-48F0-A543-342632A97584' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.AbstainCount 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Outcome',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9EBC1D34-03DD-4056-A2AF-B70456673A2E' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.Notes 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Additional Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4B0AF217-58E9-4E5D-9D51-C05E69AFCE76' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8AE862FA-5A74-4990-B6C9-92EDE5C962EC' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '98C6D8AB-1A76-459D-8A23-1A97720E4CA1' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-gavel */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-gavel', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = 'AC908A89-225C-48CF-8852-40E612096D6C';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('a4475c02-7721-482a-9bdb-4b311699b6bd', 'AC908A89-225C-48CF-8852-40E612096D6C', 'FieldCategoryInfo', '{"Meeting Context":{"icon":"fa fa-calendar","description":"Links and ordering information for the meeting and agenda"},"Motion Details":{"icon":"fa fa-align-left","description":"Core description and title of the motion"},"Participation":{"icon":"fa fa-user-friends","description":"Members involved in moving and seconding the motion"},"Outcome":{"icon":"fa fa-flag-checkered","description":"Voting results and summary of the motion"},"Additional Information":{"icon":"fa fa-sticky-note","description":"Supplementary notes related to the motion"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit and tracking fields"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('62e28767-4e51-4791-95c0-5e10f5997c11', 'AC908A89-225C-48CF-8852-40E612096D6C', 'FieldCategoryIcons', '{"Meeting Context":"fa fa-calendar","Motion Details":"fa fa-align-left","Participation":"fa fa-user-friends","Outcome":"fa fa-flag-checkered","Additional Information":"fa fa-sticky-note","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=true for NEW entity (category: primary, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 1, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = 'AC908A89-225C-48CF-8852-40E612096D6C';

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET IsNameField = 1
               WHERE ID = '96EC7FCC-85B6-418A-8FBF-05753FE85248'
               AND AutoUpdateIsNameField = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '28400D79-0525-4E81-A11D-A90E3871371B'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '0D489164-45AA-4FCF-AEC5-760203BF6F87'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '96EC7FCC-85B6-418A-8FBF-05753FE85248'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'AAEA3EE4-4B20-4C19-BF9A-B586364A2627'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '96EC7FCC-85B6-418A-8FBF-05753FE85248'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'AAEA3EE4-4B20-4C19-BF9A-B586364A2627'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '96EC7FCC-85B6-418A-8FBF-05753FE85248'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set categories for 7 fields */

-- UPDATE Entity Field Category Info Committees: Votes.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F4634031-0BAA-4766-A7D4-8E9D13D11C66' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Votes.MotionID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Motion Reference',
   GeneratedFormSection = 'Category',
   DisplayName = 'Motion',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '28400D79-0525-4E81-A11D-A90E3871371B' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Votes.MembershipID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Member Reference',
   GeneratedFormSection = 'Category',
   DisplayName = 'Member',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0D489164-45AA-4FCF-AEC5-760203BF6F87' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Votes.VoteValue 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Vote Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '96EC7FCC-85B6-418A-8FBF-05753FE85248' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Votes.Notes 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Vote Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AAEA3EE4-4B20-4C19-BF9A-B586364A2627' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Votes.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8211C314-3D36-40CF-B830-25E4A389AC29' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Votes.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D0AF7FC9-2EC3-40FD-84F8-4CDA2CB7F558' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-handshake */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-handshake', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = 'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('5401dcda-6486-4f69-9596-133dbab90e90', 'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF', 'FieldCategoryInfo', '{"Motion Reference":{"icon":"fa fa-gavel","description":"Reference to the committee motion being voted on"},"Member Reference":{"icon":"fa fa-user","description":"Reference to the committee member who cast the vote"},"Vote Details":{"icon":"fa fa-check-square","description":"Core voting information including the choice and any notes"},"System Metadata":{"icon":"fa fa-cog","description":"System-managed audit fields"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('0fbe21bf-7d94-4b14-be01-e064132da579', 'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF', 'FieldCategoryIcons', '{"Motion Reference":"fa fa-gavel","Member Reference":"fa fa-user","Vote Details":"fa fa-check-square","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=false for NEW entity (category: reference, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 0, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = 'BACA039C-8D23-4AEF-9A03-2E1AD2426EDF';


GO

/*----------------------------- APPLICATION CONFIG --------------------------------*/
-- Committee Applications: finalize the member-facing app + create the staff app.
--
-- CodeGen auto-creates the application for this schema, named after the schema
-- itself ('${flyway:defaultSchema}'). This migration:
--   1. Renames it to 'Committees' with a friendly description and member-facing
--      nav items (including the Members tab).
--   2. Creates the staff-facing 'Committee Management' application.
--   3. Copies the Committees app's ApplicationEntity rows to the management app.
--
-- Runs after the baseline (which contains the CodeGen app create). Idempotent.

---------------------------------------------------------------------------
-- 1. Rename + configure the member-facing Committees application
--    (CodeGen names it after the schema with an auto-derived path;
--     match either and normalize both name and path)
---------------------------------------------------------------------------
UPDATE ${mjSchema}.Application
SET Name = 'Committees',
    Path = 'mjcommittees',
    Description = 'Member and officer participation app for committees, meetings, voting, and task tracking',
    DefaultNavItems = '[{"Label":"Dashboard","Icon":"fa-solid fa-gauge-high","ResourceType":"Custom","DriverClass":"CommitteeDashboardComponent","isDefault":true},{"Label":"Committees","Icon":"fa-solid fa-users-rectangle","ResourceType":"Custom","DriverClass":"CommitteeListComponent","isDefault":false},{"Label":"Members","Icon":"fa-solid fa-user-group","ResourceType":"Custom","DriverClass":"MembershipListComponent","isDefault":false},{"Label":"Meetings","Icon":"fa-solid fa-calendar-days","ResourceType":"Custom","DriverClass":"MeetingListComponent","isDefault":false},{"Label":"Action Items","Icon":"fa-solid fa-list-check","ResourceType":"Custom","DriverClass":"ActionItemTrackerComponent","isDefault":false},{"Label":"Documents","Icon":"fa-solid fa-file-lines","ResourceType":"Custom","DriverClass":"DocumentBrowserComponent","isDefault":false}]'
-- Match the CodeGen-created app by its deterministic auto-derived path
-- (mjbizappscommittees) OR the already-normalized path (mjcommittees, on re-run).
-- The earlier version also ANDed on Name IN ('${flyway:defaultSchema}', ...); that
-- made the UPDATE match zero rows, leaving the raw schema-named app in place. The
-- path is stable and unambiguous, so match on it alone.
WHERE Path IN ('mjbizappscommittees', 'mjcommittees');
GO

---------------------------------------------------------------------------
-- 2. Create the staff-facing "Committee Management" application
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM ${mjSchema}.Application WHERE Name = 'Committee Management')
    INSERT INTO ${mjSchema}.Application (
        ID, Name, Description, Icon, Color, Path, DefaultNavItems
    )
    VALUES (
        NEWID(),
        'Committee Management',
        'Staff-facing administrative application for managing all committees, memberships, meetings, and documents',
        'fa-solid fa-clipboard-list',
        '#e64a19',
        'mjcommitteemgmt',
        '[{"Label":"Command Center","Icon":"fa-solid fa-chart-simple","ResourceType":"Custom","DriverClass":"CommandCenterComponent","isDefault":true},{"Label":"Committees","Icon":"fa-solid fa-users-rectangle","ResourceType":"Custom","DriverClass":"ManagementCommitteeListComponent","isDefault":false},{"Label":"Members","Icon":"fa-solid fa-user-group","ResourceType":"Custom","DriverClass":"ManagementMembershipListComponent","isDefault":false},{"Label":"Meetings","Icon":"fa-solid fa-calendar-days","ResourceType":"Custom","DriverClass":"MeetingListComponent","isDefault":false},{"Label":"Action Items","Icon":"fa-solid fa-list-check","ResourceType":"Custom","DriverClass":"ActionItemTrackerComponent","isDefault":false},{"Label":"Documents","Icon":"fa-solid fa-file-lines","ResourceType":"Custom","DriverClass":"DocumentBrowserComponent","isDefault":false}]'
    );
GO

---------------------------------------------------------------------------
-- 3. Copy ApplicationEntity rows from Committees so the management app
--    has access to the same entities (skip rows already present)
---------------------------------------------------------------------------
DECLARE @MgmtAppID UNIQUEIDENTIFIER = (SELECT ID FROM ${mjSchema}.Application WHERE Name = 'Committee Management');

INSERT INTO ${mjSchema}.ApplicationEntity (ApplicationID, EntityID, Sequence)
SELECT @MgmtAppID, ae.EntityID, ae.Sequence
FROM ${mjSchema}.ApplicationEntity ae
JOIN ${mjSchema}.Application a ON ae.ApplicationID = a.ID
WHERE a.Name = 'Committees'
  AND NOT EXISTS (
      SELECT 1 FROM ${mjSchema}.ApplicationEntity x
      WHERE x.ApplicationID = @MgmtAppID AND x.EntityID = ae.EntityID
  );
GO
