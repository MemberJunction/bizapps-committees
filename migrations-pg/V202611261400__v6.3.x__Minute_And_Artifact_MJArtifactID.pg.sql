-- @mj-pg-provenance: split-bake v1 source=V202611261400__v6.3.x__Minute_And_Artifact_MJArtifactID.sql source-sha256=b847290ffff57ae0abf4130a502d88882007476000caf96c9195d3a12b8c001c mode=needs-hand-rebaked
-- ============================================================================
-- MemberJunction PostgreSQL Migration — V202611261400__v6.3.x__Minute_And_Artifact_MJArtifactID.sql
-- Split-and-regenerate with INLINE NATIVE CodeGen baking: hand-written DDL transpiled
-- (AST dialect), metadata DML inline, and CodeGen objects (views/sprocs/triggers/grants)
-- baked natively from `mj codegen`. Applies standalone via `mj migrate` — no deploy codegen.
-- ============================================================================

-- None required: UUID defaults use the built-in gen_random_uuid() (PostgreSQL 13+).
CREATE SCHEMA IF NOT EXISTS __mj_BizAppsCommittees;
SET search_path TO __mj_BizAppsCommittees, public;
SET standard_conforming_strings = on;

ALTER TABLE __mj_BizAppsCommittees."Minute"
  ADD COLUMN "MJArtifactID" UUID NULL,
  ADD COLUMN "ApprovedArtifactVersionID" UUID NULL;

ALTER TABLE __mj_BizAppsCommittees."Minute"
  ADD CONSTRAINT "FK_Minute_MJArtifact" FOREIGN KEY ("MJArtifactID") REFERENCES "__mj"."Artifact" (
    "ID"
  ) ON DELETE NO ACTION,
  ADD CONSTRAINT "FK_Minute_ApprovedArtifactVersion" FOREIGN KEY ("ApprovedArtifactVersionID") REFERENCES "__mj"."ArtifactVersion" (
    "ID"
  ) ON DELETE NO ACTION;

ALTER TABLE __mj_BizAppsCommittees."Artifact"
ADD COLUMN "MJArtifactID" UUID NULL;

ALTER TABLE __mj_BizAppsCommittees."Artifact"
  ADD CONSTRAINT "FK_Artifact_MJArtifact" FOREIGN KEY ("MJArtifactID") REFERENCES "__mj"."Artifact" (
    "ID"
  ) ON DELETE NO ACTION;

COMMENT ON COLUMN __mj_BizAppsCommittees."Minute"."MJArtifactID" IS 'Optional foreign key to MJ: Artifacts linking this meeting minute to a native MJ Docs document. When NULL, legacy Minute.Content is used.';

COMMENT ON COLUMN __mj_BizAppsCommittees."Minute"."ApprovedArtifactVersionID" IS 'Optional foreign key to MJ: Artifact Versions pinning this minute to an immutable approved version of the linked MJArtifactID document. Must belong to MJArtifactID and must be NULL when MJArtifactID is NULL.';

COMMENT ON COLUMN __mj_BizAppsCommittees."Artifact"."MJArtifactID" IS 'Optional foreign key to MJ: Artifacts linking this committee artifact to a native MJ Docs document. When NULL, the artifact is an external URL or cloud-provider link.';

/* Seed Hierarchy.IsHierarchy on legacy self-referencing FK Committees: Agenda Items.ParentAgendaItemID */
UPDATE "__mj"."EntityField" SET "Configuration" = '{"Hierarchy":{"IsHierarchy":true}}'
WHERE
  "ID" = 'F3793FB0-E8BE-4E77-9776-8EAC87E2FD8E'
  AND (
    "Configuration" IS NULL OR "Configuration" = ''
  );
/* Seed Hierarchy.IsHierarchy on legacy self-referencing FK Committees: Comments.ParentCommentID */
UPDATE "__mj"."EntityField" SET "Configuration" = '{"Hierarchy":{"IsHierarchy":true}}'
WHERE
  "ID" = '4D316764-A3C3-473B-BEF5-03B6CC27699F'
  AND (
    "Configuration" IS NULL OR "Configuration" = ''
  );
/* Seed Hierarchy.IsHierarchy on legacy self-referencing FK Committees: Committees.ParentCommitteeID */
UPDATE "__mj"."EntityField" SET "Configuration" = '{"Hierarchy":{"IsHierarchy":true}}'
WHERE
  "ID" = 'D0D9D59A-0081-4B68-AE77-CD8F6D9F92F8'
  AND (
    "Configuration" IS NULL OR "Configuration" = ''
  );
/* SQL text to insert 3 new entity field(s) */;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityField" WHERE "ID" = '85f11ba1-7826-422a-b8cb-a69b74192f25' OR ("EntityID" = '272BEFB5-727A-4525-B235-775A56B7ACBB' AND "Name" = 'MJArtifactID')) THEN
    INSERT INTO "__mj"."EntityField" ("ID", "EntityID", "Sequence", "Name", "DisplayName", "Description", "Type", "Length", "Precision", "Scale", "AllowsNull", "DefaultValue", "AutoIncrement", "AllowUpdateAPI", "IsVirtual", "IsComputed", "RelatedEntityID", "RelatedEntityFieldName", "IsNameField", "IncludeInUserSearchAPI", "IncludeRelatedEntityNameFieldInBaseView", "DefaultInView", "IsPrimaryKey", "IsUnique", "RelatedEntityDisplayType", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('85f11ba1-7826-422a-b8cb-a69b74192f25', '272BEFB5-727A-4525-B235-775A56B7ACBB' /* Entity: Committees: Artifacts */, (SELECT COALESCE(MAX("Sequence"), 0) + 1 FROM "__mj"."EntityField" WHERE "EntityID" = '272BEFB5-727A-4525-B235-775A56B7ACBB'), 'MJArtifactID', 'MJ Artifact ID', 'Optional foreign key to MJ: Artifacts linking this committee artifact to a native MJ Docs document. When NULL, the artifact is an external URL or cloud-provider link.', 'uniqueidentifier', 16, 0, 0, TRUE, NULL, FALSE, TRUE, FALSE, FALSE, 'F48D2341-8667-40BB-BCA8-87D7F80E16CD', 'ID', FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, 'Search', NOW(), NOW());
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityField" WHERE "ID" = '94b85e5a-de77-4b71-bc0d-0b7123794ed8' OR ("EntityID" = '0EC944F9-F908-4662-87B2-E57077A873FF' AND "Name" = 'MJArtifactID')) THEN
    INSERT INTO "__mj"."EntityField" ("ID", "EntityID", "Sequence", "Name", "DisplayName", "Description", "Type", "Length", "Precision", "Scale", "AllowsNull", "DefaultValue", "AutoIncrement", "AllowUpdateAPI", "IsVirtual", "IsComputed", "RelatedEntityID", "RelatedEntityFieldName", "IsNameField", "IncludeInUserSearchAPI", "IncludeRelatedEntityNameFieldInBaseView", "DefaultInView", "IsPrimaryKey", "IsUnique", "RelatedEntityDisplayType", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('94b85e5a-de77-4b71-bc0d-0b7123794ed8', '0EC944F9-F908-4662-87B2-E57077A873FF' /* Entity: Committees: Minutes */, (SELECT COALESCE(MAX("Sequence"), 0) + 1 FROM "__mj"."EntityField" WHERE "EntityID" = '0EC944F9-F908-4662-87B2-E57077A873FF'), 'MJArtifactID', 'MJ Artifact ID', 'Optional foreign key to MJ: Artifacts linking this meeting minute to a native MJ Docs document. When NULL, legacy Minute.Content is used.', 'uniqueidentifier', 16, 0, 0, TRUE, NULL, FALSE, TRUE, FALSE, FALSE, 'F48D2341-8667-40BB-BCA8-87D7F80E16CD', 'ID', FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, 'Search', NOW(), NOW());
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityField" WHERE "ID" = 'e52aef7a-c9f8-4cde-ab50-825e4304893a' OR ("EntityID" = '0EC944F9-F908-4662-87B2-E57077A873FF' AND "Name" = 'ApprovedArtifactVersionID')) THEN
    INSERT INTO "__mj"."EntityField" ("ID", "EntityID", "Sequence", "Name", "DisplayName", "Description", "Type", "Length", "Precision", "Scale", "AllowsNull", "DefaultValue", "AutoIncrement", "AllowUpdateAPI", "IsVirtual", "IsComputed", "RelatedEntityID", "RelatedEntityFieldName", "IsNameField", "IncludeInUserSearchAPI", "IncludeRelatedEntityNameFieldInBaseView", "DefaultInView", "IsPrimaryKey", "IsUnique", "RelatedEntityDisplayType", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('e52aef7a-c9f8-4cde-ab50-825e4304893a', '0EC944F9-F908-4662-87B2-E57077A873FF' /* Entity: Committees: Minutes */, (SELECT COALESCE(MAX("Sequence"), 0) + 1 FROM "__mj"."EntityField" WHERE "EntityID" = '0EC944F9-F908-4662-87B2-E57077A873FF'), 'ApprovedArtifactVersionID', 'Approved Artifact Version ID', 'Optional foreign key to MJ: Artifact Versions pinning this minute to an immutable approved version of the linked MJArtifactID document. Must belong to MJArtifactID and must be NULL when MJArtifactID is NULL.', 'uniqueidentifier', 16, 0, 0, TRUE, NULL, FALSE, TRUE, FALSE, FALSE, 'AEB408D2-162A-49AE-9DC2-DBE9A21A3C01', 'ID', FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, 'Search', NOW(), NOW());
  END IF;
END $$;

/* SQL text to sync entity unique keys (7 added, 0 updated, 0 removed) */
INSERT INTO "__mj"."EntityUniqueKey" (
  "ID",
  "EntityID",
  "Name",
  "FieldNames",
  "FilterDefinition"
)
VALUES
  (
    '1ca2adea-9073-4785-9459-0baf06973c16',
    '07BB0F44-EC35-4CAF-8C36-A766A545159D',
    'UQ_ArtifactType_Name',
    'Name',
    NULL
  ) ON CONFLICT DO NOTHING;
INSERT INTO "__mj"."EntityUniqueKey" (
  "ID",
  "EntityID",
  "Name",
  "FieldNames",
  "FilterDefinition"
)
VALUES
  (
    'b8878a97-68bc-46ea-89a8-d8360d880dc8',
    '194B3496-2829-4806-BC42-CF0724A1DD26',
    'UQ_Ballot_Motion',
    'MotionID',
    NULL
  ) ON CONFLICT DO NOTHING;
INSERT INTO "__mj"."EntityUniqueKey" (
  "ID",
  "EntityID",
  "Name",
  "FieldNames",
  "FilterDefinition"
)
VALUES
  (
    '7a3610ba-f54a-4971-8714-79f2c92edc4b',
    '93C97937-A33B-41D2-9791-FC271E49F96F',
    'UQ_Type_Name',
    'Name',
    NULL
  ) ON CONFLICT DO NOTHING;
INSERT INTO "__mj"."EntityUniqueKey" (
  "ID",
  "EntityID",
  "Name",
  "FieldNames",
  "FilterDefinition"
)
VALUES
  (
    '0ad5238d-7ab7-4a8b-a358-e3c414ac2191',
    '94A59079-7436-4178-A31B-9B42DDA822C1',
    'UQ_Vote',
    'MotionID,MembershipID',
    NULL
  ) ON CONFLICT DO NOTHING;
INSERT INTO "__mj"."EntityUniqueKey" (
  "ID",
  "EntityID",
  "Name",
  "FieldNames",
  "FilterDefinition"
)
VALUES
  (
    '78ac5cad-b26a-4051-a0ff-c6f3e51a4a43',
    '9BEDCBE8-0EF8-4F86-AB72-2063CE41A138',
    'UQ_Role_Name',
    'Name',
    NULL
  ) ON CONFLICT DO NOTHING;
INSERT INTO "__mj"."EntityUniqueKey" (
  "ID",
  "EntityID",
  "Name",
  "FieldNames",
  "FilterDefinition"
)
VALUES
  (
    '47feced7-8e78-493a-ba8c-3b443a625181',
    'E7D9813E-3C34-4233-AFCC-4CB76CFE081C',
    'UQ_Attendance',
    'MeetingID,PersonID',
    NULL
  ) ON CONFLICT DO NOTHING;
INSERT INTO "__mj"."EntityUniqueKey" (
  "ID",
  "EntityID",
  "Name",
  "FieldNames",
  "FilterDefinition"
)
VALUES
  (
    'b4b529f2-5734-4e2e-930b-e99bb3f33f8c',
    'F11B4DC5-9850-4782-B3A1-7D2277A19837',
    'UQ_VideoProvider_Name',
    'Name',
    NULL
  ) ON CONFLICT DO NOTHING;
/* SQL text to sync 6 entity field value row(s) for entity field ID 037FF375-4775-4E79-A577-B6CAC28232DE */
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '9BA1DA62-82EB-4B7F-AA0C-1B7C9980E286';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'DA4324A6-0C88-4798-AF2A-9E9A412D5C12';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '77E83A77-DA4C-42D5-BD2E-C0339C786175';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '15AC8450-4FBA-4304-98B7-25F53FF3DDAC';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '643B43E9-0B99-480D-A25C-B9D31CA72682';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '5C841A86-EE7F-4DDC-A574-48BF8098300C';
/* SQL text to sync 3 entity field value row(s) for entity field ID 027FDC1A-8C4C-4213-BEFA-0732875E3E25 */
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '60AE11A9-477F-42C8-8D5D-8FD9124B18FB';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '6AC0F3F4-9487-4653-B7A1-E34D1C8F9005';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '8FFCA08A-018B-4E26-A7B3-D3FC20B90415';
/* SQL text to sync 6 entity field value row(s) for entity field ID 8A910201-7941-4805-87DF-6B5474738257 */
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'D2725FCB-D772-4C9B-9850-77A13D3E84E5';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '97BD7889-7D51-4C85-8794-64E08D0A8572';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'D7C0AB32-6542-41FB-98F5-2659CB6E9296';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'F73EA186-195D-421C-B56B-565E5D8B542E';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'F2295655-AB8E-4193-92AD-B7165CC41E94';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'EECD42D1-8CF4-463B-9ED4-C97A87872BB0';
/* SQL text to sync 5 entity field value row(s) for entity field ID 56526981-0CC5-4CC8-BBD9-DF18DF2D25AB */
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'B36E3A90-8514-46CE-85E9-8DFA8BE233C0';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '857CA9E8-461F-4A95-8D2F-B245FCA2192A';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'DD6BD229-C92C-4263-971C-057FE95B3763';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'A9AB5983-B061-4773-9E07-582D6B43C0A7';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '68044DC3-8999-4011-B859-868D03538C75';
/* SQL text to sync 5 entity field value row(s) for entity field ID 384C5BD0-6CF2-4BCE-8864-97B3EE0437FD */
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'AC9CDEF1-016B-4CDA-8FD0-9AD460E0DF02';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '77A11F9B-1781-41B7-9EBB-B21895AEC7CD';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'AE792113-6E50-4269-8F52-C18B42172096';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '8428D005-58C3-468E-A5B1-BC757EA88120';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '53582FC4-9028-4F5E-83DF-BE4043089747';
/* SQL text to sync 6 entity field value row(s) for entity field ID E750F12D-98D2-4B8F-87D1-BF5EC239E0B5 */
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '7B071685-8E73-473E-886A-6513759930D5';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '3E3446B7-B6EB-480C-AB96-EB2C5433F608';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '1FB13A4A-8353-4513-85A8-C482185DCFC5';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '29689013-42C3-421C-AA91-D4651DA1C046';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'F425B007-5BC4-47DD-8B52-3828D6F3E340';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '076E3A07-4E95-40EE-98A7-8161A920DB66';
/* SQL text to sync 4 entity field value row(s) for entity field ID 9E003073-E3D2-47E3-8BB4-BE12A8E6FE2B */
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '53B2D78E-6B49-4FAE-99A1-2C259997A8A0';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'B761349A-3BFB-4629-8ADA-B95508A3C81D';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '399F92FA-EC9D-407E-98C7-3C32B7D8F6D6';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'A82B1009-F6A9-4D0D-8B5E-5DBC2E0ACD8F';
/* SQL text to sync 5 entity field value row(s) for entity field ID 218BE2B4-659F-479F-8495-E7A5F4BDD60A */
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'C1E7CFC8-3352-4371-B007-7D055FDC5FB0';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '440DA35F-B40B-4221-B90B-8E81CEE578DA';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '493D32E0-91AC-409A-8265-3943990434EB';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '450E5F15-B5E4-4551-A903-F29896064668';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'D1657F4F-2D5B-407D-BA83-311FB957E3B0';
/* SQL text to sync 4 entity field value row(s) for entity field ID D7477465-D420-4905-B722-00B8794609DE */
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '6C4593E8-50EF-4172-BFA0-3087DDCCAAE8';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '670F5730-9439-4277-8050-C2D6EE009A47';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '40437D32-01D0-4712-A97C-0D70E51728A4';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'BC5142AF-5A90-4934-A38C-E5F326AA679B';
/* SQL text to sync 3 entity field value row(s) for entity field ID F4D30FF9-116C-4401-BCAF-A33631988BFD */
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '951AFFFA-40B0-4B04-BFC0-AD01582CA324';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'B6D5F97C-E4C4-4838-9DA2-B206F7055783';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '7D63B23F-33DE-49D3-82C8-1B58CA35C6CF';
/* SQL text to sync 3 entity field value row(s) for entity field ID 101F8FD4-5ACC-4368-84A6-CC6FED8ECC93 */
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'DC67AAD8-0DD3-44BB-B974-C02E825F1C87';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '0C25B161-6189-47EA-87A8-A9D58F474352';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '26D7F873-45D3-410B-AC00-3F4381372937';
/* SQL text to sync 3 entity field value row(s) for entity field ID 0A11C5F0-25BF-45B0-A299-699162195771 */
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'F02AAADF-3B5D-4D0E-BA2E-2E92C7A7B1AE';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '081EADFF-20F2-495A-9CCB-C2C8D9FE495C';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'C4A96028-203C-4048-9462-B7116F19D108';
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM "__mj"."EntityField" WHERE "ID" = 'C1A02E75-4C6E-49B0-96F3-79D1A8E26072') THEN
/* SQL text to sync 4 entity field value row(s) for entity field ID C1A02E75-4C6E-49B0-96F3-79D1A8E26072 */
INSERT INTO "__mj"."EntityFieldValue" (
  "ID",
  "EntityFieldID",
  "Sequence",
  "Value",
  "Code",
  "Source",
  "__mj_CreatedAt",
  "__mj_UpdatedAt"
)
VALUES
  (
    'fb286223-facf-4fb2-a936-7ac78dd484de',
    'C1A02E75-4C6E-49B0-96F3-79D1A8E26072',
    1,
    'Critical',
    'Critical',
    'Check',
    NOW(),
    NOW()
  ) ON CONFLICT DO NOTHING;
INSERT INTO "__mj"."EntityFieldValue" (
  "ID",
  "EntityFieldID",
  "Sequence",
  "Value",
  "Code",
  "Source",
  "__mj_CreatedAt",
  "__mj_UpdatedAt"
)
VALUES
  (
    'a1e73121-0377-430b-b838-dd469e417119',
    'C1A02E75-4C6E-49B0-96F3-79D1A8E26072',
    2,
    'High',
    'High',
    'Check',
    NOW(),
    NOW()
  ) ON CONFLICT DO NOTHING;
INSERT INTO "__mj"."EntityFieldValue" (
  "ID",
  "EntityFieldID",
  "Sequence",
  "Value",
  "Code",
  "Source",
  "__mj_CreatedAt",
  "__mj_UpdatedAt"
)
VALUES
  (
    '4330ef70-f32e-440c-b43e-8cde79ce0532',
    'C1A02E75-4C6E-49B0-96F3-79D1A8E26072',
    3,
    'Low',
    'Low',
    'Check',
    NOW(),
    NOW()
  ) ON CONFLICT DO NOTHING;
INSERT INTO "__mj"."EntityFieldValue" (
  "ID",
  "EntityFieldID",
  "Sequence",
  "Value",
  "Code",
  "Source",
  "__mj_CreatedAt",
  "__mj_UpdatedAt"
)
VALUES
  (
    '6961d0cb-1ef9-4ef0-bdd6-8f474f9dc646',
    'C1A02E75-4C6E-49B0-96F3-79D1A8E26072',
    4,
    'Medium',
    'Medium',
    'Check',
    NOW(),
    NOW()
  ) ON CONFLICT DO NOTHING;

  END IF;
END $$;
/* SQL text to update ValueListType for entity field ID C1A02E75-4C6E-49B0-96F3-79D1A8E26072 */
UPDATE "__mj"."EntityField" SET "ValueListType" = 'List'
WHERE
  "ID" = 'C1A02E75-4C6E-49B0-96F3-79D1A8E26072';
/* SQL text to sync 4 entity field value row(s) for entity field ID A70FE423-7FCC-4A69-8985-8B97A412DD50 */
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'DA47B784-AFDC-4400-973F-434DA68D68A4';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'B3BFEB4C-BAEC-4D3D-9A02-971B663CE2E4';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '09DB9D33-8C14-4255-BBB8-4344B3124AAB';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'A56F1075-99A2-4641-86CD-0EC01AA5EE73';
/* SQL text to sync 3 entity field value row(s) for entity field ID 39881813-0D5C-4A1E-B555-073757DB66AB */
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'B330AC38-3BD0-4F70-9E1A-F21FEDBEA16C';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '5037DE28-7CB7-4698-9B07-B07438722631';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = 'B2DAAE8C-B1EC-4073-B43D-5D66AF40F517';
/* SQL text to sync 4 entity field value row(s) for entity field ID D0B81AA7-32D5-49D2-B7B4-D67872C48787 */
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '4790060C-7241-4924-9E69-CC87EE626E82';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '0FB82B68-157F-47B6-A74E-AA0A1B3F7448';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '3971BE29-EA3C-4883-9852-4C5335B4A52B';
UPDATE "__mj"."EntityFieldValue" SET "Source" = 'Check'
WHERE
  "ID" = '5BC2E04E-BBF6-4A3E-B5E4-383FBF3637CE';
/* Create Entity Relationship: MJ: Artifacts -> Committees: Artifacts (One To Many via MJArtifactID) */;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityRelationship" WHERE "ID" = '8bf09e5b-55f2-4391-910a-ecb4c65fac72' OR ("EntityID" = 'F48D2341-8667-40BB-BCA8-87D7F80E16CD' AND "RelatedEntityID" = '272BEFB5-727A-4525-B235-775A56B7ACBB' AND "RelatedEntityJoinField" = 'MJArtifactID')) THEN
    INSERT INTO "__mj"."EntityRelationship" ("ID", "EntityID", "RelatedEntityID", "RelatedEntityJoinField", "Type", "BundleInAPI", "DisplayInForm", "Sequence", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('8bf09e5b-55f2-4391-910a-ecb4c65fac72', 'F48D2341-8667-40BB-BCA8-87D7F80E16CD', '272BEFB5-727A-4525-B235-775A56B7ACBB', 'MJArtifactID', 'One To Many', TRUE, TRUE, 8, NOW(), NOW());
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityRelationship" WHERE "ID" = 'f6725681-68da-42f2-a8f9-749b38edcc50' OR ("EntityID" = 'F48D2341-8667-40BB-BCA8-87D7F80E16CD' AND "RelatedEntityID" = '0EC944F9-F908-4662-87B2-E57077A873FF' AND "RelatedEntityJoinField" = 'MJArtifactID')) THEN
    INSERT INTO "__mj"."EntityRelationship" ("ID", "EntityID", "RelatedEntityID", "RelatedEntityJoinField", "Type", "BundleInAPI", "DisplayInForm", "Sequence", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('f6725681-68da-42f2-a8f9-749b38edcc50', 'F48D2341-8667-40BB-BCA8-87D7F80E16CD', '0EC944F9-F908-4662-87B2-E57077A873FF', 'MJArtifactID', 'One To Many', TRUE, TRUE, 9, NOW(), NOW());
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityRelationship" WHERE "ID" = 'a155fac7-4cb9-42df-a377-650cb3b3a339' OR ("EntityID" = 'AEB408D2-162A-49AE-9DC2-DBE9A21A3C01' AND "RelatedEntityID" = '0EC944F9-F908-4662-87B2-E57077A873FF' AND "RelatedEntityJoinField" = 'ApprovedArtifactVersionID')) THEN
    INSERT INTO "__mj"."EntityRelationship" ("ID", "EntityID", "RelatedEntityID", "RelatedEntityJoinField", "Type", "BundleInAPI", "DisplayInForm", "Sequence", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('a155fac7-4cb9-42df-a377-650cb3b3a339', 'AEB408D2-162A-49AE-9DC2-DBE9A21A3C01', '0EC944F9-F908-4662-87B2-E57077A873FF', 'ApprovedArtifactVersionID', 'One To Many', TRUE, TRUE, 9, NOW(), NOW());
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityField" WHERE "ID" = '48200fbe-5515-4eec-994b-aeddfcabfb6a' OR ("EntityID" = 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8' AND "Name" = 'ParentAgendaItemIDDepth')) THEN
    INSERT INTO "__mj"."EntityField" ("ID", "EntityID", "Sequence", "Name", "DisplayName", "Description", "Type", "Length", "Precision", "Scale", "AllowsNull", "DefaultValue", "AutoIncrement", "AllowUpdateAPI", "IsVirtual", "IsComputed", "RelatedEntityID", "RelatedEntityFieldName", "IsNameField", "IncludeInUserSearchAPI", "IncludeRelatedEntityNameFieldInBaseView", "DefaultInView", "IsPrimaryKey", "IsUnique", "RelatedEntityDisplayType", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('48200fbe-5515-4eec-994b-aeddfcabfb6a', 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8' /* Entity: Committees: Agenda Items */, (SELECT COALESCE(MAX("Sequence"), 0) + 1 FROM "__mj"."EntityField" WHERE "EntityID" = 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8'), 'ParentAgendaItemIDDepth', 'Parent Agenda Item ID Depth', NULL, 'int', 4, 10, 0, TRUE, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Search', NOW(), NOW());
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityField" WHERE "ID" = '2cbeae51-280c-47fe-a01a-09cbcd3b22b0' OR ("EntityID" = 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8' AND "Name" = 'ParentAgendaItemIDPath')) THEN
    INSERT INTO "__mj"."EntityField" ("ID", "EntityID", "Sequence", "Name", "DisplayName", "Description", "Type", "Length", "Precision", "Scale", "AllowsNull", "DefaultValue", "AutoIncrement", "AllowUpdateAPI", "IsVirtual", "IsComputed", "RelatedEntityID", "RelatedEntityFieldName", "IsNameField", "IncludeInUserSearchAPI", "IncludeRelatedEntityNameFieldInBaseView", "DefaultInView", "IsPrimaryKey", "IsUnique", "RelatedEntityDisplayType", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('2cbeae51-280c-47fe-a01a-09cbcd3b22b0', 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8' /* Entity: Committees: Agenda Items */, (SELECT COALESCE(MAX("Sequence"), 0) + 1 FROM "__mj"."EntityField" WHERE "EntityID" = 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8'), 'ParentAgendaItemIDPath', 'Parent Agenda Item ID Path', NULL, 'nvarchar', -1, 0, 0, TRUE, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Search', NOW(), NOW());
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityField" WHERE "ID" = '50da97f7-f1af-4dcb-8a13-d59191f87b20' OR ("EntityID" = 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8' AND "Name" = 'ParentAgendaItemIDIsLeaf')) THEN
    INSERT INTO "__mj"."EntityField" ("ID", "EntityID", "Sequence", "Name", "DisplayName", "Description", "Type", "Length", "Precision", "Scale", "AllowsNull", "DefaultValue", "AutoIncrement", "AllowUpdateAPI", "IsVirtual", "IsComputed", "RelatedEntityID", "RelatedEntityFieldName", "IsNameField", "IncludeInUserSearchAPI", "IncludeRelatedEntityNameFieldInBaseView", "DefaultInView", "IsPrimaryKey", "IsUnique", "RelatedEntityDisplayType", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('50da97f7-f1af-4dcb-8a13-d59191f87b20', 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8' /* Entity: Committees: Agenda Items */, (SELECT COALESCE(MAX("Sequence"), 0) + 1 FROM "__mj"."EntityField" WHERE "EntityID" = 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8'), 'ParentAgendaItemIDIsLeaf', 'Parent Agenda Item ID Is Leaf', NULL, 'bit', 1, 1, 0, TRUE, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Search', NOW(), NOW());
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityField" WHERE "ID" = 'bcdff096-2b57-4d29-b4a1-6976cdd49746' OR ("EntityID" = 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8' AND "Name" = 'ParentAgendaItemIDChildCount')) THEN
    INSERT INTO "__mj"."EntityField" ("ID", "EntityID", "Sequence", "Name", "DisplayName", "Description", "Type", "Length", "Precision", "Scale", "AllowsNull", "DefaultValue", "AutoIncrement", "AllowUpdateAPI", "IsVirtual", "IsComputed", "RelatedEntityID", "RelatedEntityFieldName", "IsNameField", "IncludeInUserSearchAPI", "IncludeRelatedEntityNameFieldInBaseView", "DefaultInView", "IsPrimaryKey", "IsUnique", "RelatedEntityDisplayType", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('bcdff096-2b57-4d29-b4a1-6976cdd49746', 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8' /* Entity: Committees: Agenda Items */, (SELECT COALESCE(MAX("Sequence"), 0) + 1 FROM "__mj"."EntityField" WHERE "EntityID" = 'D7F80482-E5EE-4DD9-ABAC-1F357D8A76E8'), 'ParentAgendaItemIDChildCount', 'Parent Agenda Item ID Child Count', NULL, 'int', 4, 10, 0, TRUE, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Search', NOW(), NOW());
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityField" WHERE "ID" = '09f74a61-00c5-4bf4-97c4-c2123053c307' OR ("EntityID" = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF' AND "Name" = 'ParentCommentIDDepth')) THEN
    INSERT INTO "__mj"."EntityField" ("ID", "EntityID", "Sequence", "Name", "DisplayName", "Description", "Type", "Length", "Precision", "Scale", "AllowsNull", "DefaultValue", "AutoIncrement", "AllowUpdateAPI", "IsVirtual", "IsComputed", "RelatedEntityID", "RelatedEntityFieldName", "IsNameField", "IncludeInUserSearchAPI", "IncludeRelatedEntityNameFieldInBaseView", "DefaultInView", "IsPrimaryKey", "IsUnique", "RelatedEntityDisplayType", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('09f74a61-00c5-4bf4-97c4-c2123053c307', 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF' /* Entity: Committees: Comments */, (SELECT COALESCE(MAX("Sequence"), 0) + 1 FROM "__mj"."EntityField" WHERE "EntityID" = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF'), 'ParentCommentIDDepth', 'Parent Comment ID Depth', NULL, 'int', 4, 10, 0, TRUE, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Search', NOW(), NOW());
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityField" WHERE "ID" = '1a0ec43b-87dc-480c-a5a5-d72a94ecddab' OR ("EntityID" = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF' AND "Name" = 'ParentCommentIDPath')) THEN
    INSERT INTO "__mj"."EntityField" ("ID", "EntityID", "Sequence", "Name", "DisplayName", "Description", "Type", "Length", "Precision", "Scale", "AllowsNull", "DefaultValue", "AutoIncrement", "AllowUpdateAPI", "IsVirtual", "IsComputed", "RelatedEntityID", "RelatedEntityFieldName", "IsNameField", "IncludeInUserSearchAPI", "IncludeRelatedEntityNameFieldInBaseView", "DefaultInView", "IsPrimaryKey", "IsUnique", "RelatedEntityDisplayType", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('1a0ec43b-87dc-480c-a5a5-d72a94ecddab', 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF' /* Entity: Committees: Comments */, (SELECT COALESCE(MAX("Sequence"), 0) + 1 FROM "__mj"."EntityField" WHERE "EntityID" = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF'), 'ParentCommentIDPath', 'Parent Comment ID Path', NULL, 'nvarchar', -1, 0, 0, TRUE, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Search', NOW(), NOW());
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityField" WHERE "ID" = '61fe1b2c-426d-4c90-b9e5-180503c1cb87' OR ("EntityID" = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF' AND "Name" = 'ParentCommentIDIsLeaf')) THEN
    INSERT INTO "__mj"."EntityField" ("ID", "EntityID", "Sequence", "Name", "DisplayName", "Description", "Type", "Length", "Precision", "Scale", "AllowsNull", "DefaultValue", "AutoIncrement", "AllowUpdateAPI", "IsVirtual", "IsComputed", "RelatedEntityID", "RelatedEntityFieldName", "IsNameField", "IncludeInUserSearchAPI", "IncludeRelatedEntityNameFieldInBaseView", "DefaultInView", "IsPrimaryKey", "IsUnique", "RelatedEntityDisplayType", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('61fe1b2c-426d-4c90-b9e5-180503c1cb87', 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF' /* Entity: Committees: Comments */, (SELECT COALESCE(MAX("Sequence"), 0) + 1 FROM "__mj"."EntityField" WHERE "EntityID" = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF'), 'ParentCommentIDIsLeaf', 'Parent Comment ID Is Leaf', NULL, 'bit', 1, 1, 0, TRUE, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Search', NOW(), NOW());
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityField" WHERE "ID" = '682fe1af-f9d0-4b29-87f5-deeaf5e19a61' OR ("EntityID" = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF' AND "Name" = 'ParentCommentIDChildCount')) THEN
    INSERT INTO "__mj"."EntityField" ("ID", "EntityID", "Sequence", "Name", "DisplayName", "Description", "Type", "Length", "Precision", "Scale", "AllowsNull", "DefaultValue", "AutoIncrement", "AllowUpdateAPI", "IsVirtual", "IsComputed", "RelatedEntityID", "RelatedEntityFieldName", "IsNameField", "IncludeInUserSearchAPI", "IncludeRelatedEntityNameFieldInBaseView", "DefaultInView", "IsPrimaryKey", "IsUnique", "RelatedEntityDisplayType", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('682fe1af-f9d0-4b29-87f5-deeaf5e19a61', 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF' /* Entity: Committees: Comments */, (SELECT COALESCE(MAX("Sequence"), 0) + 1 FROM "__mj"."EntityField" WHERE "EntityID" = 'C1CEF804-AA80-47A0-9750-2A4C5227B6DF'), 'ParentCommentIDChildCount', 'Parent Comment ID Child Count', NULL, 'int', 4, 10, 0, TRUE, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Search', NOW(), NOW());
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityField" WHERE "ID" = '60f4e307-42e7-4dc4-bb7e-9b09b07056bd' OR ("EntityID" = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND "Name" = 'ParentCommitteeIDDepth')) THEN
    INSERT INTO "__mj"."EntityField" ("ID", "EntityID", "Sequence", "Name", "DisplayName", "Description", "Type", "Length", "Precision", "Scale", "AllowsNull", "DefaultValue", "AutoIncrement", "AllowUpdateAPI", "IsVirtual", "IsComputed", "RelatedEntityID", "RelatedEntityFieldName", "IsNameField", "IncludeInUserSearchAPI", "IncludeRelatedEntityNameFieldInBaseView", "DefaultInView", "IsPrimaryKey", "IsUnique", "RelatedEntityDisplayType", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('60f4e307-42e7-4dc4-bb7e-9b09b07056bd', 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' /* Entity: Committees: Committees */, (SELECT COALESCE(MAX("Sequence"), 0) + 1 FROM "__mj"."EntityField" WHERE "EntityID" = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'), 'ParentCommitteeIDDepth', 'Parent Committee ID Depth', NULL, 'int', 4, 10, 0, TRUE, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Search', NOW(), NOW());
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityField" WHERE "ID" = 'eb6e2a40-162b-4860-b0b6-ab7e2173564a' OR ("EntityID" = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND "Name" = 'ParentCommitteeIDPath')) THEN
    INSERT INTO "__mj"."EntityField" ("ID", "EntityID", "Sequence", "Name", "DisplayName", "Description", "Type", "Length", "Precision", "Scale", "AllowsNull", "DefaultValue", "AutoIncrement", "AllowUpdateAPI", "IsVirtual", "IsComputed", "RelatedEntityID", "RelatedEntityFieldName", "IsNameField", "IncludeInUserSearchAPI", "IncludeRelatedEntityNameFieldInBaseView", "DefaultInView", "IsPrimaryKey", "IsUnique", "RelatedEntityDisplayType", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('eb6e2a40-162b-4860-b0b6-ab7e2173564a', 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' /* Entity: Committees: Committees */, (SELECT COALESCE(MAX("Sequence"), 0) + 1 FROM "__mj"."EntityField" WHERE "EntityID" = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'), 'ParentCommitteeIDPath', 'Parent Committee ID Path', NULL, 'nvarchar', -1, 0, 0, TRUE, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Search', NOW(), NOW());
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityField" WHERE "ID" = 'e639ab26-3a8a-4cfa-9256-a00d27080bd8' OR ("EntityID" = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND "Name" = 'ParentCommitteeIDIsLeaf')) THEN
    INSERT INTO "__mj"."EntityField" ("ID", "EntityID", "Sequence", "Name", "DisplayName", "Description", "Type", "Length", "Precision", "Scale", "AllowsNull", "DefaultValue", "AutoIncrement", "AllowUpdateAPI", "IsVirtual", "IsComputed", "RelatedEntityID", "RelatedEntityFieldName", "IsNameField", "IncludeInUserSearchAPI", "IncludeRelatedEntityNameFieldInBaseView", "DefaultInView", "IsPrimaryKey", "IsUnique", "RelatedEntityDisplayType", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('e639ab26-3a8a-4cfa-9256-a00d27080bd8', 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' /* Entity: Committees: Committees */, (SELECT COALESCE(MAX("Sequence"), 0) + 1 FROM "__mj"."EntityField" WHERE "EntityID" = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'), 'ParentCommitteeIDIsLeaf', 'Parent Committee ID Is Leaf', NULL, 'bit', 1, 1, 0, TRUE, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Search', NOW(), NOW());
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityField" WHERE "ID" = '1af53eed-dc1d-4b08-ab26-d581fda01d53' OR ("EntityID" = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' AND "Name" = 'ParentCommitteeIDChildCount')) THEN
    INSERT INTO "__mj"."EntityField" ("ID", "EntityID", "Sequence", "Name", "DisplayName", "Description", "Type", "Length", "Precision", "Scale", "AllowsNull", "DefaultValue", "AutoIncrement", "AllowUpdateAPI", "IsVirtual", "IsComputed", "RelatedEntityID", "RelatedEntityFieldName", "IsNameField", "IncludeInUserSearchAPI", "IncludeRelatedEntityNameFieldInBaseView", "DefaultInView", "IsPrimaryKey", "IsUnique", "RelatedEntityDisplayType", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('1af53eed-dc1d-4b08-ab26-d581fda01d53', 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE' /* Entity: Committees: Committees */, (SELECT COALESCE(MAX("Sequence"), 0) + 1 FROM "__mj"."EntityField" WHERE "EntityID" = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'), 'ParentCommitteeIDChildCount', 'Parent Committee ID Child Count', NULL, 'int', 4, 10, 0, TRUE, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Search', NOW(), NOW());
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityField" WHERE "ID" = '48f5be45-0f98-4ef6-a01d-f78966596c42' OR ("EntityID" = '272BEFB5-727A-4525-B235-775A56B7ACBB' AND "Name" = 'MJArtifact')) THEN
    INSERT INTO "__mj"."EntityField" ("ID", "EntityID", "Sequence", "Name", "DisplayName", "Description", "Type", "Length", "Precision", "Scale", "AllowsNull", "DefaultValue", "AutoIncrement", "AllowUpdateAPI", "IsVirtual", "IsComputed", "RelatedEntityID", "RelatedEntityFieldName", "IsNameField", "IncludeInUserSearchAPI", "IncludeRelatedEntityNameFieldInBaseView", "DefaultInView", "IsPrimaryKey", "IsUnique", "RelatedEntityDisplayType", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('48f5be45-0f98-4ef6-a01d-f78966596c42', '272BEFB5-727A-4525-B235-775A56B7ACBB' /* Entity: Committees: Artifacts */, (SELECT COALESCE(MAX("Sequence"), 0) + 1 FROM "__mj"."EntityField" WHERE "EntityID" = '272BEFB5-727A-4525-B235-775A56B7ACBB'), 'MJArtifact', 'MJ Artifact', NULL, 'nvarchar', 510, 0, 0, TRUE, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Search', NOW(), NOW());
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityField" WHERE "ID" = 'db5068f4-b2e4-4472-a778-674ba2760327' OR ("EntityID" = '0EC944F9-F908-4662-87B2-E57077A873FF' AND "Name" = 'MJArtifact')) THEN
    INSERT INTO "__mj"."EntityField" ("ID", "EntityID", "Sequence", "Name", "DisplayName", "Description", "Type", "Length", "Precision", "Scale", "AllowsNull", "DefaultValue", "AutoIncrement", "AllowUpdateAPI", "IsVirtual", "IsComputed", "RelatedEntityID", "RelatedEntityFieldName", "IsNameField", "IncludeInUserSearchAPI", "IncludeRelatedEntityNameFieldInBaseView", "DefaultInView", "IsPrimaryKey", "IsUnique", "RelatedEntityDisplayType", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('db5068f4-b2e4-4472-a778-674ba2760327', '0EC944F9-F908-4662-87B2-E57077A873FF' /* Entity: Committees: Minutes */, (SELECT COALESCE(MAX("Sequence"), 0) + 1 FROM "__mj"."EntityField" WHERE "EntityID" = '0EC944F9-F908-4662-87B2-E57077A873FF'), 'MJArtifact', 'MJ Artifact', NULL, 'nvarchar', 510, 0, 0, TRUE, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Search', NOW(), NOW());
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM "__mj"."EntityField" WHERE "ID" = 'f0d99a30-e913-424f-b3e5-217018e73b98' OR ("EntityID" = '0EC944F9-F908-4662-87B2-E57077A873FF' AND "Name" = 'ApprovedArtifactVersion')) THEN
    INSERT INTO "__mj"."EntityField" ("ID", "EntityID", "Sequence", "Name", "DisplayName", "Description", "Type", "Length", "Precision", "Scale", "AllowsNull", "DefaultValue", "AutoIncrement", "AllowUpdateAPI", "IsVirtual", "IsComputed", "RelatedEntityID", "RelatedEntityFieldName", "IsNameField", "IncludeInUserSearchAPI", "IncludeRelatedEntityNameFieldInBaseView", "DefaultInView", "IsPrimaryKey", "IsUnique", "RelatedEntityDisplayType", "__mj_CreatedAt", "__mj_UpdatedAt") VALUES ('f0d99a30-e913-424f-b3e5-217018e73b98', '0EC944F9-F908-4662-87B2-E57077A873FF' /* Entity: Committees: Minutes */, (SELECT COALESCE(MAX("Sequence"), 0) + 1 FROM "__mj"."EntityField" WHERE "EntityID" = '0EC944F9-F908-4662-87B2-E57077A873FF'), 'ApprovedArtifactVersion', 'Approved Artifact Version', NULL, 'nvarchar', 510, 0, 0, TRUE, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Search', NOW(), NOW());
  END IF;
END $$;

UPDATE "__mj"."EntityField" SET "RelatedEntityNameFieldMap" = 'MJArtifact' WHERE "ID" = '85f11ba1-7826-422a-b8cb-a69b74192f25';

-- ===================== CodeGen (native PG, baked) =====================

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Agenda Items
-- Item: Index for Foreign Keys
-- ============================================================
-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'AgendaItem'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'MeetingID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_agenda_item_meeting_id"
            ON "__mj_bizappscommittees"."AgendaItem" ("MeetingID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'AgendaItem'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'ParentAgendaItemID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_agenda_item_parent_agenda_item_id"
            ON "__mj_bizappscommittees"."AgendaItem" ("ParentAgendaItemID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'AgendaItem'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'PresenterPersonID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_agenda_item_presenter_person_id"
            ON "__mj_bizappscommittees"."AgendaItem" ("PresenterPersonID");
    END IF;
END
$$;

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Agenda Items
-- Item: fn_agenda_item_parent_agenda_item_id_get_hierarchy_meta
-- ============================================================

------------------------------------------------------------
----- HIERARCHY METADATA FUNCTION FOR: AgendaItem.ParentAgendaItemID
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_agenda_item_parent_agenda_item_id_get_hierarchy_meta"(
    p_record_id UUID,
    p_parent_id UUID
) RETURNS TABLE (
    "RootID" UUID,
    "Depth" INTEGER,
    "Path" TEXT,
    "IsLeaf" BOOLEAN,
    "ChildCount" INTEGER
) AS $$
    WITH RECURSIVE cte_ancestors AS (
        SELECT
            "ID",
            "ParentAgendaItemID",
            0 AS depth,
            '/' || "ID"::TEXT || '/' AS path
        FROM
            "__mj_bizappscommittees"."AgendaItem"
        WHERE
            "ID" = p_record_id

        UNION ALL

        SELECT
            p."ID",
            p."ParentAgendaItemID",
            c.depth + 1 AS depth,
            '/' || p."ID"::TEXT || c.path AS path
        FROM
            "__mj_bizappscommittees"."AgendaItem" p
        INNER JOIN
            cte_ancestors c ON p."ID" = c."ParentAgendaItemID"
        WHERE
            c.depth < 100
    )
    SELECT
        a."ID" AS "RootID",
        a.depth::INTEGER AS "Depth",
        a.path::TEXT AS "Path",
        (ch.child_count = 0)::BOOLEAN AS "IsLeaf",
        ch.child_count AS "ChildCount"
    FROM
        cte_ancestors a
    CROSS JOIN LATERAL (
        SELECT COUNT(1)::INTEGER AS child_count
        FROM "__mj_bizappscommittees"."AgendaItem"
        WHERE "ParentAgendaItemID" = p_record_id
    ) ch
    WHERE
        a."ParentAgendaItemID" IS NULL OR p_parent_id IS NULL
    ORDER BY
        a.depth DESC
    LIMIT 1;
$$ LANGUAGE sql STABLE;


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Agenda Items
-- Item: fn_agenda_item_parent_agenda_item_id_get_descendants
-- ============================================================

------------------------------------------------------------
----- DESCENDANTS FUNCTION FOR: AgendaItem.ParentAgendaItemID
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_agenda_item_parent_agenda_item_id_get_descendants"(
    p_root_id UUID,
    p_max_depth INTEGER DEFAULT NULL
) RETURNS TABLE (
    "ID" UUID,
    "Depth" INTEGER,
    "Path" TEXT,
    "IsLeaf" BOOLEAN,
    "ChildCount" INTEGER
) AS $$
    WITH RECURSIVE cte_descendants AS (
        SELECT
            "ID",
            "ParentAgendaItemID",
            0 AS relative_depth,
            '/' || "ID"::TEXT || '/' AS path
        FROM
            "__mj_bizappscommittees"."AgendaItem"
        WHERE
            "ID" = p_root_id

        UNION ALL

        SELECT
            c."ID",
            c."ParentAgendaItemID",
            p.relative_depth + 1 AS relative_depth,
            p.path || c."ID"::TEXT || '/' AS path
        FROM
            "__mj_bizappscommittees"."AgendaItem" c
        INNER JOIN
            cte_descendants p ON c."ParentAgendaItemID" = p."ID"
        WHERE
            (p_max_depth IS NULL OR p.relative_depth < p_max_depth)
            AND p.relative_depth < 100
    )
    SELECT
        d."ID" AS "ID",
        d.relative_depth AS "Depth",
        d.path AS "Path",
        (NOT EXISTS (SELECT 1 FROM "__mj_bizappscommittees"."AgendaItem" WHERE "ParentAgendaItemID" = d."ID"))::BOOLEAN AS "IsLeaf",
        (SELECT COUNT(1)::INTEGER FROM "__mj_bizappscommittees"."AgendaItem" WHERE "ParentAgendaItemID" = d."ID") AS "ChildCount"
    FROM
        cte_descendants d;
$$ LANGUAGE sql STABLE;


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Agenda Items
-- Item: fn_agenda_item_parent_agenda_item_id_get_ancestors
-- ============================================================

------------------------------------------------------------
----- ANCESTORS FUNCTION FOR: AgendaItem.ParentAgendaItemID
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_agenda_item_parent_agenda_item_id_get_ancestors"(
    p_record_id UUID
) RETURNS TABLE (
    "ID" UUID,
    "LevelUp" INTEGER,
    "Path" TEXT
) AS $$
    WITH RECURSIVE cte_ancestors AS (
        SELECT
            "ID",
            "ParentAgendaItemID",
            0 AS level_up,
            '/' || "ID"::TEXT || '/' AS path
        FROM
            "__mj_bizappscommittees"."AgendaItem"
        WHERE
            "ID" = p_record_id

        UNION ALL

        SELECT
            p."ID",
            p."ParentAgendaItemID",
            c.level_up + 1 AS level_up,
            '/' || p."ID"::TEXT || c.path AS path
        FROM
            "__mj_bizappscommittees"."AgendaItem" p
        INNER JOIN
            cte_ancestors c ON p."ID" = c."ParentAgendaItemID"
        WHERE
            c.level_up < 100
    )
    SELECT
        a."ID" AS "ID",
        a.level_up AS "LevelUp",
        a.path AS "Path"
    FROM
        cte_ancestors a;
$$ LANGUAGE sql STABLE;


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Agenda Items
-- Item: fn_agenda_item_parent_agenda_item_id_get_root_id
-- ============================================================

------------------------------------------------------------
----- ROOT ID FUNCTION FOR: AgendaItem.ParentAgendaItemID
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_agenda_item_parent_agenda_item_id_get_root_id"(
    p_record_id UUID,
    p_parent_id UUID
) RETURNS UUID AS $$
    WITH RECURSIVE cte_root_parent AS (
        -- Anchor: Start from p_parent_id if not null, otherwise start from p_record_id
        SELECT
            "ID",
            "ParentAgendaItemID",
            "ID" AS root_parent_id,
            0 AS depth
        FROM
            "__mj_bizappscommittees"."AgendaItem"
        WHERE
            "ID" = COALESCE(p_parent_id, p_record_id)

        UNION ALL

        -- Recursive: Keep going up the hierarchy
        SELECT
            c."ID",
            c."ParentAgendaItemID",
            c."ID" AS root_parent_id,
            p.depth + 1 AS depth
        FROM
            "__mj_bizappscommittees"."AgendaItem" c
        INNER JOIN
            cte_root_parent p ON c."ID" = p."ParentAgendaItemID"
        WHERE
            p.depth < 100  -- Prevent infinite loops
    )
    SELECT root_parent_id
    FROM cte_root_parent
    WHERE "ParentAgendaItemID" IS NULL
    ORDER BY root_parent_id
    LIMIT 1;
$$ LANGUAGE sql STABLE;


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Agenda Items
-- Item: vwAgendaItems
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Agenda Items
-----               SCHEMA:      __mj_bizappscommittees
-----               BASE TABLE:  AgendaItem
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW "__mj_bizappscommittees"."vwAgendaItems"
AS
SELECT
    a.*,
    mjBizAppsCommitteesMeeting_MeetingID."Name" AS "Meeting",
    mjBizAppsCommitteesAgendaItem_ParentAgendaItemID."Name" AS "ParentAgendaItem",
    mjBizAppsCommonPerson_PresenterPersonID."DisplayName" AS "PresenterPerson",
    hier_ParentAgendaItemID."RootID" AS "RootParentAgendaItemID",
    hier_ParentAgendaItemID."Depth" AS "ParentAgendaItemIDDepth",
    hier_ParentAgendaItemID."Path" AS "ParentAgendaItemIDPath",
    hier_ParentAgendaItemID."IsLeaf" AS "ParentAgendaItemIDIsLeaf",
    hier_ParentAgendaItemID."ChildCount" AS "ParentAgendaItemIDChildCount"
FROM
    "__mj_bizappscommittees"."AgendaItem" AS a
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Meeting" AS mjBizAppsCommitteesMeeting_MeetingID
  ON
    "a"."MeetingID" = mjBizAppsCommitteesMeeting_MeetingID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommittees"."AgendaItem" AS mjBizAppsCommitteesAgendaItem_ParentAgendaItemID
  ON
    "a"."ParentAgendaItemID" = mjBizAppsCommitteesAgendaItem_ParentAgendaItemID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommon"."Person" AS mjBizAppsCommonPerson_PresenterPersonID
  ON
    "a"."PresenterPersonID" = mjBizAppsCommonPerson_PresenterPersonID."ID"

LEFT JOIN LATERAL "__mj_bizappscommittees"."fn_agenda_item_parent_agenda_item_id_get_hierarchy_meta"(a."ID", a."ParentAgendaItemID") AS hier_ParentAgendaItemID ON true
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT,
    depth       INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Every view that DROP ... CASCADE removes: direct dependents AND theirs, transitively.
  -- Capturing only direct dependents restored vwTestRuns after a vwTestSuiteRuns regen but
  -- not vwConversations / vwConversationDetails, which select from vwTestRuns — they and their
  -- CRUD functions stayed permanently missing. depth is the LONGEST path from the target, so
  -- replaying in depth order always recreates a view after every view it reads.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_dep_oids (
    view_oid OID,
    depth    INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_dep_oids;
  INSERT INTO _vw_regen_dep_oids (view_oid, depth)
  WITH RECURSIVE deps(view_oid, depth) AS (
      SELECT DISTINCT dc.oid, 1
      FROM pg_depend d
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      JOIN pg_class tc ON tc.oid = d.refobjid
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tn.nspname = '__mj_bizappscommittees'
        AND tc.relname = 'vwAgendaItems'
        AND tc.relkind IN ('v', 'm')
        AND dc.oid <> tc.oid
    UNION
      SELECT dc.oid, deps.depth + 1
      FROM deps
      JOIN pg_depend d ON d.refobjid = deps.view_oid
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      WHERE dc.oid <> deps.view_oid
        AND deps.depth < 50
  )
  SELECT view_oid, MAX(depth) FROM deps GROUP BY view_oid;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql, depth)
  SELECT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER')),
      o.depth
  FROM _vw_regen_dep_oids o
  JOIN pg_class dc ON dc.oid = o.view_oid
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  -- The set is the target view plus every view captured above, because CASCADE drops the
  -- functions of each of them, not only the target's.
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_proc pp
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE pp.prokind IN ('f', 'p')
    AND EXISTS (
      SELECT 1
      FROM pg_class c
      WHERE (c.oid IN (SELECT view_oid FROM _vw_regen_dep_oids)
             OR c.oid = (SELECT tc.oid FROM pg_class tc
                         JOIN pg_namespace tn ON tn.oid = tc.relnamespace
                         WHERE tn.nspname = '__mj_bizappscommittees'
                           AND tc.relname = 'vwAgendaItems'
                           AND tc.relkind IN ('v', 'm')))
        AND (pp.prorettype = c.reltype
             OR EXISTS (SELECT 1 FROM pg_depend d
                        WHERE d.classid = 'pg_proc'::regclass
                          AND d.objid = pp.oid
                          AND d.refobjid = c.oid))
  );

  DROP VIEW IF EXISTS "__mj_bizappscommittees"."vwAgendaItems" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps ORDER BY depth, view_name LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_dep_oids;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON "__mj_bizappscommittees"."vwAgendaItems" TO "cdp_UI";
GRANT SELECT ON "__mj_bizappscommittees"."vwAgendaItems" TO "cdp_Developer";
GRANT SELECT ON "__mj_bizappscommittees"."vwAgendaItems" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Agenda Items
-- Item: spCreateAgendaItem
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR AgendaItem
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateAgendaItem'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spCreateAgendaItem"(
    p_id UUID DEFAULT NULL,
    p_meetingid UUID DEFAULT NULL,
    p_parentagendaitemid_clear boolean DEFAULT false,
    p_parentagendaitemid UUID DEFAULT NULL,
    p_sequence int DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_presenterpersonid_clear boolean DEFAULT false,
    p_presenterpersonid UUID DEFAULT NULL,
    p_durationminutes_clear boolean DEFAULT false,
    p_durationminutes int DEFAULT NULL,
    p_itemtype varchar(50) DEFAULT NULL,
    p_relateddocumenturl_clear boolean DEFAULT false,
    p_relateddocumenturl varchar(1000) DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes TEXT DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwAgendaItems" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO "__mj_bizappscommittees"."AgendaItem"
        (
            "ID",
            "MeetingID",
                "ParentAgendaItemID",
                "Sequence",
                "Name",
                "Description",
                "PresenterPersonID",
                "DurationMinutes",
                "ItemType",
                "RelatedDocumentURL",
                "Status",
                "Notes"
        )
    VALUES
        (
            v_new_id,
            p_meetingid,
                CASE WHEN p_parentagendaitemid_clear = true THEN NULL ELSE COALESCE(p_parentagendaitemid, NULL) END,
                p_sequence,
                p_name,
                CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, NULL) END,
                CASE WHEN p_presenterpersonid_clear = true THEN NULL ELSE COALESCE(p_presenterpersonid, NULL) END,
                CASE WHEN p_durationminutes_clear = true THEN NULL ELSE COALESCE(p_durationminutes, NULL) END,
                COALESCE(p_itemtype, 'Discussion'),
                CASE WHEN p_relateddocumenturl_clear = true THEN NULL ELSE COALESCE(p_relateddocumenturl, NULL) END,
                COALESCE(p_status, 'Pending'),
                CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwAgendaItems"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateAgendaItem" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateAgendaItem" TO "cdp_Integration";


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Agenda Items
-- Item: spUpdateAgendaItem
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR AgendaItem
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateAgendaItem'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spUpdateAgendaItem"(
    p_id UUID,
    p_meetingid UUID DEFAULT NULL,
    p_parentagendaitemid_clear boolean DEFAULT false,
    p_parentagendaitemid UUID DEFAULT NULL,
    p_sequence int DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_presenterpersonid_clear boolean DEFAULT false,
    p_presenterpersonid UUID DEFAULT NULL,
    p_durationminutes_clear boolean DEFAULT false,
    p_durationminutes int DEFAULT NULL,
    p_itemtype varchar(50) DEFAULT NULL,
    p_relateddocumenturl_clear boolean DEFAULT false,
    p_relateddocumenturl varchar(1000) DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes TEXT DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwAgendaItems" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE "__mj_bizappscommittees"."AgendaItem"
    SET
        "MeetingID" = COALESCE(p_meetingid, "MeetingID"),
        "ParentAgendaItemID" = CASE WHEN p_parentagendaitemid_clear = true THEN NULL ELSE COALESCE(p_parentagendaitemid, "ParentAgendaItemID") END,
        "Sequence" = COALESCE(p_sequence, "Sequence"),
        "Name" = COALESCE(p_name, "Name"),
        "Description" = CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, "Description") END,
        "PresenterPersonID" = CASE WHEN p_presenterpersonid_clear = true THEN NULL ELSE COALESCE(p_presenterpersonid, "PresenterPersonID") END,
        "DurationMinutes" = CASE WHEN p_durationminutes_clear = true THEN NULL ELSE COALESCE(p_durationminutes, "DurationMinutes") END,
        "ItemType" = COALESCE(p_itemtype, "ItemType"),
        "RelatedDocumentURL" = CASE WHEN p_relateddocumenturl_clear = true THEN NULL ELSE COALESCE(p_relateddocumenturl, "RelatedDocumentURL") END,
        "Status" = COALESCE(p_status, "Status"),
        "Notes" = CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, "Notes") END,
        "__mj_UpdatedAt" = (NOW() AT TIME ZONE 'UTC')
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwAgendaItems"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateAgendaItem" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateAgendaItem" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the AgendaItem table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_trg_update_agenda_item"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_agenda_item" ON "__mj_bizappscommittees"."AgendaItem";

CREATE TRIGGER "trg_update_agenda_item"
BEFORE UPDATE ON "__mj_bizappscommittees"."AgendaItem"
FOR EACH ROW
EXECUTE FUNCTION "__mj_bizappscommittees"."fn_trg_update_agenda_item"();



-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Agenda Items
-- Item: spDeleteAgendaItem
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR AgendaItem
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteAgendaItem'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spDeleteAgendaItem"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM "__mj_bizappscommittees"."AgendaItem"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteAgendaItem" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteAgendaItem" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifact Types
-- Item: Index for Foreign Keys
-- ============================================================
-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'ArtifactType'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'ExtendedEntityID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_artifact_type_extended_entity_id"
            ON "__mj_bizappscommittees"."ArtifactType" ("ExtendedEntityID");
    END IF;
END
$$;

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifact Types
-- Item: vwArtifactTypes
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Artifact Types
-----               SCHEMA:      __mj_bizappscommittees
-----               BASE TABLE:  ArtifactType
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW "__mj_bizappscommittees"."vwArtifactTypes"
AS
SELECT
    a.*,
    MJEntity_ExtendedEntityID."Name" AS "ExtendedEntity"
FROM
    "__mj_bizappscommittees"."ArtifactType" AS a
LEFT OUTER JOIN
    "__mj"."Entity" AS MJEntity_ExtendedEntityID
  ON
    "a"."ExtendedEntityID" = MJEntity_ExtendedEntityID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT,
    depth       INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Every view that DROP ... CASCADE removes: direct dependents AND theirs, transitively.
  -- Capturing only direct dependents restored vwTestRuns after a vwTestSuiteRuns regen but
  -- not vwConversations / vwConversationDetails, which select from vwTestRuns — they and their
  -- CRUD functions stayed permanently missing. depth is the LONGEST path from the target, so
  -- replaying in depth order always recreates a view after every view it reads.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_dep_oids (
    view_oid OID,
    depth    INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_dep_oids;
  INSERT INTO _vw_regen_dep_oids (view_oid, depth)
  WITH RECURSIVE deps(view_oid, depth) AS (
      SELECT DISTINCT dc.oid, 1
      FROM pg_depend d
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      JOIN pg_class tc ON tc.oid = d.refobjid
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tn.nspname = '__mj_bizappscommittees'
        AND tc.relname = 'vwArtifactTypes'
        AND tc.relkind IN ('v', 'm')
        AND dc.oid <> tc.oid
    UNION
      SELECT dc.oid, deps.depth + 1
      FROM deps
      JOIN pg_depend d ON d.refobjid = deps.view_oid
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      WHERE dc.oid <> deps.view_oid
        AND deps.depth < 50
  )
  SELECT view_oid, MAX(depth) FROM deps GROUP BY view_oid;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql, depth)
  SELECT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER')),
      o.depth
  FROM _vw_regen_dep_oids o
  JOIN pg_class dc ON dc.oid = o.view_oid
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  -- The set is the target view plus every view captured above, because CASCADE drops the
  -- functions of each of them, not only the target's.
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_proc pp
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE pp.prokind IN ('f', 'p')
    AND EXISTS (
      SELECT 1
      FROM pg_class c
      WHERE (c.oid IN (SELECT view_oid FROM _vw_regen_dep_oids)
             OR c.oid = (SELECT tc.oid FROM pg_class tc
                         JOIN pg_namespace tn ON tn.oid = tc.relnamespace
                         WHERE tn.nspname = '__mj_bizappscommittees'
                           AND tc.relname = 'vwArtifactTypes'
                           AND tc.relkind IN ('v', 'm')))
        AND (pp.prorettype = c.reltype
             OR EXISTS (SELECT 1 FROM pg_depend d
                        WHERE d.classid = 'pg_proc'::regclass
                          AND d.objid = pp.oid
                          AND d.refobjid = c.oid))
  );

  DROP VIEW IF EXISTS "__mj_bizappscommittees"."vwArtifactTypes" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps ORDER BY depth, view_name LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_dep_oids;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON "__mj_bizappscommittees"."vwArtifactTypes" TO "cdp_UI";
GRANT SELECT ON "__mj_bizappscommittees"."vwArtifactTypes" TO "cdp_Developer";
GRANT SELECT ON "__mj_bizappscommittees"."vwArtifactTypes" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifact Types
-- Item: spCreateArtifactType
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR ArtifactType
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateArtifactType'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spCreateArtifactType"(
    p_id UUID DEFAULT NULL,
    p_name varchar(100) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_extendedentityid_clear boolean DEFAULT false,
    p_extendedentityid UUID DEFAULT NULL,
    p_iconclass_clear boolean DEFAULT false,
    p_iconclass varchar(100) DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwArtifactTypes" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO "__mj_bizappscommittees"."ArtifactType"
        (
            "ID",
            "Name",
                "Description",
                "ExtendedEntityID",
                "IconClass"
        )
    VALUES
        (
            v_new_id,
            p_name,
                CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, NULL) END,
                CASE WHEN p_extendedentityid_clear = true THEN NULL ELSE COALESCE(p_extendedentityid, NULL) END,
                CASE WHEN p_iconclass_clear = true THEN NULL ELSE COALESCE(p_iconclass, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwArtifactTypes"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateArtifactType" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateArtifactType" TO "cdp_Integration";


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifact Types
-- Item: spUpdateArtifactType
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR ArtifactType
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateArtifactType'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spUpdateArtifactType"(
    p_id UUID,
    p_name varchar(100) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_extendedentityid_clear boolean DEFAULT false,
    p_extendedentityid UUID DEFAULT NULL,
    p_iconclass_clear boolean DEFAULT false,
    p_iconclass varchar(100) DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwArtifactTypes" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE "__mj_bizappscommittees"."ArtifactType"
    SET
        "Name" = COALESCE(p_name, "Name"),
        "Description" = CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, "Description") END,
        "ExtendedEntityID" = CASE WHEN p_extendedentityid_clear = true THEN NULL ELSE COALESCE(p_extendedentityid, "ExtendedEntityID") END,
        "IconClass" = CASE WHEN p_iconclass_clear = true THEN NULL ELSE COALESCE(p_iconclass, "IconClass") END,
        "__mj_UpdatedAt" = (NOW() AT TIME ZONE 'UTC')
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwArtifactTypes"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateArtifactType" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateArtifactType" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the ArtifactType table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_trg_update_artifact_type"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_artifact_type" ON "__mj_bizappscommittees"."ArtifactType";

CREATE TRIGGER "trg_update_artifact_type"
BEFORE UPDATE ON "__mj_bizappscommittees"."ArtifactType"
FOR EACH ROW
EXECUTE FUNCTION "__mj_bizappscommittees"."fn_trg_update_artifact_type"();



-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifact Types
-- Item: spDeleteArtifactType
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR ArtifactType
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteArtifactType'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spDeleteArtifactType"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM "__mj_bizappscommittees"."ArtifactType"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteArtifactType" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteArtifactType" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifacts
-- Item: Index for Foreign Keys
-- ============================================================
-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Artifact'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'CommitteeID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_artifact_committee_id"
            ON "__mj_bizappscommittees"."Artifact" ("CommitteeID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Artifact'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'MeetingID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_artifact_meeting_id"
            ON "__mj_bizappscommittees"."Artifact" ("MeetingID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Artifact'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'AgendaItemID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_artifact_agenda_item_id"
            ON "__mj_bizappscommittees"."Artifact" ("AgendaItemID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Artifact'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'TaskID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_artifact_task_id"
            ON "__mj_bizappscommittees"."Artifact" ("TaskID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Artifact'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'ArtifactTypeID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_artifact_artifact_type_id"
            ON "__mj_bizappscommittees"."Artifact" ("ArtifactTypeID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Artifact'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'UploadedByPersonID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_artifact_uploaded_by_person_id"
            ON "__mj_bizappscommittees"."Artifact" ("UploadedByPersonID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Artifact'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'MJArtifactID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_artifact_mj_artifact_id"
            ON "__mj_bizappscommittees"."Artifact" ("MJArtifactID");
    END IF;
END
$$;

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifacts
-- Item: vwArtifacts
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Artifacts
-----               SCHEMA:      __mj_bizappscommittees
-----               BASE TABLE:  Artifact
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW "__mj_bizappscommittees"."vwArtifacts"
AS
SELECT
    a.*,
    mjBizAppsCommitteesCommittee_CommitteeID."Name" AS "Committee",
    mjBizAppsCommitteesMeeting_MeetingID."Name" AS "Meeting",
    mjBizAppsCommitteesAgendaItem_AgendaItemID."Name" AS "AgendaItem",
    mjBizAppsTasksTask_TaskID."Name" AS "Task",
    mjBizAppsCommitteesArtifactType_ArtifactTypeID."Name" AS "ArtifactType",
    mjBizAppsCommonPerson_UploadedByPersonID."DisplayName" AS "UploadedByPerson",
    MJArtifact_MJArtifactID."Name" AS "MJArtifact"
FROM
    "__mj_bizappscommittees"."Artifact" AS a
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Committee" AS mjBizAppsCommitteesCommittee_CommitteeID
  ON
    "a"."CommitteeID" = mjBizAppsCommitteesCommittee_CommitteeID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Meeting" AS mjBizAppsCommitteesMeeting_MeetingID
  ON
    "a"."MeetingID" = mjBizAppsCommitteesMeeting_MeetingID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommittees"."AgendaItem" AS mjBizAppsCommitteesAgendaItem_AgendaItemID
  ON
    "a"."AgendaItemID" = mjBizAppsCommitteesAgendaItem_AgendaItemID."ID"
LEFT OUTER JOIN
    "__mj_bizappstasks"."Task" AS mjBizAppsTasksTask_TaskID
  ON
    "a"."TaskID" = mjBizAppsTasksTask_TaskID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommittees"."ArtifactType" AS mjBizAppsCommitteesArtifactType_ArtifactTypeID
  ON
    "a"."ArtifactTypeID" = mjBizAppsCommitteesArtifactType_ArtifactTypeID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommon"."Person" AS mjBizAppsCommonPerson_UploadedByPersonID
  ON
    "a"."UploadedByPersonID" = mjBizAppsCommonPerson_UploadedByPersonID."ID"
LEFT OUTER JOIN
    "__mj"."Artifact" AS MJArtifact_MJArtifactID
  ON
    "a"."MJArtifactID" = MJArtifact_MJArtifactID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT,
    depth       INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Every view that DROP ... CASCADE removes: direct dependents AND theirs, transitively.
  -- Capturing only direct dependents restored vwTestRuns after a vwTestSuiteRuns regen but
  -- not vwConversations / vwConversationDetails, which select from vwTestRuns — they and their
  -- CRUD functions stayed permanently missing. depth is the LONGEST path from the target, so
  -- replaying in depth order always recreates a view after every view it reads.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_dep_oids (
    view_oid OID,
    depth    INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_dep_oids;
  INSERT INTO _vw_regen_dep_oids (view_oid, depth)
  WITH RECURSIVE deps(view_oid, depth) AS (
      SELECT DISTINCT dc.oid, 1
      FROM pg_depend d
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      JOIN pg_class tc ON tc.oid = d.refobjid
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tn.nspname = '__mj_bizappscommittees'
        AND tc.relname = 'vwArtifacts'
        AND tc.relkind IN ('v', 'm')
        AND dc.oid <> tc.oid
    UNION
      SELECT dc.oid, deps.depth + 1
      FROM deps
      JOIN pg_depend d ON d.refobjid = deps.view_oid
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      WHERE dc.oid <> deps.view_oid
        AND deps.depth < 50
  )
  SELECT view_oid, MAX(depth) FROM deps GROUP BY view_oid;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql, depth)
  SELECT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER')),
      o.depth
  FROM _vw_regen_dep_oids o
  JOIN pg_class dc ON dc.oid = o.view_oid
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  -- The set is the target view plus every view captured above, because CASCADE drops the
  -- functions of each of them, not only the target's.
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_proc pp
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE pp.prokind IN ('f', 'p')
    AND EXISTS (
      SELECT 1
      FROM pg_class c
      WHERE (c.oid IN (SELECT view_oid FROM _vw_regen_dep_oids)
             OR c.oid = (SELECT tc.oid FROM pg_class tc
                         JOIN pg_namespace tn ON tn.oid = tc.relnamespace
                         WHERE tn.nspname = '__mj_bizappscommittees'
                           AND tc.relname = 'vwArtifacts'
                           AND tc.relkind IN ('v', 'm')))
        AND (pp.prorettype = c.reltype
             OR EXISTS (SELECT 1 FROM pg_depend d
                        WHERE d.classid = 'pg_proc'::regclass
                          AND d.objid = pp.oid
                          AND d.refobjid = c.oid))
  );

  DROP VIEW IF EXISTS "__mj_bizappscommittees"."vwArtifacts" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps ORDER BY depth, view_name LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_dep_oids;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON "__mj_bizappscommittees"."vwArtifacts" TO "cdp_UI";
GRANT SELECT ON "__mj_bizappscommittees"."vwArtifacts" TO "cdp_Developer";
GRANT SELECT ON "__mj_bizappscommittees"."vwArtifacts" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifacts
-- Item: spCreateArtifact
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Artifact
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateArtifact'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spCreateArtifact"(
    p_id UUID DEFAULT NULL,
    p_committeeid_clear boolean DEFAULT false,
    p_committeeid UUID DEFAULT NULL,
    p_meetingid_clear boolean DEFAULT false,
    p_meetingid UUID DEFAULT NULL,
    p_agendaitemid_clear boolean DEFAULT false,
    p_agendaitemid UUID DEFAULT NULL,
    p_taskid_clear boolean DEFAULT false,
    p_taskid UUID DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_artifacttypeid UUID DEFAULT NULL,
    p_provider varchar(50) DEFAULT NULL,
    p_externalid_clear boolean DEFAULT false,
    p_externalid varchar(500) DEFAULT NULL,
    p_url varchar(2000) DEFAULT NULL,
    p_mimetype_clear boolean DEFAULT false,
    p_mimetype varchar(100) DEFAULT NULL,
    p_filesize_clear boolean DEFAULT false,
    p_filesize bigint DEFAULT NULL,
    p_uploadedbypersonid_clear boolean DEFAULT false,
    p_uploadedbypersonid UUID DEFAULT NULL,
    p_mjartifactid_clear boolean DEFAULT false,
    p_mjartifactid UUID DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwArtifacts" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO "__mj_bizappscommittees"."Artifact"
        (
            "ID",
            "CommitteeID",
                "MeetingID",
                "AgendaItemID",
                "TaskID",
                "Name",
                "Description",
                "ArtifactTypeID",
                "Provider",
                "ExternalID",
                "URL",
                "MimeType",
                "FileSize",
                "UploadedByPersonID",
                "MJArtifactID"
        )
    VALUES
        (
            v_new_id,
            CASE WHEN p_committeeid_clear = true THEN NULL ELSE COALESCE(p_committeeid, NULL) END,
                CASE WHEN p_meetingid_clear = true THEN NULL ELSE COALESCE(p_meetingid, NULL) END,
                CASE WHEN p_agendaitemid_clear = true THEN NULL ELSE COALESCE(p_agendaitemid, NULL) END,
                CASE WHEN p_taskid_clear = true THEN NULL ELSE COALESCE(p_taskid, NULL) END,
                p_name,
                CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, NULL) END,
                p_artifacttypeid,
                p_provider,
                CASE WHEN p_externalid_clear = true THEN NULL ELSE COALESCE(p_externalid, NULL) END,
                p_url,
                CASE WHEN p_mimetype_clear = true THEN NULL ELSE COALESCE(p_mimetype, NULL) END,
                CASE WHEN p_filesize_clear = true THEN NULL ELSE COALESCE(p_filesize, NULL) END,
                CASE WHEN p_uploadedbypersonid_clear = true THEN NULL ELSE COALESCE(p_uploadedbypersonid, NULL) END,
                CASE WHEN p_mjartifactid_clear = true THEN NULL ELSE COALESCE(p_mjartifactid, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwArtifacts"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateArtifact" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateArtifact" TO "cdp_Integration";


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifacts
-- Item: spUpdateArtifact
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Artifact
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateArtifact'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spUpdateArtifact"(
    p_id UUID,
    p_committeeid_clear boolean DEFAULT false,
    p_committeeid UUID DEFAULT NULL,
    p_meetingid_clear boolean DEFAULT false,
    p_meetingid UUID DEFAULT NULL,
    p_agendaitemid_clear boolean DEFAULT false,
    p_agendaitemid UUID DEFAULT NULL,
    p_taskid_clear boolean DEFAULT false,
    p_taskid UUID DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_artifacttypeid UUID DEFAULT NULL,
    p_provider varchar(50) DEFAULT NULL,
    p_externalid_clear boolean DEFAULT false,
    p_externalid varchar(500) DEFAULT NULL,
    p_url varchar(2000) DEFAULT NULL,
    p_mimetype_clear boolean DEFAULT false,
    p_mimetype varchar(100) DEFAULT NULL,
    p_filesize_clear boolean DEFAULT false,
    p_filesize bigint DEFAULT NULL,
    p_uploadedbypersonid_clear boolean DEFAULT false,
    p_uploadedbypersonid UUID DEFAULT NULL,
    p_mjartifactid_clear boolean DEFAULT false,
    p_mjartifactid UUID DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwArtifacts" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE "__mj_bizappscommittees"."Artifact"
    SET
        "CommitteeID" = CASE WHEN p_committeeid_clear = true THEN NULL ELSE COALESCE(p_committeeid, "CommitteeID") END,
        "MeetingID" = CASE WHEN p_meetingid_clear = true THEN NULL ELSE COALESCE(p_meetingid, "MeetingID") END,
        "AgendaItemID" = CASE WHEN p_agendaitemid_clear = true THEN NULL ELSE COALESCE(p_agendaitemid, "AgendaItemID") END,
        "TaskID" = CASE WHEN p_taskid_clear = true THEN NULL ELSE COALESCE(p_taskid, "TaskID") END,
        "Name" = COALESCE(p_name, "Name"),
        "Description" = CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, "Description") END,
        "ArtifactTypeID" = COALESCE(p_artifacttypeid, "ArtifactTypeID"),
        "Provider" = COALESCE(p_provider, "Provider"),
        "ExternalID" = CASE WHEN p_externalid_clear = true THEN NULL ELSE COALESCE(p_externalid, "ExternalID") END,
        "URL" = COALESCE(p_url, "URL"),
        "MimeType" = CASE WHEN p_mimetype_clear = true THEN NULL ELSE COALESCE(p_mimetype, "MimeType") END,
        "FileSize" = CASE WHEN p_filesize_clear = true THEN NULL ELSE COALESCE(p_filesize, "FileSize") END,
        "UploadedByPersonID" = CASE WHEN p_uploadedbypersonid_clear = true THEN NULL ELSE COALESCE(p_uploadedbypersonid, "UploadedByPersonID") END,
        "MJArtifactID" = CASE WHEN p_mjartifactid_clear = true THEN NULL ELSE COALESCE(p_mjartifactid, "MJArtifactID") END,
        "__mj_UpdatedAt" = (NOW() AT TIME ZONE 'UTC')
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwArtifacts"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateArtifact" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateArtifact" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Artifact table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_trg_update_artifact"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_artifact" ON "__mj_bizappscommittees"."Artifact";

CREATE TRIGGER "trg_update_artifact"
BEFORE UPDATE ON "__mj_bizappscommittees"."Artifact"
FOR EACH ROW
EXECUTE FUNCTION "__mj_bizappscommittees"."fn_trg_update_artifact"();



-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Artifacts
-- Item: spDeleteArtifact
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Artifact
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteArtifact'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spDeleteArtifact"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM "__mj_bizappscommittees"."Artifact"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteArtifact" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteArtifact" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Attendances
-- Item: Index for Foreign Keys
-- ============================================================
-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Attendance'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'MeetingID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_attendance_meeting_id"
            ON "__mj_bizappscommittees"."Attendance" ("MeetingID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Attendance'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'PersonID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_attendance_person_id"
            ON "__mj_bizappscommittees"."Attendance" ("PersonID");
    END IF;
END
$$;

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Attendances
-- Item: vwAttendances
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Attendances
-----               SCHEMA:      __mj_bizappscommittees
-----               BASE TABLE:  Attendance
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW "__mj_bizappscommittees"."vwAttendances"
AS
SELECT
    a.*,
    mjBizAppsCommitteesMeeting_MeetingID."Name" AS "Meeting",
    mjBizAppsCommonPerson_PersonID."DisplayName" AS "Person"
FROM
    "__mj_bizappscommittees"."Attendance" AS a
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Meeting" AS mjBizAppsCommitteesMeeting_MeetingID
  ON
    "a"."MeetingID" = mjBizAppsCommitteesMeeting_MeetingID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommon"."Person" AS mjBizAppsCommonPerson_PersonID
  ON
    "a"."PersonID" = mjBizAppsCommonPerson_PersonID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT,
    depth       INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Every view that DROP ... CASCADE removes: direct dependents AND theirs, transitively.
  -- Capturing only direct dependents restored vwTestRuns after a vwTestSuiteRuns regen but
  -- not vwConversations / vwConversationDetails, which select from vwTestRuns — they and their
  -- CRUD functions stayed permanently missing. depth is the LONGEST path from the target, so
  -- replaying in depth order always recreates a view after every view it reads.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_dep_oids (
    view_oid OID,
    depth    INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_dep_oids;
  INSERT INTO _vw_regen_dep_oids (view_oid, depth)
  WITH RECURSIVE deps(view_oid, depth) AS (
      SELECT DISTINCT dc.oid, 1
      FROM pg_depend d
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      JOIN pg_class tc ON tc.oid = d.refobjid
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tn.nspname = '__mj_bizappscommittees'
        AND tc.relname = 'vwAttendances'
        AND tc.relkind IN ('v', 'm')
        AND dc.oid <> tc.oid
    UNION
      SELECT dc.oid, deps.depth + 1
      FROM deps
      JOIN pg_depend d ON d.refobjid = deps.view_oid
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      WHERE dc.oid <> deps.view_oid
        AND deps.depth < 50
  )
  SELECT view_oid, MAX(depth) FROM deps GROUP BY view_oid;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql, depth)
  SELECT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER')),
      o.depth
  FROM _vw_regen_dep_oids o
  JOIN pg_class dc ON dc.oid = o.view_oid
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  -- The set is the target view plus every view captured above, because CASCADE drops the
  -- functions of each of them, not only the target's.
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_proc pp
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE pp.prokind IN ('f', 'p')
    AND EXISTS (
      SELECT 1
      FROM pg_class c
      WHERE (c.oid IN (SELECT view_oid FROM _vw_regen_dep_oids)
             OR c.oid = (SELECT tc.oid FROM pg_class tc
                         JOIN pg_namespace tn ON tn.oid = tc.relnamespace
                         WHERE tn.nspname = '__mj_bizappscommittees'
                           AND tc.relname = 'vwAttendances'
                           AND tc.relkind IN ('v', 'm')))
        AND (pp.prorettype = c.reltype
             OR EXISTS (SELECT 1 FROM pg_depend d
                        WHERE d.classid = 'pg_proc'::regclass
                          AND d.objid = pp.oid
                          AND d.refobjid = c.oid))
  );

  DROP VIEW IF EXISTS "__mj_bizappscommittees"."vwAttendances" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps ORDER BY depth, view_name LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_dep_oids;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON "__mj_bizappscommittees"."vwAttendances" TO "cdp_UI";
GRANT SELECT ON "__mj_bizappscommittees"."vwAttendances" TO "cdp_Developer";
GRANT SELECT ON "__mj_bizappscommittees"."vwAttendances" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Attendances
-- Item: spCreateAttendance
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Attendance
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateAttendance'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spCreateAttendance"(
    p_id UUID DEFAULT NULL,
    p_meetingid UUID DEFAULT NULL,
    p_personid UUID DEFAULT NULL,
    p_attendancestatus varchar(50) DEFAULT NULL,
    p_joinedat_clear boolean DEFAULT false,
    p_joinedat TIMESTAMPTZ DEFAULT NULL,
    p_leftat_clear boolean DEFAULT false,
    p_leftat TIMESTAMPTZ DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes varchar(500) DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwAttendances" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO "__mj_bizappscommittees"."Attendance"
        (
            "ID",
            "MeetingID",
                "PersonID",
                "AttendanceStatus",
                "JoinedAt",
                "LeftAt",
                "Notes"
        )
    VALUES
        (
            v_new_id,
            p_meetingid,
                p_personid,
                COALESCE(p_attendancestatus, 'Expected'),
                CASE WHEN p_joinedat_clear = true THEN NULL ELSE COALESCE(p_joinedat, NULL) END,
                CASE WHEN p_leftat_clear = true THEN NULL ELSE COALESCE(p_leftat, NULL) END,
                CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwAttendances"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateAttendance" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateAttendance" TO "cdp_Integration";


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Attendances
-- Item: spUpdateAttendance
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Attendance
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateAttendance'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spUpdateAttendance"(
    p_id UUID,
    p_meetingid UUID DEFAULT NULL,
    p_personid UUID DEFAULT NULL,
    p_attendancestatus varchar(50) DEFAULT NULL,
    p_joinedat_clear boolean DEFAULT false,
    p_joinedat TIMESTAMPTZ DEFAULT NULL,
    p_leftat_clear boolean DEFAULT false,
    p_leftat TIMESTAMPTZ DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes varchar(500) DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwAttendances" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE "__mj_bizappscommittees"."Attendance"
    SET
        "MeetingID" = COALESCE(p_meetingid, "MeetingID"),
        "PersonID" = COALESCE(p_personid, "PersonID"),
        "AttendanceStatus" = COALESCE(p_attendancestatus, "AttendanceStatus"),
        "JoinedAt" = CASE WHEN p_joinedat_clear = true THEN NULL ELSE COALESCE(p_joinedat, "JoinedAt") END,
        "LeftAt" = CASE WHEN p_leftat_clear = true THEN NULL ELSE COALESCE(p_leftat, "LeftAt") END,
        "Notes" = CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, "Notes") END,
        "__mj_UpdatedAt" = (NOW() AT TIME ZONE 'UTC')
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwAttendances"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateAttendance" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateAttendance" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Attendance table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_trg_update_attendance"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_attendance" ON "__mj_bizappscommittees"."Attendance";

CREATE TRIGGER "trg_update_attendance"
BEFORE UPDATE ON "__mj_bizappscommittees"."Attendance"
FOR EACH ROW
EXECUTE FUNCTION "__mj_bizappscommittees"."fn_trg_update_attendance"();



-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Attendances
-- Item: spDeleteAttendance
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Attendance
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteAttendance'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spDeleteAttendance"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM "__mj_bizappscommittees"."Attendance"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteAttendance" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteAttendance" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Ballots
-- Item: Index for Foreign Keys
-- ============================================================
-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Ballot'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'CommitteeID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_ballot_committee_id"
            ON "__mj_bizappscommittees"."Ballot" ("CommitteeID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Ballot'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'MotionID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_ballot_motion_id"
            ON "__mj_bizappscommittees"."Ballot" ("MotionID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Ballot'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'CreatedByMembershipID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_ballot_created_by_membership_id"
            ON "__mj_bizappscommittees"."Ballot" ("CreatedByMembershipID");
    END IF;
END
$$;

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Ballots
-- Item: vwBallots
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Ballots
-----               SCHEMA:      __mj_bizappscommittees
-----               BASE TABLE:  Ballot
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW "__mj_bizappscommittees"."vwBallots"
AS
SELECT
    b.*,
    mjBizAppsCommitteesCommittee_CommitteeID."Name" AS "Committee",
    mjBizAppsCommitteesMotion_MotionID."Name" AS "Motion"
FROM
    "__mj_bizappscommittees"."Ballot" AS b
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Committee" AS mjBizAppsCommitteesCommittee_CommitteeID
  ON
    "b"."CommitteeID" = mjBizAppsCommitteesCommittee_CommitteeID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Motion" AS mjBizAppsCommitteesMotion_MotionID
  ON
    "b"."MotionID" = mjBizAppsCommitteesMotion_MotionID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT,
    depth       INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Every view that DROP ... CASCADE removes: direct dependents AND theirs, transitively.
  -- Capturing only direct dependents restored vwTestRuns after a vwTestSuiteRuns regen but
  -- not vwConversations / vwConversationDetails, which select from vwTestRuns — they and their
  -- CRUD functions stayed permanently missing. depth is the LONGEST path from the target, so
  -- replaying in depth order always recreates a view after every view it reads.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_dep_oids (
    view_oid OID,
    depth    INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_dep_oids;
  INSERT INTO _vw_regen_dep_oids (view_oid, depth)
  WITH RECURSIVE deps(view_oid, depth) AS (
      SELECT DISTINCT dc.oid, 1
      FROM pg_depend d
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      JOIN pg_class tc ON tc.oid = d.refobjid
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tn.nspname = '__mj_bizappscommittees'
        AND tc.relname = 'vwBallots'
        AND tc.relkind IN ('v', 'm')
        AND dc.oid <> tc.oid
    UNION
      SELECT dc.oid, deps.depth + 1
      FROM deps
      JOIN pg_depend d ON d.refobjid = deps.view_oid
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      WHERE dc.oid <> deps.view_oid
        AND deps.depth < 50
  )
  SELECT view_oid, MAX(depth) FROM deps GROUP BY view_oid;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql, depth)
  SELECT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER')),
      o.depth
  FROM _vw_regen_dep_oids o
  JOIN pg_class dc ON dc.oid = o.view_oid
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  -- The set is the target view plus every view captured above, because CASCADE drops the
  -- functions of each of them, not only the target's.
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_proc pp
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE pp.prokind IN ('f', 'p')
    AND EXISTS (
      SELECT 1
      FROM pg_class c
      WHERE (c.oid IN (SELECT view_oid FROM _vw_regen_dep_oids)
             OR c.oid = (SELECT tc.oid FROM pg_class tc
                         JOIN pg_namespace tn ON tn.oid = tc.relnamespace
                         WHERE tn.nspname = '__mj_bizappscommittees'
                           AND tc.relname = 'vwBallots'
                           AND tc.relkind IN ('v', 'm')))
        AND (pp.prorettype = c.reltype
             OR EXISTS (SELECT 1 FROM pg_depend d
                        WHERE d.classid = 'pg_proc'::regclass
                          AND d.objid = pp.oid
                          AND d.refobjid = c.oid))
  );

  DROP VIEW IF EXISTS "__mj_bizappscommittees"."vwBallots" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps ORDER BY depth, view_name LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_dep_oids;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON "__mj_bizappscommittees"."vwBallots" TO "cdp_UI";
GRANT SELECT ON "__mj_bizappscommittees"."vwBallots" TO "cdp_Developer";
GRANT SELECT ON "__mj_bizappscommittees"."vwBallots" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Ballots
-- Item: spCreateBallot
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Ballot
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateBallot'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spCreateBallot"(
    p_id UUID DEFAULT NULL,
    p_committeeid UUID DEFAULT NULL,
    p_motionid UUID DEFAULT NULL,
    p_opensat TIMESTAMPTZ DEFAULT NULL,
    p_closesat TIMESTAMPTZ DEFAULT NULL,
    p_closedat_clear boolean DEFAULT false,
    p_closedat TIMESTAMPTZ DEFAULT NULL,
    p_thresholdtype varchar(20) DEFAULT NULL,
    p_issealed BOOLEAN DEFAULT NULL,
    p_status varchar(20) DEFAULT NULL,
    p_createdbymembershipid_clear boolean DEFAULT false,
    p_createdbymembershipid UUID DEFAULT NULL,
    p_resultnotes_clear boolean DEFAULT false,
    p_resultnotes TEXT DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwBallots" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO "__mj_bizappscommittees"."Ballot"
        (
            "ID",
            "CommitteeID",
                "MotionID",
                "OpensAt",
                "ClosesAt",
                "ClosedAt",
                "ThresholdType",
                "IsSealed",
                "Status",
                "CreatedByMembershipID",
                "ResultNotes"
        )
    VALUES
        (
            v_new_id,
            p_committeeid,
                p_motionid,
                p_opensat,
                p_closesat,
                CASE WHEN p_closedat_clear = true THEN NULL ELSE COALESCE(p_closedat, NULL) END,
                COALESCE(p_thresholdtype, 'SimpleMajority'),
                COALESCE(p_issealed, TRUE),
                COALESCE(p_status, 'Open'),
                CASE WHEN p_createdbymembershipid_clear = true THEN NULL ELSE COALESCE(p_createdbymembershipid, NULL) END,
                CASE WHEN p_resultnotes_clear = true THEN NULL ELSE COALESCE(p_resultnotes, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwBallots"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateBallot" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateBallot" TO "cdp_Integration";


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Ballots
-- Item: spUpdateBallot
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Ballot
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateBallot'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spUpdateBallot"(
    p_id UUID,
    p_committeeid UUID DEFAULT NULL,
    p_motionid UUID DEFAULT NULL,
    p_opensat TIMESTAMPTZ DEFAULT NULL,
    p_closesat TIMESTAMPTZ DEFAULT NULL,
    p_closedat_clear boolean DEFAULT false,
    p_closedat TIMESTAMPTZ DEFAULT NULL,
    p_thresholdtype varchar(20) DEFAULT NULL,
    p_issealed BOOLEAN DEFAULT NULL,
    p_status varchar(20) DEFAULT NULL,
    p_createdbymembershipid_clear boolean DEFAULT false,
    p_createdbymembershipid UUID DEFAULT NULL,
    p_resultnotes_clear boolean DEFAULT false,
    p_resultnotes TEXT DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwBallots" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE "__mj_bizappscommittees"."Ballot"
    SET
        "CommitteeID" = COALESCE(p_committeeid, "CommitteeID"),
        "MotionID" = COALESCE(p_motionid, "MotionID"),
        "OpensAt" = COALESCE(p_opensat, "OpensAt"),
        "ClosesAt" = COALESCE(p_closesat, "ClosesAt"),
        "ClosedAt" = CASE WHEN p_closedat_clear = true THEN NULL ELSE COALESCE(p_closedat, "ClosedAt") END,
        "ThresholdType" = COALESCE(p_thresholdtype, "ThresholdType"),
        "IsSealed" = COALESCE(p_issealed, "IsSealed"),
        "Status" = COALESCE(p_status, "Status"),
        "CreatedByMembershipID" = CASE WHEN p_createdbymembershipid_clear = true THEN NULL ELSE COALESCE(p_createdbymembershipid, "CreatedByMembershipID") END,
        "ResultNotes" = CASE WHEN p_resultnotes_clear = true THEN NULL ELSE COALESCE(p_resultnotes, "ResultNotes") END,
        "__mj_UpdatedAt" = (NOW() AT TIME ZONE 'UTC')
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwBallots"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateBallot" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateBallot" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Ballot table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_trg_update_ballot"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_ballot" ON "__mj_bizappscommittees"."Ballot";

CREATE TRIGGER "trg_update_ballot"
BEFORE UPDATE ON "__mj_bizappscommittees"."Ballot"
FOR EACH ROW
EXECUTE FUNCTION "__mj_bizappscommittees"."fn_trg_update_ballot"();



-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Ballots
-- Item: spDeleteBallot
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Ballot
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteBallot'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spDeleteBallot"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM "__mj_bizappscommittees"."Ballot"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteBallot" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteBallot" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Comments
-- Item: Index for Foreign Keys
-- ============================================================
-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Comment'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'CommitteeID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_comment_committee_id"
            ON "__mj_bizappscommittees"."Comment" ("CommitteeID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Comment'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'MeetingID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_comment_meeting_id"
            ON "__mj_bizappscommittees"."Comment" ("MeetingID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Comment'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'AgendaItemID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_comment_agenda_item_id"
            ON "__mj_bizappscommittees"."Comment" ("AgendaItemID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Comment'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'TaskID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_comment_task_id"
            ON "__mj_bizappscommittees"."Comment" ("TaskID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Comment'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'ArtifactID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_comment_artifact_id"
            ON "__mj_bizappscommittees"."Comment" ("ArtifactID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Comment'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'ParentCommentID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_comment_parent_comment_id"
            ON "__mj_bizappscommittees"."Comment" ("ParentCommentID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Comment'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'PersonID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_comment_person_id"
            ON "__mj_bizappscommittees"."Comment" ("PersonID");
    END IF;
END
$$;

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Comments
-- Item: fn_comment_parent_comment_id_get_hierarchy_meta
-- ============================================================

------------------------------------------------------------
----- HIERARCHY METADATA FUNCTION FOR: Comment.ParentCommentID
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_comment_parent_comment_id_get_hierarchy_meta"(
    p_record_id UUID,
    p_parent_id UUID
) RETURNS TABLE (
    "RootID" UUID,
    "Depth" INTEGER,
    "Path" TEXT,
    "IsLeaf" BOOLEAN,
    "ChildCount" INTEGER
) AS $$
    WITH RECURSIVE cte_ancestors AS (
        SELECT
            "ID",
            "ParentCommentID",
            0 AS depth,
            '/' || "ID"::TEXT || '/' AS path
        FROM
            "__mj_bizappscommittees"."Comment"
        WHERE
            "ID" = p_record_id

        UNION ALL

        SELECT
            p."ID",
            p."ParentCommentID",
            c.depth + 1 AS depth,
            '/' || p."ID"::TEXT || c.path AS path
        FROM
            "__mj_bizappscommittees"."Comment" p
        INNER JOIN
            cte_ancestors c ON p."ID" = c."ParentCommentID"
        WHERE
            c.depth < 100
    )
    SELECT
        a."ID" AS "RootID",
        a.depth::INTEGER AS "Depth",
        a.path::TEXT AS "Path",
        (ch.child_count = 0)::BOOLEAN AS "IsLeaf",
        ch.child_count AS "ChildCount"
    FROM
        cte_ancestors a
    CROSS JOIN LATERAL (
        SELECT COUNT(1)::INTEGER AS child_count
        FROM "__mj_bizappscommittees"."Comment"
        WHERE "ParentCommentID" = p_record_id
    ) ch
    WHERE
        a."ParentCommentID" IS NULL OR p_parent_id IS NULL
    ORDER BY
        a.depth DESC
    LIMIT 1;
$$ LANGUAGE sql STABLE;


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Comments
-- Item: fn_comment_parent_comment_id_get_descendants
-- ============================================================

------------------------------------------------------------
----- DESCENDANTS FUNCTION FOR: Comment.ParentCommentID
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_comment_parent_comment_id_get_descendants"(
    p_root_id UUID,
    p_max_depth INTEGER DEFAULT NULL
) RETURNS TABLE (
    "ID" UUID,
    "Depth" INTEGER,
    "Path" TEXT,
    "IsLeaf" BOOLEAN,
    "ChildCount" INTEGER
) AS $$
    WITH RECURSIVE cte_descendants AS (
        SELECT
            "ID",
            "ParentCommentID",
            0 AS relative_depth,
            '/' || "ID"::TEXT || '/' AS path
        FROM
            "__mj_bizappscommittees"."Comment"
        WHERE
            "ID" = p_root_id

        UNION ALL

        SELECT
            c."ID",
            c."ParentCommentID",
            p.relative_depth + 1 AS relative_depth,
            p.path || c."ID"::TEXT || '/' AS path
        FROM
            "__mj_bizappscommittees"."Comment" c
        INNER JOIN
            cte_descendants p ON c."ParentCommentID" = p."ID"
        WHERE
            (p_max_depth IS NULL OR p.relative_depth < p_max_depth)
            AND p.relative_depth < 100
    )
    SELECT
        d."ID" AS "ID",
        d.relative_depth AS "Depth",
        d.path AS "Path",
        (NOT EXISTS (SELECT 1 FROM "__mj_bizappscommittees"."Comment" WHERE "ParentCommentID" = d."ID"))::BOOLEAN AS "IsLeaf",
        (SELECT COUNT(1)::INTEGER FROM "__mj_bizappscommittees"."Comment" WHERE "ParentCommentID" = d."ID") AS "ChildCount"
    FROM
        cte_descendants d;
$$ LANGUAGE sql STABLE;


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Comments
-- Item: fn_comment_parent_comment_id_get_ancestors
-- ============================================================

------------------------------------------------------------
----- ANCESTORS FUNCTION FOR: Comment.ParentCommentID
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_comment_parent_comment_id_get_ancestors"(
    p_record_id UUID
) RETURNS TABLE (
    "ID" UUID,
    "LevelUp" INTEGER,
    "Path" TEXT
) AS $$
    WITH RECURSIVE cte_ancestors AS (
        SELECT
            "ID",
            "ParentCommentID",
            0 AS level_up,
            '/' || "ID"::TEXT || '/' AS path
        FROM
            "__mj_bizappscommittees"."Comment"
        WHERE
            "ID" = p_record_id

        UNION ALL

        SELECT
            p."ID",
            p."ParentCommentID",
            c.level_up + 1 AS level_up,
            '/' || p."ID"::TEXT || c.path AS path
        FROM
            "__mj_bizappscommittees"."Comment" p
        INNER JOIN
            cte_ancestors c ON p."ID" = c."ParentCommentID"
        WHERE
            c.level_up < 100
    )
    SELECT
        a."ID" AS "ID",
        a.level_up AS "LevelUp",
        a.path AS "Path"
    FROM
        cte_ancestors a;
$$ LANGUAGE sql STABLE;


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Comments
-- Item: fn_comment_parent_comment_id_get_root_id
-- ============================================================

------------------------------------------------------------
----- ROOT ID FUNCTION FOR: Comment.ParentCommentID
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_comment_parent_comment_id_get_root_id"(
    p_record_id UUID,
    p_parent_id UUID
) RETURNS UUID AS $$
    WITH RECURSIVE cte_root_parent AS (
        -- Anchor: Start from p_parent_id if not null, otherwise start from p_record_id
        SELECT
            "ID",
            "ParentCommentID",
            "ID" AS root_parent_id,
            0 AS depth
        FROM
            "__mj_bizappscommittees"."Comment"
        WHERE
            "ID" = COALESCE(p_parent_id, p_record_id)

        UNION ALL

        -- Recursive: Keep going up the hierarchy
        SELECT
            c."ID",
            c."ParentCommentID",
            c."ID" AS root_parent_id,
            p.depth + 1 AS depth
        FROM
            "__mj_bizappscommittees"."Comment" c
        INNER JOIN
            cte_root_parent p ON c."ID" = p."ParentCommentID"
        WHERE
            p.depth < 100  -- Prevent infinite loops
    )
    SELECT root_parent_id
    FROM cte_root_parent
    WHERE "ParentCommentID" IS NULL
    ORDER BY root_parent_id
    LIMIT 1;
$$ LANGUAGE sql STABLE;


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Comments
-- Item: vwComments
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Comments
-----               SCHEMA:      __mj_bizappscommittees
-----               BASE TABLE:  Comment
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW "__mj_bizappscommittees"."vwComments"
AS
SELECT
    c.*,
    mjBizAppsCommitteesCommittee_CommitteeID."Name" AS "Committee",
    mjBizAppsCommitteesMeeting_MeetingID."Name" AS "Meeting",
    mjBizAppsCommitteesAgendaItem_AgendaItemID."Name" AS "AgendaItem",
    mjBizAppsTasksTask_TaskID."Name" AS "Task",
    mjBizAppsCommitteesArtifact_ArtifactID."Name" AS "Artifact",
    mjBizAppsCommonPerson_PersonID."DisplayName" AS "Person",
    hier_ParentCommentID."RootID" AS "RootParentCommentID",
    hier_ParentCommentID."Depth" AS "ParentCommentIDDepth",
    hier_ParentCommentID."Path" AS "ParentCommentIDPath",
    hier_ParentCommentID."IsLeaf" AS "ParentCommentIDIsLeaf",
    hier_ParentCommentID."ChildCount" AS "ParentCommentIDChildCount"
FROM
    "__mj_bizappscommittees"."Comment" AS c
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Committee" AS mjBizAppsCommitteesCommittee_CommitteeID
  ON
    "c"."CommitteeID" = mjBizAppsCommitteesCommittee_CommitteeID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Meeting" AS mjBizAppsCommitteesMeeting_MeetingID
  ON
    "c"."MeetingID" = mjBizAppsCommitteesMeeting_MeetingID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommittees"."AgendaItem" AS mjBizAppsCommitteesAgendaItem_AgendaItemID
  ON
    "c"."AgendaItemID" = mjBizAppsCommitteesAgendaItem_AgendaItemID."ID"
LEFT OUTER JOIN
    "__mj_bizappstasks"."Task" AS mjBizAppsTasksTask_TaskID
  ON
    "c"."TaskID" = mjBizAppsTasksTask_TaskID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Artifact" AS mjBizAppsCommitteesArtifact_ArtifactID
  ON
    "c"."ArtifactID" = mjBizAppsCommitteesArtifact_ArtifactID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommon"."Person" AS mjBizAppsCommonPerson_PersonID
  ON
    "c"."PersonID" = mjBizAppsCommonPerson_PersonID."ID"

LEFT JOIN LATERAL "__mj_bizappscommittees"."fn_comment_parent_comment_id_get_hierarchy_meta"(c."ID", c."ParentCommentID") AS hier_ParentCommentID ON true
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT,
    depth       INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Every view that DROP ... CASCADE removes: direct dependents AND theirs, transitively.
  -- Capturing only direct dependents restored vwTestRuns after a vwTestSuiteRuns regen but
  -- not vwConversations / vwConversationDetails, which select from vwTestRuns — they and their
  -- CRUD functions stayed permanently missing. depth is the LONGEST path from the target, so
  -- replaying in depth order always recreates a view after every view it reads.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_dep_oids (
    view_oid OID,
    depth    INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_dep_oids;
  INSERT INTO _vw_regen_dep_oids (view_oid, depth)
  WITH RECURSIVE deps(view_oid, depth) AS (
      SELECT DISTINCT dc.oid, 1
      FROM pg_depend d
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      JOIN pg_class tc ON tc.oid = d.refobjid
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tn.nspname = '__mj_bizappscommittees'
        AND tc.relname = 'vwComments'
        AND tc.relkind IN ('v', 'm')
        AND dc.oid <> tc.oid
    UNION
      SELECT dc.oid, deps.depth + 1
      FROM deps
      JOIN pg_depend d ON d.refobjid = deps.view_oid
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      WHERE dc.oid <> deps.view_oid
        AND deps.depth < 50
  )
  SELECT view_oid, MAX(depth) FROM deps GROUP BY view_oid;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql, depth)
  SELECT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER')),
      o.depth
  FROM _vw_regen_dep_oids o
  JOIN pg_class dc ON dc.oid = o.view_oid
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  -- The set is the target view plus every view captured above, because CASCADE drops the
  -- functions of each of them, not only the target's.
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_proc pp
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE pp.prokind IN ('f', 'p')
    AND EXISTS (
      SELECT 1
      FROM pg_class c
      WHERE (c.oid IN (SELECT view_oid FROM _vw_regen_dep_oids)
             OR c.oid = (SELECT tc.oid FROM pg_class tc
                         JOIN pg_namespace tn ON tn.oid = tc.relnamespace
                         WHERE tn.nspname = '__mj_bizappscommittees'
                           AND tc.relname = 'vwComments'
                           AND tc.relkind IN ('v', 'm')))
        AND (pp.prorettype = c.reltype
             OR EXISTS (SELECT 1 FROM pg_depend d
                        WHERE d.classid = 'pg_proc'::regclass
                          AND d.objid = pp.oid
                          AND d.refobjid = c.oid))
  );

  DROP VIEW IF EXISTS "__mj_bizappscommittees"."vwComments" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps ORDER BY depth, view_name LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_dep_oids;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON "__mj_bizappscommittees"."vwComments" TO "cdp_UI";
GRANT SELECT ON "__mj_bizappscommittees"."vwComments" TO "cdp_Developer";
GRANT SELECT ON "__mj_bizappscommittees"."vwComments" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Comments
-- Item: spCreateComment
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Comment
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateComment'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spCreateComment"(
    p_id UUID DEFAULT NULL,
    p_committeeid UUID DEFAULT NULL,
    p_meetingid_clear boolean DEFAULT false,
    p_meetingid UUID DEFAULT NULL,
    p_agendaitemid_clear boolean DEFAULT false,
    p_agendaitemid UUID DEFAULT NULL,
    p_taskid_clear boolean DEFAULT false,
    p_taskid UUID DEFAULT NULL,
    p_artifactid_clear boolean DEFAULT false,
    p_artifactid UUID DEFAULT NULL,
    p_parentcommentid_clear boolean DEFAULT false,
    p_parentcommentid UUID DEFAULT NULL,
    p_personid UUID DEFAULT NULL,
    p_commenttext TEXT DEFAULT NULL,
    p_mentionedpersonids_clear boolean DEFAULT false,
    p_mentionedpersonids TEXT DEFAULT NULL,
    p_isresolved BOOLEAN DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwComments" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO "__mj_bizappscommittees"."Comment"
        (
            "ID",
            "CommitteeID",
                "MeetingID",
                "AgendaItemID",
                "TaskID",
                "ArtifactID",
                "ParentCommentID",
                "PersonID",
                "CommentText",
                "MentionedPersonIDs",
                "IsResolved"
        )
    VALUES
        (
            v_new_id,
            p_committeeid,
                CASE WHEN p_meetingid_clear = true THEN NULL ELSE COALESCE(p_meetingid, NULL) END,
                CASE WHEN p_agendaitemid_clear = true THEN NULL ELSE COALESCE(p_agendaitemid, NULL) END,
                CASE WHEN p_taskid_clear = true THEN NULL ELSE COALESCE(p_taskid, NULL) END,
                CASE WHEN p_artifactid_clear = true THEN NULL ELSE COALESCE(p_artifactid, NULL) END,
                CASE WHEN p_parentcommentid_clear = true THEN NULL ELSE COALESCE(p_parentcommentid, NULL) END,
                p_personid,
                p_commenttext,
                CASE WHEN p_mentionedpersonids_clear = true THEN NULL ELSE COALESCE(p_mentionedpersonids, NULL) END,
                COALESCE(p_isresolved, FALSE)
        )
    ;

    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwComments"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateComment" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateComment" TO "cdp_Integration";


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Comments
-- Item: spUpdateComment
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Comment
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateComment'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spUpdateComment"(
    p_id UUID,
    p_committeeid UUID DEFAULT NULL,
    p_meetingid_clear boolean DEFAULT false,
    p_meetingid UUID DEFAULT NULL,
    p_agendaitemid_clear boolean DEFAULT false,
    p_agendaitemid UUID DEFAULT NULL,
    p_taskid_clear boolean DEFAULT false,
    p_taskid UUID DEFAULT NULL,
    p_artifactid_clear boolean DEFAULT false,
    p_artifactid UUID DEFAULT NULL,
    p_parentcommentid_clear boolean DEFAULT false,
    p_parentcommentid UUID DEFAULT NULL,
    p_personid UUID DEFAULT NULL,
    p_commenttext TEXT DEFAULT NULL,
    p_mentionedpersonids_clear boolean DEFAULT false,
    p_mentionedpersonids TEXT DEFAULT NULL,
    p_isresolved BOOLEAN DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwComments" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE "__mj_bizappscommittees"."Comment"
    SET
        "CommitteeID" = COALESCE(p_committeeid, "CommitteeID"),
        "MeetingID" = CASE WHEN p_meetingid_clear = true THEN NULL ELSE COALESCE(p_meetingid, "MeetingID") END,
        "AgendaItemID" = CASE WHEN p_agendaitemid_clear = true THEN NULL ELSE COALESCE(p_agendaitemid, "AgendaItemID") END,
        "TaskID" = CASE WHEN p_taskid_clear = true THEN NULL ELSE COALESCE(p_taskid, "TaskID") END,
        "ArtifactID" = CASE WHEN p_artifactid_clear = true THEN NULL ELSE COALESCE(p_artifactid, "ArtifactID") END,
        "ParentCommentID" = CASE WHEN p_parentcommentid_clear = true THEN NULL ELSE COALESCE(p_parentcommentid, "ParentCommentID") END,
        "PersonID" = COALESCE(p_personid, "PersonID"),
        "CommentText" = COALESCE(p_commenttext, "CommentText"),
        "MentionedPersonIDs" = CASE WHEN p_mentionedpersonids_clear = true THEN NULL ELSE COALESCE(p_mentionedpersonids, "MentionedPersonIDs") END,
        "IsResolved" = COALESCE(p_isresolved, "IsResolved"),
        "__mj_UpdatedAt" = (NOW() AT TIME ZONE 'UTC')
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwComments"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateComment" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateComment" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Comment table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_trg_update_comment"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_comment" ON "__mj_bizappscommittees"."Comment";

CREATE TRIGGER "trg_update_comment"
BEFORE UPDATE ON "__mj_bizappscommittees"."Comment"
FOR EACH ROW
EXECUTE FUNCTION "__mj_bizappscommittees"."fn_trg_update_comment"();



-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Comments
-- Item: spDeleteComment
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Comment
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteComment'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spDeleteComment"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM "__mj_bizappscommittees"."Comment"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteComment" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteComment" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Committees
-- Item: Index for Foreign Keys
-- ============================================================
-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Committee'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'TypeID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_committee_type_id"
            ON "__mj_bizappscommittees"."Committee" ("TypeID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Committee'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'ParentCommitteeID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_committee_parent_committee_id"
            ON "__mj_bizappscommittees"."Committee" ("ParentCommitteeID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Committee'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'OrganizationID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_committee_organization_id"
            ON "__mj_bizappscommittees"."Committee" ("OrganizationID");
    END IF;
END
$$;

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Committees
-- Item: fn_committee_parent_committee_id_get_hierarchy_meta
-- ============================================================

------------------------------------------------------------
----- HIERARCHY METADATA FUNCTION FOR: Committee.ParentCommitteeID
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_committee_parent_committee_id_get_hierarchy_meta"(
    p_record_id UUID,
    p_parent_id UUID
) RETURNS TABLE (
    "RootID" UUID,
    "Depth" INTEGER,
    "Path" TEXT,
    "IsLeaf" BOOLEAN,
    "ChildCount" INTEGER
) AS $$
    WITH RECURSIVE cte_ancestors AS (
        SELECT
            "ID",
            "ParentCommitteeID",
            0 AS depth,
            '/' || "ID"::TEXT || '/' AS path
        FROM
            "__mj_bizappscommittees"."Committee"
        WHERE
            "ID" = p_record_id

        UNION ALL

        SELECT
            p."ID",
            p."ParentCommitteeID",
            c.depth + 1 AS depth,
            '/' || p."ID"::TEXT || c.path AS path
        FROM
            "__mj_bizappscommittees"."Committee" p
        INNER JOIN
            cte_ancestors c ON p."ID" = c."ParentCommitteeID"
        WHERE
            c.depth < 100
    )
    SELECT
        a."ID" AS "RootID",
        a.depth::INTEGER AS "Depth",
        a.path::TEXT AS "Path",
        (ch.child_count = 0)::BOOLEAN AS "IsLeaf",
        ch.child_count AS "ChildCount"
    FROM
        cte_ancestors a
    CROSS JOIN LATERAL (
        SELECT COUNT(1)::INTEGER AS child_count
        FROM "__mj_bizappscommittees"."Committee"
        WHERE "ParentCommitteeID" = p_record_id
    ) ch
    WHERE
        a."ParentCommitteeID" IS NULL OR p_parent_id IS NULL
    ORDER BY
        a.depth DESC
    LIMIT 1;
$$ LANGUAGE sql STABLE;


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Committees
-- Item: fn_committee_parent_committee_id_get_descendants
-- ============================================================

------------------------------------------------------------
----- DESCENDANTS FUNCTION FOR: Committee.ParentCommitteeID
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_committee_parent_committee_id_get_descendants"(
    p_root_id UUID,
    p_max_depth INTEGER DEFAULT NULL
) RETURNS TABLE (
    "ID" UUID,
    "Depth" INTEGER,
    "Path" TEXT,
    "IsLeaf" BOOLEAN,
    "ChildCount" INTEGER
) AS $$
    WITH RECURSIVE cte_descendants AS (
        SELECT
            "ID",
            "ParentCommitteeID",
            0 AS relative_depth,
            '/' || "ID"::TEXT || '/' AS path
        FROM
            "__mj_bizappscommittees"."Committee"
        WHERE
            "ID" = p_root_id

        UNION ALL

        SELECT
            c."ID",
            c."ParentCommitteeID",
            p.relative_depth + 1 AS relative_depth,
            p.path || c."ID"::TEXT || '/' AS path
        FROM
            "__mj_bizappscommittees"."Committee" c
        INNER JOIN
            cte_descendants p ON c."ParentCommitteeID" = p."ID"
        WHERE
            (p_max_depth IS NULL OR p.relative_depth < p_max_depth)
            AND p.relative_depth < 100
    )
    SELECT
        d."ID" AS "ID",
        d.relative_depth AS "Depth",
        d.path AS "Path",
        (NOT EXISTS (SELECT 1 FROM "__mj_bizappscommittees"."Committee" WHERE "ParentCommitteeID" = d."ID"))::BOOLEAN AS "IsLeaf",
        (SELECT COUNT(1)::INTEGER FROM "__mj_bizappscommittees"."Committee" WHERE "ParentCommitteeID" = d."ID") AS "ChildCount"
    FROM
        cte_descendants d;
$$ LANGUAGE sql STABLE;


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Committees
-- Item: fn_committee_parent_committee_id_get_ancestors
-- ============================================================

------------------------------------------------------------
----- ANCESTORS FUNCTION FOR: Committee.ParentCommitteeID
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_committee_parent_committee_id_get_ancestors"(
    p_record_id UUID
) RETURNS TABLE (
    "ID" UUID,
    "LevelUp" INTEGER,
    "Path" TEXT
) AS $$
    WITH RECURSIVE cte_ancestors AS (
        SELECT
            "ID",
            "ParentCommitteeID",
            0 AS level_up,
            '/' || "ID"::TEXT || '/' AS path
        FROM
            "__mj_bizappscommittees"."Committee"
        WHERE
            "ID" = p_record_id

        UNION ALL

        SELECT
            p."ID",
            p."ParentCommitteeID",
            c.level_up + 1 AS level_up,
            '/' || p."ID"::TEXT || c.path AS path
        FROM
            "__mj_bizappscommittees"."Committee" p
        INNER JOIN
            cte_ancestors c ON p."ID" = c."ParentCommitteeID"
        WHERE
            c.level_up < 100
    )
    SELECT
        a."ID" AS "ID",
        a.level_up AS "LevelUp",
        a.path AS "Path"
    FROM
        cte_ancestors a;
$$ LANGUAGE sql STABLE;


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Committees
-- Item: fn_committee_parent_committee_id_get_root_id
-- ============================================================

------------------------------------------------------------
----- ROOT ID FUNCTION FOR: Committee.ParentCommitteeID
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_committee_parent_committee_id_get_root_id"(
    p_record_id UUID,
    p_parent_id UUID
) RETURNS UUID AS $$
    WITH RECURSIVE cte_root_parent AS (
        -- Anchor: Start from p_parent_id if not null, otherwise start from p_record_id
        SELECT
            "ID",
            "ParentCommitteeID",
            "ID" AS root_parent_id,
            0 AS depth
        FROM
            "__mj_bizappscommittees"."Committee"
        WHERE
            "ID" = COALESCE(p_parent_id, p_record_id)

        UNION ALL

        -- Recursive: Keep going up the hierarchy
        SELECT
            c."ID",
            c."ParentCommitteeID",
            c."ID" AS root_parent_id,
            p.depth + 1 AS depth
        FROM
            "__mj_bizappscommittees"."Committee" c
        INNER JOIN
            cte_root_parent p ON c."ID" = p."ParentCommitteeID"
        WHERE
            p.depth < 100  -- Prevent infinite loops
    )
    SELECT root_parent_id
    FROM cte_root_parent
    WHERE "ParentCommitteeID" IS NULL
    ORDER BY root_parent_id
    LIMIT 1;
$$ LANGUAGE sql STABLE;


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Committees
-- Item: vwCommittees
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Committees
-----               SCHEMA:      __mj_bizappscommittees
-----               BASE TABLE:  Committee
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW "__mj_bizappscommittees"."vwCommittees"
AS
SELECT
    c.*,
    mjBizAppsCommitteesType_TypeID."Name" AS "Type",
    mjBizAppsCommitteesCommittee_ParentCommitteeID."Name" AS "ParentCommittee",
    mjBizAppsCommonOrganization_OrganizationID."Name" AS "Organization",
    hier_ParentCommitteeID."RootID" AS "RootParentCommitteeID",
    hier_ParentCommitteeID."Depth" AS "ParentCommitteeIDDepth",
    hier_ParentCommitteeID."Path" AS "ParentCommitteeIDPath",
    hier_ParentCommitteeID."IsLeaf" AS "ParentCommitteeIDIsLeaf",
    hier_ParentCommitteeID."ChildCount" AS "ParentCommitteeIDChildCount"
FROM
    "__mj_bizappscommittees"."Committee" AS c
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Type" AS mjBizAppsCommitteesType_TypeID
  ON
    "c"."TypeID" = mjBizAppsCommitteesType_TypeID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Committee" AS mjBizAppsCommitteesCommittee_ParentCommitteeID
  ON
    "c"."ParentCommitteeID" = mjBizAppsCommitteesCommittee_ParentCommitteeID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommon"."Organization" AS mjBizAppsCommonOrganization_OrganizationID
  ON
    "c"."OrganizationID" = mjBizAppsCommonOrganization_OrganizationID."ID"

LEFT JOIN LATERAL "__mj_bizappscommittees"."fn_committee_parent_committee_id_get_hierarchy_meta"(c."ID", c."ParentCommitteeID") AS hier_ParentCommitteeID ON true
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT,
    depth       INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Every view that DROP ... CASCADE removes: direct dependents AND theirs, transitively.
  -- Capturing only direct dependents restored vwTestRuns after a vwTestSuiteRuns regen but
  -- not vwConversations / vwConversationDetails, which select from vwTestRuns — they and their
  -- CRUD functions stayed permanently missing. depth is the LONGEST path from the target, so
  -- replaying in depth order always recreates a view after every view it reads.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_dep_oids (
    view_oid OID,
    depth    INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_dep_oids;
  INSERT INTO _vw_regen_dep_oids (view_oid, depth)
  WITH RECURSIVE deps(view_oid, depth) AS (
      SELECT DISTINCT dc.oid, 1
      FROM pg_depend d
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      JOIN pg_class tc ON tc.oid = d.refobjid
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tn.nspname = '__mj_bizappscommittees'
        AND tc.relname = 'vwCommittees'
        AND tc.relkind IN ('v', 'm')
        AND dc.oid <> tc.oid
    UNION
      SELECT dc.oid, deps.depth + 1
      FROM deps
      JOIN pg_depend d ON d.refobjid = deps.view_oid
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      WHERE dc.oid <> deps.view_oid
        AND deps.depth < 50
  )
  SELECT view_oid, MAX(depth) FROM deps GROUP BY view_oid;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql, depth)
  SELECT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER')),
      o.depth
  FROM _vw_regen_dep_oids o
  JOIN pg_class dc ON dc.oid = o.view_oid
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  -- The set is the target view plus every view captured above, because CASCADE drops the
  -- functions of each of them, not only the target's.
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_proc pp
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE pp.prokind IN ('f', 'p')
    AND EXISTS (
      SELECT 1
      FROM pg_class c
      WHERE (c.oid IN (SELECT view_oid FROM _vw_regen_dep_oids)
             OR c.oid = (SELECT tc.oid FROM pg_class tc
                         JOIN pg_namespace tn ON tn.oid = tc.relnamespace
                         WHERE tn.nspname = '__mj_bizappscommittees'
                           AND tc.relname = 'vwCommittees'
                           AND tc.relkind IN ('v', 'm')))
        AND (pp.prorettype = c.reltype
             OR EXISTS (SELECT 1 FROM pg_depend d
                        WHERE d.classid = 'pg_proc'::regclass
                          AND d.objid = pp.oid
                          AND d.refobjid = c.oid))
  );

  DROP VIEW IF EXISTS "__mj_bizappscommittees"."vwCommittees" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps ORDER BY depth, view_name LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_dep_oids;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON "__mj_bizappscommittees"."vwCommittees" TO "cdp_UI";
GRANT SELECT ON "__mj_bizappscommittees"."vwCommittees" TO "cdp_Developer";
GRANT SELECT ON "__mj_bizappscommittees"."vwCommittees" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Committees
-- Item: spCreateCommittee
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Committee
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateCommittee'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spCreateCommittee"(
    p_id UUID DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_typeid UUID DEFAULT NULL,
    p_parentcommitteeid_clear boolean DEFAULT false,
    p_parentcommitteeid UUID DEFAULT NULL,
    p_organizationid_clear boolean DEFAULT false,
    p_organizationid UUID DEFAULT NULL,
    p_charterdocumenturl_clear boolean DEFAULT false,
    p_charterdocumenturl varchar(1000) DEFAULT NULL,
    p_missionstatement_clear boolean DEFAULT false,
    p_missionstatement TEXT DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL,
    p_ispublic BOOLEAN DEFAULT NULL,
    p_formationdate_clear boolean DEFAULT false,
    p_formationdate date DEFAULT NULL,
    p_dissolutiondate_clear boolean DEFAULT false,
    p_dissolutiondate date DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwCommittees" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO "__mj_bizappscommittees"."Committee"
        (
            "ID",
            "Name",
                "Description",
                "TypeID",
                "ParentCommitteeID",
                "OrganizationID",
                "CharterDocumentURL",
                "MissionStatement",
                "Status",
                "IsPublic",
                "FormationDate",
                "DissolutionDate"
        )
    VALUES
        (
            v_new_id,
            p_name,
                CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, NULL) END,
                p_typeid,
                CASE WHEN p_parentcommitteeid_clear = true THEN NULL ELSE COALESCE(p_parentcommitteeid, NULL) END,
                CASE WHEN p_organizationid_clear = true THEN NULL ELSE COALESCE(p_organizationid, NULL) END,
                CASE WHEN p_charterdocumenturl_clear = true THEN NULL ELSE COALESCE(p_charterdocumenturl, NULL) END,
                CASE WHEN p_missionstatement_clear = true THEN NULL ELSE COALESCE(p_missionstatement, NULL) END,
                COALESCE(p_status, 'Active'),
                COALESCE(p_ispublic, TRUE),
                CASE WHEN p_formationdate_clear = true THEN NULL ELSE COALESCE(p_formationdate, NULL) END,
                CASE WHEN p_dissolutiondate_clear = true THEN NULL ELSE COALESCE(p_dissolutiondate, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwCommittees"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateCommittee" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateCommittee" TO "cdp_Integration";


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Committees
-- Item: spUpdateCommittee
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Committee
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateCommittee'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spUpdateCommittee"(
    p_id UUID,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_typeid UUID DEFAULT NULL,
    p_parentcommitteeid_clear boolean DEFAULT false,
    p_parentcommitteeid UUID DEFAULT NULL,
    p_organizationid_clear boolean DEFAULT false,
    p_organizationid UUID DEFAULT NULL,
    p_charterdocumenturl_clear boolean DEFAULT false,
    p_charterdocumenturl varchar(1000) DEFAULT NULL,
    p_missionstatement_clear boolean DEFAULT false,
    p_missionstatement TEXT DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL,
    p_ispublic BOOLEAN DEFAULT NULL,
    p_formationdate_clear boolean DEFAULT false,
    p_formationdate date DEFAULT NULL,
    p_dissolutiondate_clear boolean DEFAULT false,
    p_dissolutiondate date DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwCommittees" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE "__mj_bizappscommittees"."Committee"
    SET
        "Name" = COALESCE(p_name, "Name"),
        "Description" = CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, "Description") END,
        "TypeID" = COALESCE(p_typeid, "TypeID"),
        "ParentCommitteeID" = CASE WHEN p_parentcommitteeid_clear = true THEN NULL ELSE COALESCE(p_parentcommitteeid, "ParentCommitteeID") END,
        "OrganizationID" = CASE WHEN p_organizationid_clear = true THEN NULL ELSE COALESCE(p_organizationid, "OrganizationID") END,
        "CharterDocumentURL" = CASE WHEN p_charterdocumenturl_clear = true THEN NULL ELSE COALESCE(p_charterdocumenturl, "CharterDocumentURL") END,
        "MissionStatement" = CASE WHEN p_missionstatement_clear = true THEN NULL ELSE COALESCE(p_missionstatement, "MissionStatement") END,
        "Status" = COALESCE(p_status, "Status"),
        "IsPublic" = COALESCE(p_ispublic, "IsPublic"),
        "FormationDate" = CASE WHEN p_formationdate_clear = true THEN NULL ELSE COALESCE(p_formationdate, "FormationDate") END,
        "DissolutionDate" = CASE WHEN p_dissolutiondate_clear = true THEN NULL ELSE COALESCE(p_dissolutiondate, "DissolutionDate") END,
        "__mj_UpdatedAt" = (NOW() AT TIME ZONE 'UTC')
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwCommittees"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateCommittee" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateCommittee" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Committee table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_trg_update_committee"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_committee" ON "__mj_bizappscommittees"."Committee";

CREATE TRIGGER "trg_update_committee"
BEFORE UPDATE ON "__mj_bizappscommittees"."Committee"
FOR EACH ROW
EXECUTE FUNCTION "__mj_bizappscommittees"."fn_trg_update_committee"();



-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Committees
-- Item: spDeleteCommittee
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Committee
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteCommittee'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spDeleteCommittee"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM "__mj_bizappscommittees"."Committee"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteCommittee" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteCommittee" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Meetings
-- Item: Index for Foreign Keys
-- ============================================================
-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Meeting'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'CommitteeID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_meeting_committee_id"
            ON "__mj_bizappscommittees"."Meeting" ("CommitteeID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Meeting'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'VideoProviderID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_meeting_video_provider_id"
            ON "__mj_bizappscommittees"."Meeting" ("VideoProviderID");
    END IF;
END
$$;

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Meetings
-- Item: vwMeetings
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Meetings
-----               SCHEMA:      __mj_bizappscommittees
-----               BASE TABLE:  Meeting
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW "__mj_bizappscommittees"."vwMeetings"
AS
SELECT
    m.*,
    mjBizAppsCommitteesCommittee_CommitteeID."Name" AS "Committee",
    mjBizAppsCommitteesVideoProvider_VideoProviderID."Name" AS "VideoProvider_Virtual"
FROM
    "__mj_bizappscommittees"."Meeting" AS m
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Committee" AS mjBizAppsCommitteesCommittee_CommitteeID
  ON
    "m"."CommitteeID" = mjBizAppsCommitteesCommittee_CommitteeID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommittees"."VideoProvider" AS mjBizAppsCommitteesVideoProvider_VideoProviderID
  ON
    "m"."VideoProviderID" = mjBizAppsCommitteesVideoProvider_VideoProviderID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT,
    depth       INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Every view that DROP ... CASCADE removes: direct dependents AND theirs, transitively.
  -- Capturing only direct dependents restored vwTestRuns after a vwTestSuiteRuns regen but
  -- not vwConversations / vwConversationDetails, which select from vwTestRuns — they and their
  -- CRUD functions stayed permanently missing. depth is the LONGEST path from the target, so
  -- replaying in depth order always recreates a view after every view it reads.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_dep_oids (
    view_oid OID,
    depth    INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_dep_oids;
  INSERT INTO _vw_regen_dep_oids (view_oid, depth)
  WITH RECURSIVE deps(view_oid, depth) AS (
      SELECT DISTINCT dc.oid, 1
      FROM pg_depend d
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      JOIN pg_class tc ON tc.oid = d.refobjid
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tn.nspname = '__mj_bizappscommittees'
        AND tc.relname = 'vwMeetings'
        AND tc.relkind IN ('v', 'm')
        AND dc.oid <> tc.oid
    UNION
      SELECT dc.oid, deps.depth + 1
      FROM deps
      JOIN pg_depend d ON d.refobjid = deps.view_oid
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      WHERE dc.oid <> deps.view_oid
        AND deps.depth < 50
  )
  SELECT view_oid, MAX(depth) FROM deps GROUP BY view_oid;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql, depth)
  SELECT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER')),
      o.depth
  FROM _vw_regen_dep_oids o
  JOIN pg_class dc ON dc.oid = o.view_oid
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  -- The set is the target view plus every view captured above, because CASCADE drops the
  -- functions of each of them, not only the target's.
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_proc pp
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE pp.prokind IN ('f', 'p')
    AND EXISTS (
      SELECT 1
      FROM pg_class c
      WHERE (c.oid IN (SELECT view_oid FROM _vw_regen_dep_oids)
             OR c.oid = (SELECT tc.oid FROM pg_class tc
                         JOIN pg_namespace tn ON tn.oid = tc.relnamespace
                         WHERE tn.nspname = '__mj_bizappscommittees'
                           AND tc.relname = 'vwMeetings'
                           AND tc.relkind IN ('v', 'm')))
        AND (pp.prorettype = c.reltype
             OR EXISTS (SELECT 1 FROM pg_depend d
                        WHERE d.classid = 'pg_proc'::regclass
                          AND d.objid = pp.oid
                          AND d.refobjid = c.oid))
  );

  DROP VIEW IF EXISTS "__mj_bizappscommittees"."vwMeetings" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps ORDER BY depth, view_name LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_dep_oids;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON "__mj_bizappscommittees"."vwMeetings" TO "cdp_UI";
GRANT SELECT ON "__mj_bizappscommittees"."vwMeetings" TO "cdp_Developer";
GRANT SELECT ON "__mj_bizappscommittees"."vwMeetings" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Meetings
-- Item: spCreateMeeting
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Meeting
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateMeeting'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spCreateMeeting"(
    p_id UUID DEFAULT NULL,
    p_committeeid UUID DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_startdatetime TIMESTAMPTZ DEFAULT NULL,
    p_enddatetime_clear boolean DEFAULT false,
    p_enddatetime TIMESTAMPTZ DEFAULT NULL,
    p_timezone varchar(50) DEFAULT NULL,
    p_locationtype varchar(50) DEFAULT NULL,
    p_locationtext_clear boolean DEFAULT false,
    p_locationtext varchar(500) DEFAULT NULL,
    p_videoprovider_clear boolean DEFAULT false,
    p_videoprovider varchar(50) DEFAULT NULL,
    p_videoproviderid_clear boolean DEFAULT false,
    p_videoproviderid UUID DEFAULT NULL,
    p_videomeetingid_clear boolean DEFAULT false,
    p_videomeetingid varchar(255) DEFAULT NULL,
    p_videojoinurl_clear boolean DEFAULT false,
    p_videojoinurl varchar(1000) DEFAULT NULL,
    p_videorecordingurl_clear boolean DEFAULT false,
    p_videorecordingurl varchar(1000) DEFAULT NULL,
    p_transcripturl_clear boolean DEFAULT false,
    p_transcripturl varchar(1000) DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL,
    p_calendareventid_clear boolean DEFAULT false,
    p_calendareventid varchar(255) DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwMeetings" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO "__mj_bizappscommittees"."Meeting"
        (
            "ID",
            "CommitteeID",
                "Name",
                "Description",
                "StartDateTime",
                "EndDateTime",
                "TimeZone",
                "LocationType",
                "LocationText",
                "VideoProvider",
                "VideoProviderID",
                "VideoMeetingID",
                "VideoJoinURL",
                "VideoRecordingURL",
                "TranscriptURL",
                "Status",
                "CalendarEventID"
        )
    VALUES
        (
            v_new_id,
            p_committeeid,
                p_name,
                CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, NULL) END,
                p_startdatetime,
                CASE WHEN p_enddatetime_clear = true THEN NULL ELSE COALESCE(p_enddatetime, NULL) END,
                COALESCE(p_timezone, 'America/New_York'),
                COALESCE(p_locationtype, 'Virtual'),
                CASE WHEN p_locationtext_clear = true THEN NULL ELSE COALESCE(p_locationtext, NULL) END,
                CASE WHEN p_videoprovider_clear = true THEN NULL ELSE COALESCE(p_videoprovider, NULL) END,
                CASE WHEN p_videoproviderid_clear = true THEN NULL ELSE COALESCE(p_videoproviderid, NULL) END,
                CASE WHEN p_videomeetingid_clear = true THEN NULL ELSE COALESCE(p_videomeetingid, NULL) END,
                CASE WHEN p_videojoinurl_clear = true THEN NULL ELSE COALESCE(p_videojoinurl, NULL) END,
                CASE WHEN p_videorecordingurl_clear = true THEN NULL ELSE COALESCE(p_videorecordingurl, NULL) END,
                CASE WHEN p_transcripturl_clear = true THEN NULL ELSE COALESCE(p_transcripturl, NULL) END,
                COALESCE(p_status, 'Scheduled'),
                CASE WHEN p_calendareventid_clear = true THEN NULL ELSE COALESCE(p_calendareventid, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwMeetings"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateMeeting" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateMeeting" TO "cdp_Integration";


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Meetings
-- Item: spUpdateMeeting
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Meeting
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateMeeting'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spUpdateMeeting"(
    p_id UUID,
    p_committeeid UUID DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_startdatetime TIMESTAMPTZ DEFAULT NULL,
    p_enddatetime_clear boolean DEFAULT false,
    p_enddatetime TIMESTAMPTZ DEFAULT NULL,
    p_timezone varchar(50) DEFAULT NULL,
    p_locationtype varchar(50) DEFAULT NULL,
    p_locationtext_clear boolean DEFAULT false,
    p_locationtext varchar(500) DEFAULT NULL,
    p_videoprovider_clear boolean DEFAULT false,
    p_videoprovider varchar(50) DEFAULT NULL,
    p_videoproviderid_clear boolean DEFAULT false,
    p_videoproviderid UUID DEFAULT NULL,
    p_videomeetingid_clear boolean DEFAULT false,
    p_videomeetingid varchar(255) DEFAULT NULL,
    p_videojoinurl_clear boolean DEFAULT false,
    p_videojoinurl varchar(1000) DEFAULT NULL,
    p_videorecordingurl_clear boolean DEFAULT false,
    p_videorecordingurl varchar(1000) DEFAULT NULL,
    p_transcripturl_clear boolean DEFAULT false,
    p_transcripturl varchar(1000) DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL,
    p_calendareventid_clear boolean DEFAULT false,
    p_calendareventid varchar(255) DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwMeetings" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE "__mj_bizappscommittees"."Meeting"
    SET
        "CommitteeID" = COALESCE(p_committeeid, "CommitteeID"),
        "Name" = COALESCE(p_name, "Name"),
        "Description" = CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, "Description") END,
        "StartDateTime" = COALESCE(p_startdatetime, "StartDateTime"),
        "EndDateTime" = CASE WHEN p_enddatetime_clear = true THEN NULL ELSE COALESCE(p_enddatetime, "EndDateTime") END,
        "TimeZone" = COALESCE(p_timezone, "TimeZone"),
        "LocationType" = COALESCE(p_locationtype, "LocationType"),
        "LocationText" = CASE WHEN p_locationtext_clear = true THEN NULL ELSE COALESCE(p_locationtext, "LocationText") END,
        "VideoProvider" = CASE WHEN p_videoprovider_clear = true THEN NULL ELSE COALESCE(p_videoprovider, "VideoProvider") END,
        "VideoProviderID" = CASE WHEN p_videoproviderid_clear = true THEN NULL ELSE COALESCE(p_videoproviderid, "VideoProviderID") END,
        "VideoMeetingID" = CASE WHEN p_videomeetingid_clear = true THEN NULL ELSE COALESCE(p_videomeetingid, "VideoMeetingID") END,
        "VideoJoinURL" = CASE WHEN p_videojoinurl_clear = true THEN NULL ELSE COALESCE(p_videojoinurl, "VideoJoinURL") END,
        "VideoRecordingURL" = CASE WHEN p_videorecordingurl_clear = true THEN NULL ELSE COALESCE(p_videorecordingurl, "VideoRecordingURL") END,
        "TranscriptURL" = CASE WHEN p_transcripturl_clear = true THEN NULL ELSE COALESCE(p_transcripturl, "TranscriptURL") END,
        "Status" = COALESCE(p_status, "Status"),
        "CalendarEventID" = CASE WHEN p_calendareventid_clear = true THEN NULL ELSE COALESCE(p_calendareventid, "CalendarEventID") END,
        "__mj_UpdatedAt" = (NOW() AT TIME ZONE 'UTC')
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwMeetings"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateMeeting" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateMeeting" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Meeting table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_trg_update_meeting"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_meeting" ON "__mj_bizappscommittees"."Meeting";

CREATE TRIGGER "trg_update_meeting"
BEFORE UPDATE ON "__mj_bizappscommittees"."Meeting"
FOR EACH ROW
EXECUTE FUNCTION "__mj_bizappscommittees"."fn_trg_update_meeting"();



-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Meetings
-- Item: spDeleteMeeting
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Meeting
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteMeeting'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spDeleteMeeting"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM "__mj_bizappscommittees"."Meeting"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteMeeting" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteMeeting" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Memberships
-- Item: Index for Foreign Keys
-- ============================================================
-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Membership'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'PersonID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_membership_person_id"
            ON "__mj_bizappscommittees"."Membership" ("PersonID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Membership'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'RoleID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_membership_role_id"
            ON "__mj_bizappscommittees"."Membership" ("RoleID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Membership'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'TermID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_membership_term_id"
            ON "__mj_bizappscommittees"."Membership" ("TermID");
    END IF;
END
$$;

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Memberships
-- Item: vwMemberships
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Memberships
-----               SCHEMA:      __mj_bizappscommittees
-----               BASE TABLE:  Membership
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW "__mj_bizappscommittees"."vwMemberships"
AS
SELECT
    m.*,
    mjBizAppsCommonPerson_PersonID."DisplayName" AS "Person",
    mjBizAppsCommitteesRole_RoleID."Name" AS "Role",
    mjBizAppsCommitteesTerm_TermID."Name" AS "Term"
FROM
    "__mj_bizappscommittees"."Membership" AS m
LEFT OUTER JOIN
    "__mj_bizappscommon"."Person" AS mjBizAppsCommonPerson_PersonID
  ON
    "m"."PersonID" = mjBizAppsCommonPerson_PersonID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Role" AS mjBizAppsCommitteesRole_RoleID
  ON
    "m"."RoleID" = mjBizAppsCommitteesRole_RoleID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Term" AS mjBizAppsCommitteesTerm_TermID
  ON
    "m"."TermID" = mjBizAppsCommitteesTerm_TermID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT,
    depth       INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Every view that DROP ... CASCADE removes: direct dependents AND theirs, transitively.
  -- Capturing only direct dependents restored vwTestRuns after a vwTestSuiteRuns regen but
  -- not vwConversations / vwConversationDetails, which select from vwTestRuns — they and their
  -- CRUD functions stayed permanently missing. depth is the LONGEST path from the target, so
  -- replaying in depth order always recreates a view after every view it reads.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_dep_oids (
    view_oid OID,
    depth    INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_dep_oids;
  INSERT INTO _vw_regen_dep_oids (view_oid, depth)
  WITH RECURSIVE deps(view_oid, depth) AS (
      SELECT DISTINCT dc.oid, 1
      FROM pg_depend d
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      JOIN pg_class tc ON tc.oid = d.refobjid
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tn.nspname = '__mj_bizappscommittees'
        AND tc.relname = 'vwMemberships'
        AND tc.relkind IN ('v', 'm')
        AND dc.oid <> tc.oid
    UNION
      SELECT dc.oid, deps.depth + 1
      FROM deps
      JOIN pg_depend d ON d.refobjid = deps.view_oid
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      WHERE dc.oid <> deps.view_oid
        AND deps.depth < 50
  )
  SELECT view_oid, MAX(depth) FROM deps GROUP BY view_oid;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql, depth)
  SELECT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER')),
      o.depth
  FROM _vw_regen_dep_oids o
  JOIN pg_class dc ON dc.oid = o.view_oid
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  -- The set is the target view plus every view captured above, because CASCADE drops the
  -- functions of each of them, not only the target's.
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_proc pp
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE pp.prokind IN ('f', 'p')
    AND EXISTS (
      SELECT 1
      FROM pg_class c
      WHERE (c.oid IN (SELECT view_oid FROM _vw_regen_dep_oids)
             OR c.oid = (SELECT tc.oid FROM pg_class tc
                         JOIN pg_namespace tn ON tn.oid = tc.relnamespace
                         WHERE tn.nspname = '__mj_bizappscommittees'
                           AND tc.relname = 'vwMemberships'
                           AND tc.relkind IN ('v', 'm')))
        AND (pp.prorettype = c.reltype
             OR EXISTS (SELECT 1 FROM pg_depend d
                        WHERE d.classid = 'pg_proc'::regclass
                          AND d.objid = pp.oid
                          AND d.refobjid = c.oid))
  );

  DROP VIEW IF EXISTS "__mj_bizappscommittees"."vwMemberships" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps ORDER BY depth, view_name LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_dep_oids;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON "__mj_bizappscommittees"."vwMemberships" TO "cdp_UI";
GRANT SELECT ON "__mj_bizappscommittees"."vwMemberships" TO "cdp_Developer";
GRANT SELECT ON "__mj_bizappscommittees"."vwMemberships" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Memberships
-- Item: spCreateMembership
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Membership
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateMembership'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spCreateMembership"(
    p_id UUID DEFAULT NULL,
    p_personid UUID DEFAULT NULL,
    p_roleid UUID DEFAULT NULL,
    p_termid UUID DEFAULT NULL,
    p_startdate date DEFAULT NULL,
    p_enddate_clear boolean DEFAULT false,
    p_enddate date DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL,
    p_endreason_clear boolean DEFAULT false,
    p_endreason varchar(100) DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes TEXT DEFAULT NULL,
    p_renewalintent_clear boolean DEFAULT false,
    p_renewalintent varchar(20) DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwMemberships" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO "__mj_bizappscommittees"."Membership"
        (
            "ID",
            "PersonID",
                "RoleID",
                "TermID",
                "StartDate",
                "EndDate",
                "Status",
                "EndReason",
                "Notes",
                "RenewalIntent"
        )
    VALUES
        (
            v_new_id,
            p_personid,
                p_roleid,
                p_termid,
                p_startdate,
                CASE WHEN p_enddate_clear = true THEN NULL ELSE COALESCE(p_enddate, NULL) END,
                COALESCE(p_status, 'Active'),
                CASE WHEN p_endreason_clear = true THEN NULL ELSE COALESCE(p_endreason, NULL) END,
                CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, NULL) END,
                CASE WHEN p_renewalintent_clear = true THEN NULL ELSE COALESCE(p_renewalintent, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwMemberships"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateMembership" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateMembership" TO "cdp_Integration";


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Memberships
-- Item: spUpdateMembership
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Membership
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateMembership'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spUpdateMembership"(
    p_id UUID,
    p_personid UUID DEFAULT NULL,
    p_roleid UUID DEFAULT NULL,
    p_termid UUID DEFAULT NULL,
    p_startdate date DEFAULT NULL,
    p_enddate_clear boolean DEFAULT false,
    p_enddate date DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL,
    p_endreason_clear boolean DEFAULT false,
    p_endreason varchar(100) DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes TEXT DEFAULT NULL,
    p_renewalintent_clear boolean DEFAULT false,
    p_renewalintent varchar(20) DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwMemberships" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE "__mj_bizappscommittees"."Membership"
    SET
        "PersonID" = COALESCE(p_personid, "PersonID"),
        "RoleID" = COALESCE(p_roleid, "RoleID"),
        "TermID" = COALESCE(p_termid, "TermID"),
        "StartDate" = COALESCE(p_startdate, "StartDate"),
        "EndDate" = CASE WHEN p_enddate_clear = true THEN NULL ELSE COALESCE(p_enddate, "EndDate") END,
        "Status" = COALESCE(p_status, "Status"),
        "EndReason" = CASE WHEN p_endreason_clear = true THEN NULL ELSE COALESCE(p_endreason, "EndReason") END,
        "Notes" = CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, "Notes") END,
        "RenewalIntent" = CASE WHEN p_renewalintent_clear = true THEN NULL ELSE COALESCE(p_renewalintent, "RenewalIntent") END,
        "__mj_UpdatedAt" = (NOW() AT TIME ZONE 'UTC')
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwMemberships"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateMembership" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateMembership" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Membership table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_trg_update_membership"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_membership" ON "__mj_bizappscommittees"."Membership";

CREATE TRIGGER "trg_update_membership"
BEFORE UPDATE ON "__mj_bizappscommittees"."Membership"
FOR EACH ROW
EXECUTE FUNCTION "__mj_bizappscommittees"."fn_trg_update_membership"();



-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Memberships
-- Item: spDeleteMembership
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Membership
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteMembership'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spDeleteMembership"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM "__mj_bizappscommittees"."Membership"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteMembership" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteMembership" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Minutes
-- Item: Index for Foreign Keys
-- ============================================================
-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Minute'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'ArtifactID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_minute_artifact_id"
            ON "__mj_bizappscommittees"."Minute" ("ArtifactID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Minute'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'MeetingID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_minute_meeting_id"
            ON "__mj_bizappscommittees"."Minute" ("MeetingID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Minute'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'ApprovedByMeetingID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_minute_approved_by_meeting_id"
            ON "__mj_bizappscommittees"."Minute" ("ApprovedByMeetingID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Minute'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'MJArtifactID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_minute_mj_artifact_id"
            ON "__mj_bizappscommittees"."Minute" ("MJArtifactID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Minute'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'ApprovedArtifactVersionID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_minute_approved_artifact_version_id"
            ON "__mj_bizappscommittees"."Minute" ("ApprovedArtifactVersionID");
    END IF;
END
$$;

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Minutes
-- Item: vwMinutes
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Minutes
-----               SCHEMA:      __mj_bizappscommittees
-----               BASE TABLE:  Minute
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW "__mj_bizappscommittees"."vwMinutes"
AS
SELECT
    m.*,
    mjBizAppsCommitteesArtifact_ArtifactID."Name" AS "Artifact",
    mjBizAppsCommitteesMeeting_MeetingID."Name" AS "Meeting",
    mjBizAppsCommitteesMeeting_ApprovedByMeetingID."Name" AS "ApprovedByMeeting",
    MJArtifact_MJArtifactID."Name" AS "MJArtifact",
    MJArtifactVersion_ApprovedArtifactVersionID."Name" AS "ApprovedArtifactVersion"
FROM
    "__mj_bizappscommittees"."Minute" AS m
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Artifact" AS mjBizAppsCommitteesArtifact_ArtifactID
  ON
    "m"."ArtifactID" = mjBizAppsCommitteesArtifact_ArtifactID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Meeting" AS mjBizAppsCommitteesMeeting_MeetingID
  ON
    "m"."MeetingID" = mjBizAppsCommitteesMeeting_MeetingID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Meeting" AS mjBizAppsCommitteesMeeting_ApprovedByMeetingID
  ON
    "m"."ApprovedByMeetingID" = mjBizAppsCommitteesMeeting_ApprovedByMeetingID."ID"
LEFT OUTER JOIN
    "__mj"."Artifact" AS MJArtifact_MJArtifactID
  ON
    "m"."MJArtifactID" = MJArtifact_MJArtifactID."ID"
LEFT OUTER JOIN
    "__mj"."ArtifactVersion" AS MJArtifactVersion_ApprovedArtifactVersionID
  ON
    "m"."ApprovedArtifactVersionID" = MJArtifactVersion_ApprovedArtifactVersionID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT,
    depth       INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Every view that DROP ... CASCADE removes: direct dependents AND theirs, transitively.
  -- Capturing only direct dependents restored vwTestRuns after a vwTestSuiteRuns regen but
  -- not vwConversations / vwConversationDetails, which select from vwTestRuns — they and their
  -- CRUD functions stayed permanently missing. depth is the LONGEST path from the target, so
  -- replaying in depth order always recreates a view after every view it reads.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_dep_oids (
    view_oid OID,
    depth    INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_dep_oids;
  INSERT INTO _vw_regen_dep_oids (view_oid, depth)
  WITH RECURSIVE deps(view_oid, depth) AS (
      SELECT DISTINCT dc.oid, 1
      FROM pg_depend d
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      JOIN pg_class tc ON tc.oid = d.refobjid
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tn.nspname = '__mj_bizappscommittees'
        AND tc.relname = 'vwMinutes'
        AND tc.relkind IN ('v', 'm')
        AND dc.oid <> tc.oid
    UNION
      SELECT dc.oid, deps.depth + 1
      FROM deps
      JOIN pg_depend d ON d.refobjid = deps.view_oid
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      WHERE dc.oid <> deps.view_oid
        AND deps.depth < 50
  )
  SELECT view_oid, MAX(depth) FROM deps GROUP BY view_oid;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql, depth)
  SELECT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER')),
      o.depth
  FROM _vw_regen_dep_oids o
  JOIN pg_class dc ON dc.oid = o.view_oid
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  -- The set is the target view plus every view captured above, because CASCADE drops the
  -- functions of each of them, not only the target's.
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_proc pp
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE pp.prokind IN ('f', 'p')
    AND EXISTS (
      SELECT 1
      FROM pg_class c
      WHERE (c.oid IN (SELECT view_oid FROM _vw_regen_dep_oids)
             OR c.oid = (SELECT tc.oid FROM pg_class tc
                         JOIN pg_namespace tn ON tn.oid = tc.relnamespace
                         WHERE tn.nspname = '__mj_bizappscommittees'
                           AND tc.relname = 'vwMinutes'
                           AND tc.relkind IN ('v', 'm')))
        AND (pp.prorettype = c.reltype
             OR EXISTS (SELECT 1 FROM pg_depend d
                        WHERE d.classid = 'pg_proc'::regclass
                          AND d.objid = pp.oid
                          AND d.refobjid = c.oid))
  );

  DROP VIEW IF EXISTS "__mj_bizappscommittees"."vwMinutes" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps ORDER BY depth, view_name LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_dep_oids;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON "__mj_bizappscommittees"."vwMinutes" TO "cdp_UI";
GRANT SELECT ON "__mj_bizappscommittees"."vwMinutes" TO "cdp_Developer";
GRANT SELECT ON "__mj_bizappscommittees"."vwMinutes" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Minutes
-- Item: spCreateMinute
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Minute
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateMinute'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spCreateMinute"(
    p_id UUID DEFAULT NULL,
    p_artifactid_clear boolean DEFAULT false,
    p_artifactid UUID DEFAULT NULL,
    p_meetingid_clear boolean DEFAULT false,
    p_meetingid UUID DEFAULT NULL,
    p_content_clear boolean DEFAULT false,
    p_content TEXT DEFAULT NULL,
    p_approvalstatus varchar(50) DEFAULT NULL,
    p_approvedat_clear boolean DEFAULT false,
    p_approvedat TIMESTAMPTZ DEFAULT NULL,
    p_approvedbymeetingid_clear boolean DEFAULT false,
    p_approvedbymeetingid UUID DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes TEXT DEFAULT NULL,
    p_mjartifactid_clear boolean DEFAULT false,
    p_mjartifactid UUID DEFAULT NULL,
    p_approvedartifactversionid_clear boolean DEFAULT false,
    p_approvedartifactversionid UUID DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwMinutes" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO "__mj_bizappscommittees"."Minute"
        (
            "ID",
            "ArtifactID",
                "MeetingID",
                "Content",
                "ApprovalStatus",
                "ApprovedAt",
                "ApprovedByMeetingID",
                "Notes",
                "MJArtifactID",
                "ApprovedArtifactVersionID"
        )
    VALUES
        (
            v_new_id,
            CASE WHEN p_artifactid_clear = true THEN NULL ELSE COALESCE(p_artifactid, NULL) END,
                CASE WHEN p_meetingid_clear = true THEN NULL ELSE COALESCE(p_meetingid, NULL) END,
                CASE WHEN p_content_clear = true THEN NULL ELSE COALESCE(p_content, NULL) END,
                COALESCE(p_approvalstatus, 'Draft'),
                CASE WHEN p_approvedat_clear = true THEN NULL ELSE COALESCE(p_approvedat, NULL) END,
                CASE WHEN p_approvedbymeetingid_clear = true THEN NULL ELSE COALESCE(p_approvedbymeetingid, NULL) END,
                CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, NULL) END,
                CASE WHEN p_mjartifactid_clear = true THEN NULL ELSE COALESCE(p_mjartifactid, NULL) END,
                CASE WHEN p_approvedartifactversionid_clear = true THEN NULL ELSE COALESCE(p_approvedartifactversionid, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwMinutes"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateMinute" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateMinute" TO "cdp_Integration";


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Minutes
-- Item: spUpdateMinute
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Minute
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateMinute'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spUpdateMinute"(
    p_id UUID,
    p_artifactid_clear boolean DEFAULT false,
    p_artifactid UUID DEFAULT NULL,
    p_meetingid_clear boolean DEFAULT false,
    p_meetingid UUID DEFAULT NULL,
    p_content_clear boolean DEFAULT false,
    p_content TEXT DEFAULT NULL,
    p_approvalstatus varchar(50) DEFAULT NULL,
    p_approvedat_clear boolean DEFAULT false,
    p_approvedat TIMESTAMPTZ DEFAULT NULL,
    p_approvedbymeetingid_clear boolean DEFAULT false,
    p_approvedbymeetingid UUID DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes TEXT DEFAULT NULL,
    p_mjartifactid_clear boolean DEFAULT false,
    p_mjartifactid UUID DEFAULT NULL,
    p_approvedartifactversionid_clear boolean DEFAULT false,
    p_approvedartifactversionid UUID DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwMinutes" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE "__mj_bizappscommittees"."Minute"
    SET
        "ArtifactID" = CASE WHEN p_artifactid_clear = true THEN NULL ELSE COALESCE(p_artifactid, "ArtifactID") END,
        "MeetingID" = CASE WHEN p_meetingid_clear = true THEN NULL ELSE COALESCE(p_meetingid, "MeetingID") END,
        "Content" = CASE WHEN p_content_clear = true THEN NULL ELSE COALESCE(p_content, "Content") END,
        "ApprovalStatus" = COALESCE(p_approvalstatus, "ApprovalStatus"),
        "ApprovedAt" = CASE WHEN p_approvedat_clear = true THEN NULL ELSE COALESCE(p_approvedat, "ApprovedAt") END,
        "ApprovedByMeetingID" = CASE WHEN p_approvedbymeetingid_clear = true THEN NULL ELSE COALESCE(p_approvedbymeetingid, "ApprovedByMeetingID") END,
        "Notes" = CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, "Notes") END,
        "MJArtifactID" = CASE WHEN p_mjartifactid_clear = true THEN NULL ELSE COALESCE(p_mjartifactid, "MJArtifactID") END,
        "ApprovedArtifactVersionID" = CASE WHEN p_approvedartifactversionid_clear = true THEN NULL ELSE COALESCE(p_approvedartifactversionid, "ApprovedArtifactVersionID") END,
        "__mj_UpdatedAt" = (NOW() AT TIME ZONE 'UTC')
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwMinutes"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateMinute" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateMinute" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Minute table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_trg_update_minute"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_minute" ON "__mj_bizappscommittees"."Minute";

CREATE TRIGGER "trg_update_minute"
BEFORE UPDATE ON "__mj_bizappscommittees"."Minute"
FOR EACH ROW
EXECUTE FUNCTION "__mj_bizappscommittees"."fn_trg_update_minute"();



-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Minutes
-- Item: spDeleteMinute
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Minute
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteMinute'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spDeleteMinute"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM "__mj_bizappscommittees"."Minute"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteMinute" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteMinute" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Motions
-- Item: Index for Foreign Keys
-- ============================================================
-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Motion'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'MeetingID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_motion_meeting_id"
            ON "__mj_bizappscommittees"."Motion" ("MeetingID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Motion'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'AgendaItemID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_motion_agenda_item_id"
            ON "__mj_bizappscommittees"."Motion" ("AgendaItemID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Motion'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'MovedByMembershipID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_motion_moved_by_membership_id"
            ON "__mj_bizappscommittees"."Motion" ("MovedByMembershipID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Motion'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'SecondedByMembershipID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_motion_seconded_by_membership_id"
            ON "__mj_bizappscommittees"."Motion" ("SecondedByMembershipID");
    END IF;
END
$$;

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Motions
-- Item: vwMotions
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Motions
-----               SCHEMA:      __mj_bizappscommittees
-----               BASE TABLE:  Motion
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW "__mj_bizappscommittees"."vwMotions"
AS
SELECT
    m.*,
    mjBizAppsCommitteesMeeting_MeetingID."Name" AS "Meeting",
    mjBizAppsCommitteesAgendaItem_AgendaItemID."Name" AS "AgendaItem"
FROM
    "__mj_bizappscommittees"."Motion" AS m
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Meeting" AS mjBizAppsCommitteesMeeting_MeetingID
  ON
    "m"."MeetingID" = mjBizAppsCommitteesMeeting_MeetingID."ID"
LEFT OUTER JOIN
    "__mj_bizappscommittees"."AgendaItem" AS mjBizAppsCommitteesAgendaItem_AgendaItemID
  ON
    "m"."AgendaItemID" = mjBizAppsCommitteesAgendaItem_AgendaItemID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT,
    depth       INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Every view that DROP ... CASCADE removes: direct dependents AND theirs, transitively.
  -- Capturing only direct dependents restored vwTestRuns after a vwTestSuiteRuns regen but
  -- not vwConversations / vwConversationDetails, which select from vwTestRuns — they and their
  -- CRUD functions stayed permanently missing. depth is the LONGEST path from the target, so
  -- replaying in depth order always recreates a view after every view it reads.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_dep_oids (
    view_oid OID,
    depth    INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_dep_oids;
  INSERT INTO _vw_regen_dep_oids (view_oid, depth)
  WITH RECURSIVE deps(view_oid, depth) AS (
      SELECT DISTINCT dc.oid, 1
      FROM pg_depend d
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      JOIN pg_class tc ON tc.oid = d.refobjid
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tn.nspname = '__mj_bizappscommittees'
        AND tc.relname = 'vwMotions'
        AND tc.relkind IN ('v', 'm')
        AND dc.oid <> tc.oid
    UNION
      SELECT dc.oid, deps.depth + 1
      FROM deps
      JOIN pg_depend d ON d.refobjid = deps.view_oid
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      WHERE dc.oid <> deps.view_oid
        AND deps.depth < 50
  )
  SELECT view_oid, MAX(depth) FROM deps GROUP BY view_oid;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql, depth)
  SELECT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER')),
      o.depth
  FROM _vw_regen_dep_oids o
  JOIN pg_class dc ON dc.oid = o.view_oid
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  -- The set is the target view plus every view captured above, because CASCADE drops the
  -- functions of each of them, not only the target's.
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_proc pp
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE pp.prokind IN ('f', 'p')
    AND EXISTS (
      SELECT 1
      FROM pg_class c
      WHERE (c.oid IN (SELECT view_oid FROM _vw_regen_dep_oids)
             OR c.oid = (SELECT tc.oid FROM pg_class tc
                         JOIN pg_namespace tn ON tn.oid = tc.relnamespace
                         WHERE tn.nspname = '__mj_bizappscommittees'
                           AND tc.relname = 'vwMotions'
                           AND tc.relkind IN ('v', 'm')))
        AND (pp.prorettype = c.reltype
             OR EXISTS (SELECT 1 FROM pg_depend d
                        WHERE d.classid = 'pg_proc'::regclass
                          AND d.objid = pp.oid
                          AND d.refobjid = c.oid))
  );

  DROP VIEW IF EXISTS "__mj_bizappscommittees"."vwMotions" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps ORDER BY depth, view_name LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_dep_oids;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON "__mj_bizappscommittees"."vwMotions" TO "cdp_UI";
GRANT SELECT ON "__mj_bizappscommittees"."vwMotions" TO "cdp_Developer";
GRANT SELECT ON "__mj_bizappscommittees"."vwMotions" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Motions
-- Item: spCreateMotion
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Motion
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateMotion'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spCreateMotion"(
    p_id UUID DEFAULT NULL,
    p_meetingid_clear boolean DEFAULT false,
    p_meetingid UUID DEFAULT NULL,
    p_agendaitemid_clear boolean DEFAULT false,
    p_agendaitemid UUID DEFAULT NULL,
    p_sequence int DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_movedbymembershipid_clear boolean DEFAULT false,
    p_movedbymembershipid UUID DEFAULT NULL,
    p_secondedbymembershipid_clear boolean DEFAULT false,
    p_secondedbymembershipid UUID DEFAULT NULL,
    p_result varchar(50) DEFAULT NULL,
    p_resultsummary_clear boolean DEFAULT false,
    p_resultsummary varchar(255) DEFAULT NULL,
    p_yescount_clear boolean DEFAULT false,
    p_yescount int DEFAULT NULL,
    p_nocount_clear boolean DEFAULT false,
    p_nocount int DEFAULT NULL,
    p_abstaincount_clear boolean DEFAULT false,
    p_abstaincount int DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes TEXT DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwMotions" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO "__mj_bizappscommittees"."Motion"
        (
            "ID",
            "MeetingID",
                "AgendaItemID",
                "Sequence",
                "Name",
                "Description",
                "MovedByMembershipID",
                "SecondedByMembershipID",
                "Result",
                "ResultSummary",
                "YesCount",
                "NoCount",
                "AbstainCount",
                "Notes"
        )
    VALUES
        (
            v_new_id,
            CASE WHEN p_meetingid_clear = true THEN NULL ELSE COALESCE(p_meetingid, NULL) END,
                CASE WHEN p_agendaitemid_clear = true THEN NULL ELSE COALESCE(p_agendaitemid, NULL) END,
                COALESCE(p_sequence, 1),
                p_name,
                CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, NULL) END,
                CASE WHEN p_movedbymembershipid_clear = true THEN NULL ELSE COALESCE(p_movedbymembershipid, NULL) END,
                CASE WHEN p_secondedbymembershipid_clear = true THEN NULL ELSE COALESCE(p_secondedbymembershipid, NULL) END,
                COALESCE(p_result, 'Pending'),
                CASE WHEN p_resultsummary_clear = true THEN NULL ELSE COALESCE(p_resultsummary, NULL) END,
                CASE WHEN p_yescount_clear = true THEN NULL ELSE COALESCE(p_yescount, NULL) END,
                CASE WHEN p_nocount_clear = true THEN NULL ELSE COALESCE(p_nocount, NULL) END,
                CASE WHEN p_abstaincount_clear = true THEN NULL ELSE COALESCE(p_abstaincount, NULL) END,
                CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwMotions"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateMotion" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateMotion" TO "cdp_Integration";


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Motions
-- Item: spUpdateMotion
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Motion
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateMotion'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spUpdateMotion"(
    p_id UUID,
    p_meetingid_clear boolean DEFAULT false,
    p_meetingid UUID DEFAULT NULL,
    p_agendaitemid_clear boolean DEFAULT false,
    p_agendaitemid UUID DEFAULT NULL,
    p_sequence int DEFAULT NULL,
    p_name varchar(255) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_movedbymembershipid_clear boolean DEFAULT false,
    p_movedbymembershipid UUID DEFAULT NULL,
    p_secondedbymembershipid_clear boolean DEFAULT false,
    p_secondedbymembershipid UUID DEFAULT NULL,
    p_result varchar(50) DEFAULT NULL,
    p_resultsummary_clear boolean DEFAULT false,
    p_resultsummary varchar(255) DEFAULT NULL,
    p_yescount_clear boolean DEFAULT false,
    p_yescount int DEFAULT NULL,
    p_nocount_clear boolean DEFAULT false,
    p_nocount int DEFAULT NULL,
    p_abstaincount_clear boolean DEFAULT false,
    p_abstaincount int DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes TEXT DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwMotions" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE "__mj_bizappscommittees"."Motion"
    SET
        "MeetingID" = CASE WHEN p_meetingid_clear = true THEN NULL ELSE COALESCE(p_meetingid, "MeetingID") END,
        "AgendaItemID" = CASE WHEN p_agendaitemid_clear = true THEN NULL ELSE COALESCE(p_agendaitemid, "AgendaItemID") END,
        "Sequence" = COALESCE(p_sequence, "Sequence"),
        "Name" = COALESCE(p_name, "Name"),
        "Description" = CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, "Description") END,
        "MovedByMembershipID" = CASE WHEN p_movedbymembershipid_clear = true THEN NULL ELSE COALESCE(p_movedbymembershipid, "MovedByMembershipID") END,
        "SecondedByMembershipID" = CASE WHEN p_secondedbymembershipid_clear = true THEN NULL ELSE COALESCE(p_secondedbymembershipid, "SecondedByMembershipID") END,
        "Result" = COALESCE(p_result, "Result"),
        "ResultSummary" = CASE WHEN p_resultsummary_clear = true THEN NULL ELSE COALESCE(p_resultsummary, "ResultSummary") END,
        "YesCount" = CASE WHEN p_yescount_clear = true THEN NULL ELSE COALESCE(p_yescount, "YesCount") END,
        "NoCount" = CASE WHEN p_nocount_clear = true THEN NULL ELSE COALESCE(p_nocount, "NoCount") END,
        "AbstainCount" = CASE WHEN p_abstaincount_clear = true THEN NULL ELSE COALESCE(p_abstaincount, "AbstainCount") END,
        "Notes" = CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, "Notes") END,
        "__mj_UpdatedAt" = (NOW() AT TIME ZONE 'UTC')
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwMotions"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateMotion" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateMotion" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Motion table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_trg_update_motion"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_motion" ON "__mj_bizappscommittees"."Motion";

CREATE TRIGGER "trg_update_motion"
BEFORE UPDATE ON "__mj_bizappscommittees"."Motion"
FOR EACH ROW
EXECUTE FUNCTION "__mj_bizappscommittees"."fn_trg_update_motion"();



-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Motions
-- Item: spDeleteMotion
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Motion
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteMotion'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spDeleteMotion"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM "__mj_bizappscommittees"."Motion"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteMotion" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteMotion" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Roles
-- Item: Index for Foreign Keys
-- ============================================================


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Roles
-- Item: vwRoles
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Roles
-----               SCHEMA:      __mj_bizappscommittees
-----               BASE TABLE:  Role
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW "__mj_bizappscommittees"."vwRoles"
AS
SELECT
    r.*
FROM
    "__mj_bizappscommittees"."Role" AS r
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT,
    depth       INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Every view that DROP ... CASCADE removes: direct dependents AND theirs, transitively.
  -- Capturing only direct dependents restored vwTestRuns after a vwTestSuiteRuns regen but
  -- not vwConversations / vwConversationDetails, which select from vwTestRuns — they and their
  -- CRUD functions stayed permanently missing. depth is the LONGEST path from the target, so
  -- replaying in depth order always recreates a view after every view it reads.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_dep_oids (
    view_oid OID,
    depth    INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_dep_oids;
  INSERT INTO _vw_regen_dep_oids (view_oid, depth)
  WITH RECURSIVE deps(view_oid, depth) AS (
      SELECT DISTINCT dc.oid, 1
      FROM pg_depend d
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      JOIN pg_class tc ON tc.oid = d.refobjid
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tn.nspname = '__mj_bizappscommittees'
        AND tc.relname = 'vwRoles'
        AND tc.relkind IN ('v', 'm')
        AND dc.oid <> tc.oid
    UNION
      SELECT dc.oid, deps.depth + 1
      FROM deps
      JOIN pg_depend d ON d.refobjid = deps.view_oid
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      WHERE dc.oid <> deps.view_oid
        AND deps.depth < 50
  )
  SELECT view_oid, MAX(depth) FROM deps GROUP BY view_oid;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql, depth)
  SELECT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER')),
      o.depth
  FROM _vw_regen_dep_oids o
  JOIN pg_class dc ON dc.oid = o.view_oid
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  -- The set is the target view plus every view captured above, because CASCADE drops the
  -- functions of each of them, not only the target's.
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_proc pp
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE pp.prokind IN ('f', 'p')
    AND EXISTS (
      SELECT 1
      FROM pg_class c
      WHERE (c.oid IN (SELECT view_oid FROM _vw_regen_dep_oids)
             OR c.oid = (SELECT tc.oid FROM pg_class tc
                         JOIN pg_namespace tn ON tn.oid = tc.relnamespace
                         WHERE tn.nspname = '__mj_bizappscommittees'
                           AND tc.relname = 'vwRoles'
                           AND tc.relkind IN ('v', 'm')))
        AND (pp.prorettype = c.reltype
             OR EXISTS (SELECT 1 FROM pg_depend d
                        WHERE d.classid = 'pg_proc'::regclass
                          AND d.objid = pp.oid
                          AND d.refobjid = c.oid))
  );

  DROP VIEW IF EXISTS "__mj_bizappscommittees"."vwRoles" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps ORDER BY depth, view_name LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_dep_oids;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON "__mj_bizappscommittees"."vwRoles" TO "cdp_UI";
GRANT SELECT ON "__mj_bizappscommittees"."vwRoles" TO "cdp_Developer";
GRANT SELECT ON "__mj_bizappscommittees"."vwRoles" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Roles
-- Item: spCreateRole
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Role
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateRole'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spCreateRole"(
    p_id UUID DEFAULT NULL,
    p_name varchar(100) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_isofficer BOOLEAN DEFAULT NULL,
    p_isvotingrole BOOLEAN DEFAULT NULL,
    p_defaultpermissionsjson_clear boolean DEFAULT false,
    p_defaultpermissionsjson TEXT DEFAULT NULL,
    p_sequence int DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwRoles" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO "__mj_bizappscommittees"."Role"
        (
            "ID",
            "Name",
                "Description",
                "IsOfficer",
                "IsVotingRole",
                "DefaultPermissionsJSON",
                "Sequence"
        )
    VALUES
        (
            v_new_id,
            p_name,
                CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, NULL) END,
                COALESCE(p_isofficer, FALSE),
                COALESCE(p_isvotingrole, TRUE),
                CASE WHEN p_defaultpermissionsjson_clear = true THEN NULL ELSE COALESCE(p_defaultpermissionsjson, NULL) END,
                COALESCE(p_sequence, 100)
        )
    ;

    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwRoles"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateRole" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateRole" TO "cdp_Integration";


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Roles
-- Item: spUpdateRole
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Role
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateRole'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spUpdateRole"(
    p_id UUID,
    p_name varchar(100) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_isofficer BOOLEAN DEFAULT NULL,
    p_isvotingrole BOOLEAN DEFAULT NULL,
    p_defaultpermissionsjson_clear boolean DEFAULT false,
    p_defaultpermissionsjson TEXT DEFAULT NULL,
    p_sequence int DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwRoles" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE "__mj_bizappscommittees"."Role"
    SET
        "Name" = COALESCE(p_name, "Name"),
        "Description" = CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, "Description") END,
        "IsOfficer" = COALESCE(p_isofficer, "IsOfficer"),
        "IsVotingRole" = COALESCE(p_isvotingrole, "IsVotingRole"),
        "DefaultPermissionsJSON" = CASE WHEN p_defaultpermissionsjson_clear = true THEN NULL ELSE COALESCE(p_defaultpermissionsjson, "DefaultPermissionsJSON") END,
        "Sequence" = COALESCE(p_sequence, "Sequence"),
        "__mj_UpdatedAt" = (NOW() AT TIME ZONE 'UTC')
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwRoles"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateRole" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateRole" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Role table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_trg_update_role"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_role" ON "__mj_bizappscommittees"."Role";

CREATE TRIGGER "trg_update_role"
BEFORE UPDATE ON "__mj_bizappscommittees"."Role"
FOR EACH ROW
EXECUTE FUNCTION "__mj_bizappscommittees"."fn_trg_update_role"();



-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Roles
-- Item: spDeleteRole
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Role
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteRole'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spDeleteRole"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM "__mj_bizappscommittees"."Role"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteRole" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteRole" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Terms
-- Item: Index for Foreign Keys
-- ============================================================
-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Term'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'CommitteeID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_term_committee_id"
            ON "__mj_bizappscommittees"."Term" ("CommitteeID");
    END IF;
END
$$;

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Terms
-- Item: vwTerms
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Terms
-----               SCHEMA:      __mj_bizappscommittees
-----               BASE TABLE:  Term
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW "__mj_bizappscommittees"."vwTerms"
AS
SELECT
    t.*,
    mjBizAppsCommitteesCommittee_CommitteeID."Name" AS "Committee"
FROM
    "__mj_bizappscommittees"."Term" AS t
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Committee" AS mjBizAppsCommitteesCommittee_CommitteeID
  ON
    "t"."CommitteeID" = mjBizAppsCommitteesCommittee_CommitteeID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT,
    depth       INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Every view that DROP ... CASCADE removes: direct dependents AND theirs, transitively.
  -- Capturing only direct dependents restored vwTestRuns after a vwTestSuiteRuns regen but
  -- not vwConversations / vwConversationDetails, which select from vwTestRuns — they and their
  -- CRUD functions stayed permanently missing. depth is the LONGEST path from the target, so
  -- replaying in depth order always recreates a view after every view it reads.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_dep_oids (
    view_oid OID,
    depth    INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_dep_oids;
  INSERT INTO _vw_regen_dep_oids (view_oid, depth)
  WITH RECURSIVE deps(view_oid, depth) AS (
      SELECT DISTINCT dc.oid, 1
      FROM pg_depend d
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      JOIN pg_class tc ON tc.oid = d.refobjid
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tn.nspname = '__mj_bizappscommittees'
        AND tc.relname = 'vwTerms'
        AND tc.relkind IN ('v', 'm')
        AND dc.oid <> tc.oid
    UNION
      SELECT dc.oid, deps.depth + 1
      FROM deps
      JOIN pg_depend d ON d.refobjid = deps.view_oid
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      WHERE dc.oid <> deps.view_oid
        AND deps.depth < 50
  )
  SELECT view_oid, MAX(depth) FROM deps GROUP BY view_oid;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql, depth)
  SELECT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER')),
      o.depth
  FROM _vw_regen_dep_oids o
  JOIN pg_class dc ON dc.oid = o.view_oid
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  -- The set is the target view plus every view captured above, because CASCADE drops the
  -- functions of each of them, not only the target's.
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_proc pp
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE pp.prokind IN ('f', 'p')
    AND EXISTS (
      SELECT 1
      FROM pg_class c
      WHERE (c.oid IN (SELECT view_oid FROM _vw_regen_dep_oids)
             OR c.oid = (SELECT tc.oid FROM pg_class tc
                         JOIN pg_namespace tn ON tn.oid = tc.relnamespace
                         WHERE tn.nspname = '__mj_bizappscommittees'
                           AND tc.relname = 'vwTerms'
                           AND tc.relkind IN ('v', 'm')))
        AND (pp.prorettype = c.reltype
             OR EXISTS (SELECT 1 FROM pg_depend d
                        WHERE d.classid = 'pg_proc'::regclass
                          AND d.objid = pp.oid
                          AND d.refobjid = c.oid))
  );

  DROP VIEW IF EXISTS "__mj_bizappscommittees"."vwTerms" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps ORDER BY depth, view_name LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_dep_oids;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON "__mj_bizappscommittees"."vwTerms" TO "cdp_UI";
GRANT SELECT ON "__mj_bizappscommittees"."vwTerms" TO "cdp_Developer";
GRANT SELECT ON "__mj_bizappscommittees"."vwTerms" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Terms
-- Item: spCreateTerm
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Term
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateTerm'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spCreateTerm"(
    p_id UUID DEFAULT NULL,
    p_committeeid UUID DEFAULT NULL,
    p_name varchar(100) DEFAULT NULL,
    p_startdate date DEFAULT NULL,
    p_enddate_clear boolean DEFAULT false,
    p_enddate date DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwTerms" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO "__mj_bizappscommittees"."Term"
        (
            "ID",
            "CommitteeID",
                "Name",
                "StartDate",
                "EndDate",
                "Status"
        )
    VALUES
        (
            v_new_id,
            p_committeeid,
                p_name,
                p_startdate,
                CASE WHEN p_enddate_clear = true THEN NULL ELSE COALESCE(p_enddate, NULL) END,
                COALESCE(p_status, 'Active')
        )
    ;

    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwTerms"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateTerm" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateTerm" TO "cdp_Integration";


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Terms
-- Item: spUpdateTerm
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Term
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateTerm'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spUpdateTerm"(
    p_id UUID,
    p_committeeid UUID DEFAULT NULL,
    p_name varchar(100) DEFAULT NULL,
    p_startdate date DEFAULT NULL,
    p_enddate_clear boolean DEFAULT false,
    p_enddate date DEFAULT NULL,
    p_status varchar(50) DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwTerms" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE "__mj_bizappscommittees"."Term"
    SET
        "CommitteeID" = COALESCE(p_committeeid, "CommitteeID"),
        "Name" = COALESCE(p_name, "Name"),
        "StartDate" = COALESCE(p_startdate, "StartDate"),
        "EndDate" = CASE WHEN p_enddate_clear = true THEN NULL ELSE COALESCE(p_enddate, "EndDate") END,
        "Status" = COALESCE(p_status, "Status"),
        "__mj_UpdatedAt" = (NOW() AT TIME ZONE 'UTC')
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwTerms"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateTerm" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateTerm" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Term table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_trg_update_term"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_term" ON "__mj_bizappscommittees"."Term";

CREATE TRIGGER "trg_update_term"
BEFORE UPDATE ON "__mj_bizappscommittees"."Term"
FOR EACH ROW
EXECUTE FUNCTION "__mj_bizappscommittees"."fn_trg_update_term"();



-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Terms
-- Item: spDeleteTerm
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Term
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteTerm'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spDeleteTerm"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM "__mj_bizappscommittees"."Term"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteTerm" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteTerm" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Types
-- Item: Index for Foreign Keys
-- ============================================================


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Types
-- Item: vwTypes
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Types
-----               SCHEMA:      __mj_bizappscommittees
-----               BASE TABLE:  Type
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW "__mj_bizappscommittees"."vwTypes"
AS
SELECT
    t.*
FROM
    "__mj_bizappscommittees"."Type" AS t
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT,
    depth       INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Every view that DROP ... CASCADE removes: direct dependents AND theirs, transitively.
  -- Capturing only direct dependents restored vwTestRuns after a vwTestSuiteRuns regen but
  -- not vwConversations / vwConversationDetails, which select from vwTestRuns — they and their
  -- CRUD functions stayed permanently missing. depth is the LONGEST path from the target, so
  -- replaying in depth order always recreates a view after every view it reads.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_dep_oids (
    view_oid OID,
    depth    INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_dep_oids;
  INSERT INTO _vw_regen_dep_oids (view_oid, depth)
  WITH RECURSIVE deps(view_oid, depth) AS (
      SELECT DISTINCT dc.oid, 1
      FROM pg_depend d
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      JOIN pg_class tc ON tc.oid = d.refobjid
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tn.nspname = '__mj_bizappscommittees'
        AND tc.relname = 'vwTypes'
        AND tc.relkind IN ('v', 'm')
        AND dc.oid <> tc.oid
    UNION
      SELECT dc.oid, deps.depth + 1
      FROM deps
      JOIN pg_depend d ON d.refobjid = deps.view_oid
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      WHERE dc.oid <> deps.view_oid
        AND deps.depth < 50
  )
  SELECT view_oid, MAX(depth) FROM deps GROUP BY view_oid;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql, depth)
  SELECT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER')),
      o.depth
  FROM _vw_regen_dep_oids o
  JOIN pg_class dc ON dc.oid = o.view_oid
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  -- The set is the target view plus every view captured above, because CASCADE drops the
  -- functions of each of them, not only the target's.
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_proc pp
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE pp.prokind IN ('f', 'p')
    AND EXISTS (
      SELECT 1
      FROM pg_class c
      WHERE (c.oid IN (SELECT view_oid FROM _vw_regen_dep_oids)
             OR c.oid = (SELECT tc.oid FROM pg_class tc
                         JOIN pg_namespace tn ON tn.oid = tc.relnamespace
                         WHERE tn.nspname = '__mj_bizappscommittees'
                           AND tc.relname = 'vwTypes'
                           AND tc.relkind IN ('v', 'm')))
        AND (pp.prorettype = c.reltype
             OR EXISTS (SELECT 1 FROM pg_depend d
                        WHERE d.classid = 'pg_proc'::regclass
                          AND d.objid = pp.oid
                          AND d.refobjid = c.oid))
  );

  DROP VIEW IF EXISTS "__mj_bizappscommittees"."vwTypes" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps ORDER BY depth, view_name LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_dep_oids;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON "__mj_bizappscommittees"."vwTypes" TO "cdp_UI";
GRANT SELECT ON "__mj_bizappscommittees"."vwTypes" TO "cdp_Developer";
GRANT SELECT ON "__mj_bizappscommittees"."vwTypes" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Types
-- Item: spCreateType
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Type
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateType'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spCreateType"(
    p_id UUID DEFAULT NULL,
    p_name varchar(100) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_isstandards BOOLEAN DEFAULT NULL,
    p_defaulttermmonths_clear boolean DEFAULT false,
    p_defaulttermmonths int DEFAULT NULL,
    p_iconclass_clear boolean DEFAULT false,
    p_iconclass varchar(100) DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwTypes" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO "__mj_bizappscommittees"."Type"
        (
            "ID",
            "Name",
                "Description",
                "IsStandards",
                "DefaultTermMonths",
                "IconClass"
        )
    VALUES
        (
            v_new_id,
            p_name,
                CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, NULL) END,
                COALESCE(p_isstandards, FALSE),
                CASE WHEN p_defaulttermmonths_clear = true THEN NULL ELSE COALESCE(p_defaulttermmonths, NULL) END,
                CASE WHEN p_iconclass_clear = true THEN NULL ELSE COALESCE(p_iconclass, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwTypes"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateType" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateType" TO "cdp_Integration";


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Types
-- Item: spUpdateType
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Type
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateType'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spUpdateType"(
    p_id UUID,
    p_name varchar(100) DEFAULT NULL,
    p_description_clear boolean DEFAULT false,
    p_description TEXT DEFAULT NULL,
    p_isstandards BOOLEAN DEFAULT NULL,
    p_defaulttermmonths_clear boolean DEFAULT false,
    p_defaulttermmonths int DEFAULT NULL,
    p_iconclass_clear boolean DEFAULT false,
    p_iconclass varchar(100) DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwTypes" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE "__mj_bizappscommittees"."Type"
    SET
        "Name" = COALESCE(p_name, "Name"),
        "Description" = CASE WHEN p_description_clear = true THEN NULL ELSE COALESCE(p_description, "Description") END,
        "IsStandards" = COALESCE(p_isstandards, "IsStandards"),
        "DefaultTermMonths" = CASE WHEN p_defaulttermmonths_clear = true THEN NULL ELSE COALESCE(p_defaulttermmonths, "DefaultTermMonths") END,
        "IconClass" = CASE WHEN p_iconclass_clear = true THEN NULL ELSE COALESCE(p_iconclass, "IconClass") END,
        "__mj_UpdatedAt" = (NOW() AT TIME ZONE 'UTC')
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwTypes"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateType" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateType" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Type table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_trg_update_type"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_type" ON "__mj_bizappscommittees"."Type";

CREATE TRIGGER "trg_update_type"
BEFORE UPDATE ON "__mj_bizappscommittees"."Type"
FOR EACH ROW
EXECUTE FUNCTION "__mj_bizappscommittees"."fn_trg_update_type"();



-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Types
-- Item: spDeleteType
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Type
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteType'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spDeleteType"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM "__mj_bizappscommittees"."Type"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteType" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteType" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Video Providers
-- Item: Index for Foreign Keys
-- ============================================================
-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'VideoProvider'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'CredentialID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_video_provider_credential_id"
            ON "__mj_bizappscommittees"."VideoProvider" ("CredentialID");
    END IF;
END
$$;

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Video Providers
-- Item: vwVideoProviders
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Video Providers
-----               SCHEMA:      __mj_bizappscommittees
-----               BASE TABLE:  VideoProvider
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW "__mj_bizappscommittees"."vwVideoProviders"
AS
SELECT
    v.*,
    MJCredential_CredentialID."Name" AS "Credential"
FROM
    "__mj_bizappscommittees"."VideoProvider" AS v
LEFT OUTER JOIN
    "__mj"."Credential" AS MJCredential_CredentialID
  ON
    "v"."CredentialID" = MJCredential_CredentialID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT,
    depth       INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Every view that DROP ... CASCADE removes: direct dependents AND theirs, transitively.
  -- Capturing only direct dependents restored vwTestRuns after a vwTestSuiteRuns regen but
  -- not vwConversations / vwConversationDetails, which select from vwTestRuns — they and their
  -- CRUD functions stayed permanently missing. depth is the LONGEST path from the target, so
  -- replaying in depth order always recreates a view after every view it reads.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_dep_oids (
    view_oid OID,
    depth    INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_dep_oids;
  INSERT INTO _vw_regen_dep_oids (view_oid, depth)
  WITH RECURSIVE deps(view_oid, depth) AS (
      SELECT DISTINCT dc.oid, 1
      FROM pg_depend d
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      JOIN pg_class tc ON tc.oid = d.refobjid
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tn.nspname = '__mj_bizappscommittees'
        AND tc.relname = 'vwVideoProviders'
        AND tc.relkind IN ('v', 'm')
        AND dc.oid <> tc.oid
    UNION
      SELECT dc.oid, deps.depth + 1
      FROM deps
      JOIN pg_depend d ON d.refobjid = deps.view_oid
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      WHERE dc.oid <> deps.view_oid
        AND deps.depth < 50
  )
  SELECT view_oid, MAX(depth) FROM deps GROUP BY view_oid;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql, depth)
  SELECT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER')),
      o.depth
  FROM _vw_regen_dep_oids o
  JOIN pg_class dc ON dc.oid = o.view_oid
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  -- The set is the target view plus every view captured above, because CASCADE drops the
  -- functions of each of them, not only the target's.
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_proc pp
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE pp.prokind IN ('f', 'p')
    AND EXISTS (
      SELECT 1
      FROM pg_class c
      WHERE (c.oid IN (SELECT view_oid FROM _vw_regen_dep_oids)
             OR c.oid = (SELECT tc.oid FROM pg_class tc
                         JOIN pg_namespace tn ON tn.oid = tc.relnamespace
                         WHERE tn.nspname = '__mj_bizappscommittees'
                           AND tc.relname = 'vwVideoProviders'
                           AND tc.relkind IN ('v', 'm')))
        AND (pp.prorettype = c.reltype
             OR EXISTS (SELECT 1 FROM pg_depend d
                        WHERE d.classid = 'pg_proc'::regclass
                          AND d.objid = pp.oid
                          AND d.refobjid = c.oid))
  );

  DROP VIEW IF EXISTS "__mj_bizappscommittees"."vwVideoProviders" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps ORDER BY depth, view_name LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_dep_oids;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON "__mj_bizappscommittees"."vwVideoProviders" TO "cdp_UI";
GRANT SELECT ON "__mj_bizappscommittees"."vwVideoProviders" TO "cdp_Developer";
GRANT SELECT ON "__mj_bizappscommittees"."vwVideoProviders" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Video Providers
-- Item: spCreateVideoProvider
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR VideoProvider
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateVideoProvider'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spCreateVideoProvider"(
    p_id UUID DEFAULT NULL,
    p_name varchar(100) DEFAULT NULL,
    p_serverdriverkey varchar(100) DEFAULT NULL,
    p_isactive BOOLEAN DEFAULT NULL,
    p_isdefault BOOLEAN DEFAULT NULL,
    p_credentialid_clear boolean DEFAULT false,
    p_credentialid UUID DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwVideoProviders" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO "__mj_bizappscommittees"."VideoProvider"
        (
            "ID",
            "Name",
                "ServerDriverKey",
                "IsActive",
                "IsDefault",
                "CredentialID"
        )
    VALUES
        (
            v_new_id,
            p_name,
                p_serverdriverkey,
                COALESCE(p_isactive, TRUE),
                COALESCE(p_isdefault, FALSE),
                CASE WHEN p_credentialid_clear = true THEN NULL ELSE COALESCE(p_credentialid, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwVideoProviders"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateVideoProvider" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateVideoProvider" TO "cdp_Integration";


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Video Providers
-- Item: spUpdateVideoProvider
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR VideoProvider
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateVideoProvider'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spUpdateVideoProvider"(
    p_id UUID,
    p_name varchar(100) DEFAULT NULL,
    p_serverdriverkey varchar(100) DEFAULT NULL,
    p_isactive BOOLEAN DEFAULT NULL,
    p_isdefault BOOLEAN DEFAULT NULL,
    p_credentialid_clear boolean DEFAULT false,
    p_credentialid UUID DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwVideoProviders" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE "__mj_bizappscommittees"."VideoProvider"
    SET
        "Name" = COALESCE(p_name, "Name"),
        "ServerDriverKey" = COALESCE(p_serverdriverkey, "ServerDriverKey"),
        "IsActive" = COALESCE(p_isactive, "IsActive"),
        "IsDefault" = COALESCE(p_isdefault, "IsDefault"),
        "CredentialID" = CASE WHEN p_credentialid_clear = true THEN NULL ELSE COALESCE(p_credentialid, "CredentialID") END,
        "__mj_UpdatedAt" = (NOW() AT TIME ZONE 'UTC')
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwVideoProviders"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateVideoProvider" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateVideoProvider" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the VideoProvider table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_trg_update_video_provider"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_video_provider" ON "__mj_bizappscommittees"."VideoProvider";

CREATE TRIGGER "trg_update_video_provider"
BEFORE UPDATE ON "__mj_bizappscommittees"."VideoProvider"
FOR EACH ROW
EXECUTE FUNCTION "__mj_bizappscommittees"."fn_trg_update_video_provider"();



-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Video Providers
-- Item: spDeleteVideoProvider
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR VideoProvider
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteVideoProvider'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spDeleteVideoProvider"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM "__mj_bizappscommittees"."VideoProvider"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteVideoProvider" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteVideoProvider" TO "cdp_Integration";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Votes
-- Item: Index for Foreign Keys
-- ============================================================
-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Vote'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'MotionID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_vote_motion_id"
            ON "__mj_bizappscommittees"."Vote" ("MotionID");
    END IF;
END
$$;

-- Skipped when another non-partial index already leads with the column.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_index ix
        INNER JOIN pg_class t ON t.oid = ix.indrelid
        INNER JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = '__mj_bizappscommittees'
          AND t.relname = 'Vote'
          AND ix.indpred IS NULL
          AND ix.indnkeyatts >= 1
              AND ix.indkey[0] = (SELECT a.attnum FROM pg_attribute a WHERE a.attrelid = t.oid AND a.attname = 'MembershipID')
    ) THEN
        CREATE INDEX IF NOT EXISTS "idx_auto_mj_fkey_vote_membership_id"
            ON "__mj_bizappscommittees"."Vote" ("MembershipID");
    END IF;
END
$$;

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Votes
-- Item: vwVotes
-- ============================================================

------------------------------------------------------------
----- BASE VIEW FOR ENTITY:      Committees: Votes
-----               SCHEMA:      __mj_bizappscommittees
-----               BASE TABLE:  Vote
-----               PRIMARY KEY: ID
------------------------------------------------------------
DO $vw_regen$
DECLARE
  vsql CONSTANT TEXT := $vsql$CREATE OR REPLACE VIEW "__mj_bizappscommittees"."vwVotes"
AS
SELECT
    v.*,
    mjBizAppsCommitteesMotion_MotionID."Name" AS "Motion"
FROM
    "__mj_bizappscommittees"."Vote" AS v
LEFT OUTER JOIN
    "__mj_bizappscommittees"."Motion" AS mjBizAppsCommitteesMotion_MotionID
  ON
    "v"."MotionID" = mjBizAppsCommitteesMotion_MotionID."ID"
$vsql$;
  rec RECORD;
BEGIN
  EXECUTE vsql;
EXCEPTION WHEN invalid_table_definition THEN
  -- 42P16: column rename/reorder/type change. CREATE OR REPLACE can't handle
  -- non-additive shape changes — must DROP CASCADE + recreate. CASCADE drops
  -- every dependent view (anything that JOINs this view in its body), so we
  -- capture each dependent's definition + grants BEFORE the drop and replay
  -- them afterward (best-effort). Without this, on a fresh-DB replay where
  -- one entity's wrapper triggers (e.g. vwAIModelTypes shape changed since
  -- baseline V202605021056), CASCADE wipes downstream views (vwAIModels)
  -- that the wrapper for this entity doesn't know how to recreate, and
  -- those views stay permanently missing.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_deps (
    schema_name TEXT,
    view_name   TEXT,
    relkind     CHAR(1),
    definition  TEXT,
    grants_sql  TEXT,
    depth       INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_deps;

  -- Every view that DROP ... CASCADE removes: direct dependents AND theirs, transitively.
  -- Capturing only direct dependents restored vwTestRuns after a vwTestSuiteRuns regen but
  -- not vwConversations / vwConversationDetails, which select from vwTestRuns — they and their
  -- CRUD functions stayed permanently missing. depth is the LONGEST path from the target, so
  -- replaying in depth order always recreates a view after every view it reads.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_dep_oids (
    view_oid OID,
    depth    INT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_dep_oids;
  INSERT INTO _vw_regen_dep_oids (view_oid, depth)
  WITH RECURSIVE deps(view_oid, depth) AS (
      SELECT DISTINCT dc.oid, 1
      FROM pg_depend d
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      JOIN pg_class tc ON tc.oid = d.refobjid
      JOIN pg_namespace tn ON tn.oid = tc.relnamespace
      WHERE tn.nspname = '__mj_bizappscommittees'
        AND tc.relname = 'vwVotes'
        AND tc.relkind IN ('v', 'm')
        AND dc.oid <> tc.oid
    UNION
      SELECT dc.oid, deps.depth + 1
      FROM deps
      JOIN pg_depend d ON d.refobjid = deps.view_oid
      JOIN pg_rewrite r ON r.oid = d.objid AND d.classid = 'pg_rewrite'::regclass
      JOIN pg_class dc ON dc.oid = r.ev_class AND dc.relkind IN ('v', 'm')
      WHERE dc.oid <> deps.view_oid
        AND deps.depth < 50
  )
  SELECT view_oid, MAX(depth) FROM deps GROUP BY view_oid;

  -- Capture dependent FUNCTIONS too. CASCADE drops every function with
  -- RETURNS SETOF <view> (the codegen-emitted spCreate/spUpdate/spDelete
  -- pattern) when the target view is dropped. Without restoring them,
  -- post-codegen CRUD validation reports those routines as missing —
  -- e.g. "MJ: Recommendation Items → missing create routine
  -- spCreateRecommendationItem" — even though the next codegen pass
  -- emits them. The restored definitions are pg_get_functiondef() output
  -- which is a complete CREATE OR REPLACE FUNCTION statement plus a
  -- trailing semicolon; replaying them verbatim recreates the function
  -- with its original body, parameter list, and return type.
  CREATE TEMP TABLE IF NOT EXISTS _vw_regen_fn_deps (
    schema_name TEXT,
    fn_name     TEXT,
    fn_oid      OID,
    definition  TEXT
  ) ON COMMIT DROP;
  DELETE FROM _vw_regen_fn_deps;

  -- Capture dependents. NOTES on the grants_sql build:
  --   - Resolve role name via pg_get_userbyid(oid) — returns the bare,
  --     unquoted role name (or 'unknown (OID=N)' if the oid no longer
  --     exists). pg_get_userbyid is a public catalog function available to
  --     every database user, including unprivileged accounts on managed
  --     PostgreSQL services (Amazon RDS, Azure Database for PostgreSQL,
  --     Cloud SQL) where pg_authid is restricted to the rds_superuser /
  --     azure_pg_admin / cloudsqlsuperuser group. Earlier revisions joined
  --     to pg_authid which works on self-hosted PG but fails with
  --     "permission denied for table pg_authid" on managed services.
  --   - The earlier (broken) approach cast (aclexplode).grantee::regrole::text
  --     which RETURNS the role name pre-quoted when it contains uppercase
  --     (e.g. cdp_Developer comes back already wrapped); calling quote_ident
  --     on the already-quoted string double-wrapped and the GRANT failed at
  --     replay with "role does not exist". Using
  --     pg_get_userbyid returns a bare name and lets quote_ident wrap it
  --     correctly exactly once.
  --   - PUBLIC is grantee oid 0; pg_get_userbyid(0) returns 'unknown
  --     (OID=0)' so handle the PUBLIC case explicitly and use it as the
  --     literal 'PUBLIC' rather than quote_ident on the synthetic name.
  INSERT INTO _vw_regen_deps (schema_name, view_name, relkind, definition, grants_sql, depth)
  SELECT
      dn.nspname,
      dc.relname,
      dc.relkind,
      pg_get_viewdef(dc.oid),
      (SELECT string_agg(
          'GRANT ' || g.privilege || ' ON ' || quote_ident(dn.nspname) || '.' || quote_ident(dc.relname) ||
          ' TO ' || (CASE WHEN g.grantee_oid = 0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(g.grantee_oid)) END) || ';',
          E'
')
       FROM (
           SELECT (aclexplode(dc.relacl)).grantee AS grantee_oid,
                  (aclexplode(dc.relacl)).privilege_type AS privilege
       ) g
       WHERE g.privilege IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER')),
      o.depth
  FROM _vw_regen_dep_oids o
  JOIN pg_class dc ON dc.oid = o.view_oid
  JOIN pg_namespace dn ON dn.oid = dc.relnamespace;

  -- Capture dependent functions. Two paths matter on PG:
  --   1. Functions whose RETURN type references the view (RETURNS SETOF
  --      <view>) — pg_depend records this as type=pg_type → pg_class.
  --   2. Functions whose body references the view (used by sql functions
  --      and by some plpgsql edge cases) — pg_depend records this as
  --      pg_proc → pg_class.
  -- pg_get_functiondef returns a complete CREATE OR REPLACE FUNCTION
  -- statement that we replay verbatim. We DO include RETURNS-only
  -- references because that's the dominant codegen pattern (sp* CRUD
  -- functions all RETURNS SETOF the matching vwX).
  -- The set is the target view plus every view captured above, because CASCADE drops the
  -- functions of each of them, not only the target's.
  INSERT INTO _vw_regen_fn_deps (schema_name, fn_name, fn_oid, definition)
  SELECT DISTINCT
      pn.nspname,
      pp.proname,
      pp.oid,
      pg_get_functiondef(pp.oid)
  FROM pg_proc pp
  JOIN pg_namespace pn ON pn.oid = pp.pronamespace
  WHERE pp.prokind IN ('f', 'p')
    AND EXISTS (
      SELECT 1
      FROM pg_class c
      WHERE (c.oid IN (SELECT view_oid FROM _vw_regen_dep_oids)
             OR c.oid = (SELECT tc.oid FROM pg_class tc
                         JOIN pg_namespace tn ON tn.oid = tc.relnamespace
                         WHERE tn.nspname = '__mj_bizappscommittees'
                           AND tc.relname = 'vwVotes'
                           AND tc.relkind IN ('v', 'm')))
        AND (pp.prorettype = c.reltype
             OR EXISTS (SELECT 1 FROM pg_depend d
                        WHERE d.classid = 'pg_proc'::regclass
                          AND d.objid = pp.oid
                          AND d.refobjid = c.oid))
  );

  DROP VIEW IF EXISTS "__mj_bizappscommittees"."vwVotes" CASCADE;
  EXECUTE vsql;

  -- Replay captured dependents. Best-effort: log + continue on failure.
  -- IMPORTANT: the CREATE VIEW and the GRANTs run in SEPARATE inner BEGIN
  -- blocks. PL/pgSQL's BEGIN ... EXCEPTION creates an implicit savepoint
  -- and rolls back EVERY statement in the block on any exception. If we
  -- combined CREATE+GRANT in one block and a GRANT failed (e.g. role not
  -- present in target environment), the just-recreated VIEW would also
  -- get rolled back and stay missing — the exact failure mode this
  -- wrapper exists to prevent.
  FOR rec IN SELECT schema_name, view_name, relkind, definition, grants_sql FROM _vw_regen_deps ORDER BY depth, view_name LOOP
    BEGIN
      IF rec.relkind = 'm' THEN
        EXECUTE 'CREATE MATERIALIZED VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      ELSE
        EXECUTE 'CREATE VIEW ' || quote_ident(rec.schema_name) || '.' || quote_ident(rec.view_name) || ' AS ' || rec.definition;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent %.%: %', rec.schema_name, rec.view_name, SQLERRM;
    END;

    IF rec.grants_sql IS NOT NULL THEN
      BEGIN
        EXECUTE rec.grants_sql;
      EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Best-effort grant restore skipped %.%: %', rec.schema_name, rec.view_name, SQLERRM;
      END;
    END IF;
  END LOOP;

  -- Replay captured dependent functions AFTER all dependent views are
  -- restored — most codegen-emitted sp* functions reference both the
  -- target view AND the dependent views in their bodies/return types.
  -- Wrapped per-function in its own savepoint so a single failure
  -- doesn't poison subsequent restores or the just-recreated target.
  FOR rec IN SELECT schema_name, fn_name, definition FROM _vw_regen_fn_deps LOOP
    BEGIN
      EXECUTE rec.definition;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Best-effort restore skipped dependent function %.%: %', rec.schema_name, rec.fn_name, SQLERRM;
    END;
  END LOOP;

  DROP TABLE _vw_regen_deps;
  DROP TABLE _vw_regen_dep_oids;
  DROP TABLE _vw_regen_fn_deps;
END $vw_regen$;
GRANT SELECT ON "__mj_bizappscommittees"."vwVotes" TO "cdp_Developer";
GRANT SELECT ON "__mj_bizappscommittees"."vwVotes" TO "cdp_Integration";
GRANT SELECT ON "__mj_bizappscommittees"."vwVotes" TO "cdp_UI";

-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Votes
-- Item: spCreateVote
-- ============================================================

------------------------------------------------------------
----- CREATE FUNCTION FOR Vote
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spCreateVote'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spCreateVote"(
    p_id UUID DEFAULT NULL,
    p_motionid UUID DEFAULT NULL,
    p_membershipid UUID DEFAULT NULL,
    p_votevalue varchar(20) DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes varchar(500) DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwVotes" AS $$
DECLARE
    v_new_id UUID;
BEGIN
    v_new_id := COALESCE(p_id, gen_random_uuid());
    INSERT INTO "__mj_bizappscommittees"."Vote"
        (
            "ID",
            "MotionID",
                "MembershipID",
                "VoteValue",
                "Notes"
        )
    VALUES
        (
            v_new_id,
            p_motionid,
                p_membershipid,
                p_votevalue,
                CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, NULL) END
        )
    ;

    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwVotes"
    WHERE "ID" = v_new_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateVote" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spCreateVote" TO "cdp_Integration";


-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Votes
-- Item: spUpdateVote
-- ============================================================

------------------------------------------------------------
----- UPDATE FUNCTION FOR Vote
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spUpdateVote'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spUpdateVote"(
    p_id UUID,
    p_motionid UUID DEFAULT NULL,
    p_membershipid UUID DEFAULT NULL,
    p_votevalue varchar(20) DEFAULT NULL,
    p_notes_clear boolean DEFAULT false,
    p_notes varchar(500) DEFAULT NULL
) RETURNS SETOF "__mj_bizappscommittees"."vwVotes" AS $$
DECLARE
    v_updated_count INTEGER;
BEGIN
    UPDATE "__mj_bizappscommittees"."Vote"
    SET
        "MotionID" = COALESCE(p_motionid, "MotionID"),
        "MembershipID" = COALESCE(p_membershipid, "MembershipID"),
        "VoteValue" = COALESCE(p_votevalue, "VoteValue"),
        "Notes" = CASE WHEN p_notes_clear = true THEN NULL ELSE COALESCE(p_notes, "Notes") END,
        "__mj_UpdatedAt" = (NOW() AT TIME ZONE 'UTC')
    WHERE
        "ID" = p_id;

    GET DIAGNOSTICS v_updated_count = ROW_COUNT;

    IF v_updated_count = 0 THEN
        -- Nothing was updated, return empty result set
        RETURN;
    END IF;

    -- Return the updated record from the base view
    RETURN QUERY
    SELECT * FROM "__mj_bizappscommittees"."vwVotes"
    WHERE "ID" = p_id;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateVote" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spUpdateVote" TO "cdp_Integration";


------------------------------------------------------------
----- TRIGGER FOR __mj_UpdatedAt field for the Vote table
------------------------------------------------------------
CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."fn_trg_update_vote"()
RETURNS TRIGGER AS $$
BEGIN
    NEW."__mj_UpdatedAt" := NOW() AT TIME ZONE 'UTC';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "trg_update_vote" ON "__mj_bizappscommittees"."Vote";

CREATE TRIGGER "trg_update_vote"
BEFORE UPDATE ON "__mj_bizappscommittees"."Vote"
FOR EACH ROW
EXECUTE FUNCTION "__mj_bizappscommittees"."fn_trg_update_vote"();



-- ============================================================
-- PostgreSQL Generated SQL for Entity: Committees: Votes
-- Item: spDeleteVote
-- ============================================================

------------------------------------------------------------
----- DELETE FUNCTION FOR Vote
------------------------------------------------------------
DO $do$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure AS sig
             FROM pg_proc
             WHERE proname = 'spDeleteVote'
               AND pronamespace = '__mj_bizappscommittees'::regnamespace
    LOOP
        EXECUTE 'DROP FUNCTION ' || r.sig::text;
    END LOOP;
END
$do$;

CREATE OR REPLACE FUNCTION "__mj_bizappscommittees"."spDeleteVote"(
    p_id UUID
) RETURNS TABLE("ID" UUID) AS $$
#variable_conflict use_column
DECLARE
    v_affected_count INTEGER;
BEGIN

    DELETE FROM "__mj_bizappscommittees"."Vote"
    WHERE "ID" = p_id;

    GET DIAGNOSTICS v_affected_count = ROW_COUNT;

    IF v_affected_count = 0 THEN
        RETURN QUERY SELECT NULL::UUID AS "ID";
    ELSE
        RETURN QUERY SELECT p_id AS "ID";
    END IF;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteVote" TO "cdp_Developer";
GRANT EXECUTE ON FUNCTION "__mj_bizappscommittees"."spDeleteVote" TO "cdp_Integration";
