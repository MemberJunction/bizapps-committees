import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { BaseFormsModule } from '@memberjunction/ng-base-forms';

import { CommitteeHeaderPanel } from './form-panels/committee-header.panel';
import { CommitteeOverviewPanel } from './form-panels/committee-overview.panel';
import { CommitteeGovernanceTreePanel } from './form-panels/committee-governance-tree.panel';
import { CommitteeRosterPanel } from './form-panels/committee-roster.panel';
import { PersonCommitteesPanel } from './form-panels/person-committees.panel';
import { MeetingHeaderPanel } from './form-panels/meeting-header.panel';
import { MeetingOverviewPanel } from './form-panels/meeting-overview.panel';

const PANELS = [
    CommitteeHeaderPanel,
    CommitteeOverviewPanel,
    CommitteeGovernanceTreePanel,
    CommitteeRosterPanel,
    PersonCommitteesPanel,
    MeetingHeaderPanel,
    MeetingOverviewPanel,
];

@NgModule({
    imports: [
        CommonModule,
        BaseFormsModule,
        ...PANELS
    ],
    exports: [...PANELS],
})
export class CustomFormsModule {}
