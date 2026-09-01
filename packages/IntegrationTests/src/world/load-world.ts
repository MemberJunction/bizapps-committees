/**
 * Commit COM-WORLD through BaseEntity so Explorer has a living governance book.
 *
 * Dates are relative to UTC today. Re-runs upsert by Description marker (committees)
 * or FirstName+LastName (people). Never the throwaway Demos/*.sql INSERT script.
 */
import type { IntegrationCheckContext } from '@memberjunction/testing-integration/registry';
import { Assert } from '@memberjunction/testing-integration/registry';
import {
    E_AGENDA,
    E_ATTENDANCE,
    E_BALLOT,
    E_COMMITTEE,
    E_MEETING,
    E_MEMBERSHIP,
    E_MINUTE,
    E_MOTION,
    E_ORGANIZATION,
    E_PERSON,
    E_ROLE,
    E_TERM,
    E_TYPE,
    E_VOTE,
    EntityOf,
    FindId,
    FindRows,
    LoadExisting,
    Quote,
    RequireSave,
    UpcomingWeekday,
    UtcDay,
    WorldAvatarURL,
    WorldDescription,
    WorldFilter,
} from '../fixture.js';
import { SetWorld, type WorldIds } from './world.js';

const WORLD_EMAIL = 'com-world.test';

type SeatRole = 'chair' | 'vice' | 'secretary' | 'member';

const PEOPLE: ReadonlyArray<{ key: string; first: string; last: string; title: string; email: string }> = [
    { key: 'priya', first: 'Priya', last: 'Shah', title: 'CFO', email: `priya.shah@${WORLD_EMAIL}` },
    { key: 'alex', first: 'Alex', last: 'Chen', title: 'Controller', email: `alex.chen@${WORLD_EMAIL}` },
    { key: 'marcus', first: 'Marcus', last: 'Lee', title: 'General Counsel', email: `marcus.lee@${WORLD_EMAIL}` },
    { key: 'dana', first: 'Dana', last: 'Ortiz', title: 'Internal Audit Director', email: `dana.ortiz@${WORLD_EMAIL}` },
    { key: 'jordan', first: 'Jordan', last: 'Hale', title: 'VP Membership', email: `jordan.hale@${WORLD_EMAIL}` },
    { key: 'sam', first: 'Sam', last: 'Rivera', title: 'Board Member', email: `sam.rivera@${WORLD_EMAIL}` },
    { key: 'casey', first: 'Casey', last: 'Ng', title: 'Board Member', email: `casey.ng@${WORLD_EMAIL}` },
    { key: 'riley', first: 'Riley', last: 'Brooks', title: 'Board Member', email: `riley.brooks@${WORLD_EMAIL}` },
    { key: 'morgan', first: 'Morgan', last: 'Ellis', title: 'Board Member', email: `morgan.ellis@${WORLD_EMAIL}` },
    { key: 'taylor', first: 'Taylor', last: 'Kim', title: 'Board Member', email: `taylor.kim@${WORLD_EMAIL}` },
    { key: 'jamie', first: 'Jamie', last: 'Walsh', title: 'Board Member', email: `jamie.walsh@${WORLD_EMAIL}` },
    { key: 'dev', first: 'Devon', last: 'Patel', title: 'Program Director', email: `devon.patel@${WORLD_EMAIL}` },
    { key: 'elena', first: 'Elena', last: 'Voss', title: "Children's Librarian", email: `elena.voss@${WORLD_EMAIL}` },
    { key: 'nora', first: 'Nora', last: 'Calhoun', title: 'Director', email: `nora.calhoun@${WORLD_EMAIL}` },
    { key: 'owen', first: 'Owen', last: 'Park', title: 'Trustee', email: `owen.park@${WORLD_EMAIL}` },
    { key: 'lea', first: 'Lea', last: 'Okonkwo', title: 'Trustee', email: `lea.okonkwo@${WORLD_EMAIL}` },
    { key: 'frank', first: 'Frank', last: 'Ibarra', title: 'Trustee', email: `frank.ibarra@${WORLD_EMAIL}` },
    { key: 'gita', first: 'Gita', last: 'Raman', title: 'Trustee', email: `gita.raman@${WORLD_EMAIL}` },
    { key: 'henry', first: 'Henry', last: 'Cho', title: 'Trustee', email: `henry.cho@${WORLD_EMAIL}` },
    { key: 'iris', first: 'Iris', last: 'Bennett', title: 'Trustee', email: `iris.bennett@${WORLD_EMAIL}` },
    { key: 'nico', first: 'Nico', last: 'Alvarez', title: 'Trustee', email: `nico.alvarez@${WORLD_EMAIL}` },
    { key: 'sasha', first: 'Sasha', last: 'Petrov', title: 'Trustee', email: `sasha.petrov@${WORLD_EMAIL}` },
    { key: 'quinn', first: 'Quinn', last: 'Delgado', title: 'Trustee', email: `quinn.delgado@${WORLD_EMAIL}` },
    { key: 'blake', first: 'Blake', last: 'Nguyen', title: 'Trustee', email: `blake.nguyen@${WORLD_EMAIL}` },
    { key: 'robin', first: 'Robin', last: 'Shaw', title: 'Public Health Advisor', email: `robin.shaw@${WORLD_EMAIL}` },
    { key: 'pat', first: 'Pat', last: 'Iyer', title: 'Operations Lead', email: `pat.iyer@${WORLD_EMAIL}` },
    { key: 'ruth', first: 'Ruth', last: 'Adeleke', title: 'Abstract Chair', email: `ruth.adeleke@${WORLD_EMAIL}` },
    { key: 'mina', first: 'Mina', last: 'Choi', title: 'Reviewer', email: `mina.choi@${WORLD_EMAIL}` },
    { key: 'paul', first: 'Paul', last: 'Okeke', title: 'Reviewer', email: `paul.okeke@${WORLD_EMAIL}` },
    { key: 'yara', first: 'Yara', last: 'Said', title: 'Reviewer', email: `yara.said@${WORLD_EMAIL}` },
    { key: 'theo', first: 'Theo', last: 'Brandt', title: 'Reviewer', email: `theo.brandt@${WORLD_EMAIL}` },
    { key: 'lin', first: 'Lin', last: 'Zhao', title: 'Reviewer', email: `lin.zhao@${WORLD_EMAIL}` },
    { key: 'cole', first: 'Cole', last: 'Mendez', title: 'Reviewer', email: `cole.mendez@${WORLD_EMAIL}` },
    { key: 'ada', first: 'Ada', last: 'Lovelace', title: 'Editor in Chief', email: `ada.lovelace@${WORLD_EMAIL}` },
    { key: 'alan', first: 'Alan', last: 'Turing', title: 'Faculty', email: `alan.turing@${WORLD_EMAIL}` },
];

/** July–June board windows. 11 seats each; consecutive terms overlap but are not identical. */
const BOARD_WINDOWS: ReadonlyArray<{
    key: string;
    name: string;
    startYear: number;
    status: 'Active' | 'Completed';
    seats: Array<[string, SeatRole]>;
}> = [
    {
        key: 'board2018',
        name: '2018–2020',
        startYear: 2018,
        status: 'Completed',
        seats: [
            ['sam', 'chair'], ['casey', 'member'], ['riley', 'member'], ['morgan', 'member'],
            ['taylor', 'member'], ['jamie', 'member'], ['nora', 'member'], ['owen', 'member'],
            ['lea', 'member'], ['frank', 'member'], ['gita', 'member'],
        ],
    },
    {
        key: 'board2020',
        name: '2020–2022',
        startYear: 2020,
        status: 'Completed',
        seats: [
            ['casey', 'chair'], ['sam', 'member'], ['riley', 'member'], ['morgan', 'member'],
            ['taylor', 'member'], ['jamie', 'member'], ['nora', 'member'], ['owen', 'member'],
            ['henry', 'member'], ['iris', 'member'], ['nico', 'member'],
        ],
    },
    {
        key: 'board2022',
        name: '2022–2024',
        startYear: 2022,
        status: 'Completed',
        seats: [
            ['riley', 'chair'], ['sam', 'member'], ['casey', 'member'], ['morgan', 'member'],
            ['taylor', 'member'], ['elena', 'member'], ['henry', 'member'], ['iris', 'member'],
            ['nico', 'member'], ['sasha', 'member'], ['quinn', 'member'],
        ],
    },
    {
        key: 'board2024',
        name: '2024–2026',
        startYear: 2024,
        status: 'Completed',
        seats: [
            ['morgan', 'chair'], ['sam', 'member'], ['casey', 'member'], ['riley', 'member'],
            ['elena', 'member'], ['priya', 'member'], ['sasha', 'member'], ['quinn', 'member'],
            ['blake', 'member'], ['gita', 'member'], ['jamie', 'member'],
        ],
    },
    {
        key: 'board2026',
        name: '2026–2028',
        startYear: 2026,
        status: 'Active',
        seats: [
            ['elena', 'chair'], ['casey', 'vice'], ['jamie', 'secretary'], ['sam', 'member'],
            ['riley', 'member'], ['priya', 'member'], ['blake', 'member'], ['gita', 'member'],
            ['nora', 'member'], ['alex', 'member'], ['dana', 'member'],
        ],
    },
];

function BoardDates(startYear: number): { start: Date; end: Date } {
    return {
        start: new Date(Date.UTC(startYear, 6, 1)),
        end: new Date(Date.UTC(startYear + 2, 5, 30)),
    };
}

export async function LoadWorld(ctx: IntegrationCheckContext): Promise<WorldIds> {
    const orgID = await upsertOrg(ctx);
    const people = await upsertPeople(ctx);
    const types = await loadTypes(ctx);
    const roles = await loadRoles(ctx);

    const finance = await upsertCommittee(ctx, 'finance', 'Finance Committee', types.standing, orgID,
        'Oversees financial reporting, the annual budget, and the independent audit liaison.');
    const governance = await upsertCommittee(ctx, 'governance', 'Governance Committee', types.standing, orgID,
        'Bylaws, conflict of interest, board composition, and officer succession.');
    const audit = await upsertCommittee(ctx, 'audit', 'Audit Committee', types.standing, orgID,
        'Internal controls and the annual independent audit. Distinct from Finance.');
    const membership = await upsertCommittee(ctx, 'membership', 'Membership Committee', types.standing, orgID,
        'Recruitment, onboarding, and the annual membership report.');
    const program = await upsertCommittee(ctx, 'program', 'Program Committee', types.standing, orgID,
        'Annual conference and education calendar. Currently healthy.');
    const pubs = await upsertCommittee(ctx, 'publications', 'Publications Workgroup', types.workgroup, orgID,
        'Newsletter and journal. Small workgroup, no open signals.');
    const board = await upsertCommittee(ctx, 'board', 'Board of Directors', types.board, orgID,
        'Governing board. Two-year terms; eleven directors. History back to 2018.',
        new Date(Date.UTC(2018, 6, 1)));

    const termFinance = await upsertTerm(ctx, finance, '2025–2026', UtcDay(-280), UtcDay(200), 'Active');
    const termGov = await upsertTerm(ctx, governance, '2025–2026', UtcDay(-280), UtcDay(42), 'Active');
    const termAudit = await upsertTerm(ctx, audit, '2025–2026', UtcDay(-280), UtcDay(200), 'Active');
    const termMem = await upsertTerm(ctx, membership, '2025–2026', UtcDay(-280), UtcDay(200), 'Active');
    const termProg = await upsertTerm(ctx, program, '2025–2026', UtcDay(-280), UtcDay(200), 'Active');
    const termPubs = await upsertTerm(ctx, pubs, '2025–2026', UtcDay(-200), UtcDay(160), 'Active');

    const mFin = await seedRoster(ctx, termFinance, people, roles, [
        ['priya', 'chair'], ['alex', 'member'], ['sam', 'member'], ['casey', 'member'],
        ['riley', 'member'], ['morgan', 'member'], ['taylor', 'member'],
    ], { start: UtcDay(-280) });
    const mGov = await seedRoster(ctx, termGov, people, roles, [
        ['marcus', 'chair'], ['alex', 'member'], ['jamie', 'member'], ['sam', 'member'],
        ['dana', 'member'], ['jordan', 'member'], ['priya', 'member'], ['elena', 'member'],
    ], { unansweredRenewal: ['alex', 'jamie', 'sam'], start: UtcDay(-280) });
    const mAudit = await seedRoster(ctx, termAudit, people, roles, [
        ['dana', 'chair'], ['priya', 'member'], ['marcus', 'member'], ['casey', 'member'],
        ['riley', 'member'], ['morgan', 'member'], ['taylor', 'member'],
    ], { start: UtcDay(-280) });
    await seedRoster(ctx, termMem, people, roles, [
        ['jordan', 'chair'], ['dev', 'member'], ['jamie', 'member'], ['alex', 'member'],
        ['sam', 'member'], ['casey', 'member'], ['riley', 'member'], ['morgan', 'member'],
        ['taylor', 'member'], ['elena', 'member'],
    ], { start: UtcDay(-280) });
    const mProg = await seedRoster(ctx, termProg, people, roles, [
        ['dev', 'chair'], ['jordan', 'member'], ['jamie', 'member'], ['alex', 'member'], ['elena', 'member'],
    ], { start: UtcDay(-280) });
    const mPubs = await seedRoster(ctx, termPubs, people, roles, [
        ['jamie', 'chair'], ['dev', 'member'], ['casey', 'member'], ['elena', 'member'],
    ], { start: UtcDay(-200) });

    const boardTerms: Record<string, string> = {};
    for (const window of BOARD_WINDOWS) {
        const { start, end } = BoardDates(window.startYear);
        const termID = await upsertTerm(ctx, board, window.name, start, end, window.status);
        boardTerms[window.key] = termID;
        await seedRoster(ctx, termID, people, roles, window.seats, {
            start,
            end,
            status: window.status === 'Active' ? 'Active' : 'Ended',
        });
    }

    const pandemic = await upsertCommittee(
        ctx, 'pandemic', 'Pandemic Response Task Force', types.adHoc, orgID,
        'Stood up in March 2020 for remote operations and member safety. Two terms, then dissolved when the emergency ended.',
        new Date(Date.UTC(2020, 2, 15)),
        'Dissolved',
        new Date(Date.UTC(2021, 11, 31)),
    );
    const termPan2020 = await upsertTerm(ctx, pandemic, '2020', new Date(Date.UTC(2020, 2, 15)), new Date(Date.UTC(2020, 11, 31)), 'Completed');
    const termPan2021 = await upsertTerm(ctx, pandemic, '2021', new Date(Date.UTC(2021, 0, 1)), new Date(Date.UTC(2021, 11, 31)), 'Completed');
    await seedRoster(ctx, termPan2020, people, roles, [
        ['iris', 'chair'], ['nico', 'member'], ['henry', 'member'], ['nora', 'member'],
        ['owen', 'member'], ['robin', 'member'], ['pat', 'member'],
    ], { start: new Date(Date.UTC(2020, 2, 15)), end: new Date(Date.UTC(2020, 11, 31)), status: 'Ended' });
    await seedRoster(ctx, termPan2021, people, roles, [
        ['nico', 'chair'], ['iris', 'member'], ['henry', 'member'], ['robin', 'member'],
        ['lea', 'member'], ['frank', 'member'], ['gita', 'member'],
    ], { start: new Date(Date.UTC(2021, 0, 1)), end: new Date(Date.UTC(2021, 11, 31)), status: 'Ended' });

    const abstracts = await upsertCommittee(
        ctx, 'abstracts', 'Abstract Review Committee', types.standing, orgID,
        'Peer review of conference abstracts. Rotating reviewers; two-year terms.',
        new Date(Date.UTC(2023, 6, 1)),
    );
    const termAbsPrev = await upsertTerm(ctx, abstracts, '2023–2024', new Date(Date.UTC(2023, 6, 1)), new Date(Date.UTC(2024, 5, 30)), 'Completed');
    const termAbs = await upsertTerm(ctx, abstracts, '2025–2026', UtcDay(-200), UtcDay(160), 'Active');
    await seedRoster(ctx, termAbsPrev, people, roles, [
        ['ada', 'chair'], ['alan', 'member'], ['mina', 'member'], ['paul', 'member'],
        ['yara', 'member'], ['elena', 'member'],
    ], { start: new Date(Date.UTC(2023, 6, 1)), end: new Date(Date.UTC(2024, 5, 30)), status: 'Ended' });
    const mAbs = await seedRoster(ctx, termAbs, people, roles, [
        ['ruth', 'chair'], ['mina', 'member'], ['paul', 'member'], ['theo', 'member'],
        ['lin', 'member'], ['cole', 'member'], ['ada', 'member'], ['yara', 'member'],
    ], { start: UtcDay(-200) });

    const thu = UpcomingWeekday(4, 19, 1); // Thursday 19:00 UTC ~ 3pm ET
    const wed = UpcomingWeekday(3, 16, 1);
    const financePast = new Date(Date.UTC(UtcDay(-80).getUTCFullYear(), UtcDay(-80).getUTCMonth(), UtcDay(-80).getUTCDate(), 19, 0, 0));

    const meetFinPast = await upsertMeeting(ctx, finance, 'finance-jun', 'Q1 close review', financePast, 90, 'Completed', 'Virtual');
    const meetFinThu = await upsertMeeting(ctx, finance, 'finance-thu', 'Q2 close', thu, 90, 'Scheduled', 'Virtual');
    const meetAuditThu = await upsertMeeting(ctx, audit, 'audit-thu', 'Internal controls walkthrough', new Date(thu.getTime() + 90 * 60_000), 75, 'Scheduled', 'Hybrid');
    const meetMemWed = await upsertMeeting(ctx, membership, 'membership-wed', 'Fall recruitment working session', wed, 60, 'Scheduled', 'Virtual');
    const meetGovPast = await upsertMeeting(ctx, governance, 'governance-aug', 'Bylaws working session', UtcDay(-35), 90, 'Completed', 'Virtual');
    const meetBoardPast = await upsertMeeting(ctx, board, 'board-june', 'Annual board meeting', UtcDay(-70), 180, 'Completed', 'InPerson');
    const meetProgPostpone = await upsertMeeting(ctx, program, 'program-postponed', 'Site visit dry-run', UtcDay(10), 120, 'Postponed', 'Hybrid');
    const meetPubsCancel = await upsertMeeting(ctx, pubs, 'pubs-cancelled', 'Printer walkthrough', UtcDay(-12), 60, 'Cancelled', 'InPerson');
    const meetAbsPast = await upsertMeeting(ctx, abstracts, 'abstracts-may', 'Round 1 scoring', UtcDay(-50), 90, 'Completed', 'Virtual');
    const meetAbsNext = await upsertMeeting(ctx, abstracts, 'abstracts-next', 'Round 2 calibration', UpcomingWeekday(2, 17, 3), 75, 'Scheduled', 'InPerson');
    const meetPan2020 = await upsertMeeting(ctx, pandemic, 'pandemic-kickoff', 'Remote-ops kickoff', new Date(Date.UTC(2020, 3, 8, 18, 0, 0)), 60, 'Completed', 'Virtual');
    const meetPan2021 = await upsertMeeting(ctx, pandemic, 'pandemic-sunset', 'Sunset and lessons learned', new Date(Date.UTC(2021, 10, 12, 18, 0, 0)), 90, 'Completed', 'Hybrid');
    const meetFinProgress = await upsertMeeting(ctx, finance, 'finance-live', 'Budget amendment working session', UpcomingWeekday(2, 15, 1), 90, 'InProgress', 'Virtual');

    await upsertAgenda(ctx, meetFinThu, [
        { seq: 1, name: 'Call to order', type: 'Information', mins: 5 },
        { seq: 2, name: 'Q2 close pack', type: 'Report', mins: 25, presenter: people.priya },
        { seq: 3, name: 'Cash forecast', type: 'Discussion', mins: 20, presenter: people.alex },
        { seq: 4, name: 'Approve Q1 minutes', type: 'Vote', mins: 10 },
        { seq: 5, name: 'Adjourn', type: 'Information', mins: 5 },
    ]);
    await upsertAgenda(ctx, meetAuditThu, [
        { seq: 1, name: 'Call to order', type: 'Information', mins: 5 },
        { seq: 2, name: 'Control findings', type: 'Report', mins: 40, presenter: people.dana },
        { seq: 3, name: 'Adjourn', type: 'Information', mins: 5 },
    ]);

    await upsertMinutes(ctx, meetFinPast, 'Draft',
        'Finance Committee met to review Q1 close. Packet incomplete; minutes held as draft pending the chair’s signature.');
    await upsertMinutes(ctx, meetGovPast, 'Approved',
        'Governance Committee adopted the working draft of the conflict-of-interest policy for member review.');
    await upsertMinutes(ctx, meetAbsPast, 'Approved',
        'Abstract Review adopted the double-blind scoring rubric. Calibration notes filed.');
    await upsertMinutes(ctx, meetPan2021, 'Approved',
        'Task force voted to dissolve at year-end. Lessons learned attached.');

    // Audit quorum risk: 4 Expected, 3 Absent of 7.
    const auditMembers = [people.dana, people.priya, people.marcus, people.casey, people.riley, people.morgan, people.taylor];
    await upsertAttendance(ctx, meetAuditThu, auditMembers, 4);
    await upsertAttendanceMix(ctx, meetAbsPast, [
        [people.ruth, 'Present'], [people.mina, 'Present'], [people.paul, 'Excused'],
        [people.theo, 'Present'], [people.lin, 'Partial'], [people.cole, 'Absent'],
        [people.ada, 'Present'], [people.yara, 'Present'],
    ]);
    await upsertAttendanceMix(ctx, meetBoardPast, [
        [people.elena, 'Present'], [people.casey, 'Present'], [people.jamie, 'Present'],
        [people.sam, 'Present'], [people.riley, 'Excused'], [people.priya, 'Present'],
        [people.blake, 'Present'], [people.gita, 'Absent'], [people.nora, 'Present'],
        [people.alex, 'Partial'], [people.dana, 'Present'],
    ]);

    const ballotMotion = await upsertMotion(ctx, governance, mGov.marcus, mGov.priya,
        'Adopt revised conflict-of-interest policy',
        'Between-meeting ballot. Seals this week. Policy circulated after the August working session.');
    const ballot = await upsertBallot(ctx, governance, ballotMotion, mGov.marcus);
    await upsertVote(ctx, ballotMotion, mGov.marcus, 'Yes');
    await upsertVote(ctx, ballotMotion, mGov.priya, 'Yes');

    const finMotion = await upsertMotion(ctx, finance, mFin.priya, mFin.alex,
        'Approve FY27 budget amendment',
        'Closed e-ballot. Simple majority. Split result.',
        'Passed', meetFinPast);
    await upsertBallot(ctx, finance, finMotion, mFin.priya, {
        status: 'Closed',
        threshold: 'SimpleMajority',
        sealed: false,
        opensAt: UtcDay(-40),
        closesAt: UtcDay(-33),
        closedAt: UtcDay(-33),
    });
    await upsertVote(ctx, finMotion, mFin.priya, 'Yes');
    await upsertVote(ctx, finMotion, mFin.alex, 'Yes');
    await upsertVote(ctx, finMotion, mFin.sam, 'Yes');
    await upsertVote(ctx, finMotion, mFin.casey, 'No');
    await upsertVote(ctx, finMotion, mFin.riley, 'Abstain');
    await upsertVote(ctx, finMotion, mFin.morgan, 'Yes');
    await upsertVote(ctx, finMotion, mFin.taylor, 'Yes');

    const absMotion = await upsertMotion(ctx, abstracts, mAbs.ruth, mAbs.ada,
        'Adopt double-blind scoring rubric',
        'Unanimous threshold. Closed.',
        'Passed', meetAbsPast);
    await upsertBallot(ctx, abstracts, absMotion, mAbs.ruth, {
        status: 'Closed',
        threshold: 'Unanimous',
        sealed: false,
        opensAt: UtcDay(-48),
        closesAt: UtcDay(-45),
        closedAt: UtcDay(-45),
    });
    for (const key of ['ruth', 'mina', 'paul', 'theo', 'lin', 'cole', 'ada', 'yara'] as const) {
        await upsertVote(ctx, absMotion, mAbs[key], 'Yes');
    }

    const failMotion = await upsertMotion(ctx, audit, mAudit.dana, mAudit.priya,
        'Engage a second external auditor this cycle',
        'Two-thirds threshold. Did not carry.',
        'Failed');
    await upsertBallot(ctx, audit, failMotion, mAudit.dana, {
        status: 'Closed',
        threshold: 'TwoThirds',
        sealed: false,
        opensAt: UtcDay(-20),
        closesAt: UtcDay(-14),
        closedAt: UtcDay(-14),
    });
    await upsertVote(ctx, failMotion, mAudit.dana, 'Yes');
    await upsertVote(ctx, failMotion, mAudit.priya, 'No');
    await upsertVote(ctx, failMotion, mAudit.marcus, 'No');
    await upsertVote(ctx, failMotion, mAudit.casey, 'No');
    await upsertVote(ctx, failMotion, mAudit.riley, 'Yes');
    await upsertVote(ctx, failMotion, mAudit.morgan, 'No');
    await upsertVote(ctx, failMotion, mAudit.taylor, 'Abstain');

    await upsertMotion(ctx, pubs, mPubs.jamie, mPubs.dev,
        'Retire the print newsletter',
        'Withdrawn after member feedback; no ballot.',
        'Withdrawn');

    await upsertMotion(ctx, program, mProg.dev, mProg.jordan,
        'Move the 2027 conference to a hybrid venue',
        'Tabled until site-visit data is in.',
        'Tabled');

    const world: WorldIds = {
        OrganizationID: orgID,
        People: people,
        Roles: roles,
        Types: types,
        Committees: {
            finance, governance, audit, membership, program, publications: pubs, board,
            pandemic, abstracts,
        },
        Terms: {
            finance: termFinance, governance: termGov, audit: termAudit,
            membership: termMem, program: termProg, publications: termPubs,
            pandemic2020: termPan2020, pandemic2021: termPan2021,
            abstractsPrev: termAbsPrev, abstracts: termAbs,
            ...boardTerms,
        },
        Meetings: {
            financePast: meetFinPast, financeThu: meetFinThu, auditThu: meetAuditThu,
            membershipWed: meetMemWed, governancePast: meetGovPast,
            boardPast: meetBoardPast, programPostponed: meetProgPostpone,
            pubsCancelled: meetPubsCancel, abstractsPast: meetAbsPast,
            abstractsNext: meetAbsNext, pandemicKickoff: meetPan2020,
            pandemicSunset: meetPan2021, financeLive: meetFinProgress,
        },
    };
    void ballot;
    SetWorld(world);
    return world;
}

async function upsertOrg(ctx: IntegrationCheckContext): Promise<string> {
    const existing = await FindId(ctx, E_ORGANIZATION, `Name = 'Blue Cypress Press'`);
    if (existing) return existing;
    const org = await EntityOf(ctx, E_ORGANIZATION);
    org.NewRecord();
    org.Set('Name', 'Blue Cypress Press');
    org.Set('Status', 'Active');
    await RequireSave(org, 'Blue Cypress Press');
    return String(org.Get('ID'));
}

async function upsertPeople(ctx: IntegrationCheckContext): Promise<Record<string, string>> {
    const ids: Record<string, string> = {};
    for (const p of PEOPLE) {
        const existing =
            (await FindId(ctx, E_PERSON, `Email = '${Quote(p.email)}'`)) ??
            (await FindId(ctx, E_PERSON, `FirstName = '${Quote(p.first)}' AND LastName = '${Quote(p.last)}'`));
        const person = await EntityOf(ctx, E_PERSON);
        if (existing) {
            Assert(await LoadExisting(person, existing), `load person ${p.first} ${p.last}`);
        } else {
            person.NewRecord();
            person.Set('FirstName', p.first);
            person.Set('LastName', p.last);
        }
        person.Set('Title', p.title);
        const currentEmail = String(person.Get('Email') ?? '').trim();
        if (!currentEmail) {
            person.Set('Email', p.email);
        }
        const email = currentEmail || p.email;
        person.Set('PhotoURL', WorldAvatarURL(email));
        person.Set('Status', 'Active');
        await RequireSave(person, `${p.first} ${p.last}`);
        ids[p.key] = String(person.Get('ID'));
    }
    return ids;
}

async function loadTypes(ctx: IntegrationCheckContext): Promise<Record<string, string>> {
    const wanted = [
        { key: 'standing', name: 'Standing Committee' },
        { key: 'adHoc', name: 'Ad Hoc Committee' },
        { key: 'workgroup', name: 'Workgroup' },
        { key: 'board', name: 'Board of Directors' },
    ];
    const ids: Record<string, string> = {};
    for (const t of wanted) {
        ids[t.key] = await upsertNamed(ctx, E_TYPE, t.name, (row) => {
            row.Set('Name', t.name);
        });
    }
    return ids;
}

async function loadRoles(ctx: IntegrationCheckContext): Promise<Record<string, string>> {
    const wanted: Array<{ key: string; name: string; officer: boolean; voting: boolean; seq: number }> = [
        { key: 'chair', name: 'Chair', officer: true, voting: true, seq: 10 },
        { key: 'vice', name: 'Vice Chair', officer: true, voting: true, seq: 20 },
        { key: 'secretary', name: 'Secretary', officer: true, voting: true, seq: 30 },
        { key: 'member', name: 'Member', officer: false, voting: true, seq: 100 },
    ];
    const ids: Record<string, string> = {};
    for (const r of wanted) {
        ids[r.key] = await upsertNamed(ctx, E_ROLE, r.name, (row) => {
            row.Set('Name', r.name);
            row.Set('IsOfficer', r.officer);
            row.Set('IsVotingRole', r.voting);
            row.Set('Sequence', r.seq);
        });
    }
    return ids;
}

async function upsertNamed(
    ctx: IntegrationCheckContext,
    entityName: string,
    name: string,
    shape: (row: Awaited<ReturnType<typeof EntityOf>>) => void,
): Promise<string> {
    const existing = await FindId(ctx, entityName, `Name = '${Quote(name)}'`);
    const row = await EntityOf(ctx, entityName);
    if (existing) {
        Assert(await LoadExisting(row, existing), `load ${entityName} ${name}`);
    } else {
        row.NewRecord();
    }
    shape(row);
    await RequireSave(row, `${entityName} ${name}`);
    return String(row.Get('ID'));
}

async function upsertCommittee(
    ctx: IntegrationCheckContext,
    key: string,
    name: string,
    typeID: string,
    orgID: string,
    rest: string,
    formation?: Date,
    status: 'Active' | 'Dissolved' | 'Inactive' | 'Pending' = 'Active',
    dissolution?: Date,
): Promise<string> {
    const desc = WorldDescription(key, rest);
    const existing = await FindId(ctx, E_COMMITTEE, WorldFilter(key));
    const row = await EntityOf(ctx, E_COMMITTEE);
    if (existing) {
        Assert(await LoadExisting(row, existing), `could not load committee ${key}`);
    } else {
        row.NewRecord();
    }
    row.Set('Name', name);
    row.Set('TypeID', typeID);
    row.Set('OrganizationID', orgID);
    row.Set('Description', desc);
    row.Set('Status', status);
    row.Set('IsPublic', true);
    row.Set('FormationDate', formation ?? UtcDay(-800));
    row.Set('DissolutionDate', dissolution ?? null);
    row.Set('MissionStatement', rest);
    await RequireSave(row, name);
    return String(row.Get('ID'));
}

async function upsertTerm(
    ctx: IntegrationCheckContext,
    committeeID: string,
    name: string,
    start: Date,
    end: Date,
    status: 'Active' | 'Completed' | 'Upcoming',
): Promise<string> {
    const existing = await FindId(ctx, E_TERM, `CommitteeID = '${committeeID}' AND Name = '${Quote(name)}'`);
    const row = await EntityOf(ctx, E_TERM);
    if (existing) {
        Assert(await LoadExisting(row, existing), `could not load term ${name}`);
    } else {
        row.NewRecord();
        row.Set('CommitteeID', committeeID);
        row.Set('Name', name);
    }
    row.Set('StartDate', start);
    row.Set('EndDate', end);
    row.Set('Status', status);
    await RequireSave(row, `term ${name}`);
    return String(row.Get('ID'));
}

async function seedRoster(
    ctx: IntegrationCheckContext,
    termID: string,
    people: Record<string, string>,
    roles: Record<string, string>,
    seats: Array<[string, SeatRole]>,
    opts?: {
        unansweredRenewal?: string[];
        start?: Date;
        end?: Date;
        status?: 'Active' | 'Ended' | 'Pending' | 'Suspended';
    },
): Promise<Record<string, string>> {
    const memberships: Record<string, string> = {};
    const unanswered = new Set(opts?.unansweredRenewal ?? []);
    const status = opts?.status ?? 'Active';
    for (const [personKey, roleKey] of seats) {
        const personID = people[personKey];
        Assert(!!personID, `roster person ${personKey} missing`);
        const roleID = roles[roleKey];
        Assert(!!roleID, `role ${roleKey} missing`);
        const existing = await FindId(ctx, E_MEMBERSHIP, `TermID = '${termID}' AND PersonID = '${personID}'`);
        const row = await EntityOf(ctx, E_MEMBERSHIP);
        if (existing) {
            Assert(await LoadExisting(row, existing), `could not load membership ${personKey}`);
        } else {
            row.NewRecord();
            row.Set('TermID', termID);
            row.Set('PersonID', personID);
        }
        row.Set('RoleID', roleID);
        row.Set('StartDate', opts?.start ?? UtcDay(-280));
        row.Set('EndDate', opts?.end ?? null);
        row.Set('Status', status);
        if (status === 'Ended' && !row.Get('EndReason')) {
            row.Set('EndReason', 'Term completed');
        }
        if (!unanswered.has(personKey)) {
            row.Set('RenewalIntent', status === 'Ended' ? 'No' : 'Yes');
        } else {
            row.Set('RenewalIntent', null);
        }
        await RequireSave(row, `membership ${personKey}`);
        memberships[personKey] = String(row.Get('ID'));
    }
    return memberships;
}

async function upsertMeeting(
    ctx: IntegrationCheckContext,
    committeeID: string,
    key: string,
    name: string,
    start: Date,
    durationMin: number,
    status: 'Scheduled' | 'Completed' | 'Draft' | 'Cancelled' | 'Postponed' | 'InProgress',
    location: 'Virtual' | 'Hybrid' | 'InPerson',
): Promise<string> {
    const desc = WorldDescription(key, name);
    const existing = await FindId(ctx, E_MEETING, `CommitteeID = '${committeeID}' AND Description LIKE '${Quote(WORLD_MARK_KEY(key))}%'`);
    const row = await EntityOf(ctx, E_MEETING);
    if (existing) {
        Assert(await LoadExisting(row, existing), `could not load meeting ${key}`);
    } else {
        row.NewRecord();
        row.Set('CommitteeID', committeeID);
    }
    row.Set('Name', name);
    row.Set('Description', desc);
    row.Set('StartDateTime', start);
    row.Set('EndDateTime', new Date(start.getTime() + durationMin * 60_000));
    row.Set('TimeZone', 'America/New_York');
    row.Set('LocationType', location);
    row.Set('Status', status);
    if (location !== 'InPerson') {
        row.Set('VideoJoinURL', 'https://example.test/zoom/com-world');
    } else {
        row.Set('LocationText', 'Blue Cypress Press, Board Room');
    }
    await RequireSave(row, `meeting ${name}`);
    return String(row.Get('ID'));
}

function WORLD_MARK_KEY(key: string): string {
    return `COM-WORLD:${key}`;
}

async function upsertAgenda(
    ctx: IntegrationCheckContext,
    meetingID: string,
    items: Array<{ seq: number; name: string; type: string; mins: number; presenter?: string }>,
): Promise<void> {
    for (const item of items) {
        const existing = await FindId(ctx, E_AGENDA, `MeetingID = '${meetingID}' AND Sequence = ${item.seq}`);
        const row = await EntityOf(ctx, E_AGENDA);
        if (existing) {
            Assert(await LoadExisting(row, existing), `agenda ${item.seq}`);
        } else {
            row.NewRecord();
            row.Set('MeetingID', meetingID);
            row.Set('Sequence', item.seq);
        }
        row.Set('Name', item.name);
        row.Set('ItemType', item.type);
        row.Set('DurationMinutes', item.mins);
        row.Set('Status', 'Pending');
        if (item.presenter) row.Set('PresenterPersonID', item.presenter);
        await RequireSave(row, `agenda ${item.name}`);
    }
}

async function upsertMinutes(
    ctx: IntegrationCheckContext,
    meetingID: string,
    status: 'Draft' | 'Approved' | 'PendingApproval',
    content: string,
): Promise<void> {
    const existing = await FindId(ctx, E_MINUTE, `MeetingID = '${meetingID}'`);
    const row = await EntityOf(ctx, E_MINUTE);
    if (existing) {
        Assert(await LoadExisting(row, existing), 'minutes');
    } else {
        row.NewRecord();
        row.Set('MeetingID', meetingID);
    }
    row.Set('ApprovalStatus', status);
    row.Set('Content', content);
    if (status === 'Approved') {
        row.Set('ApprovedAt', UtcDay(-30));
    }
    await RequireSave(row, 'minutes');
}

async function upsertAttendance(
    ctx: IntegrationCheckContext,
    meetingID: string,
    personIDs: string[],
    expectedCount: number,
): Promise<void> {
    for (let i = 0; i < personIDs.length; i++) {
        const personID = personIDs[i];
        const existing = await FindId(ctx, E_ATTENDANCE, `MeetingID = '${meetingID}' AND PersonID = '${personID}'`);
        const row = await EntityOf(ctx, E_ATTENDANCE);
        if (existing) {
            Assert(await LoadExisting(row, existing), 'attendance');
        } else {
            row.NewRecord();
            row.Set('MeetingID', meetingID);
            row.Set('PersonID', personID);
        }
        row.Set('AttendanceStatus', i < expectedCount ? 'Expected' : 'Absent');
        await RequireSave(row, 'attendance');
    }
}

async function upsertAttendanceMix(
    ctx: IntegrationCheckContext,
    meetingID: string,
    rows: Array<[string, 'Absent' | 'Excused' | 'Expected' | 'Partial' | 'Present']>,
): Promise<void> {
    for (const [personID, status] of rows) {
        const existing = await FindId(ctx, E_ATTENDANCE, `MeetingID = '${meetingID}' AND PersonID = '${personID}'`);
        const row = await EntityOf(ctx, E_ATTENDANCE);
        if (existing) {
            Assert(await LoadExisting(row, existing), 'attendance');
        } else {
            row.NewRecord();
            row.Set('MeetingID', meetingID);
            row.Set('PersonID', personID);
        }
        row.Set('AttendanceStatus', status);
        await RequireSave(row, 'attendance mix');
    }
}

async function upsertMotion(
    ctx: IntegrationCheckContext,
    committeeID: string,
    movedBy: string,
    secondedBy: string,
    name: string,
    description: string,
    result: 'Failed' | 'Passed' | 'Pending' | 'Tabled' | 'Withdrawn' = 'Pending',
    meetingID?: string,
): Promise<string> {
    const existing = await FindId(ctx, E_MOTION, `Name = '${Quote(name)}'`);
    const row = await EntityOf(ctx, E_MOTION);
    if (existing) {
        Assert(await LoadExisting(row, existing), name);
    } else {
        row.NewRecord();
    }
    row.Set('Name', name);
    row.Set('Description', description);
    row.Set('MeetingID', meetingID ?? null);
    row.Set('Sequence', 1);
    row.Set('MovedByMembershipID', movedBy);
    row.Set('SecondedByMembershipID', secondedBy);
    row.Set('Result', result);
    await RequireSave(row, name);
    void committeeID;
    return String(row.Get('ID'));
}

async function upsertBallot(
    ctx: IntegrationCheckContext,
    committeeID: string,
    motionID: string,
    createdBy: string,
    opts?: {
        status?: 'Cancelled' | 'Closed' | 'Open';
        threshold?: 'SimpleMajority' | 'TwoThirds' | 'Unanimous';
        sealed?: boolean;
        opensAt?: Date;
        closesAt?: Date;
        closedAt?: Date | null;
    },
): Promise<string> {
    const existing = await FindId(ctx, E_BALLOT, `MotionID = '${motionID}'`);
    const row = await EntityOf(ctx, E_BALLOT);
    if (existing) {
        Assert(await LoadExisting(row, existing), 'ballot');
    } else {
        row.NewRecord();
        row.Set('MotionID', motionID);
        row.Set('CommitteeID', committeeID);
    }
    row.Set('OpensAt', opts?.opensAt ?? UtcDay(-1));
    row.Set('ClosesAt', opts?.closesAt ?? UpcomingWeekday(5, 21, 1));
    row.Set('ClosedAt', opts?.closedAt ?? null);
    row.Set('ThresholdType', opts?.threshold ?? 'SimpleMajority');
    row.Set('IsSealed', opts?.sealed ?? true);
    row.Set('Status', opts?.status ?? 'Open');
    row.Set('CreatedByMembershipID', createdBy);
    await RequireSave(row, 'ballot');
    return String(row.Get('ID'));
}

async function upsertVote(
    ctx: IntegrationCheckContext,
    motionID: string,
    membershipID: string,
    value: 'Yes' | 'No' | 'Abstain',
): Promise<void> {
    const existing = await FindId(ctx, E_VOTE, `MotionID = '${motionID}' AND MembershipID = '${membershipID}'`);
    const row = await EntityOf(ctx, E_VOTE);
    if (existing) {
        Assert(await LoadExisting(row, existing), 'vote');
    } else {
        row.NewRecord();
        row.Set('MotionID', motionID);
        row.Set('MembershipID', membershipID);
    }
    row.Set('VoteValue', value);
    await RequireSave(row, 'vote');
}

