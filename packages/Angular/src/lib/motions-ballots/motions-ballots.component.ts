import { Component, ChangeDetectionStrategy, ChangeDetectorRef, OnInit, inject } from '@angular/core';
import { Metadata, RunView } from '@memberjunction/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import {
    BallotService, MotionService, MotionRegisterData, MotionRegisterRow,
    MembershipRefRow, VoteRow, VoteTally, OutcomeForecast, BallotCountdown,
    BallotThresholdType, RollCallEntry,
} from '@mj-biz-apps/committees-core';
import { mjBizAppsCommitteesBallotEntity, mjBizAppsCommitteesMotionEntity, mjBizAppsCommitteesVoteEntity } from '@mj-biz-apps/committees-entities';
import { GraphQLDataProvider } from '@memberjunction/graphql-dataprovider';
import { CommitteesLookupEngine } from '@mj-biz-apps/committees-core/lookup';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';

interface BallotRow {
    ID: string;
    CommitteeID: string;
    Committee: string;
    MotionID: string;
    OpensAt: Date;
    ClosesAt: Date;
    ClosedAt: Date | null;
    ThresholdType: BallotThresholdType;
    IsSealed: boolean;
    Status: string;
    CreatedByMembershipID: string | null;
    ResultNotes: string | null;
    __mj_CreatedAt: Date;
}

interface TermRow { ID: string; CommitteeID: string; Status: string; }
interface RoleRow { ID: string; IsVotingRole: boolean; }
interface MembershipFullRow extends MembershipRefRow { RoleID: string; TermID: string; Status: string; }
interface CommitteeRefRow { ID: string; Name: string; }

/** One voter line on the ballot hero. */
export interface BallotVoterChip {
    MembershipID: string;
    PersonName: string;
    RoleName: string;
    IsVoting: boolean;
    HasVoted: boolean;
    VotedAt: Date | null;
}

export interface BallotAuditEvent {
    Kind: 'system' | 'vote';
    Text: string;
    When: Date | null;
    IsScheduled: boolean;
}

/** Fully assembled view model for one ballot hero. */
export interface BallotView {
    Ballot: BallotRow;
    MotionTitle: string;
    MotionText: string | null;
    OpenedByName: string | null;
    VotingMemberCount: number;
    Tally: VoteTally;
    Forecast: OutcomeForecast;
    Countdown: BallotCountdown;
    Sealed: boolean;
    Voters: BallotVoterChip[];
    Audit: BallotAuditEvent[];
    /** Current user's voting membership on this ballot's committee, if they haven't voted. */
    MyVotableMembershipID: string | null;
}

export function LoadMotionsBallots(): void { }

@Component({
    standalone: false,
    selector: 'committees-motions-ballots',
    templateUrl: './motions-ballots.component.html',
    styleUrls: ['../command-center/command-center-shared.css', './motions-ballots.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
})
@RegisterClass(BaseResourceComponent, 'MotionsBallotsComponent')
export class MotionsBallotsComponent extends BaseResourceComponent implements OnInit {
    IsLoading = true;
    ErrorMessage = '';
    SearchText = '';

    OpenBallots: BallotView[] = [];
    ClosedBallotCount = 0;
    Register: MotionRegisterData = { Rows: [], VotesByMotion: new Map(), MembershipsByID: new Map() };
    /** MotionID → committee name for ballot motions (no meeting to derive from). */
    private ballotCommitteeByMotion = new Map<string, { CommitteeID: string; Name: string }>();
    /** MotionID → sealed flag so the register hides pending ballot roll calls. */
    private sealedByMotion = new Map<string, boolean>();
    ExpandedMotionID: string | null = null;
    ExpandedRollCall: RollCallEntry[] = [];

    ShowNewBallotDialog = false;
    IsActing = false;
    /** Ballot whose inline extend-deadline row is open. */
    ExtendTarget: BallotView | null = null;

    DecidedThisQuarter = 0;

    private cdr = inject(ChangeDetectorRef);
    private motionService = new MotionService();

    async GetResourceDisplayName(_data: ResourceData): Promise<string> { return 'Motions & Ballots'; }
    async GetResourceIconClass(_data: ResourceData): Promise<string> { return 'fa-solid fa-gavel'; }

    async ngOnInit(): Promise<void> {
        await this.Load();
    }

    async Load(): Promise<void> {
        this.IsLoading = true;
        this.ErrorMessage = '';
        this.cdr.detectChanges();
        try {
            await CommitteesLookupEngine.Instance.Config();
            const rv = new RunView();
            const [register, ballotsResult, extras] = await Promise.all([
                this.motionService.GetRegister(),
                rv.RunView({
                    EntityName: 'Committees: Ballots',
                    OrderBy: 'ClosesAt ASC',
                    ResultType: 'simple',
                }),
                rv.RunViews([
                    { EntityName: 'Committees: Terms', Fields: ['ID', 'CommitteeID', 'Status'], ResultType: 'simple' },
                    { EntityName: 'Committees: Memberships', ExtraFilter: "Status = 'Active'", Fields: ['ID', 'PersonID', 'Person', 'Role', 'RoleID', 'TermID', 'Status'], ResultType: 'simple' },
                ]),
            ]);
            const ballots = (ballotsResult.Success ? ballotsResult.Results : []) as unknown as BallotRow[];
            const [terms, memberships] = extras;
            // Roles come from the process-wide lookup engine — no per-load query.
            const roles: RoleRow[] = CommitteesLookupEngine.Instance.Roles
                .map(r => ({ ID: r.ID, IsVotingRole: r.IsVotingRole }));
            await this.assemble(
                register,
                ballots,
                (terms.Success ? terms.Results : []) as unknown as TermRow[],
                (memberships.Success ? memberships.Results : []) as unknown as MembershipFullRow[],
                roles,
            );
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to load motions and ballots';
        }
        this.IsLoading = false;
        this.cdr.detectChanges();
    }

    private async assemble(
        register: MotionRegisterData, ballots: BallotRow[],
        terms: TermRow[], memberships: MembershipFullRow[], roles: RoleRow[]
    ): Promise<void> {
        this.Register = register;
        const votingRoleIDs = new Set(roles.filter(r => r.IsVotingRole).map(r => r.ID.toLowerCase()));
        const activeTermsByCommittee = new Map<string, Set<string>>();
        for (const t of terms.filter(t => t.Status === 'Active')) {
            const key = t.CommitteeID.toLowerCase();
            const set = activeTermsByCommittee.get(key) ?? new Set<string>();
            set.add(t.ID.toLowerCase());
            activeTermsByCommittee.set(key, set);
        }
        const myPersonID = (await CommitteePermissionHelper.GetCurrentPersonID())?.toLowerCase() ?? null;

        this.ballotCommitteeByMotion.clear();
        this.sealedByMotion.clear();
        const open: BallotView[] = [];
        let closed = 0;
        for (const b of ballots) {
            this.ballotCommitteeByMotion.set(b.MotionID.toLowerCase(), { CommitteeID: b.CommitteeID, Name: b.Committee });
            this.sealedByMotion.set(b.MotionID.toLowerCase(), BallotService.AreChoicesSealed(b));
            if (b.Status === 'Closed') { closed++; continue; }
            if (b.Status !== 'Open') continue;
            open.push(this.buildBallotView(b, register, activeTermsByCommittee, memberships, votingRoleIDs, myPersonID));
        }
        this.OpenBallots = open;
        this.ClosedBallotCount = closed;
        this.DecidedThisQuarter = this.countDecidedThisQuarter(register.Rows);
    }

    private buildBallotView(
        b: BallotRow, register: MotionRegisterData,
        activeTermsByCommittee: Map<string, Set<string>>,
        memberships: MembershipFullRow[], votingRoleIDs: Set<string>,
        myPersonID: string | null
    ): BallotView {
        const termIDs = activeTermsByCommittee.get(b.CommitteeID.toLowerCase()) ?? new Set<string>();
        const committeeMembers = memberships.filter(m => termIDs.has(m.TermID.toLowerCase()));
        const votingMembers = committeeMembers.filter(m => votingRoleIDs.has(m.RoleID.toLowerCase()));
        const votes = register.VotesByMotion.get(b.MotionID.toLowerCase()) ?? [];
        const votesByMembership = new Map(votes.map(v => [v.MembershipID.toLowerCase(), v]));
        const tally = BallotService.ComputeTally(votes, votingMembers.length);
        const motionRow = register.Rows.find(r => r.MotionID.toLowerCase() === b.MotionID.toLowerCase());
        const sealed = BallotService.AreChoicesSealed(b);
        const now = new Date();

        const voters: BallotVoterChip[] = committeeMembers.map(m => {
            const vote = votesByMembership.get(m.ID.toLowerCase());
            return {
                MembershipID: m.ID,
                PersonName: m.Person,
                RoleName: m.Role,
                IsVoting: votingRoleIDs.has(m.RoleID.toLowerCase()),
                HasVoted: !!vote,
                VotedAt: vote?.__mj_CreatedAt ? new Date(vote.__mj_CreatedAt) : null,
            };
        }).sort((a, b2) => Number(b2.IsVoting) - Number(a.IsVoting));

        const mine = myPersonID
            ? votingMembers.find(m => m.PersonID.toLowerCase() === myPersonID && !votesByMembership.has(m.ID.toLowerCase()))
            : undefined;

        return {
            Ballot: b,
            MotionTitle: motionRow?.Name ?? '(motion)',
            MotionText: motionRow?.Description ?? null,
            OpenedByName: b.CreatedByMembershipID
                ? register.MembershipsByID.get(b.CreatedByMembershipID.toLowerCase())?.Person ?? null
                : null,
            VotingMemberCount: votingMembers.length,
            Tally: tally,
            Forecast: BallotService.ForecastOutcome(tally, b.ThresholdType, 'VotingMembers', votingMembers.length),
            Countdown: BallotService.ComputeCountdown(new Date(b.ClosesAt), 'Open', now),
            Sealed: sealed,
            Voters: voters,
            Audit: this.buildAudit(b, votes, register),
            MyVotableMembershipID: mine?.ID ?? null,
        };
    }

    private buildAudit(b: BallotRow, votes: VoteRow[], register: MotionRegisterData): BallotAuditEvent[] {
        const events: BallotAuditEvent[] = [];
        const opener = b.CreatedByMembershipID
            ? register.MembershipsByID.get(b.CreatedByMembershipID.toLowerCase())?.Person ?? 'member'
            : 'staff';
        const thresholdLabel = this.ThresholdLabel(b.ThresholdType);
        events.push({
            Kind: 'system', IsScheduled: false, When: new Date(b.__mj_CreatedAt),
            Text: `Ballot created by ${opener} · threshold ${thresholdLabel} · closes ${new Date(b.ClosesAt).toLocaleString()}`,
        });
        for (const v of votes) {
            const who = register.MembershipsByID.get(v.MembershipID.toLowerCase())?.Person ?? 'member';
            events.push({
                Kind: 'vote', IsScheduled: false,
                When: v.__mj_CreatedAt ? new Date(v.__mj_CreatedAt) : null,
                Text: BallotService.AreChoicesSealed(b) ? `${who} voted — choice sealed` : `${who} voted ${v.VoteValue}`,
            });
        }
        events.sort((a, b2) => (a.When?.getTime() ?? 0) - (b2.When?.getTime() ?? 0));
        if (b.Status === 'Open') {
            events.push({
                Kind: 'system', IsScheduled: true, When: new Date(b.ClosesAt),
                Text: 'Ballot closes — result computed, tally revealed, Motion stamped',
            });
        } else if (b.ClosedAt) {
            events.push({
                Kind: 'system', IsScheduled: false, When: new Date(b.ClosedAt),
                Text: `Ballot closed — ${b.ResultNotes ?? 'result recorded'}`,
            });
        }
        return events;
    }

    private countDecidedThisQuarter(rows: MotionRegisterRow[]): number {
        const now = new Date();
        const qStart = new Date(now.getFullYear(), Math.floor(now.getMonth() / 3) * 3, 1);
        return rows.filter(r => r.Result !== 'Pending' && r.MeetingDate != null && r.MeetingDate >= qStart).length;
    }

    // ── Register display helpers ────────────────────────────────

    get FilteredRows(): MotionRegisterRow[] {
        const q = this.SearchText.trim().toLowerCase();
        if (!q) return this.Register.Rows;
        return this.Register.Rows.filter(r =>
            r.Name.toLowerCase().includes(q)
            || (this.CommitteeNameFor(r) ?? '').toLowerCase().includes(q)
            || (r.MovedByName ?? '').toLowerCase().includes(q));
    }

    CommitteeNameFor(row: MotionRegisterRow): string | null {
        return row.CommitteeName ?? this.ballotCommitteeByMotion.get(row.MotionID.toLowerCase())?.Name ?? null;
    }

    IsSealedRow(row: MotionRegisterRow): boolean {
        return this.sealedByMotion.get(row.MotionID.toLowerCase()) ?? false;
    }

    ToggleRollCall(row: MotionRegisterRow): void {
        if (this.ExpandedMotionID === row.MotionID) {
            this.ExpandedMotionID = null;
            this.ExpandedRollCall = [];
            return;
        }
        const votes = this.Register.VotesByMotion.get(row.MotionID.toLowerCase()) ?? [];
        const eligible = votes
            .map(v => this.Register.MembershipsByID.get(v.MembershipID.toLowerCase()))
            .filter((m): m is MembershipRefRow => !!m);
        this.ExpandedMotionID = row.MotionID;
        this.ExpandedRollCall = MotionService.BuildRollCall(eligible, votes, this.IsSealedRow(row));
        this.cdr.detectChanges();
    }

    TallyLabel(t: VoteTally | null): string {
        return t ? `${t.Yes}-${t.No}-${t.Abstain}` : '—';
    }

    ResultTone(result: string): string {
        switch (result) {
            case 'Passed': return 'success';
            case 'Failed': return 'error';
            case 'Pending': return 'warning';
            default: return 'neutral';
        }
    }

    ThresholdLabel(t: BallotThresholdType): string {
        switch (t) {
            case 'SimpleMajority': return 'simple majority';
            case 'TwoThirds': return '⅔ of voting members';
            case 'Unanimous': return 'unanimous';
        }
    }

    // ── Ballot actions ──────────────────────────────────────────

    async OnCastVote(view: BallotView, value: 'Yes' | 'No' | 'Abstain'): Promise<void> {
        if (!view.MyVotableMembershipID || this.IsActing) return;
        this.IsActing = true;
        try {
            const md = new Metadata();
            const vote = await md.GetEntityObject<mjBizAppsCommitteesVoteEntity>('Committees: Votes');
            vote.MotionID = view.Ballot.MotionID;
            vote.MembershipID = view.MyVotableMembershipID;
            vote.VoteValue = value;
            if (!await vote.Save()) throw new Error(vote.LatestResult?.Message ?? 'Vote failed to save');
            await this.Load();
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to record vote';
            this.IsActing = false;
            this.cdr.detectChanges();
        }
        this.IsActing = false;
    }

    /** Validates the inline datetime-local value, then extends. */
    ConfirmExtend(view: BallotView, value: string): void {
        if (!value) return;
        const newClose = new Date(value);
        if (isNaN(newClose.getTime()) || newClose <= new Date()) {
            this.ErrorMessage = 'New close must be a future date/time';
            this.cdr.detectChanges();
            return;
        }
        this.ExtendTarget = null;
        void this.OnExtendDeadline(view, newClose);
    }

    async OnExtendDeadline(view: BallotView, newClose: Date): Promise<void> {
        if (this.IsActing) return;
        this.IsActing = true;
        try {
            const ballot = await this.loadBallotEntity(view.Ballot.ID);
            ballot.ClosesAt = newClose;
            if (!await ballot.Save()) throw new Error(ballot.LatestResult?.Message ?? 'Extend failed');
            await this.Load();
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to extend deadline';
            this.cdr.detectChanges();
        }
        this.IsActing = false;
    }

    /**
     * Close the ballot: compute the outcome from the recorded votes, stamp the
     * Motion (result + counts), unseal, and mark the ballot Closed.
     */
    // ── Close ceremony + Remind (Phase 4 feature 2) ─────────────

    CloseTarget: BallotView | null = null;
    /** Per-ballot remind outcome text, session-only. */
    RemindResults = new Map<string, string>();
    RemindingBallotID: string | null = null;

    OnCloseBallot(view: BallotView): void {
        this.CloseTarget = view;
        this.cdr.detectChanges();
    }

    async OnCloseDialogExited(changed: boolean): Promise<void> {
        this.CloseTarget = null;
        this.cdr.detectChanges();
        if (changed) await this.Load();
    }

    async OnRemind(view: BallotView): Promise<void> {
        if (this.RemindingBallotID) return;
        this.RemindingBallotID = view.Ballot.ID;
        this.cdr.detectChanges();
        try {
            const query = `mutation RemindBallotNonVoters($input: RemindBallotNonVotersInput!) {
                RemindBallotNonVoters(input: $input) {
                    Success ErrorMessage TotalNonVoters RemindedCount UnreachableNames
                }
            }`;
            const result = await GraphQLDataProvider.Instance.ExecuteGQL(query, { input: { BallotID: view.Ballot.ID } });
            const payload = result?.RemindBallotNonVoters;
            if (!payload?.Success) throw new Error(payload?.ErrorMessage ?? 'Reminder failed');
            this.RemindResults.set(view.Ballot.ID, this.remindSummary(payload));
        } catch (err) {
            this.RemindResults.set(view.Ballot.ID, err instanceof Error ? err.message : 'Reminder failed');
        }
        this.RemindingBallotID = null;
        this.cdr.detectChanges();
    }

    private remindSummary(payload: { TotalNonVoters: number; RemindedCount: number; UnreachableNames: string[] }): string {
        if (payload.TotalNonVoters === 0) return 'Everyone has voted — nothing to remind.';
        const base = `Reminded ${payload.RemindedCount} of ${payload.TotalNonVoters}`;
        return payload.UnreachableNames.length > 0
            ? `${base} — no linked account: ${payload.UnreachableNames.join(', ')}`
            : `${base} via in-app notification.`;
    }

    private async loadBallotEntity(id: string): Promise<mjBizAppsCommitteesBallotEntity> {
        const md = new Metadata();
        const ballot = await md.GetEntityObject<mjBizAppsCommitteesBallotEntity>('Committees: Ballots');
        if (!await ballot.Load(id)) throw new Error('Ballot not found');
        return ballot;
    }

    OnNewBallotClosed(created: boolean): void {
        this.ShowNewBallotDialog = false;
        if (created) void this.Load();
        else this.cdr.detectChanges();
    }
}
