import { Component, EventEmitter, Input, Output, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { Metadata, RunView } from '@memberjunction/core';
import { CommitteesLookupEngine } from '@mj-biz-apps/committees-core/lookup';
import { mjBizAppsCommitteesMotionEntity, mjBizAppsCommitteesVoteEntity } from '@mj-biz-apps/committees-entities';

export interface MotionDialogResult {
    Saved: boolean;
    Motion: mjBizAppsCommitteesMotionEntity | null;
}

interface VoterRow {
    MembershipID: string;
    PersonName: string;
    RoleName: string;
    IsVotingRole: boolean;
    VoteID: string | null;
    VoteValue: 'Yes' | 'No' | 'Abstain' | 'Absent' | null;
    Changed: boolean;
}

@Component({
    standalone: false,
    selector: 'motion-edit-dialog',
    templateUrl: './motion-edit-dialog.component.html',
    styleUrls: ['../shared/design-system.css', '../shared/slide-panel.css', './motion-edit-dialog.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class MotionEditDialogComponent implements OnInit {
    @Input() MotionID: string | null = null;
    @Input() MeetingID: string | null = null;
    @Input() CommitteeID: string | null = null;
    @Output() DialogClosed = new EventEmitter<MotionDialogResult>();

    Motion: mjBizAppsCommitteesMotionEntity | null = null;
    IsLoading = true;
    IsSaving = false;
    ErrorMessage = '';

    AgendaItems: { ID: string; Name: string }[] = [];
    Members: { ID: string; Person: string; Role: string; IsVotingRole: boolean }[] = [];
    Voters: VoterRow[] = [];

    readonly ResultOptions = ['Pending', 'Passed', 'Failed', 'Tabled', 'Withdrawn'] as const;
    readonly VoteOptions = ['Yes', 'No', 'Abstain', 'Absent'] as const;

    private cdr = inject(ChangeDetectorRef);

    get IsNew(): boolean { return this.MotionID == null; }
    get DialogTitle(): string { return this.IsNew ? 'New Motion' : 'Edit Motion'; }

    get YesCount(): number { return this.Voters.filter(v => v.VoteValue === 'Yes').length; }
    get NoCount(): number { return this.Voters.filter(v => v.VoteValue === 'No').length; }
    get AbstainCount(): number { return this.Voters.filter(v => v.VoteValue === 'Abstain').length; }
    get AbsentCount(): number { return this.Voters.filter(v => v.VoteValue === 'Absent').length; }
    get NotVotedCount(): number { return this.Voters.filter(v => v.VoteValue == null && v.IsVotingRole).length; }

    get TallyText(): string {
        return `${this.YesCount} Yes · ${this.NoCount} No · ${this.AbstainCount} Abstain`;
    }

    async ngOnInit(): Promise<void> {
        await Promise.all([
            this.loadLookups(),
            this.loadOrCreateMotion()
        ]);
        if (!this.IsNew) {
            await this.loadVotes();
        } else {
            this.initVoterRows();
        }
        this.IsLoading = false;
        this.cdr.markForCheck();
    }

    OnVote(voter: VoterRow, value: 'Yes' | 'No' | 'Abstain' | 'Absent'): void {
        if (voter.VoteValue === value) {
            voter.VoteValue = null;
        } else {
            voter.VoteValue = value;
        }
        voter.Changed = true;
        this.cdr.markForCheck();
    }

    async OnSave(): Promise<void> {
        if (!this.Motion) return;

        const err = this.validate();
        if (err) {
            this.ErrorMessage = err;
            this.cdr.markForCheck();
            return;
        }

        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.markForCheck();

        // Update tally
        this.Motion.YesCount = this.YesCount;
        this.Motion.NoCount = this.NoCount;
        this.Motion.AbstainCount = this.AbstainCount;
        this.Motion.ResultSummary = this.TallyText;

        const saved = await this.Motion.Save();
        if (!saved) {
            this.IsSaving = false;
            this.ErrorMessage = 'Failed to save motion.';
            this.cdr.markForCheck();
            return;
        }

        // Save votes
        await this.saveVotes();

        this.IsSaving = false;
        this.DialogClosed.emit({ Saved: true, Motion: this.Motion });
    }

    OnClose(): void {
        this.DialogClosed.emit({ Saved: false, Motion: null });
    }

    GetVoteClass(value: string | null): string {
        switch (value) {
            case 'Yes': return 'vote-yes';
            case 'No': return 'vote-no';
            case 'Abstain': return 'vote-abstain';
            case 'Absent': return 'vote-absent';
            default: return '';
        }
    }

    private validate(): string | null {
        if (!this.Motion!.Name?.trim()) return 'Title is required.';
        return null;
    }

    private async loadOrCreateMotion(): Promise<void> {
        const md = new Metadata();
        if (this.IsNew) {
            this.Motion = await md.GetEntityObject<mjBizAppsCommitteesMotionEntity>('Committees: Motions');
            this.Motion.MeetingID = this.MeetingID!;
            this.Motion.Sequence = 1;
            this.Motion.Result = 'Pending';
        } else {
            this.Motion = await md.GetEntityObject<mjBizAppsCommitteesMotionEntity>('Committees: Motions');
            await this.Motion.Load(this.MotionID!);
        }
    }

    private async loadLookups(): Promise<void> {
        // Roles come from the process-wide lookup engine — no per-open query.
        await CommitteesLookupEngine.Instance.Config();
        const votingRoleIDs = new Set(
            CommitteesLookupEngine.Instance.Roles.filter(r => r.IsVotingRole).map(r => r.ID));

        const rv = new RunView();
        const queries: Parameters<typeof rv.RunViews>[0] = [];
        if (this.MeetingID) {
            queries.push({
                EntityName: 'Committees: Agenda Items',
                Fields: ['ID', 'Name'],
                ExtraFilter: `MeetingID = '${this.MeetingID}'`,
                OrderBy: 'Sequence ASC',
                ResultType: 'simple'
            });
        }
        if (this.CommitteeID) {
            queries.push({
                EntityName: 'Committees: Terms',
                ExtraFilter: `CommitteeID = '${this.CommitteeID}'`,
                Fields: ['ID'],
                ResultType: 'simple'
            });
        }
        const results = queries.length > 0 ? await rv.RunViews(queries) : [];
        const agendaResult = this.MeetingID ? results[0] : undefined;
        const termsResult = this.CommitteeID ? results[this.MeetingID ? 1 : 0] : undefined;

        if (agendaResult?.Success) {
            this.AgendaItems = agendaResult.Results as { ID: string; Name: string }[];
        }
        await this.loadMembersForTerms(rv, termsResult, votingRoleIDs);
    }

    /** Committee members resolve through terms — dependent on the terms read above. */
    private async loadMembersForTerms(
        rv: RunView,
        termsResult: { Success: boolean; Results: unknown[] } | undefined,
        votingRoleIDs: Set<string>
    ): Promise<void> {
        const termRows = (termsResult?.Success ? termsResult.Results : []) as { ID: string }[];
        if (termRows.length === 0) return;
        const termIDs = termRows.map(t => `'${t.ID}'`).join(',');
        const membersResult = await rv.RunView<{ ID: string; PersonID: string; Person: string; RoleID: string; Role: string }>({
            EntityName: 'Committees: Memberships',
            ExtraFilter: `TermID IN (${termIDs}) AND Status = 'Active'`,
            Fields: ['ID', 'PersonID', 'Person', 'RoleID', 'Role'],
            OrderBy: 'Role ASC, Person ASC',
            ResultType: 'simple'
        });
        if (membersResult.Success) {
            this.Members = membersResult.Results.map(m => ({
                ID: m.ID,
                Person: m.Person || 'Unknown',
                Role: m.Role,
                IsVotingRole: votingRoleIDs.has(m.RoleID)
            }));
        }
    }

    private initVoterRows(): void {
        this.Voters = this.Members.map(m => ({
            MembershipID: m.ID,
            PersonName: m.Person,
            RoleName: m.Role,
            IsVotingRole: m.IsVotingRole,
            VoteID: null,
            VoteValue: null,
            Changed: false,
        }));
    }

    private async loadVotes(): Promise<void> {
        this.initVoterRows();

        const rv = new RunView();
        const result = await rv.RunView<{ ID: string; MembershipID: string; VoteValue: string }>({
            EntityName: 'Committees: Votes',
            ExtraFilter: `MotionID = '${this.MotionID}'`,
            Fields: ['ID', 'MembershipID', 'VoteValue'],
            ResultType: 'simple'
        });

        if (result.Success) {
            for (const vote of result.Results) {
                const voter = this.Voters.find(v => v.MembershipID === vote.MembershipID);
                if (voter) {
                    voter.VoteID = vote.ID;
                    voter.VoteValue = vote.VoteValue as VoterRow['VoteValue'];
                }
            }
        }
    }

    private async saveVotes(): Promise<void> {
        const md = new Metadata();
        const changedVoters = this.Voters.filter(v => v.Changed);

        for (const voter of changedVoters) {
            if (voter.VoteID) {
                // Update existing vote
                if (voter.VoteValue) {
                    const vote = await md.GetEntityObject<mjBizAppsCommitteesVoteEntity>('Committees: Votes');
                    await vote.Load(voter.VoteID);
                    vote.VoteValue = voter.VoteValue;
                    await vote.Save();
                } else {
                    // Clear vote — delete it
                    const vote = await md.GetEntityObject<mjBizAppsCommitteesVoteEntity>('Committees: Votes');
                    await vote.Load(voter.VoteID);
                    try { await vote.Delete(); } catch { /* ignore */ }
                }
            } else if (voter.VoteValue) {
                // Create new vote
                const vote = await md.GetEntityObject<mjBizAppsCommitteesVoteEntity>('Committees: Votes');
                vote.NewRecord();
                vote.MotionID = this.Motion!.ID;
                vote.MembershipID = voter.MembershipID;
                vote.VoteValue = voter.VoteValue;
                await vote.Save();
            }
        }
    }
}

export function LoadMotionEditDialog() { }
