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
            { sectionKey: 'providerSettings', sectionName: 'Provider Settings', isExpanded: true },
            { sectionKey: 'providerStatus', sectionName: 'Provider Status', isExpanded: true },
            { sectionKey: 'credentials', sectionName: 'Credentials', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesMeetings', sectionName: 'Meetings', isExpanded: false }
        ]);
    }
}

