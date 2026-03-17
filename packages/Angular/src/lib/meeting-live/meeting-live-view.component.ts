import { Component, EventEmitter, Input, Output, OnInit, OnDestroy, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { Metadata, RunView } from '@memberjunction/core';
import { mjCommitteesAgendaItemEntity, mjCommitteesMotionEntity, mjCommitteesVoteEntity } from '@mj-biz-apps/committees-entities';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';
import { MotionDialogResult } from '../motions/motion-edit-dialog.component';
import { MeetingDialogResult } from '../meeting-list/meeting-edit-dialog.component';

@Component({
    standalone: false,
    selector: 'meeting-live-view',
    templateUrl: './meeting-live-view.component.html',
    styleUrls: ['../shared/design-system.css', './meeting-live-view.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class MeetingLiveViewComponent implements OnInit, OnDestroy {
    @Input() MeetingID: string | null = null;
    @Output() BackToList = new EventEmitter<void>();

    Meeting: Record<string, unknown> | null = null;
    AgendaItems: Record<string, unknown>[] = [];
    Motions: MotionWithVotes[] = [];
    IsLoading = true;
    IsOfficer = false;
    IsVotingMember = false;
    CurrentMembershipID: string | null = null;
    VideoCollapsed = false;
    VideoUrl: SafeResourceUrl | null = null;
    VideoFailed = false;
    LastRefresh = new Date();

    ShowMotionDialog = false;
    EditingMotionID: string | null = null;
    ShowMeetingEditDialog = false;

    private refreshInterval: ReturnType<typeof setInterval> | null = null;
    private cdr = inject(ChangeDetectorRef);
    private sanitizer = inject(DomSanitizer);

    readonly AgendaStatusOptions = ['Pending', 'Discussed', 'Completed', 'Tabled', 'Skipped'] as const;

    get VideoJoinURL(): string | null {
        return (this.Meeting?.['VideoJoinURL'] as string) || null;
    }

    get TimeSinceRefresh(): string {
        const seconds = Math.floor((Date.now() - this.LastRefresh.getTime()) / 1000);
        if (seconds < 5) return 'Just now';
        if (seconds < 60) return `${seconds}s ago`;
        return `${Math.floor(seconds / 60)}m ago`;
    }

    async ngOnInit(): Promise<void> {
        await this.LoadAllData();
        this.IsLoading = false;
        this.cdr.markForCheck();

        // Start auto-refresh
        this.refreshInterval = setInterval(() => this.RefreshData(), 20000);
    }

    ngOnDestroy(): void {
        if (this.refreshInterval) clearInterval(this.refreshInterval);
        if (this.videoTimeout) clearTimeout(this.videoTimeout);
    }

    OnBack(): void {
        this.BackToList.emit();
    }

    ToggleVideo(): void {
        this.VideoCollapsed = !this.VideoCollapsed;
        this.cdr.markForCheck();
    }

    OnVideoError(): void {
        this.VideoFailed = true;
        this.cdr.markForCheck();
    }

    OnVideoLoad(): void {
        // If iframe loaded, cancel the failure timeout
        if (this.videoTimeout) {
            clearTimeout(this.videoTimeout);
            this.videoTimeout = null;
        }
    }

    private videoTimeout: ReturnType<typeof setTimeout> | null = null;

    /** Called after VideoUrl is set — start a timeout to detect blocked iframes */
    private StartVideoTimeout(): void {
        this.videoTimeout = setTimeout(() => {
            // Most blocked iframes won't fire error events, so assume failure after timeout
            // Only mark as failed if still not explicitly loaded
            if (!this.VideoFailed) {
                this.VideoFailed = true;
                this.cdr.markForCheck();
            }
        }, 3000);
    }

    OpenVideoInTab(): void {
        if (this.VideoJoinURL) {
            window.open(this.VideoJoinURL, '_blank', 'noopener');
        }
    }

    async RefreshData(): Promise<void> {
        await this.LoadAgendaAndMotions();
        this.LastRefresh = new Date();
        this.cdr.markForCheck();
    }

    // ─── Voting ───
    async OnVote(motion: MotionWithVotes, value: 'Yes' | 'No' | 'Abstain'): Promise<void> {
        if (!this.CurrentMembershipID || motion.Result !== 'Pending') return;

        const existingVote = motion.Votes.find(v => v.MembershipID === this.CurrentMembershipID);
        const md = new Metadata();

        if (existingVote) {
            if (existingVote.VoteValue === value) return; // Already voted this way
            const vote = await md.GetEntityObject<mjCommitteesVoteEntity>('Votes');
            await vote.Load(existingVote.VoteID);
            vote.VoteValue = value;
            await vote.Save();
            existingVote.VoteValue = value;
        } else {
            const vote = await md.GetEntityObject<mjCommitteesVoteEntity>('Votes');
            vote.NewRecord();
            vote.MotionID = motion.ID;
            vote.MembershipID = this.CurrentMembershipID;
            vote.VoteValue = value;
            await vote.Save();
            motion.Votes.push({ VoteID: vote.ID, MembershipID: this.CurrentMembershipID, VoteValue: value });
        }

        this.RecalcTally(motion);
        this.cdr.markForCheck();
    }

    GetMyVote(motion: MotionWithVotes): string | null {
        const vote = motion.Votes.find(v => v.MembershipID === this.CurrentMembershipID);
        return vote?.VoteValue ?? null;
    }

    // ─── Officer: Agenda Status ───
    async OnAgendaStatusChange(itemID: string, newStatus: string): Promise<void> {
        const md = new Metadata();
        const item = await md.GetEntityObject<mjCommitteesAgendaItemEntity>('Agenda Items');
        await item.Load(itemID);
        item.Status = newStatus as 'Pending' | 'Discussed' | 'Completed' | 'Tabled' | 'Skipped';
        await item.Save();

        const local = this.AgendaItems.find(a => a['ID'] === itemID);
        if (local) local['Status'] = newStatus;
        this.cdr.markForCheck();
    }

    // ─── Officer: Close Vote ───
    async OnCloseVote(motion: MotionWithVotes): Promise<void> {
        const md = new Metadata();
        const entity = await md.GetEntityObject<mjCommitteesMotionEntity>('Motions');
        await entity.Load(motion.ID);

        const yes = motion.Votes.filter(v => v.VoteValue === 'Yes').length;
        const no = motion.Votes.filter(v => v.VoteValue === 'No').length;
        entity.Result = yes > no ? 'Passed' : 'Failed';
        entity.YesCount = yes;
        entity.NoCount = no;
        entity.AbstainCount = motion.Votes.filter(v => v.VoteValue === 'Abstain').length;
        entity.ResultSummary = `${yes} Yes · ${no} No · ${entity.AbstainCount} Abstain`;
        await entity.Save();

        motion.Result = entity.Result;
        motion.ResultSummary = entity.ResultSummary;
        this.cdr.markForCheck();
    }

    // ─── Officer: Motion Dialog ───
    OnCreateMotion(): void {
        this.EditingMotionID = null;
        this.ShowMotionDialog = true;
        this.cdr.markForCheck();
    }

    async OnMotionDialogClosed(result: MotionDialogResult): Promise<void> {
        this.ShowMotionDialog = false;
        if (result.Saved) await this.RefreshData();
        this.cdr.markForCheck();
    }

    // ─── Officer: Meeting Edit ───
    OnOpenMeetingSettings(): void {
        this.ShowMeetingEditDialog = true;
        this.cdr.markForCheck();
    }

    async OnMeetingEditClosed(result: MeetingDialogResult): Promise<void> {
        this.ShowMeetingEditDialog = false;
        if (result.Saved) await this.LoadAllData();
        this.cdr.markForCheck();
    }

    // ─── Helpers ───
    GetAgendaStatusClass(status: string): string {
        switch (status) {
            case 'Completed': case 'Discussed': return 'status-done';
            case 'Pending': return 'status-current';
            case 'Tabled': return 'status-tabled';
            case 'Skipped': return 'status-skipped';
            default: return '';
        }
    }

    GetResultClass(result: string): string {
        switch (result) {
            case 'Passed': return 'result-passed';
            case 'Failed': return 'result-failed';
            case 'Pending': return 'result-pending';
            case 'Tabled': return 'result-tabled';
            default: return 'result-other';
        }
    }

    GetTallyPercent(motion: MotionWithVotes, type: 'yes' | 'no' | 'abstain'): number {
        const total = motion.Votes.length;
        if (total === 0) return 0;
        const count = motion.Votes.filter(v =>
            type === 'yes' ? v.VoteValue === 'Yes' :
            type === 'no' ? v.VoteValue === 'No' :
            v.VoteValue === 'Abstain'
        ).length;
        return (count / total) * 100;
    }

    // ─── Data Loading ───
    private async LoadAllData(): Promise<void> {
        if (!this.MeetingID) return;
        const rv = new RunView();

        const meetingResult = await rv.RunView<Record<string, unknown>>({
            EntityName: 'Meetings',
            ExtraFilter: `ID = '${this.MeetingID}'`,
            Fields: ['ID', 'Title', 'Committee', 'CommitteeID', 'Status', 'StartDateTime', 'EndDateTime', 'LocationType', 'VideoJoinURL'],
            MaxRows: 1,
            ResultType: 'simple'
        });

        if (meetingResult.Success && meetingResult.Results.length > 0) {
            this.Meeting = meetingResult.Results[0];
            // Auto-open video call in new tab
            const url = this.VideoJoinURL;
            if (url) {
                window.open(url, '_blank', 'noopener');
            }

            // Load permissions
            const committeeID = this.Meeting['CommitteeID'] as string;
            const perms = await CommitteePermissionHelper.GetPermissionsForCommittee(committeeID);
            this.IsOfficer = perms.IsOfficer;

            // Resolve current user's membership for voting
            await this.ResolveCurrentMembership(committeeID);
        }

        await this.LoadAgendaAndMotions();
    }

    private async LoadAgendaAndMotions(): Promise<void> {
        if (!this.MeetingID) return;
        const rv = new RunView();

        const [agendaResult, motionsResult] = await rv.RunViews([
            {
                EntityName: 'Agenda Items',
                Fields: ['ID', 'Sequence', 'Title', 'ItemType', 'Status', 'Presenter', 'DurationMinutes'],
                ExtraFilter: `MeetingID = '${this.MeetingID}'`,
                OrderBy: 'Sequence ASC',
                ResultType: 'simple'
            },
            {
                EntityName: 'Motions',
                Fields: ['ID', 'Sequence', 'Title', 'Description', 'Result', 'ResultSummary', 'MovedByMembershipID', 'SecondedByMembershipID', 'YesCount', 'NoCount', 'AbstainCount'],
                ExtraFilter: `MeetingID = '${this.MeetingID}'`,
                OrderBy: 'Sequence ASC',
                ResultType: 'simple'
            }
        ]);

        if (agendaResult.Success) {
            this.AgendaItems = agendaResult.Results;
        }

        if (motionsResult.Success) {
            // Load votes and resolve member names for motions
            const motionIDs = motionsResult.Results.map(m => (m as Record<string, unknown>)['ID'] as string);
            const votesMap = await this.LoadVotesForMotions(motionIDs);

            // Resolve membership IDs to person names
            const membershipIDs = new Set<string>();
            for (const m of motionsResult.Results) {
                const rec = m as Record<string, unknown>;
                if (rec['MovedByMembershipID']) membershipIDs.add(rec['MovedByMembershipID'] as string);
                if (rec['SecondedByMembershipID']) membershipIDs.add(rec['SecondedByMembershipID'] as string);
            }
            const memberNames = await this.ResolveMemberNames([...membershipIDs]);

            this.Motions = motionsResult.Results.map(m => {
                const rec = m as Record<string, unknown>;
                const id = rec['ID'] as string;
                const motion: MotionWithVotes = {
                    ID: id,
                    Title: rec['Title'] as string,
                    Description: rec['Description'] as string | null,
                    Result: rec['Result'] as string,
                    ResultSummary: rec['ResultSummary'] as string | null,
                    MovedBy: memberNames.get(rec['MovedByMembershipID'] as string) ?? null,
                    SecondedBy: memberNames.get(rec['SecondedByMembershipID'] as string) ?? null,
                    Votes: votesMap.get(id) || [],
                };
                return motion;
            });
        }
    }

    private async LoadVotesForMotions(motionIDs: string[]): Promise<Map<string, VoteInfo[]>> {
        const result = new Map<string, VoteInfo[]>();
        if (motionIDs.length === 0) return result;

        const rv = new RunView();
        const ids = motionIDs.map(id => `'${id}'`).join(',');
        const votesResult = await rv.RunView<{ ID: string; MotionID: string; MembershipID: string; VoteValue: string }>({
            EntityName: 'Votes',
            ExtraFilter: `MotionID IN (${ids})`,
            Fields: ['ID', 'MotionID', 'MembershipID', 'VoteValue'],
            ResultType: 'simple'
        });

        if (votesResult.Success) {
            for (const v of votesResult.Results) {
                const list = result.get(v.MotionID) || [];
                list.push({ VoteID: v.ID, MembershipID: v.MembershipID, VoteValue: v.VoteValue });
                result.set(v.MotionID, list);
            }
        }
        return result;
    }

    private async ResolveCurrentMembership(committeeID: string): Promise<void> {
        const personID = await CommitteePermissionHelper.GetCurrentPersonID();
        if (!personID) return;

        const rv = new RunView();
        const termsResult = await rv.RunView<{ ID: string }>({
            EntityName: 'Terms',
            ExtraFilter: `CommitteeID = '${committeeID}'`,
            Fields: ['ID'],
            ResultType: 'simple'
        });
        if (!termsResult.Success || !termsResult.Results || termsResult.Results.length === 0) return;

        const termIDs = termsResult.Results.map(t => `'${t.ID}'`).join(',');
        const memberResult = await rv.RunView<{ ID: string; RoleID: string }>({
            EntityName: 'Memberships',
            ExtraFilter: `PersonID = '${personID}' AND TermID IN (${termIDs}) AND Status = 'Active'`,
            Fields: ['ID', 'RoleID'],
            ResultType: 'simple'
        });

        if (memberResult.Success && memberResult.Results && memberResult.Results.length > 0) {
            this.CurrentMembershipID = memberResult.Results[0].ID;

            // Check if voting role
            const roleResult = await rv.RunView<{ IsVotingRole: boolean | number }>({
                EntityName: 'Roles',
                ExtraFilter: `ID = '${memberResult.Results[0].RoleID}'`,
                Fields: ['IsVotingRole'],
                MaxRows: 1,
                ResultType: 'simple'
            });
            if (roleResult.Success && roleResult.Results && roleResult.Results.length > 0) {
                this.IsVotingMember = roleResult.Results[0].IsVotingRole === true || roleResult.Results[0].IsVotingRole === 1;
            }
        }
    }

    private async ResolveMemberNames(membershipIDs: string[]): Promise<Map<string, string>> {
        const result = new Map<string, string>();
        if (membershipIDs.length === 0) return result;

        const rv = new RunView();
        const ids = membershipIDs.map(id => `'${id}'`).join(',');
        const membershipsResult = await rv.RunView<{ ID: string; Person: string }>({
            EntityName: 'Memberships',
            ExtraFilter: `ID IN (${ids})`,
            Fields: ['ID', 'Person'],
            ResultType: 'simple'
        });

        if (membershipsResult.Success) {
            for (const m of membershipsResult.Results) {
                result.set(m.ID, m.Person || 'Unknown');
            }
        }
        return result;
    }

    private RecalcTally(motion: MotionWithVotes): void {
        const yes = motion.Votes.filter(v => v.VoteValue === 'Yes').length;
        const no = motion.Votes.filter(v => v.VoteValue === 'No').length;
        const abstain = motion.Votes.filter(v => v.VoteValue === 'Abstain').length;
        motion.ResultSummary = `${yes} Yes · ${no} No · ${abstain} Abstain`;
    }
}

export interface MotionWithVotes {
    ID: string;
    Title: string;
    Description: string | null;
    Result: string;
    ResultSummary: string | null;
    MovedBy: string | null;
    SecondedBy: string | null;
    Votes: VoteInfo[];
}

export interface VoteInfo {
    VoteID: string;
    MembershipID: string;
    VoteValue: string;
}

export function LoadMeetingLiveView() { }
