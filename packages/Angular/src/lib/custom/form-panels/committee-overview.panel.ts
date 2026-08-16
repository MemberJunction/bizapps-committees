import { Component, ChangeDetectionStrategy, OnInit, inject, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RunView } from '@memberjunction/core';
import { RegisterClassEx } from '@memberjunction/global';
import { BaseFormPanel } from '@memberjunction/ng-base-forms';
import { mjBizAppsCommitteesCommitteeEntity } from '@mj-biz-apps/committees-entities';

interface MeetingRow {
    ID: string;
    Name: string;
    StartDateTime: string;
    LocationType: string;
}

@RegisterClassEx(BaseFormPanel, {
    key: 'form-panel:Committees:overview',
    metadata: {
        entity: 'Committees: Committees',
        slot: 'before-fields',
        sortKey: 10,
    },
})
@Component({
    selector: 'bizapps-committee-overview-panel',
    standalone: true,
    imports: [CommonModule],
    changeDetection: ChangeDetectionStrategy.OnPush,
    template: `
        <div class="mj-committee-overview-grid">
            <!-- Card 1: Upcoming Meetings -->
            <div class="mj-overview-card">
                <div class="mj-card-header">
                    <div class="mj-card-title"><i class="fa-solid fa-calendar-days" style="color: var(--mj-brand-primary, #38bdf8);"></i> Scheduled Meetings</div>
                    <span class="mj-card-badge">{{ Meetings.length }} Sessions</span>
                </div>
                <div class="mj-card-body">
                    @if (Meetings.length === 0) {
                        <span style="font-size: 12px; color: var(--mj-text-muted);">No upcoming meetings scheduled.</span>
                    } @else {
                        @for (m of Meetings; track m.ID) {
                            <div class="mj-metric-row">
                                <span class="mj-metric-label">{{ m.Name }}</span>
                                <span class="mj-pill mj-pill-blue">{{ m.LocationType || 'Hybrid' }}</span>
                            </div>
                        }
                    }
                </div>
            </div>

            <!-- Card 2: Committee Governance -->
            <div class="mj-overview-card">
                <div class="mj-card-header">
                    <div class="mj-card-title"><i class="fa-solid fa-scale-balanced" style="color: #10b981;"></i> Committee Charter</div>
                    <span class="mj-card-badge">Charter</span>
                </div>
                <div class="mj-card-body">
                    <div class="mj-metric-row">
                        <span class="mj-metric-label">Committee Name</span>
                        <span class="mj-metric-val">{{ Committee?.Name }}</span>
                    </div>
                    <div class="mj-metric-row">
                        <span class="mj-metric-label">Quorum Status</span>
                        <span class="mj-pill mj-pill-green">Active Mandate</span>
                    </div>
                </div>
            </div>
        </div>
    `,
    styles: [`
        :host { display: block; width: 100%; margin-bottom: 20px; }
        .mj-committee-overview-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 16px;
        }
        .mj-overview-card {
            background: var(--mj-bg-surface-card, #141f36);
            border: 1px solid var(--mj-border-default, #223254);
            border-radius: 10px;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        .mj-card-header {
            padding: 10px 14px;
            background: var(--mj-bg-surface, #111a2e);
            border-bottom: 1px solid var(--mj-border-default, #223254);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .mj-card-title {
            font-size: 12.5px;
            font-weight: 700;
            color: var(--mj-text-primary, #f8fafc);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .mj-card-badge {
            font-size: 11px;
            padding: 2px 7px;
            border-radius: 9999px;
            background: var(--mj-bg-surface-elevated, #1a2744);
            color: var(--mj-text-secondary, #94a3b8);
            border: 1px solid var(--mj-border-default, #223254);
        }
        .mj-card-body {
            padding: 14px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .mj-metric-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 12px;
        }
        .mj-metric-label { color: var(--mj-text-secondary, #94a3b8); }
        .mj-metric-val { font-weight: 600; color: var(--mj-text-primary, #f8fafc); font-family: monospace; }
        .mj-pill { font-size: 10.5px; font-weight: 700; padding: 2px 6px; border-radius: 4px; }
        .mj-pill-green { background: rgba(16, 185, 129, 0.15); color: #10b981; }
        .mj-pill-blue { background: rgba(56, 189, 248, 0.15); color: #38bdf8; }
    `]
})
export class CommitteeOverviewPanel extends BaseFormPanel<mjBizAppsCommitteesCommitteeEntity> implements OnInit {
    private cdr = inject(ChangeDetectorRef);
    public Meetings: MeetingRow[] = [];

    public get Committee(): mjBizAppsCommitteesCommitteeEntity | null {
        return this.Record;
    }

    public ngOnInit(): void {
        this.LoadUpcomingMeetings();
    }

    private async LoadUpcomingMeetings(): Promise<void> {
        if (!this.Record?.ID) return;
        try {
            const rv = new RunView();
            const res = await rv.RunView<MeetingRow>({
                EntityName: 'Committees: Meetings',
                ExtraFilter: `CommitteeID = '${this.Record.ID}'`,
                Fields: ['ID', 'Name', 'StartDateTime', 'LocationType'],
                OrderBy: 'StartDateTime DESC',
                MaxRows: 10,
                ResultType: 'simple'
            });
            if (res.Success && res.Results) {
                this.Meetings = res.Results;
                this.cdr.markForCheck();
            }
        } catch (e) {
            console.error('Failed to load committee meetings:', e);
        }
    }
}
