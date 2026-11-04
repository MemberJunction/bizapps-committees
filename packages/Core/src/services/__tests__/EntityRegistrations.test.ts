import { describe, it, expect } from 'vitest';
import { BaseEntity } from '@memberjunction/core';
import { MJGlobal } from '@memberjunction/global';
import { mjBizAppsCollaborationSpaceEntity } from '@mj-biz-apps/collaboration-entities';
import {
    CommitteeEntityCustom,
    MembershipEntityCustom,
    TermEntityCustom,
} from '@mj-biz-apps/committees-entities';

/**
 * The class factory hands out entity classes by the entity's full name ("Committees: Memberships"), which is
 * what `Metadata.GetEntityObject` asks for. A subclass registered under the bare table name ('Memberships') is
 * never found, so its validation rules never run. These tests pin the keys the custom classes register under
 * and verify the C4 IsA hierarchy on Space.
 */
describe('custom entity registrations', () => {
    it('Committees: Memberships resolves to the custom membership class', () => {
        const registration = MJGlobal.Instance.ClassFactory.GetRegistration(BaseEntity, 'Committees: Memberships');
        expect(registration?.SubClass).toBe(MembershipEntityCustom);
    });

    it('Committees: Committees and Committees: Terms register with Space IsA fields (C4)', () => {
        const committeeReg = MJGlobal.Instance.ClassFactory.GetRegistration(BaseEntity, 'Committees: Committees');
        const termReg = MJGlobal.Instance.ClassFactory.GetRegistration(BaseEntity, 'Committees: Terms');
        expect(committeeReg?.SubClass).toBe(CommitteeEntityCustom);
        expect(termReg?.SubClass).toBe(TermEntityCustom);
        expect('SpaceTypeID' in CommitteeEntityCustom.prototype).toBe(true);
        expect('InheritsMembership' in CommitteeEntityCustom.prototype).toBe(true);
        expect('ParentID' in TermEntityCustom.prototype).toBe(true);
        expect('PlannedCloseAt' in TermEntityCustom.prototype).toBe(true);
    });

    it('the bare table names and dropped Committees: Meetings are not registration keys', () => {
        expect(MJGlobal.Instance.ClassFactory.GetRegistration(BaseEntity, 'Memberships')?.SubClass).not.toBe(MembershipEntityCustom);
        expect(MJGlobal.Instance.ClassFactory.GetRegistration(BaseEntity, 'Committees: Meetings')).toBeNull();
    });
});
