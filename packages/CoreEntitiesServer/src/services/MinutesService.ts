import { Metadata, RunView, UserInfo, LogError } from '@memberjunction/core';
import { AIEngine } from '@memberjunction/aiengine';
import { CompletionWithFallback } from './aiModel.js';
import { assertPublicHttpsTarget } from '../security/ssrf-guard.js';
import { mjBizAppsTasksMeetingEntity } from '@mj-biz-apps/tasks-entities';
import { mjBizAppsCommitteesMinuteEntity } from '@mj-biz-apps/committees-entities';

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

/** Guards IDs that are interpolated into RunView ExtraFilter strings. */
const GUID_PATTERN = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/** Result returned by SaveDraftMinutes. */
export interface MinutesSaveResult {
    Success: boolean;
    ErrorMessage?: string;
    MinuteID: string;
}

/** Read-only shape of an Agenda Item row from a simple RunView query. */
interface AgendaItemRow {
    ID: string;
    Sequence: number;
    Name: string;
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
    Name: string;
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
    meeting: mjBizAppsTasksMeetingEntity;
    committeeName: string;
    agendaItems: AgendaItemRow[];
    motions: MotionRow[];
    attendance: AttendanceRow[];
    storedTranscript: string | null;
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
            if (!GUID_PATTERN.test(meetingID)) {
                return { Success: false, ErrorMessage: 'Invalid meeting ID', MeetingID: meetingID, Content: '' };
            }
            const bundle = await this.loadMeetingBundle(meetingID, contextUser);
            if (!bundle) {
                return {
                    Success: false,
                    ErrorMessage: `Meeting ${meetingID} not found`,
                    MeetingID: meetingID,
                    Content: '',
                };
            }

            const urlToFetch = transcriptURLOverride;
            const transcript = transcriptText ?? bundle.storedTranscript ?? await this.fetchTranscript(urlToFetch);
            const prompt = this.buildPrompt(bundle, transcript);
            const content = await this.callAI(prompt, contextUser);

            return { Success: true, MeetingID: meetingID, Content: content };
        } catch (error) {
            const message = error instanceof Error ? error.message : String(error);
            LogError(`[MinutesService] GenerateDraftMinutes failed for meeting ${meetingID}: ${message}`);
            return { Success: false, ErrorMessage: message, MeetingID: meetingID, Content: '' };
        }
    }

    /**
     * Saves (or updates) a draft Minute record for the given meeting.
     * If a Minute record already exists for the meeting it is overwritten;
     * otherwise a new Draft record is created.
     */
    public async SaveDraftMinutes(
        meetingID: string,
        content: string,
        contextUser: UserInfo
    ): Promise<MinutesSaveResult> {
        try {
            if (!GUID_PATTERN.test(meetingID)) {
                return { Success: false, ErrorMessage: 'Invalid meeting ID', MinuteID: '' };
            }
            const minute = await this.findOrCreateMinute(meetingID, contextUser);
            minute.MeetingID = meetingID;
            minute.Content = content;
            minute.ApprovalStatus = 'Draft';

            const saved = await minute.Save();
            if (!saved) {
                return { Success: false, ErrorMessage: 'Failed to save minute record', MinuteID: '' };
            }
            return { Success: true, MinuteID: minute.ID };
        } catch (error) {
            const message = error instanceof Error ? error.message : String(error);
            LogError(`[MinutesService] SaveDraftMinutes failed for meeting ${meetingID}: ${message}`);
            return { Success: false, ErrorMessage: message, MinuteID: '' };
        }
    }

    /** Finds an existing Draft Minute for the meeting, or creates a new entity object. */
    private async findOrCreateMinute(meetingID: string, contextUser: UserInfo): Promise<mjBizAppsCommitteesMinuteEntity> {
        const rv = new RunView();
        const result = await rv.RunView<mjBizAppsCommitteesMinuteEntity>({
            EntityName: 'Committees: Minutes',
            ExtraFilter: `MeetingID='${meetingID}'`,
            ResultType: 'entity_object',
        }, contextUser);

        if (result.Success && result.Results && result.Results.length > 0) {
            return result.Results[0];
        }

        const md = new Metadata();
        return await md.GetEntityObject<mjBizAppsCommitteesMinuteEntity>('Committees: Minutes', contextUser);
    }

    // -------------------------------------------------------------------------
    // Data loading
    // -------------------------------------------------------------------------

    /** Loads the meeting entity and all related data needed for minute generation. */
    private async loadMeetingBundle(meetingID: string, contextUser: UserInfo): Promise<MeetingBundle | null> {
        const meeting = await this.loadMeeting(meetingID, contextUser);
        if (!meeting) return null;

        const rv = new RunView();
        const [agendaResult, motionResult, attendanceResult, linkResult, noteResult] = await rv.RunViews([
            {
                EntityName: 'MJ_BizApps_Tasks: Meeting Agenda Items',
                ExtraFilter: `MeetingID='${meetingID}'`,
                OrderBy: 'Sequence ASC',
                Fields: ['ID', 'Sequence', 'Name', 'Description', 'Type', 'Status', 'Outcome', 'DurationMinutes'],
                ResultType: 'simple',
            },
            {
                EntityName: 'Committees: Motions',
                ExtraFilter: `MeetingID='${meetingID}'`,
                OrderBy: 'Sequence ASC',
                Fields: ['ID', 'Sequence', 'Name', 'Description', 'Result', 'ResultSummary', 'YesCount', 'NoCount', 'AbstainCount', 'Notes'],
                ResultType: 'simple',
            },
            {
                EntityName: 'MJ_BizApps_Tasks: Meeting Attendees',
                ExtraFilter: `MeetingID='${meetingID}'`,
                Fields: ['ID', 'AttendanceStatus', 'ResponseStatus', 'Person', 'DisplayName'],
                ResultType: 'simple',
            },
            {
                EntityName: 'MJ_BizApps_Tasks: Meeting Links',
                ExtraFilter: `MeetingID='${meetingID}' AND EntityID='A5DA88A1-AA21-4A3F-B1C4-42652FB440CE'`,
                Fields: ['RecordID'],
                MaxRows: 1,
                ResultType: 'simple',
            },
            {
                EntityName: 'MJ_BizApps_Tasks: Meeting Notes',
                ExtraFilter: `MeetingID='${meetingID}' AND Kind IN ('Transcript', 'LiveTranscript')`,
                OrderBy: '__mj_CreatedAt DESC',
                MaxRows: 1,
                Fields: ['Body'],
                ResultType: 'simple',
            },
        ], contextUser);

        let committeeName = '';
        const committeeID = (linkResult.Success ? (linkResult.Results as Array<{ RecordID: string }>)?.[0]?.RecordID : null) ?? null;
        if (committeeID && GUID_PATTERN.test(committeeID)) {
            const comRes = await rv.RunView<{ Name: string }>({
                EntityName: 'Committees: Committees',
                ExtraFilter: `ID='${committeeID}'`,
                Fields: ['Name'],
                MaxRows: 1,
                ResultType: 'simple',
            }, contextUser);
            if (comRes.Success && comRes.Results?.[0]) {
                committeeName = comRes.Results[0].Name;
            }
        }

        const rawAgenda = (agendaResult.Success ? agendaResult.Results ?? [] : []) as Array<{
            ID: string; Sequence: number; Name: string; Description: string | null; Type: string | null; Status: string | null; Outcome: string | null; DurationMinutes: number | null;
        }>;
        const agendaItems: AgendaItemRow[] = rawAgenda.map(a => ({
            ID: a.ID,
            Sequence: a.Sequence,
            Name: a.Name,
            Description: a.Description,
            ItemType: a.Type ?? 'Discussion',
            Status: a.Status ?? 'Done',
            Notes: a.Outcome ?? null,
            DurationMinutes: a.DurationMinutes,
        }));

        const rawAtt = (attendanceResult.Success ? attendanceResult.Results ?? [] : []) as Array<{
            ID: string; AttendanceStatus: string | null; ResponseStatus: string | null; Person: string | null; DisplayName: string | null;
        }>;
        const attendance: AttendanceRow[] = rawAtt.map(a => ({
            ID: a.ID,
            AttendanceStatus: a.AttendanceStatus && a.AttendanceStatus !== 'Unknown' ? a.AttendanceStatus : (a.ResponseStatus === 'Declined' ? 'Excused' : 'Absent'),
            Person: a.Person ?? a.DisplayName ?? 'Attendee',
        }));

        const storedTranscript = (noteResult.Success ? (noteResult.Results as Array<{ Body: string | null }>)?.[0]?.Body : null) ?? null;

        return {
            meeting,
            committeeName,
            agendaItems,
            motions: motionResult.Success ? (motionResult.Results ?? []) as MotionRow[] : [],
            attendance,
            storedTranscript,
        };
    }

    /** Loads a single Meeting entity by ID, returning null if not found. */
    private async loadMeeting(meetingID: string, contextUser: UserInfo): Promise<mjBizAppsTasksMeetingEntity | null> {
        const md = new Metadata();
        const meeting = await md.GetEntityObject<mjBizAppsTasksMeetingEntity>('MJ_BizApps_Tasks: Meetings', contextUser);
        const loaded = await meeting.Load(meetingID);
        return loaded ? meeting : null;
    }

    /**
     * Fetches transcript text from a URL, returning null on fetch failure.
     * SECURITY (SSRF): the URL is caller-supplied (TranscriptURL override or the
     * Meeting.TranscriptURL column), so it is validated against the shared SSRF
     * guard first — a disallowed target (non-https, private/loopback/metadata
     * address) throws a descriptive error rather than being fetched. Redirects
     * are refused so a redirect to an internal address cannot slip past the
     * pre-flight check.
     */
    private async fetchTranscript(url: string | null): Promise<string | null> {
        if (!url) return null;
        await assertPublicHttpsTarget(url, 'transcript URL');
        try {
            const response = await fetch(url, { redirect: 'error' });
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
        const { meeting, committeeName, agendaItems, motions, attendance } = bundle;

        const meetingDate = new Date(meeting.StartsAt).toLocaleDateString('en-US', {
            weekday: 'long', year: 'numeric', month: 'long', day: 'numeric',
        });
        const hasVideo = meeting.VideoProvider && meeting.VideoProvider !== 'None';
        const locationLine = [
            hasVideo ? (meeting.Location ? 'Hybrid' : 'Virtual') : (meeting.Location ? 'InPerson' : null),
            meeting.Location ?? null,
            hasVideo ? `via ${meeting.VideoProvider}` : null,
        ].filter(Boolean).join(' — ');

        const attendanceSection = this.formatAttendanceForPrompt(attendance);
        const agendaSection = this.formatAgendaForPrompt(agendaItems);
        const motionsSection = this.formatMotionsForPrompt(motions);
        const transcriptSection = transcript
            ? `\n\n## MEETING TRANSCRIPT\n${transcript}`
            : '\n\n(No transcript provided — draft minutes from structured data above.)';

        return `You are a professional parliamentary secretary generating official meeting minutes.

## MEETING DATA

**Meeting:** ${meeting.Name}
**Date:** ${meetingDate}
**Committee:** ${committeeName}
**Format:** ${locationLine}

${attendanceSection}

## AGENDA
${agendaSection}

## MOTIONS
${motionsSection}
${transcriptSection}

---

Generate formal, professional meeting minutes in Markdown with this exact structure:
1. # [Meeting Name] — Minutes
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
            const lines = [`${item.Sequence}. **${item.Name}** (${item.ItemType} — ${item.Status})`];
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
            const lines = [`- **${m.Name}** — ${m.Result}${tally ? ` (${tally})` : ''}`];
            if (m.Description) lines.push(`  ${m.Description}`);
            if (m.Notes) lines.push(`  Notes: ${m.Notes}`);
            return lines.join('\n');
        }).join('\n');
    }

    // -------------------------------------------------------------------------
    // AI call
    // -------------------------------------------------------------------------

    /** Initialises the AI engine and runs a completion on the best credentialed model. */
    private async callAI(prompt: string, contextUser: UserInfo): Promise<string> {
        await AIEngine.Instance.Config(false, contextUser);
        return CompletionWithFallback(prompt, contextUser);
    }
}
