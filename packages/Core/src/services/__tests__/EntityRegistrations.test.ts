import { describe, it, expect } from 'vitest';
import { BaseEntity } from '@memberjunction/core';
import { MJGlobal } from '@memberjunction/global';
import { MeetingEntityCustom, MembershipEntityCustom } from '@mj-biz-apps/committees-entities';

/**
 * The class factory hands out entity classes by the entity's full name ("Committees: Memberships"), which is
 * what `Metadata.GetEntityObject` asks for. A subclass registered under the bare table name ('Memberships') is
 * never found, so its validation rules never run. These tests pin the keys the custom classes register under.
 */
describe('custom entity registrations', () => {
    it('Committees: Memberships resolves to the custom membership class', () => {
        const registration = MJGlobal.Instance.ClassFactory.GetRegistration(BaseEntity, 'Committees: Memberships');
        expect(registration?.SubClass).toBe(MembershipEntityCustom);
    });

    it('Committees: Meetings resolves to the custom meeting class', () => {
        const registration = MJGlobal.Instance.ClassFactory.GetRegistration(BaseEntity, 'Committees: Meetings');
        expect(registration?.SubClass).toBe(MeetingEntityCustom);
    });

    it('the bare table names are not registration keys', () => {
        expect(MJGlobal.Instance.ClassFactory.GetRegistration(BaseEntity, 'Memberships')?.SubClass).not.toBe(MembershipEntityCustom);
        expect(MJGlobal.Instance.ClassFactory.GetRegistration(BaseEntity, 'Meetings')?.SubClass).not.toBe(MeetingEntityCustom);
    });
});
