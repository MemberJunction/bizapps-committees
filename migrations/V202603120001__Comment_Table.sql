-- Comment table for threaded discussions on committee entities
-- Phase 1B: Comment/Discussion threading
-- Depends on: V202602150002__Committees_Schema_and_Tables.sql

---------------------------------------------------------------------------
-- Threaded comments attachable to meetings, agenda items, action items,
-- or artifacts. Uses direct FK pattern (matching Artifact table design).
-- CommitteeID is always set for easy scoping/filtering.
---------------------------------------------------------------------------
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
-- EXTENDED PROPERTIES: Comment table
---------------------------------------------------------------------------
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Threaded discussion comments on committee meetings, agenda items, action items, and documents', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Comment';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Committee this comment belongs to (always set for easy filtering)', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Comment', @level2type = N'COLUMN', @level2name = N'CommitteeID';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Optional meeting this comment is attached to', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Comment', @level2type = N'COLUMN', @level2name = N'MeetingID';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Optional agenda item this comment is attached to', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Comment', @level2type = N'COLUMN', @level2name = N'AgendaItemID';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Optional action item this comment is attached to', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Comment', @level2type = N'COLUMN', @level2name = N'ActionItemID';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Optional artifact/document this comment is attached to', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Comment', @level2type = N'COLUMN', @level2name = N'ArtifactID';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Parent comment for threading; NULL for top-level comments', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Comment', @level2type = N'COLUMN', @level2name = N'ParentCommentID';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Person who wrote the comment', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Comment', @level2type = N'COLUMN', @level2name = N'PersonID';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Comment body text', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Comment', @level2type = N'COLUMN', @level2name = N'CommentText';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'JSON array of PersonIDs mentioned via @mentions', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Comment', @level2type = N'COLUMN', @level2name = N'MentionedPersonIDs';
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Whether this comment thread has been resolved', @level0type = N'SCHEMA', @level0name = N'__mj_Committees', @level1type = N'TABLE', @level1name = N'Comment', @level2type = N'COLUMN', @level2name = N'IsResolved';
GO
