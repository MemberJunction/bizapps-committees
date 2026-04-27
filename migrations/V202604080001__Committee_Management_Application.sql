-- Create the "Committee Management" staff-facing MJ Application
-- This is the administrative counterpart to the member-facing "Committees" app.
-- Staff users get access via UserApplication records.

DECLARE @MgmtAppID UNIQUEIDENTIFIER = NEWID();

INSERT INTO ${flyway:defaultSchema}.Application (
    ID, Name, Description, Icon, Color, Path,
    DefaultNavItems
)
VALUES (
    @MgmtAppID,
    'Committee Management',
    'Staff-facing administrative application for managing all committees, memberships, meetings, and documents',
    'fa-solid fa-clipboard-list',
    '#e64a19',
    'mjcommitteemgmt',
    '[{"Label":"Dashboard","Icon":"fa-solid fa-gauge-high","ResourceType":"Custom","DriverClass":"ManagementDashboardComponent","isDefault":true},{"Label":"Committees","Icon":"fa-solid fa-users-rectangle","ResourceType":"Custom","DriverClass":"ManagementCommitteeListComponent","isDefault":false},{"Label":"Members","Icon":"fa-solid fa-user-group","ResourceType":"Custom","DriverClass":"ManagementMembershipListComponent","isDefault":false},{"Label":"Meetings","Icon":"fa-solid fa-calendar-days","ResourceType":"Custom","DriverClass":"MeetingListComponent","isDefault":false},{"Label":"Action Items","Icon":"fa-solid fa-list-check","ResourceType":"Custom","DriverClass":"ActionItemTrackerComponent","isDefault":false},{"Label":"Documents","Icon":"fa-solid fa-file-lines","ResourceType":"Custom","DriverClass":"DocumentBrowserComponent","isDefault":false}]'
);
GO

-- Copy ApplicationEntity records from Committees app so the new app has access to the same entities
DECLARE @MgmtAppID2 UNIQUEIDENTIFIER = (SELECT ID FROM ${flyway:defaultSchema}.Application WHERE Name = 'Committee Management');

INSERT INTO ${flyway:defaultSchema}.ApplicationEntity (ApplicationID, EntityID, Sequence)
SELECT @MgmtAppID2, ae.EntityID, ae.Sequence
FROM ${flyway:defaultSchema}.ApplicationEntity ae
JOIN ${flyway:defaultSchema}.Application a ON ae.ApplicationID = a.ID
WHERE a.Name = 'Committees';
GO

-- Update the Committees app description to clarify its member-facing role
UPDATE ${flyway:defaultSchema}.Application
SET Description = 'Member and officer participation app for committees, meetings, voting, and task tracking'
WHERE Name = 'Committees';
GO
