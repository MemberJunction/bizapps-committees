/* SQL generated to create new entity Video Providers */

      INSERT INTO [${flyway:defaultSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI]
         , [TrackRecordChanges]
         , [AuditRecordAccess]
         , [AuditViewRuns]
         , [AllowAllRowsAPI]
         , [AllowCreateAPI]
         , [AllowUpdateAPI]
         , [AllowDeleteAPI]
         , [UserViewMaxRows]
         , [__mj_CreatedAt]
         , [__mj_UpdatedAt]
      )
      VALUES (
         'c12b60e5-bd78-4f73-ab8c-37df5a0c4891',
         'Video Providers',
         NULL,
         NULL,
         NULL,
         'VideoProvider',
         'vwVideoProviders',
         '${flyway:defaultSchema}_Committees',
         1,
         0
         , 1
         , 0
         , 0
         , 0
         , 1
         , 1
         , 1
         , 1000
         , GETUTCDATE()
         , GETUTCDATE()
      )
   

/* SQL generated to add new entity Video Providers to application ID: 'D08B9391-0CF4-44D9-8577-064ED9020427' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('D08B9391-0CF4-44D9-8577-064ED9020427', 'c12b60e5-bd78-4f73-ab8c-37df5a0c4891', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = 'D08B9391-0CF4-44D9-8577-064ED9020427'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Video Providers for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('c12b60e5-bd78-4f73-ab8c-37df5a0c4891', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Video Providers for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('c12b60e5-bd78-4f73-ab8c-37df5a0c4891', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Video Providers for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('c12b60e5-bd78-4f73-ab8c-37df5a0c4891', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.VideoProvider */
ALTER TABLE [${flyway:defaultSchema}_Committees].[VideoProvider] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.VideoProvider */
UPDATE [${flyway:defaultSchema}_Committees].[VideoProvider] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.VideoProvider */
ALTER TABLE [${flyway:defaultSchema}_Committees].[VideoProvider] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.VideoProvider */
ALTER TABLE [${flyway:defaultSchema}_Committees].[VideoProvider] ADD CONSTRAINT [DF___mj_Committees_VideoProvider___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt]

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.VideoProvider */
ALTER TABLE [${flyway:defaultSchema}_Committees].[VideoProvider] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.VideoProvider */
UPDATE [${flyway:defaultSchema}_Committees].[VideoProvider] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.VideoProvider */
ALTER TABLE [${flyway:defaultSchema}_Committees].[VideoProvider] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.VideoProvider */
ALTER TABLE [${flyway:defaultSchema}_Committees].[VideoProvider] ADD CONSTRAINT [DF___mj_Committees_VideoProvider___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt]

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'f166b6b1-2116-432d-9c5a-fd501b19d32c' OR (EntityID = 'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891' AND Name = 'ID')) BEGIN
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
            'f166b6b1-2116-432d-9c5a-fd501b19d32c',
            'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891', -- Entity: Video Providers
            100001,
            'ID',
            'ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            'newsequentialid()',
            0,
            0,
            0,
            NULL,
            NULL,
            0,
            1,
            0,
            0,
            1,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '55654d00-c203-4af3-8e0d-590e4d32c23f' OR (EntityID = 'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891' AND Name = 'Name')) BEGIN
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
            '55654d00-c203-4af3-8e0d-590e4d32c23f',
            'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891', -- Entity: Video Providers
            100002,
            'Name',
            'Name',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            NULL,
            NULL,
            1,
            1,
            0,
            1,
            0,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '23efb831-86db-4d4d-b5d7-2b2ebcb2ab63' OR (EntityID = 'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891' AND Name = 'ServerDriverKey')) BEGIN
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
            '23efb831-86db-4d4d-b5d7-2b2ebcb2ab63',
            'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891', -- Entity: Video Providers
            100003,
            'ServerDriverKey',
            'Server Driver Key',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            0,
            NULL,
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
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '7c6dee3e-ed02-4984-b60e-0c0e0ef4a7b7' OR (EntityID = 'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891' AND Name = 'IsActive')) BEGIN
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
            '7c6dee3e-ed02-4984-b60e-0c0e0ef4a7b7',
            'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891', -- Entity: Video Providers
            100004,
            'IsActive',
            'Is Active',
            NULL,
            'bit',
            1,
            1,
            0,
            0,
            '(1)',
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
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '65d71f42-46d0-4639-8ea0-bbf96e6e7399' OR (EntityID = 'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891' AND Name = 'IsDefault')) BEGIN
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
            '65d71f42-46d0-4639-8ea0-bbf96e6e7399',
            'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891', -- Entity: Video Providers
            100005,
            'IsDefault',
            'Is Default',
            NULL,
            'bit',
            1,
            1,
            0,
            0,
            '(0)',
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
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c6476217-4aa0-4b8c-ae7c-bb250f56f10f' OR (EntityID = 'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891' AND Name = 'CredentialID')) BEGIN
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
            'c6476217-4aa0-4b8c-ae7c-bb250f56f10f',
            'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891', -- Entity: Video Providers
            100006,
            'CredentialID',
            'Credential ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            '7E023DDF-82C6-4B0C-9650-8D35699B9FD0',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'ca799cae-ec16-4637-95fd-e7955bd9f48f' OR (EntityID = 'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891' AND Name = '__mj_CreatedAt')) BEGIN
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
            'ca799cae-ec16-4637-95fd-e7955bd9f48f',
            'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891', -- Entity: Video Providers
            100007,
            '__mj_CreatedAt',
            'Created At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
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
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1fd88a35-5bcb-4c89-ad5c-dfa321c8f6c5' OR (EntityID = 'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '1fd88a35-5bcb-4c89-ad5c-dfa321c8f6c5',
            'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891', -- Entity: Video Providers
            100008,
            '__mj_UpdatedAt',
            'Updated At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            'getutcdate()',
            0,
            0,
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
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '9d2daba6-cae5-4031-afe0-9ba77903fd62' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = 'VideoProviderID')) BEGIN
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
            '9d2daba6-cae5-4031-afe0-9ba77903fd62',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
            100038,
            'VideoProviderID',
            'Video Provider ID',
            'FK to VideoProvider — when set, video meeting URL is auto-created on save',
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891',
            'ID',
            0,
            0,
            1,
            0,
            0,
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END


/* Create Entity Relationship: Video Providers -> Meetings (One To Many via VideoProviderID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '8a11b191-b4ab-40fc-8a35-bca6c2c5650f'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('8a11b191-b4ab-40fc-8a35-bca6c2c5650f', 'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891', 'C6C5BD14-0D36-4442-812E-97F802728524', 'VideoProviderID', 'One To Many', 1, 1, 9, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: MJ: Credentials -> Video Providers (One To Many via CredentialID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '515a1478-d6f7-4fe6-b3b0-f6723ce6e1e6'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('515a1478-d6f7-4fe6-b3b0-f6723ce6e1e6', '7E023DDF-82C6-4B0C-9650-8D35699B9FD0', 'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891', 'CredentialID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    

/* Index for Foreign Keys for Meeting */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Meetings
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key CommitteeID in table Meeting
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Meeting_CommitteeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Meeting]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Meeting_CommitteeID ON [${flyway:defaultSchema}_Committees].[Meeting] ([CommitteeID]);

-- Index for foreign key VideoProviderID in table Meeting
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Meeting_VideoProviderID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Meeting]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Meeting_VideoProviderID ON [${flyway:defaultSchema}_Committees].[Meeting] ([VideoProviderID]);

/* SQL text to update entity field related entity name field map for entity field ID 9D2DABA6-CAE5-4031-AFE0-9BA77903FD62 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='9D2DABA6-CAE5-4031-AFE0-9BA77903FD62', @RelatedEntityNameFieldMap='VideoProvider_Virtual'

/* Base View SQL for Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Meetings
-- Item: vwMeetings
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Meetings
-----               SCHEMA:      ${flyway:defaultSchema}_Committees
-----               BASE TABLE:  Meeting
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[vwMeetings]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_Committees].[vwMeetings];
GO

CREATE VIEW [${flyway:defaultSchema}_Committees].[vwMeetings]
AS
SELECT
    m.*,
    mjCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjCommitteesVideoProvider_VideoProviderID.[Name] AS [VideoProvider_Virtual]
FROM
    [${flyway:defaultSchema}_Committees].[Meeting] AS m
INNER JOIN
    [${flyway:defaultSchema}_Committees].[Committee] AS mjCommitteesCommittee_CommitteeID
  ON
    [m].[CommitteeID] = mjCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}_Committees].[VideoProvider] AS mjCommitteesVideoProvider_VideoProviderID
  ON
    [m].[VideoProviderID] = mjCommitteesVideoProvider_VideoProviderID.[ID]
GO
GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwMeetings] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Meetings
-- Item: Permissions for vwMeetings
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwMeetings] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Meetings
-- Item: spCreateMeeting
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Meeting
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spCreateMeeting]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateMeeting];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateMeeting]
    @ID uniqueidentifier = NULL,
    @CommitteeID uniqueidentifier,
    @Title nvarchar(255),
    @Description nvarchar(MAX),
    @StartDateTime datetimeoffset,
    @EndDateTime datetimeoffset,
    @TimeZone nvarchar(50) = NULL,
    @LocationType nvarchar(50) = NULL,
    @LocationText nvarchar(500),
    @VideoProvider nvarchar(50),
    @VideoMeetingID nvarchar(255),
    @VideoJoinURL nvarchar(1000),
    @VideoRecordingURL nvarchar(1000),
    @TranscriptURL nvarchar(1000),
    @Status nvarchar(50) = NULL,
    @CalendarEventID nvarchar(255),
    @VideoProviderID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_Committees].[Meeting]
            (
                [ID],
                [CommitteeID],
                [Title],
                [Description],
                [StartDateTime],
                [EndDateTime],
                [TimeZone],
                [LocationType],
                [LocationText],
                [VideoProvider],
                [VideoMeetingID],
                [VideoJoinURL],
                [VideoRecordingURL],
                [TranscriptURL],
                [Status],
                [CalendarEventID],
                [VideoProviderID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @CommitteeID,
                @Title,
                @Description,
                @StartDateTime,
                @EndDateTime,
                ISNULL(@TimeZone, 'America/New_York'),
                ISNULL(@LocationType, 'Virtual'),
                @LocationText,
                @VideoProvider,
                @VideoMeetingID,
                @VideoJoinURL,
                @VideoRecordingURL,
                @TranscriptURL,
                ISNULL(@Status, 'Scheduled'),
                @CalendarEventID,
                @VideoProviderID
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_Committees].[Meeting]
            (
                [CommitteeID],
                [Title],
                [Description],
                [StartDateTime],
                [EndDateTime],
                [TimeZone],
                [LocationType],
                [LocationText],
                [VideoProvider],
                [VideoMeetingID],
                [VideoJoinURL],
                [VideoRecordingURL],
                [TranscriptURL],
                [Status],
                [CalendarEventID],
                [VideoProviderID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @CommitteeID,
                @Title,
                @Description,
                @StartDateTime,
                @EndDateTime,
                ISNULL(@TimeZone, 'America/New_York'),
                ISNULL(@LocationType, 'Virtual'),
                @LocationText,
                @VideoProvider,
                @VideoMeetingID,
                @VideoJoinURL,
                @VideoRecordingURL,
                @TranscriptURL,
                ISNULL(@Status, 'Scheduled'),
                @CalendarEventID,
                @VideoProviderID
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_Committees].[vwMeetings] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateMeeting] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Meetings */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateMeeting] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Meetings
-- Item: spUpdateMeeting
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Meeting
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spUpdateMeeting]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateMeeting];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateMeeting]
    @ID uniqueidentifier,
    @CommitteeID uniqueidentifier,
    @Title nvarchar(255),
    @Description nvarchar(MAX),
    @StartDateTime datetimeoffset,
    @EndDateTime datetimeoffset,
    @TimeZone nvarchar(50),
    @LocationType nvarchar(50),
    @LocationText nvarchar(500),
    @VideoProvider nvarchar(50),
    @VideoMeetingID nvarchar(255),
    @VideoJoinURL nvarchar(1000),
    @VideoRecordingURL nvarchar(1000),
    @TranscriptURL nvarchar(1000),
    @Status nvarchar(50),
    @CalendarEventID nvarchar(255),
    @VideoProviderID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Meeting]
    SET
        [CommitteeID] = @CommitteeID,
        [Title] = @Title,
        [Description] = @Description,
        [StartDateTime] = @StartDateTime,
        [EndDateTime] = @EndDateTime,
        [TimeZone] = @TimeZone,
        [LocationType] = @LocationType,
        [LocationText] = @LocationText,
        [VideoProvider] = @VideoProvider,
        [VideoMeetingID] = @VideoMeetingID,
        [VideoJoinURL] = @VideoJoinURL,
        [VideoRecordingURL] = @VideoRecordingURL,
        [TranscriptURL] = @TranscriptURL,
        [Status] = @Status,
        [CalendarEventID] = @CalendarEventID,
        [VideoProviderID] = @VideoProviderID
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_Committees].[vwMeetings] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_Committees].[vwMeetings]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateMeeting] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Meeting table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[trgUpdateMeeting]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_Committees].[trgUpdateMeeting];
GO
CREATE TRIGGER [${flyway:defaultSchema}_Committees].trgUpdateMeeting
ON [${flyway:defaultSchema}_Committees].[Meeting]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Meeting]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_Committees].[Meeting] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Meetings */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateMeeting] TO [cdp_Developer], [cdp_Integration]



/* spDelete SQL for Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Meetings
-- Item: spDeleteMeeting
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Meeting
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spDeleteMeeting]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteMeeting];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteMeeting]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_Committees].[Meeting]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteMeeting] TO [cdp_Developer], [cdp_Integration]
    

/* spDelete Permissions for Meetings */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteMeeting] TO [cdp_Developer], [cdp_Integration]



/* Index for Foreign Keys for VideoProvider */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Video Providers
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key CredentialID in table VideoProvider
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_VideoProvider_CredentialID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[VideoProvider]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_VideoProvider_CredentialID ON [${flyway:defaultSchema}_Committees].[VideoProvider] ([CredentialID]);

/* SQL text to update entity field related entity name field map for entity field ID C6476217-4AA0-4B8C-AE7C-BB250F56F10F */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='C6476217-4AA0-4B8C-AE7C-BB250F56F10F', @RelatedEntityNameFieldMap='Credential'

/* Base View SQL for Video Providers */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Video Providers
-- Item: vwVideoProviders
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Video Providers
-----               SCHEMA:      ${flyway:defaultSchema}_Committees
-----               BASE TABLE:  VideoProvider
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[vwVideoProviders]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_Committees].[vwVideoProviders];
GO

CREATE VIEW [${flyway:defaultSchema}_Committees].[vwVideoProviders]
AS
SELECT
    v.*,
    MJCredential_CredentialID.[Name] AS [Credential]
FROM
    [${flyway:defaultSchema}_Committees].[VideoProvider] AS v
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Credential] AS MJCredential_CredentialID
  ON
    [v].[CredentialID] = MJCredential_CredentialID.[ID]
GO
GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwVideoProviders] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Video Providers */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Video Providers
-- Item: Permissions for vwVideoProviders
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwVideoProviders] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for Video Providers */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Video Providers
-- Item: spCreateVideoProvider
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR VideoProvider
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spCreateVideoProvider]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateVideoProvider];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateVideoProvider]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(100),
    @ServerDriverKey nvarchar(100),
    @IsActive bit = NULL,
    @IsDefault bit = NULL,
    @CredentialID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_Committees].[VideoProvider]
            (
                [ID],
                [Name],
                [ServerDriverKey],
                [IsActive],
                [IsDefault],
                [CredentialID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @Name,
                @ServerDriverKey,
                ISNULL(@IsActive, 1),
                ISNULL(@IsDefault, 0),
                @CredentialID
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_Committees].[VideoProvider]
            (
                [Name],
                [ServerDriverKey],
                [IsActive],
                [IsDefault],
                [CredentialID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @Name,
                @ServerDriverKey,
                ISNULL(@IsActive, 1),
                ISNULL(@IsDefault, 0),
                @CredentialID
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_Committees].[vwVideoProviders] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateVideoProvider] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Video Providers */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateVideoProvider] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for Video Providers */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Video Providers
-- Item: spUpdateVideoProvider
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR VideoProvider
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spUpdateVideoProvider]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateVideoProvider];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateVideoProvider]
    @ID uniqueidentifier,
    @Name nvarchar(100),
    @ServerDriverKey nvarchar(100),
    @IsActive bit,
    @IsDefault bit,
    @CredentialID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[VideoProvider]
    SET
        [Name] = @Name,
        [ServerDriverKey] = @ServerDriverKey,
        [IsActive] = @IsActive,
        [IsDefault] = @IsDefault,
        [CredentialID] = @CredentialID
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_Committees].[vwVideoProviders] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_Committees].[vwVideoProviders]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateVideoProvider] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the VideoProvider table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[trgUpdateVideoProvider]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_Committees].[trgUpdateVideoProvider];
GO
CREATE TRIGGER [${flyway:defaultSchema}_Committees].trgUpdateVideoProvider
ON [${flyway:defaultSchema}_Committees].[VideoProvider]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[VideoProvider]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_Committees].[VideoProvider] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Video Providers */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateVideoProvider] TO [cdp_Developer], [cdp_Integration]



/* spDelete SQL for Video Providers */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Video Providers
-- Item: spDeleteVideoProvider
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR VideoProvider
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spDeleteVideoProvider]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteVideoProvider];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteVideoProvider]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_Committees].[VideoProvider]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteVideoProvider] TO [cdp_Integration]
    

/* spDelete Permissions for Video Providers */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteVideoProvider] TO [cdp_Integration]



/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'b50569ce-366d-453a-9056-94530f4f13f1' OR (EntityID = 'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891' AND Name = 'Credential')) BEGIN
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
            'b50569ce-366d-453a-9056-94530f4f13f1',
            'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891', -- Entity: Video Providers
            100017,
            'Credential',
            'Credential',
            NULL,
            'nvarchar',
            400,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '8fd0d063-1604-4b47-8f9e-1b6a94197b6c' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = 'VideoProvider_Virtual')) BEGIN
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
            '8fd0d063-1604-4b47-8f9e-1b6a94197b6c',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
            100041,
            'VideoProvider_Virtual',
            'Video Provider Virtual',
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

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '23EFB831-86DB-4D4D-B5D7-2B2EBCB2AB63'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '7C6DEE3E-ED02-4984-B60E-0C0E0EF4A7B7'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '65D71F42-46D0-4639-8EA0-BBF96E6E7399'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '23EFB831-86DB-4D4D-B5D7-2B2EBCB2AB63'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'B50569CE-366D-453A-9056-94530F4F13F1'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '852B0082-7008-497D-8CCC-3A86DC371FDF'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '2DDBEB25-13D4-4157-9141-75B3FA3E6B20'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set categories for 9 fields */

-- UPDATE Entity Field Category Info Video Providers.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F166B6B1-2116-432D-9C5A-FD501B19D32C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Video Providers.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CA799CAE-EC16-4637-95FD-E7955BD9F48F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Video Providers.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1FD88A35-5BCB-4C89-AD5C-DFA321C8F6C5' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Video Providers.Name 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Provider Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '55654D00-C203-4AF3-8E0D-590E4D32C23F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Video Providers.ServerDriverKey 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Provider Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '23EFB831-86DB-4D4D-B5D7-2B2EBCB2AB63' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Video Providers.IsDefault 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Provider Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Default Provider',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '65D71F42-46D0-4639-8EA0-BBF96E6E7399' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Video Providers.IsActive 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Access Configuration',
   GeneratedFormSection = 'Category',
   DisplayName = 'Active',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7C6DEE3E-ED02-4984-B60E-0C0E0EF4A7B7' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Video Providers.CredentialID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Access Configuration',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C6476217-4AA0-4B8C-AE7C-BB250F56F10F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Video Providers.Credential 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Access Configuration',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B50569CE-366D-453A-9056-94530F4F13F1' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-video */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-video', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = 'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('1e5f00ff-5307-477b-9214-cff0ad37ebb8', 'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891', 'FieldCategoryInfo', '{"Provider Details":{"icon":"fa fa-video","description":"Core information describing the video provider, including name and driver key"},"Access Configuration":{"icon":"fa fa-lock","description":"Settings that control activation status and authentication details"},"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('3e1c79e0-b5e4-4659-afc5-33e3d9c164ee', 'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891', 'FieldCategoryIcons', '{"Provider Details":"fa fa-video","Access Configuration":"fa fa-lock","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=0 for NEW entity (category: reference, confidence: high) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 0, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = 'C12B60E5-BD78-4F73-AB8C-37DF5A0C4891'
      

/* Set categories for 21 fields */

-- UPDATE Entity Field Category Info Meetings.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9CC3F2BD-A9E0-4034-8759-6912199189E4' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.CommitteeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F1241E55-FEFE-4CBE-BA7D-9B79FECA3126' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.Title 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '629D9C8F-AC11-479A-852E-41213263F696' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '923D4880-C2DF-454F-B06C-392027C0B89C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.Status 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2DDBEB25-13D4-4157-9141-75B3FA3E6B20' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.CalendarEventID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Calendar Event',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2A813C73-484B-40B7-BE33-094FDB113416' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.Committee 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '852B0082-7008-497D-8CCC-3A86DC371FDF' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.StartDateTime 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '45D8FAF6-513D-40AB-858A-83A046CF0E96' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.EndDateTime 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AF847EA1-8549-4AC5-A03F-FD2C53824F26' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.TimeZone 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3D47DDE6-9A48-49A4-97B9-B74C113B1C89' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.LocationType 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'DF7E91B3-3D0C-4860-913A-3ABD79E1AA85' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.LocationText 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CA026FCD-1B43-4C6E-984A-27E197B474AC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.VideoProvider 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FEF1718A-741B-44F3-8C79-17B1B7880C90' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.VideoMeetingID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '699639BB-6601-4FDF-92E1-322BED6A2394' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.VideoProviderID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Location & Access',
   GeneratedFormSection = 'Category',
   DisplayName = 'Video Provider',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9D2DABA6-CAE5-4031-AFE0-9BA77903FD62' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.VideoProvider_Virtual 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Location & Access',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8FD0D063-1604-4B47-8F9E-1B6A94197B6C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.VideoJoinURL 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = 'B00EDD25-53FA-44C3-B540-A8CE4E16BB8B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.VideoRecordingURL 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '675A855F-2DA3-40BB-B522-3A5E346F6DAE' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.TranscriptURL 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '85B0AE79-1E21-48C5-9AEA-2B4D538AD6DE' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A7E04C80-8961-4371-AAAA-D6ABBA5EB125' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '510CD2F8-7DBA-4BE7-A6AB-07B38C856BD9' AND AutoUpdateCategory = 1

