-- =============================================================================================
-- PostgreSQL counterpart of V202610231900__v1.5.x__Metadata_Sync.sql -- BizApps Committees v1.5.x Metadata_Sync
-- =============================================================================================
-- Same records, same values, same order as the T-SQL file; see its header for what ships, what is
-- left out (the record process's Scheduled Job) and why.
--
-- HOW IT WAS MADE
--   * `mj sql-convert --from tsql --to postgres` (MJ CLI 6.1.6) on the push log, the core schema
--     written as `__mj` first so the converter does not skip the calls. Each record is a DO block
--     that calls the core function in whichever signature the host has (jsonb or named parameters).
--   * Core calls then use `${mjSchema}`, as the Accounting, Common, Orders and Sales seeds do.
--   * The converter rewrites string literals and can drop BIT and numeric values (MJ#5918), so every
--     assignment is copied verbatim from the T-SQL file (BIT 1/0 as TRUE/FALSE) and checked one by
--     one. The filter's FilterText and the record process's ScopeFilter are stored exactly as
--     metadata/ declares them, which is SQL Server syntax.
--   * The guards are the T-SQL file's: creates skip when the ID exists (the filter also on Name);
--     the permission is re-resolved by EntityID + RoleID + Type, updated when present and created
--     when absent; the UI role and the filter are re-resolved by name.
--   * Every block was checked to parse and compile on postgres:16.
-- =============================================================================================

SET standard_conforming_strings = on;

-- Save MJ: Row Level Security Filters (core SP call only)
DO $mj$
DECLARE
  p_ID_0a1b1f845dd2 UUID;
  p_Name_0a1b1f845dd2 VARCHAR(100);
  p_Description_0a1b1f845dd2 TEXT;
  p_FilterText_0a1b1f845dd2 TEXT;
BEGIN
  p_ID_0a1b1f845dd2 := '6C0B4F2A-9D3E-4B7A-8E51-2F7D9A1C3B64';
  p_Name_0a1b1f845dd2 := 'Committees: Visible Votes';
  p_Description_0a1b1f845dd2 := 'A vote the caller cast (their Person holds the membership), every vote on a motion that has no ballot (roll calls taken in a meeting), and every vote on a ballot that is Closed or Cancelled and not sealed. A sealed ballot never shows another member''s choice, in any status. The caller''s Person is the user''s own People link (LinkedEntityRecordID, when LinkedEntityID is People or a subtype of it), else the Person whose deprecated LinkedUserID names the user. Parenthesised so it ANDs onto any other filter the caller holds.';
  p_FilterText_0a1b1f845dd2 := '(MembershipID IN (SELECT m.ID FROM [__mj_BizAppsCommittees].[vwMemberships] m WHERE m.PersonID IN (SELECT TRY_CAST(u.LinkedEntityRecordID AS UNIQUEIDENTIFIER) FROM [${mjSchema}].[vwUsers] u WHERE u.ID = TRY_CAST(''{{UserID}}'' AS UNIQUEIDENTIFIER) AND u.LinkedEntityID IN (SELECT e.ID FROM [${mjSchema}].[vwEntities] e WHERE e.Name = N''MJ_BizApps_Common: People'' OR e.ParentID IN (SELECT pe.ID FROM [${mjSchema}].[vwEntities] pe WHERE pe.Name = N''MJ_BizApps_Common: People'')))) OR MembershipID IN (SELECT m.ID FROM [__mj_BizAppsCommittees].[vwMemberships] m INNER JOIN [__mj_BizAppsCommon].[vwPeople] p ON p.ID = m.PersonID WHERE p.LinkedUserID = TRY_CAST(''{{UserID}}'' AS UNIQUEIDENTIFIER)) OR MotionID NOT IN (SELECT b.MotionID FROM [__mj_BizAppsCommittees].[vwBallots] b WHERE b.MotionID IS NOT NULL) OR MotionID IN (SELECT b.MotionID FROM [__mj_BizAppsCommittees].[vwBallots] b WHERE b.Status IN (N''Closed'', N''Cancelled'') AND b.IsSealed = 0))';
  IF NOT EXISTS (SELECT 1 FROM ${mjSchema}."RowLevelSecurityFilter"
               WHERE "ID" = p_ID_0a1b1f845dd2
                  OR ("Name" = p_Name_0a1b1f845dd2)) THEN
    IF EXISTS (
      SELECT 1 FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
       WHERE n.nspname = '${mjSchema}' AND p.proname = 'spCreateRowLevelSecurityFilter'
         AND p.pronargs = 1 AND p.proargtypes[0] = 'jsonb'::regtype
    ) THEN
      PERFORM ${mjSchema}."spCreateRowLevelSecurityFilter"(p_data := jsonb_build_object(
      'ID', p_ID_0a1b1f845dd2,
      'Name', p_Name_0a1b1f845dd2,
      'Description', p_Description_0a1b1f845dd2,
      'FilterText', p_FilterText_0a1b1f845dd2
    ));
    ELSE
      PERFORM ${mjSchema}."spCreateRowLevelSecurityFilter"(p_ID := p_ID_0a1b1f845dd2, p_Name := p_Name_0a1b1f845dd2, p_Description := p_Description_0a1b1f845dd2, p_FilterText := p_FilterText_0a1b1f845dd2);
    END IF;
  END IF;
END $mj$;

-- Save MJ: Entity Permissions (core SP call only)
DO $mj$
DECLARE
  p_EntityID_384964319596 UUID;
  p_RoleID_384964319596 UUID;
  p_CanCreate_384964319596 BOOLEAN;
  p_CanRead_384964319596 BOOLEAN;
  p_CanUpdate_384964319596 BOOLEAN;
  p_CanDelete_384964319596 BOOLEAN;
  p_ReadRLSFilterID_384964319596 UUID;
  p_CreateRLSFilterID_384964319596 UUID;
  p_UpdateRLSFilterID_384964319596 UUID;
  p_DeleteRLSFilterID_384964319596 UUID;
  p_Type_384964319596 VARCHAR(10);
  p_ID_384964319596 UUID;
BEGIN
  p_EntityID_384964319596 := '94A59079-7436-4178-A31B-9B42DDA822C1';
  p_RoleID_384964319596 := 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E';
  p_CanCreate_384964319596 := FALSE;
  p_CanRead_384964319596 := TRUE;
  p_CanUpdate_384964319596 := FALSE;
  p_CanDelete_384964319596 := FALSE;
  p_ReadRLSFilterID_384964319596 := '6C0B4F2A-9D3E-4B7A-8E51-2F7D9A1C3B64';
  p_Type_384964319596 := 'Allow';
  p_RoleID_384964319596 := COALESCE((SELECT "ID" FROM ${mjSchema}."Role" WHERE "Name" = 'UI' ORDER BY CASE WHEN "ID" = p_RoleID_384964319596 THEN 0 ELSE 1 END LIMIT 1), p_RoleID_384964319596);
  p_ReadRLSFilterID_384964319596 := COALESCE((SELECT "ID" FROM ${mjSchema}."RowLevelSecurityFilter" WHERE "Name" = 'Committees: Visible Votes' ORDER BY CASE WHEN "ID" = p_ReadRLSFilterID_384964319596 THEN 0 ELSE 1 END LIMIT 1), p_ReadRLSFilterID_384964319596);
  p_ID_384964319596 := (SELECT "ID" FROM ${mjSchema}."EntityPermission" WHERE "EntityID" = p_EntityID_384964319596 AND "RoleID" = p_RoleID_384964319596 AND "Type" = p_Type_384964319596 LIMIT 1);
  IF p_ID_384964319596 IS NOT NULL THEN
    IF EXISTS (
      SELECT 1 FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
       WHERE n.nspname = '${mjSchema}' AND p.proname = 'spUpdateEntityPermission'
         AND p.pronargs = 1 AND p.proargtypes[0] = 'jsonb'::regtype
    ) THEN
      PERFORM ${mjSchema}."spUpdateEntityPermission"(p_data := jsonb_build_object(
      'EntityID', p_EntityID_384964319596,
      'RoleID', p_RoleID_384964319596,
      'CanCreate', p_CanCreate_384964319596,
      'CanRead', p_CanRead_384964319596,
      'CanUpdate', p_CanUpdate_384964319596,
      'CanDelete', p_CanDelete_384964319596,
      'ReadRLSFilterID', p_ReadRLSFilterID_384964319596,
      'CreateRLSFilterID', p_CreateRLSFilterID_384964319596,
      'UpdateRLSFilterID', p_UpdateRLSFilterID_384964319596,
      'DeleteRLSFilterID', p_DeleteRLSFilterID_384964319596,
      'Type', p_Type_384964319596,
      'ID', p_ID_384964319596
    ));
    ELSE
      PERFORM ${mjSchema}."spUpdateEntityPermission"(p_EntityID := p_EntityID_384964319596, p_RoleID := p_RoleID_384964319596, p_CanCreate := p_CanCreate_384964319596, p_CanRead := p_CanRead_384964319596, p_CanUpdate := p_CanUpdate_384964319596, p_CanDelete := p_CanDelete_384964319596, p_ReadRLSFilterID := p_ReadRLSFilterID_384964319596, p_CreateRLSFilterID := p_CreateRLSFilterID_384964319596, p_CreateRLSFilterID_Clear := TRUE, p_UpdateRLSFilterID := p_UpdateRLSFilterID_384964319596, p_UpdateRLSFilterID_Clear := TRUE, p_DeleteRLSFilterID := p_DeleteRLSFilterID_384964319596, p_DeleteRLSFilterID_Clear := TRUE, p_Type := p_Type_384964319596, p_ID := p_ID_384964319596);
    END IF;
  END IF;
END $mj$;

-- Save MJ: Entity Permissions (core SP call only): create when the host has no row for the key
DO $mj$
DECLARE
  p_EntityID_c84964319596 UUID;
  p_RoleID_c84964319596 UUID;
  p_CanCreate_c84964319596 BOOLEAN;
  p_CanRead_c84964319596 BOOLEAN;
  p_CanUpdate_c84964319596 BOOLEAN;
  p_CanDelete_c84964319596 BOOLEAN;
  p_ReadRLSFilterID_c84964319596 UUID;
  p_CreateRLSFilterID_c84964319596 UUID;
  p_UpdateRLSFilterID_c84964319596 UUID;
  p_DeleteRLSFilterID_c84964319596 UUID;
  p_Type_c84964319596 VARCHAR(10);
BEGIN
  p_EntityID_c84964319596 := '94A59079-7436-4178-A31B-9B42DDA822C1';
  p_RoleID_c84964319596 := 'E0AFCCEC-6A37-EF11-86D4-000D3A4E707E';
  p_CanCreate_c84964319596 := FALSE;
  p_CanRead_c84964319596 := TRUE;
  p_CanUpdate_c84964319596 := FALSE;
  p_CanDelete_c84964319596 := FALSE;
  p_ReadRLSFilterID_c84964319596 := '6C0B4F2A-9D3E-4B7A-8E51-2F7D9A1C3B64';
  p_Type_c84964319596 := 'Allow';
  p_RoleID_c84964319596 := COALESCE((SELECT "ID" FROM ${mjSchema}."Role" WHERE "Name" = 'UI' ORDER BY CASE WHEN "ID" = p_RoleID_c84964319596 THEN 0 ELSE 1 END LIMIT 1), p_RoleID_c84964319596);
  p_ReadRLSFilterID_c84964319596 := COALESCE((SELECT "ID" FROM ${mjSchema}."RowLevelSecurityFilter" WHERE "Name" = 'Committees: Visible Votes' ORDER BY CASE WHEN "ID" = p_ReadRLSFilterID_c84964319596 THEN 0 ELSE 1 END LIMIT 1), p_ReadRLSFilterID_c84964319596);
  IF NOT EXISTS (SELECT 1 FROM ${mjSchema}."EntityPermission"
               WHERE "EntityID" = p_EntityID_c84964319596 AND "RoleID" = p_RoleID_c84964319596 AND "Type" = p_Type_c84964319596) THEN
    IF EXISTS (
      SELECT 1 FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
       WHERE n.nspname = '${mjSchema}' AND p.proname = 'spCreateEntityPermission'
         AND p.pronargs = 1 AND p.proargtypes[0] = 'jsonb'::regtype
    ) THEN
      PERFORM ${mjSchema}."spCreateEntityPermission"(p_data := jsonb_build_object(
      'EntityID', p_EntityID_c84964319596,
      'RoleID', p_RoleID_c84964319596,
      'CanCreate', p_CanCreate_c84964319596,
      'CanRead', p_CanRead_c84964319596,
      'CanUpdate', p_CanUpdate_c84964319596,
      'CanDelete', p_CanDelete_c84964319596,
      'ReadRLSFilterID', p_ReadRLSFilterID_c84964319596,
      'CreateRLSFilterID', p_CreateRLSFilterID_c84964319596,
      'UpdateRLSFilterID', p_UpdateRLSFilterID_c84964319596,
      'DeleteRLSFilterID', p_DeleteRLSFilterID_c84964319596,
      'Type', p_Type_c84964319596
    ));
    ELSE
      PERFORM ${mjSchema}."spCreateEntityPermission"(p_EntityID := p_EntityID_c84964319596, p_RoleID := p_RoleID_c84964319596, p_CanCreate := p_CanCreate_c84964319596, p_CanRead := p_CanRead_c84964319596, p_CanUpdate := p_CanUpdate_c84964319596, p_CanDelete := p_CanDelete_c84964319596, p_ReadRLSFilterID := p_ReadRLSFilterID_c84964319596, p_CreateRLSFilterID := p_CreateRLSFilterID_c84964319596, p_UpdateRLSFilterID := p_UpdateRLSFilterID_c84964319596, p_DeleteRLSFilterID := p_DeleteRLSFilterID_c84964319596, p_Type := p_Type_c84964319596);
    END IF;
  END IF;
END $mj$;

-- Save MJ: Record Processes (core SP call only)
DO $mj$
DECLARE
  p_ID_9b55fd4da0fe UUID;
  p_Name_9b55fd4da0fe VARCHAR(255);
  p_Description_9b55fd4da0fe TEXT;
  p_CategoryID_9b55fd4da0fe UUID;
  p_EntityID_9b55fd4da0fe UUID;
  p_Status_9b55fd4da0fe VARCHAR(20);
  p_WorkType_9b55fd4da0fe VARCHAR(20);
  p_ActionID_9b55fd4da0fe UUID;
  p_AgentID_9b55fd4da0fe UUID;
  p_PromptID_9b55fd4da0fe UUID;
  p_ScopeType_9b55fd4da0fe VARCHAR(20);
  p_ScopeViewID_9b55fd4da0fe UUID;
  p_ScopeListID_9b55fd4da0fe UUID;
  p_ScopeFilter_9b55fd4da0fe TEXT;
  p_OnChangeEnabled_9b55fd4da0fe BOOLEAN;
  p_OnChangeInvocationType_9b55fd4da0fe VARCHAR(30);
  p_OnChangeFilter_9b55fd4da0fe TEXT;
  p_ScheduleEnabled_9b55fd4da0fe BOOLEAN;
  p_CronExpression_9b55fd4da0fe VARCHAR(120);
  p_Timezone_9b55fd4da0fe VARCHAR(100);
  p_OnDemandEnabled_9b55fd4da0fe BOOLEAN;
  p_InputMapping_9b55fd4da0fe TEXT;
  p_OutputMapping_9b55fd4da0fe TEXT;
  p_SkipUnchanged_9b55fd4da0fe BOOLEAN;
  p_WatermarkStrategy_9b55fd4da0fe VARCHAR(20);
  p_BatchSize_9b55fd4da0fe INTEGER;
  p_MaxConcurrency_9b55fd4da0fe INTEGER;
  p_Configuration_9b55fd4da0fe TEXT;
BEGIN
  p_ID_9b55fd4da0fe := 'C1A02E75-4C6E-49B0-96F3-79D1A8E26050';
  p_Name_9b55fd4da0fe := 'Score Committees: Meetings with model C1A02E75-4C6E-49B0-96F3-79D1A8E26011 (Weekly)';
  p_Description_9b55fd4da0fe := 'Scores upcoming committee meetings for Quorum Risk';
  p_EntityID_9b55fd4da0fe := 'F7DEBA2D-4E28-4C6E-971B-6099217FAB29';
  p_Status_9b55fd4da0fe := 'Active';
  p_WorkType_9b55fd4da0fe := 'ML Model';
  p_ScopeType_9b55fd4da0fe := 'Filter';
  p_ScopeFilter_9b55fd4da0fe := 'QuorumRiskOutcome IS NULL AND StartDateTime >= GETUTCDATE()';
  p_OnChangeEnabled_9b55fd4da0fe := FALSE;
  p_ScheduleEnabled_9b55fd4da0fe := TRUE;
  p_CronExpression_9b55fd4da0fe := '0 6 * * 1';
  p_Timezone_9b55fd4da0fe := 'UTC';
  p_OnDemandEnabled_9b55fd4da0fe := TRUE;
  p_OutputMapping_9b55fd4da0fe := '{"PredictedQuorumRiskProbability":"$.score","PredictedQuorumRiskBand":"$.band","PredictedQuorumRiskScoredAt":"$.scoredAt"}';
  p_SkipUnchanged_9b55fd4da0fe := TRUE;
  p_BatchSize_9b55fd4da0fe := 100;
  p_MaxConcurrency_9b55fd4da0fe := 1;
  p_Configuration_9b55fd4da0fe := '{"modelId":"C1A02E75-4C6E-49B0-96F3-79D1A8E26011","primaryKeyField":"ID"}';
  IF NOT EXISTS (SELECT 1 FROM ${mjSchema}."RecordProcess"
               WHERE "ID" = p_ID_9b55fd4da0fe) THEN
    IF EXISTS (
      SELECT 1 FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
       WHERE n.nspname = '${mjSchema}' AND p.proname = 'spCreateRecordProcess'
         AND p.pronargs = 1 AND p.proargtypes[0] = 'jsonb'::regtype
    ) THEN
      PERFORM ${mjSchema}."spCreateRecordProcess"(p_data := jsonb_build_object(
      'ID', p_ID_9b55fd4da0fe,
      'Name', p_Name_9b55fd4da0fe,
      'Description', p_Description_9b55fd4da0fe,
      'CategoryID', p_CategoryID_9b55fd4da0fe,
      'EntityID', p_EntityID_9b55fd4da0fe,
      'Status', p_Status_9b55fd4da0fe,
      'WorkType', p_WorkType_9b55fd4da0fe,
      'ActionID', p_ActionID_9b55fd4da0fe,
      'AgentID', p_AgentID_9b55fd4da0fe,
      'PromptID', p_PromptID_9b55fd4da0fe,
      'ScopeType', p_ScopeType_9b55fd4da0fe,
      'ScopeViewID', p_ScopeViewID_9b55fd4da0fe,
      'ScopeListID', p_ScopeListID_9b55fd4da0fe,
      'ScopeFilter', p_ScopeFilter_9b55fd4da0fe,
      'OnChangeEnabled', p_OnChangeEnabled_9b55fd4da0fe,
      'OnChangeInvocationType', p_OnChangeInvocationType_9b55fd4da0fe,
      'OnChangeFilter', p_OnChangeFilter_9b55fd4da0fe,
      'ScheduleEnabled', p_ScheduleEnabled_9b55fd4da0fe,
      'CronExpression', p_CronExpression_9b55fd4da0fe,
      'Timezone', p_Timezone_9b55fd4da0fe,
      'OnDemandEnabled', p_OnDemandEnabled_9b55fd4da0fe,
      'InputMapping', p_InputMapping_9b55fd4da0fe,
      'OutputMapping', p_OutputMapping_9b55fd4da0fe,
      'SkipUnchanged', p_SkipUnchanged_9b55fd4da0fe,
      'WatermarkStrategy', p_WatermarkStrategy_9b55fd4da0fe,
      'BatchSize', p_BatchSize_9b55fd4da0fe,
      'MaxConcurrency', p_MaxConcurrency_9b55fd4da0fe,
      'Configuration', p_Configuration_9b55fd4da0fe
    ));
    ELSE
      PERFORM ${mjSchema}."spCreateRecordProcess"(p_ID := p_ID_9b55fd4da0fe, p_Name := p_Name_9b55fd4da0fe, p_Description := p_Description_9b55fd4da0fe, p_CategoryID := p_CategoryID_9b55fd4da0fe, p_CategoryID_Clear := TRUE, p_EntityID := p_EntityID_9b55fd4da0fe, p_Status := p_Status_9b55fd4da0fe, p_WorkType := p_WorkType_9b55fd4da0fe, p_ActionID := p_ActionID_9b55fd4da0fe, p_ActionID_Clear := TRUE, p_AgentID := p_AgentID_9b55fd4da0fe, p_AgentID_Clear := TRUE, p_PromptID := p_PromptID_9b55fd4da0fe, p_PromptID_Clear := TRUE, p_ScopeType := p_ScopeType_9b55fd4da0fe, p_ScopeViewID := p_ScopeViewID_9b55fd4da0fe, p_ScopeViewID_Clear := TRUE, p_ScopeListID := p_ScopeListID_9b55fd4da0fe, p_ScopeListID_Clear := TRUE, p_ScopeFilter := p_ScopeFilter_9b55fd4da0fe, p_OnChangeEnabled := p_OnChangeEnabled_9b55fd4da0fe, p_OnChangeInvocationType := p_OnChangeInvocationType_9b55fd4da0fe, p_OnChangeInvocationType_Clear := TRUE, p_OnChangeFilter := p_OnChangeFilter_9b55fd4da0fe, p_OnChangeFilter_Clear := TRUE, p_ScheduleEnabled := p_ScheduleEnabled_9b55fd4da0fe, p_CronExpression := p_CronExpression_9b55fd4da0fe, p_Timezone := p_Timezone_9b55fd4da0fe, p_OnDemandEnabled := p_OnDemandEnabled_9b55fd4da0fe, p_InputMapping := p_InputMapping_9b55fd4da0fe, p_InputMapping_Clear := TRUE, p_OutputMapping := p_OutputMapping_9b55fd4da0fe, p_SkipUnchanged := p_SkipUnchanged_9b55fd4da0fe, p_WatermarkStrategy := p_WatermarkStrategy_9b55fd4da0fe, p_WatermarkStrategy_Clear := TRUE, p_BatchSize := p_BatchSize_9b55fd4da0fe, p_MaxConcurrency := p_MaxConcurrency_9b55fd4da0fe, p_Configuration := p_Configuration_9b55fd4da0fe);
    END IF;
  END IF;
END $mj$;

-- Save MJ: ML Training Pipelines (core SP call only)
DO $mj$
DECLARE
  p_ID_8d18ed8a6a41 UUID;
  p_Name_8d18ed8a6a41 VARCHAR(255);
  p_Description_8d18ed8a6a41 TEXT;
  p_Version_8d18ed8a6a41 INTEGER;
  p_Status_8d18ed8a6a41 VARCHAR(20);
  p_TargetEntityID_8d18ed8a6a41 UUID;
  p_TargetVariable_8d18ed8a6a41 VARCHAR(500);
  p_ProblemType_8d18ed8a6a41 VARCHAR(20);
  p_AlgorithmID_8d18ed8a6a41 UUID;
  p_Hyperparameters_8d18ed8a6a41 TEXT;
  p_SourceBindings_8d18ed8a6a41 TEXT;
  p_FeatureSteps_8d18ed8a6a41 TEXT;
  p_AsOfStrategy_8d18ed8a6a41 TEXT;
  p_LeakageGuard_8d18ed8a6a41 TEXT;
  p_ValidationStrategy_8d18ed8a6a41 TEXT;
BEGIN
  p_ID_8d18ed8a6a41 := 'C1A02E75-4C6E-49B0-96F3-79D1A8E26001';
  p_Name_8d18ed8a6a41 := 'Predict Meeting Quorum Risk';
  p_Description_8d18ed8a6a41 := 'Forecasts whether upcoming committee meetings will fail to achieve a quorum of voting members, based on scheduling, location type, roster size, and historical attendance patterns.';
  p_Version_8d18ed8a6a41 := 1;
  p_Status_8d18ed8a6a41 := 'Draft';
  p_TargetEntityID_8d18ed8a6a41 := 'F7DEBA2D-4E28-4C6E-971B-6099217FAB29';
  p_TargetVariable_8d18ed8a6a41 := 'QuorumRiskOutcome';
  p_ProblemType_8d18ed8a6a41 := 'classification';
  p_AlgorithmID_8d18ed8a6a41 := '25E83BF9-C5EE-4BDF-A891-D36D871B73E3';
  p_Hyperparameters_8d18ed8a6a41 := '{}';
  p_SourceBindings_8d18ed8a6a41 := '[{"Kind":"Entity","Ref":"Committees: Meetings"}]';
  p_FeatureSteps_8d18ed8a6a41 := '{"Steps":[{"Id":"select-features","Kind":"select","Columns":["MeetingDurationMinutes","DaysUntilMeeting","IsVirtualFlag","IsHybridFlag","IsInPersonFlag","HasVideoLink","AgendaItemCount","TotalAttendees","ExpectedAttendees","LocationType"]},{"Id":"onehot-LocationType","Kind":"onehot","Column":"LocationType"},{"Id":"standardize-numerics","Kind":"standardize","Columns":["MeetingDurationMinutes","DaysUntilMeeting","AgendaItemCount","TotalAttendees","ExpectedAttendees"]}]}';
  p_AsOfStrategy_8d18ed8a6a41 := '{"Mode":"none"}';
  p_LeakageGuard_8d18ed8a6a41 := '{"DenyFields":["PresentAttendees","AbsentAttendees","Status","QuorumRiskOutcome"],"SingleFeatureDominanceThreshold":0.85}';
  p_ValidationStrategy_8d18ed8a6a41 := '{"Strategy":"train_test_split","TestSize":0.2,"LockedHoldoutFraction":0.15}';
  IF NOT EXISTS (SELECT 1 FROM ${mjSchema}."MLTrainingPipeline"
               WHERE "ID" = p_ID_8d18ed8a6a41) THEN
    IF EXISTS (
      SELECT 1 FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
       WHERE n.nspname = '${mjSchema}' AND p.proname = 'spCreateMLTrainingPipeline'
         AND p.pronargs = 1 AND p.proargtypes[0] = 'jsonb'::regtype
    ) THEN
      PERFORM ${mjSchema}."spCreateMLTrainingPipeline"(p_data := jsonb_build_object(
      'ID', p_ID_8d18ed8a6a41,
      'Name', p_Name_8d18ed8a6a41,
      'Description', p_Description_8d18ed8a6a41,
      'Version', p_Version_8d18ed8a6a41,
      'Status', p_Status_8d18ed8a6a41,
      'TargetEntityID', p_TargetEntityID_8d18ed8a6a41,
      'TargetVariable', p_TargetVariable_8d18ed8a6a41,
      'ProblemType', p_ProblemType_8d18ed8a6a41,
      'AlgorithmID', p_AlgorithmID_8d18ed8a6a41,
      'Hyperparameters', p_Hyperparameters_8d18ed8a6a41,
      'SourceBindings', p_SourceBindings_8d18ed8a6a41,
      'FeatureSteps', p_FeatureSteps_8d18ed8a6a41,
      'AsOfStrategy', p_AsOfStrategy_8d18ed8a6a41,
      'LeakageGuard', p_LeakageGuard_8d18ed8a6a41,
      'ValidationStrategy', p_ValidationStrategy_8d18ed8a6a41
    ));
    ELSE
      PERFORM ${mjSchema}."spCreateMLTrainingPipeline"(p_ID := p_ID_8d18ed8a6a41, p_Name := p_Name_8d18ed8a6a41, p_Description := p_Description_8d18ed8a6a41, p_Version := p_Version_8d18ed8a6a41, p_Status := p_Status_8d18ed8a6a41, p_TargetEntityID := p_TargetEntityID_8d18ed8a6a41, p_TargetVariable := p_TargetVariable_8d18ed8a6a41, p_ProblemType := p_ProblemType_8d18ed8a6a41, p_AlgorithmID := p_AlgorithmID_8d18ed8a6a41, p_Hyperparameters := p_Hyperparameters_8d18ed8a6a41, p_SourceBindings := p_SourceBindings_8d18ed8a6a41, p_FeatureSteps := p_FeatureSteps_8d18ed8a6a41, p_AsOfStrategy := p_AsOfStrategy_8d18ed8a6a41, p_LeakageGuard := p_LeakageGuard_8d18ed8a6a41, p_ValidationStrategy := p_ValidationStrategy_8d18ed8a6a41);
    END IF;
  END IF;
END $mj$;

-- Save MJ: ML Models (core SP call only)
DO $mj$
DECLARE
  p_ID_1558ea58b895 UUID;
  p_PipelineID_1558ea58b895 UUID;
  p_Version_1558ea58b895 INTEGER;
  p_AlgorithmID_1558ea58b895 UUID;
  p_ArtifactFileID_1558ea58b895 UUID;
  p_FittedPreprocessing_1558ea58b895 TEXT;
  p_FeatureSchema_1558ea58b895 TEXT;
  p_TargetVariable_1558ea58b895 VARCHAR(500);
  p_ProblemType_1558ea58b895 VARCHAR(20);
  p_Metrics_1558ea58b895 TEXT;
  p_HoldoutMetrics_1558ea58b895 TEXT;
  p_FeatureImportance_1558ea58b895 TEXT;
  p_Lineage_1558ea58b895 TEXT;
  p_TrainedAt_1558ea58b895 TIMESTAMPTZ;
  p_TrainingDurationSec_1558ea58b895 INTEGER;
  p_TrainingRowCount_1558ea58b895 INTEGER;
  p_Status_1558ea58b895 VARCHAR(20);
BEGIN
  p_ID_1558ea58b895 := 'C1A02E75-4C6E-49B0-96F3-79D1A8E26011';
  p_PipelineID_1558ea58b895 := 'C1A02E75-4C6E-49B0-96F3-79D1A8E26001';
  p_Version_1558ea58b895 := 1;
  p_AlgorithmID_1558ea58b895 := '25E83BF9-C5EE-4BDF-A891-D36D871B73E3';
  p_FittedPreprocessing_1558ea58b895 := '{"ops":[{"op":"onehot","col":"LocationType","vocabulary":["Hybrid","InPerson","Virtual"]},{"op":"standardize","cols":["MeetingDurationMinutes","DaysUntilMeeting","AgendaItemCount","TotalAttendees","ExpectedAttendees"],"stats":{"MeetingDurationMinutes":{"mean":60.0,"std":30.0},"DaysUntilMeeting":{"mean":7.0,"std":5.0},"AgendaItemCount":{"mean":4.0,"std":2.5},"TotalAttendees":{"mean":8.0,"std":3.0},"ExpectedAttendees":{"mean":7.0,"std":2.8}}}],"output_columns":["LocationType=Hybrid","LocationType=InPerson","LocationType=Virtual","MeetingDurationMinutes","DaysUntilMeeting","IsVirtualFlag","IsHybridFlag","IsInPersonFlag","HasVideoLink","AgendaItemCount","TotalAttendees","ExpectedAttendees"]}';
  p_FeatureSchema_1558ea58b895 := '[{"Name":"MeetingDurationMinutes","Kind":"numeric"},{"Name":"DaysUntilMeeting","Kind":"numeric"},{"Name":"IsVirtualFlag","Kind":"numeric"},{"Name":"IsHybridFlag","Kind":"numeric"},{"Name":"IsInPersonFlag","Kind":"numeric"},{"Name":"HasVideoLink","Kind":"numeric"},{"Name":"AgendaItemCount","Kind":"numeric"},{"Name":"TotalAttendees","Kind":"numeric"},{"Name":"ExpectedAttendees","Kind":"numeric"},{"Name":"LocationType","Kind":"categorical"}]';
  p_TargetVariable_1558ea58b895 := 'QuorumRiskOutcome';
  p_ProblemType_1558ea58b895 := 'classification';
  p_FeatureImportance_1558ea58b895 := '{"LocationType=Hybrid":0.02,"LocationType=InPerson":0.08,"LocationType=Virtual":0.01,"MeetingDurationMinutes":0.05,"DaysUntilMeeting":0.12,"IsVirtualFlag":0.01,"IsHybridFlag":0.02,"IsInPersonFlag":0.07,"HasVideoLink":0.03,"AgendaItemCount":0.09,"TotalAttendees":0.25,"ExpectedAttendees":0.25}';
  p_Lineage_1558ea58b895 := '{"pipelineId":"c1a02e75-4c6e-49b0-96f3-79d1a8e26001","pipelineVersion":1,"targetEntityName":"Committees: Meetings","sourceBindings":[{"Kind":"Entity","Ref":"Committees: Meetings"}],"featureSteps":{"Steps":[{"Id":"select-features","Kind":"select","Columns":["MeetingDurationMinutes","DaysUntilMeeting","IsVirtualFlag","IsHybridFlag","IsInPersonFlag","HasVideoLink","AgendaItemCount","TotalAttendees","ExpectedAttendees","LocationType"]},{"Id":"onehot-LocationType","Kind":"onehot","Column":"LocationType"},{"Id":"standardize-numerics","Kind":"standardize","Columns":["MeetingDurationMinutes","DaysUntilMeeting","AgendaItemCount","TotalAttendees","ExpectedAttendees"]}]},"asOfStrategy":{"Mode":"none"},"Tournament":"Meeting Quorum Risk Tournament Wave 1","Algorithm":"XGBoost","TrainedAt":"2026-09-20T21:00:00.000Z","TrainingRows":250,"outcomeConfig":{"ScoreLabel":"Quorum Risk Probability","StatusLabel":"Quorum Risk","Polarity":"adverse","Bands":[{"Key":"high","Label":"High Risk","Min":0.7,"Max":1.0,"MinScore":0.7,"MaxScore":1.0,"BadgeColor":"red","Icon":"fa-circle-exclamation"},{"Key":"medium","Label":"Med Risk","Min":0.4,"Max":0.7,"MinScore":0.4,"MaxScore":0.7,"BadgeColor":"amber","Icon":"fa-triangle-exclamation"},{"Key":"low","Label":"Low Risk","Min":0.0,"Max":0.4,"MinScore":0.0,"MaxScore":0.4,"BadgeColor":"green","Icon":"fa-circle-check"}],"OutcomeStyles":{"QuorumLacked":{"BadgeColor":"red","Icon":"fa-circle-exclamation"},"QuorumMet":{"BadgeColor":"green","Icon":"fa-check"},"True":{"BadgeColor":"red","Icon":"fa-circle-exclamation"},"False":{"BadgeColor":"green","Icon":"fa-check"}}}}';
  p_TrainedAt_1558ea58b895 := '2026-09-20T21:00:00.000Z';
  p_TrainingDurationSec_1558ea58b895 := 0;
  p_TrainingRowCount_1558ea58b895 := 0;
  p_Status_1558ea58b895 := 'Draft';
  IF NOT EXISTS (SELECT 1 FROM ${mjSchema}."MLModel"
               WHERE "ID" = p_ID_1558ea58b895) THEN
    IF EXISTS (
      SELECT 1 FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
       WHERE n.nspname = '${mjSchema}' AND p.proname = 'spCreateMLModel'
         AND p.pronargs = 1 AND p.proargtypes[0] = 'jsonb'::regtype
    ) THEN
      PERFORM ${mjSchema}."spCreateMLModel"(p_data := jsonb_build_object(
      'ID', p_ID_1558ea58b895,
      'PipelineID', p_PipelineID_1558ea58b895,
      'Version', p_Version_1558ea58b895,
      'AlgorithmID', p_AlgorithmID_1558ea58b895,
      'ArtifactFileID', p_ArtifactFileID_1558ea58b895,
      'FittedPreprocessing', p_FittedPreprocessing_1558ea58b895,
      'FeatureSchema', p_FeatureSchema_1558ea58b895,
      'TargetVariable', p_TargetVariable_1558ea58b895,
      'ProblemType', p_ProblemType_1558ea58b895,
      'Metrics', p_Metrics_1558ea58b895,
      'HoldoutMetrics', p_HoldoutMetrics_1558ea58b895,
      'FeatureImportance', p_FeatureImportance_1558ea58b895,
      'Lineage', p_Lineage_1558ea58b895,
      'TrainedAt', p_TrainedAt_1558ea58b895,
      'TrainingDurationSec', p_TrainingDurationSec_1558ea58b895,
      'TrainingRowCount', p_TrainingRowCount_1558ea58b895,
      'Status', p_Status_1558ea58b895
    ));
    ELSE
      PERFORM ${mjSchema}."spCreateMLModel"(p_ID := p_ID_1558ea58b895, p_PipelineID := p_PipelineID_1558ea58b895, p_Version := p_Version_1558ea58b895, p_AlgorithmID := p_AlgorithmID_1558ea58b895, p_ArtifactFileID := p_ArtifactFileID_1558ea58b895, p_ArtifactFileID_Clear := TRUE, p_FittedPreprocessing := p_FittedPreprocessing_1558ea58b895, p_FeatureSchema := p_FeatureSchema_1558ea58b895, p_TargetVariable := p_TargetVariable_1558ea58b895, p_ProblemType := p_ProblemType_1558ea58b895, p_Metrics := p_Metrics_1558ea58b895, p_Metrics_Clear := TRUE, p_HoldoutMetrics := p_HoldoutMetrics_1558ea58b895, p_HoldoutMetrics_Clear := TRUE, p_FeatureImportance := p_FeatureImportance_1558ea58b895, p_Lineage := p_Lineage_1558ea58b895, p_TrainedAt := p_TrainedAt_1558ea58b895, p_TrainingDurationSec := p_TrainingDurationSec_1558ea58b895, p_TrainingRowCount := p_TrainingRowCount_1558ea58b895, p_Status := p_Status_1558ea58b895);
    END IF;
  END IF;
END $mj$;

-- Save MJ: ML Models (core SP call only)
DO $mj$
DECLARE
  p_ID_23bf56855eeb UUID;
  p_PipelineID_23bf56855eeb UUID;
  p_Version_23bf56855eeb INTEGER;
  p_AlgorithmID_23bf56855eeb UUID;
  p_ArtifactFileID_23bf56855eeb UUID;
  p_FittedPreprocessing_23bf56855eeb TEXT;
  p_FeatureSchema_23bf56855eeb TEXT;
  p_TargetVariable_23bf56855eeb VARCHAR(500);
  p_ProblemType_23bf56855eeb VARCHAR(20);
  p_Metrics_23bf56855eeb TEXT;
  p_HoldoutMetrics_23bf56855eeb TEXT;
  p_FeatureImportance_23bf56855eeb TEXT;
  p_Lineage_23bf56855eeb TEXT;
  p_TrainedAt_23bf56855eeb TIMESTAMPTZ;
  p_TrainingDurationSec_23bf56855eeb INTEGER;
  p_TrainingRowCount_23bf56855eeb INTEGER;
  p_Status_23bf56855eeb VARCHAR(20);
BEGIN
  p_ID_23bf56855eeb := 'C1A02E75-4C6E-49B0-96F3-79D1A8E26012';
  p_PipelineID_23bf56855eeb := 'C1A02E75-4C6E-49B0-96F3-79D1A8E26001';
  p_Version_23bf56855eeb := 2;
  p_AlgorithmID_23bf56855eeb := 'B2FD5E4A-75D4-401A-A1DA-F223A5234FDA';
  p_FittedPreprocessing_23bf56855eeb := '{"ops":[{"op":"onehot","col":"LocationType","vocabulary":["Hybrid","InPerson","Virtual"]},{"op":"standardize","cols":["MeetingDurationMinutes","DaysUntilMeeting","AgendaItemCount","TotalAttendees","ExpectedAttendees"],"stats":{"MeetingDurationMinutes":{"mean":60.0,"std":30.0},"DaysUntilMeeting":{"mean":7.0,"std":5.0},"AgendaItemCount":{"mean":4.0,"std":2.5},"TotalAttendees":{"mean":8.0,"std":3.0},"ExpectedAttendees":{"mean":7.0,"std":2.8}}}],"output_columns":["LocationType=Hybrid","LocationType=InPerson","LocationType=Virtual","MeetingDurationMinutes","DaysUntilMeeting","IsVirtualFlag","IsHybridFlag","IsInPersonFlag","HasVideoLink","AgendaItemCount","TotalAttendees","ExpectedAttendees"]}';
  p_FeatureSchema_23bf56855eeb := '[{"Name":"MeetingDurationMinutes","Kind":"numeric"},{"Name":"DaysUntilMeeting","Kind":"numeric"},{"Name":"IsVirtualFlag","Kind":"numeric"},{"Name":"IsHybridFlag","Kind":"numeric"},{"Name":"IsInPersonFlag","Kind":"numeric"},{"Name":"HasVideoLink","Kind":"numeric"},{"Name":"AgendaItemCount","Kind":"numeric"},{"Name":"TotalAttendees","Kind":"numeric"},{"Name":"ExpectedAttendees","Kind":"numeric"},{"Name":"LocationType","Kind":"categorical"}]';
  p_TargetVariable_23bf56855eeb := 'QuorumRiskOutcome';
  p_ProblemType_23bf56855eeb := 'classification';
  p_FeatureImportance_23bf56855eeb := '{"LocationType=Hybrid":12,"LocationType=InPerson":35,"LocationType=Virtual":8,"MeetingDurationMinutes":45,"DaysUntilMeeting":80,"IsVirtualFlag":5,"IsHybridFlag":10,"IsInPersonFlag":30,"HasVideoLink":15,"AgendaItemCount":60,"TotalAttendees":150,"ExpectedAttendees":145}';
  p_Lineage_23bf56855eeb := '{"pipelineId":"c1a02e75-4c6e-49b0-96f3-79d1a8e26001","pipelineVersion":1,"targetEntityName":"Committees: Meetings","sourceBindings":[{"Kind":"Entity","Ref":"Committees: Meetings"}],"featureSteps":{"Steps":[{"Id":"select-features","Kind":"select","Columns":["MeetingDurationMinutes","DaysUntilMeeting","IsVirtualFlag","IsHybridFlag","IsInPersonFlag","HasVideoLink","AgendaItemCount","TotalAttendees","ExpectedAttendees","LocationType"]},{"Id":"onehot-LocationType","Kind":"onehot","Column":"LocationType"},{"Id":"standardize-numerics","Kind":"standardize","Columns":["MeetingDurationMinutes","DaysUntilMeeting","AgendaItemCount","TotalAttendees","ExpectedAttendees"]}]},"asOfStrategy":{"Mode":"none"},"Tournament":"Meeting Quorum Risk Tournament Wave 1","Algorithm":"LightGBM","TrainedAt":"2026-09-20T21:00:00.000Z","TrainingRows":250,"outcomeConfig":{"ScoreLabel":"Quorum Risk Probability","StatusLabel":"Quorum Risk","Polarity":"adverse","Bands":[{"Key":"high","Label":"High Risk","Min":0.7,"Max":1.0,"MinScore":0.7,"MaxScore":1.0,"BadgeColor":"red","Icon":"fa-circle-exclamation"},{"Key":"medium","Label":"Med Risk","Min":0.4,"Max":0.7,"MinScore":0.4,"MaxScore":0.7,"BadgeColor":"amber","Icon":"fa-triangle-exclamation"},{"Key":"low","Label":"Low Risk","Min":0.0,"Max":0.4,"MinScore":0.0,"MaxScore":0.4,"BadgeColor":"green","Icon":"fa-circle-check"}],"OutcomeStyles":{"QuorumLacked":{"BadgeColor":"red","Icon":"fa-circle-exclamation"},"QuorumMet":{"BadgeColor":"green","Icon":"fa-check"},"True":{"BadgeColor":"red","Icon":"fa-circle-exclamation"},"False":{"BadgeColor":"green","Icon":"fa-check"}}}}';
  p_TrainedAt_23bf56855eeb := '2026-09-20T21:00:00.000Z';
  p_TrainingDurationSec_23bf56855eeb := 0;
  p_TrainingRowCount_23bf56855eeb := 0;
  p_Status_23bf56855eeb := 'Draft';
  IF NOT EXISTS (SELECT 1 FROM ${mjSchema}."MLModel"
               WHERE "ID" = p_ID_23bf56855eeb) THEN
    IF EXISTS (
      SELECT 1 FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
       WHERE n.nspname = '${mjSchema}' AND p.proname = 'spCreateMLModel'
         AND p.pronargs = 1 AND p.proargtypes[0] = 'jsonb'::regtype
    ) THEN
      PERFORM ${mjSchema}."spCreateMLModel"(p_data := jsonb_build_object(
      'ID', p_ID_23bf56855eeb,
      'PipelineID', p_PipelineID_23bf56855eeb,
      'Version', p_Version_23bf56855eeb,
      'AlgorithmID', p_AlgorithmID_23bf56855eeb,
      'ArtifactFileID', p_ArtifactFileID_23bf56855eeb,
      'FittedPreprocessing', p_FittedPreprocessing_23bf56855eeb,
      'FeatureSchema', p_FeatureSchema_23bf56855eeb,
      'TargetVariable', p_TargetVariable_23bf56855eeb,
      'ProblemType', p_ProblemType_23bf56855eeb,
      'Metrics', p_Metrics_23bf56855eeb,
      'HoldoutMetrics', p_HoldoutMetrics_23bf56855eeb,
      'FeatureImportance', p_FeatureImportance_23bf56855eeb,
      'Lineage', p_Lineage_23bf56855eeb,
      'TrainedAt', p_TrainedAt_23bf56855eeb,
      'TrainingDurationSec', p_TrainingDurationSec_23bf56855eeb,
      'TrainingRowCount', p_TrainingRowCount_23bf56855eeb,
      'Status', p_Status_23bf56855eeb
    ));
    ELSE
      PERFORM ${mjSchema}."spCreateMLModel"(p_ID := p_ID_23bf56855eeb, p_PipelineID := p_PipelineID_23bf56855eeb, p_Version := p_Version_23bf56855eeb, p_AlgorithmID := p_AlgorithmID_23bf56855eeb, p_ArtifactFileID := p_ArtifactFileID_23bf56855eeb, p_ArtifactFileID_Clear := TRUE, p_FittedPreprocessing := p_FittedPreprocessing_23bf56855eeb, p_FeatureSchema := p_FeatureSchema_23bf56855eeb, p_TargetVariable := p_TargetVariable_23bf56855eeb, p_ProblemType := p_ProblemType_23bf56855eeb, p_Metrics := p_Metrics_23bf56855eeb, p_Metrics_Clear := TRUE, p_HoldoutMetrics := p_HoldoutMetrics_23bf56855eeb, p_HoldoutMetrics_Clear := TRUE, p_FeatureImportance := p_FeatureImportance_23bf56855eeb, p_Lineage := p_Lineage_23bf56855eeb, p_TrainedAt := p_TrainedAt_23bf56855eeb, p_TrainingDurationSec := p_TrainingDurationSec_23bf56855eeb, p_TrainingRowCount := p_TrainingRowCount_23bf56855eeb, p_Status := p_Status_23bf56855eeb);
    END IF;
  END IF;
END $mj$;

-- Save MJ: ML Models (core SP call only)
DO $mj$
DECLARE
  p_ID_3f1bf39e44cb UUID;
  p_PipelineID_3f1bf39e44cb UUID;
  p_Version_3f1bf39e44cb INTEGER;
  p_AlgorithmID_3f1bf39e44cb UUID;
  p_ArtifactFileID_3f1bf39e44cb UUID;
  p_FittedPreprocessing_3f1bf39e44cb TEXT;
  p_FeatureSchema_3f1bf39e44cb TEXT;
  p_TargetVariable_3f1bf39e44cb VARCHAR(500);
  p_ProblemType_3f1bf39e44cb VARCHAR(20);
  p_Metrics_3f1bf39e44cb TEXT;
  p_HoldoutMetrics_3f1bf39e44cb TEXT;
  p_FeatureImportance_3f1bf39e44cb TEXT;
  p_Lineage_3f1bf39e44cb TEXT;
  p_TrainedAt_3f1bf39e44cb TIMESTAMPTZ;
  p_TrainingDurationSec_3f1bf39e44cb INTEGER;
  p_TrainingRowCount_3f1bf39e44cb INTEGER;
  p_Status_3f1bf39e44cb VARCHAR(20);
BEGIN
  p_ID_3f1bf39e44cb := 'C1A02E75-4C6E-49B0-96F3-79D1A8E26013';
  p_PipelineID_3f1bf39e44cb := 'C1A02E75-4C6E-49B0-96F3-79D1A8E26001';
  p_Version_3f1bf39e44cb := 3;
  p_AlgorithmID_3f1bf39e44cb := 'F966965D-3A87-4DD6-91E0-4F9D1AF17796';
  p_FittedPreprocessing_3f1bf39e44cb := '{"ops":[{"op":"onehot","col":"LocationType","vocabulary":["Hybrid","InPerson","Virtual"]},{"op":"standardize","cols":["MeetingDurationMinutes","DaysUntilMeeting","AgendaItemCount","TotalAttendees","ExpectedAttendees"],"stats":{"MeetingDurationMinutes":{"mean":60.0,"std":30.0},"DaysUntilMeeting":{"mean":7.0,"std":5.0},"AgendaItemCount":{"mean":4.0,"std":2.5},"TotalAttendees":{"mean":8.0,"std":3.0},"ExpectedAttendees":{"mean":7.0,"std":2.8}}}],"output_columns":["LocationType=Hybrid","LocationType=InPerson","LocationType=Virtual","MeetingDurationMinutes","DaysUntilMeeting","IsVirtualFlag","IsHybridFlag","IsInPersonFlag","HasVideoLink","AgendaItemCount","TotalAttendees","ExpectedAttendees"]}';
  p_FeatureSchema_3f1bf39e44cb := '[{"Name":"MeetingDurationMinutes","Kind":"numeric"},{"Name":"DaysUntilMeeting","Kind":"numeric"},{"Name":"IsVirtualFlag","Kind":"numeric"},{"Name":"IsHybridFlag","Kind":"numeric"},{"Name":"IsInPersonFlag","Kind":"numeric"},{"Name":"HasVideoLink","Kind":"numeric"},{"Name":"AgendaItemCount","Kind":"numeric"},{"Name":"TotalAttendees","Kind":"numeric"},{"Name":"ExpectedAttendees","Kind":"numeric"},{"Name":"LocationType","Kind":"categorical"}]';
  p_TargetVariable_3f1bf39e44cb := 'QuorumRiskOutcome';
  p_ProblemType_3f1bf39e44cb := 'classification';
  p_FeatureImportance_3f1bf39e44cb := '{"LocationType=Hybrid":0.03,"LocationType=InPerson":0.07,"LocationType=Virtual":0.02,"MeetingDurationMinutes":0.06,"DaysUntilMeeting":0.14,"IsVirtualFlag":0.01,"IsHybridFlag":0.02,"IsInPersonFlag":0.08,"HasVideoLink":0.04,"AgendaItemCount":0.08,"TotalAttendees":0.23,"ExpectedAttendees":0.22}';
  p_Lineage_3f1bf39e44cb := '{"pipelineId":"c1a02e75-4c6e-49b0-96f3-79d1a8e26001","pipelineVersion":1,"targetEntityName":"Committees: Meetings","sourceBindings":[{"Kind":"Entity","Ref":"Committees: Meetings"}],"featureSteps":{"Steps":[{"Id":"select-features","Kind":"select","Columns":["MeetingDurationMinutes","DaysUntilMeeting","IsVirtualFlag","IsHybridFlag","IsInPersonFlag","HasVideoLink","AgendaItemCount","TotalAttendees","ExpectedAttendees","LocationType"]},{"Id":"onehot-LocationType","Kind":"onehot","Column":"LocationType"},{"Id":"standardize-numerics","Kind":"standardize","Columns":["MeetingDurationMinutes","DaysUntilMeeting","AgendaItemCount","TotalAttendees","ExpectedAttendees"]}]},"asOfStrategy":{"Mode":"none"},"Tournament":"Meeting Quorum Risk Tournament Wave 1","Algorithm":"Random Forest","TrainedAt":"2026-09-20T21:00:00.000Z","TrainingRows":250,"outcomeConfig":{"ScoreLabel":"Quorum Risk Probability","StatusLabel":"Quorum Risk","Polarity":"adverse","Bands":[{"Key":"high","Label":"High Risk","Min":0.7,"Max":1.0,"MinScore":0.7,"MaxScore":1.0,"BadgeColor":"red","Icon":"fa-circle-exclamation"},{"Key":"medium","Label":"Med Risk","Min":0.4,"Max":0.7,"MinScore":0.4,"MaxScore":0.7,"BadgeColor":"amber","Icon":"fa-triangle-exclamation"},{"Key":"low","Label":"Low Risk","Min":0.0,"Max":0.4,"MinScore":0.0,"MaxScore":0.4,"BadgeColor":"green","Icon":"fa-circle-check"}],"OutcomeStyles":{"QuorumLacked":{"BadgeColor":"red","Icon":"fa-circle-exclamation"},"QuorumMet":{"BadgeColor":"green","Icon":"fa-check"},"True":{"BadgeColor":"red","Icon":"fa-circle-exclamation"},"False":{"BadgeColor":"green","Icon":"fa-check"}}}}';
  p_TrainedAt_3f1bf39e44cb := '2026-09-20T21:00:00.000Z';
  p_TrainingDurationSec_3f1bf39e44cb := 0;
  p_TrainingRowCount_3f1bf39e44cb := 0;
  p_Status_3f1bf39e44cb := 'Draft';
  IF NOT EXISTS (SELECT 1 FROM ${mjSchema}."MLModel"
               WHERE "ID" = p_ID_3f1bf39e44cb) THEN
    IF EXISTS (
      SELECT 1 FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
       WHERE n.nspname = '${mjSchema}' AND p.proname = 'spCreateMLModel'
         AND p.pronargs = 1 AND p.proargtypes[0] = 'jsonb'::regtype
    ) THEN
      PERFORM ${mjSchema}."spCreateMLModel"(p_data := jsonb_build_object(
      'ID', p_ID_3f1bf39e44cb,
      'PipelineID', p_PipelineID_3f1bf39e44cb,
      'Version', p_Version_3f1bf39e44cb,
      'AlgorithmID', p_AlgorithmID_3f1bf39e44cb,
      'ArtifactFileID', p_ArtifactFileID_3f1bf39e44cb,
      'FittedPreprocessing', p_FittedPreprocessing_3f1bf39e44cb,
      'FeatureSchema', p_FeatureSchema_3f1bf39e44cb,
      'TargetVariable', p_TargetVariable_3f1bf39e44cb,
      'ProblemType', p_ProblemType_3f1bf39e44cb,
      'Metrics', p_Metrics_3f1bf39e44cb,
      'HoldoutMetrics', p_HoldoutMetrics_3f1bf39e44cb,
      'FeatureImportance', p_FeatureImportance_3f1bf39e44cb,
      'Lineage', p_Lineage_3f1bf39e44cb,
      'TrainedAt', p_TrainedAt_3f1bf39e44cb,
      'TrainingDurationSec', p_TrainingDurationSec_3f1bf39e44cb,
      'TrainingRowCount', p_TrainingRowCount_3f1bf39e44cb,
      'Status', p_Status_3f1bf39e44cb
    ));
    ELSE
      PERFORM ${mjSchema}."spCreateMLModel"(p_ID := p_ID_3f1bf39e44cb, p_PipelineID := p_PipelineID_3f1bf39e44cb, p_Version := p_Version_3f1bf39e44cb, p_AlgorithmID := p_AlgorithmID_3f1bf39e44cb, p_ArtifactFileID := p_ArtifactFileID_3f1bf39e44cb, p_ArtifactFileID_Clear := TRUE, p_FittedPreprocessing := p_FittedPreprocessing_3f1bf39e44cb, p_FeatureSchema := p_FeatureSchema_3f1bf39e44cb, p_TargetVariable := p_TargetVariable_3f1bf39e44cb, p_ProblemType := p_ProblemType_3f1bf39e44cb, p_Metrics := p_Metrics_3f1bf39e44cb, p_Metrics_Clear := TRUE, p_HoldoutMetrics := p_HoldoutMetrics_3f1bf39e44cb, p_HoldoutMetrics_Clear := TRUE, p_FeatureImportance := p_FeatureImportance_3f1bf39e44cb, p_Lineage := p_Lineage_3f1bf39e44cb, p_TrainedAt := p_TrainedAt_3f1bf39e44cb, p_TrainingDurationSec := p_TrainingDurationSec_3f1bf39e44cb, p_TrainingRowCount := p_TrainingRowCount_3f1bf39e44cb, p_Status := p_Status_3f1bf39e44cb);
    END IF;
  END IF;
END $mj$;

-- Save MJ: ML Model Scoring Bindings (core SP call only)
DO $mj$
DECLARE
  p_ID_63835ac6c8fa UUID;
  p_MLModelID_63835ac6c8fa UUID;
  p_RecordProcessID_63835ac6c8fa UUID;
  p_TargetEntityID_63835ac6c8fa UUID;
  p_TargetColumn_63835ac6c8fa VARCHAR(255);
  p_Mode_63835ac6c8fa VARCHAR(20);
  p_MaterializedResultID_63835ac6c8fa UUID;
  p_LastScoredAt_63835ac6c8fa TIMESTAMPTZ;
  p_LastRowCount_63835ac6c8fa INTEGER;
BEGIN
  p_ID_63835ac6c8fa := 'C1A02E75-4C6E-49B0-96F3-79D1A8E26060';
  p_MLModelID_63835ac6c8fa := 'C1A02E75-4C6E-49B0-96F3-79D1A8E26011';
  p_RecordProcessID_63835ac6c8fa := 'C1A02E75-4C6E-49B0-96F3-79D1A8E26050';
  p_TargetEntityID_63835ac6c8fa := 'F7DEBA2D-4E28-4C6E-971B-6099217FAB29';
  p_TargetColumn_63835ac6c8fa := 'PredictedQuorumRiskProbability';
  p_Mode_63835ac6c8fa := 'Scheduled';
  IF NOT EXISTS (SELECT 1 FROM ${mjSchema}."MLModelScoringBinding"
               WHERE "ID" = p_ID_63835ac6c8fa) THEN
    IF EXISTS (
      SELECT 1 FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
       WHERE n.nspname = '${mjSchema}' AND p.proname = 'spCreateMLModelScoringBinding'
         AND p.pronargs = 1 AND p.proargtypes[0] = 'jsonb'::regtype
    ) THEN
      PERFORM ${mjSchema}."spCreateMLModelScoringBinding"(p_data := jsonb_build_object(
      'ID', p_ID_63835ac6c8fa,
      'MLModelID', p_MLModelID_63835ac6c8fa,
      'RecordProcessID', p_RecordProcessID_63835ac6c8fa,
      'TargetEntityID', p_TargetEntityID_63835ac6c8fa,
      'TargetColumn', p_TargetColumn_63835ac6c8fa,
      'Mode', p_Mode_63835ac6c8fa,
      'MaterializedResultID', p_MaterializedResultID_63835ac6c8fa,
      'LastScoredAt', p_LastScoredAt_63835ac6c8fa,
      'LastRowCount', p_LastRowCount_63835ac6c8fa
    ));
    ELSE
      PERFORM ${mjSchema}."spCreateMLModelScoringBinding"(p_ID := p_ID_63835ac6c8fa, p_MLModelID := p_MLModelID_63835ac6c8fa, p_RecordProcessID := p_RecordProcessID_63835ac6c8fa, p_TargetEntityID := p_TargetEntityID_63835ac6c8fa, p_TargetColumn := p_TargetColumn_63835ac6c8fa, p_Mode := p_Mode_63835ac6c8fa, p_MaterializedResultID := p_MaterializedResultID_63835ac6c8fa, p_MaterializedResultID_Clear := TRUE, p_LastScoredAt := p_LastScoredAt_63835ac6c8fa, p_LastScoredAt_Clear := TRUE, p_LastRowCount := p_LastRowCount_63835ac6c8fa, p_LastRowCount_Clear := TRUE);
    END IF;
  END IF;
END $mj$;
