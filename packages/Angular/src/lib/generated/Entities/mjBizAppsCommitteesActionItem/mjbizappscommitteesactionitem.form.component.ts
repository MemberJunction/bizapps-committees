import { Component } from '@angular/core';
import { mjBizAppsCommitteesActionItemEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';

@RegisterClass(BaseFormComponent, 'Committees: Action Items') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommitteesactionitem-form',
    templateUrl: './mjbizappscommitteesactionitem.form.component.html'
})
export class mjBizAppsCommitteesActionItemFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommitteesActionItemEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'details', sectionName: 'Details', isExpanded: true }
        ]);
    }
}

