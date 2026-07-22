---------------------------------------------------------------------------
-- Phase 3 "Sustain" — renewal-intent capture (UX v2 screens 05/06)
--
-- Adds Membership.RenewalIntent: the member's answer to "Will you serve
-- another term?" captured via Member Home self-service and fed into the
-- People & Terms vacancy pipeline. Nullable — NULL means not yet asked or
-- not yet answered; the pipeline treats NULL as Undecided-but-unprompted.
--
-- This is the ONLY schema Phase 3 needs: pipeline seats derive from
-- Terms/Memberships/Attendance, and AI succession suggestions are generated
-- on demand (evidence-linked, never stored until a human acts).
--
-- After migrating: run `npm run mj:codegen` (single pass), append the
-- emitted SQL to this file below the CODEGEN marker, then verify with
-- `npm run test:harness:metadata` (drift must be zero).
---------------------------------------------------------------------------

IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = '${flyway:defaultSchema}' AND TABLE_NAME = 'Membership' AND COLUMN_NAME = 'RenewalIntent'
)
BEGIN
    ALTER TABLE ${flyway:defaultSchema}.Membership
        ADD RenewalIntent NVARCHAR(20) NULL
            CONSTRAINT CK_Membership_RenewalIntent CHECK (RenewalIntent IN ('Yes', 'No', 'Undecided'));
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.extended_properties WHERE major_id = OBJECT_ID('${flyway:defaultSchema}.Membership') AND minor_id = COLUMNPROPERTY(OBJECT_ID('${flyway:defaultSchema}.Membership'), 'RenewalIntent', 'ColumnId') AND name = 'MS_Description')
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'The member''s stated intent to serve another term (Yes, No, Undecided), captured via Member Home self-service; NULL = not yet answered. Feeds the People & Terms succession pipeline.', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Membership', @level2type = N'COLUMN', @level2name = N'RenewalIntent';
GO

/*================================ CODEGEN SPLICE POINT ================================
  Append the single-pass `mj codegen` output below after running the migration.
=======================================================================================*/

/*  CODEGEN — output of `mj codegen` (@memberjunction/cli 5.44.0), SINGLE PASS,
    run 2026-07-07 after the ALTER above. Verified: drift = 0 (test:harness:metadata 23/23).  */

/* SQL text to update existing entities from schema */
EXEC [${mjSchema}].[spUpdateExistingEntitiesFromSchema] @ExcludedSchemaNames='sys,staging,dbo,${mjSchema},__mj_BizAppsCommon,${mjSchema}_BizAppsTasks';

/* SQL text to insert new entity field */

      IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE ID = '0a11c5f0-25bf-45b0-a299-699162195771' OR (EntityID = 'F8FADBBE-A323-48FB-8395-3B543729F6E6' AND Name = 'RenewalIntent')) BEGIN
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
            '0a11c5f0-25bf-45b0-a299-699162195771',
            'F8FADBBE-A323-48FB-8395-3B543729F6E6', -- Entity: Committees: Memberships
            100026,
            'RenewalIntent',
            'Renewal Intent',
            'The member''s stated intent to serve another term (Yes, No, Undecided), captured via Member Home self-service; NULL = not yet answered. Feeds the People & Terms succession pipeline.',
            'nvarchar',
            40,
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

/* SQL text to update existing entity fields from schema */
EXEC [${mjSchema}].[spUpdateExistingEntityFieldsFromSchema] @ExcludedSchemaNames='sys,staging,dbo,${mjSchema},__mj_BizAppsCommon,${mjSchema}_BizAppsTasks';

/* SQL text to set default column width where needed */
EXEC [${mjSchema}].[spSetDefaultColumnWidthWhereNeeded] @ExcludedSchemaNames='sys,staging,dbo,${mjSchema},__mj_BizAppsCommon,${mjSchema}_BizAppsTasks';

/* SQL text to insert entity field value with ID f02aaadf-3b5d-4d0e-ba2e-2e92c7a7b1ae */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('f02aaadf-3b5d-4d0e-ba2e-2e92c7a7b1ae', '0A11C5F0-25BF-45B0-A299-699162195771', 1, 'No', 'No', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID 081eadff-20f2-495a-9ccb-c2c8d9fe495c */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('081eadff-20f2-495a-9ccb-c2c8d9fe495c', '0A11C5F0-25BF-45B0-A299-699162195771', 2, 'Undecided', 'Undecided', GETUTCDATE(), GETUTCDATE());

/* SQL text to insert entity field value with ID c4a96028-203c-4048-9462-b7116f19d108 */
INSERT INTO [${mjSchema}].[EntityFieldValue]
                                       ([ID], [EntityFieldID], [Sequence], [Value], [Code], [__mj_CreatedAt], [__mj_UpdatedAt])
                                    VALUES
                                       ('c4a96028-203c-4048-9462-b7116f19d108', '0A11C5F0-25BF-45B0-A299-699162195771', 3, 'Yes', 'Yes', GETUTCDATE(), GETUTCDATE());

/* SQL text to update ValueListType for entity field ID 0A11C5F0-25BF-45B0-A299-699162195771 */
UPDATE [${mjSchema}].[EntityField] SET ValueListType='List' WHERE ID='0A11C5F0-25BF-45B0-A299-699162195771';

/* SQL text to sync schema info from database schemas */
EXEC [${mjSchema}].[spUpdateSchemaInfoFromDatabase] @ExcludedSchemaNames='sys,staging,dbo,${mjSchema},__mj_BizAppsCommon,${mjSchema}_BizAppsTasks';

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
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Membership]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Membership_PersonID ON [${flyway:defaultSchema}].[Membership] ([PersonID]);

-- Index for foreign key RoleID in table Membership
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Membership_RoleID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Membership]')
)
CREATE INDEX IDX_AUTO_MJ_FKEY_Membership_RoleID ON [${flyway:defaultSchema}].[Membership] ([RoleID]);

-- Index for foreign key TermID in table Membership
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IDX_AUTO_MJ_FKEY_Membership_TermID' 
    AND object_id = OBJECT_ID('[${flyway:defaultSchema}].[Membership]')
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
INNER JOIN
    [__mj_BizAppsCommon].[Person] AS mjBizAppsCommonPerson_PersonID
  ON
    [m].[PersonID] = mjBizAppsCommonPerson_PersonID.[ID]
INNER JOIN
    [${flyway:defaultSchema}].[Role] AS mjBizAppsCommitteesRole_RoleID
  ON
    [m].[RoleID] = mjBizAppsCommitteesRole_RoleID.[ID]
INNER JOIN
    [${flyway:defaultSchema}].[Term] AS mjBizAppsCommitteesTerm_TermID
  ON
    [m].[TermID] = mjBizAppsCommitteesTerm_TermID.[ID]
GO
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
GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMembership] TO [cdp_Developer], [cdp_Integration];

/* spCreate Permissions for Committees: Memberships */

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
        [RenewalIntent] = CASE WHEN @RenewalIntent_Clear = 1 THEN NULL ELSE ISNULL(@RenewalIntent, [RenewalIntent]) END
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
    UPDATE
        [${flyway:defaultSchema}].[Membership]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}].[Membership] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO

/* spUpdate Permissions for Committees: Memberships */

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
GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMembership] TO [cdp_Developer], [cdp_Integration];

/* spDelete Permissions for Committees: Memberships */

GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMembership] TO [cdp_Developer], [cdp_Integration];

/* SQL text to delete unneeded entity fields (1 scoped entities) */
EXEC [${mjSchema}].[spDeleteUnneededEntityFields] @ExcludedSchemaNames='sys,staging,dbo,${mjSchema},__mj_BizAppsCommon,${mjSchema}_BizAppsTasks', @EntityIDs='F8FADBBE-A323-48FB-8395-3B543729F6E6';

/* SQL text to update existing entity fields from schema (1 scoped entities) */
EXEC [${mjSchema}].[spUpdateExistingEntityFieldsFromSchema] @ExcludedSchemaNames='sys,staging,dbo,${mjSchema},__mj_BizAppsCommon,${mjSchema}_BizAppsTasks', @EntityIDs='F8FADBBE-A323-48FB-8395-3B543729F6E6';

/* SQL text to set default column width where needed */
EXEC [${mjSchema}].[spSetDefaultColumnWidthWhereNeeded] @ExcludedSchemaNames='sys,staging,dbo,${mjSchema},__mj_BizAppsCommon,${mjSchema}_BizAppsTasks';

