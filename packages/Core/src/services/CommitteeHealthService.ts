import { RunView, UserInfo } from '@memberjunction/core';

/**
 * Committee health signal computation for the Governance Command Center.
 *
 * All signals are computed from real columns — Terms, Attendance, Minutes,
 * and Action Items — never from shadow fields. Thresholds below are the
 * UX v2 mockup defaults (plans/PHASE1_PRD.md §9.2); tune after first demo.
 */

/** Terms ending within this many days count as "expiring soon" (warning). */
export const TERM_EXPIRY_WINDOW_DAYS = 90;
/** Quorum = strict majority of voting members. */
export const QUORUM_FRACTION = 0.5;
/** Completed meetings sampled for the attendance-rate forecast. */
export const ATTENDANCE_LOOKBACK_MEETINGS = 6;
/** Overdue-action count at or above this renders the error (not warning) badge. */
export const ACTION_ERROR_THRESHOLD = 5;
/** Minutes pending longer than this many days show their age ("Draft 41d"). */
export const MINUTES_AGE_CALLOUT_DAYS = 30;

export type QuorumRiskLevel = 'High' | 'Medium' | 'Low' | 'None';
export type HealthLevel = 'AtRisk' | 'Watch' | 'Healthy' | 'Pending' | 'Dissolved';
export type TermHygieneKind = 'NoActiveTerm' | 'EndingSoon' | 'Current' | 'NotStarted' | 'Completed';

export interface TermHygiene {
    Kind: TermHygieneKind;
    /** End date of the active term, if any. */
    EndDate: Date | null;
    /** Days until the active term ends (negative = past). */
    DaysRemaining: number | null;
    /** True when an Upcoming term exists to succeed the active one ("staged ✓"). */
    HasStagedNextTerm: boolean;
}

export interface MinutesDebt {
    /** Minutes with ApprovalStatus Draft or PendingApproval. */
    PendingCount: number;
    /** Age in days of the oldest pending minute (0 when none). */
    OldestPendingDays: number;
}

export interface ActionAging {
    OpenCount: number;
    OverdueCount: number;
    OldestOverdueDays: number;
}

export interface QuorumForecast {
    Level: QuorumRiskLevel;
    /** Expected attendees = voting members × historical attendance rate. */
    ExpectedAttendees: number;
    /** Strict majority of voting members. */
    Required: number;
    VotingMemberCount: number;
}

export interface CommitteeHealthRow {
    CommitteeID: string;
    Name: string;
    TypeName: string;
    ChairName: string | null;
    Status: string;
    IsPublic: boolean;
    /** True when the current user cannot open this committee (locked row). */
    IsLocked: boolean;
    MemberCount: number;
    VotingMemberCount: number;
    Health: HealthLevel;
    Quorum: QuorumForecast;
    Term: TermHygiene;
    Minutes: MinutesDebt;
    Actions: ActionAging;
    /** Next scheduled meeting start, if any. */
    NextMeetingAt: Date | null;
    NextMeetingTitle: string | null;
}

export interface PortfolioSummary {
    TotalCommittees: number;
    ActiveCommittees: number;
    NewThisYear: number;
    ServingMembers: number;
    TotalSeats: number;
    TermsExpiringSoon: number;
    NearestExpiryDate: Date | null;
    OverdueActions: number;
    OldestOverdueDays: number;
    MeetingsThisWeek: number;
    NeedsAttentionCount: number;
}

export interface UpcomingMeetingForecast {
    MeetingID: string;
    CommitteeID: string;
    CommitteeName: string;
    Title: string;
    StartDateTime: Date;
    EndDateTime: Date | null;
    LocationType: string | null;
    LocationText: string | null;
    VideoProviderName: string | null;
    Quorum: QuorumForecast;
    AgendaItemCount: number;
}

export type AttentionKind = 'TermLapse' | 'MinutesPending' | 'OverdueAction' | 'QuorumRisk';

export interface AttentionItem {
    Kind: AttentionKind;
    CommitteeID: string;
    CommitteeName: string;
    Title: string;
    Detail: string;
}

export interface GovernancePortfolio {
    Summary: PortfolioSummary;
    Rows: CommitteeHealthRow[];
    ThisWeek: UpcomingMeetingForecast[];
    Attention: AttentionItem[];
}

/** Simple-row shapes returned by the batched RunViews load. */
interface CommitteeRow { ID: string; Name: string; Status: string; IsPublic: boolean; Type: string; FormationDate: string | null; __mj_CreatedAt: string; }
interface TermRow { ID: string; CommitteeID: string; Status: string; StartDate: string; EndDate: string | null; }
interface MembershipRow { ID: string; TermID: string; PersonID: string; Status: string; Role: string; Person: string; }
interface RoleRow { ID: string; Name: string; IsVotingRole: boolean; IsOfficer: boolean; }
interface MeetingRow { ID: string; CommitteeID: string; Committee: string; Title: string; StartDateTime: string; EndDateTime: string | null; Status: string; LocationType: string | null; LocationText: string | null; VideoProvider_Virtual: string | null; }
interface AttendanceRow { MeetingID: string; PersonID: string; AttendanceStatus: string; }
interface MinuteRow { ID: string; MeetingID: string; ApprovalStatus: string; __mj_CreatedAt: string; }
interface ActionItemRow { ID: string; CommitteeID: string; Title: string; DueDate: string | null; Status: string; AssignedToPerson: string | null; }
interface AgendaItemRow { ID: string; MeetingID: string; }
interface MembershipRoleRow extends MembershipRow { RoleID: string; }

/**
 * Loads the full governance portfolio in one batched query set and computes
 * every Command Center signal client-side. No per-committee queries.
 */
export class CommitteeHealthService {
    public async GetPortfolio(contextUser?: UserInfo): Promise<GovernancePortfolio> {
        const data = await this.loadPortfolioData(contextUser);
        return CommitteeHealthService.ComputePortfolio(data, new Date());
    }

    private async loadPortfolioData(contextUser?: UserInfo): Promise<PortfolioData> {
        const rv = new RunView();
        const now = new Date();
        const lookbackISO = new Date(now.getTime() - 365 * 86400000).toISOString();
        const [committees, terms, memberships, roles, meetings, minutes, actionItems, agendaItems] = await rv.RunViews([
            { EntityName: 'Committees: Committees', Fields: ['ID', 'Name', 'Status', 'IsPublic', 'Type', 'FormationDate', '__mj_CreatedAt'], ResultType: 'simple' },
            { EntityName: 'Committees: Terms', Fields: ['ID', 'CommitteeID', 'Status', 'StartDate', 'EndDate'], ResultType: 'simple' },
            { EntityName: 'Committees: Memberships', ExtraFilter: "Status = 'Active'", Fields: ['ID', 'TermID', 'PersonID', 'RoleID', 'Status', 'Role', 'Person'], ResultType: 'simple' },
            { EntityName: 'Committees: Roles', Fields: ['ID', 'Name', 'IsVotingRole', 'IsOfficer'], ResultType: 'simple' },
            { EntityName: 'Committees: Meetings', ExtraFilter: `StartDateTime >= '${lookbackISO}'`, Fields: ['ID', 'CommitteeID', 'Committee', 'Title', 'StartDateTime', 'EndDateTime', 'Status', 'LocationType', 'LocationText', 'VideoProvider_Virtual'], OrderBy: 'StartDateTime ASC', ResultType: 'simple' },
            { EntityName: 'Committees: Minutes', ExtraFilter: "ApprovalStatus IN ('Draft', 'PendingApproval')", Fields: ['ID', 'MeetingID', 'ApprovalStatus', '__mj_CreatedAt'], ResultType: 'simple' },
            { EntityName: 'Committees: Action Items', ExtraFilter: "Status IN ('Open', 'InProgress')", Fields: ['ID', 'CommitteeID', 'Title', 'DueDate', 'Status', 'AssignedToPerson'], ResultType: 'simple' },
            { EntityName: 'Committees: Agenda Items', Fields: ['ID', 'MeetingID'], ResultType: 'simple' },
        ], contextUser);

        // Attendance is loaded second because it is scoped to the meetings above.
        const meetingRows = (meetings.Success ? meetings.Results : []) as unknown as MeetingRow[];
        const completedIDs = meetingRows.filter(m => m.Status === 'Completed').map(m => `'${m.ID}'`);
        let attendanceRows: AttendanceRow[] = [];
        if (completedIDs.length > 0) {
            const attendance = await rv.RunView({
                EntityName: 'Committees: Attendances',
                ExtraFilter: `MeetingID IN (${completedIDs.join(',')})`,
                Fields: ['MeetingID', 'PersonID', 'AttendanceStatus'],
                ResultType: 'simple',
            }, contextUser);
            if (attendance.Success) attendanceRows = attendance.Results as unknown as AttendanceRow[];
        }

        return {
            Committees: (committees.Success ? committees.Results : []) as unknown as CommitteeRow[],
            Terms: (terms.Success ? terms.Results : []) as unknown as TermRow[],
            Memberships: (memberships.Success ? memberships.Results : []) as unknown as MembershipRoleRow[],
            Roles: (roles.Success ? roles.Results : []) as unknown as RoleRow[],
            Meetings: meetingRows,
            Attendance: attendanceRows,
            Minutes: (minutes.Success ? minutes.Results : []) as unknown as MinuteRow[],
            ActionItems: (actionItems.Success ? actionItems.Results : []) as unknown as ActionItemRow[],
            AgendaItems: (agendaItems.Success ? agendaItems.Results : []) as unknown as AgendaItemRow[],
        };
    }

    // ------------------------------------------------------------------
    // Pure computation — everything below is deterministic and unit-testable
    // without a database. `now` is always injected.
    // ------------------------------------------------------------------

    public static ComputePortfolio(data: PortfolioData, now: Date): GovernancePortfolio {
        const votingRoleIDs = new Set(data.Roles.filter(r => r.IsVotingRole).map(r => r.ID));
        const officerRoleNames = new Map(data.Roles.map(r => [r.ID, r] as const));
        const termsByCommittee = groupBy(data.Terms, t => t.CommitteeID);
        const membershipsByTerm = groupBy(data.Memberships, m => m.TermID);
        const meetingsByCommittee = groupBy(data.Meetings, m => m.CommitteeID);
        const actionsByCommittee = groupBy(data.ActionItems, a => a.CommitteeID);
        const meetingCommittee = new Map(data.Meetings.map(m => [m.ID, m.CommitteeID] as const));
        const minutesByCommittee = groupBy(
            data.Minutes.filter(mi => meetingCommittee.has(mi.MeetingID)),
            mi => meetingCommittee.get(mi.MeetingID) as string
        );
        const agendaCountByMeeting = countBy(data.AgendaItems, a => a.MeetingID);
        const attendanceByMeeting = groupBy(data.Attendance, a => a.MeetingID);

        const rows = data.Committees.map(c => this.computeRow(
            c,
            termsByCommittee.get(c.ID) ?? [],
            membershipsByTerm,
            votingRoleIDs,
            officerRoleNames,
            meetingsByCommittee.get(c.ID) ?? [],
            attendanceByMeeting,
            minutesByCommittee.get(c.ID) ?? [],
            actionsByCommittee.get(c.ID) ?? [],
            now,
        ));
        sortNeedsAttentionFirst(rows);

        const thisWeek = this.computeThisWeek(data, rows, agendaCountByMeeting, now);
        const attention = this.computeAttention(rows, now);
        const summary = this.computeSummary(data, rows, thisWeek, now);
        return { Summary: summary, Rows: rows, ThisWeek: thisWeek, Attention: attention };
    }

    public static ComputeTermHygiene(terms: TermRow[], now: Date): TermHygiene {
        const active = terms.filter(t => t.Status === 'Active');
        const staged = terms.some(t => t.Status === 'Upcoming');
        if (active.length === 0) {
            const anyPast = terms.some(t => t.Status === 'Completed' || (t.EndDate !== null && new Date(t.EndDate) < now));
            return { Kind: anyPast ? 'NoActiveTerm' : 'NotStarted', EndDate: null, DaysRemaining: null, HasStagedNextTerm: staged };
        }
        // Latest-ending active term governs hygiene
        const current = active.reduce((a, b) => (endTime(a) >= endTime(b) ? a : b));
        if (current.EndDate === null) {
            return { Kind: 'Current', EndDate: null, DaysRemaining: null, HasStagedNextTerm: staged };
        }
        const end = new Date(current.EndDate);
        const days = Math.ceil((end.getTime() - now.getTime()) / 86400000);
        const kind: TermHygieneKind = days <= TERM_EXPIRY_WINDOW_DAYS && !staged ? 'EndingSoon' : 'Current';
        return { Kind: kind, EndDate: end, DaysRemaining: days, HasStagedNextTerm: staged };
    }

    public static ComputeQuorumForecast(
        votingMemberCount: number,
        attendanceRate: number | null,
    ): QuorumForecast {
        if (votingMemberCount === 0) {
            return { Level: 'None', ExpectedAttendees: 0, Required: 0, VotingMemberCount: 0 };
        }
        const required = Math.floor(votingMemberCount * QUORUM_FRACTION) + 1;
        // With no history, assume full attendance (new committees start Low).
        const expected = attendanceRate === null
            ? votingMemberCount
            : Math.round(votingMemberCount * attendanceRate * 10) / 10;
        let level: QuorumRiskLevel = 'Low';
        if (expected < required) level = 'High';
        else if (expected < required + 1) level = 'Medium';
        return { Level: level, ExpectedAttendees: expected, Required: required, VotingMemberCount: votingMemberCount };
    }

    public static ComputeMinutesDebt(minutes: MinuteRow[], now: Date): MinutesDebt {
        if (minutes.length === 0) return { PendingCount: 0, OldestPendingDays: 0 };
        const oldest = Math.max(...minutes.map(mi => now.getTime() - new Date(mi.__mj_CreatedAt).getTime()));
        return { PendingCount: minutes.length, OldestPendingDays: Math.floor(oldest / 86400000) };
    }

    public static ComputeActionAging(actions: ActionItemRow[], now: Date): ActionAging {
        const overdue = actions.filter(a => a.DueDate !== null && new Date(a.DueDate) < now);
        const oldest = overdue.length === 0 ? 0 : Math.max(...overdue.map(a => now.getTime() - new Date(a.DueDate as string).getTime()));
        return { OpenCount: actions.length, OverdueCount: overdue.length, OldestOverdueDays: Math.floor(oldest / 86400000) };
    }

    public static RollupHealth(status: string, quorum: QuorumForecast, term: TermHygiene, minutes: MinutesDebt, actions: ActionAging): HealthLevel {
        if (status === 'Dissolved' || status === 'Inactive') return 'Dissolved';
        if (status === 'Pending' || term.Kind === 'NotStarted') return 'Pending';
        if (term.Kind === 'NoActiveTerm' || quorum.Level === 'High') return 'AtRisk';
        if (quorum.Level === 'Medium' || minutes.PendingCount > 0 || actions.OverdueCount > 0 || term.Kind === 'EndingSoon') return 'Watch';
        return 'Healthy';
    }

    private static computeRow(
        c: CommitteeRow,
        terms: TermRow[],
        membershipsByTerm: Map<string, MembershipRoleRow[]>,
        votingRoleIDs: Set<string>,
        roles: Map<string, RoleRow>,
        meetings: MeetingRow[],
        attendanceByMeeting: Map<string, AttendanceRow[]>,
        minutes: MinuteRow[],
        actions: ActionItemRow[],
        now: Date,
    ): CommitteeHealthRow {
        const term = this.ComputeTermHygiene(terms, now);
        const members = terms
            .filter(t => t.Status === 'Active')
            .flatMap(t => membershipsByTerm.get(t.ID) ?? []);
        const votingMembers = members.filter(m => votingRoleIDs.has(m.RoleID));
        const chair = members.find(m => roles.get(m.RoleID)?.Name === 'Chair');

        const attendanceRate = this.attendanceRate(meetings, attendanceByMeeting, votingMembers.map(m => m.PersonID), now);
        const quorum = this.ComputeQuorumForecast(votingMembers.length, attendanceRate);
        const minutesDebt = this.ComputeMinutesDebt(minutes, now);
        const actionAging = this.ComputeActionAging(actions, now);
        const next = meetings.find(m => new Date(m.StartDateTime) >= now && (m.Status === 'Scheduled' || m.Status === 'Draft'));

        return {
            CommitteeID: c.ID,
            Name: c.Name,
            TypeName: c.Type,
            ChairName: chair?.Person ?? null,
            Status: c.Status,
            IsPublic: c.IsPublic,
            IsLocked: false, // set by the component from CommitteePermissionHelper
            MemberCount: members.length,
            VotingMemberCount: votingMembers.length,
            Health: this.RollupHealth(c.Status, quorum, term, minutesDebt, actionAging),
            Quorum: quorum,
            Term: term,
            Minutes: minutesDebt,
            Actions: actionAging,
            NextMeetingAt: next ? new Date(next.StartDateTime) : null,
            NextMeetingTitle: next?.Title ?? null,
        };
    }

    /** Mean attendance rate of the committee's voting members over the last N completed meetings. */
    private static attendanceRate(
        meetings: MeetingRow[],
        attendanceByMeeting: Map<string, AttendanceRow[]>,
        votingPersonIDs: string[],
        now: Date,
    ): number | null {
        if (votingPersonIDs.length === 0) return null;
        const completed = meetings
            .filter(m => m.Status === 'Completed' && new Date(m.StartDateTime) < now)
            .slice(-ATTENDANCE_LOOKBACK_MEETINGS);
        if (completed.length === 0) return null;
        const votingSet = new Set(votingPersonIDs);
        let present = 0;
        for (const m of completed) {
            const rows = attendanceByMeeting.get(m.ID) ?? [];
            present += rows.filter(a => votingSet.has(a.PersonID) && a.AttendanceStatus !== 'Absent').length;
        }
        return present / (completed.length * votingPersonIDs.length);
    }

    private static computeThisWeek(
        data: PortfolioData,
        rows: CommitteeHealthRow[],
        agendaCountByMeeting: Map<string, number>,
        now: Date,
    ): UpcomingMeetingForecast[] {
        const weekEnd = new Date(now.getTime() + 7 * 86400000);
        const rowByCommittee = new Map(rows.map(r => [r.CommitteeID, r] as const));
        return data.Meetings
            .filter(m => {
                const start = new Date(m.StartDateTime);
                return start >= now && start <= weekEnd && (m.Status === 'Scheduled' || m.Status === 'Draft');
            })
            .map(m => ({
                MeetingID: m.ID,
                CommitteeID: m.CommitteeID,
                CommitteeName: m.Committee,
                Title: m.Title,
                StartDateTime: new Date(m.StartDateTime),
                EndDateTime: m.EndDateTime ? new Date(m.EndDateTime) : null,
                LocationType: m.LocationType,
                LocationText: m.LocationText,
                VideoProviderName: m.VideoProvider_Virtual,
                Quorum: rowByCommittee.get(m.CommitteeID)?.Quorum
                    ?? { Level: 'None' as QuorumRiskLevel, ExpectedAttendees: 0, Required: 0, VotingMemberCount: 0 },
                AgendaItemCount: agendaCountByMeeting.get(m.ID) ?? 0,
            }));
    }

    private static computeAttention(rows: CommitteeHealthRow[], now: Date): AttentionItem[] {
        const items: AttentionItem[] = [];
        for (const r of rows) {
            if (r.Health === 'Pending' || r.Health === 'Dissolved') continue;
            if (r.Term.Kind === 'NoActiveTerm') {
                items.push({
                    Kind: 'TermLapse', CommitteeID: r.CommitteeID, CommitteeName: r.Name,
                    Title: `${r.Name} has no active term`,
                    Detail: `${r.MemberCount} memberships unanchored`,
                });
            }
            if (r.Minutes.PendingCount > 0) {
                items.push({
                    Kind: 'MinutesPending', CommitteeID: r.CommitteeID, CommitteeName: r.Name,
                    Title: `${r.Name} minutes await approval`,
                    Detail: `Pending ${r.Minutes.OldestPendingDays} days`,
                });
            }
            if (r.Actions.OverdueCount > 0) {
                items.push({
                    Kind: 'OverdueAction', CommitteeID: r.CommitteeID, CommitteeName: r.Name,
                    Title: `${r.Actions.OverdueCount} overdue action${r.Actions.OverdueCount === 1 ? '' : 's'} in ${r.Name}`,
                    Detail: `Oldest ${r.Actions.OldestOverdueDays} days overdue`,
                });
            }
            if (r.Quorum.Level === 'High' && r.NextMeetingAt !== null) {
                items.push({
                    Kind: 'QuorumRisk', CommitteeID: r.CommitteeID, CommitteeName: r.Name,
                    Title: `Quorum at risk for ${r.Name}`,
                    Detail: `Forecast ${r.Quorum.ExpectedAttendees} of ${r.Quorum.Required} required`,
                });
            }
        }
        const severity: Record<AttentionKind, number> = { TermLapse: 0, QuorumRisk: 1, MinutesPending: 2, OverdueAction: 3 };
        items.sort((a, b) => severity[a.Kind] - severity[b.Kind]);
        return items;
    }

    private static computeSummary(
        data: PortfolioData,
        rows: CommitteeHealthRow[],
        thisWeek: UpcomingMeetingForecast[],
        now: Date,
    ): PortfolioSummary {
        const yearStart = new Date(now.getFullYear(), 0, 1);
        const servingPeople = new Set(
            data.Terms.filter(t => t.Status === 'Active')
                .flatMap(t => (groupBy(data.Memberships, m => m.TermID).get(t.ID) ?? []).map(m => m.PersonID))
        );
        const expiring = rows.filter(r =>
            r.Term.DaysRemaining !== null && r.Term.DaysRemaining >= 0 && r.Term.DaysRemaining <= TERM_EXPIRY_WINDOW_DAYS
        );
        const nearest = expiring.length === 0 ? null
            : expiring.reduce((a, b) => ((a.Term.EndDate as Date) <= (b.Term.EndDate as Date) ? a : b)).Term.EndDate;
        const overdue = rows.reduce((sum, r) => sum + r.Actions.OverdueCount, 0);
        const oldestOverdue = rows.reduce((max, r) => Math.max(max, r.Actions.OldestOverdueDays), 0);
        return {
            TotalCommittees: data.Committees.length,
            ActiveCommittees: data.Committees.filter(c => c.Status === 'Active').length,
            NewThisYear: data.Committees.filter(c => new Date(c.__mj_CreatedAt) >= yearStart).length,
            ServingMembers: servingPeople.size,
            TotalSeats: data.Memberships.length,
            TermsExpiringSoon: expiring.length,
            NearestExpiryDate: nearest,
            OverdueActions: overdue,
            OldestOverdueDays: oldestOverdue,
            MeetingsThisWeek: thisWeek.length,
            NeedsAttentionCount: rows.filter(r => r.Health === 'AtRisk' || r.Health === 'Watch').length,
        };
    }
}

export interface PortfolioData {
    Committees: CommitteeRow[];
    Terms: TermRow[];
    Memberships: MembershipRoleRow[];
    Roles: RoleRow[];
    Meetings: MeetingRow[];
    Attendance: AttendanceRow[];
    Minutes: MinuteRow[];
    ActionItems: ActionItemRow[];
    AgendaItems: AgendaItemRow[];
}

/** Health sort: AtRisk → Watch → Healthy → Pending → Dissolved, then by name. */
function sortNeedsAttentionFirst(rows: CommitteeHealthRow[]): void {
    const order: Record<HealthLevel, number> = { AtRisk: 0, Watch: 1, Healthy: 2, Pending: 3, Dissolved: 4 };
    rows.sort((a, b) => order[a.Health] - order[b.Health] || a.Name.localeCompare(b.Name));
}

function endTime(t: TermRow): number {
    return t.EndDate === null ? Number.MAX_SAFE_INTEGER : new Date(t.EndDate).getTime();
}

function groupBy<T>(items: T[], key: (item: T) => string): Map<string, T[]> {
    const map = new Map<string, T[]>();
    for (const item of items) {
        const k = key(item);
        const list = map.get(k);
        if (list) list.push(item);
        else map.set(k, [item]);
    }
    return map;
}

function countBy<T>(items: T[], key: (item: T) => string): Map<string, number> {
    const map = new Map<string, number>();
    for (const item of items) {
        const k = key(item);
        map.set(k, (map.get(k) ?? 0) + 1);
    }
    return map;
}
