import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { BaseEnginePropertyConfig, IMetadataProvider, UserInfo } from '@memberjunction/core';
import type {
    mjBizAppsCommitteesArtifactTypeEntity,
    mjBizAppsCommitteesRoleEntity,
    mjBizAppsCommitteesTypeEntity,
    mjBizAppsCommitteesVideoProviderEntity,
} from '@mj-biz-apps/committees-entities';
import { CommitteesLookupEngine } from '../CommitteesLookupEngine.js';

interface MockLoadCall {
    configs: Array<Partial<BaseEnginePropertyConfig>>;
    provider: IMetadataProvider | undefined;
    forceRefresh: boolean;
    contextUser: UserInfo | undefined;
}

class TestableCommitteesLookupEngine extends CommitteesLookupEngine {
    public LoadCalls: MockLoadCall[] = [];

    public static CreateForTest(): TestableCommitteesLookupEngine {
        return new TestableCommitteesLookupEngine();
    }

    public override async Load(
        configs: Array<Partial<BaseEnginePropertyConfig>>,
        provider?: IMetadataProvider,
        forceRefresh = false,
        contextUser?: UserInfo
    ): Promise<void> {
        this.LoadCalls.push({ configs, provider, forceRefresh, contextUser });
        const state = this as {
            _Roles?: mjBizAppsCommitteesRoleEntity[];
            _CommitteeTypes?: mjBizAppsCommitteesTypeEntity[];
            _ArtifactTypes?: mjBizAppsCommitteesArtifactTypeEntity[];
            _VideoProviders?: mjBizAppsCommitteesVideoProviderEntity[];
        };
        for (const cfg of configs) {
            if (cfg.PropertyName === '_Roles') {
                state._Roles = [
                    { ID: 'role-chair', Name: 'Chair', IsOfficer: true, IsVotingRole: true } as mjBizAppsCommitteesRoleEntity,
                    { ID: 'role-member', Name: 'Member', IsOfficer: false, IsVotingRole: true } as mjBizAppsCommitteesRoleEntity,
                    { ID: 'role-liaison', Name: 'Liaison', IsOfficer: false, IsVotingRole: false } as mjBizAppsCommitteesRoleEntity,
                ];
            } else if (cfg.PropertyName === '_CommitteeTypes') {
                state._CommitteeTypes = [
                    { ID: 'type-standing', Name: 'Standing' } as mjBizAppsCommitteesTypeEntity,
                ];
            } else if (cfg.PropertyName === '_ArtifactTypes') {
                state._ArtifactTypes = [
                    { ID: 'art-charter', Name: 'Charter' } as mjBizAppsCommitteesArtifactTypeEntity,
                ];
            } else if (cfg.PropertyName === '_VideoProviders') {
                state._VideoProviders = [
                    { ID: 'vp-zoom', Name: 'Zoom', IsActive: true, IsDefault: true, ServerDriverKey: 'Zoom' } as mjBizAppsCommitteesVideoProviderEntity,
                    { ID: 'vp-teams', Name: 'Teams', IsActive: true, IsDefault: false, ServerDriverKey: 'Teams' } as mjBizAppsCommitteesVideoProviderEntity,
                    { ID: 'vp-old', Name: 'Legacy', IsActive: false, IsDefault: false, ServerDriverKey: 'Legacy' } as mjBizAppsCommitteesVideoProviderEntity,
                ];
            }
        }
    }
}

function makeProvider(
    userId: string,
    deniedEntities: ReadonlySet<string> = new Set()
): IMetadataProvider {
    const stub: Pick<IMetadataProvider, 'CurrentUser' | 'EntityByName'> = {
        CurrentUser: { ID: userId } as UserInfo,
        EntityByName: (name: string) =>
            ({
                GetUserPermisions: (_user: UserInfo) => ({
                    CanRead: !deniedEntities.has(name),
                }),
            }) as ReturnType<IMetadataProvider['EntityByName']>,
    };
    return stub as IMetadataProvider;
}

describe('CommitteesLookupEngine', () => {
    let engine: TestableCommitteesLookupEngine;

    beforeEach(() => {
        vi.restoreAllMocks();
        engine = TestableCommitteesLookupEngine.CreateForTest();
    });

    it('uses active provider override and enforces CacheLocal: false on Video Providers', async () => {
        const providerA = makeProvider('user-a');

        await engine.Config(false, undefined, providerA);

        expect(engine.ProviderToUse).toBe(providerA);
        expect(engine.LoadCalls).toHaveLength(1);
        expect(engine.LoadCalls[0].provider).toBe(providerA);

        const byEntity = new Map(engine.LoadCalls[0].configs.map(c => [c.EntityName, c]));
        expect(byEntity.get('Committees: Roles')?.CacheLocal).toBe(true);
        expect(byEntity.get('Committees: Types')?.CacheLocal).toBe(true);
        expect(byEntity.get('Committees: Artifact Types')?.CacheLocal).toBe(true);
        expect(byEntity.get('Committees: Video Providers')?.CacheLocal).toBe(false);
    });

    it('provides case-insensitive O(1) lookups across roles, types, artifact types, and video providers', async () => {
        const provider = makeProvider('user-a');
        await engine.Config(false, undefined, provider);

        expect(engine.RoleById('ROLE-CHAIR')?.Name).toBe('Chair');
        expect(engine.RoleByName('chair')?.ID).toBe('role-chair');
        expect(engine.IsOfficerRole('ROLE-CHAIR')).toBe(true);
        expect(engine.IsOfficerRole('role-member')).toBe(false);
        expect(engine.IsVotingRole('role-member')).toBe(true);
        expect(engine.IsVotingRole('role-liaison')).toBe(false);
        expect(engine.OfficerRoles.map(r => r.ID)).toEqual(['role-chair']);
        expect(engine.VotingRoles.map(r => r.ID)).toEqual(['role-chair', 'role-member']);

        expect(engine.CommitteeTypeById('TYPE-STANDING')?.Name).toBe('Standing');
        expect(engine.CommitteeTypeByName('standing')?.ID).toBe('type-standing');
        expect(engine.ArtifactTypeById('ART-CHARTER')?.Name).toBe('Charter');
        expect(engine.ArtifactTypeByName('charter')?.ID).toBe('art-charter');

        expect(engine.DefaultVideoProvider?.ID).toBe('vp-zoom');
        expect(engine.ActiveVideoProviders.map(p => p.Name)).toEqual(['Teams', 'Zoom']);
        expect(engine.VideoProviderById('VP-TEAMS')?.Name).toBe('Teams');
    });

    it('auto-forces refresh and updates ProviderToUse when switching users/providers', async () => {
        const providerA = makeProvider('user-a');
        const providerB = makeProvider('user-b');

        await engine.Config(false, undefined, providerA);
        expect(engine.LoadCalls[0].forceRefresh).toBe(false);

        await engine.Config(false, undefined, providerA);
        expect(engine.LoadCalls[1].forceRefresh).toBe(false);

        await engine.Config(false, undefined, providerB);
        expect(engine.ProviderToUse).toBe(providerB);
        expect(engine.LoadCalls[2].forceRefresh).toBe(true);
        expect(engine.LoadCalls[2].provider).toBe(providerB);
    });

    it('gates entities by CanRead so restricted roles skip denied entities cleanly', async () => {
        const restrictedProvider = makeProvider('user-guest', new Set(['Committees: Video Providers']));

        await engine.Config(false, undefined, restrictedProvider);

        expect(engine.LoadCalls).toHaveLength(1);
        const entityNames = engine.LoadCalls[0].configs.map(c => c.EntityName);
        expect(entityNames).toEqual([
            'Committees: Roles',
            'Committees: Types',
            'Committees: Artifact Types',
        ]);
        expect(engine.VideoProviders).toEqual([]);
        expect(engine.DefaultVideoProvider).toBeUndefined();
    });

    it('clears cached collections and indexes on InvalidateCache()', async () => {
        const provider = makeProvider('user-a');
        await engine.Config(false, undefined, provider);
        expect(engine.RoleById('role-chair')).toBeDefined();

        engine.InvalidateCache();
        expect(engine.Roles).toEqual([]);
        expect(engine.VideoProviders).toEqual([]);
        expect(engine.RoleById('role-chair')).toBeUndefined();
        expect(engine.IsConfiguredForUser('user-a')).toBe(false);
    });
});
