import { Component } from '@angular/core';
import { mjBizAppsCommitteesBallotEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';

@RegisterClass(BaseFormComponent, 'Committees: Ballots') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommitteesballot-form',
    templateUrl: './mjbizappscommitteesballot.form.component.html'
})
export class mjBizAppsCommitteesBallotFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommitteesBallotEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'details', sectionName: 'Details', isExpanded: true }
        ]);
    }
}

