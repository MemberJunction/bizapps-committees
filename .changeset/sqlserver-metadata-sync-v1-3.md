---
"@mj-biz-apps/committees-entities": minor
---

Add the SQL Server Metadata_Sync migration that v1.2.0 shipped without (`V202609181200__v1.3.x__Metadata_Sync.sql`). A fresh SQL Server install now gets the seed data and entity configuration from `metadata/`: committee types, roles, artifact types, the Video Provider OAuth credential type, the External URL file storage provider, the Committee Importer prompt and agent, and the entity / field / relationship form and search settings. It replaces `V202607080009`, removed in v1.2.0, and is a full capture rather than a delta on top of it.

Raise the MemberJunction floor to `>=6.1.0-edge.6`. The migration's full-row core procedure calls need `spUpdateEntity @SubtypeSelector` and the restored `spCreateFileStorageProvider @SupportsSearch / @RequiresOAuth`, both first shipped in 6.1.0-edge.6.

Fix the publish workflow so it no longer lowers a hand-set prerelease `mjVersionRange` floor back to the `@memberjunction/core` dependency's version.
