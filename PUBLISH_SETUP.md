# Publishing Setup — committees

This repo publishes the five `@mj-biz-apps/committees-*` packages to npm using a
Changesets-based pipeline, modeled on **bizapps-tasks** / **bizapps-common**
(`MemberJunction/bizapps-tasks`). The workflow files, validator scripts, `ci/`
helpers, and Changesets config are already in place.

## Branch model

```
feature branch ──PR──▶ next ──(merge)──▶ main ──(push triggers publish.yml)──▶ npm
```

- PRs land on **`next`**. `build.yml` + `changes.yml` run as checks.
- Changesets (`.changeset/*.md`) accumulate on `next`. A migration-bearing PR to
  `next` is *required* to include a changeset with at least a `minor` bump
  (`changes.yml` enforces this).
- Releasing = merging **`next` → `main`**. The push to `main` fires `publish.yml`,
  which (if pending changesets exist) bumps the fixed version across all five
  packages, builds, `changeset publish` to npm, tags `vX.Y.Z`, commits the bump
  back to `main`, then merges `main` → `next` and refreshes the lockfile.
- If there are **no** pending changesets, a push to `main` is a no-op.

> **Setup required:** if the remote only has `main`, you must create a **`next`**
> branch (`git push origin main:next`) and make it the repository's default
> branch on GitHub, so PRs target `next`. The Changesets `baseBranch` stays
> `main` (matching bizapps-tasks) — it is the comparison base for
> `changeset version`, not the PR target.

> **Branch protection:** like bizapps-tasks, `main` is **not** protected. The
> "publish only flows next→main" rule is a *convention*, enforced by discipline,
> not by a ruleset. `publish.yml` pushes the version-bump commit back to `main`
> using the default `GITHUB_TOKEN`, which works because `main` is open.

## npm authentication — OIDC (no NPM_TOKEN secret)

This repo publishes via **npm OIDC trusted publishing**, the same as
bizapps-tasks. The workflow declares `id-token: write` and npm verifies the
GitHub Actions OIDC identity at publish time — there is **no `NPM_TOKEN` secret**
to manage.

One-time setup on npmjs.com (per package, by an `@mj-biz-apps` org owner): under
each package's **Settings → Trusted Publisher**, add this repo
(`MemberJunction/committees`) and the `publish.yml` workflow. Trusted
publishing can only be configured *after* the package exists, so it happens
together with the placeholder publish below.

## First publish — npm placeholders

Until the five packages exist on npm, `validate-npm-packages.sh` fails the
publish job — every package needs at least a placeholder version published.
Publish a `0.0.0` placeholder for each **once, manually**, then the automated
flow takes over:

- `@mj-biz-apps/committees-entities`
- `@mj-biz-apps/committees-core`
- `@mj-biz-apps/committees-actions`
- `@mj-biz-apps/committees-server`
- `@mj-biz-apps/committees-ng`

After publishing each placeholder, configure its **Trusted Publisher** on npm
(see above) so the automated OIDC publish works.

## Checklist

- [ ] Create `next` branch on the remote (`git push origin main:next`) and set it as the default branch
- [ ] Publish `0.0.0` placeholders for all five packages (manually, with a token)
- [ ] Configure npm Trusted Publisher for each package → `MemberJunction/committees` / `publish.yml`
- [ ] Land a changeset on `next`, merge `next` → `main`, confirm `publish.yml` publishes + tags

## Notes / divergences from bizapps-tasks

- **Migration validators are ACTIVE here** (unlike bizapps-tasks, where they pass
  vacuously). committees ships real `V[0-9]{12}`-prefixed migrations, so
  `validate-migration-filenames.sh` and the timestamp/changeset gates in
  `changes.yml` genuinely enforce naming, monotonic timestamps, and the
  changeset requirement on migration-bearing PRs to `next`. The `B`-prefixed
  baseline (`B202602151200__…`) is not matched by the `V`-only gates — that's
  intentional; baselines are exempt.
- **Two upstream mj-app.json dependencies.** committees depends on both
  **mj-bizapps-common** and **mj-bizapps-tasks**. `publish.yml` syncs both
  `versionRange` entries in `mj-app.json` from the `@mj-biz-apps/common-server`
  and `@mj-biz-apps/tasks-server` dependencies declared in
  `apps/MJAPI/package.json`.
- The version-detection package (`packages/GeneratedEntities/package.json`,
  published as `@mj-biz-apps/committees-entities`) and the fixed
  `@mj-biz-apps/*` version group mean all five publish in lockstep at one version.
