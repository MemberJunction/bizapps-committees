import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { RunView } from '@memberjunction/core';

@RegisterClass(BaseResourceComponent, 'ManagementMembershipListComponent')
@Component({
    standalone: false,
    selector: 'management-membership-list',
    templateUrl: './management-membership-list.component.html',
    styleUrls: ['../shared/design-system.css', '../membership/membership-list.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class ManagementMembershipListComponent extends BaseResourceComponent implements OnInit {
    Committees: { ID: string; Name: string }[] = [];
    SelectedCommitteeID: string | null = null;
    IsLoading = true;

    private cdr = inject(ChangeDetectorRef);

    async ngOnInit(): Promise<void> {
        this.NotifyLoadStarted();
        await this.loadAllCommittees();
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

    private async loadAllCommittees(): Promise<void> {
        const rv = new RunView();
        const result = await rv.RunView<{ ID: string; Name: string }>({
            EntityName: 'Committees: Committees',
            ExtraFilter: "Status = 'Active'",
            Fields: ['ID', 'Name'],
            OrderBy: 'Name ASC',
            ResultType: 'simple'
        });

        if (result.Success && result.Results) {
            this.Committees = result.Results;
            if (this.Committees.length > 0) {
                this.SelectedCommitteeID = this.Committees[0].ID;
            }
        }
    }
}

export function LoadManagementMembershipList() { }
