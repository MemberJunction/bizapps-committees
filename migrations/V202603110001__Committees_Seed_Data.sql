-- Committees App Seed Data
-- Populates lookup tables: Type, Role, ArtifactType
-- Uses hardcoded UUIDs for consistency across environments

---------------------------------------------------------------------------
-- Committee Types (5)
---------------------------------------------------------------------------
INSERT INTO __mj_Committees.Type (ID, Name, Description, IsStandards, DefaultTermMonths, IconClass) VALUES
    ('A1B2C3D4-1111-4000-8000-000000000001', 'Board of Directors', 'The governing board of the organization with fiduciary and strategic oversight responsibilities.', 0, 12, 'fa-solid fa-landmark'),
    ('A1B2C3D4-1111-4000-8000-000000000002', 'Standing Committee', 'A permanent committee with ongoing responsibilities defined by the organization bylaws.', 0, 12, 'fa-solid fa-users'),
    ('A1B2C3D4-1111-4000-8000-000000000003', 'Ad Hoc Committee', 'A temporary committee formed to address a specific issue, dissolved upon completion.', 0, NULL, 'fa-solid fa-clock'),
    ('A1B2C3D4-1111-4000-8000-000000000004', 'Workgroup', 'A task-oriented group focused on delivering specific outputs or recommendations.', 0, NULL, 'fa-solid fa-briefcase'),
    ('A1B2C3D4-1111-4000-8000-000000000005', 'Standards Working Group', 'A group responsible for developing, reviewing, and maintaining technical or organizational standards.', 1, NULL, 'fa-solid fa-file-contract');
GO

---------------------------------------------------------------------------
-- Committee Roles (7)
---------------------------------------------------------------------------
INSERT INTO __mj_Committees.Role (ID, Name, Description, IsOfficer, IsVotingRole, Sequence) VALUES
    ('B2C3D4E5-2222-4000-8000-000000000001', 'Chair', 'Presides over meetings, sets agendas, and serves as the primary spokesperson for the committee.', 1, 1, 10),
    ('B2C3D4E5-2222-4000-8000-000000000002', 'Vice Chair', 'Assists the Chair and presides in their absence. May lead specific initiatives or subgroups.', 1, 1, 20),
    ('B2C3D4E5-2222-4000-8000-000000000003', 'Secretary', 'Records minutes, manages committee correspondence, and maintains official committee records.', 1, 1, 30),
    ('B2C3D4E5-2222-4000-8000-000000000004', 'Member', 'A full voting member of the committee who participates in discussions and decision-making.', 0, 1, 100),
    ('B2C3D4E5-2222-4000-8000-000000000005', 'Non-Voting Member', 'Participates in discussions but does not have voting rights on committee decisions.', 0, 0, 110),
    ('B2C3D4E5-2222-4000-8000-000000000006', 'Liaison', 'Represents another committee or organization, facilitating cross-committee communication.', 0, 0, 120),
    ('B2C3D4E5-2222-4000-8000-000000000007', 'Advisor', 'Provides subject matter expertise and guidance without formal membership or voting rights.', 0, 0, 130);
GO

---------------------------------------------------------------------------
-- Artifact Types (9)
---------------------------------------------------------------------------
INSERT INTO __mj_Committees.ArtifactType (ID, Name, Description, IconClass) VALUES
    ('C3D4E5F6-3333-4000-8000-000000000001', 'Document', 'General document such as a report, policy draft, or reference material.', 'fa-solid fa-file'),
    ('C3D4E5F6-3333-4000-8000-000000000002', 'Spreadsheet', 'Spreadsheet or structured data file used for analysis, budgets, or tracking.', 'fa-solid fa-file-excel'),
    ('C3D4E5F6-3333-4000-8000-000000000003', 'Presentation', 'Slide deck or presentation used for briefings, proposals, or reports.', 'fa-solid fa-file-powerpoint'),
    ('C3D4E5F6-3333-4000-8000-000000000004', 'Minutes', 'Official meeting minutes documenting discussions, decisions, and action items.', 'fa-solid fa-clipboard-check'),
    ('C3D4E5F6-3333-4000-8000-000000000005', 'Agenda', 'Meeting agenda outlining topics, speakers, and time allocations.', 'fa-solid fa-list-check'),
    ('C3D4E5F6-3333-4000-8000-000000000006', 'Recording', 'Audio or video recording of a meeting or presentation.', 'fa-solid fa-video'),
    ('C3D4E5F6-3333-4000-8000-000000000007', 'Transcript', 'Written transcript of a meeting or presentation recording.', 'fa-solid fa-closed-captioning'),
    ('C3D4E5F6-3333-4000-8000-000000000008', 'Image', 'Image, diagram, chart, or other visual asset.', 'fa-solid fa-image'),
    ('C3D4E5F6-3333-4000-8000-000000000009', 'Other', 'Other artifact type not covered by the standard categories.', 'fa-solid fa-file-lines');
GO
