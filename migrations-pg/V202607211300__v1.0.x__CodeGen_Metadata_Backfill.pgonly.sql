-- ============================================================================
-- CodeGen metadata backfill (PostgreSQL only — no T-SQL counterpart)
-- ============================================================================
-- Brings __mj core metadata for the Committees Open App (canonical schema
-- __mj_BizAppsCommittees, physical PG schema __mj_bizappscommittees, 16 live
-- entities after V202607072300 removed Committees: Action Items) to MJ
-- CodeGen's fixed-point state. The committees PG migrations bake CodeGen's
-- native plpgsql inline, so the install is ONE-SHOT: `mj migrate` alone (then
-- `mj sync push` for reference data) — no `mj codegen` step. This file pins the
-- __mj metadata that baking does NOT cover, so that IF codegen is ever run it
-- is a no-op. Mirrors bizapps-tasks V202607101100 and bizapps-common
-- V202607092207; group numbering follows the tasks file (its group 2, entity
-- icons, is intentionally omitted here — see OMITTED GROUPS below).
--
-- Why this file exists: the SS baseline's spliced CodeGen output relies on
-- SQL Server-side maintenance procs (spUpdateExistingEntityFieldsFromSchema,
-- spSetDefaultColumnWidthWhereNeeded, spUpdateEntityFieldRelatedEntityNameFieldMap,
-- spUpdateSchemaInfoFromDatabase). The mj migrate convert legacy rule pipeline
-- classifies bare EXEC statements as SKIP_SQLSERVER (SQLConverter
-- StatementClassifier), so none of those run on PG, and the baked plpgsql
-- covers app-schema objects but not this __mj metadata. Without this backfill a
-- codegen run would churn Sequence, DefaultColumnWidth, RelatedEntityNameFieldMap,
-- SchemaInfo, and the Ballots validator (an AI re-parse, nondeterministic
-- wording) instead of being a no-op.
--
-- Groups (all data, no app-schema DDL):
--
-- 1. SchemaInfo (MemberJunction/MJ#2992). Committees migrations never INSERT
--    a SchemaInfo row (the SS baseline only ran spUpdateSchemaInfoFromDatabase,
--    which the converter drops), so on a fresh PG install CodeGen would
--    auto-create one with CanonicalSchemaName NULL — and the installer's own
--    PersistCanonicalSchemaName UPDATE fires BEFORE migrations, so it always
--    misses. Without the canonical name, generated class names and runtime
--    GraphQL type names come out lowercase (mjbizappscommittees* instead of
--    mjBizAppsCommittees*) and no longer match the published entity packages.
--    ID 6AD431DD-590D-4800-9147-B44830888A44 was pinned at authoring time
--    (freshly generated UUID; no SS counterpart exists because SS auto-creates
--    its row via the proc). EntityNamePrefix 'Committees: ' reproduces the SS
--    dev-DB setting that gave the entities their 'Committees: X' names, so any
--    future table added to this schema is named consistently on PG.
--    Also restores the schema COMMENT the converter drops (ExtendedPropertyRule
--    parses only TABLE/COLUMN-level extended properties; the schema-level
--    MS_Description from the SS baseline is commented out), and pins
--    SchemaInfo.Description to the same text so codegen's
--    spUpdateSchemaInfoFromDatabase (which copies the pg_namespace comment via
--    vwSQLSchemas) finds them already equal.
--
-- 3. EntityField normalization to the CodeGen fixed point for all 222
--    fields of the 16 live entities (the 20 Committees: Action Items fields
--    deleted by V202607072300 are excluded). Per field this ships:
--      * Sequence — the converted INSERTs carry CodeGen's staged +100000
--        values (e.g. 100001, 100026); on SS spUpdateExistingEntityFieldsFromSchema
--        renumbers them to the base-view column ordinal, on PG that proc call
--        is dropped. Values here are the base-view attnum CodeGen's PG port
--        (vwSQLColumnsAndEntityFields, CodeGenLib metadataSupportObjects) will
--        compute: physical table columns in CREATE TABLE order, then
--        __mj_CreatedAt/__mj_UpdatedAt (ALTER-added), then Membership.RenewalIntent
--        (ALTER-added by V202607071000, hence AFTER the __mj columns), then the
--        view's virtual join columns in SELECT-list order. Cross-checked
--        programmatically against every CREATE TABLE and base-view definition
--        in the SS migrations (0 mismatches).
--      * DefaultColumnWidth — spSetDefaultColumnWidthWhereNeeded fills NULLs
--        by type: int=50, datetimeoffset=100, money=100, nchar=75, else 150
--        (committees uses uniqueidentifier/nvarchar/bit/date/bigint -> 150,
--        datetimeoffset -> 100, int -> 50).
--      * Length=4, Precision=0 for the six live 'date' columns — SS sys.columns
--        reports date as max_length 3 / precision 10, PG pg_attribute reports
--        attlen 4 / precision 0 (same before->after pattern as the date fields
--        in the bizapps-common backfill), so CodeGen's first PG run would
--        rewrite them.
--      * RelatedEntityNameFieldMap for the 36 FK fields whose
--        spUpdateEntityFieldRelatedEntityNameFieldMap EXECs the converter
--        dropped (values verbatim from the SS baseline EXECs; the 5 maps
--        belonging to Action Items fields are excluded).
--    NOT normalized here (deliberately, unlike the tasks/common backfills,
--    which were converted with an earlier pipeline that mangled metadata
--    literals): Type / DefaultValue / AllowsNull / Scale — the current
--    SQLConverter InsertRule carries these string literals through unchanged,
--    CodeGen's PG introspection maps PG types back to the same SS-canonical
--    vocabulary (varchar->nvarchar, uuid->uniqueidentifier, bool->bit,
--    timestamptz->datetimeoffset, int4->int, int8->bigint), and DefaultValue
--    comparison is semantic (fnNormalizeDefaultValue), so the converted values
--    are already at the fixed point.
--
-- 4. GeneratedCode registration for the single table-level CHECK-constraint
--    validator (CK_Ballot_Window: ClosesAt > OpensAt). The SS baseline INSERTs
--    this row with the SS constraint text '([ClosesAt]>[OpensAt])' and an
--    UPPERCASE LinkedRecordPrimaryKey. On PG, vwEntityFieldsWithCheckConstraints
--    joins GeneratedCode with pg_get_constraintdef(oid) = "Source" AND
--    "LinkedRecordPrimaryKey" = CAST(e."ID" AS TEXT) — the cast renders
--    lowercase and the join is case-sensitive TEXT equality — so with the
--    converted values CodeGen never matches the row and re-parses the
--    constraint through the AI pipeline (ParseCheckConstraints is the one
--    advancedGeneration feature enabled in mj.config.cjs), producing
--    nondeterministic wording on every fresh install. This group normalizes
--    Source to the PG constraint text and lowercases LinkedRecordPrimaryKey,
--    keeping Name/Code/Description at the exact wording that ships in
--    @mj-biz-apps/committees-entities. An INSERT-if-missing (pinned ID) covers
--    the case where the converted baseline INSERT did not survive.
--    The remaining 17 CHECK constraints are all single-column IN-lists:
--    on PG they are column-level (conkey length 1) and CodeGen parses them
--    natively (parsePgArrayConstraint) into EntityFieldValues — which the
--    converted baseline/RenewalIntent INSERTs already ship, alphabetically
--    sequenced exactly as syncEntityFieldValues sorts them — so they generate
--    no validators and no churn.
--
-- OMITTED GROUPS (present in a sibling, deliberately absent here):
--   * Entity icons (tasks group 2): committees' SS migrations never set
--     Entity.Icon (the baseline Entity INSERTs carry no Icon column) and icon
--     assignment comes from CodeGen's AI naming passes, which are all disabled
--     in mj.config.cjs (only ParseCheckConstraints is enabled). CodeGen's
--     first PG run therefore writes no icons; there is nothing to pin.
--   * Entity descriptions (common group 2): the baseline Entity INSERTs carry
--     the descriptions, the converter preserves them, and no later V-migration
--     touches Entity metadata (V202607072300 only deletes the Action Items
--     entity; V202607080009 is app data via SP calls). Codegen's
--     spUpdateExistingEntitiesFromSchema would only rewrite Description from
--     the table COMMENT, and those comments (converted from the SS
--     MS_Description extended properties) carry identical text — verified
--     against the baseline. No drift to pin.
--
-- VALIDATED 2026-07-22 on a fresh postgres:17 one-shot install (MJ core
-- v5.44.0 + common + tasks + committees migrate-only, no codegen). The authoring-time
-- TODO(pg-validate) items were all confirmed live:
--   1. Group 4 "Source": pg_get_constraintdef() renders CK_Ballot_Window
--      exactly as 'CHECK (("ClosesAt" > "OpensAt"))' — matched as assumed.
--      Note: on the FIRST codegen run codegen creates its own validator row
--      (Name 'ValidateClosesAtAfterOpensAt', a codegen-assigned ID) rather
--      than adopting this group's pinned ID; exactly ONE validator exists
--      (no duplicate), and a SECOND codegen run produces ZERO GeneratedCode
--      drift. So this group's ID-pin is cosmetic — the fixed point is reached
--      via codegen's own idempotency once the EntityField rows (Group 3) are
--      pinned — but it is harmless and left in for parity with the siblings.
--   2. Group 1 schema COMMENT: confirmed — the converter drops the
--      schema-level extended property, and this group's COMMENT ON SCHEMA
--      restores it (obj_description returns the text post-install), so
--      spUpdateSchemaInfoFromDatabase finds Description already equal.
--   3. Group 3 Sequence values: confirmed at the fixed point — after codegen,
--      all 222 committees EntityField rows match this file (RenewalIntent
--      Sequence=12, zero rows left at the staged +100000 values), and a
--      second codegen run drifts ZERO of the 222 rows. No duplicate entities
--      (the '<Entity>____mj_bizappscommittees' shadow-entity failure is
--      prevented by pg-finalize lowercasing SchemaName in metadata literals).
--
-- This file is .pgonly.sql: on SQL Server none of this is needed — the
-- maintenance procs run as part of the spliced CodeGen output, the schema
-- name is stored as authored, and sys.check_constraints returns the SS
-- constraint text the GeneratedCode row already carries.
-- ============================================================================
SET standard_conforming_strings = on;

-- ----------------------------------------------------------------------------
-- 1. SchemaInfo — create (fresh install) or repair (row already auto-created
--    by CodeGen). Guarded on SchemaName because SchemaInfo has a UNIQUE
--    constraint on it (IX_SchemaInfo) and CodeGen auto-creates with a random ID.
-- ----------------------------------------------------------------------------
-- Restore the schema comment the converter dropped (schema-level MS_Description
-- from the SS baseline) so vwSQLSchemas/spUpdateSchemaInfoFromDatabase see the
-- same description SchemaInfo carries.
COMMENT ON SCHEMA "__mj_bizappscommittees" IS 'Committee management app for governance, meetings, and action tracking';

INSERT INTO __mj."SchemaInfo" ("ID", "SchemaName", "EntityIDMin", "EntityIDMax", "Comments", "Description", "EntityNamePrefix", "CanonicalSchemaName")
SELECT '6AD431DD-590D-4800-9147-B44830888A44', '__mj_bizappscommittees', 1, 999999999, 'Auto-created by CodeGen. Please update EntityIDMin and EntityIDMax to appropriate values for this schema.', 'Committee management app for governance, meetings, and action tracking', 'Committees: ', '__mj_BizAppsCommittees'
WHERE NOT EXISTS (SELECT 1 FROM __mj."SchemaInfo" WHERE "SchemaName" = '__mj_bizappscommittees');

UPDATE __mj."SchemaInfo"
SET "CanonicalSchemaName" = '__mj_BizAppsCommittees',
    "EntityNamePrefix" = COALESCE("EntityNamePrefix", 'Committees: '),
    "Description" = COALESCE("Description", 'Committee management app for governance, meetings, and action tracking')
WHERE "SchemaName" = '__mj_bizappscommittees' AND "CanonicalSchemaName" IS NULL;

-- ----------------------------------------------------------------------------
-- 3. EntityField normalization (CodeGen fixed point).
--    Sequence renumbering is collision-safe under UQ_EntityField_EntityID_Sequence:
--    the converted rows all sit in CodeGen's staged zone (>= 100001), the final
--    values are all <= 22, and re-running assigns identical values.
-- ----------------------------------------------------------------------------
-- Committees: Agenda Items (d7f80482-e5ee-4dd9-abac-1f357d8a76e8) — 18 fields
UPDATE __mj."EntityField" SET "Sequence" = 1, "DefaultColumnWidth" = 150 WHERE "ID" = 'c659e73e-8fdb-4785-885a-20e4f8359722';  -- ID
UPDATE __mj."EntityField" SET "Sequence" = 2, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Meeting' WHERE "ID" = 'b41adaa9-d5b2-452e-a335-171438a6eff8';  -- MeetingID
UPDATE __mj."EntityField" SET "Sequence" = 3, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'ParentAgendaItem' WHERE "ID" = 'f3793fb0-e8be-4e77-9776-8eac87e2fd8e';  -- ParentAgendaItemID
UPDATE __mj."EntityField" SET "Sequence" = 4, "DefaultColumnWidth" = 50 WHERE "ID" = '8117b611-c4c9-42ef-9c92-6b3cdceb9bbd';  -- Sequence
UPDATE __mj."EntityField" SET "Sequence" = 5, "DefaultColumnWidth" = 150 WHERE "ID" = '7077b0cc-dcbf-4251-b2c5-c6194c02e973';  -- Name
UPDATE __mj."EntityField" SET "Sequence" = 6, "DefaultColumnWidth" = 150 WHERE "ID" = 'ccaea806-ed34-469f-81d7-3b56bcfc0e88';  -- Description
UPDATE __mj."EntityField" SET "Sequence" = 7, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'PresenterPerson' WHERE "ID" = 'a949f94a-77fa-47c7-afda-d37ffdfc4a32';  -- PresenterPersonID
UPDATE __mj."EntityField" SET "Sequence" = 8, "DefaultColumnWidth" = 50 WHERE "ID" = 'ff3eca78-2736-43bc-87ac-3909ef842caa';  -- DurationMinutes
UPDATE __mj."EntityField" SET "Sequence" = 9, "DefaultColumnWidth" = 150 WHERE "ID" = '8a910201-7941-4805-87df-6b5474738257';  -- ItemType
UPDATE __mj."EntityField" SET "Sequence" = 10, "DefaultColumnWidth" = 150 WHERE "ID" = '2d8c1cdf-a761-4729-b0d0-dafd270dddef';  -- RelatedDocumentURL
UPDATE __mj."EntityField" SET "Sequence" = 11, "DefaultColumnWidth" = 150 WHERE "ID" = '56526981-0cc5-4cc8-bbd9-df18df2d25ab';  -- Status
UPDATE __mj."EntityField" SET "Sequence" = 12, "DefaultColumnWidth" = 150 WHERE "ID" = 'fd33e31e-d634-42a2-89a4-8d32ccd22c0f';  -- Notes
UPDATE __mj."EntityField" SET "Sequence" = 13, "DefaultColumnWidth" = 100 WHERE "ID" = '4d974680-7ad5-48cf-9b55-903fd9a1d68f';  -- __mj_CreatedAt
UPDATE __mj."EntityField" SET "Sequence" = 14, "DefaultColumnWidth" = 100 WHERE "ID" = 'af9f6176-815b-4218-b75e-3b271f3d6e9e';  -- __mj_UpdatedAt
UPDATE __mj."EntityField" SET "Sequence" = 15, "DefaultColumnWidth" = 150 WHERE "ID" = '6d64b4c3-c1db-4b12-8877-94bf6c80b325';  -- Meeting (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 16, "DefaultColumnWidth" = 150 WHERE "ID" = '8c3a4e9c-fdbf-4ae3-aedd-85cb7042ff78';  -- ParentAgendaItem (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 17, "DefaultColumnWidth" = 150 WHERE "ID" = '291fa22d-a9c9-4c5b-b536-f2b1090289e2';  -- PresenterPerson (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 18, "DefaultColumnWidth" = 150 WHERE "ID" = 'ca425224-b094-42ad-8f30-909f9e6ecd6e';  -- RootParentAgendaItemID (virtual)

-- Committees: Artifact Types (07bb0f44-ec35-4caf-8c36-a766a545159d) — 8 fields
UPDATE __mj."EntityField" SET "Sequence" = 1, "DefaultColumnWidth" = 150 WHERE "ID" = '6e7a9c12-e930-4a03-8713-d21aa478a44b';  -- ID
UPDATE __mj."EntityField" SET "Sequence" = 2, "DefaultColumnWidth" = 150 WHERE "ID" = 'fcbfd0f8-4d64-43e3-81a9-9de2b11b2b87';  -- Name
UPDATE __mj."EntityField" SET "Sequence" = 3, "DefaultColumnWidth" = 150 WHERE "ID" = '06fcf459-a5a3-4979-8015-0bf1e02f79b2';  -- Description
UPDATE __mj."EntityField" SET "Sequence" = 4, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'ExtendedEntity' WHERE "ID" = '5421629f-b7b1-47a0-b29f-0c8be1f8d559';  -- ExtendedEntityID
UPDATE __mj."EntityField" SET "Sequence" = 5, "DefaultColumnWidth" = 150 WHERE "ID" = 'f1076ea8-4cc7-4c93-800e-60948ce03a24';  -- IconClass
UPDATE __mj."EntityField" SET "Sequence" = 6, "DefaultColumnWidth" = 100 WHERE "ID" = '6a1f7f5b-0295-4ab2-8f62-3fcdd4ae6e0e';  -- __mj_CreatedAt
UPDATE __mj."EntityField" SET "Sequence" = 7, "DefaultColumnWidth" = 100 WHERE "ID" = '78e7e779-c74c-4f80-99f6-897ddf89a795';  -- __mj_UpdatedAt
UPDATE __mj."EntityField" SET "Sequence" = 8, "DefaultColumnWidth" = 150 WHERE "ID" = '0682346d-e73d-4651-a144-b77bb61070b7';  -- ExtendedEntity (virtual)

-- Committees: Artifacts (272befb5-727a-4525-b235-775a56b7acbb) — 22 fields
UPDATE __mj."EntityField" SET "Sequence" = 1, "DefaultColumnWidth" = 150 WHERE "ID" = 'b0e41a0d-fc55-417e-9c25-2abcfa49efb5';  -- ID
UPDATE __mj."EntityField" SET "Sequence" = 2, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Committee' WHERE "ID" = '66b8c65f-5eac-44c1-9a76-588836334e9f';  -- CommitteeID
UPDATE __mj."EntityField" SET "Sequence" = 3, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Meeting' WHERE "ID" = 'ec872ea4-88b1-4787-90a5-144e6aabddaa';  -- MeetingID
UPDATE __mj."EntityField" SET "Sequence" = 4, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'AgendaItem' WHERE "ID" = '2d95ff9c-71fb-4fac-a742-db537c15d7d8';  -- AgendaItemID
UPDATE __mj."EntityField" SET "Sequence" = 5, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Task' WHERE "ID" = '529e01ad-5ff0-4848-b4d9-42db7f4adbd6';  -- TaskID
UPDATE __mj."EntityField" SET "Sequence" = 6, "DefaultColumnWidth" = 150 WHERE "ID" = '1ba5ff74-8897-4d4b-8331-384546572861';  -- Name
UPDATE __mj."EntityField" SET "Sequence" = 7, "DefaultColumnWidth" = 150 WHERE "ID" = '92a7dddd-0e10-4817-b704-e3aa5e972595';  -- Description
UPDATE __mj."EntityField" SET "Sequence" = 8, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'ArtifactType' WHERE "ID" = '536eebaf-5b58-4634-8dfa-252bea744994';  -- ArtifactTypeID
UPDATE __mj."EntityField" SET "Sequence" = 9, "DefaultColumnWidth" = 150 WHERE "ID" = 'e750f12d-98d2-4b8f-87d1-bf5ec239e0b5';  -- Provider
UPDATE __mj."EntityField" SET "Sequence" = 10, "DefaultColumnWidth" = 150 WHERE "ID" = '8d999a5b-603a-465e-a09a-7eca37900fe1';  -- ExternalID
UPDATE __mj."EntityField" SET "Sequence" = 11, "DefaultColumnWidth" = 150 WHERE "ID" = '2675462f-e25e-4dfb-868b-b37b9ce497c6';  -- URL
UPDATE __mj."EntityField" SET "Sequence" = 12, "DefaultColumnWidth" = 150 WHERE "ID" = 'd07d220e-e3e0-4149-b627-7eb88ccac538';  -- MimeType
UPDATE __mj."EntityField" SET "Sequence" = 13, "DefaultColumnWidth" = 150 WHERE "ID" = '7d85a684-e1a1-4670-9490-950ae349f263';  -- FileSize
UPDATE __mj."EntityField" SET "Sequence" = 14, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'UploadedByPerson' WHERE "ID" = '8a56701e-8b90-4fab-a477-39a2e489c13e';  -- UploadedByPersonID
UPDATE __mj."EntityField" SET "Sequence" = 15, "DefaultColumnWidth" = 100 WHERE "ID" = 'e3862750-3082-4c0f-9f1b-46e0bd8a22ca';  -- __mj_CreatedAt
UPDATE __mj."EntityField" SET "Sequence" = 16, "DefaultColumnWidth" = 100 WHERE "ID" = '947471d6-af61-43c9-a3cb-e734ddb0e530';  -- __mj_UpdatedAt
UPDATE __mj."EntityField" SET "Sequence" = 17, "DefaultColumnWidth" = 150 WHERE "ID" = 'd3d226c2-683c-43a3-afdb-7d4b5828b014';  -- Committee (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 18, "DefaultColumnWidth" = 150 WHERE "ID" = '219000b4-de29-476c-9df9-a5806446750d';  -- Meeting (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 19, "DefaultColumnWidth" = 150 WHERE "ID" = 'aaeb731b-d427-4c47-9a07-22f860f5ab66';  -- AgendaItem (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 20, "DefaultColumnWidth" = 150 WHERE "ID" = '7587dfed-8fc4-408d-b7dc-8b9b6d010e61';  -- Task (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 21, "DefaultColumnWidth" = 150 WHERE "ID" = '222437d8-211e-4c6d-ae70-c4ed93270ca9';  -- ArtifactType (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 22, "DefaultColumnWidth" = 150 WHERE "ID" = 'db28deb9-fec1-4c7a-a221-aca17d335707';  -- UploadedByPerson (virtual)

-- Committees: Attendances (e7d9813e-3c34-4233-afcc-4cb76cfe081c) — 11 fields
UPDATE __mj."EntityField" SET "Sequence" = 1, "DefaultColumnWidth" = 150 WHERE "ID" = '85655e4c-2d10-4dab-8db6-3869a3d3ca50';  -- ID
UPDATE __mj."EntityField" SET "Sequence" = 2, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Meeting' WHERE "ID" = '32e971c8-99de-465e-a988-0ae2a5f2dfad';  -- MeetingID
UPDATE __mj."EntityField" SET "Sequence" = 3, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Person' WHERE "ID" = 'b473a850-bbbe-4b06-88b1-ec8bb70d6a32';  -- PersonID
UPDATE __mj."EntityField" SET "Sequence" = 4, "DefaultColumnWidth" = 150 WHERE "ID" = '384c5bd0-6cf2-4bce-8864-97b3ee0437fd';  -- AttendanceStatus
UPDATE __mj."EntityField" SET "Sequence" = 5, "DefaultColumnWidth" = 100 WHERE "ID" = '01ffa5d5-6192-4018-a426-27dcac8c47cc';  -- JoinedAt
UPDATE __mj."EntityField" SET "Sequence" = 6, "DefaultColumnWidth" = 100 WHERE "ID" = '0a9aa965-00eb-45d6-874d-7b995f2942be';  -- LeftAt
UPDATE __mj."EntityField" SET "Sequence" = 7, "DefaultColumnWidth" = 150 WHERE "ID" = '0cc78126-26df-4f83-b041-293ea100f69d';  -- Notes
UPDATE __mj."EntityField" SET "Sequence" = 8, "DefaultColumnWidth" = 100 WHERE "ID" = 'a58fc00c-c527-43ec-8163-f02a230cc2aa';  -- __mj_CreatedAt
UPDATE __mj."EntityField" SET "Sequence" = 9, "DefaultColumnWidth" = 100 WHERE "ID" = '67c7de76-1574-40a3-b1d4-390c0d2d6ea4';  -- __mj_UpdatedAt
UPDATE __mj."EntityField" SET "Sequence" = 10, "DefaultColumnWidth" = 150 WHERE "ID" = 'bd6e3b75-2172-43a0-9bfc-fc58493d70af';  -- Meeting (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 11, "DefaultColumnWidth" = 150 WHERE "ID" = '63dc73f1-fde4-4b9a-9598-03bb186246c9';  -- Person (virtual)

-- Committees: Ballots (194b3496-2829-4806-bc42-cf0724a1dd26) — 15 fields
UPDATE __mj."EntityField" SET "Sequence" = 1, "DefaultColumnWidth" = 150 WHERE "ID" = '678efd82-6e1e-44d2-a420-dc9408c5747f';  -- ID
UPDATE __mj."EntityField" SET "Sequence" = 2, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Committee' WHERE "ID" = '20f7cfb0-799b-4118-90e6-c54a6462bb40';  -- CommitteeID
UPDATE __mj."EntityField" SET "Sequence" = 3, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Motion' WHERE "ID" = '9f0c32be-ae5f-49fd-9476-695204325fcf';  -- MotionID
UPDATE __mj."EntityField" SET "Sequence" = 4, "DefaultColumnWidth" = 100 WHERE "ID" = 'b7f67fc3-c3b0-476f-9c26-92800c5c2155';  -- OpensAt
UPDATE __mj."EntityField" SET "Sequence" = 5, "DefaultColumnWidth" = 100 WHERE "ID" = 'bdc1d32b-6a2e-43ef-a168-0eb4b6ec0962';  -- ClosesAt
UPDATE __mj."EntityField" SET "Sequence" = 6, "DefaultColumnWidth" = 100 WHERE "ID" = '989d0423-18e5-48f0-beac-afc087300cc4';  -- ClosedAt
UPDATE __mj."EntityField" SET "Sequence" = 7, "DefaultColumnWidth" = 150 WHERE "ID" = 'f4d30ff9-116c-4401-bcaf-a33631988bfd';  -- ThresholdType
UPDATE __mj."EntityField" SET "Sequence" = 8, "DefaultColumnWidth" = 150 WHERE "ID" = 'a01b2d79-530f-42b2-81b0-06cf90f76217';  -- IsSealed
UPDATE __mj."EntityField" SET "Sequence" = 9, "DefaultColumnWidth" = 150 WHERE "ID" = '101f8fd4-5acc-4368-84a6-cc6fed8ecc93';  -- Status
UPDATE __mj."EntityField" SET "Sequence" = 10, "DefaultColumnWidth" = 150 WHERE "ID" = 'ce3152e7-56b1-4dd0-b308-4a8490823944';  -- CreatedByMembershipID
UPDATE __mj."EntityField" SET "Sequence" = 11, "DefaultColumnWidth" = 150 WHERE "ID" = 'aaca41aa-bbdc-41c9-99cf-9a8318337864';  -- ResultNotes
UPDATE __mj."EntityField" SET "Sequence" = 12, "DefaultColumnWidth" = 100 WHERE "ID" = '2504ef54-c571-43cb-a451-b78dbd4de6ca';  -- __mj_CreatedAt
UPDATE __mj."EntityField" SET "Sequence" = 13, "DefaultColumnWidth" = 100 WHERE "ID" = 'c530fcad-fa43-44a9-86b8-7ed9e2df815d';  -- __mj_UpdatedAt
UPDATE __mj."EntityField" SET "Sequence" = 14, "DefaultColumnWidth" = 150 WHERE "ID" = '78ed7689-fae8-4ff4-9fa8-8ca8bbd56365';  -- Committee (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 15, "DefaultColumnWidth" = 150 WHERE "ID" = '85648ca7-50be-48fb-a3ac-3eb9b86f79df';  -- Motion (virtual)

-- Committees: Comments (c1cef804-aa80-47a0-9750-2a4c5227b6df) — 20 fields
UPDATE __mj."EntityField" SET "Sequence" = 1, "DefaultColumnWidth" = 150 WHERE "ID" = '1ce7d067-9ce0-4ce4-a0ac-97de46a9d883';  -- ID
UPDATE __mj."EntityField" SET "Sequence" = 2, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Committee' WHERE "ID" = 'a67dd4b3-c305-4b0a-a7a2-b0184ad7fee8';  -- CommitteeID
UPDATE __mj."EntityField" SET "Sequence" = 3, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Meeting' WHERE "ID" = '51d7d037-b163-45de-aafa-673336e89905';  -- MeetingID
UPDATE __mj."EntityField" SET "Sequence" = 4, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'AgendaItem' WHERE "ID" = 'de3ae885-3e72-4625-8390-afd515a116d1';  -- AgendaItemID
UPDATE __mj."EntityField" SET "Sequence" = 5, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Task' WHERE "ID" = '0462212d-0b87-4ec3-8bf4-6a79d1b492f0';  -- TaskID
UPDATE __mj."EntityField" SET "Sequence" = 6, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Artifact' WHERE "ID" = '29440bef-5351-477e-a826-ecc0408ce365';  -- ArtifactID
UPDATE __mj."EntityField" SET "Sequence" = 7, "DefaultColumnWidth" = 150 WHERE "ID" = '4d316764-a3c3-473b-bef5-03b6cc27699f';  -- ParentCommentID
UPDATE __mj."EntityField" SET "Sequence" = 8, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Person' WHERE "ID" = 'd3c9161b-b9fa-429c-a316-2bdaa149b19b';  -- PersonID
UPDATE __mj."EntityField" SET "Sequence" = 9, "DefaultColumnWidth" = 150 WHERE "ID" = '8e2f7fc7-f3f5-4a4a-b4f1-37ac12233872';  -- CommentText
UPDATE __mj."EntityField" SET "Sequence" = 10, "DefaultColumnWidth" = 150 WHERE "ID" = '6fb4bb9f-e6f7-4e8d-9bba-c1028c0dd5bf';  -- MentionedPersonIDs
UPDATE __mj."EntityField" SET "Sequence" = 11, "DefaultColumnWidth" = 150 WHERE "ID" = '1806da4a-563a-4edc-82ea-fb7462a496cc';  -- IsResolved
UPDATE __mj."EntityField" SET "Sequence" = 12, "DefaultColumnWidth" = 100 WHERE "ID" = 'e5daf86a-7d7f-4153-b8ba-c957ef597f5a';  -- __mj_CreatedAt
UPDATE __mj."EntityField" SET "Sequence" = 13, "DefaultColumnWidth" = 100 WHERE "ID" = '62fa5f6f-d92d-4de6-b98e-7e91a3b4e5a7';  -- __mj_UpdatedAt
UPDATE __mj."EntityField" SET "Sequence" = 14, "DefaultColumnWidth" = 150 WHERE "ID" = '89bcddc9-0ecf-4b41-b556-ba2a6d62f220';  -- Committee (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 15, "DefaultColumnWidth" = 150 WHERE "ID" = '349e60e3-e493-4b1d-b5e1-7c3803b8f9ee';  -- Meeting (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 16, "DefaultColumnWidth" = 150 WHERE "ID" = '582db1d3-a78f-4874-aaea-baa12e6cd8ce';  -- AgendaItem (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 17, "DefaultColumnWidth" = 150 WHERE "ID" = '6ca674d5-8a13-4589-9d5f-85a257e979aa';  -- Task (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 18, "DefaultColumnWidth" = 150 WHERE "ID" = '6238d3fc-f7f5-4a7a-8175-5ddf2d24631e';  -- Artifact (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 19, "DefaultColumnWidth" = 150 WHERE "ID" = '81b1e6ee-c3f7-4e81-b5bb-9ca0e0c388a8';  -- Person (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 20, "DefaultColumnWidth" = 150 WHERE "ID" = '84aa19af-a881-4563-ba3e-91b48b573150';  -- RootParentCommentID (virtual)

-- Committees: Committees (a5da88a1-aa21-4a3f-b1c4-42652fb440ce) — 18 fields
UPDATE __mj."EntityField" SET "Sequence" = 1, "DefaultColumnWidth" = 150 WHERE "ID" = 'f78ab99a-8c46-47b1-96d2-6a8fbccb1f54';  -- ID
UPDATE __mj."EntityField" SET "Sequence" = 2, "DefaultColumnWidth" = 150 WHERE "ID" = '95a27c8f-95ce-4281-8628-2a8923d7f28d';  -- Name
UPDATE __mj."EntityField" SET "Sequence" = 3, "DefaultColumnWidth" = 150 WHERE "ID" = '61486760-bb9d-4b14-9d60-d1c1440b1dad';  -- Description
UPDATE __mj."EntityField" SET "Sequence" = 4, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Type' WHERE "ID" = '1575a61c-8d36-4bdb-b686-08de0c9a9ea9';  -- TypeID
UPDATE __mj."EntityField" SET "Sequence" = 5, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'ParentCommittee' WHERE "ID" = 'd0d9d59a-0081-4b68-ae77-cd8f6d9f92f8';  -- ParentCommitteeID
UPDATE __mj."EntityField" SET "Sequence" = 6, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Organization' WHERE "ID" = 'd61b64be-b5ea-46ef-a9ed-347166f8f36c';  -- OrganizationID
UPDATE __mj."EntityField" SET "Sequence" = 7, "DefaultColumnWidth" = 150 WHERE "ID" = 'fe40d7a6-6127-41fa-9696-88d0155d9716';  -- CharterDocumentURL
UPDATE __mj."EntityField" SET "Sequence" = 8, "DefaultColumnWidth" = 150 WHERE "ID" = 'fbfccd2c-d5b9-491d-b897-20be933519c5';  -- MissionStatement
UPDATE __mj."EntityField" SET "Sequence" = 9, "DefaultColumnWidth" = 150 WHERE "ID" = 'a70fe423-7fcc-4a69-8985-8b97a412dd50';  -- Status
UPDATE __mj."EntityField" SET "Sequence" = 10, "DefaultColumnWidth" = 150 WHERE "ID" = 'f9ed6382-6221-4d3a-8ac9-32e2bf866058';  -- IsPublic
UPDATE __mj."EntityField" SET "Sequence" = 11, "Length" = 4, "Precision" = 0, "DefaultColumnWidth" = 150 WHERE "ID" = '75143a0c-ea86-48b0-85e5-7610760b35cc';  -- FormationDate
UPDATE __mj."EntityField" SET "Sequence" = 12, "Length" = 4, "Precision" = 0, "DefaultColumnWidth" = 150 WHERE "ID" = '1a7c39a9-f4fe-4ea0-b19d-c7a12491cf76';  -- DissolutionDate
UPDATE __mj."EntityField" SET "Sequence" = 13, "DefaultColumnWidth" = 100 WHERE "ID" = '89a602f9-903e-49b7-83b4-8082ba741f4a';  -- __mj_CreatedAt
UPDATE __mj."EntityField" SET "Sequence" = 14, "DefaultColumnWidth" = 100 WHERE "ID" = 'd17f2781-5a1e-422b-9c6e-0ac434ac108a';  -- __mj_UpdatedAt
UPDATE __mj."EntityField" SET "Sequence" = 15, "DefaultColumnWidth" = 150 WHERE "ID" = '14a7a47e-cd0a-489f-ba8b-9374729d3097';  -- Type (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 16, "DefaultColumnWidth" = 150 WHERE "ID" = 'c334852d-9d47-4776-acb6-aa6aaf19f7b5';  -- ParentCommittee (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 17, "DefaultColumnWidth" = 150 WHERE "ID" = 'd38909c2-4743-438a-af3c-b2c7c24ac8a0';  -- Organization (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 18, "DefaultColumnWidth" = 150 WHERE "ID" = '4c4509b1-dc45-4e49-a74b-6736533ae547';  -- RootParentCommitteeID (virtual)

-- Committees: Meetings (f7deba2d-4e28-4c6e-971b-6099217fab29) — 21 fields
UPDATE __mj."EntityField" SET "Sequence" = 1, "DefaultColumnWidth" = 150 WHERE "ID" = 'abe2aa8e-9285-4d12-bea5-b73c4aec0aed';  -- ID
UPDATE __mj."EntityField" SET "Sequence" = 2, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Committee' WHERE "ID" = '8751fe7a-1d3a-4db2-b06e-7c97cee3497f';  -- CommitteeID
UPDATE __mj."EntityField" SET "Sequence" = 3, "DefaultColumnWidth" = 150 WHERE "ID" = '53c455be-ece2-4a5b-bcc3-b0608f46b130';  -- Name
UPDATE __mj."EntityField" SET "Sequence" = 4, "DefaultColumnWidth" = 150 WHERE "ID" = 'e1e4daef-f363-45f4-aabc-d370591c2a1a';  -- Description
UPDATE __mj."EntityField" SET "Sequence" = 5, "DefaultColumnWidth" = 100 WHERE "ID" = '7cedbfbf-28f9-44dc-bb7a-635bbd932b5d';  -- StartDateTime
UPDATE __mj."EntityField" SET "Sequence" = 6, "DefaultColumnWidth" = 100 WHERE "ID" = 'cddc2788-b45f-436b-9418-3d1c33fb0bd5';  -- EndDateTime
UPDATE __mj."EntityField" SET "Sequence" = 7, "DefaultColumnWidth" = 150 WHERE "ID" = '682b8f2c-0c37-4051-b252-cc4197ed77c6';  -- TimeZone
UPDATE __mj."EntityField" SET "Sequence" = 8, "DefaultColumnWidth" = 150 WHERE "ID" = '027fdc1a-8c4c-4213-befa-0732875e3e25';  -- LocationType
UPDATE __mj."EntityField" SET "Sequence" = 9, "DefaultColumnWidth" = 150 WHERE "ID" = '7e5c7099-e886-41b8-a37c-6e6f85e51a45';  -- LocationText
UPDATE __mj."EntityField" SET "Sequence" = 10, "DefaultColumnWidth" = 150 WHERE "ID" = 'c9189dcd-9267-4746-8f35-547b8d0f2ac8';  -- VideoProvider
UPDATE __mj."EntityField" SET "Sequence" = 11, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'VideoProvider_Virtual' WHERE "ID" = 'c3669be0-0e5f-4024-ba08-6e436dc94bd5';  -- VideoProviderID
UPDATE __mj."EntityField" SET "Sequence" = 12, "DefaultColumnWidth" = 150 WHERE "ID" = '7eaca417-3d37-47f2-8fa7-99304a66e65c';  -- VideoMeetingID
UPDATE __mj."EntityField" SET "Sequence" = 13, "DefaultColumnWidth" = 150 WHERE "ID" = 'c459b220-8e93-4839-947e-27495ed94877';  -- VideoJoinURL
UPDATE __mj."EntityField" SET "Sequence" = 14, "DefaultColumnWidth" = 150 WHERE "ID" = '4759bee5-488e-448d-85f9-c6c68f461e0b';  -- VideoRecordingURL
UPDATE __mj."EntityField" SET "Sequence" = 15, "DefaultColumnWidth" = 150 WHERE "ID" = '01a2472e-275d-4aea-8558-17b8cc453c58';  -- TranscriptURL
UPDATE __mj."EntityField" SET "Sequence" = 16, "DefaultColumnWidth" = 150 WHERE "ID" = '037ff375-4775-4e79-a577-b6cac28232de';  -- Status
UPDATE __mj."EntityField" SET "Sequence" = 17, "DefaultColumnWidth" = 150 WHERE "ID" = 'bb2b27a6-e160-4550-81f5-581fa755aa40';  -- CalendarEventID
UPDATE __mj."EntityField" SET "Sequence" = 18, "DefaultColumnWidth" = 100 WHERE "ID" = 'b4410c18-7917-4d05-99e1-907ee7cb9b04';  -- __mj_CreatedAt
UPDATE __mj."EntityField" SET "Sequence" = 19, "DefaultColumnWidth" = 100 WHERE "ID" = '8ea3f939-4d93-4689-be84-e4b43d75867d';  -- __mj_UpdatedAt
UPDATE __mj."EntityField" SET "Sequence" = 20, "DefaultColumnWidth" = 150 WHERE "ID" = 'bcdde8ca-86b8-4029-841b-f9aacba9a860';  -- Committee (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 21, "DefaultColumnWidth" = 150 WHERE "ID" = 'dd64093e-bd9d-4887-a3da-06142c7628a6';  -- VideoProvider_Virtual (virtual)

-- Committees: Memberships (f8fadbbe-a323-48fb-8395-3b543729f6e6) — 15 fields
UPDATE __mj."EntityField" SET "Sequence" = 1, "DefaultColumnWidth" = 150 WHERE "ID" = 'e69216e4-1f01-4b30-b7a9-b8634870edd4';  -- ID
UPDATE __mj."EntityField" SET "Sequence" = 2, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Person' WHERE "ID" = 'f60b8d57-f085-4766-a8a3-9e5e6ccbd660';  -- PersonID
UPDATE __mj."EntityField" SET "Sequence" = 3, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Role' WHERE "ID" = '69965319-baa4-4c27-9e09-6c7240987300';  -- RoleID
UPDATE __mj."EntityField" SET "Sequence" = 4, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Term' WHERE "ID" = '80f460c9-db4a-4c4a-bb37-e2379cec2418';  -- TermID
UPDATE __mj."EntityField" SET "Sequence" = 5, "Length" = 4, "Precision" = 0, "DefaultColumnWidth" = 150 WHERE "ID" = '18068303-389a-4ef1-a7bc-ab343774e841';  -- StartDate
UPDATE __mj."EntityField" SET "Sequence" = 6, "Length" = 4, "Precision" = 0, "DefaultColumnWidth" = 150 WHERE "ID" = '3be6634d-1af5-41f4-b901-7ea68a8c6d41';  -- EndDate
UPDATE __mj."EntityField" SET "Sequence" = 7, "DefaultColumnWidth" = 150 WHERE "ID" = 'd0b81aa7-32d5-49d2-b7b4-d67872c48787';  -- Status
UPDATE __mj."EntityField" SET "Sequence" = 8, "DefaultColumnWidth" = 150 WHERE "ID" = '1410f710-4a18-4f88-b29d-6a9b608f8fa2';  -- EndReason
UPDATE __mj."EntityField" SET "Sequence" = 9, "DefaultColumnWidth" = 150 WHERE "ID" = '2e837b57-32f8-4c65-b9f5-4e5b0ab63144';  -- Notes
UPDATE __mj."EntityField" SET "Sequence" = 10, "DefaultColumnWidth" = 100 WHERE "ID" = '130cfba7-e84f-4899-a1eb-6e2c76aa442a';  -- __mj_CreatedAt
UPDATE __mj."EntityField" SET "Sequence" = 11, "DefaultColumnWidth" = 100 WHERE "ID" = '8879682e-4ce4-459a-82e3-cc084e9f73b2';  -- __mj_UpdatedAt
UPDATE __mj."EntityField" SET "Sequence" = 12, "DefaultColumnWidth" = 150 WHERE "ID" = '0a11c5f0-25bf-45b0-a299-699162195771';  -- RenewalIntent
UPDATE __mj."EntityField" SET "Sequence" = 13, "DefaultColumnWidth" = 150 WHERE "ID" = '1942c566-9f81-4a69-9498-dd9556adf77f';  -- Person (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 14, "DefaultColumnWidth" = 150 WHERE "ID" = '09f116bc-f9f7-417c-8b63-92f3f1f96875';  -- Role (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 15, "DefaultColumnWidth" = 150 WHERE "ID" = '83d223a8-a9e5-4069-9354-c7ec53d7bd76';  -- Term (virtual)

-- Committees: Minutes (0ec944f9-f908-4662-87b2-e57077a873ff) — 13 fields
UPDATE __mj."EntityField" SET "Sequence" = 1, "DefaultColumnWidth" = 150 WHERE "ID" = '0df3891e-7cf4-486a-bb88-0d101f54c6e3';  -- ID
UPDATE __mj."EntityField" SET "Sequence" = 2, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Artifact' WHERE "ID" = '1e5cd98f-1514-45d0-ae5b-7a1067ef73b8';  -- ArtifactID
UPDATE __mj."EntityField" SET "Sequence" = 3, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Meeting' WHERE "ID" = '182f76f8-27f2-4c37-9cf0-dd16f58cba1c';  -- MeetingID
UPDATE __mj."EntityField" SET "Sequence" = 4, "DefaultColumnWidth" = 150 WHERE "ID" = '1518bcfa-559c-4c3d-9a5a-1dad6bb1b13d';  -- Content
UPDATE __mj."EntityField" SET "Sequence" = 5, "DefaultColumnWidth" = 150 WHERE "ID" = '9e003073-e3d2-47e3-8bb4-be12a8e6fe2b';  -- ApprovalStatus
UPDATE __mj."EntityField" SET "Sequence" = 6, "DefaultColumnWidth" = 100 WHERE "ID" = 'e276e218-4137-41d2-b8c5-5495311bfd63';  -- ApprovedAt
UPDATE __mj."EntityField" SET "Sequence" = 7, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'ApprovedByMeeting' WHERE "ID" = 'fa2001cb-5f3b-41b2-a9c9-303c7a025bf4';  -- ApprovedByMeetingID
UPDATE __mj."EntityField" SET "Sequence" = 8, "DefaultColumnWidth" = 150 WHERE "ID" = 'fc524b9d-e1b0-4718-9c86-8e016a53dfe0';  -- Notes
UPDATE __mj."EntityField" SET "Sequence" = 9, "DefaultColumnWidth" = 100 WHERE "ID" = '0bf38e31-e7eb-4feb-95f4-a2362c797de1';  -- __mj_CreatedAt
UPDATE __mj."EntityField" SET "Sequence" = 10, "DefaultColumnWidth" = 100 WHERE "ID" = '2352766c-ddb1-409e-b2cf-c29f08526d30';  -- __mj_UpdatedAt
UPDATE __mj."EntityField" SET "Sequence" = 11, "DefaultColumnWidth" = 150 WHERE "ID" = '0cc86c4a-607d-4973-8f6f-a30974df0d38';  -- Artifact (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 12, "DefaultColumnWidth" = 150 WHERE "ID" = '6c604d19-aeeb-4ee9-bcc9-bee9b4fb1754';  -- Meeting (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 13, "DefaultColumnWidth" = 150 WHERE "ID" = 'da3df5bc-0d04-46e0-ab75-6c3b18c86caa';  -- ApprovedByMeeting (virtual)

-- Committees: Motions (aaaee71b-d7cf-4628-bed0-59d43256e46a) — 18 fields
UPDATE __mj."EntityField" SET "Sequence" = 1, "DefaultColumnWidth" = 150 WHERE "ID" = 'e54efe89-a3e3-4b11-8a95-faa48d134d21';  -- ID
UPDATE __mj."EntityField" SET "Sequence" = 2, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Meeting' WHERE "ID" = '18e4a1b6-f158-4eda-87ef-1d12af630bb6';  -- MeetingID
UPDATE __mj."EntityField" SET "Sequence" = 3, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'AgendaItem' WHERE "ID" = '00099c83-c202-489f-b975-8f97fb844e68';  -- AgendaItemID
UPDATE __mj."EntityField" SET "Sequence" = 4, "DefaultColumnWidth" = 50 WHERE "ID" = '4da9d19e-62c7-447f-af30-8a5c9dbb2a08';  -- Sequence
UPDATE __mj."EntityField" SET "Sequence" = 5, "DefaultColumnWidth" = 150 WHERE "ID" = 'b854120d-9680-4155-8e70-6164a437e7d7';  -- Name
UPDATE __mj."EntityField" SET "Sequence" = 6, "DefaultColumnWidth" = 150 WHERE "ID" = '6f0a62c9-da2e-42d4-9228-24b3084910e7';  -- Description
UPDATE __mj."EntityField" SET "Sequence" = 7, "DefaultColumnWidth" = 150 WHERE "ID" = '0d0a1c9c-e69a-4c4d-828b-6e2ed76ac569';  -- MovedByMembershipID
UPDATE __mj."EntityField" SET "Sequence" = 8, "DefaultColumnWidth" = 150 WHERE "ID" = '8887c47d-72da-49da-a8de-24fa3b5b7b0a';  -- SecondedByMembershipID
UPDATE __mj."EntityField" SET "Sequence" = 9, "DefaultColumnWidth" = 150 WHERE "ID" = '218be2b4-659f-479f-8495-e7a5f4bdd60a';  -- Result
UPDATE __mj."EntityField" SET "Sequence" = 10, "DefaultColumnWidth" = 150 WHERE "ID" = '289a9cc7-8371-4aef-9bdc-31d330e08b41';  -- ResultSummary
UPDATE __mj."EntityField" SET "Sequence" = 11, "DefaultColumnWidth" = 50 WHERE "ID" = '9093e53c-cc9a-43e9-bbc0-65493565adf0';  -- YesCount
UPDATE __mj."EntityField" SET "Sequence" = 12, "DefaultColumnWidth" = 50 WHERE "ID" = 'b2b94f3b-cac1-4f57-91c5-7b9dc9f47a89';  -- NoCount
UPDATE __mj."EntityField" SET "Sequence" = 13, "DefaultColumnWidth" = 50 WHERE "ID" = '33148733-1b4f-4116-91ee-ded04b2f6226';  -- AbstainCount
UPDATE __mj."EntityField" SET "Sequence" = 14, "DefaultColumnWidth" = 150 WHERE "ID" = '19a8621f-7989-40bb-ae76-cbdafae23f80';  -- Notes
UPDATE __mj."EntityField" SET "Sequence" = 15, "DefaultColumnWidth" = 100 WHERE "ID" = 'b17eed2b-e79c-44ea-822a-7fdf8899ad5a';  -- __mj_CreatedAt
UPDATE __mj."EntityField" SET "Sequence" = 16, "DefaultColumnWidth" = 100 WHERE "ID" = 'b2480833-9c99-4102-a8a3-75fb58f1d88e';  -- __mj_UpdatedAt
UPDATE __mj."EntityField" SET "Sequence" = 17, "DefaultColumnWidth" = 150 WHERE "ID" = '4a2c2d5f-ad3f-45c3-baab-9e2cd2bb2152';  -- Meeting (virtual)
UPDATE __mj."EntityField" SET "Sequence" = 18, "DefaultColumnWidth" = 150 WHERE "ID" = '155fb857-95fd-4a12-a977-ca38b16287f2';  -- AgendaItem (virtual)

-- Committees: Roles (9bedcbe8-0ef8-4f86-ab72-2063ce41a138) — 9 fields
UPDATE __mj."EntityField" SET "Sequence" = 1, "DefaultColumnWidth" = 150 WHERE "ID" = 'edf71d72-0fbf-431b-9cf7-f94203f56ee9';  -- ID
UPDATE __mj."EntityField" SET "Sequence" = 2, "DefaultColumnWidth" = 150 WHERE "ID" = '05a46dd1-b38f-4f88-9ff3-19ae9e079909';  -- Name
UPDATE __mj."EntityField" SET "Sequence" = 3, "DefaultColumnWidth" = 150 WHERE "ID" = '437f2813-c32c-4bb0-bc8f-583a0be4400b';  -- Description
UPDATE __mj."EntityField" SET "Sequence" = 4, "DefaultColumnWidth" = 150 WHERE "ID" = '34365ec2-428c-4eb1-8658-1b55063b09ce';  -- IsOfficer
UPDATE __mj."EntityField" SET "Sequence" = 5, "DefaultColumnWidth" = 150 WHERE "ID" = '00919dc2-5cd5-4f13-af78-dbccf7700163';  -- IsVotingRole
UPDATE __mj."EntityField" SET "Sequence" = 6, "DefaultColumnWidth" = 150 WHERE "ID" = 'f67f8414-29bc-409d-afa3-f93c01110f0c';  -- DefaultPermissionsJSON
UPDATE __mj."EntityField" SET "Sequence" = 7, "DefaultColumnWidth" = 50 WHERE "ID" = '14288471-75db-490c-949a-ef335d110bd5';  -- Sequence
UPDATE __mj."EntityField" SET "Sequence" = 8, "DefaultColumnWidth" = 100 WHERE "ID" = '3ab43781-c365-4bbc-91de-eaeae83e5cdf';  -- __mj_CreatedAt
UPDATE __mj."EntityField" SET "Sequence" = 9, "DefaultColumnWidth" = 100 WHERE "ID" = 'c647b51e-f912-455d-a2ee-83a9452286f8';  -- __mj_UpdatedAt

-- Committees: Terms (87bedfa6-f149-4af2-993c-81bd01169584) — 9 fields
UPDATE __mj."EntityField" SET "Sequence" = 1, "DefaultColumnWidth" = 150 WHERE "ID" = 'e19536f8-37d2-44eb-accd-c824b1027b5e';  -- ID
UPDATE __mj."EntityField" SET "Sequence" = 2, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Committee' WHERE "ID" = 'e3a9a5af-6660-43b8-bc3c-29c190bdd846';  -- CommitteeID
UPDATE __mj."EntityField" SET "Sequence" = 3, "DefaultColumnWidth" = 150 WHERE "ID" = 'b6dac16d-3717-462a-bd1a-6db3c3dec2e6';  -- Name
UPDATE __mj."EntityField" SET "Sequence" = 4, "Length" = 4, "Precision" = 0, "DefaultColumnWidth" = 150 WHERE "ID" = 'f60e3828-a7ca-4e84-9688-0ca94f40aeef';  -- StartDate
UPDATE __mj."EntityField" SET "Sequence" = 5, "Length" = 4, "Precision" = 0, "DefaultColumnWidth" = 150 WHERE "ID" = 'bf5dc428-4999-4e4c-b224-36d068c1d5c3';  -- EndDate
UPDATE __mj."EntityField" SET "Sequence" = 6, "DefaultColumnWidth" = 150 WHERE "ID" = '39881813-0d5c-4a1e-b555-073757db66ab';  -- Status
UPDATE __mj."EntityField" SET "Sequence" = 7, "DefaultColumnWidth" = 100 WHERE "ID" = '6a3d40d1-f246-4ee0-8aa6-908607b8c092';  -- __mj_CreatedAt
UPDATE __mj."EntityField" SET "Sequence" = 8, "DefaultColumnWidth" = 100 WHERE "ID" = 'b69ee0eb-4b77-4bff-bc37-2a3b82097c6a';  -- __mj_UpdatedAt
UPDATE __mj."EntityField" SET "Sequence" = 9, "DefaultColumnWidth" = 150 WHERE "ID" = '64c60af8-9e2f-461f-88f1-ed4ec44e8123';  -- Committee (virtual)

-- Committees: Types (93c97937-a33b-41d2-9791-fc271e49f96f) — 8 fields
UPDATE __mj."EntityField" SET "Sequence" = 1, "DefaultColumnWidth" = 150 WHERE "ID" = '4700115b-6ec6-4e51-a927-9361b44b70eb';  -- ID
UPDATE __mj."EntityField" SET "Sequence" = 2, "DefaultColumnWidth" = 150 WHERE "ID" = 'c3c2a890-f56e-42f5-b7a2-364c153eabdc';  -- Name
UPDATE __mj."EntityField" SET "Sequence" = 3, "DefaultColumnWidth" = 150 WHERE "ID" = '3cab0bce-aa9d-4b03-99dd-779dbc22e49c';  -- Description
UPDATE __mj."EntityField" SET "Sequence" = 4, "DefaultColumnWidth" = 150 WHERE "ID" = 'b5cf3e99-8fa9-4a07-a3b0-8d40b7fd7d1e';  -- IsStandards
UPDATE __mj."EntityField" SET "Sequence" = 5, "DefaultColumnWidth" = 50 WHERE "ID" = 'eac52b31-e315-400b-8d2e-73d2c9ec3412';  -- DefaultTermMonths
UPDATE __mj."EntityField" SET "Sequence" = 6, "DefaultColumnWidth" = 150 WHERE "ID" = '0d2f5bf8-8762-4b5c-9b71-db1acbbb7475';  -- IconClass
UPDATE __mj."EntityField" SET "Sequence" = 7, "DefaultColumnWidth" = 100 WHERE "ID" = '982cb9b9-9b4c-4ad4-957d-b2f3252cc5c4';  -- __mj_CreatedAt
UPDATE __mj."EntityField" SET "Sequence" = 8, "DefaultColumnWidth" = 100 WHERE "ID" = '5129f91f-7cff-426f-8d3d-4d6e475cdc80';  -- __mj_UpdatedAt

-- Committees: Video Providers (f11b4dc5-9850-4782-b3a1-7d2277a19837) — 9 fields
UPDATE __mj."EntityField" SET "Sequence" = 1, "DefaultColumnWidth" = 150 WHERE "ID" = 'a1e4b952-61d7-446a-a212-341b3ceba00e';  -- ID
UPDATE __mj."EntityField" SET "Sequence" = 2, "DefaultColumnWidth" = 150 WHERE "ID" = 'a7474b89-d513-46ea-b66c-5c6cc5ecb00c';  -- Name
UPDATE __mj."EntityField" SET "Sequence" = 3, "DefaultColumnWidth" = 150 WHERE "ID" = 'b9a15d44-dc70-4967-8ef1-0d9d91aaa071';  -- ServerDriverKey
UPDATE __mj."EntityField" SET "Sequence" = 4, "DefaultColumnWidth" = 150 WHERE "ID" = '0f9b9ce8-200d-4ac8-8894-521bad32497b';  -- IsActive
UPDATE __mj."EntityField" SET "Sequence" = 5, "DefaultColumnWidth" = 150 WHERE "ID" = 'ad3ac309-867a-4fdb-92d2-62020a18f60a';  -- IsDefault
UPDATE __mj."EntityField" SET "Sequence" = 6, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Credential' WHERE "ID" = 'a375944c-fa58-4825-add9-d3bc7f85815d';  -- CredentialID
UPDATE __mj."EntityField" SET "Sequence" = 7, "DefaultColumnWidth" = 100 WHERE "ID" = '398fae9f-ebed-4be3-b308-4efcae4384e9';  -- __mj_CreatedAt
UPDATE __mj."EntityField" SET "Sequence" = 8, "DefaultColumnWidth" = 100 WHERE "ID" = 'f2a01211-e621-4fe7-995d-62f9a96105db';  -- __mj_UpdatedAt
UPDATE __mj."EntityField" SET "Sequence" = 9, "DefaultColumnWidth" = 150 WHERE "ID" = '70916604-9547-4a69-b893-c897623b229f';  -- Credential (virtual)

-- Committees: Votes (94a59079-7436-4178-a31b-9b42dda822c1) — 8 fields
UPDATE __mj."EntityField" SET "Sequence" = 1, "DefaultColumnWidth" = 150 WHERE "ID" = '47a0f435-b32a-4941-8e97-3d57b94dbcc1';  -- ID
UPDATE __mj."EntityField" SET "Sequence" = 2, "DefaultColumnWidth" = 150, "RelatedEntityNameFieldMap" = 'Motion' WHERE "ID" = '73149db6-9be2-4edf-9d02-46b78e096211';  -- MotionID
UPDATE __mj."EntityField" SET "Sequence" = 3, "DefaultColumnWidth" = 150 WHERE "ID" = '42852469-955c-4129-964a-2e98e987426c';  -- MembershipID
UPDATE __mj."EntityField" SET "Sequence" = 4, "DefaultColumnWidth" = 150 WHERE "ID" = 'd7477465-d420-4905-b722-00b8794609de';  -- VoteValue
UPDATE __mj."EntityField" SET "Sequence" = 5, "DefaultColumnWidth" = 150 WHERE "ID" = '437aaf52-2ad6-4413-9fda-b8a8274a251a';  -- Notes
UPDATE __mj."EntityField" SET "Sequence" = 6, "DefaultColumnWidth" = 100 WHERE "ID" = 'c29b4a82-3db3-4bf2-b104-905b1a0fdc5e';  -- __mj_CreatedAt
UPDATE __mj."EntityField" SET "Sequence" = 7, "DefaultColumnWidth" = 100 WHERE "ID" = '0d41978d-105f-47cd-be8a-2b108a5f49a3';  -- __mj_UpdatedAt
UPDATE __mj."EntityField" SET "Sequence" = 8, "DefaultColumnWidth" = 150 WHERE "ID" = '9add5112-5031-4b7c-863c-4cef0f4ba8ae';  -- Motion (virtual)

-- ----------------------------------------------------------------------------
-- 3b. EntityField.Type normalization to the SS-canonical vocabulary.
--     The converted baseline/RenewalIntent INSERTs carry PG-native type names
--     (UUID, TEXT, INTEGER, BOOLEAN, TIMESTAMPTZ). CodeGen at MJ core v5.44
--     left these untouched (validated no-op 2026-07-22), but v5.45 normalizes
--     EntityField.Type to the SS-canonical names — confirmed live: a v5.45
--     codegen run rewrote exactly these 176 rows (uniqueidentifier/int/
--     nvarchar/bit/datetimeoffset) and NOTHING else (zero function/view/
--     trigger drift). Pin the canonical values here so codegen stays a no-op.
--     Scoped to PHYSICAL columns ("IsVirtual" = FALSE): v5.45 codegen keeps
--     PG-native names (TEXT/UUID) for the view-join virtual fields while
--     normalizing physical columns to SS-canonical — confirmed live both ways.
--     Set-based and idempotent; 'date' columns already match and are untouched.
-- ----------------------------------------------------------------------------
UPDATE __mj."EntityField" ef SET "Type" = 'uniqueidentifier' FROM __mj."Entity" e WHERE ef."EntityID" = e."ID" AND e."SchemaName" = '__mj_bizappscommittees' AND ef."IsVirtual" = FALSE AND ef."Type" = 'UUID';
UPDATE __mj."EntityField" ef SET "Type" = 'nvarchar'         FROM __mj."Entity" e WHERE ef."EntityID" = e."ID" AND e."SchemaName" = '__mj_bizappscommittees' AND ef."IsVirtual" = FALSE AND ef."Type" = 'TEXT';
UPDATE __mj."EntityField" ef SET "Type" = 'int'              FROM __mj."Entity" e WHERE ef."EntityID" = e."ID" AND e."SchemaName" = '__mj_bizappscommittees' AND ef."IsVirtual" = FALSE AND ef."Type" = 'INTEGER';
UPDATE __mj."EntityField" ef SET "Type" = 'bit'              FROM __mj."Entity" e WHERE ef."EntityID" = e."ID" AND e."SchemaName" = '__mj_bizappscommittees' AND ef."IsVirtual" = FALSE AND ef."Type" = 'BOOLEAN';
UPDATE __mj."EntityField" ef SET "Type" = 'datetimeoffset'   FROM __mj."Entity" e WHERE ef."EntityID" = e."ID" AND e."SchemaName" = '__mj_bizappscommittees' AND ef."IsVirtual" = FALSE AND ef."Type" = 'TIMESTAMPTZ';

-- ----------------------------------------------------------------------------
-- 4. GeneratedCode — Ballots window validator (CK_Ballot_Window).
--    Normalize the row the converted baseline inserted (SS Source text,
--    uppercase LinkedRecordPrimaryKey) to the PG lookup form; insert it with a
--    pinned ID if it is missing. Name/Code/Description are verbatim from the
--    SS baseline (the wording shipped in @mj-biz-apps/committees-entities).
--    ID D09B2FB5-0A7E-418B-A5B3-83CB466431CA pinned at authoring time (the SS
--    baseline INSERT carries no ID column, so there is no SS ID to reuse).
-- ----------------------------------------------------------------------------
-- TODO(pg-validate): confirm pg_get_constraintdef() renders the converted
-- CK_Ballot_Window exactly as 'CHECK (("ClosesAt" > "OpensAt"))' on the first
-- live PG install; adjust "Source" here if it differs.
UPDATE __mj."GeneratedCode"
SET "Source" = 'CHECK (("ClosesAt" > "OpensAt"))',
    "LinkedRecordPrimaryKey" = '194b3496-2829-4806-bc42-cf0724a1dd26'
WHERE "Name" = 'ValidateClosesAtAfterOpensAt'
  AND "LinkedEntityID" = 'E0238F34-2837-EF11-86D4-6045BDEE16E6'
  AND LOWER("LinkedRecordPrimaryKey") = '194b3496-2829-4806-bc42-cf0724a1dd26';

INSERT INTO __mj."GeneratedCode" ("ID", "CategoryID", "GeneratedByModelID", "GeneratedAt", "Language", "Status", "Source", "Code", "Description", "Name", "LinkedEntityID", "LinkedRecordPrimaryKey")
SELECT 'D09B2FB5-0A7E-418B-A5B3-83CB466431CA', c."ID", '8E1BADD5-D593-4F9B-90D4-BF6D8AFA74A0', NOW(), 'TypeScript', 'Approved', 'CHECK (("ClosesAt" > "OpensAt"))', 'public ValidateClosesAtAfterOpensAt(result: ValidationResult) {
	// Both OpensAt and ClosesAt are required fields, but we still guard against unexpected nulls
	if (this.OpensAt != null && this.ClosesAt != null && !(this.ClosesAt > this.OpensAt)) {
		result.Errors.push(new ValidationErrorInfo(
			"ClosesAt",
			"Closing time must be after opening time.",
			this.ClosesAt,
			ValidationErrorType.Failure
		));
	}
}', 'The closing time must be later than the opening time, ensuring that a voting period cannot end before it starts.', 'ValidateClosesAtAfterOpensAt', 'E0238F34-2837-EF11-86D4-6045BDEE16E6', '194b3496-2829-4806-bc42-cf0724a1dd26'
FROM __mj."vwGeneratedCodeCategories" c
WHERE c."Name" = 'CodeGen: Validators'
  AND NOT EXISTS (
    SELECT 1 FROM __mj."GeneratedCode" gc
    WHERE gc."Name" = 'ValidateClosesAtAfterOpensAt'
      AND gc."LinkedEntityID" = 'E0238F34-2837-EF11-86D4-6045BDEE16E6'
      AND LOWER(gc."LinkedRecordPrimaryKey") = '194b3496-2829-4806-bc42-cf0724a1dd26'
  );
