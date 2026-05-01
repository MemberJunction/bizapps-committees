import { BaseEngine, IMetadataProvider, UserInfo } from '@memberjunction/core';
import {
    mjCommitteesRoleEntity,
    mjCommitteesTypeEntity,
    mjCommitteesArtifactTypeEntity,
} from '@mj-biz-apps/committees-entities';

/**
 * Singleton lookup engine for slow-changing committee metadata: roles,
 * committee types, and artifact types. Cached across the process so consumers
 * (UI dropdowns, server-side validators) hit the DB at most once per process
 * unless `Config(true)` is called explicitly.
 *
 * Mirrors the MJ pattern (`AIEngine`, `DocumentationEngine`, etc.): subclass
 * `BaseEngine`, declare property configs in `Config()`, expose getters.
 *
 * **Browser consumers**: import via the subpath export to avoid pulling in
 * server-only transitive dependencies:
 *
 * ```ts
 * import { CommitteesLookupEngine } from '@mj-biz-apps/committees-core/lookup';
 * await CommitteesLookupEngine.Instance.Config();
 * const roles = CommitteesLookupEngine.Instance.Roles;
 * ```
 *
 * **Server consumers** can also import from the main entry point:
 *
 * ```ts
 * import { CommitteesLookupEngine } from '@mj-biz-apps/committees-core';
 * ```
 */
export class CommitteesLookupEngine extends BaseEngine<CommitteesLookupEngine> {
    public static get Instance(): CommitteesLookupEngine {
        return super.getInstance<CommitteesLookupEngine>();
    }

    private _Roles: mjCommitteesRoleEntity[] = [];
    private _CommitteeTypes: mjCommitteesTypeEntity[] = [];
    private _ArtifactTypes: mjCommitteesArtifactTypeEntity[] = [];

    public async Config(
        forceRefresh = false,
        contextUser?: UserInfo,
        provider?: IMetadataProvider
    ): Promise<void> {
        const configs = [
            { EntityName: 'Committees: Roles',          PropertyName: '_Roles',          CacheLocal: true },
            { EntityName: 'Committees: Types',          PropertyName: '_CommitteeTypes', CacheLocal: true },
            { EntityName: 'Committees: Artifact Types', PropertyName: '_ArtifactTypes',  CacheLocal: true },
        ];
        await this.Load(configs, provider, forceRefresh, contextUser);
    }

    /** All committee roles (Chair, Vice Chair, Secretary, Member, Liaison, etc.). */
    public get Roles(): mjCommitteesRoleEntity[] {
        return this._Roles;
    }

    /** Officer roles (IsOfficer = true). */
    public get OfficerRoles(): mjCommitteesRoleEntity[] {
        return this._Roles.filter(r => r.IsOfficer);
    }

    /** All committee types (Standing, Ad Hoc, Workgroup, etc.). */
    public get CommitteeTypes(): mjCommitteesTypeEntity[] {
        return this._CommitteeTypes;
    }

    /** All artifact types used for documents/files attached to committees. */
    public get ArtifactTypes(): mjCommitteesArtifactTypeEntity[] {
        return this._ArtifactTypes;
    }

    /** Case-insensitive role lookup by name. */
    public RoleByName(name: string): mjCommitteesRoleEntity | undefined {
        const k = name?.toLowerCase();
        return this._Roles.find(r => r.Name.toLowerCase() === k);
    }

    /** Case-insensitive committee-type lookup by name. */
    public CommitteeTypeByName(name: string): mjCommitteesTypeEntity | undefined {
        const k = name?.toLowerCase();
        return this._CommitteeTypes.find(t => t.Name.toLowerCase() === k);
    }
}
