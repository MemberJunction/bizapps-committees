-- =============================================================================
-- BizAppsCommittees: Add Nullable MJArtifactID & ApprovedArtifactVersionID
-- Foreign Keys to Committees.Minute and MJArtifactID to Committees.Artifact
-- =============================================================================
-- Strictly additive migration bridging Committees Minutes and Artifacts with
-- native MJ Docs (MJ: Artifacts / MJ: Artifact Versions):
--   * Adds nullable [MJArtifactID] UNIQUEIDENTIFIER NULL FK -> [${mjSchema}].[Artifact]([ID])
--     to [${flyway:defaultSchema}].[Minute] (when NULL, legacy Minute.Content is used).
--   * Adds nullable [ApprovedArtifactVersionID] UNIQUEIDENTIFIER NULL
--     FK -> [${mjSchema}].[ArtifactVersion]([ID]) to [${flyway:defaultSchema}].[Minute]
--     for immutable version pinning upon minute approval.
--   * Adds nullable [MJArtifactID] UNIQUEIDENTIFIER NULL FK -> [${mjSchema}].[Artifact]([ID])
--     to [${flyway:defaultSchema}].[Artifact] (bridging external URL links vs native MJ Docs).
--
-- Backward-compatibility guarantees (PUBLISH_NO_BREAK_POLICY.md):
--   * Minute.Content, Minute.ArtifactID, Artifact.URL, Artifact.Provider, and all
--     existing columns remain intact and untouched.
--   * Motion.Notes, Vote.Notes, and Attendance.Notes remain strictly relational (Category C).
--   * All three foreign keys specify ON DELETE NO ACTION for SQL Server / PostgreSQL parity
--     and to prevent multiple-cascade-path errors on Minute.
--   * CodeGen owns automatic single-column FK indexes (IDX_AUTO_MJ_FKEY_*), base view
--     updates (vwMinutes, vwArtifacts), CRUD stored procedures, and EntityField metadata.
-- =============================================================================

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

ALTER TABLE [${flyway:defaultSchema}].[Minute]
ADD [MJArtifactID] UNIQUEIDENTIFIER NULL,
    [ApprovedArtifactVersionID] UNIQUEIDENTIFIER NULL;
GO

ALTER TABLE [${flyway:defaultSchema}].[Minute]
ADD CONSTRAINT [FK_Minute_MJArtifact]
        FOREIGN KEY ([MJArtifactID]) REFERENCES [${mjSchema}].[Artifact] ([ID]) ON DELETE NO ACTION,
    CONSTRAINT [FK_Minute_ApprovedArtifactVersion]
        FOREIGN KEY ([ApprovedArtifactVersionID]) REFERENCES [${mjSchema}].[ArtifactVersion] ([ID]) ON DELETE NO ACTION;
GO

ALTER TABLE [${flyway:defaultSchema}].[Artifact]
ADD [MJArtifactID] UNIQUEIDENTIFIER NULL;
GO

ALTER TABLE [${flyway:defaultSchema}].[Artifact]
ADD CONSTRAINT [FK_Artifact_MJArtifact]
        FOREIGN KEY ([MJArtifactID]) REFERENCES [${mjSchema}].[Artifact] ([ID]) ON DELETE NO ACTION;
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Optional foreign key to MJ: Artifacts linking this meeting minute to a native MJ Docs document. When NULL, legacy Minute.Content is used.',
    @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}',
    @level1type = N'TABLE',  @level1name = N'Minute',
    @level2type = N'COLUMN', @level2name = N'MJArtifactID';
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Optional foreign key to MJ: Artifact Versions pinning this minute to an immutable approved version of the linked MJArtifactID document. Must belong to MJArtifactID and must be NULL when MJArtifactID is NULL.',
    @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}',
    @level1type = N'TABLE',  @level1name = N'Minute',
    @level2type = N'COLUMN', @level2name = N'ApprovedArtifactVersionID';
GO

EXEC sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Optional foreign key to MJ: Artifacts linking this committee artifact to a native MJ Docs document. When NULL, the artifact is an external URL or cloud-provider link.',
    @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}',
    @level1type = N'TABLE',  @level1name = N'Artifact',
    @level2type = N'COLUMN', @level2name = N'MJArtifactID';
GO























































/* =============================================================================
 * CODEGEN GENERATED SQL — Single-pass `mj codegen` output
 * Generated against MJ 6.3.0-edge.1 scratch DB after applying Part 1 DDL above.
 * (Live-only spDeleteUnneededEntityFields omitted per check-migration-no-prune.mjs.)
 * ============================================================================= */

/* SQL text to update existing entities from schema */
EXEC [${mjSchema}].[spUpdateExistingEntitiesFromSchema] @ExcludedSchemaNames='', @IncludedSchemaNames='${flyway:defaultSchema}';

/* Seed Hierarchy.IsHierarchy on legacy self-referencing FK Committees: Agenda Items.ParentAgendaItemID */
UPDATE [${mjSchema}].[EntityField]
                         SET [Configuration] = '{"Hierarchy":{"IsHierarchy":true}}'
                         WHERE [ID] = 'F3793FB0-E8BE-4E77-9776-8EAC87E2FD8E' AND ([Configuration] IS NULL OR [Configuration] = '');

/* Seed Hierarchy.IsHierarchy on legacy self-referencing FK Committees: Comments.ParentCommentID */
UPDATE [${mjSchema}].[EntityField]
                         SET [Configuration] = '{"Hierarchy":{"IsHierarchy":true}}'
                         WHERE [ID] = '4D316764-A3C3-473B-BEF5-03B6CC27699F' AND ([Configuration] IS NULL OR [Configuration] = '');

/* Seed Hierarchy.IsHierarchy on legacy self-referencing FK Committees: Committees.ParentCommitteeID */
UPDATE [${mjSchema}].[EntityField]
                         SET [Configuration] = '{"Hierarchy":{"IsHierarchy":true}}'
                         WHERE [ID] = 'D0D9D59A-0081-4B68-AE77-CD8F6D9F92F8' AND ([Configuration] IS NULL OR [Configuration] = '');

/* SQL text to insert 3 new entity field(s) */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '85f11ba1-7826-422a-b8cb-a69b74192f25' OR (EntityID = '272BEFB5-727A-4525-B235-775A56B7ACBB' AND Name = 'MJArtifactID')) BEGIN
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
            '85f11ba1-7826-422a-b8cb-a69b74192f25',
            '272BEFB5-727A-4525-B235-775A56B7ACBB', -- Entity: Committees: Artifacts
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '272BEFB5-727A-4525-B235-775A56B7ACBB'),
            'MJArtifactID',
            'MJ Artifact ID',
            'Optional foreign key to MJ: Artifacts linking this committee artifact to a native MJ Docs document. When NULL, the artifact is an external URL or cloud-provider link.',
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
            'F48D2341-8667-40BB-BCA8-87D7F80E16CD',
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '94b85e5a-de77-4b71-bc0d-0b7123794ed8' OR (EntityID = '0EC944F9-F908-4662-87B2-E57077A873FF' AND Name = 'MJArtifactID')) BEGIN
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
            '94b85e5a-de77-4b71-bc0d-0b7123794ed8',
            '0EC944F9-F908-4662-87B2-E57077A873FF', -- Entity: Committees: Minutes
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '0EC944F9-F908-4662-87B2-E57077A873FF'),
            'MJArtifactID',
            'MJ Artifact ID',
            'Optional foreign key to MJ: Artifacts linking this meeting minute to a native MJ Docs document. When NULL, legacy Minute.Content is used.',
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
            'F48D2341-8667-40BB-BCA8-87D7F80E16CD',
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'e52aef7a-c9f8-4cde-ab50-825e4304893a' OR (EntityID = '0EC944F9-F908-4662-87B2-E57077A873FF' AND Name = 'ApprovedArtifactVersionID')) BEGIN
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
            'e52aef7a-c9f8-4cde-ab50-825e4304893a',
            '0EC944F9-F908-4662-87B2-E57077A873FF', -- Entity: Committees: Minutes
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '0EC944F9-F908-4662-87B2-E57077A873FF'),
            'ApprovedArtifactVersionID',
            'Approved Artifact Version ID',
            'Optional foreign key to MJ: Artifact Versions pinning this minute to an immutable approved version of the linked MJArtifactID document. Must belong to MJArtifactID and must be NULL when MJArtifactID is NULL.',
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
            'AEB408D2-162A-49AE-9DC2-DBE9A21A3C01',
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

/* SQL text to update existing entity fields from schema */
EXEC [${mjSchema}].[spUpdateExistingEntityFieldsFromSchema] @ExcludedSchemaNames='', @IncludedSchemaNames='${flyway:defaultSchema}';

/* SQL text to sync entity unique keys (7 added, 0 updated, 0 removed) */
INSERT INTO [${mjSchema}].[EntityUniqueKey] ([ID], [EntityID], [Name], [FieldNames], [FilterDefinition]) VALUES ('1ca2adea-9073-4785-9459-0baf06973c16', '07BB0F44-EC35-4CAF-8C36-A766A545159D', 'UQ_ArtifactType_Name', 'Name', NULL);
INSERT INTO [${mjSchema}].[EntityUniqueKey] ([ID], [EntityID], [Name], [FieldNames], [FilterDefinition]) VALUES ('b8878a97-68bc-46ea-89a8-d8360d880dc8', '194B3496-2829-4806-BC42-CF0724A1DD26', 'UQ_Ballot_Motion', 'MotionID', NULL);
INSERT INTO [${mjSchema}].[EntityUniqueKey] ([ID], [EntityID], [Name], [FieldNames], [FilterDefinition]) VALUES ('7a3610ba-f54a-4971-8714-79f2c92edc4b', '93C97937-A33B-41D2-9791-FC271E49F96F', 'UQ_Type_Name', 'Name', NULL);
INSERT INTO [${mjSchema}].[EntityUniqueKey] ([ID], [EntityID], [Name], [FieldNames], [FilterDefinition]) VALUES ('0ad5238d-7ab7-4a8b-a358-e3c414ac2191', '94A59079-7436-4178-A31B-9B42DDA822C1', 'UQ_Vote', 'MotionID,MembershipID', NULL);
INSERT INTO [${mjSchema}].[EntityUniqueKey] ([ID], [EntityID], [Name], [FieldNames], [FilterDefinition]) VALUES ('78ac5cad-b26a-4051-a0ff-c6f3e51a4a43', '9BEDCBE8-0EF8-4F86-AB72-2063CE41A138', 'UQ_Role_Name', 'Name', NULL);
INSERT INTO [${mjSchema}].[EntityUniqueKey] ([ID], [EntityID], [Name], [FieldNames], [FilterDefinition]) VALUES ('47feced7-8e78-493a-ba8c-3b443a625181', 'E7D9813E-3C34-4233-AFCC-4CB76CFE081C', 'UQ_Attendance', 'MeetingID,PersonID', NULL);
INSERT INTO [${mjSchema}].[EntityUniqueKey] ([ID], [EntityID], [Name], [FieldNames], [FilterDefinition]) VALUES ('b4b529f2-5734-4e2e-930b-e99bb3f33f8c', 'F11B4DC5-9850-4782-B3A1-7D2277A19837', 'UQ_VideoProvider_Name', 'Name', NULL);

/* SQL text to set default column width where needed */
EXEC [${mjSchema}].[spSetDefaultColumnWidthWhereNeeded] @ExcludedSchemaNames='', @IncludedSchemaNames='${flyway:defaultSchema}';

/* SQL text to sync 6 entity field value row(s) for entity field ID 037FF375-4775-4E79-A577-B6CAC28232DE */
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='9BA1DA62-82EB-4B7F-AA0C-1B7C9980E286';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='DA4324A6-0C88-4798-AF2A-9E9A412D5C12';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='77E83A77-DA4C-42D5-BD2E-C0339C786175';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='15AC8450-4FBA-4304-98B7-25F53FF3DDAC';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='643B43E9-0B99-480D-A25C-B9D31CA72682';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='5C841A86-EE7F-4DDC-A574-48BF8098300C';

/* SQL text to sync 3 entity field value row(s) for entity field ID 027FDC1A-8C4C-4213-BEFA-0732875E3E25 */
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='60AE11A9-477F-42C8-8D5D-8FD9124B18FB';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='6AC0F3F4-9487-4653-B7A1-E34D1C8F9005';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='8FFCA08A-018B-4E26-A7B3-D3FC20B90415';

/* SQL text to sync 6 entity field value row(s) for entity field ID 8A910201-7941-4805-87DF-6B5474738257 */
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='D2725FCB-D772-4C9B-9850-77A13D3E84E5';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='97BD7889-7D51-4C85-8794-64E08D0A8572';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='D7C0AB32-6542-41FB-98F5-2659CB6E9296';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='F73EA186-195D-421C-B56B-565E5D8B542E';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='F2295655-AB8E-4193-92AD-B7165CC41E94';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='EECD42D1-8CF4-463B-9ED4-C97A87872BB0';

/* SQL text to sync 5 entity field value row(s) for entity field ID 56526981-0CC5-4CC8-BBD9-DF18DF2D25AB */
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='B36E3A90-8514-46CE-85E9-8DFA8BE233C0';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='857CA9E8-461F-4A95-8D2F-B245FCA2192A';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='DD6BD229-C92C-4263-971C-057FE95B3763';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='A9AB5983-B061-4773-9E07-582D6B43C0A7';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='68044DC3-8999-4011-B859-868D03538C75';

/* SQL text to sync 5 entity field value row(s) for entity field ID 384C5BD0-6CF2-4BCE-8864-97B3EE0437FD */
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='AC9CDEF1-016B-4CDA-8FD0-9AD460E0DF02';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='77A11F9B-1781-41B7-9EBB-B21895AEC7CD';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='AE792113-6E50-4269-8F52-C18B42172096';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='8428D005-58C3-468E-A5B1-BC757EA88120';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='53582FC4-9028-4F5E-83DF-BE4043089747';

/* SQL text to sync 6 entity field value row(s) for entity field ID E750F12D-98D2-4B8F-87D1-BF5EC239E0B5 */
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='7B071685-8E73-473E-886A-6513759930D5';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='3E3446B7-B6EB-480C-AB96-EB2C5433F608';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='1FB13A4A-8353-4513-85A8-C482185DCFC5';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='29689013-42C3-421C-AA91-D4651DA1C046';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='F425B007-5BC4-47DD-8B52-3828D6F3E340';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='076E3A07-4E95-40EE-98A7-8161A920DB66';

/* SQL text to sync 4 entity field value row(s) for entity field ID 9E003073-E3D2-47E3-8BB4-BE12A8E6FE2B */
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='53B2D78E-6B49-4FAE-99A1-2C259997A8A0';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='B761349A-3BFB-4629-8ADA-B95508A3C81D';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='399F92FA-EC9D-407E-98C7-3C32B7D8F6D6';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='A82B1009-F6A9-4D0D-8B5E-5DBC2E0ACD8F';

/* SQL text to sync 5 entity field value row(s) for entity field ID 218BE2B4-659F-479F-8495-E7A5F4BDD60A */
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='C1E7CFC8-3352-4371-B007-7D055FDC5FB0';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='440DA35F-B40B-4221-B90B-8E81CEE578DA';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='493D32E0-91AC-409A-8265-3943990434EB';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='450E5F15-B5E4-4551-A903-F29896064668';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='D1657F4F-2D5B-407D-BA83-311FB957E3B0';

/* SQL text to sync 4 entity field value row(s) for entity field ID D7477465-D420-4905-B722-00B8794609DE */
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='6C4593E8-50EF-4172-BFA0-3087DDCCAAE8';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='670F5730-9439-4277-8050-C2D6EE009A47';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='40437D32-01D0-4712-A97C-0D70E51728A4';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='BC5142AF-5A90-4934-A38C-E5F326AA679B';

/* SQL text to sync 3 entity field value row(s) for entity field ID F4D30FF9-116C-4401-BCAF-A33631988BFD */
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='951AFFFA-40B0-4B04-BFC0-AD01582CA324';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='B6D5F97C-E4C4-4838-9DA2-B206F7055783';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='7D63B23F-33DE-49D3-82C8-1B58CA35C6CF';

/* SQL text to sync 3 entity field value row(s) for entity field ID 101F8FD4-5ACC-4368-84A6-CC6FED8ECC93 */
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='DC67AAD8-0DD3-44BB-B974-C02E825F1C87';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='0C25B161-6189-47EA-87A8-A9D58F474352';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='26D7F873-45D3-410B-AC00-3F4381372937';

/* SQL text to sync 3 entity field value row(s) for entity field ID 0A11C5F0-25BF-45B0-A299-699162195771 */
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='F02AAADF-3B5D-4D0E-BA2E-2E92C7A7B1AE';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='081EADFF-20F2-495A-9CCB-C2C8D9FE495C';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='C4A96028-203C-4048-9462-B7116F19D108';

/* SQL text to sync 4 entity field value row(s) for entity field ID C1A02E75-4C6E-49B0-96F3-79D1A8E26072 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [Source], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('fb286223-facf-4fb2-a936-7ac78dd484de', 'C1A02E75-4C6E-49B0-96F3-79D1A8E26072', 1, 'Critical', 'Critical', 'Check', GETUTCDATE(), GETUTCDATE());
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [Source], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('a1e73121-0377-430b-b838-dd469e417119', 'C1A02E75-4C6E-49B0-96F3-79D1A8E26072', 2, 'High', 'High', 'Check', GETUTCDATE(), GETUTCDATE());
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [Source], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('4330ef70-f32e-440c-b43e-8cde79ce0532', 'C1A02E75-4C6E-49B0-96F3-79D1A8E26072', 3, 'Low', 'Low', 'Check', GETUTCDATE(), GETUTCDATE());
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [Source], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('6961d0cb-1ef9-4ef0-bdd6-8f474f9dc646', 'C1A02E75-4C6E-49B0-96F3-79D1A8E26072', 4, 'Medium', 'Medium', 'Check', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID C1A02E75-4C6E-49B0-96F3-79D1A8E26072 */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='C1A02E75-4C6E-49B0-96F3-79D1A8E26072';

/* SQL text to sync 4 entity field value row(s) for entity field ID A70FE423-7FCC-4A69-8985-8B97A412DD50 */
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='DA47B784-AFDC-4400-973F-434DA68D68A4';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='B3BFEB4C-BAEC-4D3D-9A02-971B663CE2E4';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='09DB9D33-8C14-4255-BBB8-4344B3124AAB';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='A56F1075-99A2-4641-86CD-0EC01AA5EE73';

/* SQL text to sync 3 entity field value row(s) for entity field ID 39881813-0D5C-4A1E-B555-073757DB66AB */
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='B330AC38-3BD0-4F70-9E1A-F21FEDBEA16C';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='5037DE28-7CB7-4698-9B07-B07438722631';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='B2DAAE8C-B1EC-4073-B43D-5D66AF40F517';

/* SQL text to sync 4 entity field value row(s) for entity field ID D0B81AA7-32D5-49D2-B7B4-D67872C48787 */
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='4790060C-7241-4924-9E69-CC87EE626E82';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='0FB82B68-157F-47B6-A74E-AA0A1B3F7448';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='3971BE29-EA3C-4883-9852-4C5335B4A52B';
UPDATE [${mjSchema}].[EntityFieldValue] SET [Source]='Check' WHERE ID='5BC2E04E-BBF6-4A3E-B5E4-383FBF3637CE';


/* Create Entity Relationship: MJ: Artifacts -> Committees: Artifacts (One To Many via MJArtifactID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = '8bf09e5b-55f2-4391-910a-ecb4c65fac72' OR ([EntityID] = 'F48D2341-8667-40BB-BCA8-87D7F80E16CD' AND [RelatedEntityID] = '272BEFB5-727A-4525-B235-775A56B7ACBB' AND [RelatedEntityJoinField] = 'MJArtifactID')
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('8bf09e5b-55f2-4391-910a-ecb4c65fac72', 'F48D2341-8667-40BB-BCA8-87D7F80E16CD', '272BEFB5-727A-4525-B235-775A56B7ACBB', 'MJArtifactID', 'One To Many', 1, 1, 8, GETUTCDATE(), GETUTCDATE())
   END;


/* Create Entity Relationship: MJ: Artifacts -> Committees: Minutes (One To Many via MJArtifactID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'f6725681-68da-42f2-a8f9-749b38edcc50' OR ([EntityID] = 'F48D2341-8667-40BB-BCA8-87D7F80E16CD' AND [RelatedEntityID] = '0EC944F9-F908-4662-87B2-E57077A873FF' AND [RelatedEntityJoinField] = 'MJArtifactID')
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('f6725681-68da-42f2-a8f9-749b38edcc50', 'F48D2341-8667-40BB-BCA8-87D7F80E16CD', '0EC944F9-F908-4662-87B2-E57077A873FF', 'MJArtifactID', 'One To Many', 1, 1, 9, GETUTCDATE(), GETUTCDATE())
   END;


/* Create Entity Relationship: MJ: Artifact Versions -> Committees: Minutes (One To Many via ApprovedArtifactVersionID) */
   IF NOT EXISTS (
      SELECT 1 FROM [${mjSchema}].[EntityRelationship] WHERE [ID] = 'a155fac7-4cb9-42df-a377-650cb3b3a339' OR ([EntityID] = 'AEB408D2-162A-49AE-9DC2-DBE9A21A3C01' AND [RelatedEntityID] = '0EC944F9-F908-4662-87B2-E57077A873FF' AND [RelatedEntityJoinField] = 'ApprovedArtifactVersionID')
   )
   BEGIN
      INSERT INTO [${mjSchema}].[EntityRelationship] ([ID], [EntityID], [RelatedEntityID], [RelatedEntityJoinField], [Type], [BundleInAPI], [DisplayInForm], [Sequence], [__mj_CreatedAt], [__mj_UpdatedAt])
                    VALUES ('a155fac7-4cb9-42df-a377-650cb3b3a339', 'AEB408D2-162A-49AE-9DC2-DBE9A21A3C01', '0EC944F9-F908-4662-87B2-E57077A873FF', 'ApprovedArtifactVersionID', 'One To Many', 1, 1, 9, GETUTCDATE(), GETUTCDATE())
   END;

/* SQL text to sync schema info from database schemas */
EXEC [${mjSchema}].[spUpdateSchemaInfoFromDatabase] @ExcludedSchemaNames='', @IncludedSchemaNames='${flyway:defaultSchema}';

/* SQL text to update entity field related entity name field map for entity field ID 85F11BA1-7826-422A-B8CB-A69B74192F25 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='85F11BA1-7826-422A-B8CB-A69B74192F25', @RelatedEntityNameFieldMap='MJArtifact';

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
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_AgendaItem_MeetingID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[AgendaItem]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[AgendaItem]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'MeetingID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_AgendaItem_MeetingID ON [${flyway:defaultSchema}].[AgendaItem] ([MeetingID]);

-- Index for foreign key ParentAgendaItemID in table AgendaItem
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_AgendaItem_ParentAgendaItemID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[AgendaItem]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[AgendaItem]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'ParentAgendaItemID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_AgendaItem_ParentAgendaItemID ON [${flyway:defaultSchema}].[AgendaItem] ([ParentAgendaItemID]);

-- Index for foreign key PresenterPersonID in table AgendaItem
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_AgendaItem_PresenterPersonID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[AgendaItem]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[AgendaItem]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'PresenterPersonID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_AgendaItem_PresenterPersonID ON [${flyway:defaultSchema}].[AgendaItem] ([PresenterPersonID]);

/* Hierarchy Metadata Function SQL for Committees: Agenda Items.ParentAgendaItemID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Agenda Items
-- Item: fnAgendaItemParentAgendaItemID_GetHierarchyMeta
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- HIERARCHY METADATA FUNCTION FOR: [AgendaItem].[ParentAgendaItemID]
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[fnAgendaItemParentAgendaItemID_GetHierarchyMeta]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}].[fnAgendaItemParentAgendaItemID_GetHierarchyMeta];
GO

CREATE FUNCTION [${flyway:defaultSchema}].[fnAgendaItemParentAgendaItemID_GetHierarchyMeta]
(
    @RecordID uniqueidentifier,
    @ParentID uniqueidentifier
)
RETURNS TABLE
AS
RETURN
(
    WITH CTE_Ancestors AS (
        SELECT
            [ID],
            [ParentAgendaItemID],
            0 AS [Depth],
            CAST('/' + CAST([ID] AS NVARCHAR(36)) + '/' AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[AgendaItem]
        WHERE
            [ID] = @RecordID

        UNION ALL

        SELECT
            p.[ID],
            p.[ParentAgendaItemID],
            c.[Depth] + 1 AS [Depth],
            CAST('/' + CAST(p.[ID] AS NVARCHAR(36)) + c.[Path] AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[AgendaItem] p
        INNER JOIN
            CTE_Ancestors c ON p.[ID] = c.[ParentAgendaItemID]
        WHERE
            c.[Depth] < 100
    )
    SELECT TOP 1
        a.[ID] AS [RootID],
        a.[Depth] AS [Depth],
        a.[Path] AS [Path],
        CAST(CASE WHEN ch.[ChildCount] > 0 THEN 0 ELSE 1 END AS BIT) AS [IsLeaf],
        ch.[ChildCount] AS [ChildCount]
    FROM
        CTE_Ancestors a
    OUTER APPLY (
        SELECT COUNT(1) AS [ChildCount]
        FROM [${flyway:defaultSchema}].[AgendaItem]
        WHERE [ParentAgendaItemID] = @RecordID
    ) ch
    WHERE
        a.[ParentAgendaItemID] IS NULL OR @ParentID IS NULL
    ORDER BY
        a.[Depth] DESC
);
GO

/* Descendants Traversal Function SQL for Committees: Agenda Items.ParentAgendaItemID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Agenda Items
-- Item: fnAgendaItemParentAgendaItemID_GetDescendants
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- DESCENDANTS FUNCTION FOR: [AgendaItem].[ParentAgendaItemID]
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[fnAgendaItemParentAgendaItemID_GetDescendants]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}].[fnAgendaItemParentAgendaItemID_GetDescendants];
GO

CREATE FUNCTION [${flyway:defaultSchema}].[fnAgendaItemParentAgendaItemID_GetDescendants]
(
    @RootID uniqueidentifier,
    @MaxDepth INT = NULL
)
RETURNS TABLE
AS
RETURN
(
    WITH CTE_Descendants AS (
        SELECT
            [ID],
            [ParentAgendaItemID],
            0 AS [RelativeDepth],
            CAST('/' + CAST([ID] AS NVARCHAR(36)) + '/' AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[AgendaItem]
        WHERE
            [ID] = @RootID

        UNION ALL

        SELECT
            c.[ID],
            c.[ParentAgendaItemID],
            p.[RelativeDepth] + 1 AS [RelativeDepth],
            CAST(p.[Path] + CAST(c.[ID] AS NVARCHAR(36)) + '/' AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[AgendaItem] c
        INNER JOIN
            CTE_Descendants p ON c.[ParentAgendaItemID] = p.[ID]
        WHERE
            (@MaxDepth IS NULL OR p.[RelativeDepth] < @MaxDepth)
            AND p.[RelativeDepth] < 100
    )
    SELECT
        d.[ID] AS [ID],
        d.[RelativeDepth] AS [Depth],
        d.[Path],
        CAST(CASE WHEN EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[AgendaItem] WHERE [ParentAgendaItemID] = d.[ID]) THEN 0 ELSE 1 END AS BIT) AS [IsLeaf],
        (SELECT COUNT(1) FROM [${flyway:defaultSchema}].[AgendaItem] WHERE [ParentAgendaItemID] = d.[ID]) AS [ChildCount]
    FROM
        CTE_Descendants d
);
GO

/* Ancestors Traversal Function SQL for Committees: Agenda Items.ParentAgendaItemID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Agenda Items
-- Item: fnAgendaItemParentAgendaItemID_GetAncestors
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- ANCESTORS FUNCTION FOR: [AgendaItem].[ParentAgendaItemID]
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[fnAgendaItemParentAgendaItemID_GetAncestors]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}].[fnAgendaItemParentAgendaItemID_GetAncestors];
GO

CREATE FUNCTION [${flyway:defaultSchema}].[fnAgendaItemParentAgendaItemID_GetAncestors]
(
    @RecordID uniqueidentifier
)
RETURNS TABLE
AS
RETURN
(
    WITH CTE_Ancestors AS (
        SELECT
            [ID],
            [ParentAgendaItemID],
            0 AS [LevelUp],
            CAST('/' + CAST([ID] AS NVARCHAR(36)) + '/' AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[AgendaItem]
        WHERE
            [ID] = @RecordID

        UNION ALL

        SELECT
            p.[ID],
            p.[ParentAgendaItemID],
            c.[LevelUp] + 1 AS [LevelUp],
            CAST('/' + CAST(p.[ID] AS NVARCHAR(36)) + c.[Path] AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[AgendaItem] p
        INNER JOIN
            CTE_Ancestors c ON p.[ID] = c.[ParentAgendaItemID]
        WHERE
            c.[LevelUp] < 100
    )
    SELECT
        a.[ID] AS [ID],
        a.[LevelUp],
        a.[Path]
    FROM
        CTE_Ancestors a
);
GO

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
IF OBJECT_ID('[${flyway:defaultSchema}].[fnAgendaItemParentAgendaItemID_GetRootID]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}].[fnAgendaItemParentAgendaItemID_GetRootID];
GO

CREATE FUNCTION [${flyway:defaultSchema}].[fnAgendaItemParentAgendaItemID_GetRootID]
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
            [${flyway:defaultSchema}].[AgendaItem]
        WHERE
            [ID] = COALESCE(@ParentID, @RecordID)

        UNION ALL

        SELECT
            c.[ID],
            c.[ParentAgendaItemID],
            c.[ID] AS [RootParentID],
            p.[Depth] + 1 AS [Depth]
        FROM
            [${flyway:defaultSchema}].[AgendaItem] c
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
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  AgendaItem
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwAgendaItems]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwAgendaItems];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwAgendaItems]
AS
SELECT
    a.*,
    mjBizAppsCommitteesMeeting_MeetingID.[Name] AS [Meeting],
    mjBizAppsCommitteesAgendaItem_ParentAgendaItemID.[Name] AS [ParentAgendaItem],
    mjBizAppsCommonPerson_PresenterPersonID.[DisplayName] AS [PresenterPerson],
    hier_ParentAgendaItemID.RootID AS [RootParentAgendaItemID],
    hier_ParentAgendaItemID.Depth AS [ParentAgendaItemIDDepth],
    hier_ParentAgendaItemID.Path AS [ParentAgendaItemIDPath],
    hier_ParentAgendaItemID.IsLeaf AS [ParentAgendaItemIDIsLeaf],
    hier_ParentAgendaItemID.ChildCount AS [ParentAgendaItemIDChildCount]
FROM
    [${flyway:defaultSchema}].[AgendaItem] AS a
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Meeting] AS mjBizAppsCommitteesMeeting_MeetingID
  ON
    [a].[MeetingID] = mjBizAppsCommitteesMeeting_MeetingID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[AgendaItem] AS mjBizAppsCommitteesAgendaItem_ParentAgendaItemID
  ON
    [a].[ParentAgendaItemID] = mjBizAppsCommitteesAgendaItem_ParentAgendaItemID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsCommon].[Person] AS mjBizAppsCommonPerson_PresenterPersonID
  ON
    [a].[PresenterPersonID] = mjBizAppsCommonPerson_PresenterPersonID.[ID]
OUTER APPLY
    [${flyway:defaultSchema}].[fnAgendaItemParentAgendaItemID_GetHierarchyMeta]([a].[ID], [a].[ParentAgendaItemID]) AS hier_ParentAgendaItemID
GO
REVOKE SELECT ON [${flyway:defaultSchema}].[vwAgendaItems] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwAgendaItems] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwAgendaItems] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwAgendaItems] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Agenda Items */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Agenda Items
-- Item: Permissions for vwAgendaItems
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

REVOKE SELECT ON [${flyway:defaultSchema}].[vwAgendaItems] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwAgendaItems] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwAgendaItems] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwAgendaItems] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateAgendaItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateAgendaItem];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateAgendaItem]
    @ID uniqueidentifier = NULL,
    @MeetingID uniqueidentifier,
    @ParentAgendaItemID_Clear bit = 0,
    @ParentAgendaItemID uniqueidentifier = NULL,
    @Sequence int,
    @Name nvarchar(255),
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
        INSERT INTO [${flyway:defaultSchema}].[AgendaItem]
            (
                [ID],
                [MeetingID],
                [ParentAgendaItemID],
                [Sequence],
                [Name],
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
                @Name,
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
        INSERT INTO [${flyway:defaultSchema}].[AgendaItem]
            (
                [MeetingID],
                [ParentAgendaItemID],
                [Sequence],
                [Name],
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
                @Name,
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
    SELECT * FROM [${flyway:defaultSchema}].[vwAgendaItems] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateAgendaItem] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateAgendaItem] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateAgendaItem] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Agenda Items */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateAgendaItem] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateAgendaItem] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateAgendaItem] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateAgendaItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateAgendaItem];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateAgendaItem]
    @ID uniqueidentifier,
    @MeetingID uniqueidentifier = NULL,
    @ParentAgendaItemID_Clear bit = 0,
    @ParentAgendaItemID uniqueidentifier = NULL,
    @Sequence int = NULL,
    @Name nvarchar(255) = NULL,
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
        [${flyway:defaultSchema}].[AgendaItem]
    SET
        [MeetingID] = ISNULL(@MeetingID, [MeetingID]),
        [ParentAgendaItemID] = CASE WHEN @ParentAgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@ParentAgendaItemID, [ParentAgendaItemID]) END,
        [Sequence] = ISNULL(@Sequence, [Sequence]),
        [Name] = ISNULL(@Name, [Name]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [PresenterPersonID] = CASE WHEN @PresenterPersonID_Clear = 1 THEN NULL ELSE ISNULL(@PresenterPersonID, [PresenterPersonID]) END,
        [DurationMinutes] = CASE WHEN @DurationMinutes_Clear = 1 THEN NULL ELSE ISNULL(@DurationMinutes, [DurationMinutes]) END,
        [ItemType] = ISNULL(@ItemType, [ItemType]),
        [RelatedDocumentURL] = CASE WHEN @RelatedDocumentURL_Clear = 1 THEN NULL ELSE ISNULL(@RelatedDocumentURL, [RelatedDocumentURL]) END,
        [Status] = ISNULL(@Status, [Status]),
        [Notes] = CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, [Notes]) END,
        [__mj_UpdatedAt] = GETUTCDATE()
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwAgendaItems] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwAgendaItems]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateAgendaItem] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateAgendaItem] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateAgendaItem] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the AgendaItem table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateAgendaItem]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateAgendaItem];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateAgendaItem
ON [${flyway:defaultSchema}].[AgendaItem]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE([__mj_UpdatedAt])
    BEGIN
        UPDATE
            [${flyway:defaultSchema}].[AgendaItem]
        SET
            __mj_UpdatedAt = GETUTCDATE()
        FROM
            [${flyway:defaultSchema}].[AgendaItem] AS _organicTable
        INNER JOIN
            INSERTED AS I ON
            _organicTable.[ID] = I.[ID];
    END
END;
GO

/* spUpdate Permissions for Committees: Agenda Items */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateAgendaItem] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateAgendaItem] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateAgendaItem] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteAgendaItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteAgendaItem];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteAgendaItem]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[AgendaItem]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteAgendaItem] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteAgendaItem] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteAgendaItem] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Agenda Items */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteAgendaItem] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteAgendaItem] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteAgendaItem] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateArtifactType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateArtifactType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateArtifactType]
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
        [${flyway:defaultSchema}].[ArtifactType]
    SET
        [Name] = ISNULL(@Name, [Name]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [ExtendedEntityID] = CASE WHEN @ExtendedEntityID_Clear = 1 THEN NULL ELSE ISNULL(@ExtendedEntityID, [ExtendedEntityID]) END,
        [IconClass] = CASE WHEN @IconClass_Clear = 1 THEN NULL ELSE ISNULL(@IconClass, [IconClass]) END,
        [__mj_UpdatedAt] = GETUTCDATE()
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwArtifactTypes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwArtifactTypes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifactType] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifactType] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifactType] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the ArtifactType table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateArtifactType]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateArtifactType];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateArtifactType
ON [${flyway:defaultSchema}].[ArtifactType]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE([__mj_UpdatedAt])
    BEGIN
        UPDATE
            [${flyway:defaultSchema}].[ArtifactType]
        SET
            __mj_UpdatedAt = GETUTCDATE()
        FROM
            [${flyway:defaultSchema}].[ArtifactType] AS _organicTable
        INNER JOIN
            INSERTED AS I ON
            _organicTable.[ID] = I.[ID];
    END
END;
GO

/* spUpdate Permissions for Committees: Artifact Types */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifactType] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifactType] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifactType] TO [cdp_Developer], [cdp_Integration];

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
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_CommitteeID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'CommitteeID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_CommitteeID ON [${flyway:defaultSchema}].[Artifact] ([CommitteeID]);

-- Index for foreign key MeetingID in table Artifact
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_MeetingID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'MeetingID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_MeetingID ON [${flyway:defaultSchema}].[Artifact] ([MeetingID]);

-- Index for foreign key AgendaItemID in table Artifact
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_AgendaItemID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'AgendaItemID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_AgendaItemID ON [${flyway:defaultSchema}].[Artifact] ([AgendaItemID]);

-- Index for foreign key TaskID in table Artifact
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_TaskID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'TaskID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_TaskID ON [${flyway:defaultSchema}].[Artifact] ([TaskID]);

-- Index for foreign key ArtifactTypeID in table Artifact
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_ArtifactTypeID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'ArtifactTypeID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_ArtifactTypeID ON [${flyway:defaultSchema}].[Artifact] ([ArtifactTypeID]);

-- Index for foreign key UploadedByPersonID in table Artifact
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_UploadedByPersonID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'UploadedByPersonID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_UploadedByPersonID ON [${flyway:defaultSchema}].[Artifact] ([UploadedByPersonID]);

-- Index for foreign key MJArtifactID in table Artifact
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Artifact_MJArtifactID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Artifact]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'MJArtifactID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Artifact_MJArtifactID ON [${flyway:defaultSchema}].[Artifact] ([MJArtifactID]);

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
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Artifact
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwArtifacts]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwArtifacts];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwArtifacts]
AS
SELECT
    a.*,
    mjBizAppsCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjBizAppsCommitteesMeeting_MeetingID.[Name] AS [Meeting],
    mjBizAppsCommitteesAgendaItem_AgendaItemID.[Name] AS [AgendaItem],
    mjBizAppsTasksTask_TaskID.[Name] AS [Task],
    mjBizAppsCommitteesArtifactType_ArtifactTypeID.[Name] AS [ArtifactType],
    mjBizAppsCommonPerson_UploadedByPersonID.[DisplayName] AS [UploadedByPerson],
    MJArtifact_MJArtifactID.[Name] AS [MJArtifact]
FROM
    [${flyway:defaultSchema}].[Artifact] AS a
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Committee] AS mjBizAppsCommitteesCommittee_CommitteeID
  ON
    [a].[CommitteeID] = mjBizAppsCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Meeting] AS mjBizAppsCommitteesMeeting_MeetingID
  ON
    [a].[MeetingID] = mjBizAppsCommitteesMeeting_MeetingID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[AgendaItem] AS mjBizAppsCommitteesAgendaItem_AgendaItemID
  ON
    [a].[AgendaItemID] = mjBizAppsCommitteesAgendaItem_AgendaItemID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsTasks].[Task] AS mjBizAppsTasksTask_TaskID
  ON
    [a].[TaskID] = mjBizAppsTasksTask_TaskID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[ArtifactType] AS mjBizAppsCommitteesArtifactType_ArtifactTypeID
  ON
    [a].[ArtifactTypeID] = mjBizAppsCommitteesArtifactType_ArtifactTypeID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsCommon].[Person] AS mjBizAppsCommonPerson_UploadedByPersonID
  ON
    [a].[UploadedByPersonID] = mjBizAppsCommonPerson_UploadedByPersonID.[ID]
LEFT OUTER JOIN
    [${mjSchema}].[Artifact] AS MJArtifact_MJArtifactID
  ON
    [a].[MJArtifactID] = MJArtifact_MJArtifactID.[ID]
GO
REVOKE SELECT ON [${flyway:defaultSchema}].[vwArtifacts] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwArtifacts] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwArtifacts] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwArtifacts] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Artifacts */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Artifacts
-- Item: Permissions for vwArtifacts
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

REVOKE SELECT ON [${flyway:defaultSchema}].[vwArtifacts] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwArtifacts] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwArtifacts] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwArtifacts] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateArtifact]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateArtifact];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateArtifact]
    @ID uniqueidentifier = NULL,
    @CommitteeID_Clear bit = 0,
    @CommitteeID uniqueidentifier = NULL,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @TaskID_Clear bit = 0,
    @TaskID uniqueidentifier = NULL,
    @Name nvarchar(255),
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
    @UploadedByPersonID uniqueidentifier = NULL,
    @MJArtifactID_Clear bit = 0,
    @MJArtifactID uniqueidentifier = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[Artifact]
            (
                [ID],
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [TaskID],
                [Name],
                [Description],
                [ArtifactTypeID],
                [Provider],
                [ExternalID],
                [URL],
                [MimeType],
                [FileSize],
                [UploadedByPersonID],
                [MJArtifactID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                CASE WHEN @CommitteeID_Clear = 1 THEN NULL ELSE ISNULL(@CommitteeID, NULL) END,
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                CASE WHEN @TaskID_Clear = 1 THEN NULL ELSE ISNULL(@TaskID, NULL) END,
                @Name,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @ArtifactTypeID,
                @Provider,
                CASE WHEN @ExternalID_Clear = 1 THEN NULL ELSE ISNULL(@ExternalID, NULL) END,
                @URL,
                CASE WHEN @MimeType_Clear = 1 THEN NULL ELSE ISNULL(@MimeType, NULL) END,
                CASE WHEN @FileSize_Clear = 1 THEN NULL ELSE ISNULL(@FileSize, NULL) END,
                CASE WHEN @UploadedByPersonID_Clear = 1 THEN NULL ELSE ISNULL(@UploadedByPersonID, NULL) END,
                CASE WHEN @MJArtifactID_Clear = 1 THEN NULL ELSE ISNULL(@MJArtifactID, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[Artifact]
            (
                [CommitteeID],
                [MeetingID],
                [AgendaItemID],
                [TaskID],
                [Name],
                [Description],
                [ArtifactTypeID],
                [Provider],
                [ExternalID],
                [URL],
                [MimeType],
                [FileSize],
                [UploadedByPersonID],
                [MJArtifactID]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                CASE WHEN @CommitteeID_Clear = 1 THEN NULL ELSE ISNULL(@CommitteeID, NULL) END,
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                CASE WHEN @TaskID_Clear = 1 THEN NULL ELSE ISNULL(@TaskID, NULL) END,
                @Name,
                CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, NULL) END,
                @ArtifactTypeID,
                @Provider,
                CASE WHEN @ExternalID_Clear = 1 THEN NULL ELSE ISNULL(@ExternalID, NULL) END,
                @URL,
                CASE WHEN @MimeType_Clear = 1 THEN NULL ELSE ISNULL(@MimeType, NULL) END,
                CASE WHEN @FileSize_Clear = 1 THEN NULL ELSE ISNULL(@FileSize, NULL) END,
                CASE WHEN @UploadedByPersonID_Clear = 1 THEN NULL ELSE ISNULL(@UploadedByPersonID, NULL) END,
                CASE WHEN @MJArtifactID_Clear = 1 THEN NULL ELSE ISNULL(@MJArtifactID, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwArtifacts] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateArtifact] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateArtifact] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateArtifact] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Artifacts */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateArtifact] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateArtifact] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateArtifact] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateArtifact]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateArtifact];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateArtifact]
    @ID uniqueidentifier,
    @CommitteeID_Clear bit = 0,
    @CommitteeID uniqueidentifier = NULL,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @TaskID_Clear bit = 0,
    @TaskID uniqueidentifier = NULL,
    @Name nvarchar(255) = NULL,
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
    @UploadedByPersonID uniqueidentifier = NULL,
    @MJArtifactID_Clear bit = 0,
    @MJArtifactID uniqueidentifier = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Artifact]
    SET
        [CommitteeID] = CASE WHEN @CommitteeID_Clear = 1 THEN NULL ELSE ISNULL(@CommitteeID, [CommitteeID]) END,
        [MeetingID] = CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, [MeetingID]) END,
        [AgendaItemID] = CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, [AgendaItemID]) END,
        [TaskID] = CASE WHEN @TaskID_Clear = 1 THEN NULL ELSE ISNULL(@TaskID, [TaskID]) END,
        [Name] = ISNULL(@Name, [Name]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [ArtifactTypeID] = ISNULL(@ArtifactTypeID, [ArtifactTypeID]),
        [Provider] = ISNULL(@Provider, [Provider]),
        [ExternalID] = CASE WHEN @ExternalID_Clear = 1 THEN NULL ELSE ISNULL(@ExternalID, [ExternalID]) END,
        [URL] = ISNULL(@URL, [URL]),
        [MimeType] = CASE WHEN @MimeType_Clear = 1 THEN NULL ELSE ISNULL(@MimeType, [MimeType]) END,
        [FileSize] = CASE WHEN @FileSize_Clear = 1 THEN NULL ELSE ISNULL(@FileSize, [FileSize]) END,
        [UploadedByPersonID] = CASE WHEN @UploadedByPersonID_Clear = 1 THEN NULL ELSE ISNULL(@UploadedByPersonID, [UploadedByPersonID]) END,
        [MJArtifactID] = CASE WHEN @MJArtifactID_Clear = 1 THEN NULL ELSE ISNULL(@MJArtifactID, [MJArtifactID]) END,
        [__mj_UpdatedAt] = GETUTCDATE()
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwArtifacts] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwArtifacts]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifact] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifact] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifact] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Artifact table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateArtifact]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateArtifact];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateArtifact
ON [${flyway:defaultSchema}].[Artifact]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE([__mj_UpdatedAt])
    BEGIN
        UPDATE
            [${flyway:defaultSchema}].[Artifact]
        SET
            __mj_UpdatedAt = GETUTCDATE()
        FROM
            [${flyway:defaultSchema}].[Artifact] AS _organicTable
        INNER JOIN
            INSERTED AS I ON
            _organicTable.[ID] = I.[ID];
    END
END;
GO

/* spUpdate Permissions for Committees: Artifacts */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifact] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifact] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateArtifact] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteArtifact]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteArtifact];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteArtifact]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Artifact]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteArtifact] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteArtifact] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteArtifact] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Artifacts */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteArtifact] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteArtifact] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteArtifact] TO [cdp_Developer], [cdp_Integration];

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
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Attendance_MeetingID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Attendance]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Attendance]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'MeetingID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Attendance_MeetingID ON [${flyway:defaultSchema}].[Attendance] ([MeetingID]);

-- Index for foreign key PersonID in table Attendance
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Attendance_PersonID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Attendance]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Attendance]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'PersonID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Attendance_PersonID ON [${flyway:defaultSchema}].[Attendance] ([PersonID]);

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
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Attendance
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwAttendances]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwAttendances];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwAttendances]
AS
SELECT
    a.*,
    mjBizAppsCommitteesMeeting_MeetingID.[Name] AS [Meeting],
    mjBizAppsCommonPerson_PersonID.[DisplayName] AS [Person]
FROM
    [${flyway:defaultSchema}].[Attendance] AS a
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Meeting] AS mjBizAppsCommitteesMeeting_MeetingID
  ON
    [a].[MeetingID] = mjBizAppsCommitteesMeeting_MeetingID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsCommon].[Person] AS mjBizAppsCommonPerson_PersonID
  ON
    [a].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
GO
REVOKE SELECT ON [${flyway:defaultSchema}].[vwAttendances] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwAttendances] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwAttendances] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwAttendances] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Attendances */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Attendances
-- Item: Permissions for vwAttendances
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

REVOKE SELECT ON [${flyway:defaultSchema}].[vwAttendances] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwAttendances] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwAttendances] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwAttendances] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateAttendance]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateAttendance];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateAttendance]
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
        INSERT INTO [${flyway:defaultSchema}].[Attendance]
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
        INSERT INTO [${flyway:defaultSchema}].[Attendance]
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
    SELECT * FROM [${flyway:defaultSchema}].[vwAttendances] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateAttendance] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateAttendance] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateAttendance] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Attendances */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateAttendance] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateAttendance] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateAttendance] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateAttendance]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateAttendance];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateAttendance]
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
        [${flyway:defaultSchema}].[Attendance]
    SET
        [MeetingID] = ISNULL(@MeetingID, [MeetingID]),
        [PersonID] = ISNULL(@PersonID, [PersonID]),
        [AttendanceStatus] = ISNULL(@AttendanceStatus, [AttendanceStatus]),
        [JoinedAt] = CASE WHEN @JoinedAt_Clear = 1 THEN NULL ELSE ISNULL(@JoinedAt, [JoinedAt]) END,
        [LeftAt] = CASE WHEN @LeftAt_Clear = 1 THEN NULL ELSE ISNULL(@LeftAt, [LeftAt]) END,
        [Notes] = CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, [Notes]) END,
        [__mj_UpdatedAt] = GETUTCDATE()
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwAttendances] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwAttendances]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateAttendance] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateAttendance] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateAttendance] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Attendance table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateAttendance]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateAttendance];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateAttendance
ON [${flyway:defaultSchema}].[Attendance]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE([__mj_UpdatedAt])
    BEGIN
        UPDATE
            [${flyway:defaultSchema}].[Attendance]
        SET
            __mj_UpdatedAt = GETUTCDATE()
        FROM
            [${flyway:defaultSchema}].[Attendance] AS _organicTable
        INNER JOIN
            INSERTED AS I ON
            _organicTable.[ID] = I.[ID];
    END
END;
GO

/* spUpdate Permissions for Committees: Attendances */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateAttendance] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateAttendance] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateAttendance] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteAttendance]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteAttendance];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteAttendance]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Attendance]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteAttendance] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteAttendance] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteAttendance] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Attendances */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteAttendance] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteAttendance] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteAttendance] TO [cdp_Developer], [cdp_Integration];

/* Index for Foreign Keys for Ballot */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Ballots
-- Item: Index for Foreign Keys
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
-- Index for foreign key CommitteeID in table Ballot
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Ballot_CommitteeID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Ballot]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Ballot]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'CommitteeID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Ballot_CommitteeID ON [${flyway:defaultSchema}].[Ballot] ([CommitteeID]);

-- Index for foreign key MotionID in table Ballot
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Ballot_MotionID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Ballot]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Ballot]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'MotionID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Ballot_MotionID ON [${flyway:defaultSchema}].[Ballot] ([MotionID]);

-- Index for foreign key CreatedByMembershipID in table Ballot
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Ballot_CreatedByMembershipID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Ballot]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Ballot]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'CreatedByMembershipID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Ballot_CreatedByMembershipID ON [${flyway:defaultSchema}].[Ballot] ([CreatedByMembershipID]);

/* Base View SQL for Committees: Ballots */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Ballots
-- Item: vwBallots
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Ballots
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Ballot
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwBallots]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwBallots];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwBallots]
AS
SELECT
    b.*,
    mjBizAppsCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjBizAppsCommitteesMotion_MotionID.[Name] AS [Motion]
FROM
    [${flyway:defaultSchema}].[Ballot] AS b
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Committee] AS mjBizAppsCommitteesCommittee_CommitteeID
  ON
    [b].[CommitteeID] = mjBizAppsCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Motion] AS mjBizAppsCommitteesMotion_MotionID
  ON
    [b].[MotionID] = mjBizAppsCommitteesMotion_MotionID.[ID]
GO
REVOKE SELECT ON [${flyway:defaultSchema}].[vwBallots] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwBallots] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwBallots] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwBallots] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Ballots */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Ballots
-- Item: Permissions for vwBallots
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

REVOKE SELECT ON [${flyway:defaultSchema}].[vwBallots] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwBallots] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwBallots] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwBallots] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* spCreate SQL for Committees: Ballots */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Ballots
-- Item: spCreateBallot
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- CREATE PROCEDURE FOR Ballot
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateBallot]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateBallot];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateBallot]
    @ID uniqueidentifier = NULL,
    @CommitteeID uniqueidentifier,
    @MotionID uniqueidentifier,
    @OpensAt datetimeoffset,
    @ClosesAt datetimeoffset,
    @ClosedAt_Clear bit = 0,
    @ClosedAt datetimeoffset = NULL,
    @ThresholdType nvarchar(20) = NULL,
    @IsSealed bit = NULL,
    @Status nvarchar(20) = NULL,
    @CreatedByMembershipID_Clear bit = 0,
    @CreatedByMembershipID uniqueidentifier = NULL,
    @ResultNotes_Clear bit = 0,
    @ResultNotes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[Ballot]
            (
                [ID],
                [CommitteeID],
                [MotionID],
                [OpensAt],
                [ClosesAt],
                [ClosedAt],
                [ThresholdType],
                [IsSealed],
                [Status],
                [CreatedByMembershipID],
                [ResultNotes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @CommitteeID,
                @MotionID,
                @OpensAt,
                @ClosesAt,
                CASE WHEN @ClosedAt_Clear = 1 THEN NULL ELSE ISNULL(@ClosedAt, NULL) END,
                ISNULL(@ThresholdType, 'SimpleMajority'),
                ISNULL(@IsSealed, 1),
                ISNULL(@Status, 'Open'),
                CASE WHEN @CreatedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@CreatedByMembershipID, NULL) END,
                CASE WHEN @ResultNotes_Clear = 1 THEN NULL ELSE ISNULL(@ResultNotes, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[Ballot]
            (
                [CommitteeID],
                [MotionID],
                [OpensAt],
                [ClosesAt],
                [ClosedAt],
                [ThresholdType],
                [IsSealed],
                [Status],
                [CreatedByMembershipID],
                [ResultNotes]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @CommitteeID,
                @MotionID,
                @OpensAt,
                @ClosesAt,
                CASE WHEN @ClosedAt_Clear = 1 THEN NULL ELSE ISNULL(@ClosedAt, NULL) END,
                ISNULL(@ThresholdType, 'SimpleMajority'),
                ISNULL(@IsSealed, 1),
                ISNULL(@Status, 'Open'),
                CASE WHEN @CreatedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@CreatedByMembershipID, NULL) END,
                CASE WHEN @ResultNotes_Clear = 1 THEN NULL ELSE ISNULL(@ResultNotes, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwBallots] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateBallot] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateBallot] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateBallot] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Ballots */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateBallot] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateBallot] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateBallot] TO [cdp_Developer], [cdp_Integration];

/* spUpdate SQL for Committees: Ballots */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Ballots
-- Item: spUpdateBallot
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- UPDATE PROCEDURE FOR Ballot
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateBallot]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateBallot];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateBallot]
    @ID uniqueidentifier,
    @CommitteeID uniqueidentifier = NULL,
    @MotionID uniqueidentifier = NULL,
    @OpensAt datetimeoffset = NULL,
    @ClosesAt datetimeoffset = NULL,
    @ClosedAt_Clear bit = 0,
    @ClosedAt datetimeoffset = NULL,
    @ThresholdType nvarchar(20) = NULL,
    @IsSealed bit = NULL,
    @Status nvarchar(20) = NULL,
    @CreatedByMembershipID_Clear bit = 0,
    @CreatedByMembershipID uniqueidentifier = NULL,
    @ResultNotes_Clear bit = 0,
    @ResultNotes nvarchar(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Ballot]
    SET
        [CommitteeID] = ISNULL(@CommitteeID, [CommitteeID]),
        [MotionID] = ISNULL(@MotionID, [MotionID]),
        [OpensAt] = ISNULL(@OpensAt, [OpensAt]),
        [ClosesAt] = ISNULL(@ClosesAt, [ClosesAt]),
        [ClosedAt] = CASE WHEN @ClosedAt_Clear = 1 THEN NULL ELSE ISNULL(@ClosedAt, [ClosedAt]) END,
        [ThresholdType] = ISNULL(@ThresholdType, [ThresholdType]),
        [IsSealed] = ISNULL(@IsSealed, [IsSealed]),
        [Status] = ISNULL(@Status, [Status]),
        [CreatedByMembershipID] = CASE WHEN @CreatedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@CreatedByMembershipID, [CreatedByMembershipID]) END,
        [ResultNotes] = CASE WHEN @ResultNotes_Clear = 1 THEN NULL ELSE ISNULL(@ResultNotes, [ResultNotes]) END,
        [__mj_UpdatedAt] = GETUTCDATE()
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwBallots] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwBallots]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateBallot] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateBallot] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateBallot] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Ballot table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateBallot]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateBallot];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateBallot
ON [${flyway:defaultSchema}].[Ballot]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE([__mj_UpdatedAt])
    BEGIN
        UPDATE
            [${flyway:defaultSchema}].[Ballot]
        SET
            __mj_UpdatedAt = GETUTCDATE()
        FROM
            [${flyway:defaultSchema}].[Ballot] AS _organicTable
        INNER JOIN
            INSERTED AS I ON
            _organicTable.[ID] = I.[ID];
    END
END;
GO

/* spUpdate Permissions for Committees: Ballots */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateBallot] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateBallot] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateBallot] TO [cdp_Developer], [cdp_Integration];

/* spDelete SQL for Committees: Ballots */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Ballots
-- Item: spDeleteBallot
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- DELETE PROCEDURE FOR Ballot
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteBallot]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteBallot];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteBallot]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Ballot]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteBallot] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteBallot] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteBallot] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Ballots */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteBallot] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteBallot] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteBallot] TO [cdp_Developer], [cdp_Integration];

/* Hierarchy Metadata Function SQL for Committees: Comments.ParentCommentID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: fnCommentParentCommentID_GetHierarchyMeta
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- HIERARCHY METADATA FUNCTION FOR: [Comment].[ParentCommentID]
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[fnCommentParentCommentID_GetHierarchyMeta]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}].[fnCommentParentCommentID_GetHierarchyMeta];
GO

CREATE FUNCTION [${flyway:defaultSchema}].[fnCommentParentCommentID_GetHierarchyMeta]
(
    @RecordID uniqueidentifier,
    @ParentID uniqueidentifier
)
RETURNS TABLE
AS
RETURN
(
    WITH CTE_Ancestors AS (
        SELECT
            [ID],
            [ParentCommentID],
            0 AS [Depth],
            CAST('/' + CAST([ID] AS NVARCHAR(36)) + '/' AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[Comment]
        WHERE
            [ID] = @RecordID

        UNION ALL

        SELECT
            p.[ID],
            p.[ParentCommentID],
            c.[Depth] + 1 AS [Depth],
            CAST('/' + CAST(p.[ID] AS NVARCHAR(36)) + c.[Path] AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[Comment] p
        INNER JOIN
            CTE_Ancestors c ON p.[ID] = c.[ParentCommentID]
        WHERE
            c.[Depth] < 100
    )
    SELECT TOP 1
        a.[ID] AS [RootID],
        a.[Depth] AS [Depth],
        a.[Path] AS [Path],
        CAST(CASE WHEN ch.[ChildCount] > 0 THEN 0 ELSE 1 END AS BIT) AS [IsLeaf],
        ch.[ChildCount] AS [ChildCount]
    FROM
        CTE_Ancestors a
    OUTER APPLY (
        SELECT COUNT(1) AS [ChildCount]
        FROM [${flyway:defaultSchema}].[Comment]
        WHERE [ParentCommentID] = @RecordID
    ) ch
    WHERE
        a.[ParentCommentID] IS NULL OR @ParentID IS NULL
    ORDER BY
        a.[Depth] DESC
);
GO

/* Descendants Traversal Function SQL for Committees: Comments.ParentCommentID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: fnCommentParentCommentID_GetDescendants
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- DESCENDANTS FUNCTION FOR: [Comment].[ParentCommentID]
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[fnCommentParentCommentID_GetDescendants]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}].[fnCommentParentCommentID_GetDescendants];
GO

CREATE FUNCTION [${flyway:defaultSchema}].[fnCommentParentCommentID_GetDescendants]
(
    @RootID uniqueidentifier,
    @MaxDepth INT = NULL
)
RETURNS TABLE
AS
RETURN
(
    WITH CTE_Descendants AS (
        SELECT
            [ID],
            [ParentCommentID],
            0 AS [RelativeDepth],
            CAST('/' + CAST([ID] AS NVARCHAR(36)) + '/' AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[Comment]
        WHERE
            [ID] = @RootID

        UNION ALL

        SELECT
            c.[ID],
            c.[ParentCommentID],
            p.[RelativeDepth] + 1 AS [RelativeDepth],
            CAST(p.[Path] + CAST(c.[ID] AS NVARCHAR(36)) + '/' AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[Comment] c
        INNER JOIN
            CTE_Descendants p ON c.[ParentCommentID] = p.[ID]
        WHERE
            (@MaxDepth IS NULL OR p.[RelativeDepth] < @MaxDepth)
            AND p.[RelativeDepth] < 100
    )
    SELECT
        d.[ID] AS [ID],
        d.[RelativeDepth] AS [Depth],
        d.[Path],
        CAST(CASE WHEN EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[Comment] WHERE [ParentCommentID] = d.[ID]) THEN 0 ELSE 1 END AS BIT) AS [IsLeaf],
        (SELECT COUNT(1) FROM [${flyway:defaultSchema}].[Comment] WHERE [ParentCommentID] = d.[ID]) AS [ChildCount]
    FROM
        CTE_Descendants d
);
GO

/* Ancestors Traversal Function SQL for Committees: Comments.ParentCommentID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: fnCommentParentCommentID_GetAncestors
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- ANCESTORS FUNCTION FOR: [Comment].[ParentCommentID]
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[fnCommentParentCommentID_GetAncestors]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}].[fnCommentParentCommentID_GetAncestors];
GO

CREATE FUNCTION [${flyway:defaultSchema}].[fnCommentParentCommentID_GetAncestors]
(
    @RecordID uniqueidentifier
)
RETURNS TABLE
AS
RETURN
(
    WITH CTE_Ancestors AS (
        SELECT
            [ID],
            [ParentCommentID],
            0 AS [LevelUp],
            CAST('/' + CAST([ID] AS NVARCHAR(36)) + '/' AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[Comment]
        WHERE
            [ID] = @RecordID

        UNION ALL

        SELECT
            p.[ID],
            p.[ParentCommentID],
            c.[LevelUp] + 1 AS [LevelUp],
            CAST('/' + CAST(p.[ID] AS NVARCHAR(36)) + c.[Path] AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[Comment] p
        INNER JOIN
            CTE_Ancestors c ON p.[ID] = c.[ParentCommentID]
        WHERE
            c.[LevelUp] < 100
    )
    SELECT
        a.[ID] AS [ID],
        a.[LevelUp],
        a.[Path]
    FROM
        CTE_Ancestors a
);
GO

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
IF OBJECT_ID('[${flyway:defaultSchema}].[fnCommentParentCommentID_GetRootID]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}].[fnCommentParentCommentID_GetRootID];
GO

CREATE FUNCTION [${flyway:defaultSchema}].[fnCommentParentCommentID_GetRootID]
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
            [${flyway:defaultSchema}].[Comment]
        WHERE
            [ID] = COALESCE(@ParentID, @RecordID)

        UNION ALL

        SELECT
            c.[ID],
            c.[ParentCommentID],
            c.[ID] AS [RootParentID],
            p.[Depth] + 1 AS [Depth]
        FROM
            [${flyway:defaultSchema}].[Comment] c
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
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Comment
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwComments]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwComments];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwComments]
AS
SELECT
    c.*,
    mjBizAppsCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjBizAppsCommitteesMeeting_MeetingID.[Name] AS [Meeting],
    mjBizAppsCommitteesAgendaItem_AgendaItemID.[Name] AS [AgendaItem],
    mjBizAppsTasksTask_TaskID.[Name] AS [Task],
    mjBizAppsCommitteesArtifact_ArtifactID.[Name] AS [Artifact],
    mjBizAppsCommonPerson_PersonID.[DisplayName] AS [Person],
    hier_ParentCommentID.RootID AS [RootParentCommentID],
    hier_ParentCommentID.Depth AS [ParentCommentIDDepth],
    hier_ParentCommentID.Path AS [ParentCommentIDPath],
    hier_ParentCommentID.IsLeaf AS [ParentCommentIDIsLeaf],
    hier_ParentCommentID.ChildCount AS [ParentCommentIDChildCount]
FROM
    [${flyway:defaultSchema}].[Comment] AS c
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Committee] AS mjBizAppsCommitteesCommittee_CommitteeID
  ON
    [c].[CommitteeID] = mjBizAppsCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Meeting] AS mjBizAppsCommitteesMeeting_MeetingID
  ON
    [c].[MeetingID] = mjBizAppsCommitteesMeeting_MeetingID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[AgendaItem] AS mjBizAppsCommitteesAgendaItem_AgendaItemID
  ON
    [c].[AgendaItemID] = mjBizAppsCommitteesAgendaItem_AgendaItemID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsTasks].[Task] AS mjBizAppsTasksTask_TaskID
  ON
    [c].[TaskID] = mjBizAppsTasksTask_TaskID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Artifact] AS mjBizAppsCommitteesArtifact_ArtifactID
  ON
    [c].[ArtifactID] = mjBizAppsCommitteesArtifact_ArtifactID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsCommon].[Person] AS mjBizAppsCommonPerson_PersonID
  ON
    [c].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
OUTER APPLY
    [${flyway:defaultSchema}].[fnCommentParentCommentID_GetHierarchyMeta]([c].[ID], [c].[ParentCommentID]) AS hier_ParentCommentID
GO
REVOKE SELECT ON [${flyway:defaultSchema}].[vwComments] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwComments] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwComments] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwComments] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Comments */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Comments
-- Item: Permissions for vwComments
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

REVOKE SELECT ON [${flyway:defaultSchema}].[vwComments] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwComments] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwComments] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwComments] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateComment]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateComment];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateComment]
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
        INSERT INTO [${flyway:defaultSchema}].[Comment]
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
        INSERT INTO [${flyway:defaultSchema}].[Comment]
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
    SELECT * FROM [${flyway:defaultSchema}].[vwComments] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateComment] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateComment] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateComment] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Comments */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateComment] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateComment] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateComment] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateComment]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateComment];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateComment]
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
        [${flyway:defaultSchema}].[Comment]
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
        [IsResolved] = ISNULL(@IsResolved, [IsResolved]),
        [__mj_UpdatedAt] = GETUTCDATE()
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwComments] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwComments]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateComment] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateComment] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateComment] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Comment table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateComment]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateComment];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateComment
ON [${flyway:defaultSchema}].[Comment]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE([__mj_UpdatedAt])
    BEGIN
        UPDATE
            [${flyway:defaultSchema}].[Comment]
        SET
            __mj_UpdatedAt = GETUTCDATE()
        FROM
            [${flyway:defaultSchema}].[Comment] AS _organicTable
        INNER JOIN
            INSERTED AS I ON
            _organicTable.[ID] = I.[ID];
    END
END;
GO

/* spUpdate Permissions for Committees: Comments */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateComment] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateComment] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateComment] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteComment]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteComment];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteComment]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Comment]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteComment] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteComment] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteComment] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Comments */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteComment] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteComment] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteComment] TO [cdp_Developer], [cdp_Integration];

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
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Committee_TypeID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Committee]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Committee]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'TypeID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Committee_TypeID ON [${flyway:defaultSchema}].[Committee] ([TypeID]);

-- Index for foreign key ParentCommitteeID in table Committee
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Committee_ParentCommitteeID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Committee]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Committee]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'ParentCommitteeID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Committee_ParentCommitteeID ON [${flyway:defaultSchema}].[Committee] ([ParentCommitteeID]);

-- Index for foreign key OrganizationID in table Committee
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Committee_OrganizationID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Committee]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Committee]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'OrganizationID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Committee_OrganizationID ON [${flyway:defaultSchema}].[Committee] ([OrganizationID]);

/* Hierarchy Metadata Function SQL for Committees: Committees.ParentCommitteeID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Committees
-- Item: fnCommitteeParentCommitteeID_GetHierarchyMeta
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- HIERARCHY METADATA FUNCTION FOR: [Committee].[ParentCommitteeID]
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[fnCommitteeParentCommitteeID_GetHierarchyMeta]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}].[fnCommitteeParentCommitteeID_GetHierarchyMeta];
GO

CREATE FUNCTION [${flyway:defaultSchema}].[fnCommitteeParentCommitteeID_GetHierarchyMeta]
(
    @RecordID uniqueidentifier,
    @ParentID uniqueidentifier
)
RETURNS TABLE
AS
RETURN
(
    WITH CTE_Ancestors AS (
        SELECT
            [ID],
            [ParentCommitteeID],
            0 AS [Depth],
            CAST('/' + CAST([ID] AS NVARCHAR(36)) + '/' AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[Committee]
        WHERE
            [ID] = @RecordID

        UNION ALL

        SELECT
            p.[ID],
            p.[ParentCommitteeID],
            c.[Depth] + 1 AS [Depth],
            CAST('/' + CAST(p.[ID] AS NVARCHAR(36)) + c.[Path] AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[Committee] p
        INNER JOIN
            CTE_Ancestors c ON p.[ID] = c.[ParentCommitteeID]
        WHERE
            c.[Depth] < 100
    )
    SELECT TOP 1
        a.[ID] AS [RootID],
        a.[Depth] AS [Depth],
        a.[Path] AS [Path],
        CAST(CASE WHEN ch.[ChildCount] > 0 THEN 0 ELSE 1 END AS BIT) AS [IsLeaf],
        ch.[ChildCount] AS [ChildCount]
    FROM
        CTE_Ancestors a
    OUTER APPLY (
        SELECT COUNT(1) AS [ChildCount]
        FROM [${flyway:defaultSchema}].[Committee]
        WHERE [ParentCommitteeID] = @RecordID
    ) ch
    WHERE
        a.[ParentCommitteeID] IS NULL OR @ParentID IS NULL
    ORDER BY
        a.[Depth] DESC
);
GO

/* Descendants Traversal Function SQL for Committees: Committees.ParentCommitteeID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Committees
-- Item: fnCommitteeParentCommitteeID_GetDescendants
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- DESCENDANTS FUNCTION FOR: [Committee].[ParentCommitteeID]
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[fnCommitteeParentCommitteeID_GetDescendants]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}].[fnCommitteeParentCommitteeID_GetDescendants];
GO

CREATE FUNCTION [${flyway:defaultSchema}].[fnCommitteeParentCommitteeID_GetDescendants]
(
    @RootID uniqueidentifier,
    @MaxDepth INT = NULL
)
RETURNS TABLE
AS
RETURN
(
    WITH CTE_Descendants AS (
        SELECT
            [ID],
            [ParentCommitteeID],
            0 AS [RelativeDepth],
            CAST('/' + CAST([ID] AS NVARCHAR(36)) + '/' AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[Committee]
        WHERE
            [ID] = @RootID

        UNION ALL

        SELECT
            c.[ID],
            c.[ParentCommitteeID],
            p.[RelativeDepth] + 1 AS [RelativeDepth],
            CAST(p.[Path] + CAST(c.[ID] AS NVARCHAR(36)) + '/' AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[Committee] c
        INNER JOIN
            CTE_Descendants p ON c.[ParentCommitteeID] = p.[ID]
        WHERE
            (@MaxDepth IS NULL OR p.[RelativeDepth] < @MaxDepth)
            AND p.[RelativeDepth] < 100
    )
    SELECT
        d.[ID] AS [ID],
        d.[RelativeDepth] AS [Depth],
        d.[Path],
        CAST(CASE WHEN EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[Committee] WHERE [ParentCommitteeID] = d.[ID]) THEN 0 ELSE 1 END AS BIT) AS [IsLeaf],
        (SELECT COUNT(1) FROM [${flyway:defaultSchema}].[Committee] WHERE [ParentCommitteeID] = d.[ID]) AS [ChildCount]
    FROM
        CTE_Descendants d
);
GO

/* Ancestors Traversal Function SQL for Committees: Committees.ParentCommitteeID */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Committees
-- Item: fnCommitteeParentCommitteeID_GetAncestors
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------
------------------------------------------------------------
----- ANCESTORS FUNCTION FOR: [Committee].[ParentCommitteeID]
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[fnCommitteeParentCommitteeID_GetAncestors]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}].[fnCommitteeParentCommitteeID_GetAncestors];
GO

CREATE FUNCTION [${flyway:defaultSchema}].[fnCommitteeParentCommitteeID_GetAncestors]
(
    @RecordID uniqueidentifier
)
RETURNS TABLE
AS
RETURN
(
    WITH CTE_Ancestors AS (
        SELECT
            [ID],
            [ParentCommitteeID],
            0 AS [LevelUp],
            CAST('/' + CAST([ID] AS NVARCHAR(36)) + '/' AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[Committee]
        WHERE
            [ID] = @RecordID

        UNION ALL

        SELECT
            p.[ID],
            p.[ParentCommitteeID],
            c.[LevelUp] + 1 AS [LevelUp],
            CAST('/' + CAST(p.[ID] AS NVARCHAR(36)) + c.[Path] AS NVARCHAR(MAX)) AS [Path]
        FROM
            [${flyway:defaultSchema}].[Committee] p
        INNER JOIN
            CTE_Ancestors c ON p.[ID] = c.[ParentCommitteeID]
        WHERE
            c.[LevelUp] < 100
    )
    SELECT
        a.[ID] AS [ID],
        a.[LevelUp],
        a.[Path]
    FROM
        CTE_Ancestors a
);
GO

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
IF OBJECT_ID('[${flyway:defaultSchema}].[fnCommitteeParentCommitteeID_GetRootID]', 'IF') IS NOT NULL
    DROP FUNCTION [${flyway:defaultSchema}].[fnCommitteeParentCommitteeID_GetRootID];
GO

CREATE FUNCTION [${flyway:defaultSchema}].[fnCommitteeParentCommitteeID_GetRootID]
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
            [${flyway:defaultSchema}].[Committee]
        WHERE
            [ID] = COALESCE(@ParentID, @RecordID)

        UNION ALL

        SELECT
            c.[ID],
            c.[ParentCommitteeID],
            c.[ID] AS [RootParentID],
            p.[Depth] + 1 AS [Depth]
        FROM
            [${flyway:defaultSchema}].[Committee] c
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
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Committee
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwCommittees]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwCommittees];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwCommittees]
AS
SELECT
    c.*,
    mjBizAppsCommitteesType_TypeID.[Name] AS [Type],
    mjBizAppsCommitteesCommittee_ParentCommitteeID.[Name] AS [ParentCommittee],
    mjBizAppsCommonOrganization_OrganizationID.[Name] AS [Organization],
    hier_ParentCommitteeID.RootID AS [RootParentCommitteeID],
    hier_ParentCommitteeID.Depth AS [ParentCommitteeIDDepth],
    hier_ParentCommitteeID.Path AS [ParentCommitteeIDPath],
    hier_ParentCommitteeID.IsLeaf AS [ParentCommitteeIDIsLeaf],
    hier_ParentCommitteeID.ChildCount AS [ParentCommitteeIDChildCount]
FROM
    [${flyway:defaultSchema}].[Committee] AS c
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Type] AS mjBizAppsCommitteesType_TypeID
  ON
    [c].[TypeID] = mjBizAppsCommitteesType_TypeID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Committee] AS mjBizAppsCommitteesCommittee_ParentCommitteeID
  ON
    [c].[ParentCommitteeID] = mjBizAppsCommitteesCommittee_ParentCommitteeID.[ID]
LEFT OUTER JOIN
    [__mj_BizAppsCommon].[Organization] AS mjBizAppsCommonOrganization_OrganizationID
  ON
    [c].[OrganizationID] = mjBizAppsCommonOrganization_OrganizationID.[ID]
OUTER APPLY
    [${flyway:defaultSchema}].[fnCommitteeParentCommitteeID_GetHierarchyMeta]([c].[ID], [c].[ParentCommitteeID]) AS hier_ParentCommitteeID
GO
REVOKE SELECT ON [${flyway:defaultSchema}].[vwCommittees] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwCommittees] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwCommittees] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwCommittees] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Committees */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Committees
-- Item: Permissions for vwCommittees
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

REVOKE SELECT ON [${flyway:defaultSchema}].[vwCommittees] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwCommittees] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwCommittees] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwCommittees] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateCommittee]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateCommittee];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateCommittee]
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
        INSERT INTO [${flyway:defaultSchema}].[Committee]
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
        INSERT INTO [${flyway:defaultSchema}].[Committee]
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
    SELECT * FROM [${flyway:defaultSchema}].[vwCommittees] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateCommittee] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateCommittee] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateCommittee] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Committees */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateCommittee] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateCommittee] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateCommittee] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateCommittee]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateCommittee];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateCommittee]
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
        [${flyway:defaultSchema}].[Committee]
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
        [DissolutionDate] = CASE WHEN @DissolutionDate_Clear = 1 THEN NULL ELSE ISNULL(@DissolutionDate, [DissolutionDate]) END,
        [__mj_UpdatedAt] = GETUTCDATE()
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwCommittees] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwCommittees]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateCommittee] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateCommittee] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateCommittee] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Committee table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateCommittee]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateCommittee];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateCommittee
ON [${flyway:defaultSchema}].[Committee]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE([__mj_UpdatedAt])
    BEGIN
        UPDATE
            [${flyway:defaultSchema}].[Committee]
        SET
            __mj_UpdatedAt = GETUTCDATE()
        FROM
            [${flyway:defaultSchema}].[Committee] AS _organicTable
        INNER JOIN
            INSERTED AS I ON
            _organicTable.[ID] = I.[ID];
    END
END;
GO

/* spUpdate Permissions for Committees: Committees */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateCommittee] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateCommittee] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateCommittee] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteCommittee]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteCommittee];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteCommittee]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Committee]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteCommittee] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteCommittee] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteCommittee] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Committees */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteCommittee] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteCommittee] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteCommittee] TO [cdp_Developer], [cdp_Integration];

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
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Meeting_CommitteeID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Meeting]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Meeting]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'CommitteeID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Meeting_CommitteeID ON [${flyway:defaultSchema}].[Meeting] ([CommitteeID]);

-- Index for foreign key VideoProviderID in table Meeting
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Meeting_VideoProviderID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Meeting]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Meeting]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'VideoProviderID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Meeting_VideoProviderID ON [${flyway:defaultSchema}].[Meeting] ([VideoProviderID]);

/* Base View SQL for Committees: Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
-- Item: vwMeetingsGenerated
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Meetings
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Meeting
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwMeetingsGenerated]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwMeetingsGenerated];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwMeetingsGenerated]
AS
SELECT
    m.*,
    mjBizAppsCommitteesCommittee_CommitteeID.[Name] AS [Committee],
    mjBizAppsCommitteesVideoProvider_VideoProviderID.[Name] AS [VideoProvider_Virtual]
FROM
    [${flyway:defaultSchema}].[Meeting] AS m
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Committee] AS mjBizAppsCommitteesCommittee_CommitteeID
  ON
    [m].[CommitteeID] = mjBizAppsCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[VideoProvider] AS mjBizAppsCommitteesVideoProvider_VideoProviderID
  ON
    [m].[VideoProviderID] = mjBizAppsCommitteesVideoProvider_VideoProviderID.[ID]
GO
IF OBJECT_ID('[${flyway:defaultSchema}].[vwMeetings]', 'V') IS NOT NULL
BEGIN
    EXEC sp_executesql N'REVOKE SELECT ON [${flyway:defaultSchema}].[vwMeetings] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMeetings] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMeetings] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwMeetings] TO [cdp_UI], [cdp_Developer], [cdp_Integration]';
END;

/* Refresh layered base view for Committees: Meetings after its inner view changed */
EXEC sp_refreshview '${flyway:defaultSchema}.vwMeetingsGenerated';
IF OBJECT_ID('[${flyway:defaultSchema}].[vwMeetings]', 'V') IS NOT NULL
BEGIN
    EXEC sp_executesql N'EXEC sp_refreshview ''${flyway:defaultSchema}.vwMeetings'';';
END

GO

/* Base View Permissions SQL for Committees: Meetings */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Meetings
-- Item: Permissions for vwMeetings
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

IF OBJECT_ID('[${flyway:defaultSchema}].[vwMeetings]', 'V') IS NOT NULL
BEGIN
    EXEC sp_executesql N'REVOKE SELECT ON [${flyway:defaultSchema}].[vwMeetings] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMeetings] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMeetings] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwMeetings] TO [cdp_UI], [cdp_Developer], [cdp_Integration]';
END;

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateMeeting]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateMeeting];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateMeeting]
    @ID uniqueidentifier = NULL,
    @CommitteeID uniqueidentifier,
    @Name nvarchar(255),
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
    @CalendarEventID nvarchar(255) = NULL,
    @PredictedQuorumRiskProbability_Clear bit = 0,
    @PredictedQuorumRiskProbability decimal(5, 4) = NULL,
    @PredictedQuorumRiskBand_Clear bit = 0,
    @PredictedQuorumRiskBand nvarchar(20) = NULL,
    @PredictedQuorumRiskScoredAt_Clear bit = 0,
    @PredictedQuorumRiskScoredAt datetimeoffset = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[Meeting]
            (
                [ID],
                [CommitteeID],
                [Name],
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
                [CalendarEventID],
                [PredictedQuorumRiskProbability],
                [PredictedQuorumRiskBand],
                [PredictedQuorumRiskScoredAt]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @ID,
                @CommitteeID,
                @Name,
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
                CASE WHEN @CalendarEventID_Clear = 1 THEN NULL ELSE ISNULL(@CalendarEventID, NULL) END,
                CASE WHEN @PredictedQuorumRiskProbability_Clear = 1 THEN NULL ELSE ISNULL(@PredictedQuorumRiskProbability, NULL) END,
                CASE WHEN @PredictedQuorumRiskBand_Clear = 1 THEN NULL ELSE ISNULL(@PredictedQuorumRiskBand, NULL) END,
                CASE WHEN @PredictedQuorumRiskScoredAt_Clear = 1 THEN NULL ELSE ISNULL(@PredictedQuorumRiskScoredAt, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[Meeting]
            (
                [CommitteeID],
                [Name],
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
                [CalendarEventID],
                [PredictedQuorumRiskProbability],
                [PredictedQuorumRiskBand],
                [PredictedQuorumRiskScoredAt]
            )
        OUTPUT INSERTED.[ID] INTO @InsertedRow
        VALUES
            (
                @CommitteeID,
                @Name,
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
                CASE WHEN @CalendarEventID_Clear = 1 THEN NULL ELSE ISNULL(@CalendarEventID, NULL) END,
                CASE WHEN @PredictedQuorumRiskProbability_Clear = 1 THEN NULL ELSE ISNULL(@PredictedQuorumRiskProbability, NULL) END,
                CASE WHEN @PredictedQuorumRiskBand_Clear = 1 THEN NULL ELSE ISNULL(@PredictedQuorumRiskBand, NULL) END,
                CASE WHEN @PredictedQuorumRiskScoredAt_Clear = 1 THEN NULL ELSE ISNULL(@PredictedQuorumRiskScoredAt, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwMeetings] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMeeting] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMeeting] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMeeting] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Meetings */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMeeting] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMeeting] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMeeting] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateMeeting]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateMeeting];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateMeeting]
    @ID uniqueidentifier,
    @CommitteeID uniqueidentifier = NULL,
    @Name nvarchar(255) = NULL,
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
    @CalendarEventID nvarchar(255) = NULL,
    @PredictedQuorumRiskProbability_Clear bit = 0,
    @PredictedQuorumRiskProbability decimal(5, 4) = NULL,
    @PredictedQuorumRiskBand_Clear bit = 0,
    @PredictedQuorumRiskBand nvarchar(20) = NULL,
    @PredictedQuorumRiskScoredAt_Clear bit = 0,
    @PredictedQuorumRiskScoredAt datetimeoffset = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Meeting]
    SET
        [CommitteeID] = ISNULL(@CommitteeID, [CommitteeID]),
        [Name] = ISNULL(@Name, [Name]),
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
        [CalendarEventID] = CASE WHEN @CalendarEventID_Clear = 1 THEN NULL ELSE ISNULL(@CalendarEventID, [CalendarEventID]) END,
        [PredictedQuorumRiskProbability] = CASE WHEN @PredictedQuorumRiskProbability_Clear = 1 THEN NULL ELSE ISNULL(@PredictedQuorumRiskProbability, [PredictedQuorumRiskProbability]) END,
        [PredictedQuorumRiskBand] = CASE WHEN @PredictedQuorumRiskBand_Clear = 1 THEN NULL ELSE ISNULL(@PredictedQuorumRiskBand, [PredictedQuorumRiskBand]) END,
        [PredictedQuorumRiskScoredAt] = CASE WHEN @PredictedQuorumRiskScoredAt_Clear = 1 THEN NULL ELSE ISNULL(@PredictedQuorumRiskScoredAt, [PredictedQuorumRiskScoredAt]) END,
        [__mj_UpdatedAt] = GETUTCDATE()
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwMeetings] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwMeetings]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMeeting] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMeeting] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMeeting] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Meeting table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateMeeting]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateMeeting];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateMeeting
ON [${flyway:defaultSchema}].[Meeting]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE([__mj_UpdatedAt])
    BEGIN
        UPDATE
            [${flyway:defaultSchema}].[Meeting]
        SET
            __mj_UpdatedAt = GETUTCDATE()
        FROM
            [${flyway:defaultSchema}].[Meeting] AS _organicTable
        INNER JOIN
            INSERTED AS I ON
            _organicTable.[ID] = I.[ID];
    END
END;
GO

/* spUpdate Permissions for Committees: Meetings */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMeeting] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMeeting] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMeeting] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteMeeting]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteMeeting];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteMeeting]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Meeting]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMeeting] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMeeting] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMeeting] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Meetings */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMeeting] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMeeting] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMeeting] TO [cdp_Developer], [cdp_Integration];

/* SQL text to update entity field related entity name field map for entity field ID 94B85E5A-DE77-4B71-BC0D-0B7123794ED8 */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='94B85E5A-DE77-4B71-BC0D-0B7123794ED8', @RelatedEntityNameFieldMap='MJArtifact';

/* SQL text to update entity field related entity name field map for entity field ID E52AEF7A-C9F8-4CDE-AB50-825E4304893A */
EXEC [${mjSchema}].[spUpdateEntityFieldRelatedEntityNameFieldMap] @EntityFieldID='E52AEF7A-C9F8-4CDE-AB50-825E4304893A', @RelatedEntityNameFieldMap='ApprovedArtifactVersion';

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
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Membership_PersonID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Membership]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Membership]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'PersonID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Membership_PersonID ON [${flyway:defaultSchema}].[Membership] ([PersonID]);

-- Index for foreign key RoleID in table Membership
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Membership_RoleID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Membership]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Membership]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'RoleID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Membership_RoleID ON [${flyway:defaultSchema}].[Membership] ([RoleID]);

-- Index for foreign key TermID in table Membership
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Membership_TermID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Membership]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Membership]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'TermID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Membership_TermID ON [${flyway:defaultSchema}].[Membership] ([TermID]);

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
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Membership
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwMemberships]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwMemberships];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwMemberships]
AS
SELECT
    m.*,
    mjBizAppsCommonPerson_PersonID.[DisplayName] AS [Person],
    mjBizAppsCommitteesRole_RoleID.[Name] AS [Role],
    mjBizAppsCommitteesTerm_TermID.[Name] AS [Term]
FROM
    [${flyway:defaultSchema}].[Membership] AS m
LEFT OUTER JOIN
    [__mj_BizAppsCommon].[Person] AS mjBizAppsCommonPerson_PersonID
  ON
    [m].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Role] AS mjBizAppsCommitteesRole_RoleID
  ON
    [m].[RoleID] = mjBizAppsCommitteesRole_RoleID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Term] AS mjBizAppsCommitteesTerm_TermID
  ON
    [m].[TermID] = mjBizAppsCommitteesTerm_TermID.[ID]
GO
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMemberships] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMemberships] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMemberships] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwMemberships] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Memberships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Memberships
-- Item: Permissions for vwMemberships
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

REVOKE SELECT ON [${flyway:defaultSchema}].[vwMemberships] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMemberships] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMemberships] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwMemberships] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateMembership]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateMembership];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateMembership]
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
    @Notes nvarchar(MAX) = NULL,
    @RenewalIntent_Clear bit = 0,
    @RenewalIntent nvarchar(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[Membership]
            (
                [ID],
                [PersonID],
                [RoleID],
                [TermID],
                [StartDate],
                [EndDate],
                [Status],
                [EndReason],
                [Notes],
                [RenewalIntent]
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
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END,
                CASE WHEN @RenewalIntent_Clear = 1 THEN NULL ELSE ISNULL(@RenewalIntent, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[Membership]
            (
                [PersonID],
                [RoleID],
                [TermID],
                [StartDate],
                [EndDate],
                [Status],
                [EndReason],
                [Notes],
                [RenewalIntent]
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
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END,
                CASE WHEN @RenewalIntent_Clear = 1 THEN NULL ELSE ISNULL(@RenewalIntent, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwMemberships] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMembership] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMembership] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMembership] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Memberships */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMembership] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMembership] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMembership] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateMembership]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateMembership];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateMembership]
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
    @Notes nvarchar(MAX) = NULL,
    @RenewalIntent_Clear bit = 0,
    @RenewalIntent nvarchar(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Membership]
    SET
        [PersonID] = ISNULL(@PersonID, [PersonID]),
        [RoleID] = ISNULL(@RoleID, [RoleID]),
        [TermID] = ISNULL(@TermID, [TermID]),
        [StartDate] = ISNULL(@StartDate, [StartDate]),
        [EndDate] = CASE WHEN @EndDate_Clear = 1 THEN NULL ELSE ISNULL(@EndDate, [EndDate]) END,
        [Status] = ISNULL(@Status, [Status]),
        [EndReason] = CASE WHEN @EndReason_Clear = 1 THEN NULL ELSE ISNULL(@EndReason, [EndReason]) END,
        [Notes] = CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, [Notes]) END,
        [RenewalIntent] = CASE WHEN @RenewalIntent_Clear = 1 THEN NULL ELSE ISNULL(@RenewalIntent, [RenewalIntent]) END,
        [__mj_UpdatedAt] = GETUTCDATE()
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwMemberships] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwMemberships]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMembership] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMembership] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMembership] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Membership table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateMembership]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateMembership];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateMembership
ON [${flyway:defaultSchema}].[Membership]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE([__mj_UpdatedAt])
    BEGIN
        UPDATE
            [${flyway:defaultSchema}].[Membership]
        SET
            __mj_UpdatedAt = GETUTCDATE()
        FROM
            [${flyway:defaultSchema}].[Membership] AS _organicTable
        INNER JOIN
            INSERTED AS I ON
            _organicTable.[ID] = I.[ID];
    END
END;
GO

/* spUpdate Permissions for Committees: Memberships */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMembership] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMembership] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMembership] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteMembership]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteMembership];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteMembership]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Membership]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMembership] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMembership] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMembership] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Memberships */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMembership] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMembership] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMembership] TO [cdp_Developer], [cdp_Integration];

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
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Minute_ArtifactID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Minute]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Minute]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'ArtifactID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Minute_ArtifactID ON [${flyway:defaultSchema}].[Minute] ([ArtifactID]);

-- Index for foreign key MeetingID in table Minute
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Minute_MeetingID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Minute]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Minute]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'MeetingID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Minute_MeetingID ON [${flyway:defaultSchema}].[Minute] ([MeetingID]);

-- Index for foreign key ApprovedByMeetingID in table Minute
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Minute_ApprovedByMeetingID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Minute]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Minute]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'ApprovedByMeetingID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Minute_ApprovedByMeetingID ON [${flyway:defaultSchema}].[Minute] ([ApprovedByMeetingID]);

-- Index for foreign key MJArtifactID in table Minute
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Minute_MJArtifactID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Minute]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Minute]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'MJArtifactID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Minute_MJArtifactID ON [${flyway:defaultSchema}].[Minute] ([MJArtifactID]);

-- Index for foreign key ApprovedArtifactVersionID in table Minute
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Minute_ApprovedArtifactVersionID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Minute]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Minute]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'ApprovedArtifactVersionID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Minute_ApprovedArtifactVersionID ON [${flyway:defaultSchema}].[Minute] ([ApprovedArtifactVersionID]);

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
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Minute
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwMinutes]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwMinutes];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwMinutes]
AS
SELECT
    m.*,
    mjBizAppsCommitteesArtifact_ArtifactID.[Name] AS [Artifact],
    mjBizAppsCommitteesMeeting_MeetingID.[Name] AS [Meeting],
    mjBizAppsCommitteesMeeting_ApprovedByMeetingID.[Name] AS [ApprovedByMeeting],
    MJArtifact_MJArtifactID.[Name] AS [MJArtifact],
    MJArtifactVersion_ApprovedArtifactVersionID.[Name] AS [ApprovedArtifactVersion]
FROM
    [${flyway:defaultSchema}].[Minute] AS m
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Artifact] AS mjBizAppsCommitteesArtifact_ArtifactID
  ON
    [m].[ArtifactID] = mjBizAppsCommitteesArtifact_ArtifactID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Meeting] AS mjBizAppsCommitteesMeeting_MeetingID
  ON
    [m].[MeetingID] = mjBizAppsCommitteesMeeting_MeetingID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Meeting] AS mjBizAppsCommitteesMeeting_ApprovedByMeetingID
  ON
    [m].[ApprovedByMeetingID] = mjBizAppsCommitteesMeeting_ApprovedByMeetingID.[ID]
LEFT OUTER JOIN
    [${mjSchema}].[Artifact] AS MJArtifact_MJArtifactID
  ON
    [m].[MJArtifactID] = MJArtifact_MJArtifactID.[ID]
LEFT OUTER JOIN
    [${mjSchema}].[ArtifactVersion] AS MJArtifactVersion_ApprovedArtifactVersionID
  ON
    [m].[ApprovedArtifactVersionID] = MJArtifactVersion_ApprovedArtifactVersionID.[ID]
GO
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMinutes] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMinutes] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMinutes] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwMinutes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Minutes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Minutes
-- Item: Permissions for vwMinutes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

REVOKE SELECT ON [${flyway:defaultSchema}].[vwMinutes] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMinutes] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMinutes] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwMinutes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateMinute]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateMinute];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateMinute]
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
    @Notes nvarchar(MAX) = NULL,
    @MJArtifactID_Clear bit = 0,
    @MJArtifactID uniqueidentifier = NULL,
    @ApprovedArtifactVersionID_Clear bit = 0,
    @ApprovedArtifactVersionID uniqueidentifier = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InsertedRow TABLE ([ID] UNIQUEIDENTIFIER)

    IF @ID IS NOT NULL
    BEGIN
        -- User provided a value, use it
        INSERT INTO [${flyway:defaultSchema}].[Minute]
            (
                [ID],
                [ArtifactID],
                [MeetingID],
                [Content],
                [ApprovalStatus],
                [ApprovedAt],
                [ApprovedByMeetingID],
                [Notes],
                [MJArtifactID],
                [ApprovedArtifactVersionID]
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
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END,
                CASE WHEN @MJArtifactID_Clear = 1 THEN NULL ELSE ISNULL(@MJArtifactID, NULL) END,
                CASE WHEN @ApprovedArtifactVersionID_Clear = 1 THEN NULL ELSE ISNULL(@ApprovedArtifactVersionID, NULL) END
            )
    END
    ELSE
    BEGIN
        -- No value provided, let database use its default (e.g., NEWSEQUENTIALID())
        INSERT INTO [${flyway:defaultSchema}].[Minute]
            (
                [ArtifactID],
                [MeetingID],
                [Content],
                [ApprovalStatus],
                [ApprovedAt],
                [ApprovedByMeetingID],
                [Notes],
                [MJArtifactID],
                [ApprovedArtifactVersionID]
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
                CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, NULL) END,
                CASE WHEN @MJArtifactID_Clear = 1 THEN NULL ELSE ISNULL(@MJArtifactID, NULL) END,
                CASE WHEN @ApprovedArtifactVersionID_Clear = 1 THEN NULL ELSE ISNULL(@ApprovedArtifactVersionID, NULL) END
            )
    END
    -- return the new record from the base view, which might have some calculated fields
    SELECT * FROM [${flyway:defaultSchema}].[vwMinutes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMinute] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMinute] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMinute] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Minutes */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMinute] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMinute] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMinute] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateMinute]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateMinute];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateMinute]
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
    @Notes nvarchar(MAX) = NULL,
    @MJArtifactID_Clear bit = 0,
    @MJArtifactID uniqueidentifier = NULL,
    @ApprovedArtifactVersionID_Clear bit = 0,
    @ApprovedArtifactVersionID uniqueidentifier = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE
        [${flyway:defaultSchema}].[Minute]
    SET
        [ArtifactID] = CASE WHEN @ArtifactID_Clear = 1 THEN NULL ELSE ISNULL(@ArtifactID, [ArtifactID]) END,
        [MeetingID] = CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, [MeetingID]) END,
        [Content] = CASE WHEN @Content_Clear = 1 THEN NULL ELSE ISNULL(@Content, [Content]) END,
        [ApprovalStatus] = ISNULL(@ApprovalStatus, [ApprovalStatus]),
        [ApprovedAt] = CASE WHEN @ApprovedAt_Clear = 1 THEN NULL ELSE ISNULL(@ApprovedAt, [ApprovedAt]) END,
        [ApprovedByMeetingID] = CASE WHEN @ApprovedByMeetingID_Clear = 1 THEN NULL ELSE ISNULL(@ApprovedByMeetingID, [ApprovedByMeetingID]) END,
        [Notes] = CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, [Notes]) END,
        [MJArtifactID] = CASE WHEN @MJArtifactID_Clear = 1 THEN NULL ELSE ISNULL(@MJArtifactID, [MJArtifactID]) END,
        [ApprovedArtifactVersionID] = CASE WHEN @ApprovedArtifactVersionID_Clear = 1 THEN NULL ELSE ISNULL(@ApprovedArtifactVersionID, [ApprovedArtifactVersionID]) END,
        [__mj_UpdatedAt] = GETUTCDATE()
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwMinutes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwMinutes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMinute] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMinute] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMinute] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Minute table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateMinute]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateMinute];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateMinute
ON [${flyway:defaultSchema}].[Minute]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE([__mj_UpdatedAt])
    BEGIN
        UPDATE
            [${flyway:defaultSchema}].[Minute]
        SET
            __mj_UpdatedAt = GETUTCDATE()
        FROM
            [${flyway:defaultSchema}].[Minute] AS _organicTable
        INNER JOIN
            INSERTED AS I ON
            _organicTable.[ID] = I.[ID];
    END
END;
GO

/* spUpdate Permissions for Committees: Minutes */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMinute] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMinute] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMinute] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteMinute]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteMinute];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteMinute]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Minute]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMinute] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMinute] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMinute] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Minutes */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMinute] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMinute] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMinute] TO [cdp_Developer], [cdp_Integration];

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
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Motion_MeetingID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Motion]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Motion]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'MeetingID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Motion_MeetingID ON [${flyway:defaultSchema}].[Motion] ([MeetingID]);

-- Index for foreign key AgendaItemID in table Motion
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Motion_AgendaItemID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Motion]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Motion]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'AgendaItemID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Motion_AgendaItemID ON [${flyway:defaultSchema}].[Motion] ([AgendaItemID]);

-- Index for foreign key MovedByMembershipID in table Motion
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Motion_MovedByMembershipID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Motion]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Motion]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'MovedByMembershipID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Motion_MovedByMembershipID ON [${flyway:defaultSchema}].[Motion] ([MovedByMembershipID]);

-- Index for foreign key SecondedByMembershipID in table Motion
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Motion_SecondedByMembershipID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Motion]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Motion]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'SecondedByMembershipID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Motion_SecondedByMembershipID ON [${flyway:defaultSchema}].[Motion] ([SecondedByMembershipID]);

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
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Motion
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwMotions]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwMotions];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwMotions]
AS
SELECT
    m.*,
    mjBizAppsCommitteesMeeting_MeetingID.[Name] AS [Meeting],
    mjBizAppsCommitteesAgendaItem_AgendaItemID.[Name] AS [AgendaItem]
FROM
    [${flyway:defaultSchema}].[Motion] AS m
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Meeting] AS mjBizAppsCommitteesMeeting_MeetingID
  ON
    [m].[MeetingID] = mjBizAppsCommitteesMeeting_MeetingID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[AgendaItem] AS mjBizAppsCommitteesAgendaItem_AgendaItemID
  ON
    [m].[AgendaItemID] = mjBizAppsCommitteesAgendaItem_AgendaItemID.[ID]
GO
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMotions] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMotions] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMotions] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwMotions] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Motions */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Motions
-- Item: Permissions for vwMotions
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

REVOKE SELECT ON [${flyway:defaultSchema}].[vwMotions] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMotions] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwMotions] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwMotions] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateMotion]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateMotion];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateMotion]
    @ID uniqueidentifier = NULL,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @Sequence int = NULL,
    @Name nvarchar(255),
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
        INSERT INTO [${flyway:defaultSchema}].[Motion]
            (
                [ID],
                [MeetingID],
                [AgendaItemID],
                [Sequence],
                [Name],
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
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                ISNULL(@Sequence, 1),
                @Name,
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
        INSERT INTO [${flyway:defaultSchema}].[Motion]
            (
                [MeetingID],
                [AgendaItemID],
                [Sequence],
                [Name],
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
                CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, NULL) END,
                CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, NULL) END,
                ISNULL(@Sequence, 1),
                @Name,
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
    SELECT * FROM [${flyway:defaultSchema}].[vwMotions] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMotion] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMotion] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMotion] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Motions */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMotion] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateMotion] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMotion] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateMotion]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateMotion];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateMotion]
    @ID uniqueidentifier,
    @MeetingID_Clear bit = 0,
    @MeetingID uniqueidentifier = NULL,
    @AgendaItemID_Clear bit = 0,
    @AgendaItemID uniqueidentifier = NULL,
    @Sequence int = NULL,
    @Name nvarchar(255) = NULL,
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
        [${flyway:defaultSchema}].[Motion]
    SET
        [MeetingID] = CASE WHEN @MeetingID_Clear = 1 THEN NULL ELSE ISNULL(@MeetingID, [MeetingID]) END,
        [AgendaItemID] = CASE WHEN @AgendaItemID_Clear = 1 THEN NULL ELSE ISNULL(@AgendaItemID, [AgendaItemID]) END,
        [Sequence] = ISNULL(@Sequence, [Sequence]),
        [Name] = ISNULL(@Name, [Name]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [MovedByMembershipID] = CASE WHEN @MovedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@MovedByMembershipID, [MovedByMembershipID]) END,
        [SecondedByMembershipID] = CASE WHEN @SecondedByMembershipID_Clear = 1 THEN NULL ELSE ISNULL(@SecondedByMembershipID, [SecondedByMembershipID]) END,
        [Result] = ISNULL(@Result, [Result]),
        [ResultSummary] = CASE WHEN @ResultSummary_Clear = 1 THEN NULL ELSE ISNULL(@ResultSummary, [ResultSummary]) END,
        [YesCount] = CASE WHEN @YesCount_Clear = 1 THEN NULL ELSE ISNULL(@YesCount, [YesCount]) END,
        [NoCount] = CASE WHEN @NoCount_Clear = 1 THEN NULL ELSE ISNULL(@NoCount, [NoCount]) END,
        [AbstainCount] = CASE WHEN @AbstainCount_Clear = 1 THEN NULL ELSE ISNULL(@AbstainCount, [AbstainCount]) END,
        [Notes] = CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, [Notes]) END,
        [__mj_UpdatedAt] = GETUTCDATE()
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwMotions] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwMotions]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMotion] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMotion] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMotion] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Motion table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateMotion]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateMotion];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateMotion
ON [${flyway:defaultSchema}].[Motion]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE([__mj_UpdatedAt])
    BEGIN
        UPDATE
            [${flyway:defaultSchema}].[Motion]
        SET
            __mj_UpdatedAt = GETUTCDATE()
        FROM
            [${flyway:defaultSchema}].[Motion] AS _organicTable
        INNER JOIN
            INSERTED AS I ON
            _organicTable.[ID] = I.[ID];
    END
END;
GO

/* spUpdate Permissions for Committees: Motions */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMotion] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateMotion] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMotion] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteMotion]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteMotion];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteMotion]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Motion]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMotion] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMotion] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMotion] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Motions */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMotion] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteMotion] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMotion] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateRole]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateRole];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateRole]
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
        [${flyway:defaultSchema}].[Role]
    SET
        [Name] = ISNULL(@Name, [Name]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [IsOfficer] = ISNULL(@IsOfficer, [IsOfficer]),
        [IsVotingRole] = ISNULL(@IsVotingRole, [IsVotingRole]),
        [DefaultPermissionsJSON] = CASE WHEN @DefaultPermissionsJSON_Clear = 1 THEN NULL ELSE ISNULL(@DefaultPermissionsJSON, [DefaultPermissionsJSON]) END,
        [Sequence] = ISNULL(@Sequence, [Sequence]),
        [__mj_UpdatedAt] = GETUTCDATE()
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwRoles] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwRoles]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateRole] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateRole] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateRole] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Role table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateRole]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateRole];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateRole
ON [${flyway:defaultSchema}].[Role]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE([__mj_UpdatedAt])
    BEGIN
        UPDATE
            [${flyway:defaultSchema}].[Role]
        SET
            __mj_UpdatedAt = GETUTCDATE()
        FROM
            [${flyway:defaultSchema}].[Role] AS _organicTable
        INNER JOIN
            INSERTED AS I ON
            _organicTable.[ID] = I.[ID];
    END
END;
GO

/* spUpdate Permissions for Committees: Roles */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateRole] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateRole] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateRole] TO [cdp_Developer], [cdp_Integration];

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
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Term_CommitteeID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Term]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Term]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'CommitteeID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Term_CommitteeID ON [${flyway:defaultSchema}].[Term] ([CommitteeID]);

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
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Term
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwTerms]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwTerms];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwTerms]
AS
SELECT
    t.*,
    mjBizAppsCommitteesCommittee_CommitteeID.[Name] AS [Committee]
FROM
    [${flyway:defaultSchema}].[Term] AS t
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Committee] AS mjBizAppsCommitteesCommittee_CommitteeID
  ON
    [t].[CommitteeID] = mjBizAppsCommitteesCommittee_CommitteeID.[ID]
GO
REVOKE SELECT ON [${flyway:defaultSchema}].[vwTerms] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwTerms] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwTerms] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwTerms] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Terms */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Terms
-- Item: Permissions for vwTerms
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

REVOKE SELECT ON [${flyway:defaultSchema}].[vwTerms] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwTerms] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwTerms] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwTerms] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateTerm]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateTerm];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateTerm]
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
        INSERT INTO [${flyway:defaultSchema}].[Term]
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
        INSERT INTO [${flyway:defaultSchema}].[Term]
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
    SELECT * FROM [${flyway:defaultSchema}].[vwTerms] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateTerm] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateTerm] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateTerm] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Terms */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateTerm] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateTerm] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateTerm] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateTerm]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateTerm];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateTerm]
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
        [${flyway:defaultSchema}].[Term]
    SET
        [CommitteeID] = ISNULL(@CommitteeID, [CommitteeID]),
        [Name] = ISNULL(@Name, [Name]),
        [StartDate] = ISNULL(@StartDate, [StartDate]),
        [EndDate] = CASE WHEN @EndDate_Clear = 1 THEN NULL ELSE ISNULL(@EndDate, [EndDate]) END,
        [Status] = ISNULL(@Status, [Status]),
        [__mj_UpdatedAt] = GETUTCDATE()
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwTerms] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwTerms]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateTerm] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateTerm] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateTerm] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Term table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateTerm]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateTerm];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateTerm
ON [${flyway:defaultSchema}].[Term]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE([__mj_UpdatedAt])
    BEGIN
        UPDATE
            [${flyway:defaultSchema}].[Term]
        SET
            __mj_UpdatedAt = GETUTCDATE()
        FROM
            [${flyway:defaultSchema}].[Term] AS _organicTable
        INNER JOIN
            INSERTED AS I ON
            _organicTable.[ID] = I.[ID];
    END
END;
GO

/* spUpdate Permissions for Committees: Terms */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateTerm] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateTerm] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateTerm] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteTerm]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteTerm];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteTerm]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Term]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteTerm] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteTerm] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteTerm] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Terms */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteTerm] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteTerm] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteTerm] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateType]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateType];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateType]
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
        [${flyway:defaultSchema}].[Type]
    SET
        [Name] = ISNULL(@Name, [Name]),
        [Description] = CASE WHEN @Description_Clear = 1 THEN NULL ELSE ISNULL(@Description, [Description]) END,
        [IsStandards] = ISNULL(@IsStandards, [IsStandards]),
        [DefaultTermMonths] = CASE WHEN @DefaultTermMonths_Clear = 1 THEN NULL ELSE ISNULL(@DefaultTermMonths, [DefaultTermMonths]) END,
        [IconClass] = CASE WHEN @IconClass_Clear = 1 THEN NULL ELSE ISNULL(@IconClass, [IconClass]) END,
        [__mj_UpdatedAt] = GETUTCDATE()
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwTypes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwTypes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateType] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateType] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateType] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Type table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateType]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateType];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateType
ON [${flyway:defaultSchema}].[Type]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE([__mj_UpdatedAt])
    BEGIN
        UPDATE
            [${flyway:defaultSchema}].[Type]
        SET
            __mj_UpdatedAt = GETUTCDATE()
        FROM
            [${flyway:defaultSchema}].[Type] AS _organicTable
        INNER JOIN
            INSERTED AS I ON
            _organicTable.[ID] = I.[ID];
    END
END;
GO

/* spUpdate Permissions for Committees: Types */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateType] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateType] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateType] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateVideoProvider]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateVideoProvider];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateVideoProvider]
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
        [${flyway:defaultSchema}].[VideoProvider]
    SET
        [Name] = ISNULL(@Name, [Name]),
        [ServerDriverKey] = ISNULL(@ServerDriverKey, [ServerDriverKey]),
        [IsActive] = ISNULL(@IsActive, [IsActive]),
        [IsDefault] = ISNULL(@IsDefault, [IsDefault]),
        [CredentialID] = CASE WHEN @CredentialID_Clear = 1 THEN NULL ELSE ISNULL(@CredentialID, [CredentialID]) END,
        [__mj_UpdatedAt] = GETUTCDATE()
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwVideoProviders] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwVideoProviders]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateVideoProvider] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateVideoProvider] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateVideoProvider] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the VideoProvider table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateVideoProvider]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateVideoProvider];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateVideoProvider
ON [${flyway:defaultSchema}].[VideoProvider]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE([__mj_UpdatedAt])
    BEGIN
        UPDATE
            [${flyway:defaultSchema}].[VideoProvider]
        SET
            __mj_UpdatedAt = GETUTCDATE()
        FROM
            [${flyway:defaultSchema}].[VideoProvider] AS _organicTable
        INNER JOIN
            INSERTED AS I ON
            _organicTable.[ID] = I.[ID];
    END
END;
GO

/* spUpdate Permissions for Committees: Video Providers */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateVideoProvider] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateVideoProvider] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateVideoProvider] TO [cdp_Developer], [cdp_Integration];

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
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Vote_MotionID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Vote]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Vote]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'MotionID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Vote_MotionID ON [${flyway:defaultSchema}].[Vote] ([MotionID]);

-- Index for foreign key MembershipID in table Vote
-- Skipped when the index exists or another unfiltered index already leads with the column.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Vote_MembershipID'
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Vote]')
    UNION ALL
    SELECT 1
    FROM sys.indexes i
    WHERE i.object_id = OBJECT_ID('[${flyway:defaultSchema}].[Vote]')
    AND i.has_filter = 0
    AND i.is_disabled = 0
    AND i.is_hypothetical = 0
    AND (
        SELECT COUNT(*)
        FROM sys.index_columns ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 0
        AND ((ic.key_ordinal = 1 AND COL_NAME(ic.object_id, ic.column_id) = 'MembershipID'))
    ) = 1
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Vote_MembershipID ON [${flyway:defaultSchema}].[Vote] ([MembershipID]);

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
-----               SCHEMA:      ${flyway:defaultSchema}
-----               BASE TABLE:  Vote
-----               PRIMARY KEY: ID
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[vwVotes]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwVotes];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwVotes]
AS
SELECT
    v.*,
    mjBizAppsCommitteesMotion_MotionID.[Name] AS [Motion]
FROM
    [${flyway:defaultSchema}].[Vote] AS v
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[Motion] AS mjBizAppsCommitteesMotion_MotionID
  ON
    [v].[MotionID] = mjBizAppsCommitteesMotion_MotionID.[ID]
GO
REVOKE SELECT ON [${flyway:defaultSchema}].[vwVotes] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwVotes] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwVotes] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwVotes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

/* Base View Permissions SQL for Committees: Votes */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Votes
-- Item: Permissions for vwVotes
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------

REVOKE SELECT ON [${flyway:defaultSchema}].[vwVotes] FROM [cdp_UI]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwVotes] FROM [cdp_Developer]
REVOKE SELECT ON [${flyway:defaultSchema}].[vwVotes] FROM [cdp_Integration]
GRANT SELECT ON [${flyway:defaultSchema}].[vwVotes] TO [cdp_UI], [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateVote]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateVote];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spCreateVote]
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
        INSERT INTO [${flyway:defaultSchema}].[Vote]
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
        INSERT INTO [${flyway:defaultSchema}].[Vote]
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
    SELECT * FROM [${flyway:defaultSchema}].[vwVotes] WHERE [ID] = (SELECT [ID] FROM @InsertedRow)
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateVote] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateVote] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateVote] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Votes */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateVote] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spCreateVote] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateVote] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateVote]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateVote];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spUpdateVote]
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
        [${flyway:defaultSchema}].[Vote]
    SET
        [MotionID] = ISNULL(@MotionID, [MotionID]),
        [MembershipID] = ISNULL(@MembershipID, [MembershipID]),
        [VoteValue] = ISNULL(@VoteValue, [VoteValue]),
        [Notes] = CASE WHEN @Notes_Clear = 1 THEN NULL ELSE ISNULL(@Notes, [Notes]) END,
        [__mj_UpdatedAt] = GETUTCDATE()
    WHERE
        [ID] = @ID

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
        -- Nothing was updated, return no rows, but column structure from base view intact, semantically correct this way.
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwVotes] WHERE 1=0
    ELSE
        -- Return the updated record so the caller can see the updated values and any calculated fields
        SELECT
                                        *
                                    FROM
                                        [${flyway:defaultSchema}].[vwVotes]
                                    WHERE
                                        [ID] = @ID
                                    
END
GO

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateVote] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateVote] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateVote] TO [cdp_Developer], [cdp_Integration]
GO

------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Vote table
------------------------------------------------------------
IF OBJECT_ID('[${flyway:defaultSchema}].[trgUpdateVote]', 'TR') IS NOT NULL
    DROP TRIGGER [${flyway:defaultSchema}].[trgUpdateVote];
GO
CREATE TRIGGER [${flyway:defaultSchema}].trgUpdateVote
ON [${flyway:defaultSchema}].[Vote]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE([__mj_UpdatedAt])
    BEGIN
        UPDATE
            [${flyway:defaultSchema}].[Vote]
        SET
            __mj_UpdatedAt = GETUTCDATE()
        FROM
            [${flyway:defaultSchema}].[Vote] AS _organicTable
        INNER JOIN
            INSERTED AS I ON
            _organicTable.[ID] = I.[ID];
    END
END;
GO

/* spUpdate Permissions for Committees: Votes */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateVote] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spUpdateVote] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateVote] TO [cdp_Developer], [cdp_Integration];

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
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteVote]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteVote];
GO

CREATE PROCEDURE [${flyway:defaultSchema}].[spDeleteVote]
    @ID uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM
        [${flyway:defaultSchema}].[Vote]
    WHERE
        [ID] = @ID


    -- Check if the delete was successful
    IF @@ROWCOUNT = 0
        SELECT NULL AS [ID] -- Return NULL for all primary key fields to indicate no record was deleted
    ELSE
        SELECT @ID AS [ID] -- Return the primary key values to indicate we successfully deleted the record
END
GO
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteVote] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteVote] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteVote] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Votes */

REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteVote] FROM [cdp_Developer]
REVOKE EXECUTE ON [${flyway:defaultSchema}].[spDeleteVote] FROM [cdp_Integration]
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteVote] TO [cdp_Developer], [cdp_Integration];


/* SQL text to insert 15 new entity field(s) */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '48200fbe-5515-4eec-994b-aeddfcabfb6a' OR (EntityID = 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8' AND Name = 'ParentAgendaItemIDDepth')) BEGIN
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
            '48200fbe-5515-4eec-994b-aeddfcabfb6a',
            'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8', -- Entity: Committees: Agenda Items
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8'),
            'ParentAgendaItemIDDepth',
            'Parent Agenda Item ID Depth',
            NULL,
            'int',
            4,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '2cbeae51-280c-47fe-a01a-09cbcd3b22b0' OR (EntityID = 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8' AND Name = 'ParentAgendaItemIDPath')) BEGIN
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
            '2cbeae51-280c-47fe-a01a-09cbcd3b22b0',
            'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8', -- Entity: Committees: Agenda Items
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8'),
            'ParentAgendaItemIDPath',
            'Parent Agenda Item ID Path',
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
            0,
            NULL,
            NULL,
            0,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '50da97f7-f1af-4dcb-8a13-d59191f87b20' OR (EntityID = 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8' AND Name = 'ParentAgendaItemIDIsLeaf')) BEGIN
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
            '50da97f7-f1af-4dcb-8a13-d59191f87b20',
            'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8', -- Entity: Committees: Agenda Items
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8'),
            'ParentAgendaItemIDIsLeaf',
            'Parent Agenda Item ID Is Leaf',
            NULL,
            'bit',
            1,
            1,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'bcdff096-2b57-4d29-b4a1-6976cdd49746' OR (EntityID = 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8' AND Name = 'ParentAgendaItemIDChildCount')) BEGIN
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
            'bcdff096-2b57-4d29-b4a1-6976cdd49746',
            'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8', -- Entity: Committees: Agenda Items
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8'),
            'ParentAgendaItemIDChildCount',
            'Parent Agenda Item ID Child Count',
            NULL,
            'int',
            4,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '09f74a61-00c5-4bf4-97c4-c2123053c307' OR (EntityID = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF' AND Name = 'ParentCommentIDDepth')) BEGIN
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
            '09f74a61-00c5-4bf4-97c4-c2123053c307',
            'C1CEF804-AA80-47A0-9750-2A4C5227B6DF', -- Entity: Committees: Comments
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF'),
            'ParentCommentIDDepth',
            'Parent Comment ID Depth',
            NULL,
            'int',
            4,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '1a0ec43b-87dc-480c-a5a5-d72a94ecddab' OR (EntityID = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF' AND Name = 'ParentCommentIDPath')) BEGIN
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
            '1a0ec43b-87dc-480c-a5a5-d72a94ecddab',
            'C1CEF804-AA80-47A0-9750-2A4C5227B6DF', -- Entity: Committees: Comments
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF'),
            'ParentCommentIDPath',
            'Parent Comment ID Path',
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
            0,
            NULL,
            NULL,
            0,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '61fe1b2c-426d-4c90-b9e5-180503c1cb87' OR (EntityID = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF' AND Name = 'ParentCommentIDIsLeaf')) BEGIN
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
            '61fe1b2c-426d-4c90-b9e5-180503c1cb87',
            'C1CEF804-AA80-47A0-9750-2A4C5227B6DF', -- Entity: Committees: Comments
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF'),
            'ParentCommentIDIsLeaf',
            'Parent Comment ID Is Leaf',
            NULL,
            'bit',
            1,
            1,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '682fe1af-f9d0-4b29-87f5-deeaf5e19a61' OR (EntityID = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF' AND Name = 'ParentCommentIDChildCount')) BEGIN
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
            '682fe1af-f9d0-4b29-87f5-deeaf5e19a61',
            'C1CEF804-AA80-47A0-9750-2A4C5227B6DF', -- Entity: Committees: Comments
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF'),
            'ParentCommentIDChildCount',
            'Parent Comment ID Child Count',
            NULL,
            'int',
            4,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '60f4e307-42e7-4dc4-bb7e-9b09b07056bd' OR (EntityID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND Name = 'ParentCommitteeIDDepth')) BEGIN
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
            '60f4e307-42e7-4dc4-bb7e-9b09b07056bd',
            'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', -- Entity: Committees: Committees
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'),
            'ParentCommitteeIDDepth',
            'Parent Committee ID Depth',
            NULL,
            'int',
            4,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'eb6e2a40-162b-4860-b0b6-ab7e2173564a' OR (EntityID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND Name = 'ParentCommitteeIDPath')) BEGIN
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
            'eb6e2a40-162b-4860-b0b6-ab7e2173564a',
            'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', -- Entity: Committees: Committees
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'),
            'ParentCommitteeIDPath',
            'Parent Committee ID Path',
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
            0,
            NULL,
            NULL,
            0,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'e639ab26-3a8a-4cfa-9256-a00d27080bd8' OR (EntityID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND Name = 'ParentCommitteeIDIsLeaf')) BEGIN
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
            'e639ab26-3a8a-4cfa-9256-a00d27080bd8',
            'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', -- Entity: Committees: Committees
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'),
            'ParentCommitteeIDIsLeaf',
            'Parent Committee ID Is Leaf',
            NULL,
            'bit',
            1,
            1,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '1af53eed-dc1d-4b08-ab26-d581fda01d53' OR (EntityID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND Name = 'ParentCommitteeIDChildCount')) BEGIN
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
            '1af53eed-dc1d-4b08-ab26-d581fda01d53',
            'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE', -- Entity: Committees: Committees
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'),
            'ParentCommitteeIDChildCount',
            'Parent Committee ID Child Count',
            NULL,
            'int',
            4,
            10,
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '48f5be45-0f98-4ef6-a01d-f78966596c42' OR (EntityID = '272BEFB5-727A-4525-B235-775A56B7ACBB' AND Name = 'MJArtifact')) BEGIN
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
            '48f5be45-0f98-4ef6-a01d-f78966596c42',
            '272BEFB5-727A-4525-B235-775A56B7ACBB', -- Entity: Committees: Artifacts
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '272BEFB5-727A-4525-B235-775A56B7ACBB'),
            'MJArtifact',
            'MJ Artifact',
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'db5068f4-b2e4-4472-a778-674ba2760327' OR (EntityID = '0EC944F9-F908-4662-87B2-E57077A873FF' AND Name = 'MJArtifact')) BEGIN
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
            'db5068f4-b2e4-4472-a778-674ba2760327',
            '0EC944F9-F908-4662-87B2-E57077A873FF', -- Entity: Committees: Minutes
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '0EC944F9-F908-4662-87B2-E57077A873FF'),
            'MJArtifact',
            'MJ Artifact',
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

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = 'f0d99a30-e913-424f-b3e5-217018e73b98' OR (EntityID = '0EC944F9-F908-4662-87B2-E57077A873FF' AND Name = 'ApprovedArtifactVersion')) BEGIN
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
            'f0d99a30-e913-424f-b3e5-217018e73b98',
            '0EC944F9-F908-4662-87B2-E57077A873FF', -- Entity: Committees: Minutes
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = '0EC944F9-F908-4662-87B2-E57077A873FF'),
            'ApprovedArtifactVersion',
            'Approved Artifact Version',
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

/* SQL text to update existing entity fields from schema (12 scoped entities) */
EXEC [${mjSchema}].[spUpdateExistingEntityFieldsFromSchema] @ExcludedSchemaNames='', @EntityIDs='272BEFB5-727A-4525-B235-775A56B7ACBB,0EC944F9-F908-4662-87B2-E57077A873FF,F7DEBA2D-4E28-4C6E-971B-6099217FAB29,D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8,E7D9813E-3C34-4233-AFCC-4CB76CFE081C,AAAEE71B-D7CF-4628-BED0-59D43256E46A,94A59079-7436-4178-A31B-9B42DDA822C1,194B3496-2829-4806-BC42-CF0724A1DD26,F8FADBBE-A323-48FB-8395-3B543729F6E6,A5DA88A1-AA21-4A3F-B1C4-42652FB440CE,87BEDFA6-F149-4AF2-993C-81BD01169584,C1CEF804-AA80-47A0-9750-2A4C5227B6DF', @IncludedSchemaNames='${flyway:defaultSchema}';

/* SQL text to set default column width where needed */
EXEC [${mjSchema}].[spSetDefaultColumnWidthWhereNeeded] @ExcludedSchemaNames='', @IncludedSchemaNames='${flyway:defaultSchema}';

/* Refresh custom base views for modified entities so schema changes are picked up */
EXEC sp_refreshview '${flyway:defaultSchema}.vwMeetingsGenerated';
IF OBJECT_ID('[${flyway:defaultSchema}].[vwMeetings]', 'V') IS NOT NULL
BEGIN
    EXEC sp_executesql N'EXEC sp_refreshview ''${flyway:defaultSchema}.vwMeetings'';';
END;

