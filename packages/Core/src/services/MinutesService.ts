import { Metadata, RunView, UserInfo, LogError } from '@memberjunction/core';
import { AIEngine } from '@memberjunction/aiengine';
import {
    mjCommitteesMeetingEntity,
} from '@mj-biz-apps/committees-entities';

/**
 * Result returned by GenerateDraftMinutes. Content is Markdown-formatted
 * meeting minutes suitable for display and editing in the UI.
 */
export interface MinutesDraftResult {
    Success: boolean;
    ErrorMessage?: string;
    MeetingID: string;
    Content: string;
}

/** Read-only shape of an Agenda Item row from a simple RunView query. */
interface AgendaItemRow {
    ID: string;
    Sequence: number;
    Title: string;
    Description: string | null;
    ItemType: string;
    Status: string;
    Notes: string | null;
    DurationMinutes: number | null;
}

/** Read-only shape of a Motion row from a simple RunView query. */
interface MotionRow {
    ID: string;
    Sequence: number;
    Title: string;
    Description: string | null;
    Result: string;
    ResultSummary: string | null;
    YesCount: number | null;
    NoCount: number | null;
    AbstainCount: number | null;
    Notes: string | null;
}

/** Read-only shape of an Attendance row from a simple RunView query. */
interface AttendanceRow {
    ID: string;
    AttendanceStatus: string;
    Person: string;
}

/** Aggregated meeting data used to build the AI prompt. */
interface MeetingBundle {
    meeting: mjCommitteesMeetingEntity;
    agendaItems: AgendaItemRow[];
    motions: MotionRow[];
    attendance: AttendanceRow[];
}

/**
 * Service for generating AI-drafted meeting minutes from structured meeting
 * data and an optional transcript. Returns Markdown content ready for display
 * in the UI; the caller is responsible for persisting the draft.
 */
export class MinutesService {
    /**
     * Generates a Markdown draft of meeting minutes for the given meeting.
     * If transcriptText is null, the service attempts to fetch it from
     * Meeting.TranscriptURL. If neither is available, the AI drafts minutes
     * from the structured meeting data alone.
     */
    public async GenerateDraftMinutes(
        meetingID: string,
        transcriptText: string | null,
        contextUser: UserInfo,
        transcriptURLOverride: string | null = null
    ): Promise<MinutesDraftResult> {
        try {
            const bundle = await this.loadMeetingBundle(meetingID, contextUser);
            if (!bundle) {
                return {
                    Success: false,
                    ErrorMessage: `Meeting ${meetingID} not found`,
                    MeetingID: meetingID,
                    Content: '',
                };
            }

            const urlToFetch = transcriptURLOverride ?? bundle.meeting.TranscriptURL;
            const transcript = transcriptText ?? await this.fetchTranscript(urlToFetch);
            const prompt = this.buildPrompt(bundle, transcript);
            const content = await this.callAI(prompt, contextUser);

            return { Success: true, MeetingID: meetingID, Content: content };
        } catch (error) {
            const message = error instanceof Error ? error.message : String(error);
            LogError(`[MinutesService] GenerateDraftMinutes failed for meeting ${meetingID}: ${message}`);
            return { Success: false, ErrorMessage: message, MeetingID: meetingID, Content: '' };
        }
    }

    // -------------------------------------------------------------------------
    // Data loading
    // -------------------------------------------------------------------------

    /** Loads the meeting entity and all related data needed for minute generation. */
    private async loadMeetingBundle(meetingID: string, contextUser: UserInfo): Promise<MeetingBundle | null> {
        const meeting = await this.loadMeeting(meetingID, contextUser);
        if (!meeting) return null;

        const rv = new RunView();
        const [agendaResult, motionResult, attendanceResult] = await rv.RunViews([
            {
                EntityName: 'Agenda Items',
                ExtraFilter: `MeetingID='${meetingID}'`,
                OrderBy: 'Sequence ASC',
                Fields: ['ID', 'Sequence', 'Title', 'Description', 'ItemType', 'Status', 'Notes', 'DurationMinutes'],
                ResultType: 'simple',
            },
            {
                EntityName: 'Motions',
                ExtraFilter: `MeetingID='${meetingID}'`,
                OrderBy: 'Sequence ASC',
                Fields: ['ID', 'Sequence', 'Title', 'Description', 'Result', 'ResultSummary', 'YesCount', 'NoCount', 'AbstainCount', 'Notes'],
                ResultType: 'simple',
            },
            {
                EntityName: 'Attendances',
                ExtraFilter: `MeetingID='${meetingID}'`,
                Fields: ['ID', 'AttendanceStatus', 'Person'],
                ResultType: 'simple',
            },
        ], contextUser);

        return {
            meeting,
            agendaItems: agendaResult.Success ? (agendaResult.Results ?? []) as AgendaItemRow[] : [],
            motions: motionResult.Success ? (motionResult.Results ?? []) as MotionRow[] : [],
            attendance: attendanceResult.Success ? (attendanceResult.Results ?? []) as AttendanceRow[] : [],
        };
    }

    /** Loads a single Meeting entity by ID, returning null if not found. */
    private async loadMeeting(meetingID: string, contextUser: UserInfo): Promise<mjCommitteesMeetingEntity | null> {
        const md = new Metadata();
        const meeting = await md.GetEntityObject<mjCommitteesMeetingEntity>('Meetings', contextUser);
        const loaded = await meeting.Load(meetingID);
        return loaded ? meeting : null;
    }

    /** Fetches transcript text from a URL, returning null on failure. */
    private async fetchTranscript(url: string | null): Promise<string | null> {
        if (!url) return null;
        try {
            const response = await fetch(url);
            if (!response.ok) {
                LogError(`[MinutesService] Failed to fetch transcript from ${url}: HTTP ${response.status}`);
                return null;
            }
            return await response.text();
        } catch (error) {
            const message = error instanceof Error ? error.message : String(error);
            LogError(`[MinutesService] Transcript fetch error: ${message}`);
            return null;
        }
    }

    // -------------------------------------------------------------------------
    // Prompt construction
    // -------------------------------------------------------------------------

    /** Assembles the full AI prompt from meeting bundle and optional transcript. */
    private buildPrompt(bundle: MeetingBundle, transcript: string | null): string {
        const { meeting, agendaItems, motions, attendance } = bundle;

        const meetingDate = new Date(meeting.StartDateTime).toLocaleDateString('en-US', {
            weekday: 'long', year: 'numeric', month: 'long', day: 'numeric',
        });
        const locationLine = [
            meeting.LocationType,
            meeting.LocationText ?? null,
            meeting.VideoProvider ? `via ${meeting.VideoProvider}` : null,
        ].filter(Boolean).join(' — ');

        const attendanceSection = this.formatAttendanceForPrompt(attendance);
        const agendaSection = this.formatAgendaForPrompt(agendaItems);
        const motionsSection = this.formatMotionsForPrompt(motions);
        const transcriptSection = transcript
            ? `\n\n## MEETING TRANSCRIPT\n${transcript}`
            : '\n\n(No transcript provided — draft minutes from structured data above.)';

        return `You are a professional parliamentary secretary generating official meeting minutes.

## MEETING DATA

**Meeting:** ${meeting.Title}
**Date:** ${meetingDate}
**Committee:** ${meeting.Committee ?? ''}
**Format:** ${locationLine}

${attendanceSection}

## AGENDA
${agendaSection}

## MOTIONS
${motionsSection}
${transcriptSection}

---

Generate formal, professional meeting minutes in Markdown with this exact structure:
1. # [Meeting Title] — Minutes
2. ## Meeting Details
3. ## Attendance
4. ## Agenda Items (one ### subsection per agenda item with a brief discussion summary)
5. ## Motions & Votes
6. ## Action Items (tasks assigned or mentioned; omit section if none)
7. ## Adjournment

Be concise and factual. Use passive voice appropriate for formal minutes. If a transcript is provided, extract key decisions, action items, and discussion points from it. Do not include verbatim dialogue.`;
    }

    private formatAttendanceForPrompt(rows: AttendanceRow[]): string {
        const present = rows.filter(r => r.AttendanceStatus === 'Present').map(r => r.Person);
        const absent = rows
            .filter(r => r.AttendanceStatus === 'Absent' || r.AttendanceStatus === 'Excused')
            .map(r => r.Person);

        return [
            `**Members Present (${present.length}):** ${present.length ? present.join(', ') : 'None recorded'}`,
            `**Members Absent/Excused:** ${absent.length ? absent.join(', ') : 'None'}`,
        ].join('\n');
    }

    private formatAgendaForPrompt(items: AgendaItemRow[]): string {
        if (!items.length) return '(No agenda items recorded)';
        return items.map(item => {
            const lines = [`${item.Sequence}. **${item.Title}** (${item.ItemType} — ${item.Status})`];
            if (item.Description) lines.push(`   ${item.Description}`);
            if (item.Notes) lines.push(`   Discussion notes: ${item.Notes}`);
            return lines.join('\n');
        }).join('\n\n');
    }

    private formatMotionsForPrompt(motions: MotionRow[]): string {
        if (!motions.length) return '(No motions recorded)';
        return motions.map(m => {
            const tally = m.ResultSummary
                ? m.ResultSummary
                : m.YesCount != null ? `${m.YesCount} Yes / ${m.NoCount} No / ${m.AbstainCount} Abstain` : '';
            const lines = [`- **${m.Title}** — ${m.Result}${tally ? ` (${tally})` : ''}`];
            if (m.Description) lines.push(`  ${m.Description}`);
            if (m.Notes) lines.push(`  Notes: ${m.Notes}`);
            return lines.join('\n');
        }).join('\n');
    }

    // -------------------------------------------------------------------------
    // AI call
    // -------------------------------------------------------------------------

    /** Initialises the AI engine and runs a completion using an Anthropic model. */
    private async callAI(prompt: string, contextUser: UserInfo): Promise<string> {
        await AIEngine.Instance.Config(false, contextUser);
        const model = this.findAnthropicModel();
        const result = await AIEngine.Instance.SimpleLLMCompletion(prompt, contextUser, undefined, model ?? undefined);
        if (!result) throw new Error('AI engine returned an empty response');
        return result;
    }

    /**
     * Finds the highest-power Anthropic language model from the AI engine's
     * loaded model list. Matches on the Vendor name or DriverClass/APIName
     * containing "anthropic" or "claude". Returns null if none found, in which
     * case the AI engine picks the default model.
     */
    private findAnthropicModel() {
        const isAnthropic = (value: string | null | undefined): boolean => {
            const lower = (value ?? '').toLowerCase();
            return lower.includes('anthropic') || lower.includes('claude');
        };

        return AIEngine.Instance.LanguageModels
            .filter(m =>
                isAnthropic(m.Get('Vendor') as string) ||
                isAnthropic(m.Get('DriverClass') as string) ||
                isAnthropic(m.Get('APIName') as string)
            )
            .sort((a, b) => ((b.Get('PowerRank') as number) ?? 0) - ((a.Get('PowerRank') as number) ?? 0))[0] ?? null;
    }
}
