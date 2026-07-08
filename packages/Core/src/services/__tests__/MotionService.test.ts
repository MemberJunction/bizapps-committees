import { describe, it, expect } from 'vitest';
import { MotionService, MotionRow, MeetingRefRow, MembershipRefRow, VoteRow } from '../MotionService.js';

const MEETINGS: MeetingRefRow[] = [
    { ID: 'MTG-1', CommitteeID: 'COM-1', Committee: 'Board of Directors', Name: 'Q4 2025 Meeting', StartDateTime: new Date('2025-10-15T18:00:00Z') },
];

const MEMBERSHIPS: MembershipRefRow[] = [
    { ID: 'MEM-1', PersonID: 'P1', Person: 'Sarah Chen', Role: 'Member' },
    { ID: 'MEM-2', PersonID: 'P2', Person: "Catherine O'Brien", Role: 'Member' },
    { ID: 'MEM-3', PersonID: 'P3', Person: 'Christopher Lee', Role: 'Member' },
];

function motion(overrides: Partial<MotionRow>): MotionRow {
    return {
        ID: 'MOT-1', MeetingID: 'MTG-1', AgendaItemID: null,
        Name: 'Approve 2026 Annual Budget', Description: null,
        MovedByMembershipID: 'MEM-1', SecondedByMembershipID: 'MEM-2',
        Result: 'Passed', ResultSummary: null,
        YesCount: null, NoCount: null, AbstainCount: null,
        Notes: null, __mj_CreatedAt: new Date('2025-10-15T19:00:00Z'),
        ...overrides,
    };
}

describe('BuildRegister', () => {
    it('joins meeting/committee/people names case-insensitively', () => {
        const data = MotionService.BuildRegister(
            [motion({ MovedByMembershipID: 'mem-1', MeetingID: 'mtg-1' })], MEETINGS, MEMBERSHIPS, []);
        const row = data.Rows[0];
        expect(row.CommitteeName).toBe('Board of Directors');
        expect(row.MeetingTitle).toBe('Q4 2025 Meeting');
        expect(row.MovedByName).toBe('Sarah Chen');
        expect(row.SecondedByName).toBe("Catherine O'Brien");
        expect(row.IsBallotMotion).toBe(false);
    });

    it('meeting-less motions are ballot motions with no committee-from-meeting', () => {
        const data = MotionService.BuildRegister([motion({ MeetingID: null })], MEETINGS, MEMBERSHIPS, []);
        expect(data.Rows[0].IsBallotMotion).toBe(true);
        expect(data.Rows[0].MeetingDate).toBeNull();
        expect(data.Rows[0].CommitteeName).toBeNull();
    });

    it('stamped counts win over vote rows', () => {
        const votes: VoteRow[] = [
            { ID: 'V1', MotionID: 'MOT-1', MembershipID: 'MEM-1', VoteValue: 'Yes', Notes: null },
        ];
        const data = MotionService.BuildRegister(
            [motion({ YesCount: 5, NoCount: 1, AbstainCount: 0 })], MEETINGS, MEMBERSHIPS, votes);
        expect(data.Rows[0].Tally).toEqual({ Yes: 5, No: 1, Abstain: 0, Cast: 6, Outstanding: 0 });
    });

    it('unstamped motions tally live from vote rows; no votes means null tally', () => {
        const votes: VoteRow[] = [
            { ID: 'V1', MotionID: 'MOT-1', MembershipID: 'MEM-1', VoteValue: 'Yes', Notes: null },
            { ID: 'V2', MotionID: 'MOT-1', MembershipID: 'MEM-2', VoteValue: 'No', Notes: null },
        ];
        const withVotes = MotionService.BuildRegister([motion({})], MEETINGS, MEMBERSHIPS, votes);
        expect(withVotes.Rows[0].Tally?.Yes).toBe(1);
        expect(withVotes.Rows[0].Tally?.No).toBe(1);

        const without = MotionService.BuildRegister([motion({})], MEETINGS, MEMBERSHIPS, []);
        expect(without.Rows[0].Tally).toBeNull();
    });

    it('groups votes by motion for roll-call expansion', () => {
        const votes: VoteRow[] = [
            { ID: 'V1', MotionID: 'MOT-1', MembershipID: 'MEM-1', VoteValue: 'Yes', Notes: null },
            { ID: 'V2', MotionID: 'mot-1', MembershipID: 'MEM-2', VoteValue: 'No', Notes: 'Requested review' },
        ];
        const data = MotionService.BuildRegister([motion({})], MEETINGS, MEMBERSHIPS, votes);
        expect(data.VotesByMotion.get('mot-1')?.length).toBe(2);
    });
});

describe('BuildRollCall', () => {
    const votes: VoteRow[] = [
        { ID: 'V1', MotionID: 'MOT-1', MembershipID: 'MEM-1', VoteValue: 'Yes', Notes: null },
        { ID: 'V2', MotionID: 'MOT-1', MembershipID: 'MEM-3', VoteValue: 'No', Notes: 'Requested additional review' },
    ];

    it('lines up every eligible voter with vote or null when outstanding', () => {
        const rc = MotionService.BuildRollCall(MEMBERSHIPS, votes, false);
        expect(rc).toHaveLength(3);
        expect(rc.find(r => r.MembershipID === 'MEM-1')?.VoteValue).toBe('Yes');
        expect(rc.find(r => r.MembershipID === 'MEM-2')?.VoteValue).toBeNull();  // outstanding
        expect(rc.find(r => r.MembershipID === 'MEM-3')?.VoteNotes).toBe('Requested additional review');
    });

    it('sealed ballots withhold choices and notes but show the roster', () => {
        const rc = MotionService.BuildRollCall(MEMBERSHIPS, votes, true);
        expect(rc).toHaveLength(3);
        expect(rc.every(r => r.VoteValue === null && r.VoteNotes === null)).toBe(true);
    });
});
