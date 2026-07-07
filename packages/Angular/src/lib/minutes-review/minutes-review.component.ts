import { Component, ChangeDetectionStrategy, ChangeDetectorRef, EventEmitter, Input, OnInit, Output, inject } from '@angular/core';
import { Metadata, RunView } from '@memberjunction/core';
import { GraphQLDataProvider } from '@memberjunction/graphql-dataprovider';
import { mjBizAppsCommitteesMinuteEntity } from '@mj-biz-apps/committees-entities';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';

interface MeetingRow {
    ID: string; Name: string; Committee: string; StartDateTime: Date; Status: string;
}
interface MinuteRow {
    ID: string; MeetingID: string; Content: string | null; ApprovalStatus: string;
    ApprovedAt: Date | null; ApprovedByMeeting: string | null; ArtifactID: string | null; Artifact: string | null;
}

/** One reviewable section parsed from Minute.Content. */
export interface MinutesSection {
    Heading: string;
    Body: string;
    /** Provenance line ("Drafted by AI · Confirmed by …"); empty = provisional. */
    Provenance: string;
    /** True when a human confirmation is recorded in the provenance. */
    IsConfirmed: boolean;
}

/**
 * Minutes Review & Approval — UX v2 screen 07.
 * AI/record-drafted minutes through human review to the approved record.
 * Full-screen focus surface entered from a meeting; exited explicitly.
 */
@Component({
    standalone: false,
    selector: 'committees-minutes-review',
    templateUrl: './minutes-review.component.html',
    styleUrls: ['./minutes-review.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class MinutesReviewComponent implements OnInit {
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
    IsDrafting = false;
    ErrorMessage = '';

    Meeting: MeetingRow | null = null;
    Minute: MinuteRow | null = null;
    Sections: MinutesSection[] = [];
    AttendanceCount = 0;

    /** Secretary (edit) vs Member (read-only) lens. */
    ViewAs: 'secretary' | 'member' = 'member';
    CanEdit = false;
    EditingIndex: number | null = null;
    EditText = '';

    private cdr = inject(ChangeDetectorRef);

    async ngOnInit(): Promise<void> {
        if (this._meetingID && this.IsLoading) await this.Load();
    }

    // ── Loading ─────────────────────────────────────────────────

    async Load(): Promise<void> {
        if (!this._meetingID) return;
        this.IsLoading = true;
        this.ErrorMessage = '';
        this.cdr.detectChanges();
        try {
            const rv = new RunView();
            const [meeting, minutes, attendance] = await rv.RunViews([
                { EntityName: 'Committees: Meetings', ExtraFilter: `ID = '${this._meetingID}'`, Fields: ['ID', 'Name', 'Committee', 'StartDateTime', 'Status'], ResultType: 'simple' },
                { EntityName: 'Committees: Minutes', ExtraFilter: `MeetingID = '${this._meetingID}'`, ResultType: 'simple' },
                { EntityName: 'Committees: Attendances', ExtraFilter: `MeetingID = '${this._meetingID}' AND AttendanceStatus IN ('Present','Partial')`, Fields: ['ID'], ResultType: 'simple' },
            ]);
            this.Meeting = ((meeting.Success ? meeting.Results : []) as unknown as MeetingRow[])[0] ?? null;
            this.Minute = ((minutes.Success ? minutes.Results : []) as unknown as MinuteRow[])[0] ?? null;
            this.AttendanceCount = attendance.Success ? attendance.Results.length : 0;
            this.Sections = this.Minute?.Content ? MinutesReviewComponent.ParseSections(this.Minute.Content) : [];
            const [isOfficer, isStaff] = await Promise.all([
                CommitteePermissionHelper.IsOfficerInAny(),
                CommitteePermissionHelper.IsStaffUser(),
            ]);
            this.CanEdit = (isOfficer || isStaff) && !this.IsLocked;
            this.ViewAs = this.CanEdit ? 'secretary' : 'member';
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to load minutes';
        }
        this.IsLoading = false;
        this.cdr.detectChanges();
    }

    /** Parses '## Heading\nbody…\n_provenance_' sections; whole doc fallback. */
    public static ParseSections(content: string): MinutesSection[] {
        const parts = content.split(/^## /m).filter(p => p.trim().length > 0);
        if (parts.length === 0) return [];
        // Content that never used section markers renders as one un-headed section.
        if (!content.trimStart().startsWith('## ') && parts.length === 1) {
            return [{ Heading: '', Body: content.trim(), Provenance: '', IsConfirmed: false }];
        }
        return parts.map(part => {
            const lines = part.split('\n');
            const heading = lines[0].trim();
            const provLine = lines.find(l => l.trim().startsWith('_') && l.trim().endsWith('_'));
            const body = lines.slice(1).filter(l => l !== provLine).join('\n').trim();
            const provenance = provLine ? provLine.trim().replace(/^_+|_+$/g, '') : '';
            return { Heading: heading, Body: body, Provenance: provenance, IsConfirmed: /confirmed/i.test(provenance) };
        });
    }

    /** Re-serializes sections into Minute.Content (inverse of ParseSections). */
    private serializeSections(): string {
        return this.Sections.map(s => {
            const prov = s.Provenance ? `\n_${s.Provenance}_` : '';
            return s.Heading ? `## ${s.Heading}\n${s.Body}${prov}\n` : `${s.Body}${prov}\n`;
        }).join('\n');
    }

    // ── Derived state ───────────────────────────────────────────

    get IsSecretaryView(): boolean { return this.ViewAs === 'secretary' && this.CanEdit; }

    get IsLocked(): boolean { return this.Minute?.ApprovalStatus === 'Approved'; }

    get UnconfirmedCount(): number { return this.Sections.filter(s => !s.IsConfirmed).length; }

    get StatusBadgeTone(): string {
        switch (this.Minute?.ApprovalStatus) {
            case 'Approved': return 'success';
            case 'PendingApproval': return 'warning';
            case 'Rejected': return 'error';
            default: return 'neutral';
        }
    }

    /** Workflow step state: 0=Drafted 1=PendingApproval 2=Approved */
    StepState(step: number): 'done' | 'now' | 'todo' {
        const order = ['Draft', 'PendingApproval', 'Approved'];
        const current = order.indexOf(this.Minute?.ApprovalStatus ?? 'Draft');
        if (step < current) return 'done';
        if (step === current) return this.Minute?.ApprovalStatus === 'Approved' ? 'done' : 'now';
        return 'todo';
    }

    OnExit(): void { this.Exited.emit(); }

    // ── Section editing (Secretary) ─────────────────────────────

    StartEdit(index: number): void {
        this.EditingIndex = index;
        this.EditText = this.Sections[index].Body;
        this.cdr.detectChanges();
    }

    CancelEdit(): void {
        this.EditingIndex = null;
        this.EditText = '';
        this.cdr.detectChanges();
    }

    async SaveEdit(index: number): Promise<void> {
        const section = this.Sections[index];
        section.Body = this.EditText.trim();
        section.Provenance = this.stampProvenance(section.Provenance || 'Drafted by AI', true);
        section.IsConfirmed = true;
        await this.persistContent();
        this.EditingIndex = null;
        this.EditText = '';
        this.cdr.detectChanges();
    }

    async AcceptSection(index: number): Promise<void> {
        const section = this.Sections[index];
        section.Provenance = this.stampProvenance(section.Provenance || 'Drafted by AI', false);
        section.IsConfirmed = true;
        await this.persistContent();
        this.cdr.detectChanges();
    }

    private stampProvenance(base: string, edited: boolean): string {
        const user = new Metadata().CurrentUser?.Name ?? 'Secretary';
        const when = new Date().toLocaleDateString([], { month: 'short', day: 'numeric', year: 'numeric' });
        const origin = base.split('·')[0].trim();
        return `${origin} · ${edited ? 'Edited & confirmed' : 'Confirmed'} by ${user} — ${when}`;
    }

    private async persistContent(): Promise<void> {
        if (!this.Minute || this.IsActing) return;
        this.IsActing = true;
        try {
            const md = new Metadata();
            const minute = await md.GetEntityObject<mjBizAppsCommitteesMinuteEntity>('Committees: Minutes');
            if (!await minute.Load(this.Minute.ID)) throw new Error('Minute not found');
            minute.Content = this.serializeSections();
            if (!await minute.Save()) throw new Error(minute.LatestResult?.Message ?? 'Save failed');
            this.Minute.Content = minute.Content;
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to save minutes';
        }
        this.IsActing = false;
    }

    // ── Lifecycle actions ───────────────────────────────────────

    async OnGenerateAIDraft(): Promise<void> {
        if (!this._meetingID || this.IsDrafting) return;
        this.IsDrafting = true;
        this.cdr.detectChanges();
        try {
            const query = `mutation GenerateMeetingMinutes($input: GenerateMinutesInput!) {
                GenerateMeetingMinutes(input: $input) { Success ErrorMessage Content }
            }`;
            const result = await GraphQLDataProvider.Instance.ExecuteGQL(query, { input: { MeetingID: this._meetingID } });
            const payload = result?.GenerateMeetingMinutes;
            if (!payload?.Success) throw new Error(payload?.ErrorMessage ?? 'AI drafting failed');
            await this.ensureMinuteWithContent(payload.Content);
            await this.Load();
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'AI drafting failed';
            this.IsDrafting = false;
            this.cdr.detectChanges();
            return;
        }
        this.IsDrafting = false;
        this.cdr.detectChanges();
    }

    private async ensureMinuteWithContent(content: string): Promise<void> {
        const md = new Metadata();
        const minute = await md.GetEntityObject<mjBizAppsCommitteesMinuteEntity>('Committees: Minutes');
        if (this.Minute) {
            if (!await minute.Load(this.Minute.ID)) throw new Error('Minute not found');
        } else {
            minute.MeetingID = this._meetingID!;
            minute.ApprovalStatus = 'Draft';
        }
        minute.Content = content;
        if (!await minute.Save()) throw new Error(minute.LatestResult?.Message ?? 'Save failed');
    }

    async OnFinalize(): Promise<void> { await this.setStatus('PendingApproval'); }

    /** Formal approval: stamps ApprovedAt and locks the document. */
    async OnApprove(): Promise<void> { await this.setStatus('Approved'); }

    private async setStatus(status: string): Promise<void> {
        if (!this.Minute || this.IsActing) return;
        this.IsActing = true;
        this.cdr.detectChanges();
        try {
            const md = new Metadata();
            const minute = await md.GetEntityObject<mjBizAppsCommitteesMinuteEntity>('Committees: Minutes');
            if (!await minute.Load(this.Minute.ID)) throw new Error('Minute not found');
            minute.ApprovalStatus = status as mjBizAppsCommitteesMinuteEntity['ApprovalStatus'];
            if (status === 'Approved') minute.ApprovedAt = new Date();
            if (!await minute.Save()) throw new Error(minute.LatestResult?.Message ?? 'Save failed');
            await this.Load();
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to update status';
        }
        this.IsActing = false;
        this.cdr.detectChanges();
    }
}

export function LoadMinutesReview(): void { }
