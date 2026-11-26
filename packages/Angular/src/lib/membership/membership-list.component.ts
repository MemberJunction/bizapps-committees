import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { RunView } from '@memberjunction/core';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';

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
        await this.loadMyCommittees();
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

    private async loadMyCommittees(): Promise<void> {
        const memberships = await CommitteePermissionHelper.GetCurrentUserMemberships();
        const committeeIDs = [...new Set(memberships.map(m => m.CommitteeID).filter(Boolean))];
        if (committeeIDs.length === 0) return;

        const rv = new RunView();
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
