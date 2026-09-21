-- =============================================================================
-- BizAppsCommittees: Add Predictive Meeting Quorum Risk Fields & Layered Views
-- Materialized prediction write-back columns and engineered operational features
-- computed via layered vwMeetings wrapper for Predictive Studio quorum risk.
-- =============================================================================

---------------------------------------------------------------------------
-- 1. Meeting: Add materialized prediction fields
---------------------------------------------------------------------------
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('[${flyway:defaultSchema}].[Meeting]') 
      AND name = 'PredictedQuorumRiskProbability'
)
BEGIN
    ALTER TABLE [${flyway:defaultSchema}].[Meeting] ADD
        [PredictedQuorumRiskProbability] DECIMAL(5, 4) NULL,
        [PredictedQuorumRiskBand] NVARCHAR(20) NULL,
        [PredictedQuorumRiskScoredAt] DATETIMEOFFSET NULL;
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints 
    WHERE object_id = OBJECT_ID('[${flyway:defaultSchema}].[CK_Meeting_PredictedQuorumRiskBand]')
)
BEGIN
    ALTER TABLE [${flyway:defaultSchema}].[Meeting] ADD CONSTRAINT [CK_Meeting_PredictedQuorumRiskBand]
        CHECK ([PredictedQuorumRiskBand] IS NULL OR [PredictedQuorumRiskBand] IN ('Low', 'Medium', 'High', 'Critical'));
END
GO

IF EXISTS (
    SELECT 1 FROM fn_listextendedproperty(N'MS_Description', 'SCHEMA', N'${flyway:defaultSchema}', 'TABLE', N'Meeting', 'COLUMN', N'PredictedQuorumRiskProbability')
)
    EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'Predicted probability (0.0000 to 1.0000) that this committee meeting will fail to achieve a quorum of voting members.', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'PredictedQuorumRiskProbability';
ELSE
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Predicted probability (0.0000 to 1.0000) that this committee meeting will fail to achieve a quorum of voting members.', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'PredictedQuorumRiskProbability';
GO

IF EXISTS (
    SELECT 1 FROM fn_listextendedproperty(N'MS_Description', 'SCHEMA', N'${flyway:defaultSchema}', 'TABLE', N'Meeting', 'COLUMN', N'PredictedQuorumRiskBand')
)
    EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'Operational quorum risk band classifying quorum risk: Low (<40%), Medium (40-70%), High (>70%), or Critical.', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'PredictedQuorumRiskBand';
ELSE
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Operational quorum risk band classifying quorum risk: Low (<40%), Medium (40-70%), High (>70%), or Critical.', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'PredictedQuorumRiskBand';
GO

IF EXISTS (
    SELECT 1 FROM fn_listextendedproperty(N'MS_Description', 'SCHEMA', N'${flyway:defaultSchema}', 'TABLE', N'Meeting', 'COLUMN', N'PredictedQuorumRiskScoredAt')
)
    EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'Timestamp when this meeting was last scored by the predictive quorum risk model.', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'PredictedQuorumRiskScoredAt';
ELSE
    EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Timestamp when this meeting was last scored by the predictive quorum risk model.', @level0type = N'SCHEMA', @level0name = N'${flyway:defaultSchema}', @level1type = N'TABLE', @level1name = N'Meeting', @level2type = N'COLUMN', @level2name = N'PredictedQuorumRiskScoredAt';
GO

---------------------------------------------------------------------------
-- 2. Layered Views: vwMeetingsGenerated & vwMeetings
---------------------------------------------------------------------------
UPDATE [${mjSchema}].[Entity]
   SET [BaseViewGenerated] = 0,
       [GeneratedBaseViewName] = 'vwMeetingsGenerated'
 WHERE [Name] = 'Committees: Meetings'
   AND ([BaseViewGenerated] <> 0
        OR [GeneratedBaseViewName] IS NULL
        OR [GeneratedBaseViewName] <> 'vwMeetingsGenerated');
GO

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
INNER JOIN
    [${flyway:defaultSchema}].[Committee] AS mjBizAppsCommitteesCommittee_CommitteeID
  ON
    [m].[CommitteeID] = mjBizAppsCommitteesCommittee_CommitteeID.[ID]
LEFT OUTER JOIN
    [${flyway:defaultSchema}].[VideoProvider] AS mjBizAppsCommitteesVideoProvider_VideoProviderID
  ON
    [m].[VideoProviderID] = mjBizAppsCommitteesVideoProvider_VideoProviderID.[ID];
GO

IF OBJECT_ID('[${flyway:defaultSchema}].[vwMeetings]', 'V') IS NOT NULL
    DROP VIEW [${flyway:defaultSchema}].[vwMeetings];
GO

CREATE VIEW [${flyway:defaultSchema}].[vwMeetings]
AS
SELECT
    g.*,
    CASE 
        WHEN g.[EndDateTime] IS NOT NULL 
        THEN DATEDIFF(minute, g.[StartDateTime], g.[EndDateTime]) 
        ELSE NULL 
    END AS [MeetingDurationMinutes],
    DATEDIFF(day, CAST(GETUTCDATE() AS date), CAST(g.[StartDateTime] AS date)) AS [DaysUntilMeeting],
    CASE WHEN g.[LocationType] = 'Virtual' THEN 1 ELSE 0 END AS [IsVirtualFlag],
    CASE WHEN g.[LocationType] = 'Hybrid' THEN 1 ELSE 0 END AS [IsHybridFlag],
    CASE WHEN g.[LocationType] = 'InPerson' THEN 1 ELSE 0 END AS [IsInPersonFlag],
    CASE WHEN g.[VideoProviderID] IS NOT NULL OR g.[VideoJoinURL] IS NOT NULL THEN 1 ELSE 0 END AS [HasVideoLink],
    ISNULL(ag.[AgendaItemCount], 0) AS [AgendaItemCount],
    ISNULL(att.[TotalAttendees], 0) AS [TotalAttendees],
    ISNULL(att.[ExpectedAttendees], 0) AS [ExpectedAttendees],
    ISNULL(att.[PresentAttendees], 0) AS [PresentAttendees],
    ISNULL(att.[AbsentAttendees], 0) AS [AbsentAttendees],
    CASE
        WHEN g.[Status] = 'Cancelled' THEN 1
        WHEN g.[Status] = 'Completed' AND ISNULL(att.[PresentAttendees], 0) < 3 THEN 1
        WHEN g.[Status] = 'Completed' AND ISNULL(att.[PresentAttendees], 0) >= 3 THEN 0
        ELSE NULL
    END AS [QuorumRiskOutcome]
FROM
    [${flyway:defaultSchema}].[vwMeetingsGenerated] AS g
LEFT OUTER JOIN (
    SELECT [MeetingID], COUNT(*) AS [AgendaItemCount]
    FROM [${flyway:defaultSchema}].[AgendaItem]
    GROUP BY [MeetingID]
) AS ag ON ag.[MeetingID] = g.[ID]
LEFT OUTER JOIN (
    SELECT [MeetingID],
           COUNT(*) AS [TotalAttendees],
           SUM(CASE WHEN [AttendanceStatus] = 'Expected' THEN 1 ELSE 0 END) AS [ExpectedAttendees],
           SUM(CASE WHEN [AttendanceStatus] = 'Present' THEN 1 ELSE 0 END) AS [PresentAttendees],
           SUM(CASE WHEN [AttendanceStatus] = 'Absent' THEN 1 ELSE 0 END) AS [AbsentAttendees]
    FROM [${flyway:defaultSchema}].[Attendance]
    GROUP BY [MeetingID]
) AS att ON att.[MeetingID] = g.[ID];
GO

IF DATABASE_PRINCIPAL_ID('cdp_UI') IS NOT NULL
    EXEC('GRANT SELECT ON [${flyway:defaultSchema}].[vwMeetingsGenerated] TO [cdp_UI]');
IF DATABASE_PRINCIPAL_ID('cdp_Developer') IS NOT NULL
    EXEC('GRANT SELECT ON [${flyway:defaultSchema}].[vwMeetingsGenerated] TO [cdp_Developer]');
IF DATABASE_PRINCIPAL_ID('cdp_Integration') IS NOT NULL
    EXEC('GRANT SELECT ON [${flyway:defaultSchema}].[vwMeetingsGenerated] TO [cdp_Integration]');
GO

IF DATABASE_PRINCIPAL_ID('cdp_UI') IS NOT NULL
    EXEC('GRANT SELECT ON [${flyway:defaultSchema}].[vwMeetings] TO [cdp_UI]');
IF DATABASE_PRINCIPAL_ID('cdp_Developer') IS NOT NULL
    EXEC('GRANT SELECT ON [${flyway:defaultSchema}].[vwMeetings] TO [cdp_Developer]');
IF DATABASE_PRINCIPAL_ID('cdp_Integration') IS NOT NULL
    EXEC('GRANT SELECT ON [${flyway:defaultSchema}].[vwMeetings] TO [cdp_Integration]');
GO


















































-- =============================================================================
-- GENERATED BY MemberJunction CodeGen — DO NOT EDIT BY HAND
-- =============================================================================

/* SQL text to update existing entities from schema */
EXEC [${mjSchema}].[spUpdateExistingEntitiesFromSchema] @ExcludedSchemaNames='sys,staging,dbo,${mjSchema}', @IncludedSchemaNames='${flyway:defaultSchema}';

/* SQL text to insert new entity fields dynamically */
DECLARE @meetingEntityID UNIQUEIDENTIFIER = (SELECT [ID] FROM [${mjSchema}].[Entity] WHERE [Name] = 'Committees: Meetings');
IF @meetingEntityID IS NULL RAISERROR('Entity not registered: Committees: Meetings', 16, 1);

IF @meetingEntityID IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = @meetingEntityID AND [Name] = 'PredictedQuorumRiskProbability')
    BEGIN
        INSERT INTO [${mjSchema}].[EntityField] (
            [ID], [EntityID], [Sequence], [Name], [DisplayName], [Description], [Type], [Length], [Precision], [Scale],
            [AllowsNull], [DefaultValue], [AutoIncrement], [AllowUpdateAPI], [IsVirtual], [IsComputed],
            [IsNameField], [IncludeInUserSearchAPI], [IncludeRelatedEntityNameFieldInBaseView], [DefaultInView],
            [IsPrimaryKey], [IsUnique], [RelatedEntityDisplayType], [__mj_CreatedAt], [__mj_UpdatedAt]
        ) VALUES (
            'c1a02e75-4c6e-49b0-96f3-79d1a8e26071', @meetingEntityID,
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = @meetingEntityID),
            'PredictedQuorumRiskProbability', 'Predicted Quorum Risk Probability',
            'Predicted probability (0.0000 to 1.0000) that this committee meeting will fail to achieve a quorum of voting members.',
            'decimal', 5, 5, 4, 1, NULL, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Search', GETUTCDATE(), GETUTCDATE()
        );
    END

    IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = @meetingEntityID AND [Name] = 'PredictedQuorumRiskBand')
    BEGIN
        INSERT INTO [${mjSchema}].[EntityField] (
            [ID], [EntityID], [Sequence], [Name], [DisplayName], [Description], [Type], [Length], [Precision], [Scale],
            [AllowsNull], [DefaultValue], [AutoIncrement], [AllowUpdateAPI], [IsVirtual], [IsComputed],
            [IsNameField], [IncludeInUserSearchAPI], [IncludeRelatedEntityNameFieldInBaseView], [DefaultInView],
            [IsPrimaryKey], [IsUnique], [RelatedEntityDisplayType], [__mj_CreatedAt], [__mj_UpdatedAt]
        ) VALUES (
            'c1a02e75-4c6e-49b0-96f3-79d1a8e26072', @meetingEntityID,
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = @meetingEntityID),
            'PredictedQuorumRiskBand', 'Predicted Quorum Risk Band',
            'Operational quorum risk band classifying quorum risk: Low (<40%), Medium (40-70%), High (>70%), or Critical.',
            'nvarchar', 40, 0, 0, 1, NULL, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Search', GETUTCDATE(), GETUTCDATE()
        );
    END

    IF NOT EXISTS (SELECT 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = @meetingEntityID AND [Name] = 'PredictedQuorumRiskScoredAt')
    BEGIN
        INSERT INTO [${mjSchema}].[EntityField] (
            [ID], [EntityID], [Sequence], [Name], [DisplayName], [Description], [Type], [Length], [Precision], [Scale],
            [AllowsNull], [DefaultValue], [AutoIncrement], [AllowUpdateAPI], [IsVirtual], [IsComputed],
            [IsNameField], [IncludeInUserSearchAPI], [IncludeRelatedEntityNameFieldInBaseView], [DefaultInView],
            [IsPrimaryKey], [IsUnique], [RelatedEntityDisplayType], [__mj_CreatedAt], [__mj_UpdatedAt]
        ) VALUES (
            'c1a02e75-4c6e-49b0-96f3-79d1a8e26073', @meetingEntityID,
            (SELECT COALESCE(MAX([Sequence]), 0) + 1 FROM [${mjSchema}].[EntityField] WHERE [EntityID] = @meetingEntityID),
            'PredictedQuorumRiskScoredAt', 'Predicted Quorum Risk Scored At',
            'Timestamp when this meeting was last scored by the predictive quorum risk model.',
            'datetimeoffset', 10, 34, 7, 1, NULL, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Search', GETUTCDATE(), GETUTCDATE()
        );
    END

    -- Virtual engineered features
    DECLARE @fields TABLE (
        Name NVARCHAR(100),
        DisplayName NVARCHAR(100),
        Type NVARCHAR(50),
        Length INT,
        Precision INT,
        Scale INT,
        Description NVARCHAR(500)
    );

    INSERT INTO @fields (Name, DisplayName, Type, Length, Precision, Scale, Description) VALUES
    ('QuorumRiskOutcome', 'Quorum Risk Outcome', 'int', 4, 10, 0, 'Binary outcome: 1 if meeting lacked quorum or was cancelled, 0 if quorum was achieved, NULL if upcoming/in-flight.'),
    ('MeetingDurationMinutes', 'Meeting Duration Minutes', 'int', 4, 10, 0, 'Duration of scheduled meeting in minutes.'),
    ('DaysUntilMeeting', 'Days Until Meeting', 'int', 4, 10, 0, 'Days remaining until scheduled meeting start date.'),
    ('IsVirtualFlag', 'Is Virtual Flag', 'int', 4, 10, 0, 'Flag indicating whether meeting location type is Virtual.'),
    ('IsHybridFlag', 'Is Hybrid Flag', 'int', 4, 10, 0, 'Flag indicating whether meeting location type is Hybrid.'),
    ('IsInPersonFlag', 'Is In-Person Flag', 'int', 4, 10, 0, 'Flag indicating whether meeting location type is InPerson.'),
    ('HasVideoLink', 'Has Video Link', 'int', 4, 10, 0, 'Flag indicating whether meeting has video conferencing configured.'),
    ('AgendaItemCount', 'Agenda Item Count', 'int', 4, 10, 0, 'Total number of agenda items scheduled for this meeting.'),
    ('TotalAttendees', 'Total Attendees', 'int', 4, 10, 0, 'Total participant records configured for this meeting.'),
    ('ExpectedAttendees', 'Expected Attendees', 'int', 4, 10, 0, 'Count of participants expected to attend this meeting.'),
    ('PresentAttendees', 'Present Attendees', 'int', 4, 10, 0, 'Count of participants verified present at this meeting.'),
    ('AbsentAttendees', 'Absent Attendees', 'int', 4, 10, 0, 'Count of participants marked absent from this meeting.');

    MERGE INTO [${mjSchema}].[EntityField] AS target
    USING (
        SELECT 
            NEWID() AS ID,
            @meetingEntityID AS EntityID,
            (SELECT ISNULL(MAX(Sequence), 0) FROM [${mjSchema}].[EntityField] WHERE EntityID = @meetingEntityID) + 
                ROW_NUMBER() OVER (ORDER BY f.Name) AS Sequence,
            f.Name,
            f.DisplayName,
            f.Description,
            f.Type,
            f.Length,
            f.Precision,
            f.Scale,
            1 AS AllowsNull,
            0 AS DefaultInView,
            1 AS IsVirtual,
            0 AS AllowUpdateAPI,
            'Active' AS Status
        FROM @fields f
    ) AS source
    ON target.EntityID = source.EntityID AND target.Name = source.Name
    WHEN NOT MATCHED THEN
        INSERT (ID, EntityID, Sequence, Name, DisplayName, Description, Type, Length, Precision, Scale, AllowsNull, DefaultInView, IsVirtual, AllowUpdateAPI, Status)
        VALUES (source.ID, source.EntityID, source.Sequence, source.Name, source.DisplayName, source.Description, source.Type, source.Length, source.Precision, source.Scale, source.AllowsNull, source.DefaultInView, source.IsVirtual, source.AllowUpdateAPI, source.Status);
END
GO

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

    SELECT * FROM [${flyway:defaultSchema}].[vwMeetings] WHERE [ID] = (SELECT [ID] FROM @InsertedRow);
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}].[spCreateMeeting] TO [cdp_Developer], [cdp_Integration];
GO

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
        [PredictedQuorumRiskScoredAt] = CASE WHEN @PredictedQuorumRiskScoredAt_Clear = 1 THEN NULL ELSE ISNULL(@PredictedQuorumRiskScoredAt, [PredictedQuorumRiskScoredAt]) END
    WHERE
        [ID] = @ID;

    IF @@ROWCOUNT = 0
        SELECT TOP 0 * FROM [${flyway:defaultSchema}].[vwMeetings] WHERE 1=0;
    ELSE
        SELECT * FROM [${flyway:defaultSchema}].[vwMeetings] WHERE [ID] = @ID;
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}].[spUpdateMeeting] TO [cdp_Developer], [cdp_Integration];
GO

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
        [ID] = @ID;

    SELECT @ID AS [ID];
END
GO

GRANT EXECUTE ON [${flyway:defaultSchema}].[spDeleteMeeting] TO [cdp_Developer], [cdp_Integration];
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
    UPDATE
        [${flyway:defaultSchema}].[Meeting]
    SET
        __mj_UpdatedAt = GETUTCDATE()
    FROM
        [${flyway:defaultSchema}].[Meeting] AS _organicTable
    INNER JOIN
        INSERTED AS I ON
        _organicTable.[ID] = I.[ID];
END;
GO
