import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { Metadata, RunView } from '@memberjunction/core';

@RegisterClass(BaseResourceComponent, 'MembershipListComponent')
@Component({
    standalone: false,
    selector: 'committees-membership-list',
    templateUrl: './membership-list.component.html',
    styleUrls: ['../shared/design-system.css', './membership-list.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class MembershipListComponent extends BaseResourceComponent implements OnInit {
    Committees: { ID: string; Name: string }[] = [];
    SelectedCommitteeID: string | null = null;
    IsLoading = true;

    private cdr = inject(ChangeDetectorRef);

    async ngOnInit(): Promise<void> {
        this.NotifyLoadStarted();
        await this.LoadMyCommittees();
        this.IsLoading = false;
        this.NotifyLoadComplete();
        this.cdr.markForCheck();
    }

    async GetResourceDisplayName(_data: ResourceData): Promise<string> {
        return 'Members';
    }

    async GetResourceIconClass(_data: ResourceData): Promise<string> {
        return 'fa-solid fa-user-group';
    }

    OnCommitteeChanged(committeeID: string | null): void {
        this.SelectedCommitteeID = committeeID;
        this.cdr.markForCheck();
    }

    private async LoadMyCommittees(): Promise<void> {
        const md = new Metadata();
        const userID = md.CurrentUser?.ID;
        if (!userID) return;

        const rv = new RunView();

        // User → Person
        const personResult = await rv.RunView<{ ID: string }>({
            EntityName: 'MJ.BizApps.Common: People',
            ExtraFilter: `LinkedUserID = '${userID}'`,
            Fields: ['ID'],
            MaxRows: 1,
            ResultType: 'simple'
        });
        if (!personResult.Success || !personResult.Results || personResult.Results.length === 0) return;

        const personID = personResult.Results[0].ID;

        // Person → Memberships → Terms
        const memberResult = await rv.RunView<{ TermID: string }>({
            EntityName: 'Committees: Memberships',
            ExtraFilter: `PersonID = '${personID}' AND Status = 'Active'`,
            Fields: ['TermID'],
            ResultType: 'simple'
        });
        if (!memberResult.Success || !memberResult.Results || memberResult.Results.length === 0) return;

        const termIDs = [...new Set(memberResult.Results.map(m => m.TermID))];
        const termIDsStr = termIDs.map(id => `'${id}'`).join(',');

        // Terms → Committees
        const termResult = await rv.RunView<{ CommitteeID: string }>({
            EntityName: 'Committees: Terms',
            ExtraFilter: `ID IN (${termIDsStr})`,
            Fields: ['CommitteeID'],
            ResultType: 'simple'
        });
        if (!termResult.Success || !termResult.Results) return;

        const committeeIDs = [...new Set(termResult.Results.map(t => t.CommitteeID))];
        if (committeeIDs.length === 0) return;

        const committeeIDsStr = committeeIDs.map(id => `'${id}'`).join(',');
        const committeesResult = await rv.RunView<{ ID: string; Name: string }>({
            EntityName: 'Committees: Committees',
            ExtraFilter: `ID IN (${committeeIDsStr})`,
            Fields: ['ID', 'Name'],
            OrderBy: 'Name ASC',
            ResultType: 'simple'
        });

        if (committeesResult.Success && committeesResult.Results) {
            this.Committees = committeesResult.Results;
            // Auto-select first committee
            if (this.Committees.length > 0) {
                this.SelectedCommitteeID = this.Committees[0].ID;
            }
        }
    }
}

export function LoadMembershipList() { }
