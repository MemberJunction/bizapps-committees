import { RunView, UserInfo, LogError } from '@memberjunction/core';
import { AIEngine } from '@memberjunction/aiengine';
import { CompletionWithFallback } from './aiModel.js';

/**
 * AI succession suggestions for People & Terms (UX v2 screen 05).
 *
 * Honesty contract: every number shown to the user (attendance %, roles,
 * committee count) is computed HERE from the record — the LLM receives the
 * evidence as facts and contributes only the fit assessment and rationale,
 * choosing exclusively from the candidate pool we hand it. Suggestions are
 * never persisted; a human acts through the normal roster flow.
 */

export interface SuccessorSuggestion {
    PersonID: string;
    PersonName: string;
    CurrentRoles: string;
    AttendanceRate: number | null;
    CommitteeCount: number;
    Fit: string;
    Rationale: string;
}

export interface SuggestSuccessorsResult {
    Success: boolean;
    ErrorMessage?: string;
    Suggestions: SuccessorSuggestion[];
}

interface CandidateEvidence {
    PersonID: string;
    PersonName: string;
    Roles: string[];              // "Secretary, Technology Standards"
    AttendanceRate: number | null;
    CommitteeCount: number;
}

interface MembershipRow {
    ID: string; TermID: string; PersonID: string; Person: string;
    Role: string; RoleID: string; Status: string; RenewalIntent: string | null;
}
interface TermRow { ID: string; CommitteeID: string; Committee: string; Status: string; StartDate: string; EndDate: string | null; }
interface MeetingRow { ID: string; CommitteeID: string; }
interface AttendanceRow { MeetingID: string; PersonID: string; AttendanceStatus: string; }

const MAX_CANDIDATES = 12;
const MAX_SUGGESTIONS = 3;

export class SuccessionSuggestionService {
    public async GetSuggestions(committeeID: string, contextUser: UserInfo): Promise<SuggestSuccessorsResult> {
        try {
            const evidence = await this.buildEvidence(committeeID, contextUser);
            if (evidence.openings.length === 0) {
                return { Success: true, Suggestions: [] };
            }
            if (evidence.candidates.length === 0) {
                return { Success: true, Suggestions: [] };
            }
            const prompt = this.buildPrompt(evidence);
            const raw = await this.callAI(prompt, contextUser);
            const picks = this.parsePicks(raw);
            const byID = new Map(evidence.candidates.map(c => [c.PersonID.toLowerCase(), c]));
            const suggestions: SuccessorSuggestion[] = [];
            for (const pick of picks.slice(0, MAX_SUGGESTIONS)) {
                const cand = byID.get((pick.PersonID ?? '').toLowerCase());
                if (!cand) continue;   // the LLM may only pick from the pool we provided
                suggestions.push({
                    PersonID: cand.PersonID,
                    PersonName: cand.PersonName,
                    CurrentRoles: cand.Roles.join(' · '),
                    AttendanceRate: cand.AttendanceRate,
                    CommitteeCount: cand.CommitteeCount,
                    Fit: String(pick.Fit ?? '').slice(0, 200),
                    Rationale: String(pick.Rationale ?? '').slice(0, 500),
                });
            }
            return { Success: true, Suggestions: suggestions };
        } catch (err) {
            const message = err instanceof Error ? err.message : String(err);
            LogError(`[SuccessionSuggestionService] ${message}`);
            return { Success: false, ErrorMessage: message, Suggestions: [] };
        }
    }

    // ── Evidence (deterministic) ────────────────────────────────

    private async buildEvidence(committeeID: string, contextUser: UserInfo) {
        const rv = new RunView();
        const [termsR, membershipsR, meetingsR] = await rv.RunViews([
            { EntityName: 'Committees: Terms', Fields: ['ID', 'CommitteeID', 'Committee', 'Status', 'StartDate', 'EndDate'], ResultType: 'simple' },
            { EntityName: 'Committees: Memberships', ExtraFilter: "Status = 'Active'", Fields: ['ID', 'TermID', 'PersonID', 'Person', 'Role', 'RoleID', 'Status', 'RenewalIntent'], ResultType: 'simple' },
            { EntityName: 'Committees: Meetings', ExtraFilter: "Status = 'Completed'", Fields: ['ID', 'CommitteeID'], ResultType: 'simple' },
        ], contextUser);
        const terms = (termsR.Success ? termsR.Results : []) as unknown as TermRow[];
        const memberships = (membershipsR.Success ? membershipsR.Results : []) as unknown as MembershipRow[];
        const meetings = (meetingsR.Success ? meetingsR.Results : []) as unknown as MeetingRow[];

        const termsByID = new Map(terms.map(t => [t.ID.toLowerCase(), t]));
        const committeeName = terms.find(t => t.CommitteeID.toLowerCase() === committeeID.toLowerCase())?.Committee ?? 'the committee';

        // Openings: current roster seats where intent = No (plus lapse note).
        const isTarget = (m: MembershipRow) =>
            termsByID.get(m.TermID.toLowerCase())?.CommitteeID.toLowerCase() === committeeID.toLowerCase();
        const roster = memberships.filter(isTarget);
        const rosterPersonIDs = new Set(roster.map(m => m.PersonID.toLowerCase()));
        const openings = roster
            .filter(m => m.RenewalIntent === 'No')
            .map(m => `${m.Role} (held by ${m.Person}, declining renewal)`);
        if (openings.length === 0 && roster.length === 0) {
            openings.push('Committee has no active roster — all seats open');
        }

        // Candidate pool: active members of OTHER committees, not already on this one.
        const attendance = await this.loadAttendance(meetings.map(m => m.ID), contextUser);
        const rates = this.attendanceRates(attendance);
        const byPerson = new Map<string, CandidateEvidence>();
        for (const m of memberships) {
            if (rosterPersonIDs.has(m.PersonID.toLowerCase())) continue;
            const term = termsByID.get(m.TermID.toLowerCase());
            if (!term) continue;
            const key = m.PersonID.toLowerCase();
            let c = byPerson.get(key);
            if (!c) {
                c = { PersonID: m.PersonID, PersonName: m.Person, Roles: [], AttendanceRate: rates.get(key) ?? null, CommitteeCount: 0 };
                byPerson.set(key, c);
            }
            c.Roles.push(`${m.Role}, ${term.Committee}`);
        }
        for (const c of byPerson.values()) {
            c.CommitteeCount = new Set(c.Roles.map(r => r.split(', ').slice(1).join(', '))).size;
        }
        // Rank: attendance desc (nulls last), then breadth of service.
        const candidates = [...byPerson.values()]
            .sort((a, b) => (b.AttendanceRate ?? -1) - (a.AttendanceRate ?? -1) || b.CommitteeCount - a.CommitteeCount)
            .slice(0, MAX_CANDIDATES);

        return { committeeName, openings, candidates };
    }

    private async loadAttendance(meetingIDs: string[], contextUser: UserInfo): Promise<AttendanceRow[]> {
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

    private attendanceRates(attendance: AttendanceRow[]): Map<string, number> {
        const counts = new Map<string, { present: number; total: number }>();
        for (const a of attendance) {
            const key = a.PersonID.toLowerCase();
            const c = counts.get(key) ?? { present: 0, total: 0 };
            c.total++;
            if (a.AttendanceStatus === 'Present' || a.AttendanceStatus === 'Partial') c.present++;
            counts.set(key, c);
        }
        const rates = new Map<string, number>();
        for (const [k, c] of counts) if (c.total > 0) rates.set(k, c.present / c.total);
        return rates;
    }

    // ── Prompt + parsing ────────────────────────────────────────

    private buildPrompt(evidence: { committeeName: string; openings: string[]; candidates: CandidateEvidence[] }): string {
        const candidateLines = evidence.candidates.map(c =>
            `- PersonID: ${c.PersonID} | ${c.PersonName} | roles: ${c.Roles.join('; ')} | ` +
            `attendance: ${c.AttendanceRate != null ? Math.round(c.AttendanceRate * 100) + '%' : 'no data'} | ` +
            `committees served: ${c.CommitteeCount}`).join('\n');

        return `You are a governance advisor helping fill upcoming committee vacancies.

## COMMITTEE
${evidence.committeeName}

## OPENINGS
${evidence.openings.map(o => `- ${o}`).join('\n')}

## CANDIDATE POOL (the ONLY people you may suggest — facts are authoritative)
${candidateLines}

## TASK
Suggest up to ${MAX_SUGGESTIONS} candidates from the pool above for the openings. Base your reasoning ONLY on
the facts provided (roles, attendance, breadth of service) — do not invent qualifications.

Respond with ONLY a JSON array, no prose:
[{"PersonID": "<exact PersonID from the pool>", "Fit": "<seat/track, e.g. 'Board — Member track'>", "Rationale": "<1-2 sentences citing the provided facts>"}]`;
    }

    private async callAI(prompt: string, contextUser: UserInfo): Promise<string> {
        await AIEngine.Instance.Config(false, contextUser);
        return CompletionWithFallback(prompt, contextUser);
    }

    private parsePicks(raw: string): Array<{ PersonID?: string; Fit?: string; Rationale?: string }> {
        const start = raw.indexOf('[');
        const end = raw.lastIndexOf(']');
        if (start === -1 || end === -1 || end <= start) throw new Error('AI response did not contain a JSON array');
        const parsed: unknown = JSON.parse(raw.slice(start, end + 1));
        if (!Array.isArray(parsed)) throw new Error('AI response was not a JSON array');
        return parsed as Array<{ PersonID?: string; Fit?: string; Rationale?: string }>;
    }
}
