import { Component, EventEmitter, Input, Output, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { Metadata, RunView } from '@memberjunction/core';
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

    AgendaItems: { ID: string; Title: string }[] = [];
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
            this.LoadLookups(),
            this.LoadOrCreateMotion()
        ]);
        if (!this.IsNew) {
            await this.LoadVotes();
        } else {
            this.InitVoterRows();
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

        const err = this.Validate();
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
        await this.SaveVotes();

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

    private Validate(): string | null {
        if (!this.Motion!.Title?.trim()) return 'Title is required.';
        return null;
    }

    private async LoadOrCreateMotion(): Promise<void> {
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

    private async LoadLookups(): Promise<void> {
        const rv = new RunView();
        const queries: Parameters<typeof rv.RunViews>[0] = [
            {
                EntityName: 'Committees: Roles',
                Fields: ['ID', 'IsVotingRole'],
                ResultType: 'simple'
            }
        ];

        if (this.MeetingID) {
            queries.push({
                EntityName: 'Committees: Agenda Items',
                Fields: ['ID', 'Title'],
                ExtraFilter: `MeetingID = '${this.MeetingID}'`,
                OrderBy: 'Sequence ASC',
                ResultType: 'simple'
            });
        }

        const results = await rv.RunViews(queries);

        const votingRoleIDs = new Set<string>();
        if (results[0].Success) {
            for (const r of results[0].Results as { ID: string; IsVotingRole: boolean | number }[]) {
                if (r.IsVotingRole === true || r.IsVotingRole === 1) votingRoleIDs.add(r.ID);
            }
        }

        if (results[1]?.Success) {
            this.AgendaItems = results[1].Results as { ID: string; Title: string }[];
        }

        // Load committee members through terms
        if (this.CommitteeID) {
            const termsResult = await rv.RunView<{ ID: string }>({
                EntityName: 'Committees: Terms',
                ExtraFilter: `CommitteeID = '${this.CommitteeID}'`,
                Fields: ['ID'],
                ResultType: 'simple'
            });

            if (termsResult.Success && termsResult.Results && termsResult.Results.length > 0) {
                const termIDs = termsResult.Results.map(t => `'${t.ID}'`).join(',');
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
        }
    }

    private InitVoterRows(): void {
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

    private async LoadVotes(): Promise<void> {
        this.InitVoterRows();

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

    private async SaveVotes(): Promise<void> {
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
