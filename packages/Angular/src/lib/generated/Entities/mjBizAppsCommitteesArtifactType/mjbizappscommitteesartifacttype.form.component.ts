import { Component } from '@angular/core';
import { mjBizAppsCommitteesArtifactTypeEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Artifact Types') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjbizappscommitteesartifacttype-form',
    templateUrl: './mjbizappscommitteesartifacttype.form.component.html'
})
export class mjBizAppsCommitteesArtifactTypeFormComponent extends BaseFormComponent {
    public record!: mjBizAppsCommitteesArtifactTypeEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'details', sectionName: 'Details', isExpanded: true },
            { sectionKey: 'committeesArtifacts', sectionName: 'Artifacts', isExpanded: false }
        ]);
    }
}

