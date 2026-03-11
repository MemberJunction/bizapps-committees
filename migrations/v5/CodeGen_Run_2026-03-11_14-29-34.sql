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
         '45382fa4-d82d-40f9-a105-24f227ab50c8',
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
   

/* SQL generated to create new application ${flyway:defaultSchema}_Committees */
INSERT INTO [${flyway:defaultSchema}].[Application] (ID, Name, Description, SchemaAutoAddNewEntities, Path, AutoUpdatePath)
                       VALUES ('d08b9391-0cf4-44d9-8577-064ed9020427', '${flyway:defaultSchema}_Committees', 'Generated for schema', '${flyway:defaultSchema}_Committees', 'mjcommittees', 1)

/* SQL generated to add new entity Types to application ID: 'd08b9391-0cf4-44d9-8577-064ed9020427' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('d08b9391-0cf4-44d9-8577-064ed9020427', '45382fa4-d82d-40f9-a105-24f227ab50c8', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = 'd08b9391-0cf4-44d9-8577-064ed9020427'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Types for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('45382fa4-d82d-40f9-a105-24f227ab50c8', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Types for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('45382fa4-d82d-40f9-a105-24f227ab50c8', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Types for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('45382fa4-d82d-40f9-a105-24f227ab50c8', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

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
         '2b971e92-bbce-462c-9868-807f9c04430d',
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
   

/* SQL generated to add new entity Committees to application ID: 'D08B9391-0CF4-44D9-8577-064ED9020427' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('D08B9391-0CF4-44D9-8577-064ED9020427', '2b971e92-bbce-462c-9868-807f9c04430d', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = 'D08B9391-0CF4-44D9-8577-064ED9020427'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Committees for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('2b971e92-bbce-462c-9868-807f9c04430d', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Committees for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('2b971e92-bbce-462c-9868-807f9c04430d', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Committees for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('2b971e92-bbce-462c-9868-807f9c04430d', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

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
         'ae427eea-a9d3-4b1b-8b68-c59754e6e03d',
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
   

/* SQL generated to add new entity Terms to application ID: 'D08B9391-0CF4-44D9-8577-064ED9020427' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('D08B9391-0CF4-44D9-8577-064ED9020427', 'ae427eea-a9d3-4b1b-8b68-c59754e6e03d', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = 'D08B9391-0CF4-44D9-8577-064ED9020427'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Terms for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('ae427eea-a9d3-4b1b-8b68-c59754e6e03d', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Terms for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('ae427eea-a9d3-4b1b-8b68-c59754e6e03d', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Terms for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('ae427eea-a9d3-4b1b-8b68-c59754e6e03d', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

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
         '213b8fb0-6855-442c-8d60-b126f6ae2d38',
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
   

/* SQL generated to add new entity Roles to application ID: 'D08B9391-0CF4-44D9-8577-064ED9020427' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('D08B9391-0CF4-44D9-8577-064ED9020427', '213b8fb0-6855-442c-8d60-b126f6ae2d38', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = 'D08B9391-0CF4-44D9-8577-064ED9020427'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Roles for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('213b8fb0-6855-442c-8d60-b126f6ae2d38', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Roles for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('213b8fb0-6855-442c-8d60-b126f6ae2d38', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Roles for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('213b8fb0-6855-442c-8d60-b126f6ae2d38', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

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
         'f1eceb8f-a39b-4cca-8275-cb969fb40ec6',
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
   

/* SQL generated to add new entity Memberships to application ID: 'D08B9391-0CF4-44D9-8577-064ED9020427' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('D08B9391-0CF4-44D9-8577-064ED9020427', 'f1eceb8f-a39b-4cca-8275-cb969fb40ec6', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = 'D08B9391-0CF4-44D9-8577-064ED9020427'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Memberships for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('f1eceb8f-a39b-4cca-8275-cb969fb40ec6', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Memberships for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('f1eceb8f-a39b-4cca-8275-cb969fb40ec6', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Memberships for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('f1eceb8f-a39b-4cca-8275-cb969fb40ec6', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

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
         'c6c5bd14-0d36-4442-812e-97f802728524',
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
   

/* SQL generated to add new entity Meetings to application ID: 'D08B9391-0CF4-44D9-8577-064ED9020427' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('D08B9391-0CF4-44D9-8577-064ED9020427', 'c6c5bd14-0d36-4442-812e-97f802728524', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = 'D08B9391-0CF4-44D9-8577-064ED9020427'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Meetings for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('c6c5bd14-0d36-4442-812e-97f802728524', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Meetings for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('c6c5bd14-0d36-4442-812e-97f802728524', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Meetings for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('c6c5bd14-0d36-4442-812e-97f802728524', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

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
         '5bc3d9bb-94e3-4138-9e17-362c5256da58',
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
   

/* SQL generated to add new entity Agenda Items to application ID: 'D08B9391-0CF4-44D9-8577-064ED9020427' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('D08B9391-0CF4-44D9-8577-064ED9020427', '5bc3d9bb-94e3-4138-9e17-362c5256da58', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = 'D08B9391-0CF4-44D9-8577-064ED9020427'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Agenda Items for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('5bc3d9bb-94e3-4138-9e17-362c5256da58', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Agenda Items for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('5bc3d9bb-94e3-4138-9e17-362c5256da58', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Agenda Items for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('5bc3d9bb-94e3-4138-9e17-362c5256da58', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

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
         '5f56a290-08c7-4405-9c21-b4389869d995',
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
   

/* SQL generated to add new entity Attendances to application ID: 'D08B9391-0CF4-44D9-8577-064ED9020427' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('D08B9391-0CF4-44D9-8577-064ED9020427', '5f56a290-08c7-4405-9c21-b4389869d995', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = 'D08B9391-0CF4-44D9-8577-064ED9020427'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Attendances for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('5f56a290-08c7-4405-9c21-b4389869d995', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Attendances for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('5f56a290-08c7-4405-9c21-b4389869d995', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Attendances for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('5f56a290-08c7-4405-9c21-b4389869d995', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

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
         'bd6e486a-f68a-4f8b-a8d2-ffea628a00f9',
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
   

/* SQL generated to add new entity Action Items to application ID: 'D08B9391-0CF4-44D9-8577-064ED9020427' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('D08B9391-0CF4-44D9-8577-064ED9020427', 'bd6e486a-f68a-4f8b-a8d2-ffea628a00f9', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = 'D08B9391-0CF4-44D9-8577-064ED9020427'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Action Items for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('bd6e486a-f68a-4f8b-a8d2-ffea628a00f9', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Action Items for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('bd6e486a-f68a-4f8b-a8d2-ffea628a00f9', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Action Items for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('bd6e486a-f68a-4f8b-a8d2-ffea628a00f9', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

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
         '01717d19-eab2-4c41-ad39-864bb1555d2f',
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
   

/* SQL generated to add new entity Artifact Types to application ID: 'D08B9391-0CF4-44D9-8577-064ED9020427' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('D08B9391-0CF4-44D9-8577-064ED9020427', '01717d19-eab2-4c41-ad39-864bb1555d2f', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = 'D08B9391-0CF4-44D9-8577-064ED9020427'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Artifact Types for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('01717d19-eab2-4c41-ad39-864bb1555d2f', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Artifact Types for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('01717d19-eab2-4c41-ad39-864bb1555d2f', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Artifact Types for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('01717d19-eab2-4c41-ad39-864bb1555d2f', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

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
         'dc523bbe-93dc-49fc-b066-621d3c8162e2',
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
   

/* SQL generated to add new entity Artifacts to application ID: 'D08B9391-0CF4-44D9-8577-064ED9020427' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('D08B9391-0CF4-44D9-8577-064ED9020427', 'dc523bbe-93dc-49fc-b066-621d3c8162e2', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = 'D08B9391-0CF4-44D9-8577-064ED9020427'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Artifacts for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('dc523bbe-93dc-49fc-b066-621d3c8162e2', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Artifacts for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('dc523bbe-93dc-49fc-b066-621d3c8162e2', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Artifacts for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('dc523bbe-93dc-49fc-b066-621d3c8162e2', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

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
         'bfa46589-88e7-45af-a1dd-f9910ddd1717',
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
   

/* SQL generated to add new entity Minutes to application ID: 'D08B9391-0CF4-44D9-8577-064ED9020427' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('D08B9391-0CF4-44D9-8577-064ED9020427', 'bfa46589-88e7-45af-a1dd-f9910ddd1717', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = 'D08B9391-0CF4-44D9-8577-064ED9020427'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Minutes for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('bfa46589-88e7-45af-a1dd-f9910ddd1717', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Minutes for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('bfa46589-88e7-45af-a1dd-f9910ddd1717', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Minutes for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('bfa46589-88e7-45af-a1dd-f9910ddd1717', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

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
         'eb4ee1a6-cc17-4b5f-8140-8e1719548264',
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
   

/* SQL generated to add new entity Motions to application ID: 'D08B9391-0CF4-44D9-8577-064ED9020427' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('D08B9391-0CF4-44D9-8577-064ED9020427', 'eb4ee1a6-cc17-4b5f-8140-8e1719548264', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = 'D08B9391-0CF4-44D9-8577-064ED9020427'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Motions for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('eb4ee1a6-cc17-4b5f-8140-8e1719548264', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Motions for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('eb4ee1a6-cc17-4b5f-8140-8e1719548264', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Motions for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('eb4ee1a6-cc17-4b5f-8140-8e1719548264', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

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
         'f77ca3d7-5717-4149-8479-f258ef819c7a',
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
   

/* SQL generated to add new entity Votes to application ID: 'D08B9391-0CF4-44D9-8577-064ED9020427' */
INSERT INTO [${flyway:defaultSchema}].[ApplicationEntity]
                                       ([ApplicationID], [EntityID], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                       ('D08B9391-0CF4-44D9-8577-064ED9020427', 'f77ca3d7-5717-4149-8479-f258ef819c7a', (SELECT COALESCE(MAX([Sequence]),0)+1 FROM [${flyway:defaultSchema}].[ApplicationEntity] WHERE [ApplicationID] = 'D08B9391-0CF4-44D9-8577-064ED9020427'), GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Votes for role UI */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('f77ca3d7-5717-4149-8479-f258ef819c7a', 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 0, 0, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Votes for role Developer */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('f77ca3d7-5717-4149-8479-f258ef819c7a', 'DEAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 0, GETUTCDATE(), GETUTCDATE())

/* SQL generated to add new permission for entity Votes for role Integration */
INSERT INTO [${flyway:defaultSchema}].[EntityPermission]
                                                   ([EntityID], [RoleID], [CanRead], [CanCreate], [CanUpdate], [CanDelete], [__mj_CreatedAt], [__mj_UpdatedAt]) VALUES
                                                   ('f77ca3d7-5717-4149-8479-f258ef819c7a', 'DFAFCCEC-6A37-EF11-86D4-000D3A4E707E', 1, 1, 1, 1, GETUTCDATE(), GETUTCDATE())

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Type */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Type] ADD __mj_CreatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Type */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Type] ADD __mj_UpdatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.AgendaItem */
ALTER TABLE [${flyway:defaultSchema}_Committees].[AgendaItem] ADD __mj_CreatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.AgendaItem */
ALTER TABLE [${flyway:defaultSchema}_Committees].[AgendaItem] ADD __mj_UpdatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Artifact */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Artifact] ADD __mj_CreatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Artifact */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Artifact] ADD __mj_UpdatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Motion */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Motion] ADD __mj_CreatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Motion */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Motion] ADD __mj_UpdatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Meeting */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Meeting] ADD __mj_CreatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Meeting */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Meeting] ADD __mj_UpdatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Role */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Role] ADD __mj_CreatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Role */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Role] ADD __mj_UpdatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Term */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Term] ADD __mj_CreatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Term */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Term] ADD __mj_UpdatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Membership */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Membership] ADD __mj_CreatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Membership */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Membership] ADD __mj_UpdatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.Vote */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Vote] ADD __mj_CreatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.Vote */
ALTER TABLE [${flyway:defaultSchema}_Committees].[Vote] ADD __mj_UpdatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_CreatedAt to entity ${flyway:defaultSchema}_Committees.ActionItem */
ALTER TABLE [${flyway:defaultSchema}_Committees].[ActionItem] ADD __mj_CreatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to add special date field __mj_UpdatedAt to entity ${flyway:defaultSchema}_Committees.ActionItem */
ALTER TABLE [${flyway:defaultSchema}_Committees].[ActionItem] ADD __mj_UpdatedAt DATETIMEOFFSET NOT NULL DEFAULT GETUTCDATE()

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '80ad3535-86c8-4deb-911f-5a325e2de110' OR (EntityID = '45382FA4-D82D-40F9-A105-24F227AB50C8' AND Name = 'ID')) BEGIN
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
            '80ad3535-86c8-4deb-911f-5a325e2de110',
            '45382FA4-D82D-40F9-A105-24F227AB50C8', -- Entity: Types
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'b207f4ed-87ee-4cfc-adb5-80a1fb53a88e' OR (EntityID = '45382FA4-D82D-40F9-A105-24F227AB50C8' AND Name = 'Name')) BEGIN
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
            'b207f4ed-87ee-4cfc-adb5-80a1fb53a88e',
            '45382FA4-D82D-40F9-A105-24F227AB50C8', -- Entity: Types
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1c8addf0-4eb6-4d49-a4bb-46175860f5d9' OR (EntityID = '45382FA4-D82D-40F9-A105-24F227AB50C8' AND Name = 'Description')) BEGIN
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
            '1c8addf0-4eb6-4d49-a4bb-46175860f5d9',
            '45382FA4-D82D-40F9-A105-24F227AB50C8', -- Entity: Types
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'a5667471-a02f-4fe3-8647-edd2502a690f' OR (EntityID = '45382FA4-D82D-40F9-A105-24F227AB50C8' AND Name = 'IsStandards')) BEGIN
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
            'a5667471-a02f-4fe3-8647-edd2502a690f',
            '45382FA4-D82D-40F9-A105-24F227AB50C8', -- Entity: Types
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'e055f3c2-16a5-440b-ba16-e45e46c0b5ea' OR (EntityID = '45382FA4-D82D-40F9-A105-24F227AB50C8' AND Name = 'DefaultTermMonths')) BEGIN
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
            'e055f3c2-16a5-440b-ba16-e45e46c0b5ea',
            '45382FA4-D82D-40F9-A105-24F227AB50C8', -- Entity: Types
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '8a5b8a62-227b-4942-b034-ff1e93c2c33f' OR (EntityID = '45382FA4-D82D-40F9-A105-24F227AB50C8' AND Name = 'IconClass')) BEGIN
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
            '8a5b8a62-227b-4942-b034-ff1e93c2c33f',
            '45382FA4-D82D-40F9-A105-24F227AB50C8', -- Entity: Types
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '9d7eec50-670a-4940-a84a-5983a7f34c69' OR (EntityID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58' AND Name = 'ID')) BEGIN
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
            '9d7eec50-670a-4940-a84a-5983a7f34c69',
            '5BC3D9BB-94E3-4138-9E17-362C5256DA58', -- Entity: Agenda Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '2f5c7fd5-0699-46b0-b9eb-e4ffc8b547ef' OR (EntityID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58' AND Name = 'MeetingID')) BEGIN
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
            '2f5c7fd5-0699-46b0-b9eb-e4ffc8b547ef',
            '5BC3D9BB-94E3-4138-9E17-362C5256DA58', -- Entity: Agenda Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'af77d04a-96d8-4bef-9ce0-e65892ad91c1' OR (EntityID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58' AND Name = 'ParentAgendaItemID')) BEGIN
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
            'af77d04a-96d8-4bef-9ce0-e65892ad91c1',
            '5BC3D9BB-94E3-4138-9E17-362C5256DA58', -- Entity: Agenda Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '6af82ff1-d71e-4904-a678-d9d8e50ca1b8' OR (EntityID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58' AND Name = 'Sequence')) BEGIN
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
            '6af82ff1-d71e-4904-a678-d9d8e50ca1b8',
            '5BC3D9BB-94E3-4138-9E17-362C5256DA58', -- Entity: Agenda Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '44f0a802-c118-440a-a467-bb296dfacc2a' OR (EntityID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58' AND Name = 'Title')) BEGIN
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
            '44f0a802-c118-440a-a467-bb296dfacc2a',
            '5BC3D9BB-94E3-4138-9E17-362C5256DA58', -- Entity: Agenda Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '232d43cf-4d1e-4022-9f6e-dcdd7c33d007' OR (EntityID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58' AND Name = 'Description')) BEGIN
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
            '232d43cf-4d1e-4022-9f6e-dcdd7c33d007',
            '5BC3D9BB-94E3-4138-9E17-362C5256DA58', -- Entity: Agenda Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '2c88ba58-d204-4733-bd7b-2b12a588d289' OR (EntityID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58' AND Name = 'PresenterPersonID')) BEGIN
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
            '2c88ba58-d204-4733-bd7b-2b12a588d289',
            '5BC3D9BB-94E3-4138-9E17-362C5256DA58', -- Entity: Agenda Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c2f9687c-2d72-44b1-9fc5-15d661ca007a' OR (EntityID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58' AND Name = 'DurationMinutes')) BEGIN
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
            'c2f9687c-2d72-44b1-9fc5-15d661ca007a',
            '5BC3D9BB-94E3-4138-9E17-362C5256DA58', -- Entity: Agenda Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'e2f64d96-5de8-4918-84a7-c1a517829bbc' OR (EntityID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58' AND Name = 'ItemType')) BEGIN
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
            'e2f64d96-5de8-4918-84a7-c1a517829bbc',
            '5BC3D9BB-94E3-4138-9E17-362C5256DA58', -- Entity: Agenda Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '72565441-09bc-4ff3-858b-8999dc5262c1' OR (EntityID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58' AND Name = 'RelatedDocumentURL')) BEGIN
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
            '72565441-09bc-4ff3-858b-8999dc5262c1',
            '5BC3D9BB-94E3-4138-9E17-362C5256DA58', -- Entity: Agenda Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '8fc8e88a-0e6a-475c-9e05-729f103ba062' OR (EntityID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58' AND Name = 'Status')) BEGIN
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
            '8fc8e88a-0e6a-475c-9e05-729f103ba062',
            '5BC3D9BB-94E3-4138-9E17-362C5256DA58', -- Entity: Agenda Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '07c5263a-ce84-4a2c-99a1-e9981697c3e7' OR (EntityID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58' AND Name = 'Notes')) BEGIN
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
            '07c5263a-ce84-4a2c-99a1-e9981697c3e7',
            '5BC3D9BB-94E3-4138-9E17-362C5256DA58', -- Entity: Agenda Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '8b3f77ae-3edf-4d2a-8b9e-01387412a770' OR (EntityID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58' AND Name = 'RootParentAgendaItemID')) BEGIN
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
            '8b3f77ae-3edf-4d2a-8b9e-01387412a770',
            '5BC3D9BB-94E3-4138-9E17-362C5256DA58', -- Entity: Agenda Items
            100013,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '7c276534-b46c-4035-bb64-49baa7c0a2ab' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'ID')) BEGIN
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
            '7c276534-b46c-4035-bb64-49baa7c0a2ab',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '0b9c54ac-5206-423a-a353-056e9a24a732' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'CommitteeID')) BEGIN
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
            '0b9c54ac-5206-423a-a353-056e9a24a732',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c53fc5a3-01e2-4ab3-a84b-58b8be1de136' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'MeetingID')) BEGIN
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
            'c53fc5a3-01e2-4ab3-a84b-58b8be1de136',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '9300a125-aeea-43e1-9c41-c303c7e8899e' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'AgendaItemID')) BEGIN
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
            '9300a125-aeea-43e1-9c41-c303c7e8899e',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '278ddbca-fdc7-4c4c-9483-e336f0474c13' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'ActionItemID')) BEGIN
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
            '278ddbca-fdc7-4c4c-9483-e336f0474c13',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '0944b1f6-e52e-4d8e-8882-64eb1cac8bed' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'Title')) BEGIN
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
            '0944b1f6-e52e-4d8e-8882-64eb1cac8bed',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1bc69300-429a-466b-832f-d86f2a280f8a' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'Description')) BEGIN
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
            '1bc69300-429a-466b-832f-d86f2a280f8a',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'e948e1b1-a591-40bd-b215-a4b3f723ca7f' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'ArtifactTypeID')) BEGIN
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
            'e948e1b1-a591-40bd-b215-a4b3f723ca7f',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
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
            '01717D19-EAB2-4C41-AD39-864BB1555D2F',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'dabcf878-b859-43e1-81ad-1b3b5fac8420' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'Provider')) BEGIN
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
            'dabcf878-b859-43e1-81ad-1b3b5fac8420',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '7a1adbdc-fe0e-411b-80cd-0a67460d40f0' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'ExternalID')) BEGIN
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
            '7a1adbdc-fe0e-411b-80cd-0a67460d40f0',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '5a58a761-4af9-4371-9a9f-34d05590ae87' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'URL')) BEGIN
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
            '5a58a761-4af9-4371-9a9f-34d05590ae87',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '305360c2-44d9-416c-9b98-f4ab947f41ec' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'MimeType')) BEGIN
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
            '305360c2-44d9-416c-9b98-f4ab947f41ec',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '366a1bf2-227d-4319-ab2c-7f2adf29fb5f' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'FileSize')) BEGIN
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
            '366a1bf2-227d-4319-ab2c-7f2adf29fb5f',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '17786941-bbe8-4e5a-9dab-3a070ecf4953' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'UploadedByPersonID')) BEGIN
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
            '17786941-bbe8-4e5a-9dab-3a070ecf4953',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '043042fa-8e84-411f-a9fa-9a729d82820d' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'Committee')) BEGIN
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
            '043042fa-8e84-411f-a9fa-9a729d82820d',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
            100015,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '7a5afff4-a48f-4683-a76a-67f86972c038' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'ArtifactType')) BEGIN
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
            '7a5afff4-a48f-4683-a76a-67f86972c038',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
            100016,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '88431915-0f7d-4e5c-bc9a-fd95706c941b' OR (EntityID = '2B971E92-BBCE-462C-9868-807F9C04430D' AND Name = 'ID')) BEGIN
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
            '88431915-0f7d-4e5c-bc9a-fd95706c941b',
            '2B971E92-BBCE-462C-9868-807F9C04430D', -- Entity: Committees
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '8193dbd4-d612-4bac-8b17-f4113dee257a' OR (EntityID = '2B971E92-BBCE-462C-9868-807F9C04430D' AND Name = 'Name')) BEGIN
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
            '8193dbd4-d612-4bac-8b17-f4113dee257a',
            '2B971E92-BBCE-462C-9868-807F9C04430D', -- Entity: Committees
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '867f6d12-3fa5-40e0-93c4-e20e48fa6d0c' OR (EntityID = '2B971E92-BBCE-462C-9868-807F9C04430D' AND Name = 'Description')) BEGIN
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
            '867f6d12-3fa5-40e0-93c4-e20e48fa6d0c',
            '2B971E92-BBCE-462C-9868-807F9C04430D', -- Entity: Committees
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'd447b324-45b7-45c6-ad55-25c4832bf2d2' OR (EntityID = '2B971E92-BBCE-462C-9868-807F9C04430D' AND Name = 'TypeID')) BEGIN
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
            'd447b324-45b7-45c6-ad55-25c4832bf2d2',
            '2B971E92-BBCE-462C-9868-807F9C04430D', -- Entity: Committees
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
            '45382FA4-D82D-40F9-A105-24F227AB50C8',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '28b3b925-ea9d-45d9-90c7-a80ef90310a4' OR (EntityID = '2B971E92-BBCE-462C-9868-807F9C04430D' AND Name = 'ParentCommitteeID')) BEGIN
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
            '28b3b925-ea9d-45d9-90c7-a80ef90310a4',
            '2B971E92-BBCE-462C-9868-807F9C04430D', -- Entity: Committees
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'd49864f3-8ffe-4dd7-8686-8c629cd656ef' OR (EntityID = '2B971E92-BBCE-462C-9868-807F9C04430D' AND Name = 'OrganizationID')) BEGIN
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
            'd49864f3-8ffe-4dd7-8686-8c629cd656ef',
            '2B971E92-BBCE-462C-9868-807F9C04430D', -- Entity: Committees
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'e104df24-1a71-4437-a971-ff8064103005' OR (EntityID = '2B971E92-BBCE-462C-9868-807F9C04430D' AND Name = 'CharterDocumentURL')) BEGIN
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
            'e104df24-1a71-4437-a971-ff8064103005',
            '2B971E92-BBCE-462C-9868-807F9C04430D', -- Entity: Committees
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '73e40e52-02db-47ff-be41-8f696bafb190' OR (EntityID = '2B971E92-BBCE-462C-9868-807F9C04430D' AND Name = 'MissionStatement')) BEGIN
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
            '73e40e52-02db-47ff-be41-8f696bafb190',
            '2B971E92-BBCE-462C-9868-807F9C04430D', -- Entity: Committees
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'd6f9a1ce-45fa-49c1-961a-346bbd3f507e' OR (EntityID = '2B971E92-BBCE-462C-9868-807F9C04430D' AND Name = 'Status')) BEGIN
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
            'd6f9a1ce-45fa-49c1-961a-346bbd3f507e',
            '2B971E92-BBCE-462C-9868-807F9C04430D', -- Entity: Committees
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '25a841e5-3af7-47cb-9863-3f591b662d45' OR (EntityID = '2B971E92-BBCE-462C-9868-807F9C04430D' AND Name = 'IsPublic')) BEGIN
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
            '25a841e5-3af7-47cb-9863-3f591b662d45',
            '2B971E92-BBCE-462C-9868-807F9C04430D', -- Entity: Committees
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c54d7fa6-5a38-4c1b-ba72-8c33d133a695' OR (EntityID = '2B971E92-BBCE-462C-9868-807F9C04430D' AND Name = 'FormationDate')) BEGIN
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
            'c54d7fa6-5a38-4c1b-ba72-8c33d133a695',
            '2B971E92-BBCE-462C-9868-807F9C04430D', -- Entity: Committees
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '3fc4f1e7-ee4a-489e-b419-98102bb3c2ac' OR (EntityID = '2B971E92-BBCE-462C-9868-807F9C04430D' AND Name = 'DissolutionDate')) BEGIN
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
            '3fc4f1e7-ee4a-489e-b419-98102bb3c2ac',
            '2B971E92-BBCE-462C-9868-807F9C04430D', -- Entity: Committees
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '9d992975-6e4a-442d-8f1d-21f799b656ba' OR (EntityID = '2B971E92-BBCE-462C-9868-807F9C04430D' AND Name = '__mj_CreatedAt')) BEGIN
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
            '9d992975-6e4a-442d-8f1d-21f799b656ba',
            '2B971E92-BBCE-462C-9868-807F9C04430D', -- Entity: Committees
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '564e1db9-5f6d-4352-957b-ba07076d7b74' OR (EntityID = '2B971E92-BBCE-462C-9868-807F9C04430D' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '564e1db9-5f6d-4352-957b-ba07076d7b74',
            '2B971E92-BBCE-462C-9868-807F9C04430D', -- Entity: Committees
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'b4b7b5ce-acf5-478b-be12-fff166d8f9e1' OR (EntityID = '2B971E92-BBCE-462C-9868-807F9C04430D' AND Name = 'Type')) BEGIN
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
            'b4b7b5ce-acf5-478b-be12-fff166d8f9e1',
            '2B971E92-BBCE-462C-9868-807F9C04430D', -- Entity: Committees
            100015,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '5bdb6d78-7496-4df0-921e-fd5c70c52eb9' OR (EntityID = '2B971E92-BBCE-462C-9868-807F9C04430D' AND Name = 'ParentCommittee')) BEGIN
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
            '5bdb6d78-7496-4df0-921e-fd5c70c52eb9',
            '2B971E92-BBCE-462C-9868-807F9C04430D', -- Entity: Committees
            100016,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c203c5e3-2ffc-4a8d-910e-c9a9fb97b60a' OR (EntityID = '2B971E92-BBCE-462C-9868-807F9C04430D' AND Name = 'Organization')) BEGIN
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
            'c203c5e3-2ffc-4a8d-910e-c9a9fb97b60a',
            '2B971E92-BBCE-462C-9868-807F9C04430D', -- Entity: Committees
            100017,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '83ab3738-c8d7-4e55-a74c-869a8c6b2310' OR (EntityID = '2B971E92-BBCE-462C-9868-807F9C04430D' AND Name = 'RootParentCommitteeID')) BEGIN
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
            '83ab3738-c8d7-4e55-a74c-869a8c6b2310',
            '2B971E92-BBCE-462C-9868-807F9C04430D', -- Entity: Committees
            100018,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'b23ee2a2-d8a6-4793-81b8-081a60d007d7' OR (EntityID = '01717D19-EAB2-4C41-AD39-864BB1555D2F' AND Name = 'ID')) BEGIN
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
            'b23ee2a2-d8a6-4793-81b8-081a60d007d7',
            '01717D19-EAB2-4C41-AD39-864BB1555D2F', -- Entity: Artifact Types
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'e651a58b-54ac-4a92-8cc3-cf4da7fad5fb' OR (EntityID = '01717D19-EAB2-4C41-AD39-864BB1555D2F' AND Name = 'Name')) BEGIN
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
            'e651a58b-54ac-4a92-8cc3-cf4da7fad5fb',
            '01717D19-EAB2-4C41-AD39-864BB1555D2F', -- Entity: Artifact Types
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'be085a89-591b-40d5-bd50-c8282e5e5d1c' OR (EntityID = '01717D19-EAB2-4C41-AD39-864BB1555D2F' AND Name = 'Description')) BEGIN
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
            'be085a89-591b-40d5-bd50-c8282e5e5d1c',
            '01717D19-EAB2-4C41-AD39-864BB1555D2F', -- Entity: Artifact Types
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '0df9a2ba-f8d6-4e9f-a896-4a431f721985' OR (EntityID = '01717D19-EAB2-4C41-AD39-864BB1555D2F' AND Name = 'ExtendedEntityID')) BEGIN
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
            '0df9a2ba-f8d6-4e9f-a896-4a431f721985',
            '01717D19-EAB2-4C41-AD39-864BB1555D2F', -- Entity: Artifact Types
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '62f64169-51b0-40ab-a32a-954842624cae' OR (EntityID = '01717D19-EAB2-4C41-AD39-864BB1555D2F' AND Name = 'IconClass')) BEGIN
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
            '62f64169-51b0-40ab-a32a-954842624cae',
            '01717D19-EAB2-4C41-AD39-864BB1555D2F', -- Entity: Artifact Types
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '271d1232-591c-4092-91c9-498c5b3ad538' OR (EntityID = '01717D19-EAB2-4C41-AD39-864BB1555D2F' AND Name = '__mj_CreatedAt')) BEGIN
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
            '271d1232-591c-4092-91c9-498c5b3ad538',
            '01717D19-EAB2-4C41-AD39-864BB1555D2F', -- Entity: Artifact Types
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '7b4b4d2f-0525-45c8-a71e-fe60eddeae1a' OR (EntityID = '01717D19-EAB2-4C41-AD39-864BB1555D2F' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '7b4b4d2f-0525-45c8-a71e-fe60eddeae1a',
            '01717D19-EAB2-4C41-AD39-864BB1555D2F', -- Entity: Artifact Types
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1f8b7662-5462-48a3-9d4b-6d66fb336824' OR (EntityID = '01717D19-EAB2-4C41-AD39-864BB1555D2F' AND Name = 'ExtendedEntity')) BEGIN
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
            '1f8b7662-5462-48a3-9d4b-6d66fb336824',
            '01717D19-EAB2-4C41-AD39-864BB1555D2F', -- Entity: Artifact Types
            100008,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '40ea1d10-2d87-4337-944a-48dfcee061dc' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = 'ID')) BEGIN
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
            '40ea1d10-2d87-4337-944a-48dfcee061dc',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '83988be7-e19b-48ba-a360-e3158d903f48' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = 'MeetingID')) BEGIN
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
            '83988be7-e19b-48ba-a360-e3158d903f48',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1b91ba05-53a2-4c5c-b034-22bc1832ccdf' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = 'AgendaItemID')) BEGIN
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
            '1b91ba05-53a2-4c5c-b034-22bc1832ccdf',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '2d91f10d-04a1-4b00-bcf7-d889e80303cc' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = 'Sequence')) BEGIN
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
            '2d91f10d-04a1-4b00-bcf7-d889e80303cc',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'a8482d32-01f1-448d-a958-354a46144f4f' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = 'Title')) BEGIN
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
            'a8482d32-01f1-448d-a958-354a46144f4f',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '3b9453f6-ec9e-4d47-bc10-29c9e09463d1' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = 'Description')) BEGIN
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
            '3b9453f6-ec9e-4d47-bc10-29c9e09463d1',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'de818f09-2cc4-4b00-8635-aac75320ba53' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = 'MovedByMembershipID')) BEGIN
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
            'de818f09-2cc4-4b00-8635-aac75320ba53',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
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
            'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '8a849122-7ec5-476d-a8e8-a7561bdd4be4' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = 'SecondedByMembershipID')) BEGIN
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
            '8a849122-7ec5-476d-a8e8-a7561bdd4be4',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
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
            'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1e001563-e6b3-49cd-ab5a-bccfcfbe04e6' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = 'Result')) BEGIN
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
            '1e001563-e6b3-49cd-ab5a-bccfcfbe04e6',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'b33e9c74-c557-4a7b-9e6a-da885582017d' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = 'ResultSummary')) BEGIN
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
            'b33e9c74-c557-4a7b-9e6a-da885582017d',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c261b616-394b-438e-8d8a-fa69b869fe66' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = 'YesCount')) BEGIN
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
            'c261b616-394b-438e-8d8a-fa69b869fe66',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '65fdfa6a-9f61-42bc-a371-cb41634f0305' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = 'NoCount')) BEGIN
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
            '65fdfa6a-9f61-42bc-a371-cb41634f0305',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '48291a88-3b5e-4fcb-99c8-c22d7eddf97b' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = 'AbstainCount')) BEGIN
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
            '48291a88-3b5e-4fcb-99c8-c22d7eddf97b',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c2c862e1-c0c9-4004-a0da-fa2fe45dd3a1' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = 'Notes')) BEGIN
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
            'c2c862e1-c0c9-4004-a0da-fa2fe45dd3a1',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '9cc3f2bd-a9e0-4034-8759-6912199189e4' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = 'ID')) BEGIN
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
            '9cc3f2bd-a9e0-4034-8759-6912199189e4',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'f1241e55-fefe-4cbe-ba7d-9b79feca3126' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = 'CommitteeID')) BEGIN
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
            'f1241e55-fefe-4cbe-ba7d-9b79feca3126',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '629d9c8f-ac11-479a-852e-41213263f696' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = 'Title')) BEGIN
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
            '629d9c8f-ac11-479a-852e-41213263f696',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '923d4880-c2df-454f-b06c-392027c0b89c' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = 'Description')) BEGIN
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
            '923d4880-c2df-454f-b06c-392027c0b89c',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '45d8faf6-513d-40ab-858a-83a046cf0e96' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = 'StartDateTime')) BEGIN
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
            '45d8faf6-513d-40ab-858a-83a046cf0e96',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'af847ea1-8549-4ac5-a03f-fd2c53824f26' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = 'EndDateTime')) BEGIN
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
            'af847ea1-8549-4ac5-a03f-fd2c53824f26',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '3d47dde6-9a48-49a4-97b9-b74c113b1c89' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = 'TimeZone')) BEGIN
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
            '3d47dde6-9a48-49a4-97b9-b74c113b1c89',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'df7e91b3-3d0c-4860-913a-3abd79e1aa85' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = 'LocationType')) BEGIN
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
            'df7e91b3-3d0c-4860-913a-3abd79e1aa85',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'ca026fcd-1b43-4c6e-984a-27e197b474ac' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = 'LocationText')) BEGIN
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
            'ca026fcd-1b43-4c6e-984a-27e197b474ac',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'fef1718a-741b-44f3-8c79-17b1b7880c90' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = 'VideoProvider')) BEGIN
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
            'fef1718a-741b-44f3-8c79-17b1b7880c90',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '699639bb-6601-4fdf-92e1-322bed6a2394' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = 'VideoMeetingID')) BEGIN
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
            '699639bb-6601-4fdf-92e1-322bed6a2394',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'b00edd25-53fa-44c3-b540-a8ce4e16bb8b' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = 'VideoJoinURL')) BEGIN
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
            'b00edd25-53fa-44c3-b540-a8ce4e16bb8b',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '675a855f-2da3-40bb-b522-3a5e346f6dae' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = 'VideoRecordingURL')) BEGIN
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
            '675a855f-2da3-40bb-b522-3a5e346f6dae',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '85b0ae79-1e21-48c5-9aea-2b4d538ad6de' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = 'TranscriptURL')) BEGIN
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
            '85b0ae79-1e21-48c5-9aea-2b4d538ad6de',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '2ddbeb25-13d4-4157-9141-75b3fa3e6b20' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = 'Status')) BEGIN
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
            '2ddbeb25-13d4-4157-9141-75b3fa3e6b20',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '2a813c73-484b-40b7-be33-094fdb113416' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = 'CalendarEventID')) BEGIN
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
            '2a813c73-484b-40b7-be33-094fdb113416',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '852b0082-7008-497d-8ccc-3a86dc371fdf' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = 'Committee')) BEGIN
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
            '852b0082-7008-497d-8ccc-3a86dc371fdf',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '292f9b62-3e11-4bb3-9d27-5b491d944c4c' OR (EntityID = '213B8FB0-6855-442C-8D60-B126F6AE2D38' AND Name = 'ID')) BEGIN
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
            '292f9b62-3e11-4bb3-9d27-5b491d944c4c',
            '213B8FB0-6855-442C-8D60-B126F6AE2D38', -- Entity: Roles
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '01189293-73e8-472c-85cd-1d34e98db573' OR (EntityID = '213B8FB0-6855-442C-8D60-B126F6AE2D38' AND Name = 'Name')) BEGIN
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
            '01189293-73e8-472c-85cd-1d34e98db573',
            '213B8FB0-6855-442C-8D60-B126F6AE2D38', -- Entity: Roles
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'd71f526f-711a-4b8e-93d5-261fb8bfff56' OR (EntityID = '213B8FB0-6855-442C-8D60-B126F6AE2D38' AND Name = 'Description')) BEGIN
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
            'd71f526f-711a-4b8e-93d5-261fb8bfff56',
            '213B8FB0-6855-442C-8D60-B126F6AE2D38', -- Entity: Roles
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'e7e8477d-21dd-41aa-9d2c-ee4178699832' OR (EntityID = '213B8FB0-6855-442C-8D60-B126F6AE2D38' AND Name = 'IsOfficer')) BEGIN
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
            'e7e8477d-21dd-41aa-9d2c-ee4178699832',
            '213B8FB0-6855-442C-8D60-B126F6AE2D38', -- Entity: Roles
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '10bc7c08-fe35-4d29-9f27-f38701c8ba01' OR (EntityID = '213B8FB0-6855-442C-8D60-B126F6AE2D38' AND Name = 'IsVotingRole')) BEGIN
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
            '10bc7c08-fe35-4d29-9f27-f38701c8ba01',
            '213B8FB0-6855-442C-8D60-B126F6AE2D38', -- Entity: Roles
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'a7e540fa-092e-4f81-ad7a-ad5b9b25175d' OR (EntityID = '213B8FB0-6855-442C-8D60-B126F6AE2D38' AND Name = 'DefaultPermissionsJSON')) BEGIN
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
            'a7e540fa-092e-4f81-ad7a-ad5b9b25175d',
            '213B8FB0-6855-442C-8D60-B126F6AE2D38', -- Entity: Roles
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'a5942466-bfa4-43ed-99dc-fe1083bf27d9' OR (EntityID = '213B8FB0-6855-442C-8D60-B126F6AE2D38' AND Name = 'Sequence')) BEGIN
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
            'a5942466-bfa4-43ed-99dc-fe1083bf27d9',
            '213B8FB0-6855-442C-8D60-B126F6AE2D38', -- Entity: Roles
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '3c5ce0b2-f27e-4c29-9692-3e3f23c338a7' OR (EntityID = '5F56A290-08C7-4405-9C21-B4389869D995' AND Name = 'ID')) BEGIN
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
            '3c5ce0b2-f27e-4c29-9692-3e3f23c338a7',
            '5F56A290-08C7-4405-9C21-B4389869D995', -- Entity: Attendances
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'b68258d1-9020-419d-bdd4-277747331cc9' OR (EntityID = '5F56A290-08C7-4405-9C21-B4389869D995' AND Name = 'MeetingID')) BEGIN
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
            'b68258d1-9020-419d-bdd4-277747331cc9',
            '5F56A290-08C7-4405-9C21-B4389869D995', -- Entity: Attendances
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
            'C6C5BD14-0D36-4442-812E-97F802728524',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '64aca6a1-5351-409b-b19e-9b92cc2880f0' OR (EntityID = '5F56A290-08C7-4405-9C21-B4389869D995' AND Name = 'PersonID')) BEGIN
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
            '64aca6a1-5351-409b-b19e-9b92cc2880f0',
            '5F56A290-08C7-4405-9C21-B4389869D995', -- Entity: Attendances
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '65cacdd5-8a4c-424f-ab16-f666811f1bfe' OR (EntityID = '5F56A290-08C7-4405-9C21-B4389869D995' AND Name = 'AttendanceStatus')) BEGIN
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
            '65cacdd5-8a4c-424f-ab16-f666811f1bfe',
            '5F56A290-08C7-4405-9C21-B4389869D995', -- Entity: Attendances
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'e7cc6bef-c5ba-4315-8ec8-73e16684672c' OR (EntityID = '5F56A290-08C7-4405-9C21-B4389869D995' AND Name = 'JoinedAt')) BEGIN
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
            'e7cc6bef-c5ba-4315-8ec8-73e16684672c',
            '5F56A290-08C7-4405-9C21-B4389869D995', -- Entity: Attendances
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'b427aa57-a9d2-4855-91e4-dd0ed272de7a' OR (EntityID = '5F56A290-08C7-4405-9C21-B4389869D995' AND Name = 'LeftAt')) BEGIN
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
            'b427aa57-a9d2-4855-91e4-dd0ed272de7a',
            '5F56A290-08C7-4405-9C21-B4389869D995', -- Entity: Attendances
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '6824ab44-02a1-4aba-ada3-9708cc7e7641' OR (EntityID = '5F56A290-08C7-4405-9C21-B4389869D995' AND Name = 'Notes')) BEGIN
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
            '6824ab44-02a1-4aba-ada3-9708cc7e7641',
            '5F56A290-08C7-4405-9C21-B4389869D995', -- Entity: Attendances
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '53f86fac-bfb1-42fa-ae35-2542caa8e3c6' OR (EntityID = '5F56A290-08C7-4405-9C21-B4389869D995' AND Name = '__mj_CreatedAt')) BEGIN
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
            '53f86fac-bfb1-42fa-ae35-2542caa8e3c6',
            '5F56A290-08C7-4405-9C21-B4389869D995', -- Entity: Attendances
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '947978d3-7fc1-494d-a185-d812fcaa6770' OR (EntityID = '5F56A290-08C7-4405-9C21-B4389869D995' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '947978d3-7fc1-494d-a185-d812fcaa6770',
            '5F56A290-08C7-4405-9C21-B4389869D995', -- Entity: Attendances
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1f885eed-15cd-41dc-b5dc-af2f587a56dc' OR (EntityID = 'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D' AND Name = 'ID')) BEGIN
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
            '1f885eed-15cd-41dc-b5dc-af2f587a56dc',
            'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D', -- Entity: Terms
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'fa338df3-0781-4d4c-afe6-8ce7b13f0d64' OR (EntityID = 'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D' AND Name = 'CommitteeID')) BEGIN
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
            'fa338df3-0781-4d4c-afe6-8ce7b13f0d64',
            'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D', -- Entity: Terms
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '918aa42b-ff44-43b4-bcb2-0842602962df' OR (EntityID = 'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D' AND Name = 'Name')) BEGIN
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
            '918aa42b-ff44-43b4-bcb2-0842602962df',
            'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D', -- Entity: Terms
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1dcbfe34-3d1a-4490-8e65-e8117f93b116' OR (EntityID = 'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D' AND Name = 'StartDate')) BEGIN
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
            '1dcbfe34-3d1a-4490-8e65-e8117f93b116',
            'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D', -- Entity: Terms
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '30791651-1ac3-4e9a-b044-6c9f2000f857' OR (EntityID = 'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D' AND Name = 'EndDate')) BEGIN
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
            '30791651-1ac3-4e9a-b044-6c9f2000f857',
            'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D', -- Entity: Terms
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '5614f5a4-86fd-4fa1-a5bb-7ed0e6d9aa26' OR (EntityID = 'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D' AND Name = 'Status')) BEGIN
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
            '5614f5a4-86fd-4fa1-a5bb-7ed0e6d9aa26',
            'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D', -- Entity: Terms
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '7dbc4c1f-7d71-426a-80e3-c88a1f772c01' OR (EntityID = 'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D' AND Name = 'Committee')) BEGIN
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
            '7dbc4c1f-7d71-426a-80e3-c88a1f772c01',
            'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D', -- Entity: Terms
            100007,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '3fd73786-b92b-4197-9575-566bb9f40d9d' OR (EntityID = 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6' AND Name = 'ID')) BEGIN
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
            '3fd73786-b92b-4197-9575-566bb9f40d9d',
            'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', -- Entity: Memberships
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '9ec10e3d-f9a0-4c7c-a262-b3c0b547780b' OR (EntityID = 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6' AND Name = 'CommitteeID')) BEGIN
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
            '9ec10e3d-f9a0-4c7c-a262-b3c0b547780b',
            'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', -- Entity: Memberships
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '30b03be5-1775-456f-b899-9658056f3665' OR (EntityID = 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6' AND Name = 'PersonID')) BEGIN
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
            '30b03be5-1775-456f-b899-9658056f3665',
            'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', -- Entity: Memberships
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'ff81a867-5efb-4fe7-8515-5126b329d94d' OR (EntityID = 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6' AND Name = 'RoleID')) BEGIN
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
            'ff81a867-5efb-4fe7-8515-5126b329d94d',
            'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', -- Entity: Memberships
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
            '213B8FB0-6855-442C-8D60-B126F6AE2D38',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'fbc3beaa-4fad-4bf9-b31d-71a6f4809765' OR (EntityID = 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6' AND Name = 'TermID')) BEGIN
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
            'fbc3beaa-4fad-4bf9-b31d-71a6f4809765',
            'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', -- Entity: Memberships
            100005,
            'TermID',
            'Term ID',
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
            'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'ffcbf67a-d89d-49e9-9625-67340fa67e65' OR (EntityID = 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6' AND Name = 'StartDate')) BEGIN
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
            'ffcbf67a-d89d-49e9-9625-67340fa67e65',
            'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', -- Entity: Memberships
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c361b0ed-2a37-417f-878e-13e78ebfba39' OR (EntityID = 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6' AND Name = 'EndDate')) BEGIN
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
            'c361b0ed-2a37-417f-878e-13e78ebfba39',
            'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', -- Entity: Memberships
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '2c1ad820-598d-4bc3-ad20-8a75c1144a5e' OR (EntityID = 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6' AND Name = 'Status')) BEGIN
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
            '2c1ad820-598d-4bc3-ad20-8a75c1144a5e',
            'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', -- Entity: Memberships
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '8dbc5df8-12dc-4ec6-9548-60042fa1313f' OR (EntityID = 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6' AND Name = 'EndReason')) BEGIN
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
            '8dbc5df8-12dc-4ec6-9548-60042fa1313f',
            'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', -- Entity: Memberships
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'd17c9b81-5abb-45a4-9c30-d9d8214a5cba' OR (EntityID = 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6' AND Name = 'Notes')) BEGIN
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
            'd17c9b81-5abb-45a4-9c30-d9d8214a5cba',
            'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', -- Entity: Memberships
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '503ba90f-4261-4c3f-b7e9-cf04058be313' OR (EntityID = 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6' AND Name = 'Committee')) BEGIN
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
            '503ba90f-4261-4c3f-b7e9-cf04058be313',
            'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', -- Entity: Memberships
            100011,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '7b128c05-68b0-4639-b0ee-e10e003984b2' OR (EntityID = 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6' AND Name = 'Role')) BEGIN
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
            '7b128c05-68b0-4639-b0ee-e10e003984b2',
            'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', -- Entity: Memberships
            100012,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'a394bee2-4d53-478c-a422-b98be40e0351' OR (EntityID = 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6' AND Name = 'Term')) BEGIN
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
            'a394bee2-4d53-478c-a422-b98be40e0351',
            'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', -- Entity: Memberships
            100013,
            'Term',
            'Term',
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

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'ccdedd90-f689-48cd-b71c-08cb071b9442' OR (EntityID = 'F77CA3D7-5717-4149-8479-F258EF819C7A' AND Name = 'ID')) BEGIN
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
            'ccdedd90-f689-48cd-b71c-08cb071b9442',
            'F77CA3D7-5717-4149-8479-F258EF819C7A', -- Entity: Votes
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '96acc971-ed28-4917-be17-c66714eeb8d0' OR (EntityID = 'F77CA3D7-5717-4149-8479-F258EF819C7A' AND Name = 'MotionID')) BEGIN
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
            '96acc971-ed28-4917-be17-c66714eeb8d0',
            'F77CA3D7-5717-4149-8479-F258EF819C7A', -- Entity: Votes
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
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '8f9e992f-3912-49e9-aa2c-b10db0335bfb' OR (EntityID = 'F77CA3D7-5717-4149-8479-F258EF819C7A' AND Name = 'MembershipID')) BEGIN
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
            '8f9e992f-3912-49e9-aa2c-b10db0335bfb',
            'F77CA3D7-5717-4149-8479-F258EF819C7A', -- Entity: Votes
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
            'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'e0c19372-93d7-4e75-915b-bbd903458c7c' OR (EntityID = 'F77CA3D7-5717-4149-8479-F258EF819C7A' AND Name = 'VoteValue')) BEGIN
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
            'e0c19372-93d7-4e75-915b-bbd903458c7c',
            'F77CA3D7-5717-4149-8479-F258EF819C7A', -- Entity: Votes
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '82e90d63-1575-45ab-99b2-37e5a69765bf' OR (EntityID = 'F77CA3D7-5717-4149-8479-F258EF819C7A' AND Name = 'Notes')) BEGIN
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
            '82e90d63-1575-45ab-99b2-37e5a69765bf',
            'F77CA3D7-5717-4149-8479-F258EF819C7A', -- Entity: Votes
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'ba67048a-587e-415c-91f7-2676c6771e03' OR (EntityID = 'BFA46589-88E7-45AF-A1DD-F9910DDD1717' AND Name = 'ID')) BEGIN
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
            'ba67048a-587e-415c-91f7-2676c6771e03',
            'BFA46589-88E7-45AF-A1DD-F9910DDD1717', -- Entity: Minutes
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'f1eadc64-b2e6-4bdc-8f6c-305e72b0e691' OR (EntityID = 'BFA46589-88E7-45AF-A1DD-F9910DDD1717' AND Name = 'ArtifactID')) BEGIN
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
            'f1eadc64-b2e6-4bdc-8f6c-305e72b0e691',
            'BFA46589-88E7-45AF-A1DD-F9910DDD1717', -- Entity: Minutes
            100002,
            'ArtifactID',
            'Artifact ID',
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
            'DC523BBE-93DC-49FC-B066-621D3C8162E2',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '49a875bb-7630-4e94-ac58-66f610000bc1' OR (EntityID = 'BFA46589-88E7-45AF-A1DD-F9910DDD1717' AND Name = 'ApprovalStatus')) BEGIN
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
            '49a875bb-7630-4e94-ac58-66f610000bc1',
            'BFA46589-88E7-45AF-A1DD-F9910DDD1717', -- Entity: Minutes
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '91e0e487-d81b-4602-af75-52c5fcfb00ec' OR (EntityID = 'BFA46589-88E7-45AF-A1DD-F9910DDD1717' AND Name = 'ApprovedAt')) BEGIN
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
            '91e0e487-d81b-4602-af75-52c5fcfb00ec',
            'BFA46589-88E7-45AF-A1DD-F9910DDD1717', -- Entity: Minutes
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '9e8778ce-5fb2-4f2c-82d2-581d5bd728a7' OR (EntityID = 'BFA46589-88E7-45AF-A1DD-F9910DDD1717' AND Name = 'ApprovedByMeetingID')) BEGIN
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
            '9e8778ce-5fb2-4f2c-82d2-581d5bd728a7',
            'BFA46589-88E7-45AF-A1DD-F9910DDD1717', -- Entity: Minutes
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '6d7a2bbe-6a1c-4a13-8972-104777b69beb' OR (EntityID = 'BFA46589-88E7-45AF-A1DD-F9910DDD1717' AND Name = 'Notes')) BEGIN
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
            '6d7a2bbe-6a1c-4a13-8972-104777b69beb',
            'BFA46589-88E7-45AF-A1DD-F9910DDD1717', -- Entity: Minutes
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '27a7ea95-f423-4618-8035-c6cef17ccad0' OR (EntityID = 'BFA46589-88E7-45AF-A1DD-F9910DDD1717' AND Name = '__mj_CreatedAt')) BEGIN
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
            '27a7ea95-f423-4618-8035-c6cef17ccad0',
            'BFA46589-88E7-45AF-A1DD-F9910DDD1717', -- Entity: Minutes
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'f517a92b-f5c7-4842-a904-cf57239f677f' OR (EntityID = 'BFA46589-88E7-45AF-A1DD-F9910DDD1717' AND Name = '__mj_UpdatedAt')) BEGIN
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
            'f517a92b-f5c7-4842-a904-cf57239f677f',
            'BFA46589-88E7-45AF-A1DD-F9910DDD1717', -- Entity: Minutes
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'e5c7526c-c8f9-474a-93ac-3f8fb7c0cbe1' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = 'ID')) BEGIN
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
            'e5c7526c-c8f9-474a-93ac-3f8fb7c0cbe1',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '35136ba7-3c0b-4a3e-a2a9-e8cf321b1430' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = 'CommitteeID')) BEGIN
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
            '35136ba7-3c0b-4a3e-a2a9-e8cf321b1430',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'd38bb5da-f6ad-4a7a-9dd7-9ac4a23bf0ab' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = 'MeetingID')) BEGIN
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
            'd38bb5da-f6ad-4a7a-9dd7-9ac4a23bf0ab',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '5b1f0905-8009-484c-a9fb-c475489e9dc7' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = 'AgendaItemID')) BEGIN
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
            '5b1f0905-8009-484c-a9fb-c475489e9dc7',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '9752a9e9-fc94-4712-b1d0-52ad37899e6f' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = 'Title')) BEGIN
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
            '9752a9e9-fc94-4712-b1d0-52ad37899e6f',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '59c8a57a-bf84-4be2-8019-53dbb77c31da' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = 'Description')) BEGIN
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
            '59c8a57a-bf84-4be2-8019-53dbb77c31da',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1a44989e-e463-4f19-8bd4-ee69c6dbe58c' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = 'AssignedToPersonID')) BEGIN
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
            '1a44989e-e463-4f19-8bd4-ee69c6dbe58c',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'a6c292a6-8207-4832-b0ab-f04a195adc29' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = 'AssignedByPersonID')) BEGIN
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
            'a6c292a6-8207-4832-b0ab-f04a195adc29',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'd2b8da2b-1884-44fd-9494-b07b0e50b4b4' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = 'DueDate')) BEGIN
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
            'd2b8da2b-1884-44fd-9494-b07b0e50b4b4',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'b4e41f97-23f4-4718-b60c-50ef56d75670' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = 'Priority')) BEGIN
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
            'b4e41f97-23f4-4718-b60c-50ef56d75670',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '88828b5a-415f-40e0-90b7-7b5567375d34' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = 'Status')) BEGIN
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
            '88828b5a-415f-40e0-90b7-7b5567375d34',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '0c244108-85a6-4ea5-801e-38e3fd9322fd' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = 'CompletedAt')) BEGIN
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
            '0c244108-85a6-4ea5-801e-38e3fd9322fd',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '6237159d-d2f0-4565-9d3b-6d39b1bff4a8' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = 'CompletionNotes')) BEGIN
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
            '6237159d-d2f0-4565-9d3b-6d39b1bff4a8',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c30c23fa-0545-4914-b4b9-efaf9bbe1b99' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = 'Committee')) BEGIN
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
            'c30c23fa-0545-4914-b4b9-efaf9bbe1b99',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
            100014,
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

/* SQL text to insert entity field value with ID 2870d9ae-a878-496f-8339-e02722ff4ada */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('2870d9ae-a878-496f-8339-e02722ff4ada', 'D6F9A1CE-45FA-49C1-961A-346BBD3F507E', 1, 'Active', 'Active', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 60526c1b-56ba-4af6-adad-1b0a1f71eac7 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('60526c1b-56ba-4af6-adad-1b0a1f71eac7', 'D6F9A1CE-45FA-49C1-961A-346BBD3F507E', 2, 'Dissolved', 'Dissolved', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID b1f48e96-a815-493a-8526-79fb0c45ab0b */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('b1f48e96-a815-493a-8526-79fb0c45ab0b', 'D6F9A1CE-45FA-49C1-961A-346BBD3F507E', 3, 'Inactive', 'Inactive', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 1dfb20b1-8224-4abd-b6e6-4c6799b71a7f */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('1dfb20b1-8224-4abd-b6e6-4c6799b71a7f', 'D6F9A1CE-45FA-49C1-961A-346BBD3F507E', 4, 'Pending', 'Pending', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID D6F9A1CE-45FA-49C1-961A-346BBD3F507E */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='D6F9A1CE-45FA-49C1-961A-346BBD3F507E'

/* SQL text to insert entity field value with ID c7515e5b-af7e-43a9-b2c5-533c2420b477 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('c7515e5b-af7e-43a9-b2c5-533c2420b477', '5614F5A4-86FD-4FA1-A5BB-7ED0E6D9AA26', 1, 'Active', 'Active', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 6fbf8ac2-fffc-4080-8019-aa8ff4a77afa */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('6fbf8ac2-fffc-4080-8019-aa8ff4a77afa', '5614F5A4-86FD-4FA1-A5BB-7ED0E6D9AA26', 2, 'Completed', 'Completed', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 02a9d71e-814c-4d9a-8d64-b45dc6edc569 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('02a9d71e-814c-4d9a-8d64-b45dc6edc569', '5614F5A4-86FD-4FA1-A5BB-7ED0E6D9AA26', 3, 'Upcoming', 'Upcoming', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID 5614F5A4-86FD-4FA1-A5BB-7ED0E6D9AA26 */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='5614F5A4-86FD-4FA1-A5BB-7ED0E6D9AA26'

/* SQL text to insert entity field value with ID 25cb162b-28ae-405b-b938-7fb27f665a0c */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('25cb162b-28ae-405b-b938-7fb27f665a0c', '2C1AD820-598D-4BC3-AD20-8A75C1144A5E', 1, 'Active', 'Active', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID aa15631f-2257-4739-b7c0-039cef86a860 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('aa15631f-2257-4739-b7c0-039cef86a860', '2C1AD820-598D-4BC3-AD20-8A75C1144A5E', 2, 'Ended', 'Ended', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID e8e97b15-e47e-410d-b79e-e63eaf7f7994 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('e8e97b15-e47e-410d-b79e-e63eaf7f7994', '2C1AD820-598D-4BC3-AD20-8A75C1144A5E', 3, 'Pending', 'Pending', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID ead6c44d-3c8c-4373-a8ce-b63358c63f84 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('ead6c44d-3c8c-4373-a8ce-b63358c63f84', '2C1AD820-598D-4BC3-AD20-8A75C1144A5E', 4, 'Suspended', 'Suspended', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID 2C1AD820-598D-4BC3-AD20-8A75C1144A5E */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='2C1AD820-598D-4BC3-AD20-8A75C1144A5E'

/* SQL text to insert entity field value with ID 01865ba7-8649-411b-aaad-7ac8cd3f97d9 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('01865ba7-8649-411b-aaad-7ac8cd3f97d9', '2DDBEB25-13D4-4157-9141-75B3FA3E6B20', 1, 'Cancelled', 'Cancelled', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID a4255867-13ca-4580-9e33-6adaa6b1cb9d */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('a4255867-13ca-4580-9e33-6adaa6b1cb9d', '2DDBEB25-13D4-4157-9141-75B3FA3E6B20', 2, 'Completed', 'Completed', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 5ebb4e07-7d76-4a18-a011-46e6aa34151b */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('5ebb4e07-7d76-4a18-a011-46e6aa34151b', '2DDBEB25-13D4-4157-9141-75B3FA3E6B20', 3, 'Draft', 'Draft', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 242b212e-79e5-469e-842d-80d9b7cd3976 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('242b212e-79e5-469e-842d-80d9b7cd3976', '2DDBEB25-13D4-4157-9141-75B3FA3E6B20', 4, 'InProgress', 'InProgress', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID a98831c5-74b5-4567-a1d4-9740a54caca6 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('a98831c5-74b5-4567-a1d4-9740a54caca6', '2DDBEB25-13D4-4157-9141-75B3FA3E6B20', 5, 'Postponed', 'Postponed', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID bcf27045-32e4-4fcd-a5ed-91d99abec040 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('bcf27045-32e4-4fcd-a5ed-91d99abec040', '2DDBEB25-13D4-4157-9141-75B3FA3E6B20', 6, 'Scheduled', 'Scheduled', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID 2DDBEB25-13D4-4157-9141-75B3FA3E6B20 */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='2DDBEB25-13D4-4157-9141-75B3FA3E6B20'

/* SQL text to insert entity field value with ID 8b57cc7a-fab3-430b-be3b-03f224247564 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('8b57cc7a-fab3-430b-be3b-03f224247564', 'DF7E91B3-3D0C-4860-913A-3ABD79E1AA85', 1, 'Hybrid', 'Hybrid', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID ec3d7831-91d0-4327-84a4-cf9447fa7f1c */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('ec3d7831-91d0-4327-84a4-cf9447fa7f1c', 'DF7E91B3-3D0C-4860-913A-3ABD79E1AA85', 2, 'InPerson', 'InPerson', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID ca470e80-3a45-4be6-a601-026dc3af62f6 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('ca470e80-3a45-4be6-a601-026dc3af62f6', 'DF7E91B3-3D0C-4860-913A-3ABD79E1AA85', 3, 'Virtual', 'Virtual', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID DF7E91B3-3D0C-4860-913A-3ABD79E1AA85 */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='DF7E91B3-3D0C-4860-913A-3ABD79E1AA85'

/* SQL text to insert entity field value with ID 41c8aeb8-06c3-4267-867d-4751470b8bff */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('41c8aeb8-06c3-4267-867d-4751470b8bff', 'E2F64D96-5DE8-4918-84A7-C1A517829BBC', 1, 'Action', 'Action', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 8af10338-989e-4113-8f17-74503f5e28dc */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('8af10338-989e-4113-8f17-74503f5e28dc', 'E2F64D96-5DE8-4918-84A7-C1A517829BBC', 2, 'Discussion', 'Discussion', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 7d4bb510-6007-4056-ae29-00cd0224545d */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('7d4bb510-6007-4056-ae29-00cd0224545d', 'E2F64D96-5DE8-4918-84A7-C1A517829BBC', 3, 'Information', 'Information', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID d7702748-2d5d-42db-8003-7a07ac991d08 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('d7702748-2d5d-42db-8003-7a07ac991d08', 'E2F64D96-5DE8-4918-84A7-C1A517829BBC', 4, 'Other', 'Other', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 1e1f391c-4895-4888-800b-c115460e58c8 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('1e1f391c-4895-4888-800b-c115460e58c8', 'E2F64D96-5DE8-4918-84A7-C1A517829BBC', 5, 'Report', 'Report', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 17ef563a-9ae4-49d0-b06a-e1ff6b05f70e */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('17ef563a-9ae4-49d0-b06a-e1ff6b05f70e', 'E2F64D96-5DE8-4918-84A7-C1A517829BBC', 6, 'Vote', 'Vote', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID E2F64D96-5DE8-4918-84A7-C1A517829BBC */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='E2F64D96-5DE8-4918-84A7-C1A517829BBC'

/* SQL text to insert entity field value with ID 29a3ea48-196e-42f9-9fb2-72ee65efd9bd */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('29a3ea48-196e-42f9-9fb2-72ee65efd9bd', '8FC8E88A-0E6A-475C-9E05-729F103BA062', 1, 'Completed', 'Completed', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID b39bafbc-5b4c-4966-843e-ac3fe0357331 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('b39bafbc-5b4c-4966-843e-ac3fe0357331', '8FC8E88A-0E6A-475C-9E05-729F103BA062', 2, 'Discussed', 'Discussed', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 78ff6e91-c325-4fe7-8a9c-eb403596350c */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('78ff6e91-c325-4fe7-8a9c-eb403596350c', '8FC8E88A-0E6A-475C-9E05-729F103BA062', 3, 'Pending', 'Pending', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 3e8911b3-50f6-4622-afc0-9a3f24a62599 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('3e8911b3-50f6-4622-afc0-9a3f24a62599', '8FC8E88A-0E6A-475C-9E05-729F103BA062', 4, 'Skipped', 'Skipped', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 6c474a79-b0f8-47f4-b4a5-8947b7c8ebc3 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('6c474a79-b0f8-47f4-b4a5-8947b7c8ebc3', '8FC8E88A-0E6A-475C-9E05-729F103BA062', 5, 'Tabled', 'Tabled', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID 8FC8E88A-0E6A-475C-9E05-729F103BA062 */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='8FC8E88A-0E6A-475C-9E05-729F103BA062'

/* SQL text to insert entity field value with ID f5bc4550-d86f-43f8-8b4f-94528c25ccee */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('f5bc4550-d86f-43f8-8b4f-94528c25ccee', '65CACDD5-8A4C-424F-AB16-F666811F1BFE', 1, 'Absent', 'Absent', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID af2ea67c-0831-4803-9578-852786a74dba */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('af2ea67c-0831-4803-9578-852786a74dba', '65CACDD5-8A4C-424F-AB16-F666811F1BFE', 2, 'Excused', 'Excused', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 5d8422dc-e7eb-4b66-b33b-430822f45159 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('5d8422dc-e7eb-4b66-b33b-430822f45159', '65CACDD5-8A4C-424F-AB16-F666811F1BFE', 3, 'Expected', 'Expected', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 81e62feb-5e52-4903-a135-6c3e219f2a38 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('81e62feb-5e52-4903-a135-6c3e219f2a38', '65CACDD5-8A4C-424F-AB16-F666811F1BFE', 4, 'Partial', 'Partial', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID fb7731cb-7797-48df-9d7d-98a8b2f4f493 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('fb7731cb-7797-48df-9d7d-98a8b2f4f493', '65CACDD5-8A4C-424F-AB16-F666811F1BFE', 5, 'Present', 'Present', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID 65CACDD5-8A4C-424F-AB16-F666811F1BFE */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='65CACDD5-8A4C-424F-AB16-F666811F1BFE'

/* SQL text to insert entity field value with ID e0697a15-a07c-41fe-85e9-33f36963be74 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('e0697a15-a07c-41fe-85e9-33f36963be74', 'B4E41F97-23F4-4718-B60C-50EF56D75670', 1, 'Critical', 'Critical', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 7a3de30a-5e9a-46d2-b375-c2ccbef6764e */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('7a3de30a-5e9a-46d2-b375-c2ccbef6764e', 'B4E41F97-23F4-4718-B60C-50EF56D75670', 2, 'High', 'High', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID a323b1ab-4b82-40ab-9055-59c90db9c3f9 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('a323b1ab-4b82-40ab-9055-59c90db9c3f9', 'B4E41F97-23F4-4718-B60C-50EF56D75670', 3, 'Low', 'Low', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID b3953416-8d54-42b7-b17b-a4a45aec627d */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('b3953416-8d54-42b7-b17b-a4a45aec627d', 'B4E41F97-23F4-4718-B60C-50EF56D75670', 4, 'Medium', 'Medium', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID B4E41F97-23F4-4718-B60C-50EF56D75670 */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='B4E41F97-23F4-4718-B60C-50EF56D75670'

/* SQL text to insert entity field value with ID 34456ff1-f751-4677-a96b-7a102bbd98cf */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('34456ff1-f751-4677-a96b-7a102bbd98cf', '88828B5A-415F-40E0-90B7-7B5567375D34', 1, 'Blocked', 'Blocked', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID d6fd4ae8-bbdd-48cd-aa52-a3f9e6d5cc47 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('d6fd4ae8-bbdd-48cd-aa52-a3f9e6d5cc47', '88828B5A-415F-40E0-90B7-7B5567375D34', 2, 'Cancelled', 'Cancelled', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID f36cf14c-6fc5-44c4-ba18-b3ffa470778b */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('f36cf14c-6fc5-44c4-ba18-b3ffa470778b', '88828B5A-415F-40E0-90B7-7B5567375D34', 3, 'Completed', 'Completed', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID ea7c46f8-8263-429e-92d5-96ac7bc9212a */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('ea7c46f8-8263-429e-92d5-96ac7bc9212a', '88828B5A-415F-40E0-90B7-7B5567375D34', 4, 'InProgress', 'InProgress', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 558ef5fe-4fb7-43e4-bdac-a83d541479ae */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('558ef5fe-4fb7-43e4-bdac-a83d541479ae', '88828B5A-415F-40E0-90B7-7B5567375D34', 5, 'Open', 'Open', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID 88828B5A-415F-40E0-90B7-7B5567375D34 */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='88828B5A-415F-40E0-90B7-7B5567375D34'

/* SQL text to insert entity field value with ID 59fdc536-a351-4696-8fcc-76569d3db975 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('59fdc536-a351-4696-8fcc-76569d3db975', 'DABCF878-B859-43E1-81AD-1B3B5FAC8420', 1, 'Box', 'Box', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 24e1673c-4275-4f51-986f-ba2108ca5336 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('24e1673c-4275-4f51-986f-ba2108ca5336', 'DABCF878-B859-43E1-81AD-1B3B5FAC8420', 2, 'Dropbox', 'Dropbox', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID c57c9e4c-c21d-4eaa-8c24-f7694a28c316 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('c57c9e4c-c21d-4eaa-8c24-f7694a28c316', 'DABCF878-B859-43E1-81AD-1B3B5FAC8420', 3, 'GoogleDrive', 'GoogleDrive', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 0b60b3ea-6e81-4abf-9e56-25da46fb1636 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('0b60b3ea-6e81-4abf-9e56-25da46fb1636', 'DABCF878-B859-43E1-81AD-1B3B5FAC8420', 4, 'OneDrive', 'OneDrive', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 94fba5de-7066-4b9e-961c-2e115b3a6d09 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('94fba5de-7066-4b9e-961c-2e115b3a6d09', 'DABCF878-B859-43E1-81AD-1B3B5FAC8420', 5, 'SharePoint', 'SharePoint', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 1c8d3e38-f233-4741-9d39-8efb652df797 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('1c8d3e38-f233-4741-9d39-8efb652df797', 'DABCF878-B859-43E1-81AD-1B3B5FAC8420', 6, 'URL', 'URL', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID DABCF878-B859-43E1-81AD-1B3B5FAC8420 */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='DABCF878-B859-43E1-81AD-1B3B5FAC8420'

/* SQL text to insert entity field value with ID fc121b2e-0e4c-4410-8247-31e7218e5e91 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('fc121b2e-0e4c-4410-8247-31e7218e5e91', '49A875BB-7630-4E94-AC58-66F610000BC1', 1, 'Approved', 'Approved', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 9447c99e-47c0-477a-b569-a0889ef7e72b */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('9447c99e-47c0-477a-b569-a0889ef7e72b', '49A875BB-7630-4E94-AC58-66F610000BC1', 2, 'Draft', 'Draft', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 205aa326-e53b-4612-a43c-868c1cf0bce9 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('205aa326-e53b-4612-a43c-868c1cf0bce9', '49A875BB-7630-4E94-AC58-66F610000BC1', 3, 'PendingApproval', 'PendingApproval', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 982a0e6f-b2f2-4813-bf66-7686023e6407 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('982a0e6f-b2f2-4813-bf66-7686023e6407', '49A875BB-7630-4E94-AC58-66F610000BC1', 4, 'Rejected', 'Rejected', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID 49A875BB-7630-4E94-AC58-66F610000BC1 */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='49A875BB-7630-4E94-AC58-66F610000BC1'

/* SQL text to insert entity field value with ID 98a47204-44d4-4fac-88b0-a317d5de6495 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('98a47204-44d4-4fac-88b0-a317d5de6495', '1E001563-E6B3-49CD-AB5A-BCCFCFBE04E6', 1, 'Failed', 'Failed', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 5e619f65-6e2d-4f4c-9485-a7c9fccad316 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('5e619f65-6e2d-4f4c-9485-a7c9fccad316', '1E001563-E6B3-49CD-AB5A-BCCFCFBE04E6', 2, 'Passed', 'Passed', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 596f966c-9b57-449a-b5f5-f7b0eba7def1 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('596f966c-9b57-449a-b5f5-f7b0eba7def1', '1E001563-E6B3-49CD-AB5A-BCCFCFBE04E6', 3, 'Pending', 'Pending', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 76d5cfe9-c68d-4334-8c0e-a221e9e241da */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('76d5cfe9-c68d-4334-8c0e-a221e9e241da', '1E001563-E6B3-49CD-AB5A-BCCFCFBE04E6', 4, 'Tabled', 'Tabled', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID cc61919c-ac21-46ed-8ee5-0bbdd5244a10 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('cc61919c-ac21-46ed-8ee5-0bbdd5244a10', '1E001563-E6B3-49CD-AB5A-BCCFCFBE04E6', 5, 'Withdrawn', 'Withdrawn', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID 1E001563-E6B3-49CD-AB5A-BCCFCFBE04E6 */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='1E001563-E6B3-49CD-AB5A-BCCFCFBE04E6'

/* SQL text to insert entity field value with ID 1b9ca8ee-bd14-4e15-b9a5-89a28098d038 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('1b9ca8ee-bd14-4e15-b9a5-89a28098d038', 'E0C19372-93D7-4E75-915B-BBD903458C7C', 1, 'Absent', 'Absent', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID f51586b9-b7b2-414a-98bd-6c5c719853aa */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('f51586b9-b7b2-414a-98bd-6c5c719853aa', 'E0C19372-93D7-4E75-915B-BBD903458C7C', 2, 'Abstain', 'Abstain', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 2f4c8d02-6814-41ba-9ffb-af25a226f138 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('2f4c8d02-6814-41ba-9ffb-af25a226f138', 'E0C19372-93D7-4E75-915B-BBD903458C7C', 3, 'No', 'No', GETUTCDATE(), GETUTCDATE())

/* SQL text to insert entity field value with ID 7c406476-200f-4e46-b5c1-bbdb49531322 */
INSERT INTO [${flyway:defaultSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('7c406476-200f-4e46-b5c1-bbdb49531322', 'E0C19372-93D7-4E75-915B-BBD903458C7C', 4, 'Yes', 'Yes', GETUTCDATE(), GETUTCDATE())

/* SQL text to update ValueListType for entity field ID E0C19372-93D7-4E75-915B-BBD903458C7C */
UPDATE [${flyway:defaultSchema}].[EntityField] SET ValueListType='List' WHERE ID='E0C19372-93D7-4E75-915B-BBD903458C7C'


/* Create Entity Relationship: Types -> Committees (One To Many via TypeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '2f75edf6-ba48-4a00-aa7e-e803b39249c6'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('2f75edf6-ba48-4a00-aa7e-e803b39249c6', '45382FA4-D82D-40F9-A105-24F227AB50C8', '2B971E92-BBCE-462C-9868-807F9C04430D', 'TypeID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Agenda Items -> Motions (One To Many via AgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '3ca44546-14dc-414d-95a6-711ea5ebf45a'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('3ca44546-14dc-414d-95a6-711ea5ebf45a', '5BC3D9BB-94E3-4138-9E17-362C5256DA58', 'EB4EE1A6-CC17-4B5F-8140-8E1719548264', 'AgendaItemID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Agenda Items -> Artifacts (One To Many via AgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'd652a298-b8a4-49da-ad2d-6ecac20329c3'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('d652a298-b8a4-49da-ad2d-6ecac20329c3', '5BC3D9BB-94E3-4138-9E17-362C5256DA58', 'DC523BBE-93DC-49FC-B066-621D3C8162E2', 'AgendaItemID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Agenda Items -> Action Items (One To Many via AgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'a05ab9dc-3f87-497d-aa90-75566939b903'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('a05ab9dc-3f87-497d-aa90-75566939b903', '5BC3D9BB-94E3-4138-9E17-362C5256DA58', 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', 'AgendaItemID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Agenda Items -> Agenda Items (One To Many via ParentAgendaItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '017c64b8-170c-4c08-ac93-f691666cc91f'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('017c64b8-170c-4c08-ac93-f691666cc91f', '5BC3D9BB-94E3-4138-9E17-362C5256DA58', '5BC3D9BB-94E3-4138-9E17-362C5256DA58', 'ParentAgendaItemID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: MJ: Entities -> Artifact Types (One To Many via ExtendedEntityID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '0a530c60-4be0-4e3a-8894-076775f1f2de'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('0a530c60-4be0-4e3a-8894-076775f1f2de', 'E0238F34-2837-EF11-86D4-6045BDEE16E6', '01717D19-EAB2-4C41-AD39-864BB1555D2F', 'ExtendedEntityID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Artifacts -> Minutes (One To Many via ArtifactID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '49639d66-b05f-4098-8d1f-490e68021e1e'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('49639d66-b05f-4098-8d1f-490e68021e1e', 'DC523BBE-93DC-49FC-B066-621D3C8162E2', 'BFA46589-88E7-45AF-A1DD-F9910DDD1717', 'ArtifactID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: MJ.BizApps.Common: Organizations -> Committees (One To Many via OrganizationID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'c45b1933-e7f3-4d44-9afc-5b137ca6deae'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('c45b1933-e7f3-4d44-9afc-5b137ca6deae', 'C70448F9-9792-41D7-A82C-784B66429D54', '2B971E92-BBCE-462C-9868-807F9C04430D', 'OrganizationID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: Committees -> Terms (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'ac90b165-7a01-4190-a309-af3dc2b272ae'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('ac90b165-7a01-4190-a309-af3dc2b272ae', '2B971E92-BBCE-462C-9868-807F9C04430D', 'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D', 'CommitteeID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees -> Meetings (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'bd00da1e-b24f-4282-bbcd-70a0060a99ec'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('bd00da1e-b24f-4282-bbcd-70a0060a99ec', '2B971E92-BBCE-462C-9868-807F9C04430D', 'C6C5BD14-0D36-4442-812E-97F802728524', 'CommitteeID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees -> Committees (One To Many via ParentCommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '64d328e3-c5be-4d0b-8936-28ae7e5f8d10'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('64d328e3-c5be-4d0b-8936-28ae7e5f8d10', '2B971E92-BBCE-462C-9868-807F9C04430D', '2B971E92-BBCE-462C-9868-807F9C04430D', 'ParentCommitteeID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees -> Artifacts (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '345ebfb3-c965-4aee-a456-b594b51dfcfa'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('345ebfb3-c965-4aee-a456-b594b51dfcfa', '2B971E92-BBCE-462C-9868-807F9C04430D', 'DC523BBE-93DC-49FC-B066-621D3C8162E2', 'CommitteeID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Committees -> Memberships (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'd2dfb9b5-2abf-4382-9e0d-3b7d99118715'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('d2dfb9b5-2abf-4382-9e0d-3b7d99118715', '2B971E92-BBCE-462C-9868-807F9C04430D', 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', 'CommitteeID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: Committees -> Action Items (One To Many via CommitteeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '01a944a2-cb94-4fe6-997f-0edf8206c29f'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('01a944a2-cb94-4fe6-997f-0edf8206c29f', '2B971E92-BBCE-462C-9868-807F9C04430D', 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', 'CommitteeID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Artifact Types -> Artifacts (One To Many via ArtifactTypeID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '08a66247-4057-4de4-a0c2-13bd3b641c5f'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('08a66247-4057-4de4-a0c2-13bd3b641c5f', '01717D19-EAB2-4C41-AD39-864BB1555D2F', 'DC523BBE-93DC-49FC-B066-621D3C8162E2', 'ArtifactTypeID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Motions -> Votes (One To Many via MotionID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '9aa54ae3-bfcd-46b0-91e6-3e1bc819534f'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('9aa54ae3-bfcd-46b0-91e6-3e1bc819534f', 'EB4EE1A6-CC17-4B5F-8140-8E1719548264', 'F77CA3D7-5717-4149-8479-F258EF819C7A', 'MotionID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Meetings -> Action Items (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '9c741d26-7b02-4892-bb8f-858463693ce0'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('9c741d26-7b02-4892-bb8f-858463693ce0', 'C6C5BD14-0D36-4442-812E-97F802728524', 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', 'MeetingID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Meetings -> Attendances (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '1c4d6c4d-c39d-4cb9-bf5e-5fcf53368010'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('1c4d6c4d-c39d-4cb9-bf5e-5fcf53368010', 'C6C5BD14-0D36-4442-812E-97F802728524', '5F56A290-08C7-4405-9C21-B4389869D995', 'MeetingID', 'One To Many', 1, 1, 1, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: Meetings -> Minutes (One To Many via ApprovedByMeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '3f67a8fe-5caf-4d2d-8d38-056eb5736ab8'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('3f67a8fe-5caf-4d2d-8d38-056eb5736ab8', 'C6C5BD14-0D36-4442-812E-97F802728524', 'BFA46589-88E7-45AF-A1DD-F9910DDD1717', 'ApprovedByMeetingID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Meetings -> Artifacts (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '8604a851-d2ac-47c4-9b79-4ecfa6ff9611'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('8604a851-d2ac-47c4-9b79-4ecfa6ff9611', 'C6C5BD14-0D36-4442-812E-97F802728524', 'DC523BBE-93DC-49FC-B066-621D3C8162E2', 'MeetingID', 'One To Many', 1, 1, 4, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Meetings -> Agenda Items (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '34c06a98-c2f7-41b9-976a-3be9693f8640'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('34c06a98-c2f7-41b9-976a-3be9693f8640', 'C6C5BD14-0D36-4442-812E-97F802728524', '5BC3D9BB-94E3-4138-9E17-362C5256DA58', 'MeetingID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Meetings -> Motions (One To Many via MeetingID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '1f67c842-8295-499f-9cce-fc200d63e82f'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('1f67c842-8295-499f-9cce-fc200d63e82f', 'C6C5BD14-0D36-4442-812E-97F802728524', 'EB4EE1A6-CC17-4B5F-8140-8E1719548264', 'MeetingID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: Roles -> Memberships (One To Many via RoleID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '3e1164d7-6d20-4aee-9c0f-d8a32d25890f'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('3e1164d7-6d20-4aee-9c0f-d8a32d25890f', '213B8FB0-6855-442C-8D60-B126F6AE2D38', 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', 'RoleID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Terms -> Memberships (One To Many via TermID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'fecabc3e-54e0-43c3-a5b5-b722b907f2bf'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('fecabc3e-54e0-43c3-a5b5-b722b907f2bf', 'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D', 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', 'TermID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Memberships -> Motions (One To Many via SecondedByMembershipID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '05952b33-30c5-4ade-a179-3feb167bfd73'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('05952b33-30c5-4ade-a179-3feb167bfd73', 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', 'EB4EE1A6-CC17-4B5F-8140-8E1719548264', 'SecondedByMembershipID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Memberships -> Motions (One To Many via MovedByMembershipID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'ad385624-bf9a-41da-8574-f66d80678481'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('ad385624-bf9a-41da-8574-f66d80678481', 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', 'EB4EE1A6-CC17-4B5F-8140-8E1719548264', 'MovedByMembershipID', 'One To Many', 1, 1, 4, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Memberships -> Votes (One To Many via MembershipID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'f611df94-e8f6-408d-b62f-dfe058f7d631'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('f611df94-e8f6-408d-b62f-dfe058f7d631', 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', 'F77CA3D7-5717-4149-8479-F258EF819C7A', 'MembershipID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: MJ.BizApps.Common: People -> Attendances (One To Many via PersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '40bef2e6-e1b2-43b3-b71a-201610966635'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('40bef2e6-e1b2-43b3-b71a-201610966635', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '5F56A290-08C7-4405-9C21-B4389869D995', 'PersonID', 'One To Many', 1, 1, 2, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ.BizApps.Common: People -> Memberships (One To Many via PersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '291aeaec-20b6-4aef-a182-7b87d30abcc8'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('291aeaec-20b6-4aef-a182-7b87d30abcc8', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', 'PersonID', 'One To Many', 1, 1, 4, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ.BizApps.Common: People -> Artifacts (One To Many via UploadedByPersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'b3517791-f67c-40be-9060-672bbeb48607'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('b3517791-f67c-40be-9060-672bbeb48607', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', 'DC523BBE-93DC-49FC-B066-621D3C8162E2', 'UploadedByPersonID', 'One To Many', 1, 1, 5, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ.BizApps.Common: People -> Agenda Items (One To Many via PresenterPersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'cf00cd59-a6a0-46a4-9ad1-bec3df369e2d'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('cf00cd59-a6a0-46a4-9ad1-bec3df369e2d', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', '5BC3D9BB-94E3-4138-9E17-362C5256DA58', 'PresenterPersonID', 'One To Many', 1, 1, 3, GETUTCDATE(), GETUTCDATE())
   END;
                    


/* Create Entity Relationship: MJ.BizApps.Common: People -> Action Items (One To Many via AssignedToPersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '1cb4e9e3-2702-4fa1-bc29-86c518cb3084'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('1cb4e9e3-2702-4fa1-bc29-86c518cb3084', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', 'AssignedToPersonID', 'One To Many', 1, 1, 4, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: MJ.BizApps.Common: People -> Action Items (One To Many via AssignedByPersonID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = 'a7d32f64-af7f-4b13-96b7-08c9e79bd4ad'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('a7d32f64-af7f-4b13-96b7-08c9e79bd4ad', '7A94ADA9-7880-4FAE-97D8-DB0E934C3F5F', 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', 'AssignedByPersonID', 'One To Many', 1, 1, 5, GETUTCDATE(), GETUTCDATE())
   END;
                    
/* Create Entity Relationship: Action Items -> Artifacts (One To Many via ActionItemID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${flyway:defaultSchema}].[EntityRelationship] WHERE [ID] = '6f034182-90b1-456b-b74a-de97176ff5cd'
   )
   BEGIN
      INSERT INTO [${flyway:defaultSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('6f034182-90b1-456b-b74a-de97176ff5cd', 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', 'DC523BBE-93DC-49FC-B066-621D3C8162E2', 'ActionItemID', 'One To Many', 1, 1, 6, GETUTCDATE(), GETUTCDATE())
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

/* SQL text to update entity field related entity name field map for entity field ID 35136BA7-3C0B-4A3E-A2A9-E8CF321B1430 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='35136BA7-3C0B-4A3E-A2A9-E8CF321B1430', @RelatedEntityNameFieldMap='Committee'

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

/* SQL text to update entity field related entity name field map for entity field ID 2C88BA58-D204-4733-BD7B-2B12A588D289 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='2C88BA58-D204-4733-BD7B-2B12A588D289', @RelatedEntityNameFieldMap='PresenterPerson'

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

/* SQL text to update entity field related entity name field map for entity field ID 0DF9A2BA-F8D6-4E9F-A896-4A431F721985 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='0DF9A2BA-F8D6-4E9F-A896-4A431F721985', @RelatedEntityNameFieldMap='ExtendedEntity'

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

/* SQL text to update entity field related entity name field map for entity field ID 0B9C54AC-5206-423A-A353-056E9A24A732 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='0B9C54AC-5206-423A-A353-056E9A24A732', @RelatedEntityNameFieldMap='Committee'

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

/* SQL text to update entity field related entity name field map for entity field ID 64ACA6A1-5351-409B-B19E-9B92CC2880F0 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='64ACA6A1-5351-409B-B19E-9B92CC2880F0', @RelatedEntityNameFieldMap='Person'

/* SQL text to update entity field related entity name field map for entity field ID 1A44989E-E463-4F19-8BD4-EE69C6DBE58C */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='1A44989E-E463-4F19-8BD4-EE69C6DBE58C', @RelatedEntityNameFieldMap='AssignedToPerson'

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



/* SQL text to update entity field related entity name field map for entity field ID E948E1B1-A591-40BD-B215-A4B3F723CA7F */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='E948E1B1-A591-40BD-B215-A4B3F723CA7F', @RelatedEntityNameFieldMap='ArtifactType'

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



/* SQL text to update entity field related entity name field map for entity field ID A6C292A6-8207-4832-B0AB-F04A195ADC29 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='A6C292A6-8207-4832-B0AB-F04A195ADC29', @RelatedEntityNameFieldMap='AssignedByPerson'

/* SQL text to update entity field related entity name field map for entity field ID 17786941-BBE8-4E5A-9DAB-3A070ECF4953 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='17786941-BBE8-4E5A-9DAB-3A070ECF4953', @RelatedEntityNameFieldMap='UploadedByPerson'

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

/* SQL text to update entity field related entity name field map for entity field ID D447B324-45B7-45C6-AD55-25C4832BF2D2 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='D447B324-45B7-45C6-AD55-25C4832BF2D2', @RelatedEntityNameFieldMap='Type'

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

/* SQL text to update entity field related entity name field map for entity field ID F1241E55-FEFE-4CBE-BA7D-9B79FECA3126 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='F1241E55-FEFE-4CBE-BA7D-9B79FECA3126', @RelatedEntityNameFieldMap='Committee'

/* Index for Foreign Keys for Membership */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Memberships
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key CommitteeID in table Membership
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Membership_CommitteeID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Membership]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Membership_CommitteeID ON [${flyway:defaultSchema}_Committees].[Membership] ([CommitteeID]);

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

/* SQL text to update entity field related entity name field map for entity field ID 9EC10E3D-F9A0-4C7C-A262-B3C0B547780B */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='9EC10E3D-F9A0-4C7C-A262-B3C0B547780B', @RelatedEntityNameFieldMap='Committee'

/* Index for Foreign Keys for Minute */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Minutes
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
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Minute]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Minute_ArtifactID ON [${flyway:defaultSchema}_Committees].[Minute] ([ArtifactID]);

-- Index for foreign key ApprovedByMeetingID in table Minute
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Minute_ApprovedByMeetingID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}_Committees].[Minute]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Minute_ApprovedByMeetingID ON [${flyway:defaultSchema}_Committees].[Minute] ([ApprovedByMeetingID]);

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
    @Notes nvarchar(MAX)
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
        INSERT INTO [${flyway:defaultSchema}_Committees].[Minute]
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
    @Notes nvarchar(MAX)
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
        [Notes] = @Notes
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



/* SQL text to update entity field related entity name field map for entity field ID 28B3B925-EA9D-45D9-90C7-A80EF90310A4 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='28B3B925-EA9D-45D9-90C7-A80EF90310A4', @RelatedEntityNameFieldMap='ParentCommittee'

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
    mjCommitteesCommittee_CommitteeID.[Name] AS [Committee]
FROM
    [${flyway:defaultSchema}_Committees].[Meeting] AS m
INNER JOIN
    [${flyway:defaultSchema}_Committees].[Committee] AS mjCommitteesCommittee_CommitteeID
  ON
    [m].[CommitteeID] = mjCommitteesCommittee_CommitteeID.[ID]
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
    @CalendarEventID nvarchar(255)
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
                [CalendarEventID]
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
                @CalendarEventID
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
                [CalendarEventID]
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
                @CalendarEventID
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
    @CalendarEventID nvarchar(255)
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
        [CalendarEventID] = @CalendarEventID
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



/* SQL text to update entity field related entity name field map for entity field ID 30B03BE5-1775-456F-B899-9658056F3665 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='30B03BE5-1775-456F-B899-9658056F3665', @RelatedEntityNameFieldMap='Person'

/* SQL text to update entity field related entity name field map for entity field ID FF81A867-5EFB-4FE7-8515-5126B329D94D */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='FF81A867-5EFB-4FE7-8515-5126B329D94D', @RelatedEntityNameFieldMap='Role'

/* SQL text to update entity field related entity name field map for entity field ID D49864F3-8FFE-4DD7-8686-8C629CD656EF */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='D49864F3-8FFE-4DD7-8686-8C629CD656EF', @RelatedEntityNameFieldMap='Organization'

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



/* SQL text to update entity field related entity name field map for entity field ID FBC3BEAA-4FAD-4BF9-B31D-71A6F4809765 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='FBC3BEAA-4FAD-4BF9-B31D-71A6F4809765', @RelatedEntityNameFieldMap='Term'

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
    mjCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjBizAppsCommonPerson_PersonID.[DisplayName] AS [Person],
    mjCommitteesRole_RoleID.[Name] AS [Role],
    mjCommitteesTerm_TermID.[Name] AS [Term]
FROM
    [${flyway:defaultSchema}_Committees].[Membership] AS m
INNER JOIN
    [${flyway:defaultSchema}_Committees].[Committee] AS mjCommitteesCommittee_CommitteeID
  ON
    [m].[CommitteeID] = mjCommitteesCommittee_CommitteeID.[ID]
INNER JOIN
    [${flyway:defaultSchema}_BizAppsCommon].[vwPeopleExtended] AS mjBizAppsCommonPerson_PersonID
  ON
    [m].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
INNER JOIN
    [${flyway:defaultSchema}_Committees].[Role] AS mjCommitteesRole_RoleID
  ON
    [m].[RoleID] = mjCommitteesRole_RoleID.[ID]
LEFT OUTER JOIN
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
    @CommitteeID uniqueidentifier,
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
                [CommitteeID],
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
                @CommitteeID,
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
                [CommitteeID],
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
                @CommitteeID,
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
    @CommitteeID uniqueidentifier,
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
        [CommitteeID] = @CommitteeID,
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


/* Index for Foreign Keys for OrganizationType */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: MJ.BizApps.Common: Organization Types
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------


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

        

/* spUpdate Permissions for Motions */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateMotion] TO [cdp_Developer], [cdp_Integration]



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

/* SQL text to update entity field related entity name field map for entity field ID FA338DF3-0781-4D4C-AFE6-8CE7B13F0D64 */
EXEC [${flyway:defaultSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='FA338DF3-0781-4D4C-AFE6-8CE7B13F0D64', @RelatedEntityNameFieldMap='Committee'

/* Index for Foreign Keys for Type */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Types
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------


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

        

/* spUpdate Permissions for Types */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateType] TO [cdp_Developer], [cdp_Integration]



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

        

/* spUpdate Permissions for Votes */

GRANT EXECUTE ON [${flyway:defaultSchema}_Committees].[spUpdateVote] TO [cdp_Developer], [cdp_Integration]



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



/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '92410245-9324-4274-a689-17eb063abc7b' OR (EntityID = '45382FA4-D82D-40F9-A105-24F227AB50C8' AND Name = '__mj_CreatedAt')) BEGIN
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
            '92410245-9324-4274-a689-17eb063abc7b',
            '45382FA4-D82D-40F9-A105-24F227AB50C8', -- Entity: Types
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'b24ae8be-b6a5-4c07-a4ce-e0a06ab77236' OR (EntityID = '45382FA4-D82D-40F9-A105-24F227AB50C8' AND Name = '__mj_UpdatedAt')) BEGIN
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
            'b24ae8be-b6a5-4c07-a4ce-e0a06ab77236',
            '45382FA4-D82D-40F9-A105-24F227AB50C8', -- Entity: Types
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'a2bbfdc4-bb2b-4899-b594-12a012a07faa' OR (EntityID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58' AND Name = '__mj_CreatedAt')) BEGIN
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
            'a2bbfdc4-bb2b-4899-b594-12a012a07faa',
            '5BC3D9BB-94E3-4138-9E17-362C5256DA58', -- Entity: Agenda Items
            100026,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c9c7bbc5-fe43-4970-9466-c5fd0c4263e8' OR (EntityID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58' AND Name = '__mj_UpdatedAt')) BEGIN
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
            'c9c7bbc5-fe43-4970-9466-c5fd0c4263e8',
            '5BC3D9BB-94E3-4138-9E17-362C5256DA58', -- Entity: Agenda Items
            100027,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '7e213148-fb39-46b3-b33a-6c4b722ba849' OR (EntityID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58' AND Name = 'PresenterPerson')) BEGIN
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
            '7e213148-fb39-46b3-b33a-6c4b722ba849',
            '5BC3D9BB-94E3-4138-9E17-362C5256DA58', -- Entity: Agenda Items
            100028,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'acec7865-d05e-44d2-a692-3a43e15cf6f7' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = '__mj_CreatedAt')) BEGIN
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
            'acec7865-d05e-44d2-a692-3a43e15cf6f7',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
            100031,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '8037c2bd-f555-4fa7-bc61-0340d91a64c0' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '8037c2bd-f555-4fa7-bc61-0340d91a64c0',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
            100032,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c80fc98a-0ab7-4507-9b64-308b26309610' OR (EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2' AND Name = 'UploadedByPerson')) BEGIN
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
            'c80fc98a-0ab7-4507-9b64-308b26309610',
            'DC523BBE-93DC-49FC-B066-621D3C8162E2', -- Entity: Artifacts
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'b579595c-90cc-4270-b561-1e83538dbbdb' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = '__mj_CreatedAt')) BEGIN
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
            'b579595c-90cc-4270-b561-1e83538dbbdb',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
            100029,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'f6a6998c-80c8-49f6-a6f3-1e04caa8591b' OR (EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264' AND Name = '__mj_UpdatedAt')) BEGIN
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
            'f6a6998c-80c8-49f6-a6f3-1e04caa8591b',
            'EB4EE1A6-CC17-4B5F-8140-8E1719548264', -- Entity: Motions
            100030,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'a7e04c80-8961-4371-aaaa-d6abba5eb125' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = '__mj_CreatedAt')) BEGIN
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
            'a7e04c80-8961-4371-aaaa-d6abba5eb125',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
            100034,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '510cd2f8-7dba-4be7-a6ab-07b38c856bd9' OR (EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '510cd2f8-7dba-4be7-a6ab-07b38c856bd9',
            'C6C5BD14-0D36-4442-812E-97F802728524', -- Entity: Meetings
            100035,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1bcb5b66-433c-4046-8391-97d903e03401' OR (EntityID = '213B8FB0-6855-442C-8D60-B126F6AE2D38' AND Name = '__mj_CreatedAt')) BEGIN
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
            '1bcb5b66-433c-4046-8391-97d903e03401',
            '213B8FB0-6855-442C-8D60-B126F6AE2D38', -- Entity: Roles
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '993ca953-4598-4273-a70b-84f0a2d27c9e' OR (EntityID = '213B8FB0-6855-442C-8D60-B126F6AE2D38' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '993ca953-4598-4273-a70b-84f0a2d27c9e',
            '213B8FB0-6855-442C-8D60-B126F6AE2D38', -- Entity: Roles
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '6f7d196b-fed0-4e73-aa64-1fc2da013d9c' OR (EntityID = '5F56A290-08C7-4405-9C21-B4389869D995' AND Name = 'Person')) BEGIN
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
            '6f7d196b-fed0-4e73-aa64-1fc2da013d9c',
            '5F56A290-08C7-4405-9C21-B4389869D995', -- Entity: Attendances
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c2aa3f28-ae0d-4aab-bc9b-cecc8673f614' OR (EntityID = 'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D' AND Name = '__mj_CreatedAt')) BEGIN
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
            'c2aa3f28-ae0d-4aab-bc9b-cecc8673f614',
            'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D', -- Entity: Terms
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1a06a522-ffbf-4a1f-ab68-6ea0149f9b52' OR (EntityID = 'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '1a06a522-ffbf-4a1f-ab68-6ea0149f9b52',
            'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D', -- Entity: Terms
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '1bf89154-fc67-492d-88db-bcba9a850e62' OR (EntityID = 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6' AND Name = '__mj_CreatedAt')) BEGIN
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
            '1bf89154-fc67-492d-88db-bcba9a850e62',
            'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', -- Entity: Memberships
            100024,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '90c2610d-f618-4e32-9bc1-17140c4d7a2b' OR (EntityID = 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '90c2610d-f618-4e32-9bc1-17140c4d7a2b',
            'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', -- Entity: Memberships
            100025,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '538ca2e3-6a9c-444b-8f31-7fb9c1a359fd' OR (EntityID = 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6' AND Name = 'Person')) BEGIN
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
            '538ca2e3-6a9c-444b-8f31-7fb9c1a359fd',
            'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', -- Entity: Memberships
            100027,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '582fc669-98e5-4337-917f-0284ae41ce47' OR (EntityID = 'F77CA3D7-5717-4149-8479-F258EF819C7A' AND Name = '__mj_CreatedAt')) BEGIN
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
            '582fc669-98e5-4337-917f-0284ae41ce47',
            'F77CA3D7-5717-4149-8479-F258EF819C7A', -- Entity: Votes
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '05ab1cbf-9a22-48d7-8db9-74bbe7812538' OR (EntityID = 'F77CA3D7-5717-4149-8479-F258EF819C7A' AND Name = '__mj_UpdatedAt')) BEGIN
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
            '05ab1cbf-9a22-48d7-8db9-74bbe7812538',
            'F77CA3D7-5717-4149-8479-F258EF819C7A', -- Entity: Votes
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '5f875dc7-54e5-4f8e-ab85-3ba593bb8513' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = '__mj_CreatedAt')) BEGIN
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
            '5f875dc7-54e5-4f8e-ab85-3ba593bb8513',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
            100028,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'd9e75a01-75ba-4fb2-93db-4b99b0f6aeb0' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = '__mj_UpdatedAt')) BEGIN
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
            'd9e75a01-75ba-4fb2-93db-4b99b0f6aeb0',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
            100029,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'c1b9a705-d81e-48ed-9092-db0005bdf636' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = 'AssignedToPerson')) BEGIN
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
            'c1b9a705-d81e-48ed-9092-db0005bdf636',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
            100031,
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'a158d04a-73cb-443a-8412-6a2dd2f5c8e1' OR (EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9' AND Name = 'AssignedByPerson')) BEGIN
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
            'a158d04a-73cb-443a-8412-6a2dd2f5c8e1',
            'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', -- Entity: Action Items
            100032,
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

/* Set field properties for entity */

            UPDATE [${flyway:defaultSchema}].[EntityField]
            SET IsNameField = 1
            WHERE ID = '9752A9E9-FC94-4712-B1D0-52AD37899E6F'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '9752A9E9-FC94-4712-B1D0-52AD37899E6F'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'D2B8DA2B-1884-44FD-9494-B07B0E50B4B4'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'B4E41F97-23F4-4718-B60C-50EF56D75670'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '88828B5A-415F-40E0-90B7-7B5567375D34'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'C30C23FA-0545-4914-B4B9-EFAF9BBE1B99'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'C1B9A705-D81E-48ED-9092-DB0005BDF636'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '9752A9E9-FC94-4712-B1D0-52AD37899E6F'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'B4E41F97-23F4-4718-B60C-50EF56D75670'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '88828B5A-415F-40E0-90B7-7B5567375D34'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'C30C23FA-0545-4914-B4B9-EFAF9BBE1B99'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'C1B9A705-D81E-48ED-9092-DB0005BDF636'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'A158D04A-73CB-443A-8412-6A2DD2F5C8E1'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

            UPDATE [${flyway:defaultSchema}].[EntityField]
            SET IsNameField = 1
            WHERE ID = '44F0A802-C118-440A-A467-BB296DFACC2A'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '6AF82FF1-D71E-4904-A678-D9D8E50CA1B8'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '44F0A802-C118-440A-A467-BB296DFACC2A'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'C2F9687C-2D72-44B1-9FC5-15D661CA007A'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'E2F64D96-5DE8-4918-84A7-C1A517829BBC'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '8FC8E88A-0E6A-475C-9E05-729F103BA062'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '7E213148-FB39-46B3-B33A-6C4B722BA849'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '44F0A802-C118-440A-A467-BB296DFACC2A'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'E2F64D96-5DE8-4918-84A7-C1A517829BBC'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '8FC8E88A-0E6A-475C-9E05-729F103BA062'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '7E213148-FB39-46B3-B33A-6C4B722BA849'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

            UPDATE [${flyway:defaultSchema}].[EntityField]
            SET IsNameField = 1
            WHERE ID = '6F7D196B-FED0-4E73-AA64-1FC2DA013D9C'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '65CACDD5-8A4C-424F-AB16-F666811F1BFE'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'E7CC6BEF-C5BA-4315-8EC8-73E16684672C'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'B427AA57-A9D2-4855-91E4-DD0ED272DE7A'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '6F7D196B-FED0-4E73-AA64-1FC2DA013D9C'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '65CACDD5-8A4C-424F-AB16-F666811F1BFE'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '6F7D196B-FED0-4E73-AA64-1FC2DA013D9C'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '62F64169-51B0-40AB-A32A-954842624CAE'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'BE085A89-591B-40D5-BD50-C8282E5E5D1C'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

            UPDATE [${flyway:defaultSchema}].[EntityField]
            SET IsNameField = 1
            WHERE ID = '0944B1F6-E52E-4D8E-8882-64EB1CAC8BED'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '0944B1F6-E52E-4D8E-8882-64EB1CAC8BED'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'DABCF878-B859-43E1-81AD-1B3B5FAC8420'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '7A5AFFF4-A48F-4683-A76A-67F86972C038'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'C80FC98A-0AB7-4507-9B64-308B26309610'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '0944B1F6-E52E-4D8E-8882-64EB1CAC8BED'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'DABCF878-B859-43E1-81AD-1B3B5FAC8420'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '7A1ADBDC-FE0E-411B-80CD-0A67460D40F0'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '5A58A761-4AF9-4371-9A9F-34D05590AE87'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '7A5AFFF4-A48F-4683-A76A-67F86972C038'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'C80FC98A-0AB7-4507-9B64-308B26309610'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set categories for 8 fields */

-- UPDATE Entity Field Category Info Artifact Types.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Artifact Type Info',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B23EE2A2-D8A6-4793-81B8-081A60D007D7' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifact Types.Name 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Artifact Type Info',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E651A58B-54AC-4A92-8CC3-CF4DA7FAD5FB' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifact Types.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Artifact Type Info',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BE085A89-591B-40D5-BD50-C8282E5E5D1C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifact Types.IconClass 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Artifact Type Info',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '62F64169-51B0-40AB-A32A-954842624CAE' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifact Types.ExtendedEntityID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Extension Entity',
   GeneratedFormSection = 'Category',
   DisplayName = 'Extended Entity',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0DF9A2BA-F8D6-4E9F-A896-4A431F721985' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifact Types.ExtendedEntity 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Extension Entity',
   GeneratedFormSection = 'Category',
   DisplayName = 'Extended Entity Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1F8B7662-5462-48A3-9D4B-6D66FB336824' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifact Types.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '271D1232-591C-4092-91C9-498C5B3AD538' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifact Types.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7B4B4D2F-0525-45C8-A71E-FE60EDDEAE1A' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-file */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-file', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = '01717D19-EAB2-4C41-AD39-864BB1555D2F'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('abf2f0b6-621f-428f-8734-813d127b6c84', '01717D19-EAB2-4C41-AD39-864BB1555D2F', 'FieldCategoryInfo', '{"Artifact Type Info":{"icon":"fa fa-file-alt","description":"Core definition fields for an artifact type, including identifier, name, description, and UI icon"},"Extension Entity":{"icon":"fa fa-puzzle-piece","description":"Configuration for an optional extension entity that adds type‑specific fields"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit fields tracking creation and modification timestamps"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('172ff834-34f2-4ec3-887c-b9c5b1200734', '01717D19-EAB2-4C41-AD39-864BB1555D2F', 'FieldCategoryIcons', '{"Artifact Type Info":"fa fa-file-alt","Extension Entity":"fa fa-puzzle-piece","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=0 for NEW entity (category: reference, confidence: high) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 0, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = '01717D19-EAB2-4C41-AD39-864BB1555D2F'
      

/* Set categories for 10 fields */

-- UPDATE Entity Field Category Info Attendances.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3C5CE0B2-F27E-4C29-9692-3E3F23C338A7' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.MeetingID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Attendee & Meeting',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B68258D1-9020-419D-BDD4-277747331CC9' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.PersonID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Attendee & Meeting',
   GeneratedFormSection = 'Category',
   DisplayName = 'Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '64ACA6A1-5351-409B-B19E-9B92CC2880F0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.Person 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Attendee & Meeting',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6F7D196B-FED0-4E73-AA64-1FC2DA013D9C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.AttendanceStatus 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Attendance Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '65CACDD5-8A4C-424F-AB16-F666811F1BFE' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.JoinedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Attendance Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E7CC6BEF-C5BA-4315-8EC8-73E16684672C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.LeftAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Attendance Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B427AA57-A9D2-4855-91E4-DD0ED272DE7A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.Notes 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Attendance Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6824AB44-02A1-4ABA-ADA3-9708CC7E7641' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '53F86FAC-BFB1-42FA-AE35-2542CAA8E3C6' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Attendances.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '947978D3-7FC1-494D-A185-D812FCAA6770' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-calendar */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-calendar', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = '5F56A290-08C7-4405-9C21-B4389869D995'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('47c529df-850a-45c7-9149-a3c352aba00d', '5F56A290-08C7-4405-9C21-B4389869D995', 'FieldCategoryInfo', '{"Attendee & Meeting":{"icon":"fa fa-user","description":"Identification details linking a person to a meeting"},"Attendance Details":{"icon":"fa fa-calendar-check","description":"Status, timestamps and notes of the attendee''s participation"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit and tracking fields"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('ab0dd471-eeda-4792-9da7-c12a5a3cb7e0', '5F56A290-08C7-4405-9C21-B4389869D995', 'FieldCategoryIcons', '{"Attendee & Meeting":"fa fa-user","Attendance Details":"fa fa-calendar-check","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=1 for NEW entity (category: supporting, confidence: medium) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 1, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = '5F56A290-08C7-4405-9C21-B4389869D995'
      

/* Set categories for 18 fields */

-- UPDATE Entity Field Category Info Action Items.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E5C7526C-C8F9-474A-93AC-3F8FB7C0CBE1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.CommitteeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Context',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '35136BA7-3C0B-4A3E-A2A9-E8CF321B1430' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.MeetingID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Context',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D38BB5DA-F6AD-4A7A-9DD7-9AC4A23BF0AB' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.AgendaItemID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Context',
   GeneratedFormSection = 'Category',
   DisplayName = 'Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5B1F0905-8009-484C-A9FB-C475489E9DC7' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.Title 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Action Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9752A9E9-FC94-4712-B1D0-52AD37899E6F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Action Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '59C8A57A-BF84-4BE2-8019-53DBB77C31DA' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.AssignedToPersonID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Responsibility',
   GeneratedFormSection = 'Category',
   DisplayName = 'Assigned To Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1A44989E-E463-4F19-8BD4-EE69C6DBE58C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.AssignedByPersonID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Responsibility',
   GeneratedFormSection = 'Category',
   DisplayName = 'Assigned By Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A6C292A6-8207-4832-B0AB-F04A195ADC29' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.DueDate 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Timeline & Completion',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D2B8DA2B-1884-44FD-9494-B07B0E50B4B4' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.Priority 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Action Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B4E41F97-23F4-4718-B60C-50EF56D75670' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.Status 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Action Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '88828B5A-415F-40E0-90B7-7B5567375D34' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.CompletedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Timeline & Completion',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0C244108-85A6-4EA5-801E-38E3FD9322FD' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.CompletionNotes 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Timeline & Completion',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6237159D-D2F0-4565-9D3B-6D39B1BFF4A8' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5F875DC7-54E5-4F8E-AB85-3BA593BB8513' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D9E75A01-75BA-4FB2-93DB-4B99B0F6AEB0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.Committee 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Context',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C30C23FA-0545-4914-B4B9-EFAF9BBE1B99' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.AssignedToPerson 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Responsibility',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C1B9A705-D81E-48ED-9092-DB0005BDF636' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Action Items.AssignedByPerson 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Responsibility',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A158D04A-73CB-443A-8412-6A2DD2F5C8E1' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-tasks */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-tasks', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('17dfc22d-3bff-4db1-9e37-324b1ec7bcb0', 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', 'FieldCategoryInfo', '{"Action Details":{"icon":"fa fa-align-left","description":"Core information describing the action item such as title, description, priority and current status"},"Responsibility":{"icon":"fa fa-user","description":"People responsible for and assigning the action item, including their identifiers"},"Context":{"icon":"fa fa-map-marker-alt","description":"Links to related committee, meeting and agenda items providing situational context"},"Timeline & Completion":{"icon":"fa fa-calendar","description":"Key dates and notes tracking due dates, completion time and post‑completion comments"},"System Metadata":{"icon":"fa fa-cog","description":"Audit fields and system‑generated identifiers"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('34e1bf9c-0ab4-4d60-b376-4086db734b86', 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9', 'FieldCategoryIcons', '{"Action Details":"fa fa-align-left","Responsibility":"fa fa-user","Context":"fa fa-map-marker-alt","Timeline & Completion":"fa fa-calendar","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=1 for NEW entity (category: primary, confidence: medium) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 1, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = 'BD6E486A-F68A-4F8B-A8D2-FFEA628A00F9'
      

/* Set categories for 16 fields */

-- UPDATE Entity Field Category Info Agenda Items.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9D7EEC50-670A-4940-A84A-5983A7F34C69' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.MeetingID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Agenda Structure',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2F5C7FD5-0699-46B0-B9EB-E4FFC8B547EF' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.ParentAgendaItemID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Agenda Structure',
   GeneratedFormSection = 'Category',
   DisplayName = 'Parent Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AF77D04A-96D8-4BEF-9CE0-E65892AD91C1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.RootParentAgendaItemID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Agenda Structure',
   GeneratedFormSection = 'Category',
   DisplayName = 'Root Parent Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8B3F77AE-3EDF-4D2A-8B9E-01387412A770' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.Sequence 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Agenda Structure',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6AF82FF1-D71E-4904-A678-D9D8E50CA1B8' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.Title 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Item Content',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '44F0A802-C118-440A-A467-BB296DFACC2A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Item Content',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '232D43CF-4D1E-4022-9F6E-DCDD7C33D007' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.ItemType 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Item Content',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E2F64D96-5DE8-4918-84A7-C1A517829BBC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.Status 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Item Content',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8FC8E88A-0E6A-475C-9E05-729F103BA062' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.RelatedDocumentURL 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Item Content',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '72565441-09BC-4FF3-858B-8999DC5262C1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.PresenterPersonID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Presentation & Timing',
   GeneratedFormSection = 'Category',
   DisplayName = 'Presenter',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2C88BA58-D204-4733-BD7B-2B12A588D289' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.PresenterPerson 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Presentation & Timing',
   GeneratedFormSection = 'Category',
   DisplayName = 'Presenter Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7E213148-FB39-46B3-B33A-6C4B722BA849' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.DurationMinutes 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Presentation & Timing',
   GeneratedFormSection = 'Category',
   DisplayName = 'Duration (Minutes)',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C2F9687C-2D72-44B1-9FC5-15D661CA007A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.Notes 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Presentation & Timing',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '07C5263A-CE84-4A2C-99A1-E9981697C3E7' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A2BBFDC4-BB2B-4899-B594-12A012A07FAA' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Agenda Items.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C9C7BBC5-FE43-4970-9466-C5FD0C4263E8' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-clipboard-list */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-clipboard-list', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('0bcd505f-05cd-45d7-b449-b448f659dbc7', '5BC3D9BB-94E3-4138-9E17-362C5256DA58', 'FieldCategoryInfo', '{"Agenda Structure":{"icon":"fa fa-sitemap","description":"Defines the meeting context and hierarchical placement of agenda items"},"Item Content":{"icon":"fa fa-file-alt","description":"Core details of the agenda item such as title, description, type, status, and linked documents"},"Presentation & Timing":{"icon":"fa fa-clock","description":"Information about who presents the item, how long it should take, and any notes captured"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit fields and primary identifier"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('301ed6f8-08c9-48e5-95ac-5fee00dd5f22', '5BC3D9BB-94E3-4138-9E17-362C5256DA58', 'FieldCategoryIcons', '{"Agenda Structure":"fa fa-sitemap","Item Content":"fa fa-file-alt","Presentation & Timing":"fa fa-clock","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=1 for NEW entity (category: primary, confidence: high) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 1, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = '5BC3D9BB-94E3-4138-9E17-362C5256DA58'
      

/* Set categories for 19 fields */

-- UPDATE Entity Field Category Info Artifacts.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7C276534-B46C-4035-BB64-49BAA7C0A2AB' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.CommitteeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0B9C54AC-5206-423A-A353-056E9A24A732' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.MeetingID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C53FC5A3-01E2-4AB3-A84B-58B8BE1DE136' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.AgendaItemID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   DisplayName = 'Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9300A125-AEEA-43E1-9C41-C303C7E8899E' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.ActionItemID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   DisplayName = 'Action Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '278DDBCA-FDC7-4C4C-9483-E336F0474C13' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.Title 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Artifact Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '0944B1F6-E52E-4D8E-8882-64EB1CAC8BED' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Artifact Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1BC69300-429A-466B-832F-D86F2A280F8A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.ArtifactTypeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   DisplayName = 'Artifact Type',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E948E1B1-A591-40BD-B215-A4B3F723CA7F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.Provider 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Artifact Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'DABCF878-B859-43E1-81AD-1B3B5FAC8420' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.ExternalID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Artifact Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7A1ADBDC-FE0E-411B-80CD-0A67460D40F0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.URL 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Artifact Details',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '5A58A761-4AF9-4371-9A9F-34D05590AE87' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.MimeType 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Artifact Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'MIME Type',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '305360C2-44D9-416C-9B98-F4AB947F41EC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.FileSize 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Artifact Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '366A1BF2-227D-4319-AB2C-7F2ADF29FB5F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.UploadedByPersonID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   DisplayName = 'Uploaded By',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '17786941-BBE8-4E5A-9DAB-3A070ECF4953' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'ACEC7865-D05E-44D2-A692-3A43E15CF6F7' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8037C2BD-F555-4FA7-BC61-0340D91A64C0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.Committee 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '043042FA-8E84-411F-A9FA-9A729D82820D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.ArtifactType 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   DisplayName = 'Artifact Type Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7A5AFFF4-A48F-4683-A76A-67F86972C038' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Artifacts.UploadedByPerson 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Related Entities',
   GeneratedFormSection = 'Category',
   DisplayName = 'Uploaded By Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C80FC98A-0AB7-4507-9B64-308B26309610' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-file */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-file', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('7723d24b-20a2-48f5-b496-b5ef84bd3e2b', 'DC523BBE-93DC-49FC-B066-621D3C8162E2', 'FieldCategoryInfo', '{"Artifact Details":{"icon":"fa fa-file-alt","description":"Core information describing the artifact such as title, description, storage provider, and file metadata"},"Related Entities":{"icon":"fa fa-link","description":"Links to other business objects like committee, meeting, agenda item, action item, type and uploader"},"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('4cd4a558-e954-4f51-a703-679f086f3258', 'DC523BBE-93DC-49FC-B066-621D3C8162E2', 'FieldCategoryIcons', '{"Artifact Details":"fa fa-file-alt","Related Entities":"fa fa-link","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=1 for NEW entity (category: supporting, confidence: high) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 1, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = 'DC523BBE-93DC-49FC-B066-621D3C8162E2'
      

/* Set field properties for entity */

            UPDATE [${flyway:defaultSchema}].[EntityField]
            SET IsNameField = 1
            WHERE ID = '629D9C8F-AC11-479A-852E-41213263F696'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '629D9C8F-AC11-479A-852E-41213263F696'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '45D8FAF6-513D-40AB-858A-83A046CF0E96'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'AF847EA1-8549-4AC5-A03F-FD2C53824F26'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'DF7E91B3-3D0C-4860-913A-3ABD79E1AA85'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '2DDBEB25-13D4-4157-9141-75B3FA3E6B20'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '629D9C8F-AC11-479A-852E-41213263F696'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'CA026FCD-1B43-4C6E-984A-27E197B474AC'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'FEF1718A-741B-44F3-8C79-17B1B7880C90'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '699639BB-6601-4FDF-92E1-322BED6A2394'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '852B0082-7008-497D-8CCC-3A86DC371FDF'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

            UPDATE [${flyway:defaultSchema}].[EntityField]
            SET IsNameField = 1
            WHERE ID = '538CA2E3-6A9C-444B-8F31-7FB9C1A359FD'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'FFCBF67A-D89D-49E9-9625-67340FA67E65'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '2C1AD820-598D-4BC3-AD20-8A75C1144A5E'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '503BA90F-4261-4C3F-B7E9-CF04058BE313'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '538CA2E3-6A9C-444B-8F31-7FB9C1A359FD'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '7B128C05-68B0-4639-B0EE-E10E003984B2'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '2C1AD820-598D-4BC3-AD20-8A75C1144A5E'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '503BA90F-4261-4C3F-B7E9-CF04058BE313'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '538CA2E3-6A9C-444B-8F31-7FB9C1A359FD'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '7B128C05-68B0-4639-B0EE-E10E003984B2'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'A394BEE2-4D53-478C-A422-B98BE40E0351'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'D6F9A1CE-45FA-49C1-961A-346BBD3F507E'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'C54D7FA6-5A38-4C1B-BA72-8C33D133A695'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'B4B7B5CE-ACF5-478B-BE12-FFF166D8F9E1'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'C203C5E3-2FFC-4A8D-910E-C9A9FB97B60A'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'B4B7B5CE-ACF5-478B-BE12-FFF166D8F9E1'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '5BDB6D78-7496-4DF0-921E-FD5C70C52EB9'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'C203C5E3-2FFC-4A8D-910E-C9A9FB97B60A'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

            UPDATE [${flyway:defaultSchema}].[EntityField]
            SET IsNameField = 1
            WHERE ID = '49A875BB-7630-4E94-AC58-66F610000BC1'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '49A875BB-7630-4E94-AC58-66F610000BC1'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '91E0E487-D81B-4602-AF75-52C5FCFB00EC'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '49A875BB-7630-4E94-AC58-66F610000BC1'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set categories for 8 fields */

-- UPDATE Entity Field Category Info Minutes.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'General Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'BA67048A-587E-415C-91F7-2676C6771E03' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.ArtifactID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'General Information',
   GeneratedFormSection = 'Category',
   DisplayName = 'Artifact',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F1EADC64-B2E6-4BDC-8F6C-305E72B0E691' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.Notes 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'General Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '6D7A2BBE-6A1C-4A13-8972-104777B69BEB' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.ApprovalStatus 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Approval Tracking',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '49A875BB-7630-4E94-AC58-66F610000BC1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.ApprovedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Approval Tracking',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '91E0E487-D81B-4602-AF75-52C5FCFB00EC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.ApprovedByMeetingID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Approval Tracking',
   GeneratedFormSection = 'Category',
   DisplayName = 'Approved By Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9E8778CE-5FB2-4F2C-82D2-581D5BD728A7' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '27A7EA95-F423-4618-8035-C6CEF17CCAD0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Minutes.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F517A92B-F5C7-4842-A904-CF57239F677F' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-clipboard-check */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-clipboard-check', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = 'BFA46589-88E7-45AF-A1DD-F9910DDD1717'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('ec2587bb-0d6f-4bcc-9732-138f06f03501', 'BFA46589-88E7-45AF-A1DD-F9910DDD1717', 'FieldCategoryInfo', '{"General Information":{"icon":"fa fa-info-circle","description":"Core identifiers and free‑form notes for the minutes artifact"},"Approval Tracking":{"icon":"fa fa-check-circle","description":"Fields that capture approval status, timestamps, and related meeting"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit timestamps"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('141e0531-a3ef-4176-b309-827ed4cbddba', 'BFA46589-88E7-45AF-A1DD-F9910DDD1717', 'FieldCategoryIcons', '{"General Information":"fa fa-info-circle","Approval Tracking":"fa fa-check-circle","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=1 for NEW entity (category: supporting, confidence: high) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 1, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = 'BFA46589-88E7-45AF-A1DD-F9910DDD1717'
      

/* Set categories for 19 fields */

-- UPDATE Entity Field Category Info Meetings.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'General Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9CC3F2BD-A9E0-4034-8759-6912199189E4' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.CommitteeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'General Information',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F1241E55-FEFE-4CBE-BA7D-9B79FECA3126' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.Committee 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'General Information',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '852B0082-7008-497D-8CCC-3A86DC371FDF' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.Title 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'General Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '629D9C8F-AC11-479A-852E-41213263F696' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'General Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '923D4880-C2DF-454F-B06C-392027C0B89C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.Status 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'General Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2DDBEB25-13D4-4157-9141-75B3FA3E6B20' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.CalendarEventID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'General Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2A813C73-484B-40B7-BE33-094FDB113416' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.StartDateTime 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Schedule & Timing',
   GeneratedFormSection = 'Category',
   DisplayName = 'Start Date/Time',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '45D8FAF6-513D-40AB-858A-83A046CF0E96' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.EndDateTime 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Schedule & Timing',
   GeneratedFormSection = 'Category',
   DisplayName = 'End Date/Time',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'AF847EA1-8549-4AC5-A03F-FD2C53824F26' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.TimeZone 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Schedule & Timing',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3D47DDE6-9A48-49A4-97B9-B74C113B1C89' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.LocationType 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Location & Access',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'DF7E91B3-3D0C-4860-913A-3ABD79E1AA85' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.LocationText 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Location & Access',
   GeneratedFormSection = 'Category',
   DisplayName = 'Location',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CA026FCD-1B43-4C6E-984A-27E197B474AC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.VideoProvider 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Location & Access',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FEF1718A-741B-44F3-8C79-17B1B7880C90' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.VideoMeetingID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Location & Access',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '699639BB-6601-4FDF-92E1-322BED6A2394' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.VideoJoinURL 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Video & Recording',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = 'B00EDD25-53FA-44C3-B540-A8CE4E16BB8B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.VideoRecordingURL 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Video & Recording',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '675A855F-2DA3-40BB-B522-3A5E346F6DAE' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.TranscriptURL 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Video & Recording',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = '85B0AE79-1E21-48C5-9AEA-2B4D538AD6DE' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A7E04C80-8961-4371-AAAA-D6ABBA5EB125' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Meetings.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '510CD2F8-7DBA-4BE7-A6AB-07B38C856BD9' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-handshake */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-handshake', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = 'C6C5BD14-0D36-4442-812E-97F802728524'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('41c60e8d-7daf-4e83-91c4-fe5fdf36edb6', 'C6C5BD14-0D36-4442-812E-97F802728524', 'FieldCategoryInfo', '{"General Information":{"icon":"fa fa-info-circle","description":"Core identifiers, committee reference, title, description, status and calendar sync data"},"Schedule & Timing":{"icon":"fa fa-calendar-alt","description":"Planned start/end times and associated timezone information"},"Location & Access":{"icon":"fa fa-map-marker-alt","description":"Physical or virtual venue details and video platform identifiers"},"Video & Recording":{"icon":"fa fa-video","description":"Links for joining, recordings and transcripts of the meeting"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit fields"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('ab55d703-9685-4f4a-9419-98a81dbc0dd7', 'C6C5BD14-0D36-4442-812E-97F802728524', 'FieldCategoryIcons', '{"General Information":"fa fa-info-circle","Schedule & Timing":"fa fa-calendar-alt","Location & Access":"fa fa-map-marker-alt","Video & Recording":"fa fa-video","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=1 for NEW entity (category: primary, confidence: medium) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 1, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = 'C6C5BD14-0D36-4442-812E-97F802728524'
      

/* Set categories for 16 fields */

-- UPDATE Entity Field Category Info Memberships.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3FD73786-B92B-4197-9575-566BB9F40D9D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1BF89154-FC67-492D-88DB-BCBA9A850E62' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '90C2610D-F618-4E32-9BC1-17140C4D7A2B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.CommitteeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Membership Assignment',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9EC10E3D-F9A0-4C7C-A262-B3C0B547780B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.PersonID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Membership Assignment',
   GeneratedFormSection = 'Category',
   DisplayName = 'Person',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '30B03BE5-1775-456F-B899-9658056F3665' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.RoleID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Membership Assignment',
   GeneratedFormSection = 'Category',
   DisplayName = 'Role',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FF81A867-5EFB-4FE7-8515-5126B329D94D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.TermID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Membership Assignment',
   GeneratedFormSection = 'Category',
   DisplayName = 'Term',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FBC3BEAA-4FAD-4BF9-B31D-71A6F4809765' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.Committee 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Membership Assignment',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '503BA90F-4261-4C3F-B7E9-CF04058BE313' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.Person 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Membership Assignment',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '538CA2E3-6A9C-444B-8F31-7FB9C1A359FD' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.Role 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Membership Assignment',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7B128C05-68B0-4639-B0EE-E10E003984B2' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.Term 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Membership Assignment',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A394BEE2-4D53-478C-A422-B98BE40E0351' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.StartDate 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Timeline & Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FFCBF67A-D89D-49E9-9625-67340FA67E65' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.EndDate 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Timeline & Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C361B0ED-2A37-417F-878E-13E78EBFBA39' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.Status 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Timeline & Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2C1AD820-598D-4BC3-AD20-8A75C1144A5E' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.EndReason 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Timeline & Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8DBC5DF8-12DC-4EC6-9548-60042FA1313F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Memberships.Notes 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Timeline & Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D17C9B81-5ABB-45A4-9C30-D9D8214A5CBA' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-users */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-users', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('d803bd8a-aaf7-44cb-bcc5-214190b277c6', 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', 'FieldCategoryInfo', '{"Membership Assignment":{"icon":"fa fa-users","description":"Links and descriptive names for committee, person, role, and term assignments"},"Timeline & Status":{"icon":"fa fa-calendar","description":"Dates, current status, termination reason and related notes for the membership"},"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields and primary identifier"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('f06d2737-ae84-47c2-8dc0-1474df1411c0', 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6', 'FieldCategoryIcons', '{"Membership Assignment":"fa fa-users","Timeline & Status":"fa fa-calendar","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=1 for NEW entity (category: supporting, confidence: medium) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 1, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = 'F1ECEB8F-A39B-4CCA-8275-CB969FB40EC6'
      

/* Set categories for 18 fields */

-- UPDATE Entity Field Category Info Committees.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '88431915-0F7D-4E5C-BC9A-FD95706C941B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.Name 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Committee Overview',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8193DBD4-D612-4BAC-8B17-F4113DEE257A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Committee Overview',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '867F6D12-3FA5-40E0-93C4-E20E48FA6D0C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.MissionStatement 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Committee Overview',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '73E40E52-02DB-47FF-BE41-8F696BAFB190' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.TypeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Classification',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee Type',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D447B324-45B7-45C6-AD55-25C4832BF2D2' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.Type 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Classification',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee Type Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B4B7B5CE-ACF5-478B-BE12-FFF166D8F9E1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.OrganizationID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Classification',
   GeneratedFormSection = 'Category',
   DisplayName = 'Organization',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D49864F3-8FFE-4DD7-8686-8C629CD656EF' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.Organization 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Classification',
   GeneratedFormSection = 'Category',
   DisplayName = 'Organization Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C203C5E3-2FFC-4A8D-910E-C9A9FB97B60A' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.ParentCommitteeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Hierarchy',
   GeneratedFormSection = 'Category',
   DisplayName = 'Parent Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '28B3B925-EA9D-45D9-90C7-A80EF90310A4' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.ParentCommittee 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Hierarchy',
   GeneratedFormSection = 'Category',
   DisplayName = 'Parent Committee Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5BDB6D78-7496-4DF0-921E-FD5C70C52EB9' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.RootParentCommitteeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Hierarchy',
   GeneratedFormSection = 'Category',
   DisplayName = 'Root Parent Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '83AB3738-C8D7-4E55-A74C-869A8C6B2310' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.CharterDocumentURL 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Governance & Status',
   GeneratedFormSection = 'Category',
   ExtendedType = 'URL',
   CodeType = NULL
WHERE 
   ID = 'E104DF24-1A71-4437-A971-FF8064103005' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.Status 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Governance & Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D6F9A1CE-45FA-49C1-961A-346BBD3F507E' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.IsPublic 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Governance & Status',
   GeneratedFormSection = 'Category',
   DisplayName = 'Publicly Visible',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '25A841E5-3AF7-47CB-9863-3F591B662D45' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.FormationDate 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Governance & Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C54D7FA6-5A38-4C1B-BA72-8C33D133A695' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.DissolutionDate 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Governance & Status',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3FC4F1E7-EE4A-489E-B419-98102BB3C2AC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '9D992975-6E4A-442D-8F1D-21F799B656BA' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Committees.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '564E1DB9-5F6D-4352-957B-BA07076D7B74' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-users */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-users', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = '2B971E92-BBCE-462C-9868-807F9C04430D'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('1e043f61-7873-4ca3-9f8a-99af4a8e929c', '2B971E92-BBCE-462C-9868-807F9C04430D', 'FieldCategoryInfo', '{"Committee Overview":{"icon":"fa fa-info-circle","description":"Core descriptive details of the committee such as name, description, and mission"},"Classification":{"icon":"fa fa-tags","description":"Categorization of the committee by type and its parent organization"},"Hierarchy":{"icon":"fa fa-sitemap","description":"Parent‑child relationships linking to other committees in the hierarchy"},"Governance & Status":{"icon":"fa fa-gavel","description":"Governance documents, operational status, visibility, and lifecycle dates"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit and technical fields"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('dbb4069f-1f05-41ce-8b3d-5c669431a591', '2B971E92-BBCE-462C-9868-807F9C04430D', 'FieldCategoryIcons', '{"Committee Overview":"fa fa-info-circle","Classification":"fa fa-tags","Hierarchy":"fa fa-sitemap","Governance & Status":"fa fa-gavel","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=1 for NEW entity (category: primary, confidence: high) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 1, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = '2B971E92-BBCE-462C-9868-807F9C04430D'
      

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'B0408D09-CF61-4D1D-B951-8E0C5490BD29'
               AND AutoUpdateDefaultInView = 1
            

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '1D7E13DF-447A-49B8-9A07-1FA0CC058115'
               AND AutoUpdateDefaultInView = 1
            

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
               WHERE ID = '1B312AA3-5CCC-48E6-B034-A8BF437C9A4D'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '0BC215F7-F097-4246-A9F1-112D7E47C1A0'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '5F857A6E-BEFC-4C29-BC2B-FD6876C269B2'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

            UPDATE [${flyway:defaultSchema}].[EntityField]
            SET IsNameField = 1
            WHERE ID = 'A8482D32-01F1-448D-A958-354A46144F4F'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '2D91F10D-04A1-4B00-BCF7-D889E80303CC'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'A8482D32-01F1-448D-A958-354A46144F4F'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '1E001563-E6B3-49CD-AB5A-BCCFCFBE04E6'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'B33E9C74-C557-4A7B-9E6A-DA885582017D'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'A8482D32-01F1-448D-A958-354A46144F4F'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '1E001563-E6B3-49CD-AB5A-BCCFCFBE04E6'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'B33E9C74-C557-4A7B-9E6A-DA885582017D'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '28DAA78C-FABD-438D-8F24-055987B58B60'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '41F97D51-B1CC-4968-B7EC-B2F452D60322'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'EFD20ADA-E18B-41DC-8F4F-F4ED58FE0165'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '97844D3B-A436-4CE7-8246-976BA9FF9A87'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '695D7778-DE23-4866-BC21-045A5DDC48FA'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '41F97D51-B1CC-4968-B7EC-B2F452D60322'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set categories for 16 fields */

-- UPDATE Entity Field Category Info Motions.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '40EA1D10-2D87-4337-944A-48DFCEE061DC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.MeetingID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Motion Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Meeting',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '83988BE7-E19B-48BA-A360-E3158D903F48' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.AgendaItemID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Motion Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Agenda Item',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1B91BA05-53A2-4C5C-B034-22BC1832CCDF' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.Sequence 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Motion Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '2D91F10D-04A1-4B00-BCF7-D889E80303CC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.Title 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Motion Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A8482D32-01F1-448D-A958-354A46144F4F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Motion Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '3B9453F6-EC9E-4D47-BC10-29C9E09463D1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.MovedByMembershipID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Member Participation',
   GeneratedFormSection = 'Category',
   DisplayName = 'Moved By',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'DE818F09-2CC4-4B00-8635-AAC75320BA53' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.SecondedByMembershipID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Member Participation',
   GeneratedFormSection = 'Category',
   DisplayName = 'Seconded By',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8A849122-7EC5-476D-A8E8-A7561BDD4BE4' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.Notes 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Member Participation',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C2C862E1-C0C9-4004-A0DA-FA2FE45DD3A1' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.Result 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Voting Outcome',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1E001563-E6B3-49CD-AB5A-BCCFCFBE04E6' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.ResultSummary 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Voting Outcome',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B33E9C74-C557-4A7B-9E6A-DA885582017D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.YesCount 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Voting Outcome',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C261B616-394B-438E-8D8A-FA69B869FE66' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.NoCount 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Voting Outcome',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '65FDFA6A-9F61-42BC-A371-CB41634F0305' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.AbstainCount 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Voting Outcome',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '48291A88-3B5E-4FCB-99C8-C22D7EDDF97B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B579595C-90CC-4270-B561-1E83538DBBDB' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Motions.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'F6A6998C-80C8-49F6-A6F3-1E04CAA8591B' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-gavel */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-gavel', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('77f1c688-2b61-4205-b4c3-bce1aa422e00', 'EB4EE1A6-CC17-4B5F-8140-8E1719548264', 'FieldCategoryInfo', '{"Motion Details":{"icon":"fa fa-file-alt","description":"Core information about the motion including title, description, sequence and meeting linkage"},"Member Participation":{"icon":"fa fa-users","description":"Members involved in proposing and seconding the motion plus any related notes"},"Voting Outcome":{"icon":"fa fa-check-circle","description":"Result status, summary, and vote counts for the motion"},"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields and primary identifier"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('dd4837d9-7711-4e58-b5bd-83dfacec2d76', 'EB4EE1A6-CC17-4B5F-8140-8E1719548264', 'FieldCategoryIcons', '{"Motion Details":"fa fa-file-alt","Member Participation":"fa fa-users","Voting Outcome":"fa fa-check-circle","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=1 for NEW entity (category: primary, confidence: medium) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 1, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = 'EB4EE1A6-CC17-4B5F-8140-8E1719548264'
      

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'A5667471-A02F-4FE3-8647-EDD2502A690F'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '8A5B8A62-227B-4942-B034-FF1E93C2C33F'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '1C8ADDF0-4EB6-4D49-A4BB-46175860F5D9'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '1DCBFE34-3D1A-4490-8E65-E8117F93B116'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '30791651-1AC3-4E9A-B044-6C9F2000F857'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '5614F5A4-86FD-4FA1-A5BB-7ED0E6D9AA26'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '7DBC4C1F-7D71-426A-80E3-C88A1F772C01'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '5614F5A4-86FD-4FA1-A5BB-7ED0E6D9AA26'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '7DBC4C1F-7D71-426A-80E3-C88A1F772C01'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'E7E8477D-21DD-41AA-9D2C-EE4178699832'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '10BC7C08-FE35-4D29-9F27-F38701C8BA01'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'A5942466-BFA4-43ED-99DC-FE1083BF27D9'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'D71F526F-711A-4B8E-93D5-261FB8BFFF56'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set field properties for entity */

            UPDATE [${flyway:defaultSchema}].[EntityField]
            SET IsNameField = 1
            WHERE ID = 'E0C19372-93D7-4E75-915B-BBD903458C7C'
            AND AutoUpdateIsNameField = 1
         

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = 'E0C19372-93D7-4E75-915B-BBD903458C7C'
               AND AutoUpdateDefaultInView = 1
            

               UPDATE [${flyway:defaultSchema}].[EntityField]
               SET DefaultInView = 1
               WHERE ID = '82E90D63-1575-45AB-99B2-37E5A69765BF'
               AND AutoUpdateDefaultInView = 1
            

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = 'E0C19372-93D7-4E75-915B-BBD903458C7C'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

                  UPDATE [${flyway:defaultSchema}].[EntityField]
                  SET IncludeInUserSearchAPI = 1
                  WHERE ID = '82E90D63-1575-45AB-99B2-37E5A69765BF'
                  AND AutoUpdateIncludeInUserSearchAPI = 1
               

/* Set categories for 8 fields */

-- UPDATE Entity Field Category Info Types.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Identification',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '80AD3535-86C8-4DEB-911F-5A325E2DE110' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Types.Name 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Identification',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B207F4ED-87EE-4CFC-ADB5-80A1FB53A88E' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Types.IconClass 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Identification',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8A5B8A62-227B-4942-B034-FF1E93C2C33F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Types.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Definition',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1C8ADDF0-4EB6-4D49-A4BB-46175860F5D9' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Types.IsStandards 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Definition',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A5667471-A02F-4FE3-8647-EDD2502A690F' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Types.DefaultTermMonths 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Definition',
   GeneratedFormSection = 'Category',
   DisplayName = 'Default Term (Months)',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E055F3C2-16A5-440B-BA16-E45E46C0B5EA' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Types.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '92410245-9324-4274-A689-17EB063ABC7B' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Types.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'B24AE8BE-B6A5-4C07-A4CE-E0A06AB77236' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-users-cog */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-users-cog', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = '45382FA4-D82D-40F9-A105-24F227AB50C8'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('13434176-68a5-46ed-af35-75884e86e8c0', '45382FA4-D82D-40F9-A105-24F227AB50C8', 'FieldCategoryInfo', '{"Identification":{"icon":"fa fa-id-card","description":"Core identifiers and visual icon for the committee type"},"Definition":{"icon":"fa fa-info-circle","description":"Descriptive text and governance settings for the committee type"},"System Metadata":{"icon":"fa fa-cog","description":"System‑managed audit and tracking fields"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('90bc4703-d87a-4a4f-9bdf-fd175d4d256c', '45382FA4-D82D-40F9-A105-24F227AB50C8', 'FieldCategoryIcons', '{"Identification":"fa fa-id-card","Definition":"fa fa-info-circle","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=0 for NEW entity (category: reference, confidence: high) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 0, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = '45382FA4-D82D-40F9-A105-24F227AB50C8'
      

/* Set categories for 9 fields */

-- UPDATE Entity Field Category Info Roles.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '292F9B62-3E11-4BB3-9D27-5B491D944C4C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Roles.Name 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Core Role Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '01189293-73E8-472C-85CD-1D34E98DB573' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Roles.Description 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Core Role Information',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'D71F526F-711A-4B8E-93D5-261FB8BFFF56' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Roles.Sequence 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Core Role Information',
   GeneratedFormSection = 'Category',
   DisplayName = 'Display Order',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A5942466-BFA4-43ED-99DC-FE1083BF27D9' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Roles.IsOfficer 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Role Settings',
   GeneratedFormSection = 'Category',
   DisplayName = 'Officer Role',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E7E8477D-21DD-41AA-9D2C-EE4178699832' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Roles.IsVotingRole 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Role Settings',
   GeneratedFormSection = 'Category',
   DisplayName = 'Voting Role',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '10BC7C08-FE35-4D29-9F27-F38701C8BA01' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Roles.DefaultPermissionsJSON 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Role Settings',
   GeneratedFormSection = 'Category',
   DisplayName = 'Default Permissions',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'A7E540FA-092E-4F81-AD7A-AD5B9B25175D' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Roles.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1BCB5B66-433C-4046-8391-97D903E03401' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Roles.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '993CA953-4598-4273-A70B-84F0A2D27C9E' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-users */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-users', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = '213B8FB0-6855-442C-8D60-B126F6AE2D38'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('761b2181-45dd-42a7-b60b-ca1e5b29d8da', '213B8FB0-6855-442C-8D60-B126F6AE2D38', 'FieldCategoryInfo', '{"Core Role Information":{"icon":"fa fa-id-card","description":"Basic definition of a role including its name, description, and display order"},"Role Settings":{"icon":"fa fa-sliders-h","description":"Configuration flags and default permissions that govern role behavior"},"System Metadata":{"icon":"fa fa-cog","description":"Technical audit fields managed by the system"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('607d9900-2ddd-483c-8de0-aeac20bce3ae', '213B8FB0-6855-442C-8D60-B126F6AE2D38', 'FieldCategoryIcons', '{"Core Role Information":"fa fa-id-card","Role Settings":"fa fa-sliders-h","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=0 for NEW entity (category: reference, confidence: high) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 0, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = '213B8FB0-6855-442C-8D60-B126F6AE2D38'
      

/* Set categories for 7 fields */

-- UPDATE Entity Field Category Info Votes.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'CCDEDD90-F689-48CD-B71C-08CB071B9442' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.MotionID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'References',
   GeneratedFormSection = 'Category',
   DisplayName = 'Motion',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '96ACC971-ED28-4917-BE17-C66714EEB8D0' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.MembershipID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'References',
   GeneratedFormSection = 'Category',
   DisplayName = 'Member',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '8F9E992F-3912-49E9-AA2C-B10DB0335BFB' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.VoteValue 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Vote Details',
   GeneratedFormSection = 'Category',
   DisplayName = 'Vote',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'E0C19372-93D7-4E75-915B-BBD903458C7C' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.Notes 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Vote Details',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '82E90D63-1575-45AB-99B2-37E5A69765BF' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '582FC669-98E5-4337-917F-0284AE41CE47' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Votes.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '05AB1CBF-9A22-48D7-8DB9-74BBE7812538' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-ballot */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-ballot', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = 'F77CA3D7-5717-4149-8479-F258EF819C7A'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('3b21630b-078d-487a-b8ca-08920f58d72a', 'F77CA3D7-5717-4149-8479-F258EF819C7A', 'FieldCategoryInfo', '{"Vote Details":{"icon":"fa fa-check-circle","description":"Core voting outcome and optional commentary"},"References":{"icon":"fa fa-link","description":"Links to the related motion and committee member"},"System Metadata":{"icon":"fa fa-cog","description":"Audit timestamps and record identifier"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('a9eb3a1d-7062-4388-b8d6-6bcccf6dab2a', 'F77CA3D7-5717-4149-8479-F258EF819C7A', 'FieldCategoryIcons', '{"Vote Details":"fa fa-check-circle","References":"fa fa-link","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=0 for NEW entity (category: supporting, confidence: medium) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 0, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = 'F77CA3D7-5717-4149-8479-F258EF819C7A'
      

/* Set categories for 9 fields */

-- UPDATE Entity Field Category Info Terms.ID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1F885EED-15CD-41DC-B5DC-AF2F587A56DC' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Terms.CommitteeID 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Term Overview',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'FA338DF3-0781-4D4C-AFE6-8CE7B13F0D64' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Terms.Name 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Term Overview',
   GeneratedFormSection = 'Category',
   DisplayName = 'Term Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '918AA42B-FF44-43B4-BCB2-0842602962DF' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Terms.StartDate 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Term Schedule',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1DCBFE34-3D1A-4490-8E65-E8117F93B116' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Terms.EndDate 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Term Schedule',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '30791651-1AC3-4E9A-B044-6C9F2000F857' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Terms.Status 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Term Overview',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '5614F5A4-86FD-4FA1-A5BB-7ED0E6D9AA26' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Terms.__mj_CreatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = 'C2AA3F28-AE0D-4AAB-BC9B-CECC8673F614' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Terms.__mj_UpdatedAt 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'System Metadata',
   GeneratedFormSection = 'Category',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '1A06A522-FFBF-4A1F-AB68-6EA0149F9B52' AND AutoUpdateCategory = 1

-- UPDATE Entity Field Category Info Terms.Committee 
UPDATE [${flyway:defaultSchema}].[EntityField]
SET 
   Category = 'Term Overview',
   GeneratedFormSection = 'Category',
   DisplayName = 'Committee Name',
   ExtendedType = NULL,
   CodeType = NULL
WHERE 
   ID = '7DBC4C1F-7D71-426A-80E3-C88A1F772C01' AND AutoUpdateCategory = 1

/* Set entity icon to fa fa-calendar-alt */

               UPDATE [${flyway:defaultSchema}].[Entity]
               SET Icon = 'fa fa-calendar-alt', __mj_UpdatedAt = GETUTCDATE()
               WHERE ID = 'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D'
            

/* Insert FieldCategoryInfo setting for entity */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('ba695e40-d095-4082-92a8-5f0e7293b370', 'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D', 'FieldCategoryInfo', '{"Term Overview":{"icon":"fa fa-info-circle","description":"Core information about the committee term including name, associated committee and current status"},"Term Schedule":{"icon":"fa fa-calendar","description":"Start and end dates that define the term’s time span"},"System Metadata":{"icon":"fa fa-cog","description":"Audit fields managed by the system"}}', GETUTCDATE(), GETUTCDATE())
            

/* Insert FieldCategoryIcons setting (legacy) */

               INSERT INTO [${flyway:defaultSchema}].[EntitySetting] (ID, EntityID, Name, Value, __mj_CreatedAt, __mj_UpdatedAt)
               VALUES ('62ddb77b-1c8a-4616-acf7-695077d40c1c', 'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D', 'FieldCategoryIcons', '{"Term Overview":"fa fa-info-circle","Term Schedule":"fa fa-calendar","System Metadata":"fa fa-cog"}', GETUTCDATE(), GETUTCDATE())
            

/* Set DefaultForNewUser=0 for NEW entity (category: reference, confidence: high) */

         UPDATE [${flyway:defaultSchema}].[ApplicationEntity]
         SET DefaultForNewUser = 0, __mj_UpdatedAt = GETUTCDATE()
         WHERE EntityID = 'AE427EEA-A9D3-4B1B-8B68-C59754E6E03D'
      

