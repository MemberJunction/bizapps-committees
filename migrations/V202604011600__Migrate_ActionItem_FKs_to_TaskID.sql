-- Migrate Artifact and Comment ActionItemID references to TaskID
-- After BizAppsTasks migration has converted ActionItems → Tasks,
-- update Artifact/Comment rows that referenced ActionItems to point
-- at the corresponding Tasks instead.

GO

---------------------------------------------------------------------------
-- 1. Add TaskID column to Artifact (nullable FK to BizAppsTasks.Task)
---------------------------------------------------------------------------
IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('__mj_Committees.Artifact') AND name = 'TaskID'
)
BEGIN
    ALTER TABLE __mj_Committees.Artifact ADD TaskID UNIQUEIDENTIFIER NULL;
    ALTER TABLE __mj_Committees.Artifact ADD CONSTRAINT FK_Artifact_Task
        FOREIGN KEY (TaskID) REFERENCES __mj_BizAppsTasks.Task(ID);
END
GO

---------------------------------------------------------------------------
-- 2. Add TaskID column to Comment (nullable FK to BizAppsTasks.Task)
---------------------------------------------------------------------------
IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('__mj_Committees.Comment') AND name = 'TaskID'
)
BEGIN
    ALTER TABLE __mj_Committees.Comment ADD TaskID UNIQUEIDENTIFIER NULL;
    ALTER TABLE __mj_Committees.Comment ADD CONSTRAINT FK_Comment_Task
        FOREIGN KEY (TaskID) REFERENCES __mj_BizAppsTasks.Task(ID);
END
GO

---------------------------------------------------------------------------
-- 3. Migrate existing ActionItemID references to TaskID
--    Match via ActionItem.Title = Task.Name AND ActionItem.__mj_CreatedAt = Task.__mj_CreatedAt
---------------------------------------------------------------------------
UPDATE a
SET a.TaskID = t.ID
FROM __mj_Committees.Artifact a
INNER JOIN __mj_Committees.ActionItem ai ON ai.ID = a.ActionItemID
INNER JOIN __mj_BizAppsTasks.Task t
    ON t.Name = ai.Title AND t.__mj_CreatedAt = ai.__mj_CreatedAt
WHERE a.ActionItemID IS NOT NULL;
GO

UPDATE c
SET c.TaskID = t.ID
FROM __mj_Committees.Comment c
INNER JOIN __mj_Committees.ActionItem ai ON ai.ID = c.ActionItemID
INNER JOIN __mj_BizAppsTasks.Task t
    ON t.Name = ai.Title AND t.__mj_CreatedAt = ai.__mj_CreatedAt
WHERE c.ActionItemID IS NOT NULL;
GO

---------------------------------------------------------------------------
-- 4. Drop the old ActionItemID FK constraints and columns
---------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Artifact_ActionItem')
    ALTER TABLE __mj_Committees.Artifact DROP CONSTRAINT FK_Artifact_ActionItem;
GO

DROP INDEX IF EXISTS IDX_AUTO_MJ_FKEY_Artifact_ActionItemID ON __mj_Committees.Artifact;
GO

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('__mj_Committees.Artifact') AND name = 'ActionItemID')
    ALTER TABLE __mj_Committees.Artifact DROP COLUMN ActionItemID;
GO

IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Comment_ActionItem')
    ALTER TABLE __mj_Committees.Comment DROP CONSTRAINT FK_Comment_ActionItem;
GO

DROP INDEX IF EXISTS IDX_AUTO_MJ_FKEY_Comment_ActionItemID ON __mj_Committees.Comment;
GO

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('__mj_Committees.Comment') AND name = 'ActionItemID')
    ALTER TABLE __mj_Committees.Comment DROP COLUMN ActionItemID;
GO
