import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { BaseFormsModule } from '@memberjunction/ng-base-forms';

import { CommitteeHeaderPanel } from './form-panels/committee-header.panel';
import { CommitteeOverviewPanel } from './form-panels/committee-overview.panel';
import { MeetingHeaderPanel } from './form-panels/meeting-header.panel';
import { MeetingOverviewPanel } from './form-panels/meeting-overview.panel';

const PANELS = [
    CommitteeHeaderPanel,
    CommitteeOverviewPanel,
    MeetingHeaderPanel,
    MeetingOverviewPanel,
];

@NgModule({
    imports: [
        CommonModule,
        BaseFormsModule,
        CommitteeHeaderPanel,
        CommitteeOverviewPanel,
        MeetingHeaderPanel,
        MeetingOverviewPanel,
    ],
    exports: [...PANELS],
})
export class CustomFormsModule {}
