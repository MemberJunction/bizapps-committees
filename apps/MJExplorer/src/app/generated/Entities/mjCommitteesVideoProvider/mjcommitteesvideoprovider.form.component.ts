import { Component } from '@angular/core';
import { mjCommitteesVideoProviderEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Video Providers') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjcommitteesvideoprovider-form',
    templateUrl: './mjcommitteesvideoprovider.form.component.html'
})
export class mjCommitteesVideoProviderFormComponent extends BaseFormComponent {
    public record!: mjCommitteesVideoProviderEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'providerDetails', sectionName: 'Provider Details', isExpanded: true },
            { sectionKey: 'accessConfiguration', sectionName: 'Access Configuration', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesMeetings', sectionName: 'Committees: Meetings', isExpanded: false }
        ]);
    }
}

