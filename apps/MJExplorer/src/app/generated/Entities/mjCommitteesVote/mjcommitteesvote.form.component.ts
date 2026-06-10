import { Component } from '@angular/core';
import { mjCommitteesVoteEntity } from '@mj-biz-apps/committees-entities';
import { RegisterClass } from '@memberjunction/global';
import { BaseFormComponent } from '@memberjunction/ng-base-forms';

@RegisterClass(BaseFormComponent, 'Committees: Votes') // Tell MemberJunction about this class
@Component({
    standalone: false,
    selector: 'gen-mjcommitteesvote-form',
    templateUrl: './mjcommitteesvote.form.component.html'
})
export class mjCommitteesVoteFormComponent extends BaseFormComponent {
    public record!: mjCommitteesVoteEntity;

    override async ngOnInit() {
        await super.ngOnInit();
        this.initSections([
            { sectionKey: 'voteContext', sectionName: 'Vote Context', isExpanded: true },
            { sectionKey: 'voteDetails', sectionName: 'Vote Details', isExpanded: true },
            { sectionKey: 'systemMetadata', sectionName: 'System Metadata', isExpanded: false }
        ]);
    }
}

