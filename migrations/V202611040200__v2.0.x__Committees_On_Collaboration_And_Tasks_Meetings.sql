-- =============================================================================
-- BizAppsCommittees v2.0.x — C4 Rebuild on Collaboration and Tasks Meetings
-- =============================================================================
-- 1. Committee and Term become disjoint IsA subtypes of __mj_BizAppsCollaboration.Space:
--    - Committee drops Name, Description, ParentCommitteeID, FormationDate, DissolutionDate
--      and adds FK_Committee_Space (ID -> __mj_BizAppsCollaboration.Space.ID).
--    - Term drops Name, StartDate, EndDate, CommitteeID
--      and adds FK_Term_Space (ID -> __mj_BizAppsCollaboration.Space.ID).
-- 2. Meeting, AgendaItem, Attendance, and VideoProvider are dropped from
--    __mj_BizAppsCommittees (superseded by __mj_BizAppsTasks.Meeting,
--    MeetingAgendaItem, MeetingAttendee, MeetingLink, VideoProvider).
-- 3. Minute, Motion, Artifact, and Comment repoint their MeetingID,
--    ApprovedByMeetingID, and AgendaItemID foreign keys to
--    __mj_BizAppsTasks.Meeting and __mj_BizAppsTasks.MeetingAgendaItem.
-- 4. No data is carried over (major version 2.0.0).
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Breaking-change upgrade guard & clear existing rows in dependency order
--    BREAKING CHANGE (v2.0): Committee and Term become IS-A subtypes of
--    __mj_BizAppsCollaboration.Space and Committee Meetings move to Tasks
--    Meetings. Refuse to run if the Committee table already contains rows so a
--    2.0 upgrade cannot silently empty a populated host.
-- -----------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[Committee])
    THROW 50000, 'Committees 2.0 requires an empty Committee table because Committee and Term become IS-A subtypes of Collaboration Space. Back up and clear or migrate existing Committee rows before applying this migration.', 1;
GO

DELETE FROM [${flyway:defaultSchema}].[Vote];
DELETE FROM [${flyway:defaultSchema}].[Ballot];
DELETE FROM [${flyway:defaultSchema}].[Motion];
DELETE FROM [${flyway:defaultSchema}].[Minute];
DELETE FROM [${flyway:defaultSchema}].[Comment];
DELETE FROM [${flyway:defaultSchema}].[Artifact];
IF OBJECT_ID('[${flyway:defaultSchema}].[Attendance]', 'U') IS NOT NULL
    EXEC('DELETE FROM [${flyway:defaultSchema}].[Attendance]');
IF OBJECT_ID('[${flyway:defaultSchema}].[AgendaItem]', 'U') IS NOT NULL
    EXEC('DELETE FROM [${flyway:defaultSchema}].[AgendaItem]');
IF OBJECT_ID('[${flyway:defaultSchema}].[Meeting]', 'U') IS NOT NULL
    EXEC('DELETE FROM [${flyway:defaultSchema}].[Meeting]');
DELETE FROM [${flyway:defaultSchema}].[Membership];
DELETE FROM [${flyway:defaultSchema}].[Term];
DELETE FROM [${flyway:defaultSchema}].[Committee];
IF OBJECT_ID('[${flyway:defaultSchema}].[VideoProvider]', 'U') IS NOT NULL
    EXEC('DELETE FROM [${flyway:defaultSchema}].[VideoProvider]');
GO

-- -----------------------------------------------------------------------------
-- 2. Drop foreign keys referencing Committee, Term, Meeting, AgendaItem,
--    Attendance, and VideoProvider
-- -----------------------------------------------------------------------------
ALTER TABLE [${flyway:defaultSchema}].[Artifact] DROP CONSTRAINT IF EXISTS [FK_Artifact_Committee];
ALTER TABLE [${flyway:defaultSchema}].[Artifact] DROP CONSTRAINT IF EXISTS [FK_Artifact_Meeting];
ALTER TABLE [${flyway:defaultSchema}].[Artifact] DROP CONSTRAINT IF EXISTS [FK_Artifact_AgendaItem];

ALTER TABLE [${flyway:defaultSchema}].[Ballot] DROP CONSTRAINT IF EXISTS [FK_Ballot_Committee];

ALTER TABLE [${flyway:defaultSchema}].[Comment] DROP CONSTRAINT IF EXISTS [FK_Comment_Committee];
ALTER TABLE [${flyway:defaultSchema}].[Comment] DROP CONSTRAINT IF EXISTS [FK_Comment_Meeting];
ALTER TABLE [${flyway:defaultSchema}].[Comment] DROP CONSTRAINT IF EXISTS [FK_Comment_AgendaItem];

ALTER TABLE [${flyway:defaultSchema}].[Minute] DROP CONSTRAINT IF EXISTS [FK_Minute_Meeting];
ALTER TABLE [${flyway:defaultSchema}].[Minute] DROP CONSTRAINT IF EXISTS [FK_Minute_ApprovedByMeeting];

ALTER TABLE [${flyway:defaultSchema}].[Motion] DROP CONSTRAINT IF EXISTS [FK_Motion_Meeting];
ALTER TABLE [${flyway:defaultSchema}].[Motion] DROP CONSTRAINT IF EXISTS [FK_Motion_AgendaItem];

ALTER TABLE [${flyway:defaultSchema}].[Membership] DROP CONSTRAINT IF EXISTS [FK_Membership_Term];
GO

-- -----------------------------------------------------------------------------
-- 3. Drop legacy Attendance, AgendaItem, Meeting, and VideoProvider objects
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS [${flyway:defaultSchema}].[spCreateAttendance];
DROP PROCEDURE IF EXISTS [${flyway:defaultSchema}].[spUpdateAttendance];
DROP PROCEDURE IF EXISTS [${flyway:defaultSchema}].[spDeleteAttendance];
DROP VIEW IF EXISTS [${flyway:defaultSchema}].[vwAttendances];
DROP TABLE IF EXISTS [${flyway:defaultSchema}].[Attendance];

DROP PROCEDURE IF EXISTS [${flyway:defaultSchema}].[spCreateAgendaItem];
DROP PROCEDURE IF EXISTS [${flyway:defaultSchema}].[spUpdateAgendaItem];
DROP PROCEDURE IF EXISTS [${flyway:defaultSchema}].[spDeleteAgendaItem];
DROP VIEW IF EXISTS [${flyway:defaultSchema}].[vwAgendaItems];
DROP TABLE IF EXISTS [${flyway:defaultSchema}].[AgendaItem];

DROP PROCEDURE IF EXISTS [${flyway:defaultSchema}].[spCreateMeeting];
DROP PROCEDURE IF EXISTS [${flyway:defaultSchema}].[spUpdateMeeting];
DROP PROCEDURE IF EXISTS [${flyway:defaultSchema}].[spDeleteMeeting];
DROP VIEW IF EXISTS [${flyway:defaultSchema}].[vwMeetings];
DROP VIEW IF EXISTS [${flyway:defaultSchema}].[vwMeetingsGenerated];
DROP TABLE IF EXISTS [${flyway:defaultSchema}].[Meeting];

DROP PROCEDURE IF EXISTS [${flyway:defaultSchema}].[spCreateVideoProvider];
DROP PROCEDURE IF EXISTS [${flyway:defaultSchema}].[spUpdateVideoProvider];
DROP PROCEDURE IF EXISTS [${flyway:defaultSchema}].[spDeleteVideoProvider];
DROP VIEW IF EXISTS [${flyway:defaultSchema}].[vwVideoProviders];
DROP TABLE IF EXISTS [${flyway:defaultSchema}].[VideoProvider];
GO

-- -----------------------------------------------------------------------------
-- 4. Remove MJ Entity metadata for dropped tables
--    - Committees: Attendances      (E7D9813E-3C34-4233-AFCC-4CB76CFE081C)
--    - Committees: Agenda Items     (D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8)
--    - Committees: Meetings         (F7DEBA2D-4E28-4C6E-971B-6099217FAB29)
--    - Committees: Video Providers  (F11B4DC5-9850-4782-B3A1-7D2277A19837)
-- -----------------------------------------------------------------------------
DECLARE @DroppedEntities TABLE ([ID] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY);
INSERT INTO @DroppedEntities ([ID]) VALUES
    ('E7D9813E-3C34-4233-AFCC-4CB76CFE081C'),
    ('D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8'),
    ('F7DEBA2D-4E28-4C6E-971B-6099217FAB29'),
    ('F11B4DC5-9850-4782-B3A1-7D2277A19837');

UPDATE [${flyway:defaultSchema}].[ArtifactType]
   SET [ExtendedEntityID] = NULL
 WHERE [ExtendedEntityID] IN (SELECT [ID] FROM @DroppedEntities);

-- Clear RelatedEntityID referencing dropped entities so CodeGen's spUpdateExistingEntityFieldsFromSchema
-- discovers the new foreign keys to MJ_BizApps_Tasks: Meetings and Meeting Agenda Items and marks
-- Minutes, Motions, Artifacts, and Comments as modified for view/SP regeneration.
UPDATE [${mjSchema}].[EntityField]
   SET [RelatedEntityID] = NULL,
       [RelatedEntityFieldName] = NULL
 WHERE [RelatedEntityID] IN (SELECT [ID] FROM @DroppedEntities)
   AND [EntityID] NOT IN (SELECT [ID] FROM @DroppedEntities);

DELETE efv
  FROM [${mjSchema}].[EntityFieldValue] efv
  INNER JOIN [${mjSchema}].[EntityField] ef ON efv.[EntityFieldID] = ef.[ID]
 WHERE ef.[EntityID] IN (SELECT [ID] FROM @DroppedEntities);

DELETE FROM [${mjSchema}].[EntityField]
 WHERE [EntityID] IN (SELECT [ID] FROM @DroppedEntities);

DELETE FROM [${mjSchema}].[EntityRelationship]
 WHERE [EntityID] IN (SELECT [ID] FROM @DroppedEntities)
    OR [RelatedEntityID] IN (SELECT [ID] FROM @DroppedEntities);

DELETE FROM [${mjSchema}].[EntityPermission]
 WHERE [EntityID] IN (SELECT [ID] FROM @DroppedEntities);

DELETE FROM [${mjSchema}].[RecordChange]
 WHERE [EntityID] IN (SELECT [ID] FROM @DroppedEntities);

DELETE FROM [${mjSchema}].[UserApplicationEntity]
 WHERE [EntityID] IN (SELECT [ID] FROM @DroppedEntities);

DELETE FROM [${mjSchema}].[ApplicationEntity]
 WHERE [EntityID] IN (SELECT [ID] FROM @DroppedEntities);

DELETE FROM [${mjSchema}].[MLModelScoringBinding]
 WHERE [TargetEntityID] IN (SELECT [ID] FROM @DroppedEntities);

DELETE FROM [${mjSchema}].[MLModel]
 WHERE [PipelineID] IN (
     SELECT [ID] FROM [${mjSchema}].[MLTrainingPipeline]
      WHERE [TargetEntityID] IN (SELECT [ID] FROM @DroppedEntities)
 );

DELETE FROM [${mjSchema}].[MLTrainingPipeline]
 WHERE [TargetEntityID] IN (SELECT [ID] FROM @DroppedEntities);

DELETE FROM [${mjSchema}].[RecordProcess]
 WHERE [EntityID] IN (SELECT [ID] FROM @DroppedEntities);

DELETE FROM [${mjSchema}].[Entity]
 WHERE [ID] IN (SELECT [ID] FROM @DroppedEntities);
GO

-- -----------------------------------------------------------------------------
-- 5. Recreate Committee and Term as IsA subtypes of __mj_BizAppsCollaboration.Space
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS [${flyway:defaultSchema}].[spCreateTerm];
DROP PROCEDURE IF EXISTS [${flyway:defaultSchema}].[spUpdateTerm];
DROP PROCEDURE IF EXISTS [${flyway:defaultSchema}].[spDeleteTerm];
DROP VIEW IF EXISTS [${flyway:defaultSchema}].[vwTerms];
DROP TABLE IF EXISTS [${flyway:defaultSchema}].[Term];

DROP PROCEDURE IF EXISTS [${flyway:defaultSchema}].[spCreateCommittee];
DROP PROCEDURE IF EXISTS [${flyway:defaultSchema}].[spUpdateCommittee];
DROP PROCEDURE IF EXISTS [${flyway:defaultSchema}].[spDeleteCommittee];
DROP VIEW IF EXISTS [${flyway:defaultSchema}].[vwCommittees];
DROP TABLE IF EXISTS [${flyway:defaultSchema}].[Committee];
GO

CREATE TABLE [${flyway:defaultSchema}].[Committee] (
    [ID] UNIQUEIDENTIFIER NOT NULL,
    [TypeID] UNIQUEIDENTIFIER NOT NULL,
    [OrganizationID] UNIQUEIDENTIFIER NULL,
    [CharterDocumentURL] NVARCHAR(1000) NULL,
    [MissionStatement] NVARCHAR(MAX) NULL,
    [Status] NVARCHAR(50) NOT NULL CONSTRAINT [DF_Committee_Status] DEFAULT (N'Active'),
    [IsPublic] BIT NOT NULL CONSTRAINT [DF_Committee_IsPublic] DEFAULT ((1)),
    [__mj_CreatedAt] DATETIMEOFFSET(7) NOT NULL CONSTRAINT [DF___mj_BizAppsCommittees_Committee___mj_CreatedAt] DEFAULT (getutcdate()),
    [__mj_UpdatedAt] DATETIMEOFFSET(7) NOT NULL CONSTRAINT [DF___mj_BizAppsCommittees_Committee___mj_UpdatedAt] DEFAULT (getutcdate()),
    CONSTRAINT [PK_Committee] PRIMARY KEY CLUSTERED ([ID]),
    CONSTRAINT [FK_Committee_Space] FOREIGN KEY ([ID]) REFERENCES [__mj_BizAppsCollaboration].[Space]([ID]),
    CONSTRAINT [FK_Committee_Type] FOREIGN KEY ([TypeID]) REFERENCES [${flyway:defaultSchema}].[Type]([ID]),
    CONSTRAINT [FK_Committee_Organization] FOREIGN KEY ([OrganizationID]) REFERENCES [__mj_BizAppsCommon].[Organization]([ID]),
    CONSTRAINT [CK_Committee_Status] CHECK ([Status] IN (N'Active', N'Inactive', N'Pending', N'Dissolved'))
);
GO

CREATE TABLE [${flyway:defaultSchema}].[Term] (
    [ID] UNIQUEIDENTIFIER NOT NULL,
    [Status] NVARCHAR(50) NOT NULL CONSTRAINT [DF_Term_Status] DEFAULT (N'Active'),
    [__mj_CreatedAt] DATETIMEOFFSET(7) NOT NULL CONSTRAINT [DF___mj_BizAppsCommittees_Term___mj_CreatedAt] DEFAULT (getutcdate()),
    [__mj_UpdatedAt] DATETIMEOFFSET(7) NOT NULL CONSTRAINT [DF___mj_BizAppsCommittees_Term___mj_UpdatedAt] DEFAULT (getutcdate()),
    CONSTRAINT [PK_Term] PRIMARY KEY CLUSTERED ([ID]),
    CONSTRAINT [FK_Term_Space] FOREIGN KEY ([ID]) REFERENCES [__mj_BizAppsCollaboration].[Space]([ID]),
    CONSTRAINT [CK_Term_Status] CHECK ([Status] IN (N'Active', N'Upcoming', N'Completed'))
);
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Core committee governance record: an IsA subtype of __mj_BizAppsCollaboration.Space sharing Space.ID.', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Committee';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'The Collaboration Space this committee specializes (same value as Space.ID).', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Committee', @level2type = N'COLUMN', @level2name = N'ID';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Foreign key to committee type classification.', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Committee', @level2type = N'COLUMN', @level2name = N'TypeID';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Foreign key to the sponsoring organization in BizAppsCommon.', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Committee', @level2type = N'COLUMN', @level2name = N'OrganizationID';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'URL to the committee charter document.', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Committee', @level2type = N'COLUMN', @level2name = N'CharterDocumentURL';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Formal mission statement of the committee.', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Committee', @level2type = N'COLUMN', @level2name = N'MissionStatement';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Lifecycle status: Active, Inactive, Pending, Dissolved.', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Committee', @level2type = N'COLUMN', @level2name = N'Status';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Whether the committee is publicly visible (maps to Space.Discoverability Listed vs Hidden).', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Committee', @level2type = N'COLUMN', @level2name = N'IsPublic';

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Committee term cycle: an IsA subtype of __mj_BizAppsCollaboration.Space sharing Space.ID, parented under the Committee Space via Space.ParentID.', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Term';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'The Collaboration Space this term specializes (same value as Space.ID).', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Term', @level2type = N'COLUMN', @level2name = N'ID';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Term status: Active, Upcoming, Completed.', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Term', @level2type = N'COLUMN', @level2name = N'Status';
GO

-- -----------------------------------------------------------------------------
-- 6. Re-bind Foreign Keys to Committee, Term, and Tasks' Meeting & MeetingAgendaItem
-- -----------------------------------------------------------------------------
ALTER TABLE [${flyway:defaultSchema}].[Membership]
    ADD CONSTRAINT [FK_Membership_Term] FOREIGN KEY ([TermID]) REFERENCES [${flyway:defaultSchema}].[Term]([ID]);

ALTER TABLE [${flyway:defaultSchema}].[Artifact]
    ADD CONSTRAINT [FK_Artifact_Committee] FOREIGN KEY ([CommitteeID]) REFERENCES [${flyway:defaultSchema}].[Committee]([ID]),
        CONSTRAINT [FK_Artifact_Meeting] FOREIGN KEY ([MeetingID]) REFERENCES [__mj_BizAppsTasks].[Meeting]([ID]),
        CONSTRAINT [FK_Artifact_AgendaItem] FOREIGN KEY ([AgendaItemID]) REFERENCES [__mj_BizAppsTasks].[MeetingAgendaItem]([ID]);

ALTER TABLE [${flyway:defaultSchema}].[Minute]
    ADD CONSTRAINT [FK_Minute_Meeting] FOREIGN KEY ([MeetingID]) REFERENCES [__mj_BizAppsTasks].[Meeting]([ID]),
        CONSTRAINT [FK_Minute_ApprovedByMeeting] FOREIGN KEY ([ApprovedByMeetingID]) REFERENCES [__mj_BizAppsTasks].[Meeting]([ID]);

ALTER TABLE [${flyway:defaultSchema}].[Motion]
    ADD CONSTRAINT [FK_Motion_Meeting] FOREIGN KEY ([MeetingID]) REFERENCES [__mj_BizAppsTasks].[Meeting]([ID]),
        CONSTRAINT [FK_Motion_AgendaItem] FOREIGN KEY ([AgendaItemID]) REFERENCES [__mj_BizAppsTasks].[MeetingAgendaItem]([ID]);

ALTER TABLE [${flyway:defaultSchema}].[Ballot]
    ADD CONSTRAINT [FK_Ballot_Committee] FOREIGN KEY ([CommitteeID]) REFERENCES [${flyway:defaultSchema}].[Committee]([ID]);

ALTER TABLE [${flyway:defaultSchema}].[Comment]
    ADD CONSTRAINT [FK_Comment_Committee] FOREIGN KEY ([CommitteeID]) REFERENCES [${flyway:defaultSchema}].[Committee]([ID]),
        CONSTRAINT [FK_Comment_Meeting] FOREIGN KEY ([MeetingID]) REFERENCES [__mj_BizAppsTasks].[Meeting]([ID]),
        CONSTRAINT [FK_Comment_AgendaItem] FOREIGN KEY ([AgendaItemID]) REFERENCES [__mj_BizAppsTasks].[MeetingAgendaItem]([ID]);
GO

-- -----------------------------------------------------------------------------
-- 7. Prepare MJ Entity metadata for IsA ParentID and clean up dropped fields
--    before CodeGen section
-- -----------------------------------------------------------------------------
UPDATE [${mjSchema}].[Entity]
   SET [ParentID] = '3648DC35-1DC4-4ED6-A1A6-5D87271A54DB'
 WHERE [ID] IN ('A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', '87BEDFA6-F149-4AF2-993C-81BD01169584');

DELETE efv
  FROM [${mjSchema}].[EntityFieldValue] efv
  INNER JOIN [${mjSchema}].[EntityField] ef ON efv.[EntityFieldID] = ef.[ID]
 WHERE (ef.[EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND ef.[Name] IN ('ParentCommitteeID', 'FormationDate', 'DissolutionDate', 'ParentCommittee'))
    OR (ef.[EntityID] = '87BEDFA6-F149-4AF2-993C-81BD01169584' AND ef.[Name] IN ('CommitteeID', 'StartDate', 'EndDate', 'Committee'));

DELETE FROM [${mjSchema}].[EntityField]
 WHERE ([EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND [Name] IN ('ParentCommitteeID', 'FormationDate', 'DissolutionDate', 'ParentCommittee'))
    OR ([EntityID] = '87BEDFA6-F149-4AF2-993C-81BD01169584' AND [Name] IN ('CommitteeID', 'StartDate', 'EndDate', 'Committee'));

UPDATE [${mjSchema}].[EntityField]
   SET [IsVirtual] = 1
 WHERE ([EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND [Name] IN ('Name', 'Description'))
    OR ([EntityID] = '87BEDFA6-F149-4AF2-993C-81BD01169584' AND [Name] IN ('Name'));

DELETE FROM [${mjSchema}].[EntityRelationship]
 WHERE ([EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND [RelatedEntityJoinField] IN ('ParentCommitteeID', 'CommitteeID'))
    OR ([RelatedEntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND [RelatedEntityJoinField] IN ('ParentCommitteeID', 'CommitteeID'));

-- Offset existing virtual field sequences on the 6 schema-modified entities before CodeGen Pass 1
-- so spUpdateExistingEntityFieldsFromSchema never collides on UQ_EntityField_EntityID_Sequence
-- before the final base views are regenerated and renumbered in Pass 2.
UPDATE [${mjSchema}].[EntityField]
   SET [Sequence] = [Sequence] + 1000
 WHERE [EntityID] IN (
     'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', -- Committees: Committees
     '87BEDFA6-F149-4AF2-993C-81BD01169584', -- Committees: Terms
     '0EC944F9-F908-4662-87B2-E57077A873FF', -- Committees: Minutes
     'AAAEE71B-D7CF-4628-BED0-59D43256E46A', -- Committees: Motions
     '272BEFB5-727A-4525-B235-775A56B7ACBB', -- Committees: Artifacts
     'C1CEF804-AA80-47A0-9750-2A4C5227B6DF'  -- Committees: Comments
 )
   AND [IsVirtual] = 1;
GO

DROP VIEW IF EXISTS [${flyway:defaultSchema}].[vwArtifacts];
DROP VIEW IF EXISTS [${flyway:defaultSchema}].[vwBallots];
DROP VIEW IF EXISTS [${flyway:defaultSchema}].[vwComments];
DROP VIEW IF EXISTS [${flyway:defaultSchema}].[vwMemberships];
DROP VIEW IF EXISTS [${flyway:defaultSchema}].[vwMinutes];
DROP VIEW IF EXISTS [${flyway:defaultSchema}].[vwMotions];
GO

-- -----------------------------------------------------------------------------
-- 8. Seed Collaboration SpaceType rows for Committee & Committee Term,
--    Tasks MeetingAgendaItemType rows for Governance, and RLS Filters +
--    EntityPermission rows for UI and Space Participant roles
-- -----------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM [__mj_BizAppsCollaboration].[SpaceType] WHERE [ID] = '5FABEBE3-0207-4DB2-8B4C-8DAF0178A3C6' OR [Code] = N'committee')
BEGIN
    INSERT INTO [__mj_BizAppsCollaboration].[SpaceType] (
        [ID], [Code], [Name], [Description], [Vocabulary], [Discoverability], [JoinMode],
        [MessagingPanel], [LibraryPanel], [WorkPanel], [DefaultAgentRetrieval], [DefaultBand],
        [InviteApproval], [MemberCap], [DisplayRank], [IsActive], [DefaultAllowParentAssignees],
        [IconClass], [Color], [ServerDriverClass], [UIDriverClass], [SpaceExtensionEntity], [Configuration]
    ) VALUES (
        '5FABEBE3-0207-4DB2-8B4C-8DAF0178A3C6', N'committee', N'Committee',
        N'Governance committee space with terms, rosters, meetings, motions, and ballots.',
        N'Committee', N'Listed', N'InviteOnly',
        1, 1, 1, N'Included', N'Team',
        N'Approve', NULL, 10, 1, 1,
        N'fa-solid fa-users-rectangle', N'#1e40af',
        N'CommitteeSpaceServerDriver', N'CommitteeSpaceUIDriver',
        N'Committees: Committees',
        N'{"Children":{"AllowedTypeCodes":["committee","committee-term"]},"Chats":{"AgentReplyMode":"MentionOnly"}}'
    );
END
ELSE
BEGIN
    UPDATE [__mj_BizAppsCollaboration].[SpaceType]
       SET [ServerDriverClass] = N'CommitteeSpaceServerDriver',
           [UIDriverClass] = N'CommitteeSpaceUIDriver',
           [SpaceExtensionEntity] = N'Committees: Committees',
           [Configuration] = N'{"Children":{"AllowedTypeCodes":["committee","committee-term"]},"Chats":{"AgentReplyMode":"MentionOnly"}}'
     WHERE [ID] = '5FABEBE3-0207-4DB2-8B4C-8DAF0178A3C6' OR [Code] = N'committee';
END;

IF NOT EXISTS (SELECT 1 FROM [__mj_BizAppsCollaboration].[SpaceType] WHERE [ID] = 'B7CA4E22-91F3-4E04-A812-3C9F08D42E11' OR [Code] = N'committee-term')
BEGIN
    INSERT INTO [__mj_BizAppsCollaboration].[SpaceType] (
        [ID], [Code], [Name], [Description], [Vocabulary], [Discoverability], [JoinMode],
        [MessagingPanel], [LibraryPanel], [WorkPanel], [DefaultAgentRetrieval], [DefaultBand],
        [InviteApproval], [MemberCap], [DisplayRank], [IsActive], [DefaultAllowParentAssignees],
        [IconClass], [Color], [ServerDriverClass], [UIDriverClass], [SpaceExtensionEntity], [Configuration]
    ) VALUES (
        'B7CA4E22-91F3-4E04-A812-3C9F08D42E11', N'committee-term', N'Committee Term',
        N'Term cycle space under a Committee space; seats SyncSeats from active Memberships.',
        N'Term', N'Hidden', N'InviteOnly',
        1, 1, 1, N'Included', N'Team',
        N'Approve', NULL, 20, 1, 1,
        N'fa-solid fa-calendar-days', N'#3730a3',
        N'TermSpaceServerDriver', N'TermSpaceUIDriver',
        N'Committees: Terms',
        N'{"Children":{"AllowedTypeCodes":[],"MaxOpen":0},"Chats":{"AgentReplyMode":"MentionOnly"}}'
    );
END
ELSE
BEGIN
    UPDATE [__mj_BizAppsCollaboration].[SpaceType]
       SET [ServerDriverClass] = N'TermSpaceServerDriver',
           [UIDriverClass] = N'TermSpaceUIDriver',
           [SpaceExtensionEntity] = N'Committees: Terms',
           [Configuration] = N'{"Children":{"AllowedTypeCodes":[],"MaxOpen":0},"Chats":{"AgentReplyMode":"MentionOnly"}}'
     WHERE [ID] = 'B7CA4E22-91F3-4E04-A812-3C9F08D42E11' OR [Code] = N'committee-term';
END;

IF NOT EXISTS (SELECT 1 FROM [__mj_BizAppsTasks].[MeetingAgendaItemType] WHERE [ID] = 'C0200001-0000-4000-8000-000000000001' OR [Code] = N'VOTE')
BEGIN
    INSERT INTO [__mj_BizAppsTasks].[MeetingAgendaItemType] (
        [ID], [Name], [Code], [Description], [IconClass], [DefaultDurationMinutes], [IsActive], [Sequence]
    ) VALUES (
        'C0200001-0000-4000-8000-000000000001', N'Vote', N'VOTE',
        N'Motion or ballot vote agenda item', N'fa-solid fa-check-to-slot', 10, 1, 350
    );
END;

IF NOT EXISTS (SELECT 1 FROM [__mj_BizAppsTasks].[MeetingAgendaItemType] WHERE [ID] = 'C0200001-0000-4000-8000-000000000002' OR [Code] = N'ACTION_ITEM')
BEGIN
    INSERT INTO [__mj_BizAppsTasks].[MeetingAgendaItemType] (
        [ID], [Name], [Code], [Description], [IconClass], [DefaultDurationMinutes], [IsActive], [Sequence]
    ) VALUES (
        'C0200001-0000-4000-8000-000000000002', N'Action Item', N'ACTION_ITEM',
        N'Committee action item review or assignment', N'fa-solid fa-list-check', 10, 1, 650
    );
END;

IF NOT EXISTS (SELECT 1 FROM [__mj_BizAppsTasks].[MeetingAgendaItemType] WHERE [ID] = 'C0200001-0000-4000-8000-000000000003' OR [Code] = N'OTHER')
BEGIN
    INSERT INTO [__mj_BizAppsTasks].[MeetingAgendaItemType] (
        [ID], [Name], [Code], [Description], [IconClass], [DefaultDurationMinutes], [IsActive], [Sequence]
    ) VALUES (
        'C0200001-0000-4000-8000-000000000003', N'Other', N'OTHER',
        N'General or procedural agenda item', N'fa-solid fa-ellipsis', 5, 1, 800
    );
END;
IF NOT EXISTS (SELECT 1 FROM [__mj_BizAppsTasks].[MeetingAgendaItemType] WHERE [ID] = 'C0200001-0000-4000-8000-000000000004' OR [Code] = N'CALL_TO_ORDER')
BEGIN
    INSERT INTO [__mj_BizAppsTasks].[MeetingAgendaItemType] (
        [ID], [Name], [Code], [Description], [IconClass], [DefaultDurationMinutes], [IsActive], [Sequence]
    ) VALUES (
        'C0200001-0000-4000-8000-000000000004', N'Call to Order', N'CALL_TO_ORDER',
        N'Opening of a parliamentary committee meeting', N'fa-solid fa-gavel', 2, 1, 10
    );
END;

IF NOT EXISTS (SELECT 1 FROM [__mj_BizAppsTasks].[MeetingAgendaItemType] WHERE [ID] = 'C0200001-0000-4000-8000-000000000005' OR [Code] = N'ROLL_CALL')
BEGIN
    INSERT INTO [__mj_BizAppsTasks].[MeetingAgendaItemType] (
        [ID], [Name], [Code], [Description], [IconClass], [DefaultDurationMinutes], [IsActive], [Sequence]
    ) VALUES (
        'C0200001-0000-4000-8000-000000000005', N'Roll Call', N'ROLL_CALL',
        N'Attendance and quorum verification', N'fa-solid fa-clipboard-user', 5, 1, 20
    );
END;

IF NOT EXISTS (SELECT 1 FROM [__mj_BizAppsTasks].[MeetingAgendaItemType] WHERE [ID] = 'C0200001-0000-4000-8000-000000000006' OR [Code] = N'APPROVAL_OF_MINUTES')
BEGIN
    INSERT INTO [__mj_BizAppsTasks].[MeetingAgendaItemType] (
        [ID], [Name], [Code], [Description], [IconClass], [DefaultDurationMinutes], [IsActive], [Sequence]
    ) VALUES (
        'C0200001-0000-4000-8000-000000000006', N'Approval of Minutes', N'APPROVAL_OF_MINUTES',
        N'Review and approval of prior meeting minutes', N'fa-solid fa-file-signature', 5, 1, 30
    );
END;

IF NOT EXISTS (SELECT 1 FROM [__mj_BizAppsTasks].[MeetingAgendaItemType] WHERE [ID] = 'C0200001-0000-4000-8000-000000000007' OR [Code] = N'MOTION')
BEGIN
    INSERT INTO [__mj_BizAppsTasks].[MeetingAgendaItemType] (
        [ID], [Name], [Code], [Description], [IconClass], [DefaultDurationMinutes], [IsActive], [Sequence]
    ) VALUES (
        'C0200001-0000-4000-8000-000000000007', N'Motion', N'MOTION',
        N'Formal parliamentary motion for deliberation and vote', N'fa-solid fa-scale-balanced', 15, 1, 360
    );
END;

IF NOT EXISTS (SELECT 1 FROM [__mj_BizAppsTasks].[MeetingAgendaItemType] WHERE [ID] = 'C0200001-0000-4000-8000-000000000008' OR [Code] = N'EXECUTIVE_SESSION')
BEGIN
    INSERT INTO [__mj_BizAppsTasks].[MeetingAgendaItemType] (
        [ID], [Name], [Code], [Description], [IconClass], [DefaultDurationMinutes], [IsActive], [Sequence]
    ) VALUES (
        'C0200001-0000-4000-8000-000000000008', N'Executive Session', N'EXECUTIVE_SESSION',
        N'Closed session restricted to eligible committee members', N'fa-solid fa-user-shield', 20, 1, 750
    );
END;

IF NOT EXISTS (SELECT 1 FROM [__mj_BizAppsTasks].[MeetingAgendaItemType] WHERE [ID] = 'C0200001-0000-4000-8000-000000000009' OR [Code] = N'ADJOURNMENT')
BEGIN
    INSERT INTO [__mj_BizAppsTasks].[MeetingAgendaItemType] (
        [ID], [Name], [Code], [Description], [IconClass], [DefaultDurationMinutes], [IsActive], [Sequence]
    ) VALUES (
        'C0200001-0000-4000-8000-000000000009', N'Adjournment', N'ADJOURNMENT',
        N'Formal closing of the committee meeting', N'fa-solid fa-door-closed', 2, 1, 900
    );
END;

-- Ensure IsA subtypes of Spaces (Committees & Terms) carry the exact same ReadRLSFilterID as Spaces per role
UPDATE subEp
   SET subEp.[ReadRLSFilterID] = spaceEp.[ReadRLSFilterID]
  FROM [${mjSchema}].[EntityPermission] subEp
  INNER JOIN [${mjSchema}].[EntityPermission] spaceEp
    ON spaceEp.[EntityID] = '3648DC35-1DC4-4ED6-A1A6-5D87271A54DB'
   AND spaceEp.[RoleID] = subEp.[RoleID]
 WHERE subEp.[EntityID] IN ('A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', '87BEDFA6-F149-4AF2-993C-81BD01169584');
GO

-- =============================================================================
-- GENERATED BY MemberJunction CodeGen — DO NOT EDIT BY HAND
-- =============================================================================
/* SQL text to update existing entities from schema */
EXEC [${mjSchema}].[spUpdateExistingEntitiesFromSchema] @ExcludedSchemaNames='', @IncludedSchemaNames='${flyway:defaultSchema}';

/* Seed Hierarchy.IsHierarchy on legacy self-referencing FK Committees: Comments.ParentCommentID */
UPDATE [${mjSchema}].[EntityField]
                         SET [Configuration] = '{"Hierarchy":{"IsHierarchy":true}}'
                         WHERE [ID] = '4D316764-A3C3-473B-BEF5-03B6CC27699F' AND ([Configuration] IS NULL OR [Configuration] = '');


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

/* Index for Foreign Keys for Ballot */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Ballots
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key CommitteeID in table Ballot
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Ballot_CommitteeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Ballot]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Ballot_CommitteeID ON [${flyway:defaultSchema}].[Ballot] ([CommitteeID]);

-- Index for foreign key MotionID in table Ballot
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Ballot_MotionID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Ballot]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Ballot_MotionID ON [${flyway:defaultSchema}].[Ballot] ([MotionID]);

-- Index for foreign key CreatedByMembershipID in table Ballot
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Ballot_CreatedByMembershipID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Ballot]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Ballot_CreatedByMembershipID ON [${flyway:defaultSchema}].[Ballot] ([CreatedByMembershipID]);

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

-- Index for foreign key OrganizationID in table Committee
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Committee_OrganizationID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Committee]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Committee_OrganizationID ON [${flyway:defaultSchema}].[Committee] ([OrganizationID]);

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
    __mj_isa_p1.[SpaceTypeID],
    __mj_isa_p1.[ParentID],
    __mj_isa_p1.[Name],
    __mj_isa_p1.[Description],
    __mj_isa_p1.[OwnerID],
    __mj_isa_p1.[InheritsMembership],
    __mj_isa_p1.[AgentRetrieval],
    __mj_isa_p1.[StartedAt],
    __mj_isa_p1.[ClosedAt],
    __mj_isa_p1.[AllowParentAssignees],
    __mj_isa_p1.[PlannedCloseAt],
    __mj_isa_p1.[IconClass],
    __mj_isa_p1.[Color],
    __mj_isa_p1.[BackgroundImageURL],
    __mj_isa_p1.[Configuration],
    __mj_isa_p1.[StatusID],
    mjBizAppsCommitteesType_TypeID.[Name] AS [Type],
    mjBizAppsCommonOrganization_OrganizationID.[Name] AS [Organization]
FROM
    [${flyway:defaultSchema}].[Committee] AS c
INNER JOIN
    [__mj_BizAppsCollaboration].[Space] AS __mj_isa_p1
  ON
    [c].[ID] = __mj_isa_p1.[ID]
INNER JOIN
    [${flyway:defaultSchema}].[Type] AS mjBizAppsCommitteesType_TypeID
  ON
    [c].[TypeID] = mjBizAppsCommitteesType_TypeID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsCommon].[Organization] AS mjBizAppsCommonOrganization_OrganizationID
  ON
    [c].[OrganizationID] = mjBizAppsCommonOrganization_OrganizationID.[ID]
GO
REVOKE SELECT ON [${flyway:defaultSchema}].[vwCommittees] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwCommittees] FROM [cdp_Integration]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwCommittees] FROM [cdp_UI]
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

REVOKE SELECT ON [${flyway:defaultSchema}].[vwCommittees] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwCommittees] FROM [cdp_Integration]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwCommittees] FROM [cdp_UI]
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
    @TypeID uniqueidentifier,
    @OrganizationID_Clear bit = 0,
    @OrganizationID uniqueidentifier = NULL,
    @CharterDocumentURL_Clear bit = 0,
    @CharterDocumentURL nvarchar(1000) = NULL,
    @MissionStatement_Clear bit = 0,
    @MissionStatement nvarchar(MAX) = NULL,
    @Status nvarchar(50) = NULL,
    @IsPublic bit = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ActualID UNIQUEIDENTIFIER = ISNULL(@ID, NEWID())
    INSERT INTO
    [${flyway:defaultSchema}].[Committee]
        (
            [TypeID],
                [OrganizationID],
                [CharterDocumentURL],
                [MissionStatement],
                [Status],
                [IsPublic],
                [ID]
        )
    VALUES
        (
            @TypeID,
                CASE WHEN @OrganizationID_Clear = 1 THEN NULL ELSE ISNULL(@OrganizationID, NULL) END,
                CASE WHEN @CharterDocumentURL_Clear = 1 THEN NULL ELSE ISNULL(@CharterDocumentURL, NULL) END,
                CASE WHEN @MissionStatement_Clear = 1 THEN NULL ELSE ISNULL(@MissionStatement, NULL) END,
                ISNULL(@Status, 'Active'),
                ISNULL(@IsPublic, 1),
                @ActualID
        )
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwCommittees] WHERE [ID] = @ActualID
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
    @TypeID uniqueidentifier = NULL,
    @OrganizationID_Clear bit = 0,
    @OrganizationID uniqueidentifier = NULL,
    @CharterDocumentURL_Clear bit = 0,
    @CharterDocumentURL nvarchar(1000) = NULL,
    @MissionStatement_Clear bit = 0,
    @MissionStatement nvarchar(MAX) = NULL,
    @Status nvarchar(50) = NULL,
    @IsPublic bit = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Committee]
    SET
        [TypeID] = ISNULL(@TypeID, [TypeID]),
        [OrganizationID] = CASE WHEN @OrganizationID_Clear = 1 THEN NULL ELSE ISNULL(@OrganizationID, [OrganizationID]) END,
        [CharterDocumentURL] = CASE WHEN @CharterDocumentURL_Clear = 1 THEN NULL ELSE ISNULL(@CharterDocumentURL, [CharterDocumentURL]) END,
        [MissionStatement] = CASE WHEN @MissionStatement_Clear = 1 THEN NULL ELSE ISNULL(@MissionStatement, [MissionStatement]) END,
        [Status] = ISNULL(@Status, [Status]),
        [IsPublic] = ISNULL(@IsPublic, [IsPublic])
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

/* Index for Foreign Keys for Term */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Terms
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------;

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
    __mj_isa_p1.[SpaceTypeID],
    __mj_isa_p1.[ParentID],
    __mj_isa_p1.[Name],
    __mj_isa_p1.[Description],
    __mj_isa_p1.[OwnerID],
    __mj_isa_p1.[InheritsMembership],
    __mj_isa_p1.[AgentRetrieval],
    __mj_isa_p1.[StartedAt],
    __mj_isa_p1.[ClosedAt],
    __mj_isa_p1.[AllowParentAssignees],
    __mj_isa_p1.[PlannedCloseAt],
    __mj_isa_p1.[IconClass],
    __mj_isa_p1.[Color],
    __mj_isa_p1.[BackgroundImageURL],
    __mj_isa_p1.[Configuration],
    __mj_isa_p1.[StatusID]
FROM
    [${flyway:defaultSchema}].[Term] AS t
INNER JOIN
    [__mj_BizAppsCollaboration].[Space] AS __mj_isa_p1
  ON
    [t].[ID] = __mj_isa_p1.[ID]
GO
REVOKE SELECT ON [${flyway:defaultSchema}].[vwTerms] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwTerms] FROM [cdp_Integration]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwTerms] FROM [cdp_UI]
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

REVOKE SELECT ON [${flyway:defaultSchema}].[vwTerms] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwTerms] FROM [cdp_Integration]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwTerms] FROM [cdp_UI]
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
    @Status nvarchar(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ActualID UNIQUEIDENTIFIER = ISNULL(@ID, NEWID())
    INSERT INTO
    [${flyway:defaultSchema}].[Term]
        (
            [Status],
                [ID]
        )
    VALUES
        (
            ISNULL(@Status, 'Active'),
                @ActualID
        )
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwTerms] WHERE [ID] = @ActualID
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
    @Status nvarchar(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Term]
    SET
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
    mjBizAppsTasksMeeting_MeetingID.[Name] AS [Meeting],
    mjBizAppsTasksMeetingAgendaItem_AgendaItemID.[Name] AS [AgendaItem],
    mjBizAppsTasksTask_TaskID.[Name] AS [Task],
    mjBizAppsCommitteesArtifactType_ArtifactTypeID.[Name] AS [ArtifactType],
    mjBizAppsCommonPerson_UploadedByPersonID.[DisplayName] AS [UploadedByPerson]
FROM
    [${flyway:defaultSchema}].[Artifact] AS a
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[vwCommittees] AS mjBizAppsCommitteesCommittee_CommitteeID
  ON
    [a].[CommitteeID] = mjBizAppsCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsTasks].[Meeting] AS mjBizAppsTasksMeeting_MeetingID
  ON
    [a].[MeetingID] = mjBizAppsTasksMeeting_MeetingID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsTasks].[MeetingAgendaItem] AS mjBizAppsTasksMeetingAgendaItem_AgendaItemID
  ON
    [a].[AgendaItemID] = mjBizAppsTasksMeetingAgendaItem_AgendaItemID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsTasks].[Task] AS mjBizAppsTasksTask_TaskID
  ON
    [a].[TaskID] = mjBizAppsTasksTask_TaskID.[ID]
INNER JOIN
    [${flyway:defaultSchema}].[ArtifactType] AS mjBizAppsCommitteesArtifactType_ArtifactTypeID
  ON
    [a].[ArtifactTypeID] = mjBizAppsCommitteesArtifactType_ArtifactTypeID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsCommon].[Person] AS mjBizAppsCommonPerson_UploadedByPersonID
  ON
    [a].[UploadedByPersonID] = mjBizAppsCommonPerson_UploadedByPersonID.[ID]
GO
REVOKE SELECT ON [${flyway:defaultSchema}].[vwArtifacts] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwArtifacts] FROM [cdp_Integration]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwArtifacts] FROM [cdp_UI]
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

REVOKE SELECT ON [${flyway:defaultSchema}].[vwArtifacts] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwArtifacts] FROM [cdp_Integration]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwArtifacts] FROM [cdp_UI]
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
    @Name nvarchar(255),
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
                [Name],
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
                @Name,
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
                [Name],
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
                @Name,
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
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateArtifact] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateArtifact] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateArtifact] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Artifacts */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateArtifact] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateArtifact] FROM [cdp_Integration]
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
    @Name nvarchar(255) = NULL,
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
        [Name] = ISNULL(@Name, [Name]),
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

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifact] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifact] FROM [cdp_Integration]
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

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifact] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifact] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifact] TO [cdp_Developer], [cdp_Integration];

/* Base View SQL for Committees: Ballots */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Ballots
-- Item: vwBallots
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Ballots
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Ballot
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwBallots]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwBallots];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwBallots]
AS
SELECT
    b.*,
    mjBizAppsCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjBizAppsCommitteesMotion_MotionID.[Name] AS [Motion]
FROM
    [${flyway:defaultSchema}].[Ballot] AS b
INNER JOIN
    [${flyway:defaultSchema}].[vwCommittees] AS mjBizAppsCommitteesCommittee_CommitteeID
  ON
    [b].[CommitteeID] = mjBizAppsCommitteesCommittee_CommitteeID.[ID]
INNER JOIN
    [${flyway:defaultSchema}].[Motion] AS mjBizAppsCommitteesMotion_MotionID
  ON
    [b].[MotionID] = mjBizAppsCommitteesMotion_MotionID.[ID]
GO
REVOKE SELECT ON [${flyway:defaultSchema}].[vwBallots] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwBallots] FROM [cdp_Integration]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwBallots] FROM [cdp_UI]
GRANT SELECT ON [${flyway:defaultSchema}].[vwBallots] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Ballots */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Ballots
-- Item: Permissions for vwBallots
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

REVOKE SELECT ON [${flyway:defaultSchema}].[vwBallots] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwBallots] FROM [cdp_Integration]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwBallots] FROM [cdp_UI]
GRANT SELECT ON [${flyway:defaultSchema}].[vwBallots] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Ballots */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Ballots
-- Item: spCreateBallot
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Ballot
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateBallot]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateBallot];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateBallot]
    @ID uniqueidentifier = NULL,
    @CommitteeID uniqueidentifier,
    @MotionID uniqueidentifier,
    @OpensAt datetimeoffset,
    @ClosesAt datetimeoffset,
    @ClosedAt_Clear bit = 0,
    @ClosedAt datetimeoffset = NULL,
    @ThresholdType nvarchar(20) = NULL,
    @IsSealed bit = NULL,
    @Status nvarchar(20) = NULL,
    @CreatedByMembershipID_Clear bit = 0,
    @CreatedByMembershipID uniqueidentifier = NULL,
    @ResultNotes_Clear bit = 0,
    @ResultNotes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[Ballot]
            (
                [ID],
                [CommitteeID],
                [MotionID],
                [OpensAt],
                [ClosesAt],
                [ClosedAt],
                [ThresholdType],
                [IsSealed],
                [Status],
                [CreatedByMembershipID],
                [ResultNotes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @CommitteeID,
                @MotionID,
                @OpensAt,
                @ClosesAt,
                CASE WHEN @ClosedAt_Clear = 1 THEN NULL ELSE ISNULL(@ClosedAt, NULL) END,
                ISNULL(@ThresholdType, 'SimpleMajority'),
                ISNULL(@IsSealed, 1),
                ISNULL(@Status, 'Open'),
                CASE WHEN @CreatedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@CreatedByMembershipID, NULL) END,
                CASE WHEN @ResultNotes_Clear = 1 THEN NULL ELSE ISNULL(@ResultNotes, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[Ballot]
            (
                [CommitteeID],
                [MotionID],
                [OpensAt],
                [ClosesAt],
                [ClosedAt],
                [ThresholdType],
                [IsSealed],
                [Status],
                [CreatedByMembershipID],
                [ResultNotes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @CommitteeID,
                @MotionID,
                @OpensAt,
                @ClosesAt,
                CASE WHEN @ClosedAt_Clear = 1 THEN NULL ELSE ISNULL(@ClosedAt, NULL) END,
                ISNULL(@ThresholdType, 'SimpleMajority'),
                ISNULL(@IsSealed, 1),
                ISNULL(@Status, 'Open'),
                CASE WHEN @CreatedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@CreatedByMembershipID, NULL) END,
                CASE WHEN @ResultNotes_Clear = 1 THEN NULL ELSE ISNULL(@ResultNotes, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwBallots] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateBallot] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateBallot] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateBallot] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Ballots */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateBallot] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateBallot] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateBallot] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Ballots */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Ballots
-- Item: spUpdateBallot
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Ballot
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateBallot]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateBallot];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateBallot]
    @ID uniqueidentifier,
    @CommitteeID uniqueidentifier = NULL,
    @MotionID uniqueidentifier = NULL,
    @OpensAt datetimeoffset = NULL,
    @ClosesAt datetimeoffset = NULL,
    @ClosedAt_Clear bit = 0,
    @ClosedAt datetimeoffset = NULL,
    @ThresholdType nvarchar(20) = NULL,
    @IsSealed bit = NULL,
    @Status nvarchar(20) = NULL,
    @CreatedByMembershipID_Clear bit = 0,
    @CreatedByMembershipID uniqueidentifier = NULL,
    @ResultNotes_Clear bit = 0,
    @ResultNotes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Ballot]
    SET
        [CommitteeID] = ISNULL(@CommitteeID, [CommitteeID]),
        [MotionID] = ISNULL(@MotionID, [MotionID]),
        [OpensAt] = ISNULL(@OpensAt, [OpensAt]),
        [ClosesAt] = ISNULL(@ClosesAt, [ClosesAt]),
        [ClosedAt] = CASE WHEN @ClosedAt_Clear = 1 THEN NULL ELSE ISNULL(@ClosedAt, [ClosedAt]) END,
        [ThresholdType] = ISNULL(@ThresholdType, [ThresholdType]),
        [IsSealed] = ISNULL(@IsSealed, [IsSealed]),
        [Status] = ISNULL(@Status, [Status]),
        [CreatedByMembershipID] = CASE WHEN @CreatedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@CreatedByMembershipID, [CreatedByMembershipID]) END,
        [ResultNotes] = CASE WHEN @ResultNotes_Clear = 1 THEN NULL ELSE ISNULL(@ResultNotes, [ResultNotes]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwBallots] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwBallots]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateBallot] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateBallot] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateBallot] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Ballot table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateBallot]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateBallot];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateBallot
ON [${flyway:defaultSchema}].[Ballot]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Ballot]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}].[Ballot] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Ballots */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateBallot] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateBallot] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateBallot] TO [cdp_Developer], [cdp_Integration];

/* Hierarchy Metadata Function SQL for Committees: Comments.ParentCommentID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: fnCommentParentCommentID_GetHierarchyMeta
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- HIERARCHY METADATA FUNCTION FOR: [Comment].[ParentCommentID]
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[fnCommentParentCommentID_GetHierarchyMeta]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}].[fnCommentParentCommentID_GetHierarchyMeta];
GO

CREATE FUNCTION [${flyway:defaultSchema}].[fnCommentParentCommentID_GetHierarchyMeta]
(
    @RecordID uniqueidentifier,
    @ParentID uniqueidentifier
)
RETURNS TABLE
AS
RETURN
(
    WITH CTE_Ancestors AS (
        SELECT
            [ID],
            [ParentCommentID],
            0 AS [Depth],
            CAST('/' + CAST([ID] AS NVARCHAR(36)) + '/' AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[Comment]
        WHERE
            [ID] = @RecordID

        UNION ALL

        SELECT
            p.[ID],
            p.[ParentCommentID],
            c.[Depth] + 1 AS [Depth],
            CAST('/' + CAST(p.[ID] AS NVARCHAR(36)) + c.[Path] AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[Comment] p
        INNER JOIN
            CTE_Ancestors c ON p.[ID] = c.[ParentCommentID]
        WHERE
            c.[Depth] < 100
    )
    SELECT TOP 1
        a.[ID] AS [RootID],
        (SELECT MAX([Depth]) FROM CTE_Ancestors) AS [Depth],
        (SELECT TOP 1 [Path] FROM CTE_Ancestors ORDER BY [Depth] DESC) AS [Path],
        CAST(CASE WHEN EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[Comment] WHERE [ParentCommentID] = @RecordID) THEN 0 ELSE 1 END AS BIT) AS [IsLeaf],
        (SELECT COUNT(1) FROM [${flyway:defaultSchema}].[Comment] WHERE [ParentCommentID] = @RecordID) AS [ChildCount]
    FROM
        CTE_Ancestors a
    WHERE
        a.[ParentCommentID] IS NULL OR @ParentID IS NULL
    ORDER BY
        a.[Depth] DESC
);
GO

/* Descendants Traversal Function SQL for Committees: Comments.ParentCommentID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: fnCommentParentCommentID_GetDescendants
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- DESCENDANTS FUNCTION FOR: [Comment].[ParentCommentID]
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[fnCommentParentCommentID_GetDescendants]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}].[fnCommentParentCommentID_GetDescendants];
GO

CREATE FUNCTION [${flyway:defaultSchema}].[fnCommentParentCommentID_GetDescendants]
(
    @RootID uniqueidentifier,
    @MaxDepth INT = NULL
)
RETURNS TABLE
AS
RETURN
(
    WITH CTE_Descendants AS (
        SELECT
            [ID],
            [ParentCommentID],
            0 AS [RelativeDepth],
            CAST('/' + CAST([ID] AS NVARCHAR(36)) + '/' AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[Comment]
        WHERE
            [ID] = @RootID

        UNION ALL

        SELECT
            c.[ID],
            c.[ParentCommentID],
            p.[RelativeDepth] + 1 AS [RelativeDepth],
            CAST(p.[Path] + CAST(c.[ID] AS NVARCHAR(36)) + '/' AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[Comment] c
        INNER JOIN
            CTE_Descendants p ON c.[ParentCommentID] = p.[ID]
        WHERE
            (@MaxDepth IS NULL OR p.[RelativeDepth] < @MaxDepth)
            AND p.[RelativeDepth] < 100
    )
    SELECT
        d.[ID] AS [ID],
        d.[RelativeDepth] AS [Depth],
        d.[Path],
        CAST(CASE WHEN EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[Comment] WHERE [ParentCommentID] = d.[ID]) THEN 0 ELSE 1 END AS BIT) AS [IsLeaf],
        (SELECT COUNT(1) FROM [${flyway:defaultSchema}].[Comment] WHERE [ParentCommentID] = d.[ID]) AS [ChildCount]
    FROM
        CTE_Descendants d
);
GO

/* Ancestors Traversal Function SQL for Committees: Comments.ParentCommentID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: fnCommentParentCommentID_GetAncestors
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- ANCESTORS FUNCTION FOR: [Comment].[ParentCommentID]
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[fnCommentParentCommentID_GetAncestors]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}].[fnCommentParentCommentID_GetAncestors];
GO

CREATE FUNCTION [${flyway:defaultSchema}].[fnCommentParentCommentID_GetAncestors]
(
    @RecordID uniqueidentifier
)
RETURNS TABLE
AS
RETURN
(
    WITH CTE_Ancestors AS (
        SELECT
            [ID],
            [ParentCommentID],
            0 AS [LevelUp],
            CAST('/' + CAST([ID] AS NVARCHAR(36)) + '/' AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[Comment]
        WHERE
            [ID] = @RecordID

        UNION ALL

        SELECT
            p.[ID],
            p.[ParentCommentID],
            c.[LevelUp] + 1 AS [LevelUp],
            CAST('/' + CAST(p.[ID] AS NVARCHAR(36)) + c.[Path] AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[Comment] p
        INNER JOIN
            CTE_Ancestors c ON p.[ID] = c.[ParentCommentID]
        WHERE
            c.[LevelUp] < 100
    )
    SELECT
        a.[ID] AS [ID],
        a.[LevelUp],
        a.[Path]
    FROM
        CTE_Ancestors a
);
GO

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
    mjBizAppsTasksMeeting_MeetingID.[Name] AS [Meeting],
    mjBizAppsTasksMeetingAgendaItem_AgendaItemID.[Name] AS [AgendaItem],
    mjBizAppsTasksTask_TaskID.[Name] AS [Task],
    mjBizAppsCommitteesArtifact_ArtifactID.[Name] AS [Artifact],
    mjBizAppsCommonPerson_PersonID.[DisplayName] AS [Person],
    hier_ParentCommentID.RootID AS [RootParentCommentID],
    hier_ParentCommentID.Depth AS [ParentCommentIDDepth],
    hier_ParentCommentID.Path AS [ParentCommentIDPath],
    hier_ParentCommentID.IsLeaf AS [ParentCommentIDIsLeaf],
    hier_ParentCommentID.ChildCount AS [ParentCommentIDChildCount]
FROM
    [${flyway:defaultSchema}].[Comment] AS c
INNER JOIN
    [${flyway:defaultSchema}].[vwCommittees] AS mjBizAppsCommitteesCommittee_CommitteeID
  ON
    [c].[CommitteeID] = mjBizAppsCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsTasks].[Meeting] AS mjBizAppsTasksMeeting_MeetingID
  ON
    [c].[MeetingID] = mjBizAppsTasksMeeting_MeetingID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsTasks].[MeetingAgendaItem] AS mjBizAppsTasksMeetingAgendaItem_AgendaItemID
  ON
    [c].[AgendaItemID] = mjBizAppsTasksMeetingAgendaItem_AgendaItemID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsTasks].[Task] AS mjBizAppsTasksTask_TaskID
  ON
    [c].[TaskID] = mjBizAppsTasksTask_TaskID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Artifact] AS mjBizAppsCommitteesArtifact_ArtifactID
  ON
    [c].[ArtifactID] = mjBizAppsCommitteesArtifact_ArtifactID.[ID]
INNER JOIN
    [__mj_BizAppsCommon].[Person] AS mjBizAppsCommonPerson_PersonID
  ON
    [c].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
OUTER APPLY
    [${flyway:defaultSchema}].[fnCommentParentCommentID_GetHierarchyMeta]([c].[ID], [c].[ParentCommentID]) AS hier_ParentCommentID
GO
REVOKE SELECT ON [${flyway:defaultSchema}].[vwComments] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwComments] FROM [cdp_Integration]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwComments] FROM [cdp_UI]
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

REVOKE SELECT ON [${flyway:defaultSchema}].[vwComments] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwComments] FROM [cdp_Integration]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwComments] FROM [cdp_UI]
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
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateComment] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateComment] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateComment] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Comments */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateComment] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateComment] FROM [cdp_Integration]
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

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateComment] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateComment] FROM [cdp_Integration]
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

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateComment] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateComment] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateComment] TO [cdp_Developer], [cdp_Integration];

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
    [__mj_BizAppsCommon].[Person] AS mjBizAppsCommonPerson_PersonID
  ON
    [m].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
INNER JOIN
    [${flyway:defaultSchema}].[Role] AS mjBizAppsCommitteesRole_RoleID
  ON
    [m].[RoleID] = mjBizAppsCommitteesRole_RoleID.[ID]
INNER JOIN
    [${flyway:defaultSchema}].[vwTerms] AS mjBizAppsCommitteesTerm_TermID
  ON
    [m].[TermID] = mjBizAppsCommitteesTerm_TermID.[ID]
GO
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMemberships] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMemberships] FROM [cdp_Integration]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMemberships] FROM [cdp_UI]
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

REVOKE SELECT ON [${flyway:defaultSchema}].[vwMemberships] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMemberships] FROM [cdp_Integration]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMemberships] FROM [cdp_UI]
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
    @Notes nvarchar(MAX) = NULL,
    @RenewalIntent_Clear bit = 0,
    @RenewalIntent nvarchar(20) = NULL
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
                [Notes],
                [RenewalIntent]
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
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END,
                CASE WHEN @RenewalIntent_Clear = 1 THEN NULL ELSE ISNULL(@RenewalIntent, NULL) END
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
                [Notes],
                [RenewalIntent]
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
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END,
                CASE WHEN @RenewalIntent_Clear = 1 THEN NULL ELSE ISNULL(@RenewalIntent, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwMemberships] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMembership] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMembership] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMembership] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Memberships */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMembership] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMembership] FROM [cdp_Integration]
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
    @Notes nvarchar(MAX) = NULL,
    @RenewalIntent_Clear bit = 0,
    @RenewalIntent nvarchar(20) = NULL
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
        [Notes] = CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, [Notes]) END,
        [RenewalIntent] = CASE WHEN @RenewalIntent_Clear = 1 THEN NULL ELSE ISNULL(@RenewalIntent, [RenewalIntent]) END
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

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMembership] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMembership] FROM [cdp_Integration]
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

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMembership] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMembership] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMembership] TO [cdp_Developer], [cdp_Integration];

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
    m.*,
    mjBizAppsCommitteesArtifact_ArtifactID.[Name] AS [Artifact],
    mjBizAppsTasksMeeting_MeetingID.[Name] AS [Meeting],
    mjBizAppsTasksMeeting_ApprovedByMeetingID.[Name] AS [ApprovedByMeeting]
FROM
    [${flyway:defaultSchema}].[Minute] AS m
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Artifact] AS mjBizAppsCommitteesArtifact_ArtifactID
  ON
    [m].[ArtifactID] = mjBizAppsCommitteesArtifact_ArtifactID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsTasks].[Meeting] AS mjBizAppsTasksMeeting_MeetingID
  ON
    [m].[MeetingID] = mjBizAppsTasksMeeting_MeetingID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsTasks].[Meeting] AS mjBizAppsTasksMeeting_ApprovedByMeetingID
  ON
    [m].[ApprovedByMeetingID] = mjBizAppsTasksMeeting_ApprovedByMeetingID.[ID]
GO
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMinutes] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMinutes] FROM [cdp_Integration]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMinutes] FROM [cdp_UI]
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

REVOKE SELECT ON [${flyway:defaultSchema}].[vwMinutes] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMinutes] FROM [cdp_Integration]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMinutes] FROM [cdp_UI]
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
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMinute] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMinute] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMinute] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Minutes */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMinute] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMinute] FROM [cdp_Integration]
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

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMinute] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMinute] FROM [cdp_Integration]
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

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMinute] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMinute] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMinute] TO [cdp_Developer], [cdp_Integration];

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
    m.*,
    mjBizAppsTasksMeeting_MeetingID.[Name] AS [Meeting],
    mjBizAppsTasksMeetingAgendaItem_AgendaItemID.[Name] AS [AgendaItem]
FROM
    [${flyway:defaultSchema}].[Motion] AS m
LEFT OUTER JOIN
    [__mj_BizAppsTasks].[Meeting] AS mjBizAppsTasksMeeting_MeetingID
  ON
    [m].[MeetingID] = mjBizAppsTasksMeeting_MeetingID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsTasks].[MeetingAgendaItem] AS mjBizAppsTasksMeetingAgendaItem_AgendaItemID
  ON
    [m].[AgendaItemID] = mjBizAppsTasksMeetingAgendaItem_AgendaItemID.[ID]
GO
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMotions] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMotions] FROM [cdp_Integration]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMotions] FROM [cdp_UI]
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

REVOKE SELECT ON [${flyway:defaultSchema}].[vwMotions] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMotions] FROM [cdp_Integration]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMotions] FROM [cdp_UI]
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
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @Sequence int = NULL,
    @Name nvarchar(255),
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
                [Name],
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
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                ISNULL(@Sequence, 1),
                @Name,
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
                [Name],
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
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                ISNULL(@Sequence, 1),
                @Name,
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
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMotion] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMotion] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMotion] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Motions */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMotion] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMotion] FROM [cdp_Integration]
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
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @Sequence int = NULL,
    @Name nvarchar(255) = NULL,
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
        [MeetingID] = CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, [MeetingID]) END,
        [AgendaItemID] = CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, [AgendaItemID]) END,
        [Sequence] = ISNULL(@Sequence, [Sequence]),
        [Name] = ISNULL(@Name, [Name]),
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

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMotion] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMotion] FROM [cdp_Integration]
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

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMotion] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMotion] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMotion] TO [cdp_Developer], [cdp_Integration];

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
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteArtifact] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteArtifact] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteArtifact] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Artifacts */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteArtifact] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteArtifact] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteArtifact] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Ballots */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Ballots
-- Item: spDeleteBallot
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Ballot
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteBallot]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteBallot];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteBallot]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Ballot]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteBallot] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteBallot] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteBallot] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Ballots */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteBallot] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteBallot] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteBallot] TO [cdp_Developer], [cdp_Integration];

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
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteComment] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteComment] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteComment] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Comments */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteComment] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteComment] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteComment] TO [cdp_Developer], [cdp_Integration];

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
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMembership] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMembership] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMembership] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Memberships */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMembership] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMembership] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMembership] TO [cdp_Developer], [cdp_Integration];

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
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMinute] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMinute] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMinute] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Minutes */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMinute] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMinute] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMinute] TO [cdp_Developer], [cdp_Integration];

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
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMotion] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMotion] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMotion] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Motions */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMotion] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMotion] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMotion] TO [cdp_Developer], [cdp_Integration];


EXEC [${mjSchema}].[spDeleteUnneededEntityFields] @ExcludedSchemaNames='', @IncludedSchemaNames='${flyway:defaultSchema}';

/* SQL text to insert 4 new entity field(s) */
/* SQL text to insert 33 new entity field(s) */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '777c2d0a-58e6-4dc7-aee6-79408a73f1f3' OR (EntityID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND Name = 'SpaceTypeID')) BEGIN
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
            '777c2d0a-58e6-4dc7-aee6-79408a73f1f3',
            'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', -- Entity: Committees: Committees
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'),
            'SpaceTypeID',
            'Space Type ID',
            NULL,
            'uniqueidentifier',
            16,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '56d8ef59-ee56-4da8-9002-edb7c5d7c423' OR (EntityID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND Name = 'ParentID')) BEGIN
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
            '56d8ef59-ee56-4da8-9002-edb7c5d7c423',
            'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', -- Entity: Committees: Committees
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'),
            'ParentID',
            'Parent ID',
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '73ae2fde-380b-4828-88b5-91c3c0346371' OR (EntityID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND Name = 'OwnerID')) BEGIN
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
            '73ae2fde-380b-4828-88b5-91c3c0346371',
            'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', -- Entity: Committees: Committees
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'),
            'OwnerID',
            'Owner ID',
            NULL,
            'uniqueidentifier',
            16,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0e4a3e6a-d45c-4852-b785-a264b9383fc3' OR (EntityID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND Name = 'InheritsMembership')) BEGIN
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
            '0e4a3e6a-d45c-4852-b785-a264b9383fc3',
            'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', -- Entity: Committees: Committees
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'),
            'InheritsMembership',
            'Inherits Membership',
            NULL,
            'bit',
            1,
            1,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '02154acc-3aea-43de-9c82-acc956b64b10' OR (EntityID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND Name = 'AgentRetrieval')) BEGIN
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
            '02154acc-3aea-43de-9c82-acc956b64b10',
            'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', -- Entity: Committees: Committees
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'),
            'AgentRetrieval',
            'Agent Retrieval',
            NULL,
            'nvarchar',
            60,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '465f154a-d85f-455c-94fb-a15d7189c962' OR (EntityID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND Name = 'StartedAt')) BEGIN
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
            '465f154a-d85f-455c-94fb-a15d7189c962',
            'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', -- Entity: Committees: Committees
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'),
            'StartedAt',
            'Started At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '884aae4f-0883-4ab7-83f6-e056817ce166' OR (EntityID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND Name = 'ClosedAt')) BEGIN
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
            '884aae4f-0883-4ab7-83f6-e056817ce166',
            'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', -- Entity: Committees: Committees
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'),
            'ClosedAt',
            'Closed At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '18397653-b5f6-4867-a1ad-e0c7786da5ce' OR (EntityID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND Name = 'AllowParentAssignees')) BEGIN
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
            '18397653-b5f6-4867-a1ad-e0c7786da5ce',
            'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', -- Entity: Committees: Committees
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'),
            'AllowParentAssignees',
            'Allow Parent Assignees',
            NULL,
            'bit',
            1,
            1,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '7b6fbfee-3be1-4940-8bfc-890370c44285' OR (EntityID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND Name = 'PlannedCloseAt')) BEGIN
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
            '7b6fbfee-3be1-4940-8bfc-890370c44285',
            'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', -- Entity: Committees: Committees
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'),
            'PlannedCloseAt',
            'Planned Close At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '289726ec-fdc8-43cd-9bd7-0bb63de23dfc' OR (EntityID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND Name = 'IconClass')) BEGIN
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
            '289726ec-fdc8-43cd-9bd7-0bb63de23dfc',
            'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', -- Entity: Committees: Committees
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'),
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '1c95ff3a-fbb2-4659-9a8e-6e5b5cd82a50' OR (EntityID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND Name = 'Color')) BEGIN
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
            '1c95ff3a-fbb2-4659-9a8e-6e5b5cd82a50',
            'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', -- Entity: Committees: Committees
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'),
            'Color',
            'Color',
            NULL,
            'nvarchar',
            100,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'bb5d9674-fa09-42db-ba32-9e7e182e5141' OR (EntityID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND Name = 'BackgroundImageURL')) BEGIN
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
            'bb5d9674-fa09-42db-ba32-9e7e182e5141',
            'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', -- Entity: Committees: Committees
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'),
            'BackgroundImageURL',
            'Background Image URL',
            NULL,
            'nvarchar',
            2000,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '8e2ce8ab-373a-4386-9189-aeeefb913d2a' OR (EntityID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND Name = 'Configuration')) BEGIN
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
            '8e2ce8ab-373a-4386-9189-aeeefb913d2a',
            'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', -- Entity: Committees: Committees
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'),
            'Configuration',
            'Configuration',
            NULL,
            'nvarchar',
            -1,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '23ce41c0-7388-4f31-9cd5-bc9340c86d2b' OR (EntityID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND Name = 'StatusID')) BEGIN
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
            '23ce41c0-7388-4f31-9cd5-bc9340c86d2b',
            'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', -- Entity: Committees: Committees
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'),
            'StatusID',
            'Status ID',
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'c269b8ec-a05a-40ce-9f9e-7c2959c8ebc0' OR (EntityID = '87BEDFA6-F149-4AF2-993C-81BD01169584' AND Name = 'SpaceTypeID')) BEGIN
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
            'c269b8ec-a05a-40ce-9f9e-7c2959c8ebc0',
            '87BEDFA6-F149-4AF2-993C-81BD01169584', -- Entity: Committees: Terms
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '87BEDFA6-F149-4AF2-993C-81BD01169584'),
            'SpaceTypeID',
            'Space Type ID',
            NULL,
            'uniqueidentifier',
            16,
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
            1,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END;

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'fd84730c-f6a3-4103-9180-58fd37e2609e' OR (EntityID = '87BEDFA6-F149-4AF2-993C-81BD01169584' AND Name = 'ParentID')) BEGIN
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
            'fd84730c-f6a3-4103-9180-58fd37e2609e',
            '87BEDFA6-F149-4AF2-993C-81BD01169584', -- Entity: Committees: Terms
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '87BEDFA6-F149-4AF2-993C-81BD01169584'),
            'ParentID',
            'Parent ID',
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'e65dac9f-bb1d-46be-9045-4343dace80cc' OR (EntityID = '87BEDFA6-F149-4AF2-993C-81BD01169584' AND Name = 'Description')) BEGIN
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
            'e65dac9f-bb1d-46be-9045-4343dace80cc',
            '87BEDFA6-F149-4AF2-993C-81BD01169584', -- Entity: Committees: Terms
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '87BEDFA6-F149-4AF2-993C-81BD01169584'),
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'd26a4989-ee55-4115-ba56-6818fe635612' OR (EntityID = '87BEDFA6-F149-4AF2-993C-81BD01169584' AND Name = 'OwnerID')) BEGIN
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
            'd26a4989-ee55-4115-ba56-6818fe635612',
            '87BEDFA6-F149-4AF2-993C-81BD01169584', -- Entity: Committees: Terms
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '87BEDFA6-F149-4AF2-993C-81BD01169584'),
            'OwnerID',
            'Owner ID',
            NULL,
            'uniqueidentifier',
            16,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '4753a9bb-638a-46cb-a96c-1d99edb3a9db' OR (EntityID = '87BEDFA6-F149-4AF2-993C-81BD01169584' AND Name = 'InheritsMembership')) BEGIN
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
            '4753a9bb-638a-46cb-a96c-1d99edb3a9db',
            '87BEDFA6-F149-4AF2-993C-81BD01169584', -- Entity: Committees: Terms
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '87BEDFA6-F149-4AF2-993C-81BD01169584'),
            'InheritsMembership',
            'Inherits Membership',
            NULL,
            'bit',
            1,
            1,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '6771a866-6ad9-451d-b6ee-3f1400bfeed2' OR (EntityID = '87BEDFA6-F149-4AF2-993C-81BD01169584' AND Name = 'AgentRetrieval')) BEGIN
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
            '6771a866-6ad9-451d-b6ee-3f1400bfeed2',
            '87BEDFA6-F149-4AF2-993C-81BD01169584', -- Entity: Committees: Terms
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '87BEDFA6-F149-4AF2-993C-81BD01169584'),
            'AgentRetrieval',
            'Agent Retrieval',
            NULL,
            'nvarchar',
            60,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'e9b39ee1-bec8-4325-becf-77434f140167' OR (EntityID = '87BEDFA6-F149-4AF2-993C-81BD01169584' AND Name = 'StartedAt')) BEGIN
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
            'e9b39ee1-bec8-4325-becf-77434f140167',
            '87BEDFA6-F149-4AF2-993C-81BD01169584', -- Entity: Committees: Terms
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '87BEDFA6-F149-4AF2-993C-81BD01169584'),
            'StartedAt',
            'Started At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '75fb82e1-5d99-4775-9fee-a2487a3fa70d' OR (EntityID = '87BEDFA6-F149-4AF2-993C-81BD01169584' AND Name = 'ClosedAt')) BEGIN
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
            '75fb82e1-5d99-4775-9fee-a2487a3fa70d',
            '87BEDFA6-F149-4AF2-993C-81BD01169584', -- Entity: Committees: Terms
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '87BEDFA6-F149-4AF2-993C-81BD01169584'),
            'ClosedAt',
            'Closed At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'ec2b9ff2-6218-4e6b-9e91-4d6e68e51e43' OR (EntityID = '87BEDFA6-F149-4AF2-993C-81BD01169584' AND Name = 'AllowParentAssignees')) BEGIN
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
            'ec2b9ff2-6218-4e6b-9e91-4d6e68e51e43',
            '87BEDFA6-F149-4AF2-993C-81BD01169584', -- Entity: Committees: Terms
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '87BEDFA6-F149-4AF2-993C-81BD01169584'),
            'AllowParentAssignees',
            'Allow Parent Assignees',
            NULL,
            'bit',
            1,
            1,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '6ef0974c-eb56-4f55-bac6-65f9d4f0bf5c' OR (EntityID = '87BEDFA6-F149-4AF2-993C-81BD01169584' AND Name = 'PlannedCloseAt')) BEGIN
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
            '6ef0974c-eb56-4f55-bac6-65f9d4f0bf5c',
            '87BEDFA6-F149-4AF2-993C-81BD01169584', -- Entity: Committees: Terms
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '87BEDFA6-F149-4AF2-993C-81BD01169584'),
            'PlannedCloseAt',
            'Planned Close At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'ccc3ce45-8ad8-4206-82d3-67e547c4b324' OR (EntityID = '87BEDFA6-F149-4AF2-993C-81BD01169584' AND Name = 'IconClass')) BEGIN
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
            'ccc3ce45-8ad8-4206-82d3-67e547c4b324',
            '87BEDFA6-F149-4AF2-993C-81BD01169584', -- Entity: Committees: Terms
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '87BEDFA6-F149-4AF2-993C-81BD01169584'),
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'e6c01f74-452c-474b-a45c-47e8f8bf1c70' OR (EntityID = '87BEDFA6-F149-4AF2-993C-81BD01169584' AND Name = 'Color')) BEGIN
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
            'e6c01f74-452c-474b-a45c-47e8f8bf1c70',
            '87BEDFA6-F149-4AF2-993C-81BD01169584', -- Entity: Committees: Terms
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '87BEDFA6-F149-4AF2-993C-81BD01169584'),
            'Color',
            'Color',
            NULL,
            'nvarchar',
            100,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'ec7edf8a-e0f0-49b2-9f8d-18ba47da478d' OR (EntityID = '87BEDFA6-F149-4AF2-993C-81BD01169584' AND Name = 'BackgroundImageURL')) BEGIN
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
            'ec7edf8a-e0f0-49b2-9f8d-18ba47da478d',
            '87BEDFA6-F149-4AF2-993C-81BD01169584', -- Entity: Committees: Terms
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '87BEDFA6-F149-4AF2-993C-81BD01169584'),
            'BackgroundImageURL',
            'Background Image URL',
            NULL,
            'nvarchar',
            2000,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'd976b72a-9d57-474c-bc0d-a3c54e74338d' OR (EntityID = '87BEDFA6-F149-4AF2-993C-81BD01169584' AND Name = 'Configuration')) BEGIN
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
            'd976b72a-9d57-474c-bc0d-a3c54e74338d',
            '87BEDFA6-F149-4AF2-993C-81BD01169584', -- Entity: Committees: Terms
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '87BEDFA6-F149-4AF2-993C-81BD01169584'),
            'Configuration',
            'Configuration',
            NULL,
            'nvarchar',
            -1,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '683b817a-a0f1-4d85-aa0a-08390d2b5e19' OR (EntityID = '87BEDFA6-F149-4AF2-993C-81BD01169584' AND Name = 'StatusID')) BEGIN
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
            '683b817a-a0f1-4d85-aa0a-08390d2b5e19',
            '87BEDFA6-F149-4AF2-993C-81BD01169584', -- Entity: Committees: Terms
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '87BEDFA6-F149-4AF2-993C-81BD01169584'),
            'StatusID',
            'Status ID',
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '91d9dcf2-36cb-4999-a975-9c004ceea46e' OR (EntityID = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF' AND Name = 'ParentCommentIDDepth')) BEGIN
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
            '91d9dcf2-36cb-4999-a975-9c004ceea46e',
            'C1CEF804-AA80-47A0-9750-2A4C5227B6DF', -- Entity: Committees: Comments
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF'),
            'ParentCommentIDDepth',
            'Parent Comment ID Depth',
            NULL,
            'int',
            4,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '6f186aa1-e1e3-4efc-b3fd-569a124a2a98' OR (EntityID = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF' AND Name = 'ParentCommentIDPath')) BEGIN
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
            '6f186aa1-e1e3-4efc-b3fd-569a124a2a98',
            'C1CEF804-AA80-47A0-9750-2A4C5227B6DF', -- Entity: Committees: Comments
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF'),
            'ParentCommentIDPath',
            'Parent Comment ID Path',
            NULL,
            'nvarchar',
            -1,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'b35a33e3-2497-4e15-9588-c8b62cd8d763' OR (EntityID = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF' AND Name = 'ParentCommentIDIsLeaf')) BEGIN
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
            'b35a33e3-2497-4e15-9588-c8b62cd8d763',
            'C1CEF804-AA80-47A0-9750-2A4C5227B6DF', -- Entity: Committees: Comments
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF'),
            'ParentCommentIDIsLeaf',
            'Parent Comment ID Is Leaf',
            NULL,
            'bit',
            1,
            1,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '61144bb3-e01d-4226-9290-dcdf8c077889' OR (EntityID = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF' AND Name = 'ParentCommentIDChildCount')) BEGIN
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
            '61144bb3-e01d-4226-9290-dcdf8c077889',
            'C1CEF804-AA80-47A0-9750-2A4C5227B6DF', -- Entity: Committees: Comments
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF'),
            'ParentCommentIDChildCount',
            'Parent Comment ID Child Count',
            NULL,
            'int',
            4,
            10,
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

/* SQL text to update existing entity fields from schema (8 scoped entities) */
EXEC [${mjSchema}].[spUpdateExistingEntityFieldsFromSchema] @ExcludedSchemaNames='', @IncludedSchemaNames='${flyway:defaultSchema}';

/* Update IS-A parent field SpaceTypeID on Committees: Committees */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='uniqueidentifier',
                      [Length]=16,
                      [Precision]=0,
                      [Scale]=0,
                      [AllowsNull]=0,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]='01596359-EC4B-449C-BA16-316DE4B92A4E',
                      [RelatedEntityFieldName]='ID',
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='777C2D0A-58E6-4DC7-AEE6-79408A73F1F3';

/* Update IS-A parent field ParentID on Committees: Committees */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='uniqueidentifier',
                      [Length]=16,
                      [Precision]=0,
                      [Scale]=0,
                      [AllowsNull]=1,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]='3648DC35-1DC4-4ED6-A1A6-5D87271A54DB',
                      [RelatedEntityFieldName]='ID',
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='56D8EF59-EE56-4DA8-9002-EDB7C5D7C423';

/* Update IS-A parent field OwnerID on Committees: Committees */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='uniqueidentifier',
                      [Length]=16,
                      [Precision]=0,
                      [Scale]=0,
                      [AllowsNull]=0,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]='E1238F34-2837-EF11-86D4-6045BDEE16E6',
                      [RelatedEntityFieldName]='ID',
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='73AE2FDE-380B-4828-88B5-91C3C0346371';

/* Update IS-A parent field InheritsMembership on Committees: Committees */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='bit',
                      [Length]=1,
                      [Precision]=1,
                      [Scale]=0,
                      [AllowsNull]=0,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='0E4A3E6A-D45C-4852-B785-A264B9383FC3';

/* Update IS-A parent field AgentRetrieval on Committees: Committees */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='nvarchar',
                      [Length]=60,
                      [Precision]=0,
                      [Scale]=0,
                      [AllowsNull]=0,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='02154ACC-3AEA-43DE-9C82-ACC956B64B10';

/* Update IS-A parent field StartedAt on Committees: Committees */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='datetimeoffset',
                      [Length]=10,
                      [Precision]=34,
                      [Scale]=7,
                      [AllowsNull]=1,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='465F154A-D85F-455C-94FB-A15D7189C962';

/* Update IS-A parent field ClosedAt on Committees: Committees */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='datetimeoffset',
                      [Length]=10,
                      [Precision]=34,
                      [Scale]=7,
                      [AllowsNull]=1,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='884AAE4F-0883-4AB7-83F6-E056817CE166';

/* Update IS-A parent field AllowParentAssignees on Committees: Committees */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='bit',
                      [Length]=1,
                      [Precision]=1,
                      [Scale]=0,
                      [AllowsNull]=0,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='18397653-B5F6-4867-A1AD-E0C7786DA5CE';

/* Update IS-A parent field PlannedCloseAt on Committees: Committees */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='datetimeoffset',
                      [Length]=10,
                      [Precision]=34,
                      [Scale]=7,
                      [AllowsNull]=1,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='7B6FBFEE-3BE1-4940-8BFC-890370C44285';

/* Update IS-A parent field IconClass on Committees: Committees */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='nvarchar',
                      [Length]=200,
                      [Precision]=0,
                      [Scale]=0,
                      [AllowsNull]=1,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='289726EC-FDC8-43CD-9BD7-0BB63DE23DFC';

/* Update IS-A parent field Color on Committees: Committees */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='nvarchar',
                      [Length]=100,
                      [Precision]=0,
                      [Scale]=0,
                      [AllowsNull]=1,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='1C95FF3A-FBB2-4659-9A8E-6E5B5CD82A50';

/* Update IS-A parent field BackgroundImageURL on Committees: Committees */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='nvarchar',
                      [Length]=2000,
                      [Precision]=0,
                      [Scale]=0,
                      [AllowsNull]=1,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='BB5D9674-FA09-42DB-BA32-9E7E182E5141';

/* Update IS-A parent field Configuration on Committees: Committees */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='nvarchar',
                      [Length]=-1,
                      [Precision]=0,
                      [Scale]=0,
                      [AllowsNull]=1,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='8E2CE8AB-373A-4386-9189-AEEEFB913D2A';

/* Update IS-A parent field StatusID on Committees: Committees */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='uniqueidentifier',
                      [Length]=16,
                      [Precision]=0,
                      [Scale]=0,
                      [AllowsNull]=1,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]='106DF2B5-DF08-48EE-A0E1-26C329DC0343',
                      [RelatedEntityFieldName]='ID',
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='23CE41C0-7388-4F31-9CD5-BC9340C86D2B';

/* Update entity timestamp for Committees: Committees after IS-A field sync */
UPDATE [${mjSchema}].[Entity] SET [__mj_UpdatedAt]=GETUTCDATE() WHERE ID='A5DA88A1-AA21-4A3F-B1C4-42652FB440CE';

/* Update IS-A parent field SpaceTypeID on Committees: Terms */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='uniqueidentifier',
                      [Length]=16,
                      [Precision]=0,
                      [Scale]=0,
                      [AllowsNull]=0,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]='01596359-EC4B-449C-BA16-316DE4B92A4E',
                      [RelatedEntityFieldName]='ID',
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='C269B8EC-A05A-40CE-9F9E-7C2959C8EBC0';

/* Update IS-A parent field ParentID on Committees: Terms */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='uniqueidentifier',
                      [Length]=16,
                      [Precision]=0,
                      [Scale]=0,
                      [AllowsNull]=1,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]='3648DC35-1DC4-4ED6-A1A6-5D87271A54DB',
                      [RelatedEntityFieldName]='ID',
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='FD84730C-F6A3-4103-9180-58FD37E2609E';

/* Update IS-A parent field Description on Committees: Terms */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='nvarchar',
                      [Length]=-1,
                      [Precision]=0,
                      [Scale]=0,
                      [AllowsNull]=1,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='E65DAC9F-BB1D-46BE-9045-4343DACE80CC';

/* Update IS-A parent field OwnerID on Committees: Terms */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='uniqueidentifier',
                      [Length]=16,
                      [Precision]=0,
                      [Scale]=0,
                      [AllowsNull]=0,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]='E1238F34-2837-EF11-86D4-6045BDEE16E6',
                      [RelatedEntityFieldName]='ID',
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='D26A4989-EE55-4115-BA56-6818FE635612';

/* Update IS-A parent field InheritsMembership on Committees: Terms */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='bit',
                      [Length]=1,
                      [Precision]=1,
                      [Scale]=0,
                      [AllowsNull]=0,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='4753A9BB-638A-46CB-A96C-1D99EDB3A9DB';

/* Update IS-A parent field AgentRetrieval on Committees: Terms */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='nvarchar',
                      [Length]=60,
                      [Precision]=0,
                      [Scale]=0,
                      [AllowsNull]=0,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='6771A866-6AD9-451D-B6EE-3F1400BFEED2';

/* Update IS-A parent field StartedAt on Committees: Terms */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='datetimeoffset',
                      [Length]=10,
                      [Precision]=34,
                      [Scale]=7,
                      [AllowsNull]=1,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='E9B39EE1-BEC8-4325-BECF-77434F140167';

/* Update IS-A parent field ClosedAt on Committees: Terms */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='datetimeoffset',
                      [Length]=10,
                      [Precision]=34,
                      [Scale]=7,
                      [AllowsNull]=1,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='75FB82E1-5D99-4775-9FEE-A2487A3FA70D';

/* Update IS-A parent field AllowParentAssignees on Committees: Terms */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='bit',
                      [Length]=1,
                      [Precision]=1,
                      [Scale]=0,
                      [AllowsNull]=0,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='EC2B9FF2-6218-4E6B-9E91-4D6E68E51E43';

/* Update IS-A parent field PlannedCloseAt on Committees: Terms */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='datetimeoffset',
                      [Length]=10,
                      [Precision]=34,
                      [Scale]=7,
                      [AllowsNull]=1,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='6EF0974C-EB56-4F55-BAC6-65F9D4F0BF5C';

/* Update IS-A parent field IconClass on Committees: Terms */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='nvarchar',
                      [Length]=200,
                      [Precision]=0,
                      [Scale]=0,
                      [AllowsNull]=1,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='CCC3CE45-8AD8-4206-82D3-67E547C4B324';

/* Update IS-A parent field Color on Committees: Terms */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='nvarchar',
                      [Length]=100,
                      [Precision]=0,
                      [Scale]=0,
                      [AllowsNull]=1,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='E6C01F74-452C-474B-A45C-47E8F8BF1C70';

/* Update IS-A parent field BackgroundImageURL on Committees: Terms */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='nvarchar',
                      [Length]=2000,
                      [Precision]=0,
                      [Scale]=0,
                      [AllowsNull]=1,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='EC7EDF8A-E0F0-49B2-9F8D-18BA47DA478D';

/* Update IS-A parent field Configuration on Committees: Terms */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='nvarchar',
                      [Length]=-1,
                      [Precision]=0,
                      [Scale]=0,
                      [AllowsNull]=1,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]=NULL,
                      [RelatedEntityFieldName]=NULL,
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='D976B72A-9D57-474C-BC0D-A3C54E74338D';

/* Update IS-A parent field StatusID on Committees: Terms */
UPDATE [${mjSchema}].[EntityField]
                  SET [IsVirtual]=1,
                      [Type]='uniqueidentifier',
                      [Length]=16,
                      [Precision]=0,
                      [Scale]=0,
                      [AllowsNull]=1,
                      [AllowUpdateAPI]=1,
                      [IncludeRelatedEntityNameFieldInBaseView]=0,
                      [RelatedEntityID]='106DF2B5-DF08-48EE-A0E1-26C329DC0343',
                      [RelatedEntityFieldName]='ID',
                      [RelatedEntityDisplayType]='Search'
                  WHERE [ID]='683B817A-A0F1-4D85-AA0A-08390D2B5E19';

/* Update entity timestamp for Committees: Terms after IS-A field sync */
UPDATE [${mjSchema}].[Entity] SET [__mj_UpdatedAt]=GETUTCDATE() WHERE ID='87BEDFA6-F149-4AF2-993C-81BD01169584';

/* SQL text to set default column width where needed */
EXEC [${mjSchema}].[spSetDefaultColumnWidthWhereNeeded] @ExcludedSchemaNames='', @IncludedSchemaNames='${flyway:defaultSchema}';


/* Create Entity Relationship: MJ_BizApps_Tasks: Meeting Agenda Items -> Committees: Comments (One To Many via AgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '61054aae-cc04-4cf8-9182-d8ee0564350f' OR ([EntityID] = '9C171F1D-86F9-4630-8548-1DC6163272CA' AND [RelatedEntityID] = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF' AND [RelatedEntityJoinField] = 'AgendaItemID')
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('61054aae-cc04-4cf8-9182-d8ee0564350f', '9C171F1D-86F9-4630-8548-1DC6163272CA', 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF', 'AgendaItemID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Tasks: Meeting Agenda Items -> Committees: Motions (One To Many via AgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '0ff4fe63-6127-4794-9ba9-5440e7babbf6' OR ([EntityID] = '9C171F1D-86F9-4630-8548-1DC6163272CA' AND [RelatedEntityID] = 'AAAEE71B-D7CF-4628-BED0-59D43256E46A' AND [RelatedEntityJoinField] = 'AgendaItemID')
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('0ff4fe63-6127-4794-9ba9-5440e7babbf6', '9C171F1D-86F9-4630-8548-1DC6163272CA', 'AAAEE71B-D7CF-4628-BED0-59D43256E46A', 'AgendaItemID', 'One To Many', 1, 1, 4, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Tasks: Meeting Agenda Items -> Committees: Artifacts (One To Many via AgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'ebe40c77-017e-4595-9a56-e68baf4937e4' OR ([EntityID] = '9C171F1D-86F9-4630-8548-1DC6163272CA' AND [RelatedEntityID] = '272BEFB5-727A-4525-B235-775A56B7ACBB' AND [RelatedEntityJoinField] = 'AgendaItemID')
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('ebe40c77-017e-4595-9a56-e68baf4937e4', '9C171F1D-86F9-4630-8548-1DC6163272CA', '272BEFB5-727A-4525-B235-775A56B7ACBB', 'AgendaItemID', 'One To Many', 1, 1, 5, GETUTCDATE(), GETUTCDATE())
   END;


/* Create Entity Relationship: Committees: Committees -> Committees: Comments (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '4d0f8874-4855-40e3-a92a-f476a3fa5d7d' OR ([EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND [RelatedEntityID] = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF' AND [RelatedEntityJoinField] = 'CommitteeID')
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('4d0f8874-4855-40e3-a92a-f476a3fa5d7d', 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF', 'CommitteeID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Committees -> Committees: Artifacts (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '5679460b-1f7d-4977-bf84-83491e2be12b' OR ([EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND [RelatedEntityID] = '272BEFB5-727A-4525-B235-775A56B7ACBB' AND [RelatedEntityJoinField] = 'CommitteeID')
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('5679460b-1f7d-4977-bf84-83491e2be12b', 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', '272BEFB5-727A-4525-B235-775A56B7ACBB', 'CommitteeID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;


/* Create Entity Relationship: Committees: Committees -> Committees: Ballots (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '3b6bd477-5fae-422b-b46b-942c65761366' OR ([EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND [RelatedEntityID] = '194B3496-2829-4806-BC42-CF0724A1DD26' AND [RelatedEntityJoinField] = 'CommitteeID')
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('3b6bd477-5fae-422b-b46b-942c65761366', 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', '194B3496-2829-4806-BC42-CF0724A1DD26', 'CommitteeID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Tasks: Meetings -> Committees: Comments (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '6ac28120-f853-45e1-8502-29930e727986' OR ([EntityID] = 'D8B37817-4EB1-414C-9273-5977AB80DB63' AND [RelatedEntityID] = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF' AND [RelatedEntityJoinField] = 'MeetingID')
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('6ac28120-f853-45e1-8502-29930e727986', 'D8B37817-4EB1-414C-9273-5977AB80DB63', 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF', 'MeetingID', 'One To Many', 1, 1, 6, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Tasks: Meetings -> Committees: Motions (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '82cc6b39-6bab-4c01-92ad-a05f56633939' OR ([EntityID] = 'D8B37817-4EB1-414C-9273-5977AB80DB63' AND [RelatedEntityID] = 'AAAEE71B-D7CF-4628-BED0-59D43256E46A' AND [RelatedEntityJoinField] = 'MeetingID')
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('82cc6b39-6bab-4c01-92ad-a05f56633939', 'D8B37817-4EB1-414C-9273-5977AB80DB63', 'AAAEE71B-D7CF-4628-BED0-59D43256E46A', 'MeetingID', 'One To Many', 1, 1, 7, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Tasks: Meetings -> Committees: Artifacts (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '72127cba-d63b-41a9-950c-558bca555550' OR ([EntityID] = 'D8B37817-4EB1-414C-9273-5977AB80DB63' AND [RelatedEntityID] = '272BEFB5-727A-4525-B235-775A56B7ACBB' AND [RelatedEntityJoinField] = 'MeetingID')
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('72127cba-d63b-41a9-950c-558bca555550', 'D8B37817-4EB1-414C-9273-5977AB80DB63', '272BEFB5-727A-4525-B235-775A56B7ACBB', 'MeetingID', 'One To Many', 1, 1, 8, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Tasks: Meetings -> Committees: Minutes (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '8dc176e2-62d3-4460-9d2e-ecc35507920b' OR ([EntityID] = 'D8B37817-4EB1-414C-9273-5977AB80DB63' AND [RelatedEntityID] = '0EC944F9-F908-4662-87B2-E57077A873FF' AND [RelatedEntityJoinField] = 'MeetingID')
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('8dc176e2-62d3-4460-9d2e-ecc35507920b', 'D8B37817-4EB1-414C-9273-5977AB80DB63', '0EC944F9-F908-4662-87B2-E57077A873FF', 'MeetingID', 'One To Many', 1, 1, 9, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Tasks: Meetings -> Committees: Minutes (One To Many via ApprovedByMeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '0759db96-d2b8-44ef-8fad-c40f4dcf846d' OR ([EntityID] = 'D8B37817-4EB1-414C-9273-5977AB80DB63' AND [RelatedEntityID] = '0EC944F9-F908-4662-87B2-E57077A873FF' AND [RelatedEntityJoinField] = 'ApprovedByMeetingID')
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('0759db96-d2b8-44ef-8fad-c40f4dcf846d', 'D8B37817-4EB1-414C-9273-5977AB80DB63', '0EC944F9-F908-4662-87B2-E57077A873FF', 'ApprovedByMeetingID', 'One To Many', 1, 1, 10, GETUTCDATE(), GETUTCDATE())
   END;


/* Create Entity Relationship: MJ_BizApps_Collaboration: Spaces -> Committees: Committees (One To Many via ID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'd4781366-8acf-446b-8b05-015422ce6532' OR ([EntityID] = '3648DC35-1DC4-4ED6-A1A6-5D87271A54DB' AND [RelatedEntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND [RelatedEntityJoinField] = 'ID')
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('d4781366-8acf-446b-8b05-015422ce6532', '3648DC35-1DC4-4ED6-A1A6-5D87271A54DB', 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', 'ID', 'One To Many', 1, 1, 13, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Collaboration: Spaces -> Committees: Terms (One To Many via ID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '936b9518-3fa3-477a-a109-e06e853bcbad' OR ([EntityID] = '3648DC35-1DC4-4ED6-A1A6-5D87271A54DB' AND [RelatedEntityID] = '87BEDFA6-F149-4AF2-993C-81BD01169584' AND [RelatedEntityJoinField] = 'ID')
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('936b9518-3fa3-477a-a109-e06e853bcbad', '3648DC35-1DC4-4ED6-A1A6-5D87271A54DB', '87BEDFA6-F149-4AF2-993C-81BD01169584', 'ID', 'One To Many', 1, 1, 14, GETUTCDATE(), GETUTCDATE())
   END;

/* SQL text to sync schema info from database schemas */
EXEC [${mjSchema}].[spUpdateSchemaInfoFromDatabase] @ExcludedSchemaNames='', @IncludedSchemaNames='${flyway:defaultSchema}';

