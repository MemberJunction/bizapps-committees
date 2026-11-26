import { beforeEach, describe, expect, it, vi } from 'vitest';
import { Metadata, RunView } from '@memberjunction/core';
import { CommitteesLookupEngine } from '@mj-biz-apps/committees-core/lookup';
import { CommitteePermissionHelper } from '../committee-permission-helper';

describe('CommitteePermissionHelper', () => {
    let activeUserId: string | null = 'user-1';

    beforeEach(() => {
        activeUserId = 'user-1';
        CommitteePermissionHelper.ClearCache();
        vi.restoreAllMocks();
        vi.spyOn(Metadata.prototype, 'CurrentUser', 'get').mockImplementation(() =>
            activeUserId ? ({ ID: activeUserId } as Metadata['CurrentUser']) : null
        );
    });

    it('deduplicates concurrent IsStaffUser calls and invalidates on user switch', async () => {
        const runViewSpy = vi.spyOn(RunView.prototype, 'RunView').mockImplementation(async (params) => {
            const isUser1 = String(params.ExtraFilter ?? '').includes('user-1');
            return {
                Success: true,
                Results: isUser1 ? [{ ID: 'app-1' }] : [],
            } as Awaited<ReturnType<RunView['RunView']>>;
        });

        const [first, second] = await Promise.all([
            CommitteePermissionHelper.IsStaffUser(),
            CommitteePermissionHelper.IsStaffUser(),
        ]);
        expect(first).toBe(true);
        expect(second).toBe(true);
        expect(runViewSpy).toHaveBeenCalledTimes(1);

        // Switching user (impersonation) must invalidate cached staff flag
        activeUserId = 'user-2';
        const switched = await CommitteePermissionHelper.IsStaffUser();
        expect(switched).toBe(false);
        expect(runViewSpy).toHaveBeenCalledTimes(2);
    });

    it('uses CommitteesLookupEngine.IsOfficerRole instead of issuing a Roles RunView', async () => {
        const configSpy = vi.spyOn(CommitteesLookupEngine.Instance, 'Config').mockResolvedValue();
        const isOfficerSpy = vi.spyOn(CommitteesLookupEngine.Instance, 'IsOfficerRole')
            .mockImplementation((roleId) => roleId === 'role-chair');

        const runViewSpy = vi.spyOn(RunView.prototype, 'RunView').mockImplementation(async (params) => {
            if (params.EntityName === 'MJ_BizApps_Common: People') {
                return { Success: true, Results: [{ ID: 'person-1' }] } as Awaited<ReturnType<RunView['RunView']>>;
            }
            if (params.EntityName === 'Committees: Memberships') {
                return { Success: true, Results: [{ RoleID: 'role-chair', TermID: 'term-1' }] } as Awaited<ReturnType<RunView['RunView']>>;
            }
            if (params.EntityName === 'Committees: Terms') {
                return { Success: true, Results: [{ ID: 'term-1', CommitteeID: 'comm-1' }] } as Awaited<ReturnType<RunView['RunView']>>;
            }
            throw new Error(`Unexpected RunView entity: ${params.EntityName}`);
        });

        const memberships = await CommitteePermissionHelper.GetCurrentUserMemberships();
        expect(memberships).toEqual([
            { RoleID: 'role-chair', TermID: 'term-1', CommitteeID: 'comm-1', IsOfficer: true },
        ]);
        expect(configSpy).toHaveBeenCalledTimes(1);
        expect(isOfficerSpy).toHaveBeenCalledWith('role-chair');
        expect(runViewSpy).toHaveBeenCalledTimes(3); // People, Memberships, Terms (zero Roles RunView)
    });
});
