-- Video Provider Table and Meeting FK
-- Adds infrastructure for auto-creating video meeting URLs via configured providers.
-- Depends on: V202602150002__Committees_Schema_and_Tables.sql

-- ---------------------------------------------------------------------------
-- CredentialType seed: "Video Provider OAuth"
-- Used by CredentialEngine to store OAuth credentials for video providers.
-- ---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM [__mj].[CredentialType] WHERE Name = 'Video Provider OAuth')
    INSERT INTO [__mj].[CredentialType] (Name, Description, Category, FieldSchema)
    VALUES (
        'Video Provider OAuth',
        'OAuth credentials for video conferencing providers (Zoom Server-to-Server, Teams, Google Meet)',
        'Integration',
        N'{"type":"object","properties":{"client_id":{"type":"string","title":"Client ID / Service Account Email"},"client_secret":{"type":"string","title":"Client Secret / Private Key PEM"},"account_id":{"type":"string","title":"Account ID (Zoom) / Tenant ID (Teams) / Impersonated User (Google)"},"organizer_user_id":{"type":"string","title":"Organizer User ID (Teams only) — AAD Object ID or UPN"}},"required":["client_id","client_secret","account_id"]}'
    );
GO

-- ---------------------------------------------------------------------------
-- VideoProvider table
-- ---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'VideoProvider')
CREATE TABLE [__mj_Committees].[VideoProvider] (
    ID              UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    Name            NVARCHAR(100)    NOT NULL,
    ServerDriverKey NVARCHAR(100)    NOT NULL,
    IsActive        BIT              NOT NULL DEFAULT 1,
    IsDefault       BIT              NOT NULL DEFAULT 0,
    CredentialID    UNIQUEIDENTIFIER NULL,
    CONSTRAINT PK_VideoProvider PRIMARY KEY (ID),
    CONSTRAINT UQ_VideoProvider_Name UNIQUE (Name)
);
GO

-- FK: VideoProvider → MJ Credentials
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'VideoProvider'
      AND CONSTRAINT_NAME = 'FK_VideoProvider_Credential'
)
    ALTER TABLE [__mj_Committees].[VideoProvider]
        ADD CONSTRAINT FK_VideoProvider_Credential
        FOREIGN KEY (CredentialID) REFERENCES [__mj].[Credential](ID);
GO

-- ---------------------------------------------------------------------------
-- Add VideoProviderID FK to Meeting
-- The free-text VideoProvider column is kept for backward compatibility;
-- the entity hook will keep both in sync.
-- ---------------------------------------------------------------------------
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'Meeting'
      AND COLUMN_NAME = 'VideoProviderID'
)
    ALTER TABLE [__mj_Committees].[Meeting]
        ADD VideoProviderID UNIQUEIDENTIFIER NULL;
GO

IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE TABLE_SCHEMA = '__mj_Committees' AND TABLE_NAME = 'Meeting'
      AND CONSTRAINT_NAME = 'FK_Meeting_VideoProvider'
)
    ALTER TABLE [__mj_Committees].[Meeting]
        ADD CONSTRAINT FK_Meeting_VideoProvider
        FOREIGN KEY (VideoProviderID) REFERENCES [__mj_Committees].[VideoProvider](ID);
GO

-- Extended property descriptions
EXEC sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'FK to VideoProvider — when set, video meeting URL is auto-created on save',
    @level0type = N'SCHEMA', @level0name = N'__mj_Committees',
    @level1type = N'TABLE',  @level1name = N'Meeting',
    @level2type = N'COLUMN', @level2name = N'VideoProviderID';
GO
