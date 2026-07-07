import { describe, it, expect } from 'vitest';
import { BallotService, VoteTally } from '../BallotService.js';

/** Shorthand tally builder. */
function tally(yes: number, no: number, abstain: number, outstanding: number): VoteTally {
    return { Yes: yes, No: no, Abstain: abstain, Outstanding: outstanding, Cast: yes + no + abstain };
}

describe('RequiredYes', () => {
    it('simple majority — strictly more than half', () => {
        expect(BallotService.RequiredYes('SimpleMajority', 7)).toBe(4);
        expect(BallotService.RequiredYes('SimpleMajority', 8)).toBe(5);  // half is not enough
        expect(BallotService.RequiredYes('SimpleMajority', 2)).toBe(2);
        expect(BallotService.RequiredYes('SimpleMajority', 1)).toBe(1);
    });

    it('two-thirds — ceiling, matches the mockup "Needs 4 Yes (2/3 of 5 voting members)"', () => {
        expect(BallotService.RequiredYes('TwoThirds', 5)).toBe(4);   // ceil(10/3)
        expect(BallotService.RequiredYes('TwoThirds', 6)).toBe(4);   // exact
        expect(BallotService.RequiredYes('TwoThirds', 9)).toBe(6);
        expect(BallotService.RequiredYes('TwoThirds', 7)).toBe(5);   // ceil(14/3)
    });

    it('unanimous — everyone', () => {
        expect(BallotService.RequiredYes('Unanimous', 5)).toBe(5);
    });

    it('degenerate basis', () => {
        expect(BallotService.RequiredYes('SimpleMajority', 0)).toBe(0);
        expect(BallotService.RequiredYes('TwoThirds', -1)).toBe(0);
    });
});

describe('ComputeTally', () => {
    it('counts values and outstanding against the roster', () => {
        const votes = [
            { VoteValue: 'Yes' }, { VoteValue: 'Yes' }, { VoteValue: 'No' }, { VoteValue: 'Abstain' },
        ];
        const t = BallotService.ComputeTally(votes, 7);
        expect(t).toEqual({ Yes: 2, No: 1, Abstain: 1, Cast: 4, Outstanding: 3 });
    });

    it('ignores unknown values and never reports negative outstanding', () => {
        const t = BallotService.ComputeTally([{ VoteValue: 'Absent' }, { VoteValue: 'Yes' }], 1);
        expect(t.Yes).toBe(1);
        expect(t.Cast).toBe(1);         // Absent is not a cast choice
        expect(t.Outstanding).toBe(0);
    });
});

describe('ForecastOutcome — VotesCast basis (in-meeting roll call)', () => {
    it('mockup scenario: 5Y-1N, 1 outstanding of 7 — passes even if remaining vote is No', () => {
        const f = BallotService.ForecastOutcome(tally(5, 1, 0, 1), 'SimpleMajority', 'VotesCast', 7);
        expect(f.Outcome).toBe('Passed');
        expect(f.IsDecided).toBe(true);
        expect(f.DecidedReason).toBe('ThresholdMet');
        expect(f.RequiredYes).toBe(4);  // "Passes at 4 of 7 cast"
    });

    it('undecided while the outstanding votes still swing it', () => {
        const f = BallotService.ForecastOutcome(tally(3, 3, 0, 1), 'SimpleMajority', 'VotesCast', 7);
        expect(f.Outcome).toBe('Undecided');
        expect(f.IsDecided).toBe(false);
    });

    it('failed early when even all-Yes outstanding cannot reach threshold', () => {
        const f = BallotService.ForecastOutcome(tally(0, 4, 0, 1), 'SimpleMajority', 'VotesCast', 5);
        expect(f.Outcome).toBe('Failed');
        expect(f.DecidedReason).toBe('CannotReachThreshold');
    });

    it('all votes in — decided on the actual cast denominator', () => {
        const f = BallotService.ForecastOutcome(tally(3, 2, 2, 0), 'SimpleMajority', 'VotesCast', 7);
        expect(f.RequiredYes).toBe(4);  // majority of 7 cast (abstains count in the denominator)
        expect(f.Outcome).toBe('Failed');
        expect(f.DecidedReason).toBe('AllVotesIn');
    });
});

describe('ForecastOutcome — VotingMembers basis (e-ballots)', () => {
    it('two-thirds of 5 voting members needs 4; 3 yes with 2 outstanding is undecided', () => {
        const f = BallotService.ForecastOutcome(tally(3, 0, 0, 2), 'TwoThirds', 'VotingMembers', 5);
        expect(f.RequiredYes).toBe(4);
        expect(f.Outcome).toBe('Undecided');
    });

    it('passes the moment the 4th yes lands, votes still outstanding', () => {
        const f = BallotService.ForecastOutcome(tally(4, 0, 0, 1), 'TwoThirds', 'VotingMembers', 5);
        expect(f.Outcome).toBe('Passed');
        expect(f.DecidedReason).toBe('ThresholdMet');
    });

    it('fails early when outstanding yes votes cannot reach the bar', () => {
        const f = BallotService.ForecastOutcome(tally(1, 3, 0, 1), 'TwoThirds', 'VotingMembers', 5);
        expect(f.Outcome).toBe('Failed');
        expect(f.DecidedReason).toBe('CannotReachThreshold');
    });

    it('abstentions burn ballots against a fixed denominator', () => {
        // 5 voting members, 2 abstain: only 3 possible yes < required 4.
        const f = BallotService.ForecastOutcome(tally(2, 0, 2, 1), 'TwoThirds', 'VotingMembers', 5);
        expect(f.Outcome).toBe('Failed');
    });
});

describe('ForecastOutcome — Unanimous', () => {
    it('a single No sinks it immediately', () => {
        const f = BallotService.ForecastOutcome(tally(3, 1, 0, 1), 'Unanimous', 'VotingMembers', 5);
        expect(f.Outcome).toBe('Failed');
        expect(f.IsDecided).toBe(true);
    });

    it('an Abstain also breaks unanimity', () => {
        const f = BallotService.ForecastOutcome(tally(4, 0, 1, 0), 'Unanimous', 'VotingMembers', 5);
        expect(f.Outcome).toBe('Failed');
    });

    it('undecided until the last yes is in', () => {
        expect(BallotService.ForecastOutcome(tally(4, 0, 0, 1), 'Unanimous', 'VotingMembers', 5).Outcome).toBe('Undecided');
        const done = BallotService.ForecastOutcome(tally(5, 0, 0, 0), 'Unanimous', 'VotingMembers', 5);
        expect(done.Outcome).toBe('Passed');
        expect(done.DecidedReason).toBe('AllVotesIn');
    });

    it('an empty committee cannot pass anything', () => {
        expect(BallotService.ForecastOutcome(tally(0, 0, 0, 0), 'Unanimous', 'VotingMembers', 0).Outcome).toBe('Undecided');
    });
});

describe('AreChoicesSealed', () => {
    it('sealed while open, unsealed at close, never sealed when IsSealed=false', () => {
        expect(BallotService.AreChoicesSealed({ IsSealed: true, Status: 'Open' })).toBe(true);
        expect(BallotService.AreChoicesSealed({ IsSealed: true, Status: 'Closed' })).toBe(true);   // secret ballots stay secret
        expect(BallotService.AreChoicesSealed({ IsSealed: false, Status: 'Open' })).toBe(false);
        expect(BallotService.AreChoicesSealed({ IsSealed: true, Status: 'Cancelled' })).toBe(true);
    });
});

describe('ComputeCountdown', () => {
    const now = new Date('2026-04-08T12:00:00Z');

    it('mockup scenario: closes Apr 11 — 3 days out', () => {
        const c = BallotService.ComputeCountdown(new Date('2026-04-11T22:00:00Z'), 'Open', now);
        expect(c.DaysRemaining).toBe(3);
        expect(c.IsOverdue).toBe(false);
    });

    it('overdue only while still open', () => {
        const past = new Date('2026-04-07T12:00:00Z');
        expect(BallotService.ComputeCountdown(past, 'Open', now).IsOverdue).toBe(true);
        expect(BallotService.ComputeCountdown(past, 'Closed', now).IsOverdue).toBe(false);
        expect(BallotService.ComputeCountdown(past, 'Open', now).DaysRemaining).toBe(0);
    });
});

describe('HasParticipationQuorum', () => {
    it('majority of voting members must cast', () => {
        expect(BallotService.HasParticipationQuorum(tally(2, 1, 0, 2), 5)).toBe(true);   // 3 of 5
        expect(BallotService.HasParticipationQuorum(tally(1, 1, 0, 3), 5)).toBe(false);  // 2 of 5
        expect(BallotService.HasParticipationQuorum(tally(2, 2, 0, 4), 8)).toBe(false);  // exactly half fails
        expect(BallotService.HasParticipationQuorum(tally(0, 0, 0, 0), 0)).toBe(false);
    });
});
