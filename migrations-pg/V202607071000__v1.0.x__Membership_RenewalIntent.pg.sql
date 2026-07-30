-- ============================================================================
-- MemberJunction PostgreSQL Migration
-- Converted from SQL Server using TypeScript conversion pipeline
-- ============================================================================

-- Extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Schema
CREATE SCHEMA IF NOT EXISTS __mj_BizAppsCommittees;
SET search_path TO __mj_BizAppsCommittees, public;

-- Ensure backslashes in string literals are treated literally (not as escape sequences)
SET standard_conforming_strings = on;

-- NOTE: Earlier converter versions made INTEGER to BOOLEAN cast implicit by
-- modifying the system catalog so SS-style INSERT INTO bool_col VALUES (1)
-- would work. That modification required pg_catalog write privileges, which
-- managed PG (RDS, Aurora, Cloud SQL, Azure) does not grant. As of v5.30 all
-- bulk INSERTs are emitted with native TRUE/FALSE values directly, so the
-- cast modification is no longer needed. Removed to support managed-PG
-- installs out of the box.


-- ===================== DDL: Tables, PKs, Indexes =====================

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = '__mj_bizappscommittees' AND table_name = 'Membership' AND column_name = 'RenewalIntent'
    ) THEN
        ALTER TABLE __mj_BizAppsCommittees."Membership"
        ADD "RenewalIntent" VARCHAR(20) NULL
        CONSTRAINT "CK_Membership_RenewalIntent" CHECK ("RenewalIntent" IN ('Yes', 'No', 'Undecided'));
    END IF;
END $$;

COMMENT ON COLUMN __mj_BizAppsCommittees."Membership"."RenewalIntent" IS 'The member''s stated intent to serve another term (Yes, No, Undecided), captured via Member Home self-service; NULL = not yet answered. Feeds the People & Terms succession pipeline.';

CREATE INDEX IF NOT EXISTS "IDX_AUTO_MJ_FKEY_Membership_PersonID" ON __mj_BizAppsCommittees."Membership" ("PersonID");

CREATE INDEX IF NOT EXISTS "IDX_AUTO_MJ_FKEY_Membership_RoleID" ON __mj_BizAppsCommittees."Membership" ("RoleID");

CREATE INDEX IF NOT EXISTS "IDX_AUTO_MJ_FKEY_Membership_TermID" ON __mj_BizAppsCommittees."Membership" ("TermID");


-- ===================== Views =====================

DROP VIEW IF EXISTS __mj_BizAppsCommittees."vwMemberships" CASCADE;
DO $do$
DECLARE
  v_target_schema CONSTANT TEXT := '__mj_bizappscommittees';
  v_target_name CONSTANT TEXT := 'vwMemberships';
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW __mj_BizAppsCommittees."vwMemberships"
AS SELECT
    m.*,
    "mjBizAppsCommonPerson_PersonID"."DisplayName" AS "Person",
    "mjBizAppsCommitteesRole_RoleID"."Name" AS "Role",
    "mjBizAppsCommitteesTerm_TermID"."Name" AS "Term"
FROM
    __mj_BizAppsCommittees."Membership" AS m
INNER JOIN
    __mj_BizAppsCommon."Person" AS "mjBizAppsCommonPerson_PersonID"
  ON
    m."PersonID" = "mjBizAppsCommonPerson_PersonID"."ID"
INNER JOIN
    __mj_BizAppsCommittees."Role" AS "mjBizAppsCommitteesRole_RoleID"
  ON
    m."RoleID" = "mjBizAppsCommitteesRole_RoleID"."ID"
INNER JOIN
    __mj_BizAppsCommittees."Term" AS "mjBizAppsCommitteesTerm_TermID"
  ON
    m."TermID" = "mjBizAppsCommitteesTerm_TermID"."ID"$vsql$;
  v_target_oid OID;
  v_dep RECORD;
  v_captured JSONB[] := ARRAY[]::JSONB[];
  v_n INTEGER;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- Column list changed; need CASCADE. Preserve dependent views first.
  SELECT c.oid INTO v_target_oid
  FROM pg_class c JOIN pg_namespace n ON c.relnamespace = n.oid
  WHERE n.nspname = v_target_schema AND c.relname = v_target_name AND c.relkind = 'v';
  IF v_target_oid IS NOT NULL THEN
    FOR v_dep IN
      WITH RECURSIVE deps AS (
        SELECT c.oid, c.relname AS name, n.nspname AS schema, 1 AS depth
        FROM pg_rewrite r
        JOIN pg_depend d ON d.objid = r.oid
        JOIN pg_class c ON c.oid = r.ev_class
        JOIN pg_namespace n ON c.relnamespace = n.oid
        WHERE d.refobjid = v_target_oid AND d.deptype = 'n'
          AND c.oid <> v_target_oid AND c.relkind = 'v'
        UNION
        SELECT c.oid, c.relname, n.nspname, p.depth + 1
        FROM deps p
        JOIN pg_rewrite r ON TRUE
        JOIN pg_depend d ON d.objid = r.oid AND d.refobjid = p.oid
        JOIN pg_class c ON c.oid = r.ev_class
        JOIN pg_namespace n ON c.relnamespace = n.oid
        WHERE c.relkind = 'v' AND c.oid <> p.oid
      )
      SELECT oid, name, schema, MAX(depth) AS max_depth,
             pg_catalog.pg_get_viewdef(oid, true) AS viewdef
      FROM deps GROUP BY oid, name, schema
      ORDER BY MAX(depth) ASC
    LOOP
      v_captured := v_captured || jsonb_build_object(
        'schema', v_dep.schema, 'name', v_dep.name, 'def', v_dep.viewdef);
    END LOOP;
  END IF;
  EXECUTE format('DROP VIEW IF EXISTS %I.%I CASCADE', v_target_schema, v_target_name);
  EXECUTE vsql;
  IF v_captured IS NOT NULL AND array_length(v_captured, 1) > 0 THEN
    FOR v_n IN 1..array_length(v_captured, 1) LOOP
      BEGIN
        EXECUTE format('CREATE VIEW %I.%I AS %s',
          v_captured[v_n]->>'schema', v_captured[v_n]->>'name', v_captured[v_n]->>'def');
      EXCEPTION WHEN others THEN
        RAISE WARNING 'Could not restore dependent view %.%: %',
          v_captured[v_n]->>'schema', v_captured[v_n]->>'name', SQLERRM;
      END;
    END LOOP;
  END IF;
END;
$do$;


-- ===================== Stored Procedures (sp*) =====================

-- SKIPPED: procedure (auto-conversion not supported)
-- CREATE PROCEDURE [__mj_BizAppsCommittees].[spCreateMembership]
--     @ID UUID = NULL,
--     @PersonID UUID,
--     @RoleID UUID,
--     @TermID UUID,
--     @StartDa...

-- SKIPPED: procedure (auto-conversion not supported)
-- CREATE PROCEDURE [__mj_BizAppsCommittees].[spUpdateMembership]
--     @ID UUID,
--     @PersonID UUID = NULL,
--     @RoleID UUID = NULL,
--     @TermID UUID = NULL...

-- SKIPPED: procedure (auto-conversion not supported)
-- CREATE PROCEDURE [__mj_BizAppsCommittees].[spDeleteMembership]
--     @ID UUID
-- AS
-- BEGIN
--     SET NOCOUNT ON;
-- 
--     DELETE FROM
--         [__mj_BizAppsCommittees].[Membership]
--     WHERE
--         [I...


-- ===================== Triggers =====================

-- SKIPPED: trigger (auto-conversion not supported)
-- CREATE TRIGGER [__mj_BizAppsCommittees].trgUpdateMembership
-- ON __mj_BizAppsCommittees."Membership"
-- AFTER UPDATE
-- AS
-- BEGIN
--     SET NOCOUNT ON;
--     UPDATE
--         __mj_BizAppsCommittees."Membership"


-- ===================== Data (INSERT/UPDATE/DELETE) =====================

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM "${mjSchema}"."EntityField" WHERE "ID" = '0a11c5f0-25bf-45b0-a299-699162195771' OR ("EntityID" = 'F8FADBBE-A323-48FB-8395-3B543729F6E6' AND "Name" = 'RenewalIntent')
    ) THEN
        INSERT INTO "${mjSchema}"."EntityField"
        (
        "ID",
        "EntityID",
        "Sequence",
        "Name",
        "DisplayName",
        "Description",
        "Type",
        "Length",
        "Precision",
        "Scale",
        "AllowsNull",
        "DefaultValue",
        "AutoIncrement",
        "AllowUpdateAPI",
        "IsVirtual",
        "IsComputed",
        "RelatedEntityID",
        "RelatedEntityFieldName",
        "IsNameField",
        "IncludeInUserSearchAPI",
        "IncludeRelatedEntityNameFieldInBaseView",
        "DefaultInView",
        "IsPrimaryKey",
        "IsUnique",
        "RelatedEntityDisplayType",
        "__mj_CreatedAt",
        "__mj_UpdatedAt"
        )
        VALUES
        (
        '0a11c5f0-25bf-45b0-a299-699162195771',
        'F8FADBBE-A323-48FB-8395-3B543729F6E6', -- "Entity": "Committees": "Memberships"
        100026,
        'RenewalIntent',
        'Renewal Intent',
        'The member''s stated intent to serve another term (Yes, No, Undecided), captured via Member Home self-service; NULL = not yet answered. Feeds the People & Terms succession pipeline.',
        'TEXT',
        40,
        0,
        0,
        TRUE,
        NULL,
        FALSE,
        TRUE,
        FALSE,
        FALSE,
        NULL,
        NULL,
        FALSE,
        FALSE,
        FALSE,
        FALSE,
        FALSE,
        FALSE,
        'Search',
        NOW(),
        NOW()
        );
    END IF;
END $$;

INSERT INTO "${mjSchema}"."EntityFieldValue"
                                       ("ID", "EntityFieldID", "Sequence", "Value", "Code", "__mj_CreatedAt", "__mj_UpdatedAt")
                                    VALUES
                                       ('f02aaadf-3b5d-4d0e-ba2e-2e92c7a7b1ae', '0A11C5F0-25BF-45B0-A299-699162195771', 1, 'No', 'No', NOW(), NOW());

/* SQL text to insert entity field value with ID 081eadff-20f2-495a-9ccb-c2c8d9fe495c */

INSERT INTO "${mjSchema}"."EntityFieldValue"
                                       ("ID", "EntityFieldID", "Sequence", "Value", "Code", "__mj_CreatedAt", "__mj_UpdatedAt")
                                    VALUES
                                       ('081eadff-20f2-495a-9ccb-c2c8d9fe495c', '0A11C5F0-25BF-45B0-A299-699162195771', 2, 'Undecided', 'Undecided', NOW(), NOW());

/* SQL text to insert entity field value with ID c4a96028-203c-4048-9462-b7116f19d108 */

INSERT INTO "${mjSchema}"."EntityFieldValue"
                                       ("ID", "EntityFieldID", "Sequence", "Value", "Code", "__mj_CreatedAt", "__mj_UpdatedAt")
                                    VALUES
                                       ('c4a96028-203c-4048-9462-b7116f19d108', '0A11C5F0-25BF-45B0-A299-699162195771', 3, 'Yes', 'Yes', NOW(), NOW());

/* SQL text to update ValueListType for entity field ID 0A11C5F0-25BF-45B0-A299-699162195771 */

UPDATE "${mjSchema}"."EntityField" SET "ValueListType"='List' WHERE "ID"='0A11C5F0-25BF-45B0-A299-699162195771';

/* SQL text to sync schema info from database schemas */


-- ===================== Grants =====================

DO $$ BEGIN GRANT SELECT ON __mj_BizAppsCommittees."vwMemberships" TO "cdp_UI", "cdp_Developer", "cdp_Integration"; EXCEPTION WHEN others THEN NULL; END $$;
/* Base View Permissions SQL for Committees: Memberships */
-----------------------------------------------------------------
-- SQL Code Generation
-- Entity: Committees: Memberships
-- Item: Permissions for vwMemberships
--
-- This was generated by the MemberJunction CodeGen tool.
-- This file should NOT be edited by hand.
-----------------------------------------------------------------;

DO $$ BEGIN GRANT SELECT ON __mj_BizAppsCommittees."vwMemberships" TO "cdp_UI", "cdp_Developer", "cdp_Integration"; EXCEPTION WHEN others THEN NULL; END $$;
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
------------------------------------------------------------;

DO $$ BEGIN GRANT EXECUTE ON FUNCTION __mj_BizAppsCommittees."spCreateMembership" TO "cdp_Developer", "cdp_Integration"; EXCEPTION WHEN others THEN NULL; END $$;
/* spCreate Permissions for Committees: Memberships */

DO $$ BEGIN GRANT EXECUTE ON FUNCTION __mj_BizAppsCommittees."spCreateMembership" TO "cdp_Developer", "cdp_Integration"; EXCEPTION WHEN others THEN NULL; END $$;
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
------------------------------------------------------------;

DO $$ BEGIN GRANT EXECUTE ON FUNCTION __mj_BizAppsCommittees."spUpdateMembership" TO "cdp_Developer", "cdp_Integration"; EXCEPTION WHEN others THEN NULL; END $$;
DO $$ BEGIN GRANT EXECUTE ON FUNCTION __mj_BizAppsCommittees."spUpdateMembership" TO "cdp_Developer", "cdp_Integration"; EXCEPTION WHEN others THEN NULL; END $$;
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
------------------------------------------------------------;

DO $$ BEGIN GRANT EXECUTE ON FUNCTION __mj_BizAppsCommittees."spDeleteMembership" TO "cdp_Developer", "cdp_Integration"; EXCEPTION WHEN others THEN NULL; END $$;
/* spDelete Permissions for Committees: Memberships */

DO $$ BEGIN GRANT EXECUTE ON FUNCTION __mj_BizAppsCommittees."spDeleteMembership" TO "cdp_Developer", "cdp_Integration"; EXCEPTION WHEN others THEN NULL; END $$;
/* SQL text to delete unneeded entity fields (1 scoped entities) */


-- ===================== Other =====================

/*================================ CODEGEN SPLICE POINT ================================
  Append the single-pass `mj codegen` output below after running the migration.
=======================================================================================*/

/*  CODEGEN — output of `mj codegen` (@memberjunction/cli 5.44.0), SINGLE PASS,
    run 2026-07-07 after the ALTER above. Verified: drift = 0 (test:harness:metadata 23/23).  */

/* SQL text to update existing entities from schema */

/* spUpdate Permissions for Committees: Memberships */


-- =====================================================================
-- CodeGen native PostgreSQL objects (baked from `mj codegen` v5.44, post-RenewalIntent state).
-- Replaces the converter's SKIPPED procedures/triggers and placeholder
-- views with CodeGen's own PG emission, so `mj migrate` alone yields a
-- fully functional schema (one-shot install; no `mj codegen` step).
-- DO NOT run scripts/pg-finalize.mjs over this file (it skips baked files).
-- =====================================================================

/* SQL text to update existing entities from schema */
-- [stripped: core maintenance reconciliation] spUpdateExistingEntitiesFromSchema — every value this call would
-- compute is pinned by the metadata INSERTs and the CodeGen_Metadata_Backfill
-- .pgonly migration (fixed point), and core PG maintenance sprocs can lag core
-- schema changes (v5.45 spDeleteUnneededEntityFields references the dropped
-- vwEntities.ExternalDataSourceID). The siblings' baked files omit these too.

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Artifact */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Artifact'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Artifact', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Artifact" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommittees.Artifact */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Artifact" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Artifact */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Artifact'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Artifact', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Artifact" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommittees.Artifact */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Artifact" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.ArtifactType */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'ArtifactType'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'ArtifactType', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."ArtifactType" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommittees.ArtifactType */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."ArtifactType" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.ArtifactType */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'ArtifactType'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'ArtifactType', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."ArtifactType" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommittees.ArtifactType */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."ArtifactType" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.ActionItem */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'ActionItem'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'ActionItem', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."ActionItem" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommittees.ActionItem */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."ActionItem" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.ActionItem */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'ActionItem'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'ActionItem', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."ActionItem" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommittees.ActionItem */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."ActionItem" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Attendance */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Attendance'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Attendance', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Attendance" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommittees.Attendance */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Attendance" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Attendance */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Attendance'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Attendance', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Attendance" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommittees.Attendance */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Attendance" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.AgendaItem */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'AgendaItem'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'AgendaItem', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."AgendaItem" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommittees.AgendaItem */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."AgendaItem" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.AgendaItem */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'AgendaItem'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'AgendaItem', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."AgendaItem" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommittees.AgendaItem */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."AgendaItem" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Meeting */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Meeting'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Meeting', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Meeting" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommittees.Meeting */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Meeting" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Meeting */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Meeting'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Meeting', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Meeting" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommittees.Meeting */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Meeting" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.VideoProvider */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'VideoProvider'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'VideoProvider', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."VideoProvider" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommittees.VideoProvider */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."VideoProvider" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.VideoProvider */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'VideoProvider'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'VideoProvider', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."VideoProvider" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommittees.VideoProvider */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."VideoProvider" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Membership */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Membership'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Membership', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Membership" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommittees.Membership */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Membership" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Membership */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Membership'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Membership', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Membership" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommittees.Membership */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Membership" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Role */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Role'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Role', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Role" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommittees.Role */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Role" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Role */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Role'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Role', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Role" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommittees.Role */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Role" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Term */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Term'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Term', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Term" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommittees.Term */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Term" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Term */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Term'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Term', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Term" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommittees.Term */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Term" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Committee */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Committee'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Committee', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Committee" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommittees.Committee */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Committee" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Committee */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Committee'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Committee', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Committee" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommittees.Committee */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Committee" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Comment */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Comment'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Comment', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Comment" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommittees.Comment */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Comment" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Comment */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Comment'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Comment', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Comment" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommittees.Comment */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Comment" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskAssignment */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskAssignment'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskAssignment', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskAssignment" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappstasks.TaskAssignment */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskAssignment" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskAssignment */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskAssignment'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskAssignment', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskAssignment" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappstasks.TaskAssignment */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskAssignment" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.Task */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'Task'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'Task', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."Task" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappstasks.Task */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."Task" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.Task */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'Task'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'Task', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."Task" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappstasks.Task */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."Task" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskTemplateItemRole */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskTemplateItemRole'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskTemplateItemRole', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskTemplateItemRole" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappstasks.TaskTemplateItemRole */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskTemplateItemRole" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskTemplateItemRole */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskTemplateItemRole'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskTemplateItemRole', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskTemplateItemRole" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappstasks.TaskTemplateItemRole */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskTemplateItemRole" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskTemplateItem */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskTemplateItem'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskTemplateItem', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskTemplateItem" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappstasks.TaskTemplateItem */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskTemplateItem" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskTemplateItem */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskTemplateItem'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskTemplateItem', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskTemplateItem" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappstasks.TaskTemplateItem */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskTemplateItem" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskTemplateItemDependency */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskTemplateItemDependency'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskTemplateItemDependency', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskTemplateItemDependency" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappstasks.TaskTemplateItemDependency */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskTemplateItemDependency" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskTemplateItemDependency */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskTemplateItemDependency'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskTemplateItemDependency', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskTemplateItemDependency" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappstasks.TaskTemplateItemDependency */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskTemplateItemDependency" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskTemplate */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskTemplate'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskTemplate', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskTemplate" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappstasks.TaskTemplate */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskTemplate" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskTemplate */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskTemplate'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskTemplate', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskTemplate" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappstasks.TaskTemplate */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskTemplate" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.AddressType */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'AddressType'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'AddressType', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."AddressType" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommon.AddressType */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."AddressType" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.AddressType */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'AddressType'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'AddressType', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."AddressType" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommon.AddressType */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."AddressType" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.ContactType */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'ContactType'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'ContactType', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."ContactType" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommon.ContactType */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."ContactType" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.ContactType */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'ContactType'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'ContactType', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."ContactType" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommon.ContactType */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."ContactType" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.RelationshipType */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'RelationshipType'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'RelationshipType', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."RelationshipType" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommon.RelationshipType */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."RelationshipType" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.RelationshipType */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'RelationshipType'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'RelationshipType', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."RelationshipType" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommon.RelationshipType */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."RelationshipType" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskRole */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskRole'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskRole', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskRole" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappstasks.TaskRole */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskRole" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskRole */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskRole'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskRole', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskRole" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappstasks.TaskRole */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskRole" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskType */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskType'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskType', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskType" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappstasks.TaskType */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskType" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskType */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskType'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskType', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskType" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappstasks.TaskType */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskType" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskCategory */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskCategory'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskCategory', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskCategory" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappstasks.TaskCategory */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskCategory" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskCategory */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskCategory'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskCategory', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskCategory" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappstasks.TaskCategory */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskCategory" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskTagLink */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskTagLink'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskTagLink', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskTagLink" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappstasks.TaskTagLink */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskTagLink" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskTagLink */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskTagLink'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskTagLink', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskTagLink" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappstasks.TaskTagLink */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskTagLink" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskTag */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskTag'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskTag', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskTag" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappstasks.TaskTag */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskTag" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskTag */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskTag'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskTag', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskTag" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappstasks.TaskTag */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskTag" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskDependency */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskDependency'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskDependency', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskDependency" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappstasks.TaskDependency */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskDependency" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskDependency */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskDependency'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskDependency', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskDependency" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappstasks.TaskDependency */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskDependency" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskLink */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskLink'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskLink', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskLink" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappstasks.TaskLink */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskLink" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskLink */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskLink'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskLink', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskLink" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappstasks.TaskLink */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskLink" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskComment */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskComment'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskComment', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskComment" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappstasks.TaskComment */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskComment" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskComment */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskComment'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskComment', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskComment" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappstasks.TaskComment */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskComment" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskDecisionOutcome */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskDecisionOutcome'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskDecisionOutcome', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskDecisionOutcome" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappstasks.TaskDecisionOutcome */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskDecisionOutcome" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskDecisionOutcome */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskDecisionOutcome'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskDecisionOutcome', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskDecisionOutcome" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappstasks.TaskDecisionOutcome */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskDecisionOutcome" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.AddressLink */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'AddressLink'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'AddressLink', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."AddressLink" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommon.AddressLink */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."AddressLink" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.AddressLink */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'AddressLink'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'AddressLink', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."AddressLink" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommon.AddressLink */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."AddressLink" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.Organization */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'Organization'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'Organization', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."Organization" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommon.Organization */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."Organization" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.Organization */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'Organization'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'Organization', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."Organization" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommon.Organization */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."Organization" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.OrganizationType */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'OrganizationType'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'OrganizationType', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."OrganizationType" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommon.OrganizationType */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."OrganizationType" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.OrganizationType */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'OrganizationType'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'OrganizationType', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."OrganizationType" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommon.OrganizationType */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."OrganizationType" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.Person */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'Person'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'Person', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."Person" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommon.Person */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."Person" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.Person */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'Person'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'Person', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."Person" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommon.Person */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."Person" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Type */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Type'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Type', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Type" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommittees.Type */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Type" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Type */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Type'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Type', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Type" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommittees.Type */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Type" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskActivity */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskActivity'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskActivity', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskActivity" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappstasks.TaskActivity */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskActivity" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskActivity */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskActivity'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskActivity', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskActivity" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappstasks.TaskActivity */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskActivity" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskDecision */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskDecision'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskDecision', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskDecision" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappstasks.TaskDecision */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskDecision" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskDecision */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskDecision'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskDecision', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskDecision" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappstasks.TaskDecision */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskDecision" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.Relationship */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'Relationship'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'Relationship', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."Relationship" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommon.Relationship */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."Relationship" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.Relationship */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'Relationship'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'Relationship', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."Relationship" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommon.Relationship */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."Relationship" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.Address */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'Address'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'Address', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."Address" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommon.Address */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."Address" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.Address */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'Address'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'Address', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."Address" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommon.Address */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."Address" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.ContactMethod */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'ContactMethod'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'ContactMethod', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."ContactMethod" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommon.ContactMethod */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."ContactMethod" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommon.ContactMethod */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommon'
     AND rel.relname = 'ContactMethod'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommon', 'ContactMethod', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommon."ContactMethod" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommon.ContactMethod */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommon."ContactMethod" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskNotificationLog */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskNotificationLog'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskNotificationLog', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskNotificationLog" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappstasks.TaskNotificationLog */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskNotificationLog" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskNotificationLog */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskNotificationLog'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskNotificationLog', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskNotificationLog" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappstasks.TaskNotificationLog */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskNotificationLog" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskNotificationConfig */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskNotificationConfig'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskNotificationConfig', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskNotificationConfig" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappstasks.TaskNotificationConfig */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskNotificationConfig" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappstasks.TaskNotificationConfig */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappstasks'
     AND rel.relname = 'TaskNotificationConfig'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappstasks', 'TaskNotificationConfig', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappstasks."TaskNotificationConfig" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappstasks.TaskNotificationConfig */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappstasks."TaskNotificationConfig" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Ballot */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Ballot'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Ballot', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Ballot" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommittees.Ballot */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Ballot" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Ballot */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Ballot'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Ballot', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Ballot" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommittees.Ballot */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Ballot" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Vote */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Vote'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Vote', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Vote" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommittees.Vote */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Vote" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Vote */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Vote'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Vote', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Vote" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommittees.Vote */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Vote" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Motion */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Motion'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Motion', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Motion" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommittees.Motion */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Motion" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Motion */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Motion'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Motion', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Motion" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommittees.Motion */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Motion" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Minute */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Minute'
     AND att.attname = '__mj_CreatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Minute', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Minute" ALTER COLUMN "__mj_CreatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_CreatedAt in entity ${mjSchema}_bizappscommittees.Minute */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Minute" ALTER COLUMN "__mj_CreatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL text to drop default existing default constraints in entity ${mjSchema}_bizappscommittees.Minute */
SET CONSTRAINTS ALL IMMEDIATE;
DO $$
DECLARE
   v_constraint_name TEXT;
BEGIN
   SELECT con.conname INTO v_constraint_name
   FROM pg_catalog.pg_constraint con
   JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
   JOIN pg_catalog.pg_namespace nsp ON nsp.oid = rel.relnamespace
   JOIN pg_catalog.pg_attribute att ON att.attrelid = rel.oid AND att.attnum = ANY(con.conkey)
   WHERE nsp.nspname = '${mjSchema}_bizappscommittees'
     AND rel.relname = 'Minute'
     AND att.attname = '__mj_UpdatedAt'
     AND con.contype = 'c';

   IF v_constraint_name IS NOT NULL THEN
      EXECUTE format('ALTER TABLE %I.%I DROP CONSTRAINT %I', '${mjSchema}_bizappscommittees', 'Minute', v_constraint_name);
   END IF;

   -- Also drop any column default
   ALTER TABLE ${mjSchema}_bizappscommittees."Minute" ALTER COLUMN "__mj_UpdatedAt" DROP DEFAULT;
END $$;

/* SQL text to add default constraint for special date field __mj_UpdatedAt in entity ${mjSchema}_bizappscommittees.Minute */
SET CONSTRAINTS ALL IMMEDIATE;
ALTER TABLE ${mjSchema}_bizappscommittees."Minute" ALTER COLUMN "__mj_UpdatedAt" SET DEFAULT (NOW() AT TIME ZONE 'UTC');

/* SQL to fix virtual field nullability */

UPDATE ${mjSchema}."EntityField" vf
SET "AllowsNull" = fk."AllowsNull"
FROM ${mjSchema}."EntityField" fk
WHERE vf."IsVirtual" = true
  AND fk."IsVirtual" = false
  AND vf."EntityID" = fk."EntityID"
  AND fk."RelatedEntityID" IS NOT NULL
  AND (
     (LENGTH(fk."Name") > 2
      AND LOWER(vf."Name") = LOWER(LEFT(fk."Name", LENGTH(fk."Name") - 2)))
     OR
     (LENGTH(fk."Name") > 2
      AND LOWER(vf."Name") = LOWER(LEFT(fk."Name", LENGTH(fk."Name") - 2) || '_Virtual'))
     OR
     (fk."RelatedEntityNameFieldMap" IS NOT NULL
      AND fk."RelatedEntityNameFieldMap" != ''
      AND LOWER(vf."Name") = LOWER(fk."RelatedEntityNameFieldMap"))
  )
  AND vf."AllowsNull" != fk."AllowsNull";

/* SQL text to update existing entity fields from schema */
-- [stripped: core maintenance reconciliation] spUpdateExistingEntityFieldsFromSchema — every value this call would
-- compute is pinned by the metadata INSERTs and the CodeGen_Metadata_Backfill
-- .pgonly migration (fixed point), and core PG maintenance sprocs can lag core
-- schema changes (v5.45 spDeleteUnneededEntityFields references the dropped
-- vwEntities.ExternalDataSourceID). The siblings' baked files omit these too.

/* SQL text to set default column width where needed */
-- [stripped: core maintenance reconciliation] spSetDefaultColumnWidthWhereNeeded — every value this call would
-- compute is pinned by the metadata INSERTs and the CodeGen_Metadata_Backfill
-- .pgonly migration (fixed point), and core PG maintenance sprocs can lag core
-- schema changes (v5.45 spDeleteUnneededEntityFields references the dropped
-- vwEntities.ExternalDataSourceID). The siblings' baked files omit these too.

/* SQL text to sync schema info from database schemas */
-- [stripped: core maintenance reconciliation] spUpdateSchemaInfoFromDatabase — every value this call would
-- compute is pinned by the metadata INSERTs and the CodeGen_Metadata_Backfill
-- .pgonly migration (fixed point), and core PG maintenance sprocs can lag core
-- schema changes (v5.45 spDeleteUnneededEntityFields references the dropped
-- vwEntities.ExternalDataSourceID). The siblings' baked files omit these too.

/* Base View SQL for Committees: Action Items */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Action Items
-- Item: vwActionItems
-- Generated at: 2026-07-22T15:45:58.134Z
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Action Items
-----               SCHEMA:      ${mjSchema}_bizappscommittees
-----               BASE TABLE:  ActionItem
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW ${mjSchema}_bizappscommittees."vwActionItems"
AS
SELECT
    a.*,
    mjbizappscommitteesCommittee_CommitteeID."Name" AS "Committee",
    mjbizappscommitteesMeeting_MeetingID."Name" AS "Meeting",
    mjbizappscommitteesAgendaItem_AgendaItemID."Name" AS "AgendaItem",
    mjBizAppsCommonPerson_AssignedToPersonID."DisplayName" AS "AssignedToPerson",
    mjBizAppsCommonPerson_AssignedByPersonID."DisplayName" AS "AssignedByPerson"
FROM
    ${mjSchema}_bizappscommittees."ActionItem" AS a
INNER JOIN
    ${mjSchema}_bizappscommittees."Committee" AS mjbizappscommitteesCommittee_CommitteeID
  ON
    "a"."CommitteeID" = mjbizappscommitteesCommittee_CommitteeID."ID"
LEFT OUTER JOIN
    ${mjSchema}_bizappscommittees."Meeting" AS mjbizappscommitteesMeeting_MeetingID
  ON
    "a"."MeetingID" = mjbizappscommitteesMeeting_MeetingID."ID"
LEFT OUTER JOIN
    ${mjSchema}_bizappscommittees."AgendaItem" AS mjbizappscommitteesAgendaItem_AgendaItemID
  ON
    "a"."AgendaItemID" = mjbizappscommitteesAgendaItem_AgendaItemID."ID"
INNER JOIN
    ${mjSchema}_bizappscommon."Person" AS mjBizAppsCommonPerson_AssignedToPersonID
  ON
    "a"."AssignedToPersonID" = mjBizAppsCommonPerson_AssignedToPersonID."ID"
LEFT OUTER JOIN
    ${mjSchema}_bizappscommon."Person" AS mjBizAppsCommonPerson_AssignedByPersonID
  ON
    "a"."AssignedByPersonID" = mjBizAppsCommonPerson_AssignedByPersonID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql)
  SELECT DISTINCT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'))
  FROM pg_depend d
  JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
  JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwActionItems'
    AND tc.relkind IN ('v', 'm')
    AND dc.oid <> tc.oid;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_proc pp ON pp.oid = d.objid AND d.classid = 'pg_proc'::regclass
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwActionItems'
    AND tc.relkind IN ('v', 'm')
  UNION
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_type pt ON pt.oid = d.refobjid AND d.refclassid = 'pg_type'::regclass
  JOIN pg_proc pp ON pp.prorettype = pt.oid OR pt.typrelid = pp.oid
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE EXISTS (
      SELECT 1 FROM pg_class tc
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tc.reltype = pt.oid
        AND tn.nspname = '${mjSchema}_bizappscommittees'
        AND tc.relname = 'vwActionItems'
        AND tc.relkind IN ('v', 'm')
  );

  DROP VIEW IF EXISTS ${mjSchema}_bizappscommittees."vwActionItems" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwActionItems" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwActionItems" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwActionItems" TO "cdp_Integration";

/* Base View Permissions SQL for Committees: Action Items */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Action Items
-- Item: Permissions for vwActionItems
-- Generated at: 2026-07-22T15:45:58.137Z
-- ============================================================
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwActionItems" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwActionItems" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwActionItems" TO "cdp_Integration";

/* spCreate SQL for Committees: Action Items */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Action Items
-- Item: spCreateActionItem
-- Generated at: 2026-07-22T15:45:58.137Z
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR ActionItem
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateActionItem'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spCreateActionItem"(
    p_id UUID DEFAULT NULL,
    p_committeeid UUID DEFAULT NULL,
    p_meetingid_clear boolean DEFAULT false,
    p_meetingid UUID DEFAULT NULL,
    p_agendaitemid_clear boolean DEFAULT false,
    p_agendaitemid UUID DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_assignedtopersonid UUID DEFAULT NULL,
    p_assignedbypersonid_clear boolean DEFAULT false,
    p_assignedbypersonid UUID DEFAULT NULL,
    p_duedate_clear boolean DEFAULT false,
    p_duedate date DEFAULT NULL,
    p_priority varchar(20) DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL,
    p_completedat_clear boolean DEFAULT false,
    p_completedat TIMESTAMPTZ DEFAULT NULL,
    p_completionnotes_clear boolean DEFAULT false,
    p_completionnotes TEXT DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwActionItems" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO ${mjSchema}_bizappscommittees."ActionItem"
        (
            "ID",
            "CommitteeID",
                "MeetingID",
                "AgendaItemID",
                "Name",
                "Description",
                "AssignedToPersonID",
                "AssignedByPersonID",
                "DueDate",
                "Priority",
                "Status",
                "CompletedAt",
                "CompletionNotes"
        )
    VALUES
        (
            v_new_id,
            p_committeeid,
                CASE WHEN p_meetingid_clear = true THEN NULL ELSE COALESCE(p_meetingid, NULL) END,
                CASE WHEN p_agendaitemid_clear = true THEN NULL ELSE COALESCE(p_agendaitemid, NULL) END,
                p_name,
                CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, NULL) END,
                p_assignedtopersonid,
                CASE WHEN p_assignedbypersonid_clear = true THEN NULL ELSE COALESCE(p_assignedbypersonid, NULL) END,
                CASE WHEN p_duedate_clear = true THEN NULL ELSE COALESCE(p_duedate, NULL) END,
                COALESCE(p_priority, 'Medium'),
                COALESCE(p_status, 'Open'),
                CASE WHEN p_completedat_clear = true THEN NULL ELSE COALESCE(p_completedat, NULL) END,
                CASE WHEN p_completionnotes_clear = true THEN NULL ELSE COALESCE(p_completionnotes, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwActionItems"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateActionItem" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateActionItem" TO "cdp_Integration";

/* spCreate Permissions for Committees: Action Items */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateActionItem" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateActionItem" TO "cdp_Integration";

/* spUpdate SQL for Committees: Action Items */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Action Items
-- Item: spUpdateActionItem
-- Generated at: 2026-07-22T15:45:58.139Z
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR ActionItem
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateActionItem'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spUpdateActionItem"(
    p_id UUID,
    p_committeeid UUID DEFAULT NULL,
    p_meetingid_clear boolean DEFAULT false,
    p_meetingid UUID DEFAULT NULL,
    p_agendaitemid_clear boolean DEFAULT false,
    p_agendaitemid UUID DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_assignedtopersonid UUID DEFAULT NULL,
    p_assignedbypersonid_clear boolean DEFAULT false,
    p_assignedbypersonid UUID DEFAULT NULL,
    p_duedate_clear boolean DEFAULT false,
    p_duedate date DEFAULT NULL,
    p_priority varchar(20) DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL,
    p_completedat_clear boolean DEFAULT false,
    p_completedat TIMESTAMPTZ DEFAULT NULL,
    p_completionnotes_clear boolean DEFAULT false,
    p_completionnotes TEXT DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwActionItems" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE ${mjSchema}_bizappscommittees."ActionItem"
    SET
        "CommitteeID" = COALESCE(p_committeeid, "CommitteeID"),
        "MeetingID" = CASE WHEN p_meetingid_clear = true THEN NULL ELSE COALESCE(p_meetingid, "MeetingID") END,
        "AgendaItemID" = CASE WHEN p_agendaitemid_clear = true THEN NULL ELSE COALESCE(p_agendaitemid, "AgendaItemID") END,
        "Name" = COALESCE(p_name, "Name"),
        "Description" = CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, "Description") END,
        "AssignedToPersonID" = COALESCE(p_assignedtopersonid, "AssignedToPersonID"),
        "AssignedByPersonID" = CASE WHEN p_assignedbypersonid_clear = true THEN NULL ELSE COALESCE(p_assignedbypersonid, "AssignedByPersonID") END,
        "DueDate" = CASE WHEN p_duedate_clear = true THEN NULL ELSE COALESCE(p_duedate, "DueDate") END,
        "Priority" = COALESCE(p_priority, "Priority"),
        "Status" = COALESCE(p_status, "Status"),
        "CompletedAt" = CASE WHEN p_completedat_clear = true THEN NULL ELSE COALESCE(p_completedat, "CompletedAt") END,
        "CompletionNotes" = CASE WHEN p_completionnotes_clear = true THEN NULL ELSE COALESCE(p_completionnotes, "CompletionNotes") END
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwActionItems"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateActionItem" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateActionItem" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the ActionItem table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_action_item"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_action_item" ON ${mjSchema}_bizappscommittees."ActionItem";

CREATE TRIGGER "trg_update_action_item"
BEFORE UPDATE ON ${mjSchema}_bizappscommittees."ActionItem"
FOR EACH ROW
EXECUTE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_action_item"();

/* spUpdate Permissions for Committees: Action Items */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateActionItem" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateActionItem" TO "cdp_Integration";

/* spDelete SQL for Committees: Action Items */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Action Items
-- Item: spDeleteActionItem
-- Generated at: 2026-07-22T15:45:58.140Z
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR ActionItem
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteActionItem'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spDeleteActionItem"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM ${mjSchema}_bizappscommittees."ActionItem"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteActionItem" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteActionItem" TO "cdp_Integration";

/* spDelete Permissions for Committees: Action Items */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteActionItem" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteActionItem" TO "cdp_Integration";

/* Root ID Function SQL for Committees: Agenda Items.ParentAgendaItemID */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Agenda Items
-- Item: fnAgendaItemParentAgendaItemID_GetRootID
-- Generated at: 2026-07-22T15:45:58.160Z
-- ============================================================

------------------------------------------------------------
----- ROOT ID FUNCTION FOR: AgendaItem.ParentAgendaItemID
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_agenda_item_parent_agenda_item_id_get_root_id"(
    p_record_id UUID,
    p_parent_id UUID
) RETURNS UUID AS $$
    WITH RECURSIVE cte_root_parent AS (
        -- Anchor: Start from p_parent_id if not null, otherwise start from p_record_id
        SELECT
            "ID",
            "ParentAgendaItemID",
            "ID" AS root_parent_id,
            0 AS depth
        FROM
            ${mjSchema}_bizappscommittees."AgendaItem"
        WHERE
            "ID" = COALESCE(p_parent_id, p_record_id)

        UNION ALL

        -- Recursive: Keep going up the hierarchy
        SELECT
            c."ID",
            c."ParentAgendaItemID",
            c."ID" AS root_parent_id,
            p.depth + 1 AS depth
        FROM
            ${mjSchema}_bizappscommittees."AgendaItem" c
        INNER JOIN
            cte_root_parent p ON c."ID" = p."ParentAgendaItemID"
        WHERE
            p.depth < 100  -- Prevent infinite loops
    )
    SELECT root_parent_id
    FROM cte_root_parent
    WHERE "ParentAgendaItemID" IS NULL
    ORDER BY root_parent_id
    LIMIT 1;
$$ LANGUAGE sql STABLE;

/* Base View SQL for Committees: Agenda Items */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Agenda Items
-- Item: vwAgendaItems
-- Generated at: 2026-07-22T15:45:58.160Z
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Agenda Items
-----               SCHEMA:      ${mjSchema}_bizappscommittees
-----               BASE TABLE:  AgendaItem
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW ${mjSchema}_bizappscommittees."vwAgendaItems"
AS
SELECT
    a.*,
    mjbizappscommitteesMeeting_MeetingID."Name" AS "Meeting",
    mjbizappscommitteesAgendaItem_ParentAgendaItemID."Name" AS "ParentAgendaItem",
    mjBizAppsCommonPerson_PresenterPersonID."DisplayName" AS "PresenterPerson",
    root_ParentAgendaItemID.root_id AS "RootParentAgendaItemID"
FROM
    ${mjSchema}_bizappscommittees."AgendaItem" AS a
INNER JOIN
    ${mjSchema}_bizappscommittees."Meeting" AS mjbizappscommitteesMeeting_MeetingID
  ON
    "a"."MeetingID" = mjbizappscommitteesMeeting_MeetingID."ID"
LEFT OUTER JOIN
    ${mjSchema}_bizappscommittees."AgendaItem" AS mjbizappscommitteesAgendaItem_ParentAgendaItemID
  ON
    "a"."ParentAgendaItemID" = mjbizappscommitteesAgendaItem_ParentAgendaItemID."ID"
LEFT OUTER JOIN
    ${mjSchema}_bizappscommon."Person" AS mjBizAppsCommonPerson_PresenterPersonID
  ON
    "a"."PresenterPersonID" = mjBizAppsCommonPerson_PresenterPersonID."ID"

LEFT JOIN LATERAL (
    SELECT ${mjSchema}_bizappscommittees."fn_agenda_item_parent_agenda_item_id_get_root_id"(a."ID", a."ParentAgendaItemID") AS root_id
) AS root_ParentAgendaItemID ON true
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql)
  SELECT DISTINCT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'))
  FROM pg_depend d
  JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
  JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwAgendaItems'
    AND tc.relkind IN ('v', 'm')
    AND dc.oid <> tc.oid;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_proc pp ON pp.oid = d.objid AND d.classid = 'pg_proc'::regclass
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwAgendaItems'
    AND tc.relkind IN ('v', 'm')
  UNION
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_type pt ON pt.oid = d.refobjid AND d.refclassid = 'pg_type'::regclass
  JOIN pg_proc pp ON pp.prorettype = pt.oid OR pt.typrelid = pp.oid
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE EXISTS (
      SELECT 1 FROM pg_class tc
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tc.reltype = pt.oid
        AND tn.nspname = '${mjSchema}_bizappscommittees'
        AND tc.relname = 'vwAgendaItems'
        AND tc.relkind IN ('v', 'm')
  );

  DROP VIEW IF EXISTS ${mjSchema}_bizappscommittees."vwAgendaItems" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwAgendaItems" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwAgendaItems" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwAgendaItems" TO "cdp_Integration";

/* Base View Permissions SQL for Committees: Agenda Items */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Agenda Items
-- Item: Permissions for vwAgendaItems
-- Generated at: 2026-07-22T15:45:58.161Z
-- ============================================================
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwAgendaItems" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwAgendaItems" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwAgendaItems" TO "cdp_Integration";

/* spCreate SQL for Committees: Agenda Items */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Agenda Items
-- Item: spCreateAgendaItem
-- Generated at: 2026-07-22T15:45:58.161Z
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR AgendaItem
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateAgendaItem'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spCreateAgendaItem"(
    p_id UUID DEFAULT NULL,
    p_meetingid UUID DEFAULT NULL,
    p_parentagendaitemid_clear boolean DEFAULT false,
    p_parentagendaitemid UUID DEFAULT NULL,
    p_sequence int DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_presenterpersonid_clear boolean DEFAULT false,
    p_presenterpersonid UUID DEFAULT NULL,
    p_durationminutes_clear boolean DEFAULT false,
    p_durationminutes int DEFAULT NULL,
    p_itemtype varchar(50) DEFAULT NULL,
    p_relateddocumenturl_clear boolean DEFAULT false,
    p_relateddocumenturl varchar(1000) DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes TEXT DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwAgendaItems" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO ${mjSchema}_bizappscommittees."AgendaItem"
        (
            "ID",
            "MeetingID",
                "ParentAgendaItemID",
                "Sequence",
                "Name",
                "Description",
                "PresenterPersonID",
                "DurationMinutes",
                "ItemType",
                "RelatedDocumentURL",
                "Status",
                "Notes"
        )
    VALUES
        (
            v_new_id,
            p_meetingid,
                CASE WHEN p_parentagendaitemid_clear = true THEN NULL ELSE COALESCE(p_parentagendaitemid, NULL) END,
                p_sequence,
                p_name,
                CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, NULL) END,
                CASE WHEN p_presenterpersonid_clear = true THEN NULL ELSE COALESCE(p_presenterpersonid, NULL) END,
                CASE WHEN p_durationminutes_clear = true THEN NULL ELSE COALESCE(p_durationminutes, NULL) END,
                COALESCE(p_itemtype, 'Discussion'),
                CASE WHEN p_relateddocumenturl_clear = true THEN NULL ELSE COALESCE(p_relateddocumenturl, NULL) END,
                COALESCE(p_status, 'Pending'),
                CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwAgendaItems"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateAgendaItem" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateAgendaItem" TO "cdp_Integration";

/* spCreate Permissions for Committees: Agenda Items */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateAgendaItem" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateAgendaItem" TO "cdp_Integration";

/* spUpdate SQL for Committees: Agenda Items */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Agenda Items
-- Item: spUpdateAgendaItem
-- Generated at: 2026-07-22T15:45:58.162Z
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR AgendaItem
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateAgendaItem'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spUpdateAgendaItem"(
    p_id UUID,
    p_meetingid UUID DEFAULT NULL,
    p_parentagendaitemid_clear boolean DEFAULT false,
    p_parentagendaitemid UUID DEFAULT NULL,
    p_sequence int DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_presenterpersonid_clear boolean DEFAULT false,
    p_presenterpersonid UUID DEFAULT NULL,
    p_durationminutes_clear boolean DEFAULT false,
    p_durationminutes int DEFAULT NULL,
    p_itemtype varchar(50) DEFAULT NULL,
    p_relateddocumenturl_clear boolean DEFAULT false,
    p_relateddocumenturl varchar(1000) DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes TEXT DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwAgendaItems" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE ${mjSchema}_bizappscommittees."AgendaItem"
    SET
        "MeetingID" = COALESCE(p_meetingid, "MeetingID"),
        "ParentAgendaItemID" = CASE WHEN p_parentagendaitemid_clear = true THEN NULL ELSE COALESCE(p_parentagendaitemid, "ParentAgendaItemID") END,
        "Sequence" = COALESCE(p_sequence, "Sequence"),
        "Name" = COALESCE(p_name, "Name"),
        "Description" = CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, "Description") END,
        "PresenterPersonID" = CASE WHEN p_presenterpersonid_clear = true THEN NULL ELSE COALESCE(p_presenterpersonid, "PresenterPersonID") END,
        "DurationMinutes" = CASE WHEN p_durationminutes_clear = true THEN NULL ELSE COALESCE(p_durationminutes, "DurationMinutes") END,
        "ItemType" = COALESCE(p_itemtype, "ItemType"),
        "RelatedDocumentURL" = CASE WHEN p_relateddocumenturl_clear = true THEN NULL ELSE COALESCE(p_relateddocumenturl, "RelatedDocumentURL") END,
        "Status" = COALESCE(p_status, "Status"),
        "Notes" = CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, "Notes") END
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwAgendaItems"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateAgendaItem" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateAgendaItem" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the AgendaItem table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_agenda_item"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_agenda_item" ON ${mjSchema}_bizappscommittees."AgendaItem";

CREATE TRIGGER "trg_update_agenda_item"
BEFORE UPDATE ON ${mjSchema}_bizappscommittees."AgendaItem"
FOR EACH ROW
EXECUTE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_agenda_item"();

/* spUpdate Permissions for Committees: Agenda Items */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateAgendaItem" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateAgendaItem" TO "cdp_Integration";

/* spDelete SQL for Committees: Agenda Items */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Agenda Items
-- Item: spDeleteAgendaItem
-- Generated at: 2026-07-22T15:45:58.162Z
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR AgendaItem
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteAgendaItem'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spDeleteAgendaItem"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM ${mjSchema}_bizappscommittees."AgendaItem"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteAgendaItem" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteAgendaItem" TO "cdp_Integration";

/* spDelete Permissions for Committees: Agenda Items */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteAgendaItem" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteAgendaItem" TO "cdp_Integration";

/* Base View SQL for Committees: Artifact Types */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifact Types
-- Item: vwArtifactTypes
-- Generated at: 2026-07-22T15:45:58.173Z
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Artifact Types
-----               SCHEMA:      ${mjSchema}_bizappscommittees
-----               BASE TABLE:  ArtifactType
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW ${mjSchema}_bizappscommittees."vwArtifactTypes"
AS
SELECT
    a.*,
    MJEntity_ExtendedEntityID."Name" AS "ExtendedEntity"
FROM
    ${mjSchema}_bizappscommittees."ArtifactType" AS a
LEFT OUTER JOIN
    ${mjSchema}."Entity" AS MJEntity_ExtendedEntityID
  ON
    "a"."ExtendedEntityID" = MJEntity_ExtendedEntityID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql)
  SELECT DISTINCT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'))
  FROM pg_depend d
  JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
  JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwArtifactTypes'
    AND tc.relkind IN ('v', 'm')
    AND dc.oid <> tc.oid;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_proc pp ON pp.oid = d.objid AND d.classid = 'pg_proc'::regclass
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwArtifactTypes'
    AND tc.relkind IN ('v', 'm')
  UNION
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_type pt ON pt.oid = d.refobjid AND d.refclassid = 'pg_type'::regclass
  JOIN pg_proc pp ON pp.prorettype = pt.oid OR pt.typrelid = pp.oid
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE EXISTS (
      SELECT 1 FROM pg_class tc
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tc.reltype = pt.oid
        AND tn.nspname = '${mjSchema}_bizappscommittees'
        AND tc.relname = 'vwArtifactTypes'
        AND tc.relkind IN ('v', 'm')
  );

  DROP VIEW IF EXISTS ${mjSchema}_bizappscommittees."vwArtifactTypes" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwArtifactTypes" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwArtifactTypes" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwArtifactTypes" TO "cdp_Integration";

/* Base View Permissions SQL for Committees: Artifact Types */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifact Types
-- Item: Permissions for vwArtifactTypes
-- Generated at: 2026-07-22T15:45:58.174Z
-- ============================================================
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwArtifactTypes" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwArtifactTypes" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwArtifactTypes" TO "cdp_Integration";

/* spCreate SQL for Committees: Artifact Types */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifact Types
-- Item: spCreateArtifactType
-- Generated at: 2026-07-22T15:45:58.174Z
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR ArtifactType
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateArtifactType'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spCreateArtifactType"(
    p_id UUID DEFAULT NULL,
    p_name varchar(100) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_extendedentityid_clear boolean DEFAULT false,
    p_extendedentityid UUID DEFAULT NULL,
    p_iconclass_clear boolean DEFAULT false,
    p_iconclass varchar(100) DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwArtifactTypes" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO ${mjSchema}_bizappscommittees."ArtifactType"
        (
            "ID",
            "Name",
                "Description",
                "ExtendedEntityID",
                "IconClass"
        )
    VALUES
        (
            v_new_id,
            p_name,
                CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, NULL) END,
                CASE WHEN p_extendedentityid_clear = true THEN NULL ELSE COALESCE(p_extendedentityid, NULL) END,
                CASE WHEN p_iconclass_clear = true THEN NULL ELSE COALESCE(p_iconclass, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwArtifactTypes"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateArtifactType" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateArtifactType" TO "cdp_Integration";

/* spCreate Permissions for Committees: Artifact Types */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateArtifactType" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateArtifactType" TO "cdp_Integration";

/* spUpdate SQL for Committees: Artifact Types */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifact Types
-- Item: spUpdateArtifactType
-- Generated at: 2026-07-22T15:45:58.174Z
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR ArtifactType
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateArtifactType'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spUpdateArtifactType"(
    p_id UUID,
    p_name varchar(100) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_extendedentityid_clear boolean DEFAULT false,
    p_extendedentityid UUID DEFAULT NULL,
    p_iconclass_clear boolean DEFAULT false,
    p_iconclass varchar(100) DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwArtifactTypes" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE ${mjSchema}_bizappscommittees."ArtifactType"
    SET
        "Name" = COALESCE(p_name, "Name"),
        "Description" = CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, "Description") END,
        "ExtendedEntityID" = CASE WHEN p_extendedentityid_clear = true THEN NULL ELSE COALESCE(p_extendedentityid, "ExtendedEntityID") END,
        "IconClass" = CASE WHEN p_iconclass_clear = true THEN NULL ELSE COALESCE(p_iconclass, "IconClass") END
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwArtifactTypes"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateArtifactType" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateArtifactType" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the ArtifactType table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_artifact_type"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_artifact_type" ON ${mjSchema}_bizappscommittees."ArtifactType";

CREATE TRIGGER "trg_update_artifact_type"
BEFORE UPDATE ON ${mjSchema}_bizappscommittees."ArtifactType"
FOR EACH ROW
EXECUTE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_artifact_type"();

/* spUpdate Permissions for Committees: Artifact Types */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateArtifactType" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateArtifactType" TO "cdp_Integration";

/* spDelete SQL for Committees: Artifact Types */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifact Types
-- Item: spDeleteArtifactType
-- Generated at: 2026-07-22T15:45:58.175Z
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR ArtifactType
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteArtifactType'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spDeleteArtifactType"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM ${mjSchema}_bizappscommittees."ArtifactType"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteArtifactType" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteArtifactType" TO "cdp_Integration";

/* spDelete Permissions for Committees: Artifact Types */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteArtifactType" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteArtifactType" TO "cdp_Integration";

/* Base View SQL for Committees: Artifacts */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifacts
-- Item: vwArtifacts
-- Generated at: 2026-07-22T15:45:58.184Z
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Artifacts
-----               SCHEMA:      ${mjSchema}_bizappscommittees
-----               BASE TABLE:  Artifact
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW ${mjSchema}_bizappscommittees."vwArtifacts"
AS
SELECT
    a.*,
    mjbizappscommitteesCommittee_CommitteeID."Name" AS "Committee",
    mjbizappscommitteesMeeting_MeetingID."Name" AS "Meeting",
    mjbizappscommitteesAgendaItem_AgendaItemID."Name" AS "AgendaItem",
    mjBizAppsTasksTask_TaskID."Name" AS "Task",
    mjbizappscommitteesArtifactType_ArtifactTypeID."Name" AS "ArtifactType",
    mjBizAppsCommonPerson_UploadedByPersonID."DisplayName" AS "UploadedByPerson"
FROM
    ${mjSchema}_bizappscommittees."Artifact" AS a
LEFT OUTER JOIN
    ${mjSchema}_bizappscommittees."Committee" AS mjbizappscommitteesCommittee_CommitteeID
  ON
    "a"."CommitteeID" = mjbizappscommitteesCommittee_CommitteeID."ID"
LEFT OUTER JOIN
    ${mjSchema}_bizappscommittees."Meeting" AS mjbizappscommitteesMeeting_MeetingID
  ON
    "a"."MeetingID" = mjbizappscommitteesMeeting_MeetingID."ID"
LEFT OUTER JOIN
    ${mjSchema}_bizappscommittees."AgendaItem" AS mjbizappscommitteesAgendaItem_AgendaItemID
  ON
    "a"."AgendaItemID" = mjbizappscommitteesAgendaItem_AgendaItemID."ID"
LEFT OUTER JOIN
    ${mjSchema}_bizappstasks."Task" AS mjBizAppsTasksTask_TaskID
  ON
    "a"."TaskID" = mjBizAppsTasksTask_TaskID."ID"
INNER JOIN
    ${mjSchema}_bizappscommittees."ArtifactType" AS mjbizappscommitteesArtifactType_ArtifactTypeID
  ON
    "a"."ArtifactTypeID" = mjbizappscommitteesArtifactType_ArtifactTypeID."ID"
LEFT OUTER JOIN
    ${mjSchema}_bizappscommon."Person" AS mjBizAppsCommonPerson_UploadedByPersonID
  ON
    "a"."UploadedByPersonID" = mjBizAppsCommonPerson_UploadedByPersonID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql)
  SELECT DISTINCT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'))
  FROM pg_depend d
  JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
  JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwArtifacts'
    AND tc.relkind IN ('v', 'm')
    AND dc.oid <> tc.oid;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_proc pp ON pp.oid = d.objid AND d.classid = 'pg_proc'::regclass
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwArtifacts'
    AND tc.relkind IN ('v', 'm')
  UNION
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_type pt ON pt.oid = d.refobjid AND d.refclassid = 'pg_type'::regclass
  JOIN pg_proc pp ON pp.prorettype = pt.oid OR pt.typrelid = pp.oid
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE EXISTS (
      SELECT 1 FROM pg_class tc
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tc.reltype = pt.oid
        AND tn.nspname = '${mjSchema}_bizappscommittees'
        AND tc.relname = 'vwArtifacts'
        AND tc.relkind IN ('v', 'm')
  );

  DROP VIEW IF EXISTS ${mjSchema}_bizappscommittees."vwArtifacts" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwArtifacts" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwArtifacts" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwArtifacts" TO "cdp_Integration";

/* Base View Permissions SQL for Committees: Artifacts */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifacts
-- Item: Permissions for vwArtifacts
-- Generated at: 2026-07-22T15:45:58.186Z
-- ============================================================
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwArtifacts" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwArtifacts" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwArtifacts" TO "cdp_Integration";

/* spCreate SQL for Committees: Artifacts */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifacts
-- Item: spCreateArtifact
-- Generated at: 2026-07-22T15:45:58.186Z
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Artifact
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateArtifact'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spCreateArtifact"(
    p_id UUID DEFAULT NULL,
    p_committeeid_clear boolean DEFAULT false,
    p_committeeid UUID DEFAULT NULL,
    p_meetingid_clear boolean DEFAULT false,
    p_meetingid UUID DEFAULT NULL,
    p_agendaitemid_clear boolean DEFAULT false,
    p_agendaitemid UUID DEFAULT NULL,
    p_taskid_clear boolean DEFAULT false,
    p_taskid UUID DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_artifacttypeid UUID DEFAULT NULL,
    p_provider varchar(50) DEFAULT NULL,
    p_externalid_clear boolean DEFAULT false,
    p_externalid varchar(500) DEFAULT NULL,
    p_url varchar(2000) DEFAULT NULL,
    p_mimetype_clear boolean DEFAULT false,
    p_mimetype varchar(100) DEFAULT NULL,
    p_filesize_clear boolean DEFAULT false,
    p_filesize bigint DEFAULT NULL,
    p_uploadedbypersonid_clear boolean DEFAULT false,
    p_uploadedbypersonid UUID DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwArtifacts" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO ${mjSchema}_bizappscommittees."Artifact"
        (
            "ID",
            "CommitteeID",
                "MeetingID",
                "AgendaItemID",
                "TaskID",
                "Name",
                "Description",
                "ArtifactTypeID",
                "Provider",
                "ExternalID",
                "URL",
                "MimeType",
                "FileSize",
                "UploadedByPersonID"
        )
    VALUES
        (
            v_new_id,
            CASE WHEN p_committeeid_clear = true THEN NULL ELSE COALESCE(p_committeeid, NULL) END,
                CASE WHEN p_meetingid_clear = true THEN NULL ELSE COALESCE(p_meetingid, NULL) END,
                CASE WHEN p_agendaitemid_clear = true THEN NULL ELSE COALESCE(p_agendaitemid, NULL) END,
                CASE WHEN p_taskid_clear = true THEN NULL ELSE COALESCE(p_taskid, NULL) END,
                p_name,
                CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, NULL) END,
                p_artifacttypeid,
                p_provider,
                CASE WHEN p_externalid_clear = true THEN NULL ELSE COALESCE(p_externalid, NULL) END,
                p_url,
                CASE WHEN p_mimetype_clear = true THEN NULL ELSE COALESCE(p_mimetype, NULL) END,
                CASE WHEN p_filesize_clear = true THEN NULL ELSE COALESCE(p_filesize, NULL) END,
                CASE WHEN p_uploadedbypersonid_clear = true THEN NULL ELSE COALESCE(p_uploadedbypersonid, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwArtifacts"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateArtifact" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateArtifact" TO "cdp_Integration";

/* spCreate Permissions for Committees: Artifacts */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateArtifact" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateArtifact" TO "cdp_Integration";

/* spUpdate SQL for Committees: Artifacts */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifacts
-- Item: spUpdateArtifact
-- Generated at: 2026-07-22T15:45:58.186Z
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Artifact
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateArtifact'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spUpdateArtifact"(
    p_id UUID,
    p_committeeid_clear boolean DEFAULT false,
    p_committeeid UUID DEFAULT NULL,
    p_meetingid_clear boolean DEFAULT false,
    p_meetingid UUID DEFAULT NULL,
    p_agendaitemid_clear boolean DEFAULT false,
    p_agendaitemid UUID DEFAULT NULL,
    p_taskid_clear boolean DEFAULT false,
    p_taskid UUID DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_artifacttypeid UUID DEFAULT NULL,
    p_provider varchar(50) DEFAULT NULL,
    p_externalid_clear boolean DEFAULT false,
    p_externalid varchar(500) DEFAULT NULL,
    p_url varchar(2000) DEFAULT NULL,
    p_mimetype_clear boolean DEFAULT false,
    p_mimetype varchar(100) DEFAULT NULL,
    p_filesize_clear boolean DEFAULT false,
    p_filesize bigint DEFAULT NULL,
    p_uploadedbypersonid_clear boolean DEFAULT false,
    p_uploadedbypersonid UUID DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwArtifacts" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE ${mjSchema}_bizappscommittees."Artifact"
    SET
        "CommitteeID" = CASE WHEN p_committeeid_clear = true THEN NULL ELSE COALESCE(p_committeeid, "CommitteeID") END,
        "MeetingID" = CASE WHEN p_meetingid_clear = true THEN NULL ELSE COALESCE(p_meetingid, "MeetingID") END,
        "AgendaItemID" = CASE WHEN p_agendaitemid_clear = true THEN NULL ELSE COALESCE(p_agendaitemid, "AgendaItemID") END,
        "TaskID" = CASE WHEN p_taskid_clear = true THEN NULL ELSE COALESCE(p_taskid, "TaskID") END,
        "Name" = COALESCE(p_name, "Name"),
        "Description" = CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, "Description") END,
        "ArtifactTypeID" = COALESCE(p_artifacttypeid, "ArtifactTypeID"),
        "Provider" = COALESCE(p_provider, "Provider"),
        "ExternalID" = CASE WHEN p_externalid_clear = true THEN NULL ELSE COALESCE(p_externalid, "ExternalID") END,
        "URL" = COALESCE(p_url, "URL"),
        "MimeType" = CASE WHEN p_mimetype_clear = true THEN NULL ELSE COALESCE(p_mimetype, "MimeType") END,
        "FileSize" = CASE WHEN p_filesize_clear = true THEN NULL ELSE COALESCE(p_filesize, "FileSize") END,
        "UploadedByPersonID" = CASE WHEN p_uploadedbypersonid_clear = true THEN NULL ELSE COALESCE(p_uploadedbypersonid, "UploadedByPersonID") END
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwArtifacts"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateArtifact" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateArtifact" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Artifact table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_artifact"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_artifact" ON ${mjSchema}_bizappscommittees."Artifact";

CREATE TRIGGER "trg_update_artifact"
BEFORE UPDATE ON ${mjSchema}_bizappscommittees."Artifact"
FOR EACH ROW
EXECUTE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_artifact"();

/* spUpdate Permissions for Committees: Artifacts */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateArtifact" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateArtifact" TO "cdp_Integration";

/* spDelete SQL for Committees: Artifacts */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifacts
-- Item: spDeleteArtifact
-- Generated at: 2026-07-22T15:45:58.187Z
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Artifact
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteArtifact'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spDeleteArtifact"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM ${mjSchema}_bizappscommittees."Artifact"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteArtifact" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteArtifact" TO "cdp_Integration";

/* spDelete Permissions for Committees: Artifacts */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteArtifact" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteArtifact" TO "cdp_Integration";

/* Base View SQL for Committees: Attendances */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Attendances
-- Item: vwAttendances
-- Generated at: 2026-07-22T15:45:58.198Z
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Attendances
-----               SCHEMA:      ${mjSchema}_bizappscommittees
-----               BASE TABLE:  Attendance
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW ${mjSchema}_bizappscommittees."vwAttendances"
AS
SELECT
    a.*,
    mjbizappscommitteesMeeting_MeetingID."Name" AS "Meeting",
    mjBizAppsCommonPerson_PersonID."DisplayName" AS "Person"
FROM
    ${mjSchema}_bizappscommittees."Attendance" AS a
INNER JOIN
    ${mjSchema}_bizappscommittees."Meeting" AS mjbizappscommitteesMeeting_MeetingID
  ON
    "a"."MeetingID" = mjbizappscommitteesMeeting_MeetingID."ID"
INNER JOIN
    ${mjSchema}_bizappscommon."Person" AS mjBizAppsCommonPerson_PersonID
  ON
    "a"."PersonID" = mjBizAppsCommonPerson_PersonID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql)
  SELECT DISTINCT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'))
  FROM pg_depend d
  JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
  JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwAttendances'
    AND tc.relkind IN ('v', 'm')
    AND dc.oid <> tc.oid;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_proc pp ON pp.oid = d.objid AND d.classid = 'pg_proc'::regclass
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwAttendances'
    AND tc.relkind IN ('v', 'm')
  UNION
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_type pt ON pt.oid = d.refobjid AND d.refclassid = 'pg_type'::regclass
  JOIN pg_proc pp ON pp.prorettype = pt.oid OR pt.typrelid = pp.oid
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE EXISTS (
      SELECT 1 FROM pg_class tc
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tc.reltype = pt.oid
        AND tn.nspname = '${mjSchema}_bizappscommittees'
        AND tc.relname = 'vwAttendances'
        AND tc.relkind IN ('v', 'm')
  );

  DROP VIEW IF EXISTS ${mjSchema}_bizappscommittees."vwAttendances" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwAttendances" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwAttendances" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwAttendances" TO "cdp_Integration";

/* Base View Permissions SQL for Committees: Attendances */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Attendances
-- Item: Permissions for vwAttendances
-- Generated at: 2026-07-22T15:45:58.199Z
-- ============================================================
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwAttendances" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwAttendances" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwAttendances" TO "cdp_Integration";

/* spCreate SQL for Committees: Attendances */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Attendances
-- Item: spCreateAttendance
-- Generated at: 2026-07-22T15:45:58.199Z
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Attendance
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateAttendance'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spCreateAttendance"(
    p_id UUID DEFAULT NULL,
    p_meetingid UUID DEFAULT NULL,
    p_personid UUID DEFAULT NULL,
    p_attendancestatus varchar(50) DEFAULT NULL,
    p_joinedat_clear boolean DEFAULT false,
    p_joinedat TIMESTAMPTZ DEFAULT NULL,
    p_leftat_clear boolean DEFAULT false,
    p_leftat TIMESTAMPTZ DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes varchar(500) DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwAttendances" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO ${mjSchema}_bizappscommittees."Attendance"
        (
            "ID",
            "MeetingID",
                "PersonID",
                "AttendanceStatus",
                "JoinedAt",
                "LeftAt",
                "Notes"
        )
    VALUES
        (
            v_new_id,
            p_meetingid,
                p_personid,
                COALESCE(p_attendancestatus, 'Expected'),
                CASE WHEN p_joinedat_clear = true THEN NULL ELSE COALESCE(p_joinedat, NULL) END,
                CASE WHEN p_leftat_clear = true THEN NULL ELSE COALESCE(p_leftat, NULL) END,
                CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwAttendances"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateAttendance" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateAttendance" TO "cdp_Integration";

/* spCreate Permissions for Committees: Attendances */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateAttendance" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateAttendance" TO "cdp_Integration";

/* spUpdate SQL for Committees: Attendances */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Attendances
-- Item: spUpdateAttendance
-- Generated at: 2026-07-22T15:45:58.199Z
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Attendance
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateAttendance'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spUpdateAttendance"(
    p_id UUID,
    p_meetingid UUID DEFAULT NULL,
    p_personid UUID DEFAULT NULL,
    p_attendancestatus varchar(50) DEFAULT NULL,
    p_joinedat_clear boolean DEFAULT false,
    p_joinedat TIMESTAMPTZ DEFAULT NULL,
    p_leftat_clear boolean DEFAULT false,
    p_leftat TIMESTAMPTZ DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes varchar(500) DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwAttendances" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE ${mjSchema}_bizappscommittees."Attendance"
    SET
        "MeetingID" = COALESCE(p_meetingid, "MeetingID"),
        "PersonID" = COALESCE(p_personid, "PersonID"),
        "AttendanceStatus" = COALESCE(p_attendancestatus, "AttendanceStatus"),
        "JoinedAt" = CASE WHEN p_joinedat_clear = true THEN NULL ELSE COALESCE(p_joinedat, "JoinedAt") END,
        "LeftAt" = CASE WHEN p_leftat_clear = true THEN NULL ELSE COALESCE(p_leftat, "LeftAt") END,
        "Notes" = CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, "Notes") END
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwAttendances"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateAttendance" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateAttendance" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Attendance table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_attendance"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_attendance" ON ${mjSchema}_bizappscommittees."Attendance";

CREATE TRIGGER "trg_update_attendance"
BEFORE UPDATE ON ${mjSchema}_bizappscommittees."Attendance"
FOR EACH ROW
EXECUTE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_attendance"();

/* spUpdate Permissions for Committees: Attendances */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateAttendance" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateAttendance" TO "cdp_Integration";

/* spDelete SQL for Committees: Attendances */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Attendances
-- Item: spDeleteAttendance
-- Generated at: 2026-07-22T15:45:58.199Z
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Attendance
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteAttendance'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spDeleteAttendance"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM ${mjSchema}_bizappscommittees."Attendance"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteAttendance" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteAttendance" TO "cdp_Integration";

/* spDelete Permissions for Committees: Attendances */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteAttendance" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteAttendance" TO "cdp_Integration";

/* Base View SQL for Committees: Ballots */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Ballots
-- Item: vwBallots
-- Generated at: 2026-07-22T15:45:58.210Z
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Ballots
-----               SCHEMA:      ${mjSchema}_bizappscommittees
-----               BASE TABLE:  Ballot
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW ${mjSchema}_bizappscommittees."vwBallots"
AS
SELECT
    b.*,
    mjbizappscommitteesCommittee_CommitteeID."Name" AS "Committee",
    mjbizappscommitteesMotion_MotionID."Name" AS "Motion"
FROM
    ${mjSchema}_bizappscommittees."Ballot" AS b
INNER JOIN
    ${mjSchema}_bizappscommittees."Committee" AS mjbizappscommitteesCommittee_CommitteeID
  ON
    "b"."CommitteeID" = mjbizappscommitteesCommittee_CommitteeID."ID"
INNER JOIN
    ${mjSchema}_bizappscommittees."Motion" AS mjbizappscommitteesMotion_MotionID
  ON
    "b"."MotionID" = mjbizappscommitteesMotion_MotionID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql)
  SELECT DISTINCT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'))
  FROM pg_depend d
  JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
  JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwBallots'
    AND tc.relkind IN ('v', 'm')
    AND dc.oid <> tc.oid;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_proc pp ON pp.oid = d.objid AND d.classid = 'pg_proc'::regclass
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwBallots'
    AND tc.relkind IN ('v', 'm')
  UNION
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_type pt ON pt.oid = d.refobjid AND d.refclassid = 'pg_type'::regclass
  JOIN pg_proc pp ON pp.prorettype = pt.oid OR pt.typrelid = pp.oid
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE EXISTS (
      SELECT 1 FROM pg_class tc
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tc.reltype = pt.oid
        AND tn.nspname = '${mjSchema}_bizappscommittees'
        AND tc.relname = 'vwBallots'
        AND tc.relkind IN ('v', 'm')
  );

  DROP VIEW IF EXISTS ${mjSchema}_bizappscommittees."vwBallots" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwBallots" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwBallots" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwBallots" TO "cdp_Integration";

/* Base View Permissions SQL for Committees: Ballots */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Ballots
-- Item: Permissions for vwBallots
-- Generated at: 2026-07-22T15:45:58.211Z
-- ============================================================
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwBallots" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwBallots" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwBallots" TO "cdp_Integration";

/* spCreate SQL for Committees: Ballots */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Ballots
-- Item: spCreateBallot
-- Generated at: 2026-07-22T15:45:58.211Z
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Ballot
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateBallot'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spCreateBallot"(
    p_id UUID DEFAULT NULL,
    p_committeeid UUID DEFAULT NULL,
    p_motionid UUID DEFAULT NULL,
    p_opensat TIMESTAMPTZ DEFAULT NULL,
    p_closesat TIMESTAMPTZ DEFAULT NULL,
    p_closedat_clear boolean DEFAULT false,
    p_closedat TIMESTAMPTZ DEFAULT NULL,
    p_thresholdtype varchar(20) DEFAULT NULL,
    p_issealed BOOLEAN DEFAULT NULL,
    p_status varchar(20) DEFAULT NULL,
    p_createdbymembershipid_clear boolean DEFAULT false,
    p_createdbymembershipid UUID DEFAULT NULL,
    p_resultnotes_clear boolean DEFAULT false,
    p_resultnotes TEXT DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwBallots" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO ${mjSchema}_bizappscommittees."Ballot"
        (
            "ID",
            "CommitteeID",
                "MotionID",
                "OpensAt",
                "ClosesAt",
                "ClosedAt",
                "ThresholdType",
                "IsSealed",
                "Status",
                "CreatedByMembershipID",
                "ResultNotes"
        )
    VALUES
        (
            v_new_id,
            p_committeeid,
                p_motionid,
                p_opensat,
                p_closesat,
                CASE WHEN p_closedat_clear = true THEN NULL ELSE COALESCE(p_closedat, NULL) END,
                COALESCE(p_thresholdtype, 'SimpleMajority'),
                COALESCE(p_issealed, TRUE),
                COALESCE(p_status, 'Open'),
                CASE WHEN p_createdbymembershipid_clear = true THEN NULL ELSE COALESCE(p_createdbymembershipid, NULL) END,
                CASE WHEN p_resultnotes_clear = true THEN NULL ELSE COALESCE(p_resultnotes, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwBallots"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateBallot" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateBallot" TO "cdp_Integration";

/* spCreate Permissions for Committees: Ballots */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateBallot" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateBallot" TO "cdp_Integration";

/* spUpdate SQL for Committees: Ballots */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Ballots
-- Item: spUpdateBallot
-- Generated at: 2026-07-22T15:45:58.211Z
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Ballot
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateBallot'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spUpdateBallot"(
    p_id UUID,
    p_committeeid UUID DEFAULT NULL,
    p_motionid UUID DEFAULT NULL,
    p_opensat TIMESTAMPTZ DEFAULT NULL,
    p_closesat TIMESTAMPTZ DEFAULT NULL,
    p_closedat_clear boolean DEFAULT false,
    p_closedat TIMESTAMPTZ DEFAULT NULL,
    p_thresholdtype varchar(20) DEFAULT NULL,
    p_issealed BOOLEAN DEFAULT NULL,
    p_status varchar(20) DEFAULT NULL,
    p_createdbymembershipid_clear boolean DEFAULT false,
    p_createdbymembershipid UUID DEFAULT NULL,
    p_resultnotes_clear boolean DEFAULT false,
    p_resultnotes TEXT DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwBallots" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE ${mjSchema}_bizappscommittees."Ballot"
    SET
        "CommitteeID" = COALESCE(p_committeeid, "CommitteeID"),
        "MotionID" = COALESCE(p_motionid, "MotionID"),
        "OpensAt" = COALESCE(p_opensat, "OpensAt"),
        "ClosesAt" = COALESCE(p_closesat, "ClosesAt"),
        "ClosedAt" = CASE WHEN p_closedat_clear = true THEN NULL ELSE COALESCE(p_closedat, "ClosedAt") END,
        "ThresholdType" = COALESCE(p_thresholdtype, "ThresholdType"),
        "IsSealed" = COALESCE(p_issealed, "IsSealed"),
        "Status" = COALESCE(p_status, "Status"),
        "CreatedByMembershipID" = CASE WHEN p_createdbymembershipid_clear = true THEN NULL ELSE COALESCE(p_createdbymembershipid, "CreatedByMembershipID") END,
        "ResultNotes" = CASE WHEN p_resultnotes_clear = true THEN NULL ELSE COALESCE(p_resultnotes, "ResultNotes") END
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwBallots"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateBallot" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateBallot" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Ballot table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_ballot"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_ballot" ON ${mjSchema}_bizappscommittees."Ballot";

CREATE TRIGGER "trg_update_ballot"
BEFORE UPDATE ON ${mjSchema}_bizappscommittees."Ballot"
FOR EACH ROW
EXECUTE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_ballot"();

/* spUpdate Permissions for Committees: Ballots */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateBallot" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateBallot" TO "cdp_Integration";

/* spDelete SQL for Committees: Ballots */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Ballots
-- Item: spDeleteBallot
-- Generated at: 2026-07-22T15:45:58.211Z
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Ballot
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteBallot'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spDeleteBallot"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM ${mjSchema}_bizappscommittees."Ballot"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteBallot" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteBallot" TO "cdp_Integration";

/* spDelete Permissions for Committees: Ballots */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteBallot" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteBallot" TO "cdp_Integration";

/* Root ID Function SQL for Committees: Comments.ParentCommentID */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Comments
-- Item: fnCommentParentCommentID_GetRootID
-- Generated at: 2026-07-22T15:45:58.220Z
-- ============================================================

------------------------------------------------------------
----- ROOT ID FUNCTION FOR: Comment.ParentCommentID
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_comment_parent_comment_id_get_root_id"(
    p_record_id UUID,
    p_parent_id UUID
) RETURNS UUID AS $$
    WITH RECURSIVE cte_root_parent AS (
        -- Anchor: Start from p_parent_id if not null, otherwise start from p_record_id
        SELECT
            "ID",
            "ParentCommentID",
            "ID" AS root_parent_id,
            0 AS depth
        FROM
            ${mjSchema}_bizappscommittees."Comment"
        WHERE
            "ID" = COALESCE(p_parent_id, p_record_id)

        UNION ALL

        -- Recursive: Keep going up the hierarchy
        SELECT
            c."ID",
            c."ParentCommentID",
            c."ID" AS root_parent_id,
            p.depth + 1 AS depth
        FROM
            ${mjSchema}_bizappscommittees."Comment" c
        INNER JOIN
            cte_root_parent p ON c."ID" = p."ParentCommentID"
        WHERE
            p.depth < 100  -- Prevent infinite loops
    )
    SELECT root_parent_id
    FROM cte_root_parent
    WHERE "ParentCommentID" IS NULL
    ORDER BY root_parent_id
    LIMIT 1;
$$ LANGUAGE sql STABLE;

/* Base View SQL for Committees: Comments */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Comments
-- Item: vwComments
-- Generated at: 2026-07-22T15:45:58.220Z
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Comments
-----               SCHEMA:      ${mjSchema}_bizappscommittees
-----               BASE TABLE:  Comment
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW ${mjSchema}_bizappscommittees."vwComments"
AS
SELECT
    c.*,
    mjbizappscommitteesCommittee_CommitteeID."Name" AS "Committee",
    mjbizappscommitteesMeeting_MeetingID."Name" AS "Meeting",
    mjbizappscommitteesAgendaItem_AgendaItemID."Name" AS "AgendaItem",
    mjBizAppsTasksTask_TaskID."Name" AS "Task",
    mjbizappscommitteesArtifact_ArtifactID."Name" AS "Artifact",
    mjBizAppsCommonPerson_PersonID."DisplayName" AS "Person",
    root_ParentCommentID.root_id AS "RootParentCommentID"
FROM
    ${mjSchema}_bizappscommittees."Comment" AS c
INNER JOIN
    ${mjSchema}_bizappscommittees."Committee" AS mjbizappscommitteesCommittee_CommitteeID
  ON
    "c"."CommitteeID" = mjbizappscommitteesCommittee_CommitteeID."ID"
LEFT OUTER JOIN
    ${mjSchema}_bizappscommittees."Meeting" AS mjbizappscommitteesMeeting_MeetingID
  ON
    "c"."MeetingID" = mjbizappscommitteesMeeting_MeetingID."ID"
LEFT OUTER JOIN
    ${mjSchema}_bizappscommittees."AgendaItem" AS mjbizappscommitteesAgendaItem_AgendaItemID
  ON
    "c"."AgendaItemID" = mjbizappscommitteesAgendaItem_AgendaItemID."ID"
LEFT OUTER JOIN
    ${mjSchema}_bizappstasks."Task" AS mjBizAppsTasksTask_TaskID
  ON
    "c"."TaskID" = mjBizAppsTasksTask_TaskID."ID"
LEFT OUTER JOIN
    ${mjSchema}_bizappscommittees."Artifact" AS mjbizappscommitteesArtifact_ArtifactID
  ON
    "c"."ArtifactID" = mjbizappscommitteesArtifact_ArtifactID."ID"
INNER JOIN
    ${mjSchema}_bizappscommon."Person" AS mjBizAppsCommonPerson_PersonID
  ON
    "c"."PersonID" = mjBizAppsCommonPerson_PersonID."ID"

LEFT JOIN LATERAL (
    SELECT ${mjSchema}_bizappscommittees."fn_comment_parent_comment_id_get_root_id"(c."ID", c."ParentCommentID") AS root_id
) AS root_ParentCommentID ON true
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql)
  SELECT DISTINCT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'))
  FROM pg_depend d
  JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
  JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwComments'
    AND tc.relkind IN ('v', 'm')
    AND dc.oid <> tc.oid;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_proc pp ON pp.oid = d.objid AND d.classid = 'pg_proc'::regclass
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwComments'
    AND tc.relkind IN ('v', 'm')
  UNION
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_type pt ON pt.oid = d.refobjid AND d.refclassid = 'pg_type'::regclass
  JOIN pg_proc pp ON pp.prorettype = pt.oid OR pt.typrelid = pp.oid
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE EXISTS (
      SELECT 1 FROM pg_class tc
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tc.reltype = pt.oid
        AND tn.nspname = '${mjSchema}_bizappscommittees'
        AND tc.relname = 'vwComments'
        AND tc.relkind IN ('v', 'm')
  );

  DROP VIEW IF EXISTS ${mjSchema}_bizappscommittees."vwComments" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwComments" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwComments" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwComments" TO "cdp_Integration";

/* Base View Permissions SQL for Committees: Comments */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Comments
-- Item: Permissions for vwComments
-- Generated at: 2026-07-22T15:45:58.221Z
-- ============================================================
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwComments" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwComments" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwComments" TO "cdp_Integration";

/* spCreate SQL for Committees: Comments */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Comments
-- Item: spCreateComment
-- Generated at: 2026-07-22T15:45:58.222Z
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Comment
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateComment'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spCreateComment"(
    p_id UUID DEFAULT NULL,
    p_committeeid UUID DEFAULT NULL,
    p_meetingid_clear boolean DEFAULT false,
    p_meetingid UUID DEFAULT NULL,
    p_agendaitemid_clear boolean DEFAULT false,
    p_agendaitemid UUID DEFAULT NULL,
    p_taskid_clear boolean DEFAULT false,
    p_taskid UUID DEFAULT NULL,
    p_artifactid_clear boolean DEFAULT false,
    p_artifactid UUID DEFAULT NULL,
    p_parentcommentid_clear boolean DEFAULT false,
    p_parentcommentid UUID DEFAULT NULL,
    p_personid UUID DEFAULT NULL,
    p_commenttext TEXT DEFAULT NULL,
    p_mentionedpersonids_clear boolean DEFAULT false,
    p_mentionedpersonids TEXT DEFAULT NULL,
    p_isresolved BOOLEAN DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwComments" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO ${mjSchema}_bizappscommittees."Comment"
        (
            "ID",
            "CommitteeID",
                "MeetingID",
                "AgendaItemID",
                "TaskID",
                "ArtifactID",
                "ParentCommentID",
                "PersonID",
                "CommentText",
                "MentionedPersonIDs",
                "IsResolved"
        )
    VALUES
        (
            v_new_id,
            p_committeeid,
                CASE WHEN p_meetingid_clear = true THEN NULL ELSE COALESCE(p_meetingid, NULL) END,
                CASE WHEN p_agendaitemid_clear = true THEN NULL ELSE COALESCE(p_agendaitemid, NULL) END,
                CASE WHEN p_taskid_clear = true THEN NULL ELSE COALESCE(p_taskid, NULL) END,
                CASE WHEN p_artifactid_clear = true THEN NULL ELSE COALESCE(p_artifactid, NULL) END,
                CASE WHEN p_parentcommentid_clear = true THEN NULL ELSE COALESCE(p_parentcommentid, NULL) END,
                p_personid,
                p_commenttext,
                CASE WHEN p_mentionedpersonids_clear = true THEN NULL ELSE COALESCE(p_mentionedpersonids, NULL) END,
                COALESCE(p_isresolved, FALSE)
        )
    ;

    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwComments"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateComment" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateComment" TO "cdp_Integration";

/* spCreate Permissions for Committees: Comments */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateComment" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateComment" TO "cdp_Integration";

/* spUpdate SQL for Committees: Comments */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Comments
-- Item: spUpdateComment
-- Generated at: 2026-07-22T15:45:58.222Z
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Comment
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateComment'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spUpdateComment"(
    p_id UUID,
    p_committeeid UUID DEFAULT NULL,
    p_meetingid_clear boolean DEFAULT false,
    p_meetingid UUID DEFAULT NULL,
    p_agendaitemid_clear boolean DEFAULT false,
    p_agendaitemid UUID DEFAULT NULL,
    p_taskid_clear boolean DEFAULT false,
    p_taskid UUID DEFAULT NULL,
    p_artifactid_clear boolean DEFAULT false,
    p_artifactid UUID DEFAULT NULL,
    p_parentcommentid_clear boolean DEFAULT false,
    p_parentcommentid UUID DEFAULT NULL,
    p_personid UUID DEFAULT NULL,
    p_commenttext TEXT DEFAULT NULL,
    p_mentionedpersonids_clear boolean DEFAULT false,
    p_mentionedpersonids TEXT DEFAULT NULL,
    p_isresolved BOOLEAN DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwComments" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE ${mjSchema}_bizappscommittees."Comment"
    SET
        "CommitteeID" = COALESCE(p_committeeid, "CommitteeID"),
        "MeetingID" = CASE WHEN p_meetingid_clear = true THEN NULL ELSE COALESCE(p_meetingid, "MeetingID") END,
        "AgendaItemID" = CASE WHEN p_agendaitemid_clear = true THEN NULL ELSE COALESCE(p_agendaitemid, "AgendaItemID") END,
        "TaskID" = CASE WHEN p_taskid_clear = true THEN NULL ELSE COALESCE(p_taskid, "TaskID") END,
        "ArtifactID" = CASE WHEN p_artifactid_clear = true THEN NULL ELSE COALESCE(p_artifactid, "ArtifactID") END,
        "ParentCommentID" = CASE WHEN p_parentcommentid_clear = true THEN NULL ELSE COALESCE(p_parentcommentid, "ParentCommentID") END,
        "PersonID" = COALESCE(p_personid, "PersonID"),
        "CommentText" = COALESCE(p_commenttext, "CommentText"),
        "MentionedPersonIDs" = CASE WHEN p_mentionedpersonids_clear = true THEN NULL ELSE COALESCE(p_mentionedpersonids, "MentionedPersonIDs") END,
        "IsResolved" = COALESCE(p_isresolved, "IsResolved")
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwComments"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateComment" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateComment" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Comment table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_comment"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_comment" ON ${mjSchema}_bizappscommittees."Comment";

CREATE TRIGGER "trg_update_comment"
BEFORE UPDATE ON ${mjSchema}_bizappscommittees."Comment"
FOR EACH ROW
EXECUTE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_comment"();

/* spUpdate Permissions for Committees: Comments */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateComment" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateComment" TO "cdp_Integration";

/* spDelete SQL for Committees: Comments */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Comments
-- Item: spDeleteComment
-- Generated at: 2026-07-22T15:45:58.222Z
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Comment
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteComment'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spDeleteComment"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM ${mjSchema}_bizappscommittees."Comment"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteComment" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteComment" TO "cdp_Integration";

/* spDelete Permissions for Committees: Comments */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteComment" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteComment" TO "cdp_Integration";

/* Root ID Function SQL for Committees: Committees.ParentCommitteeID */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Committees
-- Item: fnCommitteeParentCommitteeID_GetRootID
-- Generated at: 2026-07-22T15:45:58.233Z
-- ============================================================

------------------------------------------------------------
----- ROOT ID FUNCTION FOR: Committee.ParentCommitteeID
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_committee_parent_committee_id_get_root_id"(
    p_record_id UUID,
    p_parent_id UUID
) RETURNS UUID AS $$
    WITH RECURSIVE cte_root_parent AS (
        -- Anchor: Start from p_parent_id if not null, otherwise start from p_record_id
        SELECT
            "ID",
            "ParentCommitteeID",
            "ID" AS root_parent_id,
            0 AS depth
        FROM
            ${mjSchema}_bizappscommittees."Committee"
        WHERE
            "ID" = COALESCE(p_parent_id, p_record_id)

        UNION ALL

        -- Recursive: Keep going up the hierarchy
        SELECT
            c."ID",
            c."ParentCommitteeID",
            c."ID" AS root_parent_id,
            p.depth + 1 AS depth
        FROM
            ${mjSchema}_bizappscommittees."Committee" c
        INNER JOIN
            cte_root_parent p ON c."ID" = p."ParentCommitteeID"
        WHERE
            p.depth < 100  -- Prevent infinite loops
    )
    SELECT root_parent_id
    FROM cte_root_parent
    WHERE "ParentCommitteeID" IS NULL
    ORDER BY root_parent_id
    LIMIT 1;
$$ LANGUAGE sql STABLE;

/* Base View SQL for Committees: Committees */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Committees
-- Item: vwCommittees
-- Generated at: 2026-07-22T15:45:58.233Z
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Committees
-----               SCHEMA:      ${mjSchema}_bizappscommittees
-----               BASE TABLE:  Committee
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW ${mjSchema}_bizappscommittees."vwCommittees"
AS
SELECT
    c.*,
    mjbizappscommitteesType_TypeID."Name" AS "Type",
    mjbizappscommitteesCommittee_ParentCommitteeID."Name" AS "ParentCommittee",
    mjBizAppsCommonOrganization_OrganizationID."Name" AS "Organization",
    root_ParentCommitteeID.root_id AS "RootParentCommitteeID"
FROM
    ${mjSchema}_bizappscommittees."Committee" AS c
INNER JOIN
    ${mjSchema}_bizappscommittees."Type" AS mjbizappscommitteesType_TypeID
  ON
    "c"."TypeID" = mjbizappscommitteesType_TypeID."ID"
LEFT OUTER JOIN
    ${mjSchema}_bizappscommittees."Committee" AS mjbizappscommitteesCommittee_ParentCommitteeID
  ON
    "c"."ParentCommitteeID" = mjbizappscommitteesCommittee_ParentCommitteeID."ID"
LEFT OUTER JOIN
    ${mjSchema}_bizappscommon."Organization" AS mjBizAppsCommonOrganization_OrganizationID
  ON
    "c"."OrganizationID" = mjBizAppsCommonOrganization_OrganizationID."ID"

LEFT JOIN LATERAL (
    SELECT ${mjSchema}_bizappscommittees."fn_committee_parent_committee_id_get_root_id"(c."ID", c."ParentCommitteeID") AS root_id
) AS root_ParentCommitteeID ON true
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql)
  SELECT DISTINCT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'))
  FROM pg_depend d
  JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
  JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwCommittees'
    AND tc.relkind IN ('v', 'm')
    AND dc.oid <> tc.oid;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_proc pp ON pp.oid = d.objid AND d.classid = 'pg_proc'::regclass
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwCommittees'
    AND tc.relkind IN ('v', 'm')
  UNION
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_type pt ON pt.oid = d.refobjid AND d.refclassid = 'pg_type'::regclass
  JOIN pg_proc pp ON pp.prorettype = pt.oid OR pt.typrelid = pp.oid
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE EXISTS (
      SELECT 1 FROM pg_class tc
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tc.reltype = pt.oid
        AND tn.nspname = '${mjSchema}_bizappscommittees'
        AND tc.relname = 'vwCommittees'
        AND tc.relkind IN ('v', 'm')
  );

  DROP VIEW IF EXISTS ${mjSchema}_bizappscommittees."vwCommittees" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwCommittees" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwCommittees" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwCommittees" TO "cdp_Integration";

/* Base View Permissions SQL for Committees: Committees */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Committees
-- Item: Permissions for vwCommittees
-- Generated at: 2026-07-22T15:45:58.234Z
-- ============================================================
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwCommittees" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwCommittees" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwCommittees" TO "cdp_Integration";

/* spCreate SQL for Committees: Committees */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Committees
-- Item: spCreateCommittee
-- Generated at: 2026-07-22T15:45:58.235Z
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Committee
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateCommittee'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spCreateCommittee"(
    p_id UUID DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_typeid UUID DEFAULT NULL,
    p_parentcommitteeid_clear boolean DEFAULT false,
    p_parentcommitteeid UUID DEFAULT NULL,
    p_organizationid_clear boolean DEFAULT false,
    p_organizationid UUID DEFAULT NULL,
    p_charterdocumenturl_clear boolean DEFAULT false,
    p_charterdocumenturl varchar(1000) DEFAULT NULL,
    p_missionstatement_clear boolean DEFAULT false,
    p_missionstatement TEXT DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL,
    p_ispublic BOOLEAN DEFAULT NULL,
    p_formationdate_clear boolean DEFAULT false,
    p_formationdate date DEFAULT NULL,
    p_dissolutiondate_clear boolean DEFAULT false,
    p_dissolutiondate date DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwCommittees" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO ${mjSchema}_bizappscommittees."Committee"
        (
            "ID",
            "Name",
                "Description",
                "TypeID",
                "ParentCommitteeID",
                "OrganizationID",
                "CharterDocumentURL",
                "MissionStatement",
                "Status",
                "IsPublic",
                "FormationDate",
                "DissolutionDate"
        )
    VALUES
        (
            v_new_id,
            p_name,
                CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, NULL) END,
                p_typeid,
                CASE WHEN p_parentcommitteeid_clear = true THEN NULL ELSE COALESCE(p_parentcommitteeid, NULL) END,
                CASE WHEN p_organizationid_clear = true THEN NULL ELSE COALESCE(p_organizationid, NULL) END,
                CASE WHEN p_charterdocumenturl_clear = true THEN NULL ELSE COALESCE(p_charterdocumenturl, NULL) END,
                CASE WHEN p_missionstatement_clear = true THEN NULL ELSE COALESCE(p_missionstatement, NULL) END,
                COALESCE(p_status, 'Active'),
                COALESCE(p_ispublic, TRUE),
                CASE WHEN p_formationdate_clear = true THEN NULL ELSE COALESCE(p_formationdate, NULL) END,
                CASE WHEN p_dissolutiondate_clear = true THEN NULL ELSE COALESCE(p_dissolutiondate, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwCommittees"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateCommittee" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateCommittee" TO "cdp_Integration";

/* spCreate Permissions for Committees: Committees */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateCommittee" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateCommittee" TO "cdp_Integration";

/* spUpdate SQL for Committees: Committees */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Committees
-- Item: spUpdateCommittee
-- Generated at: 2026-07-22T15:45:58.235Z
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Committee
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateCommittee'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spUpdateCommittee"(
    p_id UUID,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_typeid UUID DEFAULT NULL,
    p_parentcommitteeid_clear boolean DEFAULT false,
    p_parentcommitteeid UUID DEFAULT NULL,
    p_organizationid_clear boolean DEFAULT false,
    p_organizationid UUID DEFAULT NULL,
    p_charterdocumenturl_clear boolean DEFAULT false,
    p_charterdocumenturl varchar(1000) DEFAULT NULL,
    p_missionstatement_clear boolean DEFAULT false,
    p_missionstatement TEXT DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL,
    p_ispublic BOOLEAN DEFAULT NULL,
    p_formationdate_clear boolean DEFAULT false,
    p_formationdate date DEFAULT NULL,
    p_dissolutiondate_clear boolean DEFAULT false,
    p_dissolutiondate date DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwCommittees" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE ${mjSchema}_bizappscommittees."Committee"
    SET
        "Name" = COALESCE(p_name, "Name"),
        "Description" = CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, "Description") END,
        "TypeID" = COALESCE(p_typeid, "TypeID"),
        "ParentCommitteeID" = CASE WHEN p_parentcommitteeid_clear = true THEN NULL ELSE COALESCE(p_parentcommitteeid, "ParentCommitteeID") END,
        "OrganizationID" = CASE WHEN p_organizationid_clear = true THEN NULL ELSE COALESCE(p_organizationid, "OrganizationID") END,
        "CharterDocumentURL" = CASE WHEN p_charterdocumenturl_clear = true THEN NULL ELSE COALESCE(p_charterdocumenturl, "CharterDocumentURL") END,
        "MissionStatement" = CASE WHEN p_missionstatement_clear = true THEN NULL ELSE COALESCE(p_missionstatement, "MissionStatement") END,
        "Status" = COALESCE(p_status, "Status"),
        "IsPublic" = COALESCE(p_ispublic, "IsPublic"),
        "FormationDate" = CASE WHEN p_formationdate_clear = true THEN NULL ELSE COALESCE(p_formationdate, "FormationDate") END,
        "DissolutionDate" = CASE WHEN p_dissolutiondate_clear = true THEN NULL ELSE COALESCE(p_dissolutiondate, "DissolutionDate") END
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwCommittees"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateCommittee" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateCommittee" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Committee table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_committee"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_committee" ON ${mjSchema}_bizappscommittees."Committee";

CREATE TRIGGER "trg_update_committee"
BEFORE UPDATE ON ${mjSchema}_bizappscommittees."Committee"
FOR EACH ROW
EXECUTE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_committee"();

/* spUpdate Permissions for Committees: Committees */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateCommittee" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateCommittee" TO "cdp_Integration";

/* spDelete SQL for Committees: Committees */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Committees
-- Item: spDeleteCommittee
-- Generated at: 2026-07-22T15:45:58.236Z
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Committee
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteCommittee'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spDeleteCommittee"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM ${mjSchema}_bizappscommittees."Committee"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteCommittee" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteCommittee" TO "cdp_Integration";

/* spDelete Permissions for Committees: Committees */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteCommittee" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteCommittee" TO "cdp_Integration";

/* Base View SQL for Committees: Meetings */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Meetings
-- Item: vwMeetings
-- Generated at: 2026-07-22T15:45:58.244Z
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Meetings
-----               SCHEMA:      ${mjSchema}_bizappscommittees
-----               BASE TABLE:  Meeting
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW ${mjSchema}_bizappscommittees."vwMeetings"
AS
SELECT
    m.*,
    mjbizappscommitteesCommittee_CommitteeID."Name" AS "Committee",
    mjbizappscommitteesVideoProvider_VideoProviderID."Name" AS "VideoProvider_Virtual"
FROM
    ${mjSchema}_bizappscommittees."Meeting" AS m
INNER JOIN
    ${mjSchema}_bizappscommittees."Committee" AS mjbizappscommitteesCommittee_CommitteeID
  ON
    "m"."CommitteeID" = mjbizappscommitteesCommittee_CommitteeID."ID"
LEFT OUTER JOIN
    ${mjSchema}_bizappscommittees."VideoProvider" AS mjbizappscommitteesVideoProvider_VideoProviderID
  ON
    "m"."VideoProviderID" = mjbizappscommitteesVideoProvider_VideoProviderID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql)
  SELECT DISTINCT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'))
  FROM pg_depend d
  JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
  JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwMeetings'
    AND tc.relkind IN ('v', 'm')
    AND dc.oid <> tc.oid;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_proc pp ON pp.oid = d.objid AND d.classid = 'pg_proc'::regclass
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwMeetings'
    AND tc.relkind IN ('v', 'm')
  UNION
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_type pt ON pt.oid = d.refobjid AND d.refclassid = 'pg_type'::regclass
  JOIN pg_proc pp ON pp.prorettype = pt.oid OR pt.typrelid = pp.oid
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE EXISTS (
      SELECT 1 FROM pg_class tc
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tc.reltype = pt.oid
        AND tn.nspname = '${mjSchema}_bizappscommittees'
        AND tc.relname = 'vwMeetings'
        AND tc.relkind IN ('v', 'm')
  );

  DROP VIEW IF EXISTS ${mjSchema}_bizappscommittees."vwMeetings" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMeetings" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMeetings" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMeetings" TO "cdp_Integration";

/* Base View Permissions SQL for Committees: Meetings */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Meetings
-- Item: Permissions for vwMeetings
-- Generated at: 2026-07-22T15:45:58.245Z
-- ============================================================
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMeetings" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMeetings" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMeetings" TO "cdp_Integration";

/* spCreate SQL for Committees: Meetings */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Meetings
-- Item: spCreateMeeting
-- Generated at: 2026-07-22T15:45:58.245Z
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Meeting
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateMeeting'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spCreateMeeting"(
    p_id UUID DEFAULT NULL,
    p_committeeid UUID DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_startdatetime TIMESTAMPTZ DEFAULT NULL,
    p_enddatetime_clear boolean DEFAULT false,
    p_enddatetime TIMESTAMPTZ DEFAULT NULL,
    p_timezone varchar(50) DEFAULT NULL,
    p_locationtype varchar(50) DEFAULT NULL,
    p_locationtext_clear boolean DEFAULT false,
    p_locationtext varchar(500) DEFAULT NULL,
    p_videoprovider_clear boolean DEFAULT false,
    p_videoprovider varchar(50) DEFAULT NULL,
    p_videoproviderid_clear boolean DEFAULT false,
    p_videoproviderid UUID DEFAULT NULL,
    p_videomeetingid_clear boolean DEFAULT false,
    p_videomeetingid varchar(255) DEFAULT NULL,
    p_videojoinurl_clear boolean DEFAULT false,
    p_videojoinurl varchar(1000) DEFAULT NULL,
    p_videorecordingurl_clear boolean DEFAULT false,
    p_videorecordingurl varchar(1000) DEFAULT NULL,
    p_transcripturl_clear boolean DEFAULT false,
    p_transcripturl varchar(1000) DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL,
    p_calendareventid_clear boolean DEFAULT false,
    p_calendareventid varchar(255) DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwMeetings" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO ${mjSchema}_bizappscommittees."Meeting"
        (
            "ID",
            "CommitteeID",
                "Name",
                "Description",
                "StartDateTime",
                "EndDateTime",
                "TimeZone",
                "LocationType",
                "LocationText",
                "VideoProvider",
                "VideoProviderID",
                "VideoMeetingID",
                "VideoJoinURL",
                "VideoRecordingURL",
                "TranscriptURL",
                "Status",
                "CalendarEventID"
        )
    VALUES
        (
            v_new_id,
            p_committeeid,
                p_name,
                CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, NULL) END,
                p_startdatetime,
                CASE WHEN p_enddatetime_clear = true THEN NULL ELSE COALESCE(p_enddatetime, NULL) END,
                COALESCE(p_timezone, 'America/New_York'),
                COALESCE(p_locationtype, 'Virtual'),
                CASE WHEN p_locationtext_clear = true THEN NULL ELSE COALESCE(p_locationtext, NULL) END,
                CASE WHEN p_videoprovider_clear = true THEN NULL ELSE COALESCE(p_videoprovider, NULL) END,
                CASE WHEN p_videoproviderid_clear = true THEN NULL ELSE COALESCE(p_videoproviderid, NULL) END,
                CASE WHEN p_videomeetingid_clear = true THEN NULL ELSE COALESCE(p_videomeetingid, NULL) END,
                CASE WHEN p_videojoinurl_clear = true THEN NULL ELSE COALESCE(p_videojoinurl, NULL) END,
                CASE WHEN p_videorecordingurl_clear = true THEN NULL ELSE COALESCE(p_videorecordingurl, NULL) END,
                CASE WHEN p_transcripturl_clear = true THEN NULL ELSE COALESCE(p_transcripturl, NULL) END,
                COALESCE(p_status, 'Scheduled'),
                CASE WHEN p_calendareventid_clear = true THEN NULL ELSE COALESCE(p_calendareventid, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwMeetings"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateMeeting" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateMeeting" TO "cdp_Integration";

/* spCreate Permissions for Committees: Meetings */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateMeeting" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateMeeting" TO "cdp_Integration";

/* spUpdate SQL for Committees: Meetings */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Meetings
-- Item: spUpdateMeeting
-- Generated at: 2026-07-22T15:45:58.246Z
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Meeting
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateMeeting'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spUpdateMeeting"(
    p_id UUID,
    p_committeeid UUID DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_startdatetime TIMESTAMPTZ DEFAULT NULL,
    p_enddatetime_clear boolean DEFAULT false,
    p_enddatetime TIMESTAMPTZ DEFAULT NULL,
    p_timezone varchar(50) DEFAULT NULL,
    p_locationtype varchar(50) DEFAULT NULL,
    p_locationtext_clear boolean DEFAULT false,
    p_locationtext varchar(500) DEFAULT NULL,
    p_videoprovider_clear boolean DEFAULT false,
    p_videoprovider varchar(50) DEFAULT NULL,
    p_videoproviderid_clear boolean DEFAULT false,
    p_videoproviderid UUID DEFAULT NULL,
    p_videomeetingid_clear boolean DEFAULT false,
    p_videomeetingid varchar(255) DEFAULT NULL,
    p_videojoinurl_clear boolean DEFAULT false,
    p_videojoinurl varchar(1000) DEFAULT NULL,
    p_videorecordingurl_clear boolean DEFAULT false,
    p_videorecordingurl varchar(1000) DEFAULT NULL,
    p_transcripturl_clear boolean DEFAULT false,
    p_transcripturl varchar(1000) DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL,
    p_calendareventid_clear boolean DEFAULT false,
    p_calendareventid varchar(255) DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwMeetings" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE ${mjSchema}_bizappscommittees."Meeting"
    SET
        "CommitteeID" = COALESCE(p_committeeid, "CommitteeID"),
        "Name" = COALESCE(p_name, "Name"),
        "Description" = CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, "Description") END,
        "StartDateTime" = COALESCE(p_startdatetime, "StartDateTime"),
        "EndDateTime" = CASE WHEN p_enddatetime_clear = true THEN NULL ELSE COALESCE(p_enddatetime, "EndDateTime") END,
        "TimeZone" = COALESCE(p_timezone, "TimeZone"),
        "LocationType" = COALESCE(p_locationtype, "LocationType"),
        "LocationText" = CASE WHEN p_locationtext_clear = true THEN NULL ELSE COALESCE(p_locationtext, "LocationText") END,
        "VideoProvider" = CASE WHEN p_videoprovider_clear = true THEN NULL ELSE COALESCE(p_videoprovider, "VideoProvider") END,
        "VideoProviderID" = CASE WHEN p_videoproviderid_clear = true THEN NULL ELSE COALESCE(p_videoproviderid, "VideoProviderID") END,
        "VideoMeetingID" = CASE WHEN p_videomeetingid_clear = true THEN NULL ELSE COALESCE(p_videomeetingid, "VideoMeetingID") END,
        "VideoJoinURL" = CASE WHEN p_videojoinurl_clear = true THEN NULL ELSE COALESCE(p_videojoinurl, "VideoJoinURL") END,
        "VideoRecordingURL" = CASE WHEN p_videorecordingurl_clear = true THEN NULL ELSE COALESCE(p_videorecordingurl, "VideoRecordingURL") END,
        "TranscriptURL" = CASE WHEN p_transcripturl_clear = true THEN NULL ELSE COALESCE(p_transcripturl, "TranscriptURL") END,
        "Status" = COALESCE(p_status, "Status"),
        "CalendarEventID" = CASE WHEN p_calendareventid_clear = true THEN NULL ELSE COALESCE(p_calendareventid, "CalendarEventID") END
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwMeetings"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateMeeting" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateMeeting" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Meeting table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_meeting"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_meeting" ON ${mjSchema}_bizappscommittees."Meeting";

CREATE TRIGGER "trg_update_meeting"
BEFORE UPDATE ON ${mjSchema}_bizappscommittees."Meeting"
FOR EACH ROW
EXECUTE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_meeting"();

/* spUpdate Permissions for Committees: Meetings */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateMeeting" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateMeeting" TO "cdp_Integration";

/* spDelete SQL for Committees: Meetings */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Meetings
-- Item: spDeleteMeeting
-- Generated at: 2026-07-22T15:45:58.246Z
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Meeting
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteMeeting'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spDeleteMeeting"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM ${mjSchema}_bizappscommittees."Meeting"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteMeeting" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteMeeting" TO "cdp_Integration";

/* spDelete Permissions for Committees: Meetings */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteMeeting" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteMeeting" TO "cdp_Integration";

/* Index for Foreign Keys for Membership */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Memberships
-- Item: Index for Foreign Keys
-- Generated at: 2026-07-22T15:45:58.254Z
-- ============================================================
CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_membership_person_id"
    ON ${mjSchema}_bizappscommittees."Membership" ("PersonID");

CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_membership_role_id"
    ON ${mjSchema}_bizappscommittees."Membership" ("RoleID");

CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_membership_term_id"
    ON ${mjSchema}_bizappscommittees."Membership" ("TermID");

/* Base View SQL for Committees: Memberships */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Memberships
-- Item: vwMemberships
-- Generated at: 2026-07-22T15:45:58.254Z
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Memberships
-----               SCHEMA:      ${mjSchema}_bizappscommittees
-----               BASE TABLE:  Membership
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW ${mjSchema}_bizappscommittees."vwMemberships"
AS
SELECT
    m.*,
    mjBizAppsCommonPerson_PersonID."DisplayName" AS "Person",
    mjbizappscommitteesRole_RoleID."Name" AS "Role",
    mjbizappscommitteesTerm_TermID."Name" AS "Term"
FROM
    ${mjSchema}_bizappscommittees."Membership" AS m
INNER JOIN
    ${mjSchema}_bizappscommon."Person" AS mjBizAppsCommonPerson_PersonID
  ON
    "m"."PersonID" = mjBizAppsCommonPerson_PersonID."ID"
INNER JOIN
    ${mjSchema}_bizappscommittees."Role" AS mjbizappscommitteesRole_RoleID
  ON
    "m"."RoleID" = mjbizappscommitteesRole_RoleID."ID"
INNER JOIN
    ${mjSchema}_bizappscommittees."Term" AS mjbizappscommitteesTerm_TermID
  ON
    "m"."TermID" = mjbizappscommitteesTerm_TermID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql)
  SELECT DISTINCT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'))
  FROM pg_depend d
  JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
  JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwMemberships'
    AND tc.relkind IN ('v', 'm')
    AND dc.oid <> tc.oid;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_proc pp ON pp.oid = d.objid AND d.classid = 'pg_proc'::regclass
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwMemberships'
    AND tc.relkind IN ('v', 'm')
  UNION
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_type pt ON pt.oid = d.refobjid AND d.refclassid = 'pg_type'::regclass
  JOIN pg_proc pp ON pp.prorettype = pt.oid OR pt.typrelid = pp.oid
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE EXISTS (
      SELECT 1 FROM pg_class tc
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tc.reltype = pt.oid
        AND tn.nspname = '${mjSchema}_bizappscommittees'
        AND tc.relname = 'vwMemberships'
        AND tc.relkind IN ('v', 'm')
  );

  DROP VIEW IF EXISTS ${mjSchema}_bizappscommittees."vwMemberships" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMemberships" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMemberships" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMemberships" TO "cdp_Integration";

/* Base View Permissions SQL for Committees: Memberships */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Memberships
-- Item: Permissions for vwMemberships
-- Generated at: 2026-07-22T15:45:58.254Z
-- ============================================================
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMemberships" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMemberships" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMemberships" TO "cdp_Integration";

/* spCreate SQL for Committees: Memberships */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Memberships
-- Item: spCreateMembership
-- Generated at: 2026-07-22T15:45:58.254Z
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Membership
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateMembership'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spCreateMembership"(
    p_id UUID DEFAULT NULL,
    p_personid UUID DEFAULT NULL,
    p_roleid UUID DEFAULT NULL,
    p_termid UUID DEFAULT NULL,
    p_startdate date DEFAULT NULL,
    p_enddate_clear boolean DEFAULT false,
    p_enddate date DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL,
    p_endreason_clear boolean DEFAULT false,
    p_endreason varchar(100) DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes TEXT DEFAULT NULL,
    p_renewalintent_clear boolean DEFAULT false,
    p_renewalintent varchar(20) DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwMemberships" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO ${mjSchema}_bizappscommittees."Membership"
        (
            "ID",
            "PersonID",
                "RoleID",
                "TermID",
                "StartDate",
                "EndDate",
                "Status",
                "EndReason",
                "Notes",
                "RenewalIntent"
        )
    VALUES
        (
            v_new_id,
            p_personid,
                p_roleid,
                p_termid,
                p_startdate,
                CASE WHEN p_enddate_clear = true THEN NULL ELSE COALESCE(p_enddate, NULL) END,
                COALESCE(p_status, 'Active'),
                CASE WHEN p_endreason_clear = true THEN NULL ELSE COALESCE(p_endreason, NULL) END,
                CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, NULL) END,
                CASE WHEN p_renewalintent_clear = true THEN NULL ELSE COALESCE(p_renewalintent, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwMemberships"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateMembership" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateMembership" TO "cdp_Integration";

/* spCreate Permissions for Committees: Memberships */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateMembership" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateMembership" TO "cdp_Integration";

/* spUpdate SQL for Committees: Memberships */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Memberships
-- Item: spUpdateMembership
-- Generated at: 2026-07-22T15:45:58.255Z
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Membership
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateMembership'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spUpdateMembership"(
    p_id UUID,
    p_personid UUID DEFAULT NULL,
    p_roleid UUID DEFAULT NULL,
    p_termid UUID DEFAULT NULL,
    p_startdate date DEFAULT NULL,
    p_enddate_clear boolean DEFAULT false,
    p_enddate date DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL,
    p_endreason_clear boolean DEFAULT false,
    p_endreason varchar(100) DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes TEXT DEFAULT NULL,
    p_renewalintent_clear boolean DEFAULT false,
    p_renewalintent varchar(20) DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwMemberships" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE ${mjSchema}_bizappscommittees."Membership"
    SET
        "PersonID" = COALESCE(p_personid, "PersonID"),
        "RoleID" = COALESCE(p_roleid, "RoleID"),
        "TermID" = COALESCE(p_termid, "TermID"),
        "StartDate" = COALESCE(p_startdate, "StartDate"),
        "EndDate" = CASE WHEN p_enddate_clear = true THEN NULL ELSE COALESCE(p_enddate, "EndDate") END,
        "Status" = COALESCE(p_status, "Status"),
        "EndReason" = CASE WHEN p_endreason_clear = true THEN NULL ELSE COALESCE(p_endreason, "EndReason") END,
        "Notes" = CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, "Notes") END,
        "RenewalIntent" = CASE WHEN p_renewalintent_clear = true THEN NULL ELSE COALESCE(p_renewalintent, "RenewalIntent") END
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwMemberships"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateMembership" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateMembership" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Membership table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_membership"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_membership" ON ${mjSchema}_bizappscommittees."Membership";

CREATE TRIGGER "trg_update_membership"
BEFORE UPDATE ON ${mjSchema}_bizappscommittees."Membership"
FOR EACH ROW
EXECUTE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_membership"();

/* spUpdate Permissions for Committees: Memberships */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateMembership" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateMembership" TO "cdp_Integration";

/* spDelete SQL for Committees: Memberships */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Memberships
-- Item: spDeleteMembership
-- Generated at: 2026-07-22T15:45:58.255Z
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Membership
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteMembership'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spDeleteMembership"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM ${mjSchema}_bizappscommittees."Membership"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteMembership" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteMembership" TO "cdp_Integration";

/* spDelete Permissions for Committees: Memberships */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteMembership" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteMembership" TO "cdp_Integration";

/* Base View SQL for Committees: Minutes */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Minutes
-- Item: vwMinutes
-- Generated at: 2026-07-22T15:45:58.263Z
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Minutes
-----               SCHEMA:      ${mjSchema}_bizappscommittees
-----               BASE TABLE:  Minute
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW ${mjSchema}_bizappscommittees."vwMinutes"
AS
SELECT
    m.*,
    mjbizappscommitteesArtifact_ArtifactID."Name" AS "Artifact",
    mjbizappscommitteesMeeting_MeetingID."Name" AS "Meeting",
    mjbizappscommitteesMeeting_ApprovedByMeetingID."Name" AS "ApprovedByMeeting"
FROM
    ${mjSchema}_bizappscommittees."Minute" AS m
LEFT OUTER JOIN
    ${mjSchema}_bizappscommittees."Artifact" AS mjbizappscommitteesArtifact_ArtifactID
  ON
    "m"."ArtifactID" = mjbizappscommitteesArtifact_ArtifactID."ID"
LEFT OUTER JOIN
    ${mjSchema}_bizappscommittees."Meeting" AS mjbizappscommitteesMeeting_MeetingID
  ON
    "m"."MeetingID" = mjbizappscommitteesMeeting_MeetingID."ID"
LEFT OUTER JOIN
    ${mjSchema}_bizappscommittees."Meeting" AS mjbizappscommitteesMeeting_ApprovedByMeetingID
  ON
    "m"."ApprovedByMeetingID" = mjbizappscommitteesMeeting_ApprovedByMeetingID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql)
  SELECT DISTINCT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'))
  FROM pg_depend d
  JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
  JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwMinutes'
    AND tc.relkind IN ('v', 'm')
    AND dc.oid <> tc.oid;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_proc pp ON pp.oid = d.objid AND d.classid = 'pg_proc'::regclass
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwMinutes'
    AND tc.relkind IN ('v', 'm')
  UNION
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_type pt ON pt.oid = d.refobjid AND d.refclassid = 'pg_type'::regclass
  JOIN pg_proc pp ON pp.prorettype = pt.oid OR pt.typrelid = pp.oid
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE EXISTS (
      SELECT 1 FROM pg_class tc
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tc.reltype = pt.oid
        AND tn.nspname = '${mjSchema}_bizappscommittees'
        AND tc.relname = 'vwMinutes'
        AND tc.relkind IN ('v', 'm')
  );

  DROP VIEW IF EXISTS ${mjSchema}_bizappscommittees."vwMinutes" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMinutes" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMinutes" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMinutes" TO "cdp_Integration";

/* Base View Permissions SQL for Committees: Minutes */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Minutes
-- Item: Permissions for vwMinutes
-- Generated at: 2026-07-22T15:45:58.263Z
-- ============================================================
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMinutes" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMinutes" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMinutes" TO "cdp_Integration";

/* spCreate SQL for Committees: Minutes */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Minutes
-- Item: spCreateMinute
-- Generated at: 2026-07-22T15:45:58.264Z
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Minute
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateMinute'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spCreateMinute"(
    p_id UUID DEFAULT NULL,
    p_artifactid_clear boolean DEFAULT false,
    p_artifactid UUID DEFAULT NULL,
    p_meetingid_clear boolean DEFAULT false,
    p_meetingid UUID DEFAULT NULL,
    p_content_clear boolean DEFAULT false,
    p_content TEXT DEFAULT NULL,
    p_approvalstatus varchar(50) DEFAULT NULL,
    p_approvedat_clear boolean DEFAULT false,
    p_approvedat TIMESTAMPTZ DEFAULT NULL,
    p_approvedbymeetingid_clear boolean DEFAULT false,
    p_approvedbymeetingid UUID DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes TEXT DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwMinutes" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO ${mjSchema}_bizappscommittees."Minute"
        (
            "ID",
            "ArtifactID",
                "MeetingID",
                "Content",
                "ApprovalStatus",
                "ApprovedAt",
                "ApprovedByMeetingID",
                "Notes"
        )
    VALUES
        (
            v_new_id,
            CASE WHEN p_artifactid_clear = true THEN NULL ELSE COALESCE(p_artifactid, NULL) END,
                CASE WHEN p_meetingid_clear = true THEN NULL ELSE COALESCE(p_meetingid, NULL) END,
                CASE WHEN p_content_clear = true THEN NULL ELSE COALESCE(p_content, NULL) END,
                COALESCE(p_approvalstatus, 'Draft'),
                CASE WHEN p_approvedat_clear = true THEN NULL ELSE COALESCE(p_approvedat, NULL) END,
                CASE WHEN p_approvedbymeetingid_clear = true THEN NULL ELSE COALESCE(p_approvedbymeetingid, NULL) END,
                CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwMinutes"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateMinute" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateMinute" TO "cdp_Integration";

/* spCreate Permissions for Committees: Minutes */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateMinute" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateMinute" TO "cdp_Integration";

/* spUpdate SQL for Committees: Minutes */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Minutes
-- Item: spUpdateMinute
-- Generated at: 2026-07-22T15:45:58.264Z
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Minute
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateMinute'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spUpdateMinute"(
    p_id UUID,
    p_artifactid_clear boolean DEFAULT false,
    p_artifactid UUID DEFAULT NULL,
    p_meetingid_clear boolean DEFAULT false,
    p_meetingid UUID DEFAULT NULL,
    p_content_clear boolean DEFAULT false,
    p_content TEXT DEFAULT NULL,
    p_approvalstatus varchar(50) DEFAULT NULL,
    p_approvedat_clear boolean DEFAULT false,
    p_approvedat TIMESTAMPTZ DEFAULT NULL,
    p_approvedbymeetingid_clear boolean DEFAULT false,
    p_approvedbymeetingid UUID DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes TEXT DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwMinutes" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE ${mjSchema}_bizappscommittees."Minute"
    SET
        "ArtifactID" = CASE WHEN p_artifactid_clear = true THEN NULL ELSE COALESCE(p_artifactid, "ArtifactID") END,
        "MeetingID" = CASE WHEN p_meetingid_clear = true THEN NULL ELSE COALESCE(p_meetingid, "MeetingID") END,
        "Content" = CASE WHEN p_content_clear = true THEN NULL ELSE COALESCE(p_content, "Content") END,
        "ApprovalStatus" = COALESCE(p_approvalstatus, "ApprovalStatus"),
        "ApprovedAt" = CASE WHEN p_approvedat_clear = true THEN NULL ELSE COALESCE(p_approvedat, "ApprovedAt") END,
        "ApprovedByMeetingID" = CASE WHEN p_approvedbymeetingid_clear = true THEN NULL ELSE COALESCE(p_approvedbymeetingid, "ApprovedByMeetingID") END,
        "Notes" = CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, "Notes") END
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwMinutes"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateMinute" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateMinute" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Minute table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_minute"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_minute" ON ${mjSchema}_bizappscommittees."Minute";

CREATE TRIGGER "trg_update_minute"
BEFORE UPDATE ON ${mjSchema}_bizappscommittees."Minute"
FOR EACH ROW
EXECUTE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_minute"();

/* spUpdate Permissions for Committees: Minutes */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateMinute" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateMinute" TO "cdp_Integration";

/* spDelete SQL for Committees: Minutes */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Minutes
-- Item: spDeleteMinute
-- Generated at: 2026-07-22T15:45:58.264Z
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Minute
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteMinute'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spDeleteMinute"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM ${mjSchema}_bizappscommittees."Minute"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteMinute" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteMinute" TO "cdp_Integration";

/* spDelete Permissions for Committees: Minutes */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteMinute" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteMinute" TO "cdp_Integration";

/* Base View SQL for Committees: Motions */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Motions
-- Item: vwMotions
-- Generated at: 2026-07-22T15:45:58.272Z
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Motions
-----               SCHEMA:      ${mjSchema}_bizappscommittees
-----               BASE TABLE:  Motion
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW ${mjSchema}_bizappscommittees."vwMotions"
AS
SELECT
    m.*,
    mjbizappscommitteesMeeting_MeetingID."Name" AS "Meeting",
    mjbizappscommitteesAgendaItem_AgendaItemID."Name" AS "AgendaItem"
FROM
    ${mjSchema}_bizappscommittees."Motion" AS m
LEFT OUTER JOIN
    ${mjSchema}_bizappscommittees."Meeting" AS mjbizappscommitteesMeeting_MeetingID
  ON
    "m"."MeetingID" = mjbizappscommitteesMeeting_MeetingID."ID"
LEFT OUTER JOIN
    ${mjSchema}_bizappscommittees."AgendaItem" AS mjbizappscommitteesAgendaItem_AgendaItemID
  ON
    "m"."AgendaItemID" = mjbizappscommitteesAgendaItem_AgendaItemID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql)
  SELECT DISTINCT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'))
  FROM pg_depend d
  JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
  JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwMotions'
    AND tc.relkind IN ('v', 'm')
    AND dc.oid <> tc.oid;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_proc pp ON pp.oid = d.objid AND d.classid = 'pg_proc'::regclass
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwMotions'
    AND tc.relkind IN ('v', 'm')
  UNION
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_type pt ON pt.oid = d.refobjid AND d.refclassid = 'pg_type'::regclass
  JOIN pg_proc pp ON pp.prorettype = pt.oid OR pt.typrelid = pp.oid
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE EXISTS (
      SELECT 1 FROM pg_class tc
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tc.reltype = pt.oid
        AND tn.nspname = '${mjSchema}_bizappscommittees'
        AND tc.relname = 'vwMotions'
        AND tc.relkind IN ('v', 'm')
  );

  DROP VIEW IF EXISTS ${mjSchema}_bizappscommittees."vwMotions" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMotions" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMotions" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMotions" TO "cdp_Integration";

/* Base View Permissions SQL for Committees: Motions */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Motions
-- Item: Permissions for vwMotions
-- Generated at: 2026-07-22T15:45:58.273Z
-- ============================================================
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMotions" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMotions" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwMotions" TO "cdp_Integration";

/* spCreate SQL for Committees: Motions */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Motions
-- Item: spCreateMotion
-- Generated at: 2026-07-22T15:45:58.273Z
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Motion
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateMotion'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spCreateMotion"(
    p_id UUID DEFAULT NULL,
    p_meetingid_clear boolean DEFAULT false,
    p_meetingid UUID DEFAULT NULL,
    p_agendaitemid_clear boolean DEFAULT false,
    p_agendaitemid UUID DEFAULT NULL,
    p_sequence int DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_movedbymembershipid_clear boolean DEFAULT false,
    p_movedbymembershipid UUID DEFAULT NULL,
    p_secondedbymembershipid_clear boolean DEFAULT false,
    p_secondedbymembershipid UUID DEFAULT NULL,
    p_result varchar(50) DEFAULT NULL,
    p_resultsummary_clear boolean DEFAULT false,
    p_resultsummary varchar(255) DEFAULT NULL,
    p_yescount_clear boolean DEFAULT false,
    p_yescount int DEFAULT NULL,
    p_nocount_clear boolean DEFAULT false,
    p_nocount int DEFAULT NULL,
    p_abstaincount_clear boolean DEFAULT false,
    p_abstaincount int DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes TEXT DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwMotions" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO ${mjSchema}_bizappscommittees."Motion"
        (
            "ID",
            "MeetingID",
                "AgendaItemID",
                "Sequence",
                "Name",
                "Description",
                "MovedByMembershipID",
                "SecondedByMembershipID",
                "Result",
                "ResultSummary",
                "YesCount",
                "NoCount",
                "AbstainCount",
                "Notes"
        )
    VALUES
        (
            v_new_id,
            CASE WHEN p_meetingid_clear = true THEN NULL ELSE COALESCE(p_meetingid, NULL) END,
                CASE WHEN p_agendaitemid_clear = true THEN NULL ELSE COALESCE(p_agendaitemid, NULL) END,
                COALESCE(p_sequence, 1),
                p_name,
                CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, NULL) END,
                CASE WHEN p_movedbymembershipid_clear = true THEN NULL ELSE COALESCE(p_movedbymembershipid, NULL) END,
                CASE WHEN p_secondedbymembershipid_clear = true THEN NULL ELSE COALESCE(p_secondedbymembershipid, NULL) END,
                COALESCE(p_result, 'Pending'),
                CASE WHEN p_resultsummary_clear = true THEN NULL ELSE COALESCE(p_resultsummary, NULL) END,
                CASE WHEN p_yescount_clear = true THEN NULL ELSE COALESCE(p_yescount, NULL) END,
                CASE WHEN p_nocount_clear = true THEN NULL ELSE COALESCE(p_nocount, NULL) END,
                CASE WHEN p_abstaincount_clear = true THEN NULL ELSE COALESCE(p_abstaincount, NULL) END,
                CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwMotions"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateMotion" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateMotion" TO "cdp_Integration";

/* spCreate Permissions for Committees: Motions */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateMotion" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateMotion" TO "cdp_Integration";

/* spUpdate SQL for Committees: Motions */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Motions
-- Item: spUpdateMotion
-- Generated at: 2026-07-22T15:45:58.273Z
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Motion
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateMotion'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spUpdateMotion"(
    p_id UUID,
    p_meetingid_clear boolean DEFAULT false,
    p_meetingid UUID DEFAULT NULL,
    p_agendaitemid_clear boolean DEFAULT false,
    p_agendaitemid UUID DEFAULT NULL,
    p_sequence int DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_movedbymembershipid_clear boolean DEFAULT false,
    p_movedbymembershipid UUID DEFAULT NULL,
    p_secondedbymembershipid_clear boolean DEFAULT false,
    p_secondedbymembershipid UUID DEFAULT NULL,
    p_result varchar(50) DEFAULT NULL,
    p_resultsummary_clear boolean DEFAULT false,
    p_resultsummary varchar(255) DEFAULT NULL,
    p_yescount_clear boolean DEFAULT false,
    p_yescount int DEFAULT NULL,
    p_nocount_clear boolean DEFAULT false,
    p_nocount int DEFAULT NULL,
    p_abstaincount_clear boolean DEFAULT false,
    p_abstaincount int DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes TEXT DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwMotions" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE ${mjSchema}_bizappscommittees."Motion"
    SET
        "MeetingID" = CASE WHEN p_meetingid_clear = true THEN NULL ELSE COALESCE(p_meetingid, "MeetingID") END,
        "AgendaItemID" = CASE WHEN p_agendaitemid_clear = true THEN NULL ELSE COALESCE(p_agendaitemid, "AgendaItemID") END,
        "Sequence" = COALESCE(p_sequence, "Sequence"),
        "Name" = COALESCE(p_name, "Name"),
        "Description" = CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, "Description") END,
        "MovedByMembershipID" = CASE WHEN p_movedbymembershipid_clear = true THEN NULL ELSE COALESCE(p_movedbymembershipid, "MovedByMembershipID") END,
        "SecondedByMembershipID" = CASE WHEN p_secondedbymembershipid_clear = true THEN NULL ELSE COALESCE(p_secondedbymembershipid, "SecondedByMembershipID") END,
        "Result" = COALESCE(p_result, "Result"),
        "ResultSummary" = CASE WHEN p_resultsummary_clear = true THEN NULL ELSE COALESCE(p_resultsummary, "ResultSummary") END,
        "YesCount" = CASE WHEN p_yescount_clear = true THEN NULL ELSE COALESCE(p_yescount, "YesCount") END,
        "NoCount" = CASE WHEN p_nocount_clear = true THEN NULL ELSE COALESCE(p_nocount, "NoCount") END,
        "AbstainCount" = CASE WHEN p_abstaincount_clear = true THEN NULL ELSE COALESCE(p_abstaincount, "AbstainCount") END,
        "Notes" = CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, "Notes") END
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwMotions"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateMotion" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateMotion" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Motion table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_motion"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_motion" ON ${mjSchema}_bizappscommittees."Motion";

CREATE TRIGGER "trg_update_motion"
BEFORE UPDATE ON ${mjSchema}_bizappscommittees."Motion"
FOR EACH ROW
EXECUTE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_motion"();

/* spUpdate Permissions for Committees: Motions */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateMotion" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateMotion" TO "cdp_Integration";

/* spDelete SQL for Committees: Motions */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Motions
-- Item: spDeleteMotion
-- Generated at: 2026-07-22T15:45:58.274Z
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Motion
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteMotion'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spDeleteMotion"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM ${mjSchema}_bizappscommittees."Motion"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteMotion" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteMotion" TO "cdp_Integration";

/* spDelete Permissions for Committees: Motions */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteMotion" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteMotion" TO "cdp_Integration";

/* Base View SQL for Committees: Roles */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Roles
-- Item: vwRoles
-- Generated at: 2026-07-22T15:45:58.282Z
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Roles
-----               SCHEMA:      ${mjSchema}_bizappscommittees
-----               BASE TABLE:  Role
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW ${mjSchema}_bizappscommittees."vwRoles"
AS
SELECT
    r.*
FROM
    ${mjSchema}_bizappscommittees."Role" AS r
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql)
  SELECT DISTINCT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'))
  FROM pg_depend d
  JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
  JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwRoles'
    AND tc.relkind IN ('v', 'm')
    AND dc.oid <> tc.oid;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_proc pp ON pp.oid = d.objid AND d.classid = 'pg_proc'::regclass
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwRoles'
    AND tc.relkind IN ('v', 'm')
  UNION
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_type pt ON pt.oid = d.refobjid AND d.refclassid = 'pg_type'::regclass
  JOIN pg_proc pp ON pp.prorettype = pt.oid OR pt.typrelid = pp.oid
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE EXISTS (
      SELECT 1 FROM pg_class tc
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tc.reltype = pt.oid
        AND tn.nspname = '${mjSchema}_bizappscommittees'
        AND tc.relname = 'vwRoles'
        AND tc.relkind IN ('v', 'm')
  );

  DROP VIEW IF EXISTS ${mjSchema}_bizappscommittees."vwRoles" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwRoles" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwRoles" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwRoles" TO "cdp_Integration";

/* Base View Permissions SQL for Committees: Roles */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Roles
-- Item: Permissions for vwRoles
-- Generated at: 2026-07-22T15:45:58.282Z
-- ============================================================
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwRoles" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwRoles" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwRoles" TO "cdp_Integration";

/* spCreate SQL for Committees: Roles */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Roles
-- Item: spCreateRole
-- Generated at: 2026-07-22T15:45:58.282Z
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Role
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateRole'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spCreateRole"(
    p_id UUID DEFAULT NULL,
    p_name varchar(100) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_isofficer BOOLEAN DEFAULT NULL,
    p_isvotingrole BOOLEAN DEFAULT NULL,
    p_defaultpermissionsjson_clear boolean DEFAULT false,
    p_defaultpermissionsjson TEXT DEFAULT NULL,
    p_sequence int DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwRoles" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO ${mjSchema}_bizappscommittees."Role"
        (
            "ID",
            "Name",
                "Description",
                "IsOfficer",
                "IsVotingRole",
                "DefaultPermissionsJSON",
                "Sequence"
        )
    VALUES
        (
            v_new_id,
            p_name,
                CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, NULL) END,
                COALESCE(p_isofficer, FALSE),
                COALESCE(p_isvotingrole, TRUE),
                CASE WHEN p_defaultpermissionsjson_clear = true THEN NULL ELSE COALESCE(p_defaultpermissionsjson, NULL) END,
                COALESCE(p_sequence, 100)
        )
    ;

    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwRoles"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateRole" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateRole" TO "cdp_Integration";

/* spCreate Permissions for Committees: Roles */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateRole" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateRole" TO "cdp_Integration";

/* spUpdate SQL for Committees: Roles */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Roles
-- Item: spUpdateRole
-- Generated at: 2026-07-22T15:45:58.283Z
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Role
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateRole'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spUpdateRole"(
    p_id UUID,
    p_name varchar(100) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_isofficer BOOLEAN DEFAULT NULL,
    p_isvotingrole BOOLEAN DEFAULT NULL,
    p_defaultpermissionsjson_clear boolean DEFAULT false,
    p_defaultpermissionsjson TEXT DEFAULT NULL,
    p_sequence int DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwRoles" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE ${mjSchema}_bizappscommittees."Role"
    SET
        "Name" = COALESCE(p_name, "Name"),
        "Description" = CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, "Description") END,
        "IsOfficer" = COALESCE(p_isofficer, "IsOfficer"),
        "IsVotingRole" = COALESCE(p_isvotingrole, "IsVotingRole"),
        "DefaultPermissionsJSON" = CASE WHEN p_defaultpermissionsjson_clear = true THEN NULL ELSE COALESCE(p_defaultpermissionsjson, "DefaultPermissionsJSON") END,
        "Sequence" = COALESCE(p_sequence, "Sequence")
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwRoles"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateRole" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateRole" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Role table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_role"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_role" ON ${mjSchema}_bizappscommittees."Role";

CREATE TRIGGER "trg_update_role"
BEFORE UPDATE ON ${mjSchema}_bizappscommittees."Role"
FOR EACH ROW
EXECUTE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_role"();

/* spUpdate Permissions for Committees: Roles */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateRole" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateRole" TO "cdp_Integration";

/* spDelete SQL for Committees: Roles */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Roles
-- Item: spDeleteRole
-- Generated at: 2026-07-22T15:45:58.283Z
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Role
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteRole'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spDeleteRole"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM ${mjSchema}_bizappscommittees."Role"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteRole" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteRole" TO "cdp_Integration";

/* spDelete Permissions for Committees: Roles */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteRole" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteRole" TO "cdp_Integration";

/* Base View SQL for Committees: Terms */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Terms
-- Item: vwTerms
-- Generated at: 2026-07-22T15:45:58.290Z
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Terms
-----               SCHEMA:      ${mjSchema}_bizappscommittees
-----               BASE TABLE:  Term
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW ${mjSchema}_bizappscommittees."vwTerms"
AS
SELECT
    t.*,
    mjbizappscommitteesCommittee_CommitteeID."Name" AS "Committee"
FROM
    ${mjSchema}_bizappscommittees."Term" AS t
INNER JOIN
    ${mjSchema}_bizappscommittees."Committee" AS mjbizappscommitteesCommittee_CommitteeID
  ON
    "t"."CommitteeID" = mjbizappscommitteesCommittee_CommitteeID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql)
  SELECT DISTINCT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'))
  FROM pg_depend d
  JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
  JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwTerms'
    AND tc.relkind IN ('v', 'm')
    AND dc.oid <> tc.oid;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_proc pp ON pp.oid = d.objid AND d.classid = 'pg_proc'::regclass
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwTerms'
    AND tc.relkind IN ('v', 'm')
  UNION
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_type pt ON pt.oid = d.refobjid AND d.refclassid = 'pg_type'::regclass
  JOIN pg_proc pp ON pp.prorettype = pt.oid OR pt.typrelid = pp.oid
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE EXISTS (
      SELECT 1 FROM pg_class tc
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tc.reltype = pt.oid
        AND tn.nspname = '${mjSchema}_bizappscommittees'
        AND tc.relname = 'vwTerms'
        AND tc.relkind IN ('v', 'm')
  );

  DROP VIEW IF EXISTS ${mjSchema}_bizappscommittees."vwTerms" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwTerms" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwTerms" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwTerms" TO "cdp_Integration";

/* Base View Permissions SQL for Committees: Terms */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Terms
-- Item: Permissions for vwTerms
-- Generated at: 2026-07-22T15:45:58.291Z
-- ============================================================
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwTerms" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwTerms" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwTerms" TO "cdp_Integration";

/* spCreate SQL for Committees: Terms */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Terms
-- Item: spCreateTerm
-- Generated at: 2026-07-22T15:45:58.291Z
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Term
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateTerm'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spCreateTerm"(
    p_id UUID DEFAULT NULL,
    p_committeeid UUID DEFAULT NULL,
    p_name varchar(100) DEFAULT NULL,
    p_startdate date DEFAULT NULL,
    p_enddate_clear boolean DEFAULT false,
    p_enddate date DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwTerms" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO ${mjSchema}_bizappscommittees."Term"
        (
            "ID",
            "CommitteeID",
                "Name",
                "StartDate",
                "EndDate",
                "Status"
        )
    VALUES
        (
            v_new_id,
            p_committeeid,
                p_name,
                p_startdate,
                CASE WHEN p_enddate_clear = true THEN NULL ELSE COALESCE(p_enddate, NULL) END,
                COALESCE(p_status, 'Active')
        )
    ;

    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwTerms"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateTerm" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateTerm" TO "cdp_Integration";

/* spCreate Permissions for Committees: Terms */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateTerm" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateTerm" TO "cdp_Integration";

/* spUpdate SQL for Committees: Terms */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Terms
-- Item: spUpdateTerm
-- Generated at: 2026-07-22T15:45:58.291Z
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Term
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateTerm'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spUpdateTerm"(
    p_id UUID,
    p_committeeid UUID DEFAULT NULL,
    p_name varchar(100) DEFAULT NULL,
    p_startdate date DEFAULT NULL,
    p_enddate_clear boolean DEFAULT false,
    p_enddate date DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwTerms" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE ${mjSchema}_bizappscommittees."Term"
    SET
        "CommitteeID" = COALESCE(p_committeeid, "CommitteeID"),
        "Name" = COALESCE(p_name, "Name"),
        "StartDate" = COALESCE(p_startdate, "StartDate"),
        "EndDate" = CASE WHEN p_enddate_clear = true THEN NULL ELSE COALESCE(p_enddate, "EndDate") END,
        "Status" = COALESCE(p_status, "Status")
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwTerms"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateTerm" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateTerm" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Term table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_term"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_term" ON ${mjSchema}_bizappscommittees."Term";

CREATE TRIGGER "trg_update_term"
BEFORE UPDATE ON ${mjSchema}_bizappscommittees."Term"
FOR EACH ROW
EXECUTE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_term"();

/* spUpdate Permissions for Committees: Terms */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateTerm" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateTerm" TO "cdp_Integration";

/* spDelete SQL for Committees: Terms */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Terms
-- Item: spDeleteTerm
-- Generated at: 2026-07-22T15:45:58.291Z
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Term
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteTerm'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spDeleteTerm"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM ${mjSchema}_bizappscommittees."Term"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteTerm" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteTerm" TO "cdp_Integration";

/* spDelete Permissions for Committees: Terms */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteTerm" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteTerm" TO "cdp_Integration";

/* Base View SQL for Committees: Types */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Types
-- Item: vwTypes
-- Generated at: 2026-07-22T15:45:58.299Z
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Types
-----               SCHEMA:      ${mjSchema}_bizappscommittees
-----               BASE TABLE:  Type
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW ${mjSchema}_bizappscommittees."vwTypes"
AS
SELECT
    t.*
FROM
    ${mjSchema}_bizappscommittees."Type" AS t
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql)
  SELECT DISTINCT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'))
  FROM pg_depend d
  JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
  JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwTypes'
    AND tc.relkind IN ('v', 'm')
    AND dc.oid <> tc.oid;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_proc pp ON pp.oid = d.objid AND d.classid = 'pg_proc'::regclass
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwTypes'
    AND tc.relkind IN ('v', 'm')
  UNION
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_type pt ON pt.oid = d.refobjid AND d.refclassid = 'pg_type'::regclass
  JOIN pg_proc pp ON pp.prorettype = pt.oid OR pt.typrelid = pp.oid
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE EXISTS (
      SELECT 1 FROM pg_class tc
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tc.reltype = pt.oid
        AND tn.nspname = '${mjSchema}_bizappscommittees'
        AND tc.relname = 'vwTypes'
        AND tc.relkind IN ('v', 'm')
  );

  DROP VIEW IF EXISTS ${mjSchema}_bizappscommittees."vwTypes" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwTypes" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwTypes" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwTypes" TO "cdp_Integration";

/* Base View Permissions SQL for Committees: Types */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Types
-- Item: Permissions for vwTypes
-- Generated at: 2026-07-22T15:45:58.299Z
-- ============================================================
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwTypes" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwTypes" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwTypes" TO "cdp_Integration";

/* spCreate SQL for Committees: Types */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Types
-- Item: spCreateType
-- Generated at: 2026-07-22T15:45:58.299Z
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Type
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateType'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spCreateType"(
    p_id UUID DEFAULT NULL,
    p_name varchar(100) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_isstandards BOOLEAN DEFAULT NULL,
    p_defaulttermmonths_clear boolean DEFAULT false,
    p_defaulttermmonths int DEFAULT NULL,
    p_iconclass_clear boolean DEFAULT false,
    p_iconclass varchar(100) DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwTypes" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO ${mjSchema}_bizappscommittees."Type"
        (
            "ID",
            "Name",
                "Description",
                "IsStandards",
                "DefaultTermMonths",
                "IconClass"
        )
    VALUES
        (
            v_new_id,
            p_name,
                CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, NULL) END,
                COALESCE(p_isstandards, FALSE),
                CASE WHEN p_defaulttermmonths_clear = true THEN NULL ELSE COALESCE(p_defaulttermmonths, NULL) END,
                CASE WHEN p_iconclass_clear = true THEN NULL ELSE COALESCE(p_iconclass, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwTypes"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateType" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateType" TO "cdp_Integration";

/* spCreate Permissions for Committees: Types */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateType" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateType" TO "cdp_Integration";

/* spUpdate SQL for Committees: Types */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Types
-- Item: spUpdateType
-- Generated at: 2026-07-22T15:45:58.300Z
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Type
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateType'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spUpdateType"(
    p_id UUID,
    p_name varchar(100) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_isstandards BOOLEAN DEFAULT NULL,
    p_defaulttermmonths_clear boolean DEFAULT false,
    p_defaulttermmonths int DEFAULT NULL,
    p_iconclass_clear boolean DEFAULT false,
    p_iconclass varchar(100) DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwTypes" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE ${mjSchema}_bizappscommittees."Type"
    SET
        "Name" = COALESCE(p_name, "Name"),
        "Description" = CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, "Description") END,
        "IsStandards" = COALESCE(p_isstandards, "IsStandards"),
        "DefaultTermMonths" = CASE WHEN p_defaulttermmonths_clear = true THEN NULL ELSE COALESCE(p_defaulttermmonths, "DefaultTermMonths") END,
        "IconClass" = CASE WHEN p_iconclass_clear = true THEN NULL ELSE COALESCE(p_iconclass, "IconClass") END
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwTypes"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateType" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateType" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Type table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_type"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_type" ON ${mjSchema}_bizappscommittees."Type";

CREATE TRIGGER "trg_update_type"
BEFORE UPDATE ON ${mjSchema}_bizappscommittees."Type"
FOR EACH ROW
EXECUTE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_type"();

/* spUpdate Permissions for Committees: Types */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateType" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateType" TO "cdp_Integration";

/* spDelete SQL for Committees: Types */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Types
-- Item: spDeleteType
-- Generated at: 2026-07-22T15:45:58.300Z
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Type
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteType'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spDeleteType"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM ${mjSchema}_bizappscommittees."Type"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteType" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteType" TO "cdp_Integration";

/* spDelete Permissions for Committees: Types */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteType" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteType" TO "cdp_Integration";

/* Base View SQL for Committees: Video Providers */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Video Providers
-- Item: vwVideoProviders
-- Generated at: 2026-07-22T15:45:58.307Z
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Video Providers
-----               SCHEMA:      ${mjSchema}_bizappscommittees
-----               BASE TABLE:  VideoProvider
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW ${mjSchema}_bizappscommittees."vwVideoProviders"
AS
SELECT
    v.*,
    MJCredential_CredentialID."Name" AS "Credential"
FROM
    ${mjSchema}_bizappscommittees."VideoProvider" AS v
LEFT OUTER JOIN
    ${mjSchema}."Credential" AS MJCredential_CredentialID
  ON
    "v"."CredentialID" = MJCredential_CredentialID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql)
  SELECT DISTINCT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'))
  FROM pg_depend d
  JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
  JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwVideoProviders'
    AND tc.relkind IN ('v', 'm')
    AND dc.oid <> tc.oid;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_proc pp ON pp.oid = d.objid AND d.classid = 'pg_proc'::regclass
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwVideoProviders'
    AND tc.relkind IN ('v', 'm')
  UNION
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_type pt ON pt.oid = d.refobjid AND d.refclassid = 'pg_type'::regclass
  JOIN pg_proc pp ON pp.prorettype = pt.oid OR pt.typrelid = pp.oid
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE EXISTS (
      SELECT 1 FROM pg_class tc
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tc.reltype = pt.oid
        AND tn.nspname = '${mjSchema}_bizappscommittees'
        AND tc.relname = 'vwVideoProviders'
        AND tc.relkind IN ('v', 'm')
  );

  DROP VIEW IF EXISTS ${mjSchema}_bizappscommittees."vwVideoProviders" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwVideoProviders" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwVideoProviders" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwVideoProviders" TO "cdp_Integration";

/* Base View Permissions SQL for Committees: Video Providers */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Video Providers
-- Item: Permissions for vwVideoProviders
-- Generated at: 2026-07-22T15:45:58.307Z
-- ============================================================
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwVideoProviders" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwVideoProviders" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwVideoProviders" TO "cdp_Integration";

/* spCreate SQL for Committees: Video Providers */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Video Providers
-- Item: spCreateVideoProvider
-- Generated at: 2026-07-22T15:45:58.307Z
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR VideoProvider
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateVideoProvider'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spCreateVideoProvider"(
    p_id UUID DEFAULT NULL,
    p_name varchar(100) DEFAULT NULL,
    p_serverdriverkey varchar(100) DEFAULT NULL,
    p_isactive BOOLEAN DEFAULT NULL,
    p_isdefault BOOLEAN DEFAULT NULL,
    p_credentialid_clear boolean DEFAULT false,
    p_credentialid UUID DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwVideoProviders" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO ${mjSchema}_bizappscommittees."VideoProvider"
        (
            "ID",
            "Name",
                "ServerDriverKey",
                "IsActive",
                "IsDefault",
                "CredentialID"
        )
    VALUES
        (
            v_new_id,
            p_name,
                p_serverdriverkey,
                COALESCE(p_isactive, TRUE),
                COALESCE(p_isdefault, FALSE),
                CASE WHEN p_credentialid_clear = true THEN NULL ELSE COALESCE(p_credentialid, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwVideoProviders"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateVideoProvider" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateVideoProvider" TO "cdp_Integration";

/* spCreate Permissions for Committees: Video Providers */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateVideoProvider" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateVideoProvider" TO "cdp_Integration";

/* spUpdate SQL for Committees: Video Providers */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Video Providers
-- Item: spUpdateVideoProvider
-- Generated at: 2026-07-22T15:45:58.308Z
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR VideoProvider
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateVideoProvider'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spUpdateVideoProvider"(
    p_id UUID,
    p_name varchar(100) DEFAULT NULL,
    p_serverdriverkey varchar(100) DEFAULT NULL,
    p_isactive BOOLEAN DEFAULT NULL,
    p_isdefault BOOLEAN DEFAULT NULL,
    p_credentialid_clear boolean DEFAULT false,
    p_credentialid UUID DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwVideoProviders" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE ${mjSchema}_bizappscommittees."VideoProvider"
    SET
        "Name" = COALESCE(p_name, "Name"),
        "ServerDriverKey" = COALESCE(p_serverdriverkey, "ServerDriverKey"),
        "IsActive" = COALESCE(p_isactive, "IsActive"),
        "IsDefault" = COALESCE(p_isdefault, "IsDefault"),
        "CredentialID" = CASE WHEN p_credentialid_clear = true THEN NULL ELSE COALESCE(p_credentialid, "CredentialID") END
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwVideoProviders"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateVideoProvider" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateVideoProvider" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the VideoProvider table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_video_provider"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_video_provider" ON ${mjSchema}_bizappscommittees."VideoProvider";

CREATE TRIGGER "trg_update_video_provider"
BEFORE UPDATE ON ${mjSchema}_bizappscommittees."VideoProvider"
FOR EACH ROW
EXECUTE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_video_provider"();

/* spUpdate Permissions for Committees: Video Providers */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateVideoProvider" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateVideoProvider" TO "cdp_Integration";

/* spDelete SQL for Committees: Video Providers */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Video Providers
-- Item: spDeleteVideoProvider
-- Generated at: 2026-07-22T15:45:58.308Z
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR VideoProvider
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteVideoProvider'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spDeleteVideoProvider"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM ${mjSchema}_bizappscommittees."VideoProvider"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteVideoProvider" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteVideoProvider" TO "cdp_Integration";

/* spDelete Permissions for Committees: Video Providers */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteVideoProvider" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteVideoProvider" TO "cdp_Integration";

/* Base View SQL for Committees: Votes */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Votes
-- Item: vwVotes
-- Generated at: 2026-07-22T15:45:58.315Z
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Votes
-----               SCHEMA:      ${mjSchema}_bizappscommittees
-----               BASE TABLE:  Vote
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW ${mjSchema}_bizappscommittees."vwVotes"
AS
SELECT
    v.*,
    mjbizappscommitteesMotion_MotionID."Name" AS "Motion"
FROM
    ${mjSchema}_bizappscommittees."Vote" AS v
INNER JOIN
    ${mjSchema}_bizappscommittees."Motion" AS mjbizappscommitteesMotion_MotionID
  ON
    "v"."MotionID" = mjbizappscommitteesMotion_MotionID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql)
  SELECT DISTINCT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'))
  FROM pg_depend d
  JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
  JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwVotes'
    AND tc.relkind IN ('v', 'm')
    AND dc.oid <> tc.oid;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_proc pp ON pp.oid = d.objid AND d.classid = 'pg_proc'::regclass
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  JOIN pg_class tc ON tc.oid = d.refobjid
  JOIN pg_namespace tn ON tn.oid = tc.relnamespace
  WHERE tn.nspname = '${mjSchema}_bizappscommittees'
    AND tc.relname = 'vwVotes'
    AND tc.relkind IN ('v', 'm')
  UNION
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_depend d
  JOIN pg_type pt ON pt.oid = d.refobjid AND d.refclassid = 'pg_type'::regclass
  JOIN pg_proc pp ON pp.prorettype = pt.oid OR pt.typrelid = pp.oid
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE EXISTS (
      SELECT 1 FROM pg_class tc
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tc.reltype = pt.oid
        AND tn.nspname = '${mjSchema}_bizappscommittees'
        AND tc.relname = 'vwVotes'
        AND tc.relkind IN ('v', 'm')
  );

  DROP VIEW IF EXISTS ${mjSchema}_bizappscommittees."vwVotes" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwVotes" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwVotes" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwVotes" TO "cdp_Integration";

/* Base View Permissions SQL for Committees: Votes */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Votes
-- Item: Permissions for vwVotes
-- Generated at: 2026-07-22T15:45:58.315Z
-- ============================================================
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwVotes" TO "cdp_UI";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwVotes" TO "cdp_Developer";
GRANT SELECT ON ${mjSchema}_bizappscommittees."vwVotes" TO "cdp_Integration";

/* spCreate SQL for Committees: Votes */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Votes
-- Item: spCreateVote
-- Generated at: 2026-07-22T15:45:58.315Z
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Vote
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateVote'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spCreateVote"(
    p_id UUID DEFAULT NULL,
    p_motionid UUID DEFAULT NULL,
    p_membershipid UUID DEFAULT NULL,
    p_votevalue varchar(20) DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes varchar(500) DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwVotes" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO ${mjSchema}_bizappscommittees."Vote"
        (
            "ID",
            "MotionID",
                "MembershipID",
                "VoteValue",
                "Notes"
        )
    VALUES
        (
            v_new_id,
            p_motionid,
                p_membershipid,
                p_votevalue,
                CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwVotes"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateVote" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateVote" TO "cdp_Integration";

/* spCreate Permissions for Committees: Votes */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateVote" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spCreateVote" TO "cdp_Integration";

/* spUpdate SQL for Committees: Votes */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Votes
-- Item: spUpdateVote
-- Generated at: 2026-07-22T15:45:58.316Z
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Vote
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateVote'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spUpdateVote"(
    p_id UUID,
    p_motionid UUID DEFAULT NULL,
    p_membershipid UUID DEFAULT NULL,
    p_votevalue varchar(20) DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes varchar(500) DEFAULT NULL
) RETURNS SETOF ${mjSchema}_bizappscommittees."vwVotes" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE ${mjSchema}_bizappscommittees."Vote"
    SET
        "MotionID" = COALESCE(p_motionid, "MotionID"),
        "MembershipID" = COALESCE(p_membershipid, "MembershipID"),
        "VoteValue" = COALESCE(p_votevalue, "VoteValue"),
        "Notes" = CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, "Notes") END
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM ${mjSchema}_bizappscommittees."vwVotes"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateVote" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateVote" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Vote table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_vote"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_vote" ON ${mjSchema}_bizappscommittees."Vote";

CREATE TRIGGER "trg_update_vote"
BEFORE UPDATE ON ${mjSchema}_bizappscommittees."Vote"
FOR EACH ROW
EXECUTE FUNCTION ${mjSchema}_bizappscommittees."fn_trg_update_vote"();

/* spUpdate Permissions for Committees: Votes */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateVote" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spUpdateVote" TO "cdp_Integration";

/* spDelete SQL for Committees: Votes */
-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Votes
-- Item: spDeleteVote
-- Generated at: 2026-07-22T15:45:58.318Z
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Vote
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteVote'
               AND pronamespace = '${mjSchema}_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION ${mjSchema}_bizappscommittees."spDeleteVote"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM ${mjSchema}_bizappscommittees."Vote"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteVote" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteVote" TO "cdp_Integration";

/* spDelete Permissions for Committees: Votes */
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteVote" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION ${mjSchema}_bizappscommittees."spDeleteVote" TO "cdp_Integration";

/* SQL text to delete unneeded entity fields (1 scoped entities) */
-- [stripped: core maintenance reconciliation] spDeleteUnneededEntityFields — every value this call would
-- compute is pinned by the metadata INSERTs and the CodeGen_Metadata_Backfill
-- .pgonly migration (fixed point), and core PG maintenance sprocs can lag core
-- schema changes (v5.45 spDeleteUnneededEntityFields references the dropped
-- vwEntities.ExternalDataSourceID). The siblings' baked files omit these too.

/* SQL to fix virtual field nullability */

UPDATE ${mjSchema}."EntityField" vf
SET "AllowsNull" = fk."AllowsNull"
FROM ${mjSchema}."EntityField" fk
WHERE vf."IsVirtual" = true
  AND fk."IsVirtual" = false
  AND vf."EntityID" = fk."EntityID"
  AND fk."RelatedEntityID" IS NOT NULL
  AND (
     (LENGTH(fk."Name") > 2
      AND LOWER(vf."Name") = LOWER(LEFT(fk."Name", LENGTH(fk."Name") - 2)))
     OR
     (LENGTH(fk."Name") > 2
      AND LOWER(vf."Name") = LOWER(LEFT(fk."Name", LENGTH(fk."Name") - 2) || '_Virtual'))
     OR
     (fk."RelatedEntityNameFieldMap" IS NOT NULL
      AND fk."RelatedEntityNameFieldMap" != ''
      AND LOWER(vf."Name") = LOWER(fk."RelatedEntityNameFieldMap"))
  )
  AND vf."AllowsNull" != fk."AllowsNull";

/* SQL text to update existing entity fields from schema (1 scoped entities) */
-- [stripped: core maintenance reconciliation] spUpdateExistingEntityFieldsFromSchema — every value this call would
-- compute is pinned by the metadata INSERTs and the CodeGen_Metadata_Backfill
-- .pgonly migration (fixed point), and core PG maintenance sprocs can lag core
-- schema changes (v5.45 spDeleteUnneededEntityFields references the dropped
-- vwEntities.ExternalDataSourceID). The siblings' baked files omit these too.

/* SQL text to set default column width where needed */
-- [stripped: core maintenance reconciliation] spSetDefaultColumnWidthWhereNeeded — every value this call would
-- compute is pinned by the metadata INSERTs and the CodeGen_Metadata_Backfill
-- .pgonly migration (fixed point), and core PG maintenance sprocs can lag core
-- schema changes (v5.45 spDeleteUnneededEntityFields references the dropped
-- vwEntities.ExternalDataSourceID). The siblings' baked files omit these too.

