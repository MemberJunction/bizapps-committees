---
"@mj-biz-apps/committees-core": minor
"@mj-biz-apps/committees-ng": patch
"@mj-biz-apps/committees-core-entities-server": patch
"@mj-biz-apps/committees-server": patch
---

Committee pages, authorization, comment notifications and ballot reminders resolve a user to their Person, and a Person to their user, through the user's own People link first: `LinkedEntityRecordID`, when the user's `LinkedEntityID` is People or an IS-A subtype of it. `People.LinkedUserID`, which bizapps-common deprecated and a platform that binds users through a People subtype leaves empty, is the fallback. Before, such users had no committee access, permissions or dashboard, and received no comment notifications or ballot reminders. New exports from `@mj-biz-apps/committees-core`: `ResolvePersonIDForUser`, `ResolvePersonIDsForUsers`, `ResolveUserIDsForPeople`, `ResolveUserIDForPerson`, `LinkedPersonRecordID`, `IsPeopleEntity`, `PEOPLE_ENTITY`. The membership list, dashboard and comment thread now share `CommitteePermissionHelper.GetCurrentPersonID`.
