/* SQL generated to create new entity Attendances */

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
         '28992c32-d738-4e7c-97ca-5f0489e89d56',
         'Attendances',
         NULL,
         'Meeting attendance records for committee members',
         NULL,
         'Attendance',
         'vwAttendances',
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
   

/* SQL generated to create new application ${flyway:defaultSchema}_Committees */
INSERT INTO [${flyway:defaultSchema}].[Application] (ID, Name, Description, SchemaAutoAddNewEntities, Path, AutoUpdatePath)
                       VALUES ('4e2cbb84-5561-4d12-9ab2-e56701859557', '${flyway:defaultSchema}_Committees', 'Generated for schema', '${flyway:defaultSchema}_Committees', 'mjcommittees', 1)

/* SQL generated to add new entity Attendances to application ID: '4e2cbb84-5561-4d12-9ab2-e56701859557' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('4e2cbb84-5561-4d12-9ab2-e56701859557', '28992c32-d738-4e7c-97ca-5f0489e89d56', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = '4e2cbb84-5561-4d12-9ab2-e56701859557'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Attendances for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('28992c32-d738-4e7c-97ca-5f0489e89d56', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Attendances for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('28992c32-d738-4e7c-97ca-5f0489e89d56', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Attendances for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('28992c32-d738-4e7c-97ca-5f0489e89d56', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

/* SQL generated to create new entity Action Items */

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
         '216dc5a7-41c9-4165-9e5a-93e514b9fd4b',
         'Action Items',
         NULL,
         'Tasks and action items assigned from committees or meetings',
         NULL,
         'ActionItem',
         'vwActionItems',
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
   

/* SQL generated to add new entity Action Items to application ID: '4E2CBB84-5561-4D12-9AB2-E56701859557' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('4E2CBB84-5561-4D12-9AB2-E56701859557', '216dc5a7-41c9-4165-9e5a-93e514b9fd4b', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = '4E2CBB84-5561-4D12-9AB2-E56701859557'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Action Items for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('216dc5a7-41c9-4165-9e5a-93e514b9fd4b', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Action Items for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('216dc5a7-41c9-4165-9e5a-93e514b9fd4b', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Action Items for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('216dc5a7-41c9-4165-9e5a-93e514b9fd4b', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

/* SQL generated to create new entity Artifact Types */

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
         'e9bcb64e-8aa3-45fa-bcd3-ea9da7af0476',
         'Artifact Types',
         NULL,
         'Categories of committee artifacts with optional extension entity for type-specific fields',
         NULL,
         'ArtifactType',
         'vwArtifactTypes',
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
   

/* SQL generated to add new entity Artifact Types to application ID: '4E2CBB84-5561-4D12-9AB2-E56701859557' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('4E2CBB84-5561-4D12-9AB2-E56701859557', 'e9bcb64e-8aa3-45fa-bcd3-ea9da7af0476', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = '4E2CBB84-5561-4D12-9AB2-E56701859557'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Artifact Types for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('e9bcb64e-8aa3-45fa-bcd3-ea9da7af0476', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Artifact Types for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('e9bcb64e-8aa3-45fa-bcd3-ea9da7af0476', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Artifact Types for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('e9bcb64e-8aa3-45fa-bcd3-ea9da7af0476', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

/* SQL generated to create new entity Artifacts */

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
         '26e04065-1f39-4ab6-913e-6b87481defa7',
         'Artifacts',
         NULL,
         'Links to external documents and files from various providers',
         NULL,
         'Artifact',
         'vwArtifacts',
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
   

/* SQL generated to add new entity Artifacts to application ID: '4E2CBB84-5561-4D12-9AB2-E56701859557' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('4E2CBB84-5561-4D12-9AB2-E56701859557', '26e04065-1f39-4ab6-913e-6b87481defa7', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = '4E2CBB84-5561-4D12-9AB2-E56701859557'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Artifacts for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('26e04065-1f39-4ab6-913e-6b87481defa7', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Artifacts for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('26e04065-1f39-4ab6-913e-6b87481defa7', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Artifacts for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('26e04065-1f39-4ab6-913e-6b87481defa7', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

/* SQL generated to create new entity Minutes */

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
         '58792440-2d28-46cf-bfb3-79a214063e37',
         'Minutes',
         NULL,
         'Extension entity for Minutes artifacts with approval tracking',
         NULL,
         'Minute',
         'vwMinutes',
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
   

/* SQL generated to add new entity Minutes to application ID: '4E2CBB84-5561-4D12-9AB2-E56701859557' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('4E2CBB84-5561-4D12-9AB2-E56701859557', '58792440-2d28-46cf-bfb3-79a214063e37', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = '4E2CBB84-5561-4D12-9AB2-E56701859557'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Minutes for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('58792440-2d28-46cf-bfb3-79a214063e37', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Minutes for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('58792440-2d28-46cf-bfb3-79a214063e37', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Minutes for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('58792440-2d28-46cf-bfb3-79a214063e37', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

/* SQL generated to create new entity Motions */

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
         '36d14c54-9d93-4a39-a282-6bf7b997b70e',
         'Motions',
         NULL,
         'Formal motions put to vote during committee meetings',
         NULL,
         'Motion',
         'vwMotions',
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
   

/* SQL generated to add new entity Motions to application ID: '4E2CBB84-5561-4D12-9AB2-E56701859557' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('4E2CBB84-5561-4D12-9AB2-E56701859557', '36d14c54-9d93-4a39-a282-6bf7b997b70e', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = '4E2CBB84-5561-4D12-9AB2-E56701859557'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Motions for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('36d14c54-9d93-4a39-a282-6bf7b997b70e', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Motions for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('36d14c54-9d93-4a39-a282-6bf7b997b70e', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Motions for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('36d14c54-9d93-4a39-a282-6bf7b997b70e', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

/* SQL generated to create new entity Votes */

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
         'ccc2482f-5e43-4e5a-886f-476f7c9f2c71',
         'Votes',
         NULL,
         'Individual vote records for committee motions',
         NULL,
         'Vote',
         'vwVotes',
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
   

/* SQL generated to add new entity Votes to application ID: '4E2CBB84-5561-4D12-9AB2-E56701859557' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('4E2CBB84-5561-4D12-9AB2-E56701859557', 'ccc2482f-5e43-4e5a-886f-476f7c9f2c71', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = '4E2CBB84-5561-4D12-9AB2-E56701859557'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Votes for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('ccc2482f-5e43-4e5a-886f-476f7c9f2c71', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Votes for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('ccc2482f-5e43-4e5a-886f-476f7c9f2c71', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Votes for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('ccc2482f-5e43-4e5a-886f-476f7c9f2c71', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

/* SQL generated to create new entity Comments */

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
         'beb0a1c9-045d-4fc4-8ec9-749c236a21f1',
         'Comments',
         NULL,
         'Threaded discussion comments on committee meetings, agenda items, action items, and documents',
         NULL,
         'Comment',
         'vwComments',
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
   

/* SQL generated to add new entity Comments to application ID: '4E2CBB84-5561-4D12-9AB2-E56701859557' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('4E2CBB84-5561-4D12-9AB2-E56701859557', 'beb0a1c9-045d-4fc4-8ec9-749c236a21f1', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = '4E2CBB84-5561-4D12-9AB2-E56701859557'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Comments for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('beb0a1c9-045d-4fc4-8ec9-749c236a21f1', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Comments for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('beb0a1c9-045d-4fc4-8ec9-749c236a21f1', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Comments for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('beb0a1c9-045d-4fc4-8ec9-749c236a21f1', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

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
         '236e9d2a-60e6-4cc7-befa-43f70a24c6dc',
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
   

/* SQL generated to add new entity Video Providers to application ID: '4E2CBB84-5561-4D12-9AB2-E56701859557' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('4E2CBB84-5561-4D12-9AB2-E56701859557', '236e9d2a-60e6-4cc7-befa-43f70a24c6dc', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = '4E2CBB84-5561-4D12-9AB2-E56701859557'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Video Providers for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('236e9d2a-60e6-4cc7-befa-43f70a24c6dc', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Video Providers for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('236e9d2a-60e6-4cc7-befa-43f70a24c6dc', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Video Providers for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('236e9d2a-60e6-4cc7-befa-43f70a24c6dc', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

/* SQL generated to create new entity Types */

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
         '1b9bf218-367f-452e-9dd9-bde6f306f742',
         'Types',
         NULL,
         'Categories of committees such as Board, Standing, Ad Hoc, Workgroup',
         NULL,
         'Type',
         'vwTypes',
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
   

/* SQL generated to add new entity Types to application ID: '4E2CBB84-5561-4D12-9AB2-E56701859557' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('4E2CBB84-5561-4D12-9AB2-E56701859557', '1b9bf218-367f-452e-9dd9-bde6f306f742', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = '4E2CBB84-5561-4D12-9AB2-E56701859557'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Types for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('1b9bf218-367f-452e-9dd9-bde6f306f742', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Types for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('1b9bf218-367f-452e-9dd9-bde6f306f742', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Types for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('1b9bf218-367f-452e-9dd9-bde6f306f742', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

/* SQL generated to create new entity Committees */

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
         '74ae48b6-cddb-40b7-b987-34dafcb94fb0',
         'Committees',
         NULL,
         'Core committee records with hierarchy support',
         NULL,
         'Committee',
         'vwCommittees',
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
   

/* SQL generated to add new entity Committees to application ID: '4E2CBB84-5561-4D12-9AB2-E56701859557' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('4E2CBB84-5561-4D12-9AB2-E56701859557', '74ae48b6-cddb-40b7-b987-34dafcb94fb0', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = '4E2CBB84-5561-4D12-9AB2-E56701859557'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Committees for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('74ae48b6-cddb-40b7-b987-34dafcb94fb0', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Committees for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('74ae48b6-cddb-40b7-b987-34dafcb94fb0', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Committees for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('74ae48b6-cddb-40b7-b987-34dafcb94fb0', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

/* SQL generated to create new entity Terms */

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
         '2c53b672-ea32-465c-beab-cd20e8d2e9c4',
         'Terms',
         NULL,
         'Time periods for committee membership cycles',
         NULL,
         'Term',
         'vwTerms',
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
   

/* SQL generated to add new entity Terms to application ID: '4E2CBB84-5561-4D12-9AB2-E56701859557' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('4E2CBB84-5561-4D12-9AB2-E56701859557', '2c53b672-ea32-465c-beab-cd20e8d2e9c4', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = '4E2CBB84-5561-4D12-9AB2-E56701859557'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Terms for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('2c53b672-ea32-465c-beab-cd20e8d2e9c4', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Terms for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('2c53b672-ea32-465c-beab-cd20e8d2e9c4', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Terms for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('2c53b672-ea32-465c-beab-cd20e8d2e9c4', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

/* SQL generated to create new entity Roles */

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
         'e170a834-9278-49db-9f73-08945c0e83df',
         'Roles',
         NULL,
         'Roles that members can hold on committees',
         NULL,
         'Role',
         'vwRoles',
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
   

/* SQL generated to add new entity Roles to application ID: '4E2CBB84-5561-4D12-9AB2-E56701859557' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('4E2CBB84-5561-4D12-9AB2-E56701859557', 'e170a834-9278-49db-9f73-08945c0e83df', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = '4E2CBB84-5561-4D12-9AB2-E56701859557'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Roles for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('e170a834-9278-49db-9f73-08945c0e83df', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Roles for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('e170a834-9278-49db-9f73-08945c0e83df', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Roles for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('e170a834-9278-49db-9f73-08945c0e83df', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

/* SQL generated to create new entity Memberships */

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
         '35aacfd0-c02b-4d1b-ad41-8c081d08650c',
         'Memberships',
         NULL,
         'Person assignments to committees with roles and terms',
         NULL,
         'Membership',
         'vwMemberships',
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
   

/* SQL generated to add new entity Memberships to application ID: '4E2CBB84-5561-4D12-9AB2-E56701859557' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('4E2CBB84-5561-4D12-9AB2-E56701859557', '35aacfd0-c02b-4d1b-ad41-8c081d08650c', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = '4E2CBB84-5561-4D12-9AB2-E56701859557'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Memberships for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('35aacfd0-c02b-4d1b-ad41-8c081d08650c', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Memberships for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('35aacfd0-c02b-4d1b-ad41-8c081d08650c', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Memberships for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('35aacfd0-c02b-4d1b-ad41-8c081d08650c', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

/* SQL generated to create new entity Meetings */

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
         '473622ee-daf0-4a10-8289-f9c14b937a44',
         'Meetings',
         NULL,
         'Committee meeting records with scheduling and video conferencing info',
         NULL,
         'Meeting',
         'vwMeetings',
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
   

/* SQL generated to add new entity Meetings to application ID: '4E2CBB84-5561-4D12-9AB2-E56701859557' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('4E2CBB84-5561-4D12-9AB2-E56701859557', '473622ee-daf0-4a10-8289-f9c14b937a44', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = '4E2CBB84-5561-4D12-9AB2-E56701859557'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Meetings for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('473622ee-daf0-4a10-8289-f9c14b937a44', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Meetings for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('473622ee-daf0-4a10-8289-f9c14b937a44', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Meetings for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('473622ee-daf0-4a10-8289-f9c14b937a44', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

/* SQL generated to create new entity Agenda Items */

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
         '21eeb23a-4506-4ccf-a2d2-ede25ae5b0e6',
         'Agenda Items',
         NULL,
         'Structured agenda items for meetings with hierarchy support',
         NULL,
         'AgendaItem',
         'vwAgendaItems',
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
   

/* SQL generated to add new entity Agenda Items to application ID: '4E2CBB84-5561-4D12-9AB2-E56701859557' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('4E2CBB84-5561-4D12-9AB2-E56701859557', '21eeb23a-4506-4ccf-a2d2-ede25ae5b0e6', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = '4E2CBB84-5561-4D12-9AB2-E56701859557'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Agenda Items for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('21eeb23a-4506-4ccf-a2d2-ede25ae5b0e6', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Agenda Items for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('21eeb23a-4506-4ccf-a2d2-ede25ae5b0e6', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Agenda Items for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('21eeb23a-4506-4ccf-a2d2-ede25ae5b0e6', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Role */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Role] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Role */
UPDATE [${flyway:defaultSchema}_Committees].[Role] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Role */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Role] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Role */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Role] ADD CONSTRAINT [DF___mj_Committees_Role___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt]

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Role */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Role] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Role */
UPDATE [${flyway:defaultSchema}_Committees].[Role] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Role */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Role] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Role */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Role] ADD CONSTRAINT [DF___mj_Committees_Role___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt]

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Committee */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Committee] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Committee */
UPDATE [${flyway:defaultSchema}_Committees].[Committee] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Committee */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Committee] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Committee */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Committee] ADD CONSTRAINT [DF___mj_Committees_Committee___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt]

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Committee */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Committee] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Committee */
UPDATE [${flyway:defaultSchema}_Committees].[Committee] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Committee */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Committee] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Committee */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Committee] ADD CONSTRAINT [DF___mj_Committees_Committee___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt]

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

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Vote */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Vote] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Vote */
UPDATE [${flyway:defaultSchema}_Committees].[Vote] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Vote */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Vote] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Vote */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Vote] ADD CONSTRAINT [DF___mj_Committees_Vote___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt]

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Vote */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Vote] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Vote */
UPDATE [${flyway:defaultSchema}_Committees].[Vote] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Vote */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Vote] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Vote */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Vote] ADD CONSTRAINT [DF___mj_Committees_Vote___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt]

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Attendance */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Attendance] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Attendance */
UPDATE [${flyway:defaultSchema}_Committees].[Attendance] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Attendance */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Attendance] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Attendance */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Attendance] ADD CONSTRAINT [DF___mj_Committees_Attendance___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt]

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Attendance */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Attendance] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Attendance */
UPDATE [${flyway:defaultSchema}_Committees].[Attendance] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Attendance */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Attendance] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Attendance */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Attendance] ADD CONSTRAINT [DF___mj_Committees_Attendance___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt]

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Artifact */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Artifact] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Artifact */
UPDATE [${flyway:defaultSchema}_Committees].[Artifact] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Artifact */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Artifact] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Artifact */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Artifact] ADD CONSTRAINT [DF___mj_Committees_Artifact___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt]

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Artifact */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Artifact] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Artifact */
UPDATE [${flyway:defaultSchema}_Committees].[Artifact] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Artifact */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Artifact] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Artifact */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Artifact] ADD CONSTRAINT [DF___mj_Committees_Artifact___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt]

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Motion */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Motion] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Motion */
UPDATE [${flyway:defaultSchema}_Committees].[Motion] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Motion */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Motion] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Motion */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Motion] ADD CONSTRAINT [DF___mj_Committees_Motion___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt]

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Motion */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Motion] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Motion */
UPDATE [${flyway:defaultSchema}_Committees].[Motion] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Motion */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Motion] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Motion */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Motion] ADD CONSTRAINT [DF___mj_Committees_Motion___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt]

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Comment */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Comment] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Comment */
UPDATE [${flyway:defaultSchema}_Committees].[Comment] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Comment */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Comment] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Comment */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Comment] ADD CONSTRAINT [DF___mj_Committees_Comment___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt]

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Comment */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Comment] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Comment */
UPDATE [${flyway:defaultSchema}_Committees].[Comment] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Comment */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Comment] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Comment */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Comment] ADD CONSTRAINT [DF___mj_Committees_Comment___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt]

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Minute */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Minute] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Minute */
UPDATE [${flyway:defaultSchema}_Committees].[Minute] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Minute */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Minute] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Minute */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Minute] ADD CONSTRAINT [DF___mj_Committees_Minute___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt]

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Minute */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Minute] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Minute */
UPDATE [${flyway:defaultSchema}_Committees].[Minute] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Minute */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Minute] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Minute */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Minute] ADD CONSTRAINT [DF___mj_Committees_Minute___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt]

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Membership */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Membership] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Membership */
UPDATE [${flyway:defaultSchema}_Committees].[Membership] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Membership */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Membership] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Membership */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Membership] ADD CONSTRAINT [DF___mj_Committees_Membership___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt]

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Membership */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Membership] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Membership */
UPDATE [${flyway:defaultSchema}_Committees].[Membership] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Membership */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Membership] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Membership */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Membership] ADD CONSTRAINT [DF___mj_Committees_Membership___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt]

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.ActionItem */
ALTER TABLE [${flyway:defaultSchema}_Committees].[ActionItem] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.ActionItem */
UPDATE [${flyway:defaultSchema}_Committees].[ActionItem] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.ActionItem */
ALTER TABLE [${flyway:defaultSchema}_Committees].[ActionItem] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.ActionItem */
ALTER TABLE [${flyway:defaultSchema}_Committees].[ActionItem] ADD CONSTRAINT [DF___mj_Committees_ActionItem___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt]

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.ActionItem */
ALTER TABLE [${flyway:defaultSchema}_Committees].[ActionItem] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.ActionItem */
UPDATE [${flyway:defaultSchema}_Committees].[ActionItem] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.ActionItem */
ALTER TABLE [${flyway:defaultSchema}_Committees].[ActionItem] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.ActionItem */
ALTER TABLE [${flyway:defaultSchema}_Committees].[ActionItem] ADD CONSTRAINT [DF___mj_Committees_ActionItem___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt]

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Type */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Type] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Type */
UPDATE [${flyway:defaultSchema}_Committees].[Type] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Type */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Type] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Type */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Type] ADD CONSTRAINT [DF___mj_Committees_Type___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt]

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Type */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Type] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Type */
UPDATE [${flyway:defaultSchema}_Committees].[Type] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Type */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Type] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Type */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Type] ADD CONSTRAINT [DF___mj_Committees_Type___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt]

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Term */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Term] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Term */
UPDATE [${flyway:defaultSchema}_Committees].[Term] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Term */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Term] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Term */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Term] ADD CONSTRAINT [DF___mj_Committees_Term___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt]

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Term */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Term] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Term */
UPDATE [${flyway:defaultSchema}_Committees].[Term] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Term */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Term] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Term */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Term] ADD CONSTRAINT [DF___mj_Committees_Term___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt]

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.ArtifactType */
ALTER TABLE [${flyway:defaultSchema}_Committees].[ArtifactType] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.ArtifactType */
UPDATE [${flyway:defaultSchema}_Committees].[ArtifactType] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.ArtifactType */
ALTER TABLE [${flyway:defaultSchema}_Committees].[ArtifactType] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.ArtifactType */
ALTER TABLE [${flyway:defaultSchema}_Committees].[ArtifactType] ADD CONSTRAINT [DF___mj_Committees_ArtifactType___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt]

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.ArtifactType */
ALTER TABLE [${flyway:defaultSchema}_Committees].[ArtifactType] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.ArtifactType */
UPDATE [${flyway:defaultSchema}_Committees].[ArtifactType] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.ArtifactType */
ALTER TABLE [${flyway:defaultSchema}_Committees].[ArtifactType] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.ArtifactType */
ALTER TABLE [${flyway:defaultSchema}_Committees].[ArtifactType] ADD CONSTRAINT [DF___mj_Committees_ArtifactType___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt]

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.AgendaItem */
ALTER TABLE [${flyway:defaultSchema}_Committees].[AgendaItem] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.AgendaItem */
UPDATE [${flyway:defaultSchema}_Committees].[AgendaItem] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.AgendaItem */
ALTER TABLE [${flyway:defaultSchema}_Committees].[AgendaItem] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.AgendaItem */
ALTER TABLE [${flyway:defaultSchema}_Committees].[AgendaItem] ADD CONSTRAINT [DF___mj_Committees_AgendaItem___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt]

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.AgendaItem */
ALTER TABLE [${flyway:defaultSchema}_Committees].[AgendaItem] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.AgendaItem */
UPDATE [${flyway:defaultSchema}_Committees].[AgendaItem] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.AgendaItem */
ALTER TABLE [${flyway:defaultSchema}_Committees].[AgendaItem] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.AgendaItem */
ALTER TABLE [${flyway:defaultSchema}_Committees].[AgendaItem] ADD CONSTRAINT [DF___mj_Committees_AgendaItem___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt]

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Meeting */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Meeting] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Meeting */
UPDATE [${flyway:defaultSchema}_Committees].[Meeting] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Meeting */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Meeting] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Meeting */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Meeting] ADD CONSTRAINT [DF___mj_Committees_Meeting___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt]

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Meeting */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Meeting] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Meeting */
UPDATE [${flyway:defaultSchema}_Committees].[Meeting] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Meeting */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Meeting] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Meeting */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Meeting] ADD CONSTRAINT [DF___mj_Committees_Meeting___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt]

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '8c199fee-16ee-4e47-80b1-5c7f082622d9' OR (EntityID = 'E170A834-9278-49DB-9F73-08945C0E83DF' AND Name = 'ID')) BEGIN
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
            '8c199fee-16ee-4e47-80b1-5c7f082622d9',
            'E170A834-9278-49DB-9F73-08945C0E83DF', -- Entity: Roles
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '120680cc-02ac-4750-8c74-562be10a75df' OR (EntityID = 'E170A834-9278-49DB-9F73-08945C0E83DF' AND Name = 'Name')) BEGIN
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
            '120680cc-02ac-4750-8c74-562be10a75df',
            'E170A834-9278-49DB-9F73-08945C0E83DF', -- Entity: Roles
            100002,
            'Name',
            'Name',
            'Display name for the role',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '23aeda85-e83a-44ef-8182-76490f6ae84b' OR (EntityID = 'E170A834-9278-49DB-9F73-08945C0E83DF' AND Name = 'Description')) BEGIN
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
            '23aeda85-e83a-44ef-8182-76490f6ae84b',
            'E170A834-9278-49DB-9F73-08945C0E83DF', -- Entity: Roles
            100003,
            'Description',
            'Description',
            'Detailed description of role responsibilities',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '51040b52-e73d-447c-afb4-fea5536153e5' OR (EntityID = 'E170A834-9278-49DB-9F73-08945C0E83DF' AND Name = 'IsOfficer')) BEGIN
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
            '51040b52-e73d-447c-afb4-fea5536153e5',
            'E170A834-9278-49DB-9F73-08945C0E83DF', -- Entity: Roles
            100004,
            'IsOfficer',
            'Is Officer',
            'Whether this is an officer role like Chair or Secretary',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '14d45c1c-68ee-4f7d-973a-68517af0abde' OR (EntityID = 'E170A834-9278-49DB-9F73-08945C0E83DF' AND Name = 'IsVotingRole')) BEGIN
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
            '14d45c1c-68ee-4f7d-973a-68517af0abde',
            'E170A834-9278-49DB-9F73-08945C0E83DF', -- Entity: Roles
            100005,
            'IsVotingRole',
            'Is Voting Role',
            'Whether members in this role can vote',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1d4fff56-00c3-49d4-bbb9-869f9bfaa828' OR (EntityID = 'E170A834-9278-49DB-9F73-08945C0E83DF' AND Name = 'DefaultPermissionsJSON')) BEGIN
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
            '1d4fff56-00c3-49d4-bbb9-869f9bfaa828',
            'E170A834-9278-49DB-9F73-08945C0E83DF', -- Entity: Roles
            100006,
            'DefaultPermissionsJSON',
            'Default Permissions JSON',
            'JSON object defining default permissions for this role',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'edfc47e9-616a-4849-aaa7-59faf853b0a1' OR (EntityID = 'E170A834-9278-49DB-9F73-08945C0E83DF' AND Name = 'Sequence')) BEGIN
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
            'edfc47e9-616a-4849-aaa7-59faf853b0a1',
            'E170A834-9278-49DB-9F73-08945C0E83DF', -- Entity: Roles
            100007,
            'Sequence',
            'Sequence',
            'Display order for sorting roles',
            'int',
            4,
            10,
            0,
            0,
            '(100)',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'd3044ca2-8d5c-45c9-b94d-2312e44f9734' OR (EntityID = 'E170A834-9278-49DB-9F73-08945C0E83DF' AND Name = '__mj_CreatedAt')) BEGIN
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
            'd3044ca2-8d5c-45c9-b94d-2312e44f9734',
            'E170A834-9278-49DB-9F73-08945C0E83DF', -- Entity: Roles
            100008,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '254c51eb-4f8b-4973-8823-b60963c5f6da' OR (EntityID = 'E170A834-9278-49DB-9F73-08945C0E83DF' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '254c51eb-4f8b-4973-8823-b60963c5f6da',
            'E170A834-9278-49DB-9F73-08945C0E83DF', -- Entity: Roles
            100009,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '110eabbf-5744-49fd-99e8-716cc570e0ea' OR (EntityID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0' AND Name = 'ID')) BEGIN
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
            '110eabbf-5744-49fd-99e8-716cc570e0ea',
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', -- Entity: Committees
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '601ac8ea-462d-4f6f-89aa-46cebcd820a6' OR (EntityID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0' AND Name = 'Name')) BEGIN
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
            '601ac8ea-462d-4f6f-89aa-46cebcd820a6',
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', -- Entity: Committees
            100002,
            'Name',
            'Name',
            'Official name of the committee',
            'nvarchar',
            510,
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
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'a5acf0a8-3fd9-4cd6-b8fa-3b45bb80e004' OR (EntityID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0' AND Name = 'Description')) BEGIN
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
            'a5acf0a8-3fd9-4cd6-b8fa-3b45bb80e004',
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', -- Entity: Committees
            100003,
            'Description',
            'Description',
            'Detailed description of the committee purpose and scope',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '660c3dfb-2da3-4ff2-ad1b-d581b22c64fb' OR (EntityID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0' AND Name = 'TypeID')) BEGIN
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
            '660c3dfb-2da3-4ff2-ad1b-d581b22c64fb',
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', -- Entity: Committees
            100004,
            'TypeID',
            'Type ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            '1B9BF218-367F-452E-9DD9-BDE6F306F742',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'ced94bb1-2b5d-4034-9060-8f5d679b66ce' OR (EntityID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0' AND Name = 'ParentCommitteeID')) BEGIN
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
            'ced94bb1-2b5d-4034-9060-8f5d679b66ce',
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', -- Entity: Committees
            100005,
            'ParentCommitteeID',
            'Parent Committee ID',
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
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'ba0a2bd5-dbfa-494e-97a9-000e4dc208e4' OR (EntityID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0' AND Name = 'OrganizationID')) BEGIN
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
            'ba0a2bd5-dbfa-494e-97a9-000e4dc208e4',
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', -- Entity: Committees
            100006,
            'OrganizationID',
            'Organization ID',
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
            'C70448F9-9792-41D7-A82C-784B66429D54',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '11ecf6da-8508-4656-80f3-ad7eea41fb18' OR (EntityID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0' AND Name = 'CharterDocumentURL')) BEGIN
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
            '11ecf6da-8508-4656-80f3-ad7eea41fb18',
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', -- Entity: Committees
            100007,
            'CharterDocumentURL',
            'Charter Document URL',
            'URL to the committee charter document',
            'nvarchar',
            2000,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '47717ed1-6b71-448d-9908-d20ecd28bc73' OR (EntityID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0' AND Name = 'MissionStatement')) BEGIN
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
            '47717ed1-6b71-448d-9908-d20ecd28bc73',
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', -- Entity: Committees
            100008,
            'MissionStatement',
            'Mission Statement',
            'Brief statement of the committee mission',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '68040577-adf2-4ebf-a80e-fe0bbc205f0b' OR (EntityID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0' AND Name = 'Status')) BEGIN
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
            '68040577-adf2-4ebf-a80e-fe0bbc205f0b',
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', -- Entity: Committees
            100009,
            'Status',
            'Status',
            'Current status: Active, Inactive, Pending, or Dissolved',
            'nvarchar',
            100,
            0,
            0,
            0,
            'Active',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'cb49f682-7ebd-4e9b-893f-2ae0817ee62a' OR (EntityID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0' AND Name = 'IsPublic')) BEGIN
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
            'cb49f682-7ebd-4e9b-893f-2ae0817ee62a',
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', -- Entity: Committees
            100010,
            'IsPublic',
            'Is Public',
            'Whether the committee is visible to all users',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '5803a860-ef51-4956-a0ee-844dfc2ce4c3' OR (EntityID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0' AND Name = 'FormationDate')) BEGIN
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
            '5803a860-ef51-4956-a0ee-844dfc2ce4c3',
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', -- Entity: Committees
            100011,
            'FormationDate',
            'Formation Date',
            'Date the committee was formed',
            'date',
            3,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '35c31f10-b0dc-481b-9940-626c9fdbe2ca' OR (EntityID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0' AND Name = 'DissolutionDate')) BEGIN
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
            '35c31f10-b0dc-481b-9940-626c9fdbe2ca',
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', -- Entity: Committees
            100012,
            'DissolutionDate',
            'Dissolution Date',
            'Date the committee was dissolved, if applicable',
            'date',
            3,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'ec8efc75-212f-4276-945d-c69996c57ee4' OR (EntityID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0' AND Name = '__mj_CreatedAt')) BEGIN
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
            'ec8efc75-212f-4276-945d-c69996c57ee4',
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', -- Entity: Committees
            100013,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'afb3a817-fe73-4bef-bb95-fc6725c95807' OR (EntityID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0' AND Name = '__mj_UpdatedAt')) BEGIN
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
            'afb3a817-fe73-4bef-bb95-fc6725c95807',
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', -- Entity: Committees
            100014,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'dadec113-06ab-4d7c-8d9b-ed75172a90c5' OR (EntityID = '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC' AND Name = 'ID')) BEGIN
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
            'dadec113-06ab-4d7c-8d9b-ed75172a90c5',
            '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC', -- Entity: Video Providers
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '34ac88ae-d104-469a-8dcc-d71dab02e7c2' OR (EntityID = '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC' AND Name = 'Name')) BEGIN
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
            '34ac88ae-d104-469a-8dcc-d71dab02e7c2',
            '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC', -- Entity: Video Providers
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '8b674f0d-49a4-4f80-85cb-76501289b887' OR (EntityID = '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC' AND Name = 'ServerDriverKey')) BEGIN
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
            '8b674f0d-49a4-4f80-85cb-76501289b887',
            '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC', -- Entity: Video Providers
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '551de0ad-d745-42b2-ac86-f5ccd0be1f4c' OR (EntityID = '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC' AND Name = 'IsActive')) BEGIN
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
            '551de0ad-d745-42b2-ac86-f5ccd0be1f4c',
            '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC', -- Entity: Video Providers
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '81f9254d-d977-4fd5-b73d-2c1e3b0d234d' OR (EntityID = '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC' AND Name = 'IsDefault')) BEGIN
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
            '81f9254d-d977-4fd5-b73d-2c1e3b0d234d',
            '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC', -- Entity: Video Providers
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '2b9eca4a-f682-465d-9820-d9afb50ffce7' OR (EntityID = '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC' AND Name = 'CredentialID')) BEGIN
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
            '2b9eca4a-f682-465d-9820-d9afb50ffce7',
            '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC', -- Entity: Video Providers
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '527c3815-3082-439e-8331-9aeff102c866' OR (EntityID = '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC' AND Name = '__mj_CreatedAt')) BEGIN
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
            '527c3815-3082-439e-8331-9aeff102c866',
            '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC', -- Entity: Video Providers
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1e432657-d46c-4ca5-8d01-3f30f8b76b02' OR (EntityID = '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '1e432657-d46c-4ca5-8d01-3f30f8b76b02',
            '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC', -- Entity: Video Providers
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c5ddc77c-9397-44a6-ad5f-219a1a206cc6' OR (EntityID = 'CCC2482F-5E43-4E5A-886F-476F7C9F2C71' AND Name = 'ID')) BEGIN
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
            'c5ddc77c-9397-44a6-ad5f-219a1a206cc6',
            'CCC2482F-5E43-4E5A-886F-476F7C9F2C71', -- Entity: Votes
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '62cd5c9a-2f86-4189-8901-c4c1a65a6351' OR (EntityID = 'CCC2482F-5E43-4E5A-886F-476F7C9F2C71' AND Name = 'MotionID')) BEGIN
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
            '62cd5c9a-2f86-4189-8901-c4c1a65a6351',
            'CCC2482F-5E43-4E5A-886F-476F7C9F2C71', -- Entity: Votes
            100002,
            'MotionID',
            'Motion ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            '36D14C54-9D93-4A39-A282-6BF7B997B70E',
            'ID',
            0,
            0,
            1,
            0,
            0,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '5d0d39bf-0669-4dcc-be93-e1eb93d8376a' OR (EntityID = 'CCC2482F-5E43-4E5A-886F-476F7C9F2C71' AND Name = 'MembershipID')) BEGIN
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
            '5d0d39bf-0669-4dcc-be93-e1eb93d8376a',
            'CCC2482F-5E43-4E5A-886F-476F7C9F2C71', -- Entity: Votes
            100003,
            'MembershipID',
            'Membership ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            '35AACFD0-C02B-4D1B-AD41-8C081D08650C',
            'ID',
            0,
            0,
            1,
            0,
            0,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '5c9f9821-5901-46a1-8210-1c75cd49f08d' OR (EntityID = 'CCC2482F-5E43-4E5A-886F-476F7C9F2C71' AND Name = 'VoteValue')) BEGIN
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
            '5c9f9821-5901-46a1-8210-1c75cd49f08d',
            'CCC2482F-5E43-4E5A-886F-476F7C9F2C71', -- Entity: Votes
            100004,
            'VoteValue',
            'Vote Value',
            'The vote cast: Yes, No, Abstain, or Absent',
            'nvarchar',
            40,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '53ca9655-3f05-4cd9-8cf0-2c78e0fc77d3' OR (EntityID = 'CCC2482F-5E43-4E5A-886F-476F7C9F2C71' AND Name = 'Notes')) BEGIN
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
            '53ca9655-3f05-4cd9-8cf0-2c78e0fc77d3',
            'CCC2482F-5E43-4E5A-886F-476F7C9F2C71', -- Entity: Votes
            100005,
            'Notes',
            'Notes',
            'Optional notes explaining the vote',
            'nvarchar',
            1000,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '53ce271e-6e6f-4dec-98ba-1a106fcaa11b' OR (EntityID = 'CCC2482F-5E43-4E5A-886F-476F7C9F2C71' AND Name = '__mj_CreatedAt')) BEGIN
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
            '53ce271e-6e6f-4dec-98ba-1a106fcaa11b',
            'CCC2482F-5E43-4E5A-886F-476F7C9F2C71', -- Entity: Votes
            100006,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'a5c4e322-1f70-4b11-b08b-c833a42095ba' OR (EntityID = 'CCC2482F-5E43-4E5A-886F-476F7C9F2C71' AND Name = '__mj_UpdatedAt')) BEGIN
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
            'a5c4e322-1f70-4b11-b08b-c833a42095ba',
            'CCC2482F-5E43-4E5A-886F-476F7C9F2C71', -- Entity: Votes
            100007,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '99421172-cd14-4461-bc33-8f9323f63715' OR (EntityID = '28992C32-D738-4E7C-97CA-5F0489E89D56' AND Name = 'ID')) BEGIN
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
            '99421172-cd14-4461-bc33-8f9323f63715',
            '28992C32-D738-4E7C-97CA-5F0489E89D56', -- Entity: Attendances
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'e9086cec-bdc5-43f2-a969-50e4e944788f' OR (EntityID = '28992C32-D738-4E7C-97CA-5F0489E89D56' AND Name = 'MeetingID')) BEGIN
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
            'e9086cec-bdc5-43f2-a969-50e4e944788f',
            '28992C32-D738-4E7C-97CA-5F0489E89D56', -- Entity: Attendances
            100002,
            'MeetingID',
            'Meeting ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            '473622EE-DAF0-4A10-8289-F9C14B937A44',
            'ID',
            0,
            0,
            1,
            0,
            0,
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '4731151b-deaf-444b-bd5e-83825d55cbd1' OR (EntityID = '28992C32-D738-4E7C-97CA-5F0489E89D56' AND Name = 'PersonID')) BEGIN
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
            '4731151b-deaf-444b-bd5e-83825d55cbd1',
            '28992C32-D738-4E7C-97CA-5F0489E89D56', -- Entity: Attendances
            100003,
            'PersonID',
            'Person ID',
            NULL,
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
            1,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '2ec8cc0d-77e2-4557-99ab-f50b976b0f31' OR (EntityID = '28992C32-D738-4E7C-97CA-5F0489E89D56' AND Name = 'AttendanceStatus')) BEGIN
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
            '2ec8cc0d-77e2-4557-99ab-f50b976b0f31',
            '28992C32-D738-4E7C-97CA-5F0489E89D56', -- Entity: Attendances
            100004,
            'AttendanceStatus',
            'Attendance Status',
            'Attendance status: Expected, Present, Absent, Excused, Partial',
            'nvarchar',
            100,
            0,
            0,
            0,
            'Expected',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '2d9209f8-1afd-4c12-b909-229a7f0a9571' OR (EntityID = '28992C32-D738-4E7C-97CA-5F0489E89D56' AND Name = 'JoinedAt')) BEGIN
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
            '2d9209f8-1afd-4c12-b909-229a7f0a9571',
            '28992C32-D738-4E7C-97CA-5F0489E89D56', -- Entity: Attendances
            100005,
            'JoinedAt',
            'Joined At',
            'Timestamp when the attendee joined the meeting',
            'datetimeoffset',
            10,
            34,
            7,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c4554ee3-deda-468a-bb9d-5d479a33757a' OR (EntityID = '28992C32-D738-4E7C-97CA-5F0489E89D56' AND Name = 'LeftAt')) BEGIN
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
            'c4554ee3-deda-468a-bb9d-5d479a33757a',
            '28992C32-D738-4E7C-97CA-5F0489E89D56', -- Entity: Attendances
            100006,
            'LeftAt',
            'Left At',
            'Timestamp when the attendee left the meeting',
            'datetimeoffset',
            10,
            34,
            7,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1617dfed-ecfe-4e67-802a-40789bebf99c' OR (EntityID = '28992C32-D738-4E7C-97CA-5F0489E89D56' AND Name = 'Notes')) BEGIN
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
            '1617dfed-ecfe-4e67-802a-40789bebf99c',
            '28992C32-D738-4E7C-97CA-5F0489E89D56', -- Entity: Attendances
            100007,
            'Notes',
            'Notes',
            'Additional notes about attendance',
            'nvarchar',
            1000,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '35af10fa-3a11-4c3b-b9d0-175b4eabb12b' OR (EntityID = '28992C32-D738-4E7C-97CA-5F0489E89D56' AND Name = '__mj_CreatedAt')) BEGIN
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
            '35af10fa-3a11-4c3b-b9d0-175b4eabb12b',
            '28992C32-D738-4E7C-97CA-5F0489E89D56', -- Entity: Attendances
            100008,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '9622c490-f0bf-4e30-81d1-52f7111f12a6' OR (EntityID = '28992C32-D738-4E7C-97CA-5F0489E89D56' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '9622c490-f0bf-4e30-81d1-52f7111f12a6',
            '28992C32-D738-4E7C-97CA-5F0489E89D56', -- Entity: Attendances
            100009,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '5e9adf0b-38a6-4545-a2f4-4c0f7f73f2c4' OR (EntityID = '29248F34-2837-EF11-86D4-6045BDEE16E6' AND Name = 'URL')) BEGIN
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
            '5e9adf0b-38a6-4545-a2f4-4c0f7f73f2c4',
            '29248F34-2837-EF11-86D4-6045BDEE16E6', -- Entity: MJ: Files
            100026,
            'URL',
            'URL',
            'Full URL to the file when hosted at an external location. Used with the ExternalURL storage provider; may also serve as the publicly-accessible link for files stored in cloud providers that expose a direct URL.',
            'nvarchar',
            4096,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '695c5e8e-fe54-475d-8cba-53e2240fadfe' OR (EntityID = '29248F34-2837-EF11-86D4-6045BDEE16E6' AND Name = 'ExternalID')) BEGIN
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
            '695c5e8e-fe54-475d-8cba-53e2240fadfe',
            '29248F34-2837-EF11-86D4-6045BDEE16E6', -- Entity: MJ: Files
            100027,
            'ExternalID',
            'External ID',
            'Provider-specific identifier for the file on the external system (e.g. a document ID in a third-party DMS). Distinct from ProviderKey which holds the storage path/key within MJ-managed storage.',
            'nvarchar',
            1000,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '21fefd31-fb2f-4566-b3a3-bc6e04c7757f' OR (EntityID = '29248F34-2837-EF11-86D4-6045BDEE16E6' AND Name = 'FileSize')) BEGIN
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
            '21fefd31-fb2f-4566-b3a3-bc6e04c7757f',
            '29248F34-2837-EF11-86D4-6045BDEE16E6', -- Entity: MJ: Files
            100028,
            'FileSize',
            'File Size',
            'Size of the file in bytes. Populated during upload for cloud-stored files; may be NULL for externally-hosted files where the size is not known.',
            'bigint',
            8,
            19,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'ef220c25-78f5-493c-9ab1-aada6f432d67' OR (EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7' AND Name = 'ID')) BEGIN
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
            'ef220c25-78f5-493c-9ab1-aada6f432d67',
            '26E04065-1F39-4AB6-913E-6B87481DEFA7', -- Entity: Artifacts
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '97fab244-8b45-4704-903a-5911d79695c5' OR (EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7' AND Name = 'CommitteeID')) BEGIN
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
            '97fab244-8b45-4704-903a-5911d79695c5',
            '26E04065-1F39-4AB6-913E-6B87481DEFA7', -- Entity: Artifacts
            100002,
            'CommitteeID',
            'Committee ID',
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
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'aada9854-71cd-465b-bec8-080557e0139b' OR (EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7' AND Name = 'MeetingID')) BEGIN
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
            'aada9854-71cd-465b-bec8-080557e0139b',
            '26E04065-1F39-4AB6-913E-6B87481DEFA7', -- Entity: Artifacts
            100003,
            'MeetingID',
            'Meeting ID',
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
            '473622EE-DAF0-4A10-8289-F9C14B937A44',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '65ea63af-6352-4c9e-9c22-3628a240fd45' OR (EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7' AND Name = 'AgendaItemID')) BEGIN
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
            '65ea63af-6352-4c9e-9c22-3628a240fd45',
            '26E04065-1F39-4AB6-913E-6B87481DEFA7', -- Entity: Artifacts
            100004,
            'AgendaItemID',
            'Agenda Item ID',
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
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '66d33a0b-20c9-4b50-8f44-165d75b0a050' OR (EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7' AND Name = 'ActionItemID')) BEGIN
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
            '66d33a0b-20c9-4b50-8f44-165d75b0a050',
            '26E04065-1F39-4AB6-913E-6B87481DEFA7', -- Entity: Artifacts
            100005,
            'ActionItemID',
            'Action Item ID',
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
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '120305fc-992e-4435-b5dc-1c712ea7bf4b' OR (EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7' AND Name = 'Title')) BEGIN
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
            '120305fc-992e-4435-b5dc-1c712ea7bf4b',
            '26E04065-1F39-4AB6-913E-6B87481DEFA7', -- Entity: Artifacts
            100006,
            'Title',
            'Title',
            'Display title for the artifact',
            'nvarchar',
            510,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '74e10fef-1c6a-43a8-98c7-ce30899becf9' OR (EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7' AND Name = 'Description')) BEGIN
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
            '74e10fef-1c6a-43a8-98c7-ce30899becf9',
            '26E04065-1F39-4AB6-913E-6B87481DEFA7', -- Entity: Artifacts
            100007,
            'Description',
            'Description',
            'Description of the artifact contents',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'ee7e6b0e-6ec6-44df-b609-9828f65f0201' OR (EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7' AND Name = 'ArtifactTypeID')) BEGIN
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
            'ee7e6b0e-6ec6-44df-b609-9828f65f0201',
            '26E04065-1F39-4AB6-913E-6B87481DEFA7', -- Entity: Artifacts
            100008,
            'ArtifactTypeID',
            'Artifact Type ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '273d17c7-d240-4bdd-84ee-3f733f6a6f3c' OR (EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7' AND Name = 'Provider')) BEGIN
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
            '273d17c7-d240-4bdd-84ee-3f733f6a6f3c',
            '26E04065-1F39-4AB6-913E-6B87481DEFA7', -- Entity: Artifacts
            100009,
            'Provider',
            'Provider',
            'Storage provider: GoogleDrive, SharePoint, Box, OneDrive, Dropbox, URL',
            'nvarchar',
            100,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '98b83228-b52f-498f-9eb9-40b1255f7f91' OR (EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7' AND Name = 'ExternalID')) BEGIN
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
            '98b83228-b52f-498f-9eb9-40b1255f7f91',
            '26E04065-1F39-4AB6-913E-6B87481DEFA7', -- Entity: Artifacts
            100010,
            'ExternalID',
            'External ID',
            'Provider-specific document or file ID',
            'nvarchar',
            1000,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '45cc3cad-6e8f-4b63-9815-42fe410510a4' OR (EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7' AND Name = 'URL')) BEGIN
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
            '45cc3cad-6e8f-4b63-9815-42fe410510a4',
            '26E04065-1F39-4AB6-913E-6B87481DEFA7', -- Entity: Artifacts
            100011,
            'URL',
            'URL',
            'Direct URL to access the artifact',
            'nvarchar',
            4000,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'f7dbba41-0465-45cc-8525-dab19003ebb8' OR (EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7' AND Name = 'MimeType')) BEGIN
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
            'f7dbba41-0465-45cc-8525-dab19003ebb8',
            '26E04065-1F39-4AB6-913E-6B87481DEFA7', -- Entity: Artifacts
            100012,
            'MimeType',
            'Mime Type',
            'MIME type of the file',
            'nvarchar',
            200,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c7640649-2309-46f2-b423-b1b79d08d9ad' OR (EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7' AND Name = 'FileSize')) BEGIN
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
            'c7640649-2309-46f2-b423-b1b79d08d9ad',
            '26E04065-1F39-4AB6-913E-6B87481DEFA7', -- Entity: Artifacts
            100013,
            'FileSize',
            'File Size',
            'File size in bytes',
            'bigint',
            8,
            19,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'feb37f43-f610-412b-a9c7-e5c8354a1578' OR (EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7' AND Name = 'UploadedByPersonID')) BEGIN
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
            'feb37f43-f610-412b-a9c7-e5c8354a1578',
            '26E04065-1F39-4AB6-913E-6B87481DEFA7', -- Entity: Artifacts
            100014,
            'UploadedByPersonID',
            'Uploaded By Person ID',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'cdc942a7-f224-4142-9e12-fc6841527c25' OR (EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7' AND Name = '__mj_CreatedAt')) BEGIN
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
            'cdc942a7-f224-4142-9e12-fc6841527c25',
            '26E04065-1F39-4AB6-913E-6B87481DEFA7', -- Entity: Artifacts
            100015,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '747630a4-0e64-49d0-966e-1ac4d5061d43' OR (EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '747630a4-0e64-49d0-966e-1ac4d5061d43',
            '26E04065-1F39-4AB6-913E-6B87481DEFA7', -- Entity: Artifacts
            100016,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '3efdf79b-3b02-4da6-a33d-502f5c2702bf' OR (EntityID = '36D14C54-9D93-4A39-A282-6BF7B997B70E' AND Name = 'ID')) BEGIN
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
            '3efdf79b-3b02-4da6-a33d-502f5c2702bf',
            '36D14C54-9D93-4A39-A282-6BF7B997B70E', -- Entity: Motions
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'd46f61f7-265c-4687-bae1-7d3a2d1f5c2f' OR (EntityID = '36D14C54-9D93-4A39-A282-6BF7B997B70E' AND Name = 'MeetingID')) BEGIN
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
            'd46f61f7-265c-4687-bae1-7d3a2d1f5c2f',
            '36D14C54-9D93-4A39-A282-6BF7B997B70E', -- Entity: Motions
            100002,
            'MeetingID',
            'Meeting ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            '473622EE-DAF0-4A10-8289-F9C14B937A44',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'ce0221a7-9efc-43bc-b2d8-7a6b1c55b849' OR (EntityID = '36D14C54-9D93-4A39-A282-6BF7B997B70E' AND Name = 'AgendaItemID')) BEGIN
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
            'ce0221a7-9efc-43bc-b2d8-7a6b1c55b849',
            '36D14C54-9D93-4A39-A282-6BF7B997B70E', -- Entity: Motions
            100003,
            'AgendaItemID',
            'Agenda Item ID',
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
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '5f2c0387-0976-4c2b-a009-52548eb7f84a' OR (EntityID = '36D14C54-9D93-4A39-A282-6BF7B997B70E' AND Name = 'Sequence')) BEGIN
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
            '5f2c0387-0976-4c2b-a009-52548eb7f84a',
            '36D14C54-9D93-4A39-A282-6BF7B997B70E', -- Entity: Motions
            100004,
            'Sequence',
            'Sequence',
            'Display order when multiple motions exist for the same agenda item',
            'int',
            4,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1f8ec6d8-ac5b-4407-be83-58ee1786b1ce' OR (EntityID = '36D14C54-9D93-4A39-A282-6BF7B997B70E' AND Name = 'Title')) BEGIN
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
            '1f8ec6d8-ac5b-4407-be83-58ee1786b1ce',
            '36D14C54-9D93-4A39-A282-6BF7B997B70E', -- Entity: Motions
            100005,
            'Title',
            'Title',
            'Title of the motion',
            'nvarchar',
            510,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'f70eff1d-6308-4021-b85c-172d4b2f53b6' OR (EntityID = '36D14C54-9D93-4A39-A282-6BF7B997B70E' AND Name = 'Description')) BEGIN
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
            'f70eff1d-6308-4021-b85c-172d4b2f53b6',
            '36D14C54-9D93-4A39-A282-6BF7B997B70E', -- Entity: Motions
            100006,
            'Description',
            'Description',
            'Full text or description of the motion',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c98ebc65-314a-4b79-82c4-4c9281ccc1e0' OR (EntityID = '36D14C54-9D93-4A39-A282-6BF7B997B70E' AND Name = 'MovedByMembershipID')) BEGIN
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
            'c98ebc65-314a-4b79-82c4-4c9281ccc1e0',
            '36D14C54-9D93-4A39-A282-6BF7B997B70E', -- Entity: Motions
            100007,
            'MovedByMembershipID',
            'Moved By Membership ID',
            'The committee member who made the motion',
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            '35AACFD0-C02B-4D1B-AD41-8C081D08650C',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '3d58199e-dc98-48a0-a1ea-fdd4defa5534' OR (EntityID = '36D14C54-9D93-4A39-A282-6BF7B997B70E' AND Name = 'SecondedByMembershipID')) BEGIN
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
            '3d58199e-dc98-48a0-a1ea-fdd4defa5534',
            '36D14C54-9D93-4A39-A282-6BF7B997B70E', -- Entity: Motions
            100008,
            'SecondedByMembershipID',
            'Seconded By Membership ID',
            'The committee member who seconded the motion',
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            '35AACFD0-C02B-4D1B-AD41-8C081D08650C',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '3f71b06a-8912-4201-9124-3e7fac45574d' OR (EntityID = '36D14C54-9D93-4A39-A282-6BF7B997B70E' AND Name = 'Result')) BEGIN
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
            '3f71b06a-8912-4201-9124-3e7fac45574d',
            '36D14C54-9D93-4A39-A282-6BF7B997B70E', -- Entity: Motions
            100009,
            'Result',
            'Result',
            'Outcome of the vote: Pending, Passed, Failed, Tabled, Withdrawn',
            'nvarchar',
            100,
            0,
            0,
            0,
            'Pending',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'a46eed10-5ce2-422d-8324-ec36ddf88f6d' OR (EntityID = '36D14C54-9D93-4A39-A282-6BF7B997B70E' AND Name = 'ResultSummary')) BEGIN
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
            'a46eed10-5ce2-422d-8324-ec36ddf88f6d',
            '36D14C54-9D93-4A39-A282-6BF7B997B70E', -- Entity: Motions
            100010,
            'ResultSummary',
            'Result Summary',
            'Human-readable vote tally, e.g. 7-2-1 or Passed unanimously',
            'nvarchar',
            510,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '29d3a37c-d17c-407e-9d92-e5e2fa2e9701' OR (EntityID = '36D14C54-9D93-4A39-A282-6BF7B997B70E' AND Name = 'YesCount')) BEGIN
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
            '29d3a37c-d17c-407e-9d92-e5e2fa2e9701',
            '36D14C54-9D93-4A39-A282-6BF7B997B70E', -- Entity: Motions
            100011,
            'YesCount',
            'Yes Count',
            'Number of Yes votes',
            'int',
            4,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '46cfe2c7-44a8-43ea-9d2f-36d0c480465f' OR (EntityID = '36D14C54-9D93-4A39-A282-6BF7B997B70E' AND Name = 'NoCount')) BEGIN
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
            '46cfe2c7-44a8-43ea-9d2f-36d0c480465f',
            '36D14C54-9D93-4A39-A282-6BF7B997B70E', -- Entity: Motions
            100012,
            'NoCount',
            'No Count',
            'Number of No votes',
            'int',
            4,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c9329fa1-d6be-4852-bd67-de50c2e44481' OR (EntityID = '36D14C54-9D93-4A39-A282-6BF7B997B70E' AND Name = 'AbstainCount')) BEGIN
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
            'c9329fa1-d6be-4852-bd67-de50c2e44481',
            '36D14C54-9D93-4A39-A282-6BF7B997B70E', -- Entity: Motions
            100013,
            'AbstainCount',
            'Abstain Count',
            'Number of Abstain votes',
            'int',
            4,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'da69e947-6af8-4026-ab71-419d43d4a649' OR (EntityID = '36D14C54-9D93-4A39-A282-6BF7B997B70E' AND Name = 'Notes')) BEGIN
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
            'da69e947-6af8-4026-ab71-419d43d4a649',
            '36D14C54-9D93-4A39-A282-6BF7B997B70E', -- Entity: Motions
            100014,
            'Notes',
            'Notes',
            'Additional notes about the motion or vote',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '8bcf5c41-b87b-4bb9-be56-e602b5f63aa0' OR (EntityID = '36D14C54-9D93-4A39-A282-6BF7B997B70E' AND Name = '__mj_CreatedAt')) BEGIN
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
            '8bcf5c41-b87b-4bb9-be56-e602b5f63aa0',
            '36D14C54-9D93-4A39-A282-6BF7B997B70E', -- Entity: Motions
            100015,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'ece56826-2844-4c49-8edb-3fc9eb48282d' OR (EntityID = '36D14C54-9D93-4A39-A282-6BF7B997B70E' AND Name = '__mj_UpdatedAt')) BEGIN
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
            'ece56826-2844-4c49-8edb-3fc9eb48282d',
            '36D14C54-9D93-4A39-A282-6BF7B997B70E', -- Entity: Motions
            100016,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '0d0e6c67-0ef7-4e53-8375-5db61e5f5545' OR (EntityID = 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1' AND Name = 'ID')) BEGIN
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
            '0d0e6c67-0ef7-4e53-8375-5db61e5f5545',
            'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', -- Entity: Comments
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1f907dbb-8d97-4e97-b16b-694f501abd02' OR (EntityID = 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1' AND Name = 'CommitteeID')) BEGIN
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
            '1f907dbb-8d97-4e97-b16b-694f501abd02',
            'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', -- Entity: Comments
            100002,
            'CommitteeID',
            'Committee ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '9557fd79-3868-4f6a-81c8-17b5f2786a28' OR (EntityID = 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1' AND Name = 'MeetingID')) BEGIN
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
            '9557fd79-3868-4f6a-81c8-17b5f2786a28',
            'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', -- Entity: Comments
            100003,
            'MeetingID',
            'Meeting ID',
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
            '473622EE-DAF0-4A10-8289-F9C14B937A44',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '920e461f-22a0-4662-b20f-9af5960cc96a' OR (EntityID = 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1' AND Name = 'AgendaItemID')) BEGIN
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
            '920e461f-22a0-4662-b20f-9af5960cc96a',
            'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', -- Entity: Comments
            100004,
            'AgendaItemID',
            'Agenda Item ID',
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
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'f1b7dfc9-fef3-4a1a-a1e3-7d3f07428dbf' OR (EntityID = 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1' AND Name = 'ActionItemID')) BEGIN
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
            'f1b7dfc9-fef3-4a1a-a1e3-7d3f07428dbf',
            'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', -- Entity: Comments
            100005,
            'ActionItemID',
            'Action Item ID',
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
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '04e057ae-6730-492e-9314-bfd02b8cfd78' OR (EntityID = 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1' AND Name = 'ArtifactID')) BEGIN
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
            '04e057ae-6730-492e-9314-bfd02b8cfd78',
            'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', -- Entity: Comments
            100006,
            'ArtifactID',
            'Artifact ID',
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
            '26E04065-1F39-4AB6-913E-6B87481DEFA7',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '299b31b2-c718-45fb-b77b-912b0549660c' OR (EntityID = 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1' AND Name = 'ParentCommentID')) BEGIN
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
            '299b31b2-c718-45fb-b77b-912b0549660c',
            'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', -- Entity: Comments
            100007,
            'ParentCommentID',
            'Parent Comment ID',
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
            'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '4961b896-9389-47b7-9488-66367098d7cc' OR (EntityID = 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1' AND Name = 'PersonID')) BEGIN
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
            '4961b896-9389-47b7-9488-66367098d7cc',
            'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', -- Entity: Comments
            100008,
            'PersonID',
            'Person ID',
            NULL,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c805bbf8-10a6-4ebc-a3e4-94f1bf820436' OR (EntityID = 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1' AND Name = 'CommentText')) BEGIN
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
            'c805bbf8-10a6-4ebc-a3e4-94f1bf820436',
            'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', -- Entity: Comments
            100009,
            'CommentText',
            'Comment Text',
            NULL,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '613aaea7-e4d7-460e-8c6f-2278655bc663' OR (EntityID = 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1' AND Name = 'MentionedPersonIDs')) BEGIN
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
            '613aaea7-e4d7-460e-8c6f-2278655bc663',
            'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', -- Entity: Comments
            100010,
            'MentionedPersonIDs',
            'Mentioned Person I Ds',
            NULL,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'ee9cc2b2-1d6e-4aca-952f-83c13d3f718b' OR (EntityID = 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1' AND Name = 'IsResolved')) BEGIN
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
            'ee9cc2b2-1d6e-4aca-952f-83c13d3f718b',
            'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', -- Entity: Comments
            100011,
            'IsResolved',
            'Is Resolved',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '9b0cacff-921f-48c7-b27a-778ee094008d' OR (EntityID = 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1' AND Name = '__mj_CreatedAt')) BEGIN
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
            '9b0cacff-921f-48c7-b27a-778ee094008d',
            'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', -- Entity: Comments
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '3d4535da-392e-4b21-a86e-5e0e6855d12f' OR (EntityID = 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '3d4535da-392e-4b21-a86e-5e0e6855d12f',
            'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', -- Entity: Comments
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

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'a4946c0c-c17d-4940-bcab-b9f620b6b009' OR (EntityID = '58792440-2D28-46CF-BFB3-79A214063E37' AND Name = 'ID')) BEGIN
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
            'a4946c0c-c17d-4940-bcab-b9f620b6b009',
            '58792440-2D28-46CF-BFB3-79A214063E37', -- Entity: Minutes
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '6f72c51b-7196-4e22-a9ee-b43f93b2f045' OR (EntityID = '58792440-2D28-46CF-BFB3-79A214063E37' AND Name = 'ArtifactID')) BEGIN
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
            '6f72c51b-7196-4e22-a9ee-b43f93b2f045',
            '58792440-2D28-46CF-BFB3-79A214063E37', -- Entity: Minutes
            100002,
            'ArtifactID',
            'Artifact ID',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'db7533c1-7236-4e59-a39e-a1ca6635274a' OR (EntityID = '58792440-2D28-46CF-BFB3-79A214063E37' AND Name = 'ApprovalStatus')) BEGIN
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
            'db7533c1-7236-4e59-a39e-a1ca6635274a',
            '58792440-2D28-46CF-BFB3-79A214063E37', -- Entity: Minutes
            100003,
            'ApprovalStatus',
            'Approval Status',
            'Current approval status: Draft, PendingApproval, Approved, Rejected',
            'nvarchar',
            100,
            0,
            0,
            0,
            'Draft',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '0716669e-9229-4416-a819-622ca89e4dc7' OR (EntityID = '58792440-2D28-46CF-BFB3-79A214063E37' AND Name = 'ApprovedAt')) BEGIN
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
            '0716669e-9229-4416-a819-622ca89e4dc7',
            '58792440-2D28-46CF-BFB3-79A214063E37', -- Entity: Minutes
            100004,
            'ApprovedAt',
            'Approved At',
            'Timestamp when the minutes were approved',
            'datetimeoffset',
            10,
            34,
            7,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '65f2a2a2-a88c-4a0b-9d7d-88c76be7b6c4' OR (EntityID = '58792440-2D28-46CF-BFB3-79A214063E37' AND Name = 'ApprovedByMeetingID')) BEGIN
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
            '65f2a2a2-a88c-4a0b-9d7d-88c76be7b6c4',
            '58792440-2D28-46CF-BFB3-79A214063E37', -- Entity: Minutes
            100005,
            'ApprovedByMeetingID',
            'Approved By Meeting ID',
            'Reference to the meeting at which these minutes were approved (typically the next meeting)',
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            '473622EE-DAF0-4A10-8289-F9C14B937A44',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '92a5241e-895a-468c-9c2d-8ef528b89918' OR (EntityID = '58792440-2D28-46CF-BFB3-79A214063E37' AND Name = 'Notes')) BEGIN
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
            '92a5241e-895a-468c-9c2d-8ef528b89918',
            '58792440-2D28-46CF-BFB3-79A214063E37', -- Entity: Minutes
            100006,
            'Notes',
            'Notes',
            'Additional notes about the minutes',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '56d1f97d-fe18-4fc6-9443-750c35fab1eb' OR (EntityID = '58792440-2D28-46CF-BFB3-79A214063E37' AND Name = 'MeetingID')) BEGIN
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
            '56d1f97d-fe18-4fc6-9443-750c35fab1eb',
            '58792440-2D28-46CF-BFB3-79A214063E37', -- Entity: Minutes
            100007,
            'MeetingID',
            'Meeting ID',
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
            '473622EE-DAF0-4A10-8289-F9C14B937A44',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'ce787060-da25-4b53-aa55-50de0ff681a1' OR (EntityID = '58792440-2D28-46CF-BFB3-79A214063E37' AND Name = 'Content')) BEGIN
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
            'ce787060-da25-4b53-aa55-50de0ff681a1',
            '58792440-2D28-46CF-BFB3-79A214063E37', -- Entity: Minutes
            100008,
            'Content',
            'Content',
            NULL,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '0220646f-86f1-4731-8a5c-c8af5e371daa' OR (EntityID = '58792440-2D28-46CF-BFB3-79A214063E37' AND Name = '__mj_CreatedAt')) BEGIN
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
            '0220646f-86f1-4731-8a5c-c8af5e371daa',
            '58792440-2D28-46CF-BFB3-79A214063E37', -- Entity: Minutes
            100009,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '3d40f22b-2aff-4891-bbc6-93eda468dbea' OR (EntityID = '58792440-2D28-46CF-BFB3-79A214063E37' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '3d40f22b-2aff-4891-bbc6-93eda468dbea',
            '58792440-2D28-46CF-BFB3-79A214063E37', -- Entity: Minutes
            100010,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '93c826ba-815d-45f6-b0c5-2a460e66301a' OR (EntityID = '35AACFD0-C02B-4D1B-AD41-8C081D08650C' AND Name = 'ID')) BEGIN
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
            '93c826ba-815d-45f6-b0c5-2a460e66301a',
            '35AACFD0-C02B-4D1B-AD41-8C081D08650C', -- Entity: Memberships
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '53e824fa-c4a8-4106-9a41-79124b0e7096' OR (EntityID = '35AACFD0-C02B-4D1B-AD41-8C081D08650C' AND Name = 'PersonID')) BEGIN
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
            '53e824fa-c4a8-4106-9a41-79124b0e7096',
            '35AACFD0-C02B-4D1B-AD41-8C081D08650C', -- Entity: Memberships
            100003,
            'PersonID',
            'Person ID',
            NULL,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '8b43e54c-fc73-4666-8ee4-207d77941f74' OR (EntityID = '35AACFD0-C02B-4D1B-AD41-8C081D08650C' AND Name = 'RoleID')) BEGIN
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
            '8b43e54c-fc73-4666-8ee4-207d77941f74',
            '35AACFD0-C02B-4D1B-AD41-8C081D08650C', -- Entity: Memberships
            100004,
            'RoleID',
            'Role ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            'E170A834-9278-49DB-9F73-08945C0E83DF',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1fa2b07a-257a-4665-b041-6d92c1aec0bc' OR (EntityID = '35AACFD0-C02B-4D1B-AD41-8C081D08650C' AND Name = 'TermID')) BEGIN
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
            '1fa2b07a-257a-4665-b041-6d92c1aec0bc',
            '35AACFD0-C02B-4D1B-AD41-8C081D08650C', -- Entity: Memberships
            100005,
            'TermID',
            'Term ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '89dcfb9a-db1e-4e4b-a3a7-786b21b31b49' OR (EntityID = '35AACFD0-C02B-4D1B-AD41-8C081D08650C' AND Name = 'StartDate')) BEGIN
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
            '89dcfb9a-db1e-4e4b-a3a7-786b21b31b49',
            '35AACFD0-C02B-4D1B-AD41-8C081D08650C', -- Entity: Memberships
            100006,
            'StartDate',
            'Start Date',
            'Date the membership started',
            'date',
            3,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'b836e91c-8b59-4c34-81b7-e7e57b7a57ef' OR (EntityID = '35AACFD0-C02B-4D1B-AD41-8C081D08650C' AND Name = 'EndDate')) BEGIN
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
            'b836e91c-8b59-4c34-81b7-e7e57b7a57ef',
            '35AACFD0-C02B-4D1B-AD41-8C081D08650C', -- Entity: Memberships
            100007,
            'EndDate',
            'End Date',
            'Date the membership ended, if applicable',
            'date',
            3,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'ec0ca348-6190-4924-8715-87d0bbfdd6be' OR (EntityID = '35AACFD0-C02B-4D1B-AD41-8C081D08650C' AND Name = 'Status')) BEGIN
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
            'ec0ca348-6190-4924-8715-87d0bbfdd6be',
            '35AACFD0-C02B-4D1B-AD41-8C081D08650C', -- Entity: Memberships
            100008,
            'Status',
            'Status',
            'Current status: Active, Pending, Ended, or Suspended',
            'nvarchar',
            100,
            0,
            0,
            0,
            'Active',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'bcbc23b7-c308-4a99-9711-19c5527672fa' OR (EntityID = '35AACFD0-C02B-4D1B-AD41-8C081D08650C' AND Name = 'EndReason')) BEGIN
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
            'bcbc23b7-c308-4a99-9711-19c5527672fa',
            '35AACFD0-C02B-4D1B-AD41-8C081D08650C', -- Entity: Memberships
            100009,
            'EndReason',
            'End Reason',
            'Reason the membership ended: Term ended, Resigned, Removed, etc.',
            'nvarchar',
            200,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '615d4b07-2406-4a5f-af00-5819484d66d2' OR (EntityID = '35AACFD0-C02B-4D1B-AD41-8C081D08650C' AND Name = 'Notes')) BEGIN
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
            '615d4b07-2406-4a5f-af00-5819484d66d2',
            '35AACFD0-C02B-4D1B-AD41-8C081D08650C', -- Entity: Memberships
            100010,
            'Notes',
            'Notes',
            'Additional notes about this membership',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'e000c682-de5a-4a73-8a8d-358510b0d6e0' OR (EntityID = '35AACFD0-C02B-4D1B-AD41-8C081D08650C' AND Name = '__mj_CreatedAt')) BEGIN
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
            'e000c682-de5a-4a73-8a8d-358510b0d6e0',
            '35AACFD0-C02B-4D1B-AD41-8C081D08650C', -- Entity: Memberships
            100011,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1b10d357-8381-4613-8b89-840316d638c2' OR (EntityID = '35AACFD0-C02B-4D1B-AD41-8C081D08650C' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '1b10d357-8381-4613-8b89-840316d638c2',
            '35AACFD0-C02B-4D1B-AD41-8C081D08650C', -- Entity: Memberships
            100012,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'dc921f3f-93ca-4ec3-a3cb-0da3f990e91c' OR (EntityID = '216DC5A7-41C9-4165-9E5A-93E514B9FD4B' AND Name = 'ID')) BEGIN
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
            'dc921f3f-93ca-4ec3-a3cb-0da3f990e91c',
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', -- Entity: Action Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c42155fc-0f1b-4a8d-b239-3bbc4de5b4ad' OR (EntityID = '216DC5A7-41C9-4165-9E5A-93E514B9FD4B' AND Name = 'CommitteeID')) BEGIN
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
            'c42155fc-0f1b-4a8d-b239-3bbc4de5b4ad',
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', -- Entity: Action Items
            100002,
            'CommitteeID',
            'Committee ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'd30e95a2-5265-403e-aff0-73d41e9dda05' OR (EntityID = '216DC5A7-41C9-4165-9E5A-93E514B9FD4B' AND Name = 'MeetingID')) BEGIN
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
            'd30e95a2-5265-403e-aff0-73d41e9dda05',
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', -- Entity: Action Items
            100003,
            'MeetingID',
            'Meeting ID',
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
            '473622EE-DAF0-4A10-8289-F9C14B937A44',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '6922d6fe-9689-41a0-bb27-6cf3d8098c93' OR (EntityID = '216DC5A7-41C9-4165-9E5A-93E514B9FD4B' AND Name = 'AgendaItemID')) BEGIN
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
            '6922d6fe-9689-41a0-bb27-6cf3d8098c93',
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', -- Entity: Action Items
            100004,
            'AgendaItemID',
            'Agenda Item ID',
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
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '27944e8c-bb63-4791-94f1-d0adaf2f18e3' OR (EntityID = '216DC5A7-41C9-4165-9E5A-93E514B9FD4B' AND Name = 'Title')) BEGIN
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
            '27944e8c-bb63-4791-94f1-d0adaf2f18e3',
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', -- Entity: Action Items
            100005,
            'Title',
            'Title',
            'Title of the action item',
            'nvarchar',
            510,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '9d0f82a0-3a4b-4def-966c-0e3aaff1c3f3' OR (EntityID = '216DC5A7-41C9-4165-9E5A-93E514B9FD4B' AND Name = 'Description')) BEGIN
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
            '9d0f82a0-3a4b-4def-966c-0e3aaff1c3f3',
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', -- Entity: Action Items
            100006,
            'Description',
            'Description',
            'Detailed description of what needs to be done',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '62a51489-b1c1-42b5-ba7d-e28319fa087f' OR (EntityID = '216DC5A7-41C9-4165-9E5A-93E514B9FD4B' AND Name = 'AssignedToPersonID')) BEGIN
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
            '62a51489-b1c1-42b5-ba7d-e28319fa087f',
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', -- Entity: Action Items
            100007,
            'AssignedToPersonID',
            'Assigned To Person ID',
            NULL,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '61264e2f-fdf4-4e47-b22c-283b5a712159' OR (EntityID = '216DC5A7-41C9-4165-9E5A-93E514B9FD4B' AND Name = 'AssignedByPersonID')) BEGIN
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
            '61264e2f-fdf4-4e47-b22c-283b5a712159',
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', -- Entity: Action Items
            100008,
            'AssignedByPersonID',
            'Assigned By Person ID',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'f32c2b8d-9351-4968-aa15-2cb73a5fcf96' OR (EntityID = '216DC5A7-41C9-4165-9E5A-93E514B9FD4B' AND Name = 'DueDate')) BEGIN
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
            'f32c2b8d-9351-4968-aa15-2cb73a5fcf96',
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', -- Entity: Action Items
            100009,
            'DueDate',
            'Due Date',
            'Due date for completion',
            'date',
            3,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'f34a168b-d288-44fe-8bba-f26d4b52a03b' OR (EntityID = '216DC5A7-41C9-4165-9E5A-93E514B9FD4B' AND Name = 'Priority')) BEGIN
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
            'f34a168b-d288-44fe-8bba-f26d4b52a03b',
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', -- Entity: Action Items
            100010,
            'Priority',
            'Priority',
            'Priority level: Low, Medium, High, Critical',
            'nvarchar',
            40,
            0,
            0,
            0,
            'Medium',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'bfbe6a51-5ae0-4ee9-adec-443f75706247' OR (EntityID = '216DC5A7-41C9-4165-9E5A-93E514B9FD4B' AND Name = 'Status')) BEGIN
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
            'bfbe6a51-5ae0-4ee9-adec-443f75706247',
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', -- Entity: Action Items
            100011,
            'Status',
            'Status',
            'Current status: Open, InProgress, Blocked, Completed, Cancelled',
            'nvarchar',
            100,
            0,
            0,
            0,
            'Open',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'fdd86e8a-c888-45ca-9f22-9025ef811390' OR (EntityID = '216DC5A7-41C9-4165-9E5A-93E514B9FD4B' AND Name = 'CompletedAt')) BEGIN
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
            'fdd86e8a-c888-45ca-9f22-9025ef811390',
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', -- Entity: Action Items
            100012,
            'CompletedAt',
            'Completed At',
            'Timestamp when the action item was completed',
            'datetimeoffset',
            10,
            34,
            7,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'a57031e7-8ab2-48d0-98a3-a376260e6dc6' OR (EntityID = '216DC5A7-41C9-4165-9E5A-93E514B9FD4B' AND Name = 'CompletionNotes')) BEGIN
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
            'a57031e7-8ab2-48d0-98a3-a376260e6dc6',
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', -- Entity: Action Items
            100013,
            'CompletionNotes',
            'Completion Notes',
            'Notes about how the item was completed',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '51e3f208-0975-4401-9101-bc080cd8505d' OR (EntityID = '216DC5A7-41C9-4165-9E5A-93E514B9FD4B' AND Name = '__mj_CreatedAt')) BEGIN
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
            '51e3f208-0975-4401-9101-bc080cd8505d',
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', -- Entity: Action Items
            100014,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'b3f600a5-1efc-4e01-a966-0f1d25dddd99' OR (EntityID = '216DC5A7-41C9-4165-9E5A-93E514B9FD4B' AND Name = '__mj_UpdatedAt')) BEGIN
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
            'b3f600a5-1efc-4e01-a966-0f1d25dddd99',
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', -- Entity: Action Items
            100015,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'd56b65c7-e8e3-463e-9abc-661bc0406553' OR (EntityID = '1B9BF218-367F-452E-9DD9-BDE6F306F742' AND Name = 'ID')) BEGIN
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
            'd56b65c7-e8e3-463e-9abc-661bc0406553',
            '1B9BF218-367F-452E-9DD9-BDE6F306F742', -- Entity: Types
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '58616d5a-a379-408f-84fc-3cb9d14ceb33' OR (EntityID = '1B9BF218-367F-452E-9DD9-BDE6F306F742' AND Name = 'Name')) BEGIN
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
            '58616d5a-a379-408f-84fc-3cb9d14ceb33',
            '1B9BF218-367F-452E-9DD9-BDE6F306F742', -- Entity: Types
            100002,
            'Name',
            'Name',
            'Display name for the committee type',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '914644fa-62ca-4763-9e0f-2e3cfc9ac4c2' OR (EntityID = '1B9BF218-367F-452E-9DD9-BDE6F306F742' AND Name = 'Description')) BEGIN
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
            '914644fa-62ca-4763-9e0f-2e3cfc9ac4c2',
            '1B9BF218-367F-452E-9DD9-BDE6F306F742', -- Entity: Types
            100003,
            'Description',
            'Description',
            'Detailed description of this committee type',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'def17150-4245-4d7b-9fe3-f1544d9b19c3' OR (EntityID = '1B9BF218-367F-452E-9DD9-BDE6F306F742' AND Name = 'IsStandards')) BEGIN
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
            'def17150-4245-4d7b-9fe3-f1544d9b19c3',
            '1B9BF218-367F-452E-9DD9-BDE6F306F742', -- Entity: Types
            100004,
            'IsStandards',
            'Is Standards',
            'Whether this type is for standards development committees',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'bc1c0e23-80de-48e9-911f-b0b327ae79cc' OR (EntityID = '1B9BF218-367F-452E-9DD9-BDE6F306F742' AND Name = 'DefaultTermMonths')) BEGIN
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
            'bc1c0e23-80de-48e9-911f-b0b327ae79cc',
            '1B9BF218-367F-452E-9DD9-BDE6F306F742', -- Entity: Types
            100005,
            'DefaultTermMonths',
            'Default Term Months',
            'Default term length in months for committees of this type',
            'int',
            4,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '13baabe3-f100-4a0c-b8cf-2e3fe0d19d9c' OR (EntityID = '1B9BF218-367F-452E-9DD9-BDE6F306F742' AND Name = 'IconClass')) BEGIN
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
            '13baabe3-f100-4a0c-b8cf-2e3fe0d19d9c',
            '1B9BF218-367F-452E-9DD9-BDE6F306F742', -- Entity: Types
            100006,
            'IconClass',
            'Icon Class',
            'Font Awesome icon class for UI display',
            'nvarchar',
            200,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'b36ffda1-8635-479b-97bc-b27336c0936b' OR (EntityID = '1B9BF218-367F-452E-9DD9-BDE6F306F742' AND Name = '__mj_CreatedAt')) BEGIN
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
            'b36ffda1-8635-479b-97bc-b27336c0936b',
            '1B9BF218-367F-452E-9DD9-BDE6F306F742', -- Entity: Types
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'f6b4c1ee-b6a0-4d0f-9b9a-97acb7aa6e87' OR (EntityID = '1B9BF218-367F-452E-9DD9-BDE6F306F742' AND Name = '__mj_UpdatedAt')) BEGIN
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
            'f6b4c1ee-b6a0-4d0f-9b9a-97acb7aa6e87',
            '1B9BF218-367F-452E-9DD9-BDE6F306F742', -- Entity: Types
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'cdffd509-b268-4c92-a8ed-5960bf6ae462' OR (EntityID = '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4' AND Name = 'ID')) BEGIN
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
            'cdffd509-b268-4c92-a8ed-5960bf6ae462',
            '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4', -- Entity: Terms
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '6129241c-c879-4369-b1ad-d97f350e2bcb' OR (EntityID = '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4' AND Name = 'CommitteeID')) BEGIN
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
            '6129241c-c879-4369-b1ad-d97f350e2bcb',
            '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4', -- Entity: Terms
            100002,
            'CommitteeID',
            'Committee ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c2c0f6ef-76ba-4c48-83c6-b2062daaeefa' OR (EntityID = '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4' AND Name = 'Name')) BEGIN
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
            'c2c0f6ef-76ba-4c48-83c6-b2062daaeefa',
            '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4', -- Entity: Terms
            100003,
            'Name',
            'Name',
            'Display name for the term, e.g. 2025-2026',
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
            0,
            'Search',
            GETUTCDATE(),
            GETUTCDATE()
         )
      END

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'cbd2405f-9fd7-4495-992e-48b2154de9b7' OR (EntityID = '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4' AND Name = 'StartDate')) BEGIN
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
            'cbd2405f-9fd7-4495-992e-48b2154de9b7',
            '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4', -- Entity: Terms
            100004,
            'StartDate',
            'Start Date',
            'Start date of the term',
            'date',
            3,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'b1992ee9-b079-40f3-be6e-06094da729ed' OR (EntityID = '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4' AND Name = 'EndDate')) BEGIN
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
            'b1992ee9-b079-40f3-be6e-06094da729ed',
            '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4', -- Entity: Terms
            100005,
            'EndDate',
            'End Date',
            'End date of the term',
            'date',
            3,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '41895295-c70a-43b0-9b0a-f4f535495884' OR (EntityID = '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4' AND Name = 'Status')) BEGIN
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
            '41895295-c70a-43b0-9b0a-f4f535495884',
            '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4', -- Entity: Terms
            100006,
            'Status',
            'Status',
            'Current status: Active, Upcoming, or Completed',
            'nvarchar',
            100,
            0,
            0,
            0,
            'Active',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c35ff0cc-859e-4948-ab8b-561f52baa0d0' OR (EntityID = '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4' AND Name = '__mj_CreatedAt')) BEGIN
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
            'c35ff0cc-859e-4948-ab8b-561f52baa0d0',
            '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4', -- Entity: Terms
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '5dc338bf-aa89-4b21-a2ea-06e532e63800' OR (EntityID = '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '5dc338bf-aa89-4b21-a2ea-06e532e63800',
            '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4', -- Entity: Terms
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '23718162-8e18-4639-a205-f5188068045c' OR (EntityID = 'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476' AND Name = 'ID')) BEGIN
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
            '23718162-8e18-4639-a205-f5188068045c',
            'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476', -- Entity: Artifact Types
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'cfc4b714-420b-40f3-816e-959d8c664fd6' OR (EntityID = 'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476' AND Name = 'Name')) BEGIN
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
            'cfc4b714-420b-40f3-816e-959d8c664fd6',
            'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476', -- Entity: Artifact Types
            100002,
            'Name',
            'Name',
            'Display name for the artifact type',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '64b94782-bcee-46b1-9969-d765d3a59d97' OR (EntityID = 'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476' AND Name = 'Description')) BEGIN
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
            '64b94782-bcee-46b1-9969-d765d3a59d97',
            'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476', -- Entity: Artifact Types
            100003,
            'Description',
            'Description',
            'Detailed description of this artifact type',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '7c8227df-5515-4828-b3e5-4195a03d5f0d' OR (EntityID = 'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476' AND Name = 'ExtendedEntityID')) BEGIN
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
            '7c8227df-5515-4828-b3e5-4195a03d5f0d',
            'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476', -- Entity: Artifact Types
            100004,
            'ExtendedEntityID',
            'Extended Entity ID',
            'Optional reference to an MJ Entity that provides additional fields for this artifact type via a 1:1 extension table',
            'uniqueidentifier',
            16,
            0,
            0,
            1,
            NULL,
            0,
            1,
            0,
            'E0238F34-2837-EF11-86D4-6045BDEE16E6',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '9e02e3ce-0b9a-4e1d-94a8-3730cfd0595d' OR (EntityID = 'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476' AND Name = 'IconClass')) BEGIN
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
            '9e02e3ce-0b9a-4e1d-94a8-3730cfd0595d',
            'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476', -- Entity: Artifact Types
            100005,
            'IconClass',
            'Icon Class',
            'Font Awesome icon class for UI display',
            'nvarchar',
            200,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'e6580def-09c4-4154-af96-9e7b9f20291d' OR (EntityID = 'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476' AND Name = '__mj_CreatedAt')) BEGIN
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
            'e6580def-09c4-4154-af96-9e7b9f20291d',
            'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476', -- Entity: Artifact Types
            100006,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'f86ae8d9-fe76-4bec-a735-0de7ae591861' OR (EntityID = 'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476' AND Name = '__mj_UpdatedAt')) BEGIN
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
            'f86ae8d9-fe76-4bec-a735-0de7ae591861',
            'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476', -- Entity: Artifact Types
            100007,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'fb343961-4c8c-44ac-8a34-640512bdbe61' OR (EntityID = '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6' AND Name = 'ID')) BEGIN
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
            'fb343961-4c8c-44ac-8a34-640512bdbe61',
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', -- Entity: Agenda Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'ea8e764b-06de-4e0e-a527-951bfb4c9ba4' OR (EntityID = '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6' AND Name = 'MeetingID')) BEGIN
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
            'ea8e764b-06de-4e0e-a527-951bfb4c9ba4',
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', -- Entity: Agenda Items
            100002,
            'MeetingID',
            'Meeting ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            '473622EE-DAF0-4A10-8289-F9C14B937A44',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '3f562093-4217-473a-b77d-942e1fe392c9' OR (EntityID = '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6' AND Name = 'ParentAgendaItemID')) BEGIN
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
            '3f562093-4217-473a-b77d-942e1fe392c9',
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', -- Entity: Agenda Items
            100003,
            'ParentAgendaItemID',
            'Parent Agenda Item ID',
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
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '69784ca3-cb33-4038-a505-376042fccfad' OR (EntityID = '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6' AND Name = 'Sequence')) BEGIN
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
            '69784ca3-cb33-4038-a505-376042fccfad',
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', -- Entity: Agenda Items
            100004,
            'Sequence',
            'Sequence',
            'Display order within the meeting agenda',
            'int',
            4,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '0c4066a0-0b41-4f9f-a737-d4303ff91004' OR (EntityID = '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6' AND Name = 'Title')) BEGIN
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
            '0c4066a0-0b41-4f9f-a737-d4303ff91004',
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', -- Entity: Agenda Items
            100005,
            'Title',
            'Title',
            'Title of the agenda item',
            'nvarchar',
            510,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1de3087a-d5b1-4828-8a0f-267f2eee8e55' OR (EntityID = '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6' AND Name = 'Description')) BEGIN
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
            '1de3087a-d5b1-4828-8a0f-267f2eee8e55',
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', -- Entity: Agenda Items
            100006,
            'Description',
            'Description',
            'Detailed description of the agenda item',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '75cde5d3-bacc-4874-b8d3-5451bb4a232e' OR (EntityID = '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6' AND Name = 'PresenterPersonID')) BEGIN
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
            '75cde5d3-bacc-4874-b8d3-5451bb4a232e',
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', -- Entity: Agenda Items
            100007,
            'PresenterPersonID',
            'Presenter Person ID',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'f33f1f90-e8d9-4549-93d0-bcc7a015c16b' OR (EntityID = '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6' AND Name = 'DurationMinutes')) BEGIN
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
            'f33f1f90-e8d9-4549-93d0-bcc7a015c16b',
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', -- Entity: Agenda Items
            100008,
            'DurationMinutes',
            'Duration Minutes',
            'Estimated duration in minutes',
            'int',
            4,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '9c9bd457-9924-4532-848c-9d27ab19c316' OR (EntityID = '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6' AND Name = 'ItemType')) BEGIN
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
            '9c9bd457-9924-4532-848c-9d27ab19c316',
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', -- Entity: Agenda Items
            100009,
            'ItemType',
            'Item Type',
            'Type of item: Information, Discussion, Action, Vote, Report, Other',
            'nvarchar',
            100,
            0,
            0,
            0,
            'Discussion',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '18b6ae27-afc9-43f3-aed6-822f56a1b05f' OR (EntityID = '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6' AND Name = 'RelatedDocumentURL')) BEGIN
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
            '18b6ae27-afc9-43f3-aed6-822f56a1b05f',
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', -- Entity: Agenda Items
            100010,
            'RelatedDocumentURL',
            'Related Document URL',
            'URL to related document for this item',
            'nvarchar',
            2000,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '797dcdb2-e973-4d9a-be74-7d5c7f6c7852' OR (EntityID = '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6' AND Name = 'Status')) BEGIN
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
            '797dcdb2-e973-4d9a-be74-7d5c7f6c7852',
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', -- Entity: Agenda Items
            100011,
            'Status',
            'Status',
            'Current status: Pending, Discussed, Tabled, Completed, Skipped',
            'nvarchar',
            100,
            0,
            0,
            0,
            'Pending',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'be00e5ad-d418-436b-86b3-098d89030ca1' OR (EntityID = '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6' AND Name = 'Notes')) BEGIN
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
            'be00e5ad-d418-436b-86b3-098d89030ca1',
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', -- Entity: Agenda Items
            100012,
            'Notes',
            'Notes',
            'Discussion notes and outcomes captured during the meeting',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '7faf6250-1ebc-4907-a3fc-3e5156c70d31' OR (EntityID = '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6' AND Name = '__mj_CreatedAt')) BEGIN
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
            '7faf6250-1ebc-4907-a3fc-3e5156c70d31',
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', -- Entity: Agenda Items
            100013,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '3aba8ea1-f2a2-49c8-aa64-548149c5f3db' OR (EntityID = '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '3aba8ea1-f2a2-49c8-aa64-548149c5f3db',
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', -- Entity: Agenda Items
            100014,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '7a9c51aa-3e9f-49cc-81db-df0bbbb0a57b' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = 'ID')) BEGIN
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
            '7a9c51aa-3e9f-49cc-81db-df0bbbb0a57b',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '225ef45b-1ea5-4f13-ba96-d62419ec40a9' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = 'CommitteeID')) BEGIN
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
            '225ef45b-1ea5-4f13-ba96-d62419ec40a9',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100002,
            'CommitteeID',
            'Committee ID',
            NULL,
            'uniqueidentifier',
            16,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '55775889-9433-4e7d-b227-591b49b2eb54' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = 'Title')) BEGIN
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
            '55775889-9433-4e7d-b227-591b49b2eb54',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100003,
            'Title',
            'Title',
            'Title of the meeting',
            'nvarchar',
            510,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '776024f3-890f-49da-a878-658619732b62' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = 'Description')) BEGIN
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
            '776024f3-890f-49da-a878-658619732b62',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100004,
            'Description',
            'Description',
            'Detailed description or purpose of the meeting',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1f501596-f5de-4b62-b935-dacca3e57238' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = 'StartDateTime')) BEGIN
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
            '1f501596-f5de-4b62-b935-dacca3e57238',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100005,
            'StartDateTime',
            'Start Date Time',
            'Scheduled start date and time with timezone offset',
            'datetimeoffset',
            10,
            34,
            7,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '388cbe3a-ddcb-4b18-b08b-0f574b8c4234' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = 'EndDateTime')) BEGIN
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
            '388cbe3a-ddcb-4b18-b08b-0f574b8c4234',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100006,
            'EndDateTime',
            'End Date Time',
            'Scheduled end date and time with timezone offset',
            'datetimeoffset',
            10,
            34,
            7,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'ba646ed1-f40c-4047-ac84-aac1b77f874f' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = 'TimeZone')) BEGIN
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
            'ba646ed1-f40c-4047-ac84-aac1b77f874f',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100007,
            'TimeZone',
            'Time Zone',
            'IANA timezone identifier for the meeting',
            'nvarchar',
            100,
            0,
            0,
            0,
            'America/New_York',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '6e828b99-dd10-4f30-ad0f-a4a6ad4b25e2' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = 'LocationType')) BEGIN
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
            '6e828b99-dd10-4f30-ad0f-a4a6ad4b25e2',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100008,
            'LocationType',
            'Location Type',
            'Meeting format: Virtual, InPerson, or Hybrid',
            'nvarchar',
            100,
            0,
            0,
            0,
            'Virtual',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'effb32ee-b2c0-4c62-b9b5-e165752408cb' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = 'LocationText')) BEGIN
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
            'effb32ee-b2c0-4c62-b9b5-e165752408cb',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100009,
            'LocationText',
            'Location Text',
            'Physical address or room name for in-person meetings',
            'nvarchar',
            1000,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '938456ae-e71a-4086-9bb4-16edc0a0910c' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = 'VideoProvider')) BEGIN
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
            '938456ae-e71a-4086-9bb4-16edc0a0910c',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100010,
            'VideoProvider',
            'Video Provider',
            'Video conferencing provider: Zoom, Teams, Meet, etc.',
            'nvarchar',
            100,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c0d0d8d3-9fa1-4e40-801b-dfc31577bc13' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = 'VideoMeetingID')) BEGIN
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
            'c0d0d8d3-9fa1-4e40-801b-dfc31577bc13',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100011,
            'VideoMeetingID',
            'Video Meeting ID',
            'External meeting ID from the video provider',
            'nvarchar',
            510,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '614dba3a-c83e-4902-9225-a4f7494baf99' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = 'VideoJoinURL')) BEGIN
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
            '614dba3a-c83e-4902-9225-a4f7494baf99',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100012,
            'VideoJoinURL',
            'Video Join URL',
            'URL to join the video meeting',
            'nvarchar',
            2000,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'b2198fcd-5a71-40f6-91ed-336e43f3ea67' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = 'VideoRecordingURL')) BEGIN
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
            'b2198fcd-5a71-40f6-91ed-336e43f3ea67',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100013,
            'VideoRecordingURL',
            'Video Recording URL',
            'URL to the meeting recording after completion',
            'nvarchar',
            2000,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '9029766a-4f06-4b51-b2a0-51d00877d416' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = 'TranscriptURL')) BEGIN
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
            '9029766a-4f06-4b51-b2a0-51d00877d416',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100014,
            'TranscriptURL',
            'Transcript URL',
            'URL to the meeting transcript',
            'nvarchar',
            2000,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '63363a4e-1607-462e-8348-6907bef1dfc4' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = 'Status')) BEGIN
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
            '63363a4e-1607-462e-8348-6907bef1dfc4',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100015,
            'Status',
            'Status',
            'Current status: Draft, Scheduled, InProgress, Completed, Cancelled, Postponed',
            'nvarchar',
            100,
            0,
            0,
            0,
            'Scheduled',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'e8d38530-5e88-4e3d-8c93-fab42da20654' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = 'CalendarEventID')) BEGIN
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
            'e8d38530-5e88-4e3d-8c93-fab42da20654',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100016,
            'CalendarEventID',
            'Calendar Event ID',
            'External calendar event ID for sync purposes',
            'nvarchar',
            510,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '7b5571c3-69a1-4e82-9092-af08a5485691' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = 'VideoProviderID')) BEGIN
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
            '7b5571c3-69a1-4e82-9092-af08a5485691',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100017,
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
            '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'e923365b-1352-47da-88ec-c21a120a41d7' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = '__mj_CreatedAt')) BEGIN
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
            'e923365b-1352-47da-88ec-c21a120a41d7',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100018,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '44415857-020e-4457-abb8-5c8b4485a7af' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '44415857-020e-4457-abb8-5c8b4485a7af',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100019,
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

/* SQL text to insert entity field value with ID d583704f-5477-456b-b20c-95509c7deb45 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('d583704f-5477-456b-b20c-95509c7deb45', '9C9BD457-9924-4532-848C-9D27AB19C316', 1, 'Action', 'Action', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID febd992e-9b62-49a2-96aa-295ef945ad81 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('febd992e-9b62-49a2-96aa-295ef945ad81', '9C9BD457-9924-4532-848C-9D27AB19C316', 2, 'Discussion', 'Discussion', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID eed072de-46d5-4217-a390-449ba06f0ca9 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('eed072de-46d5-4217-a390-449ba06f0ca9', '9C9BD457-9924-4532-848C-9D27AB19C316', 3, 'Information', 'Information', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID c49eb6ec-99d9-49ca-b96a-84a4ac273cc7 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('c49eb6ec-99d9-49ca-b96a-84a4ac273cc7', '9C9BD457-9924-4532-848C-9D27AB19C316', 4, 'Other', 'Other', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 84f8c28f-ed1e-4812-9b75-62e96b0f6937 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('84f8c28f-ed1e-4812-9b75-62e96b0f6937', '9C9BD457-9924-4532-848C-9D27AB19C316', 5, 'Report', 'Report', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 51974a63-ee29-4f7c-b910-a7ed0e5ed546 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('51974a63-ee29-4f7c-b910-a7ed0e5ed546', '9C9BD457-9924-4532-848C-9D27AB19C316', 6, 'Vote', 'Vote', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID 9C9BD457-9924-4532-848C-9D27AB19C316 */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='9C9BD457-9924-4532-848C-9D27AB19C316'

/* SQL text to insert entity field value with ID 10dbee8e-0048-4cbe-b2f3-fe912c2a07e6 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('10dbee8e-0048-4cbe-b2f3-fe912c2a07e6', '797DCDB2-E973-4D9A-BE74-7D5C7F6C7852', 1, 'Completed', 'Completed', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 24c04d87-2be8-4469-be4d-e6109cd4d1a1 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('24c04d87-2be8-4469-be4d-e6109cd4d1a1', '797DCDB2-E973-4D9A-BE74-7D5C7F6C7852', 2, 'Discussed', 'Discussed', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 85f5a7ca-ac17-449c-85d8-abceb9b984d2 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('85f5a7ca-ac17-449c-85d8-abceb9b984d2', '797DCDB2-E973-4D9A-BE74-7D5C7F6C7852', 3, 'Pending', 'Pending', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 78385841-a4e2-47e4-a24c-e813032fa50c */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('78385841-a4e2-47e4-a24c-e813032fa50c', '797DCDB2-E973-4D9A-BE74-7D5C7F6C7852', 4, 'Skipped', 'Skipped', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 4f17e63c-dba8-4c9f-9962-92bd1723fd68 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('4f17e63c-dba8-4c9f-9962-92bd1723fd68', '797DCDB2-E973-4D9A-BE74-7D5C7F6C7852', 5, 'Tabled', 'Tabled', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID 797DCDB2-E973-4D9A-BE74-7D5C7F6C7852 */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='797DCDB2-E973-4D9A-BE74-7D5C7F6C7852'

/* SQL text to insert entity field value with ID 6f3f4aea-6072-4c56-853d-18030131cf2c */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('6f3f4aea-6072-4c56-853d-18030131cf2c', '2EC8CC0D-77E2-4557-99AB-F50B976B0F31', 1, 'Absent', 'Absent', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 701c8bc7-8c0b-4555-9f53-f9916940ada4 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('701c8bc7-8c0b-4555-9f53-f9916940ada4', '2EC8CC0D-77E2-4557-99AB-F50B976B0F31', 2, 'Excused', 'Excused', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 48238c29-c524-4581-ab5c-b81d68ff47ca */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('48238c29-c524-4581-ab5c-b81d68ff47ca', '2EC8CC0D-77E2-4557-99AB-F50B976B0F31', 3, 'Expected', 'Expected', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID ed60d346-c97c-44da-a86d-fd8fce20f719 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('ed60d346-c97c-44da-a86d-fd8fce20f719', '2EC8CC0D-77E2-4557-99AB-F50B976B0F31', 4, 'Partial', 'Partial', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID bedfb62c-6871-4225-8039-d8f2da961f3a */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('bedfb62c-6871-4225-8039-d8f2da961f3a', '2EC8CC0D-77E2-4557-99AB-F50B976B0F31', 5, 'Present', 'Present', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID 2EC8CC0D-77E2-4557-99AB-F50B976B0F31 */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='2EC8CC0D-77E2-4557-99AB-F50B976B0F31'

/* SQL text to insert entity field value with ID 911c85af-f2b2-47b0-a415-b2977b7926f3 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('911c85af-f2b2-47b0-a415-b2977b7926f3', 'F34A168B-D288-44FE-8BBA-F26D4B52A03B', 1, 'Critical', 'Critical', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 46327c74-6367-44bd-8485-a719f112adb9 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('46327c74-6367-44bd-8485-a719f112adb9', 'F34A168B-D288-44FE-8BBA-F26D4B52A03B', 2, 'High', 'High', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 6013eb8a-9953-4f17-9eac-59af9fb8d01e */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('6013eb8a-9953-4f17-9eac-59af9fb8d01e', 'F34A168B-D288-44FE-8BBA-F26D4B52A03B', 3, 'Low', 'Low', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 36623286-b5b0-4193-a893-c67c7c3cfd76 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('36623286-b5b0-4193-a893-c67c7c3cfd76', 'F34A168B-D288-44FE-8BBA-F26D4B52A03B', 4, 'Medium', 'Medium', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID F34A168B-D288-44FE-8BBA-F26D4B52A03B */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='F34A168B-D288-44FE-8BBA-F26D4B52A03B'

/* SQL text to insert entity field value with ID 258deee5-be59-4979-b71c-e339dbf71ee6 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('258deee5-be59-4979-b71c-e339dbf71ee6', 'BFBE6A51-5AE0-4EE9-ADEC-443F75706247', 1, 'Blocked', 'Blocked', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 69864d5a-48cb-49cf-a021-0cb379d1617b */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('69864d5a-48cb-49cf-a021-0cb379d1617b', 'BFBE6A51-5AE0-4EE9-ADEC-443F75706247', 2, 'Cancelled', 'Cancelled', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 7ad2d08c-8d53-4d59-b425-d5e892530d0a */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('7ad2d08c-8d53-4d59-b425-d5e892530d0a', 'BFBE6A51-5AE0-4EE9-ADEC-443F75706247', 3, 'Completed', 'Completed', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID c1cf8da7-83b3-451d-8d6b-126501279a22 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('c1cf8da7-83b3-451d-8d6b-126501279a22', 'BFBE6A51-5AE0-4EE9-ADEC-443F75706247', 4, 'InProgress', 'InProgress', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 8e12e4e2-f7a3-4ee4-9f45-8ac7a021fda1 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('8e12e4e2-f7a3-4ee4-9f45-8ac7a021fda1', 'BFBE6A51-5AE0-4EE9-ADEC-443F75706247', 5, 'Open', 'Open', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID BFBE6A51-5AE0-4EE9-ADEC-443F75706247 */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='BFBE6A51-5AE0-4EE9-ADEC-443F75706247'

/* SQL text to insert entity field value with ID d643a3a8-3748-45d6-a19b-08d92e7b55c5 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('d643a3a8-3748-45d6-a19b-08d92e7b55c5', '273D17C7-D240-4BDD-84EE-3F733F6A6F3C', 1, 'Box', 'Box', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 148837de-2f4b-4ed2-b514-41d5e9885229 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('148837de-2f4b-4ed2-b514-41d5e9885229', '273D17C7-D240-4BDD-84EE-3F733F6A6F3C', 2, 'Dropbox', 'Dropbox', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID f29299b9-d075-4e2b-b633-f4c13eb1e120 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('f29299b9-d075-4e2b-b633-f4c13eb1e120', '273D17C7-D240-4BDD-84EE-3F733F6A6F3C', 3, 'GoogleDrive', 'GoogleDrive', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID a8363613-8ac4-484d-929c-47ca4fa93304 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('a8363613-8ac4-484d-929c-47ca4fa93304', '273D17C7-D240-4BDD-84EE-3F733F6A6F3C', 4, 'OneDrive', 'OneDrive', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 220e4689-dbc1-4d33-8ede-a0c3b58c3521 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('220e4689-dbc1-4d33-8ede-a0c3b58c3521', '273D17C7-D240-4BDD-84EE-3F733F6A6F3C', 5, 'SharePoint', 'SharePoint', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID d53289ad-ca3b-4517-a67c-e9c368dd7c42 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('d53289ad-ca3b-4517-a67c-e9c368dd7c42', '273D17C7-D240-4BDD-84EE-3F733F6A6F3C', 6, 'URL', 'URL', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID 273D17C7-D240-4BDD-84EE-3F733F6A6F3C */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='273D17C7-D240-4BDD-84EE-3F733F6A6F3C'

/* SQL text to insert entity field value with ID 02b3725e-c8b0-4b10-a271-49ca5a43ea60 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('02b3725e-c8b0-4b10-a271-49ca5a43ea60', 'DB7533C1-7236-4E59-A39E-A1CA6635274A', 1, 'Approved', 'Approved', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 85d7b7ee-5221-459e-badc-25691801ce00 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('85d7b7ee-5221-459e-badc-25691801ce00', 'DB7533C1-7236-4E59-A39E-A1CA6635274A', 2, 'Draft', 'Draft', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID c633ff29-3cc9-4d15-8ecc-314114e0059c */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('c633ff29-3cc9-4d15-8ecc-314114e0059c', 'DB7533C1-7236-4E59-A39E-A1CA6635274A', 3, 'PendingApproval', 'PendingApproval', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 517408f1-f692-40d7-9bcb-334ce87a0996 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('517408f1-f692-40d7-9bcb-334ce87a0996', 'DB7533C1-7236-4E59-A39E-A1CA6635274A', 4, 'Rejected', 'Rejected', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID DB7533C1-7236-4E59-A39E-A1CA6635274A */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='DB7533C1-7236-4E59-A39E-A1CA6635274A'

/* SQL text to insert entity field value with ID cb4f7d7c-aeb4-4c4b-8931-6008f9e9b324 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('cb4f7d7c-aeb4-4c4b-8931-6008f9e9b324', '3F71B06A-8912-4201-9124-3E7FAC45574D', 1, 'Failed', 'Failed', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 4d108946-abdb-4538-83d1-2073b044626e */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('4d108946-abdb-4538-83d1-2073b044626e', '3F71B06A-8912-4201-9124-3E7FAC45574D', 2, 'Passed', 'Passed', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 97d583e7-7962-444c-99e7-d40a8005e40f */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('97d583e7-7962-444c-99e7-d40a8005e40f', '3F71B06A-8912-4201-9124-3E7FAC45574D', 3, 'Pending', 'Pending', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 4541d4cc-acfe-4ca7-a2f6-5e866dd70216 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('4541d4cc-acfe-4ca7-a2f6-5e866dd70216', '3F71B06A-8912-4201-9124-3E7FAC45574D', 4, 'Tabled', 'Tabled', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 285606e9-f0e8-482c-97f2-cf991341b6a9 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('285606e9-f0e8-482c-97f2-cf991341b6a9', '3F71B06A-8912-4201-9124-3E7FAC45574D', 5, 'Withdrawn', 'Withdrawn', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID 3F71B06A-8912-4201-9124-3E7FAC45574D */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='3F71B06A-8912-4201-9124-3E7FAC45574D'

/* SQL text to insert entity field value with ID dacbcb4e-e894-4c74-9d5e-a1f239d3f311 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('dacbcb4e-e894-4c74-9d5e-a1f239d3f311', '5C9F9821-5901-46A1-8210-1C75CD49F08D', 1, 'Absent', 'Absent', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 7783a6ac-326d-4582-8106-8ca2151448b8 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('7783a6ac-326d-4582-8106-8ca2151448b8', '5C9F9821-5901-46A1-8210-1C75CD49F08D', 2, 'Abstain', 'Abstain', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 3e8c0c10-499c-4ac4-aacd-ab325bf62771 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('3e8c0c10-499c-4ac4-aacd-ab325bf62771', '5C9F9821-5901-46A1-8210-1C75CD49F08D', 3, 'No', 'No', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID a579bd3d-c807-453f-8421-1fec2addaa7e */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('a579bd3d-c807-453f-8421-1fec2addaa7e', '5C9F9821-5901-46A1-8210-1C75CD49F08D', 4, 'Yes', 'Yes', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID 5C9F9821-5901-46A1-8210-1C75CD49F08D */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='5C9F9821-5901-46A1-8210-1C75CD49F08D'

/* SQL text to insert entity field value with ID fcebf733-3af4-44fc-bf2e-3deb501e337c */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('fcebf733-3af4-44fc-bf2e-3deb501e337c', '68040577-ADF2-4EBF-A80E-FE0BBC205F0B', 1, 'Active', 'Active', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID c42f8046-bef8-4f69-804e-303bec95e5c7 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('c42f8046-bef8-4f69-804e-303bec95e5c7', '68040577-ADF2-4EBF-A80E-FE0BBC205F0B', 2, 'Dissolved', 'Dissolved', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID b3eaffc3-c04a-47ce-b773-18c940d06f3a */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('b3eaffc3-c04a-47ce-b773-18c940d06f3a', '68040577-ADF2-4EBF-A80E-FE0BBC205F0B', 3, 'Inactive', 'Inactive', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 3a482ae4-78d3-4627-bb48-f962fb53902b */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('3a482ae4-78d3-4627-bb48-f962fb53902b', '68040577-ADF2-4EBF-A80E-FE0BBC205F0B', 4, 'Pending', 'Pending', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID 68040577-ADF2-4EBF-A80E-FE0BBC205F0B */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='68040577-ADF2-4EBF-A80E-FE0BBC205F0B'

/* SQL text to insert entity field value with ID 529642ba-35f0-43ca-bef1-9398129c8309 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('529642ba-35f0-43ca-bef1-9398129c8309', '41895295-C70A-43B0-9B0A-F4F535495884', 1, 'Active', 'Active', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 759fb004-ece2-4931-926a-ac2fca29e43c */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('759fb004-ece2-4931-926a-ac2fca29e43c', '41895295-C70A-43B0-9B0A-F4F535495884', 2, 'Completed', 'Completed', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 233c4cec-8440-44d3-bc9f-9691b4a02cdc */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('233c4cec-8440-44d3-bc9f-9691b4a02cdc', '41895295-C70A-43B0-9B0A-F4F535495884', 3, 'Upcoming', 'Upcoming', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID 41895295-C70A-43B0-9B0A-F4F535495884 */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='41895295-C70A-43B0-9B0A-F4F535495884'

/* SQL text to insert entity field value with ID 78b43684-3fec-4f3b-b787-23b59230e598 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('78b43684-3fec-4f3b-b787-23b59230e598', 'EC0CA348-6190-4924-8715-87D0BBFDD6BE', 1, 'Active', 'Active', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 3b844fcf-25d1-434e-ad4e-5fc673d87f68 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('3b844fcf-25d1-434e-ad4e-5fc673d87f68', 'EC0CA348-6190-4924-8715-87D0BBFDD6BE', 2, 'Ended', 'Ended', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 57bcea85-cb9e-4d29-a027-e4963bee355b */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('57bcea85-cb9e-4d29-a027-e4963bee355b', 'EC0CA348-6190-4924-8715-87D0BBFDD6BE', 3, 'Pending', 'Pending', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 95e7ea73-c1df-4591-9bf5-94aebfdae004 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('95e7ea73-c1df-4591-9bf5-94aebfdae004', 'EC0CA348-6190-4924-8715-87D0BBFDD6BE', 4, 'Suspended', 'Suspended', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID EC0CA348-6190-4924-8715-87D0BBFDD6BE */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='EC0CA348-6190-4924-8715-87D0BBFDD6BE'

/* SQL text to insert entity field value with ID 49ed30fd-94a3-4db3-b493-6f3b0d73de9b */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('49ed30fd-94a3-4db3-b493-6f3b0d73de9b', '63363A4E-1607-462E-8348-6907BEF1DFC4', 1, 'Cancelled', 'Cancelled', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 5bfd16a5-c24b-4084-a17d-23bb838b466b */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('5bfd16a5-c24b-4084-a17d-23bb838b466b', '63363A4E-1607-462E-8348-6907BEF1DFC4', 2, 'Completed', 'Completed', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID ecf7ef9e-2156-401d-b9af-5b4ce7907a69 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('ecf7ef9e-2156-401d-b9af-5b4ce7907a69', '63363A4E-1607-462E-8348-6907BEF1DFC4', 3, 'Draft', 'Draft', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 82f22454-f040-4ba5-a1e4-c9966f1c9bde */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('82f22454-f040-4ba5-a1e4-c9966f1c9bde', '63363A4E-1607-462E-8348-6907BEF1DFC4', 4, 'InProgress', 'InProgress', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 34d3e059-2599-4e4a-bcd9-b2105b6a325c */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('34d3e059-2599-4e4a-bcd9-b2105b6a325c', '63363A4E-1607-462E-8348-6907BEF1DFC4', 5, 'Postponed', 'Postponed', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 6221d350-a889-4f55-97c1-662512eb13bf */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('6221d350-a889-4f55-97c1-662512eb13bf', '63363A4E-1607-462E-8348-6907BEF1DFC4', 6, 'Scheduled', 'Scheduled', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID 63363A4E-1607-462E-8348-6907BEF1DFC4 */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='63363A4E-1607-462E-8348-6907BEF1DFC4'

/* SQL text to insert entity field value with ID 379182bc-a923-4e7c-86bf-8c88676d43d4 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('379182bc-a923-4e7c-86bf-8c88676d43d4', '6E828B99-DD10-4F30-AD0F-A4A6AD4B25E2', 1, 'Hybrid', 'Hybrid', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID f103b2ca-6bb5-4e84-9c13-acd275c1b952 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('f103b2ca-6bb5-4e84-9c13-acd275c1b952', '6E828B99-DD10-4F30-AD0F-A4A6AD4B25E2', 2, 'InPerson', 'InPerson', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 712f6da7-9cc8-4beb-bfc6-dc71b2cc767a */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('712f6da7-9cc8-4beb-bfc6-dc71b2cc767a', '6E828B99-DD10-4F30-AD0F-A4A6AD4B25E2', 3, 'Virtual', 'Virtual', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID 6E828B99-DD10-4F30-AD0F-A4A6AD4B25E2 */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='6E828B99-DD10-4F30-AD0F-A4A6AD4B25E2'


/* Create Entity Relationship: Roles -> Memberships (One To Many via RoleID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '986ffec3-fc5d-449f-994e-603bf2a94a93'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('986ffec3-fc5d-449f-994e-603bf2a94a93', 'E170A834-9278-49DB-9F73-08945C0E83DF', '35AACFD0-C02B-4D1B-AD41-8C081D08650C', 'RoleID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees -> Action Items (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '4600d9d1-a8dd-468c-b949-a6ced2a17d1b'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('4600d9d1-a8dd-468c-b949-a6ced2a17d1b', '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', 'CommitteeID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees -> Artifacts (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'ea0a694d-3023-47a6-8954-471498a2237b'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('ea0a694d-3023-47a6-8954-471498a2237b', '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', '26E04065-1F39-4AB6-913E-6B87481DEFA7', 'CommitteeID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees -> Comments (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '6076148b-b260-41b9-b657-0e3af9a0cfa0'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('6076148b-b260-41b9-b657-0e3af9a0cfa0', '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', 'CommitteeID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees -> Committees (One To Many via ParentCommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '0251939d-2930-40d2-ba5d-0415276512ff'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('0251939d-2930-40d2-ba5d-0415276512ff', '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', 'ParentCommitteeID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: Committees -> Meetings (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '101e5e2f-e550-41fa-95a5-f573afbc2dd1'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('101e5e2f-e550-41fa-95a5-f573afbc2dd1', '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', '473622EE-DAF0-4A10-8289-F9C14B937A44', 'CommitteeID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees -> Terms (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'efc564df-d048-4f6e-bab8-abb302d0339f'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('efc564df-d048-4f6e-bab8-abb302d0339f', '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4', 'CommitteeID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Video Providers -> Meetings (One To Many via VideoProviderID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'a3445edb-9d40-4590-bfe9-2ad945d9f0d1'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('a3445edb-9d40-4590-bfe9-2ad945d9f0d1', '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC', '473622EE-DAF0-4A10-8289-F9C14B937A44', 'VideoProviderID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: MJ: Entities -> Artifact Types (One To Many via ExtendedEntityID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '5e92de04-3127-497a-98d1-d64a038490ff'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('5e92de04-3127-497a-98d1-d64a038490ff', 'E0238F34-2837-EF11-86D4-6045BDEE16E6', 'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476', 'ExtendedEntityID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Artifacts -> Comments (One To Many via ArtifactID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '0a143694-6951-42d1-bbd8-bfd1c9a300ac'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('0a143694-6951-42d1-bbd8-bfd1c9a300ac', '26E04065-1F39-4AB6-913E-6B87481DEFA7', 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', 'ArtifactID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Motions -> Votes (One To Many via MotionID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '6dcec3be-5c20-4c37-8c39-8cb7593bba06'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('6dcec3be-5c20-4c37-8c39-8cb7593bba06', '36D14C54-9D93-4A39-A282-6BF7B997B70E', 'CCC2482F-5E43-4E5A-886F-476F7C9F2C71', 'MotionID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Comments -> Comments (One To Many via ParentCommentID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '307aa8fd-36c5-4414-a730-ac1734a2680c'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('307aa8fd-36c5-4414-a730-ac1734a2680c', 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', 'ParentCommentID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: MJ.BizApps.Common: Organizations -> Committees (One To Many via OrganizationID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '6c8bf5a5-50c6-4eb3-aa3d-4a3931e69535'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('6c8bf5a5-50c6-4eb3-aa3d-4a3931e69535', 'C70448F9-9792-41D7-A82C-784B66429D54', '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', 'OrganizationID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: Memberships -> Motions (One To Many via MovedByMembershipID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'bfd8ef7b-c296-4e04-a715-b9e01b8d5e1d'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('bfd8ef7b-c296-4e04-a715-b9e01b8d5e1d', '35AACFD0-C02B-4D1B-AD41-8C081D08650C', '36D14C54-9D93-4A39-A282-6BF7B997B70E', 'MovedByMembershipID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Memberships -> Motions (One To Many via SecondedByMembershipID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '41b587f8-5f56-4770-9db5-d8a781bb0f62'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('41b587f8-5f56-4770-9db5-d8a781bb0f62', '35AACFD0-C02B-4D1B-AD41-8C081D08650C', '36D14C54-9D93-4A39-A282-6BF7B997B70E', 'SecondedByMembershipID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Memberships -> Votes (One To Many via MembershipID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'f78e6be9-b003-4fc7-ad98-ec6b87ee10d0'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('f78e6be9-b003-4fc7-ad98-ec6b87ee10d0', '35AACFD0-C02B-4D1B-AD41-8C081D08650C', 'CCC2482F-5E43-4E5A-886F-476F7C9F2C71', 'MembershipID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ: Credentials -> Video Providers (One To Many via CredentialID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '736d6d69-56b7-4dec-9116-17bb79f292e0'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('736d6d69-56b7-4dec-9116-17bb79f292e0', '7E023DDF-82C6-4B0C-9650-8D35699B9FD0', '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC', 'CredentialID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Action Items -> Comments (One To Many via ActionItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'bf65ace2-1c89-4464-a341-9c2f2686ed07'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('bf65ace2-1c89-4464-a341-9c2f2686ed07', '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', 'ActionItemID', 'One To Many', 1, 1, 4, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Action Items -> Artifacts (One To Many via ActionItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '88498dfe-3cbe-4cea-94f0-60d252993a33'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('88498dfe-3cbe-4cea-94f0-60d252993a33', '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', '26E04065-1F39-4AB6-913E-6B87481DEFA7', 'ActionItemID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: Types -> Committees (One To Many via TypeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '11aee1cd-4753-48cd-b338-043802b97933'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('11aee1cd-4753-48cd-b338-043802b97933', '1B9BF218-367F-452E-9DD9-BDE6F306F742', '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', 'TypeID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Terms -> Memberships (One To Many via TermID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '8e7f5d8e-6c05-4ada-8252-1ffcf0fa2e94'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('8e7f5d8e-6c05-4ada-8252-1ffcf0fa2e94', '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4', '35AACFD0-C02B-4D1B-AD41-8C081D08650C', 'TermID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ.BizApps.Common: People -> Memberships (One To Many via PersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '8702068c-e373-4509-be0a-ba7324e38c50'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('8702068c-e373-4509-be0a-ba7324e38c50', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '35AACFD0-C02B-4D1B-AD41-8C081D08650C', 'PersonID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ.BizApps.Common: People -> Action Items (One To Many via AssignedByPersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'b63f6715-f482-44f6-8f39-98aeaebdbd44'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('b63f6715-f482-44f6-8f39-98aeaebdbd44', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', 'AssignedByPersonID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ.BizApps.Common: People -> Action Items (One To Many via AssignedToPersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '5e15bc36-a71f-4936-be7b-e4fa811dfa22'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('5e15bc36-a71f-4936-be7b-e4fa811dfa22', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', 'AssignedToPersonID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: MJ.BizApps.Common: People -> Comments (One To Many via PersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '953bca0a-b3b8-4992-8783-faa0f64ce2ca'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('953bca0a-b3b8-4992-8783-faa0f64ce2ca', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', 'PersonID', 'One To Many', 1, 1, 5, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ.BizApps.Common: People -> Artifacts (One To Many via UploadedByPersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '3ad7b76f-6043-47d6-9248-c664b5dde7cf'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('3ad7b76f-6043-47d6-9248-c664b5dde7cf', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '26E04065-1F39-4AB6-913E-6B87481DEFA7', 'UploadedByPersonID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ.BizApps.Common: People -> Attendances (One To Many via PersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '58fcda26-fab0-45e4-b56d-33884aefcc19'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('58fcda26-fab0-45e4-b56d-33884aefcc19', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '28992C32-D738-4E7C-97CA-5F0489E89D56', 'PersonID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: MJ.BizApps.Common: People -> Agenda Items (One To Many via PresenterPersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '07c64e95-71fc-4e0f-aa31-4e488c4633be'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('07c64e95-71fc-4e0f-aa31-4e488c4633be', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', 'PresenterPersonID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Artifact Types -> Artifacts (One To Many via ArtifactTypeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '219f7a42-8b48-4b8e-9f77-e2abd6de33ae'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('219f7a42-8b48-4b8e-9f77-e2abd6de33ae', 'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476', '26E04065-1F39-4AB6-913E-6B87481DEFA7', 'ArtifactTypeID', 'One To Many', 1, 1, 4, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Agenda Items -> Comments (One To Many via AgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '9163bf67-94aa-419f-bd33-a2ab915c0eaf'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('9163bf67-94aa-419f-bd33-a2ab915c0eaf', '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', 'AgendaItemID', 'One To Many', 1, 1, 6, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Agenda Items -> Agenda Items (One To Many via ParentAgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'e2720261-65c2-4e44-9f27-e524502ec2e7'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('e2720261-65c2-4e44-9f27-e524502ec2e7', '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', 'ParentAgendaItemID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Agenda Items -> Motions (One To Many via AgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'd1ec7175-2407-47dc-8b2b-05de0d23f2a6'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('d1ec7175-2407-47dc-8b2b-05de0d23f2a6', '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', '36D14C54-9D93-4A39-A282-6BF7B997B70E', 'AgendaItemID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: Agenda Items -> Action Items (One To Many via AgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'ec06dc45-115c-4cbf-a7d3-3b1a1e355467'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('ec06dc45-115c-4cbf-a7d3-3b1a1e355467', '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', 'AgendaItemID', 'One To Many', 1, 1, 4, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Agenda Items -> Artifacts (One To Many via AgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '3cddc1ba-6be1-4af3-ad65-dfa00c2e07b3'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('3cddc1ba-6be1-4af3-ad65-dfa00c2e07b3', '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', '26E04065-1F39-4AB6-913E-6B87481DEFA7', 'AgendaItemID', 'One To Many', 1, 1, 5, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Meetings -> Agenda Items (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'f87127a1-c722-4d40-8551-a57e5f805fcc'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('f87127a1-c722-4d40-8551-a57e5f805fcc', '473622EE-DAF0-4A10-8289-F9C14B937A44', '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', 'MeetingID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: Meetings -> Action Items (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '55601678-fa32-4e5f-8453-d574639f2f64'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('55601678-fa32-4e5f-8453-d574639f2f64', '473622EE-DAF0-4A10-8289-F9C14B937A44', '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', 'MeetingID', 'One To Many', 1, 1, 5, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Meetings -> Minutes (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'd5932dcd-4e38-444a-8ec7-f8d54adc684e'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('d5932dcd-4e38-444a-8ec7-f8d54adc684e', '473622EE-DAF0-4A10-8289-F9C14B937A44', '58792440-2D28-46CF-BFB3-79A214063E37', 'MeetingID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Meetings -> Minutes (One To Many via ApprovedByMeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '2d6451bd-8add-47f6-b08b-fc3fb7ed0770'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('2d6451bd-8add-47f6-b08b-fc3fb7ed0770', '473622EE-DAF0-4A10-8289-F9C14B937A44', '58792440-2D28-46CF-BFB3-79A214063E37', 'ApprovedByMeetingID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Meetings -> Motions (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '00aba6cc-e460-4f4f-8f10-203fb67872ce'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('00aba6cc-e460-4f4f-8f10-203fb67872ce', '473622EE-DAF0-4A10-8289-F9C14B937A44', '36D14C54-9D93-4A39-A282-6BF7B997B70E', 'MeetingID', 'One To Many', 1, 1, 4, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Meetings -> Comments (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'b4d8f382-0e8e-4d0d-b440-f1bfeb8e1a50'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('b4d8f382-0e8e-4d0d-b440-f1bfeb8e1a50', '473622EE-DAF0-4A10-8289-F9C14B937A44', 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', 'MeetingID', 'One To Many', 1, 1, 7, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Meetings -> Artifacts (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'ae6a8ad8-2988-412a-89d4-26c879c59e21'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('ae6a8ad8-2988-412a-89d4-26c879c59e21', '473622EE-DAF0-4A10-8289-F9C14B937A44', '26E04065-1F39-4AB6-913E-6B87481DEFA7', 'MeetingID', 'One To Many', 1, 1, 6, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: Meetings -> Attendances (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'c630c4f1-8f42-4f51-adbf-06fbedd8a30d'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('c630c4f1-8f42-4f51-adbf-06fbedd8a30d', '473622EE-DAF0-4A10-8289-F9C14B937A44', '28992C32-D738-4E7C-97CA-5F0489E89D56', 'MeetingID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    

/* Index for Foreign Keys for ActionItem */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Action Items
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key CommitteeID in table ActionItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_ActionItem_CommitteeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[ActionItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ActionItem_CommitteeID ON [${flyway:defaultSchema}_Committees].[ActionItem] ([CommitteeID]);

-- Index for foreign key MeetingID in table ActionItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_ActionItem_MeetingID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[ActionItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ActionItem_MeetingID ON [${flyway:defaultSchema}_Committees].[ActionItem] ([MeetingID]);

-- Index for foreign key AgendaItemID in table ActionItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_ActionItem_AgendaItemID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[ActionItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ActionItem_AgendaItemID ON [${flyway:defaultSchema}_Committees].[ActionItem] ([AgendaItemID]);

-- Index for foreign key AssignedToPersonID in table ActionItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_ActionItem_AssignedToPersonID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[ActionItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ActionItem_AssignedToPersonID ON [${flyway:defaultSchema}_Committees].[ActionItem] ([AssignedToPersonID]);

-- Index for foreign key AssignedByPersonID in table ActionItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_ActionItem_AssignedByPersonID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[ActionItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ActionItem_AssignedByPersonID ON [${flyway:defaultSchema}_Committees].[ActionItem] ([AssignedByPersonID]);

/* SQL text to update entity field related entity name field map for entity field ID C42155FC-0F1B-4A8D-B239-3BBC4DE5B4AD */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='C42155FC-0F1B-4A8D-B239-3BBC4DE5B4AD', @RelatedEntityNameFieldMap='Committee'

/* Index for Foreign Keys for AgendaItem */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Agenda Items
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key MeetingID in table AgendaItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_AgendaItem_MeetingID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[AgendaItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_AgendaItem_MeetingID ON [${flyway:defaultSchema}_Committees].[AgendaItem] ([MeetingID]);

-- Index for foreign key ParentAgendaItemID in table AgendaItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_AgendaItem_ParentAgendaItemID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[AgendaItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_AgendaItem_ParentAgendaItemID ON [${flyway:defaultSchema}_Committees].[AgendaItem] ([ParentAgendaItemID]);

-- Index for foreign key PresenterPersonID in table AgendaItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_AgendaItem_PresenterPersonID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[AgendaItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_AgendaItem_PresenterPersonID ON [${flyway:defaultSchema}_Committees].[AgendaItem] ([PresenterPersonID]);

/* SQL text to update entity field related entity name field map for entity field ID 75CDE5D3-BACC-4874-B8D3-5451BB4A232E */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='75CDE5D3-BACC-4874-B8D3-5451BB4A232E', @RelatedEntityNameFieldMap='PresenterPerson'

/* Index for Foreign Keys for ArtifactType */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Artifact Types
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key ExtendedEntityID in table ArtifactType
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_ArtifactType_ExtendedEntityID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[ArtifactType]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ArtifactType_ExtendedEntityID ON [${flyway:defaultSchema}_Committees].[ArtifactType] ([ExtendedEntityID]);

/* SQL text to update entity field related entity name field map for entity field ID 7C8227DF-5515-4828-B3E5-4195A03D5F0D */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='7C8227DF-5515-4828-B3E5-4195A03D5F0D', @RelatedEntityNameFieldMap='ExtendedEntity'

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

-- Index for foreign key ActionItemID in table Artifact
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_ActionItemID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Artifact]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_ActionItemID ON [${flyway:defaultSchema}_Committees].[Artifact] ([ActionItemID]);

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

/* SQL text to update entity field related entity name field map for entity field ID 97FAB244-8B45-4704-903A-5911D79695C5 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='97FAB244-8B45-4704-903A-5911D79695C5', @RelatedEntityNameFieldMap='Committee'

/* Index for Foreign Keys for Attendance */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Attendances
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key MeetingID in table Attendance
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Attendance_MeetingID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Attendance]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Attendance_MeetingID ON [${flyway:defaultSchema}_Committees].[Attendance] ([MeetingID]);

-- Index for foreign key PersonID in table Attendance
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Attendance_PersonID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Attendance]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Attendance_PersonID ON [${flyway:defaultSchema}_Committees].[Attendance] ([PersonID]);

/* SQL text to update entity field related entity name field map for entity field ID 4731151B-DEAF-444B-BD5E-83825D55CBD1 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='4731151B-DEAF-444B-BD5E-83825D55CBD1', @RelatedEntityNameFieldMap='Person'

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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[fnAgendaItemParentAgendaItemID_GetRootID]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}_Committees].[fnAgendaItemParentAgendaItemID_GetRootID];
GO

CREATE FUNCTION [${flyway:defaultSchema}_Committees].[fnAgendaItemParentAgendaItemID_GetRootID]
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
            [${flyway:defaultSchema}_Committees].[AgendaItem]
        WHERE
            [ID] = COALESCE(@ParentID, @RecordID)

        UNION ALL

        SELECT
            c.[ID],
            c.[ParentAgendaItemID],
            c.[ID] AS [RootParentID],
            p.[Depth] + 1 AS [Depth]
        FROM
            [${flyway:defaultSchema}_Committees].[AgendaItem] c
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
-----               SCHEMA:      ${flyway:defaultSchema}_Committees
-----               BASE TABLE:  AgendaItem
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[vwAgendaItems]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_Committees].[vwAgendaItems];
GO

CREATE VIEW [${flyway:defaultSchema}_Committees].[vwAgendaItems]
AS
SELECT
    a.*,
    mjBizAppsCommonPerson_PresenterPersonID.[DisplayName] AS [PresenterPerson],
    root_ParentAgendaItemID.RootID AS [RootParentAgendaItemID]
FROM
    [${flyway:defaultSchema}_Committees].[AgendaItem] AS a
LEFT OUTER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[vwPeopleExtended] AS mjBizAppsCommonPerson_PresenterPersonID
  ON
    [a].[PresenterPersonID] = mjBizAppsCommonPerson_PresenterPersonID.[ID]
OUTER APPLY
    [${flyway:defaultSchema}_Committees].[fnAgendaItemParentAgendaItemID_GetRootID]([a].[ID], [a].[ParentAgendaItemID]) AS root_ParentAgendaItemID
GO
GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwAgendaItems] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Agenda Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Agenda Items
-- Item: Permissions for vwAgendaItems
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwAgendaItems] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spCreateAgendaItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateAgendaItem];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateAgendaItem]
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
        INSERT INTO [${flyway:defaultSchema}_Committees].[AgendaItem]
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
        INSERT INTO [${flyway:defaultSchema}_Committees].[AgendaItem]
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
    SELECT * FROM [${flyway:defaultSchema}_Committees].[vwAgendaItems] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateAgendaItem] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Agenda Items */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateAgendaItem] TO [cdp_Developer], [cdp_Integration]



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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spUpdateAgendaItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateAgendaItem];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateAgendaItem]
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
        [${flyway:defaultSchema}_Committees].[AgendaItem]
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
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_Committees].[vwAgendaItems] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_Committees].[vwAgendaItems]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateAgendaItem] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the AgendaItem table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[trgUpdateAgendaItem]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_Committees].[trgUpdateAgendaItem];
GO
CREATE TRIGGER [${flyway:defaultSchema}_Committees].trgUpdateAgendaItem
ON [${flyway:defaultSchema}_Committees].[AgendaItem]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[AgendaItem]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_Committees].[AgendaItem] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Agenda Items */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateAgendaItem] TO [cdp_Developer], [cdp_Integration]



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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spDeleteAgendaItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteAgendaItem];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteAgendaItem]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_Committees].[AgendaItem]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteAgendaItem] TO [cdp_Integration]
    

/* spDelete Permissions for Agenda Items */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteAgendaItem] TO [cdp_Integration]



/* SQL text to update entity field related entity name field map for entity field ID 62A51489-B1C1-42B5-BA7D-E28319FA087F */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='62A51489-B1C1-42B5-BA7D-E28319FA087F', @RelatedEntityNameFieldMap='AssignedToPerson'

/* SQL text to update entity field related entity name field map for entity field ID EE7E6B0E-6EC6-44DF-B609-9828F65F0201 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='EE7E6B0E-6EC6-44DF-B609-9828F65F0201', @RelatedEntityNameFieldMap='ArtifactType'

/* Base View SQL for Artifact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Artifact Types
-- Item: vwArtifactTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Artifact Types
-----               SCHEMA:      ${flyway:defaultSchema}_Committees
-----               BASE TABLE:  ArtifactType
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[vwArtifactTypes]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_Committees].[vwArtifactTypes];
GO

CREATE VIEW [${flyway:defaultSchema}_Committees].[vwArtifactTypes]
AS
SELECT
    a.*,
    MJEntity_ExtendedEntityID.[Name] AS [ExtendedEntity]
FROM
    [${flyway:defaultSchema}_Committees].[ArtifactType] AS a
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Entity] AS MJEntity_ExtendedEntityID
  ON
    [a].[ExtendedEntityID] = MJEntity_ExtendedEntityID.[ID]
GO
GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwArtifactTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Artifact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Artifact Types
-- Item: Permissions for vwArtifactTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwArtifactTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for Artifact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Artifact Types
-- Item: spCreateArtifactType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR ArtifactType
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spCreateArtifactType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateArtifactType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateArtifactType]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(100),
    @Description nvarchar(MAX),
    @ExtendedEntityID uniqueidentifier,
    @IconClass nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_Committees].[ArtifactType]
            (
                [ID],
                [Name],
                [Description],
                [ExtendedEntityID],
                [IconClass]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @Name,
                @Description,
                @ExtendedEntityID,
                @IconClass
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_Committees].[ArtifactType]
            (
                [Name],
                [Description],
                [ExtendedEntityID],
                [IconClass]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @Name,
                @Description,
                @ExtendedEntityID,
                @IconClass
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_Committees].[vwArtifactTypes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateArtifactType] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Artifact Types */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateArtifactType] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for Artifact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Artifact Types
-- Item: spUpdateArtifactType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR ArtifactType
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spUpdateArtifactType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateArtifactType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateArtifactType]
    @ID uniqueidentifier,
    @Name nvarchar(100),
    @Description nvarchar(MAX),
    @ExtendedEntityID uniqueidentifier,
    @IconClass nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[ArtifactType]
    SET
        [Name] = @Name,
        [Description] = @Description,
        [ExtendedEntityID] = @ExtendedEntityID,
        [IconClass] = @IconClass
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_Committees].[vwArtifactTypes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_Committees].[vwArtifactTypes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateArtifactType] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the ArtifactType table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[trgUpdateArtifactType]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_Committees].[trgUpdateArtifactType];
GO
CREATE TRIGGER [${flyway:defaultSchema}_Committees].trgUpdateArtifactType
ON [${flyway:defaultSchema}_Committees].[ArtifactType]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[ArtifactType]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_Committees].[ArtifactType] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Artifact Types */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateArtifactType] TO [cdp_Developer], [cdp_Integration]



/* spDelete SQL for Artifact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Artifact Types
-- Item: spDeleteArtifactType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR ArtifactType
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spDeleteArtifactType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteArtifactType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteArtifactType]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_Committees].[ArtifactType]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteArtifactType] TO [cdp_Integration]
    

/* spDelete Permissions for Artifact Types */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteArtifactType] TO [cdp_Integration]



/* SQL text to update entity field related entity name field map for entity field ID 61264E2F-FDF4-4E47-B22C-283B5A712159 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='61264E2F-FDF4-4E47-B22C-283B5A712159', @RelatedEntityNameFieldMap='AssignedByPerson'

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
-----               SCHEMA:      ${flyway:defaultSchema}_Committees
-----               BASE TABLE:  Attendance
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[vwAttendances]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_Committees].[vwAttendances];
GO

CREATE VIEW [${flyway:defaultSchema}_Committees].[vwAttendances]
AS
SELECT
    a.*,
    mjBizAppsCommonPerson_PersonID.[DisplayName] AS [Person]
FROM
    [${flyway:defaultSchema}_Committees].[Attendance] AS a
INNER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[vwPeopleExtended] AS mjBizAppsCommonPerson_PersonID
  ON
    [a].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
GO
GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwAttendances] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Attendances */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Attendances
-- Item: Permissions for vwAttendances
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwAttendances] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spCreateAttendance]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateAttendance];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateAttendance]
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
        INSERT INTO [${flyway:defaultSchema}_Committees].[Attendance]
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
        INSERT INTO [${flyway:defaultSchema}_Committees].[Attendance]
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
    SELECT * FROM [${flyway:defaultSchema}_Committees].[vwAttendances] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateAttendance] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Attendances */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateAttendance] TO [cdp_Developer], [cdp_Integration]



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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spUpdateAttendance]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateAttendance];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateAttendance]
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
        [${flyway:defaultSchema}_Committees].[Attendance]
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
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_Committees].[vwAttendances] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_Committees].[vwAttendances]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateAttendance] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Attendance table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[trgUpdateAttendance]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_Committees].[trgUpdateAttendance];
GO
CREATE TRIGGER [${flyway:defaultSchema}_Committees].trgUpdateAttendance
ON [${flyway:defaultSchema}_Committees].[Attendance]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Attendance]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_Committees].[Attendance] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Attendances */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateAttendance] TO [cdp_Developer], [cdp_Integration]



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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spDeleteAttendance]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteAttendance];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteAttendance]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_Committees].[Attendance]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteAttendance] TO [cdp_Integration]
    

/* spDelete Permissions for Attendances */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteAttendance] TO [cdp_Integration]



/* SQL text to update entity field related entity name field map for entity field ID FEB37F43-F610-412B-A9C7-E5C8354A1578 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='FEB37F43-F610-412B-A9C7-E5C8354A1578', @RelatedEntityNameFieldMap='UploadedByPerson'

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
-----               SCHEMA:      ${flyway:defaultSchema}_Committees
-----               BASE TABLE:  ActionItem
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[vwActionItems]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_Committees].[vwActionItems];
GO

CREATE VIEW [${flyway:defaultSchema}_Committees].[vwActionItems]
AS
SELECT
    a.*,
    mjCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjBizAppsCommonPerson_AssignedToPersonID.[DisplayName] AS [AssignedToPerson],
    mjBizAppsCommonPerson_AssignedByPersonID.[DisplayName] AS [AssignedByPerson]
FROM
    [${flyway:defaultSchema}_Committees].[ActionItem] AS a
INNER JOIN
    [${flyway:defaultSchema}_Committees].[Committee] AS mjCommitteesCommittee_CommitteeID
  ON
    [a].[CommitteeID] = mjCommitteesCommittee_CommitteeID.[ID]
INNER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[vwPeopleExtended] AS mjBizAppsCommonPerson_AssignedToPersonID
  ON
    [a].[AssignedToPersonID] = mjBizAppsCommonPerson_AssignedToPersonID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[vwPeopleExtended] AS mjBizAppsCommonPerson_AssignedByPersonID
  ON
    [a].[AssignedByPersonID] = mjBizAppsCommonPerson_AssignedByPersonID.[ID]
GO
GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwActionItems] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Action Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Action Items
-- Item: Permissions for vwActionItems
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwActionItems] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spCreateActionItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateActionItem];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateActionItem]
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
        INSERT INTO [${flyway:defaultSchema}_Committees].[ActionItem]
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
        INSERT INTO [${flyway:defaultSchema}_Committees].[ActionItem]
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
    SELECT * FROM [${flyway:defaultSchema}_Committees].[vwActionItems] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateActionItem] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Action Items */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateActionItem] TO [cdp_Developer], [cdp_Integration]



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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spUpdateActionItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateActionItem];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateActionItem]
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
        [${flyway:defaultSchema}_Committees].[ActionItem]
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
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_Committees].[vwActionItems] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_Committees].[vwActionItems]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateActionItem] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the ActionItem table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[trgUpdateActionItem]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_Committees].[trgUpdateActionItem];
GO
CREATE TRIGGER [${flyway:defaultSchema}_Committees].trgUpdateActionItem
ON [${flyway:defaultSchema}_Committees].[ActionItem]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[ActionItem]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_Committees].[ActionItem] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Action Items */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateActionItem] TO [cdp_Developer], [cdp_Integration]



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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spDeleteActionItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteActionItem];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteActionItem]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_Committees].[ActionItem]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteActionItem] TO [cdp_Integration]
    

/* spDelete Permissions for Action Items */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteActionItem] TO [cdp_Integration]



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
    mjCommitteesArtifactType_ArtifactTypeID.[Name] AS [ArtifactType],
    mjBizAppsCommonPerson_UploadedByPersonID.[DisplayName] AS [UploadedByPerson]
FROM
    [${flyway:defaultSchema}_Committees].[Artifact] AS a
LEFT OUTER JOIN
    [${flyway:defaultSchema}_Committees].[Committee] AS mjCommitteesCommittee_CommitteeID
  ON
    [a].[CommitteeID] = mjCommitteesCommittee_CommitteeID.[ID]
INNER JOIN
    [${flyway:defaultSchema}_Committees].[ArtifactType] AS mjCommitteesArtifactType_ArtifactTypeID
  ON
    [a].[ArtifactTypeID] = mjCommitteesArtifactType_ArtifactTypeID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[vwPeopleExtended] AS mjBizAppsCommonPerson_UploadedByPersonID
  ON
    [a].[UploadedByPersonID] = mjBizAppsCommonPerson_UploadedByPersonID.[ID]
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
        INSERT INTO [${flyway:defaultSchema}_Committees].[Artifact]
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
        INSERT INTO [${flyway:defaultSchema}_Committees].[Artifact]
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
        [${flyway:defaultSchema}_Committees].[Artifact]
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
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteArtifact] TO [cdp_Integration]
    

/* spDelete Permissions for Artifacts */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteArtifact] TO [cdp_Integration]



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

-- Index for foreign key ActionItemID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_ActionItemID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_ActionItemID ON [${flyway:defaultSchema}_Committees].[Comment] ([ActionItemID]);

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

/* SQL text to update entity field related entity name field map for entity field ID 1F907DBB-8D97-4E97-B16B-694F501ABD02 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='1F907DBB-8D97-4E97-B16B-694F501ABD02', @RelatedEntityNameFieldMap='Committee'

/* Index for Foreign Keys for Committee */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key TypeID in table Committee
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Committee_TypeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Committee]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Committee_TypeID ON [${flyway:defaultSchema}_Committees].[Committee] ([TypeID]);

-- Index for foreign key ParentCommitteeID in table Committee
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Committee_ParentCommitteeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Committee]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Committee_ParentCommitteeID ON [${flyway:defaultSchema}_Committees].[Committee] ([ParentCommitteeID]);

-- Index for foreign key OrganizationID in table Committee
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Committee_OrganizationID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Committee]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Committee_OrganizationID ON [${flyway:defaultSchema}_Committees].[Committee] ([OrganizationID]);

/* SQL text to update entity field related entity name field map for entity field ID 660C3DFB-2DA3-4FF2-AD1B-D581B22C64FB */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='660C3DFB-2DA3-4FF2-AD1B-D581B22C64FB', @RelatedEntityNameFieldMap='Type'

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

/* SQL text to update entity field related entity name field map for entity field ID 225EF45B-1EA5-4F13-BA96-D62419EC40A9 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='225EF45B-1EA5-4F13-BA96-D62419EC40A9', @RelatedEntityNameFieldMap='Committee'

/* Index for Foreign Keys for Membership */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Memberships
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key PersonID in table Membership
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Membership_PersonID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Membership]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Membership_PersonID ON [${flyway:defaultSchema}_Committees].[Membership] ([PersonID]);

-- Index for foreign key RoleID in table Membership
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Membership_RoleID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Membership]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Membership_RoleID ON [${flyway:defaultSchema}_Committees].[Membership] ([RoleID]);

-- Index for foreign key TermID in table Membership
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Membership_TermID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Membership]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Membership_TermID ON [${flyway:defaultSchema}_Committees].[Membership] ([TermID]);

/* SQL text to update entity field related entity name field map for entity field ID 53E824FA-C4A8-4106-9A41-79124B0E7096 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='53E824FA-C4A8-4106-9A41-79124B0E7096', @RelatedEntityNameFieldMap='Person'

/* Index for Foreign Keys for Minute */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Minutes
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key ApprovedByMeetingID in table Minute
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Minute_ApprovedByMeetingID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Minute]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Minute_ApprovedByMeetingID ON [${flyway:defaultSchema}_Committees].[Minute] ([ApprovedByMeetingID]);

-- Index for foreign key MeetingID in table Minute
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Minute_MeetingID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Minute]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Minute_MeetingID ON [${flyway:defaultSchema}_Committees].[Minute] ([MeetingID]);

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
-----               SCHEMA:      ${flyway:defaultSchema}_Committees
-----               BASE TABLE:  Minute
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[vwMinutes]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_Committees].[vwMinutes];
GO

CREATE VIEW [${flyway:defaultSchema}_Committees].[vwMinutes]
AS
SELECT
    m.*
FROM
    [${flyway:defaultSchema}_Committees].[Minute] AS m
GO
GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwMinutes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Minutes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Minutes
-- Item: Permissions for vwMinutes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwMinutes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spCreateMinute]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateMinute];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateMinute]
    @ID uniqueidentifier = NULL,
    @ArtifactID uniqueidentifier,
    @ApprovalStatus nvarchar(50) = NULL,
    @ApprovedAt datetimeoffset,
    @ApprovedByMeetingID uniqueidentifier,
    @Notes nvarchar(MAX),
    @MeetingID uniqueidentifier,
    @Content nvarchar(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_Committees].[Minute]
            (
                [ID],
                [ArtifactID],
                [ApprovalStatus],
                [ApprovedAt],
                [ApprovedByMeetingID],
                [Notes],
                [MeetingID],
                [Content]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @ArtifactID,
                ISNULL(@ApprovalStatus, 'Draft'),
                @ApprovedAt,
                @ApprovedByMeetingID,
                @Notes,
                @MeetingID,
                @Content
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_Committees].[Minute]
            (
                [ArtifactID],
                [ApprovalStatus],
                [ApprovedAt],
                [ApprovedByMeetingID],
                [Notes],
                [MeetingID],
                [Content]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ArtifactID,
                ISNULL(@ApprovalStatus, 'Draft'),
                @ApprovedAt,
                @ApprovedByMeetingID,
                @Notes,
                @MeetingID,
                @Content
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_Committees].[vwMinutes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateMinute] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Minutes */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateMinute] TO [cdp_Developer], [cdp_Integration]



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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spUpdateMinute]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateMinute];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateMinute]
    @ID uniqueidentifier,
    @ArtifactID uniqueidentifier,
    @ApprovalStatus nvarchar(50),
    @ApprovedAt datetimeoffset,
    @ApprovedByMeetingID uniqueidentifier,
    @Notes nvarchar(MAX),
    @MeetingID uniqueidentifier,
    @Content nvarchar(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Minute]
    SET
        [ArtifactID] = @ArtifactID,
        [ApprovalStatus] = @ApprovalStatus,
        [ApprovedAt] = @ApprovedAt,
        [ApprovedByMeetingID] = @ApprovedByMeetingID,
        [Notes] = @Notes,
        [MeetingID] = @MeetingID,
        [Content] = @Content
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_Committees].[vwMinutes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_Committees].[vwMinutes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateMinute] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Minute table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[trgUpdateMinute]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_Committees].[trgUpdateMinute];
GO
CREATE TRIGGER [${flyway:defaultSchema}_Committees].trgUpdateMinute
ON [${flyway:defaultSchema}_Committees].[Minute]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Minute]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_Committees].[Minute] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Minutes */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateMinute] TO [cdp_Developer], [cdp_Integration]



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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spDeleteMinute]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteMinute];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteMinute]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_Committees].[Minute]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteMinute] TO [cdp_Integration]
    

/* spDelete Permissions for Minutes */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteMinute] TO [cdp_Integration]



/* SQL text to update entity field related entity name field map for entity field ID 8B43E54C-FC73-4666-8EE4-207D77941F74 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='8B43E54C-FC73-4666-8EE4-207D77941F74', @RelatedEntityNameFieldMap='Role'

/* SQL text to update entity field related entity name field map for entity field ID CED94BB1-2B5D-4034-9060-8F5D679B66CE */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='CED94BB1-2B5D-4034-9060-8F5D679B66CE', @RelatedEntityNameFieldMap='ParentCommittee'

/* SQL text to update entity field related entity name field map for entity field ID 4961B896-9389-47B7-9488-66367098D7CC */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='4961B896-9389-47B7-9488-66367098D7CC', @RelatedEntityNameFieldMap='Person'

/* SQL text to update entity field related entity name field map for entity field ID 7B5571C3-69A1-4E82-9092-AF08A5485691 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='7B5571C3-69A1-4E82-9092-AF08A5485691', @RelatedEntityNameFieldMap='VideoProvider_Virtual'

/* SQL text to update entity field related entity name field map for entity field ID 1FA2B07A-257A-4665-B041-6D92C1AEC0BC */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='1FA2B07A-257A-4665-B041-6D92C1AEC0BC', @RelatedEntityNameFieldMap='Term'

/* SQL text to update entity field related entity name field map for entity field ID BA0A2BD5-DBFA-494E-97A9-000E4DC208E4 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='BA0A2BD5-DBFA-494E-97A9-000E4DC208E4', @RelatedEntityNameFieldMap='Organization'

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
    mjBizAppsCommonPerson_PersonID.[DisplayName] AS [Person],
    root_ParentCommentID.RootID AS [RootParentCommentID]
FROM
    [${flyway:defaultSchema}_Committees].[Comment] AS c
INNER JOIN
    [${flyway:defaultSchema}_Committees].[Committee] AS mjCommitteesCommittee_CommitteeID
  ON
    [c].[CommitteeID] = mjCommitteesCommittee_CommitteeID.[ID]
INNER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[vwPeopleExtended] AS mjBizAppsCommonPerson_PersonID
  ON
    [c].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
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
        INSERT INTO [${flyway:defaultSchema}_Committees].[Comment]
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
        INSERT INTO [${flyway:defaultSchema}_Committees].[Comment]
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
        [${flyway:defaultSchema}_Committees].[Comment]
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
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteComment] TO [cdp_Integration]
    

/* spDelete Permissions for Comments */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteComment] TO [cdp_Integration]



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
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteMeeting] TO [cdp_Integration]
    

/* spDelete Permissions for Meetings */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteMeeting] TO [cdp_Integration]



/* Root ID Function SQL for Committees.ParentCommitteeID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees
-- Item: fnCommitteeParentCommitteeID_GetRootID
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- ROOT ID FUNCTION FOR: [Committee].[ParentCommitteeID]
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[fnCommitteeParentCommitteeID_GetRootID]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}_Committees].[fnCommitteeParentCommitteeID_GetRootID];
GO

CREATE FUNCTION [${flyway:defaultSchema}_Committees].[fnCommitteeParentCommitteeID_GetRootID]
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
            [ParentCommitteeID],
            [ID] AS [RootParentID],
            0 AS [Depth]
        FROM
            [${flyway:defaultSchema}_Committees].[Committee]
        WHERE
            [ID] = COALESCE(@ParentID, @RecordID)

        UNION ALL

        SELECT
            c.[ID],
            c.[ParentCommitteeID],
            c.[ID] AS [RootParentID],
            p.[Depth] + 1 AS [Depth]
        FROM
            [${flyway:defaultSchema}_Committees].[Committee] c
        INNER JOIN
            CTE_RootParent p ON c.[ID] = p.[ParentCommitteeID]
        WHERE
            p.[Depth] < 100
    )
    SELECT TOP 1
        [RootParentID] AS RootID
    FROM
        CTE_RootParent
    WHERE
        [ParentCommitteeID] IS NULL
    ORDER BY
        [RootParentID]
);
GO


/* Base View SQL for Committees */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees
-- Item: vwCommittees
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees
-----               SCHEMA:      ${flyway:defaultSchema}_Committees
-----               BASE TABLE:  Committee
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[vwCommittees]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_Committees].[vwCommittees];
GO

CREATE VIEW [${flyway:defaultSchema}_Committees].[vwCommittees]
AS
SELECT
    c.*,
    mjCommitteesType_TypeID.[Name] AS [Type],
    mjCommitteesCommittee_ParentCommitteeID.[Name] AS [ParentCommittee],
    mjBizAppsCommonOrganization_OrganizationID.[Name] AS [Organization],
    root_ParentCommitteeID.RootID AS [RootParentCommitteeID]
FROM
    [${flyway:defaultSchema}_Committees].[Committee] AS c
INNER JOIN
    [${flyway:defaultSchema}_Committees].[Type] AS mjCommitteesType_TypeID
  ON
    [c].[TypeID] = mjCommitteesType_TypeID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}_Committees].[Committee] AS mjCommitteesCommittee_ParentCommitteeID
  ON
    [c].[ParentCommitteeID] = mjCommitteesCommittee_ParentCommitteeID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[Organization] AS mjBizAppsCommonOrganization_OrganizationID
  ON
    [c].[OrganizationID] = mjBizAppsCommonOrganization_OrganizationID.[ID]
OUTER APPLY
    [${flyway:defaultSchema}_Committees].[fnCommitteeParentCommitteeID_GetRootID]([c].[ID], [c].[ParentCommitteeID]) AS root_ParentCommitteeID
GO
GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwCommittees] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Committees */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees
-- Item: Permissions for vwCommittees
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwCommittees] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for Committees */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees
-- Item: spCreateCommittee
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Committee
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spCreateCommittee]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateCommittee];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateCommittee]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(255),
    @Description nvarchar(MAX),
    @TypeID uniqueidentifier,
    @ParentCommitteeID uniqueidentifier,
    @OrganizationID uniqueidentifier,
    @CharterDocumentURL nvarchar(1000),
    @MissionStatement nvarchar(MAX),
    @Status nvarchar(50) = NULL,
    @IsPublic bit = NULL,
    @FormationDate date,
    @DissolutionDate date
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_Committees].[Committee]
            (
                [ID],
                [Name],
                [Description],
                [TypeID],
                [ParentCommitteeID],
                [OrganizationID],
                [CharterDocumentURL],
                [MissionStatement],
                [Status],
                [IsPublic],
                [FormationDate],
                [DissolutionDate]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @Name,
                @Description,
                @TypeID,
                @ParentCommitteeID,
                @OrganizationID,
                @CharterDocumentURL,
                @MissionStatement,
                ISNULL(@Status, 'Active'),
                ISNULL(@IsPublic, 1),
                @FormationDate,
                @DissolutionDate
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_Committees].[Committee]
            (
                [Name],
                [Description],
                [TypeID],
                [ParentCommitteeID],
                [OrganizationID],
                [CharterDocumentURL],
                [MissionStatement],
                [Status],
                [IsPublic],
                [FormationDate],
                [DissolutionDate]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @Name,
                @Description,
                @TypeID,
                @ParentCommitteeID,
                @OrganizationID,
                @CharterDocumentURL,
                @MissionStatement,
                ISNULL(@Status, 'Active'),
                ISNULL(@IsPublic, 1),
                @FormationDate,
                @DissolutionDate
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_Committees].[vwCommittees] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateCommittee] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Committees */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateCommittee] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for Committees */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees
-- Item: spUpdateCommittee
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Committee
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spUpdateCommittee]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateCommittee];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateCommittee]
    @ID uniqueidentifier,
    @Name nvarchar(255),
    @Description nvarchar(MAX),
    @TypeID uniqueidentifier,
    @ParentCommitteeID uniqueidentifier,
    @OrganizationID uniqueidentifier,
    @CharterDocumentURL nvarchar(1000),
    @MissionStatement nvarchar(MAX),
    @Status nvarchar(50),
    @IsPublic bit,
    @FormationDate date,
    @DissolutionDate date
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Committee]
    SET
        [Name] = @Name,
        [Description] = @Description,
        [TypeID] = @TypeID,
        [ParentCommitteeID] = @ParentCommitteeID,
        [OrganizationID] = @OrganizationID,
        [CharterDocumentURL] = @CharterDocumentURL,
        [MissionStatement] = @MissionStatement,
        [Status] = @Status,
        [IsPublic] = @IsPublic,
        [FormationDate] = @FormationDate,
        [DissolutionDate] = @DissolutionDate
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_Committees].[vwCommittees] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_Committees].[vwCommittees]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateCommittee] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Committee table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[trgUpdateCommittee]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_Committees].[trgUpdateCommittee];
GO
CREATE TRIGGER [${flyway:defaultSchema}_Committees].trgUpdateCommittee
ON [${flyway:defaultSchema}_Committees].[Committee]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Committee]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_Committees].[Committee] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Committees */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateCommittee] TO [cdp_Developer], [cdp_Integration]



/* spDelete SQL for Committees */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees
-- Item: spDeleteCommittee
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Committee
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spDeleteCommittee]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteCommittee];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteCommittee]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_Committees].[Committee]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteCommittee] TO [cdp_Integration]
    

/* spDelete Permissions for Committees */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteCommittee] TO [cdp_Integration]



/* Base View SQL for Memberships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Memberships
-- Item: vwMemberships
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Memberships
-----               SCHEMA:      ${flyway:defaultSchema}_Committees
-----               BASE TABLE:  Membership
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[vwMemberships]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_Committees].[vwMemberships];
GO

CREATE VIEW [${flyway:defaultSchema}_Committees].[vwMemberships]
AS
SELECT
    m.*,
    mjBizAppsCommonPerson_PersonID.[DisplayName] AS [Person],
    mjCommitteesRole_RoleID.[Name] AS [Role],
    mjCommitteesTerm_TermID.[Name] AS [Term]
FROM
    [${flyway:defaultSchema}_Committees].[Membership] AS m
INNER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[vwPeopleExtended] AS mjBizAppsCommonPerson_PersonID
  ON
    [m].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
INNER JOIN
    [${flyway:defaultSchema}_Committees].[Role] AS mjCommitteesRole_RoleID
  ON
    [m].[RoleID] = mjCommitteesRole_RoleID.[ID]
INNER JOIN
    [${flyway:defaultSchema}_Committees].[Term] AS mjCommitteesTerm_TermID
  ON
    [m].[TermID] = mjCommitteesTerm_TermID.[ID]
GO
GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwMemberships] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Memberships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Memberships
-- Item: Permissions for vwMemberships
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwMemberships] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for Memberships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Memberships
-- Item: spCreateMembership
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Membership
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spCreateMembership]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateMembership];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateMembership]
    @ID uniqueidentifier = NULL,
    @PersonID uniqueidentifier,
    @RoleID uniqueidentifier,
    @TermID uniqueidentifier,
    @StartDate date,
    @EndDate date,
    @Status nvarchar(50) = NULL,
    @EndReason nvarchar(100),
    @Notes nvarchar(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_Committees].[Membership]
            (
                [ID],
                [PersonID],
                [RoleID],
                [TermID],
                [StartDate],
                [EndDate],
                [Status],
                [EndReason],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @PersonID,
                @RoleID,
                @TermID,
                @StartDate,
                @EndDate,
                ISNULL(@Status, 'Active'),
                @EndReason,
                @Notes
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_Committees].[Membership]
            (
                [PersonID],
                [RoleID],
                [TermID],
                [StartDate],
                [EndDate],
                [Status],
                [EndReason],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @PersonID,
                @RoleID,
                @TermID,
                @StartDate,
                @EndDate,
                ISNULL(@Status, 'Active'),
                @EndReason,
                @Notes
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_Committees].[vwMemberships] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateMembership] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Memberships */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateMembership] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for Memberships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Memberships
-- Item: spUpdateMembership
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Membership
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spUpdateMembership]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateMembership];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateMembership]
    @ID uniqueidentifier,
    @PersonID uniqueidentifier,
    @RoleID uniqueidentifier,
    @TermID uniqueidentifier,
    @StartDate date,
    @EndDate date,
    @Status nvarchar(50),
    @EndReason nvarchar(100),
    @Notes nvarchar(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Membership]
    SET
        [PersonID] = @PersonID,
        [RoleID] = @RoleID,
        [TermID] = @TermID,
        [StartDate] = @StartDate,
        [EndDate] = @EndDate,
        [Status] = @Status,
        [EndReason] = @EndReason,
        [Notes] = @Notes
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_Committees].[vwMemberships] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_Committees].[vwMemberships]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateMembership] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Membership table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[trgUpdateMembership]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_Committees].[trgUpdateMembership];
GO
CREATE TRIGGER [${flyway:defaultSchema}_Committees].trgUpdateMembership
ON [${flyway:defaultSchema}_Committees].[Membership]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Membership]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_Committees].[Membership] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Memberships */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateMembership] TO [cdp_Developer], [cdp_Integration]



/* spDelete SQL for Memberships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Memberships
-- Item: spDeleteMembership
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Membership
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spDeleteMembership]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteMembership];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteMembership]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_Committees].[Membership]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteMembership] TO [cdp_Integration]
    

/* spDelete Permissions for Memberships */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteMembership] TO [cdp_Integration]



/* Index for Foreign Keys for AddressLink */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Address Links
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key AddressID in table AddressLink
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_AddressLink_AddressID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[AddressLink]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_AddressLink_AddressID ON [${flyway:defaultSchema}_BizAppsCommon].[AddressLink] ([AddressID]);

-- Index for foreign key EntityID in table AddressLink
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_AddressLink_EntityID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[AddressLink]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_AddressLink_EntityID ON [${flyway:defaultSchema}_BizAppsCommon].[AddressLink] ([EntityID]);

-- Index for foreign key AddressTypeID in table AddressLink
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_AddressLink_AddressTypeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[AddressLink]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_AddressLink_AddressTypeID ON [${flyway:defaultSchema}_BizAppsCommon].[AddressLink] ([AddressTypeID]);

/* Index for Foreign Keys for AddressType */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Address Types
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------


/* Index for Foreign Keys for Address */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Addresses
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------


/* Index for Foreign Keys for ContactMethod */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Contact Methods
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key PersonID in table ContactMethod
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_ContactMethod_PersonID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[ContactMethod]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ContactMethod_PersonID ON [${flyway:defaultSchema}_BizAppsCommon].[ContactMethod] ([PersonID]);

-- Index for foreign key OrganizationID in table ContactMethod
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_ContactMethod_OrganizationID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[ContactMethod]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ContactMethod_OrganizationID ON [${flyway:defaultSchema}_BizAppsCommon].[ContactMethod] ([OrganizationID]);

-- Index for foreign key ContactTypeID in table ContactMethod
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_ContactMethod_ContactTypeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[ContactMethod]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ContactMethod_ContactTypeID ON [${flyway:defaultSchema}_BizAppsCommon].[ContactMethod] ([ContactTypeID]);

/* Index for Foreign Keys for ContactType */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Contact Types
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------


/* Base View SQL for MJ.BizApps.Common: Address Links */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Address Links
-- Item: vwAddressLinks
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      MJ.BizApps.Common: Address Links
-----               SCHEMA:      ${flyway:defaultSchema}_BizAppsCommon
-----               BASE TABLE:  AddressLink
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[vwAddressLinks]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_BizAppsCommon].[vwAddressLinks];
GO

CREATE VIEW [${flyway:defaultSchema}_BizAppsCommon].[vwAddressLinks]
AS
SELECT
    a.*,
    mjBizAppsCommonAddress_AddressID.[Line1] AS [Address],
    MJEntity_EntityID.[Name] AS [Entity],
    mjBizAppsCommonAddressType_AddressTypeID.[Name] AS [AddressType]
FROM
    [${flyway:defaultSchema}_BizAppsCommon].[AddressLink] AS a
INNER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[Address] AS mjBizAppsCommonAddress_AddressID
  ON
    [a].[AddressID] = mjBizAppsCommonAddress_AddressID.[ID]
INNER JOIN
    [${flyway:defaultSchema}].[Entity] AS MJEntity_EntityID
  ON
    [a].[EntityID] = MJEntity_EntityID.[ID]
INNER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[AddressType] AS mjBizAppsCommonAddressType_AddressTypeID
  ON
    [a].[AddressTypeID] = mjBizAppsCommonAddressType_AddressTypeID.[ID]
GO
GRANT SELECT ON [${flyway:defaultSchema}_BizAppsCommon].[vwAddressLinks] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for MJ.BizApps.Common: Address Links */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Address Links
-- Item: Permissions for vwAddressLinks
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_BizAppsCommon].[vwAddressLinks] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for MJ.BizApps.Common: Address Links */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Address Links
-- Item: spCreateAddressLink
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR AddressLink
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spCreateAddressLink]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreateAddressLink];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreateAddressLink]
    @ID uniqueidentifier = NULL,
    @AddressID uniqueidentifier,
    @EntityID uniqueidentifier,
    @RecordID nvarchar(700),
    @AddressTypeID uniqueidentifier,
    @IsPrimary bit = NULL,
    @Rank int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[AddressLink]
            (
                [ID],
                [AddressID],
                [EntityID],
                [RecordID],
                [AddressTypeID],
                [IsPrimary],
                [Rank]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @AddressID,
                @EntityID,
                @RecordID,
                @AddressTypeID,
                ISNULL(@IsPrimary, 0),
                @Rank
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[AddressLink]
            (
                [AddressID],
                [EntityID],
                [RecordID],
                [AddressTypeID],
                [IsPrimary],
                [Rank]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @AddressID,
                @EntityID,
                @RecordID,
                @AddressTypeID,
                ISNULL(@IsPrimary, 0),
                @Rank
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwAddressLinks] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreateAddressLink] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for MJ.BizApps.Common: Address Links */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreateAddressLink] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for MJ.BizApps.Common: Address Links */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Address Links
-- Item: spUpdateAddressLink
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR AddressLink
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spUpdateAddressLink]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdateAddressLink];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdateAddressLink]
    @ID uniqueidentifier,
    @AddressID uniqueidentifier,
    @EntityID uniqueidentifier,
    @RecordID nvarchar(700),
    @AddressTypeID uniqueidentifier,
    @IsPrimary bit,
    @Rank int
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[AddressLink]
    SET
        [AddressID] = @AddressID,
        [EntityID] = @EntityID,
        [RecordID] = @RecordID,
        [AddressTypeID] = @AddressTypeID,
        [IsPrimary] = @IsPrimary,
        [Rank] = @Rank
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwAddressLinks] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_BizAppsCommon].[vwAddressLinks]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdateAddressLink] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the AddressLink table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[trgUpdateAddressLink]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_BizAppsCommon].[trgUpdateAddressLink];
GO
CREATE TRIGGER [${flyway:defaultSchema}_BizAppsCommon].trgUpdateAddressLink
ON [${flyway:defaultSchema}_BizAppsCommon].[AddressLink]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[AddressLink]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_BizAppsCommon].[AddressLink] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for MJ.BizApps.Common: Address Links */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdateAddressLink] TO [cdp_Developer], [cdp_Integration]



/* Base View SQL for MJ.BizApps.Common: Address Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Address Types
-- Item: vwAddressTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      MJ.BizApps.Common: Address Types
-----               SCHEMA:      ${flyway:defaultSchema}_BizAppsCommon
-----               BASE TABLE:  AddressType
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[vwAddressTypes]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_BizAppsCommon].[vwAddressTypes];
GO

CREATE VIEW [${flyway:defaultSchema}_BizAppsCommon].[vwAddressTypes]
AS
SELECT
    a.*
FROM
    [${flyway:defaultSchema}_BizAppsCommon].[AddressType] AS a
GO
GRANT SELECT ON [${flyway:defaultSchema}_BizAppsCommon].[vwAddressTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for MJ.BizApps.Common: Address Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Address Types
-- Item: Permissions for vwAddressTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_BizAppsCommon].[vwAddressTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for MJ.BizApps.Common: Address Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Address Types
-- Item: spCreateAddressType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR AddressType
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spCreateAddressType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreateAddressType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreateAddressType]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(100),
    @Description nvarchar(MAX),
    @IconClass nvarchar(100),
    @DefaultRank int = NULL,
    @IsActive bit = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[AddressType]
            (
                [ID],
                [Name],
                [Description],
                [IconClass],
                [DefaultRank],
                [IsActive]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @Name,
                @Description,
                @IconClass,
                ISNULL(@DefaultRank, 100),
                ISNULL(@IsActive, 1)
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[AddressType]
            (
                [Name],
                [Description],
                [IconClass],
                [DefaultRank],
                [IsActive]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @Name,
                @Description,
                @IconClass,
                ISNULL(@DefaultRank, 100),
                ISNULL(@IsActive, 1)
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwAddressTypes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreateAddressType] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for MJ.BizApps.Common: Address Types */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreateAddressType] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for MJ.BizApps.Common: Address Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Address Types
-- Item: spUpdateAddressType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR AddressType
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spUpdateAddressType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdateAddressType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdateAddressType]
    @ID uniqueidentifier,
    @Name nvarchar(100),
    @Description nvarchar(MAX),
    @IconClass nvarchar(100),
    @DefaultRank int,
    @IsActive bit
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[AddressType]
    SET
        [Name] = @Name,
        [Description] = @Description,
        [IconClass] = @IconClass,
        [DefaultRank] = @DefaultRank,
        [IsActive] = @IsActive
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwAddressTypes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_BizAppsCommon].[vwAddressTypes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdateAddressType] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the AddressType table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[trgUpdateAddressType]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_BizAppsCommon].[trgUpdateAddressType];
GO
CREATE TRIGGER [${flyway:defaultSchema}_BizAppsCommon].trgUpdateAddressType
ON [${flyway:defaultSchema}_BizAppsCommon].[AddressType]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[AddressType]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_BizAppsCommon].[AddressType] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for MJ.BizApps.Common: Address Types */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdateAddressType] TO [cdp_Developer], [cdp_Integration]



/* Base View SQL for MJ.BizApps.Common: Addresses */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Addresses
-- Item: vwAddresses
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      MJ.BizApps.Common: Addresses
-----               SCHEMA:      ${flyway:defaultSchema}_BizAppsCommon
-----               BASE TABLE:  Address
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[vwAddresses]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_BizAppsCommon].[vwAddresses];
GO

CREATE VIEW [${flyway:defaultSchema}_BizAppsCommon].[vwAddresses]
AS
SELECT
    a.*
FROM
    [${flyway:defaultSchema}_BizAppsCommon].[Address] AS a
GO
GRANT SELECT ON [${flyway:defaultSchema}_BizAppsCommon].[vwAddresses] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for MJ.BizApps.Common: Addresses */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Addresses
-- Item: Permissions for vwAddresses
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_BizAppsCommon].[vwAddresses] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for MJ.BizApps.Common: Addresses */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Addresses
-- Item: spCreateAddress
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Address
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spCreateAddress]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreateAddress];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreateAddress]
    @ID uniqueidentifier = NULL,
    @Line1 nvarchar(255),
    @Line2 nvarchar(255),
    @Line3 nvarchar(255),
    @City nvarchar(100),
    @StateProvince nvarchar(100),
    @PostalCode nvarchar(20),
    @Country nvarchar(100) = NULL,
    @Latitude decimal(9, 6),
    @Longitude decimal(9, 6)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[Address]
            (
                [ID],
                [Line1],
                [Line2],
                [Line3],
                [City],
                [StateProvince],
                [PostalCode],
                [Country],
                [Latitude],
                [Longitude]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @Line1,
                @Line2,
                @Line3,
                @City,
                @StateProvince,
                @PostalCode,
                ISNULL(@Country, 'US'),
                @Latitude,
                @Longitude
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[Address]
            (
                [Line1],
                [Line2],
                [Line3],
                [City],
                [StateProvince],
                [PostalCode],
                [Country],
                [Latitude],
                [Longitude]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @Line1,
                @Line2,
                @Line3,
                @City,
                @StateProvince,
                @PostalCode,
                ISNULL(@Country, 'US'),
                @Latitude,
                @Longitude
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwAddresses] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreateAddress] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for MJ.BizApps.Common: Addresses */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreateAddress] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for MJ.BizApps.Common: Addresses */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Addresses
-- Item: spUpdateAddress
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Address
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spUpdateAddress]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdateAddress];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdateAddress]
    @ID uniqueidentifier,
    @Line1 nvarchar(255),
    @Line2 nvarchar(255),
    @Line3 nvarchar(255),
    @City nvarchar(100),
    @StateProvince nvarchar(100),
    @PostalCode nvarchar(20),
    @Country nvarchar(100),
    @Latitude decimal(9, 6),
    @Longitude decimal(9, 6)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[Address]
    SET
        [Line1] = @Line1,
        [Line2] = @Line2,
        [Line3] = @Line3,
        [City] = @City,
        [StateProvince] = @StateProvince,
        [PostalCode] = @PostalCode,
        [Country] = @Country,
        [Latitude] = @Latitude,
        [Longitude] = @Longitude
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwAddresses] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_BizAppsCommon].[vwAddresses]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdateAddress] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Address table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[trgUpdateAddress]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_BizAppsCommon].[trgUpdateAddress];
GO
CREATE TRIGGER [${flyway:defaultSchema}_BizAppsCommon].trgUpdateAddress
ON [${flyway:defaultSchema}_BizAppsCommon].[Address]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[Address]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_BizAppsCommon].[Address] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for MJ.BizApps.Common: Addresses */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdateAddress] TO [cdp_Developer], [cdp_Integration]



/* Base View SQL for MJ.BizApps.Common: Contact Methods */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Contact Methods
-- Item: vwContactMethods
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      MJ.BizApps.Common: Contact Methods
-----               SCHEMA:      ${flyway:defaultSchema}_BizAppsCommon
-----               BASE TABLE:  ContactMethod
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[vwContactMethods]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_BizAppsCommon].[vwContactMethods];
GO

CREATE VIEW [${flyway:defaultSchema}_BizAppsCommon].[vwContactMethods]
AS
SELECT
    c.*,
    mjBizAppsCommonPerson_PersonID.[DisplayName] AS [Person],
    mjBizAppsCommonOrganization_OrganizationID.[Name] AS [Organization],
    mjBizAppsCommonContactType_ContactTypeID.[Name] AS [ContactType]
FROM
    [${flyway:defaultSchema}_BizAppsCommon].[ContactMethod] AS c
LEFT OUTER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[vwPeopleExtended] AS mjBizAppsCommonPerson_PersonID
  ON
    [c].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[Organization] AS mjBizAppsCommonOrganization_OrganizationID
  ON
    [c].[OrganizationID] = mjBizAppsCommonOrganization_OrganizationID.[ID]
INNER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[ContactType] AS mjBizAppsCommonContactType_ContactTypeID
  ON
    [c].[ContactTypeID] = mjBizAppsCommonContactType_ContactTypeID.[ID]
GO
GRANT SELECT ON [${flyway:defaultSchema}_BizAppsCommon].[vwContactMethods] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for MJ.BizApps.Common: Contact Methods */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Contact Methods
-- Item: Permissions for vwContactMethods
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_BizAppsCommon].[vwContactMethods] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for MJ.BizApps.Common: Contact Methods */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Contact Methods
-- Item: spCreateContactMethod
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR ContactMethod
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spCreateContactMethod]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreateContactMethod];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreateContactMethod]
    @ID uniqueidentifier = NULL,
    @PersonID uniqueidentifier,
    @OrganizationID uniqueidentifier,
    @ContactTypeID uniqueidentifier,
    @Value nvarchar(500),
    @Label nvarchar(100),
    @IsPrimary bit = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[ContactMethod]
            (
                [ID],
                [PersonID],
                [OrganizationID],
                [ContactTypeID],
                [Value],
                [Label],
                [IsPrimary]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @PersonID,
                @OrganizationID,
                @ContactTypeID,
                @Value,
                @Label,
                ISNULL(@IsPrimary, 0)
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[ContactMethod]
            (
                [PersonID],
                [OrganizationID],
                [ContactTypeID],
                [Value],
                [Label],
                [IsPrimary]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @PersonID,
                @OrganizationID,
                @ContactTypeID,
                @Value,
                @Label,
                ISNULL(@IsPrimary, 0)
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwContactMethods] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreateContactMethod] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for MJ.BizApps.Common: Contact Methods */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreateContactMethod] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for MJ.BizApps.Common: Contact Methods */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Contact Methods
-- Item: spUpdateContactMethod
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR ContactMethod
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spUpdateContactMethod]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdateContactMethod];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdateContactMethod]
    @ID uniqueidentifier,
    @PersonID uniqueidentifier,
    @OrganizationID uniqueidentifier,
    @ContactTypeID uniqueidentifier,
    @Value nvarchar(500),
    @Label nvarchar(100),
    @IsPrimary bit
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[ContactMethod]
    SET
        [PersonID] = @PersonID,
        [OrganizationID] = @OrganizationID,
        [ContactTypeID] = @ContactTypeID,
        [Value] = @Value,
        [Label] = @Label,
        [IsPrimary] = @IsPrimary
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwContactMethods] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_BizAppsCommon].[vwContactMethods]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdateContactMethod] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the ContactMethod table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[trgUpdateContactMethod]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_BizAppsCommon].[trgUpdateContactMethod];
GO
CREATE TRIGGER [${flyway:defaultSchema}_BizAppsCommon].trgUpdateContactMethod
ON [${flyway:defaultSchema}_BizAppsCommon].[ContactMethod]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[ContactMethod]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_BizAppsCommon].[ContactMethod] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for MJ.BizApps.Common: Contact Methods */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdateContactMethod] TO [cdp_Developer], [cdp_Integration]



/* Base View SQL for MJ.BizApps.Common: Contact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Contact Types
-- Item: vwContactTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      MJ.BizApps.Common: Contact Types
-----               SCHEMA:      ${flyway:defaultSchema}_BizAppsCommon
-----               BASE TABLE:  ContactType
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[vwContactTypes]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_BizAppsCommon].[vwContactTypes];
GO

CREATE VIEW [${flyway:defaultSchema}_BizAppsCommon].[vwContactTypes]
AS
SELECT
    c.*
FROM
    [${flyway:defaultSchema}_BizAppsCommon].[ContactType] AS c
GO
GRANT SELECT ON [${flyway:defaultSchema}_BizAppsCommon].[vwContactTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for MJ.BizApps.Common: Contact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Contact Types
-- Item: Permissions for vwContactTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_BizAppsCommon].[vwContactTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for MJ.BizApps.Common: Contact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Contact Types
-- Item: spCreateContactType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR ContactType
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spCreateContactType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreateContactType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreateContactType]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(100),
    @Description nvarchar(MAX),
    @IconClass nvarchar(100),
    @DisplayRank int = NULL,
    @IsActive bit = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[ContactType]
            (
                [ID],
                [Name],
                [Description],
                [IconClass],
                [DisplayRank],
                [IsActive]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @Name,
                @Description,
                @IconClass,
                ISNULL(@DisplayRank, 100),
                ISNULL(@IsActive, 1)
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[ContactType]
            (
                [Name],
                [Description],
                [IconClass],
                [DisplayRank],
                [IsActive]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @Name,
                @Description,
                @IconClass,
                ISNULL(@DisplayRank, 100),
                ISNULL(@IsActive, 1)
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwContactTypes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreateContactType] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for MJ.BizApps.Common: Contact Types */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreateContactType] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for MJ.BizApps.Common: Contact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Contact Types
-- Item: spUpdateContactType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR ContactType
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spUpdateContactType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdateContactType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdateContactType]
    @ID uniqueidentifier,
    @Name nvarchar(100),
    @Description nvarchar(MAX),
    @IconClass nvarchar(100),
    @DisplayRank int,
    @IsActive bit
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[ContactType]
    SET
        [Name] = @Name,
        [Description] = @Description,
        [IconClass] = @IconClass,
        [DisplayRank] = @DisplayRank,
        [IsActive] = @IsActive
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwContactTypes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_BizAppsCommon].[vwContactTypes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdateContactType] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the ContactType table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[trgUpdateContactType]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_BizAppsCommon].[trgUpdateContactType];
GO
CREATE TRIGGER [${flyway:defaultSchema}_BizAppsCommon].trgUpdateContactType
ON [${flyway:defaultSchema}_BizAppsCommon].[ContactType]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[ContactType]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_BizAppsCommon].[ContactType] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for MJ.BizApps.Common: Contact Types */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdateContactType] TO [cdp_Developer], [cdp_Integration]



/* spDelete SQL for MJ.BizApps.Common: Address Links */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Address Links
-- Item: spDeleteAddressLink
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR AddressLink
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spDeleteAddressLink]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeleteAddressLink];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeleteAddressLink]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_BizAppsCommon].[AddressLink]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeleteAddressLink] TO [cdp_Integration]
    

/* spDelete Permissions for MJ.BizApps.Common: Address Links */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeleteAddressLink] TO [cdp_Integration]



/* spDelete SQL for MJ.BizApps.Common: Address Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Address Types
-- Item: spDeleteAddressType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR AddressType
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spDeleteAddressType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeleteAddressType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeleteAddressType]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_BizAppsCommon].[AddressType]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeleteAddressType] TO [cdp_Integration]
    

/* spDelete Permissions for MJ.BizApps.Common: Address Types */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeleteAddressType] TO [cdp_Integration]



/* spDelete SQL for MJ.BizApps.Common: Addresses */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Addresses
-- Item: spDeleteAddress
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Address
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spDeleteAddress]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeleteAddress];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeleteAddress]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_BizAppsCommon].[Address]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeleteAddress] TO [cdp_Integration]
    

/* spDelete Permissions for MJ.BizApps.Common: Addresses */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeleteAddress] TO [cdp_Integration]



/* spDelete SQL for MJ.BizApps.Common: Contact Methods */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Contact Methods
-- Item: spDeleteContactMethod
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR ContactMethod
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spDeleteContactMethod]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeleteContactMethod];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeleteContactMethod]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_BizAppsCommon].[ContactMethod]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeleteContactMethod] TO [cdp_Integration]
    

/* spDelete Permissions for MJ.BizApps.Common: Contact Methods */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeleteContactMethod] TO [cdp_Integration]



/* spDelete SQL for MJ.BizApps.Common: Contact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Contact Types
-- Item: spDeleteContactType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR ContactType
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spDeleteContactType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeleteContactType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeleteContactType]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_BizAppsCommon].[ContactType]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeleteContactType] TO [cdp_Integration]
    

/* spDelete Permissions for MJ.BizApps.Common: Contact Types */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeleteContactType] TO [cdp_Integration]



/* Index for Foreign Keys for OrganizationType */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Organization Types
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------


/* Index for Foreign Keys for Organization */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Organizations
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key OrganizationTypeID in table Organization
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Organization_OrganizationTypeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[Organization]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Organization_OrganizationTypeID ON [${flyway:defaultSchema}_BizAppsCommon].[Organization] ([OrganizationTypeID]);

-- Index for foreign key ParentID in table Organization
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Organization_ParentID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[Organization]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Organization_ParentID ON [${flyway:defaultSchema}_BizAppsCommon].[Organization] ([ParentID]);

/* Base View Permissions SQL for MJ.BizApps.Common: Organizations */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Organizations
-- Item: Permissions for vwOrganizationsExtended
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_BizAppsCommon].[vwOrganizationsExtended] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for MJ.BizApps.Common: Organizations */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Organizations
-- Item: spCreateOrganization
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Organization
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spCreateOrganization]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreateOrganization];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreateOrganization]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(255),
    @LegalName nvarchar(255),
    @OrganizationTypeID uniqueidentifier,
    @ParentID uniqueidentifier,
    @Website nvarchar(1000),
    @LogoURL nvarchar(1000),
    @Description nvarchar(MAX),
    @Email nvarchar(255),
    @Phone nvarchar(50),
    @FoundedDate date,
    @TaxID nvarchar(50),
    @Status nvarchar(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[Organization]
            (
                [ID],
                [Name],
                [LegalName],
                [OrganizationTypeID],
                [ParentID],
                [Website],
                [LogoURL],
                [Description],
                [Email],
                [Phone],
                [FoundedDate],
                [TaxID],
                [Status]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @Name,
                @LegalName,
                @OrganizationTypeID,
                @ParentID,
                @Website,
                @LogoURL,
                @Description,
                @Email,
                @Phone,
                @FoundedDate,
                @TaxID,
                ISNULL(@Status, 'Active')
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[Organization]
            (
                [Name],
                [LegalName],
                [OrganizationTypeID],
                [ParentID],
                [Website],
                [LogoURL],
                [Description],
                [Email],
                [Phone],
                [FoundedDate],
                [TaxID],
                [Status]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @Name,
                @LegalName,
                @OrganizationTypeID,
                @ParentID,
                @Website,
                @LogoURL,
                @Description,
                @Email,
                @Phone,
                @FoundedDate,
                @TaxID,
                ISNULL(@Status, 'Active')
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwOrganizationsExtended] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreateOrganization] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for MJ.BizApps.Common: Organizations */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreateOrganization] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for MJ.BizApps.Common: Organizations */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Organizations
-- Item: spUpdateOrganization
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Organization
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spUpdateOrganization]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdateOrganization];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdateOrganization]
    @ID uniqueidentifier,
    @Name nvarchar(255),
    @LegalName nvarchar(255),
    @OrganizationTypeID uniqueidentifier,
    @ParentID uniqueidentifier,
    @Website nvarchar(1000),
    @LogoURL nvarchar(1000),
    @Description nvarchar(MAX),
    @Email nvarchar(255),
    @Phone nvarchar(50),
    @FoundedDate date,
    @TaxID nvarchar(50),
    @Status nvarchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[Organization]
    SET
        [Name] = @Name,
        [LegalName] = @LegalName,
        [OrganizationTypeID] = @OrganizationTypeID,
        [ParentID] = @ParentID,
        [Website] = @Website,
        [LogoURL] = @LogoURL,
        [Description] = @Description,
        [Email] = @Email,
        [Phone] = @Phone,
        [FoundedDate] = @FoundedDate,
        [TaxID] = @TaxID,
        [Status] = @Status
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwOrganizationsExtended] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_BizAppsCommon].[vwOrganizationsExtended]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdateOrganization] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Organization table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[trgUpdateOrganization]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_BizAppsCommon].[trgUpdateOrganization];
GO
CREATE TRIGGER [${flyway:defaultSchema}_BizAppsCommon].trgUpdateOrganization
ON [${flyway:defaultSchema}_BizAppsCommon].[Organization]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[Organization]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_BizAppsCommon].[Organization] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for MJ.BizApps.Common: Organizations */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdateOrganization] TO [cdp_Developer], [cdp_Integration]



/* Index for Foreign Keys for Person */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: People
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key LinkedUserID in table Person
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Person_LinkedUserID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[Person]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Person_LinkedUserID ON [${flyway:defaultSchema}_BizAppsCommon].[Person] ([LinkedUserID]);

/* Base View Permissions SQL for MJ.BizApps.Common: People */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: People
-- Item: Permissions for vwPeopleExtended
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_BizAppsCommon].[vwPeopleExtended] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for MJ.BizApps.Common: People */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: People
-- Item: spCreatePerson
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Person
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spCreatePerson]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreatePerson];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreatePerson]
    @ID uniqueidentifier = NULL,
    @FirstName nvarchar(100),
    @LastName nvarchar(100),
    @MiddleName nvarchar(100),
    @Prefix nvarchar(20),
    @Suffix nvarchar(20),
    @PreferredName nvarchar(100),
    @Title nvarchar(200),
    @Email nvarchar(255),
    @Phone nvarchar(50),
    @DateOfBirth date,
    @Gender nvarchar(50),
    @PhotoURL nvarchar(1000),
    @Bio nvarchar(MAX),
    @LinkedUserID uniqueidentifier,
    @Status nvarchar(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[Person]
            (
                [ID],
                [FirstName],
                [LastName],
                [MiddleName],
                [Prefix],
                [Suffix],
                [PreferredName],
                [Title],
                [Email],
                [Phone],
                [DateOfBirth],
                [Gender],
                [PhotoURL],
                [Bio],
                [LinkedUserID],
                [Status]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @FirstName,
                @LastName,
                @MiddleName,
                @Prefix,
                @Suffix,
                @PreferredName,
                @Title,
                @Email,
                @Phone,
                @DateOfBirth,
                @Gender,
                @PhotoURL,
                @Bio,
                @LinkedUserID,
                ISNULL(@Status, 'Active')
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[Person]
            (
                [FirstName],
                [LastName],
                [MiddleName],
                [Prefix],
                [Suffix],
                [PreferredName],
                [Title],
                [Email],
                [Phone],
                [DateOfBirth],
                [Gender],
                [PhotoURL],
                [Bio],
                [LinkedUserID],
                [Status]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @FirstName,
                @LastName,
                @MiddleName,
                @Prefix,
                @Suffix,
                @PreferredName,
                @Title,
                @Email,
                @Phone,
                @DateOfBirth,
                @Gender,
                @PhotoURL,
                @Bio,
                @LinkedUserID,
                ISNULL(@Status, 'Active')
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwPeopleExtended] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreatePerson] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for MJ.BizApps.Common: People */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreatePerson] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for MJ.BizApps.Common: People */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: People
-- Item: spUpdatePerson
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Person
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spUpdatePerson]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdatePerson];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdatePerson]
    @ID uniqueidentifier,
    @FirstName nvarchar(100),
    @LastName nvarchar(100),
    @MiddleName nvarchar(100),
    @Prefix nvarchar(20),
    @Suffix nvarchar(20),
    @PreferredName nvarchar(100),
    @Title nvarchar(200),
    @Email nvarchar(255),
    @Phone nvarchar(50),
    @DateOfBirth date,
    @Gender nvarchar(50),
    @PhotoURL nvarchar(1000),
    @Bio nvarchar(MAX),
    @LinkedUserID uniqueidentifier,
    @Status nvarchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[Person]
    SET
        [FirstName] = @FirstName,
        [LastName] = @LastName,
        [MiddleName] = @MiddleName,
        [Prefix] = @Prefix,
        [Suffix] = @Suffix,
        [PreferredName] = @PreferredName,
        [Title] = @Title,
        [Email] = @Email,
        [Phone] = @Phone,
        [DateOfBirth] = @DateOfBirth,
        [Gender] = @Gender,
        [PhotoURL] = @PhotoURL,
        [Bio] = @Bio,
        [LinkedUserID] = @LinkedUserID,
        [Status] = @Status
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwPeopleExtended] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_BizAppsCommon].[vwPeopleExtended]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdatePerson] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Person table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[trgUpdatePerson]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_BizAppsCommon].[trgUpdatePerson];
GO
CREATE TRIGGER [${flyway:defaultSchema}_BizAppsCommon].trgUpdatePerson
ON [${flyway:defaultSchema}_BizAppsCommon].[Person]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[Person]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_BizAppsCommon].[Person] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for MJ.BizApps.Common: People */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdatePerson] TO [cdp_Developer], [cdp_Integration]



/* Index for Foreign Keys for RelationshipType */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Relationship Types
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------


/* Index for Foreign Keys for Relationship */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Relationships
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key RelationshipTypeID in table Relationship
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Relationship_RelationshipTypeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[Relationship]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Relationship_RelationshipTypeID ON [${flyway:defaultSchema}_BizAppsCommon].[Relationship] ([RelationshipTypeID]);

-- Index for foreign key FromPersonID in table Relationship
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Relationship_FromPersonID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[Relationship]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Relationship_FromPersonID ON [${flyway:defaultSchema}_BizAppsCommon].[Relationship] ([FromPersonID]);

-- Index for foreign key FromOrganizationID in table Relationship
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Relationship_FromOrganizationID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[Relationship]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Relationship_FromOrganizationID ON [${flyway:defaultSchema}_BizAppsCommon].[Relationship] ([FromOrganizationID]);

-- Index for foreign key ToPersonID in table Relationship
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Relationship_ToPersonID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[Relationship]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Relationship_ToPersonID ON [${flyway:defaultSchema}_BizAppsCommon].[Relationship] ([ToPersonID]);

-- Index for foreign key ToOrganizationID in table Relationship
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Relationship_ToOrganizationID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[Relationship]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Relationship_ToOrganizationID ON [${flyway:defaultSchema}_BizAppsCommon].[Relationship] ([ToOrganizationID]);

/* spDelete SQL for MJ.BizApps.Common: Organizations */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Organizations
-- Item: spDeleteOrganization
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Organization
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spDeleteOrganization]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeleteOrganization];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeleteOrganization]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_BizAppsCommon].[Organization]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeleteOrganization] TO [cdp_Integration]
    

/* spDelete Permissions for MJ.BizApps.Common: Organizations */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeleteOrganization] TO [cdp_Integration]



/* spDelete SQL for MJ.BizApps.Common: People */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: People
-- Item: spDeletePerson
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Person
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spDeletePerson]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeletePerson];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeletePerson]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_BizAppsCommon].[Person]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeletePerson] TO [cdp_Integration]
    

/* spDelete Permissions for MJ.BizApps.Common: People */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeletePerson] TO [cdp_Integration]



/* Base View SQL for MJ.BizApps.Common: Organization Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Organization Types
-- Item: vwOrganizationTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      MJ.BizApps.Common: Organization Types
-----               SCHEMA:      ${flyway:defaultSchema}_BizAppsCommon
-----               BASE TABLE:  OrganizationType
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[vwOrganizationTypes]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_BizAppsCommon].[vwOrganizationTypes];
GO

CREATE VIEW [${flyway:defaultSchema}_BizAppsCommon].[vwOrganizationTypes]
AS
SELECT
    o.*
FROM
    [${flyway:defaultSchema}_BizAppsCommon].[OrganizationType] AS o
GO
GRANT SELECT ON [${flyway:defaultSchema}_BizAppsCommon].[vwOrganizationTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for MJ.BizApps.Common: Organization Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Organization Types
-- Item: Permissions for vwOrganizationTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_BizAppsCommon].[vwOrganizationTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for MJ.BizApps.Common: Organization Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Organization Types
-- Item: spCreateOrganizationType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR OrganizationType
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spCreateOrganizationType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreateOrganizationType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreateOrganizationType]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(100),
    @Description nvarchar(MAX),
    @IconClass nvarchar(100),
    @DisplayRank int = NULL,
    @IsActive bit = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[OrganizationType]
            (
                [ID],
                [Name],
                [Description],
                [IconClass],
                [DisplayRank],
                [IsActive]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @Name,
                @Description,
                @IconClass,
                ISNULL(@DisplayRank, 100),
                ISNULL(@IsActive, 1)
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[OrganizationType]
            (
                [Name],
                [Description],
                [IconClass],
                [DisplayRank],
                [IsActive]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @Name,
                @Description,
                @IconClass,
                ISNULL(@DisplayRank, 100),
                ISNULL(@IsActive, 1)
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwOrganizationTypes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreateOrganizationType] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for MJ.BizApps.Common: Organization Types */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreateOrganizationType] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for MJ.BizApps.Common: Organization Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Organization Types
-- Item: spUpdateOrganizationType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR OrganizationType
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spUpdateOrganizationType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdateOrganizationType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdateOrganizationType]
    @ID uniqueidentifier,
    @Name nvarchar(100),
    @Description nvarchar(MAX),
    @IconClass nvarchar(100),
    @DisplayRank int,
    @IsActive bit
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[OrganizationType]
    SET
        [Name] = @Name,
        [Description] = @Description,
        [IconClass] = @IconClass,
        [DisplayRank] = @DisplayRank,
        [IsActive] = @IsActive
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwOrganizationTypes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_BizAppsCommon].[vwOrganizationTypes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdateOrganizationType] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the OrganizationType table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[trgUpdateOrganizationType]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_BizAppsCommon].[trgUpdateOrganizationType];
GO
CREATE TRIGGER [${flyway:defaultSchema}_BizAppsCommon].trgUpdateOrganizationType
ON [${flyway:defaultSchema}_BizAppsCommon].[OrganizationType]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[OrganizationType]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_BizAppsCommon].[OrganizationType] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for MJ.BizApps.Common: Organization Types */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdateOrganizationType] TO [cdp_Developer], [cdp_Integration]



/* Base View SQL for MJ.BizApps.Common: Relationship Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Relationship Types
-- Item: vwRelationshipTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      MJ.BizApps.Common: Relationship Types
-----               SCHEMA:      ${flyway:defaultSchema}_BizAppsCommon
-----               BASE TABLE:  RelationshipType
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[vwRelationshipTypes]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_BizAppsCommon].[vwRelationshipTypes];
GO

CREATE VIEW [${flyway:defaultSchema}_BizAppsCommon].[vwRelationshipTypes]
AS
SELECT
    r.*
FROM
    [${flyway:defaultSchema}_BizAppsCommon].[RelationshipType] AS r
GO
GRANT SELECT ON [${flyway:defaultSchema}_BizAppsCommon].[vwRelationshipTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for MJ.BizApps.Common: Relationship Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Relationship Types
-- Item: Permissions for vwRelationshipTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_BizAppsCommon].[vwRelationshipTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for MJ.BizApps.Common: Relationship Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Relationship Types
-- Item: spCreateRelationshipType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR RelationshipType
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spCreateRelationshipType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreateRelationshipType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreateRelationshipType]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(100),
    @Description nvarchar(MAX),
    @Category nvarchar(50),
    @IsDirectional bit = NULL,
    @ForwardLabel nvarchar(100),
    @ReverseLabel nvarchar(100),
    @IsActive bit = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[RelationshipType]
            (
                [ID],
                [Name],
                [Description],
                [Category],
                [IsDirectional],
                [ForwardLabel],
                [ReverseLabel],
                [IsActive]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @Name,
                @Description,
                @Category,
                ISNULL(@IsDirectional, 1),
                @ForwardLabel,
                @ReverseLabel,
                ISNULL(@IsActive, 1)
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[RelationshipType]
            (
                [Name],
                [Description],
                [Category],
                [IsDirectional],
                [ForwardLabel],
                [ReverseLabel],
                [IsActive]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @Name,
                @Description,
                @Category,
                ISNULL(@IsDirectional, 1),
                @ForwardLabel,
                @ReverseLabel,
                ISNULL(@IsActive, 1)
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwRelationshipTypes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreateRelationshipType] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for MJ.BizApps.Common: Relationship Types */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreateRelationshipType] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for MJ.BizApps.Common: Relationship Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Relationship Types
-- Item: spUpdateRelationshipType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR RelationshipType
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spUpdateRelationshipType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdateRelationshipType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdateRelationshipType]
    @ID uniqueidentifier,
    @Name nvarchar(100),
    @Description nvarchar(MAX),
    @Category nvarchar(50),
    @IsDirectional bit,
    @ForwardLabel nvarchar(100),
    @ReverseLabel nvarchar(100),
    @IsActive bit
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[RelationshipType]
    SET
        [Name] = @Name,
        [Description] = @Description,
        [Category] = @Category,
        [IsDirectional] = @IsDirectional,
        [ForwardLabel] = @ForwardLabel,
        [ReverseLabel] = @ReverseLabel,
        [IsActive] = @IsActive
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwRelationshipTypes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_BizAppsCommon].[vwRelationshipTypes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdateRelationshipType] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the RelationshipType table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[trgUpdateRelationshipType]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_BizAppsCommon].[trgUpdateRelationshipType];
GO
CREATE TRIGGER [${flyway:defaultSchema}_BizAppsCommon].trgUpdateRelationshipType
ON [${flyway:defaultSchema}_BizAppsCommon].[RelationshipType]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[RelationshipType]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_BizAppsCommon].[RelationshipType] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for MJ.BizApps.Common: Relationship Types */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdateRelationshipType] TO [cdp_Developer], [cdp_Integration]



/* Base View SQL for MJ.BizApps.Common: Relationships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Relationships
-- Item: vwRelationships
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      MJ.BizApps.Common: Relationships
-----               SCHEMA:      ${flyway:defaultSchema}_BizAppsCommon
-----               BASE TABLE:  Relationship
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[vwRelationships]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_BizAppsCommon].[vwRelationships];
GO

CREATE VIEW [${flyway:defaultSchema}_BizAppsCommon].[vwRelationships]
AS
SELECT
    r.*,
    mjBizAppsCommonRelationshipType_RelationshipTypeID.[Name] AS [RelationshipType],
    mjBizAppsCommonPerson_FromPersonID.[DisplayName] AS [FromPerson],
    mjBizAppsCommonOrganization_FromOrganizationID.[Name] AS [FromOrganization],
    mjBizAppsCommonPerson_ToPersonID.[DisplayName] AS [ToPerson],
    mjBizAppsCommonOrganization_ToOrganizationID.[Name] AS [ToOrganization]
FROM
    [${flyway:defaultSchema}_BizAppsCommon].[Relationship] AS r
INNER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[RelationshipType] AS mjBizAppsCommonRelationshipType_RelationshipTypeID
  ON
    [r].[RelationshipTypeID] = mjBizAppsCommonRelationshipType_RelationshipTypeID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[vwPeopleExtended] AS mjBizAppsCommonPerson_FromPersonID
  ON
    [r].[FromPersonID] = mjBizAppsCommonPerson_FromPersonID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[Organization] AS mjBizAppsCommonOrganization_FromOrganizationID
  ON
    [r].[FromOrganizationID] = mjBizAppsCommonOrganization_FromOrganizationID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[vwPeopleExtended] AS mjBizAppsCommonPerson_ToPersonID
  ON
    [r].[ToPersonID] = mjBizAppsCommonPerson_ToPersonID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[Organization] AS mjBizAppsCommonOrganization_ToOrganizationID
  ON
    [r].[ToOrganizationID] = mjBizAppsCommonOrganization_ToOrganizationID.[ID]
GO
GRANT SELECT ON [${flyway:defaultSchema}_BizAppsCommon].[vwRelationships] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for MJ.BizApps.Common: Relationships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Relationships
-- Item: Permissions for vwRelationships
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_BizAppsCommon].[vwRelationships] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for MJ.BizApps.Common: Relationships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Relationships
-- Item: spCreateRelationship
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Relationship
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spCreateRelationship]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreateRelationship];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spCreateRelationship]
    @ID uniqueidentifier = NULL,
    @RelationshipTypeID uniqueidentifier,
    @FromPersonID uniqueidentifier,
    @FromOrganizationID uniqueidentifier,
    @ToPersonID uniqueidentifier,
    @ToOrganizationID uniqueidentifier,
    @Title nvarchar(255),
    @StartDate date,
    @EndDate date,
    @Status nvarchar(50) = NULL,
    @Notes nvarchar(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[Relationship]
            (
                [ID],
                [RelationshipTypeID],
                [FromPersonID],
                [FromOrganizationID],
                [ToPersonID],
                [ToOrganizationID],
                [Title],
                [StartDate],
                [EndDate],
                [Status],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @RelationshipTypeID,
                @FromPersonID,
                @FromOrganizationID,
                @ToPersonID,
                @ToOrganizationID,
                @Title,
                @StartDate,
                @EndDate,
                ISNULL(@Status, 'Active'),
                @Notes
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_BizAppsCommon].[Relationship]
            (
                [RelationshipTypeID],
                [FromPersonID],
                [FromOrganizationID],
                [ToPersonID],
                [ToOrganizationID],
                [Title],
                [StartDate],
                [EndDate],
                [Status],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @RelationshipTypeID,
                @FromPersonID,
                @FromOrganizationID,
                @ToPersonID,
                @ToOrganizationID,
                @Title,
                @StartDate,
                @EndDate,
                ISNULL(@Status, 'Active'),
                @Notes
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwRelationships] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreateRelationship] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for MJ.BizApps.Common: Relationships */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spCreateRelationship] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for MJ.BizApps.Common: Relationships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Relationships
-- Item: spUpdateRelationship
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Relationship
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spUpdateRelationship]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdateRelationship];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spUpdateRelationship]
    @ID uniqueidentifier,
    @RelationshipTypeID uniqueidentifier,
    @FromPersonID uniqueidentifier,
    @FromOrganizationID uniqueidentifier,
    @ToPersonID uniqueidentifier,
    @ToOrganizationID uniqueidentifier,
    @Title nvarchar(255),
    @StartDate date,
    @EndDate date,
    @Status nvarchar(50),
    @Notes nvarchar(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[Relationship]
    SET
        [RelationshipTypeID] = @RelationshipTypeID,
        [FromPersonID] = @FromPersonID,
        [FromOrganizationID] = @FromOrganizationID,
        [ToPersonID] = @ToPersonID,
        [ToOrganizationID] = @ToOrganizationID,
        [Title] = @Title,
        [StartDate] = @StartDate,
        [EndDate] = @EndDate,
        [Status] = @Status,
        [Notes] = @Notes
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_BizAppsCommon].[vwRelationships] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_BizAppsCommon].[vwRelationships]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdateRelationship] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Relationship table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[trgUpdateRelationship]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_BizAppsCommon].[trgUpdateRelationship];
GO
CREATE TRIGGER [${flyway:defaultSchema}_BizAppsCommon].trgUpdateRelationship
ON [${flyway:defaultSchema}_BizAppsCommon].[Relationship]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_BizAppsCommon].[Relationship]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_BizAppsCommon].[Relationship] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for MJ.BizApps.Common: Relationships */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spUpdateRelationship] TO [cdp_Developer], [cdp_Integration]



/* spDelete SQL for MJ.BizApps.Common: Organization Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Organization Types
-- Item: spDeleteOrganizationType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR OrganizationType
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spDeleteOrganizationType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeleteOrganizationType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeleteOrganizationType]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_BizAppsCommon].[OrganizationType]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeleteOrganizationType] TO [cdp_Integration]
    

/* spDelete Permissions for MJ.BizApps.Common: Organization Types */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeleteOrganizationType] TO [cdp_Integration]



/* spDelete SQL for MJ.BizApps.Common: Relationship Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Relationship Types
-- Item: spDeleteRelationshipType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR RelationshipType
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spDeleteRelationshipType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeleteRelationshipType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeleteRelationshipType]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_BizAppsCommon].[RelationshipType]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeleteRelationshipType] TO [cdp_Integration]
    

/* spDelete Permissions for MJ.BizApps.Common: Relationship Types */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeleteRelationshipType] TO [cdp_Integration]



/* spDelete SQL for MJ.BizApps.Common: Relationships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Relationships
-- Item: spDeleteRelationship
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Relationship
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_BizAppsCommon].[spDeleteRelationship]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeleteRelationship];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_BizAppsCommon].[spDeleteRelationship]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_BizAppsCommon].[Relationship]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeleteRelationship] TO [cdp_Integration]
    

/* spDelete Permissions for MJ.BizApps.Common: Relationships */

GRANT EXECUTE ON [${flyway:defaultSchema}_BizAppsCommon].[spDeleteRelationship] TO [cdp_Integration]



/* Index for Foreign Keys for Motion */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Motions
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key MeetingID in table Motion
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Motion_MeetingID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Motion]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Motion_MeetingID ON [${flyway:defaultSchema}_Committees].[Motion] ([MeetingID]);

-- Index for foreign key AgendaItemID in table Motion
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Motion_AgendaItemID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Motion]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Motion_AgendaItemID ON [${flyway:defaultSchema}_Committees].[Motion] ([AgendaItemID]);

-- Index for foreign key MovedByMembershipID in table Motion
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Motion_MovedByMembershipID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Motion]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Motion_MovedByMembershipID ON [${flyway:defaultSchema}_Committees].[Motion] ([MovedByMembershipID]);

-- Index for foreign key SecondedByMembershipID in table Motion
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Motion_SecondedByMembershipID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Motion]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Motion_SecondedByMembershipID ON [${flyway:defaultSchema}_Committees].[Motion] ([SecondedByMembershipID]);

/* Index for Foreign Keys for Role */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Roles
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------


/* Index for Foreign Keys for Term */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Terms
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key CommitteeID in table Term
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Term_CommitteeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Term]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Term_CommitteeID ON [${flyway:defaultSchema}_Committees].[Term] ([CommitteeID]);

/* SQL text to update entity field related entity name field map for entity field ID 6129241C-C879-4369-B1AD-D97F350E2BCB */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='6129241C-C879-4369-B1AD-D97F350E2BCB', @RelatedEntityNameFieldMap='Committee'

/* Index for Foreign Keys for Type */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Types
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------


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

/* SQL text to update entity field related entity name field map for entity field ID 2B9ECA4A-F682-465D-9820-D9AFB50FFCE7 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='2B9ECA4A-F682-465D-9820-D9AFB50FFCE7', @RelatedEntityNameFieldMap='Credential'

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
-----               SCHEMA:      ${flyway:defaultSchema}_Committees
-----               BASE TABLE:  Motion
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[vwMotions]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_Committees].[vwMotions];
GO

CREATE VIEW [${flyway:defaultSchema}_Committees].[vwMotions]
AS
SELECT
    m.*
FROM
    [${flyway:defaultSchema}_Committees].[Motion] AS m
GO
GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwMotions] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Motions */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Motions
-- Item: Permissions for vwMotions
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwMotions] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spCreateMotion]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateMotion];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateMotion]
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
        INSERT INTO [${flyway:defaultSchema}_Committees].[Motion]
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
        INSERT INTO [${flyway:defaultSchema}_Committees].[Motion]
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
    SELECT * FROM [${flyway:defaultSchema}_Committees].[vwMotions] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateMotion] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Motions */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateMotion] TO [cdp_Developer], [cdp_Integration]



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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spUpdateMotion]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateMotion];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateMotion]
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
        [${flyway:defaultSchema}_Committees].[Motion]
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
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_Committees].[vwMotions] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_Committees].[vwMotions]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateMotion] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Motion table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[trgUpdateMotion]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_Committees].[trgUpdateMotion];
GO
CREATE TRIGGER [${flyway:defaultSchema}_Committees].trgUpdateMotion
ON [${flyway:defaultSchema}_Committees].[Motion]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Motion]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_Committees].[Motion] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Motions */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateMotion] TO [cdp_Developer], [cdp_Integration]



/* Base View SQL for Roles */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Roles
-- Item: vwRoles
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Roles
-----               SCHEMA:      ${flyway:defaultSchema}_Committees
-----               BASE TABLE:  Role
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[vwRoles]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_Committees].[vwRoles];
GO

CREATE VIEW [${flyway:defaultSchema}_Committees].[vwRoles]
AS
SELECT
    r.*
FROM
    [${flyway:defaultSchema}_Committees].[Role] AS r
GO
GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwRoles] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Roles */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Roles
-- Item: Permissions for vwRoles
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwRoles] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for Roles */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Roles
-- Item: spCreateRole
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Role
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spCreateRole]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateRole];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateRole]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(100),
    @Description nvarchar(MAX),
    @IsOfficer bit = NULL,
    @IsVotingRole bit = NULL,
    @DefaultPermissionsJSON nvarchar(MAX),
    @Sequence int = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_Committees].[Role]
            (
                [ID],
                [Name],
                [Description],
                [IsOfficer],
                [IsVotingRole],
                [DefaultPermissionsJSON],
                [Sequence]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @Name,
                @Description,
                ISNULL(@IsOfficer, 0),
                ISNULL(@IsVotingRole, 1),
                @DefaultPermissionsJSON,
                ISNULL(@Sequence, 100)
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_Committees].[Role]
            (
                [Name],
                [Description],
                [IsOfficer],
                [IsVotingRole],
                [DefaultPermissionsJSON],
                [Sequence]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @Name,
                @Description,
                ISNULL(@IsOfficer, 0),
                ISNULL(@IsVotingRole, 1),
                @DefaultPermissionsJSON,
                ISNULL(@Sequence, 100)
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_Committees].[vwRoles] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateRole] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Roles */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateRole] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for Roles */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Roles
-- Item: spUpdateRole
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Role
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spUpdateRole]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateRole];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateRole]
    @ID uniqueidentifier,
    @Name nvarchar(100),
    @Description nvarchar(MAX),
    @IsOfficer bit,
    @IsVotingRole bit,
    @DefaultPermissionsJSON nvarchar(MAX),
    @Sequence int
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Role]
    SET
        [Name] = @Name,
        [Description] = @Description,
        [IsOfficer] = @IsOfficer,
        [IsVotingRole] = @IsVotingRole,
        [DefaultPermissionsJSON] = @DefaultPermissionsJSON,
        [Sequence] = @Sequence
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_Committees].[vwRoles] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_Committees].[vwRoles]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateRole] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Role table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[trgUpdateRole]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_Committees].[trgUpdateRole];
GO
CREATE TRIGGER [${flyway:defaultSchema}_Committees].trgUpdateRole
ON [${flyway:defaultSchema}_Committees].[Role]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Role]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_Committees].[Role] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Roles */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateRole] TO [cdp_Developer], [cdp_Integration]



/* Base View SQL for Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Types
-- Item: vwTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Types
-----               SCHEMA:      ${flyway:defaultSchema}_Committees
-----               BASE TABLE:  Type
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[vwTypes]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_Committees].[vwTypes];
GO

CREATE VIEW [${flyway:defaultSchema}_Committees].[vwTypes]
AS
SELECT
    t.*
FROM
    [${flyway:defaultSchema}_Committees].[Type] AS t
GO
GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Types
-- Item: Permissions for vwTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Types
-- Item: spCreateType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Type
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spCreateType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateType]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(100),
    @Description nvarchar(MAX),
    @IsStandards bit = NULL,
    @DefaultTermMonths int,
    @IconClass nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_Committees].[Type]
            (
                [ID],
                [Name],
                [Description],
                [IsStandards],
                [DefaultTermMonths],
                [IconClass]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @Name,
                @Description,
                ISNULL(@IsStandards, 0),
                @DefaultTermMonths,
                @IconClass
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_Committees].[Type]
            (
                [Name],
                [Description],
                [IsStandards],
                [DefaultTermMonths],
                [IconClass]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @Name,
                @Description,
                ISNULL(@IsStandards, 0),
                @DefaultTermMonths,
                @IconClass
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_Committees].[vwTypes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateType] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Types */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateType] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Types
-- Item: spUpdateType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Type
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spUpdateType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateType]
    @ID uniqueidentifier,
    @Name nvarchar(100),
    @Description nvarchar(MAX),
    @IsStandards bit,
    @DefaultTermMonths int,
    @IconClass nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Type]
    SET
        [Name] = @Name,
        [Description] = @Description,
        [IsStandards] = @IsStandards,
        [DefaultTermMonths] = @DefaultTermMonths,
        [IconClass] = @IconClass
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_Committees].[vwTypes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_Committees].[vwTypes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateType] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Type table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[trgUpdateType]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_Committees].[trgUpdateType];
GO
CREATE TRIGGER [${flyway:defaultSchema}_Committees].trgUpdateType
ON [${flyway:defaultSchema}_Committees].[Type]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Type]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_Committees].[Type] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Types */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateType] TO [cdp_Developer], [cdp_Integration]



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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spDeleteMotion]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteMotion];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteMotion]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_Committees].[Motion]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteMotion] TO [cdp_Integration]
    

/* spDelete Permissions for Motions */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteMotion] TO [cdp_Integration]



/* spDelete SQL for Roles */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Roles
-- Item: spDeleteRole
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Role
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spDeleteRole]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteRole];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteRole]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_Committees].[Role]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteRole] TO [cdp_Integration]
    

/* spDelete Permissions for Roles */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteRole] TO [cdp_Integration]



/* spDelete SQL for Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Types
-- Item: spDeleteType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Type
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spDeleteType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteType]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_Committees].[Type]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteType] TO [cdp_Integration]
    

/* spDelete Permissions for Types */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteType] TO [cdp_Integration]



/* Base View SQL for Terms */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Terms
-- Item: vwTerms
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Terms
-----               SCHEMA:      ${flyway:defaultSchema}_Committees
-----               BASE TABLE:  Term
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[vwTerms]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_Committees].[vwTerms];
GO

CREATE VIEW [${flyway:defaultSchema}_Committees].[vwTerms]
AS
SELECT
    t.*,
    mjCommitteesCommittee_CommitteeID.[Name] AS [Committee]
FROM
    [${flyway:defaultSchema}_Committees].[Term] AS t
INNER JOIN
    [${flyway:defaultSchema}_Committees].[Committee] AS mjCommitteesCommittee_CommitteeID
  ON
    [t].[CommitteeID] = mjCommitteesCommittee_CommitteeID.[ID]
GO
GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwTerms] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Terms */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Terms
-- Item: Permissions for vwTerms
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwTerms] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* spCreate SQL for Terms */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Terms
-- Item: spCreateTerm
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Term
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spCreateTerm]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateTerm];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateTerm]
    @ID uniqueidentifier = NULL,
    @CommitteeID uniqueidentifier,
    @Name nvarchar(100),
    @StartDate date,
    @EndDate date,
    @Status nvarchar(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}_Committees].[Term]
            (
                [ID],
                [CommitteeID],
                [Name],
                [StartDate],
                [EndDate],
                [Status]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @CommitteeID,
                @Name,
                @StartDate,
                @EndDate,
                ISNULL(@Status, 'Active')
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}_Committees].[Term]
            (
                [CommitteeID],
                [Name],
                [StartDate],
                [EndDate],
                [Status]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @CommitteeID,
                @Name,
                @StartDate,
                @EndDate,
                ISNULL(@Status, 'Active')
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}_Committees].[vwTerms] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateTerm] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Terms */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateTerm] TO [cdp_Developer], [cdp_Integration]



/* spUpdate SQL for Terms */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Terms
-- Item: spUpdateTerm
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Term
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spUpdateTerm]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateTerm];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateTerm]
    @ID uniqueidentifier,
    @CommitteeID uniqueidentifier,
    @Name nvarchar(100),
    @StartDate date,
    @EndDate date,
    @Status nvarchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Term]
    SET
        [CommitteeID] = @CommitteeID,
        [Name] = @Name,
        [StartDate] = @StartDate,
        [EndDate] = @EndDate,
        [Status] = @Status
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_Committees].[vwTerms] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_Committees].[vwTerms]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateTerm] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Term table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[trgUpdateTerm]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_Committees].[trgUpdateTerm];
GO
CREATE TRIGGER [${flyway:defaultSchema}_Committees].trgUpdateTerm
ON [${flyway:defaultSchema}_Committees].[Term]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Term]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_Committees].[Term] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Terms */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateTerm] TO [cdp_Developer], [cdp_Integration]



/* spDelete SQL for Terms */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Terms
-- Item: spDeleteTerm
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Term
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spDeleteTerm]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteTerm];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteTerm]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_Committees].[Term]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteTerm] TO [cdp_Integration]
    

/* spDelete Permissions for Terms */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteTerm] TO [cdp_Integration]



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



/* Index for Foreign Keys for Vote */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Votes
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key MotionID in table Vote
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Vote_MotionID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Vote]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Vote_MotionID ON [${flyway:defaultSchema}_Committees].[Vote] ([MotionID]);

-- Index for foreign key MembershipID in table Vote
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Vote_MembershipID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Vote]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Vote_MembershipID ON [${flyway:defaultSchema}_Committees].[Vote] ([MembershipID]);

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
-----               SCHEMA:      ${flyway:defaultSchema}_Committees
-----               BASE TABLE:  Vote
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[vwVotes]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}_Committees].[vwVotes];
GO

CREATE VIEW [${flyway:defaultSchema}_Committees].[vwVotes]
AS
SELECT
    v.*
FROM
    [${flyway:defaultSchema}_Committees].[Vote] AS v
GO
GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwVotes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

/* Base View Permissions SQL for Votes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Votes
-- Item: Permissions for vwVotes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${flyway:defaultSchema}_Committees].[vwVotes] TO [cdp_UI], [cdp_Developer], [cdp_Integration]

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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spCreateVote]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateVote];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spCreateVote]
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
        INSERT INTO [${flyway:defaultSchema}_Committees].[Vote]
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
        INSERT INTO [${flyway:defaultSchema}_Committees].[Vote]
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
    SELECT * FROM [${flyway:defaultSchema}_Committees].[vwVotes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateVote] TO [cdp_Developer], [cdp_Integration]
    

/* spCreate Permissions for Votes */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spCreateVote] TO [cdp_Developer], [cdp_Integration]



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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spUpdateVote]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateVote];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spUpdateVote]
    @ID uniqueidentifier,
    @MotionID uniqueidentifier,
    @MembershipID uniqueidentifier,
    @VoteValue nvarchar(20),
    @Notes nvarchar(500)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Vote]
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
        SELECT TOP 0 * FROM [${flyway:defaultSchema}_Committees].[vwVotes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}_Committees].[vwVotes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateVote] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Vote table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[trgUpdateVote]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}_Committees].[trgUpdateVote];
GO
CREATE TRIGGER [${flyway:defaultSchema}_Committees].trgUpdateVote
ON [${flyway:defaultSchema}_Committees].[Vote]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}_Committees].[Vote]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}_Committees].[Vote] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
        

/* spUpdate Permissions for Votes */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateVote] TO [cdp_Developer], [cdp_Integration]



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
IF OBJECT_ID('[${flyway:defaultSchema}_Committees].[spDeleteVote]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteVote];
GO

CREATE PROCEDURE [${flyway:defaultSchema}_Committees].[spDeleteVote]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}_Committees].[Vote]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteVote] TO [cdp_Integration]
    

/* spDelete Permissions for Votes */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spDeleteVote] TO [cdp_Integration]



/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '4434a278-78c3-4bf1-98c2-8db69f1adc87' OR (EntityID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0' AND Name = 'Type')) BEGIN
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
            '4434a278-78c3-4bf1-98c2-8db69f1adc87',
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', -- Entity: Committees
            100029,
            'Type',
            'Type',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'ff56f679-f952-42dc-aa5b-963961a85640' OR (EntityID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0' AND Name = 'ParentCommittee')) BEGIN
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
            'ff56f679-f952-42dc-aa5b-963961a85640',
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', -- Entity: Committees
            100030,
            'ParentCommittee',
            'Parent Committee',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '154de67d-4553-449f-a34d-9b60a5d194bd' OR (EntityID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0' AND Name = 'Organization')) BEGIN
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
            '154de67d-4553-449f-a34d-9b60a5d194bd',
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', -- Entity: Committees
            100031,
            'Organization',
            'Organization',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'a6e763c0-d5ca-4b92-9889-4c7d5b2c09b0' OR (EntityID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0' AND Name = 'RootParentCommitteeID')) BEGIN
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
            'a6e763c0-d5ca-4b92-9889-4c7d5b2c09b0',
            '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', -- Entity: Committees
            100032,
            'RootParentCommitteeID',
            'Root Parent Committee ID',
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

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'eae1f5a3-12e3-473f-886a-a5f35201392a' OR (EntityID = '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC' AND Name = 'Credential')) BEGIN
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
            'eae1f5a3-12e3-473f-886a-a5f35201392a',
            '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC', -- Entity: Video Providers
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1e2f9690-8540-4bd3-8f2e-5711831f8f0c' OR (EntityID = '28992C32-D738-4E7C-97CA-5F0489E89D56' AND Name = 'Person')) BEGIN
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
            '1e2f9690-8540-4bd3-8f2e-5711831f8f0c',
            '28992C32-D738-4E7C-97CA-5F0489E89D56', -- Entity: Attendances
            100019,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '542ce41a-62d0-4b4e-83d1-ac706a2d37d2' OR (EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7' AND Name = 'Committee')) BEGIN
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
            '542ce41a-62d0-4b4e-83d1-ac706a2d37d2',
            '26E04065-1F39-4AB6-913E-6B87481DEFA7', -- Entity: Artifacts
            100033,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'bdd106fe-f1b1-4601-9912-37efc6d27732' OR (EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7' AND Name = 'ArtifactType')) BEGIN
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
            'bdd106fe-f1b1-4601-9912-37efc6d27732',
            '26E04065-1F39-4AB6-913E-6B87481DEFA7', -- Entity: Artifacts
            100034,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '94c4b80b-b336-43ba-b215-5540d3cf3c55' OR (EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7' AND Name = 'UploadedByPerson')) BEGIN
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
            '94c4b80b-b336-43ba-b215-5540d3cf3c55',
            '26E04065-1F39-4AB6-913E-6B87481DEFA7', -- Entity: Artifacts
            100035,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'fecff567-4894-4ac9-b1be-878922f1bd7f' OR (EntityID = 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1' AND Name = 'Committee')) BEGIN
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
            'fecff567-4894-4ac9-b1be-878922f1bd7f',
            'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', -- Entity: Comments
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '6285a346-c49b-4e8d-a9b5-58ba229020d9' OR (EntityID = 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1' AND Name = 'Person')) BEGIN
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
            '6285a346-c49b-4e8d-a9b5-58ba229020d9',
            'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', -- Entity: Comments
            100028,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '8b3d4221-92b6-4ce9-aaea-418e53fef539' OR (EntityID = 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1' AND Name = 'RootParentCommentID')) BEGIN
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
            '8b3d4221-92b6-4ce9-aaea-418e53fef539',
            'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', -- Entity: Comments
            100029,
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

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '5dac39c0-a8fd-490d-8085-e34caa9bd3da' OR (EntityID = '35AACFD0-C02B-4D1B-AD41-8C081D08650C' AND Name = 'Person')) BEGIN
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
            '5dac39c0-a8fd-490d-8085-e34caa9bd3da',
            '35AACFD0-C02B-4D1B-AD41-8C081D08650C', -- Entity: Memberships
            100024,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'a097f4f5-8554-42a7-81c6-bb6b72e64669' OR (EntityID = '35AACFD0-C02B-4D1B-AD41-8C081D08650C' AND Name = 'Role')) BEGIN
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
            'a097f4f5-8554-42a7-81c6-bb6b72e64669',
            '35AACFD0-C02B-4D1B-AD41-8C081D08650C', -- Entity: Memberships
            100025,
            'Role',
            'Role',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '5a60d76e-9a8f-4543-a41b-39f27f93b465' OR (EntityID = '35AACFD0-C02B-4D1B-AD41-8C081D08650C' AND Name = 'Term')) BEGIN
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
            '5a60d76e-9a8f-4543-a41b-39f27f93b465',
            '35AACFD0-C02B-4D1B-AD41-8C081D08650C', -- Entity: Memberships
            100026,
            'Term',
            'Term',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '13c76e22-b5bb-458e-aeab-70d638e4b5ad' OR (EntityID = '216DC5A7-41C9-4165-9E5A-93E514B9FD4B' AND Name = 'Committee')) BEGIN
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
            '13c76e22-b5bb-458e-aeab-70d638e4b5ad',
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', -- Entity: Action Items
            100031,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1d74acc5-6a62-4bd1-9bd7-dfec0ff31a76' OR (EntityID = '216DC5A7-41C9-4165-9E5A-93E514B9FD4B' AND Name = 'AssignedToPerson')) BEGIN
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
            '1d74acc5-6a62-4bd1-9bd7-dfec0ff31a76',
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', -- Entity: Action Items
            100032,
            'AssignedToPerson',
            'Assigned To Person',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '023adb94-13b9-4462-92a9-d5c2204f0831' OR (EntityID = '216DC5A7-41C9-4165-9E5A-93E514B9FD4B' AND Name = 'AssignedByPerson')) BEGIN
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
            '023adb94-13b9-4462-92a9-d5c2204f0831',
            '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', -- Entity: Action Items
            100033,
            'AssignedByPerson',
            'Assigned By Person',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1ec883d0-0c4c-45dd-a59f-5da1c2e7b8cd' OR (EntityID = '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4' AND Name = 'Committee')) BEGIN
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
            '1ec883d0-0c4c-45dd-a59f-5da1c2e7b8cd',
            '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4', -- Entity: Terms
            100017,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '7d350db1-d63e-42bb-b1ff-0b501b927684' OR (EntityID = 'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476' AND Name = 'ExtendedEntity')) BEGIN
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
            '7d350db1-d63e-42bb-b1ff-0b501b927684',
            'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476', -- Entity: Artifact Types
            100015,
            'ExtendedEntity',
            'Extended Entity',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c78a07dd-4ea1-496b-b365-35f3fc1e07fc' OR (EntityID = '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6' AND Name = 'PresenterPerson')) BEGIN
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
            'c78a07dd-4ea1-496b-b365-35f3fc1e07fc',
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', -- Entity: Agenda Items
            100029,
            'PresenterPerson',
            'Presenter Person',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'a1f7ee69-d4da-429e-88bc-33ef6d65ce26' OR (EntityID = '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6' AND Name = 'RootParentAgendaItemID')) BEGIN
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
            'a1f7ee69-d4da-429e-88bc-33ef6d65ce26',
            '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', -- Entity: Agenda Items
            100030,
            'RootParentAgendaItemID',
            'Root Parent Agenda Item ID',
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

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '04cc89c8-a7e3-482f-9824-497ee4d0615c' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = 'Committee')) BEGIN
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
            '04cc89c8-a7e3-482f-9824-497ee4d0615c',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100039,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'fbabb678-df8f-4f81-8e46-0e573550ac86' OR (EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44' AND Name = 'VideoProvider_Virtual')) BEGIN
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
            'fbabb678-df8f-4f81-8e46-0e573550ac86',
            '473622EE-DAF0-4A10-8289-F9C14B937A44', -- Entity: Meetings
            100040,
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
            SET IsNameField = 1
            WHERE ID = '27944E8C-BB63-4791-94F1-D0ADAF2F18E3'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '27944E8C-BB63-4791-94F1-D0ADAF2F18E3'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'F32C2B8D-9351-4968-AA15-2CB73A5FCF96'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'F34A168B-D288-44FE-8BBA-F26D4B52A03B'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'BFBE6A51-5AE0-4EE9-ADEC-443F75706247'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '13C76E22-B5BB-458E-AEAB-70D638E4B5AD'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '1D74ACC5-6A62-4BD1-9BD7-DFEC0FF31A76'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '27944E8C-BB63-4791-94F1-D0ADAF2F18E3'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'F34A168B-D288-44FE-8BBA-F26D4B52A03B'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'BFBE6A51-5AE0-4EE9-ADEC-443F75706247'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '13C76E22-B5BB-458E-AEAB-70D638E4B5AD'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '1D74ACC5-6A62-4BD1-9BD7-DFEC0FF31A76'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '023ADB94-13B9-4462-92A9-D5C2204F0831'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

            UPDATE [${flyway:defaultSchema}].[EntityField]
            SET IsNameField = 1
            WHERE ID = '120305FC-992E-4435-B5DC-1C712EA7BF4B'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '120305FC-992E-4435-B5DC-1C712EA7BF4B'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '273D17C7-D240-4BDD-84EE-3F733F6A6F3C'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'BDD106FE-F1B1-4601-9912-37EFC6D27732'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '94C4B80B-B336-43BA-B215-5540D3CF3C55'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '120305FC-992E-4435-B5DC-1C712EA7BF4B'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '273D17C7-D240-4BDD-84EE-3F733F6A6F3C'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '98B83228-B52F-498F-9EB9-40B1255F7F91'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '45CC3CAD-6E8F-4B63-9815-42FE410510A4'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'BDD106FE-F1B1-4601-9912-37EFC6D27732'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '94C4B80B-B336-43BA-B215-5540D3CF3C55'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

            UPDATE [${flyway:defaultSchema}].[EntityField]
            SET IsNameField = 1
            WHERE ID = '1E2F9690-8540-4BD3-8F2E-5711831F8F0C'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '2EC8CC0D-77E2-4557-99AB-F50B976B0F31'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '2D9209F8-1AFD-4C12-B909-229A7F0A9571'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'C4554EE3-DEDA-468A-BB9D-5D479A33757A'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '1E2F9690-8540-4BD3-8F2E-5711831F8F0C'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '2EC8CC0D-77E2-4557-99AB-F50B976B0F31'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '1E2F9690-8540-4BD3-8F2E-5711831F8F0C'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '9E02E3CE-0B9A-4E1D-94A8-3730CFD0595D'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '64B94782-BCEE-46B1-9969-D765D3A59D97'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

            UPDATE [${flyway:defaultSchema}].[EntityField]
            SET IsNameField = 1
            WHERE ID = '0C4066A0-0B41-4F9F-A737-D4303FF91004'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '69784CA3-CB33-4038-A505-376042FCCFAD'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '0C4066A0-0B41-4F9F-A737-D4303FF91004'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'F33F1F90-E8D9-4549-93D0-BCC7A015C16B'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '9C9BD457-9924-4532-848C-9D27AB19C316'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '797DCDB2-E973-4D9A-BE74-7D5C7F6C7852'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'C78A07DD-4EA1-496B-B365-35F3FC1E07FC'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '0C4066A0-0B41-4F9F-A737-D4303FF91004'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '9C9BD457-9924-4532-848C-9D27AB19C316'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '797DCDB2-E973-4D9A-BE74-7D5C7F6C7852'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'C78A07DD-4EA1-496B-B365-35F3FC1E07FC'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set categories for 18 fields */

-- UPDATE Entity Field Category Info Action Items.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'DC921F3F-93CA-4EC3-A3CB-0DA3F990E91C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.CommitteeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Assignment',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C42155FC-0F1B-4A8D-B239-3BBC4DE5B4AD' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.MeetingID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Assignment',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D30E95A2-5265-403E-AFF0-73D41E9DDA05' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.AgendaItemID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Assignment',
   GeneratedFormSection = 'Category',
   DisplayName = 'Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6922D6FE-9689-41A0-BB27-6CF3D8098C93' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.Title 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Action Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '27944E8C-BB63-4791-94F1-D0ADAF2F18E3' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Action Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9D0F82A0-3A4B-4DEF-966C-0E3AAFF1C3F3' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.AssignedToPersonID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Assignment',
   GeneratedFormSection = 'Category',
   DisplayName = 'Assigned To',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '62A51489-B1C1-42B5-BA7D-E28319FA087F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.AssignedByPersonID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Assignment',
   GeneratedFormSection = 'Category',
   DisplayName = 'Assigned By',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '61264E2F-FDF4-4E47-B22C-283B5A712159' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.DueDate 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Action Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F32C2B8D-9351-4968-AA15-2CB73A5FCF96' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.Priority 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Action Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F34A168B-D288-44FE-8BBA-F26D4B52A03B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.Status 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Action Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BFBE6A51-5AE0-4EE9-ADEC-443F75706247' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.CompletedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Action Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FDD86E8A-C888-45CA-9F22-9025EF811390' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.CompletionNotes 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Action Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A57031E7-8AB2-48D0-98A3-A376260E6DC6' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '51E3F208-0975-4401-9101-BC080CD8505D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B3F600A5-1EFC-4E01-A966-0F1D25DDDD99' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.Committee 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Assignment',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '13C76E22-B5BB-458E-AEAB-70D638E4B5AD' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.AssignedToPerson 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Assignment',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1D74ACC5-6A62-4BD1-9BD7-DFEC0FF31A76' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.AssignedByPerson 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Assignment',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '023ADB94-13B9-4462-92A9-D5C2204F0831' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-tasks */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-tasks', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = '216DC5A7-41C9-4165-9E5A-93E514B9FD4B'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('330c2683-75bd-437e-a90e-e82bdfd93173', '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', 'FieldCategoryInfo', '{"Action Details":{"icon":"fa fa-tasks","description":"Core information describing the work, its priority, status and timing"},"Assignment":{"icon":"fa fa-user-friends","description":"Relationships to committees, meetings, agenda items and the people involved"},"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"},"entityImportance":{"defaultForNewUser":true,"entityCategory":"primary","confidence":"high","reasoning":"The table has many business fields (15) and no foreign‑key heavy pattern, indicating a rich domain object used daily for tracking work. It fits the primary entity profile."}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('fbbbab76-7138-42ba-a132-bd5d1808945d', '216DC5A7-41C9-4165-9E5A-93E514B9FD4B', 'FieldCategoryIcons', '{"Action Details":"fa fa-tasks","Assignment":"fa fa-user-friends","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set categories for 8 fields */

-- UPDATE Entity Field Category Info Artifact Types.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '23718162-8E18-4639-A205-F5188068045C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifact Types.Name 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Artifact Type Definition',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CFC4B714-420B-40F3-816E-959D8C664FD6' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifact Types.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Artifact Type Definition',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '64B94782-BCEE-46B1-9969-D765D3A59D97' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifact Types.IconClass 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Artifact Type Definition',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9E02E3CE-0B9A-4E1D-94A8-3730CFD0595D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifact Types.ExtendedEntityID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Extension Settings',
   GeneratedFormSection = 'Category',
   DisplayName = 'Extended Entity',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7C8227DF-5515-4828-B3E5-4195A03D5F0D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifact Types.ExtendedEntity 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Extension Settings',
   GeneratedFormSection = 'Category',
   DisplayName = 'Extended Entity Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7D350DB1-D63E-42BB-B1FF-0B501B927684' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifact Types.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E6580DEF-09C4-4154-AF96-9E7B9F20291D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifact Types.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F86AE8D9-FE76-4BEC-A735-0DE7AE591861' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-puzzle-piece */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-puzzle-piece', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = 'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('59a1e6df-7dc2-4918-a7f4-6c5cab6dd947', 'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476', 'FieldCategoryInfo', '{"Artifact Type Definition":{"icon":"fa fa-file-alt","description":"Core details of the artifact type, including name, description, and UI icon."},"Extension Settings":{"icon":"fa fa-cogs","description":"Configuration for linking an optional extension entity that supplies type‑specific fields."},"System Metadata":{"icon":"fa fa-cog","description":"Audit timestamps and internal identifier."}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('41f7f26f-f612-46d3-84b6-c6946aa9c1ae', 'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476', 'FieldCategoryIcons', '{"Artifact Type Definition":"fa fa-file-alt","Extension Settings":"fa fa-cogs","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=0 for NEW entity (category: reference, confidence: high) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 0, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = 'E9BCB64E-8AA3-45FA-BCD3-EA9DA7AF0476'
      

/* Set categories for 10 fields */

-- UPDATE Entity Field Category Info Attendances.AttendanceStatus 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Attendance Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2EC8CC0D-77E2-4557-99AB-F50B976B0F31' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.JoinedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Attendance Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2D9209F8-1AFD-4C12-B909-229A7F0A9571' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.LeftAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Attendance Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C4554EE3-DEDA-468A-BB9D-5D479A33757A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.Notes 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Attendance Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1617DFED-ECFE-4E67-802A-40789BEBF99C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.MeetingID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Participant & Meeting',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E9086CEC-BDC5-43F2-A969-50E4E944788F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.PersonID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Participant & Meeting',
   GeneratedFormSection = 'Category',
   DisplayName = 'Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4731151B-DEAF-444B-BD5E-83825D55CBD1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.Person 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Participant & Meeting',
   GeneratedFormSection = 'Category',
   DisplayName = 'Person Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1E2F9690-8540-4BD3-8F2E-5711831F8F0C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '99421172-CD14-4461-BC33-8F9323F63715' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '35AF10FA-3A11-4C3B-B9D0-175B4EABB12B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9622C490-F0BF-4E30-81D1-52F7111F12A6' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-calendar-check */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-calendar-check', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = '28992C32-D738-4E7C-97CA-5F0489E89D56'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('7d1f3527-8560-4f76-8a64-8231baf01fd3', '28992C32-D738-4E7C-97CA-5F0489E89D56', 'FieldCategoryInfo', '{"Attendance Details":{"icon":"fa fa-calendar-check","description":"Status, timestamps and notes that describe how and when a person participated in a meeting"},"Participant & Meeting":{"icon":"fa fa-users","description":"Identifiers linking the attendance entry to a specific meeting and person"},"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('c50eebd4-d742-4a18-a0e0-ac9c2131885b', '28992C32-D738-4E7C-97CA-5F0489E89D56', 'FieldCategoryIcons', '{"Attendance Details":"fa fa-calendar-check","Participant & Meeting":"fa fa-users","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=1 for NEW entity (category: primary, confidence: medium) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 1, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = '28992C32-D738-4E7C-97CA-5F0489E89D56'
      

/* Set categories for 16 fields */

-- UPDATE Entity Field Category Info Agenda Items.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FB343961-4C8C-44AC-8A34-640512BDBE61' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.MeetingID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Agenda Structure',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'EA8E764B-06DE-4E0E-A527-951BFB4C9BA4' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.ParentAgendaItemID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Agenda Structure',
   GeneratedFormSection = 'Category',
   DisplayName = 'Parent Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3F562093-4217-473A-B77D-942E1FE392C9' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.RootParentAgendaItemID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Agenda Structure',
   GeneratedFormSection = 'Category',
   DisplayName = 'Root Parent Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A1F7EE69-D4DA-429E-88BC-33EF6D65CE26' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.Sequence 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Agenda Structure',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '69784CA3-CB33-4038-A505-376042FCCFAD' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.Title 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Content & Outcome',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0C4066A0-0B41-4F9F-A737-D4303FF91004' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Content & Outcome',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1DE3087A-D5B1-4828-8A0F-267F2EEE8E55' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.ItemType 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Content & Outcome',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9C9BD457-9924-4532-848C-9D27AB19C316' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.Status 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Content & Outcome',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '797DCDB2-E973-4D9A-BE74-7D5C7F6C7852' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.Notes 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Content & Outcome',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BE00E5AD-D418-436B-86B3-098D89030CA1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.PresenterPersonID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Presentation & Timing',
   GeneratedFormSection = 'Category',
   DisplayName = 'Presenter',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '75CDE5D3-BACC-4874-B8D3-5451BB4A232E' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.PresenterPerson 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Presentation & Timing',
   GeneratedFormSection = 'Category',
   DisplayName = 'Presenter Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C78A07DD-4EA1-496B-B365-35F3FC1E07FC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.DurationMinutes 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Presentation & Timing',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F33F1F90-E8D9-4549-93D0-BCC7A015C16B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.RelatedDocumentURL 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Presentation & Timing',
   GeneratedFormSection = 'Category',
   DisplayName = 'Related Document',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '18B6AE27-AFC9-43F3-AED6-822F56A1B05F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7FAF6250-1EBC-4907-A3FC-3E5156C70D31' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3ABA8EA1-F2A2-49C8-AA64-548149C5F3DB' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-clipboard */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-clipboard', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('8217305d-f097-4af2-bec8-44ce677913f2', '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', 'FieldCategoryInfo', '{"Agenda Structure":{"icon":"fa fa-sitemap","description":"Defines hierarchy and ordering of agenda items within a meeting"},"Content & Outcome":{"icon":"fa fa-align-left","description":"Core details of the agenda item, including title, description, type, status, and notes"},"Presentation & Timing":{"icon":"fa fa-clock","description":"Information about who presents the item, its duration, and related documents"},"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields and record identifiers"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('e5bc9658-3e8a-46c5-bc4f-c2859d84c0d2', '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6', 'FieldCategoryIcons', '{"Agenda Structure":"fa fa-sitemap","Content & Outcome":"fa fa-align-left","Presentation & Timing":"fa fa-clock","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=1 for NEW entity (category: primary, confidence: high) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 1, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = '21EEB23A-4506-4CCF-A2D2-EDE25AE5B0E6'
      

/* Set categories for 19 fields */

-- UPDATE Entity Field Category Info Artifacts.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'EF220C25-78F5-493C-9AB1-AADA6F432D67' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.CommitteeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '97FAB244-8B45-4704-903A-5911D79695C5' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.MeetingID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AADA9854-71CD-465B-BEC8-080557E0139B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.AgendaItemID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   DisplayName = 'Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '65EA63AF-6352-4C9E-9C22-3628A240FD45' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.ActionItemID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   DisplayName = 'Action Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '66D33A0B-20C9-4B50-8F44-165D75B0A050' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.Title 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Artifact Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '120305FC-992E-4435-B5DC-1C712EA7BF4B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Artifact Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '74E10FEF-1C6A-43A8-98C7-CE30899BECF9' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.ArtifactTypeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   DisplayName = 'Artifact Type',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'EE7E6B0E-6EC6-44DF-B609-9828F65F0201' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.Provider 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Artifact Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '273D17C7-D240-4BDD-84EE-3F733F6A6F3C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.ExternalID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'File Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '98B83228-B52F-498F-9EB9-40B1255F7F91' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.URL 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'File Information',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '45CC3CAD-6E8F-4B63-9815-42FE410510A4' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.MimeType 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'File Information',
   GeneratedFormSection = 'Category',
   DisplayName = 'MIME Type',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F7DBBA41-0465-45CC-8525-DAB19003EBB8' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.FileSize 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'File Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C7640649-2309-46F2-B423-B1B79D08D9AD' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.UploadedByPersonID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   DisplayName = 'Uploaded By',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FEB37F43-F610-412B-A9C7-E5C8354A1578' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CDC942A7-F224-4142-9E12-FC6841527C25' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '747630A4-0E64-49D0-966E-1AC4D5061D43' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.Committee 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '542CE41A-62D0-4B4E-83D1-AC706A2D37D2' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.ArtifactType 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Artifact Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BDD106FE-F1B1-4601-9912-37EFC6D27732' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.UploadedByPerson 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '94C4B80B-B336-43BA-B215-5540D3CF3C55' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-file */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-file', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = '26E04065-1F39-4AB6-913E-6B87481DEFA7'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('72e35ca0-c834-442b-bd5a-1c4b2c68da2f', '26E04065-1F39-4AB6-913E-6B87481DEFA7', 'FieldCategoryInfo', '{"Artifact Details":{"icon":"fa fa-file-alt","description":"Core descriptive information about the artifact such as title, description, type and storage provider"},"File Information":{"icon":"fa fa-file","description":"Technical file data including URL, external identifier, MIME type and size"},"Associations":{"icon":"fa fa-link","description":"Links to related entities like committee, meeting, agenda, action items and uploader"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit fields and primary key"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('3dd7d2f9-76be-4448-a68f-6301fdcc2f50', '26E04065-1F39-4AB6-913E-6B87481DEFA7', 'FieldCategoryIcons', '{"Artifact Details":"fa fa-file-alt","File Information":"fa fa-file","Associations":"fa fa-link","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=1 for NEW entity (category: primary, confidence: medium) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 1, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = '26E04065-1F39-4AB6-913E-6B87481DEFA7'
      

/* Set field properties for entity */

            UPDATE [${flyway:defaultSchema}].[EntityField]
            SET IsNameField = 1
            WHERE ID = '5DAC39C0-A8FD-490D-8085-E34CAA9BD3DA'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '89DCFB9A-DB1E-4E4B-A3A7-786B21B31B49'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'EC0CA348-6190-4924-8715-87D0BBFDD6BE'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '5DAC39C0-A8FD-490D-8085-E34CAA9BD3DA'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'A097F4F5-8554-42A7-81C6-BB6B72E64669'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '5A60D76E-9A8F-4543-A41B-39F27F93B465'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'EC0CA348-6190-4924-8715-87D0BBFDD6BE'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '5DAC39C0-A8FD-490D-8085-E34CAA9BD3DA'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'A097F4F5-8554-42A7-81C6-BB6B72E64669'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '5A60D76E-9A8F-4543-A41B-39F27F93B465'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

            UPDATE [${flyway:defaultSchema}].[EntityField]
            SET IsNameField = 1
            WHERE ID = '55775889-9433-4E7D-B227-591B49B2EB54'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '55775889-9433-4E7D-B227-591B49B2EB54'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '1F501596-F5DE-4B62-B935-DACCA3E57238'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '388CBE3A-DDCB-4B18-B08B-0F574B8C4234'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '6E828B99-DD10-4F30-AD0F-A4A6AD4B25E2'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '63363A4E-1607-462E-8348-6907BEF1DFC4'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '04CC89C8-A7E3-482F-9824-497EE4D0615C'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '55775889-9433-4E7D-B227-591B49B2EB54'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'EFFB32EE-B2C0-4C62-B9B5-E165752408CB'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'C0D0D8D3-9FA1-4E40-801B-DFC31577BC13'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'E8D38530-5E88-4E3D-8C93-FAB42DA20654'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '04CC89C8-A7E3-482F-9824-497EE4D0615C'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

            UPDATE [${flyway:defaultSchema}].[EntityField]
            SET IsNameField = 1
            WHERE ID = 'C805BBF8-10A6-4EBC-A3E4-94F1BF820436'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'C805BBF8-10A6-4EBC-A3E4-94F1BF820436'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'EE9CC2B2-1D6E-4ACA-952F-83C13D3F718B'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '6285A346-C49B-4E8D-A9B5-58BA229020D9'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'FECFF567-4894-4AC9-B1BE-878922F1BD7F'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '6285A346-C49B-4E8D-A9B5-58BA229020D9'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

            UPDATE [${flyway:defaultSchema}].[EntityField]
            SET IsNameField = 1
            WHERE ID = 'CE787060-DA25-4B53-AA55-50DE0FF681A1'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'DB7533C1-7236-4E59-A39E-A1CA6635274A'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '0716669E-9229-4416-A819-622CA89E4DC7'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'CE787060-DA25-4B53-AA55-50DE0FF681A1'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'DB7533C1-7236-4E59-A39E-A1CA6635274A'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '92A5241E-895A-468C-9C2D-8EF528B89918'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'CE787060-DA25-4B53-AA55-50DE0FF681A1'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '68040577-ADF2-4EBF-A80E-FE0BBC205F0B'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '5803A860-EF51-4956-A0EE-844DFC2CE4C3'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '4434A278-78C3-4BF1-98C2-8DB69F1ADC87'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '154DE67D-4553-449F-A34D-9B60A5D194BD'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '47717ED1-6B71-448D-9908-D20ECD28BC73'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '68040577-ADF2-4EBF-A80E-FE0BBC205F0B'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '4434A278-78C3-4BF1-98C2-8DB69F1ADC87'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '154DE67D-4553-449F-A34D-9B60A5D194BD'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set categories for 16 fields */

-- UPDATE Entity Field Category Info Comments.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0D0E6C67-0EF7-4E53-8375-5DB61E5F5545' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.CommitteeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations & Threading',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1F907DBB-8D97-4E97-B16B-694F501ABD02' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.MeetingID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations & Threading',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9557FD79-3868-4F6A-81C8-17B5F2786A28' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.AgendaItemID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations & Threading',
   GeneratedFormSection = 'Category',
   DisplayName = 'Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '920E461F-22A0-4662-B20F-9AF5960CC96A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.ActionItemID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations & Threading',
   GeneratedFormSection = 'Category',
   DisplayName = 'Action Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F1B7DFC9-FEF3-4A1A-A1E3-7D3F07428DBF' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.ArtifactID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations & Threading',
   GeneratedFormSection = 'Category',
   DisplayName = 'Artifact',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '04E057AE-6730-492E-9314-BFD02B8CFD78' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.ParentCommentID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations & Threading',
   GeneratedFormSection = 'Category',
   DisplayName = 'Parent Comment',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '299B31B2-C718-45FB-B77B-912B0549660C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.PersonID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations & Threading',
   GeneratedFormSection = 'Category',
   DisplayName = 'Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4961B896-9389-47B7-9488-66367098D7CC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.CommentText 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Comment Content',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C805BBF8-10A6-4EBC-A3E4-94F1BF820436' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.MentionedPersonIDs 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Comment Content',
   GeneratedFormSection = 'Category',
   DisplayName = 'Mentioned Persons',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '613AAEA7-E4D7-460E-8C6F-2278655BC663' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.IsResolved 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Comment Content',
   GeneratedFormSection = 'Category',
   DisplayName = 'Resolved',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'EE9CC2B2-1D6E-4ACA-952F-83C13D3F718B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9B0CACFF-921F-48C7-B27A-778EE094008D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3D4535DA-392E-4B21-A86E-5E0E6855D12F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.Committee 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations & Threading',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FECFF567-4894-4AC9-B1BE-878922F1BD7F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.Person 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations & Threading',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6285A346-C49B-4E8D-A9B5-58BA229020D9' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Comments.RootParentCommentID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Associations & Threading',
   GeneratedFormSection = 'Category',
   DisplayName = 'Root Parent Comment',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8B3D4221-92B6-4CE9-AAEA-418E53FEF539' AND AutoUpdateCategory = 1

/* Set categories for 21 fields */

-- UPDATE Entity Field Category Info Meetings.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7A9C51AA-3E9F-49CC-81DB-DF0BBBB0A57B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.CommitteeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Meeting Overview',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '225EF45B-1EA5-4F13-BA96-D62419EC40A9' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.Title 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Meeting Overview',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '55775889-9433-4E7D-B227-591B49B2EB54' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Meeting Overview',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '776024F3-890F-49DA-A878-658619732B62' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.Status 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Meeting Overview',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '63363A4E-1607-462E-8348-6907BEF1DFC4' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.Committee 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Meeting Overview',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '04CC89C8-A7E3-482F-9824-497EE4D0615C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.StartDateTime 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Schedule & Timing',
   GeneratedFormSection = 'Category',
   DisplayName = 'Start Date & Time',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1F501596-F5DE-4B62-B935-DACCA3E57238' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.EndDateTime 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Schedule & Timing',
   GeneratedFormSection = 'Category',
   DisplayName = 'End Date & Time',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '388CBE3A-DDCB-4B18-B08B-0F574B8C4234' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.TimeZone 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Schedule & Timing',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BA646ED1-F40C-4047-AC84-AAC1B77F874F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.CalendarEventID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Schedule & Timing',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E8D38530-5E88-4E3D-8C93-FAB42DA20654' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.LocationType 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Location & Format',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6E828B99-DD10-4F30-AD0F-A4A6AD4B25E2' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.LocationText 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Location & Format',
   GeneratedFormSection = 'Category',
   DisplayName = 'Location Details',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'EFFB32EE-B2C0-4C62-B9B5-E165752408CB' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.VideoProvider 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Video Conferencing',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '938456AE-E71A-4086-9BB4-16EDC0A0910C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.VideoProviderID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Video Conferencing',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7B5571C3-69A1-4E82-9092-AF08A5485691' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.VideoMeetingID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Video Conferencing',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C0D0D8D3-9FA1-4E40-801B-DFC31577BC13' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.VideoJoinURL 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Video Conferencing',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '614DBA3A-C83E-4902-9225-A4F7494BAF99' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.VideoRecordingURL 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Video Conferencing',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = 'B2198FCD-5A71-40F6-91ED-336E43F3EA67' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.TranscriptURL 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Video Conferencing',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '9029766A-4F06-4B51-B2A0-51D00877D416' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.VideoProvider_Virtual 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Video Conferencing',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FBABB678-DF8F-4F81-8E46-0E573550AC86' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E923365B-1352-47DA-88EC-C21A120A41D7' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '44415857-020E-4457-ABB8-5C8B4485A7AF' AND AutoUpdateCategory = 1

/* Set categories for 10 fields */

-- UPDATE Entity Field Category Info Minutes.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A4946C0C-C17D-4940-BCAB-B9F620B6B009' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.ArtifactID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   DisplayName = 'Artifact',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6F72C51B-7196-4E22-A9EE-B43F93B2F045' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.MeetingID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '56D1F97D-FE18-4FC6-9443-750C35FAB1EB' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.ApprovedByMeetingID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   DisplayName = 'Approved By Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '65F2A2A2-A88C-4A0B-9D7D-88C76BE7B6C4' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.ApprovalStatus 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Approval Tracking',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'DB7533C1-7236-4E59-A39E-A1CA6635274A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.ApprovedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Approval Tracking',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0716669E-9229-4416-A819-622CA89E4DC7' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.Content 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Minutes Content',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CE787060-DA25-4B53-AA55-50DE0FF681A1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.Notes 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Minutes Content',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '92A5241E-895A-468C-9C2D-8EF528B89918' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0220646F-86F1-4731-8A5C-C8AF5E371DAA' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3D40F22B-2AFF-4891-BBC6-93EDA468DBEA' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-clipboard */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-clipboard', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = '58792440-2D28-46CF-BFB3-79A214063E37'
            

/* Set entity icon to fa fa-comments */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-comments', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1'
            

/* Set entity icon to fa fa-calendar-alt */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-calendar-alt', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = '473622EE-DAF0-4A10-8289-F9C14B937A44'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('29ef663f-aa51-46d4-ba75-9b05235063ce', '58792440-2D28-46CF-BFB3-79A214063E37', 'FieldCategoryInfo', '{"Related Entities":{"icon":"fa fa-link","description":"References to related objects such as the source artifact and associated meetings."},"Approval Tracking":{"icon":"fa fa-check-circle","description":"Information about the approval status, date and approving meeting."},"Minutes Content":{"icon":"fa fa-file-alt","description":"Main minutes text and any supplementary notes."},"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields tracking creation and modification."}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('f0d2bff5-ab36-43ad-8cdd-7758b4398705', 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', 'FieldCategoryInfo', '{"Comment Content":{"icon":"fa fa-comment","description":"Core text of the comment, mentions, and resolution status"},"Associations & Threading":{"icon":"fa fa-link","description":"Links to committees, meetings, agenda items, action items, artifacts, and threading hierarchy"},"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('5d2442ed-7497-4065-9072-9142239b439c', '473622EE-DAF0-4A10-8289-F9C14B937A44', 'FieldCategoryInfo', '{"Meeting Overview":{"icon":"fa fa-file-alt","description":"Core identification, committee link, and current status of the meeting"},"Schedule & Timing":{"icon":"fa fa-calendar","description":"Planned dates, times, timezone, and calendar integration details"},"Location & Format":{"icon":"fa fa-map-marker-alt","description":"Physical or virtual location type and address/room information"},"Video Conferencing":{"icon":"fa fa-video","description":"Video platform selection, meeting IDs, join links, recordings, and transcripts"},"System Metadata":{"icon":"fa fa-cog","description":"Audit fields automatically managed by the system"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('04729c2b-7580-4ea0-ab76-9989d8308b42', '58792440-2D28-46CF-BFB3-79A214063E37', 'FieldCategoryIcons', '{"Related Entities":"fa fa-link","Approval Tracking":"fa fa-check-circle","Minutes Content":"fa fa-file-alt","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('1b074616-5291-4935-b351-f32e27db636f', 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1', 'FieldCategoryIcons', '{"Comment Content":"fa fa-comment","Associations & Threading":"fa fa-link","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('45a3b1af-2c91-4c24-b16a-2e018d8e93cd', '473622EE-DAF0-4A10-8289-F9C14B937A44', 'FieldCategoryIcons', '{"Meeting Overview":"fa fa-file-alt","Schedule & Timing":"fa fa-calendar","Location & Format":"fa fa-map-marker-alt","Video Conferencing":"fa fa-video","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=1 for NEW entity (category: supporting, confidence: medium) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 1, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = '58792440-2D28-46CF-BFB3-79A214063E37'
      

/* Set DefaultForNewUser=1 for NEW entity (category: primary, confidence: high) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 1, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = 'BEB0A1C9-045D-4FC4-8EC9-749C236A21F1'
      

/* Set DefaultForNewUser=1 for NEW entity (category: primary, confidence: high) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 1, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = '473622EE-DAF0-4A10-8289-F9C14B937A44'
      

/* Set categories for 14 fields */

-- UPDATE Entity Field Category Info Memberships.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '93C826BA-815D-45F6-B0C5-2A460E66301A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.PersonID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Assignment Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '53E824FA-C4A8-4106-9A41-79124B0E7096' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.Person 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Assignment Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Person Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5DAC39C0-A8FD-490D-8085-E34CAA9BD3DA' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.RoleID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Assignment Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Role',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8B43E54C-FC73-4666-8EE4-207D77941F74' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.Role 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Assignment Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Role Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A097F4F5-8554-42A7-81C6-BB6B72E64669' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.TermID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Term Information',
   GeneratedFormSection = 'Category',
   DisplayName = 'Term',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1FA2B07A-257A-4665-B041-6D92C1AEC0BC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.Term 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Term Information',
   GeneratedFormSection = 'Category',
   DisplayName = 'Term Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5A60D76E-9A8F-4543-A41B-39F27F93B465' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.StartDate 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Term Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '89DCFB9A-DB1E-4E4B-A3A7-786B21B31B49' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.EndDate 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Term Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B836E91C-8B59-4C34-81B7-E7E57B7A57EF' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.Status 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Membership Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'EC0CA348-6190-4924-8715-87D0BBFDD6BE' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.EndReason 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Membership Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BCBC23B7-C308-4A99-9711-19C5527672FA' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.Notes 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Membership Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '615D4B07-2406-4A5F-AF00-5819484D66D2' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E000C682-DE5A-4A73-8A8D-358510B0D6E0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1B10D357-8381-4613-8B89-840316D638C2' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-users */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-users', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = '35AACFD0-C02B-4D1B-AD41-8C081D08650C'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('f8e70e5c-cf4f-4625-8578-51bd07d74702', '35AACFD0-C02B-4D1B-AD41-8C081D08650C', 'FieldCategoryInfo', '{"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit and technical fields"},"Assignment Details":{"icon":"fa fa-user","description":"Person and role assignment information for the committee"},"Term Information":{"icon":"fa fa-calendar-alt","description":"Defines the term period and dates of the membership"},"Membership Status":{"icon":"fa fa-flag-checkered","description":"Current status, termination reason, and any additional notes"},"entityImportance":{"defaultForNewUser":true,"entityCategory":"primary","confidence":"high","reasoning":"Memberships contains many business fields (person, role, term, dates, status, notes) with no foreign‑key ratio but represents a core domain object for tracking committee assignments, so it is treated as a primary entity."}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('c264dba4-be6f-4958-aec2-8102c274e645', '35AACFD0-C02B-4D1B-AD41-8C081D08650C', 'FieldCategoryIcons', '{"System Metadata":"fa fa-cog","Assignment Details":"fa fa-user","Term Information":"fa fa-calendar-alt","Membership Status":"fa fa-flag-checkered"}', GETUTCDATE(), GETUTCDATE())
            

/* Set categories for 18 fields */

-- UPDATE Entity Field Category Info Committees.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '110EABBF-5744-49FD-99E8-716CC570E0EA' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'EC8EFC75-212F-4276-945D-C69996C57EE4' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AFB3A817-FE73-4BEF-BB95-FC6725C95807' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.Name 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Committee Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '601AC8EA-462D-4F6F-89AA-46CEBCD820A6' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Committee Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A5ACF0A8-3FD9-4CD6-B8FA-3B45BB80E004' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.TypeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Committee Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee Type',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '660C3DFB-2DA3-4FF2-AD1B-D581B22C64FB' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.Type 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Committee Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4434A278-78C3-4BF1-98C2-8DB69F1ADC87' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.Status 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Committee Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '68040577-ADF2-4EBF-A80E-FE0BBC205F0B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.IsPublic 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Committee Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CB49F682-7EBD-4E9B-893F-2AE0817EE62A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.ParentCommitteeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Organizational Structure',
   GeneratedFormSection = 'Category',
   DisplayName = 'Parent Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CED94BB1-2B5D-4034-9060-8F5D679B66CE' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.ParentCommittee 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Organizational Structure',
   GeneratedFormSection = 'Category',
   DisplayName = 'Parent Committee Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FF56F679-F952-42DC-AA5B-963961A85640' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.RootParentCommitteeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Organizational Structure',
   GeneratedFormSection = 'Category',
   DisplayName = 'Root Parent Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A6E763C0-D5CA-4B92-9889-4C7D5B2C09B0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.OrganizationID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Organizational Structure',
   GeneratedFormSection = 'Category',
   DisplayName = 'Organization',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BA0A2BD5-DBFA-494E-97A9-000E4DC208E4' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.Organization 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Organizational Structure',
   GeneratedFormSection = 'Category',
   DisplayName = 'Organization Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '154DE67D-4553-449F-A34D-9B60A5D194BD' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.CharterDocumentURL 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Governance & Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '11ECF6DA-8508-4656-80F3-AD7EEA41FB18' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.MissionStatement 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Governance & Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '47717ED1-6B71-448D-9908-D20ECD28BC73' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.FormationDate 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Governance & Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5803A860-EF51-4956-A0EE-844DFC2CE4C3' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.DissolutionDate 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Governance & Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '35C31F10-B0DC-481B-9940-626C9FDBE2CA' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-users */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-users', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('31525c06-9125-416c-9134-8bfc82602646', '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', 'FieldCategoryInfo', '{"Committee Details":{"icon":"fa fa-id-card","description":"Core identifying and status information for a committee"},"Organizational Structure":{"icon":"fa fa-sitemap","description":"Hierarchy and organization relationships of the committee"},"Governance & Timeline":{"icon":"fa fa-file-alt","description":"Charter, mission, and key dates defining the committee’s lifecycle"},"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('451154f8-af4b-4e9f-8257-be1dbdc246c1', '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0', 'FieldCategoryIcons', '{"Committee Details":"fa fa-id-card","Organizational Structure":"fa fa-sitemap","Governance & Timeline":"fa fa-file-alt","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=1 for NEW entity (category: primary, confidence: high) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 1, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = '74AE48B6-CDDB-40B7-B987-34DAFCB94FB0'
      

/* Set field properties for entity */

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '9540EDE1-741A-4B6F-B9F0-8DE3C3EDFC31'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'D43ECA52-4B7A-434E-92CE-C3FF69824306'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '63BB48D1-67C2-4CD9-BDD9-F86F6154F77C'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'B0408D09-CF61-4D1D-B951-8E0C5490BD29'
               AND AutoUpdateDefaultInView = 1
            

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '1B312AA3-5CCC-48E6-B034-A8BF437C9A4D'
               AND AutoUpdateDefaultInView = 1
            

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '28DAA78C-FABD-438D-8F24-055987B58B60'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'EFD20ADA-E18B-41DC-8F4F-F4ED58FE0165'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '97844D3B-A436-4CE7-8246-976BA9FF9A87'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '0AFC293D-E93D-4BD2-A71C-ACB2631CA278'
               AND AutoUpdateDefaultInView = 1
            

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '1D7E13DF-447A-49B8-9A07-1FA0CC058115'
               AND AutoUpdateDefaultInView = 1
            

/* Set field properties for entity */

            UPDATE [${flyway:defaultSchema}].[EntityField]
            SET IsNameField = 1
            WHERE ID = '1F8EC6D8-AC5B-4407-BE83-58EE1786B1CE'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '5F2C0387-0976-4C2B-A009-52548EB7F84A'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '1F8EC6D8-AC5B-4407-BE83-58EE1786B1CE'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '3F71B06A-8912-4201-9124-3E7FAC45574D'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'A46EED10-5CE2-422D-8324-EC36DDF88F6D'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '1F8EC6D8-AC5B-4407-BE83-58EE1786B1CE'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '3F71B06A-8912-4201-9124-3E7FAC45574D'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'A46EED10-5CE2-422D-8324-EC36DDF88F6D'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'CBD2405F-9FD7-4495-992E-48B2154DE9B7'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'B1992EE9-B079-40F3-BE6E-06094DA729ED'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '41895295-C70A-43B0-9B0A-F4F535495884'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '1EC883D0-0C4C-45DD-A59F-5DA1C2E7B8CD'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '41895295-C70A-43B0-9B0A-F4F535495884'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '1EC883D0-0C4C-45DD-A59F-5DA1C2E7B8CD'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '914644FA-62CA-4763-9E0F-2E3CFC9AC4C2'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'BC1C0E23-80DE-48E9-911F-B0B327AE79CC'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '914644FA-62CA-4763-9E0F-2E3CFC9AC4C2'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '8B674F0D-49A4-4F80-85CB-76501289B887'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '551DE0AD-D745-42B2-AC86-F5CCD0BE1F4C'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '81F9254D-D977-4FD5-B73D-2C1E3B0D234D'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '8B674F0D-49A4-4F80-85CB-76501289B887'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'EAE1F5A3-12E3-473F-886A-A5F35201392A'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '51040B52-E73D-447C-AFB4-FEA5536153E5'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '14D45C1C-68EE-4F7D-973A-68517AF0ABDE'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'EDFC47E9-616A-4849-AAA7-59FAF853B0A1'
               AND AutoUpdateDefaultInView = 1
            

/* Set categories for 9 fields */

-- UPDATE Entity Field Category Info Roles.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8C199FEE-16EE-4E47-80B1-5C7F082622D9' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Roles.Name 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Role Definition',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '120680CC-02AC-4750-8C74-562BE10A75DF' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Roles.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Role Definition',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '23AEDA85-E83A-44EF-8182-76490F6AE84B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Roles.Sequence 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Role Definition',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'EDFC47E9-616A-4849-AAA7-59FAF853B0A1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Roles.IsOfficer 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Role Permissions',
   GeneratedFormSection = 'Category',
   DisplayName = 'Officer Role',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '51040B52-E73D-447C-AFB4-FEA5536153E5' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Roles.IsVotingRole 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Role Permissions',
   GeneratedFormSection = 'Category',
   DisplayName = 'Voting Role',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '14D45C1C-68EE-4F7D-973A-68517AF0ABDE' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Roles.DefaultPermissionsJSON 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Role Permissions',
   GeneratedFormSection = 'Category',
   DisplayName = 'Default Permissions (JSON)',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1D4FFF56-00C3-49D4-BBB9-869F9BFAA828' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Roles.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D3044CA2-8D5C-45C9-B94D-2312E44F9734' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Roles.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '254C51EB-4F8B-4973-8823-B60963C5F6DA' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-user-shield */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-user-shield', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = 'E170A834-9278-49DB-9F73-08945C0E83DF'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('ccc1b087-d4f6-4adc-bc45-2fcdd888c38d', 'E170A834-9278-49DB-9F73-08945C0E83DF', 'FieldCategoryInfo', '{"Role Definition":{"icon":"fa fa-id-badge","description":"Core details of the role such as name, description and display order"},"Role Permissions":{"icon":"fa fa-shield-alt","description":"Settings that define the role’s authority, voting rights, and default permissions"},"System Metadata":{"icon":"fa fa-cog","description":"Audit timestamps and internal identifier"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('0a18e71f-1f17-4982-bf19-3ffef8e831f6', 'E170A834-9278-49DB-9F73-08945C0E83DF', 'FieldCategoryIcons', '{"Role Definition":"fa fa-id-badge","Role Permissions":"fa fa-shield-alt","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=0 for NEW entity (category: reference, confidence: high) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 0, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = 'E170A834-9278-49DB-9F73-08945C0E83DF'
      

/* Set categories for 9 fields */

-- UPDATE Entity Field Category Info Video Providers.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'DADEC113-06AB-4D7C-8D9B-ED75172A90C5' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Video Providers.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '527C3815-3082-439E-8331-9AEFF102C866' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Video Providers.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1E432657-D46C-4CA5-8D01-3F30F8B76B02' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Video Providers.Name 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Provider Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '34AC88AE-D104-469A-8DCC-D71DAB02E7C2' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Video Providers.ServerDriverKey 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Provider Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8B674F0D-49A4-4F80-85CB-76501289B887' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Video Providers.IsDefault 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Provider Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Default',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '81F9254D-D977-4FD5-B73D-2C1E3B0D234D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Video Providers.IsActive 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Access Settings',
   GeneratedFormSection = 'Category',
   DisplayName = 'Active',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '551DE0AD-D745-42B2-AC86-F5CCD0BE1F4C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Video Providers.CredentialID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Access Settings',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2B9ECA4A-F682-465D-9820-D9AFB50FFCE7' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Video Providers.Credential 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Access Settings',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'EAE1F5A3-12E3-473F-886A-A5F35201392A' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-video */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-video', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('31b5193b-ec92-47c5-9c8a-32da576dc06d', '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC', 'FieldCategoryInfo', '{"Provider Details":{"icon":"fa fa-video","description":"Core definition of the video provider such as name, driver key and default flag"},"Access Settings":{"icon":"fa fa-key","description":"Activation status and credential information required to connect to the provider"},"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('d6f35572-e4b4-43a3-bcd4-ca8ca5d3bc68', '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC', 'FieldCategoryIcons', '{"Provider Details":"fa fa-video","Access Settings":"fa fa-key","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=0 for NEW entity (category: reference, confidence: high) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 0, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = '236E9D2A-60E6-4CC7-BEFA-43F70A24C6DC'
      

/* Set categories for 9 fields */

-- UPDATE Entity Field Category Info Terms.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CDFFD509-B268-4C92-A8ED-5960BF6AE462' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Terms.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C35FF0CC-859E-4948-AB8B-561F52BAA0D0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Terms.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5DC338BF-AA89-4B21-A2EA-06E532E63800' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Terms.CommitteeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Committee Association',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6129241C-C879-4369-B1AD-D97F350E2BCB' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Terms.Committee 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Committee Association',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1EC883D0-0C4C-45DD-A59F-5DA1C2E7B8CD' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Terms.Name 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Committee Association',
   GeneratedFormSection = 'Category',
   DisplayName = 'Term Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C2C0F6EF-76BA-4C48-83C6-B2062DAAEEFA' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Terms.StartDate 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Term Schedule',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CBD2405F-9FD7-4495-992E-48B2154DE9B7' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Terms.EndDate 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Term Schedule',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B1992EE9-B079-40F3-BE6E-06094DA729ED' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Terms.Status 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Term Schedule',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '41895295-C70A-43B0-9B0A-F4F535495884' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-calendar-alt */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-calendar-alt', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('e757402c-fa6e-4993-97dd-1cd1467a28d6', '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4', 'FieldCategoryInfo', '{"Committee Association":{"icon":"fa fa-users","description":"Links a term to its committee and provides the term''s display name"},"Term Schedule":{"icon":"fa fa-calendar","description":"Defines the timeframe of the term and its current status"},"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('f5264d9a-8a48-463d-832d-6b5b7f18fc91', '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4', 'FieldCategoryIcons', '{"Committee Association":"fa fa-users","Term Schedule":"fa fa-calendar","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=0 for NEW entity (category: reference, confidence: high) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 0, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = '2C53B672-EA32-465C-BEAB-CD20E8D2E9C4'
      

/* Set categories for 8 fields */

-- UPDATE Entity Field Category Info Types.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D56B65C7-E8E3-463E-9ABC-661BC0406553' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Types.Name 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Committee Type Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '58616D5A-A379-408F-84FC-3CB9D14CEB33' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Types.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Committee Type Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '914644FA-62CA-4763-9E0F-2E3CFC9AC4C2' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Types.IsStandards 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Committee Type Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'DEF17150-4245-4D7B-9FE3-F1544D9B19C3' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Types.DefaultTermMonths 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Committee Type Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BC1C0E23-80DE-48E9-911F-B0B327AE79CC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Types.IconClass 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Committee Type Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '13BAABE3-F100-4A0C-B8CF-2E3FE0D19D9C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Types.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B36FFDA1-8635-479B-97BC-B27336C0936B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Types.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F6B4C1EE-B6A0-4D0F-9B9A-97ACB7AA6E87' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-clipboard-list */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-clipboard-list', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = '1B9BF218-367F-452E-9DD9-BDE6F306F742'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('93405b86-0119-4015-8c79-3dc4b00e719e', '1B9BF218-367F-452E-9DD9-BDE6F306F742', 'FieldCategoryInfo', '{"Committee Type Details":{"icon":"fa fa-file-alt","description":"Core attributes that define a committee type, including name, description, standards flag, default term and UI icon"},"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('275e38ce-f9b9-45ee-b116-c0d8bcaade84', '1B9BF218-367F-452E-9DD9-BDE6F306F742', 'FieldCategoryIcons', '{"Committee Type Details":"fa fa-file-alt","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=0 for NEW entity (category: reference, confidence: high) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 0, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = '1B9BF218-367F-452E-9DD9-BDE6F306F742'
      

/* Set categories for 16 fields */

-- UPDATE Entity Field Category Info Motions.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Motion Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3EFDF79B-3B02-4DA6-A33D-502F5C2702BF' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.MeetingID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Motion Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D46F61F7-265C-4687-BAE1-7D3A2D1F5C2F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.AgendaItemID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Motion Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CE0221A7-9EFC-43BC-B2D8-7A6B1C55B849' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.Sequence 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Motion Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5F2C0387-0976-4C2B-A009-52548EB7F84A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.Title 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Motion Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1F8EC6D8-AC5B-4407-BE83-58EE1786B1CE' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Motion Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F70EFF1D-6308-4021-B85C-172D4B2F53B6' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.Notes 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Motion Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'DA69E947-6AF8-4026-AB71-419D43D4A649' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.MovedByMembershipID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Voting Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Moved By',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C98EBC65-314A-4B79-82C4-4C9281CCC1E0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.SecondedByMembershipID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Voting Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Seconded By',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3D58199E-DC98-48A0-A1EA-FDD4DEFA5534' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.Result 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Voting Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3F71B06A-8912-4201-9124-3E7FAC45574D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.ResultSummary 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Voting Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A46EED10-5CE2-422D-8324-EC36DDF88F6D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.YesCount 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Voting Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '29D3A37C-D17C-407E-9D92-E5E2FA2E9701' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.NoCount 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Voting Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '46CFE2C7-44A8-43EA-9D2F-36D0C480465F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.AbstainCount 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Voting Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C9329FA1-D6BE-4852-BD67-DE50C2E44481' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8BCF5C41-B87B-4BB9-BE56-E602B5F63AA0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'ECE56826-2844-4C49-8EDB-3FC9EB48282D' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-gavel */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-gavel', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = '36D14C54-9D93-4A39-A282-6BF7B997B70E'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('541e5b95-cc29-47df-a439-e893d8106572', '36D14C54-9D93-4A39-A282-6BF7B997B70E', 'FieldCategoryInfo', '{"Motion Details":{"icon":"fa fa-file-alt","description":"Core information that defines the motion, including identifiers, title, description and any notes."},"Voting Details":{"icon":"fa fa-balance-scale","description":"Information about who moved/seconded the motion and the voting results, counts and summary."},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit fields tracking creation and modification timestamps."}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('38e2d4b3-602a-444c-9a54-b7e94820a875', '36D14C54-9D93-4A39-A282-6BF7B997B70E', 'FieldCategoryIcons', '{"Motion Details":"fa fa-file-alt","Voting Details":"fa fa-balance-scale","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=1 for NEW entity (category: primary, confidence: high) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 1, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = '36D14C54-9D93-4A39-A282-6BF7B997B70E'
      

/* Set field properties for entity */

            UPDATE [${flyway:defaultSchema}].[EntityField]
            SET IsNameField = 1
            WHERE ID = '5C9F9821-5901-46A1-8210-1C75CD49F08D'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '5C9F9821-5901-46A1-8210-1C75CD49F08D'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '53CA9655-3F05-4CD9-8CF0-2C78E0FC77D3'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '5C9F9821-5901-46A1-8210-1C75CD49F08D'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '53CA9655-3F05-4CD9-8CF0-2C78E0FC77D3'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set categories for 7 fields */

-- UPDATE Entity Field Category Info Votes.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C5DDC77C-9397-44A6-AD5F-219A1A206CC6' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '53CE271E-6E6F-4DEC-98BA-1A106FCAA11B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A5C4E322-1F70-4B11-B08B-C833A42095BA' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.MotionID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Records',
   GeneratedFormSection = 'Category',
   DisplayName = 'Motion',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '62CD5C9A-2F86-4189-8901-C4C1A65A6351' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.MembershipID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Records',
   GeneratedFormSection = 'Category',
   DisplayName = 'Membership',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5D0D39BF-0669-4DCC-BE93-E1EB93D8376A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.VoteValue 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Vote Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Vote',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5C9F9821-5901-46A1-8210-1C75CD49F08D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.Notes 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Vote Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '53CA9655-3F05-4CD9-8CF0-2C78E0FC77D3' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-ballot */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-ballot', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = 'CCC2482F-5E43-4E5A-886F-476F7C9F2C71'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('bd152778-7d90-44df-a569-271ab3832d27', 'CCC2482F-5E43-4E5A-886F-476F7C9F2C71', 'FieldCategoryInfo', '{"Vote Details":{"icon":"fa fa-check-circle","description":"Core voting outcome and any accompanying commentary"},"Related Records":{"icon":"fa fa-link","description":"References to the motion and the member that produced the vote"},"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('8694d2d0-694f-4aab-a755-4f6a40374c6d', 'CCC2482F-5E43-4E5A-886F-476F7C9F2C71', 'FieldCategoryIcons', '{"Vote Details":"fa fa-check-circle","Related Records":"fa fa-link","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=1 for NEW entity (category: supporting, confidence: medium) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 1, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = 'CCC2482F-5E43-4E5A-886F-476F7C9F2C71'
      

/* Refresh custom base views for modified entities so schema changes are picked up */
EXEC sp_refreshview '${flyway:defaultSchema}_BizAppsCommon.vwOrganizationsExtended';
EXEC sp_refreshview '${flyway:defaultSchema}_BizAppsCommon.vwPeopleExtended';

