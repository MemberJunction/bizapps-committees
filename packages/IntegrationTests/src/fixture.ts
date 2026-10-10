/**
 * Shared helpers. Every write goes through BaseEntity on the check's provider —
 * the same path Explorer uses. No raw INSERT, no Demos/*.sql.
 */
import { BaseEntity, CompositeKey, RunView, UserInfo, type IMetadataProvider } from '@memberjunction/core';
import { Assert, type IntegrationCheckContext } from '@memberjunction/testing-integration/registry';
import { E_USER, E_USER_ROLE, WORLD_MARK } from './entity-names.js';

export * from './entity-names.js';

export function Quote(value: string): string {
    return value.replace(/'/g, "''");
}

export function ProviderOf(ctx: IntegrationCheckContext): IMetadataProvider {
    return ctx.Provider;
}

export function View(ctx: IntegrationCheckContext): RunView {
    return RunView.FromMetadataProvider(ctx.Provider as IMetadataProvider);
}

export function UtcToday(): Date {
    const now = new Date();
    return new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));
}

export function UtcDay(offsetDays: number): Date {
    const day = UtcToday();
    day.setUTCDate(day.getUTCDate() + offsetDays);
    return day;
}

/** Next occurrence of weekday (0=Sun … 4=Thu) at `hourUtc`, at least `minDays` from today. */
export function UpcomingWeekday(weekday: number, hourUtc: number, minDays = 1): Date {
    const day = UtcToday();
    day.setUTCDate(day.getUTCDate() + minDays);
    while (day.getUTCDay() !== weekday) {
        day.setUTCDate(day.getUTCDate() + 1);
    }
    return new Date(Date.UTC(day.getUTCFullYear(), day.getUTCMonth(), day.getUTCDate(), hourUtc, 0, 0));
}

export async function FindRows<T extends object>(
    ctx: IntegrationCheckContext,
    entityName: string,
    extraFilter: string,
    fields: string[],
    orderBy?: string,
): Promise<T[]> {
    const result = await View(ctx).RunView<T>(
        {
            EntityName: entityName,
            ExtraFilter: extraFilter || undefined,
            Fields: fields,
            OrderBy: orderBy,
            ResultType: 'simple',
        },
        ctx.User,
    );
    Assert(result.Success, `RunView ${entityName} failed — ${result.ErrorMessage ?? 'unknown error'}`);
    return result.Results ?? [];
}

export async function FindId(
    ctx: IntegrationCheckContext,
    entityName: string,
    extraFilter: string,
    orderBy?: string,
): Promise<string | null> {
    const rows = await FindRows<{ ID: string }>(ctx, entityName, extraFilter, ['ID'], orderBy);
    return rows[0]?.ID ?? null;
}

export async function RequireSave(
    entity: { Save: () => Promise<boolean>; LatestResult?: { CompleteMessage?: string; Message?: string } },
    what: string,
): Promise<void> {
    const ok = await entity.Save();
    Assert(
        ok,
        `${what} failed: ${entity.LatestResult?.CompleteMessage ?? entity.LatestResult?.Message ?? 'unknown error'}`,
    );
}

export function WorldFilter(key: string): string {
    return `Description LIKE '${Quote(WORLD_MARK + ':' + key)}%'`;
}

export function WorldDescription(key: string, rest: string): string {
    return `${WORLD_MARK}:${key} — ${rest}`;
}

export type MutableRecord = {
    NewRecord: () => void;
    Load?: (id: string) => Promise<boolean>;
    InnerLoad: (key: CompositeKey) => Promise<boolean>;
    Save: () => Promise<boolean>;
    Set: (field: string, value: unknown) => void;
    Get: (field: string) => unknown;
    LatestResult?: { CompleteMessage?: string; Message?: string };
};

/** Generated subclasses have Load(id). People/Orgs often fall back to BaseEntity — InnerLoad only. */
export async function LoadExisting(row: MutableRecord, id: string): Promise<boolean> {
    if (typeof row.Load === 'function') {
        return row.Load(id);
    }
    const key = new CompositeKey();
    key.KeyValuePairs.push({ FieldName: 'ID', Value: id });
    return row.InnerLoad(key);
}

export async function EntityOf(ctx: IntegrationCheckContext, entityName: string): Promise<MutableRecord> {
    return (await ProviderOf(ctx).GetEntityObject(entityName, ctx.User)) as unknown as MutableRecord;
}

interface UserRow { ID: string; Name: string; FirstName: string; LastName: string; Email: string; Type: string; IsActive: boolean }
interface UserRoleRow { RoleID: string; Role: string }

/**
 * A persona as MJAPI would see them: a UserInfo with their MJ roles, so a RunView run as them applies the row filters
 * their roles carry. The harness's own user (the owner) sees everything; the personas see what a member sees.
 */
export async function PersonaUser(ctx: IntegrationCheckContext, email: string): Promise<UserInfo> {
    const [row] = await FindRows<UserRow>(ctx, E_USER, `Email = '${Quote(email)}'`, ['ID', 'Name', 'FirstName', 'LastName', 'Email', 'Type', 'IsActive']);
    Assert(!!row, `MJ user ${email} exists (the committees-world bundle creates the persona users)`);
    const roles = await FindRows<UserRoleRow>(ctx, E_USER_ROLE, `UserID = '${row.ID}'`, ['RoleID', 'Role']);
    Assert(roles.length > 0, `${email} holds at least one MJ role`);
    return new UserInfo(ProviderOf(ctx), {
        ID: row.ID,
        Name: row.Name,
        FirstName: row.FirstName,
        LastName: row.LastName,
        Email: row.Email,
        Type: row.Type,
        IsActive: row.IsActive,
        UserRoles: roles.map((r) => ({ UserID: row.ID, RoleID: r.RoleID, Role: r.Role })),
    });
}

/** Rows read as a persona: the same view the owner's FindRows uses, run as the persona (their row filters apply). */
export async function FindRowsAs<T extends object>(ctx: IntegrationCheckContext, user: UserInfo, entityName: string, extraFilter: string, fields: string[]): Promise<T[]> {
    const result = await View(ctx).RunView<T>({ EntityName: entityName, ExtraFilter: extraFilter || undefined, Fields: fields, ResultType: 'simple' }, user);
    Assert(result.Success, `RunView ${entityName} as ${user.Email} failed — ${result.ErrorMessage ?? 'unknown error'}`);
    return result.Results ?? [];
}

/** Deletes one row through BaseEntity as the harness's user; a missing row is not an error (teardown is idempotent). */
export async function DeleteRow(ctx: IntegrationCheckContext, entityName: string, id: string): Promise<void> {
    const entity = (await ProviderOf(ctx).GetEntityObject(entityName, ctx.User)) as BaseEntity;
    const key = new CompositeKey();
    key.KeyValuePairs.push({ FieldName: 'ID', Value: id });
    if (!(await entity.InnerLoad(key))) return;
    Assert(await entity.Delete(), `delete ${entityName} ${id}: ${entity.LatestResult?.CompleteMessage ?? 'failed'}`);
}
