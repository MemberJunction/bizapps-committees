import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, Input, inject } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { RunView } from '@memberjunction/core';
import { CommitteesLookupEngine } from '@mj-biz-apps/committees-core/lookup';
import { CommitteeHealthService, CommitteeTaskService, CommitteeTaskRow, TermHygiene, MotionService, MotionRegisterRow } from '@mj-biz-apps/committees-core';

export type WorkspaceTab = 'overview' | 'roster' | 'meetings' | 'motions' | 'actions' | 'documents';

interface CommitteeRow { ID: string; Name: string; Status: string; IsPublic: boolean; Type: string; MissionStatement: string | null; FormationDate: string | null; ParentCommittee: string | null; }
interface TermRow { ID: string; CommitteeID: string; Name: string; Status: string; StartDate: string; EndDate: string | null; }
interface MembershipRow { ID: string; TermID: string; PersonID: string; RoleID: string; Status: string; Role: string; Person: string; StartDate: string; }
interface RoleRow { ID: string; Name: string; IsVotingRole: boolean; IsOfficer: boolean; }
interface MeetingRow { ID: string; Name: string; StartDateTime: string; EndDateTime: string | null; LocationType: string | null; LocationText: string | null; Status: string; }
interface ArtifactRow { ID: string; Name: string; Provider: string | null; URL: string | null; ArtifactType: string | null; }
interface MotionRow { ID: string; Name: string; Result: string | null; }

/**
 * Committee Workspace — one coherent surface per committee (UX v2 screen 02).
 * Staff view for Phase 1: Overview · Roster & Terms · Meetings · Motions ·
 * Actions · Documents in a left tab rail.
 */
@RegisterClass(BaseResourceComponent, 'CommitteeWorkspaceComponent')
@Component({
    standalone: false,
    selector: 'committee-workspace',
    templateUrl: './committee-workspace.component.html',
    styleUrls: ['../shared/design-system.css', '../command-center/command-center-shared.css', './committee-workspace.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class CommitteeWorkspaceComponent extends BaseResourceComponent implements OnInit {
    IsLoading = true;
    ActiveTab: WorkspaceTab = 'overview';

    Committee: CommitteeRow | null = null;
    Term: TermHygiene | null = null;
    Terms: TermRow[] = [];
    Members: MembershipRow[] = [];
    Officers: MembershipRow[] = [];
    VotingCount = 0;
    Meetings: MeetingRow[] = [];
    OpenActions: CommitteeTaskRow[] = [];
    Artifacts: ArtifactRow[] = [];
    MotionCount = 0;
    /** Committee-scoped motion register (meetings + this committee's e-ballots). */
    MotionRows: MotionRegisterRow[] = [];
    OpenBallotCount = 0;
    ShowEBallotDialog = false;
    /** Meeting shown in the Live Meeting Mode overlay; null = overlay closed. */
    LiveMeetingID: string | null = null;

    private _committeeID: string | null = null;
    @Input()
    set CommitteeID(value: string | null) {
        const prev = this._committeeID;
        this._committeeID = value;
        if (value && value !== prev && !this.IsLoading) void this.reload();
    }
    get CommitteeID(): string | null { return this._committeeID; }

    private cdr = inject(ChangeDetectorRef);
    private route = inject(ActivatedRoute);
    private router = inject(Router);

    async ngOnInit(): Promise<void> {
        this.NotifyLoadStarted();
        const fromRoute = this.route.snapshot.queryParamMap.get('committeeId');
        if (!this._committeeID && fromRoute) this._committeeID = fromRoute;
        await this.reload();
        this.NotifyLoadComplete();
    }

    async GetResourceDisplayName(_data: ResourceData): Promise<string> {
        return this.Committee?.Name ?? 'Committee';
    }

    async GetResourceIconClass(_data: ResourceData): Promise<string> {
        return 'fa-solid fa-users-rectangle';
    }

    SelectTab(tab: WorkspaceTab): void {
        this.ActiveTab = tab;
    }

    /** Enters Live Meeting Mode (full-screen overlay, UX v2 screen 03). */
    OpenLiveMeeting(meetingID: string): void {
        this.LiveMeetingID = meetingID;
    }

    /** Exit from Live Meeting Mode — reload so meeting/agenda statuses reflect the session. */
    OnLiveMeetingExited(): void {
        this.LiveMeetingID = null;
        void this.reload();
    }

    get TermLapsed(): boolean {
        return this.Term?.Kind === 'NoActiveTerm';
    }

    get NextMeeting(): MeetingRow | null {
        const now = new Date();
        return this.Meetings.find(m => new Date(m.StartDateTime) >= now && m.Status !== 'Cancelled') ?? null;
    }

    get LastMeeting(): MeetingRow | null {
        const now = new Date();
        const past = this.Meetings.filter(m => new Date(m.StartDateTime) < now);
        return past.length > 0 ? past[past.length - 1] : null;
    }

    BackToCommandCenter(): void {
        this.router.navigate(['/app/mjcommitteemgmt']);
    }

    IsOverdue(a: CommitteeTaskRow): boolean {
        return a.DueAt !== null && new Date(a.DueAt) < new Date() && a.Status !== 'Completed';
    }

    private async reload(): Promise<void> {
        try {
            if (!this._committeeID) { this.IsLoading = false; this.cdr.markForCheck(); return; }
            this.IsLoading = true;
            this.cdr.markForCheck();
            await this.loadWorkspaceData(this._committeeID);
            this.IsLoading = false;
            this.cdr.markForCheck();
        } finally {
            this.IsLoading = false;
            this.cdr.detectChanges();
        }
    }

    private async loadWorkspaceData(id: string): Promise<void> {
        const rv = new RunView();
        await CommitteesLookupEngine.Instance.Config();
        // Open tasks come from BizAppsTasks, concurrently with the batch below.
        const tasksPromise = new CommitteeTaskService().GetTasks({});
        const [committee, terms, meetings, artifacts, motions] = await rv.RunViews([
            { EntityName: 'Committees: Committees', ExtraFilter: `ID='${id}'`, Fields: ['ID', 'Name', 'Status', 'IsPublic', 'Type', 'MissionStatement', 'FormationDate', 'ParentCommittee'], ResultType: 'simple' },
            { EntityName: 'Committees: Terms', ExtraFilter: `CommitteeID='${id}'`, Fields: ['ID', 'CommitteeID', 'Name', 'Status', 'StartDate', 'EndDate'], OrderBy: 'StartDate DESC', ResultType: 'simple' },
            { EntityName: 'Committees: Meetings', ExtraFilter: `CommitteeID='${id}'`, Fields: ['ID', 'Name', 'StartDateTime', 'EndDateTime', 'LocationType', 'LocationText', 'Status'], OrderBy: 'StartDateTime ASC', ResultType: 'simple' },
            { EntityName: 'Committees: Artifacts', ExtraFilter: `CommitteeID='${id}'`, Fields: ['ID', 'Name', 'Provider', 'URL', 'ArtifactType'], ResultType: 'simple' },
            { EntityName: 'Committees: Motions', ExtraFilter: `MeetingID IN (SELECT ID FROM [__mj_BizAppsCommittees].[vwMeetings] WHERE CommitteeID='${id}')`, Fields: ['ID', 'Name', 'Result'], ResultType: 'simple' },
        ]);

        this.Committee = committee.Success && committee.Results.length > 0 ? committee.Results[0] as unknown as CommitteeRow : null;
        this.Terms = terms.Success ? terms.Results as unknown as TermRow[] : [];
        this.Meetings = meetings.Success ? meetings.Results as unknown as MeetingRow[] : [];
        this.OpenActions = (await tasksPromise).filter(t => t.CommitteeIDs.some(cid => cid.toLowerCase() === id.toLowerCase()));
        this.Artifacts = artifacts.Success ? artifacts.Results as unknown as ArtifactRow[] : [];
        this.MotionCount = motions.Success ? (motions.Results as unknown as MotionRow[]).length : 0;
        await this.loadMotionRegister(id);
        this.Term = CommitteeHealthService.ComputeTermHygiene(
            this.Terms.map(t => ({ ID: t.ID, CommitteeID: t.CommitteeID, Status: t.Status, StartDate: t.StartDate, EndDate: t.EndDate })),
            new Date()
        );
        // Roles come from the process-wide lookup engine — no per-load query.
        await this.loadMembers(CommitteesLookupEngine.Instance.Roles.map(r => ({ ID: r.ID, Name: r.Name, IsVotingRole: r.IsVotingRole, IsOfficer: r.IsOfficer })));
    }

    /** Committee-scoped register: meeting motions plus this committee's ballot motions. */
    private async loadMotionRegister(committeeID: string): Promise<void> {
        const register = await new MotionService().GetRegister();
        const rv = new RunView();
        const ballots = await rv.RunView<{ MotionID: string; Status: string }>({
            EntityName: 'Committees: Ballots',
            ExtraFilter: `CommitteeID = '${committeeID}'`,
            Fields: ['ID', 'MotionID', 'Status'],
            ResultType: 'simple',
        });
        const ballotRows = ballots.Success ? ballots.Results : [];
        const ballotMotionIDs = new Set(ballotRows.map(b => b.MotionID.toLowerCase()));
        this.OpenBallotCount = ballotRows.filter(b => b.Status === 'Open').length;
        this.MotionRows = register.Rows.filter(r =>
            (r.CommitteeID != null && r.CommitteeID.toLowerCase() === committeeID.toLowerCase())
            || ballotMotionIDs.has(r.MotionID.toLowerCase()));
    }

    OnEBallotDialogClosed(created: boolean): void {
        this.ShowEBallotDialog = false;
        if (created) void this.reload();
        else this.cdr.markForCheck();
    }

    private async loadMembers(roles: RoleRow[]): Promise<void> {
        const activeTermIDs = this.Terms.filter(t => t.Status === 'Active').map(t => `'${t.ID}'`);
        // Fall back to the most recent term when lapsed so the roster stays visible
        const termIDs = activeTermIDs.length > 0 ? activeTermIDs : this.Terms.slice(0, 1).map(t => `'${t.ID}'`);
        if (termIDs.length === 0) { this.Members = []; this.Officers = []; this.VotingCount = 0; return; }

        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'Committees: Memberships',
            ExtraFilter: `TermID IN (${termIDs.join(',')}) AND Status = 'Active'`,
            Fields: ['ID', 'TermID', 'PersonID', 'RoleID', 'Status', 'Role', 'Person', 'StartDate'],
            ResultType: 'simple',
        });
        this.Members = result.Success ? result.Results as unknown as MembershipRow[] : [];
        const officerRoleIDs = new Set(roles.filter(r => r.IsOfficer).map(r => r.ID));
        const votingRoleIDs = new Set(roles.filter(r => r.IsVotingRole).map(r => r.ID));
        this.Officers = this.Members
            .filter(m => officerRoleIDs.has(m.RoleID))
            .sort((a, b) => this.officerRank(a.Role) - this.officerRank(b.Role));
        this.VotingCount = this.Members.filter(m => votingRoleIDs.has(m.RoleID)).length;
    }

    /** Chair first, then Vice Chair, Secretary, Treasurer; unknown officer roles last. */
    private officerRank(roleName: string): number {
        const order = ['chair', 'vice chair', 'secretary', 'treasurer'];
        const idx = order.indexOf((roleName ?? '').toLowerCase());
        return idx === -1 ? order.length : idx;
    }

    /** The active Chair's display name, if one is seated. */
    get ChairName(): string | null {
        const chair = this.Officers.find(o => (o.Role ?? '').toLowerCase() === 'chair');
        return chair?.Person ?? null;
    }
}

export function LoadCommitteeWorkspace(): void { }
