import { describe, expect, it } from 'vitest';
import { TermRenewalService } from '../TermRenewalService';
import { MembershipRow, TermRow } from '../SuccessionService';

const NOW = new Date('2026-07-07T12:00:00Z');

const term = (over: Partial<TermRow>): TermRow => ({
    ID: 't1', CommitteeID: 'c1', Committee: 'Board', Name: '2025-2026',
    StartDate: '2025-07-01', EndDate: '2026-06-30', Status: 'Completed',
    ...over,
});

const member = (over: Partial<MembershipRow>): MembershipRow => ({
    ID: 'm1', TermID: 't1', PersonID: 'p1', Person: 'Ada Person',
    RoleID: 'r1', Role: 'Member', Status: 'Active', RenewalIntent: null,
    ...over,
});

describe('PickPreviousTerm', () => {
    it('picks the latest-ending started term', () => {
        const picked = TermRenewalService.PickPreviousTerm([
            term({ ID: 'old', EndDate: '2025-06-30' }),
            term({ ID: 'new', EndDate: '2026-06-30' }),
        ], NOW);
        expect(picked?.ID).toBe('new');
    });

    it('ignores future terms when a started one exists', () => {
        const picked = TermRenewalService.PickPreviousTerm([
            term({ ID: 'started', EndDate: '2026-06-30' }),
            term({ ID: 'future', StartDate: '2026-08-01', EndDate: '2027-07-31' }),
        ], NOW);
        expect(picked?.ID).toBe('started');
    });

    it('returns null with no terms', () => {
        expect(TermRenewalService.PickPreviousTerm([], NOW)).toBeNull();
    });
});

describe('SuggestNextTerm', () => {
    it('continues the day after a recently lapsed term, same duration', () => {
        const s = TermRenewalService.SuggestNextTerm(term({}), NOW);
        expect(s.StartDate.toISOString().slice(0, 10)).toBe('2026-07-01');
        expect(s.EndDate.toISOString().slice(0, 10)).toBe('2027-06-30');
        expect(s.Status).toBe('Active');   // backdated start already spans today
        expect(s.Name).toBe('2026-2027');
    });

    it('starts today after a long lapse instead of backdating', () => {
        const s = TermRenewalService.SuggestNextTerm(
            term({ StartDate: '2024-07-01', EndDate: '2025-06-30' }), NOW);
        expect(s.StartDate.toISOString().slice(0, 10)).toBe('2026-07-07');
        expect(s.Status).toBe('Active');
    });

    it('suggests Upcoming when renewing before the current term ends', () => {
        const s = TermRenewalService.SuggestNextTerm(
            term({ StartDate: '2026-07-01', EndDate: '2026-10-31', Name: '2026 H2', Status: 'Active' }), NOW);
        expect(s.StartDate.toISOString().slice(0, 10)).toBe('2026-11-01');
        expect(s.Status).toBe('Upcoming');
        expect(s.Name).toBe('2027 H1');
    });

    it('defaults to a one-year term starting today for a new committee', () => {
        const s = TermRenewalService.SuggestNextTerm(null, NOW);
        expect(s.StartDate.toISOString().slice(0, 10)).toBe('2026-07-07');
        expect(s.EndDate.toISOString().slice(0, 10)).toBe('2027-07-07');
        expect(s.Status).toBe('Active');
    });
});

describe('NextName', () => {
    const start = new Date('2026-07-01');
    const end = new Date('2027-06-30');
    it('increments year ranges', () => {
        expect(TermRenewalService.NextName('2025-2026', start, end)).toBe('2026-2027');
    });
    it('rolls half-years across the boundary', () => {
        expect(TermRenewalService.NextName('2026 H1', start, end)).toBe('2026 H2');
        expect(TermRenewalService.NextName('2026 H2', new Date('2026-11-01'), end)).toBe('2027 H1');
    });
    it('anchors years to the dates when the previous name is stale', () => {
        expect(TermRenewalService.NextName('2025 H1', start, end)).toBe('2026 H2');
        expect(TermRenewalService.NextName('2019-2020', start, end)).toBe('2026-2027');
    });
    it('increments an embedded single year', () => {
        expect(TermRenewalService.NextName('FY2026 Term', start, end)).toBe('FY2027 Term');
    });
    it('falls back to the date span', () => {
        expect(TermRenewalService.NextName('Founding Cohort', start, end)).toBe('2026-2027');
    });
});

describe('BuildCarryPlan', () => {
    it('maps intents to decisions with reasons', () => {
        const plan = TermRenewalService.BuildCarryPlan([
            member({ ID: 'yes', RenewalIntent: 'Yes' }),
            member({ ID: 'no', RenewalIntent: 'No' }),
            member({ ID: 'und', RenewalIntent: 'Undecided' }),
            member({ ID: 'nul', RenewalIntent: null }),
            member({ ID: 'sus', RenewalIntent: 'Yes', Status: 'Suspended' }),
        ]);
        const byID = new Map(plan.map(r => [r.MembershipID, r]));
        expect(byID.get('yes')?.Decision).toBe('carry');
        expect(byID.get('no')?.Decision).toBe('drop');
        expect(byID.get('und')?.Decision).toBe('carry-unconfirmed');
        expect(byID.get('und')?.Reason).toBe('Answered: undecided');
        expect(byID.get('nul')?.Decision).toBe('carry-unconfirmed');
        expect(byID.get('nul')?.Reason).toBe('Never asked');
        expect(byID.get('sus')?.Decision).toBe('drop');
    });
});
