-- Migration: Minute table — add MeetingID + Content, relax ArtifactID
--
-- Changes:
--   1. Drop UNIQUE constraint on ArtifactID (blocks nullable change)
--   2. Drop FK constraint on ArtifactID (blocks nullable change)
--   3. Make ArtifactID nullable (Artifact system is deprecated; minutes can now
--      be stored as markdown content directly on the record)
--   4. Add MeetingID column with FK to Meeting (links minutes to a specific meeting)
--   5. Add Content column for the markdown minutes body
--   6. Add index on MeetingID for query performance

-- 1. Drop constraints that block the ArtifactID column change
IF EXISTS (
    SELECT 1 FROM sys.key_constraints
    WHERE name = 'UQ_Minute_Artifact'
      AND parent_object_id = OBJECT_ID('[__mj_Committees].[Minute]')
)
    ALTER TABLE [__mj_Committees].[Minute] DROP CONSTRAINT UQ_Minute_Artifact;
GO

IF EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = 'FK_Minute_Artifact'
      AND parent_object_id = OBJECT_ID('[__mj_Committees].[Minute]')
)
    ALTER TABLE [__mj_Committees].[Minute] DROP CONSTRAINT FK_Minute_Artifact;
GO

-- 2. Make ArtifactID nullable
ALTER TABLE [__mj_Committees].[Minute]
    ALTER COLUMN ArtifactID UNIQUEIDENTIFIER NULL;
GO

-- 3. Add MeetingID (nullable — no existing rows, but allows flexibility)
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'Minute' AND COLUMN_NAME = 'MeetingID'
)
BEGIN
    ALTER TABLE [__mj_Committees].[Minute]
        ADD MeetingID UNIQUEIDENTIFIER NULL
        CONSTRAINT FK_Minute_Meeting FOREIGN KEY REFERENCES [__mj_Committees].[Meeting](ID);
END
GO

-- 4. Add Content column for markdown minutes body
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'Minute' AND COLUMN_NAME = 'Content'
)
BEGIN
    ALTER TABLE [__mj_Committees].[Minute]
        ADD Content NVARCHAR(MAX) NULL;
END
GO

-- 5. Index on MeetingID for performance
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = 'IDX_Minute_MeetingID'
      AND object_id = OBJECT_ID('[__mj_Committees].[Minute]')
)
    CREATE INDEX IDX_Minute_MeetingID ON [__mj_Committees].[Minute] (MeetingID);
GO
