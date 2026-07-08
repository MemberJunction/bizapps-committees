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
DECLARE @ActionItemTypeID uniqueidentifier =
    (SELECT ID FROM __mj_BizAppsTasks.TaskType WHERE Name = 'Action Item');
DECLARE @PrimaryRoleID uniqueidentifier =
    (SELECT ID FROM __mj_BizAppsTasks.TaskRole WHERE Name = 'Primary');
DECLARE @PeopleEntityID uniqueidentifier =
    (SELECT ID FROM [${mjSchema}].[Entity] WHERE Name = 'MJ_BizApps_Common: People');
DECLARE @CommitteeEntityID uniqueidentifier =
    (SELECT ID FROM [${mjSchema}].[Entity] WHERE Name = 'Committees: Committees');
DECLARE @MeetingEntityID uniqueidentifier =
    (SELECT ID FROM [${mjSchema}].[Entity] WHERE Name = 'Committees: Meetings');
DECLARE @AgendaItemEntityID uniqueidentifier =
    (SELECT ID FROM [${mjSchema}].[Entity] WHERE Name = 'Committees: Agenda Items');

IF @ActionItemTypeID IS NULL OR @PrimaryRoleID IS NULL OR @PeopleEntityID IS NULL
   OR @CommitteeEntityID IS NULL OR @MeetingEntityID IS NULL OR @AgendaItemEntityID IS NULL
    THROW 50001, 'ActionItem→Task migration: required TaskType/TaskRole/Entity lookup rows are missing. Install order must be __mj → __mj_BizAppsCommon → __mj_BizAppsTasks → __mj_BizAppsCommittees.', 1;

-- Step 1: a TaskCategory per committee that has action items (name = committee name)
INSERT INTO __mj_BizAppsTasks.TaskCategory (ID, Name, Description, Sequence, IsActive)
SELECT NEWID(), c.Name, 'Committee action items (migrated from Committees ActionItem)', 0, 1
FROM [${flyway:defaultSchema}].[Committee] c
WHERE EXISTS (SELECT 1 FROM [${flyway:defaultSchema}].[ActionItem] ai WHERE ai.CommitteeID = c.ID)
  AND NOT EXISTS (SELECT 1 FROM __mj_BizAppsTasks.TaskCategory tc WHERE tc.Name = c.Name);

-- Step 2: ActionItem → Task (Task reuses the ActionItem ID)
INSERT INTO __mj_BizAppsTasks.Task
    (ID, Name, Description, TypeID, CategoryID, Status, Priority,
     DueAt, CompletedAt, CompletionNotes, PercentComplete, Sequence, CreatedByPersonID)
SELECT ai.ID, ai.Name, ai.Description, @ActionItemTypeID, tc.ID, ai.Status, ai.Priority,
       CAST(ai.DueDate AS datetimeoffset), ai.CompletedAt, ai.CompletionNotes,
       CASE WHEN ai.Status = 'Completed' THEN 100 ELSE 0 END, 0, ai.AssignedByPersonID
FROM [${flyway:defaultSchema}].[ActionItem] ai
     INNER JOIN [${flyway:defaultSchema}].[Committee] c ON ai.CommitteeID = c.ID
     LEFT JOIN __mj_BizAppsTasks.TaskCategory tc ON tc.Name = c.Name
WHERE NOT EXISTS (SELECT 1 FROM __mj_BizAppsTasks.Task t WHERE t.ID = ai.ID);

-- Step 3: assignee → TaskAssignment (Role = Primary, polymorphic to People)
INSERT INTO __mj_BizAppsTasks.TaskAssignment
    (ID, TaskID, AssigneeEntityID, AssigneeRecordID, RoleID, Status, AssignedByPersonID, AssignedAt)
SELECT NEWID(), ai.ID, @PeopleEntityID, CAST(ai.AssignedToPersonID AS nvarchar(50)), @PrimaryRoleID,
       CASE ai.Status WHEN 'Completed' THEN 'Completed' WHEN 'InProgress' THEN 'InProgress' ELSE 'Pending' END,
       ai.AssignedByPersonID, ai.__mj_CreatedAt
FROM [${flyway:defaultSchema}].[ActionItem] ai
WHERE NOT EXISTS (SELECT 1 FROM __mj_BizAppsTasks.TaskAssignment ta WHERE ta.TaskID = ai.ID);

-- Step 4: provenance → TaskLink (committee always; meeting/agenda item when set)
INSERT INTO __mj_BizAppsTasks.TaskLink (ID, TaskID, EntityID, RecordID, Description)
SELECT NEWID(), ai.ID, x.EntityID, x.RecordID, x.Description
FROM [${flyway:defaultSchema}].[ActionItem] ai
     CROSS APPLY (VALUES
         (@CommitteeEntityID,  CAST(ai.CommitteeID  AS nvarchar(50)), 'Committee'),
         (@MeetingEntityID,    CAST(ai.MeetingID    AS nvarchar(50)), 'Meeting'),
         (@AgendaItemEntityID, CAST(ai.AgendaItemID AS nvarchar(50)), 'Agenda item')
     ) x (EntityID, RecordID, Description)
WHERE x.RecordID IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM __mj_BizAppsTasks.TaskLink tl
                  WHERE tl.TaskID = ai.ID AND tl.EntityID = x.EntityID AND tl.RecordID = x.RecordID);
GO

-- 2 ── Database objects (plan §3 step 6; trigger and FK indexes drop with the table)
IF OBJECT_ID('[${flyway:defaultSchema}].[spCreateActionItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spCreateActionItem];
IF OBJECT_ID('[${flyway:defaultSchema}].[spUpdateActionItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spUpdateActionItem];
IF OBJECT_ID('[${flyway:defaultSchema}].[spDeleteActionItem]', 'P') IS NOT NULL
    DROP PROCEDURE [${flyway:defaultSchema}].[spDeleteActionItem];
IF OBJECT_ID('[${flyway:defaultSchema}].[vwActionItems]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwActionItems];
IF OBJECT_ID('[${flyway:defaultSchema}].[ActionItem]', 'U') IS NOT NULL
    DROP TABLE [${flyway:defaultSchema}].[ActionItem];
GO

-- 3 ── MJ entity metadata, children first. No IF EXISTS guards on purpose:
--      if anything unexpected still references the entity, the FK violation
--      should fail this migration loudly rather than leave orphans.
DECLARE @ActionItemEntityID uniqueidentifier = '97337824-6D33-4814-BF26-F422A0869642';

DELETE efv
  FROM [${mjSchema}].[EntityFieldValue] efv
       INNER JOIN [${mjSchema}].[EntityField] ef ON efv.EntityFieldID = ef.ID
 WHERE ef.EntityID = @ActionItemEntityID;

DELETE FROM [${mjSchema}].[EntityField]
 WHERE EntityID = @ActionItemEntityID;

DELETE FROM [${mjSchema}].[EntityRelationship]
 WHERE EntityID = @ActionItemEntityID OR RelatedEntityID = @ActionItemEntityID;

DELETE FROM [${mjSchema}].[EntityPermission]
 WHERE EntityID = @ActionItemEntityID;

-- Audit rows for legacy action items (the entity is going away, so its
-- change history has nothing to attach to) and per-user app entity pins.
DELETE FROM [${mjSchema}].[RecordChange]
 WHERE EntityID = @ActionItemEntityID;

DELETE FROM [${mjSchema}].[UserApplicationEntity]
 WHERE EntityID = @ActionItemEntityID;

DELETE FROM [${mjSchema}].[ApplicationEntity]
 WHERE EntityID = @ActionItemEntityID;

DELETE FROM [${mjSchema}].[Entity]
 WHERE ID = @ActionItemEntityID;
GO

-- 4 ── App navigation: swap the tracker DriverClass in both apps.
--      Labels ("Action Items" member app, "Actions" management app) stay.
UPDATE [${mjSchema}].[Application]
   SET DefaultNavItems = REPLACE(DefaultNavItems, '"DriverClass":"ActionItemTrackerComponent"', '"DriverClass":"TaskTrackerComponent"')
 WHERE ID IN ('B5D2C7A4-3E61-4E8B-9F2A-6C815D9E4A01', 'B5D2C7A4-3E61-4E8B-9F2A-6C815D9E4A02')
   AND DefaultNavItems LIKE '%ActionItemTrackerComponent%';
GO
