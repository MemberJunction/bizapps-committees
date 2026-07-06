-- ============================================================================
-- Committees Sample Data
-- ============================================================================
-- This script populates the Committees schema with rich sample data.
--
-- PREREQUISITES:
--   1. MemberJunction core metadata must be deployed
--   2. BizAppsCommon schema must exist with Person and Organization tables
--   3. 01_BizAppsCommon_Sample_Data.sql must have been run first
--   4. Committees schema DDL must be deployed (tables, constraints, etc.)
--   5. Committees metadata sync must have seeded Type, Role, and ArtifactType
--
-- NOTES:
--   - All UserID references have been replaced with PersonID -> __mj_BizAppsCommon.Person
--   - Type, Role, and ArtifactType are looked up by Name (already seeded)
--   - All GUIDs are generated via NEWID() and stored in variables
--   - Does NOT include __mj_CreatedAt or __mj_UpdatedAt columns
-- ============================================================================

SET NOCOUNT ON;
BEGIN TRANSACTION;

BEGIN TRY

-- ============================================================================
-- STEP 1: Look Up Prerequisites
-- ============================================================================

-- --------------------------------------------------------------------------
-- 1a. Person records from BizAppsCommon (created by 01 script)
-- --------------------------------------------------------------------------
DECLARE @Sarah         UNIQUEIDENTIFIER,
        @Michael       UNIQUEIDENTIFIER,
        @Jennifer      UNIQUEIDENTIFIER,
        @David         UNIQUEIDENTIFIER,
        @Emily         UNIQUEIDENTIFIER,
        @James         UNIQUEIDENTIFIER,
        @Maria         UNIQUEIDENTIFIER,
        @Robert        UNIQUEIDENTIFIER,
        @Lisa          UNIQUEIDENTIFIER,
        @Thomas        UNIQUEIDENTIFIER,
        @Patricia      UNIQUEIDENTIFIER,
        @Christopher   UNIQUEIDENTIFIER,
        @Amanda        UNIQUEIDENTIFIER,
        @Daniel        UNIQUEIDENTIFIER,
        @Rachel        UNIQUEIDENTIFIER,
        @Marcus        UNIQUEIDENTIFIER,
        @Sophia        UNIQUEIDENTIFIER,
        @William       UNIQUEIDENTIFIER,
        @Olivia        UNIQUEIDENTIFIER,
        @Nathan        UNIQUEIDENTIFIER,
        @Elena         UNIQUEIDENTIFIER,
        @Benjamin      UNIQUEIDENTIFIER,
        @Hannah        UNIQUEIDENTIFIER,
        @Andrew        UNIQUEIDENTIFIER,
        @Catherine     UNIQUEIDENTIFIER;

SELECT @Sarah       = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Sarah'       AND LastName = 'Chen';
SELECT @Michael     = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Michael'     AND LastName = 'Rodriguez';
SELECT @Jennifer    = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Jennifer'    AND LastName = 'Okafor';
SELECT @David       = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'David'       AND LastName = 'Kim';
SELECT @Emily       = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Emily'       AND LastName = 'Watson';
SELECT @James       = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'James'       AND LastName = 'Thompson';
SELECT @Maria       = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Maria'       AND LastName = 'Garcia';
SELECT @Robert      = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Robert'      AND LastName = 'Singh';
SELECT @Lisa        = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Lisa'        AND LastName = 'Nakamura';
SELECT @Thomas      = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Thomas'      AND LastName = 'Anderson';
SELECT @Patricia    = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Patricia'    AND LastName = 'Williams';
SELECT @Christopher = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Christopher' AND LastName = 'Lee';
SELECT @Amanda      = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Amanda'      AND LastName = 'Foster';
SELECT @Daniel      = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Daniel'      AND LastName = 'Martinez';
SELECT @Rachel      = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Rachel'      AND LastName = 'Green';
SELECT @Marcus      = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Marcus'      AND LastName = 'Johnson';
SELECT @Sophia      = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Sophia'      AND LastName = 'Patel';
SELECT @William     = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'William'     AND LastName = 'Brown';
SELECT @Olivia      = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Olivia'      AND LastName = 'Taylor';
SELECT @Nathan      = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Nathan'      AND LastName = 'Wright';
SELECT @Elena       = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Elena'       AND LastName = 'Volkov';
SELECT @Benjamin    = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Benjamin'    AND LastName = 'Clark';
SELECT @Hannah      = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Hannah'      AND LastName = 'Mitchell';
SELECT @Andrew      = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Andrew'      AND LastName = 'Park';
SELECT @Catherine   = ID FROM __mj_BizAppsCommon.Person WHERE FirstName = 'Catherine'   AND LastName = 'O''Brien';

-- Validate that we found the people we need
IF @Sarah IS NULL OR @Thomas IS NULL OR @Jennifer IS NULL OR @David IS NULL OR @Robert IS NULL
BEGIN
    RAISERROR('Missing required Person records. Ensure 01_BizAppsCommon_Sample_Data.sql has been run.', 16, 1);
    RETURN;
END

-- --------------------------------------------------------------------------
-- 1b. Committee Types (already seeded via metadata sync)
-- --------------------------------------------------------------------------
DECLARE @TypeBoard        UNIQUEIDENTIFIER,
        @TypeStanding     UNIQUEIDENTIFIER,
        @TypeAdHoc        UNIQUEIDENTIFIER,
        @TypeWorkgroup    UNIQUEIDENTIFIER,
        @TypeStandardsWG  UNIQUEIDENTIFIER;

SELECT @TypeBoard       = ID FROM __mj_BizAppsCommittees.[Type] WHERE Name = 'Board of Directors';
SELECT @TypeStanding    = ID FROM __mj_BizAppsCommittees.[Type] WHERE Name = 'Standing Committee';
SELECT @TypeAdHoc       = ID FROM __mj_BizAppsCommittees.[Type] WHERE Name = 'Ad Hoc Committee';
SELECT @TypeWorkgroup   = ID FROM __mj_BizAppsCommittees.[Type] WHERE Name = 'Workgroup';
SELECT @TypeStandardsWG = ID FROM __mj_BizAppsCommittees.[Type] WHERE Name = 'Standards Working Group';

IF @TypeBoard IS NULL OR @TypeStanding IS NULL OR @TypeAdHoc IS NULL
BEGIN
    RAISERROR('Missing required Committee Type records. Ensure Committees metadata has been synced.', 16, 1);
    RETURN;
END

-- --------------------------------------------------------------------------
-- 1c. Committee Roles (already seeded via metadata sync)
-- --------------------------------------------------------------------------
DECLARE @RoleChair     UNIQUEIDENTIFIER,
        @RoleViceChair UNIQUEIDENTIFIER,
        @RoleSecretary UNIQUEIDENTIFIER,
        @RoleMember    UNIQUEIDENTIFIER,
        @RoleNonVoting UNIQUEIDENTIFIER,
        @RoleLiaison   UNIQUEIDENTIFIER,
        @RoleAdvisor   UNIQUEIDENTIFIER;

SELECT @RoleChair     = ID FROM __mj_BizAppsCommittees.[Role] WHERE Name = 'Chair';
SELECT @RoleViceChair = ID FROM __mj_BizAppsCommittees.[Role] WHERE Name = 'Vice Chair';
SELECT @RoleSecretary = ID FROM __mj_BizAppsCommittees.[Role] WHERE Name = 'Secretary';
SELECT @RoleMember    = ID FROM __mj_BizAppsCommittees.[Role] WHERE Name = 'Member';
SELECT @RoleNonVoting = ID FROM __mj_BizAppsCommittees.[Role] WHERE Name = 'Non-Voting Member';
SELECT @RoleLiaison   = ID FROM __mj_BizAppsCommittees.[Role] WHERE Name = 'Liaison';
SELECT @RoleAdvisor   = ID FROM __mj_BizAppsCommittees.[Role] WHERE Name = 'Advisor';

IF @RoleChair IS NULL OR @RoleMember IS NULL
BEGIN
    RAISERROR('Missing required Committee Role records. Ensure Committees metadata has been synced.', 16, 1);
    RETURN;
END

-- --------------------------------------------------------------------------
-- 1d. Artifact Types (already seeded via metadata sync)
-- --------------------------------------------------------------------------
DECLARE @ArtDoc          UNIQUEIDENTIFIER,
        @ArtMinutes      UNIQUEIDENTIFIER,
        @ArtAgenda       UNIQUEIDENTIFIER,
        @ArtRecording    UNIQUEIDENTIFIER,
        @ArtPresentation UNIQUEIDENTIFIER,
        @ArtSpreadsheet  UNIQUEIDENTIFIER;

SELECT @ArtDoc          = ID FROM __mj_BizAppsCommittees.ArtifactType WHERE Name = 'Document';
SELECT @ArtMinutes      = ID FROM __mj_BizAppsCommittees.ArtifactType WHERE Name = 'Minutes';
SELECT @ArtAgenda       = ID FROM __mj_BizAppsCommittees.ArtifactType WHERE Name = 'Agenda';
SELECT @ArtRecording    = ID FROM __mj_BizAppsCommittees.ArtifactType WHERE Name = 'Recording';
SELECT @ArtPresentation = ID FROM __mj_BizAppsCommittees.ArtifactType WHERE Name = 'Presentation';
SELECT @ArtSpreadsheet  = ID FROM __mj_BizAppsCommittees.ArtifactType WHERE Name = 'Spreadsheet';

IF @ArtDoc IS NULL OR @ArtMinutes IS NULL
BEGIN
    RAISERROR('Missing required ArtifactType records. Ensure Committees metadata has been synced.', 16, 1);
    RETURN;
END

-- --------------------------------------------------------------------------
-- 1e. Organization (from BizAppsCommon)
-- --------------------------------------------------------------------------
DECLARE @OrgGlobalStandards UNIQUEIDENTIFIER;
SELECT @OrgGlobalStandards = ID FROM __mj_BizAppsCommon.Organization WHERE Name = 'Global Standards Alliance';


-- ============================================================================
-- STEP 2: Committees (6)
-- ============================================================================

DECLARE @CommBoard       UNIQUEIDENTIFIER = NEWID(),
        @CommFinance     UNIQUEIDENTIFIER = NEWID(),
        @CommMembership  UNIQUEIDENTIFIER = NEWID(),
        @CommTechStd     UNIQUEIDENTIFIER = NEWID(),
        @CommDataInterop UNIQUEIDENTIFIER = NEWID(),
        @CommConference  UNIQUEIDENTIFIER = NEWID();

-- Board of Directors
INSERT INTO __mj_BizAppsCommittees.Committee
    (ID, Name, Description, TypeID, ParentCommitteeID, OrganizationID,
     CharterDocumentURL, MissionStatement, Status, IsPublic, FormationDate, DissolutionDate)
VALUES
    (@CommBoard,
     'Board of Directors',
     'The governing body of the Global Standards Alliance, responsible for strategic direction, fiduciary oversight, and organizational governance.',
     @TypeBoard,
     NULL,
     @OrgGlobalStandards,
     'https://globalstandards.org/charter/board-charter.pdf',
     'To provide strategic leadership and governance oversight for the Global Standards Alliance, ensuring the organization fulfills its mission of advancing open standards for the benefit of the global community.',
     'Active', 1, '1998-03-15', NULL);

-- Finance & Audit Committee
INSERT INTO __mj_BizAppsCommittees.Committee
    (ID, Name, Description, TypeID, ParentCommitteeID, OrganizationID,
     CharterDocumentURL, MissionStatement, Status, IsPublic, FormationDate, DissolutionDate)
VALUES
    (@CommFinance,
     'Finance & Audit Committee',
     'Oversees financial reporting, budgeting, audit processes, and fiscal responsibility for the organization.',
     @TypeStanding,
     @CommBoard,
     @OrgGlobalStandards,
     'https://globalstandards.org/charter/finance-audit-charter.pdf',
     'To ensure sound financial management, transparent reporting, and effective internal controls across all organizational activities.',
     'Active', 1, '2000-01-01', NULL);

-- Membership & Outreach Committee
INSERT INTO __mj_BizAppsCommittees.Committee
    (ID, Name, Description, TypeID, ParentCommitteeID, OrganizationID,
     CharterDocumentURL, MissionStatement, Status, IsPublic, FormationDate, DissolutionDate)
VALUES
    (@CommMembership,
     'Membership & Outreach Committee',
     'Drives membership growth, engagement programs, community outreach, and stakeholder communications.',
     @TypeStanding,
     @CommBoard,
     @OrgGlobalStandards,
     'https://globalstandards.org/charter/membership-outreach-charter.pdf',
     'To grow and engage the Alliance membership through targeted outreach, inclusive programs, and meaningful community partnerships.',
     'Active', 1, '2005-06-01', NULL);

-- Technology Standards Committee
INSERT INTO __mj_BizAppsCommittees.Committee
    (ID, Name, Description, TypeID, ParentCommitteeID, OrganizationID,
     CharterDocumentURL, MissionStatement, Status, IsPublic, FormationDate, DissolutionDate)
VALUES
    (@CommTechStd,
     'Technology Standards Committee',
     'Develops, reviews, and maintains technology standards and specifications for data exchange, interoperability, and best practices.',
     @TypeStandardsWG,
     NULL,
     @OrgGlobalStandards,
     'https://globalstandards.org/charter/tech-standards-charter.pdf',
     'To develop and promote open technology standards that enable seamless interoperability and innovation across the industry.',
     'Active', 1, '2015-01-15', NULL);

-- Data Interoperability Workgroup
INSERT INTO __mj_BizAppsCommittees.Committee
    (ID, Name, Description, TypeID, ParentCommitteeID, OrganizationID,
     CharterDocumentURL, MissionStatement, Status, IsPublic, FormationDate, DissolutionDate)
VALUES
    (@CommDataInterop,
     'Data Interoperability Workgroup',
     'Focused workgroup developing specifications and reference implementations for cross-platform data interoperability.',
     @TypeWorkgroup,
     @CommTechStd,
     @OrgGlobalStandards,
     NULL,
     'To create practical, implementable specifications that enable organizations to exchange data seamlessly across diverse platforms and systems.',
     'Active', 1, '2024-01-01', NULL);

-- 2025 Annual Conference Committee (Dissolved)
INSERT INTO __mj_BizAppsCommittees.Committee
    (ID, Name, Description, TypeID, ParentCommitteeID, OrganizationID,
     CharterDocumentURL, MissionStatement, Status, IsPublic, FormationDate, DissolutionDate)
VALUES
    (@CommConference,
     '2025 Annual Conference Committee',
     'Ad hoc committee responsible for planning and executing the 2025 Annual Conference of the Global Standards Alliance.',
     @TypeAdHoc,
     NULL,
     @OrgGlobalStandards,
     NULL,
     'To plan and deliver an outstanding annual conference that brings together standards practitioners, industry leaders, and community members.',
     'Dissolved', 1, '2024-06-01', '2025-12-31');

PRINT 'Inserted 6 __mj_BizAppsCommittees.';


-- ============================================================================
-- STEP 3: Terms (16)
-- ============================================================================

-- Board of Directors terms
DECLARE @TermBoard2324  UNIQUEIDENTIFIER = NEWID(),
        @TermBoard2425  UNIQUEIDENTIFIER = NEWID(),
        @TermBoard2526  UNIQUEIDENTIFIER = NEWID();

-- Finance & Audit terms
DECLARE @TermFin2324    UNIQUEIDENTIFIER = NEWID(),
        @TermFin2425    UNIQUEIDENTIFIER = NEWID(),
        @TermFin2526    UNIQUEIDENTIFIER = NEWID();

-- Membership & Outreach terms
DECLARE @TermMem2425    UNIQUEIDENTIFIER = NEWID(),
        @TermMem2526    UNIQUEIDENTIFIER = NEWID(),
        @TermMem2627    UNIQUEIDENTIFIER = NEWID();

-- Technology Standards terms
DECLARE @TermTech24H1   UNIQUEIDENTIFIER = NEWID(),
        @TermTech24H2   UNIQUEIDENTIFIER = NEWID(),
        @TermTech25H1   UNIQUEIDENTIFIER = NEWID();

-- Data Interoperability WG terms
DECLARE @TermData24Q34  UNIQUEIDENTIFIER = NEWID(),
        @TermData25Q12  UNIQUEIDENTIFIER = NEWID(),
        @TermData25Q34  UNIQUEIDENTIFIER = NEWID();

-- Conference Committee term
DECLARE @TermConf2025   UNIQUEIDENTIFIER = NEWID();

INSERT INTO __mj_BizAppsCommittees.Term (ID, CommitteeID, Name, StartDate, EndDate, Status)
VALUES
    -- Board of Directors
    (@TermBoard2324, @CommBoard, '2023-2024', '2023-07-01', '2024-06-30', 'Completed'),
    (@TermBoard2425, @CommBoard, '2024-2025', '2024-07-01', '2025-06-30', 'Completed'),
    (@TermBoard2526, @CommBoard, '2025-2026', '2025-07-01', '2026-06-30', 'Active'),

    -- Finance & Audit
    (@TermFin2324, @CommFinance, '2023-2024', '2023-07-01', '2024-06-30', 'Completed'),
    (@TermFin2425, @CommFinance, '2024-2025', '2024-07-01', '2025-06-30', 'Completed'),
    (@TermFin2526, @CommFinance, '2025-2026', '2025-07-01', '2026-06-30', 'Active'),

    -- Membership & Outreach
    (@TermMem2425, @CommMembership, '2024-2025', '2024-07-01', '2025-06-30', 'Completed'),
    (@TermMem2526, @CommMembership, '2025-2026', '2025-07-01', '2026-06-30', 'Active'),
    (@TermMem2627, @CommMembership, '2026-2027', '2026-07-01', '2027-06-30', 'Upcoming'),

    -- Technology Standards
    (@TermTech24H1, @CommTechStd, '2024 H1', '2024-01-01', '2024-06-30', 'Completed'),
    (@TermTech24H2, @CommTechStd, '2024 H2', '2024-07-01', '2024-12-31', 'Completed'),
    (@TermTech25H1, @CommTechStd, '2025 H1', '2025-01-01', '2025-06-30', 'Active'),

    -- Data Interoperability Workgroup
    (@TermData24Q34, @CommDataInterop, '2024 Q3-Q4', '2024-07-01', '2024-12-31', 'Completed'),
    (@TermData25Q12, @CommDataInterop, '2025 Q1-Q2', '2025-01-01', '2025-06-30', 'Active'),
    (@TermData25Q34, @CommDataInterop, '2025 Q3-Q4', '2025-07-01', '2025-12-31', 'Upcoming'),

    -- Conference Committee
    (@TermConf2025, @CommConference, '2025 Planning', '2024-06-01', '2025-12-31', 'Completed');

PRINT 'Inserted 16 Terms.';


-- ============================================================================
-- STEP 4: Memberships (~30)
-- ============================================================================

-- Board 2025-2026 (Active term, 9 members)
DECLARE @MemBrd2526_Thomas    UNIQUEIDENTIFIER = NEWID(),
        @MemBrd2526_Patricia  UNIQUEIDENTIFIER = NEWID(),
        @MemBrd2526_Lisa      UNIQUEIDENTIFIER = NEWID(),
        @MemBrd2526_Sarah     UNIQUEIDENTIFIER = NEWID(),
        @MemBrd2526_James     UNIQUEIDENTIFIER = NEWID(),
        @MemBrd2526_Catherine UNIQUEIDENTIFIER = NEWID(),
        @MemBrd2526_Chris     UNIQUEIDENTIFIER = NEWID(),
        @MemBrd2526_Elena     UNIQUEIDENTIFIER = NEWID(),
        @MemBrd2526_Amanda    UNIQUEIDENTIFIER = NEWID();

-- Board 2024-2025 (Ended term, 4 historical)
DECLARE @MemBrd2425_Thomas    UNIQUEIDENTIFIER = NEWID(),
        @MemBrd2425_Patricia  UNIQUEIDENTIFIER = NEWID(),
        @MemBrd2425_Lisa      UNIQUEIDENTIFIER = NEWID(),
        @MemBrd2425_Sarah     UNIQUEIDENTIFIER = NEWID();

-- Finance 2025-2026 (Active, 6 members)
DECLARE @MemFin_Jennifer UNIQUEIDENTIFIER = NEWID(),
        @MemFin_Marcus   UNIQUEIDENTIFIER = NEWID(),
        @MemFin_Sarah    UNIQUEIDENTIFIER = NEWID(),
        @MemFin_Patricia UNIQUEIDENTIFIER = NEWID(),
        @MemFin_Amanda   UNIQUEIDENTIFIER = NEWID(),
        @MemFin_Andrew   UNIQUEIDENTIFIER = NEWID();

-- Membership & Outreach 2025-2026 (Active, 5 members)
DECLARE @MemOut_Catherine UNIQUEIDENTIFIER = NEWID(),
        @MemOut_Emily     UNIQUEIDENTIFIER = NEWID(),
        @MemOut_Olivia    UNIQUEIDENTIFIER = NEWID(),
        @MemOut_Benjamin  UNIQUEIDENTIFIER = NEWID(),
        @MemOut_Rachel    UNIQUEIDENTIFIER = NEWID();

-- Technology Standards 2025 H1 (Active, 7 members)
DECLARE @MemTech_David   UNIQUEIDENTIFIER = NEWID(),
        @MemTech_Robert  UNIQUEIDENTIFIER = NEWID(),
        @MemTech_Sophia  UNIQUEIDENTIFIER = NEWID(),
        @MemTech_William UNIQUEIDENTIFIER = NEWID(),
        @MemTech_Nathan  UNIQUEIDENTIFIER = NEWID(),
        @MemTech_Chris   UNIQUEIDENTIFIER = NEWID(),
        @MemTech_Hannah  UNIQUEIDENTIFIER = NEWID();

-- Data Interop WG 2025 Q1-Q2 (Active, 5 members)
DECLARE @MemData_Robert  UNIQUEIDENTIFIER = NEWID(),
        @MemData_Sophia  UNIQUEIDENTIFIER = NEWID(),
        @MemData_William UNIQUEIDENTIFIER = NEWID(),
        @MemData_Nathan  UNIQUEIDENTIFIER = NEWID(),
        @MemData_Daniel  UNIQUEIDENTIFIER = NEWID();

-- Conference 2025 Planning (Ended, 4 members)
DECLARE @MemConf_Emily    UNIQUEIDENTIFIER = NEWID(),
        @MemConf_Olivia   UNIQUEIDENTIFIER = NEWID(),
        @MemConf_Benjamin UNIQUEIDENTIFIER = NEWID(),
        @MemConf_Hannah   UNIQUEIDENTIFIER = NEWID();

INSERT INTO __mj_BizAppsCommittees.Membership
    (ID, PersonID, RoleID, TermID, StartDate, EndDate, Status, EndReason, Notes)
VALUES
    -- ---- Board 2025-2026 (Active) ----
    (@MemBrd2526_Thomas,    @Thomas,      @RoleChair,     @TermBoard2526, '2025-07-01', NULL, 'Active', NULL, 'Continuing as Chair for second consecutive term'),
    (@MemBrd2526_Patricia,  @Patricia,    @RoleViceChair, @TermBoard2526, '2025-07-01', NULL, 'Active', NULL, NULL),
    (@MemBrd2526_Lisa,      @Lisa,        @RoleSecretary, @TermBoard2526, '2025-07-01', NULL, 'Active', NULL, NULL),
    (@MemBrd2526_Sarah,     @Sarah,       @RoleMember,    @TermBoard2526, '2025-07-01', NULL, 'Active', NULL, 'Also serves on Finance & Audit Committee'),
    (@MemBrd2526_James,     @James,       @RoleMember,    @TermBoard2526, '2025-07-01', NULL, 'Active', NULL, NULL),
    (@MemBrd2526_Catherine, @Catherine,   @RoleMember,    @TermBoard2526, '2025-07-01', NULL, 'Active', NULL, 'Also chairs Membership & Outreach Committee'),
    (@MemBrd2526_Chris,     @Christopher, @RoleMember,    @TermBoard2526, '2025-07-01', NULL, 'Active', NULL, NULL),
    (@MemBrd2526_Elena,     @Elena,       @RoleMember,    @TermBoard2526, '2025-07-01', NULL, 'Active', NULL, 'Research institution representative'),
    (@MemBrd2526_Amanda,    @Amanda,      @RoleAdvisor,   @TermBoard2526, '2025-07-01', NULL, 'Active', NULL, 'Non-voting advisory role; former board chair'),

    -- ---- Board 2024-2025 (Ended) ----
    (@MemBrd2425_Thomas,    @Thomas,   @RoleChair,     @TermBoard2425, '2024-07-01', '2025-06-30', 'Ended', 'Term ended', NULL),
    (@MemBrd2425_Patricia,  @Patricia, @RoleViceChair, @TermBoard2425, '2024-07-01', '2025-06-30', 'Ended', 'Term ended', NULL),
    (@MemBrd2425_Lisa,      @Lisa,     @RoleSecretary, @TermBoard2425, '2024-07-01', '2025-06-30', 'Ended', 'Term ended', NULL),
    (@MemBrd2425_Sarah,     @Sarah,    @RoleMember,    @TermBoard2425, '2024-07-01', '2025-06-30', 'Ended', 'Term ended', NULL),

    -- ---- Finance & Audit 2025-2026 (Active) ----
    (@MemFin_Jennifer, @Jennifer, @RoleChair,     @TermFin2526, '2025-07-01', NULL, 'Active', NULL, NULL),
    (@MemFin_Marcus,   @Marcus,   @RoleViceChair, @TermFin2526, '2025-07-01', NULL, 'Active', NULL, NULL),
    (@MemFin_Sarah,    @Sarah,    @RoleMember,    @TermFin2526, '2025-07-01', NULL, 'Active', NULL, 'Cross-committee member; also on Board'),
    (@MemFin_Patricia, @Patricia, @RoleMember,    @TermFin2526, '2025-07-01', NULL, 'Active', NULL, NULL),
    (@MemFin_Amanda,   @Amanda,   @RoleMember,    @TermFin2526, '2025-07-01', NULL, 'Active', NULL, NULL),
    (@MemFin_Andrew,   @Andrew,   @RoleMember,    @TermFin2526, '2025-07-01', NULL, 'Active', NULL, NULL),

    -- ---- Membership & Outreach 2025-2026 (Active) ----
    (@MemOut_Catherine, @Catherine, @RoleChair,     @TermMem2526, '2025-07-01', NULL, 'Active', NULL, NULL),
    (@MemOut_Emily,     @Emily,     @RoleViceChair, @TermMem2526, '2025-07-01', NULL, 'Active', NULL, NULL),
    (@MemOut_Olivia,    @Olivia,    @RoleMember,    @TermMem2526, '2025-07-01', NULL, 'Active', NULL, NULL),
    (@MemOut_Benjamin,  @Benjamin,  @RoleMember,    @TermMem2526, '2025-07-01', NULL, 'Active', NULL, NULL),
    (@MemOut_Rachel,    @Rachel,    @RoleMember,    @TermMem2526, '2025-07-01', NULL, 'Active', NULL, NULL),

    -- ---- Technology Standards 2025 H1 (Active) ----
    (@MemTech_David,   @David,       @RoleChair,     @TermTech25H1, '2025-01-01', NULL, 'Active', NULL, NULL),
    (@MemTech_Robert,  @Robert,      @RoleViceChair, @TermTech25H1, '2025-01-01', NULL, 'Active', NULL, NULL),
    (@MemTech_Sophia,  @Sophia,      @RoleSecretary, @TermTech25H1, '2025-01-01', NULL, 'Active', NULL, NULL),
    (@MemTech_William, @William,     @RoleMember,    @TermTech25H1, '2025-01-01', NULL, 'Active', NULL, NULL),
    (@MemTech_Nathan,  @Nathan,      @RoleMember,    @TermTech25H1, '2025-01-01', NULL, 'Active', NULL, NULL),
    (@MemTech_Chris,   @Christopher, @RoleAdvisor,   @TermTech25H1, '2025-01-01', NULL, 'Active', NULL, 'Board liaison to Technology Standards'),
    (@MemTech_Hannah,  @Hannah,      @RoleMember,    @TermTech25H1, '2025-01-01', NULL, 'Active', NULL, NULL),

    -- ---- Data Interoperability WG 2025 Q1-Q2 (Active) ----
    (@MemData_Robert,  @Robert,  @RoleChair,   @TermData25Q12, '2025-01-01', NULL, 'Active', NULL, NULL),
    (@MemData_Sophia,  @Sophia,  @RoleMember,  @TermData25Q12, '2025-01-01', NULL, 'Active', NULL, NULL),
    (@MemData_William, @William, @RoleMember,  @TermData25Q12, '2025-01-01', NULL, 'Active', NULL, NULL),
    (@MemData_Nathan,  @Nathan,  @RoleMember,  @TermData25Q12, '2025-01-01', NULL, 'Active', NULL, NULL),
    (@MemData_Daniel,  @Daniel,  @RoleLiaison, @TermData25Q12, '2025-01-01', NULL, 'Active', NULL, 'Industry liaison from partner organization'),

    -- ---- Conference 2025 Planning (Ended) ----
    (@MemConf_Emily,    @Emily,    @RoleChair,  @TermConf2025, '2024-06-01', '2025-12-31', 'Ended', 'Committee dissolved', NULL),
    (@MemConf_Olivia,   @Olivia,   @RoleMember, @TermConf2025, '2024-06-01', '2025-12-31', 'Ended', 'Committee dissolved', NULL),
    (@MemConf_Benjamin, @Benjamin, @RoleMember, @TermConf2025, '2024-06-01', '2025-12-31', 'Ended', 'Committee dissolved', NULL),
    (@MemConf_Hannah,   @Hannah,   @RoleMember, @TermConf2025, '2024-06-01', '2025-12-31', 'Ended', 'Committee dissolved', NULL);

PRINT 'Inserted Memberships.';


-- ============================================================================
-- STEP 5: Meetings (5)
-- ============================================================================

DECLARE @MtgBoardQ4    UNIQUEIDENTIFIER = NEWID(),
        @MtgBoardQ1    UNIQUEIDENTIFIER = NEWID(),
        @MtgBoardQ2    UNIQUEIDENTIFIER = NEWID(),
        @MtgFinJan     UNIQUEIDENTIFIER = NEWID(),
        @MtgTechKick   UNIQUEIDENTIFIER = NEWID();

INSERT INTO __mj_BizAppsCommittees.Meeting
    (ID, CommitteeID, Title, Description, StartDateTime, EndDateTime, TimeZone,
     LocationType, LocationText, VideoProvider, VideoMeetingID, VideoJoinURL,
     VideoRecordingURL, TranscriptURL, Status, CalendarEventID)
VALUES
    -- Board Q4 2025 Meeting
    (@MtgBoardQ4,
     @CommBoard,
     'Board Q4 2025 Meeting',
     'Quarterly review of organizational performance and strategic initiatives. Includes committee reports, 2026 budget approval, and strategic planning discussion.',
     '2025-10-15T14:00:00-04:00',
     '2025-10-15T16:00:00-04:00',
     'America/New_York',
     'Virtual', NULL,
     'Zoom', '854-2936-1047', 'https://zoom.us/j/85429361047',
     'https://zoom.us/rec/share/board-q4-2025-recording', NULL,
     'Completed', 'cal_board_q4_2025'),

    -- Board Q1 2026 Meeting
    (@MtgBoardQ1,
     @CommBoard,
     'Board Q1 2026 Meeting',
     'First quarter board meeting covering financial review, membership growth initiatives, and strategic updates.',
     '2026-01-21T14:00:00-05:00',
     '2026-01-21T16:00:00-05:00',
     'America/New_York',
     'Virtual', NULL,
     'Zoom', '921-5578-3342', 'https://zoom.us/j/92155783342',
     'https://zoom.us/rec/share/board-q1-2026-recording', NULL,
     'Completed', 'cal_board_q1_2026'),

    -- Board Q2 2026 Meeting (Scheduled, upcoming)
    (@MtgBoardQ2,
     @CommBoard,
     'Board Q2 2026 Meeting',
     'Second quarter board meeting. Agenda to include mid-year review and strategic assessment.',
     '2026-04-15T14:00:00-04:00',
     '2026-04-15T16:00:00-04:00',
     'America/New_York',
     'Virtual', NULL,
     'Zoom', '773-8841-2209', 'https://zoom.us/j/77388412209',
     NULL, NULL,
     'Scheduled', 'cal_board_q2_2026'),

    -- Finance Monthly - January 2026
    (@MtgFinJan,
     @CommFinance,
     'Finance Monthly - January 2026',
     'Monthly finance committee meeting reviewing December financials, Q1 budget forecast, and audit preparation.',
     '2026-01-08T10:00:00-05:00',
     '2026-01-08T11:00:00-05:00',
     'America/New_York',
     'Virtual', NULL,
     'Teams', 'fin-jan-2026-teams', 'https://teams.microsoft.com/l/meetup-join/fin-jan-2026',
     NULL, NULL,
     'Completed', 'cal_fin_jan_2026'),

    -- Tech Standards Kickoff 2025
    (@MtgTechKick,
     @CommTechStd,
     'Tech Standards Kickoff 2025',
     'Kickoff meeting for the 2025 standards development cycle. Setting roadmap, forming working groups, and establishing deliverables.',
     '2025-01-10T13:00:00-08:00',
     '2025-01-10T15:00:00-08:00',
     'America/Los_Angeles',
     'Hybrid', 'PNW University, Room 301 + Zoom',
     'Zoom', '667-3345-8891', 'https://zoom.us/j/66733458891',
     'https://zoom.us/rec/share/tech-kickoff-2025-recording',
     'https://docs.google.com/document/d/tech-kickoff-2025-transcript',
     'Completed', 'cal_tech_kickoff_2025');

PRINT 'Inserted 5 Meetings.';


-- ============================================================================
-- STEP 6: Agenda Items (~23)
-- ============================================================================

-- Board Q4 2025 agenda items
DECLARE @AgBrdQ4_CallToOrder  UNIQUEIDENTIFIER = NEWID(),
        @AgBrdQ4_ApproveMin   UNIQUEIDENTIFIER = NEWID(),
        @AgBrdQ4_CommReports  UNIQUEIDENTIFIER = NEWID(),
        @AgBrdQ4_FinReport    UNIQUEIDENTIFIER = NEWID(),
        @AgBrdQ4_MemReport    UNIQUEIDENTIFIER = NEWID(),
        @AgBrdQ4_TechReport   UNIQUEIDENTIFIER = NEWID(),
        @AgBrdQ4_Budget       UNIQUEIDENTIFIER = NEWID(),
        @AgBrdQ4_Strategic    UNIQUEIDENTIFIER = NEWID(),
        @AgBrdQ4_NewBiz       UNIQUEIDENTIFIER = NEWID(),
        @AgBrdQ4_Adjourn      UNIQUEIDENTIFIER = NEWID();

-- Board Q1 2026 agenda items
DECLARE @AgBrdQ1_CallToOrder  UNIQUEIDENTIFIER = NEWID(),
        @AgBrdQ1_ApproveMin   UNIQUEIDENTIFIER = NEWID(),
        @AgBrdQ1_FinReview    UNIQUEIDENTIFIER = NEWID(),
        @AgBrdQ1_MemGrowth    UNIQUEIDENTIFIER = NEWID(),
        @AgBrdQ1_Adjourn      UNIQUEIDENTIFIER = NEWID();

-- Board Q2 2026 agenda items (draft)
DECLARE @AgBrdQ2_CallToOrder  UNIQUEIDENTIFIER = NEWID(),
        @AgBrdQ2_ApproveMin   UNIQUEIDENTIFIER = NEWID(),
        @AgBrdQ2_MidYear      UNIQUEIDENTIFIER = NEWID();

-- Finance January 2026 agenda items
DECLARE @AgFin_DecFinancials  UNIQUEIDENTIFIER = NEWID(),
        @AgFin_Q1Forecast     UNIQUEIDENTIFIER = NEWID(),
        @AgFin_AuditPrep      UNIQUEIDENTIFIER = NEWID(),
        @AgFin_NextMeeting    UNIQUEIDENTIFIER = NEWID();

-- Tech Standards Kickoff agenda items
DECLARE @AgTech_Welcome       UNIQUEIDENTIFIER = NEWID(),
        @AgTech_Roadmap       UNIQUEIDENTIFIER = NEWID(),
        @AgTech_WGFormation   UNIQUEIDENTIFIER = NEWID(),
        @AgTech_NextSteps     UNIQUEIDENTIFIER = NEWID();

-- Board Q4 2025 Meeting agenda
INSERT INTO __mj_BizAppsCommittees.AgendaItem
    (ID, MeetingID, ParentAgendaItemID, Sequence, Title, Description,
     PresenterPersonID, DurationMinutes, ItemType, RelatedDocumentURL, Status, Notes)
VALUES
    (@AgBrdQ4_CallToOrder, @MtgBoardQ4, NULL, 1,
     'Call to Order',
     'Chair calls the meeting to order, confirms quorum, and reviews the agenda.',
     @Thomas, 5, 'Information', NULL, 'Completed',
     'Quorum confirmed with 7 of 8 voting members present.'),

    (@AgBrdQ4_ApproveMin, @MtgBoardQ4, NULL, 2,
     'Approval of Q3 2025 Minutes',
     'Review and approval of minutes from the Q3 2025 Board meeting.',
     NULL, 5, 'Vote', NULL, 'Completed',
     'Motion to approve passed unanimously.'),

    (@AgBrdQ4_CommReports, @MtgBoardQ4, NULL, 3,
     'Committee Reports',
     'Reports from standing committees on activities and progress during the quarter.',
     NULL, 30, 'Report', NULL, 'Completed', NULL),

    -- Sub-items under Committee Reports
    (@AgBrdQ4_FinReport, @MtgBoardQ4, @AgBrdQ4_CommReports, 1,
     'Finance Committee Report',
     'Q4 financial performance summary, budget variance analysis, and upcoming audit timeline.',
     @Jennifer, 10, 'Report', NULL, 'Completed',
     'Revenue on track; operating expenses 3% under budget.'),

    (@AgBrdQ4_MemReport, @MtgBoardQ4, @AgBrdQ4_CommReports, 2,
     'Membership Committee Report',
     'Membership growth metrics, engagement statistics, and outreach program updates.',
     @Catherine, 10, 'Report', NULL, 'Completed',
     'Net membership growth of 12% year-over-year.'),

    (@AgBrdQ4_TechReport, @MtgBoardQ4, @AgBrdQ4_CommReports, 3,
     'Technology Standards Report',
     'Standards development progress, working group updates, and upcoming milestones.',
     @David, 10, 'Report', NULL, 'Completed',
     'Data Interoperability spec v1 draft completed ahead of schedule.'),

    (@AgBrdQ4_Budget, @MtgBoardQ4, NULL, 4,
     '2026 Budget Approval',
     'Presentation and vote on the proposed 2026 annual operating budget prepared by the Finance & Audit Committee.',
     @Jennifer, 20, 'Vote', NULL, 'Completed',
     'Budget approved 5-1. One member requested additional review of research allocation line item.'),

    (@AgBrdQ4_Strategic, @MtgBoardQ4, NULL, 5,
     'Strategic Planning Update',
     'Discussion of strategic initiatives for the coming year including technology partnerships, global expansion, and standards adoption targets.',
     @Sarah, 30, 'Discussion', NULL, 'Completed',
     'Key areas identified: AI standards, cloud interop, and emerging markets outreach.'),

    (@AgBrdQ4_NewBiz, @MtgBoardQ4, NULL, 6,
     'New Business',
     'Open floor for any new business items not previously on the agenda.',
     NULL, 15, 'Discussion', NULL, 'Completed',
     'Brief discussion on potential partnership with European Standards Body.'),

    (@AgBrdQ4_Adjourn, @MtgBoardQ4, NULL, 7,
     'Adjournment',
     'Motion to adjourn the meeting.',
     NULL, 5, 'Other', NULL, 'Completed',
     'Meeting adjourned at 3:52 PM ET.');

-- Board Q1 2026 Meeting agenda
INSERT INTO __mj_BizAppsCommittees.AgendaItem
    (ID, MeetingID, ParentAgendaItemID, Sequence, Title, Description,
     PresenterPersonID, DurationMinutes, ItemType, RelatedDocumentURL, Status, Notes)
VALUES
    (@AgBrdQ1_CallToOrder, @MtgBoardQ1, NULL, 1,
     'Call to Order',
     'Chair calls the meeting to order and confirms quorum.',
     @Thomas, 5, 'Information', NULL, 'Completed',
     'Quorum confirmed with 8 of 8 voting members present.'),

    (@AgBrdQ1_ApproveMin, @MtgBoardQ1, NULL, 2,
     'Approval of Q4 2025 Minutes',
     'Review and approval of minutes from the Q4 2025 Board meeting.',
     NULL, 5, 'Vote', NULL, 'Completed',
     'Motion to approve passed unanimously.'),

    (@AgBrdQ1_FinReview, @MtgBoardQ1, NULL, 3,
     'Q1 Financial Review',
     'Review of first quarter financial performance against the approved 2026 budget.',
     @Jennifer, 20, 'Report', NULL, 'Completed',
     'Q1 revenue exceeded projections by 8%.'),

    (@AgBrdQ1_MemGrowth, @MtgBoardQ1, NULL, 4,
     'Membership Growth Initiative',
     'Presentation of the comprehensive membership growth initiative developed by the Membership & Outreach Committee.',
     @Catherine, 30, 'Discussion', NULL, 'Completed',
     'Board endorsed the three-phase approach to membership expansion.'),

    (@AgBrdQ1_Adjourn, @MtgBoardQ1, NULL, 5,
     'Adjournment',
     'Motion to adjourn the meeting.',
     NULL, 5, 'Other', NULL, 'Completed',
     'Meeting adjourned at 3:45 PM ET.');

-- Board Q2 2026 Meeting agenda (draft/upcoming)
INSERT INTO __mj_BizAppsCommittees.AgendaItem
    (ID, MeetingID, ParentAgendaItemID, Sequence, Title, Description,
     PresenterPersonID, DurationMinutes, ItemType, RelatedDocumentURL, Status, Notes)
VALUES
    (@AgBrdQ2_CallToOrder, @MtgBoardQ2, NULL, 1,
     'Call to Order',
     'Chair calls the meeting to order and confirms quorum.',
     @Thomas, 5, 'Information', NULL, 'Pending', NULL),

    (@AgBrdQ2_ApproveMin, @MtgBoardQ2, NULL, 2,
     'Approval of Q1 2026 Minutes',
     'Review and approval of minutes from the Q1 2026 Board meeting.',
     NULL, 5, 'Vote', NULL, 'Pending', NULL),

    (@AgBrdQ2_MidYear, @MtgBoardQ2, NULL, 3,
     'Mid-Year Review',
     'Comprehensive mid-year review of organizational performance, financials, and strategic progress.',
     @Sarah, 30, 'Report', NULL, 'Pending', NULL);

-- Finance January 2026 Meeting agenda
INSERT INTO __mj_BizAppsCommittees.AgendaItem
    (ID, MeetingID, ParentAgendaItemID, Sequence, Title, Description,
     PresenterPersonID, DurationMinutes, ItemType, RelatedDocumentURL, Status, Notes)
VALUES
    (@AgFin_DecFinancials, @MtgFinJan, NULL, 1,
     'Review December Financials',
     'Detailed review of December 2025 financial statements, including revenue, expenses, and balance sheet.',
     @Marcus, 15, 'Report', NULL, 'Completed',
     'All accounts reconciled; no material variances.'),

    (@AgFin_Q1Forecast, @MtgFinJan, NULL, 2,
     'Q1 Budget Forecast',
     'Forecast for Q1 2026 spending against the approved annual budget.',
     @Jennifer, 20, 'Discussion', NULL, 'Completed',
     'Projected 5% under budget due to delayed hiring.'),

    (@AgFin_AuditPrep, @MtgFinJan, NULL, 3,
     'Audit Preparation Timeline',
     'Review timeline and action items for the upcoming annual financial audit.',
     NULL, 15, 'Action', NULL, 'Completed',
     'Audit firm interviews to be scheduled by mid-February.'),

    (@AgFin_NextMeeting, @MtgFinJan, NULL, 4,
     'Next Meeting Planning',
     'Confirm date and agenda topics for the February committee meeting.',
     NULL, 5, 'Information', NULL, 'Completed',
     'Next meeting set for February 5, 2026.');

-- Tech Standards Kickoff 2025 agenda
INSERT INTO __mj_BizAppsCommittees.AgendaItem
    (ID, MeetingID, ParentAgendaItemID, Sequence, Title, Description,
     PresenterPersonID, DurationMinutes, ItemType, RelatedDocumentURL, Status, Notes)
VALUES
    (@AgTech_Welcome, @MtgTechKick, NULL, 1,
     'Welcome and Introductions',
     'Welcome remarks from the Chair and introduction of new committee members for the 2025 term.',
     @David, 15, 'Information', NULL, 'Completed',
     'Three new members introduced; returning members welcomed.'),

    (@AgTech_Roadmap, @MtgTechKick, NULL, 2,
     '2025 Standards Roadmap',
     'Presentation and discussion of proposed standards development activities for the first half of 2025.',
     @David, 45, 'Discussion', NULL, 'Completed',
     'Roadmap approved with focus on data interoperability and API standardization.'),

    (@AgTech_WGFormation, @MtgTechKick, NULL, 3,
     'Working Group Formation',
     'Formation of specialized working groups for key standards tracks, including chair appointments and member assignments.',
     @Robert, 30, 'Action', NULL, 'Completed',
     'Data Interoperability WG formed with Robert Singh as chair.'),

    (@AgTech_NextSteps, @MtgTechKick, NULL, 4,
     'Next Steps',
     'Summary of action items, next meeting schedule, and interim deliverables.',
     @David, 15, 'Information', NULL, 'Completed',
     'Monthly working group check-ins established; next full committee meeting in April.');

PRINT 'Inserted Agenda Items.';


-- ============================================================================
-- STEP 7: Attendance (~30)
-- ============================================================================

INSERT INTO __mj_BizAppsCommittees.Attendance
    (ID, MeetingID, PersonID, AttendanceStatus, JoinedAt, LeftAt, Notes)
VALUES
    -- ---- Board Q4 2025 Meeting ----
    (NEWID(), @MtgBoardQ4, @Thomas,      'Present', '2025-10-15T13:55:00-04:00', '2025-10-15T15:52:00-04:00', NULL),
    (NEWID(), @MtgBoardQ4, @Patricia,    'Present', '2025-10-15T13:58:00-04:00', '2025-10-15T15:52:00-04:00', NULL),
    (NEWID(), @MtgBoardQ4, @Lisa,        'Present', '2025-10-15T14:00:00-04:00', '2025-10-15T15:52:00-04:00', NULL),
    (NEWID(), @MtgBoardQ4, @Sarah,       'Present', '2025-10-15T14:02:00-04:00', '2025-10-15T15:52:00-04:00', NULL),
    (NEWID(), @MtgBoardQ4, @James,       'Absent',  NULL, NULL, 'Travel conflict'),
    (NEWID(), @MtgBoardQ4, @Catherine,   'Present', '2025-10-15T13:57:00-04:00', '2025-10-15T15:52:00-04:00', NULL),
    (NEWID(), @MtgBoardQ4, @Christopher, 'Partial', '2025-10-15T14:05:00-04:00', '2025-10-15T15:30:00-04:00', 'Left early due to scheduling conflict'),
    (NEWID(), @MtgBoardQ4, @Elena,       'Excused', NULL, NULL, 'Research conference'),
    (NEWID(), @MtgBoardQ4, @Amanda,      'Present', '2025-10-15T14:00:00-04:00', '2025-10-15T15:52:00-04:00', NULL),

    -- ---- Board Q1 2026 Meeting ----
    (NEWID(), @MtgBoardQ1, @Thomas,      'Present', '2026-01-21T13:55:00-05:00', '2026-01-21T15:45:00-05:00', NULL),
    (NEWID(), @MtgBoardQ1, @Patricia,    'Present', '2026-01-21T13:58:00-05:00', '2026-01-21T15:45:00-05:00', NULL),
    (NEWID(), @MtgBoardQ1, @Lisa,        'Present', '2026-01-21T14:00:00-05:00', '2026-01-21T15:45:00-05:00', NULL),
    (NEWID(), @MtgBoardQ1, @Sarah,       'Present', '2026-01-21T14:00:00-05:00', '2026-01-21T15:45:00-05:00', NULL),
    (NEWID(), @MtgBoardQ1, @James,       'Present', '2026-01-21T13:59:00-05:00', '2026-01-21T15:45:00-05:00', NULL),
    (NEWID(), @MtgBoardQ1, @Catherine,   'Present', '2026-01-21T13:57:00-05:00', '2026-01-21T15:45:00-05:00', NULL),
    (NEWID(), @MtgBoardQ1, @Christopher, 'Present', '2026-01-21T14:01:00-05:00', '2026-01-21T15:45:00-05:00', NULL),
    (NEWID(), @MtgBoardQ1, @Elena,       'Excused', NULL, NULL, 'Schedule conflict with academic commitments'),
    (NEWID(), @MtgBoardQ1, @Amanda,      'Present', '2026-01-21T14:00:00-05:00', '2026-01-21T15:45:00-05:00', NULL),

    -- ---- Finance January 2026 Meeting ----
    (NEWID(), @MtgFinJan, @Jennifer, 'Present', '2026-01-08T09:58:00-05:00', '2026-01-08T10:55:00-05:00', NULL),
    (NEWID(), @MtgFinJan, @Marcus,   'Present', '2026-01-08T09:59:00-05:00', '2026-01-08T10:55:00-05:00', NULL),
    (NEWID(), @MtgFinJan, @Sarah,    'Present', '2026-01-08T10:00:00-05:00', '2026-01-08T10:55:00-05:00', NULL),
    (NEWID(), @MtgFinJan, @Patricia, 'Present', '2026-01-08T10:01:00-05:00', '2026-01-08T10:55:00-05:00', NULL),
    (NEWID(), @MtgFinJan, @Amanda,   'Present', '2026-01-08T10:00:00-05:00', '2026-01-08T10:55:00-05:00', NULL),
    (NEWID(), @MtgFinJan, @Andrew,   'Present', '2026-01-08T10:02:00-05:00', '2026-01-08T10:55:00-05:00', NULL),

    -- ---- Tech Standards Kickoff 2025 ----
    (NEWID(), @MtgTechKick, @David,       'Present', '2025-01-10T12:55:00-08:00', '2025-01-10T14:58:00-08:00', NULL),
    (NEWID(), @MtgTechKick, @Robert,      'Present', '2025-01-10T12:58:00-08:00', '2025-01-10T14:58:00-08:00', NULL),
    (NEWID(), @MtgTechKick, @Sophia,      'Present', '2025-01-10T13:00:00-08:00', '2025-01-10T14:58:00-08:00', NULL),
    (NEWID(), @MtgTechKick, @William,     'Present', '2025-01-10T12:57:00-08:00', '2025-01-10T14:58:00-08:00', NULL),
    (NEWID(), @MtgTechKick, @Nathan,      'Present', '2025-01-10T13:00:00-08:00', '2025-01-10T14:58:00-08:00', NULL),
    (NEWID(), @MtgTechKick, @Christopher, 'Present', '2025-01-10T13:02:00-08:00', '2025-01-10T14:58:00-08:00', NULL),
    (NEWID(), @MtgTechKick, @Hannah,      'Partial', '2025-01-10T13:20:00-08:00', '2025-01-10T14:58:00-08:00', 'Joined late due to travel delay');

PRINT 'Inserted Attendance records.';


-- ============================================================================
-- STEP 8: Action Items (10)
-- ============================================================================

INSERT INTO __mj_BizAppsCommittees.ActionItem
    (ID, CommitteeID, MeetingID, AgendaItemID, Title, Description,
     AssignedToPersonID, AssignedByPersonID, DueDate, Priority, Status,
     CompletedAt, CompletionNotes)
VALUES
    -- 1. Prepare 2026 budget draft
    (NEWID(), @CommFinance, @MtgBoardQ4, @AgBrdQ4_Budget,
     'Prepare 2026 budget draft',
     'Develop comprehensive 2026 annual operating budget draft incorporating committee input and strategic priorities for board review.',
     @Jennifer, @Thomas, '2025-11-30', 'High', 'Completed',
     '2025-12-01T09:30:00-05:00',
     'Budget draft completed and distributed to board members for review prior to Q4 meeting.'),

    -- 2. Distribute Q4 meeting minutes
    (NEWID(), @CommBoard, @MtgBoardQ4, NULL,
     'Distribute Q4 meeting minutes',
     'Prepare and distribute draft minutes from the Q4 2025 Board meeting to all board members for review.',
     @Lisa, @Thomas, '2025-10-31', 'Medium', 'Completed',
     '2025-10-28T14:00:00-04:00',
     'Minutes distributed via email and uploaded to shared drive.'),

    -- 3. Develop membership growth proposal
    (NEWID(), @CommBoard, @MtgBoardQ4, @AgBrdQ4_Strategic,
     'Develop membership growth proposal',
     'Create a comprehensive membership growth proposal with targeted outreach strategies, projected growth metrics, and resource requirements.',
     @Catherine, @Thomas, '2026-01-15', 'High', 'Completed',
     '2026-01-12T16:00:00-05:00',
     'Proposal completed with three-phase approach; presented at Q1 2026 board meeting.'),

    -- 4. Review technology standards roadmap
    (NEWID(), @CommBoard, @MtgBoardQ4, @AgBrdQ4_TechReport,
     'Review technology standards roadmap',
     'Conduct detailed review of the 2025 technology standards roadmap and prepare summary recommendations for the board.',
     @David, NULL, '2025-12-31', 'Medium', 'Completed',
     '2025-12-20T11:00:00-08:00',
     'Review completed; recommendations incorporated into Q1 strategic update.'),

    -- 5. Schedule audit firm interviews
    (NEWID(), @CommFinance, @MtgFinJan, @AgFin_AuditPrep,
     'Schedule audit firm interviews',
     'Contact and schedule interviews with three pre-qualified audit firms for the annual financial audit engagement.',
     @Jennifer, NULL, '2026-02-15', 'High', 'InProgress',
     NULL, NULL),

    -- 6. Update financial reporting templates
    (NEWID(), @CommFinance, @MtgFinJan, @AgFin_DecFinancials,
     'Update financial reporting templates',
     'Redesign monthly financial reporting templates to align with the new 2026 budget structure and board reporting requirements.',
     @Marcus, NULL, '2026-02-28', 'Medium', 'Open',
     NULL, NULL),

    -- 7. Draft data interop specification v1
    (NEWID(), @CommTechStd, @MtgTechKick, @AgTech_WGFormation,
     'Draft data interop specification v1',
     'Develop the first complete draft of the Data Interoperability Specification, incorporating stakeholder requirements and industry best practices.',
     @Robert, NULL, '2025-03-31', 'Critical', 'Completed',
     '2025-03-28T17:00:00-07:00',
     'Specification v1 draft completed and circulated to working group for review. 47 pages covering core data exchange protocols.'),

    -- 8. Recruit new working group members
    (NEWID(), @CommTechStd, @MtgTechKick, @AgTech_WGFormation,
     'Recruit new working group members',
     'Identify and recruit additional members for the Data Interoperability Working Group, targeting industry practitioners with implementation experience.',
     @David, NULL, '2025-02-28', 'Medium', 'Completed',
     '2025-02-25T10:00:00-08:00',
     'Successfully recruited 3 new members from partner organizations.'),

    -- 9. Prepare mid-year board presentation (standalone, no meeting)
    (NEWID(), @CommBoard, NULL, NULL,
     'Prepare mid-year board presentation',
     'Develop comprehensive mid-year board presentation covering strategic progress, financial performance, and updated projections for H2 2026.',
     @Sarah, @Thomas, '2026-04-01', 'High', 'Open',
     NULL, NULL),

    -- 10. Coordinate conference venue booking (Conference committee)
    (NEWID(), @CommConference, NULL, NULL,
     'Coordinate conference venue booking',
     'Research, evaluate, and finalize venue booking for the 2025 Annual Conference including contract negotiation and logistics planning.',
     @Emily, NULL, '2025-09-01', 'High', 'Completed',
     '2025-08-15T12:00:00-04:00',
     'Venue confirmed: Grand Pacific Convention Center. Contract signed for October 15-17, 2025.');

PRINT 'Inserted 10 Action Items.';


-- ============================================================================
-- STEP 9: Artifacts (8)
-- ============================================================================

DECLARE @ArtBrdQ4Minutes   UNIQUEIDENTIFIER = NEWID(),
        @ArtBrdQ1Minutes   UNIQUEIDENTIFIER = NEWID(),
        @ArtBudget2026     UNIQUEIDENTIFIER = NEWID(),
        @ArtBrdQ4Agenda    UNIQUEIDENTIFIER = NEWID(),
        @ArtFinPresentation UNIQUEIDENTIFIER = NEWID(),
        @ArtTechRoadmap    UNIQUEIDENTIFIER = NEWID(),
        @ArtDataInteropSpec UNIQUEIDENTIFIER = NEWID(),
        @ArtMemGrowth      UNIQUEIDENTIFIER = NEWID();

INSERT INTO __mj_BizAppsCommittees.Artifact
    (ID, CommitteeID, MeetingID, AgendaItemID, TaskID, Title, Description,
     ArtifactTypeID, Provider, ExternalID, URL, MimeType, FileSize, UploadedByPersonID)
VALUES
    -- 1. Board Q4 2025 Meeting Minutes
    (@ArtBrdQ4Minutes, @CommBoard, @MtgBoardQ4, NULL, NULL,
     'Board Q4 2025 Meeting Minutes',
     'Official minutes from the Board of Directors Q4 2025 quarterly meeting held on October 15, 2025.',
     @ArtMinutes, 'GoogleDrive', 'doc-board-q4-2025-minutes',
     'https://docs.google.com/document/d/board-q4-2025-minutes',
     'application/vnd.google-apps.document', NULL, @Lisa),

    -- 2. Board Q1 2026 Meeting Minutes
    (@ArtBrdQ1Minutes, @CommBoard, @MtgBoardQ1, NULL, NULL,
     'Board Q1 2026 Meeting Minutes',
     'Official minutes from the Board of Directors Q1 2026 quarterly meeting held on January 21, 2026.',
     @ArtMinutes, 'GoogleDrive', 'doc-board-q1-2026-minutes',
     'https://docs.google.com/document/d/board-q1-2026-minutes',
     'application/vnd.google-apps.document', NULL, @Lisa),

    -- 3. 2026 Annual Budget (Spreadsheet)
    (@ArtBudget2026, @CommFinance, @MtgBoardQ4, @AgBrdQ4_Budget, NULL,
     '2026 Annual Budget',
     'Approved 2026 annual operating budget for the Global Standards Alliance, including departmental breakdowns and quarterly projections.',
     @ArtSpreadsheet, 'GoogleDrive', 'sheet-2026-annual-budget',
     'https://docs.google.com/spreadsheets/d/2026-annual-budget',
     'application/vnd.google-apps.spreadsheet', NULL, @Jennifer),

    -- 4. Board Q4 2025 Agenda
    (@ArtBrdQ4Agenda, @CommBoard, @MtgBoardQ4, NULL, NULL,
     'Board Q4 2025 Agenda',
     'Meeting agenda for the Board of Directors Q4 2025 quarterly meeting.',
     @ArtAgenda, 'GoogleDrive', 'doc-board-q4-2025-agenda',
     'https://docs.google.com/document/d/board-q4-2025-agenda',
     'application/vnd.google-apps.document', NULL, @Lisa),

    -- 5. Q4 Financial Summary Presentation
    (@ArtFinPresentation, @CommFinance, @MtgBoardQ4, @AgBrdQ4_FinReport, NULL,
     'Q4 Financial Summary Presentation',
     'Slide deck presenting Q4 2025 financial performance, budget variance analysis, and year-end projections.',
     @ArtPresentation, 'GoogleDrive', 'slides-q4-financial-summary',
     'https://docs.google.com/presentation/d/q4-financial-summary-2025',
     'application/vnd.google-apps.presentation', NULL, @Jennifer),

    -- 6. 2025 Standards Roadmap
    (@ArtTechRoadmap, @CommTechStd, @MtgTechKick, @AgTech_Roadmap, NULL,
     '2025 Standards Roadmap',
     'Comprehensive roadmap for technology standards development activities throughout 2025, including milestones and deliverables.',
     @ArtDoc, 'GoogleDrive', 'doc-2025-standards-roadmap',
     'https://docs.google.com/document/d/2025-standards-roadmap',
     'application/vnd.google-apps.document', NULL, @David),

    -- 7. Data Interop Spec v1 Draft
    (@ArtDataInteropSpec, @CommTechStd, NULL, NULL, NULL,
     'Data Interop Spec v1 Draft',
     'First complete draft of the Data Interoperability Specification covering core data exchange protocols, schema definitions, and implementation guidelines.',
     @ArtDoc, 'GoogleDrive', 'doc-data-interop-spec-v1',
     'https://docs.google.com/document/d/data-interop-spec-v1-draft',
     'application/vnd.google-apps.document', NULL, @Robert),

    -- 8. Membership Growth Proposal
    (@ArtMemGrowth, @CommBoard, NULL, NULL, NULL,
     'Membership Growth Proposal',
     'Three-phase membership growth proposal with targeted outreach strategies, projected growth metrics, and resource requirements for 2026-2028.',
     @ArtDoc, 'URL', NULL,
     'https://globalstandards.org/internal/membership-growth-2026.pdf',
     'application/pdf', 2457600, @Catherine);

PRINT 'Inserted 8 Artifacts.';


-- ============================================================================
-- STEP 10: Minutes (2)
-- ============================================================================

INSERT INTO __mj_BizAppsCommittees.Minute
    (ID, ArtifactID, ApprovalStatus, ApprovedAt, ApprovedByMeetingID, Notes)
VALUES
    -- Board Q4 2025 Minutes - Approved at the Q1 2026 meeting
    (NEWID(), @ArtBrdQ4Minutes, 'Approved',
     '2026-01-21T14:10:00-05:00',
     @MtgBoardQ1,
     'Minutes approved unanimously at the Q1 2026 Board meeting. No amendments requested.'),

    -- Board Q1 2026 Minutes - Pending approval at Q2 2026 meeting
    (NEWID(), @ArtBrdQ1Minutes, 'PendingApproval',
     NULL,
     NULL,
     'Draft minutes distributed to board members on January 28, 2026. Awaiting formal approval at Q2 2026 meeting.');

PRINT 'Inserted 2 Minute records.';


-- ============================================================================
-- STEP 11: Motions (3)
-- ============================================================================

DECLARE @Motion1_ApproveQ3Min  UNIQUEIDENTIFIER = NEWID(),
        @Motion2_ApproveBudget UNIQUEIDENTIFIER = NEWID(),
        @Motion3_ApproveQ4Min  UNIQUEIDENTIFIER = NEWID();

INSERT INTO __mj_BizAppsCommittees.Motion
    (ID, MeetingID, AgendaItemID, Sequence, Title, Description,
     MovedByMembershipID, SecondedByMembershipID,
     Result, ResultSummary, YesCount, NoCount, AbstainCount, Notes)
VALUES
    -- Motion 1: Approve Q3 2025 Meeting Minutes (Board Q4 meeting)
    (@Motion1_ApproveQ3Min, @MtgBoardQ4, @AgBrdQ4_ApproveMin, 1,
     'Approve Q3 2025 Meeting Minutes',
     'Motion to approve the minutes of the Q3 2025 Board of Directors meeting as distributed.',
     @MemBrd2526_Patricia, @MemBrd2526_Sarah,
     'Passed', 'Passed unanimously', 6, 0, 0,
     'No amendments requested. Minutes approved as distributed.'),

    -- Motion 2: Approve 2026 Annual Budget (Board Q4 meeting)
    (@Motion2_ApproveBudget, @MtgBoardQ4, @AgBrdQ4_Budget, 1,
     'Approve 2026 Annual Budget',
     'Motion to approve the 2026 annual operating budget as presented by the Finance & Audit Committee, totaling $4.2M in projected expenditures.',
     @MemBrd2526_Sarah, @MemBrd2526_Catherine,
     'Passed', 'Passed 5-1-0', 5, 1, 0,
     'One dissenting vote requested additional review of research allocation line item. Chair noted the concern for follow-up.'),

    -- Motion 3: Approve Q4 2025 Meeting Minutes (Board Q1 2026 meeting)
    (@Motion3_ApproveQ4Min, @MtgBoardQ1, @AgBrdQ1_ApproveMin, 1,
     'Approve Q4 2025 Meeting Minutes',
     'Motion to approve the minutes of the Q4 2025 Board of Directors meeting as distributed.',
     @MemBrd2526_Patricia, @MemBrd2526_Catherine,
     'Passed', 'Passed unanimously', 7, 0, 0,
     'No amendments requested. Minutes approved as distributed.');

PRINT 'Inserted 3 Motions.';


-- ============================================================================
-- STEP 12: Votes (~18)
-- ============================================================================

INSERT INTO __mj_BizAppsCommittees.Vote
    (ID, MotionID, MembershipID, VoteValue, Notes)
VALUES
    -- ---- Motion 1: Approve Q3 Minutes (Board Q4 2025 - 6 present voting members) ----
    (NEWID(), @Motion1_ApproveQ3Min, @MemBrd2526_Thomas,    'Yes', NULL),
    (NEWID(), @Motion1_ApproveQ3Min, @MemBrd2526_Patricia,  'Yes', NULL),
    (NEWID(), @Motion1_ApproveQ3Min, @MemBrd2526_Lisa,      'Yes', NULL),
    (NEWID(), @Motion1_ApproveQ3Min, @MemBrd2526_Sarah,     'Yes', NULL),
    (NEWID(), @Motion1_ApproveQ3Min, @MemBrd2526_Catherine, 'Yes', NULL),
    (NEWID(), @Motion1_ApproveQ3Min, @MemBrd2526_Chris,     'Yes', NULL),
    -- James: Absent, Elena: Excused, Amanda: Non-voting advisor

    -- ---- Motion 2: Approve 2026 Budget (Board Q4 2025 - 6 present voting members) ----
    (NEWID(), @Motion2_ApproveBudget, @MemBrd2526_Thomas,    'Yes', NULL),
    (NEWID(), @Motion2_ApproveBudget, @MemBrd2526_Patricia,  'Yes', NULL),
    (NEWID(), @Motion2_ApproveBudget, @MemBrd2526_Lisa,      'Yes', NULL),
    (NEWID(), @Motion2_ApproveBudget, @MemBrd2526_Sarah,     'Yes', NULL),
    (NEWID(), @Motion2_ApproveBudget, @MemBrd2526_Catherine, 'Yes', NULL),
    (NEWID(), @Motion2_ApproveBudget, @MemBrd2526_Chris,     'No',  'Requested additional review of research allocation'),

    -- ---- Motion 3: Approve Q4 Minutes (Board Q1 2026 - 7 present voting members) ----
    (NEWID(), @Motion3_ApproveQ4Min, @MemBrd2526_Thomas,    'Yes', NULL),
    (NEWID(), @Motion3_ApproveQ4Min, @MemBrd2526_Patricia,  'Yes', NULL),
    (NEWID(), @Motion3_ApproveQ4Min, @MemBrd2526_Lisa,      'Yes', NULL),
    (NEWID(), @Motion3_ApproveQ4Min, @MemBrd2526_Sarah,     'Yes', NULL),
    (NEWID(), @Motion3_ApproveQ4Min, @MemBrd2526_James,     'Yes', NULL),
    (NEWID(), @Motion3_ApproveQ4Min, @MemBrd2526_Catherine, 'Yes', NULL),
    (NEWID(), @Motion3_ApproveQ4Min, @MemBrd2526_Chris,     'Yes', NULL);
    -- Elena: Excused, Amanda: Non-voting advisor

PRINT 'Inserted 19 Vote records.';


-- ============================================================================
-- Summary
-- ============================================================================

PRINT '';
PRINT '============================================================';
PRINT ' Committees Sample Data Insert Complete';
PRINT '============================================================';
PRINT ' Committees:    6';
PRINT ' Terms:        16';
PRINT ' Memberships:  ~40';
PRINT ' Meetings:      5';
PRINT ' Agenda Items: ~23';
PRINT ' Attendance:   ~30';
PRINT ' Action Items: 10';
PRINT ' Artifacts:     8';
PRINT ' Minutes:       2';
PRINT ' Motions:       3';
PRINT ' Votes:        19';
PRINT '============================================================';

COMMIT TRANSACTION;
PRINT 'Transaction committed successfully.';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'ERROR: Transaction rolled back.';
    PRINT 'Error Number:  ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Line:    ' + CAST(ERROR_LINE() AS NVARCHAR(10));

    THROW;
END CATCH
