-- ============================================================================
-- MemberJunction PostgreSQL Migration
-- HAND-AUTHORED translation of V202607072300__v1.0.x__Replace_ActionItems_With_Tasks.sql
--
-- The rule-based converter cannot translate this migration's T-SQL constructs
-- (batch-scoped DECLARE @vars, THROW, CROSS APPLY, DELETE-with-JOIN, and the
-- OBJECT_ID()-guarded DROPs — the latter were silently dropped, losing the
-- ActionItem table/view removal entirely). This file is the maintained PG
-- version; `mj migrate convert` never regenerates a .pg.sql that already
-- exists, so it is stable across conversion runs. If the SS original changes,
-- update this file by hand.
-- ============================================================================

-- Extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Schema
CREATE SCHEMA IF NOT EXISTS __mj_BizAppsCommittees;
SET search_path TO __mj_BizAppsCommittees, public;

SET standard_conforming_strings = on;

---------------------------------------------------------------------------
-- Replace ActionItems with BizAppsTasks (plans/BIZAPPS_TASKS_PLAN.md §3)
--
-- The thin ActionItem entity predates the BizAppsTasks integration and is
-- fully superseded by Task / TaskAssignment / TaskLink: provenance links
-- polymorphically via TaskLink (EntityID + RecordID → Committee, Meeting,
-- Agenda Item) and assignees via TaskAssignment against MJ_BizApps_Common
-- People. Artifact and Comment already carry TaskID FKs (baseline), so
-- plan step 5 is a no-op here.
--
-- Order matters: data migration first (Task reuses the ActionItem ID so the
-- copy is deterministic), then DB objects, then MJ entity metadata, then the
-- two app nav entries that pointed at the legacy tracker (labels stay; the
-- DriverClass moves to the tasks-backed TaskTrackerComponent).
--
-- Value sets map 1:1 — Priority (Low/Medium/High/Critical) and Status
-- (Open/InProgress/Blocked/Completed/Cancelled) use identical names in both
-- schemas, so no translation tables are needed.
--
-- After migrating: run `npm run mj:codegen` (single pass) to regenerate
-- entity/action subclasses without ActionItem, then verify with
-- `npm run test:harness:metadata` (16 committee entities, drift = 0).
---------------------------------------------------------------------------

-- 1 ── Data migration (plan §3 steps 1-4). Inert on fresh installs (baseline
--      creates ActionItem empty); on existing databases it preserves rows.
DO $mj$
DECLARE
  v_ActionItemTypeID   UUID;
  v_PrimaryRoleID      UUID;
  v_PeopleEntityID     UUID;
  v_CommitteeEntityID  UUID;
  v_MeetingEntityID    UUID;
  v_AgendaItemEntityID UUID;
BEGIN
  SELECT "ID" INTO v_ActionItemTypeID   FROM __mj_BizAppsTasks."TaskType" WHERE "Name" = 'Action Item';
  SELECT "ID" INTO v_PrimaryRoleID      FROM __mj_BizAppsTasks."TaskRole" WHERE "Name" = 'Primary';
  SELECT "ID" INTO v_PeopleEntityID     FROM ${mjSchema}."Entity" WHERE "Name" = 'MJ_BizApps_Common: People';
  SELECT "ID" INTO v_CommitteeEntityID  FROM ${mjSchema}."Entity" WHERE "Name" = 'Committees: Committees';
  SELECT "ID" INTO v_MeetingEntityID    FROM ${mjSchema}."Entity" WHERE "Name" = 'Committees: Meetings';
  SELECT "ID" INTO v_AgendaItemEntityID FROM ${mjSchema}."Entity" WHERE "Name" = 'Committees: Agenda Items';

  IF v_ActionItemTypeID IS NULL OR v_PrimaryRoleID IS NULL OR v_PeopleEntityID IS NULL
     OR v_CommitteeEntityID IS NULL OR v_MeetingEntityID IS NULL OR v_AgendaItemEntityID IS NULL THEN
    RAISE EXCEPTION 'ActionItem→Task migration: required TaskType/TaskRole/Entity lookup rows are missing. Install order must be __mj → __mj_BizAppsCommon → __mj_BizAppsTasks → __mj_BizAppsCommittees.';
  END IF;

  -- Step 1: a TaskCategory per committee that has action items (name = committee name)
  INSERT INTO __mj_BizAppsTasks."TaskCategory" ("ID", "Name", "Description", "Sequence", "IsActive")
  SELECT gen_random_uuid(), c."Name", 'Committee action items (migrated from Committees ActionItem)', 0, TRUE
  FROM __mj_BizAppsCommittees."Committee" c
  WHERE EXISTS (SELECT 1 FROM __mj_BizAppsCommittees."ActionItem" ai WHERE ai."CommitteeID" = c."ID")
    AND NOT EXISTS (SELECT 1 FROM __mj_BizAppsTasks."TaskCategory" tc WHERE tc."Name" = c."Name");

  -- Step 2: ActionItem → Task (Task reuses the ActionItem ID)
  INSERT INTO __mj_BizAppsTasks."Task"
      ("ID", "Name", "Description", "TypeID", "CategoryID", "Status", "Priority",
       "DueAt", "CompletedAt", "CompletionNotes", "PercentComplete", "Sequence", "CreatedByPersonID")
  SELECT ai."ID", ai."Name", ai."Description", v_ActionItemTypeID, tc."ID", ai."Status", ai."Priority",
         CAST(ai."DueDate" AS timestamptz), ai."CompletedAt", ai."CompletionNotes",
         CASE WHEN ai."Status" = 'Completed' THEN 100 ELSE 0 END, 0, ai."AssignedByPersonID"
  FROM __mj_BizAppsCommittees."ActionItem" ai
       INNER JOIN __mj_BizAppsCommittees."Committee" c ON ai."CommitteeID" = c."ID"
       LEFT JOIN __mj_BizAppsTasks."TaskCategory" tc ON tc."Name" = c."Name"
  WHERE NOT EXISTS (SELECT 1 FROM __mj_BizAppsTasks."Task" t WHERE t."ID" = ai."ID");

  -- Step 3: assignee → TaskAssignment (Role = Primary, polymorphic to People)
  INSERT INTO __mj_BizAppsTasks."TaskAssignment"
      ("ID", "TaskID", "AssigneeEntityID", "AssigneeRecordID", "RoleID", "Status", "AssignedByPersonID", "AssignedAt")
  SELECT gen_random_uuid(), ai."ID", v_PeopleEntityID, CAST(ai."AssignedToPersonID" AS VARCHAR(50)), v_PrimaryRoleID,
         CASE ai."Status" WHEN 'Completed' THEN 'Completed' WHEN 'InProgress' THEN 'InProgress' ELSE 'Pending' END,
         ai."AssignedByPersonID", ai."__mj_CreatedAt"
  FROM __mj_BizAppsCommittees."ActionItem" ai
  WHERE NOT EXISTS (SELECT 1 FROM __mj_BizAppsTasks."TaskAssignment" ta WHERE ta."TaskID" = ai."ID");

  -- Step 4: provenance → TaskLink (committee always; meeting/agenda item when set).
  -- T-SQL CROSS APPLY (VALUES ...) becomes CROSS JOIN LATERAL (VALUES ...).
  INSERT INTO __mj_BizAppsTasks."TaskLink" ("ID", "TaskID", "EntityID", "RecordID", "Description")
  SELECT gen_random_uuid(), ai."ID", x."EntityID", x."RecordID", x."Description"
  FROM __mj_BizAppsCommittees."ActionItem" ai
       CROSS JOIN LATERAL (VALUES
           (v_CommitteeEntityID,  CAST(ai."CommitteeID"  AS VARCHAR(50)), 'Committee'),
           (v_MeetingEntityID,    CAST(ai."MeetingID"    AS VARCHAR(50)), 'Meeting'),
           (v_AgendaItemEntityID, CAST(ai."AgendaItemID" AS VARCHAR(50)), 'Agenda item')
       ) AS x("EntityID", "RecordID", "Description")
  WHERE x."RecordID" IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM __mj_BizAppsTasks."TaskLink" tl
                    WHERE tl."TaskID" = ai."ID" AND tl."EntityID" = x."EntityID" AND tl."RecordID" = x."RecordID");
END $mj$;

-- 2 ── Database objects (plan §3 step 6; the codegen-created trigger drops with
--      the table). On a FRESH PG install none of these exist yet (`mj codegen`
--      runs after `mj migrate`), so every drop is IF EXISTS / tolerant. On an
--      EXISTING PG install they were created by a prior codegen run.
--      The CRUD "sprocs" are FUNCTIONS on PostgreSQL.
DO $$
BEGIN
  DROP FUNCTION IF EXISTS __mj_BizAppsCommittees."spCreateActionItem";
  DROP FUNCTION IF EXISTS __mj_BizAppsCommittees."spUpdateActionItem";
  DROP FUNCTION IF EXISTS __mj_BizAppsCommittees."spDeleteActionItem";
EXCEPTION WHEN others THEN NULL; -- tolerate overload ambiguity on nonstandard installs
END $$;
DROP VIEW IF EXISTS __mj_BizAppsCommittees."vwActionItems" CASCADE;
DROP TABLE IF EXISTS __mj_BizAppsCommittees."ActionItem";

-- 3 ── MJ entity metadata, children first. No existence guards on purpose:
--      if anything unexpected still references the entity, the FK violation
--      should fail this migration loudly rather than leave orphans.
DO $mj$
DECLARE
  v_ActionItemEntityID UUID := '97337824-6D33-4814-BF26-F422A0869642';
BEGIN
  -- T-SQL DELETE-with-JOIN becomes DELETE ... USING.
  DELETE FROM ${mjSchema}."EntityFieldValue" efv
   USING ${mjSchema}."EntityField" ef
   WHERE efv."EntityFieldID" = ef."ID"
     AND ef."EntityID" = v_ActionItemEntityID;

  DELETE FROM ${mjSchema}."EntityField"
   WHERE "EntityID" = v_ActionItemEntityID;

  DELETE FROM ${mjSchema}."EntityRelationship"
   WHERE "EntityID" = v_ActionItemEntityID OR "RelatedEntityID" = v_ActionItemEntityID;

  DELETE FROM ${mjSchema}."EntityPermission"
   WHERE "EntityID" = v_ActionItemEntityID;

  -- Audit rows for legacy action items (the entity is going away, so its
  -- change history has nothing to attach to) and per-user app entity pins.
  DELETE FROM ${mjSchema}."RecordChange"
   WHERE "EntityID" = v_ActionItemEntityID;

  DELETE FROM ${mjSchema}."UserApplicationEntity"
   WHERE "EntityID" = v_ActionItemEntityID;

  DELETE FROM ${mjSchema}."ApplicationEntity"
   WHERE "EntityID" = v_ActionItemEntityID;

  DELETE FROM ${mjSchema}."Entity"
   WHERE "ID" = v_ActionItemEntityID;
END $mj$;

-- 4 ── App navigation: swap the tracker DriverClass in both apps.
--      Labels ("Action Items" member app, "Actions" management app) stay.
UPDATE ${mjSchema}."Application"
   SET "DefaultNavItems" = REPLACE("DefaultNavItems", '"DriverClass":"ActionItemTrackerComponent"', '"DriverClass":"TaskTrackerComponent"')
 WHERE "ID" IN ('B5D2C7A4-3E61-4E8B-9F2A-6C815D9E4A01', 'B5D2C7A4-3E61-4E8B-9F2A-6C815D9E4A02')
   AND "DefaultNavItems" LIKE '%ActionItemTrackerComponent%';
