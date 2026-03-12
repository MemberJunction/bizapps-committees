import { Component } from '@angular/core';
import { mjCommitteesArtifactTypeEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';
import {  } from "@memberjunction/ng-entity-viewer"

@RegisterClass(BaseFormComponent, 'Artifact Types') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjcommitteesartifacttype-form',
    templateUrl: './mjcommitteesartifacttype.form.component.html'
})
export class mjCommitteesArtifactTypeFormComponent extends BaseFormComponent {
    public record!: mjCommitteesArtifactTypeEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'artifactTypeInfo', sectionName: 'Artifact Type Info', isExpanded: true },
            { sectionKey: 'extensionEntity', sectionName: 'Extension Entity', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false },
            { sectionKey: 'artifacts', sectionName: 'Artifacts', isExpanded: false }
        ]);
    }
}

