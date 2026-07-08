import { Component, ChangeDetectionStrategy, ChangeDetectorRef, EventEmitter, Input, OnDestroy, OnInit, Output, inject } from '@angular/core';
import { Metadata, RunView } from '@memberjunction/core';
import { GraphQLDataProvider } from '@memberjunction/graphql-dataprovider';
import { BallotService, MotionService, VoteTally, OutcomeForecast } from '@mj-biz-apps/committees-core';
import { CommitteesLookupEngine } from '@mj-biz-apps/committees-core/lookup';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';
import {
    mjBizAppsCommitteesMeetingEntity, mjBizAppsCommitteesAgendaItemEntity,
    mjBizAppsCommitteesMotionEntity, mjBizAppsCommitteesVoteEntity,
    mjBizAppsCommitteesAttendanceEntity, mjBizAppsCommitteesMinuteEntity,
} from '@mj-biz-apps/committees-entities';

interface MeetingRow {
    ID: string; CommitteeID: string; Committee: string; Name: string;
    StartDateTime: Date; EndDateTime: Date | null; TimeZone: string | null;
    LocationType: string | null; LocationText: string | null; Status: string;
}
interface AgendaRow {
    ID: string; ParentAgendaItemID: string | null; Sequence: number; Name: string;
    Description: string | null; PresenterPerson: string | null; DurationMinutes: number | null;
    ItemType: string; RelatedDocumentURL: string | null; Status: string; Notes: string | null;
}
interface MemberRow {
    ID: string; PersonID: string; Person: string; Role: string; RoleID: string; TermID: string;
}
interface RoleRow { ID: string; IsVotingRole: boolean; }
interface TermRow { ID: string; CommitteeID: string; Status: string; }
interface AttendanceRow { ID: string; PersonID: string; Person: string; AttendanceStatus: string; JoinedAt: Date | null; }
interface MotionRowLocal {
    ID: string; AgendaItemID: string | null; Name: string; Description: string | null;
    MovedByMembershipID: string | null; SecondedByMembershipID: string | null;
    Result: string; YesCount: number | null; NoCount: number | null; AbstainCount: number | null;
}
interface VoteRowLocal { ID: string; MotionID: string; MembershipID: string; VoteValue: string; Notes: string | null; }

/** One member line in the live roll call. */
interface RollCallRow {
    MembershipID: string;
    PersonID: string;
    PersonName: string;
    RoleName: string;
    IsVoting: boolean;
    AttendanceStatus: string;
    Vote: string | null;
}

/** A confirmed minutes-rail entry (one per accepted agenda item section). */
interface MinutesEntry { Heading: string; Body: string; Provenance: string; }

/**
 * Live Meeting Mode — UX v2 screen 03. A deliberate full-screen chrome
 * exception: fixed-position overlay entered from the workspace Meetings tab,
 * exited explicitly. Everything on screen is entity writes — attendance,
 * agenda progression, motions, votes, and the minutes draft.
 */
@Component({
    standalone: false,
    selector: 'committees-live-meeting',
    templateUrl: './live-meeting.component.html',
    styleUrls: ['./live-meeting.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class LiveMeetingComponent implements OnInit, OnDestroy {
    private _meetingID: string | null = null;
    @Input()
    set MeetingID(value: string | null) {
        const prev = this._meetingID;
        this._meetingID = value;
        if (value && value !== prev) void this.Load();
    }
    get MeetingID(): string | null { return this._meetingID; }

    @Output() Exited = new EventEmitter<void>();

    IsLoading = true;
    IsActing = false;
    ErrorMessage = '';

    Meeting: MeetingRow | null = null;
    Agenda: AgendaRow[] = [];
    RollCall: RollCallRow[] = [];
    CurrentItemID: string | null = null;
    FloorMotion: MotionRowLocal | null = null;
    MotionVotes = new Map<string, VoteRowLocal>();
    ShowAttendance = false;
    ShowNewMotion = false;

    // New-motion form
    NewMotionTitle = '';
    NewMotionText = '';
    NewMotionMovedBy = '';
    NewMotionSecondedBy = '';

    // Minutes rail
    MinutesEntries: MinutesEntry[] = [];
    DraftText = '';
    IsDraftAI = false;
    IsDrafting = false;
    EditingDraft = false;
    private minuteID: string | null = null;

    ElapsedLabel = '';
    /** When the live session actually began: scheduled start, or now when started early. */
    private liveAnchor: Date | null = null;
    private elapsedTimer: ReturnType<typeof setInterval> | null = null;
    private attendanceByPerson = new Map<string, AttendanceRow>();
    private allMotions: MotionRowLocal[] = [];
    private allVotes: VoteRowLocal[] = [];

    private cdr = inject(ChangeDetectorRef);

    /** Scribe controls are for officers/staff; everyone else observes. */
    CanDrive = false;

    private assertDrive(): boolean {
        if (this.CanDrive) return true;
        this.ErrorMessage = 'Observer mode — only officers and staff can drive the meeting.';
        this.cdr.detectChanges();
        return false;
    }

    async ngOnInit(): Promise<void> {
        const [officer, staff] = await Promise.all([
            CommitteePermissionHelper.IsOfficerInAny(),
            CommitteePermissionHelper.IsStaffUser(),
        ]);
        this.CanDrive = officer || staff;
        if (this._meetingID && this.IsLoading) await this.Load();
        this.elapsedTimer = setInterval(() => { this.updateElapsed(); this.cdr.detectChanges(); }, 1000);
    }

    ngOnDestroy(): void {
        if (this.elapsedTimer) clearInterval(this.elapsedTimer);
    }

    // ── Loading ─────────────────────────────────────────────────

    async Load(): Promise<void> {
        if (!this._meetingID) return;
        this.IsLoading = true;
        this.ErrorMessage = '';
        this.cdr.detectChanges();
        try {
            const rv = new RunView();
            const id = this._meetingID;
            await CommitteesLookupEngine.Instance.Config();
            const [meeting, agenda, attendance, motions, votesRes, terms, memberships, minutes] = await rv.RunViews([
                { EntityName: 'Committees: Meetings', ExtraFilter: `ID = '${id}'`, ResultType: 'simple' },
                { EntityName: 'Committees: Agenda Items', ExtraFilter: `MeetingID = '${id}'`, OrderBy: 'Sequence ASC', ResultType: 'simple' },
                { EntityName: 'Committees: Attendances', ExtraFilter: `MeetingID = '${id}'`, ResultType: 'simple' },
                { EntityName: 'Committees: Motions', ExtraFilter: `MeetingID = '${id}'`, OrderBy: 'Sequence ASC', ResultType: 'simple' },
                { EntityName: 'Committees: Votes', ExtraFilter: `MotionID IN (SELECT ID FROM __mj_BizAppsCommittees.vwMotions WHERE MeetingID = '${id}')`, ResultType: 'simple' },
                { EntityName: 'Committees: Terms', ExtraFilter: "Status = 'Active'", Fields: ['ID', 'CommitteeID', 'Status'], ResultType: 'simple' },
                { EntityName: 'Committees: Memberships', ExtraFilter: "Status = 'Active'", Fields: ['ID', 'PersonID', 'Person', 'Role', 'RoleID', 'TermID'], ResultType: 'simple' },
                { EntityName: 'Committees: Minutes', ExtraFilter: `MeetingID = '${id}'`, ResultType: 'simple' },
            ]);
            this.Meeting = ((meeting.Success ? meeting.Results : []) as unknown as MeetingRow[])[0] ?? null;
            this.Agenda = (agenda.Success ? agenda.Results : []) as unknown as AgendaRow[];
            this.allMotions = (motions.Success ? motions.Results : []) as unknown as MotionRowLocal[];
            this.allVotes = (votesRes.Success ? votesRes.Results : []) as unknown as VoteRowLocal[];
            this.indexAttendance((attendance.Success ? attendance.Results : []) as unknown as AttendanceRow[]);
            this.buildRollCall(
                (terms.Success ? terms.Results : []) as unknown as TermRow[],
                (memberships.Success ? memberships.Results : []) as unknown as MemberRow[],
                // Roles come from the process-wide lookup engine — no per-load query.
                CommitteesLookupEngine.Instance.Roles.map(r => ({ ID: r.ID, IsVotingRole: r.IsVotingRole })));
            this.pickCurrentItem();
            this.refreshFloorMotion();
            this.loadMinutes(((minutes.Success ? minutes.Results : []) as unknown as { ID: string; Content: string | null }[])[0] ?? null);
            this.updateElapsed();
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to load meeting';
        }
        this.IsLoading = false;
        this.cdr.detectChanges();
    }

    private indexAttendance(rows: AttendanceRow[]): void {
        this.attendanceByPerson = new Map(rows.map(a => [a.PersonID.toLowerCase(), a]));
    }

    private buildRollCall(terms: TermRow[], memberships: MemberRow[], roles: RoleRow[]): void {
        if (!this.Meeting) { this.RollCall = []; return; }
        const committeeID = this.Meeting.CommitteeID.toLowerCase();
        const termIDs = new Set(terms.filter(t => t.CommitteeID.toLowerCase() === committeeID).map(t => t.ID.toLowerCase()));
        const votingRoleIDs = new Set(roles.filter(r => r.IsVotingRole).map(r => r.ID.toLowerCase()));
        this.RollCall = memberships
            .filter(m => termIDs.has(m.TermID.toLowerCase()))
            .map(m => ({
                MembershipID: m.ID,
                PersonID: m.PersonID,
                PersonName: m.Person,
                RoleName: m.Role,
                IsVoting: votingRoleIDs.has(m.RoleID.toLowerCase()),
                AttendanceStatus: this.attendanceByPerson.get(m.PersonID.toLowerCase())?.AttendanceStatus ?? 'Expected',
                Vote: null,
            }))
            .sort((a, b) => Number(b.IsVoting) - Number(a.IsVoting) || a.PersonName.localeCompare(b.PersonName));
        this.applyVotesToRollCall();
    }

    private applyVotesToRollCall(): void {
        this.MotionVotes.clear();
        if (this.FloorMotion) {
            for (const v of this.allVotes.filter(v => v.MotionID.toLowerCase() === this.FloorMotion!.ID.toLowerCase())) {
                this.MotionVotes.set(v.MembershipID.toLowerCase(), v);
            }
        }
        for (const row of this.RollCall) {
            row.Vote = this.MotionVotes.get(row.MembershipID.toLowerCase())?.VoteValue ?? null;
        }
    }

    private pickCurrentItem(): void {
        const current = this.Agenda.find(a => a.Status === 'Pending' && !a.ParentAgendaItemID)
            ?? this.Agenda.find(a => a.Status === 'Pending');
        this.CurrentItemID = current?.ID ?? null;
    }

    private refreshFloorMotion(): void {
        const itemID = this.CurrentItemID?.toLowerCase() ?? null;
        this.FloorMotion = this.allMotions.find(m =>
            (itemID != null && m.AgendaItemID?.toLowerCase() === itemID && m.Result === 'Pending'))
            ?? this.allMotions.find(m => m.Result === 'Pending')
            ?? null;
        this.applyVotesToRollCall();
    }

    private loadMinutes(minute: { ID: string; Content: string | null } | null): void {
        this.minuteID = minute?.ID ?? null;
        this.MinutesEntries = minute?.Content ? this.parseSections(minute.Content) : [];
        this.refreshDraftProposal();
    }

    // ── Derived view state ──────────────────────────────────────

    get CurrentItem(): AgendaRow | null {
        return this.Agenda.find(a => a.ID === this.CurrentItemID) ?? null;
    }

    get TopLevelAgenda(): AgendaRow[] { return this.Agenda; }

    get PresentVotingCount(): number {
        return this.RollCall.filter(r => r.IsVoting && (r.AttendanceStatus === 'Present' || r.AttendanceStatus === 'Partial')).length;
    }

    get VotingCount(): number { return this.RollCall.filter(r => r.IsVoting).length; }

    get QuorumRequired(): number { return Math.floor(this.VotingCount / 2) + 1; }

    get HasQuorum(): boolean { return this.VotingCount > 0 && this.PresentVotingCount >= this.QuorumRequired; }

    get VotingRollCall(): RollCallRow[] { return this.RollCall.filter(r => r.IsVoting); }

    get NonVotingRollCall(): RollCallRow[] { return this.RollCall.filter(r => !r.IsVoting); }

    get Tally(): VoteTally {
        const votes = [...this.MotionVotes.values()];
        const eligible = this.RollCall.filter(r => r.IsVoting && r.AttendanceStatus !== 'Excused' && r.AttendanceStatus !== 'Absent').length;
        return BallotService.ComputeTally(votes, eligible);
    }

    get Forecast(): OutcomeForecast {
        return BallotService.ForecastOutcome(this.Tally, 'SimpleMajority', 'VotesCast', this.Tally.Cast + this.Tally.Outstanding);
    }

    get TallyYesPct(): number {
        const total = this.Tally.Cast + this.Tally.Outstanding;
        return total > 0 ? (this.Tally.Yes / total) * 100 : 0;
    }

    get TallyNoPct(): number {
        const total = this.Tally.Cast + this.Tally.Outstanding;
        return total > 0 ? (this.Tally.No / total) * 100 : 0;
    }

    get ThresholdPct(): number {
        const total = this.Tally.Cast + this.Tally.Outstanding;
        return total > 0 ? (this.Forecast.RequiredYes / total) * 100 : 50;
    }

    get IsInProgress(): boolean { return this.Meeting?.Status === 'InProgress'; }

    MemberName(membershipID: string | null): string | null {
        if (!membershipID) return null;
        return this.RollCall.find(r => r.MembershipID.toLowerCase() === membershipID.toLowerCase())?.PersonName ?? null;
    }

    ItemTypeClass(itemType: string): string {
        switch (itemType) {
            case 'Vote': case 'Action': return 'vote';
            case 'Report': return 'report';
            default: return 'discussion';
        }
    }

    private updateElapsed(): void {
        if (!this.Meeting || !this.IsInProgress) { this.ElapsedLabel = ''; return; }
        if (!this.liveAnchor) {
            // Session already InProgress when loaded: anchor at the scheduled
            // start, unless that's still in the future (started early).
            const scheduled = new Date(this.Meeting.StartDateTime).getTime();
            this.liveAnchor = new Date(Math.min(scheduled, Date.now()));
        }
        const ms = Date.now() - this.liveAnchor.getTime();
        if (ms < 0) { this.ElapsedLabel = '0:00'; return; }
        const totalMin = Math.floor(ms / 60000);
        const h = Math.floor(totalMin / 60);
        const m = totalMin % 60;
        this.ElapsedLabel = h > 0 ? `${h}:${String(m).padStart(2, '0')}` : `${m}:${String(Math.floor((ms % 60000) / 1000)).padStart(2, '0')}`;
    }

    // ── Meeting lifecycle ───────────────────────────────────────

    async OnStartMeeting(): Promise<void> {
        if (!this.assertDrive()) return;
        await this.saveMeetingStatus('InProgress');
        if (this.IsInProgress) this.liveAnchor = new Date();
    }

    async OnEndMeeting(): Promise<void> {
        if (!this.assertDrive()) return;
        await this.saveMeetingStatus('Completed');
        this.Exited.emit();
    }

    OnExit(): void { this.Exited.emit(); }

    private async saveMeetingStatus(status: string): Promise<void> {
        if (!this.Meeting || this.IsActing) return;
        this.IsActing = true;
        try {
            const md = new Metadata();
            const meeting = await md.GetEntityObject<mjBizAppsCommitteesMeetingEntity>('Committees: Meetings');
            if (!await meeting.Load(this.Meeting.ID)) throw new Error('Meeting not found');
            meeting.Status = status as mjBizAppsCommitteesMeetingEntity['Status'];
            if (!await meeting.Save()) throw new Error(meeting.LatestResult?.Message ?? 'Status change failed');
            this.Meeting = { ...this.Meeting, Status: status };
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to update meeting';
        }
        this.IsActing = false;
        this.cdr.detectChanges();
    }

    // ── Agenda progression ──────────────────────────────────────

    SelectItem(item: AgendaRow): void {
        this.CurrentItemID = item.ID;
        this.refreshFloorMotion();
        this.refreshDraftProposal();
        this.cdr.detectChanges();
    }

    async CompleteCurrentItem(): Promise<void> { await this.setItemStatus('Completed', true); }
    async SkipCurrentItem(): Promise<void> { await this.setItemStatus('Skipped', true); }
    async TableCurrentItem(): Promise<void> { await this.setItemStatus('Tabled', true); }

    private async setItemStatus(status: string, advance: boolean): Promise<void> {
        const item = this.CurrentItem;
        if (!item || this.IsActing) return;
        this.IsActing = true;
        try {
            const md = new Metadata();
            const entity = await md.GetEntityObject<mjBizAppsCommitteesAgendaItemEntity>('Committees: Agenda Items');
            if (!await entity.Load(item.ID)) throw new Error('Agenda item not found');
            entity.Status = status as mjBizAppsCommitteesAgendaItemEntity['Status'];
            if (!await entity.Save()) throw new Error(entity.LatestResult?.Message ?? 'Agenda update failed');
            item.Status = status;
            if (advance) { this.pickCurrentItem(); this.refreshFloorMotion(); this.refreshDraftProposal(); }
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to update agenda item';
        }
        this.IsActing = false;
        this.cdr.detectChanges();
    }

    // ── Motions & voting ────────────────────────────────────────

    async OnCreateMotion(): Promise<void> {
        if (!this.assertDrive()) return;
        if (!this.Meeting || !this.NewMotionTitle.trim() || this.IsActing) return;
        this.IsActing = true;
        try {
            const md = new Metadata();
            const motion = await md.GetEntityObject<mjBizAppsCommitteesMotionEntity>('Committees: Motions');
            motion.MeetingID = this.Meeting.ID;
            if (this.CurrentItemID) motion.AgendaItemID = this.CurrentItemID;
            motion.Name = this.NewMotionTitle.trim();
            if (this.NewMotionText.trim()) motion.Description = this.NewMotionText.trim();
            if (this.NewMotionMovedBy) motion.MovedByMembershipID = this.NewMotionMovedBy;
            if (this.NewMotionSecondedBy) motion.SecondedByMembershipID = this.NewMotionSecondedBy;
            motion.Result = 'Pending';
            if (!await motion.Save()) throw new Error(motion.LatestResult?.Message ?? 'Motion create failed');
            this.allMotions.push({
                ID: motion.ID, AgendaItemID: this.CurrentItemID, Name: motion.Name,
                Description: motion.Description ?? null,
                MovedByMembershipID: this.NewMotionMovedBy || null,
                SecondedByMembershipID: this.NewMotionSecondedBy || null,
                Result: 'Pending', YesCount: null, NoCount: null, AbstainCount: null,
            });
            this.ShowNewMotion = false;
            this.NewMotionTitle = this.NewMotionText = this.NewMotionMovedBy = this.NewMotionSecondedBy = '';
            this.refreshFloorMotion();
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to create motion';
        }
        this.IsActing = false;
        this.cdr.detectChanges();
    }

    async OnCastVote(row: RollCallRow, value: 'Yes' | 'No' | 'Abstain'): Promise<void> {
        if (!this.assertDrive()) return;
        if (!this.FloorMotion || this.IsActing || this.FloorMotion.Result !== 'Pending') return;
        this.IsActing = true;
        try {
            const md = new Metadata();
            const existing = this.MotionVotes.get(row.MembershipID.toLowerCase());
            const vote = await md.GetEntityObject<mjBizAppsCommitteesVoteEntity>('Committees: Votes');
            if (existing) {
                if (!await vote.Load(existing.ID)) throw new Error('Vote not found');
            } else {
                vote.MotionID = this.FloorMotion.ID;
                vote.MembershipID = row.MembershipID;
            }
            vote.VoteValue = value;
            if (!await vote.Save()) throw new Error(vote.LatestResult?.Message ?? 'Vote failed');
            const record: VoteRowLocal = { ID: vote.ID, MotionID: this.FloorMotion.ID, MembershipID: row.MembershipID, VoteValue: value, Notes: null };
            this.allVotes = this.allVotes.filter(v => v.ID !== record.ID).concat(record);
            this.applyVotesToRollCall();
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to record vote';
        }
        this.IsActing = false;
        this.cdr.detectChanges();
    }

    async OnRecordResult(): Promise<void> {
        if (!this.assertDrive()) return;
        if (!this.FloorMotion || this.IsActing) return;
        this.IsActing = true;
        try {
            const tally = this.Tally;
            const outcome = BallotService.ForecastOutcome({ ...tally, Outstanding: 0 }, 'SimpleMajority', 'VotesCast', tally.Cast);
            const result = outcome.Outcome === 'Passed' ? 'Passed' : 'Failed';
            const md = new Metadata();
            const motion = await md.GetEntityObject<mjBizAppsCommitteesMotionEntity>('Committees: Motions');
            if (!await motion.Load(this.FloorMotion.ID)) throw new Error('Motion not found');
            motion.Result = result;
            motion.YesCount = tally.Yes;
            motion.NoCount = tally.No;
            motion.AbstainCount = tally.Abstain;
            motion.ResultSummary = `${result} ${tally.Yes}-${tally.No}-${tally.Abstain} by roll call`;
            if (!await motion.Save()) throw new Error(motion.LatestResult?.Message ?? 'Record failed');
            this.FloorMotion = { ...this.FloorMotion, Result: result, YesCount: tally.Yes, NoCount: tally.No, AbstainCount: tally.Abstain };
            const idx = this.allMotions.findIndex(m => m.ID === this.FloorMotion!.ID);
            if (idx >= 0) this.allMotions[idx] = this.FloorMotion;
            this.refreshDraftProposal();
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to record result';
        }
        this.IsActing = false;
        this.cdr.detectChanges();
    }

    // ── Attendance ──────────────────────────────────────────────

    async OnSetAttendance(row: RollCallRow, status: 'Present' | 'Absent' | 'Excused'): Promise<void> {
        if (!this.assertDrive()) return;
        if (!this.Meeting || this.IsActing) return;
        this.IsActing = true;
        try {
            const md = new Metadata();
            const existing = this.attendanceByPerson.get(row.PersonID.toLowerCase());
            const att = await md.GetEntityObject<mjBizAppsCommitteesAttendanceEntity>('Committees: Attendances');
            if (existing) {
                if (!await att.Load(existing.ID)) throw new Error('Attendance not found');
            } else {
                att.MeetingID = this.Meeting.ID;
                att.PersonID = row.PersonID;
            }
            att.AttendanceStatus = status;
            if (status === 'Present' && !att.JoinedAt) att.JoinedAt = new Date();
            if (!await att.Save()) throw new Error(att.LatestResult?.Message ?? 'Attendance failed');
            this.attendanceByPerson.set(row.PersonID.toLowerCase(), {
                ID: att.ID, PersonID: row.PersonID, Person: row.PersonName,
                AttendanceStatus: status, JoinedAt: att.JoinedAt ?? null,
            });
            row.AttendanceStatus = status;
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to set attendance';
        }
        this.IsActing = false;
        this.cdr.detectChanges();
    }

    // ── Minutes rail ────────────────────────────────────────────

    private parseSections(content: string): MinutesEntry[] {
        const entries: MinutesEntry[] = [];
        const parts = content.split(/^## /m).filter(p => p.trim().length > 0);
        for (const part of parts) {
            const lines = part.split('\n');
            const heading = lines[0].trim();
            const provLine = lines.find(l => l.trim().startsWith('_') && l.includes('·'));
            const body = lines.slice(1).filter(l => l !== provLine).join('\n').trim();
            entries.push({ Heading: heading, Body: body, Provenance: provLine?.replace(/^_+|_+$/g, '').trim() ?? '' });
        }
        return entries;
    }

    /** Compose the provisional draft for the current item from the recorded facts. */
    private refreshDraftProposal(): void {
        const item = this.CurrentItem;
        if (!item) { this.DraftText = ''; return; }
        const parts: string[] = [];
        if (item.PresenterPerson) parts.push(`${item.PresenterPerson} presented.`);
        if (item.Description) parts.push(item.Description);
        const itemMotions = this.allMotions.filter(m => m.AgendaItemID?.toLowerCase() === item.ID.toLowerCase());
        for (const m of itemMotions) {
            const moved = this.MemberName(m.MovedByMembershipID);
            const seconded = this.MemberName(m.SecondedByMembershipID);
            let line = `Motion: ${m.Name}.`;
            if (moved) line += ` Moved by ${moved}${seconded ? `, seconded by ${seconded}` : ''}.`;
            if (m.Result !== 'Pending') line += ` ${m.Result} ${m.YesCount ?? 0}-${m.NoCount ?? 0}-${m.AbstainCount ?? 0}.`;
            else line += ' Vote in progress.';
            parts.push(line);
        }
        this.DraftText = parts.join(' ');
        this.IsDraftAI = false;
    }

    async OnGenerateAIDraft(): Promise<void> {
        if (!this.assertDrive()) return;
        if (!this.Meeting || this.IsDrafting) return;
        this.IsDrafting = true;
        this.cdr.detectChanges();
        try {
            const facts = this.composeFactsTranscript();
            const query = `mutation GenerateMeetingMinutes($input: GenerateMinutesInput!) {
                GenerateMeetingMinutes(input: $input) { Success ErrorMessage Content }
            }`;
            const result = await GraphQLDataProvider.Instance.ExecuteGQL(query, { input: { MeetingID: this.Meeting.ID, Transcript: facts } });
            const payload = result?.GenerateMeetingMinutes;
            if (!payload?.Success) throw new Error(payload?.ErrorMessage ?? 'AI drafting failed');
            this.DraftText = payload.Content;
            this.IsDraftAI = true;
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'AI drafting failed';
        }
        this.IsDrafting = false;
        this.cdr.detectChanges();
    }

    /** The recorded facts, serialized for the AI drafter. */
    private composeFactsTranscript(): string {
        const lines: string[] = [];
        for (const item of this.Agenda) {
            lines.push(`Agenda item ${item.Sequence}: ${item.Name} [${item.ItemType}] — status ${item.Status}.`);
            if (item.PresenterPerson) lines.push(`  Presenter: ${item.PresenterPerson}`);
            for (const m of this.allMotions.filter(m => m.AgendaItemID?.toLowerCase() === item.ID.toLowerCase())) {
                lines.push(`  Motion: ${m.Name} — ${m.Result}${m.YesCount != null ? ` ${m.YesCount}-${m.NoCount}-${m.AbstainCount}` : ''}`);
            }
        }
        const present = this.RollCall.filter(r => r.AttendanceStatus === 'Present').map(r => r.PersonName);
        if (present.length > 0) lines.push(`Present: ${present.join(', ')}`);
        return lines.join('\n');
    }

    async OnAcceptDraft(): Promise<void> {
        if (!this.assertDrive()) return;
        const item = this.CurrentItem;
        if (!item || !this.DraftText.trim() || !this.Meeting || this.IsActing) return;
        this.IsActing = true;
        try {
            const md = new Metadata();
            const minute = await md.GetEntityObject<mjBizAppsCommitteesMinuteEntity>('Committees: Minutes');
            if (this.minuteID) {
                if (!await minute.Load(this.minuteID)) throw new Error('Minute not found');
            } else {
                minute.MeetingID = this.Meeting.ID;
                minute.ApprovalStatus = 'Draft';
            }
            const u = new Metadata().CurrentUser;
            // Name is often the login email — prefer the human display name
            const user = [u?.FirstName, u?.LastName].filter(Boolean).join(' ') || u?.Name || 'Secretary';
            const stamp = new Date().toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' });
            const provenance = this.IsDraftAI
                ? `Drafted by AI · Confirmed by ${user}, ${stamp}`
                : `Drafted from meeting record · Confirmed by ${user}, ${stamp}`;
            const section = `## ${item.Sequence} · ${item.Name}\n${this.DraftText.trim()}\n_${provenance}_\n`;
            minute.Content = (minute.Content ? minute.Content + '\n' : '') + section;
            if (!await minute.Save()) throw new Error(minute.LatestResult?.Message ?? 'Minutes save failed');
            this.minuteID = minute.ID;
            this.MinutesEntries.push({ Heading: `${item.Sequence} · ${item.Name}`, Body: this.DraftText.trim(), Provenance: provenance });
            this.DraftText = '';
            this.EditingDraft = false;
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to save minutes section';
        }
        this.IsActing = false;
        this.cdr.detectChanges();
    }

    OnDismissDraft(): void {
        this.DraftText = '';
        this.EditingDraft = false;
        this.IsDraftAI = false;
        this.cdr.detectChanges();
    }
}

export function LoadLiveMeeting(): void { }
