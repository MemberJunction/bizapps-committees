---
"@mj-biz-apps/committees-server": patch
---

Make V202609181200 metadata-sync seed creates idempotent

The v1.3.x metadata sync re-creates 29 seed records by literal ID, 27 of which
V202607080009 already created on any SQL Server install of v1.0.0–v1.1.1. The file
documented that such a database "must be rebuilt". On a live install it instead
aborted the whole upgrade at batch 1/112:

    Violation of PRIMARY KEY constraint 'PK__Credenti__3214EC27D685D4A7'.
    Cannot insert duplicate key in object '__mj.CredentialType'.
    The duplicate key value is (daa02013-510d-41f4-bfaa-9250c7bc7d37).

Every spCreate* call is now guarded by IF NOT EXISTS on its own primary key. A fresh
database creates all 29 as before; a database carrying V202607080009 skips the 27
shared IDs and creates only the genuinely new Template and TemplateContent. The 82
spUpdate* calls are unchanged — they already no-op on an absent ID.
