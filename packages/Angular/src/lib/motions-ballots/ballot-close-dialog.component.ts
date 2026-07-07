import { Component, ChangeDetectionStrategy, ChangeDetectorRef, EventEmitter, Input, OnInit, Output, inject } from '@angular/core';
import { Metadata } from '@memberjunction/core';
import { BallotService } from '@mj-biz-apps/committees-core';
import {
    mjBizAppsCommitteesBallotEntity, mjBizAppsCommitteesMotionEntity,
} from '@mj-biz-apps/committees-entities';
import { BallotView, BallotVoterChip } from './motions-ballots.component';

/**
 * Ballot-close ceremony (Phase 4 feature 2). Closing a ballot is the
 * governance act — this dialog shows participation, the threshold math, and
 * the outcome about to be stamped BEFORE the chair commits, then reveals the
 * final tally. Sealed ballots reveal the tally only; individual choices stay
 * sealed permanently. Also carries the cancel path (withdrawn motions).
 */
@Component({
    standalone: false,
    selector: 'committees-ballot-close-dialog',
    templateUrl: './ballot-close-dialog.component.html',
    styleUrls: ['./ballot-close-dialog.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class BallotCloseDialogComponent implements OnInit {
    @Input() View!: BallotView;
    /** Emits true when the ballot was closed or cancelled (parent reloads). */
    @Output() Exited = new EventEmitter<boolean>();

    Phase: 'confirm' | 'reveal' = 'confirm';
    Mode: 'close' | 'cancel' = 'close';
    Notes = '';
    IsSaving = false;
    ErrorMessage = '';
    FinalResult: 'Passed' | 'Failed' | 'Cancelled' = 'Failed';

    private cdr = inject(ChangeDetectorRef);

    ngOnInit(): void {
        this.Notes = this.stampSummary();
    }

    // ── Evidence ────────────────────────────────────────────────

    get NonVoters(): BallotVoterChip[] {
        return this.View.Voters.filter(v => v.IsVoting && !v.HasVoted);
    }

    get IsEarly(): boolean {
        return !this.View.Countdown.IsOverdue;
    }

    /** Early + outstanding votes could still flip the result → loud warning. */
    get IsRisky(): boolean {
        return this.IsEarly && !this.View.Forecast.IsDecided;
    }

    get ProjectedResult(): 'Passed' | 'Failed' {
        const outcome = BallotService.ForecastOutcome(
            { ...this.View.Tally, Outstanding: 0 },
            this.View.Ballot.ThresholdType, 'VotingMembers', this.View.VotingMemberCount);
        return outcome.Outcome === 'Passed' ? 'Passed' : 'Failed';
    }

    get YesPct(): number {
        const cast = Math.max(this.View.Tally.Cast, 1);
        return (this.View.Tally.Yes / cast) * 100;
    }
    get NoPct(): number {
        const cast = Math.max(this.View.Tally.Cast, 1);
        return (this.View.Tally.No / cast) * 100;
    }

    ThresholdLabel(): string {
        switch (this.View.Ballot.ThresholdType) {
            case 'TwoThirds': return 'two-thirds';
            case 'Unanimous': return 'unanimous';
            default: return 'simple majority';
        }
    }

    private stampSummary(): string {
        const t = this.View.Tally;
        return `E-ballot ${this.ProjectedResult.toLowerCase()} ${t.Yes}-${t.No}-${t.Abstain}`
            + ` (${this.ThresholdLabel()}, ${t.Cast} of ${this.View.VotingMemberCount} voting members cast)`;
    }

    SetMode(mode: 'close' | 'cancel'): void {
        this.Mode = mode;
        this.Notes = mode === 'close' ? this.stampSummary() : '';
        this.ErrorMessage = '';
        this.cdr.markForCheck();
    }

    get ConfirmDisabled(): boolean {
        return this.IsSaving || (this.Mode === 'cancel' && this.Notes.trim().length === 0);
    }

    // ── Writes ──────────────────────────────────────────────────

    async OnConfirm(): Promise<void> {
        if (this.ConfirmDisabled) return;
        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.detectChanges();
        try {
            if (this.Mode === 'close') {
                await this.stampMotion();
                await this.writeBallot('Closed');
                this.FinalResult = this.ProjectedResult;
            } else {
                await this.writeBallot('Cancelled');
                this.FinalResult = 'Cancelled';
            }
            this.Phase = 'reveal';
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to close ballot';
        }
        this.IsSaving = false;
        this.cdr.detectChanges();
    }

    private async stampMotion(): Promise<void> {
        const md = new Metadata();
        const motion = await md.GetEntityObject<mjBizAppsCommitteesMotionEntity>('Committees: Motions');
        if (!await motion.Load(this.View.Ballot.MotionID)) throw new Error('Motion not found');
        motion.Result = this.ProjectedResult;
        motion.ResultSummary = this.Notes.trim() || this.stampSummary();
        motion.YesCount = this.View.Tally.Yes;
        motion.NoCount = this.View.Tally.No;
        motion.AbstainCount = this.View.Tally.Abstain;
        if (!await motion.Save()) throw new Error(motion.LatestResult?.Message ?? 'Motion stamp failed');
    }

    private async writeBallot(status: 'Closed' | 'Cancelled'): Promise<void> {
        const md = new Metadata();
        const ballot = await md.GetEntityObject<mjBizAppsCommitteesBallotEntity>('Committees: Ballots');
        if (!await ballot.Load(this.View.Ballot.ID)) throw new Error('Ballot not found');
        ballot.Status = status;
        ballot.ClosedAt = new Date();
        ballot.ResultNotes = this.Notes.trim() || null;
        if (!await ballot.Save()) throw new Error(ballot.LatestResult?.Message ?? 'Ballot save failed');
    }

    // ── Exit ────────────────────────────────────────────────────

    Done(): void { this.Exited.emit(true); }
    Cancel(): void { if (!this.IsSaving) this.Exited.emit(this.Phase === 'reveal'); }
}
