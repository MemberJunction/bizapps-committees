import { Component } from '@angular/core';
import { mjBizAppsCommitteesTermEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Terms') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommitteesterm-form',
    templateUrl: './mjbizappscommitteesterm.form.component.html'
})
export class mjBizAppsCommitteesTermFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommitteesTermEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'committeeReference', sectionName: 'Committee Reference', isExpanded: true },
            { sectionKey: 'termDetails', sectionName: 'Term Details', isExpanded: true },
            { sectionKey: 'termTimeline', sectionName: 'Term Timeline', isExpanded: true },
            { sectionKey: 'termStatus', sectionName: 'Term Status', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesMemberships', sectionName: 'Memberships', isExpanded: false }
        ]);
    }
}

