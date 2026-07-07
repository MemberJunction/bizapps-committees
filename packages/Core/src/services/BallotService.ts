/**
 * Ballot + motion voting math for Phase 2 "Govern" (UX v2 screens 03/04).
 *
 * Pure computation over real columns — Ballot, Motion, Vote, Membership/Role.
 * Threshold rules are measured against the committee's voting members
 * (mockup: "Needs 4 Yes (⅔ of voting members) to pass"); in-meeting roll
 * calls use votes cast ("simple majority of votes cast"). Both bases are
 * supported explicitly so callers never guess.
 *
 * Data loading (RunViews over the generated Ballot entity) is wired in the
 * page components/services after CodeGen emits the Ballot entity.
 */

export type BallotThresholdType = 'SimpleMajority' | 'TwoThirds' | 'Unanimous';
export type BallotStatus = 'Open' | 'Closed' | 'Cancelled';
export type VoteValue = 'Yes' | 'No' | 'Abstain' | 'Absent';

/** What the threshold is measured against. */
export type ThresholdBasis = 'VotingMembers' | 'VotesCast';

export interface VoteTally {
    Yes: number;
    No: number;
    Abstain: number;
    /** Voting members who have not voted yet. */
    Outstanding: number;
    /** Yes + No + Abstain. */
    Cast: number;
}

export type MotionOutcome = 'Passed' | 'Failed' | 'Undecided';

export interface OutcomeForecast {
    /** Result if no further votes arrive (Undecided only while votes remain). */
    Outcome: MotionOutcome;
    /** Yes votes needed to pass under the threshold/basis. */
    RequiredYes: number;
    /** True when the outcome can no longer change regardless of remaining votes. */
    IsDecided: boolean;
    /**
     * Human framing of a decided-early outcome, e.g. the mockup's
     * "Threshold met — passes even if remaining vote is No". Null while undecided.
     */
    DecidedReason: 'ThresholdMet' | 'CannotReachThreshold' | 'AllVotesIn' | null;
}

export interface BallotCountdown {
    /** Milliseconds until ClosesAt (negative = past due). */
    MsRemaining: number;
    /** Whole days remaining, floored at 0. */
    DaysRemaining: number;
    /** True when ClosesAt has passed but the ballot is still Open. */
    IsOverdue: boolean;
}

export class BallotService {
    /**
     * Yes votes required to pass.
     * - SimpleMajority: strictly more than half of the basis.
     * - TwoThirds: at least ⅔ of the basis (ceiling).
     * - Unanimous: every counted vote in the basis must be Yes.
     */
    public static RequiredYes(threshold: BallotThresholdType, basisCount: number): number {
        if (basisCount <= 0) return 0;
        switch (threshold) {
            case 'SimpleMajority': return Math.floor(basisCount / 2) + 1;
            case 'TwoThirds': return Math.ceil((basisCount * 2) / 3);
            case 'Unanimous': return basisCount;
        }
    }

    /** Tally votes for one motion against its voting-member roster size. */
    public static ComputeTally(votes: { VoteValue: string }[], votingMemberCount: number): VoteTally {
        const yes = votes.filter(v => v.VoteValue === 'Yes').length;
        const no = votes.filter(v => v.VoteValue === 'No').length;
        const abstain = votes.filter(v => v.VoteValue === 'Abstain').length;
        const cast = yes + no + abstain;
        return {
            Yes: yes,
            No: no,
            Abstain: abstain,
            Cast: cast,
            Outstanding: Math.max(0, votingMemberCount - cast),
        };
    }

    /**
     * Precompute the outcome the way the Live Meeting tally bar does:
     * decided as soon as no remaining combination of votes can change it.
     *
     * For basis 'VotesCast' the final denominator is unknown until all votes
     * are in, so the decision logic uses the best/worst cases over the
     * outstanding votes.
     */
    public static ForecastOutcome(
        tally: VoteTally,
        threshold: BallotThresholdType,
        basis: ThresholdBasis,
        votingMemberCount: number
    ): OutcomeForecast {
        // Unanimous is basis-independent: one No or Abstain sinks it; every
        // voting member must record a Yes.
        if (threshold === 'Unanimous') {
            const required = votingMemberCount;
            if (tally.No > 0 || tally.Abstain > 0) {
                return { Outcome: 'Failed', RequiredYes: required, IsDecided: true, DecidedReason: 'CannotReachThreshold' };
            }
            if (tally.Yes === votingMemberCount && votingMemberCount > 0) {
                return { Outcome: 'Passed', RequiredYes: required, IsDecided: true, DecidedReason: 'AllVotesIn' };
            }
            return { Outcome: 'Undecided', RequiredYes: required, IsDecided: false, DecidedReason: null };
        }

        if (basis === 'VotingMembers') {
            // Fixed denominator: decided the moment the threshold is met or unreachable.
            const required = BallotService.RequiredYes(threshold, votingMemberCount);
            if (tally.Yes >= required) {
                return {
                    Outcome: 'Passed', RequiredYes: required, IsDecided: true,
                    DecidedReason: tally.Outstanding === 0 ? 'AllVotesIn' : 'ThresholdMet',
                };
            }
            if (tally.Yes + tally.Outstanding < required) {
                return {
                    Outcome: 'Failed', RequiredYes: required, IsDecided: true,
                    DecidedReason: tally.Outstanding === 0 ? 'AllVotesIn' : 'CannotReachThreshold',
                };
            }
            return { Outcome: 'Undecided', RequiredYes: required, IsDecided: false, DecidedReason: null };
        }

        // Basis 'VotesCast': the denominator (Yes+No+Abstain) grows as votes
        // arrive, so decide via best/worst cases over the outstanding votes.
        const finalCast = tally.Cast + tally.Outstanding;   // everyone eventually votes
        const requiredIfAllVote = BallotService.RequiredYes(threshold, finalCast);
        // Worst case for passing: every outstanding vote is No — passes anyway?
        if (tally.Yes >= requiredIfAllVote) {
            return {
                Outcome: 'Passed', RequiredYes: requiredIfAllVote, IsDecided: true,
                DecidedReason: tally.Outstanding === 0 ? 'AllVotesIn' : 'ThresholdMet',
            };
        }
        // Best case for passing: every outstanding vote is Yes — still short?
        if (tally.Yes + tally.Outstanding < requiredIfAllVote) {
            return {
                Outcome: 'Failed', RequiredYes: requiredIfAllVote, IsDecided: true,
                DecidedReason: tally.Outstanding === 0 ? 'AllVotesIn' : 'CannotReachThreshold',
            };
        }
        if (tally.Outstanding === 0) {
            const required = BallotService.RequiredYes(threshold, tally.Cast);
            return {
                Outcome: tally.Yes >= required ? 'Passed' : 'Failed',
                RequiredYes: required, IsDecided: true, DecidedReason: 'AllVotesIn',
            };
        }
        return { Outcome: 'Undecided', RequiredYes: requiredIfAllVote, IsDecided: false, DecidedReason: null };
    }

    /** Seal check: choices are hidden while a sealed ballot is not Closed. */
    public static AreChoicesSealed(ballot: { IsSealed: boolean; Status: string }): boolean {
        return ballot.IsSealed && ballot.Status !== 'Closed';
    }

    /** Countdown to the scheduled close, from an injected now. */
    public static ComputeCountdown(closesAt: Date, status: BallotStatus, now: Date): BallotCountdown {
        const ms = closesAt.getTime() - now.getTime();
        return {
            MsRemaining: ms,
            DaysRemaining: Math.max(0, Math.floor(ms / 86_400_000)),
            IsOverdue: ms < 0 && status === 'Open',
        };
    }

    /**
     * Quorum-of-participation check for a ballot: majority of voting members
     * must cast a vote for the result to be procedurally sound. Presented as
     * committee policy (Committee.QuorumRule is a v-next column).
     */
    public static HasParticipationQuorum(tally: VoteTally, votingMemberCount: number): boolean {
        if (votingMemberCount <= 0) return false;
        return tally.Cast > votingMemberCount / 2;
    }
}
