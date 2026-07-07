import { Component } from '@angular/core';
import { mjBizAppsCommitteesArtifactEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Artifacts') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommitteesartifact-form',
    templateUrl: './mjbizappscommitteesartifact.form.component.html'
})
export class mjBizAppsCommitteesArtifactFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommitteesArtifactEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'details', sectionName: 'Details', isExpanded: true },
            { sectionKey: 'committeesComments', sectionName: 'Comments', isExpanded: false },
            { sectionKey: 'committeesMinutes', sectionName: 'Minutes', isExpanded: false }
        ]);
    }
}

