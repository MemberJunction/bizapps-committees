import { RunView, UserInfo } from '@memberjunction/core';
import { CommitteesLookupEngine } from '../engines/CommitteesLookupEngine.js';
import { MembershipRow, RenewalIntentValue, RoleRow, TermRow } from './SuccessionService';

/**
 * Planning math for the Term-Renewal Wizard (Phase 4 feature 1).
 *
 * The service computes the *plan* — suggested next term and the roster
 * carry-over derived from renewal intents — as pure static functions with an
 * injected `now`, mirroring SuccessionService. The wizard component owns the
 * writes; nothing here mutates data.
 */

/** A lapse longer than this starts the suggested term today instead of
 *  backdating to the day after the previous term ended. */
export const BACKDATE_LIMIT_DAYS = 180;

const DAY_MS = 86_400_000;

export type CarryDecision = 'carry' | 'carry-unconfirmed' | 'drop';

export interface TermSuggestion {
    Name: string;
    StartDate: Date;
    EndDate: Date;
    Status: 'Active' | 'Upcoming';
}

/** One roster row in the carry-over step, pre-decided from renewal intent. */
export interface CarryRow {
    MembershipID: string;
    PersonID: string;
    PersonName: string;
    RoleID: string;
    RoleName: string;
    Intent: RenewalIntentValue;
    Decision: CarryDecision;
    /** Why the default was chosen — shown as the row's evidence line. */
    Reason: string;
}

/** Everything the wizard needs to open for a committee. */
export interface RenewalContext {
    CommitteeID: string;
    CommitteeName: string;
    /** Most recently ended (or ending) term; null for a brand-new committee. */
    PreviousTerm: TermRow | null;
    /** All existing term names for the committee — the duplicate-name guard. */
    ExistingTermNames: string[];
    /** True while the previous term still spans today (early renewal). */
    PreviousTermStillActive: boolean;
    Suggestion: TermSuggestion;
    Rows: CarryRow[];
    Roles: RoleRow[];
}

export class TermRenewalService {
    /** Loads terms/memberships/roles and assembles the wizard's opening state. */
    public async GetRenewalContext(committeeID: string, contextUser?: UserInfo, now: Date = new Date()): Promise<RenewalContext> {
        await CommitteesLookupEngine.Instance.Config(false, contextUser);
        const rv = new RunView();
        const termsR = await rv.RunView({
            EntityName: 'Committees: Terms',
            ExtraFilter: `CommitteeID = '${committeeID}'`,
            Fields: ['ID', 'CommitteeID', 'Committee', 'Name', 'StartDate', 'EndDate', 'Status'],
            ResultType: 'simple',
        }, contextUser);
        const terms = (termsR.Success ? termsR.Results : []) as unknown as TermRow[];
        // Roles come from the process-wide lookup engine — no per-call query.
        const roles: RoleRow[] = [...CommitteesLookupEngine.Instance.Roles]
            .sort((a, b) => (a.Sequence ?? 0) - (b.Sequence ?? 0))
            .map(r => ({ ID: r.ID, Name: r.Name, IsVotingRole: r.IsVotingRole, IsOfficer: r.IsOfficer }));

        const previous = TermRenewalService.PickPreviousTerm(terms, now);
        const rows = previous ? await this.loadCarryRows(previous.ID, contextUser) : [];

        return {
            CommitteeID: committeeID,
            CommitteeName: terms[0]?.Committee ?? '',
            PreviousTerm: previous,
            ExistingTermNames: terms.map(t => t.Name),
            PreviousTermStillActive: previous != null && TermRenewalService.spansNow(previous, now),
            Suggestion: TermRenewalService.SuggestNextTerm(previous, now),
            Rows: TermRenewalService.BuildCarryPlan(rows),
            Roles: roles,
        };
    }

    private async loadCarryRows(termID: string, contextUser?: UserInfo): Promise<MembershipRow[]> {
        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'Committees: Memberships',
            ExtraFilter: `TermID = '${termID}' AND Status IN ('Active', 'Ended', 'Suspended')`,
            Fields: ['ID', 'TermID', 'PersonID', 'Person', 'RoleID', 'Role', 'Status', 'RenewalIntent'],
            OrderBy: 'Person ASC',
            ResultType: 'simple',
        }, contextUser);
        return (result.Success ? result.Results : []) as unknown as MembershipRow[];
    }

    // ── Pure planning math ──────────────────────────────────────

    /** The term the renewal continues from: the latest by EndDate (nulls treated
     *  as far-future), preferring ones that have started. */
    public static PickPreviousTerm(terms: TermRow[], now: Date): TermRow | null {
        const started = terms.filter(t => new Date(t.StartDate) <= now);
        const pool = started.length > 0 ? started : terms;
        return [...pool].sort((a, b) => TermRenewalService.endTime(b) - TermRenewalService.endTime(a))[0] ?? null;
    }

    public static SuggestNextTerm(previous: TermRow | null, now: Date): TermSuggestion {
        if (!previous || !previous.EndDate) {
            const start = TermRenewalService.dateOnly(now);
            const end = TermRenewalService.addYears(start, 1);
            return { Name: TermRenewalService.spanName(start, end), StartDate: start, EndDate: end, Status: 'Active' };
        }

        const prevStart = TermRenewalService.dateOnly(new Date(previous.StartDate));
        const prevEnd = TermRenewalService.dateOnly(new Date(previous.EndDate));
        let start = new Date(prevEnd.getTime() + DAY_MS);
        if ((now.getTime() - prevEnd.getTime()) / DAY_MS > BACKDATE_LIMIT_DAYS) {
            start = TermRenewalService.dateOnly(now);
        }
        const durationMs = Math.max(prevEnd.getTime() - prevStart.getTime(), DAY_MS);
        const end = new Date(start.getTime() + durationMs);
        return {
            Name: TermRenewalService.NextName(previous.Name, start, end),
            StartDate: start,
            EndDate: end,
            Status: start <= now ? 'Active' : 'Upcoming',
        };
    }

    /** Infers the next term's name: the previous name supplies the FORMAT, the
     *  suggested dates supply the years — so a committee that lapsed with a
     *  stale name ("2025 H1" renewed in 2026) still gets a date-true name. */
    public static NextName(previousName: string, start: Date, end: Date): string {
        const range = previousName.match(/^(\d{4})\s*-\s*(\d{4})$/);
        if (range) return TermRenewalService.spanName(start, end);

        const half = previousName.match(/^(\d{4})\s+H([12])$/i);
        if (half) {
            const nextHalf = half[2] === '1' ? 2 : 1;
            const startYear = start.getUTCFullYear();
            const year = nextHalf === 2 ? startYear : (start.getUTCMonth() < 6 ? startYear : startYear + 1);
            return `${year} H${nextHalf}`;
        }

        const single = previousName.match(/^(.*?)(\d{4})(.*)$/);
        if (single) return `${single[1]}${Number(single[2]) + 1}${single[3]}`;

        return TermRenewalService.spanName(start, end);
    }

    /** Intent → default decision. Carry unless the member said No; anything
     *  short of an explicit Yes is flagged unconfirmed. Suspended members
     *  default to drop regardless of intent. */
    public static BuildCarryPlan(memberships: MembershipRow[]): CarryRow[] {
        return memberships.map(m => {
            let decision: CarryDecision;
            let reason: string;
            if (m.Status === 'Suspended') {
                decision = 'drop';
                reason = 'Suspended on the previous term';
            } else if (m.RenewalIntent === 'No') {
                decision = 'drop';
                reason = 'Declined renewal';
            } else if (m.RenewalIntent === 'Yes') {
                decision = 'carry';
                reason = 'Confirmed intent to return';
            } else {
                decision = 'carry-unconfirmed';
                reason = m.RenewalIntent === 'Undecided' ? 'Answered: undecided' : 'Never asked';
            }
            return {
                MembershipID: m.ID,
                PersonID: m.PersonID,
                PersonName: m.Person,
                RoleID: m.RoleID,
                RoleName: m.Role,
                Intent: m.RenewalIntent ?? null,
                Decision: decision,
                Reason: reason,
            };
        });
    }

    // ── Small date helpers ──────────────────────────────────────

    private static endTime(t: TermRow): number {
        return t.EndDate ? new Date(t.EndDate).getTime() : Number.MAX_SAFE_INTEGER;
    }

    private static spansNow(t: TermRow, now: Date): boolean {
        return new Date(t.StartDate) <= now && (!t.EndDate || new Date(t.EndDate) >= now);
    }

    private static dateOnly(d: Date): Date {
        return new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate()));
    }

    private static addYears(d: Date, years: number): Date {
        return new Date(Date.UTC(d.getUTCFullYear() + years, d.getUTCMonth(), d.getUTCDate()));
    }

    private static spanName(start: Date, end: Date): string {
        const s = start.getUTCFullYear();
        const e = end.getUTCFullYear();
        return s === e ? `${s}` : `${s}-${e}`;
    }
}
