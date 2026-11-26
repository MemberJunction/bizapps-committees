import {
    BaseEngine,
    type BaseEnginePropertyConfig,
    type IMetadataProvider,
    Metadata,
    RegisterForStartup,
    type UserInfo,
} from '@memberjunction/core';
import {
    mjBizAppsCommitteesRoleEntity,
    mjBizAppsCommitteesTypeEntity,
    mjBizAppsCommitteesArtifactTypeEntity,
    mjBizAppsCommitteesVideoProviderEntity,
} from '@mj-biz-apps/committees-entities';

const normalizeKey = (value: string | null | undefined): string => (value ?? '').trim().toLowerCase();

/**
 * Singleton lookup engine for slow-changing committee metadata: roles,
 * committee types, artifact types, and video providers. Cached across the
 * process so consumers (UI dropdowns, server-side validators, authorization)
 * hit the DB at most once per user/provider session unless `Config(true)` is
 * called explicitly.
 *
 * Security & multi-provider invariants:
 * - Overrides `ProviderToUse` to always route through the active provider
 *   passed to `Config()` (or live `Metadata.Provider`), preventing first-wins
 *   provider latch across impersonation or multi-provider sessions.
 * - Tracks `_loadedForUserId` and forces a refresh automatically whenever the
 *   effective user changes.
 * - Gates every entity on `EntityInfo.GetUserPermisions(user)?.CanRead` so
 *   permission-restricted roles never fail engine startup.
 * - Uses `CacheLocal: true` ONLY for shared, non-RLS taxonomy tables
 *   (`Roles`, `Types`, `Artifact Types`) and `CacheLocal: false` for
 *   config/admin-scoped entities (`Video Providers`) to avoid cross-persona
 *   IndexedDB bleed.
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
@RegisterForStartup()
export class CommitteesLookupEngine extends BaseEngine<CommitteesLookupEngine> {
    private _Roles: mjBizAppsCommitteesRoleEntity[] = [];
    private _CommitteeTypes: mjBizAppsCommitteesTypeEntity[] = [];
    private _ArtifactTypes: mjBizAppsCommitteesArtifactTypeEntity[] = [];
    private _VideoProviders: mjBizAppsCommitteesVideoProviderEntity[] = [];

    private _rolesById: Map<string, mjBizAppsCommitteesRoleEntity> | null = null;
    private _rolesByName: Map<string, mjBizAppsCommitteesRoleEntity> | null = null;
    private _typesById: Map<string, mjBizAppsCommitteesTypeEntity> | null = null;
    private _typesByName: Map<string, mjBizAppsCommitteesTypeEntity> | null = null;
    private _artifactTypesById: Map<string, mjBizAppsCommitteesArtifactTypeEntity> | null = null;
    private _artifactTypesByName: Map<string, mjBizAppsCommitteesArtifactTypeEntity> | null = null;
    private _videoProvidersById: Map<string, mjBizAppsCommitteesVideoProviderEntity> | null = null;

    private _activeProvider: IMetadataProvider | null = null;
    private _loadedForUserId: string | null = null;
    private _cacheInvalidated = false;

    protected constructor() {
        super();
    }

    public static get Instance(): CommitteesLookupEngine {
        return super.getInstance<CommitteesLookupEngine>();
    }

    /**
     * Always routes RunViews through the active provider passed to `Config()`
     * (or live `Metadata.Provider` in browser sessions) instead of BaseEngine's
     * first-wins `_provider` latch — essential for impersonation and multi-provider hosts.
     */
    public override get ProviderToUse(): IMetadataProvider {
        return this._activeProvider ?? Metadata.Provider;
    }

    public async Config(
        forceRefresh = false,
        contextUser?: UserInfo,
        provider?: IMetadataProvider
    ): Promise<void> {
        this._activeProvider = provider ?? null;
        const md = this.ProviderToUse;
        const effectiveUser = contextUser ?? md?.CurrentUser;
        const nextUserId = normalizeKey(effectiveUser?.ID);
        const userChanged =
            this._loadedForUserId !== null &&
            nextUserId.length > 0 &&
            this._loadedForUserId !== nextUserId;
        const shouldForceRefresh = Boolean(forceRefresh || this._cacheInvalidated || userChanged);

        const configs: Array<Partial<BaseEnginePropertyConfig>> = [];

        if (this.canReadEntity(md, 'Committees: Roles', effectiveUser)) {
            configs.push({
                EntityName: 'Committees: Roles',
                PropertyName: '_Roles',
                CacheLocal: true,
            });
        } else {
            this._Roles = [];
        }

        if (this.canReadEntity(md, 'Committees: Types', effectiveUser)) {
            configs.push({
                EntityName: 'Committees: Types',
                PropertyName: '_CommitteeTypes',
                CacheLocal: true,
            });
        } else {
            this._CommitteeTypes = [];
        }

        if (this.canReadEntity(md, 'Committees: Artifact Types', effectiveUser)) {
            configs.push({
                EntityName: 'Committees: Artifact Types',
                PropertyName: '_ArtifactTypes',
                CacheLocal: true,
            });
        } else {
            this._ArtifactTypes = [];
        }

        // Video Providers may carry credential links and stricter role permissions,
        // so gate on CanRead and keep CacheLocal: false (memory-only per session).
        if (this.canReadEntity(md, 'Committees: Video Providers', effectiveUser)) {
            configs.push({
                EntityName: 'Committees: Video Providers',
                PropertyName: '_VideoProviders',
                CacheLocal: false,
            });
        } else {
            this._VideoProviders = [];
        }

        if (configs.length > 0) {
            await this.Load(configs, md, shouldForceRefresh, effectiveUser);
        }

        this.resetLookupIndexes();
        this._loadedForUserId = nextUserId || null;
        this._cacheInvalidated = false;
    }

    protected override async AdditionalLoading(_contextUser?: UserInfo): Promise<void> {
        this.resetLookupIndexes();
    }

    /**
     * Clears O(1) lookup maps, cached collections, and active provider binding so the
     * next `Config()` performs a fresh load under the active user/provider.
     */
    public InvalidateCache(): void {
        this._cacheInvalidated = true;
        this._loadedForUserId = null;
        this._activeProvider = null;
        this._Roles = [];
        this._CommitteeTypes = [];
        this._ArtifactTypes = [];
        this._VideoProviders = [];
        this.resetLookupIndexes();
    }

    public IsConfiguredForUser(userId: string | null | undefined): boolean {
        if (!this.Loaded || this._cacheInvalidated) {
            return false;
        }
        const norm = normalizeKey(userId);
        if (!norm) {
            return this._loadedForUserId !== null;
        }
        return this._loadedForUserId === norm;
    }

    private canReadEntity(md: IMetadataProvider | null | undefined, entityName: string, user?: UserInfo): boolean {
        const entityInfo = md?.EntityByName?.(entityName);
        if (!entityInfo || !user) {
            return true;
        }
        const perms = entityInfo.GetUserPermisions(user);
        return perms ? perms.CanRead : true;
    }

    private resetLookupIndexes(): void {
        this._rolesById = null;
        this._rolesByName = null;
        this._typesById = null;
        this._typesByName = null;
        this._artifactTypesById = null;
        this._artifactTypesByName = null;
        this._videoProvidersById = null;
    }

    // ─── Collections ───────────────────────────────────────────────────────────

    /** All committee roles (Chair, Vice Chair, Secretary, Member, Liaison, etc.). */
    public get Roles(): mjBizAppsCommitteesRoleEntity[] {
        return this._Roles;
    }

    /** Officer roles (IsOfficer = true). */
    public get OfficerRoles(): mjBizAppsCommitteesRoleEntity[] {
        return this._Roles.filter(r => r.IsOfficer);
    }

    /** Voting roles (IsVotingRole = true). */
    public get VotingRoles(): mjBizAppsCommitteesRoleEntity[] {
        return this._Roles.filter(r => r.IsVotingRole);
    }

    /** All committee types (Standing, Ad Hoc, Workgroup, etc.). */
    public get CommitteeTypes(): mjBizAppsCommitteesTypeEntity[] {
        return this._CommitteeTypes;
    }

    /** All artifact types used for documents/files attached to committees. */
    public get ArtifactTypes(): mjBizAppsCommitteesArtifactTypeEntity[] {
        return this._ArtifactTypes;
    }

    /** All configured video conferencing providers (empty when caller lacks CanRead). */
    public get VideoProviders(): mjBizAppsCommitteesVideoProviderEntity[] {
        return this._VideoProviders;
    }

    /** Active video conferencing providers, sorted by Name ascending. */
    public get ActiveVideoProviders(): mjBizAppsCommitteesVideoProviderEntity[] {
        return this._VideoProviders
            .filter(p => p.IsActive)
            .sort((a, b) => (a.Name ?? '').localeCompare(b.Name ?? ''));
    }

    /** The default active video conferencing provider, or undefined if none configured. */
    public get DefaultVideoProvider(): mjBizAppsCommitteesVideoProviderEntity | undefined {
        return this._VideoProviders.find(p => p.IsActive && p.IsDefault);
    }

    // ─── O(1) Lookups ──────────────────────────────────────────────────────────

    private ensureRoleMaps(): void {
        if (!this._rolesById || !this._rolesByName) {
            const byId = new Map<string, mjBizAppsCommitteesRoleEntity>();
            const byName = new Map<string, mjBizAppsCommitteesRoleEntity>();
            for (const role of this._Roles) {
                if (role.ID) byId.set(normalizeKey(role.ID), role);
                if (role.Name) byName.set(normalizeKey(role.Name), role);
            }
            this._rolesById = byId;
            this._rolesByName = byName;
        }
    }

    /** Case-insensitive O(1) role lookup by ID. */
    public RoleById(id: string | null | undefined): mjBizAppsCommitteesRoleEntity | undefined {
        const key = normalizeKey(id);
        if (!key) return undefined;
        this.ensureRoleMaps();
        return this._rolesById?.get(key);
    }

    /** Case-insensitive O(1) role lookup by name. */
    public RoleByName(name: string | null | undefined): mjBizAppsCommitteesRoleEntity | undefined {
        const key = normalizeKey(name);
        if (!key) return undefined;
        this.ensureRoleMaps();
        return this._rolesByName?.get(key);
    }

    /** O(1) check for whether a RoleID is an officer role. */
    public IsOfficerRole(roleId: string | null | undefined): boolean {
        return this.RoleById(roleId)?.IsOfficer === true;
    }

    /** O(1) check for whether a RoleID is a voting role. */
    public IsVotingRole(roleId: string | null | undefined): boolean {
        return this.RoleById(roleId)?.IsVotingRole === true;
    }

    private ensureCommitteeTypeMaps(): void {
        if (!this._typesById || !this._typesByName) {
            const byId = new Map<string, mjBizAppsCommitteesTypeEntity>();
            const byName = new Map<string, mjBizAppsCommitteesTypeEntity>();
            for (const t of this._CommitteeTypes) {
                if (t.ID) byId.set(normalizeKey(t.ID), t);
                if (t.Name) byName.set(normalizeKey(t.Name), t);
            }
            this._typesById = byId;
            this._typesByName = byName;
        }
    }

    /** Case-insensitive O(1) committee-type lookup by ID. */
    public CommitteeTypeById(id: string | null | undefined): mjBizAppsCommitteesTypeEntity | undefined {
        const key = normalizeKey(id);
        if (!key) return undefined;
        this.ensureCommitteeTypeMaps();
        return this._typesById?.get(key);
    }

    /** Case-insensitive O(1) committee-type lookup by name. */
    public CommitteeTypeByName(name: string | null | undefined): mjBizAppsCommitteesTypeEntity | undefined {
        const key = normalizeKey(name);
        if (!key) return undefined;
        this.ensureCommitteeTypeMaps();
        return this._typesByName?.get(key);
    }

    private ensureArtifactTypeMaps(): void {
        if (!this._artifactTypesById || !this._artifactTypesByName) {
            const byId = new Map<string, mjBizAppsCommitteesArtifactTypeEntity>();
            const byName = new Map<string, mjBizAppsCommitteesArtifactTypeEntity>();
            for (const a of this._ArtifactTypes) {
                if (a.ID) byId.set(normalizeKey(a.ID), a);
                if (a.Name) byName.set(normalizeKey(a.Name), a);
            }
            this._artifactTypesById = byId;
            this._artifactTypesByName = byName;
        }
    }

    /** Case-insensitive O(1) artifact-type lookup by ID. */
    public ArtifactTypeById(id: string | null | undefined): mjBizAppsCommitteesArtifactTypeEntity | undefined {
        const key = normalizeKey(id);
        if (!key) return undefined;
        this.ensureArtifactTypeMaps();
        return this._artifactTypesById?.get(key);
    }

    /** Case-insensitive O(1) artifact-type lookup by name. */
    public ArtifactTypeByName(name: string | null | undefined): mjBizAppsCommitteesArtifactTypeEntity | undefined {
        const key = normalizeKey(name);
        if (!key) return undefined;
        this.ensureArtifactTypeMaps();
        return this._artifactTypesByName?.get(key);
    }

    private ensureVideoProviderMap(): void {
        if (!this._videoProvidersById) {
            const byId = new Map<string, mjBizAppsCommitteesVideoProviderEntity>();
            for (const p of this._VideoProviders) {
                if (p.ID) byId.set(normalizeKey(p.ID), p);
            }
            this._videoProvidersById = byId;
        }
    }

    /** Case-insensitive O(1) video-provider lookup by ID. */
    public VideoProviderById(id: string | null | undefined): mjBizAppsCommitteesVideoProviderEntity | undefined {
        const key = normalizeKey(id);
        if (!key) return undefined;
        this.ensureVideoProviderMap();
        return this._videoProvidersById?.get(key);
    }
}
