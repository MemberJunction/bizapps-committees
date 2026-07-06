/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '9dd17f96-3e73-45dd-ac1f-5f2706f8feaa' OR (EntityID = '29248F34-2837-EF11-86D4-6045BDEE16E6' AND Name = 'URL')) BEGIN
         INSERT INTO [${flyway:defaultSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '9dd17f96-3e73-45dd-ac1f-5f2706f8feaa',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = 'a4cfe505-71ba-48d9-8b23-93b88ec1d281' OR (EntityID = '29248F34-2837-EF11-86D4-6045BDEE16E6' AND Name = 'ExternalID')) BEGIN
         INSERT INTO [${flyway:defaultSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            'a4cfe505-71ba-48d9-8b23-93b88ec1d281',
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

      IF NOT EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[EntityField] WHERE ID = '6806cbb5-69d1-451d-8d09-ebe8074c112c' OR (EntityID = '29248F34-2837-EF11-86D4-6045BDEE16E6' AND Name = 'FileSize')) BEGIN
         INSERT INTO [${flyway:defaultSchema}].[EntityField]
         (
            [ID],
            [EntityID],
            [Sequence],
            [Name],
            [DisplayName],
            [Description],
            [Type],
            [Length],
            [Precision],
            [Scale],
            [AllowsNull],
            [DefaultValue],
            [AutoIncrement],
            [AllowUpdateAPI],
            [IsVirtual],
            [RelatedEntityID],
            [RelatedEntityFieldName],
            [IsNameField],
            [IncludeInUserSearchAPI],
            [IncludeRelatedEntityNameFieldInBaseView],
            [DefaultInView],
            [IsPrimaryKey],
            [IsUnique],
            [RelatedEntityDisplayType],
            [__mj_CreatedAt],
            [__mj_UpdatedAt]
         )
         VALUES
         (
            '6806cbb5-69d1-451d-8d09-ebe8074c112c',
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

