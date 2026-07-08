import { Component } from '@angular/core';
import { mjBizAppsCommitteesVideoProviderEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Video Providers') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommitteesvideoprovider-form',
    templateUrl: './mjbizappscommitteesvideoprovider.form.component.html'
})
export class mjBizAppsCommitteesVideoProviderFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommitteesVideoProviderEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'details', sectionName: 'Details', isExpanded: true },
            { sectionKey: 'committeesMeetings', sectionName: 'Meetings', isExpanded: false }
        ]);
    }
}

