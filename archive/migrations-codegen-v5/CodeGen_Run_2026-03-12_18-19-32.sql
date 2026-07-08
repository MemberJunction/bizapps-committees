/* SQL generated to create new entity Comments */

      INSERT INTO [__mj].[Entity] (
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
         '9dc1631e-f623-44fb-a796-a70be70923d1',
         'Comments',
         NULL,
         'Threaded discussion comments on committee meetings, agenda items, action items, and documents',
         NULL,
         'Comment',
         'vwComments',
         '__mj_Committees',
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
   

/* SQL generated to add new entity Comments to application ID: 'D08B9391-0CF4-44D9-8577-064ED9020427' */
INSERT INTO [__mj].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('D08B9391-0CF4-44D9-8577-064ED9020427', '9dc1631e-f623-44fb-a796-a70be70923d1', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [__mj].[ApplicationEntity] WHERE [ApplicationID] = 'D08B9391-0CF4-44D9-8577-064ED9020427'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Comments for role UI */
INSERT INTO [__mj].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('9dc1631e-f623-44fb-a796-a70be70923d1', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Comments for role Developer */
INSERT INTO [__mj].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('9dc1631e-f623-44fb-a796-a70be70923d1', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Comments for role Integration */
INSERT INTO [__mj].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('9dc1631e-f623-44fb-a796-a70be70923d1', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

/* SQL text to add special date field __mj_CreatedAt to entity __mj_Committees.Comment */
ALTER TABLE [__mj_Committees].[Comment] ADD __mj_CreatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_UpdatedAt to entity __mj_Committees.Comment */
ALTER TABLE [__mj_Committees].[Comment] ADD __mj_UpdatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = 'fe9a0c3d-8b21-4311-ae9b-e6f2fe3466ed' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'ID')) BEGIN
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
            'fe9a0c3d-8b21-4311-ae9b-e6f2fe3466ed',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '45d954ca-fbed-4fbd-aacf-b8ec5f6dfea1' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'CommitteeID')) BEGIN
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
            '45d954ca-fbed-4fbd-aacf-b8ec5f6dfea1',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100002,
            'CommitteeID',
            'Committee ID',
            'Committee this comment belongs to (always set for easy filtering)',
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            '2B971E92-BBCE-462C-9868-807F9C04430D',
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = 'b96b872b-94a0-422b-b1f2-c5756df46e0b' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'MeetingID')) BEGIN
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
            'b96b872b-94a0-422b-b1f2-c5756df46e0b',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100003,
            'MeetingID',
            'Meeting ID',
            'Optional meeting this comment is attached to',
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            'C6C5BD14-0D36-4442-812E-97F802728524',
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = 'a3b47465-c656-4b1a-83b5-548670731ff6' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'AgendaItemID')) BEGIN
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
            'a3b47465-c656-4b1a-83b5-548670731ff6',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100004,
            'AgendaItemID',
            'Agenda Item ID',
            'Optional agenda item this comment is attached to',
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            '5BC3D9BB-94E3-4138-9E17-362C5256DA58',
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '3f9b52b6-631c-477d-ac34-a86e1144119a' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'ActionItemID')) BEGIN
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
            '3f9b52b6-631c-477d-ac34-a86e1144119a',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100005,
            'ActionItemID',
            'Action Item ID',
            'Optional action item this comment is attached to',
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9',
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = 'afc0ed45-bb27-41f3-a014-6dc713eac021' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'ArtifactID')) BEGIN
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
            'afc0ed45-bb27-41f3-a014-6dc713eac021',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100006,
            'ArtifactID',
            'Artifact ID',
            'Optional artifact/document this comment is attached to',
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            'DC523BBE-93DC-49FC-B066-621D3C8162E2',
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '1879c6b8-7969-4e39-af36-52e28898cdbd' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'ParentCommentID')) BEGIN
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
            '1879c6b8-7969-4e39-af36-52e28898cdbd',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100007,
            'ParentCommentID',
            'Parent Comment ID',
            'Parent comment for threading; NULL for top-level comments',
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            '9DC1631E-F623-44FB-A796-A70BE70923D1',
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '5f7b6cea-5252-4bb0-93f4-b2aa60e21a86' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'PersonID')) BEGIN
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
            '5f7b6cea-5252-4bb0-93f4-b2aa60e21a86',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100008,
            'PersonID',
            'Person ID',
            'Person who wrote the comment',
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F',
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = 'fad8c690-0a7c-492e-823f-2efe7baf7f7e' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'CommentText')) BEGIN
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
            'fad8c690-0a7c-492e-823f-2efe7baf7f7e',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100009,
            'CommentText',
            'Comment Text',
            'Comment body text',
            'nvarchar',
            -1,
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '6ab58027-5dbb-445c-81b3-54bed4b6e3e7' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'MentionedPersonIDs')) BEGIN
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
            '6ab58027-5dbb-445c-81b3-54bed4b6e3e7',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100010,
            'MentionedPersonIDs',
            'Mentioned Person I Ds',
            'JSON array of PersonIDs mentioned via @mentions',
            'nvarchar',
            -1,
            0,
            0,
            1,
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = 'b3d661e2-c7cd-487d-837f-fa30ccf5531a' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = 'IsResolved')) BEGIN
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
            'b3d661e2-c7cd-487d-837f-fa30ccf5531a',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100011,
            'IsResolved',
            'Is Resolved',
            'Whether this comment thread has been resolved',
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '8878ab25-82a8-4363-949f-cf49e859cdda' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = '__mj_CreatedAt')) BEGIN
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
            '8878ab25-82a8-4363-949f-cf49e859cdda',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100012,
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = 'ae166c9f-68fd-498e-b5cb-e33f10287d66' OR (EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1' AND Name = '__mj_UpdatedAt')) BEGIN
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
            'ae166c9f-68fd-498e-b5cb-e33f10287d66',
            '9DC1631E-F623-44FB-A796-A70BE70923D1', -- Entity: Comments
            100013,
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

/* SQL text to update entity field related entity name field map for entity field ID D38BB5DA-F6AD-4A7A-9DD7-9AC4A23BF0AB */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='D38BB5DA-F6AD-4A7A-9DD7-9AC4A23BF0AB', @RelatedEntityNameFieldMap='Meeting'

/* SQL text to update entity field related entity name field map for entity field ID 2F5C7FD5-0699-46B0-B9EB-E4FFC8B547EF */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='2F5C7FD5-0699-46B0-B9EB-E4FFC8B547EF', @RelatedEntityNameFieldMap='Meeting'

/* SQL text to update entity field related entity name field map for entity field ID C53FC5A3-01E2-4AB3-A84B-58B8BE1DE136 */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='C53FC5A3-01E2-4AB3-A84B-58B8BE1DE136', @RelatedEntityNameFieldMap='Meeting'

/* SQL text to update entity field related entity name field map for entity field ID B68258D1-9020-419D-BDD4-277747331CC9 */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='B68258D1-9020-419D-BDD4-277747331CC9', @RelatedEntityNameFieldMap='Meeting'

/* SQL text to update entity field related entity name field map for entity field ID 9300A125-AEEA-43E1-9C41-C303C7E8899E */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='9300A125-AEEA-43E1-9C41-C303C7E8899E', @RelatedEntityNameFieldMap='AgendaItem'

/* SQL text to update entity field related entity name field map for entity field ID AF77D04A-96D8-4BEF-9CE0-E65892AD91C1 */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='AF77D04A-96D8-4BEF-9CE0-E65892AD91C1', @RelatedEntityNameFieldMap='ParentAgendaItem'

/* SQL text to update entity field related entity name field map for entity field ID 5B1F0905-8009-484C-A9FB-C475489E9DC7 */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='5B1F0905-8009-484C-A9FB-C475489E9DC7', @RelatedEntityNameFieldMap='AgendaItem'

/* Base View SQL for Attendances */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Attendances
-- Item: vwAttendances
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Attendances
-----               SCHEMA:      __mj_Committees
-----               BASE TABLE:  Attendance
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[vwAttendances]', 'V') IS NOT NULL
    DROP VIEW [__mj_Committees].[vwAttendances];
GO

CREATE VIEW [__mj_Committees].[vwAttendances]
AS
SELECT
    a.*,
    mjCommitteesMeeting_MeetingID.[Title] AS [Meeting],
    mjBizAppsCommonPerson_PersonID.[DisplayName] AS [Person]
FROM
    [__mj_Committees].[Attendance] AS a
INNER JOIN
    [__mj_Committees].[Meeting] AS mjCommitteesMeeting_MeetingID
  ON
    [a].[MeetingID] = mjCommitteesMeeting_MeetingID.[ID]
INNER JOIN
    [__mj_BizAppsCommon].[vwPeopleExtended] AS mjBizAppsCommonPerson_PersonID
  ON
    [a].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
GO
GRANT SELECT ON [__mj_Committees].[vwAttendances] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Attendances */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Attendances
-- Item: Permissions for vwAttendances
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [__mj_Committees].[vwAttendances] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for Attendances */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Attendances
-- Item: spCreateAttendance
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Attendance
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spCreateAttendance]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spCreateAttendance];
GO

CREATE PROCEDURE [__mj_Committees].[spCreateAttendance]
    @ID uniqueidentifier = NULL,
    @MeetingID uniqueidentifier,
    @PersonID uniqueidentifier,
    @AttendanceStatus nvarchar(50) = NULL,
    @JoinedAt datetimeoffset,
    @LeftAt datetimeoffset,
    @Notes nvarchar(500)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [__mj_Committees].[Attendance]
            (
                [ID],
                [MeetingID],
                [PersonID],
                [AttendanceStatus],
                [JoinedAt],
                [LeftAt],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @MeetingID,
                @PersonID,
                ISNULL(@AttendanceStatus, 'Expected'),
                @JoinedAt,
                @LeftAt,
                @Notes
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [__mj_Committees].[Attendance]
            (
                [MeetingID],
                [PersonID],
                [AttendanceStatus],
                [JoinedAt],
                [LeftAt],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @MeetingID,
                @PersonID,
                ISNULL(@AttendanceStatus, 'Expected'),
                @JoinedAt,
                @LeftAt,
                @Notes
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [__mj_Committees].[vwAttendances] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [__mj_Committees].[spCreateAttendance] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Attendances */

GRANT EXECUTE ON [__mj_Committees].[spCreateAttendance] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for Attendances */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Attendances
-- Item: spUpdateAttendance
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Attendance
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spUpdateAttendance]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spUpdateAttendance];
GO

CREATE PROCEDURE [__mj_Committees].[spUpdateAttendance]
    @ID uniqueidentifier,
    @MeetingID uniqueidentifier,
    @PersonID uniqueidentifier,
    @AttendanceStatus nvarchar(50),
    @JoinedAt datetimeoffset,
    @LeftAt datetimeoffset,
    @Notes nvarchar(500)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [__mj_Committees].[Attendance]
    SET
        [MeetingID] = @MeetingID,
        [PersonID] = @PersonID,
        [AttendanceStatus] = @AttendanceStatus,
        [JoinedAt] = @JoinedAt,
        [LeftAt] = @LeftAt,
        [Notes] = @Notes
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [__mj_Committees].[vwAttendances] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [__mj_Committees].[vwAttendances]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [__mj_Committees].[spUpdateAttendance] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Attendance table
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[trgUpdateAttendance]', 'TR') IS NOT NULL
    DROP TRIGGER [__mj_Committees].[trgUpdateAttendance];
GO
CREATE TRIGGER [__mj_Committees].trgUpdateAttendance
ON [__mj_Committees].[Attendance]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [__mj_Committees].[Attendance]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [__mj_Committees].[Attendance] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Attendances */

GRANT EXECUTE ON [__mj_Committees].[spUpdateAttendance] TO [cdp_Developer], [cdp_Integration]



/* spDelete SQL for Attendances */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Attendances
-- Item: spDeleteAttendance
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Attendance
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spDeleteAttendance]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spDeleteAttendance];
GO

CREATE PROCEDURE [__mj_Committees].[spDeleteAttendance]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [__mj_Committees].[Attendance]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [__mj_Committees].[spDeleteAttendance] TO [cdp_Integration]
    

/* spDelete Permissions for Attendances */

GRANT EXECUTE ON [__mj_Committees].[spDeleteAttendance] TO [cdp_Integration]



/* SQL text to update entity field related entity name field map for entity field ID 278DDBCA-FDC7-4C4C-9483-E336F0474C13 */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='278DDBCA-FDC7-4C4C-9483-E336F0474C13', @RelatedEntityNameFieldMap='ActionItem'

/* Base View SQL for Action Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Action Items
-- Item: vwActionItems
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Action Items
-----               SCHEMA:      __mj_Committees
-----               BASE TABLE:  ActionItem
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[vwActionItems]', 'V') IS NOT NULL
    DROP VIEW [__mj_Committees].[vwActionItems];
GO

CREATE VIEW [__mj_Committees].[vwActionItems]
AS
SELECT
    a.*,
    mjCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjCommitteesMeeting_MeetingID.[Title] AS [Meeting],
    mjCommitteesAgendaItem_AgendaItemID.[Title] AS [AgendaItem],
    mjBizAppsCommonPerson_AssignedToPersonID.[DisplayName] AS [AssignedToPerson],
    mjBizAppsCommonPerson_AssignedByPersonID.[DisplayName] AS [AssignedByPerson]
FROM
    [__mj_Committees].[ActionItem] AS a
INNER JOIN
    [__mj_Committees].[Committee] AS mjCommitteesCommittee_CommitteeID
  ON
    [a].[CommitteeID] = mjCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [__mj_Committees].[Meeting] AS mjCommitteesMeeting_MeetingID
  ON
    [a].[MeetingID] = mjCommitteesMeeting_MeetingID.[ID]
LEFT OUTER JOIN
    [__mj_Committees].[AgendaItem] AS mjCommitteesAgendaItem_AgendaItemID
  ON
    [a].[AgendaItemID] = mjCommitteesAgendaItem_AgendaItemID.[ID]
INNER JOIN
    [__mj_BizAppsCommon].[vwPeopleExtended] AS mjBizAppsCommonPerson_AssignedToPersonID
  ON
    [a].[AssignedToPersonID] = mjBizAppsCommonPerson_AssignedToPersonID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsCommon].[vwPeopleExtended] AS mjBizAppsCommonPerson_AssignedByPersonID
  ON
    [a].[AssignedByPersonID] = mjBizAppsCommonPerson_AssignedByPersonID.[ID]
GO
GRANT SELECT ON [__mj_Committees].[vwActionItems] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Action Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Action Items
-- Item: Permissions for vwActionItems
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [__mj_Committees].[vwActionItems] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for Action Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Action Items
-- Item: spCreateActionItem
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR ActionItem
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spCreateActionItem]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spCreateActionItem];
GO

CREATE PROCEDURE [__mj_Committees].[spCreateActionItem]
    @ID uniqueidentifier = NULL,
    @CommitteeID uniqueidentifier,
    @MeetingID uniqueidentifier,
    @AgendaItemID uniqueidentifier,
    @Title nvarchar(255),
    @Description nvarchar(MAX),
    @AssignedToPersonID uniqueidentifier,
    @AssignedByPersonID uniqueidentifier,
    @DueDate date,
    @Priority nvarchar(20) = NULL,
    @Status nvarchar(50) = NULL,
    @CompletedAt datetimeoffset,
    @CompletionNotes nvarchar(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [__mj_Committees].[ActionItem]
            (
                [ID],
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [Title],
                [Description],
                [AssignedToPersonID],
                [AssignedByPersonID],
                [DueDate],
                [Priority],
                [Status],
                [CompletedAt],
                [CompletionNotes]
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
                @AssignedToPersonID,
                @AssignedByPersonID,
                @DueDate,
                ISNULL(@Priority, 'Medium'),
                ISNULL(@Status, 'Open'),
                @CompletedAt,
                @CompletionNotes
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [__mj_Committees].[ActionItem]
            (
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [Title],
                [Description],
                [AssignedToPersonID],
                [AssignedByPersonID],
                [DueDate],
                [Priority],
                [Status],
                [CompletedAt],
                [CompletionNotes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @CommitteeID,
                @MeetingID,
                @AgendaItemID,
                @Title,
                @Description,
                @AssignedToPersonID,
                @AssignedByPersonID,
                @DueDate,
                ISNULL(@Priority, 'Medium'),
                ISNULL(@Status, 'Open'),
                @CompletedAt,
                @CompletionNotes
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [__mj_Committees].[vwActionItems] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [__mj_Committees].[spCreateActionItem] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Action Items */

GRANT EXECUTE ON [__mj_Committees].[spCreateActionItem] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for Action Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Action Items
-- Item: spUpdateActionItem
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR ActionItem
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spUpdateActionItem]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spUpdateActionItem];
GO

CREATE PROCEDURE [__mj_Committees].[spUpdateActionItem]
    @ID uniqueidentifier,
    @CommitteeID uniqueidentifier,
    @MeetingID uniqueidentifier,
    @AgendaItemID uniqueidentifier,
    @Title nvarchar(255),
    @Description nvarchar(MAX),
    @AssignedToPersonID uniqueidentifier,
    @AssignedByPersonID uniqueidentifier,
    @DueDate date,
    @Priority nvarchar(20),
    @Status nvarchar(50),
    @CompletedAt datetimeoffset,
    @CompletionNotes nvarchar(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [__mj_Committees].[ActionItem]
    SET
        [CommitteeID] = @CommitteeID,
        [MeetingID] = @MeetingID,
        [AgendaItemID] = @AgendaItemID,
        [Title] = @Title,
        [Description] = @Description,
        [AssignedToPersonID] = @AssignedToPersonID,
        [AssignedByPersonID] = @AssignedByPersonID,
        [DueDate] = @DueDate,
        [Priority] = @Priority,
        [Status] = @Status,
        [CompletedAt] = @CompletedAt,
        [CompletionNotes] = @CompletionNotes
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [__mj_Committees].[vwActionItems] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [__mj_Committees].[vwActionItems]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [__mj_Committees].[spUpdateActionItem] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the ActionItem table
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[trgUpdateActionItem]', 'TR') IS NOT NULL
    DROP TRIGGER [__mj_Committees].[trgUpdateActionItem];
GO
CREATE TRIGGER [__mj_Committees].trgUpdateActionItem
ON [__mj_Committees].[ActionItem]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [__mj_Committees].[ActionItem]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [__mj_Committees].[ActionItem] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Action Items */

GRANT EXECUTE ON [__mj_Committees].[spUpdateActionItem] TO [cdp_Developer], [cdp_Integration]



/* spDelete SQL for Action Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Action Items
-- Item: spDeleteActionItem
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR ActionItem
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spDeleteActionItem]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spDeleteActionItem];
GO

CREATE PROCEDURE [__mj_Committees].[spDeleteActionItem]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [__mj_Committees].[ActionItem]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [__mj_Committees].[spDeleteActionItem] TO [cdp_Integration]
    

/* spDelete Permissions for Action Items */

GRANT EXECUTE ON [__mj_Committees].[spDeleteActionItem] TO [cdp_Integration]



/* Root ID Function SQL for Agenda Items.ParentAgendaItemID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Agenda Items
-- Item: fnAgendaItemParentAgendaItemID_GetRootID
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- ROOT ID FUNCTION FOR: [AgendaItem].[ParentAgendaItemID]
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[fnAgendaItemParentAgendaItemID_GetRootID]', 'IF') IS NOT NULL
    DROP FUNCTION [__mj_Committees].[fnAgendaItemParentAgendaItemID_GetRootID];
GO

CREATE FUNCTION [__mj_Committees].[fnAgendaItemParentAgendaItemID_GetRootID]
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
            [ParentAgendaItemID],
            [ID] AS [RootParentID],
            0 AS [Depth]
        FROM
            [__mj_Committees].[AgendaItem]
        WHERE
            [ID] = COALESCE(@ParentID, @RecordID)

        UNION ALL

        SELECT
            c.[ID],
            c.[ParentAgendaItemID],
            c.[ID] AS [RootParentID],
            p.[Depth] + 1 AS [Depth]
        FROM
            [__mj_Committees].[AgendaItem] c
        INNER JOIN
            CTE_RootParent p ON c.[ID] = p.[ParentAgendaItemID]
        WHERE
            p.[Depth] < 100
    )
    SELECT TOP 1
        [RootParentID] AS RootID
    FROM
        CTE_RootParent
    WHERE
        [ParentAgendaItemID] IS NULL
    ORDER BY
        [RootParentID]
);
GO


/* Base View SQL for Agenda Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Agenda Items
-- Item: vwAgendaItems
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Agenda Items
-----               SCHEMA:      __mj_Committees
-----               BASE TABLE:  AgendaItem
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[vwAgendaItems]', 'V') IS NOT NULL
    DROP VIEW [__mj_Committees].[vwAgendaItems];
GO

CREATE VIEW [__mj_Committees].[vwAgendaItems]
AS
SELECT
    a.*,
    mjCommitteesMeeting_MeetingID.[Title] AS [Meeting],
    mjCommitteesAgendaItem_ParentAgendaItemID.[Title] AS [ParentAgendaItem],
    mjBizAppsCommonPerson_PresenterPersonID.[DisplayName] AS [PresenterPerson],
    root_ParentAgendaItemID.RootID AS [RootParentAgendaItemID]
FROM
    [__mj_Committees].[AgendaItem] AS a
INNER JOIN
    [__mj_Committees].[Meeting] AS mjCommitteesMeeting_MeetingID
  ON
    [a].[MeetingID] = mjCommitteesMeeting_MeetingID.[ID]
LEFT OUTER JOIN
    [__mj_Committees].[AgendaItem] AS mjCommitteesAgendaItem_ParentAgendaItemID
  ON
    [a].[ParentAgendaItemID] = mjCommitteesAgendaItem_ParentAgendaItemID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsCommon].[vwPeopleExtended] AS mjBizAppsCommonPerson_PresenterPersonID
  ON
    [a].[PresenterPersonID] = mjBizAppsCommonPerson_PresenterPersonID.[ID]
OUTER APPLY
    [__mj_Committees].[fnAgendaItemParentAgendaItemID_GetRootID]([a].[ID], [a].[ParentAgendaItemID]) AS root_ParentAgendaItemID
GO
GRANT SELECT ON [__mj_Committees].[vwAgendaItems] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Agenda Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Agenda Items
-- Item: Permissions for vwAgendaItems
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [__mj_Committees].[vwAgendaItems] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for Agenda Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Agenda Items
-- Item: spCreateAgendaItem
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR AgendaItem
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spCreateAgendaItem]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spCreateAgendaItem];
GO

CREATE PROCEDURE [__mj_Committees].[spCreateAgendaItem]
    @ID uniqueidentifier = NULL,
    @MeetingID uniqueidentifier,
    @ParentAgendaItemID uniqueidentifier,
    @Sequence int,
    @Title nvarchar(255),
    @Description nvarchar(MAX),
    @PresenterPersonID uniqueidentifier,
    @DurationMinutes int,
    @ItemType nvarchar(50) = NULL,
    @RelatedDocumentURL nvarchar(1000),
    @Status nvarchar(50) = NULL,
    @Notes nvarchar(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [__mj_Committees].[AgendaItem]
            (
                [ID],
                [MeetingID],
                [ParentAgendaItemID],
                [Sequence],
                [Title],
                [Description],
                [PresenterPersonID],
                [DurationMinutes],
                [ItemType],
                [RelatedDocumentURL],
                [Status],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @MeetingID,
                @ParentAgendaItemID,
                @Sequence,
                @Title,
                @Description,
                @PresenterPersonID,
                @DurationMinutes,
                ISNULL(@ItemType, 'Discussion'),
                @RelatedDocumentURL,
                ISNULL(@Status, 'Pending'),
                @Notes
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [__mj_Committees].[AgendaItem]
            (
                [MeetingID],
                [ParentAgendaItemID],
                [Sequence],
                [Title],
                [Description],
                [PresenterPersonID],
                [DurationMinutes],
                [ItemType],
                [RelatedDocumentURL],
                [Status],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @MeetingID,
                @ParentAgendaItemID,
                @Sequence,
                @Title,
                @Description,
                @PresenterPersonID,
                @DurationMinutes,
                ISNULL(@ItemType, 'Discussion'),
                @RelatedDocumentURL,
                ISNULL(@Status, 'Pending'),
                @Notes
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [__mj_Committees].[vwAgendaItems] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [__mj_Committees].[spCreateAgendaItem] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Agenda Items */

GRANT EXECUTE ON [__mj_Committees].[spCreateAgendaItem] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for Agenda Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Agenda Items
-- Item: spUpdateAgendaItem
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR AgendaItem
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spUpdateAgendaItem]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spUpdateAgendaItem];
GO

CREATE PROCEDURE [__mj_Committees].[spUpdateAgendaItem]
    @ID uniqueidentifier,
    @MeetingID uniqueidentifier,
    @ParentAgendaItemID uniqueidentifier,
    @Sequence int,
    @Title nvarchar(255),
    @Description nvarchar(MAX),
    @PresenterPersonID uniqueidentifier,
    @DurationMinutes int,
    @ItemType nvarchar(50),
    @RelatedDocumentURL nvarchar(1000),
    @Status nvarchar(50),
    @Notes nvarchar(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [__mj_Committees].[AgendaItem]
    SET
        [MeetingID] = @MeetingID,
        [ParentAgendaItemID] = @ParentAgendaItemID,
        [Sequence] = @Sequence,
        [Title] = @Title,
        [Description] = @Description,
        [PresenterPersonID] = @PresenterPersonID,
        [DurationMinutes] = @DurationMinutes,
        [ItemType] = @ItemType,
        [RelatedDocumentURL] = @RelatedDocumentURL,
        [Status] = @Status,
        [Notes] = @Notes
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [__mj_Committees].[vwAgendaItems] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [__mj_Committees].[vwAgendaItems]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [__mj_Committees].[spUpdateAgendaItem] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the AgendaItem table
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[trgUpdateAgendaItem]', 'TR') IS NOT NULL
    DROP TRIGGER [__mj_Committees].[trgUpdateAgendaItem];
GO
CREATE TRIGGER [__mj_Committees].trgUpdateAgendaItem
ON [__mj_Committees].[AgendaItem]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [__mj_Committees].[AgendaItem]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [__mj_Committees].[AgendaItem] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Agenda Items */

GRANT EXECUTE ON [__mj_Committees].[spUpdateAgendaItem] TO [cdp_Developer], [cdp_Integration]



/* spDelete SQL for Agenda Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Agenda Items
-- Item: spDeleteAgendaItem
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR AgendaItem
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spDeleteAgendaItem]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spDeleteAgendaItem];
GO

CREATE PROCEDURE [__mj_Committees].[spDeleteAgendaItem]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [__mj_Committees].[AgendaItem]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [__mj_Committees].[spDeleteAgendaItem] TO [cdp_Integration]
    

/* spDelete Permissions for Agenda Items */

GRANT EXECUTE ON [__mj_Committees].[spDeleteAgendaItem] TO [cdp_Integration]



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
-----               SCHEMA:      __mj_Committees
-----               BASE TABLE:  Artifact
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[vwArtifacts]', 'V') IS NOT NULL
    DROP VIEW [__mj_Committees].[vwArtifacts];
GO

CREATE VIEW [__mj_Committees].[vwArtifacts]
AS
SELECT
    a.*,
    mjCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjCommitteesMeeting_MeetingID.[Title] AS [Meeting],
    mjCommitteesAgendaItem_AgendaItemID.[Title] AS [AgendaItem],
    mjCommitteesActionItem_ActionItemID.[Title] AS [ActionItem],
    mjCommitteesArtifactType_ArtifactTypeID.[Name] AS [ArtifactType],
    mjBizAppsCommonPerson_UploadedByPersonID.[DisplayName] AS [UploadedByPerson]
FROM
    [__mj_Committees].[Artifact] AS a
LEFT OUTER JOIN
    [__mj_Committees].[Committee] AS mjCommitteesCommittee_CommitteeID
  ON
    [a].[CommitteeID] = mjCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [__mj_Committees].[Meeting] AS mjCommitteesMeeting_MeetingID
  ON
    [a].[MeetingID] = mjCommitteesMeeting_MeetingID.[ID]
LEFT OUTER JOIN
    [__mj_Committees].[AgendaItem] AS mjCommitteesAgendaItem_AgendaItemID
  ON
    [a].[AgendaItemID] = mjCommitteesAgendaItem_AgendaItemID.[ID]
LEFT OUTER JOIN
    [__mj_Committees].[ActionItem] AS mjCommitteesActionItem_ActionItemID
  ON
    [a].[ActionItemID] = mjCommitteesActionItem_ActionItemID.[ID]
INNER JOIN
    [__mj_Committees].[ArtifactType] AS mjCommitteesArtifactType_ArtifactTypeID
  ON
    [a].[ArtifactTypeID] = mjCommitteesArtifactType_ArtifactTypeID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsCommon].[vwPeopleExtended] AS mjBizAppsCommonPerson_UploadedByPersonID
  ON
    [a].[UploadedByPersonID] = mjBizAppsCommonPerson_UploadedByPersonID.[ID]
GO
GRANT SELECT ON [__mj_Committees].[vwArtifacts] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Artifacts */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Artifacts
-- Item: Permissions for vwArtifacts
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [__mj_Committees].[vwArtifacts] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

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
IF OBJECT_ID('[__mj_Committees].[spCreateArtifact]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spCreateArtifact];
GO

CREATE PROCEDURE [__mj_Committees].[spCreateArtifact]
    @ID uniqueidentifier = NULL,
    @CommitteeID uniqueidentifier,
    @MeetingID uniqueidentifier,
    @AgendaItemID uniqueidentifier,
    @ActionItemID uniqueidentifier,
    @Title nvarchar(255),
    @Description nvarchar(MAX),
    @ArtifactTypeID uniqueidentifier,
    @Provider nvarchar(50),
    @ExternalID nvarchar(500),
    @URL nvarchar(2000),
    @MimeType nvarchar(100),
    @FileSize bigint,
    @UploadedByPersonID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [__mj_Committees].[Artifact]
            (
                [ID],
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [ActionItemID],
                [Title],
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
                @CommitteeID,
                @MeetingID,
                @AgendaItemID,
                @ActionItemID,
                @Title,
                @Description,
                @ArtifactTypeID,
                @Provider,
                @ExternalID,
                @URL,
                @MimeType,
                @FileSize,
                @UploadedByPersonID
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [__mj_Committees].[Artifact]
            (
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [ActionItemID],
                [Title],
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
                @CommitteeID,
                @MeetingID,
                @AgendaItemID,
                @ActionItemID,
                @Title,
                @Description,
                @ArtifactTypeID,
                @Provider,
                @ExternalID,
                @URL,
                @MimeType,
                @FileSize,
                @UploadedByPersonID
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [__mj_Committees].[vwArtifacts] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [__mj_Committees].[spCreateArtifact] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Artifacts */

GRANT EXECUTE ON [__mj_Committees].[spCreateArtifact] TO [cdp_Developer], [cdp_Integration]



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
IF OBJECT_ID('[__mj_Committees].[spUpdateArtifact]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spUpdateArtifact];
GO

CREATE PROCEDURE [__mj_Committees].[spUpdateArtifact]
    @ID uniqueidentifier,
    @CommitteeID uniqueidentifier,
    @MeetingID uniqueidentifier,
    @AgendaItemID uniqueidentifier,
    @ActionItemID uniqueidentifier,
    @Title nvarchar(255),
    @Description nvarchar(MAX),
    @ArtifactTypeID uniqueidentifier,
    @Provider nvarchar(50),
    @ExternalID nvarchar(500),
    @URL nvarchar(2000),
    @MimeType nvarchar(100),
    @FileSize bigint,
    @UploadedByPersonID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [__mj_Committees].[Artifact]
    SET
        [CommitteeID] = @CommitteeID,
        [MeetingID] = @MeetingID,
        [AgendaItemID] = @AgendaItemID,
        [ActionItemID] = @ActionItemID,
        [Title] = @Title,
        [Description] = @Description,
        [ArtifactTypeID] = @ArtifactTypeID,
        [Provider] = @Provider,
        [ExternalID] = @ExternalID,
        [URL] = @URL,
        [MimeType] = @MimeType,
        [FileSize] = @FileSize,
        [UploadedByPersonID] = @UploadedByPersonID
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [__mj_Committees].[vwArtifacts] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [__mj_Committees].[vwArtifacts]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [__mj_Committees].[spUpdateArtifact] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Artifact table
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[trgUpdateArtifact]', 'TR') IS NOT NULL
    DROP TRIGGER [__mj_Committees].[trgUpdateArtifact];
GO
CREATE TRIGGER [__mj_Committees].trgUpdateArtifact
ON [__mj_Committees].[Artifact]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [__mj_Committees].[Artifact]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [__mj_Committees].[Artifact] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Artifacts */

GRANT EXECUTE ON [__mj_Committees].[spUpdateArtifact] TO [cdp_Developer], [cdp_Integration]



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
IF OBJECT_ID('[__mj_Committees].[spDeleteArtifact]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spDeleteArtifact];
GO

CREATE PROCEDURE [__mj_Committees].[spDeleteArtifact]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [__mj_Committees].[Artifact]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [__mj_Committees].[spDeleteArtifact] TO [cdp_Integration]
    

/* spDelete Permissions for Artifacts */

GRANT EXECUTE ON [__mj_Committees].[spDeleteArtifact] TO [cdp_Integration]



/* SQL text to update entity field related entity name field map for entity field ID F1EADC64-B2E6-4BDC-8F6C-305E72B0E691 */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='F1EADC64-B2E6-4BDC-8F6C-305E72B0E691', @RelatedEntityNameFieldMap='Artifact'

/* SQL text to update entity field related entity name field map for entity field ID 9E8778CE-5FB2-4F2C-82D2-581D5BD728A7 */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='9E8778CE-5FB2-4F2C-82D2-581D5BD728A7', @RelatedEntityNameFieldMap='ApprovedByMeeting'

/* Base View SQL for Minutes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Minutes
-- Item: vwMinutes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Minutes
-----               SCHEMA:      __mj_Committees
-----               BASE TABLE:  Minute
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[vwMinutes]', 'V') IS NOT NULL
    DROP VIEW [__mj_Committees].[vwMinutes];
GO

CREATE VIEW [__mj_Committees].[vwMinutes]
AS
SELECT
    m.*,
    mjCommitteesArtifact_ArtifactID.[Title] AS [Artifact],
    mjCommitteesMeeting_ApprovedByMeetingID.[Title] AS [ApprovedByMeeting]
FROM
    [__mj_Committees].[Minute] AS m
INNER JOIN
    [__mj_Committees].[Artifact] AS mjCommitteesArtifact_ArtifactID
  ON
    [m].[ArtifactID] = mjCommitteesArtifact_ArtifactID.[ID]
LEFT OUTER JOIN
    [__mj_Committees].[Meeting] AS mjCommitteesMeeting_ApprovedByMeetingID
  ON
    [m].[ApprovedByMeetingID] = mjCommitteesMeeting_ApprovedByMeetingID.[ID]
GO
GRANT SELECT ON [__mj_Committees].[vwMinutes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Minutes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Minutes
-- Item: Permissions for vwMinutes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [__mj_Committees].[vwMinutes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for Minutes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Minutes
-- Item: spCreateMinute
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Minute
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spCreateMinute]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spCreateMinute];
GO

CREATE PROCEDURE [__mj_Committees].[spCreateMinute]
    @ID uniqueidentifier = NULL,
    @ArtifactID uniqueidentifier,
    @ApprovalStatus nvarchar(50) = NULL,
    @ApprovedAt datetimeoffset,
    @ApprovedByMeetingID uniqueidentifier,
    @Notes nvarchar(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [__mj_Committees].[Minute]
            (
                [ID],
                [ArtifactID],
                [ApprovalStatus],
                [ApprovedAt],
                [ApprovedByMeetingID],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @ArtifactID,
                ISNULL(@ApprovalStatus, 'Draft'),
                @ApprovedAt,
                @ApprovedByMeetingID,
                @Notes
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [__mj_Committees].[Minute]
            (
                [ArtifactID],
                [ApprovalStatus],
                [ApprovedAt],
                [ApprovedByMeetingID],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ArtifactID,
                ISNULL(@ApprovalStatus, 'Draft'),
                @ApprovedAt,
                @ApprovedByMeetingID,
                @Notes
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [__mj_Committees].[vwMinutes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [__mj_Committees].[spCreateMinute] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Minutes */

GRANT EXECUTE ON [__mj_Committees].[spCreateMinute] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for Minutes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Minutes
-- Item: spUpdateMinute
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Minute
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spUpdateMinute]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spUpdateMinute];
GO

CREATE PROCEDURE [__mj_Committees].[spUpdateMinute]
    @ID uniqueidentifier,
    @ArtifactID uniqueidentifier,
    @ApprovalStatus nvarchar(50),
    @ApprovedAt datetimeoffset,
    @ApprovedByMeetingID uniqueidentifier,
    @Notes nvarchar(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [__mj_Committees].[Minute]
    SET
        [ArtifactID] = @ArtifactID,
        [ApprovalStatus] = @ApprovalStatus,
        [ApprovedAt] = @ApprovedAt,
        [ApprovedByMeetingID] = @ApprovedByMeetingID,
        [Notes] = @Notes
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [__mj_Committees].[vwMinutes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [__mj_Committees].[vwMinutes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [__mj_Committees].[spUpdateMinute] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Minute table
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[trgUpdateMinute]', 'TR') IS NOT NULL
    DROP TRIGGER [__mj_Committees].[trgUpdateMinute];
GO
CREATE TRIGGER [__mj_Committees].trgUpdateMinute
ON [__mj_Committees].[Minute]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [__mj_Committees].[Minute]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [__mj_Committees].[Minute] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Minutes */

GRANT EXECUTE ON [__mj_Committees].[spUpdateMinute] TO [cdp_Developer], [cdp_Integration]



/* spDelete SQL for Minutes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Minutes
-- Item: spDeleteMinute
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Minute
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spDeleteMinute]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spDeleteMinute];
GO

CREATE PROCEDURE [__mj_Committees].[spDeleteMinute]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [__mj_Committees].[Minute]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [__mj_Committees].[spDeleteMinute] TO [cdp_Integration]
    

/* spDelete Permissions for Minutes */

GRANT EXECUTE ON [__mj_Committees].[spDeleteMinute] TO [cdp_Integration]



/* SQL text to update entity field related entity name field map for entity field ID 83988BE7-E19B-48BA-A360-E3158D903F48 */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='83988BE7-E19B-48BA-A360-E3158D903F48', @RelatedEntityNameFieldMap='Meeting'

/* SQL text to update entity field related entity name field map for entity field ID 1B91BA05-53A2-4C5C-B034-22BC1832CCDF */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='1B91BA05-53A2-4C5C-B034-22BC1832CCDF', @RelatedEntityNameFieldMap='AgendaItem'

/* SQL text to update entity field related entity name field map for entity field ID DE818F09-2CC4-4B00-8635-AAC75320BA53 */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='DE818F09-2CC4-4B00-8635-AAC75320BA53', @RelatedEntityNameFieldMap='MovedByMembership'

/* SQL text to update entity field related entity name field map for entity field ID 8A849122-7EC5-476D-A8E8-A7561BDD4BE4 */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='8A849122-7EC5-476D-A8E8-A7561BDD4BE4', @RelatedEntityNameFieldMap='SecondedByMembership'

/* Base View SQL for Motions */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Motions
-- Item: vwMotions
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Motions
-----               SCHEMA:      __mj_Committees
-----               BASE TABLE:  Motion
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[vwMotions]', 'V') IS NOT NULL
    DROP VIEW [__mj_Committees].[vwMotions];
GO

CREATE VIEW [__mj_Committees].[vwMotions]
AS
SELECT
    m.*,
    mjCommitteesMeeting_MeetingID.[Title] AS [Meeting],
    mjCommitteesAgendaItem_AgendaItemID.[Title] AS [AgendaItem],
    mjCommitteesMembership_MovedByMembershipID.[Person] AS [MovedByMembership],
    mjCommitteesMembership_SecondedByMembershipID.[Person] AS [SecondedByMembership]
FROM
    [__mj_Committees].[Motion] AS m
INNER JOIN
    [__mj_Committees].[Meeting] AS mjCommitteesMeeting_MeetingID
  ON
    [m].[MeetingID] = mjCommitteesMeeting_MeetingID.[ID]
LEFT OUTER JOIN
    [__mj_Committees].[AgendaItem] AS mjCommitteesAgendaItem_AgendaItemID
  ON
    [m].[AgendaItemID] = mjCommitteesAgendaItem_AgendaItemID.[ID]
LEFT OUTER JOIN
    [__mj_Committees].[vwMemberships] AS mjCommitteesMembership_MovedByMembershipID
  ON
    [m].[MovedByMembershipID] = mjCommitteesMembership_MovedByMembershipID.[ID]
LEFT OUTER JOIN
    [__mj_Committees].[vwMemberships] AS mjCommitteesMembership_SecondedByMembershipID
  ON
    [m].[SecondedByMembershipID] = mjCommitteesMembership_SecondedByMembershipID.[ID]
GO
GRANT SELECT ON [__mj_Committees].[vwMotions] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Motions */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Motions
-- Item: Permissions for vwMotions
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [__mj_Committees].[vwMotions] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for Motions */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Motions
-- Item: spCreateMotion
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Motion
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spCreateMotion]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spCreateMotion];
GO

CREATE PROCEDURE [__mj_Committees].[spCreateMotion]
    @ID uniqueidentifier = NULL,
    @MeetingID uniqueidentifier,
    @AgendaItemID uniqueidentifier,
    @Sequence int = NULL,
    @Title nvarchar(255),
    @Description nvarchar(MAX),
    @MovedByMembershipID uniqueidentifier,
    @SecondedByMembershipID uniqueidentifier,
    @Result nvarchar(50) = NULL,
    @ResultSummary nvarchar(255),
    @YesCount int,
    @NoCount int,
    @AbstainCount int,
    @Notes nvarchar(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [__mj_Committees].[Motion]
            (
                [ID],
                [MeetingID],
                [AgendaItemID],
                [Sequence],
                [Title],
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
                @MeetingID,
                @AgendaItemID,
                ISNULL(@Sequence, 1),
                @Title,
                @Description,
                @MovedByMembershipID,
                @SecondedByMembershipID,
                ISNULL(@Result, 'Pending'),
                @ResultSummary,
                @YesCount,
                @NoCount,
                @AbstainCount,
                @Notes
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [__mj_Committees].[Motion]
            (
                [MeetingID],
                [AgendaItemID],
                [Sequence],
                [Title],
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
                @MeetingID,
                @AgendaItemID,
                ISNULL(@Sequence, 1),
                @Title,
                @Description,
                @MovedByMembershipID,
                @SecondedByMembershipID,
                ISNULL(@Result, 'Pending'),
                @ResultSummary,
                @YesCount,
                @NoCount,
                @AbstainCount,
                @Notes
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [__mj_Committees].[vwMotions] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [__mj_Committees].[spCreateMotion] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Motions */

GRANT EXECUTE ON [__mj_Committees].[spCreateMotion] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for Motions */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Motions
-- Item: spUpdateMotion
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Motion
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spUpdateMotion]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spUpdateMotion];
GO

CREATE PROCEDURE [__mj_Committees].[spUpdateMotion]
    @ID uniqueidentifier,
    @MeetingID uniqueidentifier,
    @AgendaItemID uniqueidentifier,
    @Sequence int,
    @Title nvarchar(255),
    @Description nvarchar(MAX),
    @MovedByMembershipID uniqueidentifier,
    @SecondedByMembershipID uniqueidentifier,
    @Result nvarchar(50),
    @ResultSummary nvarchar(255),
    @YesCount int,
    @NoCount int,
    @AbstainCount int,
    @Notes nvarchar(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [__mj_Committees].[Motion]
    SET
        [MeetingID] = @MeetingID,
        [AgendaItemID] = @AgendaItemID,
        [Sequence] = @Sequence,
        [Title] = @Title,
        [Description] = @Description,
        [MovedByMembershipID] = @MovedByMembershipID,
        [SecondedByMembershipID] = @SecondedByMembershipID,
        [Result] = @Result,
        [ResultSummary] = @ResultSummary,
        [YesCount] = @YesCount,
        [NoCount] = @NoCount,
        [AbstainCount] = @AbstainCount,
        [Notes] = @Notes
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [__mj_Committees].[vwMotions] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [__mj_Committees].[vwMotions]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [__mj_Committees].[spUpdateMotion] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Motion table
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[trgUpdateMotion]', 'TR') IS NOT NULL
    DROP TRIGGER [__mj_Committees].[trgUpdateMotion];
GO
CREATE TRIGGER [__mj_Committees].trgUpdateMotion
ON [__mj_Committees].[Motion]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [__mj_Committees].[Motion]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [__mj_Committees].[Motion] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Motions */

GRANT EXECUTE ON [__mj_Committees].[spUpdateMotion] TO [cdp_Developer], [cdp_Integration]



/* spDelete SQL for Motions */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Motions
-- Item: spDeleteMotion
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Motion
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spDeleteMotion]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spDeleteMotion];
GO

CREATE PROCEDURE [__mj_Committees].[spDeleteMotion]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [__mj_Committees].[Motion]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [__mj_Committees].[spDeleteMotion] TO [cdp_Integration]
    

/* spDelete Permissions for Motions */

GRANT EXECUTE ON [__mj_Committees].[spDeleteMotion] TO [cdp_Integration]



/* SQL text to update entity field related entity name field map for entity field ID 96ACC971-ED28-4917-BE17-C66714EEB8D0 */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='96ACC971-ED28-4917-BE17-C66714EEB8D0', @RelatedEntityNameFieldMap='Motion'

/* SQL text to update entity field related entity name field map for entity field ID 8F9E992F-3912-49E9-AA2C-B10DB0335BFB */
EXEC [__mj].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='8F9E992F-3912-49E9-AA2C-B10DB0335BFB', @RelatedEntityNameFieldMap='Membership'

/* Base View SQL for Votes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Votes
-- Item: vwVotes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Votes
-----               SCHEMA:      __mj_Committees
-----               BASE TABLE:  Vote
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[vwVotes]', 'V') IS NOT NULL
    DROP VIEW [__mj_Committees].[vwVotes];
GO

CREATE VIEW [__mj_Committees].[vwVotes]
AS
SELECT
    v.*,
    mjCommitteesMotion_MotionID.[Title] AS [Motion],
    mjCommitteesMembership_MembershipID.[Person] AS [Membership]
FROM
    [__mj_Committees].[Vote] AS v
INNER JOIN
    [__mj_Committees].[Motion] AS mjCommitteesMotion_MotionID
  ON
    [v].[MotionID] = mjCommitteesMotion_MotionID.[ID]
INNER JOIN
    [__mj_Committees].[vwMemberships] AS mjCommitteesMembership_MembershipID
  ON
    [v].[MembershipID] = mjCommitteesMembership_MembershipID.[ID]
GO
GRANT SELECT ON [__mj_Committees].[vwVotes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Votes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Votes
-- Item: Permissions for vwVotes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [__mj_Committees].[vwVotes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for Votes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Votes
-- Item: spCreateVote
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Vote
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spCreateVote]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spCreateVote];
GO

CREATE PROCEDURE [__mj_Committees].[spCreateVote]
    @ID uniqueidentifier = NULL,
    @MotionID uniqueidentifier,
    @MembershipID uniqueidentifier,
    @VoteValue nvarchar(20),
    @Notes nvarchar(500)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [__mj_Committees].[Vote]
            (
                [ID],
                [MotionID],
                [MembershipID],
                [VoteValue],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @MotionID,
                @MembershipID,
                @VoteValue,
                @Notes
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [__mj_Committees].[Vote]
            (
                [MotionID],
                [MembershipID],
                [VoteValue],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @MotionID,
                @MembershipID,
                @VoteValue,
                @Notes
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [__mj_Committees].[vwVotes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [__mj_Committees].[spCreateVote] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Votes */

GRANT EXECUTE ON [__mj_Committees].[spCreateVote] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for Votes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Votes
-- Item: spUpdateVote
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Vote
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spUpdateVote]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spUpdateVote];
GO

CREATE PROCEDURE [__mj_Committees].[spUpdateVote]
    @ID uniqueidentifier,
    @MotionID uniqueidentifier,
    @MembershipID uniqueidentifier,
    @VoteValue nvarchar(20),
    @Notes nvarchar(500)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [__mj_Committees].[Vote]
    SET
        [MotionID] = @MotionID,
        [MembershipID] = @MembershipID,
        [VoteValue] = @VoteValue,
        [Notes] = @Notes
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [__mj_Committees].[vwVotes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [__mj_Committees].[vwVotes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [__mj_Committees].[spUpdateVote] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Vote table
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[trgUpdateVote]', 'TR') IS NOT NULL
    DROP TRIGGER [__mj_Committees].[trgUpdateVote];
GO
CREATE TRIGGER [__mj_Committees].trgUpdateVote
ON [__mj_Committees].[Vote]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [__mj_Committees].[Vote]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [__mj_Committees].[Vote] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Votes */

GRANT EXECUTE ON [__mj_Committees].[spUpdateVote] TO [cdp_Developer], [cdp_Integration]



/* spDelete SQL for Votes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Votes
-- Item: spDeleteVote
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Vote
------------------------------------------------------------
IF OBJECT_ID('[__mj_Committees].[spDeleteVote]', 'P') IS NOT NULL
    DROP PROCEDURE [__mj_Committees].[spDeleteVote];
GO

CREATE PROCEDURE [__mj_Committees].[spDeleteVote]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [__mj_Committees].[Vote]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [__mj_Committees].[spDeleteVote] TO [cdp_Integration]
    

/* spDelete Permissions for Votes */

GRANT EXECUTE ON [__mj_Committees].[spDeleteVote] TO [cdp_Integration]



/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '5366f161-79ac-4340-8969-6ceb53f5bc7d' OR (EntityID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58' AND Name = 'Meeting')) BEGIN
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
            '5366f161-79ac-4340-8969-6ceb53f5bc7d',
            '5BC3D9BB-94E3-4138-9E17-362C5256DA58', -- Entity: Agenda Items
            100031,
            'Meeting',
            'Meeting',
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '89d3cf72-6943-4f40-b920-632a0a7d8edb' OR (EntityID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58' AND Name = 'ParentAgendaItem')) BEGIN
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
            '89d3cf72-6943-4f40-b920-632a0a7d8edb',
            '5BC3D9BB-94E3-4138-9E17-362C5256DA58', -- Entity: Agenda Items
            100032,
            'ParentAgendaItem',
            'Parent Agenda Item',
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '5b292bf0-de88-4671-aaea-fa266bf93158' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'Meeting')) BEGIN
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
            '5b292bf0-de88-4671-aaea-fa266bf93158',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
            100037,
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '74decb6b-940e-4bdc-a024-eb7f82f0af5f' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'AgendaItem')) BEGIN
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
            '74decb6b-940e-4bdc-a024-eb7f82f0af5f',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
            100038,
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '75026673-d374-48d8-82bb-30379a6088dd' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'ActionItem')) BEGIN
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
            '75026673-d374-48d8-82bb-30379a6088dd',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
            100039,
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = 'd33559a2-5a00-4169-8347-ada423d6e981' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = 'Meeting')) BEGIN
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
            'd33559a2-5a00-4169-8347-ada423d6e981',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
            100033,
            'Meeting',
            'Meeting',
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = 'fe387bb6-c63c-4dcf-becb-8265aa0da2dc' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = 'AgendaItem')) BEGIN
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
            'fe387bb6-c63c-4dcf-becb-8265aa0da2dc',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
            100034,
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '43a2331f-0922-4db5-98ce-31944b7e69e8' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = 'MovedByMembership')) BEGIN
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
            '43a2331f-0922-4db5-98ce-31944b7e69e8',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
            100035,
            'MovedByMembership',
            'Moved By Membership',
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = 'f9d7cfe8-dae4-456f-ac3e-75f79e2bda05' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = 'SecondedByMembership')) BEGIN
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
            'f9d7cfe8-dae4-456f-ac3e-75f79e2bda05',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
            100036,
            'SecondedByMembership',
            'Seconded By Membership',
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = 'acc6eba5-9e9e-44ec-a503-0a16c43383c9' OR (EntityID = '5F56A290-08C7-4405-9C21-B4389869D995' AND Name = 'Meeting')) BEGIN
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
            'acc6eba5-9e9e-44ec-a503-0a16c43383c9',
            '5F56A290-08C7-4405-9C21-B4389869D995', -- Entity: Attendances
            100020,
            'Meeting',
            'Meeting',
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '49eb74b3-522c-479b-a07e-000ecf6420ee' OR (EntityID = 'F77CA3D7-5717-4149-8479-F258EF819C7A' AND Name = 'Motion')) BEGIN
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
            '49eb74b3-522c-479b-a07e-000ecf6420ee',
            'F77CA3D7-5717-4149-8479-F258EF819C7A', -- Entity: Votes
            100015,
            'Motion',
            'Motion',
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = 'afa6f564-9321-4e5f-a33b-2ed05d4daf84' OR (EntityID = 'F77CA3D7-5717-4149-8479-F258EF819C7A' AND Name = 'Membership')) BEGIN
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
            'afa6f564-9321-4e5f-a33b-2ed05d4daf84',
            'F77CA3D7-5717-4149-8479-F258EF819C7A', -- Entity: Votes
            100016,
            'Membership',
            'Membership',
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '84ef2473-e60c-451a-8fc0-3d6504a6e557' OR (EntityID = 'BFA46589-88E7-45AF-A1DD-F9910DDD1717' AND Name = 'Artifact')) BEGIN
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
            '84ef2473-e60c-451a-8fc0-3d6504a6e557',
            'BFA46589-88E7-45AF-A1DD-F9910DDD1717', -- Entity: Minutes
            100017,
            'Artifact',
            'Artifact',
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '1eaf904e-6151-4861-89d4-94b2d9b80a1d' OR (EntityID = 'BFA46589-88E7-45AF-A1DD-F9910DDD1717' AND Name = 'ApprovedByMeeting')) BEGIN
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
            '1eaf904e-6151-4861-89d4-94b2d9b80a1d',
            'BFA46589-88E7-45AF-A1DD-F9910DDD1717', -- Entity: Minutes
            100018,
            'ApprovedByMeeting',
            'Approved By Meeting',
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '99600770-7337-4bc6-a586-3ce98f0bce9d' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = 'Meeting')) BEGIN
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
            '99600770-7337-4bc6-a586-3ce98f0bce9d',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
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

      IF NOT EXISTS (SELECT 1 FROM [__mj].[EntityField] WHERE ID = '4665f984-e318-40a5-91a9-e566d47d5def' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = 'AgendaItem')) BEGIN
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
            '4665f984-e318-40a5-91a9-e566d47d5def',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
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

/* Set field properties for entity */

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '99600770-7337-4BC6-A586-3CE98F0BCE9D'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '4665F984-E318-40A5-91A9-E566D47D5DEF'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

               UPDATE [__mj].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '5366F161-79AC-4340-8969-6CEB53F5BC7D'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '5366F161-79AC-4340-8969-6CEB53F5BC7D'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

               UPDATE [__mj].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'ACC6EBA5-9E9E-44EC-A503-0A16C43383C9'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'ACC6EBA5-9E9E-44EC-A503-0A16C43383C9'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '043042FA-8E84-411F-A9FA-9A729D82820D'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '5B292BF0-DE88-4671-AAEA-FA266BF93158'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

            UPDATE [__mj].[EntityField]
            SET IsNameField = 1
            WHERE ID = 'FAD8C690-0A7C-492E-823F-2EFE7BAF7F7E'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [__mj].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'FAD8C690-0A7C-492E-823F-2EFE7BAF7F7E'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [__mj].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'B3D661E2-C7CD-487D-837F-FA30CCF5531A'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'FAD8C690-0A7C-492E-823F-2EFE7BAF7F7E'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set categories for 11 fields */

-- UPDATE Entity Field Category Info Attendances.ID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3C5CE0B2-F27E-4C29-9692-3E3F23C338A7' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.__mj_CreatedAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '53F86FAC-BFB1-42FA-AE35-2542CAA8E3C6' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.__mj_UpdatedAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '947978D3-7FC1-494D-A185-D812FCAA6770' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.MeetingID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B68258D1-9020-419D-BDD4-277747331CC9' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.PersonID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '64ACA6A1-5351-409B-B19E-9B92CC2880F0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.Person 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6F7D196B-FED0-4E73-AA64-1FC2DA013D9C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.Meeting 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Attendee & Meeting',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'ACC6EBA5-9E9E-44EC-A503-0A16C43383C9' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.AttendanceStatus 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '65CACDD5-8A4C-424F-AB16-F666811F1BFE' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.JoinedAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E7CC6BEF-C5BA-4315-8EC8-73E16684672C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.LeftAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B427AA57-A9D2-4855-91E4-DD0ED272DE7A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.Notes 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6824AB44-02A1-4ABA-ADA3-9708CC7E7641' AND AutoUpdateCategory = 1

/* Set categories for 22 fields */

-- UPDATE Entity Field Category Info Artifacts.ID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7C276534-B46C-4035-BB64-49BAA7C0A2AB' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.CommitteeID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0B9C54AC-5206-423A-A353-056E9A24A732' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.MeetingID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C53FC5A3-01E2-4AB3-A84B-58B8BE1DE136' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.AgendaItemID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9300A125-AEEA-43E1-9C41-C303C7E8899E' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.ActionItemID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '278DDBCA-FDC7-4C4C-9483-E336F0474C13' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.Title 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0944B1F6-E52E-4D8E-8882-64EB1CAC8BED' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.Description 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1BC69300-429A-466B-832F-D86F2A280F8A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.ArtifactTypeID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E948E1B1-A591-40BD-B215-A4B3F723CA7F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.Provider 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'DABCF878-B859-43E1-81AD-1B3B5FAC8420' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.ExternalID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7A1ADBDC-FE0E-411B-80CD-0A67460D40F0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.URL 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '5A58A761-4AF9-4371-9A9F-34D05590AE87' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.MimeType 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '305360C2-44D9-416C-9B98-F4AB947F41EC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.FileSize 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '366A1BF2-227D-4319-AB2C-7F2ADF29FB5F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.UploadedByPersonID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Uploaded By Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '17786941-BBE8-4E5A-9DAB-3A070ECF4953' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.__mj_CreatedAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'ACEC7865-D05E-44D2-A692-3A43E15CF6F7' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.__mj_UpdatedAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8037C2BD-F555-4FA7-BC61-0340D91A64C0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.Committee 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '043042FA-8E84-411F-A9FA-9A729D82820D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.Meeting 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5B292BF0-DE88-4671-AAEA-FA266BF93158' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.AgendaItem 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '74DECB6B-940E-4BDC-A024-EB7F82F0AF5F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.ActionItem 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '75026673-D374-48D8-82BB-30379A6088DD' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.ArtifactType 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Artifact Type',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7A5AFFF4-A48F-4683-A76A-67F86972C038' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.UploadedByPerson 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Uploaded By Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C80FC98A-0AB7-4507-9B64-308B26309610' AND AutoUpdateCategory = 1

/* Set categories for 20 fields */

-- UPDATE Entity Field Category Info Action Items.ID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E5C7526C-C8F9-474A-93AC-3F8FB7C0CBE1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.CommitteeID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '35136BA7-3C0B-4A3E-A2A9-E8CF321B1430' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.MeetingID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D38BB5DA-F6AD-4A7A-9DD7-9AC4A23BF0AB' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.AgendaItemID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5B1F0905-8009-484C-A9FB-C475489E9DC7' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.Title 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9752A9E9-FC94-4712-B1D0-52AD37899E6F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.Description 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '59C8A57A-BF84-4BE2-8019-53DBB77C31DA' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.AssignedToPersonID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Assignee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1A44989E-E463-4F19-8BD4-EE69C6DBE58C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.AssignedByPersonID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Assigned By',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A6C292A6-8207-4832-B0AB-F04A195ADC29' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.DueDate 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D2B8DA2B-1884-44FD-9494-B07B0E50B4B4' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.Priority 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B4E41F97-23F4-4718-B60C-50EF56D75670' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.Status 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '88828B5A-415F-40E0-90B7-7B5567375D34' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.CompletedAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0C244108-85A6-4EA5-801E-38E3FD9322FD' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.CompletionNotes 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6237159D-D2F0-4565-9D3B-6D39B1BFF4A8' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.__mj_CreatedAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5F875DC7-54E5-4F8E-AB85-3BA593BB8513' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.__mj_UpdatedAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D9E75A01-75BA-4FB2-93DB-4B99B0F6AEB0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.Committee 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C30C23FA-0545-4914-B4B9-EFAF9BBE1B99' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.Meeting 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Context',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '99600770-7337-4BC6-A586-3CE98F0BCE9D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.AgendaItem 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Context',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4665F984-E318-40A5-91A9-E566D47D5DEF' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.AssignedToPerson 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Assignee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C1B9A705-D81E-48ED-9092-DB0005BDF636' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.AssignedByPerson 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Assigned By',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A158D04A-73CB-443A-8412-6A2DD2F5C8E1' AND AutoUpdateCategory = 1

/* Set categories for 18 fields */

-- UPDATE Entity Field Category Info Agenda Items.ID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9D7EEC50-670A-4940-A84A-5983A7F34C69' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.__mj_CreatedAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A2BBFDC4-BB2B-4899-B594-12A012A07FAA' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.__mj_UpdatedAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C9C7BBC5-FE43-4970-9466-C5FD0C4263E8' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.MeetingID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2F5C7FD5-0699-46B0-B9EB-E4FFC8B547EF' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.Meeting 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Agenda Structure',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5366F161-79AC-4340-8969-6CEB53F5BC7D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.ParentAgendaItemID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AF77D04A-96D8-4BEF-9CE0-E65892AD91C1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.ParentAgendaItem 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Agenda Structure',
   GeneratedFormSection = 'Category',
   DisplayName = 'Parent Agenda Item Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '89D3CF72-6943-4F40-B920-632A0A7D8EDB' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.RootParentAgendaItemID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8B3F77AE-3EDF-4D2A-8B9E-01387412A770' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.Sequence 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6AF82FF1-D71E-4904-A678-D9D8E50CA1B8' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.Title 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '44F0A802-C118-440A-A467-BB296DFACC2A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.Description 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '232D43CF-4D1E-4022-9F6E-DCDD7C33D007' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.ItemType 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E2F64D96-5DE8-4918-84A7-C1A517829BBC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.RelatedDocumentURL 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '72565441-09BC-4FF3-858B-8999DC5262C1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.Status 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8FC8E88A-0E6A-475C-9E05-729F103BA062' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.PresenterPersonID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2C88BA58-D204-4733-BD7B-2B12A588D289' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.PresenterPerson 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7E213148-FB39-46B3-B33A-6C4B722BA849' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.DurationMinutes 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Duration Minutes',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C2F9687C-2D72-44B1-9FC5-15D661CA007A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.Notes 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '07C5263A-CE84-4A2C-99A1-E9981697C3E7' AND AutoUpdateCategory = 1

/* Set categories for 13 fields */

-- UPDATE Entity Field Category Info Comments.ID 
UPDATE [__mj].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FE9A0C3D-8B21-4311-AE9B-E6F2FE3466ED' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.__mj_CreatedAt 
UPDATE [__mj].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8878AB25-82A8-4363-949F-CF49E859CDDA' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.__mj_UpdatedAt 
UPDATE [__mj].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AE166C9F-68FD-498E-B5CB-E33F10287D66' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.CommentText 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Discussion Content',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FAD8C690-0A7C-492E-823F-2EFE7BAF7F7E' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.MentionedPersonIDs 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Discussion Content',
   GeneratedFormSection = 'Category',
   DisplayName = 'Mentioned Persons',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6AB58027-5DBB-445C-81B3-54BED4B6E3E7' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.IsResolved 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Discussion Content',
   GeneratedFormSection = 'Category',
   DisplayName = 'Resolved',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B3D661E2-C7CD-487D-837F-FA30CCF5531A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.CommitteeID 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '45D954CA-FBED-4FBD-AACF-B8EC5F6DFEA1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.MeetingID 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B96B872B-94A0-422B-B1F2-C5756DF46E0B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.AgendaItemID 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   DisplayName = 'Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A3B47465-C656-4B1A-83B5-548670731FF6' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.ActionItemID 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   DisplayName = 'Action Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3F9B52B6-631C-477D-AC34-A86E1144119A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.ArtifactID 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   DisplayName = 'Artifact',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AFC0ED45-BB27-41F3-A014-6DC713EAC021' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.ParentCommentID 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   DisplayName = 'Parent Comment',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1879C6B8-7969-4E39-AF36-52E28898CDBD' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.PersonID 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   DisplayName = 'Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5F7B6CEA-5252-4BB0-93F4-B2AA60E21A86' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-comments */

               UPDATE [__mj].[Entity]
               SET Icon = 'fa fa-comments', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = '9DC1631E-F623-44FB-A796-A70BE70923D1'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [__mj].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('2325ad36-fd4b-410b-946a-7d1b5cf8c46e', '9DC1631E-F623-44FB-A796-A70BE70923D1', 'FieldCategoryInfo', '{"System Metadata":{"icon":"fa fa-cog","description":"Technical identifiers and audit timestamps managed by the system"},"Discussion Content":{"icon":"fa fa-comment","description":"Core comment body, mentions, and resolution status"},"Associations":{"icon":"fa fa-link","description":"Links the comment to committees, meetings, agenda items, action items, artifacts, parent comments, and the author"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [__mj].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('0d6d685e-997d-41f6-8276-99675f3f9a50', '9DC1631E-F623-44FB-A796-A70BE70923D1', 'FieldCategoryIcons', '{"System Metadata":"fa fa-cog","Discussion Content":"fa fa-comment","Associations":"fa fa-link"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=1 for NEW entity (category: supporting, confidence: medium) */

         UPDATE [__mj].[ApplicationEntity]
         SET DefaultForNewUser = 1, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = '9DC1631E-F623-44FB-A796-A70BE70923D1'
      

/* Set field properties for entity */

            UPDATE [__mj].[EntityField]
            SET IsNameField = 1
            WHERE ID = '84EF2473-E60C-451A-8FC0-3D6504A6E557'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [__mj].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '84EF2473-E60C-451A-8FC0-3D6504A6E557'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [__mj].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '1EAF904E-6151-4861-89D4-94B2D9B80A1D'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '84EF2473-E60C-451A-8FC0-3D6504A6E557'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '1EAF904E-6151-4861-89D4-94B2D9B80A1D'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

            UPDATE [__mj].[EntityField]
            SET IsNameField = 1
            WHERE ID = '49EB74B3-522C-479B-A07E-000ECF6420EE'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [__mj].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '49EB74B3-522C-479B-A07E-000ECF6420EE'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [__mj].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'AFA6F564-9321-4E5F-A33B-2ED05D4DAF84'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '49EB74B3-522C-479B-A07E-000ECF6420EE'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'AFA6F564-9321-4E5F-A33B-2ED05D4DAF84'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

               UPDATE [__mj].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '43A2331F-0922-4DB5-98CE-31944B7E69E8'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [__mj].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'F9D7CFE8-DAE4-456F-AC3E-75F79E2BDA05'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'FE387BB6-C63C-4DCF-BECB-8265AA0DA2DC'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '43A2331F-0922-4DB5-98CE-31944B7E69E8'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [__mj].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'F9D7CFE8-DAE4-456F-AC3E-75F79E2BDA05'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set categories for 9 fields */

-- UPDATE Entity Field Category Info Votes.ID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CCDEDD90-F689-48CD-B71C-08CB071B9442' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.MotionID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '96ACC971-ED28-4917-BE17-C66714EEB8D0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.MembershipID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Membership',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8F9E992F-3912-49E9-AA2C-B10DB0335BFB' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.VoteValue 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Vote Value',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E0C19372-93D7-4E75-915B-BBD903458C7C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.Notes 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '82E90D63-1575-45AB-99B2-37E5A69765BF' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.__mj_CreatedAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '582FC669-98E5-4337-917F-0284AE41CE47' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.__mj_UpdatedAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '05AB1CBF-9A22-48D7-8DB9-74BBE7812538' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.Motion 
UPDATE [__mj].[EntityField]
SET 
   Category = 'References',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '49EB74B3-522C-479B-A07E-000ECF6420EE' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.Membership 
UPDATE [__mj].[EntityField]
SET 
   Category = 'References',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AFA6F564-9321-4E5F-A33B-2ED05D4DAF84' AND AutoUpdateCategory = 1

/* Set categories for 10 fields */

-- UPDATE Entity Field Category Info Minutes.ID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BA67048A-587E-415C-91F7-2676C6771E03' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.ArtifactID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Artifact ID',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F1EADC64-B2E6-4BDC-8F6C-305E72B0E691' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.Notes 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6D7A2BBE-6A1C-4A13-8972-104777B69BEB' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.Artifact 
UPDATE [__mj].[EntityField]
SET 
   Category = 'General Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '84EF2473-E60C-451A-8FC0-3D6504A6E557' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.ApprovalStatus 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '49A875BB-7630-4E94-AC58-66F610000BC1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.ApprovedAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '91E0E487-D81B-4602-AF75-52C5FCFB00EC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.ApprovedByMeetingID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   DisplayName = 'Approved By Meeting ID',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9E8778CE-5FB2-4F2C-82D2-581D5BD728A7' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.ApprovedByMeeting 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Approval Tracking',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1EAF904E-6151-4861-89D4-94B2D9B80A1D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.__mj_CreatedAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '27A7EA95-F423-4618-8035-C6CEF17CCAD0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.__mj_UpdatedAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F517A92B-F5C7-4842-A904-CF57239F677F' AND AutoUpdateCategory = 1

/* Set categories for 20 fields */

-- UPDATE Entity Field Category Info Motions.ID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '40EA1D10-2D87-4337-944A-48DFCEE061DC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.MeetingID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '83988BE7-E19B-48BA-A360-E3158D903F48' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.AgendaItemID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1B91BA05-53A2-4C5C-B034-22BC1832CCDF' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.Sequence 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2D91F10D-04A1-4B00-BCF7-D889E80303CC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.Title 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A8482D32-01F1-448D-A958-354A46144F4F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.Description 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3B9453F6-EC9E-4D47-BC10-29C9E09463D1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.MovedByMembershipID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'DE818F09-2CC4-4B00-8635-AAC75320BA53' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.SecondedByMembershipID 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8A849122-7EC5-476D-A8E8-A7561BDD4BE4' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.Result 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1E001563-E6B3-49CD-AB5A-BCCFCFBE04E6' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.ResultSummary 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B33E9C74-C557-4A7B-9E6A-DA885582017D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.YesCount 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C261B616-394B-438E-8D8A-FA69B869FE66' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.NoCount 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '65FDFA6A-9F61-42BC-A371-CB41634F0305' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.AbstainCount 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '48291A88-3B5E-4FCB-99C8-C22D7EDDF97B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.Notes 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C2C862E1-C0C9-4004-A0DA-FA2FE45DD3A1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.__mj_CreatedAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B579595C-90CC-4270-B561-1E83538DBBDB' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.__mj_UpdatedAt 
UPDATE [__mj].[EntityField]
SET 
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F6A6998C-80C8-49F6-A6F3-1E04CAA8591B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.Meeting 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Motion Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D33559A2-5A00-4169-8347-ADA423D6E981' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.AgendaItem 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Motion Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FE387BB6-C63C-4DCF-BECB-8265AA0DA2DC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.MovedByMembership 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Member Participation',
   GeneratedFormSection = 'Category',
   DisplayName = 'Moved By Member',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '43A2331F-0922-4DB5-98CE-31944B7E69E8' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.SecondedByMembership 
UPDATE [__mj].[EntityField]
SET 
   Category = 'Member Participation',
   GeneratedFormSection = 'Category',
   DisplayName = 'Seconded By Member',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F9D7CFE8-DAE4-456F-AC3E-75F79E2BDA05' AND AutoUpdateCategory = 1

