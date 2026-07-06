/* SQL text to update entity field related entity name field map for entity field ID 45D954CA-FBED-4FBD-AACF-B8EC5F6DFEA1 */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='45D954CA-FBED-4FBD-AACF-B8EC5F6DFEA1', @RelatedEntityNameFieldMap='Committee'

/* SQL text to update entity field related entity name field map for entity field ID B96B872B-94A0-422B-B1F2-C5756DF46E0B */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='B96B872B-94A0-422B-B1F2-C5756DF46E0B', @RelatedEntityNameFieldMap='Meeting'

/* SQL text to update entity field related entity name field map for entity field ID A3B47465-C656-4B1A-83B5-548670731FF6 */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='A3B47465-C656-4B1A-83B5-548670731FF6', @RelatedEntityNameFieldMap='AgendaItem'

/* SQL text to update entity field related entity name field map for entity field ID 3F9B52B6-631C-477D-AC34-A86E1144119A */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='3F9B52B6-631C-477D-AC34-A86E1144119A', @RelatedEntityNameFieldMap='ActionItem'

/* SQL text to update entity field related entity name field map for entity field ID AFC0ED45-BB27-41F3-A014-6DC713EAC021 */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='AFC0ED45-BB27-41F3-A014-6DC713EAC021', @RelatedEntityNameFieldMap='Artifact'

/* SQL text to update entity field related entity name field map for entity field ID 1879C6B8-7969-4E39-AF36-52E28898CDBD */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='1879C6B8-7969-4E39-AF36-52E28898CDBD', @RelatedEntityNameFieldMap='ParentComment'

/* SQL text to update entity field related entity name field map for entity field ID 5F7B6CEA-5252-4BB0-93F4-B2AA60E21A86 */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='5F7B6CEA-5252-4BB0-93F4-B2AA60E21A86', @RelatedEntityNameFieldMap='Person'


/* Create Entity Relationship: Agenda Items -> Comments (One To Many via AgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [__mj].[EntityRelationship] WHERE [ID] = '5c9faaea-8071-456b-b824-6d0834c59051'
   )
   BEGIN
      INSERT INTO [__mj].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('5c9faaea-8071-456b-b824-6d0834c59051', '5BC3D9BB-94E3-4138-9E17-362C5256DA58', '9DC1631E-F623-44FB-A796-A70BE70923D1', 'AgendaItemID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: Artifacts -> Comments (One To Many via ArtifactID) */
   IF NOT EXISTS (
      SELECT 1 FROM [__mj].[EntityRelationship] WHERE [ID] = '29aaca8d-cdf4-44b7-9693-31c6cb3a65b6'
   )
   BEGIN
      INSERT INTO [__mj].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('29aaca8d-cdf4-44b7-9693-31c6cb3a65b6', 'DC523BBE-93DC-49FC-B066-621D3C8162E2', '9DC1631E-F623-44FB-A796-A70BE70923D1', 'ArtifactID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: Committees -> Comments (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [__mj].[EntityRelationship] WHERE [ID] = '127d7b0d-ab29-45ce-9480-b5aabe78170f'
   )
   BEGIN
      INSERT INTO [__mj].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('127d7b0d-ab29-45ce-9480-b5aabe78170f', '2B971E92-BBCE-462C-9868-807F9C04430D', '9DC1631E-F623-44FB-A796-A70BE70923D1', 'CommitteeID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: Meetings -> Comments (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [__mj].[EntityRelationship] WHERE [ID] = '2f8dcbdb-b792-4ca7-b9d2-cb95d50844d5'
   )
   BEGIN
      INSERT INTO [__mj].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('2f8dcbdb-b792-4ca7-b9d2-cb95d50844d5', 'C6C5BD14-0D36-4442-812E-97F802728524', '9DC1631E-F623-44FB-A796-A70BE70923D1', 'MeetingID', 'One To Many', 1, 1, 4, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: Comments -> Comments (One To Many via ParentCommentID) */
   IF NOT EXISTS (
      SELECT 1 FROM [__mj].[EntityRelationship] WHERE [ID] = '609d8d3f-9c5e-4db0-bb86-7a96109be1af'
   )
   BEGIN
      INSERT INTO [__mj].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('609d8d3f-9c5e-4db0-bb86-7a96109be1af', '9DC1631E-F623-44FB-A796-A70BE70923D1', '9DC1631E-F623-44FB-A796-A70BE70923D1', 'ParentCommentID', 'One To Many', 1, 1, 5, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: MJ.BizApps.Common: People -> Comments (One To Many via PersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [__mj].[EntityRelationship] WHERE [ID] = '0b41d749-11b9-4db4-945b-b497a1e3760d'
   )
   BEGIN
      INSERT INTO [__mj].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('0b41d749-11b9-4db4-945b-b497a1e3760d', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '9DC1631E-F623-44FB-A796-A70BE70923D1', 'PersonID', 'One To Many', 1, 1, 6, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: Action Items -> Comments (One To Many via ActionItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [__mj].[EntityRelationship] WHERE [ID] = '582b25be-32bc-4d9f-aadf-776240366ba0'
   )
   BEGIN
      INSERT INTO [__mj].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('582b25be-32bc-4d9f-aadf-776240366ba0', 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', '9DC1631E-F623-44FB-A796-A70BE70923D1', 'ActionItemID', 'One To Many', 1, 1, 7, GETUTCDATE(), GETUTCDATE())
   END;
                    

/* SQL text to update entity field related entity name field map for entity field ID 45D954CA-FBED-4FBD-AACF-B8EC5F6DFEA1 */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='45D954CA-FBED-4FBD-AACF-B8EC5F6DFEA1', @RelatedEntityNameFieldMap='Committee'

/* SQL text to update entity field related entity name field map for entity field ID B96B872B-94A0-422B-B1F2-C5756DF46E0B */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='B96B872B-94A0-422B-B1F2-C5756DF46E0B', @RelatedEntityNameFieldMap='Meeting'

/* SQL text to update entity field related entity name field map for entity field ID A3B47465-C656-4B1A-83B5-548670731FF6 */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='A3B47465-C656-4B1A-83B5-548670731FF6', @RelatedEntityNameFieldMap='AgendaItem'

/* SQL text to update entity field related entity name field map for entity field ID 3F9B52B6-631C-477D-AC34-A86E1144119A */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='3F9B52B6-631C-477D-AC34-A86E1144119A', @RelatedEntityNameFieldMap='ActionItem'

/* SQL text to update entity field related entity name field map for entity field ID AFC0ED45-BB27-41F3-A014-6DC713EAC021 */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='AFC0ED45-BB27-41F3-A014-6DC713EAC021', @RelatedEntityNameFieldMap='Artifact'

/* SQL text to update entity field related entity name field map for entity field ID 1879C6B8-7969-4E39-AF36-52E28898CDBD */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='1879C6B8-7969-4E39-AF36-52E28898CDBD', @RelatedEntityNameFieldMap='ParentComment'

/* SQL text to update entity field related entity name field map for entity field ID 5F7B6CEA-5252-4BB0-93F4-B2AA60E21A86 */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='5F7B6CEA-5252-4BB0-93F4-B2AA60E21A86', @RelatedEntityNameFieldMap='Person'

/* Root ID Function SQL for Comments.ParentCommentID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Comments
-- Item: fnCommentParentCommentID_GetRootID
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- ROOT ID FUNCTION FOR: [Comment].[ParentCommentID]
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[fnCommentParentCommentID_GetRootID]', 'IF') IS NOT NULL
    DROP FUNCTION [__mj_Committees].[fnCommentParentCommentID_GetRootID];
GO

CREATE FUNCTION [__mj_Committees].[fnCommentParentCommentID_GetRootID]
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
            [__mj_Committees].[Comment]
        WHERE
            [ID] = COALESCE(@ParentID, @RecordID)

        UNION ALL

        SELECT
            c.[ID],
            c.[ParentCommentID],
            c.[ID] AS [RootParentID],
            p.[Depth] + 1 AS [Depth]
        FROM
            [__mj_Committees].[Comment] c
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


/* Base View SQL for Comments */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Comments
-- Item: vwComments
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Comments
-----               SCHEMA:      __mj_Committees
-----               BASE TABLE:  Comment
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[vwComments]', 'V') IS NOT NULL
    DROP VIEW [__mj_Committees].[vwComments];
GO

CREATE VIEW [__mj_Committees].[vwComments]
AS
SELECT
    c.*,
    mjCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjCommitteesMeeting_MeetingID.[Title] AS [Meeting],
    mjCommitteesAgendaItem_AgendaItemID.[Title] AS [AgendaItem],
    mjCommitteesActionItem_ActionItemID.[Title] AS [ActionItem],
    mjCommitteesArtifact_ArtifactID.[Title] AS [Artifact],
    mjCommitteesComment_ParentCommentID.[CommentText] AS [ParentComment],
    mjBizAppsCommonPerson_PersonID.[DisplayName] AS [Person],
    root_ParentCommentID.RootID AS [RootParentCommentID]
FROM
    [__mj_Committees].[Comment] AS c
INNER JOIN
    [__mj_Committees].[Committee] AS mjCommitteesCommittee_CommitteeID
  ON
    [c].[CommitteeID] = mjCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [__mj_Committees].[Meeting] AS mjCommitteesMeeting_MeetingID
  ON
    [c].[MeetingID] = mjCommitteesMeeting_MeetingID.[ID]
LEFT OUTER JOIN
    [__mj_Committees].[AgendaItem] AS mjCommitteesAgendaItem_AgendaItemID
  ON
    [c].[AgendaItemID] = mjCommitteesAgendaItem_AgendaItemID.[ID]
LEFT OUTER JOIN
    [__mj_Committees].[ActionItem] AS mjCommitteesActionItem_ActionItemID
  ON
    [c].[ActionItemID] = mjCommitteesActionItem_ActionItemID.[ID]
LEFT OUTER JOIN
    [__mj_Committees].[Artifact] AS mjCommitteesArtifact_ArtifactID
  ON
    [c].[ArtifactID] = mjCommitteesArtifact_ArtifactID.[ID]
LEFT OUTER JOIN
    [__mj_Committees].[Comment] AS mjCommitteesComment_ParentCommentID
  ON
    [c].[ParentCommentID] = mjCommitteesComment_ParentCommentID.[ID]
INNER JOIN
    [__mj_BizAppsCommon].[vwPeopleExtended] AS mjBizAppsCommonPerson_PersonID
  ON
    [c].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
OUTER APPLY
    [__mj_Committees].[fnCommentParentCommentID_GetRootID]([c].[ID], [c].[ParentCommentID]) AS root_ParentCommentID
GO
GRANT SELECT ON [__mj_Committees].[vwComments] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Comments */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Comments
-- Item: Permissions for vwComments
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [__mj_Committees].[vwComments] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for Comments */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Comments
-- Item: spCreateComment
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Comment
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spCreateComment]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spCreateComment];
GO

CREATE PROCEDURE [__mj_Committees].[spCreateComment]
    @ID uniqueidentifier = NULL,
    @CommitteeID uniqueidentifier,
    @MeetingID uniqueidentifier,
    @AgendaItemID uniqueidentifier,
    @ActionItemID uniqueidentifier,
    @ArtifactID uniqueidentifier,
    @ParentCommentID uniqueidentifier,
    @PersonID uniqueidentifier,
    @CommentText nvarchar(MAX),
    @MentionedPersonIDs nvarchar(MAX),
    @IsResolved bit = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [__mj_Committees].[Comment]
            (
                [ID],
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [ActionItemID],
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
                @MeetingID,
                @AgendaItemID,
                @ActionItemID,
                @ArtifactID,
                @ParentCommentID,
                @PersonID,
                @CommentText,
                @MentionedPersonIDs,
                ISNULL(@IsResolved, 0)
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [__mj_Committees].[Comment]
            (
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [ActionItemID],
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
                @MeetingID,
                @AgendaItemID,
                @ActionItemID,
                @ArtifactID,
                @ParentCommentID,
                @PersonID,
                @CommentText,
                @MentionedPersonIDs,
                ISNULL(@IsResolved, 0)
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [__mj_Committees].[vwComments] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [__mj_Committees].[spCreateComment] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Comments */

GRANT EXECUTE ON [__mj_Committees].[spCreateComment] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for Comments */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Comments
-- Item: spUpdateComment
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Comment
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spUpdateComment]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spUpdateComment];
GO

CREATE PROCEDURE [__mj_Committees].[spUpdateComment]
    @ID uniqueidentifier,
    @CommitteeID uniqueidentifier,
    @MeetingID uniqueidentifier,
    @AgendaItemID uniqueidentifier,
    @ActionItemID uniqueidentifier,
    @ArtifactID uniqueidentifier,
    @ParentCommentID uniqueidentifier,
    @PersonID uniqueidentifier,
    @CommentText nvarchar(MAX),
    @MentionedPersonIDs nvarchar(MAX),
    @IsResolved bit
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [__mj_Committees].[Comment]
    SET
        [CommitteeID] = @CommitteeID,
        [MeetingID] = @MeetingID,
        [AgendaItemID] = @AgendaItemID,
        [ActionItemID] = @ActionItemID,
        [ArtifactID] = @ArtifactID,
        [ParentCommentID] = @ParentCommentID,
        [PersonID] = @PersonID,
        [CommentText] = @CommentText,
        [MentionedPersonIDs] = @MentionedPersonIDs,
        [IsResolved] = @IsResolved
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [__mj_Committees].[vwComments] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [__mj_Committees].[vwComments]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [__mj_Committees].[spUpdateComment] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Comment table
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[trgUpdateComment]', 'TR') IS NOT NULL
    DROP TRIGGER [__mj_Committees].[trgUpdateComment];
GO
CREATE TRIGGER [__mj_Committees].trgUpdateComment
ON [__mj_Committees].[Comment]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [__mj_Committees].[Comment]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [__mj_Committees].[Comment] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Comments */

GRANT EXECUTE ON [__mj_Committees].[spUpdateComment] TO [cdp_Developer], [cdp_Integration]



/* spDelete SQL for Comments */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Comments
-- Item: spDeleteComment
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Comment
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spDeleteComment]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spDeleteComment];
GO

CREATE PROCEDURE [__mj_Committees].[spDeleteComment]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [__mj_Committees].[Comment]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [__mj_Committees].[spDeleteComment] TO [cdp_Integration]
    

/* spDelete Permissions for Comments */

GRANT EXECUTE ON [__mj_Committees].[spDeleteComment] TO [cdp_Integration]



/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '9c96a87e-a2c0-4521-938d-0c3c144a12b5' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'Committee')) BEGIN
         INSERT INTO [__mj].[EntityField]
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
            '9c96a87e-a2c0-4521-938d-0c3c144a12b5',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
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
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = 'caa19794-502b-4094-a59d-dbf8d67195c4' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'Meeting')) BEGIN
         INSERT INTO [__mj].[EntityField]
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
            'caa19794-502b-4094-a59d-dbf8d67195c4',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100028,
            'Meeting',
            'Meeting',
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
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = 'a402fa29-de92-450f-b722-fcfad3976810' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'AgendaItem')) BEGIN
         INSERT INTO [__mj].[EntityField]
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
            'a402fa29-de92-450f-b722-fcfad3976810',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100029,
            'AgendaItem',
            'Agenda Item',
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
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '20c4eebe-493f-4cb6-9e1e-c2736b6e795f' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'ActionItem')) BEGIN
         INSERT INTO [__mj].[EntityField]
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
            '20c4eebe-493f-4cb6-9e1e-c2736b6e795f',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100030,
            'ActionItem',
            'Action Item',
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
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '0ccef5f1-defe-45d1-9a08-827d23d34912' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'Artifact')) BEGIN
         INSERT INTO [__mj].[EntityField]
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
            '0ccef5f1-defe-45d1-9a08-827d23d34912',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100031,
            'Artifact',
            'Artifact',
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
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '379576f2-2cd6-4e4a-a234-efc42d99cb7e' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'ParentComment')) BEGIN
         INSERT INTO [__mj].[EntityField]
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
            '379576f2-2cd6-4e4a-a234-efc42d99cb7e',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100032,
            'ParentComment',
            'Parent Comment',
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
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '6ae30ecf-97a0-440c-8ac1-cde45e0c584b' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'Person')) BEGIN
         INSERT INTO [__mj].[EntityField]
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
            '6ae30ecf-97a0-440c-8ac1-cde45e0c584b',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100033,
            'Person',
            'Person',
            NULL,
            'nvarchar',
            488,
            0,
            0,
            1,
            NULL,
            0,
            0,
            1,
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
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '87076417-4f45-4494-8343-01338e573e42' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'RootParentCommentID')) BEGIN
         INSERT INTO [__mj].[EntityField]
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
            '87076417-4f45-4494-8343-01338e573e42',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100034,
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
      END

/* Set field properties for entity */

               UPDATE [__mj].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '9C96A87E-A2C0-4521-938D-0C3C144A12B5'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [__mj].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '6AE30ECF-97A0-440C-8AC1-CDE45E0C584B'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '9C96A87E-A2C0-4521-938D-0C3C144A12B5'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'CAA19794-502B-4094-A59D-DBF8D67195C4'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'A402FA29-DE92-450F-B722-FCFAD3976810'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '20C4EEBE-493F-4CB6-9E1E-C2736B6E795F'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '0CCEF5F1-DEFE-45D1-9A08-827D23D34912'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '6AE30ECF-97A0-440C-8AC1-CDE45E0C584B'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set categories for 21 fields */

-- UPDATE Entity Field Category Info Comments.ID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FE9A0C3D-8B21-4311-AE9B-E6F2FE3466ED' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.CommitteeID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '45D954CA-FBED-4FBD-AACF-B8EC5F6DFEA1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.MeetingID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B96B872B-94A0-422B-B1F2-C5756DF46E0B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.AgendaItemID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A3B47465-C656-4B1A-83B5-548670731FF6' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.ActionItemID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3F9B52B6-631C-477D-AC34-A86E1144119A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.ArtifactID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AFC0ED45-BB27-41F3-A014-6DC713EAC021' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.ParentCommentID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1879C6B8-7969-4E39-AF36-52E28898CDBD' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.PersonID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5F7B6CEA-5252-4BB0-93F4-B2AA60E21A86' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.CommentText 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FAD8C690-0A7C-492E-823F-2EFE7BAF7F7E' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.MentionedPersonIDs 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Mentioned Person IDs',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6AB58027-5DBB-445C-81B3-54BED4B6E3E7' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.IsResolved 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Is Resolved',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B3D661E2-C7CD-487D-837F-FA30CCF5531A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.__mj_CreatedAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8878AB25-82A8-4363-949F-CF49E859CDDA' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.__mj_UpdatedAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AE166C9F-68FD-498E-B5CB-E33F10287D66' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.Committee 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9C96A87E-A2C0-4521-938D-0C3C144A12B5' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.Meeting 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CAA19794-502B-4094-A59D-DBF8D67195C4' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.AgendaItem 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A402FA29-DE92-450F-B722-FCFAD3976810' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.ActionItem 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '20C4EEBE-493F-4CB6-9E1E-C2736B6E795F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.Artifact 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0CCEF5F1-DEFE-45D1-9A08-827D23D34912' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.ParentComment 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '379576F2-2CD6-4E4A-A234-EFC42D99CB7E' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.Person 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6AE30ECF-97A0-440C-8AC1-CDE45E0C584B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.RootParentCommentID 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '87076417-4F45-4494-8343-01338E573E42' AND AutoUpdateCategory = 1

