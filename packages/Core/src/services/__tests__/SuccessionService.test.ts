import { describe, it, expect } from 'vitest';
import {
    SuccessionService, TermRow, MembershipRow, CompletedMeetingRow, AttendanceRow,
} from '../SuccessionService.js';

/** Frozen clock: matches the demo data era. */
const NOW = new Date('2026-04-08T12:00:00Z');

const BOARD = 'COM-BOARD';
const FINANCE = 'COM-FIN';

function term(id: string, committee: string, name: string, start: string, end: string | null, status: string): TermRow {
    return { ID: id, CommitteeID: committee, Committee: committee === BOARD ? 'Board of Directors' : 'Finance', Name: name, StartDate: start, EndDate: end, Status: status };
}
function member(id: string, termID: string, personID: string, name: string, role: string, intent: MembershipRow['RenewalIntent'] = null): MembershipRow {
    return { ID: id, TermID: termID, PersonID: personID, Person: name, RoleID: 'R1', Role: role, Status: 'Active', RenewalIntent: intent };
}

const TERMS: TermRow[] = [
    term('T-24', BOARD, '2024-25', '2024-07-01', '2025-06-30', 'Completed'),
    term('T-25', BOARD, '2025-26', '2025-07-01', '2026-06-30', 'Active'),
    term('T-FIN', FINANCE, '2025-26', '2025-07-01', '2026-06-30', 'Active'),
];

describe('BuildAxis', () => {
    it('half-year buckets span all terms with padding, today line inside', () => {
        const axis = SuccessionService.BuildAxis(NOW, TERMS);
        expect(axis.Start.getTime()).toBeLessThanOrEqual(new Date('2024-07-01').getTime());
        expect(axis.End.getTime()).toBeGreaterThanOrEqual(new Date('2026-06-30').getTime());
        expect(axis.Buckets[0].Label).toMatch(/^H[12] '2[0-9]$/);
        expect(axis.TodayPct).not.toBeNull();
        expect(axis.TodayPct!).toBeGreaterThan(0);
        expect(axis.TodayPct!).toBeLessThan(100);
    });

    it('axis with no terms still includes today', () => {
        const axis = SuccessionService.BuildAxis(NOW, []);
        expect(axis.TodayPct).not.toBeNull();
        expect(axis.Buckets.length).toBeGreaterThan(0);
    });
});

describe('BuildGanttRows', () => {
    it('one row per person, bars positioned and stated correctly', () => {
        const memberships = [
            member('M1', 'T-24', 'P1', 'Thomas Anderson', 'Chair'),
            member('M2', 'T-25', 'P1', 'Thomas Anderson', 'Chair', 'No'),
            member('M3', 'T-25', 'P2', 'Patricia Williams', 'Vice Chair', 'Yes'),
        ];
        const axis = SuccessionService.BuildAxis(NOW, TERMS);
        const rows = SuccessionService.BuildGanttRows(
            TERMS.filter(t => t.CommitteeID === BOARD), memberships, new Map(), axis, NOW);
        expect(rows).toHaveLength(2);
        const thomas = rows.find(r => r.PersonID === 'P1')!;
        expect(thomas.Bars).toHaveLength(2);
        const past = thomas.Bars.find(b => b.TermID === 'T-24')!;
        const current = thomas.Bars.find(b => b.TermID === 'T-25')!;
        expect(past.State).toBe('past');
        expect(current.State).toBe('expiring');      // ends Jun 30, 83 days from NOW
        expect(past.LeftPct).toBeLessThan(current.LeftPct);
        expect(thomas.RenewalIntent).toBe('No');     // current-term intent wins the row
    });

    it('a term ending well beyond the window is current, not expiring', () => {
        const longTerms = [term('T-LONG', BOARD, '2026-27', '2025-07-01', '2027-06-30', 'Active')];
        const axis = SuccessionService.BuildAxis(NOW, longTerms);
        const rows = SuccessionService.BuildGanttRows(
            longTerms, [member('M1', 'T-LONG', 'P1', 'A', 'Member')], new Map(), axis, NOW);
        expect(rows[0].Bars[0].State).toBe('current');
    });
});

describe('ComputeAttendanceRates', () => {
    const meetings: CompletedMeetingRow[] = [
        { ID: 'MT1', CommitteeID: BOARD, Status: 'Completed', StartDateTime: '2025-10-15' },
        { ID: 'MT2', CommitteeID: BOARD, Status: 'Completed', StartDateTime: '2026-01-21' },
    ];
    it('present + partial count as attended; other committees ignored', () => {
        const attendance: AttendanceRow[] = [
            { MeetingID: 'MT1', PersonID: 'P1', AttendanceStatus: 'Present' },
            { MeetingID: 'MT2', PersonID: 'P1', AttendanceStatus: 'Partial' },
            { MeetingID: 'MT1', PersonID: 'P2', AttendanceStatus: 'Present' },
            { MeetingID: 'MT2', PersonID: 'P2', AttendanceStatus: 'Absent' },
            { MeetingID: 'OTHER', PersonID: 'P2', AttendanceStatus: 'Absent' },
        ];
        const rates = SuccessionService.ComputeAttendanceRates(meetings, attendance);
        expect(rates.get('p1')).toBe(1);
        expect(rates.get('p2')).toBe(0.5);
    });

    it('no attendance rows means no rate (null downstream, never 0%)', () => {
        const rates = SuccessionService.ComputeAttendanceRates(meetings, []);
        expect(rates.has('p1')).toBe(false);
    });
});

describe('ComputePipeline precedence', () => {
    const boardTerms = TERMS.filter(t => t.CommitteeID === BOARD);

    it('Opening > AtRisk > AwaitingAnswer > Returning ordering', () => {
        const memberships = [
            member('M1', 'T-25', 'P1', 'Declines', 'Member', 'No'),
            member('M2', 'T-25', 'P2', 'Ghost', 'Member', null),          // 43% attendance below
            member('M3', 'T-25', 'P3', 'Loyal', 'Member', 'Yes'),
            member('M4', 'T-25', 'P4', 'Silent', 'Member', null),
            member('M5', 'T-25', 'P5', 'Maybe', 'Member', 'Undecided'),
        ];
        const rates = new Map([['p2', 0.43]]);
        const seats = SuccessionService.ComputePipeline(boardTerms, memberships, rates, NOW);
        expect(seats.map(s => s.Status)).toEqual(['Opening', 'AtRisk', 'AwaitingAnswer', 'AwaitingAnswer', 'Returning']);
        expect(seats[0].Reason).toBe('declining renewal');
        expect(seats[1].Reason).toContain('43% attendance');
    });

    it('intent No beats bad attendance (Opening wins)', () => {
        const seats = SuccessionService.ComputePipeline(
            boardTerms, [member('M1', 'T-25', 'P1', 'A', 'Member', 'No')], new Map([['p1', 0.1]]), NOW);
        expect(seats[0].Status).toBe('Opening');
    });

    it('unanswered intent with <=30 days left escalates to AtRisk', () => {
        const lateNow = new Date('2026-06-15T12:00:00Z'); // 15 days before Jun 30 end
        const seats = SuccessionService.ComputePipeline(
            boardTerms, [member('M1', 'T-25', 'P1', 'A', 'Member', null)], new Map(), lateNow);
        expect(seats[0].Status).toBe('AtRisk');
        expect(seats[0].Reason).toContain('days left');
    });

    it('completed terms produce no seats', () => {
        const seats = SuccessionService.ComputePipeline(
            boardTerms, [member('M1', 'T-24', 'P1', 'A', 'Member', 'Yes')], new Map(), NOW);
        expect(seats).toHaveLength(0);
    });
});

describe('ComputeLens', () => {
    it('lapsed committees sort first, then expiring by days, renewed marked', () => {
        const terms: TermRow[] = [
            term('T1', BOARD, '2025-26', '2025-07-01', '2026-06-30', 'Active'),       // expiring (83d)
            term('T2', 'COM-LAPSED', 'old', '2024-01-01', '2025-06-30', 'Completed'), // lapsed
            term('T3', FINANCE, '2025-26', '2025-07-01', '2026-06-30', 'Active'),
            term('T4', FINANCE, '2026-27', '2026-07-01', '2027-06-30', 'Upcoming'),   // staged → renewed
        ];
        const lens = SuccessionService.ComputeLens(terms, NOW);
        expect(lens[0].State).toBe('Lapsed');
        expect(lens.find(c => c.CommitteeID === BOARD)!.State).toBe('Expiring');
        expect(lens.find(c => c.CommitteeID === FINANCE)!.State).toBe('Renewed');
        expect(lens.find(c => c.CommitteeID === BOARD)!.DaysRemaining).toBe(83); // ceil(Jun 30 00:00 − Apr 8 12:00)
    });

    it('a term far from expiry is Current', () => {
        const terms = [term('T1', BOARD, 'long', '2025-07-01', '2027-06-30', 'Active')];
        const lens = SuccessionService.ComputeLens(terms, NOW);
        expect(lens[0].State).toBe('Current');
    });
});
