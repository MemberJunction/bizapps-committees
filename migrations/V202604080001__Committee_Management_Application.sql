-- Committee Applications: finalize the member-facing app + create the staff app.
--
-- CodeGen auto-creates the application for this schema named '__mj_Committees'.
-- This migration:
--   1. Renames it to 'Committees' with a friendly description and member-facing
--      nav items (including the Members tab).
--   2. Creates the staff-facing 'Committee Management' application.
--   3. Copies the Committees app's ApplicationEntity rows to the management app.
--
-- Runs after the baseline (which contains the CodeGen app create). Idempotent.

---------------------------------------------------------------------------
-- 1. Rename + configure the member-facing Committees application
--    (CodeGen names it '__mj_Committees'; only rename if not already done)
---------------------------------------------------------------------------
UPDATE ${mjSchema}.Application
SET Name = 'Committees',
    Description = 'Member and officer participation app for committees, meetings, voting, and task tracking',
    DefaultNavItems = '[{"Label":"Dashboard","Icon":"fa-solid fa-gauge-high","ResourceType":"Custom","DriverClass":"CommitteeDashboardComponent","isDefault":true},{"Label":"Committees","Icon":"fa-solid fa-users-rectangle","ResourceType":"Custom","DriverClass":"CommitteeListComponent","isDefault":false},{"Label":"Members","Icon":"fa-solid fa-user-group","ResourceType":"Custom","DriverClass":"MembershipListComponent","isDefault":false},{"Label":"Meetings","Icon":"fa-solid fa-calendar-days","ResourceType":"Custom","DriverClass":"MeetingListComponent","isDefault":false},{"Label":"Action Items","Icon":"fa-solid fa-list-check","ResourceType":"Custom","DriverClass":"ActionItemTrackerComponent","isDefault":false},{"Label":"Documents","Icon":"fa-solid fa-file-lines","ResourceType":"Custom","DriverClass":"DocumentBrowserComponent","isDefault":false}]'
WHERE Name IN ('__mj_Committees', 'Committees') AND Path = 'mjcommittees';
GO

---------------------------------------------------------------------------
-- 2. Create the staff-facing "Committee Management" application
---------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM ${mjSchema}.Application WHERE Name = 'Committee Management')
    INSERT INTO ${mjSchema}.Application (
        ID, Name, Description, Icon, Color, Path, DefaultNavItems
    )
    VALUES (
        NEWID(),
        'Committee Management',
        'Staff-facing administrative application for managing all committees, memberships, meetings, and documents',
        'fa-solid fa-clipboard-list',
        '#e64a19',
        'mjcommitteemgmt',
        '[{"Label":"Dashboard","Icon":"fa-solid fa-gauge-high","ResourceType":"Custom","DriverClass":"ManagementDashboardComponent","isDefault":true},{"Label":"Committees","Icon":"fa-solid fa-users-rectangle","ResourceType":"Custom","DriverClass":"ManagementCommitteeListComponent","isDefault":false},{"Label":"Members","Icon":"fa-solid fa-user-group","ResourceType":"Custom","DriverClass":"ManagementMembershipListComponent","isDefault":false},{"Label":"Meetings","Icon":"fa-solid fa-calendar-days","ResourceType":"Custom","DriverClass":"MeetingListComponent","isDefault":false},{"Label":"Action Items","Icon":"fa-solid fa-list-check","ResourceType":"Custom","DriverClass":"ActionItemTrackerComponent","isDefault":false},{"Label":"Documents","Icon":"fa-solid fa-file-lines","ResourceType":"Custom","DriverClass":"DocumentBrowserComponent","isDefault":false}]'
    );
GO

---------------------------------------------------------------------------
-- 3. Copy ApplicationEntity rows from Committees so the management app
--    has access to the same entities (skip rows already present)
---------------------------------------------------------------------------
DECLARE @MgmtAppID UNIQUEIDENTIFIER = (SELECT ID FROM ${mjSchema}.Application WHERE Name = 'Committee Management');

INSERT INTO ${mjSchema}.ApplicationEntity (ApplicationID, EntityID, Sequence)
SELECT @MgmtAppID, ae.EntityID, ae.Sequence
FROM ${mjSchema}.ApplicationEntity ae
JOIN ${mjSchema}.Application a ON ae.ApplicationID = a.ID
WHERE a.Name = 'Committees'
  AND NOT EXISTS (
      SELECT 1 FROM ${mjSchema}.ApplicationEntity x
      WHERE x.ApplicationID = @MgmtAppID AND x.EntityID = ae.EntityID
  );
GO
