import { Component, ChangeDetectionStrategy, ChangeDetectorRef, EventEmitter, Input, OnInit, Output, inject } from '@angular/core';
import { GraphQLDataProvider } from '@memberjunction/graphql-dataprovider';
import { VoteTally } from '@mj-biz-apps/committees-core';
import { BallotView, BallotVoterChip } from './motions-ballots.component';

/** The CloseBallot mutation's payload (committees-server BallotCloseResolver). */
interface CloseBallotPayload {
    Success: boolean;
    ErrorMessage?: string | null;
    Result: 'Passed' | 'Failed' | 'Cancelled' | null;
    Yes: number;
    No: number;
    Abstain: number;
    Cast: number;
    VotingMemberCount: number;
    RequiredYes: number;
    ResultNotes: string | null;
}

/** What the server revealed when it closed the ballot. */
export interface RevealedTally {
    Tally: VoteTally;
    RequiredYes: number;
    VotingMemberCount: number;
}

const CLOSE_BALLOT = `mutation CloseBallot($input: CloseBallotInput!) {
    CloseBallot(input: $input) {
        Success ErrorMessage Result Yes No Abstain Cast VotingMemberCount RequiredYes ResultNotes
    }
}`;

/**
 * Ballot-close ceremony (Phase 4 feature 2, server-side since C0). Closing a ballot is the governance act: this
 * dialog shows participation and the threshold BEFORE the chair commits, then reveals the tally the server computed.
 * The browser never sees other members' choices while a ballot is open (the Votes row filter), so the tally, the
 * outcome and the Motion stamp come from the CloseBallot mutation, which reads the votes as the system user. Sealed
 * ballots reveal the tally only; individual choices stay sealed permanently. Also carries the cancel path.
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
    /** Filled from the mutation's response; null until the ballot is closed. */
    Revealed: RevealedTally | null = null;

    private cdr = inject(ChangeDetectorRef);

    ngOnInit(): void {
        this.Notes = '';
    }

    // ── Evidence ────────────────────────────────────────────────

    get NonVoters(): BallotVoterChip[] {
        return this.View.Voters.filter(v => v.IsVoting && !v.HasVoted);
    }

    get IsEarly(): boolean {
        return !this.View.Countdown.IsOverdue;
    }

    /** Early + outstanding votes: the result the server computes could still change if the chair waited. */
    get IsRisky(): boolean {
        return this.IsEarly && this.View.Tally.Outstanding > 0;
    }

    get YesPct(): number {
        const tally = this.Revealed?.Tally;
        if (!tally) return 0;
        return (tally.Yes / Math.max(tally.Cast, 1)) * 100;
    }
    get NoPct(): number {
        const tally = this.Revealed?.Tally;
        if (!tally) return 0;
        return (tally.No / Math.max(tally.Cast, 1)) * 100;
    }

    ThresholdLabel(): string {
        switch (this.View.Ballot.ThresholdType) {
            case 'TwoThirds': return 'two-thirds';
            case 'Unanimous': return 'unanimous';
            default: return 'simple majority';
        }
    }

    SetMode(mode: 'close' | 'cancel'): void {
        this.Mode = mode;
        this.Notes = '';
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
            const payload = await this.closeOnServer(this.Mode === 'close' ? 'Close' : 'Cancel');
            this.FinalResult = payload.Result ?? 'Failed';
            this.Revealed = {
                Tally: { Yes: payload.Yes, No: payload.No, Abstain: payload.Abstain, Cast: payload.Cast, Outstanding: Math.max(0, payload.VotingMemberCount - payload.Cast) },
                RequiredYes: payload.RequiredYes,
                VotingMemberCount: payload.VotingMemberCount,
            };
            this.Notes = payload.ResultNotes ?? this.Notes;
            this.Phase = 'reveal';
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to close ballot';
        }
        this.IsSaving = false;
        this.cdr.detectChanges();
    }

    private async closeOnServer(mode: 'Close' | 'Cancel'): Promise<CloseBallotPayload> {
        const input = { BallotID: this.View.Ballot.ID, Mode: mode, Notes: this.Notes.trim() || null };
        const result = await GraphQLDataProvider.Instance.ExecuteGQL(CLOSE_BALLOT, { input });
        const payload = (result as { CloseBallot?: CloseBallotPayload } | null)?.CloseBallot;
        if (!payload) throw new Error('The server returned no answer to CloseBallot');
        if (!payload.Success) throw new Error(payload.ErrorMessage ?? 'Failed to close ballot');
        return payload;
    }

    // ── Exit ────────────────────────────────────────────────────

    Done(): void { this.Exited.emit(true); }
    Cancel(): void { if (!this.IsSaving) this.Exited.emit(this.Phase === 'reveal'); }
}
