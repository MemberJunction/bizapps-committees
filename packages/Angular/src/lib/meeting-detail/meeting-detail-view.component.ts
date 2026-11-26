import {
    Component, Input, Output, EventEmitter, OnInit,
    ChangeDetectionStrategy, ChangeDetectorRef, inject, SecurityContext
} from '@angular/core';
import { DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { RunView, Metadata, UserInfo } from '@memberjunction/core';
import { mjBizAppsCommitteesMeetingEntity } from '@mj-biz-apps/committees-entities';
import {
    BridgeLegacyMinuteResult,
    CommitteeArtifactBridgeInput,
    MinuteApprovalStatus,
    MinuteArtifactBridgeService,
    PinApprovedMinuteVersionResult,
    ResolvedCommitteeArtifact,
    ResolvedMinuteDocument,
} from '@mj-biz-apps/committees-core';
import { marked } from 'marked';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';
import { OpenExternalUrl } from '../shared/open-external-url';
import { NormalizeValidUuid } from '../minutes/minute-dual-read.model';

interface MeetingRow {
    ID: string;
    CommitteeID: string | null;
    Name: string;
    StartDateTime: Date;
    EndDateTime: Date | null;
    Committee: string | null;
    Status: string;
    LocationType: string | null;
    Location: string | null;
    VideoProvider: string | null;
    TranscriptURL: string | null;
}

interface AttendanceRow {
    ID: string;
    Person: string;
    AttendanceStatus: string;
}

interface AgendaRow {
    ID: string;
    Sequence: number;
    Name: string;
    ItemType: string;
    Status: string;
    Notes: string | null;
    DurationMinutes: number | null;
}

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
}

interface MinuteRow {
    ID: string;
    MeetingID: string | null;
    Content: string | null;
    ApprovalStatus: MinuteApprovalStatus;
    ApprovedAt: Date | string | null;
    ApprovedByMeetingID: string | null;
    MJArtifactID: string | null;
    ApprovedArtifactVersionID: string | null;
}

interface DetailBatchResult<T> {
    Success: boolean;
    Results: T[];
}

@Component({
    standalone: false,
    selector: 'meeting-detail-view',
    templateUrl: './meeting-detail-view.component.html',
    styleUrls: ['../shared/design-system.css', './meeting-detail-view.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class MeetingDetailViewComponent implements OnInit {
    @Input() MeetingID!: string;
    @Output() BackToList = new EventEmitter<void>();

    IsLoading = true;
    Meeting: MeetingRow | null = null;
    Attendance: AttendanceRow[] = [];
    AgendaItems: AgendaRow[] = [];
    Motions: MotionRow[] = [];
    Minute: MinuteRow | null = null;
    ResolvedMinute: ResolvedMinuteDocument | null = null;
    ResolvedArtifacts: ResolvedCommitteeArtifact[] = [];
    PreviewArtifact: ResolvedCommitteeArtifact | null = null;

    IsOfficer = false;
    ShowMinutesPanel = false;
    IsMarkingCompleted = false;
    /** Live Meeting Mode overlay (UX v2 screen 03). */
    ShowLiveMeeting = false;
    /** Minutes Review overlay (UX v2 screen 07). */
    ShowMinutesReview = false;
    ActiveSection: 'overview' | 'agenda' | 'motions' | 'minutes' | 'artifacts' = 'overview';

    private readonly cdr = inject(ChangeDetectorRef);
    private readonly sanitizer = inject(DomSanitizer);
    private readonly bridgeService = new MinuteArtifactBridgeService();

    async ngOnInit(): Promise<void> {
        await Promise.all([this.loadData(), this.loadPermissions()]);
        this.IsLoading = false;
        this.cdr.markForCheck();
    }

    get PresentMembers(): AttendanceRow[] {
        return this.Attendance.filter(a => a.AttendanceStatus === 'Present');
    }

    get PassedMotionsCount(): number {
        return this.Motions.filter(m => m.Result === 'Passed').length;
    }

    get AbsentMembers(): AttendanceRow[] {
        return this.Attendance.filter(a =>
            a.AttendanceStatus === 'Absent' || a.AttendanceStatus === 'Excused'
        );
    }

    get RenderedMinutes(): SafeHtml {
        if (!this.Minute?.Content) return '';
        const html = marked.parse(this.Minute.Content) as string;
        const safe = this.sanitizer.sanitize(SecurityContext.HTML, html) ?? '';
        return this.sanitizer.bypassSecurityTrustHtml(safe);
    }

    get FormattedDate(): string {
        if (!this.Meeting) return '';
        return new Date(this.Meeting.StartDateTime).toLocaleDateString('en-US', {
            weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
        });
    }

    get FormattedTime(): string {
        if (!this.Meeting) return '';
        const start = new Date(this.Meeting.StartDateTime).toLocaleTimeString('en-US', {
            hour: 'numeric', minute: '2-digit'
        });
        if (!this.Meeting.EndDateTime) return start;
        const end = new Date(this.Meeting.EndDateTime).toLocaleTimeString('en-US', {
            hour: 'numeric', minute: '2-digit'
        });
        return `${start} – ${end}`;
    }

    GetMotionResultClass(result: string): string {
        switch (result) {
            case 'Passed': return 'result-passed';
            case 'Failed': return 'result-failed';
            case 'Tabled': return 'result-tabled';
            default: return 'result-pending';
        }
    }

    GetAgendaStatusClass(status: string): string {
        switch (status) {
            case 'Completed': return 'agenda-completed';
            case 'Tabled': return 'agenda-tabled';
            case 'Skipped': return 'agenda-skipped';
            default: return 'agenda-discussed';
        }
    }

    OnMinutesPanelClose(): void {
        this.ShowMinutesPanel = false;
        void this.reloadMinutes();
        this.cdr.markForCheck();
    }

    async OnMinuteBridged(_result: BridgeLegacyMinuteResult): Promise<void> {
        await this.reloadMinutes();
    }

    async OnVersionPinned(_result: PinApprovedMinuteVersionResult): Promise<void> {
        await this.reloadMinutes();
    }

    OnPreviewArtifact(artifact: ResolvedCommitteeArtifact): void {
        this.PreviewArtifact = artifact;
        this.cdr.markForCheck();
    }

    OnCloseArtifactPreview(): void {
        this.PreviewArtifact = null;
        this.cdr.markForCheck();
    }

    OnOpenExternalArtifact(url: string): void {
        OpenExternalUrl(url);
    }

    /** Exit from Minutes Review — reload so approval status reflects edits. */
    async OnMinutesReviewExited(): Promise<void> {
        this.ShowMinutesReview = false;
        await this.loadData();
        this.cdr.markForCheck();
    }

    /** Exit from Live Meeting Mode — reload so statuses reflect the session. */
    async OnLiveMeetingExited(): Promise<void> {
        this.ShowLiveMeeting = false;
        await this.loadData();
        this.cdr.markForCheck();
    }

    async OnMarkAsCompleted(): Promise<void> {
        if (!this.Meeting || this.IsMarkingCompleted) return;
        this.IsMarkingCompleted = true;
        this.cdr.markForCheck();
        try {
            const md = new Metadata();
            const entity = await md.GetEntityObject<mjBizAppsCommitteesMeetingEntity>('Committees: Meetings');
            await entity.Load(this.Meeting.ID);
            entity.Status = 'Completed';
            const saved = await entity.Save();
            if (saved) {
                this.Meeting = { ...this.Meeting, Status: 'Completed' };
            }
        } finally {
            this.IsMarkingCompleted = false;
            this.cdr.markForCheck();
        }
    }

    OnBack(): void {
        this.BackToList.emit();
    }

    private async loadPermissions(): Promise<void> {
        const md = new Metadata();
        const user = md.CurrentUser as UserInfo;
        if (user) {
            const [isOfficer, isStaff] = await Promise.all([
                CommitteePermissionHelper.IsOfficerInAny(),
                CommitteePermissionHelper.IsStaffUser()
            ]);
            this.IsOfficer = isOfficer || isStaff;
        }
    }

    /** Prep tense: staff/officers build the agenda while the meeting is Scheduled. */
    get ShowAgendaBuilder(): boolean {
        return this.Meeting?.Status === 'Scheduled' && this.IsOfficer;
    }

    async OnAgendaChanged(): Promise<void> {
        await this.loadData();
        this.cdr.detectChanges();
    }

    private async loadData(): Promise<void> {
        const meetingId = NormalizeValidUuid(this.MeetingID);
        if (!meetingId) {
            this.resetDetailState();
            return;
        }
        const rv = new RunView();
        const [meetingResult, attendanceResult, agendaResult, motionResult, minuteResult, artifactResult] =
            await rv.RunViews(this.buildDetailQueries(meetingId));
        const rawArtifacts = this.applyDetailResults(
            meetingResult as DetailBatchResult<MeetingRow>,
            attendanceResult as DetailBatchResult<AttendanceRow>,
            agendaResult as DetailBatchResult<AgendaRow>,
            motionResult as DetailBatchResult<MotionRow>,
            minuteResult as DetailBatchResult<MinuteRow>,
            artifactResult as DetailBatchResult<CommitteeArtifactBridgeInput>
        );
        await this.resolveArtifactLinkedRecords(rawArtifacts);
    }

    private resetDetailState(): void {
        this.Meeting = null;
        this.Attendance = [];
        this.AgendaItems = [];
        this.Motions = [];
        this.Minute = null;
        this.ResolvedMinute = null;
        this.ResolvedArtifacts = [];
        this.PreviewArtifact = null;
    }

    /** All per-meeting reads collapsed into one RunViews round trip. */
    private buildDetailQueries(meetingId: string): Parameters<RunView['RunViews']>[0] {
        return [
            {
                EntityName: 'Committees: Meetings',
                ExtraFilter: `ID='${meetingId}'`,
                Fields: ['ID', 'CommitteeID', 'Name', 'StartDateTime', 'EndDateTime', 'Committee', 'Status',
                         'LocationType', 'Location', 'VideoProvider', 'TranscriptURL'],
                ResultType: 'simple',
            },
            {
                EntityName: 'Committees: Attendances',
                ExtraFilter: `MeetingID='${meetingId}'`,
                Fields: ['ID', 'Person', 'AttendanceStatus'],
                ResultType: 'simple',
            },
            {
                EntityName: 'Committees: Agenda Items',
                ExtraFilter: `MeetingID='${meetingId}'`,
                OrderBy: 'Sequence ASC',
                Fields: ['ID', 'Sequence', 'Name', 'ItemType', 'Status', 'Notes', 'DurationMinutes'],
                ResultType: 'simple',
            },
            {
                EntityName: 'Committees: Motions',
                ExtraFilter: `MeetingID='${meetingId}'`,
                OrderBy: 'Sequence ASC',
                Fields: ['ID', 'Sequence', 'Name', 'Description', 'Result', 'ResultSummary',
                         'YesCount', 'NoCount', 'AbstainCount'],
                ResultType: 'simple',
            },
            {
                EntityName: 'Committees: Minutes',
                ExtraFilter: `MeetingID='${meetingId}'`,
                Fields: [
                    'ID', 'MeetingID', 'Content', 'ApprovalStatus', 'ApprovedAt',
                    'ApprovedByMeetingID', 'MJArtifactID', 'ApprovedArtifactVersionID',
                ],
                ResultType: 'simple',
            },
            {
                EntityName: 'Committees: Artifacts',
                ExtraFilter: `MeetingID='${meetingId}'`,
                Fields: [
                    'ID', 'Name', 'Description', 'CommitteeID', 'MeetingID', 'AgendaItemID',
                    'TaskID', 'ArtifactTypeID', 'Provider', 'ExternalID', 'URL', 'MimeType',
                    'FileSize', 'MJArtifactID',
                ],
                OrderBy: 'Name ASC',
                ResultType: 'simple',
            },
        ];
    }

    private applyDetailResults(
        meetingResult: DetailBatchResult<MeetingRow>,
        attendanceResult: DetailBatchResult<AttendanceRow>,
        agendaResult: DetailBatchResult<AgendaRow>,
        motionResult: DetailBatchResult<MotionRow>,
        minuteResult: DetailBatchResult<MinuteRow>,
        artifactResult: DetailBatchResult<CommitteeArtifactBridgeInput>
    ): CommitteeArtifactBridgeInput[] {
        if (meetingResult.Success && meetingResult.Results?.length) {
            this.Meeting = meetingResult.Results[0];
        }
        if (attendanceResult.Success) this.Attendance = attendanceResult.Results ?? [];
        if (agendaResult.Success) this.AgendaItems = agendaResult.Results ?? [];
        if (motionResult.Success) this.Motions = motionResult.Results ?? [];
        this.Minute = minuteResult.Success && minuteResult.Results?.length ? minuteResult.Results[0] : null;
        return artifactResult.Success ? (artifactResult.Results ?? []) : [];
    }

    private async resolveArtifactLinkedRecords(rawArtifacts: CommitteeArtifactBridgeInput[]): Promise<void> {
        const artifactIds: Array<string | null> = [
            this.Minute?.MJArtifactID ?? null,
            ...rawArtifacts.map((item) => item.MJArtifactID),
        ];
        const pinnedIds: Array<string | null> = [this.Minute?.ApprovedArtifactVersionID ?? null];
        const bundle = await this.bridgeService.LoadArtifactBundles(artifactIds, pinnedIds);
        this.ResolvedMinute = this.Minute
            ? MinuteArtifactBridgeService.ResolveMinuteDocument(this.Minute, bundle)
            : null;
        this.ResolvedArtifacts = rawArtifacts.map((item) =>
            MinuteArtifactBridgeService.ClassifyCommitteeArtifact(item, bundle)
        );
    }

    private async reloadMinutes(): Promise<void> {
        const meetingId = NormalizeValidUuid(this.MeetingID);
        if (!meetingId) {
            this.Minute = null;
            this.ResolvedMinute = null;
            this.cdr.markForCheck();
            return;
        }
        const rv = new RunView();
        const result = await rv.RunView<MinuteRow>({
            EntityName: 'Committees: Minutes',
            ExtraFilter: `MeetingID='${meetingId}'`,
            Fields: [
                'ID', 'MeetingID', 'Content', 'ApprovalStatus', 'ApprovedAt',
                'ApprovedByMeetingID', 'MJArtifactID', 'ApprovedArtifactVersionID',
            ],
            ResultType: 'simple',
        });
        if (result.Success && result.Results?.length) {
            this.Minute = result.Results[0];
            const [resolved] = await this.bridgeService.LoadAndResolveMinutes([this.Minute]);
            this.ResolvedMinute = resolved ?? null;
        }
        this.cdr.markForCheck();
    }
}

export function LoadMeetingDetailView(): void { /* tree-shaking prevention */ }
