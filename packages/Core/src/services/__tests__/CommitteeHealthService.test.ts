import { describe, expect, it } from 'vitest';
import {
    ActionAging,
    CommitteeHealthService,
    MinutesDebt,
    PortfolioData,
    QuorumForecast,
    TermHygiene,
} from '../CommitteeHealthService';

// Fixture element types derived from the exported PortfolioData shape —
// the individual row interfaces are intentionally not exported.
type CommitteeFixture = PortfolioData['Committees'][number];
type TermFixture = PortfolioData['Terms'][number];
type MembershipFixture = PortfolioData['Memberships'][number];
type RoleFixture = PortfolioData['Roles'][number];
type MeetingFixture = PortfolioData['Meetings'][number];
type MinuteFixture = PortfolioData['Minutes'][number];
type ActionItemFixture = PortfolioData['ActionItems'][number];

/** Fixed "today" mirroring the UX mockup's world. */
const NOW = new Date('2026-04-08T12:00:00Z');

function daysFromNow(days: number): string {
    return new Date(NOW.getTime() + days * 86400000).toISOString();
}

function term(overrides: Partial<TermFixture> = {}): TermFixture {
    return { ID: 'term-1', CommitteeID: 'c-1', Status: 'Active', StartDate: daysFromNow(-300), EndDate: null, ...overrides };
}

function minute(overrides: Partial<MinuteFixture> = {}): MinuteFixture {
    return { ID: 'min-1', MeetingID: 'mtg-1', ApprovalStatus: 'Draft', __mj_CreatedAt: daysFromNow(-5), ...overrides };
}

function actionItem(overrides: Partial<ActionItemFixture> = {}): ActionItemFixture {
    return { ID: 'act-1', CommitteeID: 'c-1', Title: 'Do the thing', DueDate: null, Status: 'Open', AssignedToPerson: null, ...overrides };
}

function quorum(overrides: Partial<QuorumForecast> = {}): QuorumForecast {
    return { Level: 'Low', ExpectedAttendees: 8, Required: 5, VotingMemberCount: 8, ...overrides };
}

function termHygiene(overrides: Partial<TermHygiene> = {}): TermHygiene {
    return { Kind: 'Current', EndDate: null, DaysRemaining: null, HasStagedNextTerm: false, ...overrides };
}

function minutesDebt(overrides: Partial<MinutesDebt> = {}): MinutesDebt {
    return { PendingCount: 0, OldestPendingDays: 0, ...overrides };
}

function actionAging(overrides: Partial<ActionAging> = {}): ActionAging {
    return { OpenCount: 0, OverdueCount: 0, OldestOverdueDays: 0, ...overrides };
}

describe('ComputeTermHygiene', () => {
    it('returns NotStarted when the committee has no terms at all', () => {
        const result = CommitteeHealthService.ComputeTermHygiene([], NOW);
        expect(result.Kind).toBe('NotStarted');
        expect(result.EndDate).toBeNull();
        expect(result.DaysRemaining).toBeNull();
        expect(result.HasStagedNextTerm).toBe(false);
    });

    it('returns NoActiveTerm when only completed/past terms exist', () => {
        const terms: TermFixture[] = [
            term({ ID: 't1', Status: 'Completed', StartDate: daysFromNow(-400), EndDate: daysFromNow(-30) }),
        ];
        const result = CommitteeHealthService.ComputeTermHygiene(terms, NOW);
        expect(result.Kind).toBe('NoActiveTerm');
        expect(result.DaysRemaining).toBeNull();
    });

    it('returns EndingSoon with DaysRemaining 83 for an active term ending in 83 days', () => {
        const end = daysFromNow(83);
        const result = CommitteeHealthService.ComputeTermHygiene([term({ EndDate: end })], NOW);
        expect(result.Kind).toBe('EndingSoon');
        expect(result.DaysRemaining).toBe(83);
        expect(result.EndDate).toEqual(new Date(end));
        expect(result.HasStagedNextTerm).toBe(false);
    });

    it('returns Current with HasStagedNextTerm when an Upcoming term succeeds an expiring one', () => {
        const terms: TermFixture[] = [
            term({ ID: 't1', EndDate: daysFromNow(83) }),
            term({ ID: 't2', Status: 'Upcoming', StartDate: daysFromNow(84), EndDate: daysFromNow(450) }),
        ];
        const result = CommitteeHealthService.ComputeTermHygiene(terms, NOW);
        expect(result.Kind).toBe('Current');
        expect(result.HasStagedNextTerm).toBe(true);
        expect(result.DaysRemaining).toBe(83);
    });

    it('returns Current with null DaysRemaining for an active open-ended term', () => {
        const result = CommitteeHealthService.ComputeTermHygiene([term({ EndDate: null })], NOW);
        expect(result.Kind).toBe('Current');
        expect(result.EndDate).toBeNull();
        expect(result.DaysRemaining).toBeNull();
    });
});

describe('ComputeQuorumForecast', () => {
    it('returns None when there are no voting members', () => {
        const result = CommitteeHealthService.ComputeQuorumForecast(0, null);
        expect(result).toEqual({ Level: 'None', ExpectedAttendees: 0, Required: 0, VotingMemberCount: 0 });
    });

    it('assumes full attendance (Low) when there is no history', () => {
        const result = CommitteeHealthService.ComputeQuorumForecast(8, null);
        expect(result.ExpectedAttendees).toBe(8);
        expect(result.Required).toBe(5);
        expect(result.Level).toBe('Low');
    });

    it('flags High risk when expected attendees fall below required', () => {
        const result = CommitteeHealthService.ComputeQuorumForecast(8, 0.5);
        expect(result.ExpectedAttendees).toBe(4);
        expect(result.Required).toBe(5);
        expect(result.Level).toBe('High');
    });

    it('flags Medium risk when expected is within one of required', () => {
        const result = CommitteeHealthService.ComputeQuorumForecast(8, 0.6875);
        expect(result.ExpectedAttendees).toBe(5.5);
        expect(result.Required).toBe(5);
        expect(result.Level).toBe('Medium');
    });

    it('stays Low when expected comfortably exceeds required', () => {
        const result = CommitteeHealthService.ComputeQuorumForecast(8, 0.875);
        expect(result.ExpectedAttendees).toBe(7);
        expect(result.Level).toBe('Low');
    });
});

describe('ComputeMinutesDebt', () => {
    it('returns zeroes for no pending minutes', () => {
        expect(CommitteeHealthService.ComputeMinutesDebt([], NOW)).toEqual({ PendingCount: 0, OldestPendingDays: 0 });
    });

    it('counts pending minutes and ages the oldest one', () => {
        const minutes: MinuteFixture[] = [
            minute({ ID: 'm1', __mj_CreatedAt: daysFromNow(-77) }),
            minute({ ID: 'm2', ApprovalStatus: 'PendingApproval', __mj_CreatedAt: daysFromNow(-10) }),
        ];
        const result = CommitteeHealthService.ComputeMinutesDebt(minutes, NOW);
        expect(result.PendingCount).toBe(2);
        expect(result.OldestPendingDays).toBe(77);
    });
});

describe('ComputeActionAging', () => {
    it('returns zeroes for no open actions', () => {
        expect(CommitteeHealthService.ComputeActionAging([], NOW)).toEqual({ OpenCount: 0, OverdueCount: 0, OldestOverdueDays: 0 });
    });

    it('separates overdue, not-yet-due, and undated actions', () => {
        const actions: ActionItemFixture[] = [
            actionItem({ ID: 'a1', DueDate: daysFromNow(-12) }),
            actionItem({ ID: 'a2', DueDate: daysFromNow(-3) }),
            actionItem({ ID: 'a3', DueDate: daysFromNow(5) }),
            actionItem({ ID: 'a4', DueDate: null }),
        ];
        const result = CommitteeHealthService.ComputeActionAging(actions, NOW);
        expect(result.OpenCount).toBe(4);
        expect(result.OverdueCount).toBe(2);
        expect(result.OldestOverdueDays).toBe(12);
    });
});

describe('RollupHealth', () => {
    it('returns Dissolved for a dissolved committee regardless of signals', () => {
        const result = CommitteeHealthService.RollupHealth('Dissolved', quorum({ Level: 'High' }), termHygiene(), minutesDebt(), actionAging());
        expect(result).toBe('Dissolved');
    });

    it('returns Pending for a pending committee', () => {
        expect(CommitteeHealthService.RollupHealth('Pending', quorum(), termHygiene(), minutesDebt(), actionAging())).toBe('Pending');
    });

    it('returns Pending when the term hygiene is NotStarted', () => {
        expect(CommitteeHealthService.RollupHealth('Active', quorum(), termHygiene({ Kind: 'NotStarted' }), minutesDebt(), actionAging())).toBe('Pending');
    });

    it('returns AtRisk when there is no active term', () => {
        expect(CommitteeHealthService.RollupHealth('Active', quorum(), termHygiene({ Kind: 'NoActiveTerm' }), minutesDebt(), actionAging())).toBe('AtRisk');
    });

    it('returns AtRisk on High quorum risk', () => {
        expect(CommitteeHealthService.RollupHealth('Active', quorum({ Level: 'High' }), termHygiene(), minutesDebt(), actionAging())).toBe('AtRisk');
    });

    it('returns Watch on Medium quorum risk', () => {
        expect(CommitteeHealthService.RollupHealth('Active', quorum({ Level: 'Medium' }), termHygiene(), minutesDebt(), actionAging())).toBe('Watch');
    });

    it('returns Watch when minutes are pending', () => {
        expect(CommitteeHealthService.RollupHealth('Active', quorum(), termHygiene(), minutesDebt({ PendingCount: 1, OldestPendingDays: 41 }), actionAging())).toBe('Watch');
    });

    it('returns Watch when actions are overdue', () => {
        expect(CommitteeHealthService.RollupHealth('Active', quorum(), termHygiene(), minutesDebt(), actionAging({ OpenCount: 3, OverdueCount: 2, OldestOverdueDays: 9 }))).toBe('Watch');
    });

    it('returns Watch when the term is ending soon', () => {
        expect(CommitteeHealthService.RollupHealth('Active', quorum(), termHygiene({ Kind: 'EndingSoon', DaysRemaining: 83 }), minutesDebt(), actionAging())).toBe('Watch');
    });

    it('returns Healthy when every signal is clear', () => {
        expect(CommitteeHealthService.RollupHealth('Active', quorum(), termHygiene(), minutesDebt(), actionAging())).toBe('Healthy');
    });
});

describe('ComputePortfolio', () => {
    const roles: RoleFixture[] = [
        { ID: 'role-chair', Name: 'Chair', IsVotingRole: true, IsOfficer: true },
        { ID: 'role-member', Name: 'Member', IsVotingRole: true, IsOfficer: false },
        { ID: 'role-staff', Name: 'Staff Liaison', IsVotingRole: false, IsOfficer: false },
    ];

    const committees: CommitteeFixture[] = [
        { ID: 'c-alpha', Name: 'Alpha Committee', Status: 'Active', IsPublic: true, Type: 'Standing', FormationDate: daysFromNow(-400), __mj_CreatedAt: daysFromNow(-400) },
        { ID: 'c-beta', Name: 'Beta Committee', Status: 'Active', IsPublic: true, Type: 'Standing', FormationDate: daysFromNow(-400), __mj_CreatedAt: daysFromNow(-400) },
        { ID: 'c-zeta', Name: 'Zeta Committee', Status: 'Active', IsPublic: false, Type: 'Ad Hoc', FormationDate: daysFromNow(-500), __mj_CreatedAt: daysFromNow(-500) },
        { ID: 'c-omega', Name: 'Omega Committee', Status: 'Dissolved', IsPublic: true, Type: 'Task Force', FormationDate: daysFromNow(-900), __mj_CreatedAt: daysFromNow(-900) },
    ];

    const terms: TermFixture[] = [
        // Alpha: healthy open-ended active term.
        term({ ID: 't-alpha', CommitteeID: 'c-alpha', EndDate: null }),
        // Beta: active term; committee carries pending minutes (Watch).
        term({ ID: 't-beta', CommitteeID: 'c-beta', EndDate: daysFromNow(200) }),
        // Zeta: only a completed term — lapsed (AtRisk).
        term({ ID: 't-zeta', CommitteeID: 'c-zeta', Status: 'Completed', StartDate: daysFromNow(-500), EndDate: daysFromNow(-30) }),
    ];

    const memberships: MembershipFixture[] = [
        { ID: 'mem-1', TermID: 't-alpha', PersonID: 'p1', Status: 'Active', Role: 'Chair', Person: 'Ada Alpha', RoleID: 'role-chair' },
        { ID: 'mem-2', TermID: 't-alpha', PersonID: 'p2', Status: 'Active', Role: 'Member', Person: 'Ben Byte', RoleID: 'role-member' },
        { ID: 'mem-3', TermID: 't-alpha', PersonID: 'p3', Status: 'Active', Role: 'Member', Person: 'Cy Cypher', RoleID: 'role-member' },
        { ID: 'mem-4', TermID: 't-beta', PersonID: 'p4', Status: 'Active', Role: 'Staff Liaison', Person: 'Dee Docs', RoleID: 'role-staff' },
    ];

    const meetings: MeetingFixture[] = [
        { ID: 'mtg-beta-1', CommitteeID: 'c-beta', Committee: 'Beta Committee', Title: 'Beta Q1 Review', StartDateTime: daysFromNow(-45), EndDateTime: daysFromNow(-45), Status: 'Completed', LocationType: 'Virtual', LocationText: null, VideoProvider_Virtual: 'Zoom' },
    ];

    const minutes: MinuteFixture[] = [
        minute({ ID: 'min-beta-1', MeetingID: 'mtg-beta-1', __mj_CreatedAt: daysFromNow(-40) }),
    ];

    const data: PortfolioData = {
        Committees: committees,
        Terms: terms,
        Memberships: memberships,
        Roles: roles,
        Meetings: meetings,
        Attendance: [],
        Minutes: minutes,
        ActionItems: [],
        AgendaItems: [],
    };

    it('sorts rows needs-attention-first: AtRisk, Watch, Healthy, then Dissolved', () => {
        const portfolio = CommitteeHealthService.ComputePortfolio(data, NOW);
        expect(portfolio.Rows.map(r => r.Name)).toEqual([
            'Zeta Committee',
            'Beta Committee',
            'Alpha Committee',
            'Omega Committee',
        ]);
        expect(portfolio.Rows.map(r => r.Health)).toEqual(['AtRisk', 'Watch', 'Healthy', 'Dissolved']);
    });

    it('computes the healthy row from its active term and memberships', () => {
        const portfolio = CommitteeHealthService.ComputePortfolio(data, NOW);
        const alpha = portfolio.Rows.find(r => r.CommitteeID === 'c-alpha');
        expect(alpha).toBeDefined();
        expect(alpha?.Health).toBe('Healthy');
        expect(alpha?.ChairName).toBe('Ada Alpha');
        expect(alpha?.MemberCount).toBe(3);
        expect(alpha?.VotingMemberCount).toBe(3);
        expect(alpha?.Term.Kind).toBe('Current');
        expect(alpha?.Quorum.Level).toBe('Low');
    });

    it('summarizes totals and needs-attention counts', () => {
        const portfolio = CommitteeHealthService.ComputePortfolio(data, NOW);
        expect(portfolio.Summary.TotalCommittees).toBe(4);
        expect(portfolio.Summary.ActiveCommittees).toBe(3);
        expect(portfolio.Summary.NeedsAttentionCount).toBe(2);
        expect(portfolio.Summary.OverdueActions).toBe(0);
        expect(portfolio.Summary.MeetingsThisWeek).toBe(0);
    });

    it('raises a TermLapse attention item for the lapsed committee', () => {
        const portfolio = CommitteeHealthService.ComputePortfolio(data, NOW);
        const lapse = portfolio.Attention.find(a => a.Kind === 'TermLapse');
        expect(lapse).toBeDefined();
        expect(lapse?.CommitteeID).toBe('c-zeta');
        expect(lapse?.Title).toBe('Zeta Committee has no active term');
        // TermLapse sorts ahead of MinutesPending in the attention feed.
        expect(portfolio.Attention[0]?.Kind).toBe('TermLapse');
        expect(portfolio.Attention.some(a => a.Kind === 'MinutesPending' && a.CommitteeID === 'c-beta')).toBe(true);
    });
});
