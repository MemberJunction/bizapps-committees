import { Component, ChangeDetectionStrategy, ChangeDetectorRef, EventEmitter, Input, OnInit, Output, inject } from '@angular/core';
import { Metadata, RunView } from '@memberjunction/core';
import { BallotThresholdType } from '@mj-biz-apps/committees-core';
import { mjBizAppsCommitteesBallotEntity, mjBizAppsCommitteesMotionEntity } from '@mj-biz-apps/committees-entities';

interface CommitteeOption { ID: string; Name: string; }

/**
 * New E-Ballot dialog (UX v2 screen 04): creates a meeting-less Motion plus
 * its Ballot in one step. Voting happens on the Motions & Ballots page.
 */
@Component({
    standalone: false,
    selector: 'committees-e-ballot-dialog',
    templateUrl: './e-ballot-dialog.component.html',
    styleUrls: ['../shared/design-system.css', '../shared/slide-panel.css', './e-ballot-dialog.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class EBallotDialogComponent implements OnInit {
    /** Preselects the committee (workspace Motions tab passes this). */
    private _committeeID: string | null = null;
    @Output() DialogClosed = new EventEmitter<boolean>();

    Committees: CommitteeOption[] = [];
    IsLoading = true;
    IsSaving = false;
    ErrorMessage = '';

    // Form state
    CommitteeID = '';
    Name = '';
    MotionText = '';
    Threshold: BallotThresholdType = 'SimpleMajority';
    ClosesAtLocal = '';
    IsSealed = true;

    readonly ThresholdOptions: { Value: BallotThresholdType; Label: string }[] = [
        { Value: 'SimpleMajority', Label: 'Simple majority of voting members' },
        { Value: 'TwoThirds', Label: '⅔ of voting members' },
        { Value: 'Unanimous', Label: 'Unanimous' },
    ];

    private cdr = inject(ChangeDetectorRef);

    @Input()
    set PreselectedCommitteeID(value: string | null) {
        this._committeeID = value;
        if (value) this.CommitteeID = value;
    }
    get PreselectedCommitteeID(): string | null { return this._committeeID; }

    async ngOnInit(): Promise<void> {
        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'Committees: Committees',
            ExtraFilter: "Status = 'Active'",
            Fields: ['ID', 'Name'],
            OrderBy: 'Name ASC',
            ResultType: 'simple',
        });
        this.Committees = (result.Success ? result.Results : []) as unknown as CommitteeOption[];
        if (this._committeeID) this.CommitteeID = this._committeeID;
        // Default close: one week out, end of day
        const close = new Date();
        close.setDate(close.getDate() + 7);
        close.setHours(18, 0, 0, 0);
        this.ClosesAtLocal = this.toLocalInputValue(close);
        this.IsLoading = false;
        this.cdr.detectChanges();
    }

    get CanSave(): boolean {
        return !!this.CommitteeID && this.Name.trim().length > 0 && !!this.ClosesAtLocal && !this.IsSaving;
    }

    async OnSave(): Promise<void> {
        if (!this.CanSave) return;
        const closesAt = new Date(this.ClosesAtLocal);
        if (isNaN(closesAt.getTime()) || closesAt <= new Date()) {
            this.ErrorMessage = 'Close date must be in the future';
            this.cdr.detectChanges();
            return;
        }
        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.detectChanges();
        try {
            const md = new Metadata();
            const motion = await md.GetEntityObject<mjBizAppsCommitteesMotionEntity>('Committees: Motions');
            motion.Name = this.Name.trim();
            if (this.MotionText.trim()) motion.Description = this.MotionText.trim();
            motion.Result = 'Pending';
            if (!await motion.Save()) throw new Error(motion.LatestResult?.Message ?? 'Failed to create motion');

            const ballot = await md.GetEntityObject<mjBizAppsCommitteesBallotEntity>('Committees: Ballots');
            ballot.CommitteeID = this.CommitteeID;
            ballot.MotionID = motion.ID;
            ballot.OpensAt = new Date();
            ballot.ClosesAt = closesAt;
            ballot.ThresholdType = this.Threshold;
            ballot.IsSealed = this.IsSealed;
            ballot.Status = 'Open';
            if (!await ballot.Save()) throw new Error(ballot.LatestResult?.Message ?? 'Failed to create ballot');

            this.DialogClosed.emit(true);
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to create e-ballot';
            this.IsSaving = false;
            this.cdr.detectChanges();
        }
    }

    OnCancel(): void {
        this.DialogClosed.emit(false);
    }

    private toLocalInputValue(d: Date): string {
        const pad = (n: number) => String(n).padStart(2, '0');
        return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`;
    }
}
