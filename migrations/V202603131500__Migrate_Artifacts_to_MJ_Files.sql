-- Migration: Migrate Committees Artifacts to MJ: Files
-- Moves document data from the Committees-specific Artifact entity to the core
-- MJ: Files entity with File Entity Record Links for context associations.
-- Idempotent: safe to re-run if partially or fully applied.
--
-- Prerequisites: V202603131400__v5.12.x__Add_External_URL_Support_to_Files.sql
-- must have been applied first (adds URL, ExternalID, FileSize columns and
-- seeds ExternalURL providers + file categories).

---------------------------------------------------------------------------
-- 1. Migrate Artifact rows to MJ: Files (skip if already migrated)
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM ${flyway:defaultSchema}.[File] f INNER JOIN __mj_Committees.Artifact a ON f.ID = a.ID)
BEGIN
    INSERT INTO ${flyway:defaultSchema}.[File]
        (ID, [Name], [Description], [ProviderID], [ContentType], [URL], [ExternalID], [FileSize], [Status], [CategoryID])
    SELECT
        a.ID,
        a.Title,
        a.Description,
        CASE a.Provider
            WHEN 'GoogleDrive' THEN 'A1B2C3D4-E5F6-4A7B-8C9D-0E1F2A3B4C5D'
            WHEN 'SharePoint'  THEN 'B2C3D4E5-F6A7-4B8C-9D0E-1F2A3B4C5D6E'
            WHEN 'OneDrive'    THEN 'B2C3D4E5-F6A7-4B8C-9D0E-1F2A3B4C5D6E'
            WHEN 'Dropbox'     THEN 'C3D4E5F6-A7B8-4C9D-0E1F-2A3B4C5D6E7F'
            WHEN 'Box'         THEN 'D4E5F6A7-B8C9-4D0E-1F2A-3B4C5D6E7F8A'
            ELSE                    'E5F6A7B8-C9D0-4E1F-2A3B-4C5D6E7F8A9B'
        END,
        a.MimeType,
        a.URL,
        a.ExternalID,
        a.FileSize,
        'Uploaded',
        CASE at.Name
            WHEN 'Document'     THEN 'F6A7B8C9-D0E1-4F2A-3B4C-5D6E7F8A9B0C'
            WHEN 'Spreadsheet'  THEN 'A7B8C9D0-E1F2-4A3B-4C5D-6E7F8A9B0C1D'
            WHEN 'Presentation' THEN 'B8C9D0E1-F2A3-4B4C-5D6E-7F8A9B0C1D2E'
            WHEN 'Minutes'      THEN 'C9D0E1F2-A3B4-4C5D-6E7F-8A9B0C1D2E3F'
            WHEN 'Agenda'       THEN 'D0E1F2A3-B4C5-4D6E-7F8A-9B0C1D2E3F4A'
            WHEN 'Recording'    THEN 'E1F2A3B4-C5D6-4E7F-8A9B-0C1D2E3F4A5B'
            WHEN 'Transcript'   THEN 'F2A3B4C5-D6E7-4F8A-9B0C-1D2E3F4A5B6C'
            WHEN 'Image'        THEN 'A3B4C5D6-E7F8-4A9B-0C1D-2E3F4A5B6C7D'
            ELSE NULL
        END
    FROM __mj_Committees.Artifact a
    LEFT JOIN __mj_Committees.ArtifactType at ON a.ArtifactTypeID = at.ID;
END
GO

---------------------------------------------------------------------------
-- 2. Create File Entity Record Links for context associations
--    (skip if links already exist for migrated artifacts)
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM ${flyway:defaultSchema}.[FileEntityRecordLink] ferl INNER JOIN __mj_Committees.Artifact a ON ferl.FileID = a.ID)
BEGIN
    DECLARE @CommitteeEntityID UNIQUEIDENTIFIER = (SELECT TOP 1 ID FROM ${flyway:defaultSchema}.[Entity] WHERE Name = 'Committees: Committees');
    DECLARE @MeetingEntityID UNIQUEIDENTIFIER = (SELECT TOP 1 ID FROM ${flyway:defaultSchema}.[Entity] WHERE Name = 'Committees: Meetings');
    DECLARE @AgendaItemEntityID UNIQUEIDENTIFIER = (SELECT TOP 1 ID FROM ${flyway:defaultSchema}.[Entity] WHERE Name = 'Committees: Agenda Items');
    DECLARE @ActionItemEntityID UNIQUEIDENTIFIER = (SELECT TOP 1 ID FROM ${flyway:defaultSchema}.[Entity] WHERE Name = 'Committees: Action Items');

    -- Link to Committees
    INSERT INTO ${flyway:defaultSchema}.[FileEntityRecordLink] (FileID, EntityID, RecordID)
    SELECT a.ID, @CommitteeEntityID, CAST(a.CommitteeID AS NVARCHAR(750))
    FROM __mj_Committees.Artifact a
    WHERE a.CommitteeID IS NOT NULL AND @CommitteeEntityID IS NOT NULL;

    -- Link to Meetings
    INSERT INTO ${flyway:defaultSchema}.[FileEntityRecordLink] (FileID, EntityID, RecordID)
    SELECT a.ID, @MeetingEntityID, CAST(a.MeetingID AS NVARCHAR(750))
    FROM __mj_Committees.Artifact a
    WHERE a.MeetingID IS NOT NULL AND @MeetingEntityID IS NOT NULL;

    -- Link to Agenda Items
    INSERT INTO ${flyway:defaultSchema}.[FileEntityRecordLink] (FileID, EntityID, RecordID)
    SELECT a.ID, @AgendaItemEntityID, CAST(a.AgendaItemID AS NVARCHAR(750))
    FROM __mj_Committees.Artifact a
    WHERE a.AgendaItemID IS NOT NULL AND @AgendaItemEntityID IS NOT NULL;

    -- Link to Action Items
    INSERT INTO ${flyway:defaultSchema}.[FileEntityRecordLink] (FileID, EntityID, RecordID)
    SELECT a.ID, @ActionItemEntityID, CAST(a.ActionItemID AS NVARCHAR(750))
    FROM __mj_Committees.Artifact a
    WHERE a.ActionItemID IS NOT NULL AND @ActionItemEntityID IS NOT NULL;
END
GO

---------------------------------------------------------------------------
-- 3. Migrate Minute table FK from ArtifactID to FileID
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('__mj_Committees.Minute') AND name = 'FileID')
    ALTER TABLE __mj_Committees.Minute ADD FileID UNIQUEIDENTIFIER NULL;
GO

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('__mj_Committees.Minute') AND name = 'ArtifactID')
  AND EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('__mj_Committees.Minute') AND name = 'FileID')
    UPDATE __mj_Committees.Minute SET FileID = ArtifactID WHERE FileID IS NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Minute_File')
    ALTER TABLE __mj_Committees.Minute ADD
        CONSTRAINT FK_Minute_File FOREIGN KEY (FileID) REFERENCES ${flyway:defaultSchema}.[File](ID);
GO

---------------------------------------------------------------------------
-- 4. Mark Artifact tables as deprecated (do not drop yet)
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('__mj_Committees.Artifact') AND minor_id = 0 AND name = 'MS_Description')
    EXEC sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'DEPRECATED: Migrated to MJ: Files + File Entity Record Links. Will be dropped in a future migration.',
        @level0type = N'SCHEMA', @level0name = '__mj_Committees',
        @level1type = N'TABLE',  @level1name = N'Artifact';
ELSE
    EXEC sp_updateextendedproperty
        @name = N'MS_Description',
        @value = N'DEPRECATED: Migrated to MJ: Files + File Entity Record Links. Will be dropped in a future migration.',
        @level0type = N'SCHEMA', @level0name = '__mj_Committees',
        @level1type = N'TABLE',  @level1name = N'Artifact';
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('__mj_Committees.ArtifactType') AND minor_id = 0 AND name = 'MS_Description')
    EXEC sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'DEPRECATED: Migrated to MJ: File Categories. Will be dropped in a future migration.',
        @level0type = N'SCHEMA', @level0name = '__mj_Committees',
        @level1type = N'TABLE',  @level1name = N'ArtifactType';
ELSE
    EXEC sp_updateextendedproperty
        @name = N'MS_Description',
        @value = N'DEPRECATED: Migrated to MJ: File Categories. Will be dropped in a future migration.',
        @level0type = N'SCHEMA', @level0name = '__mj_Committees',
        @level1type = N'TABLE',  @level1name = N'ArtifactType';
GO
