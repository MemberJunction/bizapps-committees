-- Migration: Migrate Committees Artifacts to MJ: Files
-- Moves document data from the Committees-specific Artifact entity to the core
-- MJ: Files entity with File Entity Record Links for context associations.
--
-- Prerequisites: V202603131400__v5.12.x__Add_External_URL_Support_to_Files.sql
-- must have been applied first (adds URL, ExternalID, FileSize columns and
-- seeds ExternalURL providers + file categories).

---------------------------------------------------------------------------
-- 1. Migrate Artifact rows to MJ: Files
--    Maps Provider enum → seeded FileStorageProvider IDs
--    Maps ArtifactTypeID → seeded FileCategory IDs
---------------------------------------------------------------------------

-- Provider ID mapping (from core migration seed):
--   GoogleDrive  → A1B2C3D4-E5F6-4A7B-8C9D-0E1F2A3B4C5D (Google Docs)
--   SharePoint   → B2C3D4E5-F6A7-4B8C-9D0E-1F2A3B4C5D6E (SharePoint / OneDrive)
--   OneDrive     → B2C3D4E5-F6A7-4B8C-9D0E-1F2A3B4C5D6E (SharePoint / OneDrive)
--   Dropbox      → C3D4E5F6-A7B8-4C9D-0E1F-2A3B4C5D6E7F (Dropbox)
--   Box          → D4E5F6A7-B8C9-4D0E-1F2A-3B4C5D6E7F8A (Box)
--   URL          → E5F6A7B8-C9D0-4E1F-2A3B-4C5D6E7F8A9B (External URL)

-- ArtifactType → FileCategory mapping (from core migration seed):
--   Document     → F6A7B8C9-D0E1-4F2A-3B4C-5D6E7F8A9B0C
--   Spreadsheet  → A7B8C9D0-E1F2-4A3B-4C5D-6E7F8A9B0C1D
--   Presentation → B8C9D0E1-F2A3-4B4C-5D6E-7F8A9B0C1D2E
--   Minutes      → C9D0E1F2-A3B4-4C5D-6E7F-8A9B0C1D2E3F
--   Agenda       → D0E1F2A3-B4C5-4D6E-7F8A-9B0C1D2E3F4A
--   Recording    → E1F2A3B4-C5D6-4E7F-8A9B-0C1D2E3F4A5B
--   Transcript   → F2A3B4C5-D6E7-4F8A-9B0C-1D2E3F4A5B6C
--   Image        → A3B4C5D6-E7F8-4A9B-0C1D-2E3F4A5B6C7D

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
GO

---------------------------------------------------------------------------
-- 2. Create File Entity Record Links for context associations
--    Each non-null FK on Artifact becomes a link record.
---------------------------------------------------------------------------

-- Helper: Look up Entity IDs for the link records
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
GO

---------------------------------------------------------------------------
-- 3. Migrate Minute table FK from ArtifactID to FileID
--    Since we used the same ID for the File record, FileID = ArtifactID
---------------------------------------------------------------------------
ALTER TABLE __mj_Committees.Minute ADD FileID UNIQUEIDENTIFIER NULL;
GO

UPDATE __mj_Committees.Minute SET FileID = ArtifactID;
GO

ALTER TABLE __mj_Committees.Minute ADD
    CONSTRAINT FK_Minute_File FOREIGN KEY (FileID) REFERENCES ${flyway:defaultSchema}.[File](ID);
GO

---------------------------------------------------------------------------
-- 4. Mark Artifact tables as deprecated (do not drop yet)
--    Will be dropped in a future migration after verification.
---------------------------------------------------------------------------
EXEC sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'DEPRECATED: Migrated to MJ: Files + File Entity Record Links. Will be dropped in a future migration.',
    @level0type = N'SCHEMA', @level0name = '__mj_Committees',
    @level1type = N'TABLE',  @level1name = N'Artifact';
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'DEPRECATED: Migrated to MJ: File Categories. Will be dropped in a future migration.',
    @level0type = N'SCHEMA', @level0name = '__mj_Committees',
    @level1type = N'TABLE',  @level1name = N'ArtifactType';
GO
