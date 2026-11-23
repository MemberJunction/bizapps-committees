import { describe, expect, it } from 'vitest';
import { CommitteeTaskService } from '../CommitteeTaskService.js';

const VALID_UUID = '11111111-2222-3333-4444-555555555555';
const VALID_UPPER_UUID = 'AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE';

describe('CommitteeTaskService.BuildTaskFilter', () => {
    it('returns empty string when neither statusFilter nor assignedToPersonID is given', () => {
        expect(CommitteeTaskService.BuildTaskFilter('')).toBe('');
    });

    it('returns only statusFilter when assignedToPersonID is omitted', () => {
        expect(CommitteeTaskService.BuildTaskFilter("Status IN ('Open', 'InProgress')"))
            .toBe("Status IN ('Open', 'InProgress')");
    });

    it('interpolates a valid UUID assignedToPersonID (lowercase or uppercase)', () => {
        expect(CommitteeTaskService.BuildTaskFilter('', VALID_UUID)).toBe(
            `ID IN (SELECT TaskID FROM [__mj_BizAppsTasks].[vwTaskAssignments] WHERE AssigneeRecordID = '${VALID_UUID}')`
        );
        expect(CommitteeTaskService.BuildTaskFilter("Status = 'Open'", VALID_UPPER_UUID)).toBe(
            `Status = 'Open' AND ID IN (SELECT TaskID FROM [__mj_BizAppsTasks].[vwTaskAssignments] WHERE AssigneeRecordID = '${VALID_UPPER_UUID}')`
        );
    });

    it('throws on SQL injection payloads or non-UUID assignedToPersonID values', () => {
        const invalidInputs = [
            "' OR '1'='1",
            `${VALID_UUID}' OR '1'='1`,
            "12345; DROP TABLE Users; --",
            'not-a-uuid',
            ` ${VALID_UUID} `,
        ];
        for (const bad of invalidInputs) {
            expect(() => CommitteeTaskService.BuildTaskFilter('', bad)).toThrow(/not a valid ID/i);
        }
    });
});

describe('CommitteeTaskService.BuildRows', () => {
    it('unions TaskLink committees and Category matches without duplicating', () => {
        const rows = CommitteeTaskService.BuildRows(
            [{ ID: 'T1', Name: 'Review budget', Status: 'Open', Priority: 'High', DueAt: null, Category: 'Finance' }],
            [{ TaskID: 't1', RecordID: 'C1' }],
            [{ ID: 'c1', Name: 'Finance' }, { ID: 'C2', Name: 'Audit' }],
            [{ TaskID: 'T1', AssigneeRecordID: VALID_UUID }],
            [{ ID: VALID_UUID.toUpperCase(), DisplayName: 'Ada Lovelace' }]
        );
        expect(rows).toHaveLength(1);
        expect(rows[0].CommitteeIDs).toEqual(['C1']);
        expect(rows[0].CommitteeNames).toEqual(['Finance']);
        expect(rows[0].AssigneePersonID).toBe(VALID_UUID);
        expect(rows[0].AssigneeName).toBe('Ada Lovelace');
    });
});
