/**
 * pg-parity-and-boundary — adversarial validation boundaries, Category C relational invariants,
 * SQL Server <-> PostgreSQL live schema/FK/index parity, and persona RLS checks.
 *
 * Verifies:
 *   PB1 — Rejects orphan ApprovedArtifactVersionID when MJArtifactID is null (MinuteEntityCustom.Validate).
 *   PB2 — Rejects cross-artifact ApprovedArtifactVersionID mismatch (MinuteEntityCustom.ValidateAsync).
 *   PB3 — Rejects non-existent ApprovedArtifactVersionID and malformed UUIDs.
 *   PB4 — Category C relational notes on Motion, Vote, and Attendance remain strictly relational (no MJArtifactID).
 *   PB5 — Live DBMS catalog inspection (SQL Server AND PostgreSQL) confirms nullable columns, preserved legacy columns,
 *         vwMinutes/vwArtifacts projections, NO ACTION FKs, and supporting indexes.
 *   PB6 — Non-owner UI personas read Minute and Artifact MJArtifactID projections cleanly while ballot RLS stays intact.
 */
import {
    Assert,
    IntegrationCheckRegistry,
    type IntegrationCheckContext,
    type NamedCheck,
} from '@memberjunction/testing-integration/registry';
import {
    MinuteEntityCustom,
    type mjBizAppsCommitteesAttendanceEntity,
    type mjBizAppsCommitteesMinuteEntity,
    type mjBizAppsCommitteesMotionEntity,
    type mjBizAppsCommitteesVoteEntity,
} from '@mj-biz-apps/committees-entities';
import {
    DeleteRow,
    E_ARTIFACT,
    E_ATTENDANCE,
    E_MEMBERSHIP,
    E_MINUTE,
    E_MOTION,
    E_VOTE,
    FindRows,
    FindRowsAs,
    PersonaUser,
    ProviderOf,
    RequireSave,
    WORLD_MARK,
} from '../fixture.js';
import { LoadWorld, WorldUserEmail } from '../world/load-world.js';
import { World } from '../world/world.js';

interface SqlCapableProvider {
    PlatformKey?: string;
    ExecuteSQL?: <T extends object>(query: string) => Promise<T[]>;
}

interface ColumnCatalogRow {
    TableName: string;
    ColumnName: string;
    IsNullable: string;
}

interface ForeignKeyCatalogRow {
    ConstraintName: string;
    TableName: string;
    DeleteRule: string;
}

interface IndexCatalogRow {
    TableName: string;
    ColumnName: string;
}

function getSqlProvider(ctx: IntegrationCheckContext): SqlCapableProvider {
    const candidate = ProviderOf(ctx) as SqlCapableProvider;
    Assert(
        typeof candidate.ExecuteSQL === 'function',
        'Integration provider must expose ExecuteSQL for live DBMS catalog parity verification',
    );
    return candidate;
}

function assertSavedFailedWithMessage(
    saved: boolean,
    entity: mjBizAppsCommitteesMinuteEntity,
    expectedSubstring: string,
    label: string,
): void {
    Assert(!saved, `${label}: Save() must fail closed, not persist invalid state`);
    const combined = `${entity.LatestResult?.Message ?? ''} ${entity.LatestResult?.CompleteMessage ?? ''}`;
    Assert(
        combined.toLowerCase().includes(expectedSubstring.toLowerCase()),
        `${label}: expected error containing '${expectedSubstring}', got '${combined}'`,
    );
}

async function queryLiveSchemaCatalog(
    provider: SqlCapableProvider,
): Promise<{
    platform: 'sqlserver' | 'postgresql';
    columns: ColumnCatalogRow[];
    fks: ForeignKeyCatalogRow[];
    indexes: IndexCatalogRow[];
}> {
    const platform = (provider.PlatformKey ?? 'sqlserver').toLowerCase() === 'postgresql'
        ? 'postgresql'
        : 'sqlserver';

    if (platform === 'postgresql') {
        const columns = await provider.ExecuteSQL!<ColumnCatalogRow>(`
            SELECT table_name AS "TableName", column_name AS "ColumnName", is_nullable AS "IsNullable"
            FROM information_schema.columns
            WHERE table_schema = '__mj_bizappscommittees'
              AND table_name IN ('Minute', 'Artifact', 'Motion', 'Vote', 'Attendance', 'vwMinutes', 'vwArtifacts')
        `);
        const fks = await provider.ExecuteSQL!<ForeignKeyCatalogRow>(`
            SELECT tc.constraint_name AS "ConstraintName",
                   tc.table_name AS "TableName",
                   rc.delete_rule AS "DeleteRule"
            FROM information_schema.table_constraints tc
            INNER JOIN information_schema.referential_constraints rc
              ON rc.constraint_schema = tc.constraint_schema
             AND rc.constraint_name = tc.constraint_name
            WHERE tc.table_schema = '__mj_bizappscommittees'
              AND tc.constraint_type = 'FOREIGN KEY'
              AND tc.table_name IN ('Minute', 'Artifact')
        `);
        const indexes = await provider.ExecuteSQL!<IndexCatalogRow>(`
            SELECT t.relname AS "TableName", a.attname AS "ColumnName"
            FROM pg_namespace n
            INNER JOIN pg_class t ON t.relnamespace = n.oid
            INNER JOIN pg_index ix ON ix.indrelid = t.oid
            INNER JOIN pg_attribute a ON a.attrelid = t.oid AND a.attnum = ANY(ix.indkey)
            WHERE n.nspname = '__mj_bizappscommittees'
              AND t.relname IN ('Minute', 'Artifact')
        `);
        return { platform, columns, fks, indexes };
    }

    const columns = await provider.ExecuteSQL!<ColumnCatalogRow>(`
        SELECT TABLE_NAME AS TableName, COLUMN_NAME AS ColumnName, IS_NULLABLE AS IsNullable
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = '__mj_BizAppsCommittees'
          AND TABLE_NAME IN ('Minute', 'Artifact', 'Motion', 'Vote', 'Attendance', 'vwMinutes', 'vwArtifacts')
    `);
    const fks = await provider.ExecuteSQL!<ForeignKeyCatalogRow>(`
        SELECT fk.name AS ConstraintName,
               OBJECT_NAME(fk.parent_object_id) AS TableName,
               fk.delete_referential_action_desc AS DeleteRule
        FROM sys.foreign_keys fk
        INNER JOIN sys.schemas s ON s.schema_id = fk.schema_id
        WHERE s.name = '__mj_BizAppsCommittees'
          AND OBJECT_NAME(fk.parent_object_id) IN ('Minute', 'Artifact')
    `);
    const indexes = await provider.ExecuteSQL!<IndexCatalogRow>(`
        SELECT t.name AS TableName, c.name AS ColumnName
        FROM sys.indexes i
        INNER JOIN sys.index_columns ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id
        INNER JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
        INNER JOIN sys.tables t ON t.object_id = i.object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        WHERE s.name = '__mj_BizAppsCommittees'
          AND t.name IN ('Minute', 'Artifact')
    `);
    return { platform, columns, fks, indexes };
}

export const PgParityAndBoundaryChecks: NamedCheck[] = [
    {
        Id: 'pg-parity-and-boundary.PB1',
        Name: 'PB1 — adversarial: rejects saving Minute with orphan ApprovedArtifactVersionID when MJArtifactID is null',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = World();
            const md = ProviderOf(ctx);
            const minute = await md.GetEntityObject<mjBizAppsCommitteesMinuteEntity>(E_MINUTE, ctx.User);
            Assert(
                minute instanceof MinuteEntityCustom,
                `Expected MinuteEntityCustom from ClassFactory, got ${minute.constructor.name}`,
            );

            minute.NewRecord();
            minute.MeetingID = world.Meetings.pubsCancelled;
            minute.ApprovalStatus = 'Approved';
            minute.Content = `${WORLD_MARK}:PB1 orphan version test`;
            minute.MJArtifactID = null;
            minute.ApprovedArtifactVersionID = world.MJArtifactVersions.boardMinutesV1;

            const saved = await minute.Save();
            assertSavedFailedWithMessage(saved, minute, 'ApprovedArtifactVersionID cannot be set when MJArtifactID is null', 'PB1');

            const leaked = await FindRows<{ ID: string }>(
                ctx,
                E_MINUTE,
                `MeetingID = '${world.Meetings.pubsCancelled}'`,
                ['ID'],
            );
            Assert(leaked.length === 0, 'Rejected orphan-pin Minute must not be persisted');
        },
    },
    {
        Id: 'pg-parity-and-boundary.PB2',
        Name: 'PB2 — adversarial: rejects saving Minute when ApprovedArtifactVersionID belongs to a different MJArtifactID',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = World();
            const md = ProviderOf(ctx);
            const minute = await md.GetEntityObject<mjBizAppsCommitteesMinuteEntity>(E_MINUTE, ctx.User);

            minute.NewRecord();
            minute.MeetingID = world.Meetings.pubsCancelled;
            minute.ApprovalStatus = 'Approved';
            minute.Content = `${WORLD_MARK}:PB2 cross-artifact mismatch test`;
            minute.MJArtifactID = world.MJArtifacts.boardMinutes;
            minute.ApprovedArtifactVersionID = world.MJArtifactVersions.financeDraftV1;

            const saved = await minute.Save();
            assertSavedFailedWithMessage(saved, minute, 'must belong to the linked MJArtifactID', 'PB2');

            const leaked = await FindRows<{ ID: string }>(
                ctx,
                E_MINUTE,
                `MeetingID = '${world.Meetings.pubsCancelled}'`,
                ['ID'],
            );
            Assert(leaked.length === 0, 'Rejected cross-artifact Minute must not be persisted');
        },
    },
    {
        Id: 'pg-parity-and-boundary.PB3',
        Name: 'PB3 — adversarial: rejects non-existent ApprovedArtifactVersionID and malformed UUIDs',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = World();
            const md = ProviderOf(ctx);

            const missingVersionMinute = await md.GetEntityObject<mjBizAppsCommitteesMinuteEntity>(E_MINUTE, ctx.User);
            missingVersionMinute.NewRecord();
            missingVersionMinute.MeetingID = world.Meetings.pubsCancelled;
            missingVersionMinute.ApprovalStatus = 'Draft';
            missingVersionMinute.MJArtifactID = world.MJArtifacts.boardMinutes;
            missingVersionMinute.ApprovedArtifactVersionID = '99999999-9999-4999-8999-999999999999';

            const savedMissing = await missingVersionMinute.Save();
            assertSavedFailedWithMessage(savedMissing, missingVersionMinute, 'does not exist', 'PB3 missing version');

            const badUuidMinute = await md.GetEntityObject<mjBizAppsCommitteesMinuteEntity>(E_MINUTE, ctx.User);
            badUuidMinute.NewRecord();
            badUuidMinute.MeetingID = world.Meetings.pubsCancelled;
            badUuidMinute.ApprovalStatus = 'Draft';
            badUuidMinute.MJArtifactID = 'not-a-valid-uuid';

            const validation = badUuidMinute.Validate();
            Assert(!validation.Success, 'Malformed MJArtifactID UUID must fail Validate()');
            Assert(
                validation.Errors.some((e) => e.Source === 'MJArtifactID'),
                'Malformed UUID validation error attributes to MJArtifactID',
            );
        },
    },
    {
        Id: 'pg-parity-and-boundary.PB4',
        Name: 'PB4 — Category C relational invariant: Motion, Vote, and Attendance keep relational Notes with no MJArtifactID',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = World();
            const md = ProviderOf(ctx);

            const [marcusSeat] = await FindRows<{ ID: string }>(
                ctx,
                E_MEMBERSHIP,
                `PersonID = '${world.People.marcus}' AND TermID = '${world.Terms.governance}' AND Status = 'Active'`,
                ['ID'],
            );
            Assert(!!marcusSeat, 'Marcus Governance membership exists');

            let motionId: string | null = null;
            let voteId: string | null = null;
            let attendanceId: string | null = null;

            try {
                const motion = await md.GetEntityObject<mjBizAppsCommitteesMotionEntity>(E_MOTION, ctx.User);
                motion.NewRecord();
                motion.Name = `${WORLD_MARK}:PB4 Category C relational motion`;
                motion.Sequence = 99;
                motion.MovedByMembershipID = marcusSeat.ID;
                motion.Result = 'Pending';
                motion.Notes = 'Category C short relational motion note';
                await RequireSave(motion, 'PB4 motion');
                motionId = motion.ID;

                const vote = await md.GetEntityObject<mjBizAppsCommitteesVoteEntity>(E_VOTE, ctx.User);
                vote.NewRecord();
                vote.MotionID = motionId;
                vote.MembershipID = marcusSeat.ID;
                vote.VoteValue = 'Yes';
                vote.Notes = 'Category C short relational vote note';
                await RequireSave(vote, 'PB4 vote');
                voteId = vote.ID;

                const attendance = await md.GetEntityObject<mjBizAppsCommitteesAttendanceEntity>(E_ATTENDANCE, ctx.User);
                attendance.NewRecord();
                attendance.MeetingID = world.Meetings.pubsCancelled;
                attendance.PersonID = world.People.marcus;
                attendance.AttendanceStatus = 'Present';
                attendance.Notes = 'Category C short relational attendance note';
                await RequireSave(attendance, 'PB4 attendance');
                attendanceId = attendance.ID;

                const [motionRow] = await FindRows<{ Notes: string | null }>(ctx, E_MOTION, `ID = '${motionId}'`, ['Notes']);
                const [voteRow] = await FindRows<{ Notes: string | null }>(ctx, E_VOTE, `ID = '${voteId}'`, ['Notes']);
                const [attRow] = await FindRows<{ Notes: string | null }>(ctx, E_ATTENDANCE, `ID = '${attendanceId}'`, ['Notes']);

                Assert(motionRow.Notes === 'Category C short relational motion note', 'Motion.Notes round-trips relationally');
                Assert(voteRow.Notes === 'Category C short relational vote note', 'Vote.Notes round-trips relationally');
                Assert(attRow.Notes === 'Category C short relational attendance note', 'Attendance.Notes round-trips relationally');
            } finally {
                if (attendanceId) await DeleteRow(ctx, E_ATTENDANCE, attendanceId);
                if (voteId) await DeleteRow(ctx, E_VOTE, voteId);
                if (motionId) await DeleteRow(ctx, E_MOTION, motionId);
            }
        },
    },
    {
        Id: 'pg-parity-and-boundary.PB5',
        Name: 'PB5 — live DBMS catalog parity (SQL Server / PostgreSQL): columns, nullability, vw* views, NO ACTION FKs, indexes, and zero Category C drift',
        RequiresMutation: false,
        Fn: async (ctx: IntegrationCheckContext) => {
            const provider = getSqlProvider(ctx);
            const { platform, columns, fks, indexes } = await queryLiveSchemaCatalog(provider);

            const hasCol = (table: string, col: string, nullable?: boolean): boolean =>
                columns.some(
                    (c) =>
                        c.TableName.toLowerCase() === table.toLowerCase() &&
                        c.ColumnName.toLowerCase() === col.toLowerCase() &&
                        (nullable === undefined || (c.IsNullable.toUpperCase() === 'YES') === nullable),
                );

            // 1. Additive nullable columns + preserved legacy columns on Minute & Artifact
            Assert(hasCol('Minute', 'MJArtifactID', true), `[${platform}] Minute.MJArtifactID must be nullable`);
            Assert(
                hasCol('Minute', 'ApprovedArtifactVersionID', true),
                `[${platform}] Minute.ApprovedArtifactVersionID must be nullable`,
            );
            Assert(hasCol('Minute', 'Content'), `[${platform}] Legacy Minute.Content must be preserved`);
            Assert(hasCol('Minute', 'ArtifactID'), `[${platform}] Legacy Minute.ArtifactID must be preserved`);
            Assert(hasCol('Artifact', 'MJArtifactID', true), `[${platform}] Artifact.MJArtifactID must be nullable`);
            Assert(hasCol('Artifact', 'URL'), `[${platform}] Legacy Artifact.URL must be preserved`);
            Assert(hasCol('Artifact', 'Provider'), `[${platform}] Legacy Artifact.Provider must be preserved`);

            // 2. Category C tables remain strictly relational
            for (const catC of ['Motion', 'Vote', 'Attendance']) {
                Assert(hasCol(catC, 'Notes'), `[${platform}] Category C ${catC}.Notes must remain present`);
                Assert(!hasCol(catC, 'MJArtifactID'), `[${platform}] Category C ${catC} must NOT have MJArtifactID`);
            }

            // 3. Base views project the additive columns
            Assert(hasCol('vwMinutes', 'MJArtifactID'), `[${platform}] vwMinutes projects MJArtifactID`);
            Assert(
                hasCol('vwMinutes', 'ApprovedArtifactVersionID'),
                `[${platform}] vwMinutes projects ApprovedArtifactVersionID`,
            );
            Assert(hasCol('vwArtifacts', 'MJArtifactID'), `[${platform}] vwArtifacts projects MJArtifactID`);

            // 4. Foreign keys exist with NO ACTION delete rule
            const expectedFks = [
                { name: 'FK_Minute_MJArtifact', table: 'Minute' },
                { name: 'FK_Minute_ApprovedArtifactVersion', table: 'Minute' },
                { name: 'FK_Artifact_MJArtifact', table: 'Artifact' },
            ];
            for (const expected of expectedFks) {
                const fk = fks.find(
                    (row) =>
                        row.ConstraintName.toLowerCase() === expected.name.toLowerCase() &&
                        row.TableName.toLowerCase() === expected.table.toLowerCase(),
                );
                Assert(!!fk, `[${platform}] Missing foreign key ${expected.name} on ${expected.table}`);
                const normalizedDelete = (fk?.DeleteRule ?? '').replace(/_/g, ' ').toUpperCase();
                Assert(
                    normalizedDelete === 'NO ACTION',
                    `[${platform}] ${expected.name} delete rule must be NO ACTION, got '${fk?.DeleteRule}'`,
                );
            }

            // 5. Supporting indexes exist on all three additive FK columns
            const hasIndexOn = (table: string, col: string): boolean =>
                indexes.some(
                    (ix) =>
                        ix.TableName.toLowerCase() === table.toLowerCase() &&
                        ix.ColumnName.toLowerCase() === col.toLowerCase(),
                );
            Assert(hasIndexOn('Minute', 'MJArtifactID'), `[${platform}] Index missing on Minute.MJArtifactID`);
            Assert(
                hasIndexOn('Minute', 'ApprovedArtifactVersionID'),
                `[${platform}] Index missing on Minute.ApprovedArtifactVersionID`,
            );
            Assert(hasIndexOn('Artifact', 'MJArtifactID'), `[${platform}] Index missing on Artifact.MJArtifactID`);
        },
    },
    {
        Id: 'pg-parity-and-boundary.PB6',
        Name: 'PB6 — UI-role persona reads Minute & Artifact MJArtifactID projections cleanly without RLS regressions',
        RequiresMutation: false,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = World();
            const priya = await PersonaUser(ctx, WorldUserEmail('priya'));

            const minutes = await FindRowsAs<{
                ID: string;
                MJArtifactID: string | null;
                ApprovedArtifactVersionID: string | null;
            }>(
                ctx,
                priya,
                E_MINUTE,
                `ID IN ('${world.Minutes.boardApprovedPinned}', '${world.Minutes.financePastLegacy}')`,
                ['ID', 'MJArtifactID', 'ApprovedArtifactVersionID'],
            );
            Assert(minutes.length === 2, `Priya reads both pinned and legacy minutes (${minutes.length})`);

            const artifacts = await FindRowsAs<{ ID: string; MJArtifactID: string | null; URL: string }>(
                ctx,
                priya,
                E_ARTIFACT,
                `ID IN ('${world.Artifacts.boardCharterDoc}', '${world.Artifacts.financePacketUrl}')`,
                ['ID', 'MJArtifactID', 'URL'],
            );
            Assert(artifacts.length === 2, `Priya reads both native MJ Doc and external URL artifacts (${artifacts.length})`);
            Assert(
                artifacts.some((a) => a.MJArtifactID !== null) && artifacts.some((a) => a.MJArtifactID === null),
                'Persona read preserves distinction between native MJ Docs and external URL artifacts',
            );
        },
    },
];

for (const check of PgParityAndBoundaryChecks) {
    IntegrationCheckRegistry.Instance.Register(check);
}

IntegrationCheckRegistry.Instance.RegisterLifecycle('pg-parity-and-boundary', {
    Setup: async (ctx: IntegrationCheckContext) => {
        await LoadWorld(ctx);
    },
    Teardown: async () => undefined,
});
