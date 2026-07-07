import { RunView, UserInfo } from '@memberjunction/core';

/**
 * Term-clock and succession computation for Phase 3 "Sustain"
 * (UX v2 screen 05 People & Terms, screen 06 Member Home).
 *
 * Everything derives from real columns — Terms, Memberships (incl.
 * RenewalIntent), Roles, Attendance, Meetings. Assembly functions are static
 * and pure with an injected `now`, mirroring CommitteeHealthService.
 */

/** Terms ending within this window flag as "expiring" on the gantt/lens. */
export const EXPIRING_WINDOW_DAYS = 90;
/** Members are asked for renewal intent when their term ends within this window. */
export const INTENT_ASK_WINDOW_DAYS = 120;
/** Attendance below this rate marks a seat "At risk". */
export const AT_RISK_ATTENDANCE = 0.5;
/** Unanswered intent with the term ending within this window is "At risk". */
export const AT_RISK_UNANSWERED_DAYS = 30;

export type RenewalIntentValue = 'Yes' | 'No' | 'Undecided' | null;
export type SeatStatus = 'Opening' | 'AtRisk' | 'Returning' | 'AwaitingAnswer';
export type LensState = 'Lapsed' | 'Expiring' | 'Renewed' | 'Current';

// ── Row shapes (view fields) ────────────────────────────────────

export interface TermRow {
    ID: string; CommitteeID: string; Committee: string; Name: string;
    StartDate: string | Date; EndDate: string | Date | null; Status: string;
}
export interface MembershipRow {
    ID: string; TermID: string; PersonID: string; Person: string;
    RoleID: string; Role: string; Status: string;
    RenewalIntent: RenewalIntentValue;
}
export interface RoleRow { ID: string; Name: string; IsVotingRole: boolean; IsOfficer: boolean; }
export interface AttendanceRow { MeetingID: string; PersonID: string; AttendanceStatus: string; }
export interface CompletedMeetingRow { ID: string; CommitteeID: string; Status: string; StartDateTime: string | Date; }

// ── Output shapes ───────────────────────────────────────────────

/** One bar on a member's gantt track (term-anchored membership). */
export interface GanttBar {
    TermID: string;
    Label: string;
    /** Percent offsets within the axis window [0..100]. */
    LeftPct: number;
    WidthPct: number;
    State: 'past' | 'current' | 'expiring' | 'future';
    RoleName: string;
}

export interface GanttRow {
    PersonID: string;
    PersonName: string;
    RoleName: string;
    Bars: GanttBar[];
    /** Attendance rate over the committee's completed meetings; null = no data. */
    AttendanceRate: number | null;
    RenewalIntent: RenewalIntentValue;
}

/** One half-year column header on the gantt axis. */
export interface GanttBucket { Label: string; }

export interface GanttAxis {
    Start: Date;
    End: Date;
    Buckets: GanttBucket[];
    /** Today line position within the window [0..100]; null when out of range. */
    TodayPct: number | null;
}

export interface LensChip {
    CommitteeID: string;
    CommitteeName: string;
    State: LensState;
    /** Active term end date (null for Lapsed). */
    EndDate: Date | null;
    DaysRemaining: number | null;
    HasStagedNextTerm: boolean;
}

export interface PipelineSeat {
    MembershipID: string;
    PersonID: string;
    PersonName: string;
    RoleName: string;
    Status: SeatStatus;
    Reason: string;
    AttendanceRate: number | null;
    RenewalIntent: RenewalIntentValue;
}

export interface TermClock {
    Axis: GanttAxis;
    Rows: GanttRow[];
    Lens: LensChip[];
    Pipeline: PipelineSeat[];
    /** Committee options for the switcher. */
    Committees: { ID: string; Name: string }[];
}

const DAY_MS = 86_400_000;

export class SuccessionService {
    /**
     * Loads everything People & Terms needs. The gantt/pipeline are scoped to
     * committeeID (defaults to the first committee with an active term); the
     * lens always covers the whole portfolio.
     */
    public async GetTermClock(committeeID: string | null, contextUser?: UserInfo): Promise<TermClock> {
        const rv = new RunView();
        const [terms, memberships, roles, meetings] = await rv.RunViews([
            { EntityName: 'Committees: Terms', Fields: ['ID', 'CommitteeID', 'Committee', 'Name', 'StartDate', 'EndDate', 'Status'], ResultType: 'simple' },
            // Ended memberships stay in: they are the timeline's past-service bars.
            { EntityName: 'Committees: Memberships', ExtraFilter: "Status IN ('Active', 'Ended')", Fields: ['ID', 'TermID', 'PersonID', 'Person', 'RoleID', 'Role', 'Status', 'RenewalIntent'], ResultType: 'simple' },
            { EntityName: 'Committees: Roles', Fields: ['ID', 'Name', 'IsVotingRole', 'IsOfficer'], ResultType: 'simple' },
            { EntityName: 'Committees: Meetings', ExtraFilter: "Status = 'Completed'", Fields: ['ID', 'CommitteeID', 'Status', 'StartDateTime'], ResultType: 'simple' },
        ], contextUser);
        const termRows = (terms.Success ? terms.Results : []) as unknown as TermRow[];
        const membershipRows = (memberships.Success ? memberships.Results : []) as unknown as MembershipRow[];
        const roleRows = (roles.Success ? roles.Results : []) as unknown as RoleRow[];
        const meetingRows = (meetings.Success ? meetings.Results : []) as unknown as CompletedMeetingRow[];

        const attendance = await this.loadAttendance(meetingRows.map(m => m.ID), contextUser);
        return SuccessionService.Compute(termRows, membershipRows, roleRows, meetingRows, attendance, committeeID, new Date());
    }

    private async loadAttendance(meetingIDs: string[], contextUser?: UserInfo): Promise<AttendanceRow[]> {
        if (meetingIDs.length === 0) return [];
        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'Committees: Attendances',
            ExtraFilter: `MeetingID IN (${meetingIDs.map(id => `'${id}'`).join(',')})`,
            Fields: ['MeetingID', 'PersonID', 'AttendanceStatus'],
            ResultType: 'simple',
        }, contextUser);
        return (result.Success ? result.Results : []) as unknown as AttendanceRow[];
    }

    // ── Pure assembly ───────────────────────────────────────────

    public static Compute(
        terms: TermRow[], memberships: MembershipRow[], roles: RoleRow[],
        meetings: CompletedMeetingRow[], attendance: AttendanceRow[],
        committeeID: string | null, now: Date
    ): TermClock {
        const committees = SuccessionService.committeeOptions(terms);
        const selected = committeeID ?? committees[0]?.ID ?? null;
        const lens = SuccessionService.ComputeLens(terms, now);

        if (!selected) {
            return { Axis: SuccessionService.BuildAxis(now, []), Rows: [], Lens: lens, Pipeline: [], Committees: committees };
        }
        const committeeTerms = terms.filter(t => t.CommitteeID.toLowerCase() === selected.toLowerCase());
        const termIDs = new Set(committeeTerms.map(t => t.ID.toLowerCase()));
        const committeeMembers = memberships.filter(m => termIDs.has(m.TermID.toLowerCase()));
        const rates = SuccessionService.ComputeAttendanceRates(
            meetings.filter(m => m.CommitteeID.toLowerCase() === selected.toLowerCase()), attendance);

        const axis = SuccessionService.BuildAxis(now, committeeTerms);
        const rows = SuccessionService.BuildGanttRows(committeeTerms, committeeMembers, rates, axis, now);
        const pipeline = SuccessionService.ComputePipeline(committeeTerms, committeeMembers, rates, now);
        return { Axis: axis, Rows: rows, Lens: lens, Pipeline: pipeline, Committees: committees };
    }

    private static committeeOptions(terms: TermRow[]): { ID: string; Name: string }[] {
        const seen = new Map<string, { ID: string; Name: string }>();
        for (const t of terms) {
            const key = t.CommitteeID.toLowerCase();
            if (!seen.has(key)) seen.set(key, { ID: t.CommitteeID, Name: t.Committee });
        }
        return [...seen.values()].sort((a, b) => a.Name.localeCompare(b.Name));
    }

    /** Portfolio lens: one chip per committee, worst-first. */
    public static ComputeLens(terms: TermRow[], now: Date): LensChip[] {
        const byCommittee = new Map<string, TermRow[]>();
        for (const t of terms) {
            const key = t.CommitteeID.toLowerCase();
            (byCommittee.get(key) ?? byCommittee.set(key, []).get(key)!).push(t);
        }
        const chips: LensChip[] = [];
        for (const group of byCommittee.values()) {
            const active = group.find(t => t.Status === 'Active' && SuccessionService.spansNow(t, now));
            const staged = group.some(t => t.Status === 'Upcoming' || (t.Status === 'Active' && new Date(t.StartDate) > now));
            if (!active) {
                chips.push({
                    CommitteeID: group[0].CommitteeID, CommitteeName: group[0].Committee,
                    State: 'Lapsed', EndDate: null, DaysRemaining: null, HasStagedNextTerm: staged,
                });
                continue;
            }
            const end = active.EndDate ? new Date(active.EndDate) : null;
            const days = end ? Math.ceil((end.getTime() - now.getTime()) / DAY_MS) : null;
            let state: LensState = 'Current';
            if (staged) state = 'Renewed';
            else if (days != null && days <= EXPIRING_WINDOW_DAYS) state = 'Expiring';
            chips.push({
                CommitteeID: active.CommitteeID, CommitteeName: active.Committee,
                State: state, EndDate: end, DaysRemaining: days, HasStagedNextTerm: staged,
            });
        }
        const rank: Record<LensState, number> = { Lapsed: 0, Expiring: 1, Renewed: 2, Current: 3 };
        return chips.sort((a, b) => rank[a.State] - rank[b.State] || (a.DaysRemaining ?? 9e9) - (b.DaysRemaining ?? 9e9));
    }

    private static spansNow(t: TermRow, now: Date): boolean {
        const start = new Date(t.StartDate);
        const end = t.EndDate ? new Date(t.EndDate) : null;
        return start <= now && (end == null || end >= now);
    }

    /**
     * Half-year-bucketed axis covering every term in scope, padded one bucket
     * each side, always including today.
     */
    public static BuildAxis(now: Date, terms: TermRow[]): GanttAxis {
        const dates: Date[] = [now];
        for (const t of terms) {
            dates.push(new Date(t.StartDate));
            if (t.EndDate) dates.push(new Date(t.EndDate));
        }
        const min = new Date(Math.min(...dates.map(d => d.getTime())));
        const max = new Date(Math.max(...dates.map(d => d.getTime())));
        // Snap to half-year boundaries (Jan 1 / Jul 1), one bucket padding.
        const start = SuccessionService.halfYearFloor(min);
        start.setMonth(start.getMonth() - 6);
        const end = SuccessionService.halfYearFloor(max);
        end.setMonth(end.getMonth() + 12); // include max's bucket + one pad

        const buckets: GanttBucket[] = [];
        const cursor = new Date(start);
        while (cursor < end) {
            const h = cursor.getMonth() === 0 ? 'H1' : 'H2';
            buckets.push({ Label: `${h} '${String(cursor.getFullYear()).slice(2)}` });
            cursor.setMonth(cursor.getMonth() + 6);
        }
        const span = end.getTime() - start.getTime();
        const todayPct = now >= start && now <= end
            ? ((now.getTime() - start.getTime()) / span) * 100
            : null;
        return { Start: start, End: end, Buckets: buckets, TodayPct: todayPct };
    }

    private static halfYearFloor(d: Date): Date {
        return new Date(d.getFullYear(), d.getMonth() < 6 ? 0 : 6, 1);
    }

    /** One gantt row per person who has served, bars per term-anchored membership. */
    public static BuildGanttRows(
        terms: TermRow[], memberships: MembershipRow[],
        rates: Map<string, number>, axis: GanttAxis, now: Date
    ): GanttRow[] {
        const termsByID = new Map(terms.map(t => [t.ID.toLowerCase(), t]));
        const span = axis.End.getTime() - axis.Start.getTime();
        const byPerson = new Map<string, GanttRow>();

        for (const m of memberships) {
            const term = termsByID.get(m.TermID.toLowerCase());
            if (!term) continue;
            const tStart = new Date(term.StartDate);
            const tEnd = term.EndDate ? new Date(term.EndDate) : axis.End;
            const leftPct = Math.max(0, ((tStart.getTime() - axis.Start.getTime()) / span) * 100);
            const rightPct = Math.min(100, ((tEnd.getTime() - axis.Start.getTime()) / span) * 100);
            const days = Math.ceil((tEnd.getTime() - now.getTime()) / DAY_MS);
            let state: GanttBar['State'];
            if (tEnd < now) state = 'past';
            else if (tStart > now) state = 'future';
            else if (days <= EXPIRING_WINDOW_DAYS) state = 'expiring';
            else state = 'current';

            const key = m.PersonID.toLowerCase();
            let row = byPerson.get(key);
            if (!row) {
                row = {
                    PersonID: m.PersonID, PersonName: m.Person, RoleName: m.Role,
                    Bars: [], AttendanceRate: rates.get(key) ?? null, RenewalIntent: m.RenewalIntent ?? null,
                };
                byPerson.set(key, row);
            }
            // Current-term role/intent wins the row label.
            if (m.Status === 'Active' && (state === 'current' || state === 'expiring')) {
                row.RoleName = m.Role;
                row.RenewalIntent = m.RenewalIntent ?? null;
            }
            row.Bars.push({
                TermID: term.ID, Label: `${term.Name} · ${m.Role}`,
                LeftPct: leftPct, WidthPct: Math.max(1, rightPct - leftPct), State: state, RoleName: m.Role,
            });
        }
        return [...byPerson.values()].sort((a, b) => a.PersonName.localeCompare(b.PersonName));
    }

    /** Attendance rate per person over the supplied completed meetings. */
    public static ComputeAttendanceRates(meetings: CompletedMeetingRow[], attendance: AttendanceRow[]): Map<string, number> {
        const meetingIDs = new Set(meetings.map(m => m.ID.toLowerCase()));
        const counts = new Map<string, { present: number; total: number }>();
        for (const a of attendance) {
            if (!meetingIDs.has(a.MeetingID.toLowerCase())) continue;
            const key = a.PersonID.toLowerCase();
            const c = counts.get(key) ?? { present: 0, total: 0 };
            c.total++;
            if (a.AttendanceStatus === 'Present' || a.AttendanceStatus === 'Partial') c.present++;
            counts.set(key, c);
        }
        const rates = new Map<string, number>();
        for (const [key, c] of counts) {
            if (c.total > 0) rates.set(key, c.present / c.total);
        }
        return rates;
    }

    /**
     * Vacancy pipeline for the committee's expiring/current seats.
     * Precedence: Opening (intent No) > AtRisk (attendance < 50%, or
     * unanswered with ≤30 days left) > Returning (intent Yes) > AwaitingAnswer.
     */
    public static ComputePipeline(
        terms: TermRow[], memberships: MembershipRow[],
        rates: Map<string, number>, now: Date
    ): PipelineSeat[] {
        const active = terms.filter(t => t.Status === 'Active' && SuccessionService.spansNow(t, now));
        const activeIDs = new Set(active.map(t => t.ID.toLowerCase()));
        const end = active[0]?.EndDate ? new Date(active[0].EndDate!) : null;
        const daysLeft = end ? Math.ceil((end.getTime() - now.getTime()) / DAY_MS) : null;

        const seats: PipelineSeat[] = [];
        for (const m of memberships.filter(m => m.Status === 'Active' && activeIDs.has(m.TermID.toLowerCase()))) {
            const rate = rates.get(m.PersonID.toLowerCase()) ?? null;
            const intent = m.RenewalIntent ?? null;
            let status: SeatStatus;
            let reason: string;
            if (intent === 'No') {
                status = 'Opening';
                reason = 'declining renewal';
            } else if (rate != null && rate < AT_RISK_ATTENDANCE) {
                status = 'AtRisk';
                reason = `${Math.round(rate * 100)}% attendance this term`;
            } else if (intent == null && daysLeft != null && daysLeft <= AT_RISK_UNANSWERED_DAYS) {
                status = 'AtRisk';
                reason = `no answer with ${daysLeft} days left`;
            } else if (intent === 'Yes') {
                status = 'Returning';
                reason = 'confirmed intent to return';
            } else {
                status = 'AwaitingAnswer';
                reason = intent === 'Undecided' ? 'undecided' : 'not yet asked';
            }
            seats.push({
                MembershipID: m.ID, PersonID: m.PersonID, PersonName: m.Person,
                RoleName: m.Role, Status: status, Reason: reason,
                AttendanceRate: rate, RenewalIntent: intent,
            });
        }
        const rank: Record<SeatStatus, number> = { Opening: 0, AtRisk: 1, AwaitingAnswer: 2, Returning: 3 };
        return seats.sort((a, b) => rank[a.Status] - rank[b.Status] || a.PersonName.localeCompare(b.PersonName));
    }
}
