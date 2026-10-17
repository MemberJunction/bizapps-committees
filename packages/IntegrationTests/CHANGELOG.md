# @mj-biz-apps/committees-integration-tests

## 1.4.1

### Patch Changes

- 22be655: Ballot sealing is enforced on the server (C0). The UI role reads Votes through the new "Committees: Visible Votes" row filter: a member sees their own vote, roll-call votes on meeting motions, and every vote on a closed or cancelled ballot that is not sealed. Closing a ballot moves to the `CloseBallot` mutation, which tallies as the system user and stamps the motion; `BallotProgress` gives open ballots their participation counts. The custom Membership and Meeting entity classes now register under their entity names ("Committees: Memberships", "Committees: Meetings"), so their validation rules run.
- Updated dependencies [22be655]
- Updated dependencies [5296dc1]
- Updated dependencies [670f58a]
  - @mj-biz-apps/committees-core-entities-server@1.4.1
  - @mj-biz-apps/committees-server@1.4.1
  - @mj-biz-apps/committees-entities@1.4.1

## 1.4.0

### Patch Changes

- Updated dependencies [476e117]
  - @mj-biz-apps/committees-entities@1.4.0
  - @mj-biz-apps/committees-server@1.4.0

## 1.3.0

### Patch Changes

- Updated dependencies [dbb0270]
  - @mj-biz-apps/committees-entities@1.3.0
  - @mj-biz-apps/committees-server@1.3.0

## 1.2.0

### Patch Changes

- Updated dependencies [af1c6e6]
- Updated dependencies [39a6718]
- Updated dependencies [5ca3bf8]
- Updated dependencies [9b25f7f]
- Updated dependencies [0c121a3]
  - @mj-biz-apps/committees-entities@1.2.0
  - @mj-biz-apps/committees-server@1.2.0
