/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'fb296b78-9783-42b4-bb80-23c212e15d6b' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'Committee')) BEGIN
         INSERT INTO [${flyway:defaultSchema}].[EntityField]
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
            'fb296b78-9783-42b4-bb80-23c212e15d6b',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
            100034,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '50e08d44-5467-4a41-b6e1-10d92d21b319' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'Meeting')) BEGIN
         INSERT INTO [${flyway:defaultSchema}].[EntityField]
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
            '50e08d44-5467-4a41-b6e1-10d92d21b319',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
            100035,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'd1d47030-afff-416f-88e6-1542c05c27f6' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'AgendaItem')) BEGIN
         INSERT INTO [${flyway:defaultSchema}].[EntityField]
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
            'd1d47030-afff-416f-88e6-1542c05c27f6',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
            100036,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '9ff131b0-0684-4217-b7ba-1a6c68f7b6d0' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'ArtifactType')) BEGIN
         INSERT INTO [${flyway:defaultSchema}].[EntityField]
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
            '9ff131b0-0684-4217-b7ba-1a6c68f7b6d0',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
            100037,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '6a8230c0-f751-4a9c-a922-3a2d2702ca46' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'UploadedByPerson')) BEGIN
         INSERT INTO [${flyway:defaultSchema}].[EntityField]
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
            '6a8230c0-f751-4a9c-a922-3a2d2702ca46',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
            100038,
            'UploadedByPerson',
            'Uploaded By Person',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '3bc8063f-5b23-41df-8236-d818d3a16f96' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'Task')) BEGIN
         INSERT INTO [${flyway:defaultSchema}].[EntityField]
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
            '3bc8063f-5b23-41df-8236-d818d3a16f96',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
            100039,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '4e273a83-e801-4c1a-82eb-5a957c08e58d' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'Committee')) BEGIN
         INSERT INTO [${flyway:defaultSchema}].[EntityField]
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
            '4e273a83-e801-4c1a-82eb-5a957c08e58d',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100028,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '607a8298-546a-4184-ae76-60d418268daf' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'Meeting')) BEGIN
         INSERT INTO [${flyway:defaultSchema}].[EntityField]
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
            '607a8298-546a-4184-ae76-60d418268daf',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100029,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'd621166d-27cc-484e-8489-0ce91eff0383' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'AgendaItem')) BEGIN
         INSERT INTO [${flyway:defaultSchema}].[EntityField]
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
            'd621166d-27cc-484e-8489-0ce91eff0383',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100030,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1246a354-1771-4913-a09a-975598f86649' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'Artifact')) BEGIN
         INSERT INTO [${flyway:defaultSchema}].[EntityField]
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
            '1246a354-1771-4913-a09a-975598f86649',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '83acc81d-d129-4b2f-ab85-58b30fd8ea6e' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'ParentComment')) BEGIN
         INSERT INTO [${flyway:defaultSchema}].[EntityField]
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
            '83acc81d-d129-4b2f-ab85-58b30fd8ea6e',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '40c7369e-4d9e-4a8a-8958-8f19f9df72cc' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'Person')) BEGIN
         INSERT INTO [${flyway:defaultSchema}].[EntityField]
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
            '40c7369e-4d9e-4a8a-8958-8f19f9df72cc',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '35387a2c-f2e7-477f-9b0e-565e3bd3b016' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'Task')) BEGIN
         INSERT INTO [${flyway:defaultSchema}].[EntityField]
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
            '35387a2c-f2e7-477f-9b0e-565e3bd3b016',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'bbd174be-93bf-4c11-9dc0-941fcf84af5b' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'RootParentCommentID')) BEGIN
         INSERT INTO [${flyway:defaultSchema}].[EntityField]
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
            'bbd174be-93bf-4c11-9dc0-941fcf84af5b',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100035,
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

/* Index for Foreign Keys for Artifact */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Artifacts
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
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Artifact]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_CommitteeID ON [${flyway:defaultSchema}_Committees].[Artifact] ([CommitteeID]);

-- Index for foreign key MeetingID in table Artifact
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_MeetingID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Artifact]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_MeetingID ON [${flyway:defaultSchema}_Committees].[Artifact] ([MeetingID]);

-- Index for foreign key AgendaItemID in table Artifact
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_AgendaItemID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Artifact]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_AgendaItemID ON [${flyway:defaultSchema}_Committees].[Artifact] ([AgendaItemID]);

-- Index for foreign key ArtifactTypeID in table Artifact
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_ArtifactTypeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Artifact]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_ArtifactTypeID ON [${flyway:defaultSchema}_Committees].[Artifact] ([ArtifactTypeID]);

-- Index for foreign key UploadedByPersonID in table Artifact
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_UploadedByPersonID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Artifact]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_UploadedByPersonID ON [${flyway:defaultSchema}_Committees].[Artifact] ([UploadedByPersonID]);

-- Index for foreign key TaskID in table Artifact
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_TaskID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Artifact]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_TaskID ON [${flyway:defaultSchema}_Committees].[Artifact] ([TaskID]);

/* Base View SQL for Artifacts */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Artifacts
-- Item: vwArtifacts
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Artifacts
-----               SCHEMA:      ${flyway:defaultSchema}_Committees
-----               BASE TABLE:  Artifact
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[vwArtifacts]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_Committees].[vwArtifacts];
GO

CREATE VIEW [${flyway:defaultSchema}_Committees].[vwArtifacts]
AS
SELECT
    a.*,
    mjCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjCommitteesMeeting_MeetingID.[Title] AS [Meeting],
    mjCommitteesAgendaItem_AgendaItemID.[Title] AS [AgendaItem],
    mjCommitteesArtifactType_ArtifactTypeID.[Name] AS [ArtifactType],
    mjBizAppsCommonPerson_UploadedByPersonID.[DisplayName] AS [UploadedByPerson],
    mjBizAppsTasksTask_TaskID.[Name] AS [Task]
FROM
    [${flyway:defaultSchema}_Committees].[Artifact] AS a
LEFT OUTER JOIN
    [${flyway:defaultSchema}_Committees].[Committee] AS mjCommitteesCommittee_CommitteeID
  ON
    [a].[CommitteeID] = mjCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}_Committees].[Meeting] AS mjCommitteesMeeting_MeetingID
  ON
    [a].[MeetingID] = mjCommitteesMeeting_MeetingID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}_Committees].[AgendaItem] AS mjCommitteesAgendaItem_AgendaItemID
  ON
    [a].[AgendaItemID] = mjCommitteesAgendaItem_AgendaItemID.[ID]
INNER JOIN
    [${flyway:defaultSchema}_Committees].[ArtifactType] AS mjCommitteesArtifactType_ArtifactTypeID
  ON
    [a].[ArtifactTypeID] = mjCommitteesArtifactType_ArtifactTypeID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[vwPeopleExtended] AS mjBizAppsCommonPerson_UploadedByPersonID
  ON
    [a].[UploadedByPersonID] = mjBizAppsCommonPerson_UploadedByPersonID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}_BizAppsTasks].[Task] AS mjBizAppsTasksTask_TaskID
  ON
    [a].[TaskID] = mjBizAppsTasksTask_TaskID.[ID]
GO
GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwArtifacts] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Artifacts */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Artifacts
-- Item: Permissions for vwArtifacts
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwArtifacts] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for Artifacts */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Artifacts
-- Item: spCreateArtifact
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Artifact
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spCreateArtifact]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateArtifact];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateArtifact]
    @ID uniqueidentifier = NULL,
    @CommitteeID uniqueidentifier,
    @MeetingID uniqueidentifier,
    @AgendaItemID uniqueidentifier,
    @Title nvarchar(255),
    @Description nvarchar(MAX),
    @ArtifactTypeID uniqueidentifier,
    @Provider nvarchar(50),
    @ExternalID nvarchar(500),
    @URL nvarchar(2000),
    @MimeType nvarchar(100),
    @FileSize bigint,
    @UploadedByPersonID uniqueidentifier,
    @TaskID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_Committees].[Artifact]
            (
                [ID],
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [Title],
                [Description],
                [ArtifactTypeID],
                [Provider],
                [ExternalID],
                [URL],
                [MimeType],
                [FileSize],
                [UploadedByPersonID],
                [TaskID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @CommitteeID,
                @MeetingID,
                @AgendaItemID,
                @Title,
                @Description,
                @ArtifactTypeID,
                @Provider,
                @ExternalID,
                @URL,
                @MimeType,
                @FileSize,
                @UploadedByPersonID,
                @TaskID
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_Committees].[Artifact]
            (
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [Title],
                [Description],
                [ArtifactTypeID],
                [Provider],
                [ExternalID],
                [URL],
                [MimeType],
                [FileSize],
                [UploadedByPersonID],
                [TaskID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @CommitteeID,
                @MeetingID,
                @AgendaItemID,
                @Title,
                @Description,
                @ArtifactTypeID,
                @Provider,
                @ExternalID,
                @URL,
                @MimeType,
                @FileSize,
                @UploadedByPersonID,
                @TaskID
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_Committees].[vwArtifacts] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateArtifact] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Artifacts */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateArtifact] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for Artifacts */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Artifacts
-- Item: spUpdateArtifact
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Artifact
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spUpdateArtifact]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateArtifact];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateArtifact]
    @ID uniqueidentifier,
    @CommitteeID uniqueidentifier,
    @MeetingID uniqueidentifier,
    @AgendaItemID uniqueidentifier,
    @Title nvarchar(255),
    @Description nvarchar(MAX),
    @ArtifactTypeID uniqueidentifier,
    @Provider nvarchar(50),
    @ExternalID nvarchar(500),
    @URL nvarchar(2000),
    @MimeType nvarchar(100),
    @FileSize bigint,
    @UploadedByPersonID uniqueidentifier,
    @TaskID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Artifact]
    SET
        [CommitteeID] = @CommitteeID,
        [MeetingID] = @MeetingID,
        [AgendaItemID] = @AgendaItemID,
        [Title] = @Title,
        [Description] = @Description,
        [ArtifactTypeID] = @ArtifactTypeID,
        [Provider] = @Provider,
        [ExternalID] = @ExternalID,
        [URL] = @URL,
        [MimeType] = @MimeType,
        [FileSize] = @FileSize,
        [UploadedByPersonID] = @UploadedByPersonID,
        [TaskID] = @TaskID
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_Committees].[vwArtifacts] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_Committees].[vwArtifacts]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateArtifact] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Artifact table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[trgUpdateArtifact]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_Committees].[trgUpdateArtifact];
GO
CREATE TRIGGER [${flyway:defaultSchema}_Committees].trgUpdateArtifact
ON [${flyway:defaultSchema}_Committees].[Artifact]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Artifact]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_Committees].[Artifact] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Artifacts */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateArtifact] TO [cdp_Developer], [cdp_Integration]



/* spDelete SQL for Artifacts */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Artifacts
-- Item: spDeleteArtifact
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Artifact
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spDeleteArtifact]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteArtifact];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteArtifact]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_Committees].[Artifact]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteArtifact] TO [cdp_Developer], [cdp_Integration]
    

/* spDelete Permissions for Artifacts */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteArtifact] TO [cdp_Developer], [cdp_Integration]



/* Index for Foreign Keys for Comment */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Comments
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
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_CommitteeID ON [${flyway:defaultSchema}_Committees].[Comment] ([CommitteeID]);

-- Index for foreign key MeetingID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_MeetingID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_MeetingID ON [${flyway:defaultSchema}_Committees].[Comment] ([MeetingID]);

-- Index for foreign key AgendaItemID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_AgendaItemID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_AgendaItemID ON [${flyway:defaultSchema}_Committees].[Comment] ([AgendaItemID]);

-- Index for foreign key ArtifactID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_ArtifactID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_ArtifactID ON [${flyway:defaultSchema}_Committees].[Comment] ([ArtifactID]);

-- Index for foreign key ParentCommentID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_ParentCommentID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_ParentCommentID ON [${flyway:defaultSchema}_Committees].[Comment] ([ParentCommentID]);

-- Index for foreign key PersonID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_PersonID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_PersonID ON [${flyway:defaultSchema}_Committees].[Comment] ([PersonID]);

-- Index for foreign key TaskID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_TaskID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_TaskID ON [${flyway:defaultSchema}_Committees].[Comment] ([TaskID]);

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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[fnCommentParentCommentID_GetRootID]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}_Committees].[fnCommentParentCommentID_GetRootID];
GO

CREATE FUNCTION [${flyway:defaultSchema}_Committees].[fnCommentParentCommentID_GetRootID]
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
            [${flyway:defaultSchema}_Committees].[Comment]
        WHERE
            [ID] = COALESCE(@ParentID, @RecordID)

        UNION ALL

        SELECT
            c.[ID],
            c.[ParentCommentID],
            c.[ID] AS [RootParentID],
            p.[Depth] + 1 AS [Depth]
        FROM
            [${flyway:defaultSchema}_Committees].[Comment] c
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
-----               SCHEMA:      ${flyway:defaultSchema}_Committees
-----               BASE TABLE:  Comment
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[vwComments]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_Committees].[vwComments];
GO

CREATE VIEW [${flyway:defaultSchema}_Committees].[vwComments]
AS
SELECT
    c.*,
    mjCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjCommitteesMeeting_MeetingID.[Title] AS [Meeting],
    mjCommitteesAgendaItem_AgendaItemID.[Title] AS [AgendaItem],
    mjCommitteesArtifact_ArtifactID.[Title] AS [Artifact],
    mjCommitteesComment_ParentCommentID.[CommentText] AS [ParentComment],
    mjBizAppsCommonPerson_PersonID.[DisplayName] AS [Person],
    mjBizAppsTasksTask_TaskID.[Name] AS [Task],
    root_ParentCommentID.RootID AS [RootParentCommentID]
FROM
    [${flyway:defaultSchema}_Committees].[Comment] AS c
INNER JOIN
    [${flyway:defaultSchema}_Committees].[Committee] AS mjCommitteesCommittee_CommitteeID
  ON
    [c].[CommitteeID] = mjCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}_Committees].[Meeting] AS mjCommitteesMeeting_MeetingID
  ON
    [c].[MeetingID] = mjCommitteesMeeting_MeetingID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}_Committees].[AgendaItem] AS mjCommitteesAgendaItem_AgendaItemID
  ON
    [c].[AgendaItemID] = mjCommitteesAgendaItem_AgendaItemID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}_Committees].[Artifact] AS mjCommitteesArtifact_ArtifactID
  ON
    [c].[ArtifactID] = mjCommitteesArtifact_ArtifactID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}_Committees].[Comment] AS mjCommitteesComment_ParentCommentID
  ON
    [c].[ParentCommentID] = mjCommitteesComment_ParentCommentID.[ID]
INNER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[vwPeopleExtended] AS mjBizAppsCommonPerson_PersonID
  ON
    [c].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}_BizAppsTasks].[Task] AS mjBizAppsTasksTask_TaskID
  ON
    [c].[TaskID] = mjBizAppsTasksTask_TaskID.[ID]
OUTER APPLY
    [${flyway:defaultSchema}_Committees].[fnCommentParentCommentID_GetRootID]([c].[ID], [c].[ParentCommentID]) AS root_ParentCommentID
GO
GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwComments] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Comments */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Comments
-- Item: Permissions for vwComments
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwComments] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spCreateComment]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateComment];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateComment]
    @ID uniqueidentifier = NULL,
    @CommitteeID uniqueidentifier,
    @MeetingID uniqueidentifier,
    @AgendaItemID uniqueidentifier,
    @ArtifactID uniqueidentifier,
    @ParentCommentID uniqueidentifier,
    @PersonID uniqueidentifier,
    @CommentText nvarchar(MAX),
    @MentionedPersonIDs nvarchar(MAX),
    @IsResolved bit = NULL,
    @TaskID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_Committees].[Comment]
            (
                [ID],
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [ArtifactID],
                [ParentCommentID],
                [PersonID],
                [CommentText],
                [MentionedPersonIDs],
                [IsResolved],
                [TaskID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @CommitteeID,
                @MeetingID,
                @AgendaItemID,
                @ArtifactID,
                @ParentCommentID,
                @PersonID,
                @CommentText,
                @MentionedPersonIDs,
                ISNULL(@IsResolved, 0),
                @TaskID
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_Committees].[Comment]
            (
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [ArtifactID],
                [ParentCommentID],
                [PersonID],
                [CommentText],
                [MentionedPersonIDs],
                [IsResolved],
                [TaskID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @CommitteeID,
                @MeetingID,
                @AgendaItemID,
                @ArtifactID,
                @ParentCommentID,
                @PersonID,
                @CommentText,
                @MentionedPersonIDs,
                ISNULL(@IsResolved, 0),
                @TaskID
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_Committees].[vwComments] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateComment] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Comments */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateComment] TO [cdp_Developer], [cdp_Integration]



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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spUpdateComment]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateComment];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateComment]
    @ID uniqueidentifier,
    @CommitteeID uniqueidentifier,
    @MeetingID uniqueidentifier,
    @AgendaItemID uniqueidentifier,
    @ArtifactID uniqueidentifier,
    @ParentCommentID uniqueidentifier,
    @PersonID uniqueidentifier,
    @CommentText nvarchar(MAX),
    @MentionedPersonIDs nvarchar(MAX),
    @IsResolved bit,
    @TaskID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Comment]
    SET
        [CommitteeID] = @CommitteeID,
        [MeetingID] = @MeetingID,
        [AgendaItemID] = @AgendaItemID,
        [ArtifactID] = @ArtifactID,
        [ParentCommentID] = @ParentCommentID,
        [PersonID] = @PersonID,
        [CommentText] = @CommentText,
        [MentionedPersonIDs] = @MentionedPersonIDs,
        [IsResolved] = @IsResolved,
        [TaskID] = @TaskID
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_Committees].[vwComments] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_Committees].[vwComments]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateComment] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Comment table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[trgUpdateComment]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_Committees].[trgUpdateComment];
GO
CREATE TRIGGER [${flyway:defaultSchema}_Committees].trgUpdateComment
ON [${flyway:defaultSchema}_Committees].[Comment]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Comment]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_Committees].[Comment] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Comments */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateComment] TO [cdp_Developer], [cdp_Integration]



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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spDeleteComment]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteComment];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteComment]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_Committees].[Comment]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteComment] TO [cdp_Developer], [cdp_Integration]
    

/* spDelete Permissions for Comments */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteComment] TO [cdp_Developer], [cdp_Integration]



/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '9FF131B0-0684-4217-B7BA-1A6C68F7B6D0'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '6A8230C0-F751-4A9C-A922-3A2D2702CA46'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '9FF131B0-0684-4217-B7BA-1A6C68F7B6D0'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '6A8230C0-F751-4A9C-A922-3A2D2702CA46'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '4E273A83-E801-4C1A-82EB-5A957C08E58D'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '40C7369E-4D9E-4A8A-8958-8F19F9DF72CC'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '4E273A83-E801-4C1A-82EB-5A957C08E58D'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '607A8298-546A-4184-AE76-60D418268DAF'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'D621166D-27CC-484E-8489-0CE91EFF0383'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '1246A354-1771-4913-A09A-975598F86649'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '40C7369E-4D9E-4A8A-8958-8F19F9DF72CC'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '35387A2C-F2E7-477F-9B0E-565E3BD3B016'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set categories for 21 fields */

-- UPDATE Entity Field Category Info Comments.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FE9A0C3D-8B21-4311-AE9B-E6F2FE3466ED' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.CommitteeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '45D954CA-FBED-4FBD-AACF-B8EC5F6DFEA1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.MeetingID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B96B872B-94A0-422B-B1F2-C5756DF46E0B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.AgendaItemID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A3B47465-C656-4B1A-83B5-548670731FF6' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.ArtifactID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AFC0ED45-BB27-41F3-A014-6DC713EAC021' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.ParentCommentID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1879C6B8-7969-4E39-AF36-52E28898CDBD' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.PersonID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5F7B6CEA-5252-4BB0-93F4-B2AA60E21A86' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.TaskID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0F4ABC14-3877-448F-9858-E8B7FC352E13' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.Committee 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4E273A83-E801-4C1A-82EB-5A957C08E58D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.Meeting 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '607A8298-546A-4184-AE76-60D418268DAF' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.AgendaItem 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D621166D-27CC-484E-8489-0CE91EFF0383' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.Artifact 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1246A354-1771-4913-A09A-975598F86649' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.ParentComment 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '83ACC81D-D129-4B2F-AB85-58B30FD8EA6E' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.Person 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '40C7369E-4D9E-4A8A-8958-8F19F9DF72CC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.Task 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '35387A2C-F2E7-477F-9B0E-565E3BD3B016' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.RootParentCommentID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   DisplayName = 'Root Parent Comment',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BBD174BE-93BF-4C11-9DC0-941FCF84AF5B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.CommentText 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FAD8C690-0A7C-492E-823F-2EFE7BAF7F7E' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.MentionedPersonIDs 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Mentioned Person IDs',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6AB58027-5DBB-445C-81B3-54BED4B6E3E7' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.IsResolved 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Is Resolved',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B3D661E2-C7CD-487D-837F-FA30CCF5531A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8878AB25-82A8-4363-949F-CF49E859CDDA' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AE166C9F-68FD-498E-B5CB-E33F10287D66' AND AutoUpdateCategory = 1

/* Set categories for 22 fields */

-- UPDATE Entity Field Category Info Artifacts.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7C276534-B46C-4035-BB64-49BAA7C0A2AB' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.CommitteeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0B9C54AC-5206-423A-A353-056E9A24A732' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.MeetingID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C53FC5A3-01E2-4AB3-A84B-58B8BE1DE136' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.AgendaItemID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9300A125-AEEA-43E1-9C41-C303C7E8899E' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.Title 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0944B1F6-E52E-4D8E-8882-64EB1CAC8BED' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1BC69300-429A-466B-832F-D86F2A280F8A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.ArtifactTypeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E948E1B1-A591-40BD-B215-A4B3F723CA7F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.Provider 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'DABCF878-B859-43E1-81AD-1B3B5FAC8420' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.ExternalID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7A1ADBDC-FE0E-411B-80CD-0A67460D40F0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.URL 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '5A58A761-4AF9-4371-9A9F-34D05590AE87' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.MimeType 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '305360C2-44D9-416C-9B98-F4AB947F41EC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.FileSize 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '366A1BF2-227D-4319-AB2C-7F2ADF29FB5F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.UploadedByPersonID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Uploaded By Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '17786941-BBE8-4E5A-9DAB-3A070ECF4953' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'ACEC7865-D05E-44D2-A692-3A43E15CF6F7' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8037C2BD-F555-4FA7-BC61-0340D91A64C0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.TaskID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '01CA1C9F-8DAF-4542-9977-DA5C21A3A53F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.Committee 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FB296B78-9783-42B4-BB80-23C212E15D6B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.Meeting 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '50E08D44-5467-4A41-B6E1-10D92D21B319' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.AgendaItem 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D1D47030-AFFF-416F-88E6-1542C05C27F6' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.ArtifactType 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9FF131B0-0684-4217-B7BA-1A6C68F7B6D0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.UploadedByPerson 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6A8230C0-F751-4A9C-A922-3A2D2702CA46' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.Task 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3BC8063F-5B23-41DF-8236-D818D3A16F96' AND AutoUpdateCategory = 1

