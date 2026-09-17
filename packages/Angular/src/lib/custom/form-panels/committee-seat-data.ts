/**
 * Membership is on Term, not Committee. These loaders walk Term → Committee
 * so Person and Committee forms can show seats without a CommitteeID on Membership.
 */
import { RunView, type IMetadataProvider } from '@memberjunction/core';

export interface SeatTerm {
    MembershipID: string;
    TermID: string;
    TermName: string;
    TermStatus: string;
    Role: string;
    RoleID: string;
    IsOfficer: boolean;
    IsVoting: boolean;
    MembershipStatus: string;
    Start: Date | null;
    End: Date | null;
    RenewalIntent: string | null;
}

export interface PersonCommitteeCard {
    CommitteeID: string;
    CommitteeName: string;
    Terms: SeatTerm[];
}

export interface CommitteeMemberCard {
    PersonID: string;
    PersonName: string;
    PhotoURL: string | null;
    Terms: SeatTerm[];
}

interface MembershipRow {
    ID: string;
    PersonID: string;
    RoleID: string;
    TermID: string;
    StartDate?: string | Date | null;
    EndDate?: string | Date | null;
    Status?: string;
    RenewalIntent?: string | null;
    Person?: string;
    Role?: string;
    Term?: string;
}

interface TermRow {
    ID: string;
    CommitteeID: string;
    Name: string;
    StartDate?: string | Date | null;
    EndDate?: string | Date | null;
    Status?: string;
    Committee?: string;
}

interface RoleRow {
    ID: string;
    Name: string;
    IsOfficer?: boolean;
    IsVotingRole?: boolean;
}

function Quote(value: string): string {
    return value.replace(/'/g, "''");
}

function InList(ids: string[]): string {
    return ids.map((id) => `'${Quote(id)}'`).join(',');
}

function AsDate(value: string | Date | null | undefined): Date | null {
    if (!value) return null;
    const d = value instanceof Date ? value : new Date(value);
    return Number.isNaN(d.getTime()) ? null : d;
}

function ViewOf(provider?: IMetadataProvider): RunView {
    return provider ? RunView.FromMetadataProvider(provider) : new RunView();
}

function RoleLooksOfficer(name: string): boolean {
    const n = name.toLowerCase();
    return n.includes('chair') || n.includes('president') || n.includes('secretary') || n.includes('treasurer');
}

async function LoadPersonPhotos(
    provider: IMetadataProvider | undefined,
    ids: string[],
): Promise<Map<string, string | null>> {
    const map = new Map<string, string | null>();
    if (ids.length === 0) return map;
    const res = await ViewOf(provider).RunView<{ ID: string; PhotoURL?: string | null }>({
        EntityName: 'MJ_BizApps_Common: People',
        ExtraFilter: `ID IN (${InList(ids)})`,
        Fields: ['ID', 'PhotoURL'],
        ResultType: 'simple',
    });
    for (const row of res.Results ?? []) {
        const url = (row.PhotoURL ?? '').trim();
        map.set(row.ID, url.length > 0 ? url : null);
    }
    return map;
}

async function LoadRoles(provider: IMetadataProvider | undefined, ids: string[]): Promise<Map<string, RoleRow>> {
    const map = new Map<string, RoleRow>();
    if (ids.length === 0) return map;
    const res = await ViewOf(provider).RunView<RoleRow>({
        EntityName: 'Committees: Roles',
        ExtraFilter: `ID IN (${InList(ids)})`,
        Fields: ['ID', 'Name', 'IsOfficer', 'IsVotingRole'],
        ResultType: 'simple',
    });
    for (const row of res.Results ?? []) {
        map.set(row.ID, row);
    }
    return map;
}

function ToSeat(
    m: MembershipRow,
    term: TermRow | undefined,
    role: RoleRow | undefined,
): SeatTerm {
    const roleName = role?.Name || m.Role || 'Member';
    return {
        MembershipID: m.ID,
        TermID: m.TermID,
        TermName: term?.Name || m.Term || 'Term',
        TermStatus: term?.Status || '',
        Role: roleName,
        RoleID: m.RoleID,
        IsOfficer: role?.IsOfficer === true || RoleLooksOfficer(roleName),
        IsVoting: role?.IsVotingRole !== false,
        MembershipStatus: m.Status || 'Active',
        Start: AsDate(m.StartDate) ?? AsDate(term?.StartDate),
        End: AsDate(m.EndDate) ?? AsDate(term?.EndDate),
        RenewalIntent: m.RenewalIntent ?? null,
    };
}

function SortSeats(a: SeatTerm, b: SeatTerm): number {
    const aActive = a.MembershipStatus === 'Active' ? 0 : 1;
    const bActive = b.MembershipStatus === 'Active' ? 0 : 1;
    if (aActive !== bActive) return aActive - bActive;
    const aEnd = a.End?.getTime() ?? Number.MAX_SAFE_INTEGER;
    const bEnd = b.End?.getTime() ?? Number.MAX_SAFE_INTEGER;
    return bEnd - aEnd;
}

export async function LoadCommitteesForPerson(
    personID: string,
    provider?: IMetadataProvider,
): Promise<PersonCommitteeCard[]> {
    const memberships = await ViewOf(provider).RunView<MembershipRow>({
        EntityName: 'Committees: Memberships',
        ExtraFilter: `PersonID = '${Quote(personID)}'`,
        Fields: ['ID', 'PersonID', 'RoleID', 'TermID', 'StartDate', 'EndDate', 'Status', 'RenewalIntent', 'Person', 'Role', 'Term'],
        ResultType: 'simple',
    });
    const rows = memberships.Results ?? [];
    if (rows.length === 0) return [];

    const termIDs = [...new Set(rows.map((r) => r.TermID).filter(Boolean))];
    const roleIDs = [...new Set(rows.map((r) => r.RoleID).filter(Boolean))];
    const [termsRes, roles] = await Promise.all([
        ViewOf(provider).RunView<TermRow>({
            EntityName: 'Committees: Terms',
            ExtraFilter: `ID IN (${InList(termIDs)})`,
            Fields: ['ID', 'CommitteeID', 'Name', 'StartDate', 'EndDate', 'Status', 'Committee'],
            ResultType: 'simple',
        }),
        LoadRoles(provider, roleIDs),
    ]);
    const terms = new Map((termsRes.Results ?? []).map((t) => [t.ID, t]));

    const byCommittee = new Map<string, PersonCommitteeCard>();
    for (const m of rows) {
        const term = terms.get(m.TermID);
        const committeeID = term?.CommitteeID;
        if (!committeeID) continue;
        const seat = ToSeat(m, term, roles.get(m.RoleID));
        const existing = byCommittee.get(committeeID);
        if (existing) {
            existing.Terms.push(seat);
        } else {
            byCommittee.set(committeeID, {
                CommitteeID: committeeID,
                CommitteeName: term?.Committee || 'Committee',
                Terms: [seat],
            });
        }
    }
    const cards = [...byCommittee.values()];
    for (const card of cards) card.Terms.sort(SortSeats);
    cards.sort((a, b) => {
        const aOn = a.Terms.some((t) => t.MembershipStatus === 'Active') ? 0 : 1;
        const bOn = b.Terms.some((t) => t.MembershipStatus === 'Active') ? 0 : 1;
        if (aOn !== bOn) return aOn - bOn;
        return a.CommitteeName.localeCompare(b.CommitteeName);
    });
    return cards;
}

export async function LoadMembersForCommittee(
    committeeID: string,
    provider?: IMetadataProvider,
): Promise<CommitteeMemberCard[]> {
    const termsRes = await ViewOf(provider).RunView<TermRow>({
        EntityName: 'Committees: Terms',
        ExtraFilter: `CommitteeID = '${Quote(committeeID)}'`,
        Fields: ['ID', 'CommitteeID', 'Name', 'StartDate', 'EndDate', 'Status', 'Committee'],
        ResultType: 'simple',
    });
    const terms = termsRes.Results ?? [];
    if (terms.length === 0) return [];
    const termMap = new Map(terms.map((t) => [t.ID, t]));

    const memberships = await ViewOf(provider).RunView<MembershipRow>({
        EntityName: 'Committees: Memberships',
        ExtraFilter: `TermID IN (${InList(terms.map((t) => t.ID))})`,
        Fields: ['ID', 'PersonID', 'RoleID', 'TermID', 'StartDate', 'EndDate', 'Status', 'RenewalIntent', 'Person', 'Role', 'Term'],
        ResultType: 'simple',
    });
    const rows = memberships.Results ?? [];
    if (rows.length === 0) return [];

    const personIDs = [...new Set(rows.map((r) => r.PersonID).filter(Boolean))];
    const [roles, photos] = await Promise.all([
        LoadRoles(provider, [...new Set(rows.map((r) => r.RoleID).filter(Boolean))]),
        LoadPersonPhotos(provider, personIDs),
    ]);
    const byPerson = new Map<string, CommitteeMemberCard>();
    for (const m of rows) {
        const seat = ToSeat(m, termMap.get(m.TermID), roles.get(m.RoleID));
        const existing = byPerson.get(m.PersonID);
        if (existing) {
            existing.Terms.push(seat);
        } else {
            byPerson.set(m.PersonID, {
                PersonID: m.PersonID,
                PersonName: m.Person || 'Unknown',
                PhotoURL: photos.get(m.PersonID) ?? null,
                Terms: [seat],
            });
        }
    }
    const cards = [...byPerson.values()];
    for (const card of cards) card.Terms.sort(SortSeats);
    cards.sort((a, b) => {
        const aOff = a.Terms.some((t) => t.IsOfficer && t.MembershipStatus === 'Active') ? 0 : 1;
        const bOff = b.Terms.some((t) => t.IsOfficer && t.MembershipStatus === 'Active') ? 0 : 1;
        if (aOff !== bOff) return aOff - bOff;
        return a.PersonName.localeCompare(b.PersonName);
    });
    return cards;
}

export function ActiveSeat(terms: SeatTerm[]): SeatTerm | undefined {
    return terms.find((t) => t.MembershipStatus === 'Active') ?? terms[0];
}

export function FormatRange(start: Date | null, end: Date | null): string {
    const fmt = (d: Date) =>
        d.toLocaleDateString(undefined, { month: 'short', year: 'numeric' });
    if (start && end) return `${fmt(start)} – ${fmt(end)}`;
    if (start) return `from ${fmt(start)}`;
    if (end) return `until ${fmt(end)}`;
    return 'Open-ended';
}

export function DaysLeft(end: Date | null): number | null {
    if (!end) return null;
    const now = new Date();
    const today = Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate());
    const then = Date.UTC(end.getUTCFullYear(), end.getUTCMonth(), end.getUTCDate());
    return Math.round((then - today) / 86_400_000);
}

export function Initials(name: string): string {
    const parts = name.trim().split(/\s+/).filter(Boolean);
    if (parts.length === 0) return '?';
    if (parts.length === 1) return parts[0].slice(0, 2).toUpperCase();
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
}
