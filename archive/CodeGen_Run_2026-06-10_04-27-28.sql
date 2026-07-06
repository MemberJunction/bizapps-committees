/* SQL generated to create new entity Committees: Agenda Items */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
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
         '5746f567-3a1b-4772-b8ba-d46d98a137dd',
         'Committees: Agenda Items',
         'Agenda Items',
         'Structured agenda items for meetings with hierarchy support',
         NULL,
         'AgendaItem',
         'vwAgendaItems',
         '${mjSchema}_Committees',
         1,
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
      );

/* SQL generated to create new application ${mjSchema}_Committees */
INSERT INTO [${mjSchema}].[Application] (ID, Name, Description, SchemaAutoAddNewEntities, Path, AutoUpdatePath)
                       VALUES ('55b10589-0a5c-4fbc-b755-48d26680632f', '${mjSchema}_Committees', 'Generated for schema', '${mjSchema}_Committees', 'mjcommittees', 1);

/* Adding role UI to application ${mjSchema}_Committees */
INSERT INTO [${mjSchema}].[ApplicationRole]
                                 ([ApplicationID], [RoleID], [CanAccess], [CanAdmin]) VALUES
                                 ('55b10589-0a5c-4fbc-b755-48d26680632f', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0);

/* Adding role Developer to application ${mjSchema}_Committees */
INSERT INTO [${mjSchema}].[ApplicationRole]
                                 ([ApplicationID], [RoleID], [CanAccess], [CanAdmin]) VALUES
                                 ('55b10589-0a5c-4fbc-b755-48d26680632f', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1);

/* Adding role Integration to application ${mjSchema}_Committees */
INSERT INTO [${mjSchema}].[ApplicationRole]
                                 ([ApplicationID], [RoleID], [CanAccess], [CanAdmin]) VALUES
                                 ('55b10589-0a5c-4fbc-b755-48d26680632f', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0);

/* SQL generated to add new entity Committees: Agenda Items to application ID: '55b10589-0a5c-4fbc-b755-48d26680632f' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('55b10589-0a5c-4fbc-b755-48d26680632f', '5746f567-3a1b-4772-b8ba-d46d98a137dd', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '55b10589-0a5c-4fbc-b755-48d26680632f'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Agenda Items for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('5746f567-3a1b-4772-b8ba-d46d98a137dd', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Agenda Items for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('5746f567-3a1b-4772-b8ba-d46d98a137dd', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Agenda Items for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('5746f567-3a1b-4772-b8ba-d46d98a137dd', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Attendances */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
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
         '9d005287-0d07-436b-b4d4-aae31c42bfa7',
         'Committees: Attendances',
         'Attendances',
         'Meeting attendance records for committee members',
         NULL,
         'Attendance',
         'vwAttendances',
         '${mjSchema}_Committees',
         1,
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
      );

/* SQL generated to add new entity Committees: Attendances to application ID: '55B10589-0A5C-4FBC-B755-48D26680632F' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('55B10589-0A5C-4FBC-B755-48D26680632F', '9d005287-0d07-436b-b4d4-aae31c42bfa7', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '55B10589-0A5C-4FBC-B755-48D26680632F'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Attendances for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('9d005287-0d07-436b-b4d4-aae31c42bfa7', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Attendances for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('9d005287-0d07-436b-b4d4-aae31c42bfa7', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Attendances for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('9d005287-0d07-436b-b4d4-aae31c42bfa7', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Action Items */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
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
         'f4b63a74-6704-4ca9-97b5-d2ec745b0506',
         'Committees: Action Items',
         'Action Items',
         'Legacy action items assigned from committees or meetings (superseded by BizAppsTasks)',
         NULL,
         'ActionItem',
         'vwActionItems',
         '${mjSchema}_Committees',
         1,
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
      );

/* SQL generated to add new entity Committees: Action Items to application ID: '55B10589-0A5C-4FBC-B755-48D26680632F' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('55B10589-0A5C-4FBC-B755-48D26680632F', 'f4b63a74-6704-4ca9-97b5-d2ec745b0506', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '55B10589-0A5C-4FBC-B755-48D26680632F'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Action Items for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('f4b63a74-6704-4ca9-97b5-d2ec745b0506', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Action Items for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('f4b63a74-6704-4ca9-97b5-d2ec745b0506', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Action Items for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('f4b63a74-6704-4ca9-97b5-d2ec745b0506', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Artifact Types */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
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
         '8e6153b6-bc78-4ae8-b42d-34d7e2217555',
         'Committees: Artifact Types',
         'Artifact Types',
         'Categories of committee artifacts with optional extension entity for type-specific fields',
         NULL,
         'ArtifactType',
         'vwArtifactTypes',
         '${mjSchema}_Committees',
         1,
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
      );

/* SQL generated to add new entity Committees: Artifact Types to application ID: '55B10589-0A5C-4FBC-B755-48D26680632F' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('55B10589-0A5C-4FBC-B755-48D26680632F', '8e6153b6-bc78-4ae8-b42d-34d7e2217555', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '55B10589-0A5C-4FBC-B755-48D26680632F'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Artifact Types for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('8e6153b6-bc78-4ae8-b42d-34d7e2217555', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Artifact Types for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('8e6153b6-bc78-4ae8-b42d-34d7e2217555', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Artifact Types for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('8e6153b6-bc78-4ae8-b42d-34d7e2217555', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Artifacts */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
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
         '3011be1c-a871-4536-9855-2e58a28a206e',
         'Committees: Artifacts',
         'Artifacts',
         'Links to external documents and files from various providers',
         NULL,
         'Artifact',
         'vwArtifacts',
         '${mjSchema}_Committees',
         1,
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
      );

/* SQL generated to add new entity Committees: Artifacts to application ID: '55B10589-0A5C-4FBC-B755-48D26680632F' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('55B10589-0A5C-4FBC-B755-48D26680632F', '3011be1c-a871-4536-9855-2e58a28a206e', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '55B10589-0A5C-4FBC-B755-48D26680632F'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Artifacts for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('3011be1c-a871-4536-9855-2e58a28a206e', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Artifacts for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('3011be1c-a871-4536-9855-2e58a28a206e', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Artifacts for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('3011be1c-a871-4536-9855-2e58a28a206e', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Minutes */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
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
         '338f9b03-8689-4bd0-8ef1-03b84b90e4d9',
         'Committees: Minutes',
         'Minutes',
         'Meeting minutes with approval tracking; stored as markdown Content or linked Artifact',
         NULL,
         'Minute',
         'vwMinutes',
         '${mjSchema}_Committees',
         1,
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
      );

/* SQL generated to add new entity Committees: Minutes to application ID: '55B10589-0A5C-4FBC-B755-48D26680632F' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('55B10589-0A5C-4FBC-B755-48D26680632F', '338f9b03-8689-4bd0-8ef1-03b84b90e4d9', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '55B10589-0A5C-4FBC-B755-48D26680632F'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Minutes for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('338f9b03-8689-4bd0-8ef1-03b84b90e4d9', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Minutes for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('338f9b03-8689-4bd0-8ef1-03b84b90e4d9', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Minutes for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('338f9b03-8689-4bd0-8ef1-03b84b90e4d9', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Motions */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
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
         '02f0d003-4f6d-4f8e-9cfe-1a6e3c0df906',
         'Committees: Motions',
         'Motions',
         'Formal motions put to vote during committee meetings',
         NULL,
         'Motion',
         'vwMotions',
         '${mjSchema}_Committees',
         1,
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
      );

/* SQL generated to add new entity Committees: Motions to application ID: '55B10589-0A5C-4FBC-B755-48D26680632F' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('55B10589-0A5C-4FBC-B755-48D26680632F', '02f0d003-4f6d-4f8e-9cfe-1a6e3c0df906', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '55B10589-0A5C-4FBC-B755-48D26680632F'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Motions for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('02f0d003-4f6d-4f8e-9cfe-1a6e3c0df906', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Motions for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('02f0d003-4f6d-4f8e-9cfe-1a6e3c0df906', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Motions for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('02f0d003-4f6d-4f8e-9cfe-1a6e3c0df906', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Votes */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
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
         '80299a27-b207-4d99-a46b-4e5b8a2b5e62',
         'Committees: Votes',
         'Votes',
         'Individual vote records for committee motions',
         NULL,
         'Vote',
         'vwVotes',
         '${mjSchema}_Committees',
         1,
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
      );

/* SQL generated to add new entity Committees: Votes to application ID: '55B10589-0A5C-4FBC-B755-48D26680632F' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('55B10589-0A5C-4FBC-B755-48D26680632F', '80299a27-b207-4d99-a46b-4e5b8a2b5e62', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '55B10589-0A5C-4FBC-B755-48D26680632F'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Votes for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('80299a27-b207-4d99-a46b-4e5b8a2b5e62', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Votes for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('80299a27-b207-4d99-a46b-4e5b8a2b5e62', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Votes for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('80299a27-b207-4d99-a46b-4e5b8a2b5e62', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Comments */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
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
         '349618ad-3f1c-481c-8406-302817363510',
         'Committees: Comments',
         'Comments',
         'Threaded discussion comments on committee meetings, agenda items, tasks, and documents',
         NULL,
         'Comment',
         'vwComments',
         '${mjSchema}_Committees',
         1,
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
      );

/* SQL generated to add new entity Committees: Comments to application ID: '55B10589-0A5C-4FBC-B755-48D26680632F' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('55B10589-0A5C-4FBC-B755-48D26680632F', '349618ad-3f1c-481c-8406-302817363510', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '55B10589-0A5C-4FBC-B755-48D26680632F'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Comments for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('349618ad-3f1c-481c-8406-302817363510', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Comments for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('349618ad-3f1c-481c-8406-302817363510', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Comments for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('349618ad-3f1c-481c-8406-302817363510', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Types */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
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
         '1d7f24c0-622e-41e0-bc38-29c2eeb1d442',
         'Committees: Types',
         'Types',
         'Categories of committees such as Board, Standing, Ad Hoc, Workgroup',
         NULL,
         'Type',
         'vwTypes',
         '${mjSchema}_Committees',
         1,
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
      );

/* SQL generated to add new entity Committees: Types to application ID: '55B10589-0A5C-4FBC-B755-48D26680632F' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('55B10589-0A5C-4FBC-B755-48D26680632F', '1d7f24c0-622e-41e0-bc38-29c2eeb1d442', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '55B10589-0A5C-4FBC-B755-48D26680632F'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Types for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('1d7f24c0-622e-41e0-bc38-29c2eeb1d442', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Types for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('1d7f24c0-622e-41e0-bc38-29c2eeb1d442', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Types for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('1d7f24c0-622e-41e0-bc38-29c2eeb1d442', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Committees */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
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
         'a42f4a6f-c411-42f1-a977-4a5b1fb9fa38',
         'Committees: Committees',
         'Committees',
         'Core committee records with hierarchy support',
         NULL,
         'Committee',
         'vwCommittees',
         '${mjSchema}_Committees',
         1,
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
      );

/* SQL generated to add new entity Committees: Committees to application ID: '55B10589-0A5C-4FBC-B755-48D26680632F' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('55B10589-0A5C-4FBC-B755-48D26680632F', 'a42f4a6f-c411-42f1-a977-4a5b1fb9fa38', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '55B10589-0A5C-4FBC-B755-48D26680632F'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Committees for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('a42f4a6f-c411-42f1-a977-4a5b1fb9fa38', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Committees for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('a42f4a6f-c411-42f1-a977-4a5b1fb9fa38', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Committees for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('a42f4a6f-c411-42f1-a977-4a5b1fb9fa38', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Terms */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
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
         'ead3ef14-1891-4389-a0f3-1984bc8cc13f',
         'Committees: Terms',
         'Terms',
         'Time periods for committee membership cycles',
         NULL,
         'Term',
         'vwTerms',
         '${mjSchema}_Committees',
         1,
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
      );

/* SQL generated to add new entity Committees: Terms to application ID: '55B10589-0A5C-4FBC-B755-48D26680632F' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('55B10589-0A5C-4FBC-B755-48D26680632F', 'ead3ef14-1891-4389-a0f3-1984bc8cc13f', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '55B10589-0A5C-4FBC-B755-48D26680632F'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Terms for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('ead3ef14-1891-4389-a0f3-1984bc8cc13f', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Terms for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('ead3ef14-1891-4389-a0f3-1984bc8cc13f', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Terms for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('ead3ef14-1891-4389-a0f3-1984bc8cc13f', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Roles */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
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
         'cf2605ab-3f2c-4d18-b663-60105bfc2bcc',
         'Committees: Roles',
         'Roles',
         'Roles that members can hold on committees',
         NULL,
         'Role',
         'vwRoles',
         '${mjSchema}_Committees',
         1,
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
      );

/* SQL generated to add new entity Committees: Roles to application ID: '55B10589-0A5C-4FBC-B755-48D26680632F' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('55B10589-0A5C-4FBC-B755-48D26680632F', 'cf2605ab-3f2c-4d18-b663-60105bfc2bcc', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '55B10589-0A5C-4FBC-B755-48D26680632F'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Roles for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('cf2605ab-3f2c-4d18-b663-60105bfc2bcc', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Roles for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('cf2605ab-3f2c-4d18-b663-60105bfc2bcc', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Roles for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('cf2605ab-3f2c-4d18-b663-60105bfc2bcc', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Memberships */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
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
         '31a4f9b1-b185-4bdd-bde4-ede7f8e03c42',
         'Committees: Memberships',
         'Memberships',
         'Person assignments to committees with roles and terms',
         NULL,
         'Membership',
         'vwMemberships',
         '${mjSchema}_Committees',
         1,
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
      );

/* SQL generated to add new entity Committees: Memberships to application ID: '55B10589-0A5C-4FBC-B755-48D26680632F' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('55B10589-0A5C-4FBC-B755-48D26680632F', '31a4f9b1-b185-4bdd-bde4-ede7f8e03c42', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '55B10589-0A5C-4FBC-B755-48D26680632F'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Memberships for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('31a4f9b1-b185-4bdd-bde4-ede7f8e03c42', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Memberships for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('31a4f9b1-b185-4bdd-bde4-ede7f8e03c42', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Memberships for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('31a4f9b1-b185-4bdd-bde4-ede7f8e03c42', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Video Providers */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
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
         'b100ffc7-5ab7-4e86-a58a-b9fc146a4de9',
         'Committees: Video Providers',
         'Video Providers',
         'Configured video conferencing providers for auto-creating meeting URLs',
         NULL,
         'VideoProvider',
         'vwVideoProviders',
         '${mjSchema}_Committees',
         1,
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
      );

/* SQL generated to add new entity Committees: Video Providers to application ID: '55B10589-0A5C-4FBC-B755-48D26680632F' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('55B10589-0A5C-4FBC-B755-48D26680632F', 'b100ffc7-5ab7-4e86-a58a-b9fc146a4de9', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '55B10589-0A5C-4FBC-B755-48D26680632F'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Video Providers for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('b100ffc7-5ab7-4e86-a58a-b9fc146a4de9', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Video Providers for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('b100ffc7-5ab7-4e86-a58a-b9fc146a4de9', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Video Providers for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('b100ffc7-5ab7-4e86-a58a-b9fc146a4de9', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to create new entity Committees: Meetings */

      INSERT INTO [${mjSchema}].[Entity] (
         [ID],
         [Name],
         [DisplayName],
         [Description],
         [NameSuffix],
         [BaseTable],
         [BaseView],
         [SchemaName],
         [IncludeInAPI],
         [AllowUserSearchAPI],
         [AllowCaching]
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
         'f05be747-6f2a-472e-8800-8a10d416eaa1',
         'Committees: Meetings',
         'Meetings',
         'Committee meeting records with scheduling and video conferencing info',
         NULL,
         'Meeting',
         'vwMeetings',
         '${mjSchema}_Committees',
         1,
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
      );

/* SQL generated to add new entity Committees: Meetings to application ID: '55B10589-0A5C-4FBC-B755-48D26680632F' */
INSERT INTO [${mjSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('55B10589-0A5C-4FBC-B755-48D26680632F', 'f05be747-6f2a-472e-8800-8a10d416eaa1', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${mjSchema}].[ApplicationEntity] WHERE [ApplicationID] = '55B10589-0A5C-4FBC-B755-48D26680632F'), GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Meetings for role UI */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('f05be747-6f2a-472e-8800-8a10d416eaa1', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Meetings for role Developer */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('f05be747-6f2a-472e-8800-8a10d416eaa1', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL generated to add new permission for entity Committees: Meetings for role Integration */
INSERT INTO [${mjSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('f05be747-6f2a-472e-8800-8a10d416eaa1', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE());

/* SQL text to update existing entities from schema */
EXEC [${mjSchema}].[spUpdateExistingEntitiesFromSchema] @ExcludedSchemaNames='sys,staging,${mjSchema},${mjSchema}_BizAppsCommon,${mjSchema}_BizAppsTasks';

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Minute */
ALTER TABLE [${mjSchema}_Committees].[Minute] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Minute */
UPDATE [${mjSchema}_Committees].[Minute] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Minute */
ALTER TABLE [${mjSchema}_Committees].[Minute] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Minute */
ALTER TABLE [${mjSchema}_Committees].[Minute] ADD CONSTRAINT [DF___mj_Committees_Minute___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Minute */
ALTER TABLE [${mjSchema}_Committees].[Minute] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Minute */
UPDATE [${mjSchema}_Committees].[Minute] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Minute */
ALTER TABLE [${mjSchema}_Committees].[Minute] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Minute */
ALTER TABLE [${mjSchema}_Committees].[Minute] ADD CONSTRAINT [DF___mj_Committees_Minute___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Term */
ALTER TABLE [${mjSchema}_Committees].[Term] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Term */
UPDATE [${mjSchema}_Committees].[Term] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Term */
ALTER TABLE [${mjSchema}_Committees].[Term] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Term */
ALTER TABLE [${mjSchema}_Committees].[Term] ADD CONSTRAINT [DF___mj_Committees_Term___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Term */
ALTER TABLE [${mjSchema}_Committees].[Term] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Term */
UPDATE [${mjSchema}_Committees].[Term] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Term */
ALTER TABLE [${mjSchema}_Committees].[Term] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Term */
ALTER TABLE [${mjSchema}_Committees].[Term] ADD CONSTRAINT [DF___mj_Committees_Term___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Motion */
ALTER TABLE [${mjSchema}_Committees].[Motion] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Motion */
UPDATE [${mjSchema}_Committees].[Motion] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Motion */
ALTER TABLE [${mjSchema}_Committees].[Motion] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Motion */
ALTER TABLE [${mjSchema}_Committees].[Motion] ADD CONSTRAINT [DF___mj_Committees_Motion___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Motion */
ALTER TABLE [${mjSchema}_Committees].[Motion] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Motion */
UPDATE [${mjSchema}_Committees].[Motion] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Motion */
ALTER TABLE [${mjSchema}_Committees].[Motion] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Motion */
ALTER TABLE [${mjSchema}_Committees].[Motion] ADD CONSTRAINT [DF___mj_Committees_Motion___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Type */
ALTER TABLE [${mjSchema}_Committees].[Type] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Type */
UPDATE [${mjSchema}_Committees].[Type] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Type */
ALTER TABLE [${mjSchema}_Committees].[Type] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Type */
ALTER TABLE [${mjSchema}_Committees].[Type] ADD CONSTRAINT [DF___mj_Committees_Type___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Type */
ALTER TABLE [${mjSchema}_Committees].[Type] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Type */
UPDATE [${mjSchema}_Committees].[Type] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Type */
ALTER TABLE [${mjSchema}_Committees].[Type] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Type */
ALTER TABLE [${mjSchema}_Committees].[Type] ADD CONSTRAINT [DF___mj_Committees_Type___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Artifact */
ALTER TABLE [${mjSchema}_Committees].[Artifact] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Artifact */
UPDATE [${mjSchema}_Committees].[Artifact] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Artifact */
ALTER TABLE [${mjSchema}_Committees].[Artifact] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Artifact */
ALTER TABLE [${mjSchema}_Committees].[Artifact] ADD CONSTRAINT [DF___mj_Committees_Artifact___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Artifact */
ALTER TABLE [${mjSchema}_Committees].[Artifact] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Artifact */
UPDATE [${mjSchema}_Committees].[Artifact] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Artifact */
ALTER TABLE [${mjSchema}_Committees].[Artifact] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Artifact */
ALTER TABLE [${mjSchema}_Committees].[Artifact] ADD CONSTRAINT [DF___mj_Committees_Artifact___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Comment */
ALTER TABLE [${mjSchema}_Committees].[Comment] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Comment */
UPDATE [${mjSchema}_Committees].[Comment] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Comment */
ALTER TABLE [${mjSchema}_Committees].[Comment] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Comment */
ALTER TABLE [${mjSchema}_Committees].[Comment] ADD CONSTRAINT [DF___mj_Committees_Comment___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Comment */
ALTER TABLE [${mjSchema}_Committees].[Comment] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Comment */
UPDATE [${mjSchema}_Committees].[Comment] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Comment */
ALTER TABLE [${mjSchema}_Committees].[Comment] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Comment */
ALTER TABLE [${mjSchema}_Committees].[Comment] ADD CONSTRAINT [DF___mj_Committees_Comment___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.ArtifactType */
ALTER TABLE [${mjSchema}_Committees].[ArtifactType] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.ArtifactType */
UPDATE [${mjSchema}_Committees].[ArtifactType] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.ArtifactType */
ALTER TABLE [${mjSchema}_Committees].[ArtifactType] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.ArtifactType */
ALTER TABLE [${mjSchema}_Committees].[ArtifactType] ADD CONSTRAINT [DF___mj_Committees_ArtifactType___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.ArtifactType */
ALTER TABLE [${mjSchema}_Committees].[ArtifactType] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.ArtifactType */
UPDATE [${mjSchema}_Committees].[ArtifactType] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.ArtifactType */
ALTER TABLE [${mjSchema}_Committees].[ArtifactType] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.ArtifactType */
ALTER TABLE [${mjSchema}_Committees].[ArtifactType] ADD CONSTRAINT [DF___mj_Committees_ArtifactType___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Committee */
ALTER TABLE [${mjSchema}_Committees].[Committee] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Committee */
UPDATE [${mjSchema}_Committees].[Committee] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Committee */
ALTER TABLE [${mjSchema}_Committees].[Committee] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Committee */
ALTER TABLE [${mjSchema}_Committees].[Committee] ADD CONSTRAINT [DF___mj_Committees_Committee___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Committee */
ALTER TABLE [${mjSchema}_Committees].[Committee] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Committee */
UPDATE [${mjSchema}_Committees].[Committee] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Committee */
ALTER TABLE [${mjSchema}_Committees].[Committee] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Committee */
ALTER TABLE [${mjSchema}_Committees].[Committee] ADD CONSTRAINT [DF___mj_Committees_Committee___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Vote */
ALTER TABLE [${mjSchema}_Committees].[Vote] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Vote */
UPDATE [${mjSchema}_Committees].[Vote] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Vote */
ALTER TABLE [${mjSchema}_Committees].[Vote] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Vote */
ALTER TABLE [${mjSchema}_Committees].[Vote] ADD CONSTRAINT [DF___mj_Committees_Vote___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Vote */
ALTER TABLE [${mjSchema}_Committees].[Vote] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Vote */
UPDATE [${mjSchema}_Committees].[Vote] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Vote */
ALTER TABLE [${mjSchema}_Committees].[Vote] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Vote */
ALTER TABLE [${mjSchema}_Committees].[Vote] ADD CONSTRAINT [DF___mj_Committees_Vote___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Role */
ALTER TABLE [${mjSchema}_Committees].[Role] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Role */
UPDATE [${mjSchema}_Committees].[Role] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Role */
ALTER TABLE [${mjSchema}_Committees].[Role] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Role */
ALTER TABLE [${mjSchema}_Committees].[Role] ADD CONSTRAINT [DF___mj_Committees_Role___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Role */
ALTER TABLE [${mjSchema}_Committees].[Role] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Role */
UPDATE [${mjSchema}_Committees].[Role] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Role */
ALTER TABLE [${mjSchema}_Committees].[Role] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Role */
ALTER TABLE [${mjSchema}_Committees].[Role] ADD CONSTRAINT [DF___mj_Committees_Role___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Meeting */
ALTER TABLE [${mjSchema}_Committees].[Meeting] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Meeting */
UPDATE [${mjSchema}_Committees].[Meeting] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Meeting */
ALTER TABLE [${mjSchema}_Committees].[Meeting] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Meeting */
ALTER TABLE [${mjSchema}_Committees].[Meeting] ADD CONSTRAINT [DF___mj_Committees_Meeting___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Meeting */
ALTER TABLE [${mjSchema}_Committees].[Meeting] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Meeting */
UPDATE [${mjSchema}_Committees].[Meeting] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Meeting */
ALTER TABLE [${mjSchema}_Committees].[Meeting] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Meeting */
ALTER TABLE [${mjSchema}_Committees].[Meeting] ADD CONSTRAINT [DF___mj_Committees_Meeting___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Attendance */
ALTER TABLE [${mjSchema}_Committees].[Attendance] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Attendance */
UPDATE [${mjSchema}_Committees].[Attendance] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Attendance */
ALTER TABLE [${mjSchema}_Committees].[Attendance] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Attendance */
ALTER TABLE [${mjSchema}_Committees].[Attendance] ADD CONSTRAINT [DF___mj_Committees_Attendance___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Attendance */
ALTER TABLE [${mjSchema}_Committees].[Attendance] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Attendance */
UPDATE [${mjSchema}_Committees].[Attendance] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Attendance */
ALTER TABLE [${mjSchema}_Committees].[Attendance] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Attendance */
ALTER TABLE [${mjSchema}_Committees].[Attendance] ADD CONSTRAINT [DF___mj_Committees_Attendance___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.VideoProvider */
ALTER TABLE [${mjSchema}_Committees].[VideoProvider] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.VideoProvider */
UPDATE [${mjSchema}_Committees].[VideoProvider] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.VideoProvider */
ALTER TABLE [${mjSchema}_Committees].[VideoProvider] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.VideoProvider */
ALTER TABLE [${mjSchema}_Committees].[VideoProvider] ADD CONSTRAINT [DF___mj_Committees_VideoProvider___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.VideoProvider */
ALTER TABLE [${mjSchema}_Committees].[VideoProvider] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.VideoProvider */
UPDATE [${mjSchema}_Committees].[VideoProvider] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.VideoProvider */
ALTER TABLE [${mjSchema}_Committees].[VideoProvider] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.VideoProvider */
ALTER TABLE [${mjSchema}_Committees].[VideoProvider] ADD CONSTRAINT [DF___mj_Committees_VideoProvider___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.ActionItem */
ALTER TABLE [${mjSchema}_Committees].[ActionItem] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.ActionItem */
UPDATE [${mjSchema}_Committees].[ActionItem] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.ActionItem */
ALTER TABLE [${mjSchema}_Committees].[ActionItem] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.ActionItem */
ALTER TABLE [${mjSchema}_Committees].[ActionItem] ADD CONSTRAINT [DF___mj_Committees_ActionItem___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.ActionItem */
ALTER TABLE [${mjSchema}_Committees].[ActionItem] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.ActionItem */
UPDATE [${mjSchema}_Committees].[ActionItem] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.ActionItem */
ALTER TABLE [${mjSchema}_Committees].[ActionItem] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.ActionItem */
ALTER TABLE [${mjSchema}_Committees].[ActionItem] ADD CONSTRAINT [DF___mj_Committees_ActionItem___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.AgendaItem */
ALTER TABLE [${mjSchema}_Committees].[AgendaItem] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.AgendaItem */
UPDATE [${mjSchema}_Committees].[AgendaItem] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.AgendaItem */
ALTER TABLE [${mjSchema}_Committees].[AgendaItem] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.AgendaItem */
ALTER TABLE [${mjSchema}_Committees].[AgendaItem] ADD CONSTRAINT [DF___mj_Committees_AgendaItem___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.AgendaItem */
ALTER TABLE [${mjSchema}_Committees].[AgendaItem] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.AgendaItem */
UPDATE [${mjSchema}_Committees].[AgendaItem] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.AgendaItem */
ALTER TABLE [${mjSchema}_Committees].[AgendaItem] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.AgendaItem */
ALTER TABLE [${mjSchema}_Committees].[AgendaItem] ADD CONSTRAINT [DF___mj_Committees_AgendaItem___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Membership */
ALTER TABLE [${mjSchema}_Committees].[Membership] ADD [__mj_CreatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Membership */
UPDATE [${mjSchema}_Committees].[Membership] SET [__mj_CreatedAt] = GETUTCDATE() WHERE [__mj_CreatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Membership */
ALTER TABLE [${mjSchema}_Committees].[Membership] ALTER COLUMN [__mj_CreatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_CreatedAt to entity ${mjSchema}_Committees.Membership */
ALTER TABLE [${mjSchema}_Committees].[Membership] ADD CONSTRAINT [DF___mj_Committees_Membership___mj_CreatedAt] DEFAULT GETUTCDATE() FOR [__mj_CreatedAt];
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Membership */
ALTER TABLE [${mjSchema}_Committees].[Membership] ADD [__mj_UpdatedAt] DATETIMEOFFSET NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Membership */
UPDATE [${mjSchema}_Committees].[Membership] SET [__mj_UpdatedAt] = GETUTCDATE() WHERE [__mj_UpdatedAt] IS NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Membership */
ALTER TABLE [${mjSchema}_Committees].[Membership] ALTER COLUMN [__mj_UpdatedAt] DATETIMEOFFSET NOT NULL;
GO

/* SQL text to add special date field __mj_UpdatedAt to entity ${mjSchema}_Committees.Membership */
ALTER TABLE [${mjSchema}_Committees].[Membership] ADD CONSTRAINT [DF___mj_Committees_Membership___mj_UpdatedAt] DEFAULT GETUTCDATE() FOR [__mj_UpdatedAt];
GO

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '9f6d0e11-2d44-4767-9d78-81f5da9396f3' OR (EntityID = '338F9B03-8689-4BD0-8EF1-03B84B90E4D9' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '9f6d0e11-2d44-4767-9d78-81f5da9396f3',
            '338F9B03-8689-4BD0-8EF1-03B84B90E4D9', -- Entity: Committees: Minutes
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'ae3d6799-8a28-4f16-aabb-2afe2b1ddf34' OR (EntityID = '338F9B03-8689-4BD0-8EF1-03B84B90E4D9' AND Name = 'ArtifactID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'ae3d6799-8a28-4f16-aabb-2afe2b1ddf34',
            '338F9B03-8689-4BD0-8EF1-03B84B90E4D9', -- Entity: Committees: Minutes
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
            0,
            '3011BE1C-A871-4536-9855-2E58A28A206E',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '5361310d-7e27-42bb-8e56-822a360738a7' OR (EntityID = '338F9B03-8689-4BD0-8EF1-03B84B90E4D9' AND Name = 'MeetingID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '5361310d-7e27-42bb-8e56-822a360738a7',
            '338F9B03-8689-4BD0-8EF1-03B84B90E4D9', -- Entity: Committees: Minutes
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
            0,
            'F05BE747-6F2A-472E-8800-8A10D416EAA1',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '38a558ce-ff5e-45f0-8286-55e0855fbec0' OR (EntityID = '338F9B03-8689-4BD0-8EF1-03B84B90E4D9' AND Name = 'Content')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '38a558ce-ff5e-45f0-8286-55e0855fbec0',
            '338F9B03-8689-4BD0-8EF1-03B84B90E4D9', -- Entity: Committees: Minutes
            100004,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'e8674472-d4bd-49fa-a281-9fe6739f51f8' OR (EntityID = '338F9B03-8689-4BD0-8EF1-03B84B90E4D9' AND Name = 'ApprovalStatus')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'e8674472-d4bd-49fa-a281-9fe6739f51f8',
            '338F9B03-8689-4BD0-8EF1-03B84B90E4D9', -- Entity: Committees: Minutes
            100005,
            'ApprovalStatus',
            'Approval Status',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Draft',
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0f1f905e-9785-4fb3-bacb-4f5ff7f7da7b' OR (EntityID = '338F9B03-8689-4BD0-8EF1-03B84B90E4D9' AND Name = 'ApprovedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0f1f905e-9785-4fb3-bacb-4f5ff7f7da7b',
            '338F9B03-8689-4BD0-8EF1-03B84B90E4D9', -- Entity: Committees: Minutes
            100006,
            'ApprovedAt',
            'Approved At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '1464ac1b-40d1-4bc9-8297-908d92490335' OR (EntityID = '338F9B03-8689-4BD0-8EF1-03B84B90E4D9' AND Name = 'ApprovedByMeetingID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '1464ac1b-40d1-4bc9-8297-908d92490335',
            '338F9B03-8689-4BD0-8EF1-03B84B90E4D9', -- Entity: Committees: Minutes
            100007,
            'ApprovedByMeetingID',
            'Approved By Meeting ID',
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
            0,
            'F05BE747-6F2A-472E-8800-8A10D416EAA1',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '6debe838-aebe-4ecf-a73d-4c01a5195e0b' OR (EntityID = '338F9B03-8689-4BD0-8EF1-03B84B90E4D9' AND Name = 'Notes')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '6debe838-aebe-4ecf-a73d-4c01a5195e0b',
            '338F9B03-8689-4BD0-8EF1-03B84B90E4D9', -- Entity: Committees: Minutes
            100008,
            'Notes',
            'Notes',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '075bb0b8-8682-41b9-8c4b-7cab5fdbb9e6' OR (EntityID = '338F9B03-8689-4BD0-8EF1-03B84B90E4D9' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '075bb0b8-8682-41b9-8c4b-7cab5fdbb9e6',
            '338F9B03-8689-4BD0-8EF1-03B84B90E4D9', -- Entity: Committees: Minutes
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'fb4b25bb-c17d-4449-b9c8-6f4202a407dd' OR (EntityID = '338F9B03-8689-4BD0-8EF1-03B84B90E4D9' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'fb4b25bb-c17d-4449-b9c8-6f4202a407dd',
            '338F9B03-8689-4BD0-8EF1-03B84B90E4D9', -- Entity: Committees: Minutes
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '3f1fa5ed-2e67-4777-ac91-3809740f5da5' OR (EntityID = 'EAD3EF14-1891-4389-A0F3-1984BC8CC13F' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '3f1fa5ed-2e67-4777-ac91-3809740f5da5',
            'EAD3EF14-1891-4389-A0F3-1984BC8CC13F', -- Entity: Committees: Terms
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '091826c5-1f45-44fb-a3b0-b2296a9d81ac' OR (EntityID = 'EAD3EF14-1891-4389-A0F3-1984BC8CC13F' AND Name = 'CommitteeID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '091826c5-1f45-44fb-a3b0-b2296a9d81ac',
            'EAD3EF14-1891-4389-A0F3-1984BC8CC13F', -- Entity: Committees: Terms
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
            0,
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '4f41559a-018d-4c41-91d5-9b40b4bc96ae' OR (EntityID = 'EAD3EF14-1891-4389-A0F3-1984BC8CC13F' AND Name = 'Name')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '4f41559a-018d-4c41-91d5-9b40b4bc96ae',
            'EAD3EF14-1891-4389-A0F3-1984BC8CC13F', -- Entity: Committees: Terms
            100003,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '6adade18-ef8a-4ed5-8994-cea52f5eb2ba' OR (EntityID = 'EAD3EF14-1891-4389-A0F3-1984BC8CC13F' AND Name = 'StartDate')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '6adade18-ef8a-4ed5-8994-cea52f5eb2ba',
            'EAD3EF14-1891-4389-A0F3-1984BC8CC13F', -- Entity: Committees: Terms
            100004,
            'StartDate',
            'Start Date',
            NULL,
            'date',
            3,
            10,
            0,
            0,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'cb0221fe-0167-49e1-80c7-2f8f5d3688eb' OR (EntityID = 'EAD3EF14-1891-4389-A0F3-1984BC8CC13F' AND Name = 'EndDate')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'cb0221fe-0167-49e1-80c7-2f8f5d3688eb',
            'EAD3EF14-1891-4389-A0F3-1984BC8CC13F', -- Entity: Committees: Terms
            100005,
            'EndDate',
            'End Date',
            NULL,
            'date',
            3,
            10,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'bbb912df-dae0-4cd9-915f-4d10705394ae' OR (EntityID = 'EAD3EF14-1891-4389-A0F3-1984BC8CC13F' AND Name = 'Status')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'bbb912df-dae0-4cd9-915f-4d10705394ae',
            'EAD3EF14-1891-4389-A0F3-1984BC8CC13F', -- Entity: Committees: Terms
            100006,
            'Status',
            'Status',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Active',
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '8cf661bd-0e27-4dcc-926c-771c0b84bc94' OR (EntityID = 'EAD3EF14-1891-4389-A0F3-1984BC8CC13F' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '8cf661bd-0e27-4dcc-926c-771c0b84bc94',
            'EAD3EF14-1891-4389-A0F3-1984BC8CC13F', -- Entity: Committees: Terms
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '21478d75-7f46-44b7-b344-f79f1da4d251' OR (EntityID = 'EAD3EF14-1891-4389-A0F3-1984BC8CC13F' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '21478d75-7f46-44b7-b344-f79f1da4d251',
            'EAD3EF14-1891-4389-A0F3-1984BC8CC13F', -- Entity: Committees: Terms
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '4e11ccf6-d689-461d-ad1b-6075a2f53d45' OR (EntityID = '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '4e11ccf6-d689-461d-ad1b-6075a2f53d45',
            '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', -- Entity: Committees: Motions
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'd2e4b22e-b412-4eed-9420-7556d5e96b1f' OR (EntityID = '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906' AND Name = 'MeetingID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'd2e4b22e-b412-4eed-9420-7556d5e96b1f',
            '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', -- Entity: Committees: Motions
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
            0,
            'F05BE747-6F2A-472E-8800-8A10D416EAA1',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'd79e4719-9505-459a-abd1-d94c06fd0c2f' OR (EntityID = '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906' AND Name = 'AgendaItemID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'd79e4719-9505-459a-abd1-d94c06fd0c2f',
            '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', -- Entity: Committees: Motions
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
            0,
            '5746F567-3A1B-4772-B8BA-D46D98A137DD',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'b9c3b357-3301-4897-aafe-bd706cffbf9a' OR (EntityID = '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906' AND Name = 'Sequence')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'b9c3b357-3301-4897-aafe-bd706cffbf9a',
            '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', -- Entity: Committees: Motions
            100004,
            'Sequence',
            'Sequence',
            NULL,
            'int',
            4,
            10,
            0,
            0,
            '(1)',
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '855672e5-93d7-476a-9a84-e5b70c117cff' OR (EntityID = '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906' AND Name = 'Title')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '855672e5-93d7-476a-9a84-e5b70c117cff',
            '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', -- Entity: Committees: Motions
            100005,
            'Title',
            'Title',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            0,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'f9f72b80-5186-414c-8aa2-c78548f612ec' OR (EntityID = '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906' AND Name = 'Description')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'f9f72b80-5186-414c-8aa2-c78548f612ec',
            '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', -- Entity: Committees: Motions
            100006,
            'Description',
            'Description',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '6157cd60-83dc-453b-aa92-1535976ce7bc' OR (EntityID = '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906' AND Name = 'MovedByMembershipID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '6157cd60-83dc-453b-aa92-1535976ce7bc',
            '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', -- Entity: Committees: Motions
            100007,
            'MovedByMembershipID',
            'Moved By Membership ID',
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
            0,
            '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '3fb932c5-9e5b-424b-a028-3c86f5b5a319' OR (EntityID = '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906' AND Name = 'SecondedByMembershipID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '3fb932c5-9e5b-424b-a028-3c86f5b5a319',
            '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', -- Entity: Committees: Motions
            100008,
            'SecondedByMembershipID',
            'Seconded By Membership ID',
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
            0,
            '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '84428f50-1c25-46b8-a9cb-ed285792afba' OR (EntityID = '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906' AND Name = 'Result')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '84428f50-1c25-46b8-a9cb-ed285792afba',
            '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', -- Entity: Committees: Motions
            100009,
            'Result',
            'Result',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Pending',
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '271e01a1-4529-413f-b09b-dba0a93d3fdd' OR (EntityID = '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906' AND Name = 'ResultSummary')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '271e01a1-4529-413f-b09b-dba0a93d3fdd',
            '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', -- Entity: Committees: Motions
            100010,
            'ResultSummary',
            'Result Summary',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0cf4edbe-333e-47e3-b210-57a7c6362884' OR (EntityID = '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906' AND Name = 'YesCount')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0cf4edbe-333e-47e3-b210-57a7c6362884',
            '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', -- Entity: Committees: Motions
            100011,
            'YesCount',
            'Yes Count',
            NULL,
            'int',
            4,
            10,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '44e3f21e-8463-46f8-bd58-ba0ad86a2042' OR (EntityID = '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906' AND Name = 'NoCount')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '44e3f21e-8463-46f8-bd58-ba0ad86a2042',
            '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', -- Entity: Committees: Motions
            100012,
            'NoCount',
            'No Count',
            NULL,
            'int',
            4,
            10,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '479cc4f6-86aa-4584-b156-3629d194e1ac' OR (EntityID = '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906' AND Name = 'AbstainCount')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '479cc4f6-86aa-4584-b156-3629d194e1ac',
            '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', -- Entity: Committees: Motions
            100013,
            'AbstainCount',
            'Abstain Count',
            NULL,
            'int',
            4,
            10,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '4149181c-7d27-4aad-9044-b5cc0561f370' OR (EntityID = '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906' AND Name = 'Notes')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '4149181c-7d27-4aad-9044-b5cc0561f370',
            '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', -- Entity: Committees: Motions
            100014,
            'Notes',
            'Notes',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '65cb4fd2-427d-4827-85a6-11ed7ef37c43' OR (EntityID = '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '65cb4fd2-427d-4827-85a6-11ed7ef37c43',
            '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', -- Entity: Committees: Motions
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'c05df0fa-b238-4ca1-9fb9-65df1626d22f' OR (EntityID = '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'c05df0fa-b238-4ca1-9fb9-65df1626d22f',
            '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', -- Entity: Committees: Motions
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '52558564-11cb-4f0b-a13b-6ca545ffc400' OR (EntityID = '1D7F24C0-622E-41E0-BC38-29C2EEB1D442' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '52558564-11cb-4f0b-a13b-6ca545ffc400',
            '1D7F24C0-622E-41E0-BC38-29C2EEB1D442', -- Entity: Committees: Types
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '67318bcf-1a43-4a52-b373-a3fd9e875504' OR (EntityID = '1D7F24C0-622E-41E0-BC38-29C2EEB1D442' AND Name = 'Name')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '67318bcf-1a43-4a52-b373-a3fd9e875504',
            '1D7F24C0-622E-41E0-BC38-29C2EEB1D442', -- Entity: Committees: Types
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'a7427180-ce31-4eea-bb03-a4cd524c2250' OR (EntityID = '1D7F24C0-622E-41E0-BC38-29C2EEB1D442' AND Name = 'Description')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'a7427180-ce31-4eea-bb03-a4cd524c2250',
            '1D7F24C0-622E-41E0-BC38-29C2EEB1D442', -- Entity: Committees: Types
            100003,
            'Description',
            'Description',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '6464c3b1-2e2c-4b51-b4d4-61825d57a0ed' OR (EntityID = '1D7F24C0-622E-41E0-BC38-29C2EEB1D442' AND Name = 'IsStandards')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '6464c3b1-2e2c-4b51-b4d4-61825d57a0ed',
            '1D7F24C0-622E-41E0-BC38-29C2EEB1D442', -- Entity: Committees: Types
            100004,
            'IsStandards',
            'Is Standards',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'eb7d567f-57ba-469e-a736-f403b2692792' OR (EntityID = '1D7F24C0-622E-41E0-BC38-29C2EEB1D442' AND Name = 'DefaultTermMonths')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'eb7d567f-57ba-469e-a736-f403b2692792',
            '1D7F24C0-622E-41E0-BC38-29C2EEB1D442', -- Entity: Committees: Types
            100005,
            'DefaultTermMonths',
            'Default Term Months',
            NULL,
            'int',
            4,
            10,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'a9e6d7f1-7112-4155-bc48-139fca459c65' OR (EntityID = '1D7F24C0-622E-41E0-BC38-29C2EEB1D442' AND Name = 'IconClass')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'a9e6d7f1-7112-4155-bc48-139fca459c65',
            '1D7F24C0-622E-41E0-BC38-29C2EEB1D442', -- Entity: Committees: Types
            100006,
            'IconClass',
            'Icon Class',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '912011c8-7359-45f4-b7e9-8861f0493de5' OR (EntityID = '1D7F24C0-622E-41E0-BC38-29C2EEB1D442' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '912011c8-7359-45f4-b7e9-8861f0493de5',
            '1D7F24C0-622E-41E0-BC38-29C2EEB1D442', -- Entity: Committees: Types
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '275b903e-f851-4f1e-a2fe-e9612541be34' OR (EntityID = '1D7F24C0-622E-41E0-BC38-29C2EEB1D442' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '275b903e-f851-4f1e-a2fe-e9612541be34',
            '1D7F24C0-622E-41E0-BC38-29C2EEB1D442', -- Entity: Committees: Types
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'f63c416d-847e-4f6f-9850-867edc096b09' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'f63c416d-847e-4f6f-9850-867edc096b09',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'b4ecaeee-2530-44d0-a597-bd2cf2b93f3a' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = 'CommitteeID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'b4ecaeee-2530-44d0-a597-bd2cf2b93f3a',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
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
            0,
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'f7f8c47a-c5f8-48e9-bca6-dec53a9a75d3' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = 'MeetingID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'f7f8c47a-c5f8-48e9-bca6-dec53a9a75d3',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
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
            0,
            'F05BE747-6F2A-472E-8800-8A10D416EAA1',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'd94dcdee-55c0-4c26-bfce-a24ef4302f3b' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = 'AgendaItemID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'd94dcdee-55c0-4c26-bfce-a24ef4302f3b',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
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
            0,
            '5746F567-3A1B-4772-B8BA-D46D98A137DD',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'ceefedf4-d8a7-419c-8239-2a0bc5cfc8ce' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = 'TaskID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'ceefedf4-d8a7-419c-8239-2a0bc5cfc8ce',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
            100005,
            'TaskID',
            'Task ID',
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
            0,
            'B348FFA2-B1A7-4AC2-B6FD-F4E0C0697466',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2282ccf3-a155-4ab7-aa2d-0df01de8b317' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = 'Title')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '2282ccf3-a155-4ab7-aa2d-0df01de8b317',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
            100006,
            'Title',
            'Title',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            0,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '6492eaf4-5197-40e8-b0b0-e4a6cc55cceb' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = 'Description')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '6492eaf4-5197-40e8-b0b0-e4a6cc55cceb',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
            100007,
            'Description',
            'Description',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'f47e91d5-dd83-419a-a601-566bf750699d' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = 'ArtifactTypeID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'f47e91d5-dd83-419a-a601-566bf750699d',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
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
            0,
            '8E6153B6-BC78-4AE8-B42D-34D7E2217555',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'c8a72305-27ca-4723-9fc2-d875ca1d963c' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = 'Provider')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'c8a72305-27ca-4723-9fc2-d875ca1d963c',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
            100009,
            'Provider',
            'Provider',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '7ce16a2d-9c8b-4bf4-b32a-ef7c2d6ffbc0' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = 'ExternalID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '7ce16a2d-9c8b-4bf4-b32a-ef7c2d6ffbc0',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
            100010,
            'ExternalID',
            'External ID',
            NULL,
            'nvarchar',
            1000,
            0,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '3cdd410b-8a6b-4396-ab43-74aeb8fc4561' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = 'URL')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '3cdd410b-8a6b-4396-ab43-74aeb8fc4561',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
            100011,
            'URL',
            'URL',
            NULL,
            'nvarchar',
            4000,
            0,
            0,
            0,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'bf0de1cf-077f-4431-89b5-c78f5fa421cb' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = 'MimeType')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'bf0de1cf-077f-4431-89b5-c78f5fa421cb',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
            100012,
            'MimeType',
            'Mime Type',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '05bb5712-79a3-4f35-9706-204da0dc45ca' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = 'FileSize')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '05bb5712-79a3-4f35-9706-204da0dc45ca',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
            100013,
            'FileSize',
            'File Size',
            NULL,
            'bigint',
            8,
            19,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2ba603ff-1546-4673-98d3-cb116849c094' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = 'UploadedByPersonID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '2ba603ff-1546-4673-98d3-cb116849c094',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'e5a28039-d728-4fca-a43a-976d698469b6' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'e5a28039-d728-4fca-a43a-976d698469b6',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '6e640ce7-04b2-49b8-b876-d3174b3df97a' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '6e640ce7-04b2-49b8-b876-d3174b3df97a',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '260d269c-9f9c-4941-855a-eae5d2581889' OR (EntityID = '349618AD-3F1C-481C-8406-302817363510' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '260d269c-9f9c-4941-855a-eae5d2581889',
            '349618AD-3F1C-481C-8406-302817363510', -- Entity: Committees: Comments
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '6c01f98d-c2af-49a4-83cb-af9c849c96b9' OR (EntityID = '349618AD-3F1C-481C-8406-302817363510' AND Name = 'CommitteeID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '6c01f98d-c2af-49a4-83cb-af9c849c96b9',
            '349618AD-3F1C-481C-8406-302817363510', -- Entity: Committees: Comments
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
            0,
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '9b932403-b185-451d-8375-207394ca6a09' OR (EntityID = '349618AD-3F1C-481C-8406-302817363510' AND Name = 'MeetingID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '9b932403-b185-451d-8375-207394ca6a09',
            '349618AD-3F1C-481C-8406-302817363510', -- Entity: Committees: Comments
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
            0,
            'F05BE747-6F2A-472E-8800-8A10D416EAA1',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '4be7e25a-b67a-4a45-81fe-efa5b6f9bfd4' OR (EntityID = '349618AD-3F1C-481C-8406-302817363510' AND Name = 'AgendaItemID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '4be7e25a-b67a-4a45-81fe-efa5b6f9bfd4',
            '349618AD-3F1C-481C-8406-302817363510', -- Entity: Committees: Comments
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
            0,
            '5746F567-3A1B-4772-B8BA-D46D98A137DD',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '9fe98bd5-1ca5-476a-a402-d203e206355d' OR (EntityID = '349618AD-3F1C-481C-8406-302817363510' AND Name = 'TaskID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '9fe98bd5-1ca5-476a-a402-d203e206355d',
            '349618AD-3F1C-481C-8406-302817363510', -- Entity: Committees: Comments
            100005,
            'TaskID',
            'Task ID',
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
            0,
            'B348FFA2-B1A7-4AC2-B6FD-F4E0C0697466',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '791fa583-6370-4793-899a-cff1cca8cd29' OR (EntityID = '349618AD-3F1C-481C-8406-302817363510' AND Name = 'ArtifactID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '791fa583-6370-4793-899a-cff1cca8cd29',
            '349618AD-3F1C-481C-8406-302817363510', -- Entity: Committees: Comments
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
            0,
            '3011BE1C-A871-4536-9855-2E58A28A206E',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '453e2b0e-bdb2-4a4b-a879-c15883cd6d46' OR (EntityID = '349618AD-3F1C-481C-8406-302817363510' AND Name = 'ParentCommentID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '453e2b0e-bdb2-4a4b-a879-c15883cd6d46',
            '349618AD-3F1C-481C-8406-302817363510', -- Entity: Committees: Comments
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
            0,
            '349618AD-3F1C-481C-8406-302817363510',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '44f607d6-0d6a-4a99-a1bc-0e248e100c63' OR (EntityID = '349618AD-3F1C-481C-8406-302817363510' AND Name = 'PersonID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '44f607d6-0d6a-4a99-a1bc-0e248e100c63',
            '349618AD-3F1C-481C-8406-302817363510', -- Entity: Committees: Comments
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '688c4a87-2a82-41dc-8c87-24162735edab' OR (EntityID = '349618AD-3F1C-481C-8406-302817363510' AND Name = 'CommentText')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '688c4a87-2a82-41dc-8c87-24162735edab',
            '349618AD-3F1C-481C-8406-302817363510', -- Entity: Committees: Comments
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '6c4a4717-e7f5-4eb2-a105-88c235b2f41e' OR (EntityID = '349618AD-3F1C-481C-8406-302817363510' AND Name = 'MentionedPersonIDs')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '6c4a4717-e7f5-4eb2-a105-88c235b2f41e',
            '349618AD-3F1C-481C-8406-302817363510', -- Entity: Committees: Comments
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '85dd403d-c8e9-4762-a2e3-29fc9fdc83e8' OR (EntityID = '349618AD-3F1C-481C-8406-302817363510' AND Name = 'IsResolved')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '85dd403d-c8e9-4762-a2e3-29fc9fdc83e8',
            '349618AD-3F1C-481C-8406-302817363510', -- Entity: Committees: Comments
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '25b5f450-9fc1-485a-966f-132323f6eab0' OR (EntityID = '349618AD-3F1C-481C-8406-302817363510' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '25b5f450-9fc1-485a-966f-132323f6eab0',
            '349618AD-3F1C-481C-8406-302817363510', -- Entity: Committees: Comments
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '1c812b15-9efc-4a79-91a8-95f9503f3780' OR (EntityID = '349618AD-3F1C-481C-8406-302817363510' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '1c812b15-9efc-4a79-91a8-95f9503f3780',
            '349618AD-3F1C-481C-8406-302817363510', -- Entity: Committees: Comments
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2509acce-9150-4005-bd4e-ca09ba4c90c3' OR (EntityID = '8E6153B6-BC78-4AE8-B42D-34D7E2217555' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '2509acce-9150-4005-bd4e-ca09ba4c90c3',
            '8E6153B6-BC78-4AE8-B42D-34D7E2217555', -- Entity: Committees: Artifact Types
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '80f1d657-2d81-491c-83de-2ffc95273173' OR (EntityID = '8E6153B6-BC78-4AE8-B42D-34D7E2217555' AND Name = 'Name')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '80f1d657-2d81-491c-83de-2ffc95273173',
            '8E6153B6-BC78-4AE8-B42D-34D7E2217555', -- Entity: Committees: Artifact Types
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'eb569531-b35c-4797-bd00-b5532df25159' OR (EntityID = '8E6153B6-BC78-4AE8-B42D-34D7E2217555' AND Name = 'Description')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'eb569531-b35c-4797-bd00-b5532df25159',
            '8E6153B6-BC78-4AE8-B42D-34D7E2217555', -- Entity: Committees: Artifact Types
            100003,
            'Description',
            'Description',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'c3731e81-33c0-4eca-bb78-e83ea76d2a4b' OR (EntityID = '8E6153B6-BC78-4AE8-B42D-34D7E2217555' AND Name = 'ExtendedEntityID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'c3731e81-33c0-4eca-bb78-e83ea76d2a4b',
            '8E6153B6-BC78-4AE8-B42D-34D7E2217555', -- Entity: Committees: Artifact Types
            100004,
            'ExtendedEntityID',
            'Extended Entity ID',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'e4604907-1997-41aa-9656-4003be5cf219' OR (EntityID = '8E6153B6-BC78-4AE8-B42D-34D7E2217555' AND Name = 'IconClass')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'e4604907-1997-41aa-9656-4003be5cf219',
            '8E6153B6-BC78-4AE8-B42D-34D7E2217555', -- Entity: Committees: Artifact Types
            100005,
            'IconClass',
            'Icon Class',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '175df0ab-f9a3-4fb8-b3a5-a4b27e81aa33' OR (EntityID = '8E6153B6-BC78-4AE8-B42D-34D7E2217555' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '175df0ab-f9a3-4fb8-b3a5-a4b27e81aa33',
            '8E6153B6-BC78-4AE8-B42D-34D7E2217555', -- Entity: Committees: Artifact Types
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '5b65e3a3-b44c-4bda-93a1-3f79d044c50e' OR (EntityID = '8E6153B6-BC78-4AE8-B42D-34D7E2217555' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '5b65e3a3-b44c-4bda-93a1-3f79d044c50e',
            '8E6153B6-BC78-4AE8-B42D-34D7E2217555', -- Entity: Committees: Artifact Types
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '85bdbe90-5784-40b2-94fb-e4cffa402ea8' OR (EntityID = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '85bdbe90-5784-40b2-94fb-e4cffa402ea8',
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', -- Entity: Committees: Committees
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '34a962cb-28d2-4e8d-8b2f-806f2aea1cfd' OR (EntityID = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38' AND Name = 'Name')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '34a962cb-28d2-4e8d-8b2f-806f2aea1cfd',
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', -- Entity: Committees: Committees
            100002,
            'Name',
            'Name',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            0,
            NULL,
            0,
            1,
            0,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '8d1fcad6-9ce9-4cba-9d52-c7f01d3632bb' OR (EntityID = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38' AND Name = 'Description')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '8d1fcad6-9ce9-4cba-9d52-c7f01d3632bb',
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', -- Entity: Committees: Committees
            100003,
            'Description',
            'Description',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'caa9b2bc-cbb1-4dd3-9406-29f4c57a2776' OR (EntityID = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38' AND Name = 'TypeID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'caa9b2bc-cbb1-4dd3-9406-29f4c57a2776',
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', -- Entity: Committees: Committees
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
            0,
            '1D7F24C0-622E-41E0-BC38-29C2EEB1D442',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'bf45d3a7-9b28-4c2e-9648-e2b2191c64d2' OR (EntityID = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38' AND Name = 'ParentCommitteeID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'bf45d3a7-9b28-4c2e-9648-e2b2191c64d2',
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', -- Entity: Committees: Committees
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
            0,
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'f2abb2eb-d0a0-4515-90fc-1d4670414a35' OR (EntityID = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38' AND Name = 'OrganizationID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'f2abb2eb-d0a0-4515-90fc-1d4670414a35',
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', -- Entity: Committees: Committees
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '726fb23a-13c3-481f-8e24-cba573016d05' OR (EntityID = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38' AND Name = 'CharterDocumentURL')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '726fb23a-13c3-481f-8e24-cba573016d05',
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', -- Entity: Committees: Committees
            100007,
            'CharterDocumentURL',
            'Charter Document URL',
            NULL,
            'nvarchar',
            2000,
            0,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'e4ea847c-bf58-4c01-9278-3766c7205224' OR (EntityID = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38' AND Name = 'MissionStatement')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'e4ea847c-bf58-4c01-9278-3766c7205224',
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', -- Entity: Committees: Committees
            100008,
            'MissionStatement',
            'Mission Statement',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '963d5f6a-9b40-44e5-8611-64f666643d44' OR (EntityID = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38' AND Name = 'Status')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '963d5f6a-9b40-44e5-8611-64f666643d44',
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', -- Entity: Committees: Committees
            100009,
            'Status',
            'Status',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Active',
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '7b1aeeab-182a-4a20-8e7a-bf0b997dd21d' OR (EntityID = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38' AND Name = 'IsPublic')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '7b1aeeab-182a-4a20-8e7a-bf0b997dd21d',
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', -- Entity: Committees: Committees
            100010,
            'IsPublic',
            'Is Public',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'ef79c5e1-78fa-4412-8132-56115c5d980f' OR (EntityID = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38' AND Name = 'FormationDate')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'ef79c5e1-78fa-4412-8132-56115c5d980f',
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', -- Entity: Committees: Committees
            100011,
            'FormationDate',
            'Formation Date',
            NULL,
            'date',
            3,
            10,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '72f639ec-0eb2-41a9-8ee6-d9879043296c' OR (EntityID = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38' AND Name = 'DissolutionDate')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '72f639ec-0eb2-41a9-8ee6-d9879043296c',
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', -- Entity: Committees: Committees
            100012,
            'DissolutionDate',
            'Dissolution Date',
            NULL,
            'date',
            3,
            10,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '559240d2-f23c-41f8-b0f4-b2bf53cf881b' OR (EntityID = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '559240d2-f23c-41f8-b0f4-b2bf53cf881b',
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', -- Entity: Committees: Committees
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '22c6c3c0-c2a6-4005-b38c-4e25a54a87e1' OR (EntityID = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '22c6c3c0-c2a6-4005-b38c-4e25a54a87e1',
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', -- Entity: Committees: Committees
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'cc6ca82f-b4f4-470e-8fb5-2531904b154f' OR (EntityID = '80299A27-B207-4D99-A46B-4E5B8A2B5E62' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'cc6ca82f-b4f4-470e-8fb5-2531904b154f',
            '80299A27-B207-4D99-A46B-4E5B8A2B5E62', -- Entity: Committees: Votes
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'f49d1790-7d59-4c16-ac47-40ea595ce36b' OR (EntityID = '80299A27-B207-4D99-A46B-4E5B8A2B5E62' AND Name = 'MotionID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'f49d1790-7d59-4c16-ac47-40ea595ce36b',
            '80299A27-B207-4D99-A46B-4E5B8A2B5E62', -- Entity: Committees: Votes
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
            0,
            '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '804ba908-70cd-4679-ad48-72906a686c39' OR (EntityID = '80299A27-B207-4D99-A46B-4E5B8A2B5E62' AND Name = 'MembershipID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '804ba908-70cd-4679-ad48-72906a686c39',
            '80299A27-B207-4D99-A46B-4E5B8A2B5E62', -- Entity: Committees: Votes
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
            0,
            '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '92b05fa7-5d41-4e58-934d-4021853197d3' OR (EntityID = '80299A27-B207-4D99-A46B-4E5B8A2B5E62' AND Name = 'VoteValue')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '92b05fa7-5d41-4e58-934d-4021853197d3',
            '80299A27-B207-4D99-A46B-4E5B8A2B5E62', -- Entity: Committees: Votes
            100004,
            'VoteValue',
            'Vote Value',
            NULL,
            'nvarchar',
            40,
            0,
            0,
            0,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '772c3c0c-287c-493e-9a97-e109474023a1' OR (EntityID = '80299A27-B207-4D99-A46B-4E5B8A2B5E62' AND Name = 'Notes')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '772c3c0c-287c-493e-9a97-e109474023a1',
            '80299A27-B207-4D99-A46B-4E5B8A2B5E62', -- Entity: Committees: Votes
            100005,
            'Notes',
            'Notes',
            NULL,
            'nvarchar',
            1000,
            0,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '392784b0-4470-4956-ac15-ba8b4102f2a5' OR (EntityID = '80299A27-B207-4D99-A46B-4E5B8A2B5E62' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '392784b0-4470-4956-ac15-ba8b4102f2a5',
            '80299A27-B207-4D99-A46B-4E5B8A2B5E62', -- Entity: Committees: Votes
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '76f6f522-d451-46b7-905b-1c9834643f58' OR (EntityID = '80299A27-B207-4D99-A46B-4E5B8A2B5E62' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '76f6f522-d451-46b7-905b-1c9834643f58',
            '80299A27-B207-4D99-A46B-4E5B8A2B5E62', -- Entity: Committees: Votes
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'd3678c5e-5e8e-476f-b717-001d7707faed' OR (EntityID = 'CF2605AB-3F2C-4D18-B663-60105BFC2BCC' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'd3678c5e-5e8e-476f-b717-001d7707faed',
            'CF2605AB-3F2C-4D18-B663-60105BFC2BCC', -- Entity: Committees: Roles
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'e2e3b1a3-b3df-4f70-b4de-ea940f2853d7' OR (EntityID = 'CF2605AB-3F2C-4D18-B663-60105BFC2BCC' AND Name = 'Name')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'e2e3b1a3-b3df-4f70-b4de-ea940f2853d7',
            'CF2605AB-3F2C-4D18-B663-60105BFC2BCC', -- Entity: Committees: Roles
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '63781997-8686-4dca-a40f-3cf049f47e1f' OR (EntityID = 'CF2605AB-3F2C-4D18-B663-60105BFC2BCC' AND Name = 'Description')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '63781997-8686-4dca-a40f-3cf049f47e1f',
            'CF2605AB-3F2C-4D18-B663-60105BFC2BCC', -- Entity: Committees: Roles
            100003,
            'Description',
            'Description',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '6da4c45c-623d-4ffc-9d07-5d0b2a97c984' OR (EntityID = 'CF2605AB-3F2C-4D18-B663-60105BFC2BCC' AND Name = 'IsOfficer')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '6da4c45c-623d-4ffc-9d07-5d0b2a97c984',
            'CF2605AB-3F2C-4D18-B663-60105BFC2BCC', -- Entity: Committees: Roles
            100004,
            'IsOfficer',
            'Is Officer',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '38ed23ee-f6ca-405a-a8b7-c49a9f3d5fb6' OR (EntityID = 'CF2605AB-3F2C-4D18-B663-60105BFC2BCC' AND Name = 'IsVotingRole')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '38ed23ee-f6ca-405a-a8b7-c49a9f3d5fb6',
            'CF2605AB-3F2C-4D18-B663-60105BFC2BCC', -- Entity: Committees: Roles
            100005,
            'IsVotingRole',
            'Is Voting Role',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'd9bd7275-067c-481e-b753-758558590f27' OR (EntityID = 'CF2605AB-3F2C-4D18-B663-60105BFC2BCC' AND Name = 'DefaultPermissionsJSON')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'd9bd7275-067c-481e-b753-758558590f27',
            'CF2605AB-3F2C-4D18-B663-60105BFC2BCC', -- Entity: Committees: Roles
            100006,
            'DefaultPermissionsJSON',
            'Default Permissions JSON',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'f7589d48-877c-4f70-ac15-d2423ebb4e13' OR (EntityID = 'CF2605AB-3F2C-4D18-B663-60105BFC2BCC' AND Name = 'Sequence')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'f7589d48-877c-4f70-ac15-d2423ebb4e13',
            'CF2605AB-3F2C-4D18-B663-60105BFC2BCC', -- Entity: Committees: Roles
            100007,
            'Sequence',
            'Sequence',
            NULL,
            'int',
            4,
            10,
            0,
            0,
            '(100)',
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'e560ac48-f275-4c2a-9e7a-d48e22342c37' OR (EntityID = 'CF2605AB-3F2C-4D18-B663-60105BFC2BCC' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'e560ac48-f275-4c2a-9e7a-d48e22342c37',
            'CF2605AB-3F2C-4D18-B663-60105BFC2BCC', -- Entity: Committees: Roles
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '66fa2b5b-0d6f-4a0e-acb1-ee5e7f087d3a' OR (EntityID = 'CF2605AB-3F2C-4D18-B663-60105BFC2BCC' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '66fa2b5b-0d6f-4a0e-acb1-ee5e7f087d3a',
            'CF2605AB-3F2C-4D18-B663-60105BFC2BCC', -- Entity: Committees: Roles
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0788350d-fc26-463a-adb3-e645895dca5f' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0788350d-fc26-463a-adb3-e645895dca5f',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '22a63060-2ef9-4112-9d48-e5ceb876fbd2' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = 'CommitteeID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '22a63060-2ef9-4112-9d48-e5ceb876fbd2',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
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
            0,
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '17cd2d1f-0e72-4337-8e8a-0f7ee643b592' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = 'Title')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '17cd2d1f-0e72-4337-8e8a-0f7ee643b592',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
            100003,
            'Title',
            'Title',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            0,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'bc8c3498-5fa6-403e-a2b0-e94234260c92' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = 'Description')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'bc8c3498-5fa6-403e-a2b0-e94234260c92',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
            100004,
            'Description',
            'Description',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'b34dd19b-8edf-4276-9abc-60d616322638' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = 'StartDateTime')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'b34dd19b-8edf-4276-9abc-60d616322638',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
            100005,
            'StartDateTime',
            'Start Date Time',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            0,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2a285f17-fc53-4796-9075-6db3579ad23c' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = 'EndDateTime')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '2a285f17-fc53-4796-9075-6db3579ad23c',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
            100006,
            'EndDateTime',
            'End Date Time',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0b90e7d8-723f-4367-a708-52e7b65ae140' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = 'TimeZone')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0b90e7d8-723f-4367-a708-52e7b65ae140',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
            100007,
            'TimeZone',
            'Time Zone',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'America/New_York',
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '94950587-3760-40b5-b9e8-8c80078a7291' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = 'LocationType')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '94950587-3760-40b5-b9e8-8c80078a7291',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
            100008,
            'LocationType',
            'Location Type',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Virtual',
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '3374c5a3-3a8a-4ce7-8cfb-7ebd51cf7465' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = 'LocationText')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '3374c5a3-3a8a-4ce7-8cfb-7ebd51cf7465',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
            100009,
            'LocationText',
            'Location Text',
            NULL,
            'nvarchar',
            1000,
            0,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '4d5369f2-72f9-42d5-a6e6-f6043cc00e69' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = 'VideoProvider')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '4d5369f2-72f9-42d5-a6e6-f6043cc00e69',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
            100010,
            'VideoProvider',
            'Video Provider',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'a0fdc791-dd72-4a4d-bea6-53162cd2d0de' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = 'VideoProviderID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'a0fdc791-dd72-4a4d-bea6-53162cd2d0de',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
            100011,
            'VideoProviderID',
            'Video Provider ID',
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
            0,
            'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2d70be08-0848-402c-85de-77c37fe2f5f9' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = 'VideoMeetingID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '2d70be08-0848-402c-85de-77c37fe2f5f9',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
            100012,
            'VideoMeetingID',
            'Video Meeting ID',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '04d0fd69-60d9-4a19-b13b-be8ea48220aa' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = 'VideoJoinURL')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '04d0fd69-60d9-4a19-b13b-be8ea48220aa',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
            100013,
            'VideoJoinURL',
            'Video Join URL',
            NULL,
            'nvarchar',
            2000,
            0,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'e1b3b093-05f6-474b-9b65-22e104054c3e' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = 'VideoRecordingURL')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'e1b3b093-05f6-474b-9b65-22e104054c3e',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
            100014,
            'VideoRecordingURL',
            'Video Recording URL',
            NULL,
            'nvarchar',
            2000,
            0,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '831da764-9a37-49ef-a98b-21f2031d1aa8' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = 'TranscriptURL')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '831da764-9a37-49ef-a98b-21f2031d1aa8',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
            100015,
            'TranscriptURL',
            'Transcript URL',
            NULL,
            'nvarchar',
            2000,
            0,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '880dd114-cdde-49da-a0ff-13a8d41f1c43' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = 'Status')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '880dd114-cdde-49da-a0ff-13a8d41f1c43',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
            100016,
            'Status',
            'Status',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Scheduled',
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '86d0e61f-70e6-4caf-adba-e63c4dab06f5' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = 'CalendarEventID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '86d0e61f-70e6-4caf-adba-e63c4dab06f5',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
            100017,
            'CalendarEventID',
            'Calendar Event ID',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'b2be578c-9c62-4391-810c-46510b6a99b3' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'b2be578c-9c62-4391-810c-46510b6a99b3',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'abe7d755-dc72-44f5-afa2-1f581d1025ee' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'abe7d755-dc72-44f5-afa2-1f581d1025ee',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '6e7dc0cc-7f2e-4efb-a9da-344c1bfe5f2f' OR (EntityID = '9D005287-0D07-436B-B4D4-AAE31C42BFA7' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '6e7dc0cc-7f2e-4efb-a9da-344c1bfe5f2f',
            '9D005287-0D07-436B-B4D4-AAE31C42BFA7', -- Entity: Committees: Attendances
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '3255949f-4fea-4838-9c1c-ad26020e7c83' OR (EntityID = '9D005287-0D07-436B-B4D4-AAE31C42BFA7' AND Name = 'MeetingID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '3255949f-4fea-4838-9c1c-ad26020e7c83',
            '9D005287-0D07-436B-B4D4-AAE31C42BFA7', -- Entity: Committees: Attendances
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
            0,
            'F05BE747-6F2A-472E-8800-8A10D416EAA1',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '54d5634b-5e5b-416f-a43b-61a3e9c27216' OR (EntityID = '9D005287-0D07-436B-B4D4-AAE31C42BFA7' AND Name = 'PersonID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '54d5634b-5e5b-416f-a43b-61a3e9c27216',
            '9D005287-0D07-436B-B4D4-AAE31C42BFA7', -- Entity: Committees: Attendances
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '7ed59fe7-d94c-4e68-be00-e35e57b674dc' OR (EntityID = '9D005287-0D07-436B-B4D4-AAE31C42BFA7' AND Name = 'AttendanceStatus')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '7ed59fe7-d94c-4e68-be00-e35e57b674dc',
            '9D005287-0D07-436B-B4D4-AAE31C42BFA7', -- Entity: Committees: Attendances
            100004,
            'AttendanceStatus',
            'Attendance Status',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Expected',
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'dc1e550d-11cf-4dc9-9567-c3faa9cc7370' OR (EntityID = '9D005287-0D07-436B-B4D4-AAE31C42BFA7' AND Name = 'JoinedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'dc1e550d-11cf-4dc9-9567-c3faa9cc7370',
            '9D005287-0D07-436B-B4D4-AAE31C42BFA7', -- Entity: Committees: Attendances
            100005,
            'JoinedAt',
            'Joined At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '6c8e7e8d-3dd1-4d98-bb16-592688cbacc3' OR (EntityID = '9D005287-0D07-436B-B4D4-AAE31C42BFA7' AND Name = 'LeftAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '6c8e7e8d-3dd1-4d98-bb16-592688cbacc3',
            '9D005287-0D07-436B-B4D4-AAE31C42BFA7', -- Entity: Committees: Attendances
            100006,
            'LeftAt',
            'Left At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'c0f91d5d-0825-4235-86ca-861210b8eb98' OR (EntityID = '9D005287-0D07-436B-B4D4-AAE31C42BFA7' AND Name = 'Notes')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'c0f91d5d-0825-4235-86ca-861210b8eb98',
            '9D005287-0D07-436B-B4D4-AAE31C42BFA7', -- Entity: Committees: Attendances
            100007,
            'Notes',
            'Notes',
            NULL,
            'nvarchar',
            1000,
            0,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '48729ea3-aad7-4ed5-a997-6c49aa56c682' OR (EntityID = '9D005287-0D07-436B-B4D4-AAE31C42BFA7' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '48729ea3-aad7-4ed5-a997-6c49aa56c682',
            '9D005287-0D07-436B-B4D4-AAE31C42BFA7', -- Entity: Committees: Attendances
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '9120bd42-5706-46e2-b29f-ae4d32c37bfb' OR (EntityID = '9D005287-0D07-436B-B4D4-AAE31C42BFA7' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '9120bd42-5706-46e2-b29f-ae4d32c37bfb',
            '9D005287-0D07-436B-B4D4-AAE31C42BFA7', -- Entity: Committees: Attendances
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '20e082c1-d5be-4797-9662-1f006feb4e0f' OR (EntityID = 'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '20e082c1-d5be-4797-9662-1f006feb4e0f',
            'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9', -- Entity: Committees: Video Providers
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '1dce37f4-2759-4719-96cc-4da8b386528c' OR (EntityID = 'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9' AND Name = 'Name')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '1dce37f4-2759-4719-96cc-4da8b386528c',
            'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9', -- Entity: Committees: Video Providers
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'c9f8bc65-f002-4c8e-85a2-b97a88176197' OR (EntityID = 'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9' AND Name = 'ServerDriverKey')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'c9f8bc65-f002-4c8e-85a2-b97a88176197',
            'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9', -- Entity: Committees: Video Providers
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '53a4eae5-0b76-4c9b-a787-188cd1c3efe6' OR (EntityID = 'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9' AND Name = 'IsActive')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '53a4eae5-0b76-4c9b-a787-188cd1c3efe6',
            'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9', -- Entity: Committees: Video Providers
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '04f3f75d-20d7-4a65-958f-f79f563b2b91' OR (EntityID = 'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9' AND Name = 'IsDefault')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '04f3f75d-20d7-4a65-958f-f79f563b2b91',
            'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9', -- Entity: Committees: Video Providers
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '171b0cfe-85ee-431b-9ece-1da427a26acd' OR (EntityID = 'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9' AND Name = 'CredentialID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '171b0cfe-85ee-431b-9ece-1da427a26acd',
            'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9', -- Entity: Committees: Video Providers
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '03926773-a9c3-44b0-be3c-b2f15dba28a7' OR (EntityID = 'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '03926773-a9c3-44b0-be3c-b2f15dba28a7',
            'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9', -- Entity: Committees: Video Providers
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2719f8ba-2c87-4295-bbf5-40ed4100e234' OR (EntityID = 'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '2719f8ba-2c87-4295-bbf5-40ed4100e234',
            'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9', -- Entity: Committees: Video Providers
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '6b97e2f2-a62d-479c-89ff-fd01d3c9595b' OR (EntityID = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '6b97e2f2-a62d-479c-89ff-fd01d3c9595b',
            'F4B63A74-6704-4CA9-97B5-D2EC745B0506', -- Entity: Committees: Action Items
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0bebc8b0-6113-48a9-8b7f-1fd3135e7ed5' OR (EntityID = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506' AND Name = 'CommitteeID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0bebc8b0-6113-48a9-8b7f-1fd3135e7ed5',
            'F4B63A74-6704-4CA9-97B5-D2EC745B0506', -- Entity: Committees: Action Items
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
            0,
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '7e649dc5-fd61-4b87-b65e-ace72cdd2305' OR (EntityID = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506' AND Name = 'MeetingID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '7e649dc5-fd61-4b87-b65e-ace72cdd2305',
            'F4B63A74-6704-4CA9-97B5-D2EC745B0506', -- Entity: Committees: Action Items
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
            0,
            'F05BE747-6F2A-472E-8800-8A10D416EAA1',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '19336f80-4b92-4650-80b1-2c1a861916a8' OR (EntityID = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506' AND Name = 'AgendaItemID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '19336f80-4b92-4650-80b1-2c1a861916a8',
            'F4B63A74-6704-4CA9-97B5-D2EC745B0506', -- Entity: Committees: Action Items
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
            0,
            '5746F567-3A1B-4772-B8BA-D46D98A137DD',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2d138eea-22a0-4985-b496-73cb2c6f5418' OR (EntityID = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506' AND Name = 'Title')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '2d138eea-22a0-4985-b496-73cb2c6f5418',
            'F4B63A74-6704-4CA9-97B5-D2EC745B0506', -- Entity: Committees: Action Items
            100005,
            'Title',
            'Title',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            0,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'bf0a14ac-87d4-48ee-8ea0-209962a4f052' OR (EntityID = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506' AND Name = 'Description')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'bf0a14ac-87d4-48ee-8ea0-209962a4f052',
            'F4B63A74-6704-4CA9-97B5-D2EC745B0506', -- Entity: Committees: Action Items
            100006,
            'Description',
            'Description',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0af90b52-d892-4e9e-92ba-6976f9e9ced1' OR (EntityID = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506' AND Name = 'AssignedToPersonID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0af90b52-d892-4e9e-92ba-6976f9e9ced1',
            'F4B63A74-6704-4CA9-97B5-D2EC745B0506', -- Entity: Committees: Action Items
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'fffe3501-808d-4421-9157-250e2f700e75' OR (EntityID = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506' AND Name = 'AssignedByPersonID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'fffe3501-808d-4421-9157-250e2f700e75',
            'F4B63A74-6704-4CA9-97B5-D2EC745B0506', -- Entity: Committees: Action Items
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'f50a2066-8e5f-48c1-94a4-c173c5f3a970' OR (EntityID = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506' AND Name = 'DueDate')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'f50a2066-8e5f-48c1-94a4-c173c5f3a970',
            'F4B63A74-6704-4CA9-97B5-D2EC745B0506', -- Entity: Committees: Action Items
            100009,
            'DueDate',
            'Due Date',
            NULL,
            'date',
            3,
            10,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'd944c5eb-d27b-448c-90ff-869d861b0f15' OR (EntityID = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506' AND Name = 'Priority')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'd944c5eb-d27b-448c-90ff-869d861b0f15',
            'F4B63A74-6704-4CA9-97B5-D2EC745B0506', -- Entity: Committees: Action Items
            100010,
            'Priority',
            'Priority',
            NULL,
            'nvarchar',
            40,
            0,
            0,
            0,
            'Medium',
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'af149482-d081-4d19-899f-85433eac030c' OR (EntityID = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506' AND Name = 'Status')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'af149482-d081-4d19-899f-85433eac030c',
            'F4B63A74-6704-4CA9-97B5-D2EC745B0506', -- Entity: Committees: Action Items
            100011,
            'Status',
            'Status',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Open',
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '08714c0a-cdea-4139-9040-c39c0241e2a3' OR (EntityID = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506' AND Name = 'CompletedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '08714c0a-cdea-4139-9040-c39c0241e2a3',
            'F4B63A74-6704-4CA9-97B5-D2EC745B0506', -- Entity: Committees: Action Items
            100012,
            'CompletedAt',
            'Completed At',
            NULL,
            'datetimeoffset',
            10,
            34,
            7,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '4f719ac6-41cb-4624-b4ff-43bc84fc0dc2' OR (EntityID = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506' AND Name = 'CompletionNotes')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '4f719ac6-41cb-4624-b4ff-43bc84fc0dc2',
            'F4B63A74-6704-4CA9-97B5-D2EC745B0506', -- Entity: Committees: Action Items
            100013,
            'CompletionNotes',
            'Completion Notes',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '454bf1c0-1ed9-49a5-960d-69e2950b9bc6' OR (EntityID = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '454bf1c0-1ed9-49a5-960d-69e2950b9bc6',
            'F4B63A74-6704-4CA9-97B5-D2EC745B0506', -- Entity: Committees: Action Items
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'd1963121-46d2-48e5-bbf7-e3e5a78777af' OR (EntityID = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'd1963121-46d2-48e5-bbf7-e3e5a78777af',
            'F4B63A74-6704-4CA9-97B5-D2EC745B0506', -- Entity: Committees: Action Items
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '5701e3ca-8a27-483e-83b7-82799b16daec' OR (EntityID = '5746F567-3A1B-4772-B8BA-D46D98A137DD' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '5701e3ca-8a27-483e-83b7-82799b16daec',
            '5746F567-3A1B-4772-B8BA-D46D98A137DD', -- Entity: Committees: Agenda Items
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2418b74a-c484-4ce8-88f5-d7b120fec986' OR (EntityID = '5746F567-3A1B-4772-B8BA-D46D98A137DD' AND Name = 'MeetingID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '2418b74a-c484-4ce8-88f5-d7b120fec986',
            '5746F567-3A1B-4772-B8BA-D46D98A137DD', -- Entity: Committees: Agenda Items
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
            0,
            'F05BE747-6F2A-472E-8800-8A10D416EAA1',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'b25029bc-3615-4fcc-b2b7-587e0d48055c' OR (EntityID = '5746F567-3A1B-4772-B8BA-D46D98A137DD' AND Name = 'ParentAgendaItemID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'b25029bc-3615-4fcc-b2b7-587e0d48055c',
            '5746F567-3A1B-4772-B8BA-D46D98A137DD', -- Entity: Committees: Agenda Items
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
            0,
            '5746F567-3A1B-4772-B8BA-D46D98A137DD',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '43e0a6d1-42d9-4da2-87b0-01b48e093c55' OR (EntityID = '5746F567-3A1B-4772-B8BA-D46D98A137DD' AND Name = 'Sequence')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '43e0a6d1-42d9-4da2-87b0-01b48e093c55',
            '5746F567-3A1B-4772-B8BA-D46D98A137DD', -- Entity: Committees: Agenda Items
            100004,
            'Sequence',
            'Sequence',
            NULL,
            'int',
            4,
            10,
            0,
            0,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0d6fdd50-b0b8-4d93-9b60-64b55ac8d41c' OR (EntityID = '5746F567-3A1B-4772-B8BA-D46D98A137DD' AND Name = 'Title')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0d6fdd50-b0b8-4d93-9b60-64b55ac8d41c',
            '5746F567-3A1B-4772-B8BA-D46D98A137DD', -- Entity: Committees: Agenda Items
            100005,
            'Title',
            'Title',
            NULL,
            'nvarchar',
            510,
            0,
            0,
            0,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '417d0165-007c-4c55-aa34-a602c010dc46' OR (EntityID = '5746F567-3A1B-4772-B8BA-D46D98A137DD' AND Name = 'Description')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '417d0165-007c-4c55-aa34-a602c010dc46',
            '5746F567-3A1B-4772-B8BA-D46D98A137DD', -- Entity: Committees: Agenda Items
            100006,
            'Description',
            'Description',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'ad709e40-2208-40b8-a61b-1e8b6871060c' OR (EntityID = '5746F567-3A1B-4772-B8BA-D46D98A137DD' AND Name = 'PresenterPersonID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'ad709e40-2208-40b8-a61b-1e8b6871060c',
            '5746F567-3A1B-4772-B8BA-D46D98A137DD', -- Entity: Committees: Agenda Items
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'b1714c81-cd83-47a4-9282-00d0441118c2' OR (EntityID = '5746F567-3A1B-4772-B8BA-D46D98A137DD' AND Name = 'DurationMinutes')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'b1714c81-cd83-47a4-9282-00d0441118c2',
            '5746F567-3A1B-4772-B8BA-D46D98A137DD', -- Entity: Committees: Agenda Items
            100008,
            'DurationMinutes',
            'Duration Minutes',
            NULL,
            'int',
            4,
            10,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '9c96e020-b3b7-4318-9fec-44f98bf8882f' OR (EntityID = '5746F567-3A1B-4772-B8BA-D46D98A137DD' AND Name = 'ItemType')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '9c96e020-b3b7-4318-9fec-44f98bf8882f',
            '5746F567-3A1B-4772-B8BA-D46D98A137DD', -- Entity: Committees: Agenda Items
            100009,
            'ItemType',
            'Item Type',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Discussion',
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '871a5ab1-3d67-4d8a-8a40-d7a86a4fc3aa' OR (EntityID = '5746F567-3A1B-4772-B8BA-D46D98A137DD' AND Name = 'RelatedDocumentURL')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '871a5ab1-3d67-4d8a-8a40-d7a86a4fc3aa',
            '5746F567-3A1B-4772-B8BA-D46D98A137DD', -- Entity: Committees: Agenda Items
            100010,
            'RelatedDocumentURL',
            'Related Document URL',
            NULL,
            'nvarchar',
            2000,
            0,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '5a596d23-e8fa-4a00-83a8-ba71ce660975' OR (EntityID = '5746F567-3A1B-4772-B8BA-D46D98A137DD' AND Name = 'Status')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '5a596d23-e8fa-4a00-83a8-ba71ce660975',
            '5746F567-3A1B-4772-B8BA-D46D98A137DD', -- Entity: Committees: Agenda Items
            100011,
            'Status',
            'Status',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Pending',
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '5ee46944-4cf3-40b6-864b-a79d457f563c' OR (EntityID = '5746F567-3A1B-4772-B8BA-D46D98A137DD' AND Name = 'Notes')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '5ee46944-4cf3-40b6-864b-a79d457f563c',
            '5746F567-3A1B-4772-B8BA-D46D98A137DD', -- Entity: Committees: Agenda Items
            100012,
            'Notes',
            'Notes',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '5c90c329-38a2-4082-a3c9-b507f9c39762' OR (EntityID = '5746F567-3A1B-4772-B8BA-D46D98A137DD' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '5c90c329-38a2-4082-a3c9-b507f9c39762',
            '5746F567-3A1B-4772-B8BA-D46D98A137DD', -- Entity: Committees: Agenda Items
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '79c02fc4-b45b-4274-b7a9-1abe9546739e' OR (EntityID = '5746F567-3A1B-4772-B8BA-D46D98A137DD' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '79c02fc4-b45b-4274-b7a9-1abe9546739e',
            '5746F567-3A1B-4772-B8BA-D46D98A137DD', -- Entity: Committees: Agenda Items
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '4b609554-36f6-4884-bc6d-9a4baac32798' OR (EntityID = '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42' AND Name = 'ID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '4b609554-36f6-4884-bc6d-9a4baac32798',
            '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', -- Entity: Committees: Memberships
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '51f7b196-9536-4012-83aa-e5d8c11ebb45' OR (EntityID = '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42' AND Name = 'PersonID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '51f7b196-9536-4012-83aa-e5d8c11ebb45',
            '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', -- Entity: Committees: Memberships
            100002,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '750e3103-de75-48e9-8806-e5d096cf72b9' OR (EntityID = '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42' AND Name = 'RoleID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '750e3103-de75-48e9-8806-e5d096cf72b9',
            '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', -- Entity: Committees: Memberships
            100003,
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
            0,
            'CF2605AB-3F2C-4D18-B663-60105BFC2BCC',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2cee9b5e-6008-45ba-9e82-276e901e0457' OR (EntityID = '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42' AND Name = 'TermID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '2cee9b5e-6008-45ba-9e82-276e901e0457',
            '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', -- Entity: Committees: Memberships
            100004,
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
            0,
            'EAD3EF14-1891-4389-A0F3-1984BC8CC13F',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '8287de43-b082-41fd-8803-6ee9936de135' OR (EntityID = '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42' AND Name = 'StartDate')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '8287de43-b082-41fd-8803-6ee9936de135',
            '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', -- Entity: Committees: Memberships
            100005,
            'StartDate',
            'Start Date',
            NULL,
            'date',
            3,
            10,
            0,
            0,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0c4d09b0-492a-4c26-abf8-e48dc33f9c08' OR (EntityID = '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42' AND Name = 'EndDate')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0c4d09b0-492a-4c26-abf8-e48dc33f9c08',
            '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', -- Entity: Committees: Memberships
            100006,
            'EndDate',
            'End Date',
            NULL,
            'date',
            3,
            10,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0608a3e1-f79e-4336-8ae0-96880839de0f' OR (EntityID = '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42' AND Name = 'Status')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0608a3e1-f79e-4336-8ae0-96880839de0f',
            '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', -- Entity: Committees: Memberships
            100007,
            'Status',
            'Status',
            NULL,
            'nvarchar',
            100,
            0,
            0,
            0,
            'Active',
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '4bb2da57-f4b7-4d99-81e2-a4034972d8d9' OR (EntityID = '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42' AND Name = 'EndReason')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '4bb2da57-f4b7-4d99-81e2-a4034972d8d9',
            '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', -- Entity: Committees: Memberships
            100008,
            'EndReason',
            'End Reason',
            NULL,
            'nvarchar',
            200,
            0,
            0,
            1,
            NULL,
            0,
            1,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '87424f57-f767-4c17-a32b-001d45a2cd13' OR (EntityID = '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42' AND Name = 'Notes')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '87424f57-f767-4c17-a32b-001d45a2cd13',
            '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', -- Entity: Committees: Memberships
            100009,
            'Notes',
            'Notes',
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'eb60ed17-6382-4086-90a1-4176a9685aaa' OR (EntityID = '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42' AND Name = '__mj_CreatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'eb60ed17-6382-4086-90a1-4176a9685aaa',
            '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', -- Entity: Committees: Memberships
            100010,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '930b32e3-145e-40cf-89a8-08f8e01e8bc0' OR (EntityID = '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42' AND Name = '__mj_UpdatedAt')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '930b32e3-145e-40cf-89a8-08f8e01e8bc0',
            '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', -- Entity: Committees: Memberships
            100011,
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
      END;

/* SQL text to update existing entity fields from schema */
EXEC [${mjSchema}].[spUpdateExistingEntityFieldsFromSchema] @ExcludedSchemaNames='sys,staging,${mjSchema},${mjSchema}_BizAppsCommon,${mjSchema}_BizAppsTasks';

/* SQL text to set default column width where needed */
EXEC [${mjSchema}].[spSetDefaultColumnWidthWhereNeeded] @ExcludedSchemaNames='sys,staging,${mjSchema},${mjSchema}_BizAppsCommon,${mjSchema}_BizAppsTasks';

/* SQL text to insert entity field value with ID 24a2f841-8668-4146-b917-3627a597bf39 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('24a2f841-8668-4146-b917-3627a597bf39', '880DD114-CDDE-49DA-A0FF-13A8D41F1C43', 1, 'Cancelled', 'Cancelled', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID b101b3aa-9c75-47b2-988b-e3ff398b602b */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('b101b3aa-9c75-47b2-988b-e3ff398b602b', '880DD114-CDDE-49DA-A0FF-13A8D41F1C43', 2, 'Completed', 'Completed', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 0942fa28-b241-48f6-a408-c81d04bff102 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('0942fa28-b241-48f6-a408-c81d04bff102', '880DD114-CDDE-49DA-A0FF-13A8D41F1C43', 3, 'Draft', 'Draft', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID e2c727e1-b262-43c6-9710-6120503a1f2f */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('e2c727e1-b262-43c6-9710-6120503a1f2f', '880DD114-CDDE-49DA-A0FF-13A8D41F1C43', 4, 'InProgress', 'InProgress', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 306587a3-625b-473e-85dd-5a1162f14f28 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('306587a3-625b-473e-85dd-5a1162f14f28', '880DD114-CDDE-49DA-A0FF-13A8D41F1C43', 5, 'Postponed', 'Postponed', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID b6ca1f1e-82e0-4943-b91e-81add1f75a35 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('b6ca1f1e-82e0-4943-b91e-81add1f75a35', '880DD114-CDDE-49DA-A0FF-13A8D41F1C43', 6, 'Scheduled', 'Scheduled', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 880DD114-CDDE-49DA-A0FF-13A8D41F1C43 */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='880DD114-CDDE-49DA-A0FF-13A8D41F1C43';

/* SQL text to insert entity field value with ID e7193149-7583-4962-bddb-5b08ef179f29 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('e7193149-7583-4962-bddb-5b08ef179f29', '94950587-3760-40B5-B9E8-8C80078A7291', 1, 'Hybrid', 'Hybrid', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 7db70c79-7918-4b05-9d21-235c51ede4d4 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('7db70c79-7918-4b05-9d21-235c51ede4d4', '94950587-3760-40B5-B9E8-8C80078A7291', 2, 'InPerson', 'InPerson', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID e7369d75-8006-4967-b182-edc5ca86133a */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('e7369d75-8006-4967-b182-edc5ca86133a', '94950587-3760-40B5-B9E8-8C80078A7291', 3, 'Virtual', 'Virtual', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 94950587-3760-40B5-B9E8-8C80078A7291 */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='94950587-3760-40B5-B9E8-8C80078A7291';

/* SQL text to insert entity field value with ID 17cc1088-0756-4045-a8aa-c856af3c9c87 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('17cc1088-0756-4045-a8aa-c856af3c9c87', '9C96E020-B3B7-4318-9FEC-44F98BF8882F', 1, 'Action', 'Action', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID b25f2567-ff89-483b-a63b-7d536e62c2fe */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('b25f2567-ff89-483b-a63b-7d536e62c2fe', '9C96E020-B3B7-4318-9FEC-44F98BF8882F', 2, 'Discussion', 'Discussion', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 7e31896d-80c1-46b8-b117-945cdd1fc696 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('7e31896d-80c1-46b8-b117-945cdd1fc696', '9C96E020-B3B7-4318-9FEC-44F98BF8882F', 3, 'Information', 'Information', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 678e1261-9347-4b5d-a8d9-49bc969bcee0 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('678e1261-9347-4b5d-a8d9-49bc969bcee0', '9C96E020-B3B7-4318-9FEC-44F98BF8882F', 4, 'Other', 'Other', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 87cd9c33-753c-48f1-ab87-f14ce3324eeb */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('87cd9c33-753c-48f1-ab87-f14ce3324eeb', '9C96E020-B3B7-4318-9FEC-44F98BF8882F', 5, 'Report', 'Report', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 3b8bc0a6-6028-441a-a3b8-8e908391c530 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('3b8bc0a6-6028-441a-a3b8-8e908391c530', '9C96E020-B3B7-4318-9FEC-44F98BF8882F', 6, 'Vote', 'Vote', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 9C96E020-B3B7-4318-9FEC-44F98BF8882F */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='9C96E020-B3B7-4318-9FEC-44F98BF8882F';

/* SQL text to insert entity field value with ID e182010b-8961-48aa-86d4-c3a55e59b201 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('e182010b-8961-48aa-86d4-c3a55e59b201', '5A596D23-E8FA-4A00-83A8-BA71CE660975', 1, 'Completed', 'Completed', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID a3c5bb97-25f2-48f1-8e37-8b26e99df231 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('a3c5bb97-25f2-48f1-8e37-8b26e99df231', '5A596D23-E8FA-4A00-83A8-BA71CE660975', 2, 'Discussed', 'Discussed', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID babf4c75-0c2b-4af2-8454-43308fd719ef */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('babf4c75-0c2b-4af2-8454-43308fd719ef', '5A596D23-E8FA-4A00-83A8-BA71CE660975', 3, 'Pending', 'Pending', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID a2e5de25-00ba-4079-ab21-59f742278dd0 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('a2e5de25-00ba-4079-ab21-59f742278dd0', '5A596D23-E8FA-4A00-83A8-BA71CE660975', 4, 'Skipped', 'Skipped', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 3255757e-38de-42d9-8b14-7d964707cb82 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('3255757e-38de-42d9-8b14-7d964707cb82', '5A596D23-E8FA-4A00-83A8-BA71CE660975', 5, 'Tabled', 'Tabled', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 5A596D23-E8FA-4A00-83A8-BA71CE660975 */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='5A596D23-E8FA-4A00-83A8-BA71CE660975';

/* SQL text to insert entity field value with ID d79c5d17-df15-4087-950f-36fe4997104f */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('d79c5d17-df15-4087-950f-36fe4997104f', '7ED59FE7-D94C-4E68-BE00-E35E57B674DC', 1, 'Absent', 'Absent', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID fd6d18ac-00e7-4516-8d3f-c2e94d9ff7d1 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('fd6d18ac-00e7-4516-8d3f-c2e94d9ff7d1', '7ED59FE7-D94C-4E68-BE00-E35E57B674DC', 2, 'Excused', 'Excused', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID dc722c52-eefb-4287-bdbd-d040119868cf */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('dc722c52-eefb-4287-bdbd-d040119868cf', '7ED59FE7-D94C-4E68-BE00-E35E57B674DC', 3, 'Expected', 'Expected', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 826962c1-73c4-48c9-aac5-f77acea5d7ee */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('826962c1-73c4-48c9-aac5-f77acea5d7ee', '7ED59FE7-D94C-4E68-BE00-E35E57B674DC', 4, 'Partial', 'Partial', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 6c7b668a-8322-4b55-b28b-95283ba980e3 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('6c7b668a-8322-4b55-b28b-95283ba980e3', '7ED59FE7-D94C-4E68-BE00-E35E57B674DC', 5, 'Present', 'Present', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 7ED59FE7-D94C-4E68-BE00-E35E57B674DC */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='7ED59FE7-D94C-4E68-BE00-E35E57B674DC';

/* SQL text to insert entity field value with ID bfd7b24a-ddae-4316-9cdc-bc4a5f7de78d */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('bfd7b24a-ddae-4316-9cdc-bc4a5f7de78d', 'D944C5EB-D27B-448C-90FF-869D861B0F15', 1, 'Critical', 'Critical', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 1fd12a32-b79f-4857-9024-36ab81b6e520 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('1fd12a32-b79f-4857-9024-36ab81b6e520', 'D944C5EB-D27B-448C-90FF-869D861B0F15', 2, 'High', 'High', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 926f54c5-7d66-48c6-b2e7-6dc8c2d4d6b9 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('926f54c5-7d66-48c6-b2e7-6dc8c2d4d6b9', 'D944C5EB-D27B-448C-90FF-869D861B0F15', 3, 'Low', 'Low', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID dcc28662-4eaf-445d-93ec-064f38a760ca */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('dcc28662-4eaf-445d-93ec-064f38a760ca', 'D944C5EB-D27B-448C-90FF-869D861B0F15', 4, 'Medium', 'Medium', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID D944C5EB-D27B-448C-90FF-869D861B0F15 */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='D944C5EB-D27B-448C-90FF-869D861B0F15';

/* SQL text to insert entity field value with ID 3259b5e1-2675-4b2a-ac99-96f8ec049f86 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('3259b5e1-2675-4b2a-ac99-96f8ec049f86', 'AF149482-D081-4D19-899F-85433EAC030C', 1, 'Blocked', 'Blocked', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID f5725465-34a7-4623-811b-7bfb0840464e */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('f5725465-34a7-4623-811b-7bfb0840464e', 'AF149482-D081-4D19-899F-85433EAC030C', 2, 'Cancelled', 'Cancelled', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 18aa50de-ee2f-4426-858d-d8d32246c450 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('18aa50de-ee2f-4426-858d-d8d32246c450', 'AF149482-D081-4D19-899F-85433EAC030C', 3, 'Completed', 'Completed', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 016a4619-0317-46a9-9ce3-0088474e43a9 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('016a4619-0317-46a9-9ce3-0088474e43a9', 'AF149482-D081-4D19-899F-85433EAC030C', 4, 'InProgress', 'InProgress', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 7e0e17d5-28e2-4207-a3b2-a78c46f5c716 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('7e0e17d5-28e2-4207-a3b2-a78c46f5c716', 'AF149482-D081-4D19-899F-85433EAC030C', 5, 'Open', 'Open', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID AF149482-D081-4D19-899F-85433EAC030C */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='AF149482-D081-4D19-899F-85433EAC030C';

/* SQL text to insert entity field value with ID 1b37f9bc-e42f-437d-990c-bcda3cc8b5b9 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('1b37f9bc-e42f-437d-990c-bcda3cc8b5b9', 'C8A72305-27CA-4723-9FC2-D875CA1D963C', 1, 'Box', 'Box', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID d74fcf02-8c42-4b54-a7fd-73689bbcc234 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('d74fcf02-8c42-4b54-a7fd-73689bbcc234', 'C8A72305-27CA-4723-9FC2-D875CA1D963C', 2, 'Dropbox', 'Dropbox', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 93f52f2f-1cd1-4f39-b3a2-3505cff5e76f */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('93f52f2f-1cd1-4f39-b3a2-3505cff5e76f', 'C8A72305-27CA-4723-9FC2-D875CA1D963C', 3, 'GoogleDrive', 'GoogleDrive', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 9e2379ed-cf9b-4cda-bd90-6ab11627a98b */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('9e2379ed-cf9b-4cda-bd90-6ab11627a98b', 'C8A72305-27CA-4723-9FC2-D875CA1D963C', 4, 'OneDrive', 'OneDrive', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 8e118150-39cf-4a58-af77-c78f5aedcdca */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('8e118150-39cf-4a58-af77-c78f5aedcdca', 'C8A72305-27CA-4723-9FC2-D875CA1D963C', 5, 'SharePoint', 'SharePoint', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 885f87b7-ef05-4d15-8741-f9081c8eace3 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('885f87b7-ef05-4d15-8741-f9081c8eace3', 'C8A72305-27CA-4723-9FC2-D875CA1D963C', 6, 'URL', 'URL', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID C8A72305-27CA-4723-9FC2-D875CA1D963C */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='C8A72305-27CA-4723-9FC2-D875CA1D963C';

/* SQL text to insert entity field value with ID d6130da6-2927-4c7b-b796-55378bfadea7 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('d6130da6-2927-4c7b-b796-55378bfadea7', 'E8674472-D4BD-49FA-A281-9FE6739F51F8', 1, 'Approved', 'Approved', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 075d4a91-c443-4c1b-833e-d96d7cfc2b9a */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('075d4a91-c443-4c1b-833e-d96d7cfc2b9a', 'E8674472-D4BD-49FA-A281-9FE6739F51F8', 2, 'Draft', 'Draft', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 3065715c-924f-4cc7-bada-2d184c06da0c */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('3065715c-924f-4cc7-bada-2d184c06da0c', 'E8674472-D4BD-49FA-A281-9FE6739F51F8', 3, 'PendingApproval', 'PendingApproval', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID c5e39a08-7643-4982-9fb1-d24a1be828b6 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('c5e39a08-7643-4982-9fb1-d24a1be828b6', 'E8674472-D4BD-49FA-A281-9FE6739F51F8', 4, 'Rejected', 'Rejected', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID E8674472-D4BD-49FA-A281-9FE6739F51F8 */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='E8674472-D4BD-49FA-A281-9FE6739F51F8';

/* SQL text to insert entity field value with ID 012961a1-3c77-46e2-8b1e-10ecb3b45bb8 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('012961a1-3c77-46e2-8b1e-10ecb3b45bb8', '84428F50-1C25-46B8-A9CB-ED285792AFBA', 1, 'Failed', 'Failed', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 6ad719ce-bf6f-4440-aa36-62004b263174 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('6ad719ce-bf6f-4440-aa36-62004b263174', '84428F50-1C25-46B8-A9CB-ED285792AFBA', 2, 'Passed', 'Passed', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 1b9c747a-83a7-48a3-a37c-8c9f5f396f2c */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('1b9c747a-83a7-48a3-a37c-8c9f5f396f2c', '84428F50-1C25-46B8-A9CB-ED285792AFBA', 3, 'Pending', 'Pending', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID bf710400-3b07-49ff-8fae-b19995f31c61 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('bf710400-3b07-49ff-8fae-b19995f31c61', '84428F50-1C25-46B8-A9CB-ED285792AFBA', 4, 'Tabled', 'Tabled', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 58224e3a-dbf9-4273-99b1-4e6605b1317b */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('58224e3a-dbf9-4273-99b1-4e6605b1317b', '84428F50-1C25-46B8-A9CB-ED285792AFBA', 5, 'Withdrawn', 'Withdrawn', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 84428F50-1C25-46B8-A9CB-ED285792AFBA */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='84428F50-1C25-46B8-A9CB-ED285792AFBA';

/* SQL text to insert entity field value with ID 42a51828-1347-40c4-96c4-6b474014f2cd */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('42a51828-1347-40c4-96c4-6b474014f2cd', '92B05FA7-5D41-4E58-934D-4021853197D3', 1, 'Absent', 'Absent', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 500b2f76-837d-4c73-ae6d-c35770765721 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('500b2f76-837d-4c73-ae6d-c35770765721', '92B05FA7-5D41-4E58-934D-4021853197D3', 2, 'Abstain', 'Abstain', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID ec5f4935-f661-4754-b08b-9565f9eca8a2 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('ec5f4935-f661-4754-b08b-9565f9eca8a2', '92B05FA7-5D41-4E58-934D-4021853197D3', 3, 'No', 'No', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID ea1e81d5-97b5-4061-be2b-b447804389cf */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('ea1e81d5-97b5-4061-be2b-b447804389cf', '92B05FA7-5D41-4E58-934D-4021853197D3', 4, 'Yes', 'Yes', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 92B05FA7-5D41-4E58-934D-4021853197D3 */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='92B05FA7-5D41-4E58-934D-4021853197D3';

/* SQL text to insert entity field value with ID 3840850f-7071-4c29-9f6e-f825a206d8cd */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('3840850f-7071-4c29-9f6e-f825a206d8cd', '963D5F6A-9B40-44E5-8611-64F666643D44', 1, 'Active', 'Active', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID d68907a1-9c61-4f0b-8546-84931c49c595 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('d68907a1-9c61-4f0b-8546-84931c49c595', '963D5F6A-9B40-44E5-8611-64F666643D44', 2, 'Dissolved', 'Dissolved', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 600bb4fc-57b2-4036-88a9-f5942df8073d */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('600bb4fc-57b2-4036-88a9-f5942df8073d', '963D5F6A-9B40-44E5-8611-64F666643D44', 3, 'Inactive', 'Inactive', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID ea918d56-08e2-45b9-9553-d63dfdd741dc */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('ea918d56-08e2-45b9-9553-d63dfdd741dc', '963D5F6A-9B40-44E5-8611-64F666643D44', 4, 'Pending', 'Pending', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 963D5F6A-9B40-44E5-8611-64F666643D44 */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='963D5F6A-9B40-44E5-8611-64F666643D44';

/* SQL text to insert entity field value with ID d79e24e7-6450-4e54-98da-1b21dfe84547 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('d79e24e7-6450-4e54-98da-1b21dfe84547', 'BBB912DF-DAE0-4CD9-915F-4D10705394AE', 1, 'Active', 'Active', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 9ad92504-6f24-4e57-9381-4952b5c36a9d */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('9ad92504-6f24-4e57-9381-4952b5c36a9d', 'BBB912DF-DAE0-4CD9-915F-4D10705394AE', 2, 'Completed', 'Completed', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 2c649046-d29f-4b84-8e50-3d0f1e88db7f */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('2c649046-d29f-4b84-8e50-3d0f1e88db7f', 'BBB912DF-DAE0-4CD9-915F-4D10705394AE', 3, 'Upcoming', 'Upcoming', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID BBB912DF-DAE0-4CD9-915F-4D10705394AE */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='BBB912DF-DAE0-4CD9-915F-4D10705394AE';

/* SQL text to insert entity field value with ID e6173bd8-5b7a-47ad-9fe2-77981fd4f12d */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('e6173bd8-5b7a-47ad-9fe2-77981fd4f12d', '0608A3E1-F79E-4336-8AE0-96880839DE0F', 1, 'Active', 'Active', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 77f1acb4-9c2a-4da9-a6d3-9b78466e0a7b */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('77f1acb4-9c2a-4da9-a6d3-9b78466e0a7b', '0608A3E1-F79E-4336-8AE0-96880839DE0F', 2, 'Ended', 'Ended', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 5caa2d10-7317-4b31-a404-b0f7e98d7c8e */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('5caa2d10-7317-4b31-a404-b0f7e98d7c8e', '0608A3E1-F79E-4336-8AE0-96880839DE0F', 3, 'Pending', 'Pending', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID ef5e09e4-312c-4168-ab77-bd56f2c3c64c */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('ef5e09e4-312c-4168-ab77-bd56f2c3c64c', '0608A3E1-F79E-4336-8AE0-96880839DE0F', 4, 'Suspended', 'Suspended', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 0608A3E1-F79E-4336-8AE0-96880839DE0F */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='0608A3E1-F79E-4336-8AE0-96880839DE0F';


/* Create Entity Relationship: Committees: Terms -> Committees: Memberships (One To Many via TermID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '2c3c9450-ea8b-4f36-b430-369ef8dd601f'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('2c3c9450-ea8b-4f36-b430-369ef8dd601f', 'EAD3EF14-1891-4389-A0F3-1984BC8CC13F', '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', 'TermID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Motions -> Committees: Votes (One To Many via MotionID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '175d8022-6611-4e00-9913-6d824d3be03e'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('175d8022-6611-4e00-9913-6d824d3be03e', '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', '80299A27-B207-4D99-A46B-4E5B8A2B5E62', 'MotionID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Types -> Committees: Committees (One To Many via TypeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'da4039c4-c4a6-4a6c-a5d0-12d404eb2ce0'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('da4039c4-c4a6-4a6c-a5d0-12d404eb2ce0', '1D7F24C0-622E-41E0-BC38-29C2EEB1D442', 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', 'TypeID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Artifacts -> Committees: Minutes (One To Many via ArtifactID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '005b345c-824e-4083-bea8-a2ebbbf73671'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('005b345c-824e-4083-bea8-a2ebbbf73671', '3011BE1C-A871-4536-9855-2E58A28A206E', '338F9B03-8689-4BD0-8EF1-03B84B90E4D9', 'ArtifactID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Artifacts -> Committees: Comments (One To Many via ArtifactID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'b6e4654f-24d8-473a-9e05-1bb1fe9e6bde'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('b6e4654f-24d8-473a-9e05-1bb1fe9e6bde', '3011BE1C-A871-4536-9855-2E58A28A206E', '349618AD-3F1C-481C-8406-302817363510', 'ArtifactID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;


/* Create Entity Relationship: Committees: Comments -> Committees: Comments (One To Many via ParentCommentID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '82db46b9-7ede-4bbc-82d6-0b6e6e6c7260'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('82db46b9-7ede-4bbc-82d6-0b6e6e6c7260', '349618AD-3F1C-481C-8406-302817363510', '349618AD-3F1C-481C-8406-302817363510', 'ParentCommentID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Artifact Types -> Committees: Artifacts (One To Many via ArtifactTypeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '848553e6-6b3e-47ff-9308-13d2111cf2aa'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('848553e6-6b3e-47ff-9308-13d2111cf2aa', '8E6153B6-BC78-4AE8-B42D-34D7E2217555', '3011BE1C-A871-4536-9855-2E58A28A206E', 'ArtifactTypeID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Committees -> Committees: Action Items (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '71a9424a-6cd7-4814-bb68-43d9e6a724c0'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('71a9424a-6cd7-4814-bb68-43d9e6a724c0', 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', 'F4B63A74-6704-4CA9-97B5-D2EC745B0506', 'CommitteeID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Committees -> Committees: Committees (One To Many via ParentCommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'a1814cdd-a33d-46f0-bc84-3dc16ac85214'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('a1814cdd-a33d-46f0-bc84-3dc16ac85214', 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', 'ParentCommitteeID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Committees -> Committees: Meetings (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '4979ebb1-8163-450b-83f3-acf789a94de9'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('4979ebb1-8163-450b-83f3-acf789a94de9', 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', 'F05BE747-6F2A-472E-8800-8A10D416EAA1', 'CommitteeID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;


/* Create Entity Relationship: Committees: Committees -> Committees: Comments (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '86f9f43f-f480-477c-8c21-0efb13345dce'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('86f9f43f-f480-477c-8c21-0efb13345dce', 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', '349618AD-3F1C-481C-8406-302817363510', 'CommitteeID', 'One To Many', 1, 1, 4, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Committees -> Committees: Terms (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '88675dac-dc7a-4011-9965-c94eb7248df7'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('88675dac-dc7a-4011-9965-c94eb7248df7', 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', 'EAD3EF14-1891-4389-A0F3-1984BC8CC13F', 'CommitteeID', 'One To Many', 1, 1, 5, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Committees -> Committees: Artifacts (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'e98b5a24-1066-41b6-adcd-4889abc5d241'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('e98b5a24-1066-41b6-adcd-4889abc5d241', 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', '3011BE1C-A871-4536-9855-2E58A28A206E', 'CommitteeID', 'One To Many', 1, 1, 6, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Roles -> Committees: Memberships (One To Many via RoleID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'fb79dadd-2a52-4cff-a57e-ccbee27d3e88'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('fb79dadd-2a52-4cff-a57e-ccbee27d3e88', 'CF2605AB-3F2C-4D18-B663-60105BFC2BCC', '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', 'RoleID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ: Entities -> Committees: Artifact Types (One To Many via ExtendedEntityID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '93a66543-2bbe-405d-a253-da05497c1ebe'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('93a66543-2bbe-405d-a253-da05497c1ebe', 'E0238F34-2837-EF11-86D4-6045BDEE16E6', '8E6153B6-BC78-4AE8-B42D-34D7E2217555', 'ExtendedEntityID', 'One To Many', 1, 1, 66, GETUTCDATE(), GETUTCDATE())
   END;


/* Create Entity Relationship: MJ_BizApps_Common: Organizations -> Committees: Committees (One To Many via OrganizationID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'ee2b6ec5-7568-430a-ac89-ec86242a6009'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('ee2b6ec5-7568-430a-ac89-ec86242a6009', 'C70448F9-9792-41D7-A82C-784B66429D54', 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', 'OrganizationID', 'One To Many', 1, 1, 5, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Meetings -> Committees: Comments (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '98687ca9-56dc-4cb6-84cc-99d9735cfd89'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('98687ca9-56dc-4cb6-84cc-99d9735cfd89', 'F05BE747-6F2A-472E-8800-8A10D416EAA1', '349618AD-3F1C-481C-8406-302817363510', 'MeetingID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Meetings -> Committees: Action Items (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'd45f9a6c-b6be-420e-b44d-a6d328d4c8d1'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('d45f9a6c-b6be-420e-b44d-a6d328d4c8d1', 'F05BE747-6F2A-472E-8800-8A10D416EAA1', 'F4B63A74-6704-4CA9-97B5-D2EC745B0506', 'MeetingID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Meetings -> Committees: Attendances (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '66d47687-16e2-40f7-9fde-41284bcd6628'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('66d47687-16e2-40f7-9fde-41284bcd6628', 'F05BE747-6F2A-472E-8800-8A10D416EAA1', '9D005287-0D07-436B-B4D4-AAE31C42BFA7', 'MeetingID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Meetings -> Committees: Motions (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '27e74cfa-05a8-4b17-8c71-a4ed059b78ef'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('27e74cfa-05a8-4b17-8c71-a4ed059b78ef', 'F05BE747-6F2A-472E-8800-8A10D416EAA1', '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', 'MeetingID', 'One To Many', 1, 1, 4, GETUTCDATE(), GETUTCDATE())
   END;


/* Create Entity Relationship: Committees: Meetings -> Committees: Minutes (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'b14a7f54-1853-4461-9425-4fa422025212'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('b14a7f54-1853-4461-9425-4fa422025212', 'F05BE747-6F2A-472E-8800-8A10D416EAA1', '338F9B03-8689-4BD0-8EF1-03B84B90E4D9', 'MeetingID', 'One To Many', 1, 1, 5, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Meetings -> Committees: Minutes (One To Many via ApprovedByMeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '889ec1c6-6d80-4221-9310-5822dce5e3c6'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('889ec1c6-6d80-4221-9310-5822dce5e3c6', 'F05BE747-6F2A-472E-8800-8A10D416EAA1', '338F9B03-8689-4BD0-8EF1-03B84B90E4D9', 'ApprovedByMeetingID', 'One To Many', 1, 1, 6, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Meetings -> Committees: Agenda Items (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '88c833bb-b889-44b5-81b2-c830686f866c'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('88c833bb-b889-44b5-81b2-c830686f866c', 'F05BE747-6F2A-472E-8800-8A10D416EAA1', '5746F567-3A1B-4772-B8BA-D46D98A137DD', 'MeetingID', 'One To Many', 1, 1, 7, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Meetings -> Committees: Artifacts (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '12d73581-d8f4-4ebf-86b6-8ca9b1bd5dac'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('12d73581-d8f4-4ebf-86b6-8ca9b1bd5dac', 'F05BE747-6F2A-472E-8800-8A10D416EAA1', '3011BE1C-A871-4536-9855-2E58A28A206E', 'MeetingID', 'One To Many', 1, 1, 8, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ: Credentials -> Committees: Video Providers (One To Many via CredentialID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '237b54be-6c7d-46db-97ab-dd2365b1b7b8'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('237b54be-6c7d-46db-97ab-dd2365b1b7b8', '7E023DDF-82C6-4B0C-9650-8D35699B9FD0', 'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9', 'CredentialID', 'One To Many', 1, 1, 9, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Video Providers -> Committees: Meetings (One To Many via VideoProviderID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '4e08d0ee-8384-4b7a-b656-d428dbed52a4'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('4e08d0ee-8384-4b7a-b656-d428dbed52a4', 'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9', 'F05BE747-6F2A-472E-8800-8A10D416EAA1', 'VideoProviderID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;


/* Create Entity Relationship: Committees: Agenda Items -> Committees: Action Items (One To Many via AgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '6415207a-84c5-44b0-a02b-986eeb761fd3'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('6415207a-84c5-44b0-a02b-986eeb761fd3', '5746F567-3A1B-4772-B8BA-D46D98A137DD', 'F4B63A74-6704-4CA9-97B5-D2EC745B0506', 'AgendaItemID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Agenda Items -> Committees: Agenda Items (One To Many via ParentAgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '7fc5bfec-3262-4824-a764-25d9685c7f21'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('7fc5bfec-3262-4824-a764-25d9685c7f21', '5746F567-3A1B-4772-B8BA-D46D98A137DD', '5746F567-3A1B-4772-B8BA-D46D98A137DD', 'ParentAgendaItemID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Agenda Items -> Committees: Artifacts (One To Many via AgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '64c3f37b-7f30-454e-b1d7-81ad738c783a'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('64c3f37b-7f30-454e-b1d7-81ad738c783a', '5746F567-3A1B-4772-B8BA-D46D98A137DD', '3011BE1C-A871-4536-9855-2E58A28A206E', 'AgendaItemID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Agenda Items -> Committees: Motions (One To Many via AgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '2f24b7cc-4a67-4b13-bfa2-5fb0f4d88d3a'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('2f24b7cc-4a67-4b13-bfa2-5fb0f4d88d3a', '5746F567-3A1B-4772-B8BA-D46D98A137DD', '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', 'AgendaItemID', 'One To Many', 1, 1, 4, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Agenda Items -> Committees: Comments (One To Many via AgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'c34b59f8-9902-48ad-a46f-0c4791b0ea44'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('c34b59f8-9902-48ad-a46f-0c4791b0ea44', '5746F567-3A1B-4772-B8BA-D46D98A137DD', '349618AD-3F1C-481C-8406-302817363510', 'AgendaItemID', 'One To Many', 1, 1, 5, GETUTCDATE(), GETUTCDATE())
   END;


/* Create Entity Relationship: MJ_BizApps_Common: People -> Committees: Memberships (One To Many via PersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'c69cfc70-be20-4b7c-a7ab-9dc75e6f13a9'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('c69cfc70-be20-4b7c-a7ab-9dc75e6f13a9', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', 'PersonID', 'One To Many', 1, 1, 8, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Common: People -> Committees: Artifacts (One To Many via UploadedByPersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '57e6e733-079c-44c8-9020-257adf554c4d'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('57e6e733-079c-44c8-9020-257adf554c4d', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '3011BE1C-A871-4536-9855-2E58A28A206E', 'UploadedByPersonID', 'One To Many', 1, 1, 9, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Common: People -> Committees: Attendances (One To Many via PersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '4620bb75-f5ba-4578-aa0b-1c1ab85eedf9'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('4620bb75-f5ba-4578-aa0b-1c1ab85eedf9', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '9D005287-0D07-436B-B4D4-AAE31C42BFA7', 'PersonID', 'One To Many', 1, 1, 10, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Common: People -> Committees: Action Items (One To Many via AssignedToPersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '8fdd8322-8d3d-42ae-a67f-8b7da653ba47'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('8fdd8322-8d3d-42ae-a67f-8b7da653ba47', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', 'F4B63A74-6704-4CA9-97B5-D2EC745B0506', 'AssignedToPersonID', 'One To Many', 1, 1, 11, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Common: People -> Committees: Action Items (One To Many via AssignedByPersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'a731f4ca-1f64-418e-8009-d13ed80ad31b'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('a731f4ca-1f64-418e-8009-d13ed80ad31b', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', 'F4B63A74-6704-4CA9-97B5-D2EC745B0506', 'AssignedByPersonID', 'One To Many', 1, 1, 12, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Common: People -> Committees: Agenda Items (One To Many via PresenterPersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '024af5db-b59b-42a7-8f08-2545122aa202'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('024af5db-b59b-42a7-8f08-2545122aa202', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '5746F567-3A1B-4772-B8BA-D46D98A137DD', 'PresenterPersonID', 'One To Many', 1, 1, 13, GETUTCDATE(), GETUTCDATE())
   END;


/* Create Entity Relationship: MJ_BizApps_Common: People -> Committees: Comments (One To Many via PersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '8dbb7297-5398-4f95-b6be-dc08c80b2eaf'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('8dbb7297-5398-4f95-b6be-dc08c80b2eaf', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '349618AD-3F1C-481C-8406-302817363510', 'PersonID', 'One To Many', 1, 1, 14, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Memberships -> Committees: Motions (One To Many via MovedByMembershipID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '7094c123-6a07-414c-91bf-769242b31a81'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('7094c123-6a07-414c-91bf-769242b31a81', '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', 'MovedByMembershipID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Memberships -> Committees: Motions (One To Many via SecondedByMembershipID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '0a128cae-d0f4-439c-af22-0abc029cc9a4'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('0a128cae-d0f4-439c-af22-0abc029cc9a4', '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', 'SecondedByMembershipID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees: Memberships -> Committees: Votes (One To Many via MembershipID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '88ad3250-c666-4c29-ab7b-c979e9667fa3'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('88ad3250-c666-4c29-ab7b-c979e9667fa3', '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', '80299A27-B207-4D99-A46B-4E5B8A2B5E62', 'MembershipID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Tasks: Tasks -> Committees: Artifacts (One To Many via TaskID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '53b69f22-7e56-4106-8842-6e3fdb888c03'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('53b69f22-7e56-4106-8842-6e3fdb888c03', 'B348FFA2-B1A7-4AC2-B6FD-F4E0C0697466', '3011BE1C-A871-4536-9855-2E58A28A206E', 'TaskID', 'One To Many', 1, 1, 10, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ_BizApps_Tasks: Tasks -> Committees: Comments (One To Many via TaskID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '713a4d1b-7eb3-41f5-9a46-aaaa3c9914a9'
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('713a4d1b-7eb3-41f5-9a46-aaaa3c9914a9', 'B348FFA2-B1A7-4AC2-B6FD-F4E0C0697466', '349618AD-3F1C-481C-8406-302817363510', 'TaskID', 'One To Many', 1, 1, 11, GETUTCDATE(), GETUTCDATE())
   END;

/* SQL text to sync schema info from database schemas */
EXEC [${mjSchema}].[spUpdateSchemaInfoFromDatabase] @ExcludedSchemaNames='sys,staging,${mjSchema},${mjSchema}_BizAppsCommon,${mjSchema}_BizAppsTasks';

/* Index for Foreign Keys for ActionItem */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Action Items
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
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[ActionItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ActionItem_CommitteeID ON [${mjSchema}_Committees].[ActionItem] ([CommitteeID]);

-- Index for foreign key MeetingID in table ActionItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_ActionItem_MeetingID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[ActionItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ActionItem_MeetingID ON [${mjSchema}_Committees].[ActionItem] ([MeetingID]);

-- Index for foreign key AgendaItemID in table ActionItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_ActionItem_AgendaItemID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[ActionItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ActionItem_AgendaItemID ON [${mjSchema}_Committees].[ActionItem] ([AgendaItemID]);

-- Index for foreign key AssignedToPersonID in table ActionItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_ActionItem_AssignedToPersonID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[ActionItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ActionItem_AssignedToPersonID ON [${mjSchema}_Committees].[ActionItem] ([AssignedToPersonID]);

-- Index for foreign key AssignedByPersonID in table ActionItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_ActionItem_AssignedByPersonID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[ActionItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ActionItem_AssignedByPersonID ON [${mjSchema}_Committees].[ActionItem] ([AssignedByPersonID]);

/* SQL text to update entity field related entity name field map for entity field ID 0BEBC8B0-6113-48A9-8B7F-1FD3135E7ED5 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='0BEBC8B0-6113-48A9-8B7F-1FD3135E7ED5', @RelatedEntityNameFieldMap='Committee';

/* Index for Foreign Keys for AgendaItem */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Agenda Items
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
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[AgendaItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_AgendaItem_MeetingID ON [${mjSchema}_Committees].[AgendaItem] ([MeetingID]);

-- Index for foreign key ParentAgendaItemID in table AgendaItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_AgendaItem_ParentAgendaItemID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[AgendaItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_AgendaItem_ParentAgendaItemID ON [${mjSchema}_Committees].[AgendaItem] ([ParentAgendaItemID]);

-- Index for foreign key PresenterPersonID in table AgendaItem
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_AgendaItem_PresenterPersonID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[AgendaItem]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_AgendaItem_PresenterPersonID ON [${mjSchema}_Committees].[AgendaItem] ([PresenterPersonID]);

/* SQL text to update entity field related entity name field map for entity field ID AD709E40-2208-40B8-A61B-1E8B6871060C */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='AD709E40-2208-40B8-A61B-1E8B6871060C', @RelatedEntityNameFieldMap='PresenterPerson';

/* Index for Foreign Keys for ArtifactType */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifact Types
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
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[ArtifactType]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_ArtifactType_ExtendedEntityID ON [${mjSchema}_Committees].[ArtifactType] ([ExtendedEntityID]);

/* SQL text to update entity field related entity name field map for entity field ID C3731E81-33C0-4ECA-BB78-E83EA76D2A4B */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='C3731E81-33C0-4ECA-BB78-E83EA76D2A4B', @RelatedEntityNameFieldMap='ExtendedEntity';

/* Index for Foreign Keys for Artifact */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifacts
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
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Artifact]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_CommitteeID ON [${mjSchema}_Committees].[Artifact] ([CommitteeID]);

-- Index for foreign key MeetingID in table Artifact
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_MeetingID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Artifact]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_MeetingID ON [${mjSchema}_Committees].[Artifact] ([MeetingID]);

-- Index for foreign key AgendaItemID in table Artifact
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_AgendaItemID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Artifact]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_AgendaItemID ON [${mjSchema}_Committees].[Artifact] ([AgendaItemID]);

-- Index for foreign key TaskID in table Artifact
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_TaskID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Artifact]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_TaskID ON [${mjSchema}_Committees].[Artifact] ([TaskID]);

-- Index for foreign key ArtifactTypeID in table Artifact
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_ArtifactTypeID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Artifact]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_ArtifactTypeID ON [${mjSchema}_Committees].[Artifact] ([ArtifactTypeID]);

-- Index for foreign key UploadedByPersonID in table Artifact
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_UploadedByPersonID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Artifact]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_UploadedByPersonID ON [${mjSchema}_Committees].[Artifact] ([UploadedByPersonID]);

/* SQL text to update entity field related entity name field map for entity field ID B4ECAEEE-2530-44D0-A597-BD2CF2B93F3A */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='B4ECAEEE-2530-44D0-A597-BD2CF2B93F3A', @RelatedEntityNameFieldMap='Committee';

/* Index for Foreign Keys for Attendance */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Attendances
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
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Attendance]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Attendance_MeetingID ON [${mjSchema}_Committees].[Attendance] ([MeetingID]);

-- Index for foreign key PersonID in table Attendance
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Attendance_PersonID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Attendance]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Attendance_PersonID ON [${mjSchema}_Committees].[Attendance] ([PersonID]);

/* SQL text to update entity field related entity name field map for entity field ID 54D5634B-5E5B-416F-A43B-61A3E9C27216 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='54D5634B-5E5B-416F-A43B-61A3E9C27216', @RelatedEntityNameFieldMap='Person';

/* Root ID Function SQL for Committees: Agenda Items.ParentAgendaItemID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Agenda Items
-- Item: fnAgendaItemParentAgendaItemID_GetRootID
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- ROOT ID FUNCTION FOR: [AgendaItem].[ParentAgendaItemID]
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[fnAgendaItemParentAgendaItemID_GetRootID]', 'IF') IS NOT NULL
    DROP FUNCTION [${mjSchema}_Committees].[fnAgendaItemParentAgendaItemID_GetRootID];
GO

CREATE FUNCTION [${mjSchema}_Committees].[fnAgendaItemParentAgendaItemID_GetRootID]
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
            [${mjSchema}_Committees].[AgendaItem]
        WHERE
            [ID] = COALESCE(@ParentID, @RecordID)

        UNION ALL

        SELECT
            c.[ID],
            c.[ParentAgendaItemID],
            c.[ID] AS [RootParentID],
            p.[Depth] + 1 AS [Depth]
        FROM
            [${mjSchema}_Committees].[AgendaItem] c
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

/* Base View SQL for Committees: Agenda Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Agenda Items
-- Item: vwAgendaItems
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Agenda Items
-----               SCHEMA:      ${mjSchema}_Committees
-----               BASE TABLE:  AgendaItem
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[vwAgendaItems]', 'V') IS NOT NULL
    DROP VIEW [${mjSchema}_Committees].[vwAgendaItems];
GO

CREATE VIEW [${mjSchema}_Committees].[vwAgendaItems]
AS
SELECT
    a.*,
    mjBizAppsCommonPerson_PresenterPersonID.[DisplayName] AS [PresenterPerson],
    root_ParentAgendaItemID.RootID AS [RootParentAgendaItemID]
FROM
    [${mjSchema}_Committees].[AgendaItem] AS a
LEFT OUTER JOIN
    [${mjSchema}_BizAppsCommon].[Person] AS mjBizAppsCommonPerson_PresenterPersonID
  ON
    [a].[PresenterPersonID] = mjBizAppsCommonPerson_PresenterPersonID.[ID]
OUTER APPLY
    [${mjSchema}_Committees].[fnAgendaItemParentAgendaItemID_GetRootID]([a].[ID], [a].[ParentAgendaItemID]) AS root_ParentAgendaItemID
GO
GRANT SELECT ON [${mjSchema}_Committees].[vwAgendaItems] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Agenda Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Agenda Items
-- Item: Permissions for vwAgendaItems
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${mjSchema}_Committees].[vwAgendaItems] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Agenda Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Agenda Items
-- Item: spCreateAgendaItem
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR AgendaItem
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spCreateAgendaItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spCreateAgendaItem];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spCreateAgendaItem]
    @ID uniqueidentifier = NULL,
    @MeetingID uniqueidentifier,
    @ParentAgendaItemID_Clear bit = 0,
    @ParentAgendaItemID uniqueidentifier = NULL,
    @Sequence int,
    @Title nvarchar(255),
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @PresenterPersonID_Clear bit = 0,
    @PresenterPersonID uniqueidentifier = NULL,
    @DurationMinutes_Clear bit = 0,
    @DurationMinutes int = NULL,
    @ItemType nvarchar(50) = NULL,
    @RelatedDocumentURL_Clear bit = 0,
    @RelatedDocumentURL nvarchar(1000) = NULL,
    @Status nvarchar(50) = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${mjSchema}_Committees].[AgendaItem]
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
                CASE WHEN @ParentAgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@ParentAgendaItemID, NULL) END,
                @Sequence,
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                CASE WHEN @PresenterPersonID_Clear = 1 THEN NULL ELSE ISNULL(@PresenterPersonID, NULL) END,
                CASE WHEN @DurationMinutes_Clear = 1 THEN NULL ELSE ISNULL(@DurationMinutes, NULL) END,
                ISNULL(@ItemType, 'Discussion'),
                CASE WHEN @RelatedDocumentURL_Clear = 1 THEN NULL ELSE ISNULL(@RelatedDocumentURL, NULL) END,
                ISNULL(@Status, 'Pending'),
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${mjSchema}_Committees].[AgendaItem]
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
                CASE WHEN @ParentAgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@ParentAgendaItemID, NULL) END,
                @Sequence,
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                CASE WHEN @PresenterPersonID_Clear = 1 THEN NULL ELSE ISNULL(@PresenterPersonID, NULL) END,
                CASE WHEN @DurationMinutes_Clear = 1 THEN NULL ELSE ISNULL(@DurationMinutes, NULL) END,
                ISNULL(@ItemType, 'Discussion'),
                CASE WHEN @RelatedDocumentURL_Clear = 1 THEN NULL ELSE ISNULL(@RelatedDocumentURL, NULL) END,
                ISNULL(@Status, 'Pending'),
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${mjSchema}_Committees].[vwAgendaItems] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateAgendaItem] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Agenda Items */

GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateAgendaItem] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Agenda Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Agenda Items
-- Item: spUpdateAgendaItem
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR AgendaItem
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spUpdateAgendaItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spUpdateAgendaItem];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spUpdateAgendaItem]
    @ID uniqueidentifier,
    @MeetingID uniqueidentifier = NULL,
    @ParentAgendaItemID_Clear bit = 0,
    @ParentAgendaItemID uniqueidentifier = NULL,
    @Sequence int = NULL,
    @Title nvarchar(255) = NULL,
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @PresenterPersonID_Clear bit = 0,
    @PresenterPersonID uniqueidentifier = NULL,
    @DurationMinutes_Clear bit = 0,
    @DurationMinutes int = NULL,
    @ItemType nvarchar(50) = NULL,
    @RelatedDocumentURL_Clear bit = 0,
    @RelatedDocumentURL nvarchar(1000) = NULL,
    @Status nvarchar(50) = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[AgendaItem]
    SET
        [MeetingID] = ISNULL(@MeetingID, [MeetingID]),
        [ParentAgendaItemID] = CASE WHEN @ParentAgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@ParentAgendaItemID, [ParentAgendaItemID]) END,
        [Sequence] = ISNULL(@Sequence, [Sequence]),
        [Title] = ISNULL(@Title, [Title]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [PresenterPersonID] = CASE WHEN @PresenterPersonID_Clear = 1 THEN NULL ELSE ISNULL(@PresenterPersonID, [PresenterPersonID]) END,
        [DurationMinutes] = CASE WHEN @DurationMinutes_Clear = 1 THEN NULL ELSE ISNULL(@DurationMinutes, [DurationMinutes]) END,
        [ItemType] = ISNULL(@ItemType, [ItemType]),
        [RelatedDocumentURL] = CASE WHEN @RelatedDocumentURL_Clear = 1 THEN NULL ELSE ISNULL(@RelatedDocumentURL, [RelatedDocumentURL]) END,
        [Status] = ISNULL(@Status, [Status]),
        [Notes] = CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, [Notes]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${mjSchema}_Committees].[vwAgendaItems] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${mjSchema}_Committees].[vwAgendaItems]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateAgendaItem] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the AgendaItem table
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[trgUpdateAgendaItem]', 'TR') IS NOT NULL
    DROP TRIGGER [${mjSchema}_Committees].[trgUpdateAgendaItem];
GO
CREATE TRIGGER [${mjSchema}_Committees].trgUpdateAgendaItem
ON [${mjSchema}_Committees].[AgendaItem]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[AgendaItem]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${mjSchema}_Committees].[AgendaItem] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Agenda Items */

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateAgendaItem] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Agenda Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Agenda Items
-- Item: spDeleteAgendaItem
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR AgendaItem
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spDeleteAgendaItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spDeleteAgendaItem];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spDeleteAgendaItem]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${mjSchema}_Committees].[AgendaItem]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteAgendaItem] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Agenda Items */

GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteAgendaItem] TO [cdp_Developer], [cdp_Integration];

/* SQL text to update entity field related entity name field map for entity field ID 0AF90B52-D892-4E9E-92BA-6976F9E9CED1 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='0AF90B52-D892-4E9E-92BA-6976F9E9CED1', @RelatedEntityNameFieldMap='AssignedToPerson';

/* Base View SQL for Committees: Artifact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifact Types
-- Item: vwArtifactTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Artifact Types
-----               SCHEMA:      ${mjSchema}_Committees
-----               BASE TABLE:  ArtifactType
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[vwArtifactTypes]', 'V') IS NOT NULL
    DROP VIEW [${mjSchema}_Committees].[vwArtifactTypes];
GO

CREATE VIEW [${mjSchema}_Committees].[vwArtifactTypes]
AS
SELECT
    a.*,
    MJEntity_ExtendedEntityID.[Name] AS [ExtendedEntity]
FROM
    [${mjSchema}_Committees].[ArtifactType] AS a
LEFT OUTER JOIN
    [${mjSchema}].[Entity] AS MJEntity_ExtendedEntityID
  ON
    [a].[ExtendedEntityID] = MJEntity_ExtendedEntityID.[ID]
GO
GRANT SELECT ON [${mjSchema}_Committees].[vwArtifactTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Artifact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifact Types
-- Item: Permissions for vwArtifactTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${mjSchema}_Committees].[vwArtifactTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Artifact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifact Types
-- Item: spCreateArtifactType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR ArtifactType
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spCreateArtifactType]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spCreateArtifactType];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spCreateArtifactType]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(100),
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @ExtendedEntityID_Clear bit = 0,
    @ExtendedEntityID uniqueidentifier = NULL,
    @IconClass_Clear bit = 0,
    @IconClass nvarchar(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${mjSchema}_Committees].[ArtifactType]
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
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                CASE WHEN @ExtendedEntityID_Clear = 1 THEN NULL ELSE ISNULL(@ExtendedEntityID, NULL) END,
                CASE WHEN @IconClass_Clear = 1 THEN NULL ELSE ISNULL(@IconClass, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${mjSchema}_Committees].[ArtifactType]
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
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                CASE WHEN @ExtendedEntityID_Clear = 1 THEN NULL ELSE ISNULL(@ExtendedEntityID, NULL) END,
                CASE WHEN @IconClass_Clear = 1 THEN NULL ELSE ISNULL(@IconClass, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${mjSchema}_Committees].[vwArtifactTypes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateArtifactType] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Artifact Types */

GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateArtifactType] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Artifact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifact Types
-- Item: spUpdateArtifactType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR ArtifactType
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spUpdateArtifactType]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spUpdateArtifactType];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spUpdateArtifactType]
    @ID uniqueidentifier,
    @Name nvarchar(100) = NULL,
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @ExtendedEntityID_Clear bit = 0,
    @ExtendedEntityID uniqueidentifier = NULL,
    @IconClass_Clear bit = 0,
    @IconClass nvarchar(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[ArtifactType]
    SET
        [Name] = ISNULL(@Name, [Name]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [ExtendedEntityID] = CASE WHEN @ExtendedEntityID_Clear = 1 THEN NULL ELSE ISNULL(@ExtendedEntityID, [ExtendedEntityID]) END,
        [IconClass] = CASE WHEN @IconClass_Clear = 1 THEN NULL ELSE ISNULL(@IconClass, [IconClass]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${mjSchema}_Committees].[vwArtifactTypes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${mjSchema}_Committees].[vwArtifactTypes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateArtifactType] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the ArtifactType table
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[trgUpdateArtifactType]', 'TR') IS NOT NULL
    DROP TRIGGER [${mjSchema}_Committees].[trgUpdateArtifactType];
GO
CREATE TRIGGER [${mjSchema}_Committees].trgUpdateArtifactType
ON [${mjSchema}_Committees].[ArtifactType]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[ArtifactType]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${mjSchema}_Committees].[ArtifactType] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Artifact Types */

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateArtifactType] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Artifact Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifact Types
-- Item: spDeleteArtifactType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR ArtifactType
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spDeleteArtifactType]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spDeleteArtifactType];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spDeleteArtifactType]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${mjSchema}_Committees].[ArtifactType]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteArtifactType] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Artifact Types */

GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteArtifactType] TO [cdp_Developer], [cdp_Integration];

/* SQL text to update entity field related entity name field map for entity field ID CEEFEDF4-D8A7-419C-8239-2A0BC5CFC8CE */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='CEEFEDF4-D8A7-419C-8239-2A0BC5CFC8CE', @RelatedEntityNameFieldMap='Task';

/* Base View SQL for Committees: Attendances */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Attendances
-- Item: vwAttendances
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Attendances
-----               SCHEMA:      ${mjSchema}_Committees
-----               BASE TABLE:  Attendance
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[vwAttendances]', 'V') IS NOT NULL
    DROP VIEW [${mjSchema}_Committees].[vwAttendances];
GO

CREATE VIEW [${mjSchema}_Committees].[vwAttendances]
AS
SELECT
    a.*,
    mjBizAppsCommonPerson_PersonID.[DisplayName] AS [Person]
FROM
    [${mjSchema}_Committees].[Attendance] AS a
INNER JOIN
    [${mjSchema}_BizAppsCommon].[Person] AS mjBizAppsCommonPerson_PersonID
  ON
    [a].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
GO
GRANT SELECT ON [${mjSchema}_Committees].[vwAttendances] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Attendances */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Attendances
-- Item: Permissions for vwAttendances
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${mjSchema}_Committees].[vwAttendances] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Attendances */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Attendances
-- Item: spCreateAttendance
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Attendance
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spCreateAttendance]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spCreateAttendance];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spCreateAttendance]
    @ID uniqueidentifier = NULL,
    @MeetingID uniqueidentifier,
    @PersonID uniqueidentifier,
    @AttendanceStatus nvarchar(50) = NULL,
    @JoinedAt_Clear bit = 0,
    @JoinedAt datetimeoffset = NULL,
    @LeftAt_Clear bit = 0,
    @LeftAt datetimeoffset = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${mjSchema}_Committees].[Attendance]
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
                CASE WHEN @JoinedAt_Clear = 1 THEN NULL ELSE ISNULL(@JoinedAt, NULL) END,
                CASE WHEN @LeftAt_Clear = 1 THEN NULL ELSE ISNULL(@LeftAt, NULL) END,
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${mjSchema}_Committees].[Attendance]
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
                CASE WHEN @JoinedAt_Clear = 1 THEN NULL ELSE ISNULL(@JoinedAt, NULL) END,
                CASE WHEN @LeftAt_Clear = 1 THEN NULL ELSE ISNULL(@LeftAt, NULL) END,
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${mjSchema}_Committees].[vwAttendances] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateAttendance] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Attendances */

GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateAttendance] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Attendances */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Attendances
-- Item: spUpdateAttendance
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Attendance
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spUpdateAttendance]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spUpdateAttendance];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spUpdateAttendance]
    @ID uniqueidentifier,
    @MeetingID uniqueidentifier = NULL,
    @PersonID uniqueidentifier = NULL,
    @AttendanceStatus nvarchar(50) = NULL,
    @JoinedAt_Clear bit = 0,
    @JoinedAt datetimeoffset = NULL,
    @LeftAt_Clear bit = 0,
    @LeftAt datetimeoffset = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Attendance]
    SET
        [MeetingID] = ISNULL(@MeetingID, [MeetingID]),
        [PersonID] = ISNULL(@PersonID, [PersonID]),
        [AttendanceStatus] = ISNULL(@AttendanceStatus, [AttendanceStatus]),
        [JoinedAt] = CASE WHEN @JoinedAt_Clear = 1 THEN NULL ELSE ISNULL(@JoinedAt, [JoinedAt]) END,
        [LeftAt] = CASE WHEN @LeftAt_Clear = 1 THEN NULL ELSE ISNULL(@LeftAt, [LeftAt]) END,
        [Notes] = CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, [Notes]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${mjSchema}_Committees].[vwAttendances] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${mjSchema}_Committees].[vwAttendances]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateAttendance] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Attendance table
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[trgUpdateAttendance]', 'TR') IS NOT NULL
    DROP TRIGGER [${mjSchema}_Committees].[trgUpdateAttendance];
GO
CREATE TRIGGER [${mjSchema}_Committees].trgUpdateAttendance
ON [${mjSchema}_Committees].[Attendance]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Attendance]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${mjSchema}_Committees].[Attendance] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Attendances */

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateAttendance] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Attendances */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Attendances
-- Item: spDeleteAttendance
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Attendance
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spDeleteAttendance]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spDeleteAttendance];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spDeleteAttendance]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${mjSchema}_Committees].[Attendance]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteAttendance] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Attendances */

GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteAttendance] TO [cdp_Developer], [cdp_Integration];

/* SQL text to update entity field related entity name field map for entity field ID FFFE3501-808D-4421-9157-250E2F700E75 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='FFFE3501-808D-4421-9157-250E2F700E75', @RelatedEntityNameFieldMap='AssignedByPerson';

/* SQL text to update entity field related entity name field map for entity field ID F47E91D5-DD83-419A-A601-566BF750699D */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='F47E91D5-DD83-419A-A601-566BF750699D', @RelatedEntityNameFieldMap='ArtifactType';

/* Base View SQL for Committees: Action Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Action Items
-- Item: vwActionItems
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Action Items
-----               SCHEMA:      ${mjSchema}_Committees
-----               BASE TABLE:  ActionItem
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[vwActionItems]', 'V') IS NOT NULL
    DROP VIEW [${mjSchema}_Committees].[vwActionItems];
GO

CREATE VIEW [${mjSchema}_Committees].[vwActionItems]
AS
SELECT
    a.*,
    mjCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjBizAppsCommonPerson_AssignedToPersonID.[DisplayName] AS [AssignedToPerson],
    mjBizAppsCommonPerson_AssignedByPersonID.[DisplayName] AS [AssignedByPerson]
FROM
    [${mjSchema}_Committees].[ActionItem] AS a
INNER JOIN
    [${mjSchema}_Committees].[Committee] AS mjCommitteesCommittee_CommitteeID
  ON
    [a].[CommitteeID] = mjCommitteesCommittee_CommitteeID.[ID]
INNER JOIN
    [${mjSchema}_BizAppsCommon].[Person] AS mjBizAppsCommonPerson_AssignedToPersonID
  ON
    [a].[AssignedToPersonID] = mjBizAppsCommonPerson_AssignedToPersonID.[ID]
LEFT OUTER JOIN
    [${mjSchema}_BizAppsCommon].[Person] AS mjBizAppsCommonPerson_AssignedByPersonID
  ON
    [a].[AssignedByPersonID] = mjBizAppsCommonPerson_AssignedByPersonID.[ID]
GO
GRANT SELECT ON [${mjSchema}_Committees].[vwActionItems] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Action Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Action Items
-- Item: Permissions for vwActionItems
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${mjSchema}_Committees].[vwActionItems] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Action Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Action Items
-- Item: spCreateActionItem
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR ActionItem
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spCreateActionItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spCreateActionItem];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spCreateActionItem]
    @ID uniqueidentifier = NULL,
    @CommitteeID uniqueidentifier,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @Title nvarchar(255),
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @AssignedToPersonID uniqueidentifier,
    @AssignedByPersonID_Clear bit = 0,
    @AssignedByPersonID uniqueidentifier = NULL,
    @DueDate_Clear bit = 0,
    @DueDate date = NULL,
    @Priority nvarchar(20) = NULL,
    @Status nvarchar(50) = NULL,
    @CompletedAt_Clear bit = 0,
    @CompletedAt datetimeoffset = NULL,
    @CompletionNotes_Clear bit = 0,
    @CompletionNotes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${mjSchema}_Committees].[ActionItem]
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
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @AssignedToPersonID,
                CASE WHEN @AssignedByPersonID_Clear = 1 THEN NULL ELSE ISNULL(@AssignedByPersonID, NULL) END,
                CASE WHEN @DueDate_Clear = 1 THEN NULL ELSE ISNULL(@DueDate, NULL) END,
                ISNULL(@Priority, 'Medium'),
                ISNULL(@Status, 'Open'),
                CASE WHEN @CompletedAt_Clear = 1 THEN NULL ELSE ISNULL(@CompletedAt, NULL) END,
                CASE WHEN @CompletionNotes_Clear = 1 THEN NULL ELSE ISNULL(@CompletionNotes, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${mjSchema}_Committees].[ActionItem]
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
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @AssignedToPersonID,
                CASE WHEN @AssignedByPersonID_Clear = 1 THEN NULL ELSE ISNULL(@AssignedByPersonID, NULL) END,
                CASE WHEN @DueDate_Clear = 1 THEN NULL ELSE ISNULL(@DueDate, NULL) END,
                ISNULL(@Priority, 'Medium'),
                ISNULL(@Status, 'Open'),
                CASE WHEN @CompletedAt_Clear = 1 THEN NULL ELSE ISNULL(@CompletedAt, NULL) END,
                CASE WHEN @CompletionNotes_Clear = 1 THEN NULL ELSE ISNULL(@CompletionNotes, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${mjSchema}_Committees].[vwActionItems] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateActionItem] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Action Items */

GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateActionItem] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Action Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Action Items
-- Item: spUpdateActionItem
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR ActionItem
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spUpdateActionItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spUpdateActionItem];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spUpdateActionItem]
    @ID uniqueidentifier,
    @CommitteeID uniqueidentifier = NULL,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @Title nvarchar(255) = NULL,
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @AssignedToPersonID uniqueidentifier = NULL,
    @AssignedByPersonID_Clear bit = 0,
    @AssignedByPersonID uniqueidentifier = NULL,
    @DueDate_Clear bit = 0,
    @DueDate date = NULL,
    @Priority nvarchar(20) = NULL,
    @Status nvarchar(50) = NULL,
    @CompletedAt_Clear bit = 0,
    @CompletedAt datetimeoffset = NULL,
    @CompletionNotes_Clear bit = 0,
    @CompletionNotes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[ActionItem]
    SET
        [CommitteeID] = ISNULL(@CommitteeID, [CommitteeID]),
        [MeetingID] = CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, [MeetingID]) END,
        [AgendaItemID] = CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, [AgendaItemID]) END,
        [Title] = ISNULL(@Title, [Title]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [AssignedToPersonID] = ISNULL(@AssignedToPersonID, [AssignedToPersonID]),
        [AssignedByPersonID] = CASE WHEN @AssignedByPersonID_Clear = 1 THEN NULL ELSE ISNULL(@AssignedByPersonID, [AssignedByPersonID]) END,
        [DueDate] = CASE WHEN @DueDate_Clear = 1 THEN NULL ELSE ISNULL(@DueDate, [DueDate]) END,
        [Priority] = ISNULL(@Priority, [Priority]),
        [Status] = ISNULL(@Status, [Status]),
        [CompletedAt] = CASE WHEN @CompletedAt_Clear = 1 THEN NULL ELSE ISNULL(@CompletedAt, [CompletedAt]) END,
        [CompletionNotes] = CASE WHEN @CompletionNotes_Clear = 1 THEN NULL ELSE ISNULL(@CompletionNotes, [CompletionNotes]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${mjSchema}_Committees].[vwActionItems] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${mjSchema}_Committees].[vwActionItems]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateActionItem] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the ActionItem table
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[trgUpdateActionItem]', 'TR') IS NOT NULL
    DROP TRIGGER [${mjSchema}_Committees].[trgUpdateActionItem];
GO
CREATE TRIGGER [${mjSchema}_Committees].trgUpdateActionItem
ON [${mjSchema}_Committees].[ActionItem]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[ActionItem]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${mjSchema}_Committees].[ActionItem] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Action Items */

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateActionItem] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Action Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Action Items
-- Item: spDeleteActionItem
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR ActionItem
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spDeleteActionItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spDeleteActionItem];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spDeleteActionItem]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${mjSchema}_Committees].[ActionItem]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteActionItem] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Action Items */

GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteActionItem] TO [cdp_Developer], [cdp_Integration];

/* SQL text to update entity field related entity name field map for entity field ID 2BA603FF-1546-4673-98D3-CB116849C094 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='2BA603FF-1546-4673-98D3-CB116849C094', @RelatedEntityNameFieldMap='UploadedByPerson';

/* Base View SQL for Committees: Artifacts */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifacts
-- Item: vwArtifacts
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Artifacts
-----               SCHEMA:      ${mjSchema}_Committees
-----               BASE TABLE:  Artifact
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[vwArtifacts]', 'V') IS NOT NULL
    DROP VIEW [${mjSchema}_Committees].[vwArtifacts];
GO

CREATE VIEW [${mjSchema}_Committees].[vwArtifacts]
AS
SELECT
    a.*,
    mjCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjBizAppsTasksTask_TaskID.[Name] AS [Task],
    mjCommitteesArtifactType_ArtifactTypeID.[Name] AS [ArtifactType],
    mjBizAppsCommonPerson_UploadedByPersonID.[DisplayName] AS [UploadedByPerson]
FROM
    [${mjSchema}_Committees].[Artifact] AS a
LEFT OUTER JOIN
    [${mjSchema}_Committees].[Committee] AS mjCommitteesCommittee_CommitteeID
  ON
    [a].[CommitteeID] = mjCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [${mjSchema}_BizAppsTasks].[Task] AS mjBizAppsTasksTask_TaskID
  ON
    [a].[TaskID] = mjBizAppsTasksTask_TaskID.[ID]
INNER JOIN
    [${mjSchema}_Committees].[ArtifactType] AS mjCommitteesArtifactType_ArtifactTypeID
  ON
    [a].[ArtifactTypeID] = mjCommitteesArtifactType_ArtifactTypeID.[ID]
LEFT OUTER JOIN
    [${mjSchema}_BizAppsCommon].[Person] AS mjBizAppsCommonPerson_UploadedByPersonID
  ON
    [a].[UploadedByPersonID] = mjBizAppsCommonPerson_UploadedByPersonID.[ID]
GO
GRANT SELECT ON [${mjSchema}_Committees].[vwArtifacts] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Artifacts */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifacts
-- Item: Permissions for vwArtifacts
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${mjSchema}_Committees].[vwArtifacts] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Artifacts */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifacts
-- Item: spCreateArtifact
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Artifact
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spCreateArtifact]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spCreateArtifact];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spCreateArtifact]
    @ID uniqueidentifier = NULL,
    @CommitteeID_Clear bit = 0,
    @CommitteeID uniqueidentifier = NULL,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @TaskID_Clear bit = 0,
    @TaskID uniqueidentifier = NULL,
    @Title nvarchar(255),
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @ArtifactTypeID uniqueidentifier,
    @Provider nvarchar(50),
    @ExternalID_Clear bit = 0,
    @ExternalID nvarchar(500) = NULL,
    @URL nvarchar(2000),
    @MimeType_Clear bit = 0,
    @MimeType nvarchar(100) = NULL,
    @FileSize_Clear bit = 0,
    @FileSize bigint = NULL,
    @UploadedByPersonID_Clear bit = 0,
    @UploadedByPersonID uniqueidentifier = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${mjSchema}_Committees].[Artifact]
            (
                [ID],
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [TaskID],
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
                CASE WHEN @CommitteeID_Clear = 1 THEN NULL ELSE ISNULL(@CommitteeID, NULL) END,
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                CASE WHEN @TaskID_Clear = 1 THEN NULL ELSE ISNULL(@TaskID, NULL) END,
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @ArtifactTypeID,
                @Provider,
                CASE WHEN @ExternalID_Clear = 1 THEN NULL ELSE ISNULL(@ExternalID, NULL) END,
                @URL,
                CASE WHEN @MimeType_Clear = 1 THEN NULL ELSE ISNULL(@MimeType, NULL) END,
                CASE WHEN @FileSize_Clear = 1 THEN NULL ELSE ISNULL(@FileSize, NULL) END,
                CASE WHEN @UploadedByPersonID_Clear = 1 THEN NULL ELSE ISNULL(@UploadedByPersonID, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${mjSchema}_Committees].[Artifact]
            (
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [TaskID],
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
                CASE WHEN @CommitteeID_Clear = 1 THEN NULL ELSE ISNULL(@CommitteeID, NULL) END,
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                CASE WHEN @TaskID_Clear = 1 THEN NULL ELSE ISNULL(@TaskID, NULL) END,
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @ArtifactTypeID,
                @Provider,
                CASE WHEN @ExternalID_Clear = 1 THEN NULL ELSE ISNULL(@ExternalID, NULL) END,
                @URL,
                CASE WHEN @MimeType_Clear = 1 THEN NULL ELSE ISNULL(@MimeType, NULL) END,
                CASE WHEN @FileSize_Clear = 1 THEN NULL ELSE ISNULL(@FileSize, NULL) END,
                CASE WHEN @UploadedByPersonID_Clear = 1 THEN NULL ELSE ISNULL(@UploadedByPersonID, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${mjSchema}_Committees].[vwArtifacts] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateArtifact] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Artifacts */

GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateArtifact] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Artifacts */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifacts
-- Item: spUpdateArtifact
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Artifact
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spUpdateArtifact]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spUpdateArtifact];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spUpdateArtifact]
    @ID uniqueidentifier,
    @CommitteeID_Clear bit = 0,
    @CommitteeID uniqueidentifier = NULL,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @TaskID_Clear bit = 0,
    @TaskID uniqueidentifier = NULL,
    @Title nvarchar(255) = NULL,
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @ArtifactTypeID uniqueidentifier = NULL,
    @Provider nvarchar(50) = NULL,
    @ExternalID_Clear bit = 0,
    @ExternalID nvarchar(500) = NULL,
    @URL nvarchar(2000) = NULL,
    @MimeType_Clear bit = 0,
    @MimeType nvarchar(100) = NULL,
    @FileSize_Clear bit = 0,
    @FileSize bigint = NULL,
    @UploadedByPersonID_Clear bit = 0,
    @UploadedByPersonID uniqueidentifier = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Artifact]
    SET
        [CommitteeID] = CASE WHEN @CommitteeID_Clear = 1 THEN NULL ELSE ISNULL(@CommitteeID, [CommitteeID]) END,
        [MeetingID] = CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, [MeetingID]) END,
        [AgendaItemID] = CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, [AgendaItemID]) END,
        [TaskID] = CASE WHEN @TaskID_Clear = 1 THEN NULL ELSE ISNULL(@TaskID, [TaskID]) END,
        [Title] = ISNULL(@Title, [Title]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [ArtifactTypeID] = ISNULL(@ArtifactTypeID, [ArtifactTypeID]),
        [Provider] = ISNULL(@Provider, [Provider]),
        [ExternalID] = CASE WHEN @ExternalID_Clear = 1 THEN NULL ELSE ISNULL(@ExternalID, [ExternalID]) END,
        [URL] = ISNULL(@URL, [URL]),
        [MimeType] = CASE WHEN @MimeType_Clear = 1 THEN NULL ELSE ISNULL(@MimeType, [MimeType]) END,
        [FileSize] = CASE WHEN @FileSize_Clear = 1 THEN NULL ELSE ISNULL(@FileSize, [FileSize]) END,
        [UploadedByPersonID] = CASE WHEN @UploadedByPersonID_Clear = 1 THEN NULL ELSE ISNULL(@UploadedByPersonID, [UploadedByPersonID]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${mjSchema}_Committees].[vwArtifacts] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${mjSchema}_Committees].[vwArtifacts]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateArtifact] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Artifact table
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[trgUpdateArtifact]', 'TR') IS NOT NULL
    DROP TRIGGER [${mjSchema}_Committees].[trgUpdateArtifact];
GO
CREATE TRIGGER [${mjSchema}_Committees].trgUpdateArtifact
ON [${mjSchema}_Committees].[Artifact]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Artifact]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${mjSchema}_Committees].[Artifact] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Artifacts */

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateArtifact] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Artifacts */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifacts
-- Item: spDeleteArtifact
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Artifact
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spDeleteArtifact]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spDeleteArtifact];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spDeleteArtifact]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${mjSchema}_Committees].[Artifact]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteArtifact] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Artifacts */

GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteArtifact] TO [cdp_Developer], [cdp_Integration];

/* Index for Foreign Keys for Comment */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
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
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_CommitteeID ON [${mjSchema}_Committees].[Comment] ([CommitteeID]);

-- Index for foreign key MeetingID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_MeetingID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_MeetingID ON [${mjSchema}_Committees].[Comment] ([MeetingID]);

-- Index for foreign key AgendaItemID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_AgendaItemID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_AgendaItemID ON [${mjSchema}_Committees].[Comment] ([AgendaItemID]);

-- Index for foreign key TaskID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_TaskID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_TaskID ON [${mjSchema}_Committees].[Comment] ([TaskID]);

-- Index for foreign key ArtifactID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_ArtifactID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_ArtifactID ON [${mjSchema}_Committees].[Comment] ([ArtifactID]);

-- Index for foreign key ParentCommentID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_ParentCommentID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_ParentCommentID ON [${mjSchema}_Committees].[Comment] ([ParentCommentID]);

-- Index for foreign key PersonID in table Comment
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Comment_PersonID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Comment]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Comment_PersonID ON [${mjSchema}_Committees].[Comment] ([PersonID]);

/* SQL text to update entity field related entity name field map for entity field ID 6C01F98D-C2AF-49A4-83CB-AF9C849C96B9 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='6C01F98D-C2AF-49A4-83CB-AF9C849C96B9', @RelatedEntityNameFieldMap='Committee';

/* Index for Foreign Keys for Committee */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Committees
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
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Committee]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Committee_TypeID ON [${mjSchema}_Committees].[Committee] ([TypeID]);

-- Index for foreign key ParentCommitteeID in table Committee
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Committee_ParentCommitteeID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Committee]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Committee_ParentCommitteeID ON [${mjSchema}_Committees].[Committee] ([ParentCommitteeID]);

-- Index for foreign key OrganizationID in table Committee
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Committee_OrganizationID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Committee]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Committee_OrganizationID ON [${mjSchema}_Committees].[Committee] ([OrganizationID]);

/* SQL text to update entity field related entity name field map for entity field ID CAA9B2BC-CBB1-4DD3-9406-29F4C57A2776 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='CAA9B2BC-CBB1-4DD3-9406-29F4C57A2776', @RelatedEntityNameFieldMap='Type';

/* Index for Foreign Keys for Meeting */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
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
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Meeting]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Meeting_CommitteeID ON [${mjSchema}_Committees].[Meeting] ([CommitteeID]);

-- Index for foreign key VideoProviderID in table Meeting
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Meeting_VideoProviderID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Meeting]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Meeting_VideoProviderID ON [${mjSchema}_Committees].[Meeting] ([VideoProviderID]);

/* SQL text to update entity field related entity name field map for entity field ID 22A63060-2EF9-4112-9D48-E5CEB876FBD2 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='22A63060-2EF9-4112-9D48-E5CEB876FBD2', @RelatedEntityNameFieldMap='Committee';

/* Index for Foreign Keys for Membership */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Memberships
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
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Membership]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Membership_PersonID ON [${mjSchema}_Committees].[Membership] ([PersonID]);

-- Index for foreign key RoleID in table Membership
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Membership_RoleID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Membership]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Membership_RoleID ON [${mjSchema}_Committees].[Membership] ([RoleID]);

-- Index for foreign key TermID in table Membership
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Membership_TermID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Membership]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Membership_TermID ON [${mjSchema}_Committees].[Membership] ([TermID]);

/* SQL text to update entity field related entity name field map for entity field ID 51F7B196-9536-4012-83AA-E5D8C11EBB45 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='51F7B196-9536-4012-83AA-E5D8C11EBB45', @RelatedEntityNameFieldMap='Person';

/* Index for Foreign Keys for Minute */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Minutes
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key ArtifactID in table Minute
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Minute_ArtifactID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Minute]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Minute_ArtifactID ON [${mjSchema}_Committees].[Minute] ([ArtifactID]);

-- Index for foreign key MeetingID in table Minute
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Minute_MeetingID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Minute]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Minute_MeetingID ON [${mjSchema}_Committees].[Minute] ([MeetingID]);

-- Index for foreign key ApprovedByMeetingID in table Minute
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Minute_ApprovedByMeetingID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Minute]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Minute_ApprovedByMeetingID ON [${mjSchema}_Committees].[Minute] ([ApprovedByMeetingID]);

/* Base View SQL for Committees: Minutes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Minutes
-- Item: vwMinutes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Minutes
-----               SCHEMA:      ${mjSchema}_Committees
-----               BASE TABLE:  Minute
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[vwMinutes]', 'V') IS NOT NULL
    DROP VIEW [${mjSchema}_Committees].[vwMinutes];
GO

CREATE VIEW [${mjSchema}_Committees].[vwMinutes]
AS
SELECT
    m.*
FROM
    [${mjSchema}_Committees].[Minute] AS m
GO
GRANT SELECT ON [${mjSchema}_Committees].[vwMinutes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Minutes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Minutes
-- Item: Permissions for vwMinutes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${mjSchema}_Committees].[vwMinutes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Minutes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Minutes
-- Item: spCreateMinute
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Minute
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spCreateMinute]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spCreateMinute];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spCreateMinute]
    @ID uniqueidentifier = NULL,
    @ArtifactID_Clear bit = 0,
    @ArtifactID uniqueidentifier = NULL,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @Content_Clear bit = 0,
    @Content nvarchar(MAX) = NULL,
    @ApprovalStatus nvarchar(50) = NULL,
    @ApprovedAt_Clear bit = 0,
    @ApprovedAt datetimeoffset = NULL,
    @ApprovedByMeetingID_Clear bit = 0,
    @ApprovedByMeetingID uniqueidentifier = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${mjSchema}_Committees].[Minute]
            (
                [ID],
                [ArtifactID],
                [MeetingID],
                [Content],
                [ApprovalStatus],
                [ApprovedAt],
                [ApprovedByMeetingID],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                CASE WHEN @ArtifactID_Clear = 1 THEN NULL ELSE ISNULL(@ArtifactID, NULL) END,
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @Content_Clear = 1 THEN NULL ELSE ISNULL(@Content, NULL) END,
                ISNULL(@ApprovalStatus, 'Draft'),
                CASE WHEN @ApprovedAt_Clear = 1 THEN NULL ELSE ISNULL(@ApprovedAt, NULL) END,
                CASE WHEN @ApprovedByMeetingID_Clear = 1 THEN NULL ELSE ISNULL(@ApprovedByMeetingID, NULL) END,
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${mjSchema}_Committees].[Minute]
            (
                [ArtifactID],
                [MeetingID],
                [Content],
                [ApprovalStatus],
                [ApprovedAt],
                [ApprovedByMeetingID],
                [Notes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                CASE WHEN @ArtifactID_Clear = 1 THEN NULL ELSE ISNULL(@ArtifactID, NULL) END,
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @Content_Clear = 1 THEN NULL ELSE ISNULL(@Content, NULL) END,
                ISNULL(@ApprovalStatus, 'Draft'),
                CASE WHEN @ApprovedAt_Clear = 1 THEN NULL ELSE ISNULL(@ApprovedAt, NULL) END,
                CASE WHEN @ApprovedByMeetingID_Clear = 1 THEN NULL ELSE ISNULL(@ApprovedByMeetingID, NULL) END,
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${mjSchema}_Committees].[vwMinutes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateMinute] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Minutes */

GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateMinute] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Minutes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Minutes
-- Item: spUpdateMinute
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Minute
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spUpdateMinute]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spUpdateMinute];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spUpdateMinute]
    @ID uniqueidentifier,
    @ArtifactID_Clear bit = 0,
    @ArtifactID uniqueidentifier = NULL,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @Content_Clear bit = 0,
    @Content nvarchar(MAX) = NULL,
    @ApprovalStatus nvarchar(50) = NULL,
    @ApprovedAt_Clear bit = 0,
    @ApprovedAt datetimeoffset = NULL,
    @ApprovedByMeetingID_Clear bit = 0,
    @ApprovedByMeetingID uniqueidentifier = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Minute]
    SET
        [ArtifactID] = CASE WHEN @ArtifactID_Clear = 1 THEN NULL ELSE ISNULL(@ArtifactID, [ArtifactID]) END,
        [MeetingID] = CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, [MeetingID]) END,
        [Content] = CASE WHEN @Content_Clear = 1 THEN NULL ELSE ISNULL(@Content, [Content]) END,
        [ApprovalStatus] = ISNULL(@ApprovalStatus, [ApprovalStatus]),
        [ApprovedAt] = CASE WHEN @ApprovedAt_Clear = 1 THEN NULL ELSE ISNULL(@ApprovedAt, [ApprovedAt]) END,
        [ApprovedByMeetingID] = CASE WHEN @ApprovedByMeetingID_Clear = 1 THEN NULL ELSE ISNULL(@ApprovedByMeetingID, [ApprovedByMeetingID]) END,
        [Notes] = CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, [Notes]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${mjSchema}_Committees].[vwMinutes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${mjSchema}_Committees].[vwMinutes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateMinute] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Minute table
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[trgUpdateMinute]', 'TR') IS NOT NULL
    DROP TRIGGER [${mjSchema}_Committees].[trgUpdateMinute];
GO
CREATE TRIGGER [${mjSchema}_Committees].trgUpdateMinute
ON [${mjSchema}_Committees].[Minute]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Minute]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${mjSchema}_Committees].[Minute] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Minutes */

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateMinute] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Minutes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Minutes
-- Item: spDeleteMinute
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Minute
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spDeleteMinute]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spDeleteMinute];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spDeleteMinute]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${mjSchema}_Committees].[Minute]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteMinute] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Minutes */

GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteMinute] TO [cdp_Developer], [cdp_Integration];

/* SQL text to update entity field related entity name field map for entity field ID A0FDC791-DD72-4A4D-BEA6-53162CD2D0DE */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='A0FDC791-DD72-4A4D-BEA6-53162CD2D0DE', @RelatedEntityNameFieldMap='VideoProvider_Virtual';

/* SQL text to update entity field related entity name field map for entity field ID BF45D3A7-9B28-4C2E-9648-E2B2191C64D2 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='BF45D3A7-9B28-4C2E-9648-E2B2191C64D2', @RelatedEntityNameFieldMap='ParentCommittee';

/* SQL text to update entity field related entity name field map for entity field ID 9FE98BD5-1CA5-476A-A402-D203E206355D */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='9FE98BD5-1CA5-476A-A402-D203E206355D', @RelatedEntityNameFieldMap='Task';

/* SQL text to update entity field related entity name field map for entity field ID 750E3103-DE75-48E9-8806-E5D096CF72B9 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='750E3103-DE75-48E9-8806-E5D096CF72B9', @RelatedEntityNameFieldMap='Role';

/* Base View SQL for Committees: Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
-- Item: vwMeetings
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Meetings
-----               SCHEMA:      ${mjSchema}_Committees
-----               BASE TABLE:  Meeting
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[vwMeetings]', 'V') IS NOT NULL
    DROP VIEW [${mjSchema}_Committees].[vwMeetings];
GO

CREATE VIEW [${mjSchema}_Committees].[vwMeetings]
AS
SELECT
    m.*,
    mjCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjCommitteesVideoProvider_VideoProviderID.[Name] AS [VideoProvider_Virtual]
FROM
    [${mjSchema}_Committees].[Meeting] AS m
INNER JOIN
    [${mjSchema}_Committees].[Committee] AS mjCommitteesCommittee_CommitteeID
  ON
    [m].[CommitteeID] = mjCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [${mjSchema}_Committees].[VideoProvider] AS mjCommitteesVideoProvider_VideoProviderID
  ON
    [m].[VideoProviderID] = mjCommitteesVideoProvider_VideoProviderID.[ID]
GO
GRANT SELECT ON [${mjSchema}_Committees].[vwMeetings] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
-- Item: Permissions for vwMeetings
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${mjSchema}_Committees].[vwMeetings] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
-- Item: spCreateMeeting
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Meeting
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spCreateMeeting]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spCreateMeeting];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spCreateMeeting]
    @ID uniqueidentifier = NULL,
    @CommitteeID uniqueidentifier,
    @Title nvarchar(255),
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @StartDateTime datetimeoffset,
    @EndDateTime_Clear bit = 0,
    @EndDateTime datetimeoffset = NULL,
    @TimeZone nvarchar(50) = NULL,
    @LocationType nvarchar(50) = NULL,
    @LocationText_Clear bit = 0,
    @LocationText nvarchar(500) = NULL,
    @VideoProvider_Clear bit = 0,
    @VideoProvider nvarchar(50) = NULL,
    @VideoProviderID_Clear bit = 0,
    @VideoProviderID uniqueidentifier = NULL,
    @VideoMeetingID_Clear bit = 0,
    @VideoMeetingID nvarchar(255) = NULL,
    @VideoJoinURL_Clear bit = 0,
    @VideoJoinURL nvarchar(1000) = NULL,
    @VideoRecordingURL_Clear bit = 0,
    @VideoRecordingURL nvarchar(1000) = NULL,
    @TranscriptURL_Clear bit = 0,
    @TranscriptURL nvarchar(1000) = NULL,
    @Status nvarchar(50) = NULL,
    @CalendarEventID_Clear bit = 0,
    @CalendarEventID nvarchar(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${mjSchema}_Committees].[Meeting]
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
                [VideoProviderID],
                [VideoMeetingID],
                [VideoJoinURL],
                [VideoRecordingURL],
                [TranscriptURL],
                [Status],
                [CalendarEventID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @CommitteeID,
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @StartDateTime,
                CASE WHEN @EndDateTime_Clear = 1 THEN NULL ELSE ISNULL(@EndDateTime, NULL) END,
                ISNULL(@TimeZone, 'America/New_York'),
                ISNULL(@LocationType, 'Virtual'),
                CASE WHEN @LocationText_Clear = 1 THEN NULL ELSE ISNULL(@LocationText, NULL) END,
                CASE WHEN @VideoProvider_Clear = 1 THEN NULL ELSE ISNULL(@VideoProvider, NULL) END,
                CASE WHEN @VideoProviderID_Clear = 1 THEN NULL ELSE ISNULL(@VideoProviderID, NULL) END,
                CASE WHEN @VideoMeetingID_Clear = 1 THEN NULL ELSE ISNULL(@VideoMeetingID, NULL) END,
                CASE WHEN @VideoJoinURL_Clear = 1 THEN NULL ELSE ISNULL(@VideoJoinURL, NULL) END,
                CASE WHEN @VideoRecordingURL_Clear = 1 THEN NULL ELSE ISNULL(@VideoRecordingURL, NULL) END,
                CASE WHEN @TranscriptURL_Clear = 1 THEN NULL ELSE ISNULL(@TranscriptURL, NULL) END,
                ISNULL(@Status, 'Scheduled'),
                CASE WHEN @CalendarEventID_Clear = 1 THEN NULL ELSE ISNULL(@CalendarEventID, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${mjSchema}_Committees].[Meeting]
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
                [VideoProviderID],
                [VideoMeetingID],
                [VideoJoinURL],
                [VideoRecordingURL],
                [TranscriptURL],
                [Status],
                [CalendarEventID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @CommitteeID,
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @StartDateTime,
                CASE WHEN @EndDateTime_Clear = 1 THEN NULL ELSE ISNULL(@EndDateTime, NULL) END,
                ISNULL(@TimeZone, 'America/New_York'),
                ISNULL(@LocationType, 'Virtual'),
                CASE WHEN @LocationText_Clear = 1 THEN NULL ELSE ISNULL(@LocationText, NULL) END,
                CASE WHEN @VideoProvider_Clear = 1 THEN NULL ELSE ISNULL(@VideoProvider, NULL) END,
                CASE WHEN @VideoProviderID_Clear = 1 THEN NULL ELSE ISNULL(@VideoProviderID, NULL) END,
                CASE WHEN @VideoMeetingID_Clear = 1 THEN NULL ELSE ISNULL(@VideoMeetingID, NULL) END,
                CASE WHEN @VideoJoinURL_Clear = 1 THEN NULL ELSE ISNULL(@VideoJoinURL, NULL) END,
                CASE WHEN @VideoRecordingURL_Clear = 1 THEN NULL ELSE ISNULL(@VideoRecordingURL, NULL) END,
                CASE WHEN @TranscriptURL_Clear = 1 THEN NULL ELSE ISNULL(@TranscriptURL, NULL) END,
                ISNULL(@Status, 'Scheduled'),
                CASE WHEN @CalendarEventID_Clear = 1 THEN NULL ELSE ISNULL(@CalendarEventID, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${mjSchema}_Committees].[vwMeetings] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateMeeting] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Meetings */

GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateMeeting] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
-- Item: spUpdateMeeting
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Meeting
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spUpdateMeeting]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spUpdateMeeting];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spUpdateMeeting]
    @ID uniqueidentifier,
    @CommitteeID uniqueidentifier = NULL,
    @Title nvarchar(255) = NULL,
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @StartDateTime datetimeoffset = NULL,
    @EndDateTime_Clear bit = 0,
    @EndDateTime datetimeoffset = NULL,
    @TimeZone nvarchar(50) = NULL,
    @LocationType nvarchar(50) = NULL,
    @LocationText_Clear bit = 0,
    @LocationText nvarchar(500) = NULL,
    @VideoProvider_Clear bit = 0,
    @VideoProvider nvarchar(50) = NULL,
    @VideoProviderID_Clear bit = 0,
    @VideoProviderID uniqueidentifier = NULL,
    @VideoMeetingID_Clear bit = 0,
    @VideoMeetingID nvarchar(255) = NULL,
    @VideoJoinURL_Clear bit = 0,
    @VideoJoinURL nvarchar(1000) = NULL,
    @VideoRecordingURL_Clear bit = 0,
    @VideoRecordingURL nvarchar(1000) = NULL,
    @TranscriptURL_Clear bit = 0,
    @TranscriptURL nvarchar(1000) = NULL,
    @Status nvarchar(50) = NULL,
    @CalendarEventID_Clear bit = 0,
    @CalendarEventID nvarchar(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Meeting]
    SET
        [CommitteeID] = ISNULL(@CommitteeID, [CommitteeID]),
        [Title] = ISNULL(@Title, [Title]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [StartDateTime] = ISNULL(@StartDateTime, [StartDateTime]),
        [EndDateTime] = CASE WHEN @EndDateTime_Clear = 1 THEN NULL ELSE ISNULL(@EndDateTime, [EndDateTime]) END,
        [TimeZone] = ISNULL(@TimeZone, [TimeZone]),
        [LocationType] = ISNULL(@LocationType, [LocationType]),
        [LocationText] = CASE WHEN @LocationText_Clear = 1 THEN NULL ELSE ISNULL(@LocationText, [LocationText]) END,
        [VideoProvider] = CASE WHEN @VideoProvider_Clear = 1 THEN NULL ELSE ISNULL(@VideoProvider, [VideoProvider]) END,
        [VideoProviderID] = CASE WHEN @VideoProviderID_Clear = 1 THEN NULL ELSE ISNULL(@VideoProviderID, [VideoProviderID]) END,
        [VideoMeetingID] = CASE WHEN @VideoMeetingID_Clear = 1 THEN NULL ELSE ISNULL(@VideoMeetingID, [VideoMeetingID]) END,
        [VideoJoinURL] = CASE WHEN @VideoJoinURL_Clear = 1 THEN NULL ELSE ISNULL(@VideoJoinURL, [VideoJoinURL]) END,
        [VideoRecordingURL] = CASE WHEN @VideoRecordingURL_Clear = 1 THEN NULL ELSE ISNULL(@VideoRecordingURL, [VideoRecordingURL]) END,
        [TranscriptURL] = CASE WHEN @TranscriptURL_Clear = 1 THEN NULL ELSE ISNULL(@TranscriptURL, [TranscriptURL]) END,
        [Status] = ISNULL(@Status, [Status]),
        [CalendarEventID] = CASE WHEN @CalendarEventID_Clear = 1 THEN NULL ELSE ISNULL(@CalendarEventID, [CalendarEventID]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${mjSchema}_Committees].[vwMeetings] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${mjSchema}_Committees].[vwMeetings]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateMeeting] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Meeting table
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[trgUpdateMeeting]', 'TR') IS NOT NULL
    DROP TRIGGER [${mjSchema}_Committees].[trgUpdateMeeting];
GO
CREATE TRIGGER [${mjSchema}_Committees].trgUpdateMeeting
ON [${mjSchema}_Committees].[Meeting]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Meeting]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${mjSchema}_Committees].[Meeting] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Meetings */

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateMeeting] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
-- Item: spDeleteMeeting
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Meeting
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spDeleteMeeting]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spDeleteMeeting];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spDeleteMeeting]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${mjSchema}_Committees].[Meeting]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteMeeting] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Meetings */

GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteMeeting] TO [cdp_Developer], [cdp_Integration];

/* SQL text to update entity field related entity name field map for entity field ID 44F607D6-0D6A-4A99-A1BC-0E248E100C63 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='44F607D6-0D6A-4A99-A1BC-0E248E100C63', @RelatedEntityNameFieldMap='Person';

/* SQL text to update entity field related entity name field map for entity field ID 2CEE9B5E-6008-45BA-9E82-276E901E0457 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='2CEE9B5E-6008-45BA-9E82-276E901E0457', @RelatedEntityNameFieldMap='Term';

/* SQL text to update entity field related entity name field map for entity field ID F2ABB2EB-D0A0-4515-90FC-1D4670414A35 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='F2ABB2EB-D0A0-4515-90FC-1D4670414A35', @RelatedEntityNameFieldMap='Organization';

/* Root ID Function SQL for Committees: Comments.ParentCommentID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: fnCommentParentCommentID_GetRootID
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- ROOT ID FUNCTION FOR: [Comment].[ParentCommentID]
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[fnCommentParentCommentID_GetRootID]', 'IF') IS NOT NULL
    DROP FUNCTION [${mjSchema}_Committees].[fnCommentParentCommentID_GetRootID];
GO

CREATE FUNCTION [${mjSchema}_Committees].[fnCommentParentCommentID_GetRootID]
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
            [${mjSchema}_Committees].[Comment]
        WHERE
            [ID] = COALESCE(@ParentID, @RecordID)

        UNION ALL

        SELECT
            c.[ID],
            c.[ParentCommentID],
            c.[ID] AS [RootParentID],
            p.[Depth] + 1 AS [Depth]
        FROM
            [${mjSchema}_Committees].[Comment] c
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

/* Base View SQL for Committees: Comments */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: vwComments
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Comments
-----               SCHEMA:      ${mjSchema}_Committees
-----               BASE TABLE:  Comment
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[vwComments]', 'V') IS NOT NULL
    DROP VIEW [${mjSchema}_Committees].[vwComments];
GO

CREATE VIEW [${mjSchema}_Committees].[vwComments]
AS
SELECT
    c.*,
    mjCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjBizAppsTasksTask_TaskID.[Name] AS [Task],
    mjBizAppsCommonPerson_PersonID.[DisplayName] AS [Person],
    root_ParentCommentID.RootID AS [RootParentCommentID]
FROM
    [${mjSchema}_Committees].[Comment] AS c
INNER JOIN
    [${mjSchema}_Committees].[Committee] AS mjCommitteesCommittee_CommitteeID
  ON
    [c].[CommitteeID] = mjCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [${mjSchema}_BizAppsTasks].[Task] AS mjBizAppsTasksTask_TaskID
  ON
    [c].[TaskID] = mjBizAppsTasksTask_TaskID.[ID]
INNER JOIN
    [${mjSchema}_BizAppsCommon].[Person] AS mjBizAppsCommonPerson_PersonID
  ON
    [c].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
OUTER APPLY
    [${mjSchema}_Committees].[fnCommentParentCommentID_GetRootID]([c].[ID], [c].[ParentCommentID]) AS root_ParentCommentID
GO
GRANT SELECT ON [${mjSchema}_Committees].[vwComments] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Comments */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: Permissions for vwComments
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${mjSchema}_Committees].[vwComments] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Comments */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: spCreateComment
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Comment
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spCreateComment]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spCreateComment];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spCreateComment]
    @ID uniqueidentifier = NULL,
    @CommitteeID uniqueidentifier,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @TaskID_Clear bit = 0,
    @TaskID uniqueidentifier = NULL,
    @ArtifactID_Clear bit = 0,
    @ArtifactID uniqueidentifier = NULL,
    @ParentCommentID_Clear bit = 0,
    @ParentCommentID uniqueidentifier = NULL,
    @PersonID uniqueidentifier,
    @CommentText nvarchar(MAX),
    @MentionedPersonIDs_Clear bit = 0,
    @MentionedPersonIDs nvarchar(MAX) = NULL,
    @IsResolved bit = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${mjSchema}_Committees].[Comment]
            (
                [ID],
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [TaskID],
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
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                CASE WHEN @TaskID_Clear = 1 THEN NULL ELSE ISNULL(@TaskID, NULL) END,
                CASE WHEN @ArtifactID_Clear = 1 THEN NULL ELSE ISNULL(@ArtifactID, NULL) END,
                CASE WHEN @ParentCommentID_Clear = 1 THEN NULL ELSE ISNULL(@ParentCommentID, NULL) END,
                @PersonID,
                @CommentText,
                CASE WHEN @MentionedPersonIDs_Clear = 1 THEN NULL ELSE ISNULL(@MentionedPersonIDs, NULL) END,
                ISNULL(@IsResolved, 0)
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${mjSchema}_Committees].[Comment]
            (
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [TaskID],
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
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                CASE WHEN @TaskID_Clear = 1 THEN NULL ELSE ISNULL(@TaskID, NULL) END,
                CASE WHEN @ArtifactID_Clear = 1 THEN NULL ELSE ISNULL(@ArtifactID, NULL) END,
                CASE WHEN @ParentCommentID_Clear = 1 THEN NULL ELSE ISNULL(@ParentCommentID, NULL) END,
                @PersonID,
                @CommentText,
                CASE WHEN @MentionedPersonIDs_Clear = 1 THEN NULL ELSE ISNULL(@MentionedPersonIDs, NULL) END,
                ISNULL(@IsResolved, 0)
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${mjSchema}_Committees].[vwComments] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateComment] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Comments */

GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateComment] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Comments */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: spUpdateComment
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Comment
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spUpdateComment]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spUpdateComment];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spUpdateComment]
    @ID uniqueidentifier,
    @CommitteeID uniqueidentifier = NULL,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @TaskID_Clear bit = 0,
    @TaskID uniqueidentifier = NULL,
    @ArtifactID_Clear bit = 0,
    @ArtifactID uniqueidentifier = NULL,
    @ParentCommentID_Clear bit = 0,
    @ParentCommentID uniqueidentifier = NULL,
    @PersonID uniqueidentifier = NULL,
    @CommentText nvarchar(MAX) = NULL,
    @MentionedPersonIDs_Clear bit = 0,
    @MentionedPersonIDs nvarchar(MAX) = NULL,
    @IsResolved bit = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Comment]
    SET
        [CommitteeID] = ISNULL(@CommitteeID, [CommitteeID]),
        [MeetingID] = CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, [MeetingID]) END,
        [AgendaItemID] = CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, [AgendaItemID]) END,
        [TaskID] = CASE WHEN @TaskID_Clear = 1 THEN NULL ELSE ISNULL(@TaskID, [TaskID]) END,
        [ArtifactID] = CASE WHEN @ArtifactID_Clear = 1 THEN NULL ELSE ISNULL(@ArtifactID, [ArtifactID]) END,
        [ParentCommentID] = CASE WHEN @ParentCommentID_Clear = 1 THEN NULL ELSE ISNULL(@ParentCommentID, [ParentCommentID]) END,
        [PersonID] = ISNULL(@PersonID, [PersonID]),
        [CommentText] = ISNULL(@CommentText, [CommentText]),
        [MentionedPersonIDs] = CASE WHEN @MentionedPersonIDs_Clear = 1 THEN NULL ELSE ISNULL(@MentionedPersonIDs, [MentionedPersonIDs]) END,
        [IsResolved] = ISNULL(@IsResolved, [IsResolved])
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${mjSchema}_Committees].[vwComments] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${mjSchema}_Committees].[vwComments]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateComment] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Comment table
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[trgUpdateComment]', 'TR') IS NOT NULL
    DROP TRIGGER [${mjSchema}_Committees].[trgUpdateComment];
GO
CREATE TRIGGER [${mjSchema}_Committees].trgUpdateComment
ON [${mjSchema}_Committees].[Comment]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Comment]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${mjSchema}_Committees].[Comment] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Comments */

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateComment] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Comments */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: spDeleteComment
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Comment
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spDeleteComment]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spDeleteComment];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spDeleteComment]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${mjSchema}_Committees].[Comment]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteComment] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Comments */

GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteComment] TO [cdp_Developer], [cdp_Integration];

/* Base View SQL for Committees: Memberships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Memberships
-- Item: vwMemberships
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Memberships
-----               SCHEMA:      ${mjSchema}_Committees
-----               BASE TABLE:  Membership
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[vwMemberships]', 'V') IS NOT NULL
    DROP VIEW [${mjSchema}_Committees].[vwMemberships];
GO

CREATE VIEW [${mjSchema}_Committees].[vwMemberships]
AS
SELECT
    m.*,
    mjBizAppsCommonPerson_PersonID.[DisplayName] AS [Person],
    mjCommitteesRole_RoleID.[Name] AS [Role],
    mjCommitteesTerm_TermID.[Name] AS [Term]
FROM
    [${mjSchema}_Committees].[Membership] AS m
INNER JOIN
    [${mjSchema}_BizAppsCommon].[Person] AS mjBizAppsCommonPerson_PersonID
  ON
    [m].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
INNER JOIN
    [${mjSchema}_Committees].[Role] AS mjCommitteesRole_RoleID
  ON
    [m].[RoleID] = mjCommitteesRole_RoleID.[ID]
INNER JOIN
    [${mjSchema}_Committees].[Term] AS mjCommitteesTerm_TermID
  ON
    [m].[TermID] = mjCommitteesTerm_TermID.[ID]
GO
GRANT SELECT ON [${mjSchema}_Committees].[vwMemberships] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Memberships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Memberships
-- Item: Permissions for vwMemberships
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${mjSchema}_Committees].[vwMemberships] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Memberships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Memberships
-- Item: spCreateMembership
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Membership
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spCreateMembership]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spCreateMembership];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spCreateMembership]
    @ID uniqueidentifier = NULL,
    @PersonID uniqueidentifier,
    @RoleID uniqueidentifier,
    @TermID uniqueidentifier,
    @StartDate date,
    @EndDate_Clear bit = 0,
    @EndDate date = NULL,
    @Status nvarchar(50) = NULL,
    @EndReason_Clear bit = 0,
    @EndReason nvarchar(100) = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${mjSchema}_Committees].[Membership]
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
                CASE WHEN @EndDate_Clear = 1 THEN NULL ELSE ISNULL(@EndDate, NULL) END,
                ISNULL(@Status, 'Active'),
                CASE WHEN @EndReason_Clear = 1 THEN NULL ELSE ISNULL(@EndReason, NULL) END,
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${mjSchema}_Committees].[Membership]
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
                CASE WHEN @EndDate_Clear = 1 THEN NULL ELSE ISNULL(@EndDate, NULL) END,
                ISNULL(@Status, 'Active'),
                CASE WHEN @EndReason_Clear = 1 THEN NULL ELSE ISNULL(@EndReason, NULL) END,
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${mjSchema}_Committees].[vwMemberships] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateMembership] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Memberships */

GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateMembership] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Memberships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Memberships
-- Item: spUpdateMembership
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Membership
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spUpdateMembership]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spUpdateMembership];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spUpdateMembership]
    @ID uniqueidentifier,
    @PersonID uniqueidentifier = NULL,
    @RoleID uniqueidentifier = NULL,
    @TermID uniqueidentifier = NULL,
    @StartDate date = NULL,
    @EndDate_Clear bit = 0,
    @EndDate date = NULL,
    @Status nvarchar(50) = NULL,
    @EndReason_Clear bit = 0,
    @EndReason nvarchar(100) = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Membership]
    SET
        [PersonID] = ISNULL(@PersonID, [PersonID]),
        [RoleID] = ISNULL(@RoleID, [RoleID]),
        [TermID] = ISNULL(@TermID, [TermID]),
        [StartDate] = ISNULL(@StartDate, [StartDate]),
        [EndDate] = CASE WHEN @EndDate_Clear = 1 THEN NULL ELSE ISNULL(@EndDate, [EndDate]) END,
        [Status] = ISNULL(@Status, [Status]),
        [EndReason] = CASE WHEN @EndReason_Clear = 1 THEN NULL ELSE ISNULL(@EndReason, [EndReason]) END,
        [Notes] = CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, [Notes]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${mjSchema}_Committees].[vwMemberships] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${mjSchema}_Committees].[vwMemberships]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateMembership] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Membership table
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[trgUpdateMembership]', 'TR') IS NOT NULL
    DROP TRIGGER [${mjSchema}_Committees].[trgUpdateMembership];
GO
CREATE TRIGGER [${mjSchema}_Committees].trgUpdateMembership
ON [${mjSchema}_Committees].[Membership]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Membership]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${mjSchema}_Committees].[Membership] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Memberships */

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateMembership] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Memberships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Memberships
-- Item: spDeleteMembership
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Membership
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spDeleteMembership]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spDeleteMembership];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spDeleteMembership]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${mjSchema}_Committees].[Membership]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteMembership] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Memberships */

GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteMembership] TO [cdp_Developer], [cdp_Integration];

/* Root ID Function SQL for Committees: Committees.ParentCommitteeID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Committees
-- Item: fnCommitteeParentCommitteeID_GetRootID
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- ROOT ID FUNCTION FOR: [Committee].[ParentCommitteeID]
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[fnCommitteeParentCommitteeID_GetRootID]', 'IF') IS NOT NULL
    DROP FUNCTION [${mjSchema}_Committees].[fnCommitteeParentCommitteeID_GetRootID];
GO

CREATE FUNCTION [${mjSchema}_Committees].[fnCommitteeParentCommitteeID_GetRootID]
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
            [${mjSchema}_Committees].[Committee]
        WHERE
            [ID] = COALESCE(@ParentID, @RecordID)

        UNION ALL

        SELECT
            c.[ID],
            c.[ParentCommitteeID],
            c.[ID] AS [RootParentID],
            p.[Depth] + 1 AS [Depth]
        FROM
            [${mjSchema}_Committees].[Committee] c
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

/* Base View SQL for Committees: Committees */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Committees
-- Item: vwCommittees
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Committees
-----               SCHEMA:      ${mjSchema}_Committees
-----               BASE TABLE:  Committee
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[vwCommittees]', 'V') IS NOT NULL
    DROP VIEW [${mjSchema}_Committees].[vwCommittees];
GO

CREATE VIEW [${mjSchema}_Committees].[vwCommittees]
AS
SELECT
    c.*,
    mjCommitteesType_TypeID.[Name] AS [Type],
    mjCommitteesCommittee_ParentCommitteeID.[Name] AS [ParentCommittee],
    mjBizAppsCommonOrganization_OrganizationID.[Name] AS [Organization],
    root_ParentCommitteeID.RootID AS [RootParentCommitteeID]
FROM
    [${mjSchema}_Committees].[Committee] AS c
INNER JOIN
    [${mjSchema}_Committees].[Type] AS mjCommitteesType_TypeID
  ON
    [c].[TypeID] = mjCommitteesType_TypeID.[ID]
LEFT OUTER JOIN
    [${mjSchema}_Committees].[Committee] AS mjCommitteesCommittee_ParentCommitteeID
  ON
    [c].[ParentCommitteeID] = mjCommitteesCommittee_ParentCommitteeID.[ID]
LEFT OUTER JOIN
    [${mjSchema}_BizAppsCommon].[Organization] AS mjBizAppsCommonOrganization_OrganizationID
  ON
    [c].[OrganizationID] = mjBizAppsCommonOrganization_OrganizationID.[ID]
OUTER APPLY
    [${mjSchema}_Committees].[fnCommitteeParentCommitteeID_GetRootID]([c].[ID], [c].[ParentCommitteeID]) AS root_ParentCommitteeID
GO
GRANT SELECT ON [${mjSchema}_Committees].[vwCommittees] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Committees */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Committees
-- Item: Permissions for vwCommittees
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${mjSchema}_Committees].[vwCommittees] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Committees */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Committees
-- Item: spCreateCommittee
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Committee
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spCreateCommittee]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spCreateCommittee];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spCreateCommittee]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(255),
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @TypeID uniqueidentifier,
    @ParentCommitteeID_Clear bit = 0,
    @ParentCommitteeID uniqueidentifier = NULL,
    @OrganizationID_Clear bit = 0,
    @OrganizationID uniqueidentifier = NULL,
    @CharterDocumentURL_Clear bit = 0,
    @CharterDocumentURL nvarchar(1000) = NULL,
    @MissionStatement_Clear bit = 0,
    @MissionStatement nvarchar(MAX) = NULL,
    @Status nvarchar(50) = NULL,
    @IsPublic bit = NULL,
    @FormationDate_Clear bit = 0,
    @FormationDate date = NULL,
    @DissolutionDate_Clear bit = 0,
    @DissolutionDate date = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${mjSchema}_Committees].[Committee]
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
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @TypeID,
                CASE WHEN @ParentCommitteeID_Clear = 1 THEN NULL ELSE ISNULL(@ParentCommitteeID, NULL) END,
                CASE WHEN @OrganizationID_Clear = 1 THEN NULL ELSE ISNULL(@OrganizationID, NULL) END,
                CASE WHEN @CharterDocumentURL_Clear = 1 THEN NULL ELSE ISNULL(@CharterDocumentURL, NULL) END,
                CASE WHEN @MissionStatement_Clear = 1 THEN NULL ELSE ISNULL(@MissionStatement, NULL) END,
                ISNULL(@Status, 'Active'),
                ISNULL(@IsPublic, 1),
                CASE WHEN @FormationDate_Clear = 1 THEN NULL ELSE ISNULL(@FormationDate, NULL) END,
                CASE WHEN @DissolutionDate_Clear = 1 THEN NULL ELSE ISNULL(@DissolutionDate, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${mjSchema}_Committees].[Committee]
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
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @TypeID,
                CASE WHEN @ParentCommitteeID_Clear = 1 THEN NULL ELSE ISNULL(@ParentCommitteeID, NULL) END,
                CASE WHEN @OrganizationID_Clear = 1 THEN NULL ELSE ISNULL(@OrganizationID, NULL) END,
                CASE WHEN @CharterDocumentURL_Clear = 1 THEN NULL ELSE ISNULL(@CharterDocumentURL, NULL) END,
                CASE WHEN @MissionStatement_Clear = 1 THEN NULL ELSE ISNULL(@MissionStatement, NULL) END,
                ISNULL(@Status, 'Active'),
                ISNULL(@IsPublic, 1),
                CASE WHEN @FormationDate_Clear = 1 THEN NULL ELSE ISNULL(@FormationDate, NULL) END,
                CASE WHEN @DissolutionDate_Clear = 1 THEN NULL ELSE ISNULL(@DissolutionDate, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${mjSchema}_Committees].[vwCommittees] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateCommittee] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Committees */

GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateCommittee] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Committees */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Committees
-- Item: spUpdateCommittee
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Committee
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spUpdateCommittee]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spUpdateCommittee];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spUpdateCommittee]
    @ID uniqueidentifier,
    @Name nvarchar(255) = NULL,
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @TypeID uniqueidentifier = NULL,
    @ParentCommitteeID_Clear bit = 0,
    @ParentCommitteeID uniqueidentifier = NULL,
    @OrganizationID_Clear bit = 0,
    @OrganizationID uniqueidentifier = NULL,
    @CharterDocumentURL_Clear bit = 0,
    @CharterDocumentURL nvarchar(1000) = NULL,
    @MissionStatement_Clear bit = 0,
    @MissionStatement nvarchar(MAX) = NULL,
    @Status nvarchar(50) = NULL,
    @IsPublic bit = NULL,
    @FormationDate_Clear bit = 0,
    @FormationDate date = NULL,
    @DissolutionDate_Clear bit = 0,
    @DissolutionDate date = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Committee]
    SET
        [Name] = ISNULL(@Name, [Name]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [TypeID] = ISNULL(@TypeID, [TypeID]),
        [ParentCommitteeID] = CASE WHEN @ParentCommitteeID_Clear = 1 THEN NULL ELSE ISNULL(@ParentCommitteeID, [ParentCommitteeID]) END,
        [OrganizationID] = CASE WHEN @OrganizationID_Clear = 1 THEN NULL ELSE ISNULL(@OrganizationID, [OrganizationID]) END,
        [CharterDocumentURL] = CASE WHEN @CharterDocumentURL_Clear = 1 THEN NULL ELSE ISNULL(@CharterDocumentURL, [CharterDocumentURL]) END,
        [MissionStatement] = CASE WHEN @MissionStatement_Clear = 1 THEN NULL ELSE ISNULL(@MissionStatement, [MissionStatement]) END,
        [Status] = ISNULL(@Status, [Status]),
        [IsPublic] = ISNULL(@IsPublic, [IsPublic]),
        [FormationDate] = CASE WHEN @FormationDate_Clear = 1 THEN NULL ELSE ISNULL(@FormationDate, [FormationDate]) END,
        [DissolutionDate] = CASE WHEN @DissolutionDate_Clear = 1 THEN NULL ELSE ISNULL(@DissolutionDate, [DissolutionDate]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${mjSchema}_Committees].[vwCommittees] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${mjSchema}_Committees].[vwCommittees]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateCommittee] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Committee table
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[trgUpdateCommittee]', 'TR') IS NOT NULL
    DROP TRIGGER [${mjSchema}_Committees].[trgUpdateCommittee];
GO
CREATE TRIGGER [${mjSchema}_Committees].trgUpdateCommittee
ON [${mjSchema}_Committees].[Committee]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Committee]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${mjSchema}_Committees].[Committee] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Committees */

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateCommittee] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Committees */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Committees
-- Item: spDeleteCommittee
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Committee
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spDeleteCommittee]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spDeleteCommittee];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spDeleteCommittee]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${mjSchema}_Committees].[Committee]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteCommittee] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Committees */

GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteCommittee] TO [cdp_Developer], [cdp_Integration];

/* Index for Foreign Keys for Motion */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Motions
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
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Motion]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Motion_MeetingID ON [${mjSchema}_Committees].[Motion] ([MeetingID]);

-- Index for foreign key AgendaItemID in table Motion
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Motion_AgendaItemID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Motion]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Motion_AgendaItemID ON [${mjSchema}_Committees].[Motion] ([AgendaItemID]);

-- Index for foreign key MovedByMembershipID in table Motion
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Motion_MovedByMembershipID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Motion]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Motion_MovedByMembershipID ON [${mjSchema}_Committees].[Motion] ([MovedByMembershipID]);

-- Index for foreign key SecondedByMembershipID in table Motion
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Motion_SecondedByMembershipID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Motion]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Motion_SecondedByMembershipID ON [${mjSchema}_Committees].[Motion] ([SecondedByMembershipID]);

/* Index for Foreign Keys for Role */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Roles
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------;

/* Index for Foreign Keys for Term */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Terms
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
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Term]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Term_CommitteeID ON [${mjSchema}_Committees].[Term] ([CommitteeID]);

/* SQL text to update entity field related entity name field map for entity field ID 091826C5-1F45-44FB-A3B0-B2296A9D81AC */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='091826C5-1F45-44FB-A3B0-B2296A9D81AC', @RelatedEntityNameFieldMap='Committee';

/* Index for Foreign Keys for Type */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Types
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------;

/* Index for Foreign Keys for VideoProvider */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Video Providers
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
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[VideoProvider]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_VideoProvider_CredentialID ON [${mjSchema}_Committees].[VideoProvider] ([CredentialID]);

/* SQL text to update entity field related entity name field map for entity field ID 171B0CFE-85EE-431B-9ECE-1DA427A26ACD */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='171B0CFE-85EE-431B-9ECE-1DA427A26ACD', @RelatedEntityNameFieldMap='Credential';

/* Base View SQL for Committees: Motions */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Motions
-- Item: vwMotions
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Motions
-----               SCHEMA:      ${mjSchema}_Committees
-----               BASE TABLE:  Motion
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[vwMotions]', 'V') IS NOT NULL
    DROP VIEW [${mjSchema}_Committees].[vwMotions];
GO

CREATE VIEW [${mjSchema}_Committees].[vwMotions]
AS
SELECT
    m.*
FROM
    [${mjSchema}_Committees].[Motion] AS m
GO
GRANT SELECT ON [${mjSchema}_Committees].[vwMotions] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Motions */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Motions
-- Item: Permissions for vwMotions
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${mjSchema}_Committees].[vwMotions] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Motions */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Motions
-- Item: spCreateMotion
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Motion
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spCreateMotion]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spCreateMotion];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spCreateMotion]
    @ID uniqueidentifier = NULL,
    @MeetingID uniqueidentifier,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @Sequence int = NULL,
    @Title nvarchar(255),
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @MovedByMembershipID_Clear bit = 0,
    @MovedByMembershipID uniqueidentifier = NULL,
    @SecondedByMembershipID_Clear bit = 0,
    @SecondedByMembershipID uniqueidentifier = NULL,
    @Result nvarchar(50) = NULL,
    @ResultSummary_Clear bit = 0,
    @ResultSummary nvarchar(255) = NULL,
    @YesCount_Clear bit = 0,
    @YesCount int = NULL,
    @NoCount_Clear bit = 0,
    @NoCount int = NULL,
    @AbstainCount_Clear bit = 0,
    @AbstainCount int = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${mjSchema}_Committees].[Motion]
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
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                ISNULL(@Sequence, 1),
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                CASE WHEN @MovedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@MovedByMembershipID, NULL) END,
                CASE WHEN @SecondedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@SecondedByMembershipID, NULL) END,
                ISNULL(@Result, 'Pending'),
                CASE WHEN @ResultSummary_Clear = 1 THEN NULL ELSE ISNULL(@ResultSummary, NULL) END,
                CASE WHEN @YesCount_Clear = 1 THEN NULL ELSE ISNULL(@YesCount, NULL) END,
                CASE WHEN @NoCount_Clear = 1 THEN NULL ELSE ISNULL(@NoCount, NULL) END,
                CASE WHEN @AbstainCount_Clear = 1 THEN NULL ELSE ISNULL(@AbstainCount, NULL) END,
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${mjSchema}_Committees].[Motion]
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
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                ISNULL(@Sequence, 1),
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                CASE WHEN @MovedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@MovedByMembershipID, NULL) END,
                CASE WHEN @SecondedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@SecondedByMembershipID, NULL) END,
                ISNULL(@Result, 'Pending'),
                CASE WHEN @ResultSummary_Clear = 1 THEN NULL ELSE ISNULL(@ResultSummary, NULL) END,
                CASE WHEN @YesCount_Clear = 1 THEN NULL ELSE ISNULL(@YesCount, NULL) END,
                CASE WHEN @NoCount_Clear = 1 THEN NULL ELSE ISNULL(@NoCount, NULL) END,
                CASE WHEN @AbstainCount_Clear = 1 THEN NULL ELSE ISNULL(@AbstainCount, NULL) END,
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${mjSchema}_Committees].[vwMotions] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateMotion] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Motions */

GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateMotion] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Motions */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Motions
-- Item: spUpdateMotion
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Motion
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spUpdateMotion]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spUpdateMotion];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spUpdateMotion]
    @ID uniqueidentifier,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @Sequence int = NULL,
    @Title nvarchar(255) = NULL,
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @MovedByMembershipID_Clear bit = 0,
    @MovedByMembershipID uniqueidentifier = NULL,
    @SecondedByMembershipID_Clear bit = 0,
    @SecondedByMembershipID uniqueidentifier = NULL,
    @Result nvarchar(50) = NULL,
    @ResultSummary_Clear bit = 0,
    @ResultSummary nvarchar(255) = NULL,
    @YesCount_Clear bit = 0,
    @YesCount int = NULL,
    @NoCount_Clear bit = 0,
    @NoCount int = NULL,
    @AbstainCount_Clear bit = 0,
    @AbstainCount int = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Motion]
    SET
        [MeetingID] = ISNULL(@MeetingID, [MeetingID]),
        [AgendaItemID] = CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, [AgendaItemID]) END,
        [Sequence] = ISNULL(@Sequence, [Sequence]),
        [Title] = ISNULL(@Title, [Title]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [MovedByMembershipID] = CASE WHEN @MovedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@MovedByMembershipID, [MovedByMembershipID]) END,
        [SecondedByMembershipID] = CASE WHEN @SecondedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@SecondedByMembershipID, [SecondedByMembershipID]) END,
        [Result] = ISNULL(@Result, [Result]),
        [ResultSummary] = CASE WHEN @ResultSummary_Clear = 1 THEN NULL ELSE ISNULL(@ResultSummary, [ResultSummary]) END,
        [YesCount] = CASE WHEN @YesCount_Clear = 1 THEN NULL ELSE ISNULL(@YesCount, [YesCount]) END,
        [NoCount] = CASE WHEN @NoCount_Clear = 1 THEN NULL ELSE ISNULL(@NoCount, [NoCount]) END,
        [AbstainCount] = CASE WHEN @AbstainCount_Clear = 1 THEN NULL ELSE ISNULL(@AbstainCount, [AbstainCount]) END,
        [Notes] = CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, [Notes]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${mjSchema}_Committees].[vwMotions] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${mjSchema}_Committees].[vwMotions]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateMotion] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Motion table
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[trgUpdateMotion]', 'TR') IS NOT NULL
    DROP TRIGGER [${mjSchema}_Committees].[trgUpdateMotion];
GO
CREATE TRIGGER [${mjSchema}_Committees].trgUpdateMotion
ON [${mjSchema}_Committees].[Motion]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Motion]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${mjSchema}_Committees].[Motion] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Motions */

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateMotion] TO [cdp_Developer], [cdp_Integration];

/* Base View SQL for Committees: Roles */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Roles
-- Item: vwRoles
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Roles
-----               SCHEMA:      ${mjSchema}_Committees
-----               BASE TABLE:  Role
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[vwRoles]', 'V') IS NOT NULL
    DROP VIEW [${mjSchema}_Committees].[vwRoles];
GO

CREATE VIEW [${mjSchema}_Committees].[vwRoles]
AS
SELECT
    r.*
FROM
    [${mjSchema}_Committees].[Role] AS r
GO
GRANT SELECT ON [${mjSchema}_Committees].[vwRoles] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Roles */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Roles
-- Item: Permissions for vwRoles
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${mjSchema}_Committees].[vwRoles] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Roles */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Roles
-- Item: spCreateRole
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Role
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spCreateRole]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spCreateRole];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spCreateRole]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(100),
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @IsOfficer bit = NULL,
    @IsVotingRole bit = NULL,
    @DefaultPermissionsJSON_Clear bit = 0,
    @DefaultPermissionsJSON nvarchar(MAX) = NULL,
    @Sequence int = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${mjSchema}_Committees].[Role]
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
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                ISNULL(@IsOfficer, 0),
                ISNULL(@IsVotingRole, 1),
                CASE WHEN @DefaultPermissionsJSON_Clear = 1 THEN NULL ELSE ISNULL(@DefaultPermissionsJSON, NULL) END,
                ISNULL(@Sequence, 100)
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${mjSchema}_Committees].[Role]
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
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                ISNULL(@IsOfficer, 0),
                ISNULL(@IsVotingRole, 1),
                CASE WHEN @DefaultPermissionsJSON_Clear = 1 THEN NULL ELSE ISNULL(@DefaultPermissionsJSON, NULL) END,
                ISNULL(@Sequence, 100)
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${mjSchema}_Committees].[vwRoles] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateRole] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Roles */

GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateRole] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Roles */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Roles
-- Item: spUpdateRole
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Role
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spUpdateRole]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spUpdateRole];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spUpdateRole]
    @ID uniqueidentifier,
    @Name nvarchar(100) = NULL,
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @IsOfficer bit = NULL,
    @IsVotingRole bit = NULL,
    @DefaultPermissionsJSON_Clear bit = 0,
    @DefaultPermissionsJSON nvarchar(MAX) = NULL,
    @Sequence int = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Role]
    SET
        [Name] = ISNULL(@Name, [Name]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [IsOfficer] = ISNULL(@IsOfficer, [IsOfficer]),
        [IsVotingRole] = ISNULL(@IsVotingRole, [IsVotingRole]),
        [DefaultPermissionsJSON] = CASE WHEN @DefaultPermissionsJSON_Clear = 1 THEN NULL ELSE ISNULL(@DefaultPermissionsJSON, [DefaultPermissionsJSON]) END,
        [Sequence] = ISNULL(@Sequence, [Sequence])
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${mjSchema}_Committees].[vwRoles] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${mjSchema}_Committees].[vwRoles]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateRole] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Role table
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[trgUpdateRole]', 'TR') IS NOT NULL
    DROP TRIGGER [${mjSchema}_Committees].[trgUpdateRole];
GO
CREATE TRIGGER [${mjSchema}_Committees].trgUpdateRole
ON [${mjSchema}_Committees].[Role]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Role]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${mjSchema}_Committees].[Role] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Roles */

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateRole] TO [cdp_Developer], [cdp_Integration];

/* Base View SQL for Committees: Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Types
-- Item: vwTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Types
-----               SCHEMA:      ${mjSchema}_Committees
-----               BASE TABLE:  Type
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[vwTypes]', 'V') IS NOT NULL
    DROP VIEW [${mjSchema}_Committees].[vwTypes];
GO

CREATE VIEW [${mjSchema}_Committees].[vwTypes]
AS
SELECT
    t.*
FROM
    [${mjSchema}_Committees].[Type] AS t
GO
GRANT SELECT ON [${mjSchema}_Committees].[vwTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Types
-- Item: Permissions for vwTypes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${mjSchema}_Committees].[vwTypes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Types
-- Item: spCreateType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Type
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spCreateType]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spCreateType];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spCreateType]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(100),
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @IsStandards bit = NULL,
    @DefaultTermMonths_Clear bit = 0,
    @DefaultTermMonths int = NULL,
    @IconClass_Clear bit = 0,
    @IconClass nvarchar(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${mjSchema}_Committees].[Type]
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
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                ISNULL(@IsStandards, 0),
                CASE WHEN @DefaultTermMonths_Clear = 1 THEN NULL ELSE ISNULL(@DefaultTermMonths, NULL) END,
                CASE WHEN @IconClass_Clear = 1 THEN NULL ELSE ISNULL(@IconClass, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${mjSchema}_Committees].[Type]
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
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                ISNULL(@IsStandards, 0),
                CASE WHEN @DefaultTermMonths_Clear = 1 THEN NULL ELSE ISNULL(@DefaultTermMonths, NULL) END,
                CASE WHEN @IconClass_Clear = 1 THEN NULL ELSE ISNULL(@IconClass, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${mjSchema}_Committees].[vwTypes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateType] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Types */

GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateType] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Types
-- Item: spUpdateType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Type
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spUpdateType]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spUpdateType];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spUpdateType]
    @ID uniqueidentifier,
    @Name nvarchar(100) = NULL,
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @IsStandards bit = NULL,
    @DefaultTermMonths_Clear bit = 0,
    @DefaultTermMonths int = NULL,
    @IconClass_Clear bit = 0,
    @IconClass nvarchar(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Type]
    SET
        [Name] = ISNULL(@Name, [Name]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [IsStandards] = ISNULL(@IsStandards, [IsStandards]),
        [DefaultTermMonths] = CASE WHEN @DefaultTermMonths_Clear = 1 THEN NULL ELSE ISNULL(@DefaultTermMonths, [DefaultTermMonths]) END,
        [IconClass] = CASE WHEN @IconClass_Clear = 1 THEN NULL ELSE ISNULL(@IconClass, [IconClass]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${mjSchema}_Committees].[vwTypes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${mjSchema}_Committees].[vwTypes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateType] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Type table
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[trgUpdateType]', 'TR') IS NOT NULL
    DROP TRIGGER [${mjSchema}_Committees].[trgUpdateType];
GO
CREATE TRIGGER [${mjSchema}_Committees].trgUpdateType
ON [${mjSchema}_Committees].[Type]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Type]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${mjSchema}_Committees].[Type] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Types */

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateType] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Motions */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Motions
-- Item: spDeleteMotion
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Motion
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spDeleteMotion]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spDeleteMotion];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spDeleteMotion]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${mjSchema}_Committees].[Motion]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteMotion] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Motions */

GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteMotion] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Roles */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Roles
-- Item: spDeleteRole
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Role
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spDeleteRole]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spDeleteRole];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spDeleteRole]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${mjSchema}_Committees].[Role]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteRole] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Roles */

GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteRole] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Types */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Types
-- Item: spDeleteType
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Type
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spDeleteType]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spDeleteType];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spDeleteType]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${mjSchema}_Committees].[Type]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteType] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Types */

GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteType] TO [cdp_Developer], [cdp_Integration];

/* Base View SQL for Committees: Video Providers */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Video Providers
-- Item: vwVideoProviders
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Video Providers
-----               SCHEMA:      ${mjSchema}_Committees
-----               BASE TABLE:  VideoProvider
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[vwVideoProviders]', 'V') IS NOT NULL
    DROP VIEW [${mjSchema}_Committees].[vwVideoProviders];
GO

CREATE VIEW [${mjSchema}_Committees].[vwVideoProviders]
AS
SELECT
    v.*,
    MJCredential_CredentialID.[Name] AS [Credential]
FROM
    [${mjSchema}_Committees].[VideoProvider] AS v
LEFT OUTER JOIN
    [${mjSchema}].[Credential] AS MJCredential_CredentialID
  ON
    [v].[CredentialID] = MJCredential_CredentialID.[ID]
GO
GRANT SELECT ON [${mjSchema}_Committees].[vwVideoProviders] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Video Providers */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Video Providers
-- Item: Permissions for vwVideoProviders
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${mjSchema}_Committees].[vwVideoProviders] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Video Providers */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Video Providers
-- Item: spCreateVideoProvider
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR VideoProvider
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spCreateVideoProvider]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spCreateVideoProvider];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spCreateVideoProvider]
    @ID uniqueidentifier = NULL,
    @Name nvarchar(100),
    @ServerDriverKey nvarchar(100),
    @IsActive bit = NULL,
    @IsDefault bit = NULL,
    @CredentialID_Clear bit = 0,
    @CredentialID uniqueidentifier = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${mjSchema}_Committees].[VideoProvider]
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
                CASE WHEN @CredentialID_Clear = 1 THEN NULL ELSE ISNULL(@CredentialID, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${mjSchema}_Committees].[VideoProvider]
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
                CASE WHEN @CredentialID_Clear = 1 THEN NULL ELSE ISNULL(@CredentialID, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${mjSchema}_Committees].[vwVideoProviders] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateVideoProvider] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Video Providers */

GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateVideoProvider] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Video Providers */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Video Providers
-- Item: spUpdateVideoProvider
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR VideoProvider
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spUpdateVideoProvider]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spUpdateVideoProvider];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spUpdateVideoProvider]
    @ID uniqueidentifier,
    @Name nvarchar(100) = NULL,
    @ServerDriverKey nvarchar(100) = NULL,
    @IsActive bit = NULL,
    @IsDefault bit = NULL,
    @CredentialID_Clear bit = 0,
    @CredentialID uniqueidentifier = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[VideoProvider]
    SET
        [Name] = ISNULL(@Name, [Name]),
        [ServerDriverKey] = ISNULL(@ServerDriverKey, [ServerDriverKey]),
        [IsActive] = ISNULL(@IsActive, [IsActive]),
        [IsDefault] = ISNULL(@IsDefault, [IsDefault]),
        [CredentialID] = CASE WHEN @CredentialID_Clear = 1 THEN NULL ELSE ISNULL(@CredentialID, [CredentialID]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${mjSchema}_Committees].[vwVideoProviders] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${mjSchema}_Committees].[vwVideoProviders]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateVideoProvider] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the VideoProvider table
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[trgUpdateVideoProvider]', 'TR') IS NOT NULL
    DROP TRIGGER [${mjSchema}_Committees].[trgUpdateVideoProvider];
GO
CREATE TRIGGER [${mjSchema}_Committees].trgUpdateVideoProvider
ON [${mjSchema}_Committees].[VideoProvider]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[VideoProvider]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${mjSchema}_Committees].[VideoProvider] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Video Providers */

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateVideoProvider] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Video Providers */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Video Providers
-- Item: spDeleteVideoProvider
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR VideoProvider
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spDeleteVideoProvider]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spDeleteVideoProvider];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spDeleteVideoProvider]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${mjSchema}_Committees].[VideoProvider]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteVideoProvider] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Video Providers */

GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteVideoProvider] TO [cdp_Developer], [cdp_Integration];

/* Base View SQL for Committees: Terms */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Terms
-- Item: vwTerms
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Terms
-----               SCHEMA:      ${mjSchema}_Committees
-----               BASE TABLE:  Term
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[vwTerms]', 'V') IS NOT NULL
    DROP VIEW [${mjSchema}_Committees].[vwTerms];
GO

CREATE VIEW [${mjSchema}_Committees].[vwTerms]
AS
SELECT
    t.*,
    mjCommitteesCommittee_CommitteeID.[Name] AS [Committee]
FROM
    [${mjSchema}_Committees].[Term] AS t
INNER JOIN
    [${mjSchema}_Committees].[Committee] AS mjCommitteesCommittee_CommitteeID
  ON
    [t].[CommitteeID] = mjCommitteesCommittee_CommitteeID.[ID]
GO
GRANT SELECT ON [${mjSchema}_Committees].[vwTerms] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Terms */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Terms
-- Item: Permissions for vwTerms
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${mjSchema}_Committees].[vwTerms] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Terms */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Terms
-- Item: spCreateTerm
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Term
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spCreateTerm]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spCreateTerm];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spCreateTerm]
    @ID uniqueidentifier = NULL,
    @CommitteeID uniqueidentifier,
    @Name nvarchar(100),
    @StartDate date,
    @EndDate_Clear bit = 0,
    @EndDate date = NULL,
    @Status nvarchar(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${mjSchema}_Committees].[Term]
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
                CASE WHEN @EndDate_Clear = 1 THEN NULL ELSE ISNULL(@EndDate, NULL) END,
                ISNULL(@Status, 'Active')
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${mjSchema}_Committees].[Term]
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
                CASE WHEN @EndDate_Clear = 1 THEN NULL ELSE ISNULL(@EndDate, NULL) END,
                ISNULL(@Status, 'Active')
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${mjSchema}_Committees].[vwTerms] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateTerm] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Terms */

GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateTerm] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Terms */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Terms
-- Item: spUpdateTerm
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Term
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spUpdateTerm]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spUpdateTerm];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spUpdateTerm]
    @ID uniqueidentifier,
    @CommitteeID uniqueidentifier = NULL,
    @Name nvarchar(100) = NULL,
    @StartDate date = NULL,
    @EndDate_Clear bit = 0,
    @EndDate date = NULL,
    @Status nvarchar(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Term]
    SET
        [CommitteeID] = ISNULL(@CommitteeID, [CommitteeID]),
        [Name] = ISNULL(@Name, [Name]),
        [StartDate] = ISNULL(@StartDate, [StartDate]),
        [EndDate] = CASE WHEN @EndDate_Clear = 1 THEN NULL ELSE ISNULL(@EndDate, [EndDate]) END,
        [Status] = ISNULL(@Status, [Status])
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${mjSchema}_Committees].[vwTerms] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${mjSchema}_Committees].[vwTerms]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateTerm] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Term table
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[trgUpdateTerm]', 'TR') IS NOT NULL
    DROP TRIGGER [${mjSchema}_Committees].[trgUpdateTerm];
GO
CREATE TRIGGER [${mjSchema}_Committees].trgUpdateTerm
ON [${mjSchema}_Committees].[Term]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Term]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${mjSchema}_Committees].[Term] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Terms */

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateTerm] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Terms */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Terms
-- Item: spDeleteTerm
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Term
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spDeleteTerm]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spDeleteTerm];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spDeleteTerm]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${mjSchema}_Committees].[Term]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteTerm] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Terms */

GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteTerm] TO [cdp_Developer], [cdp_Integration];

/* Index for Foreign Keys for Vote */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Votes
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
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Vote]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Vote_MotionID ON [${mjSchema}_Committees].[Vote] ([MotionID]);

-- Index for foreign key MembershipID in table Vote
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Vote_MembershipID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Vote]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Vote_MembershipID ON [${mjSchema}_Committees].[Vote] ([MembershipID]);

/* Base View SQL for Committees: Votes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Votes
-- Item: vwVotes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Votes
-----               SCHEMA:      ${mjSchema}_Committees
-----               BASE TABLE:  Vote
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[vwVotes]', 'V') IS NOT NULL
    DROP VIEW [${mjSchema}_Committees].[vwVotes];
GO

CREATE VIEW [${mjSchema}_Committees].[vwVotes]
AS
SELECT
    v.*
FROM
    [${mjSchema}_Committees].[Vote] AS v
GO
GRANT SELECT ON [${mjSchema}_Committees].[vwVotes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Votes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Votes
-- Item: Permissions for vwVotes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${mjSchema}_Committees].[vwVotes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Votes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Votes
-- Item: spCreateVote
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Vote
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spCreateVote]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spCreateVote];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spCreateVote]
    @ID uniqueidentifier = NULL,
    @MotionID uniqueidentifier,
    @MembershipID uniqueidentifier,
    @VoteValue nvarchar(20),
    @Notes_Clear bit = 0,
    @Notes nvarchar(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${mjSchema}_Committees].[Vote]
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
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${mjSchema}_Committees].[Vote]
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
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${mjSchema}_Committees].[vwVotes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateVote] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Votes */

GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateVote] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Votes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Votes
-- Item: spUpdateVote
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Vote
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spUpdateVote]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spUpdateVote];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spUpdateVote]
    @ID uniqueidentifier,
    @MotionID uniqueidentifier = NULL,
    @MembershipID uniqueidentifier = NULL,
    @VoteValue nvarchar(20) = NULL,
    @Notes_Clear bit = 0,
    @Notes nvarchar(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Vote]
    SET
        [MotionID] = ISNULL(@MotionID, [MotionID]),
        [MembershipID] = ISNULL(@MembershipID, [MembershipID]),
        [VoteValue] = ISNULL(@VoteValue, [VoteValue]),
        [Notes] = CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, [Notes]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${mjSchema}_Committees].[vwVotes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${mjSchema}_Committees].[vwVotes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateVote] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Vote table
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[trgUpdateVote]', 'TR') IS NOT NULL
    DROP TRIGGER [${mjSchema}_Committees].[trgUpdateVote];
GO
CREATE TRIGGER [${mjSchema}_Committees].trgUpdateVote
ON [${mjSchema}_Committees].[Vote]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Vote]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${mjSchema}_Committees].[Vote] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Votes */

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateVote] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Votes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Votes
-- Item: spDeleteVote
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Vote
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spDeleteVote]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spDeleteVote];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spDeleteVote]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${mjSchema}_Committees].[Vote]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteVote] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Votes */

GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteVote] TO [cdp_Developer], [cdp_Integration];

/* SQL text to delete unneeded entity fields (16 scoped entities) */
EXEC [${mjSchema}].[spDeleteUnneededEntityFields] @ExcludedSchemaNames='sys,staging,${mjSchema},${mjSchema}_BizAppsCommon,${mjSchema}_BizAppsTasks', @EntityIDs='5746F567-3A1B-4772-B8BA-D46D98A137DD,9D005287-0D07-436B-B4D4-AAE31C42BFA7,F4B63A74-6704-4CA9-97B5-D2EC745B0506,8E6153B6-BC78-4AE8-B42D-34D7E2217555,3011BE1C-A871-4536-9855-2E58A28A206E,338F9B03-8689-4BD0-8EF1-03B84B90E4D9,02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906,80299A27-B207-4D99-A46B-4E5B8A2B5E62,349618AD-3F1C-481C-8406-302817363510,1D7F24C0-622E-41E0-BC38-29C2EEB1D442,A42F4A6F-C411-42F1-A977-4A5B1FB9FA38,EAD3EF14-1891-4389-A0F3-1984BC8CC13F,CF2605AB-3F2C-4D18-B663-60105BFC2BCC,31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42,B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9,F05BE747-6F2A-472E-8800-8A10D416EAA1';

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '03be6702-9f2f-457f-856d-e1e99089fa5b' OR (EntityID = 'EAD3EF14-1891-4389-A0F3-1984BC8CC13F' AND Name = 'Committee')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '03be6702-9f2f-457f-856d-e1e99089fa5b',
            'EAD3EF14-1891-4389-A0F3-1984BC8CC13F', -- Entity: Committees: Terms
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '383e1a9f-96c7-4ce4-ad59-54a1c4e61f39' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = 'Committee')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '383e1a9f-96c7-4ce4-ad59-54a1c4e61f39',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '22be104f-2980-404c-8e6a-be0b6c81cda5' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = 'Task')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '22be104f-2980-404c-8e6a-be0b6c81cda5',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '246ba7a7-9946-4b43-8d56-593b2b4ecf9b' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = 'ArtifactType')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '246ba7a7-9946-4b43-8d56-593b2b4ecf9b',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
            100035,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'ae68f7d2-47ad-4543-a4a7-4fa5cdd04f62' OR (EntityID = '3011BE1C-A871-4536-9855-2E58A28A206E' AND Name = 'UploadedByPerson')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'ae68f7d2-47ad-4543-a4a7-4fa5cdd04f62',
            '3011BE1C-A871-4536-9855-2E58A28A206E', -- Entity: Committees: Artifacts
            100036,
            'UploadedByPerson',
            'Uploaded By Person',
            NULL,
            'nvarchar',
            402,
            0,
            0,
            1,
            NULL,
            0,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'e5a4e683-295b-42d3-b63e-6aa6577d3ac5' OR (EntityID = '349618AD-3F1C-481C-8406-302817363510' AND Name = 'Committee')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'e5a4e683-295b-42d3-b63e-6aa6577d3ac5',
            '349618AD-3F1C-481C-8406-302817363510', -- Entity: Committees: Comments
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '72c9be61-50b6-4c76-9603-b78b43f16058' OR (EntityID = '349618AD-3F1C-481C-8406-302817363510' AND Name = 'Task')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '72c9be61-50b6-4c76-9603-b78b43f16058',
            '349618AD-3F1C-481C-8406-302817363510', -- Entity: Committees: Comments
            100028,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0f919fa7-8a2e-4404-883a-132e2808f0c1' OR (EntityID = '349618AD-3F1C-481C-8406-302817363510' AND Name = 'Person')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0f919fa7-8a2e-4404-883a-132e2808f0c1',
            '349618AD-3F1C-481C-8406-302817363510', -- Entity: Committees: Comments
            100029,
            'Person',
            'Person',
            NULL,
            'nvarchar',
            402,
            0,
            0,
            0,
            NULL,
            0,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '938f1155-2fbf-4d17-910b-612547255d97' OR (EntityID = '349618AD-3F1C-481C-8406-302817363510' AND Name = 'RootParentCommentID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '938f1155-2fbf-4d17-910b-612547255d97',
            '349618AD-3F1C-481C-8406-302817363510', -- Entity: Committees: Comments
            100030,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '024929b7-65d0-4ace-9f27-cbeb3fa4f1e2' OR (EntityID = '8E6153B6-BC78-4AE8-B42D-34D7E2217555' AND Name = 'ExtendedEntity')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '024929b7-65d0-4ace-9f27-cbeb3fa4f1e2',
            '8E6153B6-BC78-4AE8-B42D-34D7E2217555', -- Entity: Committees: Artifact Types
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'df06a116-2b3a-4dfe-a98a-c1d38d3f0ed3' OR (EntityID = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38' AND Name = 'Type')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'df06a116-2b3a-4dfe-a98a-c1d38d3f0ed3',
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', -- Entity: Committees: Committees
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'a34d3c72-a08f-4e99-b5d7-75ff66d94857' OR (EntityID = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38' AND Name = 'ParentCommittee')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'a34d3c72-a08f-4e99-b5d7-75ff66d94857',
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', -- Entity: Committees: Committees
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '4f67275d-9504-4c15-9be6-4f4f752f4049' OR (EntityID = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38' AND Name = 'Organization')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '4f67275d-9504-4c15-9be6-4f4f752f4049',
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', -- Entity: Committees: Committees
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '997bf1a6-7a33-4080-879c-369463409e25' OR (EntityID = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38' AND Name = 'RootParentCommitteeID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '997bf1a6-7a33-4080-879c-369463409e25',
            'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', -- Entity: Committees: Committees
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '25c85034-2d44-4eda-8b6e-71a3eb047989' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = 'Committee')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '25c85034-2d44-4eda-8b6e-71a3eb047989',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0d463eb3-aba8-475a-9a01-2f5b522e7747' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = 'VideoProvider_Virtual')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '0d463eb3-aba8-475a-9a01-2f5b522e7747',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '55e79111-2785-444b-894e-0086e17d8ef8' OR (EntityID = '9D005287-0D07-436B-B4D4-AAE31C42BFA7' AND Name = 'Person')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '55e79111-2785-444b-894e-0086e17d8ef8',
            '9D005287-0D07-436B-B4D4-AAE31C42BFA7', -- Entity: Committees: Attendances
            100019,
            'Person',
            'Person',
            NULL,
            'nvarchar',
            402,
            0,
            0,
            0,
            NULL,
            0,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'bfc265bf-fc90-4215-a6d5-140ea0a5df2e' OR (EntityID = 'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9' AND Name = 'Credential')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'bfc265bf-fc90-4215-a6d5-140ea0a5df2e',
            'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9', -- Entity: Committees: Video Providers
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '60e7c192-6416-4034-8a83-cf5d17a9e2f2' OR (EntityID = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506' AND Name = 'Committee')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '60e7c192-6416-4034-8a83-cf5d17a9e2f2',
            'F4B63A74-6704-4CA9-97B5-D2EC745B0506', -- Entity: Committees: Action Items
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'a5412d4c-f1d3-4c31-8308-4fce90d28ce9' OR (EntityID = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506' AND Name = 'AssignedToPerson')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'a5412d4c-f1d3-4c31-8308-4fce90d28ce9',
            'F4B63A74-6704-4CA9-97B5-D2EC745B0506', -- Entity: Committees: Action Items
            100032,
            'AssignedToPerson',
            'Assigned To Person',
            NULL,
            'nvarchar',
            402,
            0,
            0,
            0,
            NULL,
            0,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '54d01dc9-d6d6-4f5f-bb44-28a0e8f28138' OR (EntityID = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506' AND Name = 'AssignedByPerson')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '54d01dc9-d6d6-4f5f-bb44-28a0e8f28138',
            'F4B63A74-6704-4CA9-97B5-D2EC745B0506', -- Entity: Committees: Action Items
            100033,
            'AssignedByPerson',
            'Assigned By Person',
            NULL,
            'nvarchar',
            402,
            0,
            0,
            1,
            NULL,
            0,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2c6d8642-d5b2-4969-b3b6-c1f041a53398' OR (EntityID = '5746F567-3A1B-4772-B8BA-D46D98A137DD' AND Name = 'PresenterPerson')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '2c6d8642-d5b2-4969-b3b6-c1f041a53398',
            '5746F567-3A1B-4772-B8BA-D46D98A137DD', -- Entity: Committees: Agenda Items
            100029,
            'PresenterPerson',
            'Presenter Person',
            NULL,
            'nvarchar',
            402,
            0,
            0,
            1,
            NULL,
            0,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'f44cdcc7-b2ee-43ff-9ab6-b2af4d45f1b9' OR (EntityID = '5746F567-3A1B-4772-B8BA-D46D98A137DD' AND Name = 'RootParentAgendaItemID')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'f44cdcc7-b2ee-43ff-9ab6-b2af4d45f1b9',
            '5746F567-3A1B-4772-B8BA-D46D98A137DD', -- Entity: Committees: Agenda Items
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'fc4bba54-997a-42c4-be57-82e085fee04a' OR (EntityID = '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42' AND Name = 'Person')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'fc4bba54-997a-42c4-be57-82e085fee04a',
            '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', -- Entity: Committees: Memberships
            100023,
            'Person',
            'Person',
            NULL,
            'nvarchar',
            402,
            0,
            0,
            0,
            NULL,
            0,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2a06335c-a44f-40f2-8fa1-0516dc8ab517' OR (EntityID = '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42' AND Name = 'Role')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '2a06335c-a44f-40f2-8fa1-0516dc8ab517',
            '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', -- Entity: Committees: Memberships
            100024,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'a9308bb2-4b2c-4287-ba5c-d2f14eb54b08' OR (EntityID = '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42' AND Name = 'Term')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'a9308bb2-4b2c-4287-ba5c-d2f14eb54b08',
            '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', -- Entity: Committees: Memberships
            100025,
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
      END;

/* SQL text to update existing entity fields from schema (16 scoped entities) */
EXEC [${mjSchema}].[spUpdateExistingEntityFieldsFromSchema] @ExcludedSchemaNames='sys,staging,${mjSchema},${mjSchema}_BizAppsCommon,${mjSchema}_BizAppsTasks', @EntityIDs='5746F567-3A1B-4772-B8BA-D46D98A137DD,9D005287-0D07-436B-B4D4-AAE31C42BFA7,F4B63A74-6704-4CA9-97B5-D2EC745B0506,8E6153B6-BC78-4AE8-B42D-34D7E2217555,3011BE1C-A871-4536-9855-2E58A28A206E,338F9B03-8689-4BD0-8EF1-03B84B90E4D9,02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906,80299A27-B207-4D99-A46B-4E5B8A2B5E62,349618AD-3F1C-481C-8406-302817363510,1D7F24C0-622E-41E0-BC38-29C2EEB1D442,A42F4A6F-C411-42F1-A977-4A5B1FB9FA38,EAD3EF14-1891-4389-A0F3-1984BC8CC13F,CF2605AB-3F2C-4D18-B663-60105BFC2BCC,31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42,B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9,F05BE747-6F2A-472E-8800-8A10D416EAA1';

/* SQL text to set default column width where needed */
EXEC [${mjSchema}].[spSetDefaultColumnWidthWhereNeeded] @ExcludedSchemaNames='sys,staging,${mjSchema},${mjSchema}_BizAppsCommon,${mjSchema}_BizAppsTasks';

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET IsNameField = 1
               WHERE ID = '2D138EEA-22A0-4985-B496-73CB2C6F5418'
               AND AutoUpdateIsNameField = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '2D138EEA-22A0-4985-B496-73CB2C6F5418'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'F50A2066-8E5F-48C1-94A4-C173C5F3A970'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'D944C5EB-D27B-448C-90FF-869D861B0F15'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'AF149482-D081-4D19-899F-85433EAC030C'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'A5412D4C-F1D3-4C31-8308-4FCE90D28CE9'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '2D138EEA-22A0-4985-B496-73CB2C6F5418'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'BF0A14AC-87D4-48EE-8EA0-209962A4F052'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'D944C5EB-D27B-448C-90FF-869D861B0F15'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'AF149482-D081-4D19-899F-85433EAC030C'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'A5412D4C-F1D3-4C31-8308-4FCE90D28CE9'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '54D01DC9-D6D6-4F5F-BB44-28A0E8F28138'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '2D138EEA-22A0-4985-B496-73CB2C6F5418'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'A5412D4C-F1D3-4C31-8308-4FCE90D28CE9'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '54D01DC9-D6D6-4F5F-BB44-28A0E8F28138'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'D944C5EB-D27B-448C-90FF-869D861B0F15'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'AF149482-D081-4D19-899F-85433EAC030C'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'EB569531-B35C-4797-BD00-B5532DF25159'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'E4604907-1997-41AA-9656-4003BE5CF219'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'EB569531-B35C-4797-BD00-B5532DF25159'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'E4604907-1997-41AA-9656-4003BE5CF219'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '80F1D657-2D81-491C-83DE-2FFC95273173'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'E4604907-1997-41AA-9656-4003BE5CF219'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET IsNameField = 1
               WHERE ID = '55E79111-2785-444B-894E-0086E17D8EF8'
               AND AutoUpdateIsNameField = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '7ED59FE7-D94C-4E68-BE00-E35E57B674DC'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'DC1E550D-11CF-4DC9-9567-C3FAA9CC7370'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '6C8E7E8D-3DD1-4D98-BB16-592688CBACC3'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'C0F91D5D-0825-4235-86CA-861210B8EB98'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '55E79111-2785-444B-894E-0086E17D8EF8'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '7ED59FE7-D94C-4E68-BE00-E35E57B674DC'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'C0F91D5D-0825-4235-86CA-861210B8EB98'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '55E79111-2785-444B-894E-0086E17D8EF8'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '55E79111-2785-444B-894E-0086E17D8EF8'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '7ED59FE7-D94C-4E68-BE00-E35E57B674DC'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET IsNameField = 1
               WHERE ID = '2282CCF3-A155-4AB7-AA2D-0DF01DE8B317'
               AND AutoUpdateIsNameField = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '2282CCF3-A155-4AB7-AA2D-0DF01DE8B317'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'C8A72305-27CA-4723-9FC2-D875CA1D963C'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'E5A28039-D728-4FCA-A43A-976D698469B6'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '246BA7A7-9946-4B43-8D56-593B2B4ECF9B'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'AE68F7D2-47AD-4543-A4A7-4FA5CDD04F62'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '2282CCF3-A155-4AB7-AA2D-0DF01DE8B317'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'C8A72305-27CA-4723-9FC2-D875CA1D963C'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '7CE16A2D-9C8B-4BF4-B32A-EF7C2D6FFBC0'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '3CDD410B-8A6B-4396-AB43-74AEB8FC4561'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '246BA7A7-9946-4B43-8D56-593B2B4ECF9B'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'AE68F7D2-47AD-4543-A4A7-4FA5CDD04F62'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '2282CCF3-A155-4AB7-AA2D-0DF01DE8B317'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'C8A72305-27CA-4723-9FC2-D875CA1D963C'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '246BA7A7-9946-4B43-8D56-593B2B4ECF9B'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'AE68F7D2-47AD-4543-A4A7-4FA5CDD04F62'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET IsNameField = 1
               WHERE ID = '0D6FDD50-B0B8-4D93-9B60-64B55AC8D41C'
               AND AutoUpdateIsNameField = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '43E0A6D1-42D9-4DA2-87B0-01B48E093C55'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '0D6FDD50-B0B8-4D93-9B60-64B55AC8D41C'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'B1714C81-CD83-47A4-9282-00D0441118C2'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '9C96E020-B3B7-4318-9FEC-44F98BF8882F'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '5A596D23-E8FA-4A00-83A8-BA71CE660975'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '0D6FDD50-B0B8-4D93-9B60-64B55AC8D41C'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '9C96E020-B3B7-4318-9FEC-44F98BF8882F'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '5A596D23-E8FA-4A00-83A8-BA71CE660975'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '2C6D8642-D5B2-4969-B3B6-C1F041A53398'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '0D6FDD50-B0B8-4D93-9B60-64B55AC8D41C'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '9C96E020-B3B7-4318-9FEC-44F98BF8882F'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '5A596D23-E8FA-4A00-83A8-BA71CE660975'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '2C6D8642-D5B2-4969-B3B6-C1F041A53398'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set categories for 10 fields */

-- UPDATE Entity Field Category Info Committees: Attendances.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6E7DC0CC-7F2E-4EFB-A9DA-344C1BFE5F2F' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Attendances.MeetingID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Meeting Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3255949F-4FEA-4838-9C1C-AD26020E7C83' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Attendances.PersonID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Attendee Information',
   GeneratedFormSection = 'Category',
   DisplayName = 'Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '54D5634B-5E5B-416F-A43B-61A3E9C27216' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Attendances.AttendanceStatus 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Attendance Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7ED59FE7-D94C-4E68-BE00-E35E57B674DC' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Attendances.JoinedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Attendance Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'DC1E550D-11CF-4DC9-9567-C3FAA9CC7370' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Attendances.LeftAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Attendance Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6C8E7E8D-3DD1-4D98-BB16-592688CBACC3' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Attendances.Notes 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Attendance Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C0F91D5D-0825-4235-86CA-861210B8EB98' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Attendances.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '48729EA3-AAD7-4ED5-A997-6C49AA56C682' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Attendances.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9120BD42-5706-46E2-B29F-AE4D32C37BFB' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Attendances.Person 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Attendee Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '55E79111-2785-444B-894E-0086E17D8EF8' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-users */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-users', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '9D005287-0D07-436B-B4D4-AAE31C42BFA7';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('4a90cf34-1b57-44d8-9ffb-1dd0c378dc56', '9D005287-0D07-436B-B4D4-AAE31C42BFA7', 'FieldCategoryInfo', '{"System Metadata":{"icon":"fa fa-cog","description":"System-managed audit and tracking fields"},"Meeting Details":{"icon":"fa fa-calendar","description":"Core information linking the record to a specific meeting"},"Attendee Information":{"icon":"fa fa-user","description":"Details identifying the person attending the meeting"},"Attendance Details":{"icon":"fa fa-check-circle","description":"Status and notes about the attendance"},"Attendance Timeline":{"icon":"fa fa-clock","description":"Timestamps for when the attendee joined and left"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('ae5c04c7-1311-4491-8757-f8b18e73ded7', '9D005287-0D07-436B-B4D4-AAE31C42BFA7', 'FieldCategoryIcons', '{"System Metadata":"fa fa-cog","Meeting Details":"fa fa-calendar","Attendee Information":"fa fa-user","Attendance Details":"fa fa-check-circle","Attendance Timeline":"fa fa-clock"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=true for NEW entity (category: primary, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 1, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '9D005287-0D07-436B-B4D4-AAE31C42BFA7';

/* Set categories for 16 fields */

-- UPDATE Entity Field Category Info Committees: Agenda Items.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5701E3CA-8A27-483E-83B7-82799B16DAEC' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.MeetingID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Agenda Structure',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2418B74A-C484-4CE8-88F5-D7B120FEC986' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.ParentAgendaItemID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Agenda Structure',
   GeneratedFormSection = 'Category',
   DisplayName = 'Parent Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B25029BC-3615-4FCC-B2B7-587E0D48055C' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.RootParentAgendaItemID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Agenda Structure',
   GeneratedFormSection = 'Category',
   DisplayName = 'Root Parent Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F44CDCC7-B2EE-43FF-9AB6-B2AF4D45F1B9' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.Sequence 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Agenda Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '43E0A6D1-42D9-4DA2-87B0-01B48E093C55' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.Title 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Agenda Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0D6FDD50-B0B8-4D93-9B60-64B55AC8D41C' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.Description 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Agenda Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '417D0165-007C-4C55-AA34-A602C010DC46' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.ItemType 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Agenda Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9C96E020-B3B7-4318-9FEC-44F98BF8882F' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.Status 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Agenda Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5A596D23-E8FA-4A00-83A8-BA71CE660975' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.PresenterPersonID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Presenter Information',
   GeneratedFormSection = 'Category',
   DisplayName = 'Presenter Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AD709E40-2208-40B8-A61B-1E8B6871060C' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.PresenterPerson 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Presenter Information',
   GeneratedFormSection = 'Category',
   DisplayName = 'Presenter Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2C6D8642-D5B2-4969-B3B6-C1F041A53398' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.DurationMinutes 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Timing',
   GeneratedFormSection = 'Category',
   DisplayName = 'Duration (Minutes)',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B1714C81-CD83-47A4-9282-00D0441118C2' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.RelatedDocumentURL 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Resources',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '871A5AB1-3D67-4D8A-8A40-D7A86A4FC3AA' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.Notes 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Resources',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5EE46944-4CF3-40B6-864B-A79D457F563C' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5C90C329-38A2-4082-A3C9-B507F9C39762' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Agenda Items.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '79C02FC4-B45B-4274-B7A9-1ABE9546739E' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-list */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-list', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '5746F567-3A1B-4772-B8BA-D46D98A137DD';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('4676780c-6807-4bc8-ac32-de91305dfacd', '5746F567-3A1B-4772-B8BA-D46D98A137DD', 'FieldCategoryInfo', '{"Agenda Structure":{"icon":"fa fa-sitemap","description":"Hierarchical relationships linking agenda items to meetings and parent items"},"Agenda Details":{"icon":"fa fa-align-left","description":"Core descriptive fields for each agenda entry"},"Presenter Information":{"icon":"fa fa-user","description":"Details about the person presenting the agenda item"},"Timing":{"icon":"fa fa-clock","description":"Time‑related information such as order and duration"},"Resources":{"icon":"fa fa-file","description":"Supporting documents, notes and external links"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit and tracking fields"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('e9f520c3-6774-4596-b7b2-56c95919a7c6', '5746F567-3A1B-4772-B8BA-D46D98A137DD', 'FieldCategoryIcons', '{"Agenda Structure":"fa fa-sitemap","Agenda Details":"fa fa-align-left","Presenter Information":"fa fa-user","Timing":"fa fa-clock","Resources":"fa fa-file","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=true for NEW entity (category: primary, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 1, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '5746F567-3A1B-4772-B8BA-D46D98A137DD';

/* Set categories for 8 fields */

-- UPDATE Entity Field Category Info Committees: Artifact Types.Name 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Artifact Type Info',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '80F1D657-2D81-491C-83DE-2FFC95273173' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifact Types.Description 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Artifact Type Info',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'EB569531-B35C-4797-BD00-B5532DF25159' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifact Types.IconClass 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Artifact Type Info',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E4604907-1997-41AA-9656-4003BE5CF219' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifact Types.ExtendedEntity 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Extension Settings',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '024929B7-65D0-4ACE-9F27-CBEB3FA4F1E2' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifact Types.ExtendedEntityID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Extension Settings',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C3731E81-33C0-4ECA-BB78-E83EA76D2A4B' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifact Types.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2509ACCE-9150-4005-BD4E-CA09BA4C90C3' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifact Types.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '175DF0AB-F9A3-4FB8-B3A5-A4B27E81AA33' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifact Types.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5B65E3A3-B44C-4BDA-93A1-3F79D044C50E' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-file-alt */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-file-alt', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '8E6153B6-BC78-4AE8-B42D-34D7E2217555';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('2e99c6c0-a81b-4b6e-a929-d50446f8e019', '8E6153B6-BC78-4AE8-B42D-34D7E2217555', 'FieldCategoryInfo', '{"Artifact Type Info":{"icon":"fa fa-tag","description":"Core definition of the committee artifact type, including name, description and visual icon"},"Extension Settings":{"icon":"fa fa-puzzle-piece","description":"Configuration for optional extension entity that adds type‑specific fields"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit and identifier fields"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('f576abb8-7b27-430f-afe1-7a619db9cdc7', '8E6153B6-BC78-4AE8-B42D-34D7E2217555', 'FieldCategoryIcons', '{"Artifact Type Info":"fa fa-tag","Extension Settings":"fa fa-puzzle-piece","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=false for NEW entity (category: reference, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 0, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '8E6153B6-BC78-4AE8-B42D-34D7E2217555';

/* Set categories for 18 fields */

-- UPDATE Entity Field Category Info Committees: Action Items.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6B97E2F2-A62D-479C-89FF-FD01D3C9595B' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.CommitteeID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Context',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0BEBC8B0-6113-48A9-8B7F-1FD3135E7ED5' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.MeetingID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Context',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7E649DC5-FD61-4B87-B65E-ACE72CDD2305' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.AgendaItemID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Context',
   GeneratedFormSection = 'Category',
   DisplayName = 'Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '19336F80-4B92-4650-80B1-2C1A861916A8' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.Title 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Action Item Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2D138EEA-22A0-4985-B496-73CB2C6F5418' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.Description 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Action Item Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BF0A14AC-87D4-48EE-8EA0-209962A4F052' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.AssignedToPersonID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Assignment',
   GeneratedFormSection = 'Category',
   DisplayName = 'Assigned To Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0AF90B52-D892-4E9E-92BA-6976F9E9CED1' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.AssignedByPersonID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Assignment',
   GeneratedFormSection = 'Category',
   DisplayName = 'Assigned By Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FFFE3501-808D-4421-9157-250E2F700E75' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.DueDate 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Schedule',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F50A2066-8E5F-48C1-94A4-C173C5F3A970' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.Priority 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Schedule',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D944C5EB-D27B-448C-90FF-869D861B0F15' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.Status 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Progress',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AF149482-D081-4D19-899F-85433EAC030C' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.CompletedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Progress',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '08714C0A-CDEA-4139-9040-C39C0241E2A3' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.CompletionNotes 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Progress',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4F719AC6-41CB-4624-B4FF-43BC84FC0DC2' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '454BF1C0-1ED9-49A5-960D-69E2950B9BC6' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D1963121-46D2-48E5-BBF7-E3E5A78777AF' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.Committee 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Display Values',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '60E7C192-6416-4034-8A83-CF5D17A9E2F2' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.AssignedToPerson 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Display Values',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A5412D4C-F1D3-4C31-8308-4FCE90D28CE9' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Action Items.AssignedByPerson 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Display Values',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '54D01DC9-D6D6-4F5F-BB44-28A0E8F28138' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-tasks */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-tasks', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('50680941-aa78-409c-a34d-3b3366eed824', 'F4B63A74-6704-4CA9-97B5-D2EC745B0506', 'FieldCategoryInfo', '{"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"},"Committee Context":{"icon":"fa fa-building","description":"Identifiers linking the action item to its committee, meeting, and agenda"},"Action Item Details":{"icon":"fa fa-align-left","description":"Core description fields that define what the action item is"},"Assignment":{"icon":"fa fa-user-check","description":"People responsible for and creating the action item"},"Schedule":{"icon":"fa fa-calendar-alt","description":"Timing and priority information for the action item"},"Progress":{"icon":"fa fa-flag-checkered","description":"Current status and completion details of the action item"},"Display Values":{"icon":"fa fa-eye","description":"Denormalized human‑readable names used for UI display"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('cbdd3c60-4db5-4723-9fec-9535890a2b1a', 'F4B63A74-6704-4CA9-97B5-D2EC745B0506', 'FieldCategoryIcons', '{"System Metadata":"fa fa-cog","Committee Context":"fa fa-building","Action Item Details":"fa fa-align-left","Assignment":"fa fa-user-check","Schedule":"fa fa-calendar-alt","Progress":"fa fa-flag-checkered","Display Values":"fa fa-eye"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=true for NEW entity (category: primary, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 1, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = 'F4B63A74-6704-4CA9-97B5-D2EC745B0506';

/* Set categories for 20 fields */

-- UPDATE Entity Field Category Info Committees: Artifacts.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F63C416D-847E-4F6F-9850-867EDC096B09' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E5A28039-D728-4FCA-A43A-976D698469B6' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6E640CE7-04B2-49B8-B876-D3174B3DF97A' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.Title 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Artifact Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2282CCF3-A155-4AB7-AA2D-0DF01DE8B317' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.Description 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Artifact Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6492EAF4-5197-40E8-B0B0-E4A6CC55CCEB' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.ArtifactTypeID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Artifact Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Artifact Type',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F47E91D5-DD83-419A-A601-566BF750699D' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.ArtifactType 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Artifact Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '246BA7A7-9946-4B43-8D56-593B2B4ECF9B' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.Provider 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'External Reference',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C8A72305-27CA-4723-9FC2-D875CA1D963C' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.ExternalID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'External Reference',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7CE16A2D-9C8B-4BF4-B32A-EF7C2D6FFBC0' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.URL 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'External Reference',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '3CDD410B-8A6B-4396-AB43-74AEB8FC4561' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.MimeType 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'File Metadata',
   GeneratedFormSection = 'Category',
   DisplayName = 'MIME Type',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BF0DE1CF-077F-4431-89B5-C78F5FA421CB' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.FileSize 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'File Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '05BB5712-79A3-4F35-9706-204DA0DC45CA' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.CommitteeID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Relationships',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B4ECAEEE-2530-44D0-A597-BD2CF2B93F3A' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.Committee 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Relationships',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '383E1A9F-96C7-4CE4-AD59-54A1C4E61F39' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.MeetingID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Relationships',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F7F8C47A-C5F8-48E9-BCA6-DEC53A9A75D3' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.AgendaItemID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Relationships',
   GeneratedFormSection = 'Category',
   DisplayName = 'Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D94DCDEE-55C0-4C26-BFCE-A24EF4302F3B' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.TaskID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Relationships',
   GeneratedFormSection = 'Category',
   DisplayName = 'Task',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CEEFEDF4-D8A7-419C-8239-2A0BC5CFC8CE' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.Task 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Relationships',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '22BE104F-2980-404C-8E6A-BE0B6C81CDA5' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.UploadedByPersonID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Relationships',
   GeneratedFormSection = 'Category',
   DisplayName = 'Uploaded By',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2BA603FF-1546-4673-98D3-CB116849C094' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Artifacts.UploadedByPerson 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Relationships',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AE68F7D2-47AD-4543-A4A7-4FA5CDD04F62' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-paperclip */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-paperclip', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '3011BE1C-A871-4536-9855-2E58A28A206E';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('96843f76-28b8-416f-9ddd-d0a91c94f5ac', '3011BE1C-A871-4536-9855-2E58A28A206E', 'FieldCategoryInfo', '{"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"},"Artifact Details":{"icon":"fa fa-file-alt","description":"Core descriptive information about the artifact"},"External Reference":{"icon":"fa fa-link","description":"Links and identifiers that reference external sources"},"File Metadata":{"icon":"fa fa-file","description":"Technical properties of the stored file"},"Relationships":{"icon":"fa fa-users","description":"Links to related committees, meetings, tasks, and uploader"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('ebb462af-f980-4bbc-a71c-7b2aeb55d06c', '3011BE1C-A871-4536-9855-2E58A28A206E', 'FieldCategoryIcons', '{"System Metadata":"fa fa-cog","Artifact Details":"fa fa-file-alt","External Reference":"fa fa-link","File Metadata":"fa fa-file","Relationships":"fa fa-users"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=true for NEW entity (category: supporting, confidence: medium) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 1, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '3011BE1C-A871-4536-9855-2E58A28A206E';

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '963D5F6A-9B40-44E5-8611-64F666643D44'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '7B1AEEAB-182A-4A20-8E7A-BF0B997DD21D'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'EF79C5E1-78FA-4412-8132-56115C5D980F'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '72F639EC-0EB2-41A9-8EE6-D9879043296C'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'E4EA847C-BF58-4C01-9278-3766C7205224'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '963D5F6A-9B40-44E5-8611-64F666643D44'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'A34D3C72-A08F-4E99-B5D7-75FF66D94857'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '4F67275D-9504-4C15-9BE6-4F4F752F4049'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '34A962CB-28D2-4E8D-8B2F-806F2AEA1CFD'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '963D5F6A-9B40-44E5-8611-64F666643D44'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '4F67275D-9504-4C15-9BE6-4F4F752F4049'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'A34D3C72-A08F-4E99-B5D7-75FF66D94857'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET IsNameField = 1
               WHERE ID = '17CD2D1F-0E72-4337-8E8A-0F7EE643B592'
               AND AutoUpdateIsNameField = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '17CD2D1F-0E72-4337-8E8A-0F7EE643B592'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'B34DD19B-8EDF-4276-9ABC-60D616322638'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '2A285F17-FC53-4796-9075-6DB3579AD23C'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '3374C5A3-3A8A-4CE7-8CFB-7EBD51CF7465'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '880DD114-CDDE-49DA-A0FF-13A8D41F1C43'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '17CD2D1F-0E72-4337-8E8A-0F7EE643B592'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '3374C5A3-3A8A-4CE7-8CFB-7EBD51CF7465'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '4D5369F2-72F9-42D5-A6E6-F6043CC00E69'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '880DD114-CDDE-49DA-A0FF-13A8D41F1C43'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '25C85034-2D44-4EDA-8B6E-71A3EB047989'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '17CD2D1F-0E72-4337-8E8A-0F7EE643B592'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '4D5369F2-72F9-42D5-A6E6-F6043CC00E69'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '880DD114-CDDE-49DA-A0FF-13A8D41F1C43'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '25C85034-2D44-4EDA-8B6E-71A3EB047989'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET IsNameField = 1
               WHERE ID = 'FC4BBA54-997A-42C4-BE57-82E085FEE04A'
               AND AutoUpdateIsNameField = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IsNameField = 1
               WHERE ID = '2A06335C-A44F-40F2-8FA1-0516DC8AB517'
               AND AutoUpdateIsNameField = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IsNameField = 1
               WHERE ID = 'A9308BB2-4B2C-4287-BA5C-D2F14EB54B08'
               AND AutoUpdateIsNameField = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '8287DE43-B082-41FD-8803-6EE9936DE135'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '0C4D09B0-492A-4C26-ABF8-E48DC33F9C08'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '0608A3E1-F79E-4336-8AE0-96880839DE0F'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'FC4BBA54-997A-42C4-BE57-82E085FEE04A'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '2A06335C-A44F-40F2-8FA1-0516DC8AB517'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'A9308BB2-4B2C-4287-BA5C-D2F14EB54B08'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '0608A3E1-F79E-4336-8AE0-96880839DE0F'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '87424F57-F767-4C17-A32B-001D45A2CD13'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'FC4BBA54-997A-42C4-BE57-82E085FEE04A'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '2A06335C-A44F-40F2-8FA1-0516DC8AB517'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'A9308BB2-4B2C-4287-BA5C-D2F14EB54B08'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'FC4BBA54-997A-42C4-BE57-82E085FEE04A'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '2A06335C-A44F-40F2-8FA1-0516DC8AB517'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'A9308BB2-4B2C-4287-BA5C-D2F14EB54B08'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '0608A3E1-F79E-4336-8AE0-96880839DE0F'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET IsNameField = 1
               WHERE ID = 'E8674472-D4BD-49FA-A281-9FE6739F51F8'
               AND AutoUpdateIsNameField = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'E8674472-D4BD-49FA-A281-9FE6739F51F8'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '0F1F905E-9785-4FB3-BACB-4F5FF7F7DA7B'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '1464AC1B-40D1-4BC9-8297-908D92490335'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'E8674472-D4BD-49FA-A281-9FE6739F51F8'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '6DEBE838-AEBE-4ECF-A73D-4C01A5195E0B'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'E8674472-D4BD-49FA-A281-9FE6739F51F8'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET IsNameField = 1
               WHERE ID = '0F919FA7-8A2E-4404-883A-132E2808F0C1'
               AND AutoUpdateIsNameField = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IsNameField = 1
               WHERE ID = '688C4A87-2A82-41DC-8C87-24162735EDAB'
               AND AutoUpdateIsNameField = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '688C4A87-2A82-41DC-8C87-24162735EDAB'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '85DD403D-C8E9-4762-A2E3-29FC9FDC83E8'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '25B5F450-9FC1-485A-966F-132323F6EAB0'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '0F919FA7-8A2E-4404-883A-132E2808F0C1'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '688C4A87-2A82-41DC-8C87-24162735EDAB'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '6C4A4717-E7F5-4EB2-A105-88C235B2F41E'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '0F919FA7-8A2E-4404-883A-132E2808F0C1'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '0F919FA7-8A2E-4404-883A-132E2808F0C1'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set categories for 10 fields */

-- UPDATE Entity Field Category Info Committees: Minutes.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9F6D0E11-2D44-4767-9D78-81F5DA9396F3' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Minutes.ArtifactID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Document Reference',
   GeneratedFormSection = 'Category',
   DisplayName = 'Artifact',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AE3D6799-8A28-4F16-AABB-2AFE2B1DDF34' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Minutes.MeetingID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Meeting Context',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5361310D-7E27-42BB-8E56-822A360738A7' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Minutes.Content 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Minutes Content',
   GeneratedFormSection = 'Category',
   ExtendedType = 'Code',
   CodeType = 'Other'
WHERE 
   ID = '38A558CE-FF5E-45F0-8286-55E0855FBEC0' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Minutes.ApprovalStatus 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Approval Tracking',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E8674472-D4BD-49FA-A281-9FE6739F51F8' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Minutes.ApprovedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Approval Tracking',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0F1F905E-9785-4FB3-BACB-4F5FF7F7DA7B' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Minutes.ApprovedByMeetingID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Approval Tracking',
   GeneratedFormSection = 'Category',
   DisplayName = 'Approved By Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1464AC1B-40D1-4BC9-8297-908D92490335' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Minutes.Notes 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Minutes Content',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6DEBE838-AEBE-4ECF-A73D-4C01A5195E0B' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Minutes.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '075BB0B8-8682-41B9-8C4B-7CAB5FDBB9E6' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Minutes.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FB4B25BB-C17D-4449-B9C8-6F4202A407DD' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-file-alt */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-file-alt', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '338F9B03-8689-4BD0-8EF1-03B84B90E4D9';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('51adb27e-8a66-4d6d-bcb8-4542cb639463', '338F9B03-8689-4BD0-8EF1-03B84B90E4D9', 'FieldCategoryInfo', '{"Document Reference":{"icon":"fa fa-link","description":"Links to external artifacts that store or supplement the minutes"},"Meeting Context":{"icon":"fa fa-users","description":"Identifiers tying the minutes to a specific meeting event"},"Minutes Content":{"icon":"fa fa-file-alt","description":"Core textual content of the minutes and any supplementary notes"},"Approval Tracking":{"icon":"fa fa-check-circle","description":"Fields that capture approval status, timestamps and approving meeting"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit fields"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('286e7d36-eac0-4368-9883-4faef208d39f', '338F9B03-8689-4BD0-8EF1-03B84B90E4D9', 'FieldCategoryIcons', '{"Document Reference":"fa fa-link","Meeting Context":"fa fa-users","Minutes Content":"fa fa-file-alt","Approval Tracking":"fa fa-check-circle","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=true for NEW entity (category: primary, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 1, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '338F9B03-8689-4BD0-8EF1-03B84B90E4D9';

/* Set categories for 14 fields */

-- UPDATE Entity Field Category Info Committees: Memberships.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4B609554-36F6-4884-BC6D-9A4BAAC32798' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.PersonID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Person Assignment',
   GeneratedFormSection = 'Category',
   DisplayName = 'Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '51F7B196-9536-4012-83AA-E5D8C11EBB45' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.RoleID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Role Assignment',
   GeneratedFormSection = 'Category',
   DisplayName = 'Role',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '750E3103-DE75-48E9-8806-E5D096CF72B9' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.TermID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Term Assignment',
   GeneratedFormSection = 'Category',
   DisplayName = 'Term',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2CEE9B5E-6008-45BA-9E82-276E901E0457' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.StartDate 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Membership Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8287DE43-B082-41FD-8803-6EE9936DE135' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.EndDate 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Membership Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0C4D09B0-492A-4C26-ABF8-E48DC33F9C08' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.Status 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Membership Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0608A3E1-F79E-4336-8AE0-96880839DE0F' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.EndReason 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Membership Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4BB2DA57-F4B7-4D99-81E2-A4034972D8D9' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.Notes 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Additional Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '87424F57-F767-4C17-A32B-001D45A2CD13' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'EB60ED17-6382-4086-90A1-4176A9685AAA' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '930B32E3-145E-40CF-89A8-08F8E01E8BC0' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.Person 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Person Assignment',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FC4BBA54-997A-42C4-BE57-82E085FEE04A' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.Role 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Role Assignment',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2A06335C-A44F-40F2-8FA1-0516DC8AB517' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Memberships.Term 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Term Assignment',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A9308BB2-4B2C-4287-BA5C-D2F14EB54B08' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-users */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-users', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('e413ea89-6305-452e-89f1-2291f50c6bf0', '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', 'FieldCategoryInfo', '{"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields tracking creation and modification timestamps"},"Person Assignment":{"icon":"fa fa-user","description":"Links and displays the person involved in the committee membership"},"Role Assignment":{"icon":"fa fa-id-badge","description":"Defines the role the person holds within the committee"},"Term Assignment":{"icon":"fa fa-calendar-alt","description":"Specifies the election or service term for the committee membership"},"Membership Timeline":{"icon":"fa fa-calendar","description":"Start and end dates defining the period of membership"},"Membership Status":{"icon":"fa fa-flag-checkered","description":"Current status and termination reason of the membership"},"Additional Information":{"icon":"fa fa-align-left","description":"Free‑form notes and comments about the membership"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('da27007c-5d5e-4d47-a97b-df9fa720ac6d', '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42', 'FieldCategoryIcons', '{"System Metadata":"fa fa-cog","Person Assignment":"fa fa-user","Role Assignment":"fa fa-id-badge","Term Assignment":"fa fa-calendar-alt","Membership Timeline":"fa fa-calendar","Membership Status":"fa fa-flag-checkered","Additional Information":"fa fa-align-left"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=true for NEW entity (category: primary, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 1, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '31A4F9B1-B185-4BDD-BDE4-EDE7F8E03C42';

/* Set categories for 17 fields */

-- UPDATE Entity Field Category Info Committees: Comments.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '260D269C-9F9C-4941-855A-EAE5D2581889' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Comments.CommitteeID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Context References',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6C01F98D-C2AF-49A4-83CB-AF9C849C96B9' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Comments.MeetingID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Context References',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9B932403-B185-451D-8375-207394CA6A09' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Comments.AgendaItemID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Context References',
   GeneratedFormSection = 'Category',
   DisplayName = 'Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4BE7E25A-B67A-4A45-81FE-EFA5B6F9BFD4' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Comments.TaskID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Context References',
   GeneratedFormSection = 'Category',
   DisplayName = 'Task',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9FE98BD5-1CA5-476A-A402-D203E206355D' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Comments.ArtifactID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Context References',
   GeneratedFormSection = 'Category',
   DisplayName = 'Artifact',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '791FA583-6370-4793-899A-CFF1CCA8CD29' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Comments.ParentCommentID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Threading',
   GeneratedFormSection = 'Category',
   DisplayName = 'Parent Comment',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '453E2B0E-BDB2-4A4B-A879-C15883CD6D46' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Comments.RootParentCommentID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Threading',
   GeneratedFormSection = 'Category',
   DisplayName = 'Root Parent Comment',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '938F1155-2FBF-4D17-910B-612547255D97' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Comments.PersonID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Author Information',
   GeneratedFormSection = 'Category',
   DisplayName = 'Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '44F607D6-0D6A-4A99-A1BC-0E248E100C63' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Comments.CommentText 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Comment Content',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '688C4A87-2A82-41DC-8C87-24162735EDAB' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Comments.MentionedPersonIDs 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Comment Content',
   GeneratedFormSection = 'Category',
   DisplayName = 'Mentioned Persons',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6C4A4717-E7F5-4EB2-A105-88C235B2F41E' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Comments.IsResolved 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Comment Status',
   GeneratedFormSection = 'Category',
   DisplayName = 'Resolved',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '85DD403D-C8E9-4762-A2E3-29FC9FDC83E8' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Comments.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '25B5F450-9FC1-485A-966F-132323F6EAB0' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Comments.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1C812B15-9EFC-4A79-91A8-95F9503F3780' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Comments.Committee 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Display Values',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E5A4E683-295B-42D3-B63E-6AA6577D3AC5' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Comments.Task 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Display Values',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '72C9BE61-50B6-4C76-9603-B78B43F16058' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Comments.Person 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Display Values',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0F919FA7-8A2E-4404-883A-132E2808F0C1' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-comment */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-comment', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '349618AD-3F1C-481C-8406-302817363510';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('4767dcdd-d072-49db-be83-0cdbb5ffd56b', '349618AD-3F1C-481C-8406-302817363510', 'FieldCategoryInfo', '{"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"},"Context References":{"icon":"fa fa-link","description":"Links the comment to its related committee, meeting, agenda item, task, or artifact"},"Threading":{"icon":"fa fa-sitemap","description":"Fields that establish comment hierarchy and thread structure"},"Author Information":{"icon":"fa fa-user","description":"Details about the person who authored the comment"},"Comment Content":{"icon":"fa fa-align-left","description":"Main textual content of the comment and any mentions"},"Comment Status":{"icon":"fa fa-flag-checkered","description":"Resolution state of the discussion item"},"Display Values":{"icon":"fa fa-eye","description":"Human‑readable names for related entities used in UI display"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('27c60348-03e0-423a-bf9d-018fb6c147be', '349618AD-3F1C-481C-8406-302817363510', 'FieldCategoryIcons', '{"System Metadata":"fa fa-cog","Context References":"fa fa-link","Threading":"fa fa-sitemap","Author Information":"fa fa-user","Comment Content":"fa fa-align-left","Comment Status":"fa fa-flag-checkered","Display Values":"fa fa-eye"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=true for NEW entity (category: primary, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 1, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '349618AD-3F1C-481C-8406-302817363510';

/* Set categories for 21 fields */

-- UPDATE Entity Field Category Info Committees: Meetings.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0788350D-FC26-463A-ADB3-E645895DCA5F' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.CommitteeID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Reference',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '22A63060-2EF9-4112-9D48-E5CEB876FBD2' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.Committee 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Reference',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '25C85034-2D44-4EDA-8B6E-71A3EB047989' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.Title 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Meeting Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '17CD2D1F-0E72-4337-8E8A-0F7EE643B592' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.Description 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Meeting Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BC8C3498-5FA6-403E-A2B0-E94234260C92' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.StartDateTime 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Schedule',
   GeneratedFormSection = 'Category',
   DisplayName = 'Start Date & Time',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B34DD19B-8EDF-4276-9ABC-60D616322638' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.EndDateTime 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Schedule',
   GeneratedFormSection = 'Category',
   DisplayName = 'End Date & Time',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2A285F17-FC53-4796-9075-6DB3579AD23C' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.TimeZone 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Schedule',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0B90E7D8-723F-4367-A708-52E7B65AE140' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.LocationType 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Location',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '94950587-3760-40B5-B9E8-8C80078A7291' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.LocationText 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Location',
   GeneratedFormSection = 'Category',
   DisplayName = 'Location',
   ExtendedType = 'GeoAddress',
   CodeType = NULL
WHERE 
   ID = '3374C5A3-3A8A-4CE7-8CFB-7EBD51CF7465' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.VideoProvider 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Virtual Meeting',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4D5369F2-72F9-42D5-A6E6-F6043CC00E69' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.VideoProviderID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Virtual Meeting',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A0FDC791-DD72-4A4D-BEA6-53162CD2D0DE' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.VideoProvider_Virtual 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Virtual Meeting',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0D463EB3-ABA8-475A-9A01-2F5B522E7747' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.VideoMeetingID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Virtual Meeting',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2D70BE08-0848-402C-85DE-77C37FE2F5F9' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.VideoJoinURL 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Virtual Meeting',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '04D0FD69-60D9-4A19-B13B-BE8EA48220AA' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.VideoRecordingURL 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Virtual Meeting',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = 'E1B3B093-05F6-474B-9B65-22E104054C3E' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.TranscriptURL 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Virtual Meeting',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '831DA764-9A37-49EF-A98B-21F2031D1AA8' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.Status 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Meeting Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '880DD114-CDDE-49DA-A0FF-13A8D41F1C43' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.CalendarEventID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Meeting Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '86D0E61F-70E6-4CAF-ADBA-E63C4DAB06F5' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B2BE578C-9C62-4391-810C-46510B6A99B3' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Meetings.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'ABE7D755-DC72-44F5-AFA2-1F581D1025EE' AND AutoUpdateCategory = 1;

/* Set SupportsGeoCoding = true for Committees: Meetings */

            UPDATE [${mjSchema}].[Entity]
            SET [SupportsGeoCoding] = 1
            WHERE [ID] = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND [AutoUpdateSupportsGeoCoding] = 1;

/* Set entity icon to fa fa-calendar-alt */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-calendar-alt', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = 'F05BE747-6F2A-472E-8800-8A10D416EAA1';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('7553c564-2070-46b6-a5c7-95af897ccd77', 'F05BE747-6F2A-472E-8800-8A10D416EAA1', 'FieldCategoryInfo', '{"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"},"Committee Reference":{"icon":"fa fa-users","description":"Links the meeting to its parent committee and displays the committee name"},"Meeting Details":{"icon":"fa fa-align-left","description":"Core descriptive information such as title and agenda"},"Schedule":{"icon":"fa fa-calendar","description":"Date, time, and time‑zone information for the meeting"},"Location":{"icon":"fa fa-map-marker-alt","description":"Physical location details when the meeting is in‑person"},"Virtual Meeting":{"icon":"fa fa-video","description":"Video‑conferencing provider details and URLs for joining, recording, and transcripts"},"Meeting Status":{"icon":"fa fa-flag-checkered","description":"Current status and calendar integration identifiers"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('e2534387-5aca-4432-8982-38b4b7d3ea2a', 'F05BE747-6F2A-472E-8800-8A10D416EAA1', 'FieldCategoryIcons', '{"System Metadata":"fa fa-cog","Committee Reference":"fa fa-users","Meeting Details":"fa fa-align-left","Schedule":"fa fa-calendar","Location":"fa fa-map-marker-alt","Virtual Meeting":"fa fa-video","Meeting Status":"fa fa-flag-checkered"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=true for NEW entity (category: primary, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 1, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = 'F05BE747-6F2A-472E-8800-8A10D416EAA1';

/* Set categories for 18 fields */

-- UPDATE Entity Field Category Info Committees: Committees.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '85BDBE90-5784-40B2-94FB-E4CFFA402EA8' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.Name 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Profile',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '34A962CB-28D2-4E8D-8B2F-806F2AEA1CFD' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.Description 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Profile',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8D1FCAD6-9CE9-4CBA-9D52-C7F01D3632BB' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.TypeID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Profile',
   GeneratedFormSection = 'Category',
   DisplayName = 'Type',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CAA9B2BC-CBB1-4DD3-9406-29F4C57A2776' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.Type 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Profile',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'DF06A116-2B3A-4DFE-A98A-C1D38D3F0ED3' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.Status 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Profile',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '963D5F6A-9B40-44E5-8611-64F666643D44' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.IsPublic 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Profile',
   GeneratedFormSection = 'Category',
   DisplayName = 'Public',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7B1AEEAB-182A-4A20-8E7A-BF0B997DD21D' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.CharterDocumentURL 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Profile',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '726FB23A-13C3-481F-8E24-CBA573016D05' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.MissionStatement 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Profile',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E4EA847C-BF58-4C01-9278-3766C7205224' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.ParentCommitteeID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Hierarchy',
   GeneratedFormSection = 'Category',
   DisplayName = 'Parent Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BF45D3A7-9B28-4C2E-9648-E2B2191C64D2' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.ParentCommittee 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Hierarchy',
   GeneratedFormSection = 'Category',
   DisplayName = 'Parent Committee Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A34D3C72-A08F-4E99-B5D7-75FF66D94857' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.RootParentCommitteeID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Hierarchy',
   GeneratedFormSection = 'Category',
   DisplayName = 'Root Parent Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '997BF1A6-7A33-4080-879C-369463409E25' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.OrganizationID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Hierarchy',
   GeneratedFormSection = 'Category',
   DisplayName = 'Organization',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F2ABB2EB-D0A0-4515-90FC-1D4670414A35' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.Organization 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Hierarchy',
   GeneratedFormSection = 'Category',
   DisplayName = 'Organization Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4F67275D-9504-4C15-9BE6-4F4F752F4049' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.FormationDate 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'EF79C5E1-78FA-4412-8132-56115C5D980F' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.DissolutionDate 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '72F639EC-0EB2-41A9-8EE6-D9879043296C' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '559240D2-F23C-41F8-B0F4-B2BF53CF881B' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Committees.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '22C6C3C0-C2A6-4005-B38C-4E25A54A87E1' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-users-cog */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-users-cog', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('db774092-e182-4e7f-a25b-42df1253dfcd', 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', 'FieldCategoryInfo', '{"Committee Profile":{"icon":"fa fa-file-alt","description":"Core descriptive attributes of the committee such as name, type, status, charter link and mission"},"Hierarchy":{"icon":"fa fa-sitemap","description":"Relationships to parent committees and the owning organization, including ancestor identifiers"},"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields and key dates managed by the system"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('06d23985-fdf5-4bca-90a3-edf51ad96bf3', 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38', 'FieldCategoryIcons', '{"Committee Profile":"fa fa-file-alt","Hierarchy":"fa fa-sitemap","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=true for NEW entity (category: primary, confidence: medium) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 1, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = 'A42F4A6F-C411-42F1-A977-4A5B1FB9FA38';

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '6DA4C45C-623D-4FFC-9D07-5D0B2A97C984'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '38ED23EE-F6CA-405A-A8B7-C49A9F3D5FB6'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'F7589D48-877C-4F70-AC15-D2423EBB4E13'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'E2E3B1A3-B3DF-4F70-B4DE-EA940F2853D7'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '6ADADE18-EF8A-4ED5-8994-CEA52F5EB2BA'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'CB0221FE-0167-49E1-80C7-2F8F5D3688EB'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'BBB912DF-DAE0-4CD9-915F-4D10705394AE'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'BBB912DF-DAE0-4CD9-915F-4D10705394AE'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '4F41559A-018D-4C41-91D5-9B40B4BC96AE'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'BBB912DF-DAE0-4CD9-915F-4D10705394AE'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '53A4EAE5-0B76-4C9B-A787-188CD1C3EFE6'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '04F3F75D-20D7-4A65-958F-F79F563B2B91'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'C9F8BC65-F002-4C8E-85A2-B97A88176197'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'BFC265BF-FC90-4215-A6D5-140EA0A5DF2E'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '1DCE37F4-2759-4719-96CC-4DA8B386528C'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'BFC265BF-FC90-4215-A6D5-140EA0A5DF2E'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET IsNameField = 1
               WHERE ID = '855672E5-93D7-476A-9A84-E5B70C117CFF'
               AND AutoUpdateIsNameField = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '855672E5-93D7-476A-9A84-E5B70C117CFF'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '84428F50-1C25-46B8-A9CB-ED285792AFBA'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '0CF4EDBE-333E-47E3-B210-57A7C6362884'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '44E3F21E-8463-46F8-BD58-BA0AD86A2042'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '479CC4F6-86AA-4584-B156-3629D194E1AC'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '855672E5-93D7-476A-9A84-E5B70C117CFF'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '84428F50-1C25-46B8-A9CB-ED285792AFBA'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '271E01A1-4529-413F-B09B-DBA0A93D3FDD'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '855672E5-93D7-476A-9A84-E5B70C117CFF'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'Exact'
               WHERE ID = '84428F50-1C25-46B8-A9CB-ED285792AFBA'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'A7427180-CE31-4EEA-BB03-A4CD524C2250'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '6464C3B1-2E2C-4B51-B4D4-61825D57A0ED'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'EB7D567F-57BA-469E-A736-F403B2692792'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'A9E6D7F1-7112-4155-BC48-139FCA459C65'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = 'A7427180-CE31-4EEA-BB03-A4CD524C2250'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '67318BCF-1A43-4A52-B373-A3FD9E875504'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set categories for 9 fields */

-- UPDATE Entity Field Category Info Committees: Roles.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D3678C5E-5E8E-476F-B717-001D7707FAED' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Roles.Name 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Role Definition',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E2E3B1A3-B3DF-4F70-B4DE-EA940F2853D7' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Roles.Description 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Role Definition',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '63781997-8686-4DCA-A40F-3CF049F47E1F' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Roles.IsOfficer 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Role Permissions',
   GeneratedFormSection = 'Category',
   DisplayName = 'Officer Role',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6DA4C45C-623D-4FFC-9D07-5D0B2A97C984' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Roles.IsVotingRole 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Role Permissions',
   GeneratedFormSection = 'Category',
   DisplayName = 'Voting Role',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '38ED23EE-F6CA-405A-A8B7-C49A9F3D5FB6' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Roles.DefaultPermissionsJSON 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Role Permissions',
   GeneratedFormSection = 'Category',
   DisplayName = 'Default Permissions',
   ExtendedType = NULL,
   CodeType = 'Other'
WHERE 
   ID = 'D9BD7275-067C-481E-B753-758558590F27' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Roles.Sequence 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Display Settings',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F7589D48-877C-4F70-AC15-D2423EBB4E13' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Roles.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E560AC48-F275-4C2A-9E7A-D48E22342C37' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Roles.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '66FA2B5B-0D6F-4A0E-ACB1-EE5E7F087D3A' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-id-badge */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-id-badge', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = 'CF2605AB-3F2C-4D18-B663-60105BFC2BCC';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('86473a87-2ab2-4ded-a620-c9ede50805f4', 'CF2605AB-3F2C-4D18-B663-60105BFC2BCC', 'FieldCategoryInfo', '{"Role Definition":{"icon":"fa fa-file-alt","description":"Core identification fields describing the committee role"},"Role Permissions":{"icon":"fa fa-lock","description":"Flags and settings that control authority and voting rights for the role"},"Display Settings":{"icon":"fa fa-sort-amount-asc","description":"Controls the ordering of roles in user interfaces"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit and tracking fields"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('a23bfb1c-ddf6-44ab-ac6d-b1b3a0cd02cc', 'CF2605AB-3F2C-4D18-B663-60105BFC2BCC', 'FieldCategoryIcons', '{"Role Definition":"fa fa-file-alt","Role Permissions":"fa fa-lock","Display Settings":"fa fa-sort-amount-asc","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=false for NEW entity (category: reference, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 0, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = 'CF2605AB-3F2C-4D18-B663-60105BFC2BCC';

/* Set categories for 9 fields */

-- UPDATE Entity Field Category Info Committees: Terms.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3F1FA5ED-2E67-4777-AC91-3809740F5DA5' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Terms.CommitteeID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Relationship',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '091826C5-1F45-44FB-A3B0-B2296A9D81AC' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Terms.Name 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Term Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4F41559A-018D-4C41-91D5-9B40B4BC96AE' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Terms.StartDate 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Term Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6ADADE18-EF8A-4ED5-8994-CEA52F5EB2BA' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Terms.EndDate 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Term Timeline',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CB0221FE-0167-49E1-80C7-2F8F5D3688EB' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Terms.Status 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Term Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BBB912DF-DAE0-4CD9-915F-4D10705394AE' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Terms.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8CF661BD-0E27-4DCC-926C-771C0B84BC94' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Terms.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '21478D75-7F46-44B7-B344-F79F1DA4D251' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Terms.Committee 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Relationship',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '03BE6702-9F2F-457F-856D-E1E99089FA5B' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-users */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-users', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = 'EAD3EF14-1891-4389-A0F3-1984BC8CC13F';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('ac5cd545-fb66-4b64-a7da-f928e1f9461f', 'EAD3EF14-1891-4389-A0F3-1984BC8CC13F', 'FieldCategoryInfo', '{"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"},"Committee Relationship":{"icon":"fa fa-link","description":"Fields that associate the term with its parent committee"},"Term Details":{"icon":"fa fa-info-circle","description":"Core descriptive information about the committee term"},"Term Timeline":{"icon":"fa fa-calendar","description":"Start and end dates defining the term''s duration"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('c1c01361-844c-4939-b4ee-7ff5e9b9bc46', 'EAD3EF14-1891-4389-A0F3-1984BC8CC13F', 'FieldCategoryIcons', '{"System Metadata":"fa fa-cog","Committee Relationship":"fa fa-link","Term Details":"fa fa-info-circle","Term Timeline":"fa fa-calendar"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=false for NEW entity (category: reference, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 0, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = 'EAD3EF14-1891-4389-A0F3-1984BC8CC13F';

/* Set categories for 8 fields */

-- UPDATE Entity Field Category Info Committees: Types.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '52558564-11CB-4F0B-A13B-6CA545FFC400' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Types.Name 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Definition',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '67318BCF-1A43-4A52-B373-A3FD9E875504' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Types.Description 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Definition',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A7427180-CE31-4EEA-BB03-A4CD524C2250' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Types.IsStandards 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Attributes',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6464C3B1-2E2C-4B51-B4D4-61825D57A0ED' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Types.DefaultTermMonths 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Committee Attributes',
   GeneratedFormSection = 'Category',
   DisplayName = 'Default Term (Months)',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'EB7D567F-57BA-469E-A736-F403B2692792' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Types.IconClass 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Presentation',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A9E6D7F1-7112-4155-BC48-139FCA459C65' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Types.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '912011C8-7359-45F4-B7E9-8861F0493DE5' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Types.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '275B903E-F851-4F1E-A2FE-E9612541BE34' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-list */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-list', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '1D7F24C0-622E-41E0-BC38-29C2EEB1D442';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('686ced84-2b6d-4ecf-8f80-3eb8e892e859', '1D7F24C0-622E-41E0-BC38-29C2EEB1D442', 'FieldCategoryInfo', '{"Committee Definition":{"icon":"fa fa-file-alt","description":"Core identification fields for the committee type such as name and description"},"Committee Attributes":{"icon":"fa fa-sliders-h","description":"Behavioral and policy settings that define how the committee type operates"},"Presentation":{"icon":"fa fa-paint-brush","description":"Visual styling information for displaying the committee type in the UI"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit and tracking fields"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('149f1402-17c1-41b3-acb6-3761fdead2c3', '1D7F24C0-622E-41E0-BC38-29C2EEB1D442', 'FieldCategoryIcons', '{"Committee Definition":"fa fa-file-alt","Committee Attributes":"fa fa-sliders-h","Presentation":"fa fa-paint-brush","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=false for NEW entity (category: reference, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 0, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '1D7F24C0-622E-41E0-BC38-29C2EEB1D442';

/* Set categories for 9 fields */

-- UPDATE Entity Field Category Info Committees: Video Providers.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '20E082C1-D5BE-4797-9662-1F006FEB4E0F' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Video Providers.Name 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Provider Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1DCE37F4-2759-4719-96CC-4DA8B386528C' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Video Providers.ServerDriverKey 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Provider Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C9F8BC65-F002-4C8E-85A2-B97A88176197' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Video Providers.IsActive 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Status & Defaults',
   GeneratedFormSection = 'Category',
   DisplayName = 'Active',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '53A4EAE5-0B76-4C9B-A787-188CD1C3EFE6' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Video Providers.IsDefault 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Status & Defaults',
   GeneratedFormSection = 'Category',
   DisplayName = 'Default',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '04F3F75D-20D7-4A65-958F-F79F563B2B91' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Video Providers.CredentialID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Credentials',
   GeneratedFormSection = 'Category',
   DisplayName = 'Credential',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '171B0CFE-85EE-431B-9ECE-1DA427A26ACD' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Video Providers.Credential 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Credentials',
   GeneratedFormSection = 'Category',
   DisplayName = 'Credential Description',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BFC265BF-FC90-4215-A6D5-140EA0A5DF2E' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Video Providers.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '03926773-A9C3-44B0-BE3C-B2F15DBA28A7' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Video Providers.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2719F8BA-2C87-4295-BBF5-40ED4100E234' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-video */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-video', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = 'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('2447c617-47dc-4e53-99b8-bc30c9b49a67', 'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9', 'FieldCategoryInfo', '{"Provider Details":{"icon":"fa fa-video","description":"Core information that identifies and configures the video provider"},"Status & Defaults":{"icon":"fa fa-flag-checkered","description":"Flags controlling activation state and default selection"},"Credentials":{"icon":"fa fa-key","description":"Links to authentication credentials required for the provider"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit fields"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('bbd1905b-b55c-4ba8-81ed-aefb9737f80a', 'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9', 'FieldCategoryIcons', '{"Provider Details":"fa fa-video","Status & Defaults":"fa fa-flag-checkered","Credentials":"fa fa-key","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=false for NEW entity (category: reference, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 0, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = 'B100FFC7-5AB7-4E86-A58A-B9FC146A4DE9';

/* Set categories for 16 fields */

-- UPDATE Entity Field Category Info Committees: Motions.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4E11CCF6-D689-461D-AD1B-6075A2F53D45' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.MeetingID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Meeting Context',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D2E4B22E-B412-4EED-9420-7556D5E96B1F' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.AgendaItemID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Meeting Context',
   GeneratedFormSection = 'Category',
   DisplayName = 'Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D79E4719-9505-459A-ABD1-D94C06FD0C2F' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.Sequence 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Meeting Context',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B9C3B357-3301-4897-AAFE-BD706CFFBF9A' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.Title 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Motion Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '855672E5-93D7-476A-9A84-E5B70C117CFF' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.Description 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Motion Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F9F72B80-5186-414C-8AA2-C78548F612EC' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.MovedByMembershipID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Participation',
   GeneratedFormSection = 'Category',
   DisplayName = 'Moved By',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6157CD60-83DC-453B-AA92-1535976CE7BC' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.SecondedByMembershipID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Participation',
   GeneratedFormSection = 'Category',
   DisplayName = 'Seconded By',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3FB932C5-9E5B-424B-A028-3C86F5B5A319' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.Result 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Outcome',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '84428F50-1C25-46B8-A9CB-ED285792AFBA' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.ResultSummary 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Outcome',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '271E01A1-4529-413F-B09B-DBA0A93D3FDD' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.YesCount 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Voting Tally',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0CF4EDBE-333E-47E3-B210-57A7C6362884' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.NoCount 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Voting Tally',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '44E3F21E-8463-46F8-BD58-BA0AD86A2042' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.AbstainCount 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Voting Tally',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '479CC4F6-86AA-4584-B156-3629D194E1AC' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.Notes 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Additional Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '4149181C-7D27-4AAD-9044-B5CC0561F370' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '65CB4FD2-427D-4827-85A6-11ED7EF37C43' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Motions.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C05DF0FA-B238-4CA1-9FB9-65DF1626D22F' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-gavel */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-gavel', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('762b7146-42f9-4d8a-87a4-a3412bccaec3', '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', 'FieldCategoryInfo', '{"Meeting Context":{"icon":"fa fa-calendar-alt","description":"Fields that situate the motion within a specific meeting and agenda"},"Motion Details":{"icon":"fa fa-file-alt","description":"Core description and title of the motion"},"Participation":{"icon":"fa fa-user-friends","description":"Members involved in moving and seconding the motion"},"Outcome":{"icon":"fa fa-flag-checkered","description":"Result of the vote and any summary notes"},"Voting Tally":{"icon":"fa fa-chart-bar","description":"Counts of yes, no, and abstain votes"},"Additional Information":{"icon":"fa fa-comment-dots","description":"Free‑form notes or comments about the motion"},"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('81608c6a-7273-42fe-aba2-4f19206fa041', '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906', 'FieldCategoryIcons', '{"Meeting Context":"fa fa-calendar-alt","Motion Details":"fa fa-file-alt","Participation":"fa fa-user-friends","Outcome":"fa fa-flag-checkered","Voting Tally":"fa fa-chart-bar","Additional Information":"fa fa-comment-dots","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=true for NEW entity (category: primary, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 1, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '02F0D003-4F6D-4F8E-9CFE-1A6E3C0DF906';

/* Set field properties for entity */

               UPDATE [${mjSchema}].[EntityField]
               SET IsNameField = 1
               WHERE ID = 'F49D1790-7D59-4C16-AC47-40EA595CE36B'
               AND AutoUpdateIsNameField = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'F49D1790-7D59-4C16-AC47-40EA595CE36B'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '804BA908-70CD-4679-AD48-72906A686C39'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '92B05FA7-5D41-4E58-934D-4021853197D3'
               AND AutoUpdateDefaultInView = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '92B05FA7-5D41-4E58-934D-4021853197D3'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET IncludeInUserSearchAPI = 1
               WHERE ID = '772C3C0C-287C-493E-9A97-E109474023A1'
               AND AutoUpdateIncludeInUserSearchAPI = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = 'F49D1790-7D59-4C16-AC47-40EA595CE36B'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '804BA908-70CD-4679-AD48-72906A686C39'
               AND AutoUpdateUserSearchPredicate = 1;

               UPDATE [${mjSchema}].[EntityField]
               SET UserSearchPredicateAPI = 'BeginsWith'
               WHERE ID = '92B05FA7-5D41-4E58-934D-4021853197D3'
               AND AutoUpdateUserSearchPredicate = 1;

/* Set categories for 7 fields */

-- UPDATE Entity Field Category Info Committees: Votes.ID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CC6CA82F-B4F4-470E-8FB5-2531904B154F' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Votes.MotionID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Vote Context',
   GeneratedFormSection = 'Category',
   DisplayName = 'Motion',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F49D1790-7D59-4C16-AC47-40EA595CE36B' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Votes.MembershipID 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Vote Context',
   GeneratedFormSection = 'Category',
   DisplayName = 'Member',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '804BA908-70CD-4679-AD48-72906A686C39' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Votes.VoteValue 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Vote Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '92B05FA7-5D41-4E58-934D-4021853197D3' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Votes.Notes 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'Vote Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '772C3C0C-287C-493E-9A97-E109474023A1' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Votes.__mj_CreatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '392784B0-4470-4956-AC15-BA8B4102F2A5' AND AutoUpdateCategory = 1;

-- UPDATE Entity Field Category Info Committees: Votes.__mj_UpdatedAt 
UPDATE [${mjSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '76F6F522-D451-46B7-905B-1C9834643F58' AND AutoUpdateCategory = 1;

/* Set entity icon to fa fa-check-square */

               UPDATE [${mjSchema}].[Entity]
               SET [Icon] = 'fa fa-check-square', [__mj_UpdatedAt] = GETUTCDATE()
               WHERE [ID] = '80299A27-B207-4D99-A46B-4E5B8A2B5E62';

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('a12ad2b8-ab82-4f87-9aa8-34b10c42f72a', '80299A27-B207-4D99-A46B-4E5B8A2B5E62', 'FieldCategoryInfo', '{"Vote Context":{"icon":"fa fa-users","description":"Links the vote to the motion and the committee member who cast it"},"Vote Details":{"icon":"fa fa-align-left","description":"Core voting information including the choice and any explanatory notes"},"System Metadata":{"icon":"fa fa-cog","description":"Audit fields managed by the system for tracking record creation and updates"}}', GETUTCDATE(), GETUTCDATE());

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${mjSchema}].[EntitySetting] ([ID], [EntityID], [Name], [Value], [__mj_CreatedAt], [__mj_UpdatedAt])
               VALUES ('f4c14fe3-fe65-464b-8c8d-fb49660dc8d5', '80299A27-B207-4D99-A46B-4E5B8A2B5E62', 'FieldCategoryIcons', '{"Vote Context":"fa fa-users","Vote Details":"fa fa-align-left","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE());

/* Set DefaultForNewUser=false for NEW entity (category: reference, confidence: high) */

         UPDATE [${mjSchema}].[ApplicationEntity]
         SET [DefaultForNewUser] = 0, [__mj_UpdatedAt] = GETUTCDATE()
         WHERE [EntityID] = '80299A27-B207-4D99-A46B-4E5B8A2B5E62';

/* Index for Foreign Keys for Meeting */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
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
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Meeting]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Meeting_CommitteeID ON [${mjSchema}_Committees].[Meeting] ([CommitteeID]);

-- Index for foreign key VideoProviderID in table Meeting
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Meeting_VideoProviderID' 
    AND object_id = OBJECT_ID('[${mjSchema}_Committees].[Meeting]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Meeting_VideoProviderID ON [${mjSchema}_Committees].[Meeting] ([VideoProviderID]);

/* Base View SQL for Committees: Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
-- Item: vwMeetings
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Meetings
-----               SCHEMA:      ${mjSchema}_Committees
-----               BASE TABLE:  Meeting
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[vwMeetings]', 'V') IS NOT NULL
    DROP VIEW [${mjSchema}_Committees].[vwMeetings];
GO

CREATE VIEW [${mjSchema}_Committees].[vwMeetings]
AS
SELECT
    m.*,
    mjCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjCommitteesVideoProvider_VideoProviderID.[Name] AS [VideoProvider_Virtual],
    ${mjSchema}_rgc.[Latitude] AS [${mjSchema}_Latitude],
    ${mjSchema}_rgc.[Longitude] AS [${mjSchema}_Longitude]
FROM
    [${mjSchema}_Committees].[Meeting] AS m
INNER JOIN
    [${mjSchema}_Committees].[Committee] AS mjCommitteesCommittee_CommitteeID
  ON
    [m].[CommitteeID] = mjCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [${mjSchema}_Committees].[VideoProvider] AS mjCommitteesVideoProvider_VideoProviderID
  ON
    [m].[VideoProviderID] = mjCommitteesVideoProvider_VideoProviderID.[ID]
LEFT OUTER JOIN
    [${mjSchema}].[vwRecordGeoCodes] AS ${mjSchema}_rgc
  ON
    ${mjSchema}_rgc.[EntityID] = 'F05BE747-6F2A-472E-8800-8A10D416EAA1'
    AND ${mjSchema}_rgc.[RecordID] = CAST([m].[ID] AS NVARCHAR(450))
    AND ${mjSchema}_rgc.[LocationType] = 'Primary'
GO
GRANT SELECT ON [${mjSchema}_Committees].[vwMeetings] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
-- Item: Permissions for vwMeetings
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

GRANT SELECT ON [${mjSchema}_Committees].[vwMeetings] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
-- Item: spCreateMeeting
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Meeting
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spCreateMeeting]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spCreateMeeting];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spCreateMeeting]
    @ID uniqueidentifier = NULL,
    @CommitteeID uniqueidentifier,
    @Title nvarchar(255),
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @StartDateTime datetimeoffset,
    @EndDateTime_Clear bit = 0,
    @EndDateTime datetimeoffset = NULL,
    @TimeZone nvarchar(50) = NULL,
    @LocationType nvarchar(50) = NULL,
    @LocationText_Clear bit = 0,
    @LocationText nvarchar(500) = NULL,
    @VideoProvider_Clear bit = 0,
    @VideoProvider nvarchar(50) = NULL,
    @VideoProviderID_Clear bit = 0,
    @VideoProviderID uniqueidentifier = NULL,
    @VideoMeetingID_Clear bit = 0,
    @VideoMeetingID nvarchar(255) = NULL,
    @VideoJoinURL_Clear bit = 0,
    @VideoJoinURL nvarchar(1000) = NULL,
    @VideoRecordingURL_Clear bit = 0,
    @VideoRecordingURL nvarchar(1000) = NULL,
    @TranscriptURL_Clear bit = 0,
    @TranscriptURL nvarchar(1000) = NULL,
    @Status nvarchar(50) = NULL,
    @CalendarEventID_Clear bit = 0,
    @CalendarEventID nvarchar(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)
    
    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${mjSchema}_Committees].[Meeting]
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
                [VideoProviderID],
                [VideoMeetingID],
                [VideoJoinURL],
                [VideoRecordingURL],
                [TranscriptURL],
                [Status],
                [CalendarEventID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @CommitteeID,
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @StartDateTime,
                CASE WHEN @EndDateTime_Clear = 1 THEN NULL ELSE ISNULL(@EndDateTime, NULL) END,
                ISNULL(@TimeZone, 'America/New_York'),
                ISNULL(@LocationType, 'Virtual'),
                CASE WHEN @LocationText_Clear = 1 THEN NULL ELSE ISNULL(@LocationText, NULL) END,
                CASE WHEN @VideoProvider_Clear = 1 THEN NULL ELSE ISNULL(@VideoProvider, NULL) END,
                CASE WHEN @VideoProviderID_Clear = 1 THEN NULL ELSE ISNULL(@VideoProviderID, NULL) END,
                CASE WHEN @VideoMeetingID_Clear = 1 THEN NULL ELSE ISNULL(@VideoMeetingID, NULL) END,
                CASE WHEN @VideoJoinURL_Clear = 1 THEN NULL ELSE ISNULL(@VideoJoinURL, NULL) END,
                CASE WHEN @VideoRecordingURL_Clear = 1 THEN NULL ELSE ISNULL(@VideoRecordingURL, NULL) END,
                CASE WHEN @TranscriptURL_Clear = 1 THEN NULL ELSE ISNULL(@TranscriptURL, NULL) END,
                ISNULL(@Status, 'Scheduled'),
                CASE WHEN @CalendarEventID_Clear = 1 THEN NULL ELSE ISNULL(@CalendarEventID, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${mjSchema}_Committees].[Meeting]
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
                [VideoProviderID],
                [VideoMeetingID],
                [VideoJoinURL],
                [VideoRecordingURL],
                [TranscriptURL],
                [Status],
                [CalendarEventID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @CommitteeID,
                @Title,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @StartDateTime,
                CASE WHEN @EndDateTime_Clear = 1 THEN NULL ELSE ISNULL(@EndDateTime, NULL) END,
                ISNULL(@TimeZone, 'America/New_York'),
                ISNULL(@LocationType, 'Virtual'),
                CASE WHEN @LocationText_Clear = 1 THEN NULL ELSE ISNULL(@LocationText, NULL) END,
                CASE WHEN @VideoProvider_Clear = 1 THEN NULL ELSE ISNULL(@VideoProvider, NULL) END,
                CASE WHEN @VideoProviderID_Clear = 1 THEN NULL ELSE ISNULL(@VideoProviderID, NULL) END,
                CASE WHEN @VideoMeetingID_Clear = 1 THEN NULL ELSE ISNULL(@VideoMeetingID, NULL) END,
                CASE WHEN @VideoJoinURL_Clear = 1 THEN NULL ELSE ISNULL(@VideoJoinURL, NULL) END,
                CASE WHEN @VideoRecordingURL_Clear = 1 THEN NULL ELSE ISNULL(@VideoRecordingURL, NULL) END,
                CASE WHEN @TranscriptURL_Clear = 1 THEN NULL ELSE ISNULL(@TranscriptURL, NULL) END,
                ISNULL(@Status, 'Scheduled'),
                CASE WHEN @CalendarEventID_Clear = 1 THEN NULL ELSE ISNULL(@CalendarEventID, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${mjSchema}_Committees].[vwMeetings] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateMeeting] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Meetings */

GRANT EXECUTE ON [${mjSchema}_Committees].[spCreateMeeting] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
-- Item: spUpdateMeeting
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Meeting
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spUpdateMeeting]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spUpdateMeeting];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spUpdateMeeting]
    @ID uniqueidentifier,
    @CommitteeID uniqueidentifier = NULL,
    @Title nvarchar(255) = NULL,
    @Description_Clear bit = 0,
    @Description nvarchar(MAX) = NULL,
    @StartDateTime datetimeoffset = NULL,
    @EndDateTime_Clear bit = 0,
    @EndDateTime datetimeoffset = NULL,
    @TimeZone nvarchar(50) = NULL,
    @LocationType nvarchar(50) = NULL,
    @LocationText_Clear bit = 0,
    @LocationText nvarchar(500) = NULL,
    @VideoProvider_Clear bit = 0,
    @VideoProvider nvarchar(50) = NULL,
    @VideoProviderID_Clear bit = 0,
    @VideoProviderID uniqueidentifier = NULL,
    @VideoMeetingID_Clear bit = 0,
    @VideoMeetingID nvarchar(255) = NULL,
    @VideoJoinURL_Clear bit = 0,
    @VideoJoinURL nvarchar(1000) = NULL,
    @VideoRecordingURL_Clear bit = 0,
    @VideoRecordingURL nvarchar(1000) = NULL,
    @TranscriptURL_Clear bit = 0,
    @TranscriptURL nvarchar(1000) = NULL,
    @Status nvarchar(50) = NULL,
    @CalendarEventID_Clear bit = 0,
    @CalendarEventID nvarchar(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Meeting]
    SET
        [CommitteeID] = ISNULL(@CommitteeID, [CommitteeID]),
        [Title] = ISNULL(@Title, [Title]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [StartDateTime] = ISNULL(@StartDateTime, [StartDateTime]),
        [EndDateTime] = CASE WHEN @EndDateTime_Clear = 1 THEN NULL ELSE ISNULL(@EndDateTime, [EndDateTime]) END,
        [TimeZone] = ISNULL(@TimeZone, [TimeZone]),
        [LocationType] = ISNULL(@LocationType, [LocationType]),
        [LocationText] = CASE WHEN @LocationText_Clear = 1 THEN NULL ELSE ISNULL(@LocationText, [LocationText]) END,
        [VideoProvider] = CASE WHEN @VideoProvider_Clear = 1 THEN NULL ELSE ISNULL(@VideoProvider, [VideoProvider]) END,
        [VideoProviderID] = CASE WHEN @VideoProviderID_Clear = 1 THEN NULL ELSE ISNULL(@VideoProviderID, [VideoProviderID]) END,
        [VideoMeetingID] = CASE WHEN @VideoMeetingID_Clear = 1 THEN NULL ELSE ISNULL(@VideoMeetingID, [VideoMeetingID]) END,
        [VideoJoinURL] = CASE WHEN @VideoJoinURL_Clear = 1 THEN NULL ELSE ISNULL(@VideoJoinURL, [VideoJoinURL]) END,
        [VideoRecordingURL] = CASE WHEN @VideoRecordingURL_Clear = 1 THEN NULL ELSE ISNULL(@VideoRecordingURL, [VideoRecordingURL]) END,
        [TranscriptURL] = CASE WHEN @TranscriptURL_Clear = 1 THEN NULL ELSE ISNULL(@TranscriptURL, [TranscriptURL]) END,
        [Status] = ISNULL(@Status, [Status]),
        [CalendarEventID] = CASE WHEN @CalendarEventID_Clear = 1 THEN NULL ELSE ISNULL(@CalendarEventID, [CalendarEventID]) END
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${mjSchema}_Committees].[vwMeetings] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${mjSchema}_Committees].[vwMeetings]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateMeeting] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Meeting table
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[trgUpdateMeeting]', 'TR') IS NOT NULL
    DROP TRIGGER [${mjSchema}_Committees].[trgUpdateMeeting];
GO
CREATE TRIGGER [${mjSchema}_Committees].trgUpdateMeeting
ON [${mjSchema}_Committees].[Meeting]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${mjSchema}_Committees].[Meeting]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${mjSchema}_Committees].[Meeting] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Meetings */

GRANT EXECUTE ON [${mjSchema}_Committees].[spUpdateMeeting] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
-- Item: spDeleteMeeting
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Meeting
------------------------------------------------------------
IF OBJECT_ID('[${mjSchema}_Committees].[spDeleteMeeting]', 'P') IS NOT NULL
    DROP PROCEDURE [${mjSchema}_Committees].[spDeleteMeeting];
GO

CREATE PROCEDURE [${mjSchema}_Committees].[spDeleteMeeting]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${mjSchema}_Committees].[Meeting]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteMeeting] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Meetings */

GRANT EXECUTE ON [${mjSchema}_Committees].[spDeleteMeeting] TO [cdp_Developer], [cdp_Integration];

/* SQL text to delete unneeded entity fields (1 scoped entities) */
EXEC [${mjSchema}].[spDeleteUnneededEntityFields] @ExcludedSchemaNames='sys,staging,${mjSchema},${mjSchema}_BizAppsCommon,${mjSchema}_BizAppsTasks', @EntityIDs='F05BE747-6F2A-472E-8800-8A10D416EAA1';

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'ee812732-721f-45b8-b822-e4c9842ef0e4' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = '${mjSchema}_Latitude')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'ee812732-721f-45b8-b822-e4c9842ef0e4',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
            100043,
            '${mjSchema}_Latitude',
            'Mj Latitude',
            NULL,
            'decimal',
            9,
            10,
            6,
            1,
            NULL,
            0,
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
      END;

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'c50786df-6702-4cff-ada2-b00427a7ea9b' OR (EntityID = 'F05BE747-6F2A-472E-8800-8A10D416EAA1' AND Name = '${mjSchema}_Longitude')) BEGIN
         INSERT INTO [${mjSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [IsComputed],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'c50786df-6702-4cff-ada2-b00427a7ea9b',
            'F05BE747-6F2A-472E-8800-8A10D416EAA1', -- Entity: Committees: Meetings
            100044,
            '${mjSchema}_Longitude',
            'Mj Longitude',
            NULL,
            'decimal',
            9,
            10,
            6,
            1,
            NULL,
            0,
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
      END;

/* SQL text to update existing entity fields from schema (1 scoped entities) */
EXEC [${mjSchema}].[spUpdateExistingEntityFieldsFromSchema] @ExcludedSchemaNames='sys,staging,${mjSchema},${mjSchema}_BizAppsCommon,${mjSchema}_BizAppsTasks', @EntityIDs='F05BE747-6F2A-472E-8800-8A10D416EAA1';

/* SQL text to set default column width where needed */
EXEC [${mjSchema}].[spSetDefaultColumnWidthWhereNeeded] @ExcludedSchemaNames='sys,staging,${mjSchema},${mjSchema}_BizAppsCommon,${mjSchema}_BizAppsTasks';

/* Set ExtendedType=GeoLatitude on virtual geo fields */
UPDATE [${mjSchema}].[EntityField] SET [ExtendedType] = 'GeoLatitude' WHERE [Name] = '${mjSchema}_Latitude' AND [ExtendedType] IS NULL AND [EntityID] IN ('F05BE747-6F2A-472E-8800-8A10D416EAA1');

/* Set ExtendedType=GeoLongitude on virtual geo fields */
UPDATE [${mjSchema}].[EntityField] SET [ExtendedType] = 'GeoLongitude' WHERE [Name] = '${mjSchema}_Longitude' AND [ExtendedType] IS NULL AND [EntityID] IN ('F05BE747-6F2A-472E-8800-8A10D416EAA1');

