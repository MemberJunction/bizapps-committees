import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { RunView } from '@memberjunction/core';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';

interface CommitteeOption {
    CommitteeID: string;
    CommitteeName: string;
    CategoryID: string;
    IsOfficer: boolean;
}

@RegisterClass(BaseResourceComponent, 'ActionItemTrackerComponent')
@Component({
    standalone: false,
    selector: 'committees-action-items',
    templateUrl: './action-item-tracker.component.html',
    styleUrls: ['../shared/design-system.css', './action-item-tracker.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class ActionItemTrackerComponent extends BaseResourceComponent implements OnInit {
    IsLoading = true;

    /** Current user's PersonID */
    CurrentPersonID: string | null = null;

    /** Committees the user belongs to, with resolved TaskCategory IDs */
    Committees: CommitteeOption[] = [];

    /** Currently selected committee (null = all) */
    SelectedCommitteeID: string | null = null;

    /** Whether the user is staff (has Committee Management app access) */
    IsStaff = false;

    /** Whether user is an officer/staff in the selected committee, or all committees if none selected */
    get IsOfficerInSelected(): boolean {
        if (this.IsStaff) return true;
        if (!this.SelectedCommitteeID) {
            return this.Committees.length > 0 && this.Committees.every(c => c.IsOfficer);
        }
        return this.Committees.find(c => c.CommitteeID === this.SelectedCommitteeID)?.IsOfficer ?? false;
    }

    /** CategoryID for the task panel filter */
    get SelectedCategoryID(): string | null {
        if (!this.SelectedCommitteeID) return null;
        return this.Committees.find(c => c.CommitteeID === this.SelectedCommitteeID)?.CategoryID ?? null;
    }

    /** Name of the single committee (if user is in exactly one) */
    get SingleCommitteeName(): string | null {
        return this.Committees.length === 1 ? this.Committees[0].CommitteeName : null;
    }

    /** Whether to show the dropdown vs just a name */
    get ShowDropdown(): boolean {
        return this.Committees.length > 1;
    }

    /** Active tab: 'mine' or 'all' */
    ActiveTab: 'mine' | 'all' = 'mine';

    /** Whether the My/All tab bar should be shown.
     *  Members and officers in the member app see only "My Tasks" (no toggle).
     *  Staff users see only "All Tasks" (also no toggle — handled by defaulting ActiveTab to 'all').
     *  Result: the tab bar is never shown — task management is fully scoped per app. */
    get ShowTabBar(): boolean {
        return false;
    }

    /** ExtraFilter for "My Tasks" */
    get MyTasksFilter(): string | null {
        if (!this.CurrentPersonID) return null;
        return `ID IN (SELECT TaskID FROM __mj_BizAppsTasks.TaskAssignment WHERE AssigneeRecordID = '${this.CurrentPersonID}')`;
    }

    /** Limits the assignee picker to members of the selected committee */
    get AssigneeScope(): string | null {
        if (!this.SelectedCommitteeID) return null;
        return `ID IN (SELECT m.PersonID FROM __mj_Committees.Membership m JOIN __mj_Committees.Term t ON m.TermID = t.ID WHERE t.CommitteeID = '${this.SelectedCommitteeID}' AND m.Status = 'Active')`;
    }

    private cdr = inject(ChangeDetectorRef);

    async ngOnInit(): Promise<void> {
        this.NotifyLoadStarted();
        await this.LoadContext();
        this.IsLoading = false;
        this.NotifyLoadComplete();
        this.cdr.markForCheck();
    }

    async GetResourceDisplayName(_data: ResourceData): Promise<string> {
        return 'Action Items';
    }

    async GetResourceIconClass(_data: ResourceData): Promise<string> {
        return 'fa-solid fa-clipboard-list';
    }

    /** @internal Toggled on committee change to force panel recreation. */
    PanelVisible = true;

    OnCommitteeChanged(committeeID: string): void {
        this.SelectedCommitteeID = committeeID || null;
        // Reset to My Tasks if not an officer in the new committee
        if (!this.IsOfficerInSelected) {
            this.ActiveTab = 'mine';
        }
        // Destroy and recreate the task panel so it reloads with new filters
        this.PanelVisible = false;
        this.cdr.detectChanges();
        setTimeout(() => {
            this.PanelVisible = true;
            this.cdr.detectChanges();
        });
    }

    OnTabChanged(tab: 'mine' | 'all'): void {
        this.ActiveTab = tab;
        // Same destroy/recreate to reload with new filter
        this.PanelVisible = false;
        this.cdr.detectChanges();
        setTimeout(() => {
            this.PanelVisible = true;
            this.cdr.detectChanges();
        });
    }

    private async LoadContext(): Promise<void> {
        this.CurrentPersonID = await CommitteePermissionHelper.GetCurrentPersonID();
        this.IsStaff = await CommitteePermissionHelper.IsStaffUser();

        // Staff users skip the My/All distinction — they always see All Tasks
        if (this.IsStaff) {
            this.ActiveTab = 'all';
        }

        let committeeMap: Map<string, boolean>;

        if (this.IsStaff) {
            // Staff sees all active committees
            committeeMap = await this.LoadAllCommitteeIDs();
        } else {
            // Members see only their committees
            committeeMap = await this.LoadMemberCommitteeIDs();
        }

        if (committeeMap.size === 0) return;

        await this.LoadCommitteeOptions(committeeMap);

        // If only one committee, auto-select it
        if (this.Committees.length === 1) {
            this.SelectedCommitteeID = this.Committees[0].CommitteeID;
        }
    }

    private async LoadAllCommitteeIDs(): Promise<Map<string, boolean>> {
        const rv = new RunView();
        const result = await rv.RunView<{ ID: string }>({
            EntityName: 'Committees: Committees',
            ExtraFilter: "Status = 'Active'",
            Fields: ['ID'],
            ResultType: 'simple',
        });
        const map = new Map<string, boolean>();
        if (result.Success) {
            for (const c of result.Results) {
                map.set(c.ID, true); // Staff = officer-level for all
            }
        }
        return map;
    }

    private async LoadMemberCommitteeIDs(): Promise<Map<string, boolean>> {
        const memberships = await CommitteePermissionHelper.GetCurrentUserMemberships();
        const map = new Map<string, boolean>();
        for (const m of memberships) {
            if (m.CommitteeID) {
                const existing = map.get(m.CommitteeID) ?? false;
                map.set(m.CommitteeID, existing || m.IsOfficer);
            }
        }
        return map;
    }

    private async LoadCommitteeOptions(committeeMap: Map<string, boolean>): Promise<void> {
        const committeeIDs = [...committeeMap.keys()];
        const rv = new RunView();
        const [committeesResult, categoriesResult] = await rv.RunViews([
            {
                EntityName: 'Committees: Committees',
                ExtraFilter: `ID IN (${committeeIDs.map(id => `'${id}'`).join(',')})`,
                Fields: ['ID', 'Name'],
                ResultType: 'simple',
            },
            {
                EntityName: 'MJ.BizApps.Tasks: Task Categories',
                ExtraFilter: 'IsActive = 1',
                Fields: ['ID', 'Name'],
                ResultType: 'simple',
            }
        ]);

        const committees = committeesResult?.Results ?? [];
        const categories = categoriesResult?.Results ?? [];
        const categoryByName = new Map<string, string>();
        for (const cat of categories as { ID: string; Name: string }[]) {
            categoryByName.set(cat.Name, cat.ID);
        }

        this.Committees = [];
        for (const c of committees as { ID: string; Name: string }[]) {
            const catID = categoryByName.get(c.Name);
            if (catID) {
                this.Committees.push({
                    CommitteeID: c.ID,
                    CommitteeName: c.Name,
                    CategoryID: catID,
                    IsOfficer: committeeMap.get(c.ID) ?? false,
                });
            }
        }
    }
}

export function LoadActionItemTracker() { }
