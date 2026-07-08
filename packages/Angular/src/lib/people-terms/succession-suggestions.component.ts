import { Component, ChangeDetectionStrategy, ChangeDetectorRef, EventEmitter, Input, Output, inject } from '@angular/core';
import { GraphQLDataProvider } from '@memberjunction/graphql-dataprovider';

/** One AI-proposed successor with the evidence behind the claim. */
export interface SuccessionSuggestion {
    PersonID: string;
    PersonName: string;
    CurrentRoles: string;
    AttendanceRate: number | null;
    CommitteeCount: number;
    Fit: string;
    Rationale: string;
}

/**
 * AI succession suggestions rail (UX v2 screen 05, assist grammar).
 * On-demand generation only — nothing is stored; dismissals are client-side.
 * AI proposes; a human acts through the normal roster flow.
 */
@Component({
    standalone: false,
    selector: 'committees-succession-suggestions',
    templateUrl: './succession-suggestions.component.html',
    styleUrls: ['./succession-suggestions.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class SuccessionSuggestionsComponent {
    private _committeeID: string | null = null;
    @Input()
    set CommitteeID(value: string | null) {
        if (value !== this._committeeID) {
            this._committeeID = value;
            // Committee changed: previous suggestions no longer apply.
            this.Suggestions = [];
            this.HasGenerated = false;
            this.ErrorMessage = '';
            this.cdr.markForCheck();
        }
    }
    get CommitteeID(): string | null { return this._committeeID; }

    @Input() CommitteeName = '';

    /** When true, each card offers "Add to roster" and emits Picked — used by
     *  the term-renewal wizard. People & Terms leaves this off (view-only rail). */
    @Input() EnablePick = false;
    @Output() Picked = new EventEmitter<SuccessionSuggestion>();

    Suggestions: SuccessionSuggestion[] = [];
    IsGenerating = false;
    HasGenerated = false;
    ErrorMessage = '';
    private dismissed = new Set<string>();

    private cdr = inject(ChangeDetectorRef);

    get VisibleSuggestions(): SuccessionSuggestion[] {
        return this.Suggestions.filter(s => !this.dismissed.has(s.PersonID));
    }

    async OnGenerate(): Promise<void> {
        if (!this._committeeID || this.IsGenerating) return;
        this.IsGenerating = true;
        this.ErrorMessage = '';
        this.cdr.detectChanges();
        try {
            const query = `mutation SuggestSuccessors($input: SuggestSuccessorsInput!) {
                SuggestSuccessors(input: $input) {
                    Success
                    ErrorMessage
                    Suggestions {
                        PersonID PersonName CurrentRoles AttendanceRate CommitteeCount Fit Rationale
                    }
                }
            }`;
            const result = await GraphQLDataProvider.Instance.ExecuteGQL(query, { input: { CommitteeID: this._committeeID } });
            const payload = result?.SuggestSuccessors;
            if (!payload?.Success) throw new Error(payload?.ErrorMessage ?? 'Suggestion generation failed');
            this.Suggestions = payload.Suggestions ?? [];
            this.dismissed.clear();
            this.HasGenerated = true;
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Suggestion generation failed';
        }
        this.IsGenerating = false;
        this.cdr.detectChanges();
    }

    Dismiss(suggestion: SuccessionSuggestion): void {
        this.dismissed.add(suggestion.PersonID);
        this.cdr.markForCheck();
    }

    Pick(suggestion: SuccessionSuggestion): void {
        this.Picked.emit(suggestion);
        this.dismissed.add(suggestion.PersonID);   // picked cards leave the rail
        this.cdr.markForCheck();
    }

    Initials(name: string): string {
        return name.split(/\s+/).filter(Boolean).slice(0, 2).map(p => p[0]).join('').toUpperCase();
    }
}
