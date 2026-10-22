import { Component, ChangeDetectionStrategy, OnInit, inject, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RunView } from '@memberjunction/core';
import { RegisterClassEx } from '@memberjunction/global';
import { BaseFormPanel } from '@memberjunction/ng-base-forms';
import { mjBizAppsCommitteesMeetingEntity } from '@mj-biz-apps/committees-entities';

interface AgendaItemRow {
    ID: string;
    Name: string;
    Title?: string;
    Sequence: number;
    DurationMinutes: number;
}

@RegisterClassEx(BaseFormPanel, {
    key: 'form-panel:Meetings:overview',
    metadata: {
        entity: 'Committees: Meetings',
        slot: 'before-fields',
        sortKey: 10,
    },
})
@Component({
    selector: 'bizapps-meeting-overview-panel',
    standalone: true,
    imports: [CommonModule],
    changeDetection: ChangeDetectionStrategy.OnPush,
    template: `
        <div class="mj-meeting-overview-grid">
            <!-- Card 1: Agenda Topics -->
            <div class="mj-overview-card">
                <div class="mj-card-header">
                    <div class="mj-card-title"><i class="fa-solid fa-list-check" style="color: var(--mj-brand-primary, #38bdf8);"></i> Meeting Agenda</div>
                    <span class="mj-card-badge">{{ AgendaItems.length }} Topics</span>
                </div>
                <div class="mj-card-body">
                    @if (AgendaItems.length === 0) {
                        <span style="font-size: 12px; color: var(--mj-text-muted);">No agenda items published for this meeting.</span>
                    } @else {
                        @for (item of AgendaItems; track item.ID) {
                            <div class="mj-metric-row">
                                <span class="mj-metric-label" [title]="item.Name || item.Title || ''">{{ item.Sequence }}. {{ item.Name || item.Title }}</span>
                                <span class="mj-pill mj-pill-blue">{{ item.DurationMinutes || 15 }}m</span>
                            </div>
                        }
                    }
                </div>
            </div>

            <!-- Card 2: Meeting Logistics -->
            <div class="mj-overview-card">
                <div class="mj-card-header">
                    <div class="mj-card-title"><i class="fa-solid fa-video" style="color: #10b981;"></i> Meeting Logistics</div>
                    <span class="mj-card-badge">Details</span>
                </div>
                <div class="mj-card-body">
                    <div class="mj-metric-row">
                        <span class="mj-metric-label">Meeting Name</span>
                        <span class="mj-metric-val">{{ Meeting?.Name }}</span>
                    </div>
                    <div class="mj-metric-row">
                        <span class="mj-metric-label">Location Type</span>
                        <span class="mj-pill mj-pill-green">{{ Meeting?.LocationType || 'Hybrid' }}</span>
                    </div>
                    <div class="mj-metric-row">
                        <span class="mj-metric-label">Time Zone</span>
                        <span class="mj-metric-val">{{ Meeting?.TimeZone || 'UTC' }}</span>
                    </div>
                </div>
            </div>
        </div>
    `,
    styles: [`
        :host { display: block; width: 100%; margin-bottom: 20px; }
        .mj-meeting-overview-grid {
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
            gap: 12px;
        }
        .mj-metric-label {
            color: var(--mj-text-secondary, #94a3b8);
            flex: 1;
            min-width: 0;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .mj-metric-val { font-weight: 600; color: var(--mj-text-primary, #f8fafc); font-family: monospace; }
        .mj-pill { font-size: 10.5px; font-weight: 700; padding: 2px 6px; border-radius: 4px; flex-shrink: 0; }
        .mj-pill-green { background: rgba(16, 185, 129, 0.15); color: #10b981; }
        .mj-pill-blue { background: rgba(56, 189, 248, 0.15); color: #38bdf8; }
    `]
})
export class MeetingOverviewPanel extends BaseFormPanel<mjBizAppsCommitteesMeetingEntity> implements OnInit {
    private cdr = inject(ChangeDetectorRef);
    public AgendaItems: AgendaItemRow[] = [];

    public get Meeting(): mjBizAppsCommitteesMeetingEntity | null {
        return this.Record;
    }

    public ngOnInit(): void {
        this.LoadAgendaItems();
    }

    private async LoadAgendaItems(): Promise<void> {
        if (!this.Record?.ID) return;
        try {
            const rv = new RunView();
            const res = await rv.RunView<AgendaItemRow>({
                EntityName: 'Committees: Agenda Items',
                ExtraFilter: `MeetingID = '${this.Record.ID}'`,
                Fields: ['ID', 'Name', 'Sequence', 'DurationMinutes'],
                OrderBy: 'Sequence ASC',
                MaxRows: 20,
                ResultType: 'simple'
            });
            if (res.Success && res.Results) {
                this.AgendaItems = res.Results;
                this.cdr.markForCheck();
            }
        } catch (e) {
            console.error('Failed to load meeting agenda items:', e);
        }
    }
}
