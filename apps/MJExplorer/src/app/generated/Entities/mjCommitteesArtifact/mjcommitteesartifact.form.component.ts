import { Component } from '@angular/core';
import { mjCommitteesArtifactEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Committees: Artifacts') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjcommitteesartifact-form',
    templateUrl: './mjcommitteesartifact.form.component.html'
})
export class mjCommitteesArtifactFormComponent extends BaseFormComponent {
    public record!: mjCommitteesArtifactEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'relationships', sectionName: 'Relationships', isExpanded: true },
            { sectionKey: 'artifactDetails', sectionName: 'Artifact Details', isExpanded: true },
            { sectionKey: 'externalReference', sectionName: 'External Reference', isExpanded: true },
            { sectionKey: 'fileMetadata', sectionName: 'File Metadata', isExpanded: false },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'committeesMinutes', sectionName: 'Minutes', isExpanded: false },
            { sectionKey: 'committeesComments', sectionName: 'Comments', isExpanded: false }
        ]);
    }
}

