# GENERAL RULE
Don't say "You're absolutely right" each time I correct you. Mix it up, that's so boring!

# Committees Application Development Guide

This is an application repository built on top of the [MemberJunction](https://github.com/MemberJunction/MJ) platform. It is NOT the MJ framework itself. We consume MJ packages via npm (`@memberjunction/*`) and extend them with our own entities, actions, and UI.

## Repository Structure

```
committees/
  apps/
    MJAPI/         - GraphQL API server (port 4101)
    MJExplorer/    - Angular UI application (port 4301)
  packages/
    Entities/           - CodeGen-generated entity subclasses
    GeneratedActions/   - CodeGen-generated action subclasses
```

---

## CRITICAL RULES - VIOLATIONS ARE UNACCEPTABLE

### 1. COMMIT AND PUSH ONLY WHAT IS FULLY TESTED
- **Commit on the feature branch when the work is tested**: the package builds, its unit tests pass, and the integration harness
  passes on a fresh world. A push carries only that; nothing half-done goes up.
- **Read the pull request's comments before every push**, and answer what they ask in the push or in the push's note.
- **Never rebase or force-push** a shared branch. Merge the remote branch before pushing.
- **Never commit local configuration** (`.env*`, a host's `mj.config.cjs` edits, a dev workspace's package links).
- **Each push gets a note on the pull request** that reports evidence, not intent: the test counts, the harness tallies after a
  purge and a fresh load, and which items it closes.

### 2. NO `any` TYPES - EVER
- **NEVER use `any` types in TypeScript code**
- **ALWAYS ask the user** if you think you need to use `any`
- This includes: No `as any`, No `: any`, No `<any>`, No `unknown` as a lazy alternative
- **Why**: MemberJunction has strong typing throughout - there's always a proper type available

### 3. NO MODIFICATIONS TO MERGED PRs
- **NEVER update title/description of merged PRs** without explicit approval each time

### 4. ANGULAR COMPONENT & MODULE STRATEGY
MemberJunction supports both standalone and NgModule-declared components. Choose the right approach for each situation:

#### When to Use Standalone Components (Preferred for New Components)
- **New leaf components** (dialogs, panels, small widgets) that don't need to share a module
- **Lazy-loaded route components** - standalone enables direct `loadComponent()` without wrapper modules
- **Simple, self-contained components** with clear dependency lists

#### When to Use NgModules
- **Feature modules** grouping many related components
- **Shared modules** providing common functionality to multiple consumers
- **Existing module-declared components** - don't migrate just for the sake of it

#### Rules for Both Approaches
- **Standalone components**: declare all dependencies in the component's `imports` array
- **NgModule components**: must use `standalone: false` explicitly (Angular 21 defaults to standalone)
- **Never mix within a single component** - a component is either standalone or module-declared
- When adding to an existing package, **follow the pattern already used in that package**

#### Modern Template Syntax (Required for New Code)
- **Use `@if`/`@for`/`@switch`** block syntax instead of `*ngIf`/`*ngFor`/`*ngSwitch`
- **Use `inject()` function** instead of constructor injection for new components

### 5. NO RE-EXPORTS BETWEEN PACKAGES
- **NEVER re-export types, classes, or interfaces from other packages**
- **ALWAYS** import directly from the source package that defines them

### 6. USE BaseSingleton FOR ALL SINGLETONS
- **NEVER use manual `static _instance` singleton patterns** - always extend `BaseSingleton<T>` from `@memberjunction/global`
- See MJ documentation for the pattern

---

## IMPORTANT
- Before starting a new line of work always check the local branch we're on and see if it is (a) separate from the default branch in the remote repo - we always want to work in local feature branches and (b) if we aren't in such a feature branch that is named for the work being requested and empty, cut a new one but ask first and then switch to it

**VERY IMPORTANT** We want you to be a high performance agent. Therefore whenever you need to spin up tasks - if they do not require interaction with the user and if they are not interdependent in any way, ALWAYS spin up multiple parallel tasks to work together for faster responses. **NEVER** process tasks sequentially if they are candidates for parallelization

## Git Branch Tracking Rules

### Feature Branches MUST Track Same-Named Remote Branches
When creating or working with feature branches, **ALWAYS** ensure the local branch tracks a remote branch **with the same name**. Never track `main` or other permanent branches.

```bash
# CORRECT
git checkout -b my-feature-branch
git push -u origin my-feature-branch

# WRONG - Branch created from main will track origin/main by default!
git checkout main
git checkout -b my-feature-branch
# Now my-feature-branch tracks origin/main - DANGEROUS!
```

### Before Every Push
1. Run `git branch -vv` to verify tracking
2. Ensure your branch tracks `origin/<same-branch-name>`
3. If tracking is wrong, fix it before pushing

---

## Build Commands
- Build all packages: `npm run build` (from repo root, uses Turborepo)
- Build generated packages: `npm run build:generated`
- Build API only: `npm run build:api`
- Build Explorer only: `npm run build:explorer`
- Start API server: `npm run start:api` (port 4101)
- Start Explorer UI: `npm run start:explorer` (port 4301)
- Build specific package: `cd packages/PackageName && npm run build`
- **IMPORTANT**: When building individual packages for testing/compilation, always use `npm run build` in the specific package directory

### Build Pipeline
- MJExplorer uses the Angular `application` builder powered by ESBuild and Vite
- Dev server uses Vite with HMR for fast iteration
- Source maps are configured for full debugging support including local packages

### NPM Workspace Management
- This is an NPM workspace monorepo
- **IMPORTANT**: To add dependencies to a specific package:
  - Define dependencies in the individual package's package.json
  - Run `npm install` at the repository root (NOT within the package directory)
  - Never run `npm install` inside individual package directories

## Development Workflow
- **CRITICAL**: After making code changes, always compile the affected package by running `npm run build` in that package's directory to check for TypeScript errors
- Fix all compilation errors before proceeding with additional changes
- **Tasks**: whenever you need to spin up tasks - if they do not require interaction with the user and if they are not interdependent in any way, ALWAYS spin up multiple parallel tasks to work together for faster responses

## Ports
- MJAPI GraphQL server: **4101** (configured via `GRAPHQL_PORT` in `.env`)
- MJExplorer Angular app: **4301** (configured in MJExplorer start script)
- These avoid conflicts with other MJ dev environments (MJ uses 4001/4201)

## Environment Configuration
- The repo root `.env` file contains all configuration (DB, auth, AI keys, etc.)
- `apps/MJAPI/.env` is a **symlink** to `../../.env` - do not create a separate file there
- Angular environment files are in `apps/MJExplorer/src/environments/`

---

## Code Style Guide
- Use TypeScript strict mode and explicit typing
- Always use MemberJunction generated `BaseEntity` sub-classes for all data work for strong typing
- No explicit `any` types - see CRITICAL RULES section above
- Prefer union types over enums for better package exports
- Prefer object shorthand syntax
- Follow existing naming conventions:
  - PascalCase for classes and interfaces
  - **PascalCase for public class members** (properties, methods, `@Input()`, `@Output()`)
  - **camelCase for private/protected class members**
  - camelCase for local variables and function parameters
  - Use descriptive names and avoid abbreviations
- Imports: group imports by type (external, internal, relative)
- Error handling: use try/catch blocks and provide meaningful error messages
- Keep functions focused and concise
- **NEVER use dynamic require() or import() statements** - always use static imports at the top of files unless explicitly requested

### Functional Decomposition Is Mandatory
- **NEVER** write long, monolithic functions that do multiple things
- **ALWAYS** decompose complex operations into smaller, well-named helper functions
- **MAXIMUM** function length should be ~30-40 lines (excluding comments)
- If a function is getting long, STOP and refactor it immediately

---

## MemberJunction Entity and Data Access Patterns

> **Full framework reference**: [docs/MJ-CLAUDE.md](docs/MJ-CLAUDE.md) — a snapshot of the
> MJ repo's CLAUDE.md. Read it for anything not covered here, especially the
> **BaseEngine caching pattern** below.

### RunView is EXPENSIVE — cache expected lookups in a BaseEngine
- Every `RunView` is a network + DB round trip. Do NOT re-query small, stable
  entity sets (Roles, Types, Committees, Terms) from every component load.
- The canonical MJ pattern is a `BaseEngine` subclass: `Config()` declares the
  cached entity sets, invalidation is automatic via BaseEntity events, and
  components read sync getters / subscribe to `ObserveProperty` observables.
- Reference implementations in MJ: `ConversationEngine`, `UserInfoEngine`,
  `ComponentMetadataEngine`. See docs/MJ-CLAUDE.md § "Reactive UIs over entity
  caches" and § "Check the Registry Before You Query".
- `BypassCache: true` remains the escape hatch for read-after-write paths that
  need true DB state.


### Entity Object Creation
**Never directly instantiate BaseEntity subclasses** - always use the Metadata system:

```typescript
// WRONG - bypasses MJ class system
const entity = new TemplateContentEntity();

// CORRECT - uses MJ metadata system
const md = new Metadata();
const entity = await md.GetEntityObject<TemplateContentEntity>('Template Contents');
```

### BaseEntity Spread Operator Limitation
**CRITICAL**: Never use the spread operator (`...`) directly on BaseEntity-derived classes. Use `GetAll()` instead:

```typescript
// WRONG
const data = { ...myEntity, extraField: 'value' };

// CORRECT
const data = { ...myEntity.GetAll(), extraField: 'value' };
```

### Server-Side Context User Requirements
When working on server-side code, **ALWAYS** pass `contextUser` to `GetEntityObject` and `RunView` methods:

```typescript
// WRONG - missing contextUser on server
const entity = await md.GetEntityObject<SomeEntity>('Entity Name');

// CORRECT - includes contextUser for server-side operations
const entity = await md.GetEntityObject<SomeEntity>('Entity Name', contextUser);
```

### Loading Records with RunView
```typescript
const rv = new RunView();
const results = await rv.RunView<TemplateContentEntity>({
    EntityName: 'Template Contents',
    ExtraFilter: `TemplateID='${recordId}'`,
    OrderBy: 'Priority ASC',
    ResultType: 'entity_object'  // Returns actual entity objects
});
```

### RunView Error Handling
**Important**: RunView does NOT throw exceptions. Check `Success` property:

```typescript
const result = await rv.RunView<SomeEntity>({...});
if (result.Success) {
    const items = result.Results || [];
} else {
    console.error('Failed:', result.ErrorMessage);
}
```

### ResultType: entity_object vs simple
- Use `entity_object` when you need to **mutate and save** records
- Use `simple` with `Fields` parameter when you only need to **read/display** data
- **DO NOT** use `Fields` parameter with `entity_object` - it is automatically ignored

### Batch Queries with RunViews
Use `RunViews` (plural) for multiple independent queries:

```typescript
const rv = new RunView();
const [items, categories] = await rv.RunViews([
    { EntityName: 'Items', ExtraFilter: '', ResultType: 'entity_object' },
    { EntityName: 'Categories', ExtraFilter: '', ResultType: 'entity_object' }
]);
```

---

## Angular Development Best Practices

### Change Detection
- Add `ChangeDetectorRef` and use `cdr.detectChanges()` after programmatic changes
- Replace `setTimeout` with `Promise.resolve().then()` for microtask timing

### Input Properties - Use Getter/Setters
```typescript
// GOOD - Precise control with getter/setter
private _myInput: string | null = null;

@Input()
set myInput(value: string | null) {
    const prev = this._myInput;
    this._myInput = value;
    if (value && value !== prev) this.onMyInputChanged(value);
}
get myInput(): string | null { return this._myInput; }
```

### Loading Indicators
- **ALWAYS** use the `<mj-loading>` component from `@memberjunction/ng-shared-generic`
- **NEVER** create custom spinners

### Dialog Button Placement
- **Confirm/Submit buttons go on the LEFT**, Cancel buttons on the RIGHT

### Icon Libraries
- **Primary**: Font Awesome (already included)

---

## CodeGen

This repo uses MemberJunction's CodeGen system to generate entity and action subclasses. The generated code lives in:
- `packages/Entities/` - Entity TypeScript classes with Zod schemas
- `packages/GeneratedActions/` - Action TypeScript classes

**Key rules:**
- Never manually edit files in generated directories - CodeGen will overwrite them
- Always run CodeGen after database schema changes
- Run `npm run mj:codegen` from repo root to regenerate

## Database Migrations
- Run `npm run mj:migrate` from repo root
- See MJ documentation for migration file format and conventions
- Never include `__mj_CreatedAt`/`__mj_UpdatedAt` columns in CREATE TABLE - CodeGen handles them
- Never create indexes for foreign key columns - CodeGen creates them automatically

---

## Debugging

### VSCode Launch Configurations
- **MJAPI**: Node.js debugger with source maps for local packages
- **MJExplorer**: Chrome debugger (port 4301) with source maps
- **MJExplorer (attach)**: Attach to existing Chrome on port 9222
- **Full Stack**: Compound configuration running both MJAPI + MJExplorer

### Source Map Scoping
Source maps are scoped to local packages only (`apps/MJAPI/**`, `packages/Entities/**`, `packages/GeneratedActions/**`). Third-party packages and node_modules are excluded to avoid noise.

---

## Performance & Caching — 5-Rule BizApps Standard

> Also summarized in [`AGENTS.md`](AGENTS.md) for all coding agents working in this repository.

Every `RunView` is a network + database round trip. All new and modified code in `bizapps-committees` **MUST** follow the **5-Rule BizApps Performance & Caching Standard**:

1. **`BaseEngine` Taxonomy & Lookup Caching (`CommitteesLookupEngine`):**
   - Never re-query bounded, slow-changing taxonomy/lookup tables (`Committees: Roles`, `Committees: Types`, `Committees: Artifact Types`, `Committees: Video Providers`) in Angular components, dialogs, or server services.
   - Always read from `CommitteesLookupEngine.Instance` (`@mj-biz-apps/committees-core/lookup` in browser packages, `@mj-biz-apps/committees-core` on server) using its O(1) lookup helpers (`RoleById`, `RoleByName`, `IsOfficerRole`, `IsVotingRole`, `CommitteeTypeById`, `CommitteeTypeByName`, `ArtifactTypeById`, `VideoProviderById`, `DefaultVideoProvider`, `ActiveVideoProviders`).
   - Use `CacheLocal: true` ONLY on shared, non-RLS reference tables (`Roles`, `Types`, `Artifact Types`).

2. **Multi-Provider, Impersonation & RLS `CacheLocal` Safety:**
   - Every `BaseEngine` subclass **MUST** override `public override get ProviderToUse(): IMetadataProvider` to return the active provider passed to `Config()` (falling back to `Metadata.Provider`), preventing `BaseEngine`'s first-wins `_provider` latch from serving stale-user data during impersonation or multi-provider requests.
   - Track `_loadedForUserId` and force a reload whenever the effective user changes; expose `InvalidateCache()` for mutations and persona switches.
   - Set **`CacheLocal: false`** on any RLS-scoped, user-scoped, or role-restricted entity (such as `Committees: Video Providers`) so IndexedDB never leaks rows across personas.
   - Gate optional/restricted entities on `EntityInfo.GetUserPermisions(user)?.CanRead` before adding them to `BaseEngine.Load()` configs so restricted roles never fail engine startup.
   - Session caches (like `CommitteePermissionHelper`) MUST reset on user change and deduplicate concurrent in-flight promises.

3. **Batch Independent Queries with `rv.RunViews([...])`:**
   - **NEVER** wrap multiple independent `rv.RunView(...)` calls in `Promise.all([...])` or await independent `rv.RunView(...)` calls sequentially — collapse them into a single **`rv.RunViews([...])`** GraphQL/DB batch call.
   - Route `RunView` through the active provider (`RunView.FromMetadataProvider(this.ProviderToUse)` inside entity subclasses/engines instead of casting `as unknown as IRunViewProvider` or calling bare `new RunView()`).
   - Use `ResultType: 'simple'` with explicit `Fields: [...]` whenever mutation/save is not needed; reserve `ResultType: 'entity_object'` for write paths.
   - **NEVER** issue `RunView` calls inside loops — batch upfront and join in memory.

4. **`ConversationEngine`-Style Bounded Container Caching (No Unbounded/Filtered List Caches):**
   - For hot, bounded parent containers (such as a single active form/committee/meeting structure loaded across tabs), cache by container ID with an explicit entry cap (LRU), in-flight promise deduplication, user-switch clearing, and automatic invalidation on `BaseEntity` save/delete events.
   - **NEVER** cache unbounded transactional tables (`Meetings`, `Votes`, `Comments`, `Attendances`, `Ballots`, `Memberships`) globally in a `BaseEngine`, and **NEVER** cache arbitrary filtered list queries.

5. **RLS-Safe Two-Step Entity Reads (Zero Raw Cross-View SQL Subqueries):**
   - **NEVER** bypass entity row-level security with raw SQL subqueries inside `ExtraFilter` (e.g. `ID IN (SELECT ... FROM [__mj_BizAppsCommittees].[vwMeetings] ...)` or `[__mj_BizAppsTasks].[vwTaskAssignments]`).
   - Instead, resolve accessible parent IDs via a first-class `RunView` (with fast-path empty return when 0 rows), chunk `ID IN (...)` filters (e.g. 400 IDs per batch via `rv.RunViews`), UUID-validate any interpolated ID, and explicitly check `result.Success`.

### Use View Fields Instead of Lookups
- Most MJ views include denormalized fields from related entities
- Use the denormalized field directly instead of a separate lookup query

---

## MJ Docs (`MJ: Artifacts`) vs. `MJ: Comments` vs. Quick Notes

Use this three-category rubric when modeling textual content in `bizapps-committees` so governance records stay clean, auditable, and free of over-engineering:

| Category | Backing Store | When to Use | Committees Examples |
|---|---|---|---|
| **Category A — Rich / Versioned Governance Documents** | **MJ Docs** (`MJ: Artifacts` + `MJ: Artifact Versions`) linked via nullable `MJArtifactID` (and optional `ApprovedArtifactVersionID` for immutable governance snapshots), rendered with `<mj-artifact-viewer-panel>` from `@memberjunction/ng-artifacts` | Long-form, multi-revision, formatted, or formally approved documents needing version history, immutable approval pinning, AI extraction/refinement, or rich inline preview | `Committees: Minutes` (`MJArtifactID` + `ApprovedArtifactVersionID`; legacy `Minute.Content` preserved via dual-read + opt-in bridge), native `Committees: Artifacts` (`MJArtifactID` alongside external URLs) |
| **Category B — Threaded Review Discussions** | **`MJ: Comments`** / `Committees: Comments` (threaded `ParentCommentID` hierarchy) | Conversational back-and-forth, review feedback, questions, and discussion threads attached to a committee, meeting, motion, task, or artifact | Meeting prep discussions, review commentary on draft minutes, task/artifact comment threads |
| **Category C — Short Relational Quick Notes** | **Relational `Notes` / text columns** directly on the domain table (NEVER migrate to `MJ: Artifacts`) | Short, atomic, row-scoped annotations, rationales, or clerical remarks tied 1:1 to a transactional record | `Committees: Motions.Notes`, `Committees: Votes.Notes`, `Committees: Attendances.Notes` |

### Key Invariants for Category A Dual-Read & Pinning
- **Strictly additive (`PUBLISH_NO_BREAK_POLICY.md`)**: Never drop or rename `Minute.Content`, `Minute.ArtifactID`, or external URL `Artifact` fields.
- **Pinning consistency (`MinuteEntityCustom`)**: `ApprovedArtifactVersionID` cannot be set when `MJArtifactID` is `NULL`, and must reference a version belonging to the linked `MJArtifactID`.
- **Single-batch dual-read (`MinuteArtifactBridgeService`)**: Load `MJ: Artifacts` and `MJ: Artifact Versions` in one chunked `rv.RunViews([...])` call (`ResultType: 'simple'`). When `ApprovedArtifactVersionID` is set, render that immutable version read-only; when `NULL`, float on the latest draft version; when `MJArtifactID` is `NULL`, render legacy `Minute.Content` with an opt-in bridge helper that leaves `Minute.Content` intact.

---

## GitHub Repository
- Repository: https://github.com/MemberJunction/bizapps-committees
- Default branch: `next`
- PRs target `next`

## Release lines

`next` is built on MJ Edge and never publishes. Production releases come from release lines (`lts/<MJ major.minor>`), listed in `release-lines.json`. Land every change on `next` first, then add a `backport lts/X.Y` label; a PR that adds a migration needs a label for every open line, or its files listed as edge-only in `release-lines.json`. Never open a PR straight into a line or into `main`. Full rules, publishing and the line cut: [guides/RELEASE_LINES.md](guides/RELEASE_LINES.md).

## Metadata ships as release migrations

`mj app install` and upgrades run migrations only. There is no metadata phase, by design. A record that exists only as JSON under `metadata/` reaches no host until a release ships it inside a migration.

- **PRs carry metadata JSON only.** Never hand-write or generate a `*__Metadata_Sync.sql` in a feature PR.
- **The build engineer** generates one differential `Metadata_Sync` migration per release, from a fresh database.
- **Rows missing after a fresh install** usually mean a release shipped without its metadata migration. Hand that to the build engineer rather than changing the installer.

The model, and the Open App steps that differ from core (`--schema`, the `${mjSchema}` substitution): [Release Metadata Migrations Guide](https://github.com/MemberJunction/MJ/blob/next/guides/RELEASE_METADATA_MIGRATIONS_GUIDE.md).
