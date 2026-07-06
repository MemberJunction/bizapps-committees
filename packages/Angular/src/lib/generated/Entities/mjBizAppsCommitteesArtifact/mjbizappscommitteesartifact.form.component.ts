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
            { sectionKey: 'relationships', sectionName: 'Relationships', isExpanded: true },
            { sectionKey: 'artifactDetails', sectionName: 'Artifact Details', isExpanded: true },
            { sectionKey: 'artifactClassification', sectionName: 'Artifact Classification', isExpanded: true },
            { sectionKey: 'sourceInformation', sectionName: 'Source Information', isExpanded: true },
            { sectionKey: 'technicalMetadata', sectionName: 'Technical Metadata', isExpanded: false },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesComments', sectionName: 'Comments', isExpanded: false },
            { sectionKey: 'committeesMinutes', sectionName: 'Minutes', isExpanded: false }
        ]);
    }
}

