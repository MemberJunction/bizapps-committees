import { describe, expect, it } from 'vitest';
import { MJGlobal } from '@memberjunction/global';
import {
    BaseSpaceTypeServerDriver,
    type ChildSpaceChangeContext,
    type MemberChangeContext,
    type SpaceChangeContext,
} from '@mj-biz-apps/collaboration-core-entities-server';
import { CommitteeEntityCustom, TermEntityCustom } from '@mj-biz-apps/committees-entities';
import {
    CommitteeSpaceServerDriver,
    COMMITTEE_MEMBERSHIP_SYNC_SOURCE,
} from '../CommitteeSpaceServerDriver.js';
import { TermSpaceServerDriver } from '../TermSpaceServerDriver.js';

const COMMITTEE_ID = '00000000-0000-4000-8000-000000000001';
const TERM_ID_1 = '00000000-0000-4000-8000-000000000002';
const TERM_ID_2 = '00000000-0000-4000-8000-000000000003';
const USER_ID = '00000000-0000-4000-8000-000000000004';
const PERSON_ID = '00000000-0000-4000-8000-000000000005';

function makeFakeProvider(rowsByEntity: Record<string, unknown[]>) {
    return {
        RunViews: async (queries: Array<{ EntityName: string }>) =>
            queries.map((q) => ({
                Success: true,
                Results: rowsByEntity[q.EntityName] ?? [],
            })),
        RunView: async (query: { EntityName: string }) => ({
            Success: true,
            Results: rowsByEntity[query.EntityName] ?? [],
        }),
        GetEntityObject: async () => null,
    };
}

describe('CommitteeSpaceServerDriver & TermSpaceServerDriver (C4)', () => {
    it('registers CommitteeSpaceServerDriver and TermSpaceServerDriver with ClassFactory', () => {
        const comByClass = MJGlobal.Instance.ClassFactory.GetRegistration(
            BaseSpaceTypeServerDriver,
            'CommitteeSpaceServerDriver'
        );
        const comByCode = MJGlobal.Instance.ClassFactory.GetRegistration(
            BaseSpaceTypeServerDriver,
            'committee'
        );
        const termByClass = MJGlobal.Instance.ClassFactory.GetRegistration(
            BaseSpaceTypeServerDriver,
            'TermSpaceServerDriver'
        );
        const termByCode = MJGlobal.Instance.ClassFactory.GetRegistration(
            BaseSpaceTypeServerDriver,
            'committee-term'
        );
        expect(comByClass?.SubClass).toBe(CommitteeSpaceServerDriver);
        expect(comByCode?.SubClass).toBe(CommitteeSpaceServerDriver);
        expect(termByClass?.SubClass).toBe(TermSpaceServerDriver);
        expect(termByCode?.SubClass).toBe(TermSpaceServerDriver);
    });

    it('Decision A3: stamps Space.ClosedAt on Dissolved and leaves Inactive/Pending open', async () => {
        const driver = new CommitteeSpaceServerDriver();
        const space = {
            ID: COMMITTEE_ID,
            ClosedAt: null as Date | null,
            LeafEntity: {
                Status: 'Inactive',
                IsPublic: false,
            },
        };
        const provider = makeFakeProvider({ 'Committees: Ballots': [] });

        // Inactive leaves ClosedAt null
        const resInactive = await driver.ValidateSpaceChange({
            kind: 'Update',
            space: space as never,
            provider: provider as never,
            actingUser: { ID: USER_ID } as never,
            spaceType: {} as never,
            configuration: {} as never,
            effectiveRules: {} as never,
        } as SpaceChangeContext);
        expect(resInactive.ok).toBe(true);
        expect(space.ClosedAt).toBeNull();

        // Dissolved stamps ClosedAt
        space.LeafEntity.Status = 'Dissolved';
        space.LeafEntity.IsPublic = true;
        const resDissolved = await driver.ValidateSpaceChange({
            kind: 'Update',
            space: space as never,
            provider: provider as never,
            actingUser: { ID: USER_ID } as never,
            spaceType: {} as never,
            configuration: {} as never,
            effectiveRules: {} as never,
        } as SpaceChangeContext);
        expect(resDissolved.ok).toBe(true);
        expect(space.ClosedAt).toBeInstanceOf(Date);
    });

    it('Decision A4: enforces child space types, term InheritsMembership=true, sub-committee InheritsMembership=false, and at most one open term', async () => {
        const driver = new CommitteeSpaceServerDriver();
        const providerWithOpenTerm = makeFakeProvider({
            'MJ_BizApps_Collaboration: Spaces': [{ ID: TERM_ID_1 }],
        });

        // Second open term is refused
        const secondTermRes = await driver.ValidateChildSpaceChange({
            kind: 'CreateChild',
            space: { ID: COMMITTEE_ID } as never,
            childSpace: {
                ID: TERM_ID_2,
                SpaceTypeID: TermEntityCustom.SPACE_TYPE_ID,
                InheritsMembership: true,
                ClosedAt: null,
            } as never,
            provider: providerWithOpenTerm as never,
            actingUser: { ID: USER_ID } as never,
            spaceType: {} as never,
            configuration: {} as never,
            effectiveRules: {} as never,
        } as ChildSpaceChangeContext);
        expect(secondTermRes.ok).toBe(false);
        expect(secondTermRes.message).toContain('at most one open term');

        // Sub-committee with InheritsMembership=true is refused
        const subComBadRes = await driver.ValidateChildSpaceChange({
            kind: 'CreateChild',
            space: { ID: COMMITTEE_ID } as never,
            childSpace: {
                ID: TERM_ID_2,
                SpaceTypeID: CommitteeEntityCustom.SPACE_TYPE_ID,
                InheritsMembership: true,
                ClosedAt: null,
            } as never,
            provider: providerWithOpenTerm as never,
            actingUser: { ID: USER_ID } as never,
            spaceType: {} as never,
            configuration: {} as never,
            effectiveRules: {} as never,
        } as ChildSpaceChangeContext);
        expect(subComBadRes.ok).toBe(false);
        expect(subComBadRes.field).toBe('InheritsMembership');
    });

    it('refuses manual SpaceMember additions when the user holds an active committee membership', async () => {
        const driver = new CommitteeSpaceServerDriver();
        const provider = makeFakeProvider({
            'MJ_BizApps_Common: People': [{ ID: PERSON_ID }],
            'Committees: Terms': [{ ID: TERM_ID_1 }],
            'Committees: Memberships': [{ ID: 'mem-1' }],
        });

        const manualRes = await driver.ValidateMemberChange({
            kind: 'Invite',
            space: { ID: COMMITTEE_ID } as never,
            member: {
                UserID: USER_ID,
                SyncSource: null,
            } as never,
            provider: provider as never,
            actingUser: { ID: USER_ID } as never,
            spaceType: {} as never,
            configuration: {} as never,
            effectiveRules: {} as never,
        } as MemberChangeContext);
        expect(manualRes.ok).toBe(false);
        expect(manualRes.message).toContain('committee membership');

        const syncedRes = await driver.ValidateMemberChange({
            kind: 'Invite',
            space: { ID: COMMITTEE_ID } as never,
            member: {
                UserID: USER_ID,
                SyncSource: COMMITTEE_MEMBERSHIP_SYNC_SOURCE,
            } as never,
            provider: provider as never,
            actingUser: { ID: USER_ID } as never,
            spaceType: {} as never,
            configuration: {} as never,
            effectiveRules: {} as never,
        } as MemberChangeContext);
        expect(syncedRes.ok).toBe(true);
    });
});
