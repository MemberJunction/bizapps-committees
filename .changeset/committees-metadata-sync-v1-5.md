---
'@mj-biz-apps/committees-entities': minor
---

Release seed for 1.5: `V202610231900__v1.5.x__Metadata_Sync.sql` and its PostgreSQL counterpart carry this release's metadata to hosts, which install by migration and never read `metadata/`: the "Committees: Visible Votes" row filter and the UI role's read-only permission on Votes through it (ballot sealing), and the Quorum Risk scoring set for Meetings (its record process, training pipeline, three Draft models and scoring binding). Every create is guarded and the permission is matched by entity, role and type, so a host that already pushed this metadata is unchanged.
