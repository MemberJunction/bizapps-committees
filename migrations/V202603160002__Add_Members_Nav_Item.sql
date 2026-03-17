-- Add "Members" nav item to Committees application DefaultNavItems
-- Inserts the MembershipListComponent between Committees and Meetings tabs

UPDATE ${flyway:defaultSchema}.Application
SET DefaultNavItems = '[{"Label":"Dashboard","Icon":"fa-solid fa-gauge-high","ResourceType":"Custom","DriverClass":"CommitteeDashboardComponent","isDefault":true},{"Label":"Committees","Icon":"fa-solid fa-users-rectangle","ResourceType":"Custom","DriverClass":"CommitteeListComponent","isDefault":false},{"Label":"Members","Icon":"fa-solid fa-user-group","ResourceType":"Custom","DriverClass":"MembershipListComponent","isDefault":false},{"Label":"Meetings","Icon":"fa-solid fa-calendar-days","ResourceType":"Custom","DriverClass":"MeetingListComponent","isDefault":false},{"Label":"Action Items","Icon":"fa-solid fa-list-check","ResourceType":"Custom","DriverClass":"ActionItemTrackerComponent","isDefault":false},{"Label":"Documents","Icon":"fa-solid fa-file-lines","ResourceType":"Custom","DriverClass":"DocumentBrowserComponent","isDefault":false}]'
WHERE Name = 'Committees';
GO
