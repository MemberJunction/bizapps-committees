-- Committees App Schema and Tables
-- Phase 1: Core Entities
-- Depends on: V202602150001__BizAppsCommon_Schema_and_Tables.sql
-- Idempotent: safe to re-run if partially or fully applied.

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = '__mj_Committees')
    EXEC('CREATE SCHEMA __mj_Committees');
GO

---------------------------------------------------------------------------
-- Committee Types: Board, Standing, Ad Hoc, Workgroup, Standards WG
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'Type')
CREATE TABLE __mj_Committees.Type (
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
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'Committee')
CREATE TABLE __mj_Committees.Committee (
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
    CONSTRAINT FK_Committee_Type FOREIGN KEY (TypeID) REFERENCES __mj_Committees.Type(ID),
    CONSTRAINT FK_Committee_Parent FOREIGN KEY (ParentCommitteeID) REFERENCES __mj_Committees.Committee(ID),
    CONSTRAINT FK_Committee_Organization FOREIGN KEY (OrganizationID) REFERENCES __mj_BizAppsCommon.Organization(ID),
    CONSTRAINT CK_Committee_Status CHECK (Status IN ('Active', 'Inactive', 'Pending', 'Dissolved'))
);
GO

---------------------------------------------------------------------------
-- Committee Terms (annual or custom periods)
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'Term')
CREATE TABLE __mj_Committees.Term (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    CommitteeID UNIQUEIDENTIFIER NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE,
    Status NVARCHAR(50) NOT NULL DEFAULT 'Active',
    CONSTRAINT PK_Term PRIMARY KEY (ID),
    CONSTRAINT FK_Term_Committee FOREIGN KEY (CommitteeID) REFERENCES __mj_Committees.Committee(ID),
    CONSTRAINT CK_Term_Status CHECK (Status IN ('Active', 'Upcoming', 'Completed'))
);
GO

---------------------------------------------------------------------------
-- Role definitions (Chair, Vice Chair, Secretary, Member, Liaison, etc.)
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'Role')
CREATE TABLE __mj_Committees.Role (
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
-- Committee membership (links to BizAppsCommon Person)
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'Membership')
CREATE TABLE __mj_Committees.Membership (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    CommitteeID UNIQUEIDENTIFIER NOT NULL,
    PersonID UNIQUEIDENTIFIER NOT NULL,
    RoleID UNIQUEIDENTIFIER NOT NULL,
    TermID UNIQUEIDENTIFIER,
    StartDate DATE NOT NULL,
    EndDate DATE,
    Status NVARCHAR(50) NOT NULL DEFAULT 'Active',
    EndReason NVARCHAR(100),
    Notes NVARCHAR(MAX),
    CONSTRAINT PK_Membership PRIMARY KEY (ID),
    CONSTRAINT FK_Membership_Committee FOREIGN KEY (CommitteeID) REFERENCES __mj_Committees.Committee(ID),
    CONSTRAINT FK_Membership_Person FOREIGN KEY (PersonID) REFERENCES __mj_BizAppsCommon.Person(ID),
    CONSTRAINT FK_Membership_Role FOREIGN KEY (RoleID) REFERENCES __mj_Committees.Role(ID),
    CONSTRAINT FK_Membership_Term FOREIGN KEY (TermID) REFERENCES __mj_Committees.Term(ID),
    CONSTRAINT CK_Membership_Status CHECK (Status IN ('Active', 'Pending', 'Ended', 'Suspended'))
);
GO

---------------------------------------------------------------------------
-- Meeting records
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'Meeting')
CREATE TABLE __mj_Committees.Meeting (
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
    VideoMeetingID NVARCHAR(255),
    VideoJoinURL NVARCHAR(1000),
    VideoRecordingURL NVARCHAR(1000),
    TranscriptURL NVARCHAR(1000),
    Status NVARCHAR(50) NOT NULL DEFAULT 'Scheduled',
    CalendarEventID NVARCHAR(255),
    CONSTRAINT PK_Meeting PRIMARY KEY (ID),
    CONSTRAINT FK_Meeting_Committee FOREIGN KEY (CommitteeID) REFERENCES __mj_Committees.Committee(ID),
    CONSTRAINT CK_Meeting_Status CHECK (Status IN ('Draft', 'Scheduled', 'InProgress', 'Completed', 'Cancelled', 'Postponed')),
    CONSTRAINT CK_Meeting_LocationType CHECK (LocationType IN ('Virtual', 'InPerson', 'Hybrid'))
);
GO

---------------------------------------------------------------------------
-- Meeting agenda items
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'AgendaItem')
CREATE TABLE __mj_Committees.AgendaItem (
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
    CONSTRAINT FK_AgendaItem_Meeting FOREIGN KEY (MeetingID) REFERENCES __mj_Committees.Meeting(ID),
    CONSTRAINT FK_AgendaItem_Parent FOREIGN KEY (ParentAgendaItemID) REFERENCES __mj_Committees.AgendaItem(ID),
    CONSTRAINT FK_AgendaItem_Presenter FOREIGN KEY (PresenterPersonID) REFERENCES __mj_BizAppsCommon.Person(ID),
    CONSTRAINT CK_AgendaItem_Type CHECK (ItemType IN ('Information', 'Discussion', 'Action', 'Vote', 'Report', 'Other')),
    CONSTRAINT CK_AgendaItem_Status CHECK (Status IN ('Pending', 'Discussed', 'Tabled', 'Completed', 'Skipped'))
);
GO

---------------------------------------------------------------------------
-- Meeting attendance
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'Attendance')
CREATE TABLE __mj_Committees.Attendance (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    MeetingID UNIQUEIDENTIFIER NOT NULL,
    PersonID UNIQUEIDENTIFIER NOT NULL,
    AttendanceStatus NVARCHAR(50) NOT NULL DEFAULT 'Expected',
    JoinedAt DATETIMEOFFSET,
    LeftAt DATETIMEOFFSET,
    Notes NVARCHAR(500),
    CONSTRAINT PK_Attendance PRIMARY KEY (ID),
    CONSTRAINT FK_Attendance_Meeting FOREIGN KEY (MeetingID) REFERENCES __mj_Committees.Meeting(ID),
    CONSTRAINT FK_Attendance_Person FOREIGN KEY (PersonID) REFERENCES __mj_BizAppsCommon.Person(ID),
    CONSTRAINT CK_Attendance_Status CHECK (AttendanceStatus IN ('Expected', 'Present', 'Absent', 'Excused', 'Partial')),
    CONSTRAINT UQ_Attendance UNIQUE (MeetingID, PersonID)
);
GO

---------------------------------------------------------------------------
-- Action items (tasks assigned from meetings or committees)
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'ActionItem')
CREATE TABLE __mj_Committees.ActionItem (
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
    CONSTRAINT FK_ActionItem_Committee FOREIGN KEY (CommitteeID) REFERENCES __mj_Committees.Committee(ID),
    CONSTRAINT FK_ActionItem_Meeting FOREIGN KEY (MeetingID) REFERENCES __mj_Committees.Meeting(ID),
    CONSTRAINT FK_ActionItem_AgendaItem FOREIGN KEY (AgendaItemID) REFERENCES __mj_Committees.AgendaItem(ID),
    CONSTRAINT FK_ActionItem_AssignedTo FOREIGN KEY (AssignedToPersonID) REFERENCES __mj_BizAppsCommon.Person(ID),
    CONSTRAINT FK_ActionItem_AssignedBy FOREIGN KEY (AssignedByPersonID) REFERENCES __mj_BizAppsCommon.Person(ID),
    CONSTRAINT CK_ActionItem_Priority CHECK (Priority IN ('Low', 'Medium', 'High', 'Critical')),
    CONSTRAINT CK_ActionItem_Status CHECK (Status IN ('Open', 'InProgress', 'Blocked', 'Completed', 'Cancelled'))
);
GO

---------------------------------------------------------------------------
-- Artifact types with optional extension entity support
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'ArtifactType')
CREATE TABLE __mj_Committees.ArtifactType (
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
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'Artifact')
CREATE TABLE __mj_Committees.Artifact (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    CommitteeID UNIQUEIDENTIFIER,
    MeetingID UNIQUEIDENTIFIER,
    AgendaItemID UNIQUEIDENTIFIER,
    ActionItemID UNIQUEIDENTIFIER,
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
    CONSTRAINT FK_Artifact_Committee FOREIGN KEY (CommitteeID) REFERENCES __mj_Committees.Committee(ID),
    CONSTRAINT FK_Artifact_Meeting FOREIGN KEY (MeetingID) REFERENCES __mj_Committees.Meeting(ID),
    CONSTRAINT FK_Artifact_AgendaItem FOREIGN KEY (AgendaItemID) REFERENCES __mj_Committees.AgendaItem(ID),
    CONSTRAINT FK_Artifact_ActionItem FOREIGN KEY (ActionItemID) REFERENCES __mj_Committees.ActionItem(ID),
    CONSTRAINT FK_Artifact_ArtifactType FOREIGN KEY (ArtifactTypeID) REFERENCES __mj_Committees.ArtifactType(ID),
    CONSTRAINT FK_Artifact_UploadedBy FOREIGN KEY (UploadedByPersonID) REFERENCES __mj_BizAppsCommon.Person(ID),
    CONSTRAINT CK_Artifact_Provider CHECK (Provider IN ('GoogleDrive', 'SharePoint', 'Box', 'OneDrive', 'Dropbox', 'URL'))
);
GO

---------------------------------------------------------------------------
-- Minutes extension (1:1 with Artifact for Minutes type)
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'Minute')
CREATE TABLE __mj_Committees.Minute (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    ArtifactID UNIQUEIDENTIFIER NOT NULL,
    ApprovalStatus NVARCHAR(50) NOT NULL DEFAULT 'Draft',
    ApprovedAt DATETIMEOFFSET,
    ApprovedByMeetingID UNIQUEIDENTIFIER,
    Notes NVARCHAR(MAX),
    CONSTRAINT PK_Minute PRIMARY KEY (ID),
    CONSTRAINT FK_Minute_Artifact FOREIGN KEY (ArtifactID) REFERENCES __mj_Committees.Artifact(ID),
    CONSTRAINT FK_Minute_ApprovedByMeeting FOREIGN KEY (ApprovedByMeetingID) REFERENCES __mj_Committees.Meeting(ID),
    CONSTRAINT UQ_Minute_Artifact UNIQUE (ArtifactID),
    CONSTRAINT CK_Minute_ApprovalStatus CHECK (ApprovalStatus IN ('Draft', 'PendingApproval', 'Approved', 'Rejected'))
);
GO

---------------------------------------------------------------------------
-- Motions put to vote during meetings
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'Motion')
CREATE TABLE __mj_Committees.Motion (
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
    CONSTRAINT FK_Motion_Meeting FOREIGN KEY (MeetingID) REFERENCES __mj_Committees.Meeting(ID),
    CONSTRAINT FK_Motion_AgendaItem FOREIGN KEY (AgendaItemID) REFERENCES __mj_Committees.AgendaItem(ID),
    CONSTRAINT FK_Motion_MovedBy FOREIGN KEY (MovedByMembershipID) REFERENCES __mj_Committees.Membership(ID),
    CONSTRAINT FK_Motion_SecondedBy FOREIGN KEY (SecondedByMembershipID) REFERENCES __mj_Committees.Membership(ID),
    CONSTRAINT CK_Motion_Result CHECK (Result IN ('Pending', 'Passed', 'Failed', 'Tabled', 'Withdrawn'))
);
GO

---------------------------------------------------------------------------
-- Individual vote records per motion
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'Vote')
CREATE TABLE __mj_Committees.Vote (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    MotionID UNIQUEIDENTIFIER NOT NULL,
    MembershipID UNIQUEIDENTIFIER NOT NULL,
    VoteValue NVARCHAR(20) NOT NULL,
    Notes NVARCHAR(500),
    CONSTRAINT PK_Vote PRIMARY KEY (ID),
    CONSTRAINT FK_Vote_Motion FOREIGN KEY (MotionID) REFERENCES __mj_Committees.Motion(ID),
    CONSTRAINT FK_Vote_Membership FOREIGN KEY (MembershipID) REFERENCES __mj_Committees.Membership(ID),
    CONSTRAINT CK_Vote_Value CHECK (VoteValue IN ('Yes', 'No', 'Abstain', 'Absent')),
    CONSTRAINT UQ_Vote UNIQUE (MotionID, MembershipID)
);
GO

---------------------------------------------------------------------------
-- EXTENDED PROPERTIES: Schema
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties ep INNER JOIN sys.schemas s ON ep.major_id = s.schema_id WHERE s.name = '__mj_Committees' AND ep.minor_id = 0 AND ep.name = 'MS_Description' AND ep.class = 3)
    EXEC sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'Committee management app for governance, meetings, and action tracking',
        @level0type = N'SCHEMA', @level0name = N'__mj_Committees';
GO

---------------------------------------------------------------------------
-- EXTENDED PROPERTIES: Type table
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('__mj_Committees.Type') AND minor_id = 0 AND name = 'MS_Description')
BEGIN
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Categories of committees such as Board, Standing, Ad Hoc, Workgroup', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Type';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Display name for the committee type', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Type', @level2type = N'COLUMN', @level2name = N'Name';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Detailed description of this committee type', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Type', @level2type = N'COLUMN', @level2name = N'Description';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Whether this type is for standards development committees', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Type', @level2type = N'COLUMN', @level2name = N'IsStandards';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Default term length in months for committees of this type', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Type', @level2type = N'COLUMN', @level2name = N'DefaultTermMonths';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Font Awesome icon class for UI display', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Type', @level2type = N'COLUMN', @level2name = N'IconClass';
END
GO

---------------------------------------------------------------------------
-- EXTENDED PROPERTIES: Committee table
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('__mj_Committees.Committee') AND minor_id = 0 AND name = 'MS_Description')
BEGIN
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Core committee records with hierarchy support', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Committee';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Official name of the committee', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Committee', @level2type = N'COLUMN', @level2name = N'Name';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Detailed description of the committee purpose and scope', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Committee', @level2type = N'COLUMN', @level2name = N'Description';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'URL to the committee charter document', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Committee', @level2type = N'COLUMN', @level2name = N'CharterDocumentURL';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Brief statement of the committee mission', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Committee', @level2type = N'COLUMN', @level2name = N'MissionStatement';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Current status: Active, Inactive, Pending, or Dissolved', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Committee', @level2type = N'COLUMN', @level2name = N'Status';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Whether the committee is visible to all users', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Committee', @level2type = N'COLUMN', @level2name = N'IsPublic';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Date the committee was formed', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Committee', @level2type = N'COLUMN', @level2name = N'FormationDate';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Date the committee was dissolved, if applicable', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Committee', @level2type = N'COLUMN', @level2name = N'DissolutionDate';
END
GO

---------------------------------------------------------------------------
-- EXTENDED PROPERTIES: Term table
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('__mj_Committees.Term') AND minor_id = 0 AND name = 'MS_Description')
BEGIN
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Time periods for committee membership cycles', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Term';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Display name for the term, e.g. 2025-2026', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Term', @level2type = N'COLUMN', @level2name = N'Name';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Start date of the term', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Term', @level2type = N'COLUMN', @level2name = N'StartDate';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'End date of the term', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Term', @level2type = N'COLUMN', @level2name = N'EndDate';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Current status: Active, Upcoming, or Completed', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Term', @level2type = N'COLUMN', @level2name = N'Status';
END
GO

---------------------------------------------------------------------------
-- EXTENDED PROPERTIES: Role table
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('__mj_Committees.Role') AND minor_id = 0 AND name = 'MS_Description')
BEGIN
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Roles that members can hold on committees', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Role';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Display name for the role', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Role', @level2type = N'COLUMN', @level2name = N'Name';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Detailed description of role responsibilities', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Role', @level2type = N'COLUMN', @level2name = N'Description';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Whether this is an officer role like Chair or Secretary', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Role', @level2type = N'COLUMN', @level2name = N'IsOfficer';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Whether members in this role can vote', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Role', @level2type = N'COLUMN', @level2name = N'IsVotingRole';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'JSON object defining default permissions for this role', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Role', @level2type = N'COLUMN', @level2name = N'DefaultPermissionsJSON';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Display order for sorting roles', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Role', @level2type = N'COLUMN', @level2name = N'Sequence';
END
GO

---------------------------------------------------------------------------
-- EXTENDED PROPERTIES: Membership table
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('__mj_Committees.Membership') AND minor_id = 0 AND name = 'MS_Description')
BEGIN
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Person assignments to committees with roles and terms', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Membership';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Date the membership started', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Membership', @level2type = N'COLUMN', @level2name = N'StartDate';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Date the membership ended, if applicable', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Membership', @level2type = N'COLUMN', @level2name = N'EndDate';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Current status: Active, Pending, Ended, or Suspended', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Membership', @level2type = N'COLUMN', @level2name = N'Status';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Reason the membership ended: Term ended, Resigned, Removed, etc.', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Membership', @level2type = N'COLUMN', @level2name = N'EndReason';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Additional notes about this membership', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Membership', @level2type = N'COLUMN', @level2name = N'Notes';
END
GO

---------------------------------------------------------------------------
-- EXTENDED PROPERTIES: Meeting table
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('__mj_Committees.Meeting') AND minor_id = 0 AND name = 'MS_Description')
BEGIN
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Committee meeting records with scheduling and video conferencing info', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Meeting';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Title of the meeting', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'Title';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Detailed description or purpose of the meeting', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'Description';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Scheduled start date and time with timezone offset', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'StartDateTime';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Scheduled end date and time with timezone offset', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'EndDateTime';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'IANA timezone identifier for the meeting', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'TimeZone';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Meeting format: Virtual, InPerson, or Hybrid', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'LocationType';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Physical address or room name for in-person meetings', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'LocationText';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Video conferencing provider: Zoom, Teams, Meet, etc.', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'VideoProvider';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'External meeting ID from the video provider', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'VideoMeetingID';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'URL to join the video meeting', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'VideoJoinURL';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'URL to the meeting recording after completion', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'VideoRecordingURL';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'URL to the meeting transcript', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'TranscriptURL';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Current status: Draft, Scheduled, InProgress, Completed, Cancelled, Postponed', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'Status';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'External calendar event ID for sync purposes', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'CalendarEventID';
END
GO

---------------------------------------------------------------------------
-- EXTENDED PROPERTIES: AgendaItem table
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('__mj_Committees.AgendaItem') AND minor_id = 0 AND name = 'MS_Description')
BEGIN
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Structured agenda items for meetings with hierarchy support', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'AgendaItem';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Display order within the meeting agenda', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'AgendaItem', @level2type = N'COLUMN', @level2name = N'Sequence';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Title of the agenda item', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'AgendaItem', @level2type = N'COLUMN', @level2name = N'Title';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Detailed description of the agenda item', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'AgendaItem', @level2type = N'COLUMN', @level2name = N'Description';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Estimated duration in minutes', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'AgendaItem', @level2type = N'COLUMN', @level2name = N'DurationMinutes';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Type of item: Information, Discussion, Action, Vote, Report, Other', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'AgendaItem', @level2type = N'COLUMN', @level2name = N'ItemType';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'URL to related document for this item', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'AgendaItem', @level2type = N'COLUMN', @level2name = N'RelatedDocumentURL';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Current status: Pending, Discussed, Tabled, Completed, Skipped', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'AgendaItem', @level2type = N'COLUMN', @level2name = N'Status';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Discussion notes and outcomes captured during the meeting', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'AgendaItem', @level2type = N'COLUMN', @level2name = N'Notes';
END
GO

---------------------------------------------------------------------------
-- EXTENDED PROPERTIES: Attendance table
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('__mj_Committees.Attendance') AND minor_id = 0 AND name = 'MS_Description')
BEGIN
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Meeting attendance records for committee members', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Attendance';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Attendance status: Expected, Present, Absent, Excused, Partial', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Attendance', @level2type = N'COLUMN', @level2name = N'AttendanceStatus';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp when the attendee joined the meeting', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Attendance', @level2type = N'COLUMN', @level2name = N'JoinedAt';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp when the attendee left the meeting', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Attendance', @level2type = N'COLUMN', @level2name = N'LeftAt';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Additional notes about attendance', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Attendance', @level2type = N'COLUMN', @level2name = N'Notes';
END
GO

---------------------------------------------------------------------------
-- EXTENDED PROPERTIES: ActionItem table
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('__mj_Committees.ActionItem') AND minor_id = 0 AND name = 'MS_Description')
BEGIN
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tasks and action items assigned from committees or meetings', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'ActionItem';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Title of the action item', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'ActionItem', @level2type = N'COLUMN', @level2name = N'Title';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Detailed description of what needs to be done', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'ActionItem', @level2type = N'COLUMN', @level2name = N'Description';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Due date for completion', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'ActionItem', @level2type = N'COLUMN', @level2name = N'DueDate';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Priority level: Low, Medium, High, Critical', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'ActionItem', @level2type = N'COLUMN', @level2name = N'Priority';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Current status: Open, InProgress, Blocked, Completed, Cancelled', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'ActionItem', @level2type = N'COLUMN', @level2name = N'Status';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp when the action item was completed', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'ActionItem', @level2type = N'COLUMN', @level2name = N'CompletedAt';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Notes about how the item was completed', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'ActionItem', @level2type = N'COLUMN', @level2name = N'CompletionNotes';
END
GO

---------------------------------------------------------------------------
-- EXTENDED PROPERTIES: ArtifactType table
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('__mj_Committees.ArtifactType') AND minor_id = 0 AND name = 'MS_Description')
BEGIN
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Categories of committee artifacts with optional extension entity for type-specific fields', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'ArtifactType';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Display name for the artifact type', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'ArtifactType', @level2type = N'COLUMN', @level2name = N'Name';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Detailed description of this artifact type', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'ArtifactType', @level2type = N'COLUMN', @level2name = N'Description';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Optional reference to an MJ Entity that provides additional fields for this artifact type via a 1:1 extension table', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'ArtifactType', @level2type = N'COLUMN', @level2name = N'ExtendedEntityID';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Font Awesome icon class for UI display', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'ArtifactType', @level2type = N'COLUMN', @level2name = N'IconClass';
END
GO

---------------------------------------------------------------------------
-- EXTENDED PROPERTIES: Artifact table
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('__mj_Committees.Artifact') AND minor_id = 0 AND name = 'MS_Description')
BEGIN
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Links to external documents and files from various providers', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Artifact';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Display title for the artifact', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Artifact', @level2type = N'COLUMN', @level2name = N'Title';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Description of the artifact contents', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Artifact', @level2type = N'COLUMN', @level2name = N'Description';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Storage provider: GoogleDrive, SharePoint, Box, OneDrive, Dropbox, URL', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Artifact', @level2type = N'COLUMN', @level2name = N'Provider';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Provider-specific document or file ID', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Artifact', @level2type = N'COLUMN', @level2name = N'ExternalID';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Direct URL to access the artifact', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Artifact', @level2type = N'COLUMN', @level2name = N'URL';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'MIME type of the file', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Artifact', @level2type = N'COLUMN', @level2name = N'MimeType';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'File size in bytes', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Artifact', @level2type = N'COLUMN', @level2name = N'FileSize';
END
GO

---------------------------------------------------------------------------
-- EXTENDED PROPERTIES: Minute table
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('__mj_Committees.Minute') AND minor_id = 0 AND name = 'MS_Description')
BEGIN
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Extension entity for Minutes artifacts with approval tracking', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Minute';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Current approval status: Draft, PendingApproval, Approved, Rejected', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Minute', @level2type = N'COLUMN', @level2name = N'ApprovalStatus';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp when the minutes were approved', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Minute', @level2type = N'COLUMN', @level2name = N'ApprovedAt';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Reference to the meeting at which these minutes were approved (typically the next meeting)', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Minute', @level2type = N'COLUMN', @level2name = N'ApprovedByMeetingID';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Additional notes about the minutes', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Minute', @level2type = N'COLUMN', @level2name = N'Notes';
END
GO

---------------------------------------------------------------------------
-- EXTENDED PROPERTIES: Motion table
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('__mj_Committees.Motion') AND minor_id = 0 AND name = 'MS_Description')
BEGIN
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Formal motions put to vote during committee meetings', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Motion';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Display order when multiple motions exist for the same agenda item', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Motion', @level2type = N'COLUMN', @level2name = N'Sequence';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Title of the motion', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Motion', @level2type = N'COLUMN', @level2name = N'Title';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Full text or description of the motion', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Motion', @level2type = N'COLUMN', @level2name = N'Description';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'The committee member who made the motion', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Motion', @level2type = N'COLUMN', @level2name = N'MovedByMembershipID';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'The committee member who seconded the motion', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Motion', @level2type = N'COLUMN', @level2name = N'SecondedByMembershipID';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Outcome of the vote: Pending, Passed, Failed, Tabled, Withdrawn', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Motion', @level2type = N'COLUMN', @level2name = N'Result';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Human-readable vote tally, e.g. 7-2-1 or Passed unanimously', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Motion', @level2type = N'COLUMN', @level2name = N'ResultSummary';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Number of Yes votes', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Motion', @level2type = N'COLUMN', @level2name = N'YesCount';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Number of No votes', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Motion', @level2type = N'COLUMN', @level2name = N'NoCount';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Number of Abstain votes', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Motion', @level2type = N'COLUMN', @level2name = N'AbstainCount';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Additional notes about the motion or vote', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Motion', @level2type = N'COLUMN', @level2name = N'Notes';
END
GO

---------------------------------------------------------------------------
-- EXTENDED PROPERTIES: Vote table
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('__mj_Committees.Vote') AND minor_id = 0 AND name = 'MS_Description')
BEGIN
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Individual vote records for committee motions', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Vote';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'The vote cast: Yes, No, Abstain, or Absent', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Vote', @level2type = N'COLUMN', @level2name = N'VoteValue';
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Optional notes explaining the vote', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Vote', @level2type = N'COLUMN', @level2name = N'Notes';
END
GO

---------------------------------------------------------------------------
-- SEED DATA: Managed via metadata/ folder using mj-sync tool
-- Run: npx mj-sync push --dir ./metadata
-- See metadata/ for committee-types, roles, and artifact-types
---------------------------------------------------------------------------
