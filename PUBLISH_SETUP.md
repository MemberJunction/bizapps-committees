# Publishing Setup — bizapps-committees

This repo publishes the six `@mj-biz-apps/committees-*` packages to npm with the open-app release
pipeline shared across the BizApps repos. The release workflows and their scripts are copied
byte-for-byte from **bizapps-issues** and must stay identical; checks specific to this repo live
in `.github/workflows/repo-checks.yml`.

## Branch model

This repo follows release lines (`guides/RELEASE_LINES.md`):

```
feature ──PR──▶ next ──backport label──▶ lts/6.1 ──(App opens Version Packages PR)──▶ main ──(publish.yml)──▶ npm
```

- `next` is built on MJ Edge and **never versions or publishes**. PRs land there first, with a
  changeset (`pnpm run change`). A migration or `metadata/` change needs at least a **`minor`**
  changeset (`migration changeset` check).
- A `backport lts/X.Y` label on the PR into `next` makes `backport.yml` open the cherry-pick PR
  into that line once it merges. The changeset travels with it.
- Every push to a line runs `version.yml`, which refreshes that line's **Version Packages PR**,
  opened by the `blue-cypress-ci-bot` App. It runs `pnpm run version:prepare`: `changeset
  version`, the `mj-app.json` version and MJ range sync (`ci/sync-mj-app-version.mjs`), the
  upstream dependency range sync (`scripts/sync-mj-app-dependency-ranges.mjs`), and a lockfile
  refresh.
  - The newest line (`releasesThrough: main` in `release-lines.json`): `changeset-release/main`
    → `main`. Publishes as `latest`; afterwards the App opens and merges a
    `release-back-merge/vX.Y.Z` PR into the line.
  - An older line (`releasesThrough: branch`): `changeset-release/lts/X.Y` → `lts/X.Y`.
    Publishes under the dist-tag `lts-X.Y`; no back-merge.
- **Merging that PR is the release** (`Cut the Release` dispatch, `line` input empty for the
  newest line). `release-readiness.yml` gates it (`rr:` checks: no pending changesets, bump
  level, metadata shipped, Postgres counterparts, release base current, migration immutability,
  packages on npm). `publish.yml` publishes over npm OIDC under the line's dist-tag, tags
  `vX.Y.Z`, checks the dist-tag, and opens a PR into `next` removing the changesets it released.
- There is no hand-opened PR into `main`, and nothing commits to `main` directly.

## npm authentication — OIDC (no NPM_TOKEN secret)

`publish.yml` declares `id-token: write`; npm verifies the GitHub Actions OIDC identity at publish
time. Each package's **Settings → Trusted Publisher** on npmjs.com must name
`MemberJunction/bizapps-committees` and the `publish.yml` workflow.

## Org setup

- The `blue-cypress-ci-bot` App is installed on this repo, and the org `APP_CLIENT_ID` variable
  and `APP_PRIVATE_KEY` secret reach it.
- Rulesets: `protect-next` (PR required, the four door checks, strict; App bypass for pull
  requests only), `protect-main` (the seven `rr:` checks plus `build`, one approval) and
  `protect-lts` on `lts/*` (PR required, one approval, code-owner review, the `lines:` checks,
  the door checks and `build`; App bypass for pull requests only, for the back-merge and an
  older line's release PR).

## Notes

- `migrations/` holds a `B`-prefixed Flyway baseline; the filename and changeset checks match the
  `V…` files added after it.
- Every new `migrations/*.sql` needs a `migrations-pg/` counterpart
  (`pnpm run mj:migrate:convert`). A PR without one gets a warning; `rr: pg counterparts` fails
  the release until it exists.
- `mj-app.json` lists two upstream Open Apps, **mj-bizapps-common** and **mj-bizapps-tasks**.
  `scripts/sync-mj-app-dependency-ranges.mjs` derives each `versionRange` from the
  `@mj-biz-apps/common-entities` dependency in `packages/Core` and the
  `@mj-biz-apps/tasks-entities` dependency in `packages/Angular`, and fails if either is missing.
- The shared scripts read the release version from `packages/Entities/package.json`
  (`@mj-biz-apps/committees-entities`). The fixed `@mj-biz-apps/*` changesets group keeps every
  package at that one version.
- `mjVersionRange` is derived from the `@memberjunction/core` dependency and is never kept above
  it, so raise the package dependency when the app needs a newer MJ host, not just the manifest.
