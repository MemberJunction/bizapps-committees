import {
    ChangeDetectionStrategy,
    ChangeDetectorRef,
    Component,
    EventEmitter,
    HostListener,
    OnInit,
    Output,
    inject,
} from '@angular/core';
import { Metadata } from '@memberjunction/core';
import { GraphQLDataProvider } from '@memberjunction/graphql-dataprovider';
import { CommitteesLookupEngine } from '@mj-biz-apps/committees-core/lookup';

const ANALYZE_MUTATION = `
    mutation AnalyzeCommitteeImport($fileBase64: String!, $fileName: String!, $mimeType: String!) {
        AnalyzeCommitteeImport(fileBase64: $fileBase64, fileName: $fileName, mimeType: $mimeType) {
            Success
            ErrorMessage
            Plan {
                committees { Name Description CommitteeType _problems { field severity message suggestedValue } }
                terms { CommitteeRef Year StartDate EndDate _problems { field severity message suggestedValue } }
                people { FirstName LastName Email _problems { field severity message suggestedValue } }
                memberships { CommitteeRef PersonRef Role Status _problems { field severity message suggestedValue } }
            }
        }
    }
`;

const CONFIRM_MUTATION = `
    mutation ConfirmCommitteeImport($plan: ImportPlanInput!) {
        ConfirmCommitteeImport(plan: $plan) {
            Success
            ErrorMessage
            CommitteesCreated
            TermsCreated
            PeopleCreated
            MembershipsCreated
            Errors { Entity Identifier Message }
        }
    }
`;

// Membership statuses are an enum on the entity, not a lookup table — keep local.
const MEMBERSHIP_STATUSES = ['Active', 'Inactive', 'Pending', 'Ended', 'Suspended'];

export type BulkImportState = 'upload' | 'analyzing' | 'preview' | 'importing' | 'result';

interface Problem {
    field: string;
    severity: 'error' | 'warning';
    message: string;
    suggestedValue?: string | number | null;
}

interface CommitteeRow {
    Name: string;
    Description: string | null;
    CommitteeType: string;
    _problems?: Problem[];
}

interface TermRow {
    CommitteeRef: string;
    Year: number | null;
    StartDate: string | null;
    EndDate: string | null;
    _problems?: Problem[];
}

interface PersonRow {
    FirstName: string;
    LastName: string;
    Email: string;
    _problems?: Problem[];
}

interface MembershipRow {
    CommitteeRef: string;
    PersonRef: string;
    Role: string;
    Status: string;
    _problems?: Problem[];
}

interface ImportPlan {
    committees: CommitteeRow[];
    terms: TermRow[];
    people: PersonRow[];
    memberships: MembershipRow[];
}

interface ImportRowError {
    Entity: string;
    Identifier: string;
    Message: string;
}

@Component({
    standalone: false,
    selector: 'bulk-import-panel',
    templateUrl: './bulk-import-panel.component.html',
    styleUrls: ['../shared/design-system.css', '../shared/slide-panel.css', './bulk-import-panel.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class BulkImportPanelComponent implements OnInit {
    @Output() PanelClosed = new EventEmitter<{ Imported: boolean }>();

    State: BulkImportState = 'upload';
    FileName = '';
    Plan: ImportPlan | null = null;
    Error = '';
    DragActive = false;

    /** UI-only state for collapsible sections in preview mode. Each key is the section name. */
    SectionExpanded: Record<string, boolean> = {
        committees: true,
        terms: true,
        people: false,
        memberships: false,
    };

    /** Confirm modal state for Path C (unresolved problems). */
    ConfirmModalVisible = false;

    /** Result state after import. */
    Result: {
        CommitteesCreated: number;
        TermsCreated: number;
        PeopleCreated: number;
        MembershipsCreated: number;
        Errors: ImportRowError[];
    } | null = null;

    /** Dropdown options sourced from CommitteesLookupEngine on init. */
    CommitteeTypes: string[] = [];
    Roles: string[] = [];
    readonly Statuses = MEMBERSHIP_STATUSES;

    private cdr = inject(ChangeDetectorRef);

    async ngOnInit(): Promise<void> {
        await CommitteesLookupEngine.Instance.Config();
        this.CommitteeTypes = CommitteesLookupEngine.Instance.CommitteeTypes.map(t => t.Name);
        this.Roles = CommitteesLookupEngine.Instance.Roles.map(r => r.Name);
        this.cdr.markForCheck();
    }

    // -------------------------------------------------------------------------
    // Drop zone + upload
    // -------------------------------------------------------------------------

    @HostListener('dragover', ['$event'])
    OnDragOver(event: DragEvent): void {
        event.preventDefault();
        event.stopPropagation();
        if (this.State === 'upload') {
            this.DragActive = true;
            this.cdr.markForCheck();
        }
    }

    @HostListener('dragleave', ['$event'])
    OnDragLeave(event: DragEvent): void {
        event.preventDefault();
        event.stopPropagation();
        this.DragActive = false;
        this.cdr.markForCheck();
    }

    @HostListener('drop', ['$event'])
    async OnDrop(event: DragEvent): Promise<void> {
        event.preventDefault();
        event.stopPropagation();
        this.DragActive = false;
        const file = event.dataTransfer?.files?.[0];
        if (file) await this.handleFile(file);
    }

    async OnFileSelected(event: Event): Promise<void> {
        const input = event.target as HTMLInputElement;
        const file = input.files?.[0];
        if (file) await this.handleFile(file);
    }

    OnClose(imported = false): void {
        this.PanelClosed.emit({ Imported: imported });
    }

    // -------------------------------------------------------------------------
    // Section / row UI helpers
    // -------------------------------------------------------------------------

    ToggleSection(key: string): void {
        this.SectionExpanded[key] = !this.SectionExpanded[key];
        this.cdr.markForCheck();
    }

    GetCommitteeProblemCount(): number {
        return this.Plan?.committees.reduce((acc, r) => acc + (r._problems?.length ?? 0), 0) ?? 0;
    }
    GetTermProblemCount(): number {
        return this.Plan?.terms.reduce((acc, r) => acc + (r._problems?.length ?? 0), 0) ?? 0;
    }
    GetPersonProblemCount(): number {
        return this.Plan?.people.reduce((acc, r) => acc + (r._problems?.length ?? 0), 0) ?? 0;
    }
    GetMembershipProblemCount(): number {
        return this.Plan?.memberships.reduce((acc, r) => acc + (r._problems?.length ?? 0), 0) ?? 0;
    }
    GetTotalProblemCount(): number {
        return this.GetCommitteeProblemCount() + this.GetTermProblemCount()
             + this.GetPersonProblemCount() + this.GetMembershipProblemCount();
    }

    GetProblemForField(row: { _problems?: Problem[] }, field: string): Problem | null {
        return row._problems?.find(p => p.field === field) ?? null;
    }

    /** Clears the problem for a field after the user edits it. */
    ClearProblem(row: { _problems?: Problem[] }, field: string): void {
        if (!row._problems) return;
        row._problems = row._problems.filter(p => p.field !== field);
        this.cdr.markForCheck();
    }

    /** Track-by helpers for *ngFor / @for performance and stable DOM. */
    TrackCommittee(_idx: number, row: CommitteeRow): string { return row.Name; }
    TrackTerm(_idx: number, row: TermRow): string { return `${row.CommitteeRef}-${row.Year ?? ''}`; }
    TrackPerson(_idx: number, row: PersonRow): string { return row.Email; }
    TrackMembership(_idx: number, row: MembershipRow): string { return `${row.CommitteeRef}-${row.PersonRef}`; }

    // -------------------------------------------------------------------------
    // Confirm flow (Path C: confirm always enabled)
    // -------------------------------------------------------------------------

    OnConfirmClicked(): void {
        if (this.GetTotalProblemCount() > 0) {
            this.ConfirmModalVisible = true;
            this.cdr.markForCheck();
        } else {
            void this.runImport();
        }
    }

    OnConfirmModalCancel(): void {
        this.ConfirmModalVisible = false;
        this.cdr.markForCheck();
    }

    async OnConfirmModalProceed(): Promise<void> {
        this.ConfirmModalVisible = false;
        await this.runImport();
    }

    OnViewCommittees(): void {
        this.OnClose(true);
    }

    // -------------------------------------------------------------------------
    // Internal: file handling + GraphQL calls
    // -------------------------------------------------------------------------

    private async handleFile(file: File): Promise<void> {
        this.FileName = file.name;
        this.State = 'analyzing';
        this.Error = '';
        this.cdr.markForCheck();

        try {
            const fileBase64 = await this.fileToBase64(file);
            const provider = Metadata.Provider as GraphQLDataProvider;
            const result = await provider.ExecuteGQL(ANALYZE_MUTATION, {
                fileBase64,
                fileName: file.name,
                mimeType: file.type || this.guessMimeType(file.name),
            });
            const data = result?.AnalyzeCommitteeImport;
            if (!data?.Success) {
                this.Error = data?.ErrorMessage ?? 'Failed to analyze the spreadsheet.';
                this.State = 'upload';
                this.cdr.markForCheck();
                return;
            }
            this.Plan = data.Plan as ImportPlan;
            this.State = 'preview';
            this.cdr.markForCheck();
        } catch (error) {
            this.Error = error instanceof Error ? error.message : String(error);
            this.State = 'upload';
            this.cdr.markForCheck();
        }
    }

    private async runImport(): Promise<void> {
        if (!this.Plan) return;
        this.State = 'importing';
        this.cdr.markForCheck();

        try {
            const provider = Metadata.Provider as GraphQLDataProvider;
            const cleanedPlan = this.stripProblemsForServer(this.Plan);
            const result = await provider.ExecuteGQL(CONFIRM_MUTATION, { plan: cleanedPlan });
            const data = result?.ConfirmCommitteeImport;
            if (!data) throw new Error('No response from import mutation.');

            this.Result = {
                CommitteesCreated: data.CommitteesCreated,
                TermsCreated: data.TermsCreated,
                PeopleCreated: data.PeopleCreated,
                MembershipsCreated: data.MembershipsCreated,
                Errors: data.Errors ?? [],
            };
            if (!data.Success && !data.Errors?.length) {
                this.Error = data.ErrorMessage ?? 'Import failed.';
            }
            this.State = 'result';
            this.cdr.markForCheck();
        } catch (error) {
            this.Error = error instanceof Error ? error.message : String(error);
            this.State = 'preview';
            this.cdr.markForCheck();
        }
    }

    /** Server re-validates, but we strip _problems so the input matches GraphQL InputType. */
    private stripProblemsForServer(plan: ImportPlan): ImportPlan {
        return {
            committees: plan.committees.map(({ _problems: _, ...rest }) => rest as CommitteeRow),
            terms: plan.terms.map(({ _problems: _, ...rest }) => rest as TermRow),
            people: plan.people.map(({ _problems: _, ...rest }) => rest as PersonRow),
            memberships: plan.memberships.map(({ _problems: _, ...rest }) => rest as MembershipRow),
        };
    }

    private fileToBase64(file: File): Promise<string> {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onload = () => {
                const result = reader.result as string;
                const comma = result.indexOf(',');
                resolve(comma >= 0 ? result.slice(comma + 1) : result);
            };
            reader.onerror = () => reject(reader.error);
            reader.readAsDataURL(file);
        });
    }

    private guessMimeType(fileName: string): string {
        const lower = fileName.toLowerCase();
        if (lower.endsWith('.xlsx')) return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
        if (lower.endsWith('.xls')) return 'application/vnd.ms-excel';
        if (lower.endsWith('.csv')) return 'text/csv';
        return 'application/octet-stream';
    }
}

export function LoadBulkImportPanelComponent() { /* prevents tree-shaking */ }
