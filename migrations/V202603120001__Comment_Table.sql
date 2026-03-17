-- Comment table for threaded discussions on committee entities
-- Phase 1B: Comment/Discussion threading
-- Depends on: V202602150002__Committees_Schema_and_Tables.sql

---------------------------------------------------------------------------
-- Threaded comments attachable to meetings, agenda items, action items,
-- or artifacts. Uses direct FK pattern (matching Artifact table design).
-- CommitteeID is always set for easy scoping/filtering.
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'Comment')
CREATE TABLE __mj_Committees.Comment (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    CommitteeID UNIQUEIDENTIFIER NOT NULL,
    MeetingID UNIQUEIDENTIFIER,
    AgendaItemID UNIQUEIDENTIFIER,
    ActionItemID UNIQUEIDENTIFIER,
    ArtifactID UNIQUEIDENTIFIER,
    ParentCommentID UNIQUEIDENTIFIER,
    PersonID UNIQUEIDENTIFIER NOT NULL,
    CommentText NVARCHAR(MAX) NOT NULL,
    MentionedPersonIDs NVARCHAR(MAX),
    IsResolved BIT NOT NULL DEFAULT 0,
    CONSTRAINT PK_Comment PRIMARY KEY (ID),
    CONSTRAINT FK_Comment_Committee FOREIGN KEY (CommitteeID) REFERENCES __mj_Committees.Committee(ID),
    CONSTRAINT FK_Comment_Meeting FOREIGN KEY (MeetingID) REFERENCES __mj_Committees.Meeting(ID),
    CONSTRAINT FK_Comment_AgendaItem FOREIGN KEY (AgendaItemID) REFERENCES __mj_Committees.AgendaItem(ID),
    CONSTRAINT FK_Comment_ActionItem FOREIGN KEY (ActionItemID) REFERENCES __mj_Committees.ActionItem(ID),
    CONSTRAINT FK_Comment_Artifact FOREIGN KEY (ArtifactID) REFERENCES __mj_Committees.Artifact(ID),
    CONSTRAINT FK_Comment_Parent FOREIGN KEY (ParentCommentID) REFERENCES __mj_Committees.Comment(ID),
    CONSTRAINT FK_Comment_Person FOREIGN KEY (PersonID) REFERENCES __mj_BizAppsCommon.Person(ID)
);
GO

---------------------------------------------------------------------------
-- EXTENDED PROPERTIES: Comment table (skip if already present)
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('__mj_Committees.Comment') AND minor_id = 0 AND name = 'MS_Description')
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Threaded discussion comments on committee meetings, agenda items, action items, and documents', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Comment';
GO
