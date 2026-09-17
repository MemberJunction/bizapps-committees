---
"@mj-biz-apps/committees-entities": patch
---

Drop the Person→Votes form-chrome overlay. Vote has MembershipID, not PersonID, so that EntityRelationship never exists and mj sync push fails looking it up.
