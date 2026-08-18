import { Component, Input, Output, EventEmitter, OnInit, OnChanges, SimpleChanges, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RunView, CompositeKey } from '@memberjunction/core';
import { FormNavigationEvent, RecordNavigationEvent } from '@memberjunction/ng-base-forms';
import { UUIDsEqual } from '@memberjunction/global';

export interface RosterMemberItem {
    ID: string;
    PersonID: string;
    PersonName: string;
    Role: string;
    RoleCategory: 'officer' | 'member' | 'liaison';
    IsVoting: boolean;
    TermName: string;
    StartDate: string | null;
    EndDate: string | null;
    Status: 'Active' | 'Upcoming' | 'Expiring Soon' | 'Expired';
    DaysRemaining: number | null;
    TotalMeetings: number;
    AttendedMeetings: number;
    AttendanceRate: number;
    RawRecord: Record<string, unknown>;
}

/**
 * Interactive Committee Roster and Term Tracker Component.
 *
 * Displays active and historical committee members grouped by leadership officers
 * and general members, with real-time term countdowns, attendance track records,
 * and quick navigation to individual records.
 */
@Component({
    selector: 'bizapps-committee-roster',
    standalone: true,
    imports: [CommonModule, FormsModule],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: './committee-roster.component.html',
    styleUrls: ['./committee-roster.component.css']
})
export class CommitteeRosterComponent implements OnInit, OnChanges {
    private cdr = inject(ChangeDetectorRef);

    @Input() CommitteeID!: string;

    @Output() Navigate = new EventEmitter<FormNavigationEvent>();

    public Loading = false;
    public ErrorMessage: string | null = null;

    public AllMembers: RosterMemberItem[] = [];
    public FilteredMembers: RosterMemberItem[] = [];

    // Filter & Search State
    public ActiveFilter: 'all' | 'officers' | 'active' | 'expiring' | 'expired' = 'active';
    public SearchQuery = '';

    // Summary Metrics
    public TotalActiveCount = 0;
    public OfficerCount = 0;
    public ExpiringCount = 0;
    public AvgAttendanceRate = 0;

    public ngOnInit(): void {
        if (this.CommitteeID) {
            this.loadRosterData();
        }
    }

    public ngOnChanges(changes: SimpleChanges): void {
        if (changes['CommitteeID'] && !changes['CommitteeID'].isFirstChange()) {
            this.loadRosterData();
        }
    }

    public async loadRosterData(): Promise<void> {
        if (!this.CommitteeID) return;

        this.Loading = true;
        this.ErrorMessage = null;
        this.cdr.detectChanges();

        try {
            const rv = new RunView();

            // Run views in parallel for memberships and meeting attendance
            const results = await rv.RunViews([
                {
                    EntityName: 'Committees: Committee Memberships',
                    ExtraFilter: `CommitteeID='${this.CommitteeID}'`,
                    OrderBy: 'Role ASC, Person ASC',
                    ResultType: 'simple'
                },
                {
                    EntityName: 'Committees: Meeting Attendance',
                    ExtraFilter: `Meeting IN (SELECT ID FROM [__mj_BizApps_Committees].[Meeting] WHERE CommitteeID='${this.CommitteeID}')`,
                    ResultType: 'simple'
                }
            ]);

            const membershipResult = results[0];
            const attendanceResult = results[1];

            if (!membershipResult?.Success) {
                this.ErrorMessage = membershipResult?.ErrorMessage || 'Failed to load committee memberships.';
                return;
            }

            const rawMemberships = (membershipResult.Results as Record<string, unknown>[]) || [];
            const rawAttendance = attendanceResult?.Success ? (attendanceResult.Results as Record<string, unknown>[]) || [] : [];

            // Compute attendance metrics map by PersonID
            const attendanceMap = new Map<string, { total: number; attended: number }>();
            for (const att of rawAttendance) {
                const personId = String(att['PersonID'] ?? att['Person'] ?? '');
                if (!personId) continue;

                const curr = attendanceMap.get(personId) || { total: 0, attended: 0 };
                curr.total++;
                const status = String(att['AttendanceStatus'] ?? att['Status'] ?? '').toLowerCase();
                if (status === 'attended' || status === 'present' || status === 'virtual') {
                    curr.attended++;
                }
                attendanceMap.set(personId, curr);
            }

            const now = new Date();
            const members: RosterMemberItem[] = [];

            let activeCount = 0;
            let officerCount = 0;
            let expiringCount = 0;
            let totalAttRateSum = 0;
            let membersWithAttendanceCount = 0;

            for (const m of rawMemberships) {
                const id = String(m['ID'] ?? '');
                const personId = String(m['PersonID'] ?? '');
                const personName = String(m['Person'] ?? m['PersonName'] ?? 'Unknown Member');
                const role = String(m['Role'] ?? m['RoleName'] ?? 'Member');
                const isVoting = Boolean(m['IsVotingMember'] ?? true);
                const termName = String(m['Term'] ?? m['TermName'] ?? '');
                const startDate = m['StartDate'] ? String(m['StartDate']) : null;
                const endDate = m['EndDate'] ? String(m['EndDate']) : null;

                // Role categorization
                const roleLower = role.toLowerCase();
                let roleCategory: 'officer' | 'member' | 'liaison' = 'member';
                if (roleLower.includes('chair') || roleLower.includes('president') || roleLower.includes('secretary') || roleLower.includes('treasurer') || roleLower.includes('lead')) {
                    roleCategory = 'officer';
                    officerCount++;
                } else if (roleLower.includes('liaison') || roleLower.includes('advisor') || roleLower.includes('staff')) {
                    roleCategory = 'liaison';
                }

                // Term status calculation
                let status: 'Active' | 'Upcoming' | 'Expiring Soon' | 'Expired' = 'Active';
                let daysRemaining: number | null = null;

                if (endDate) {
                    const end = new Date(endDate);
                    const diffTime = end.getTime() - now.getTime();
                    daysRemaining = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

                    if (daysRemaining < 0) {
                        status = 'Expired';
                    } else if (daysRemaining <= 60) {
                        status = 'Expiring Soon';
                        expiringCount++;
                        activeCount++;
                    } else {
                        status = 'Active';
                        activeCount++;
                    }
                } else {
                    status = 'Active';
                    activeCount++;
                }

                if (startDate) {
                    const start = new Date(startDate);
                    if (start > now) {
                        status = 'Upcoming';
                    }
                }

                // Attendance stats
                const attStats = attendanceMap.get(personId) || { total: 0, attended: 0 };
                const attRate = attStats.total > 0 ? Math.round((attStats.attended / attStats.total) * 100) : 100;
                if (attStats.total > 0) {
                    totalAttRateSum += attRate;
                    membersWithAttendanceCount++;
                }

                members.push({
                    ID: id,
                    PersonID: personId,
                    PersonName: personName,
                    Role: role,
                    RoleCategory: roleCategory,
                    IsVoting: isVoting,
                    TermName: termName,
                    StartDate: startDate,
                    EndDate: endDate,
                    Status: status,
                    DaysRemaining: daysRemaining,
                    TotalMeetings: attStats.total,
                    AttendedMeetings: attStats.attended,
                    AttendanceRate: attRate,
                    RawRecord: m
                });
            }

            this.AllMembers = members;
            this.TotalActiveCount = activeCount;
            this.OfficerCount = officerCount;
            this.ExpiringCount = expiringCount;
            this.AvgAttendanceRate = membersWithAttendanceCount > 0 ? Math.round(totalAttRateSum / membersWithAttendanceCount) : 100;

            this.applyFilters();
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Error loading roster data.';
            console.error('CommitteeRoster: Error loading roster', err);
        } finally {
            this.Loading = false;
            this.cdr.detectChanges();
        }
    }

    public setFilter(filter: 'all' | 'officers' | 'active' | 'expiring' | 'expired'): void {
        this.ActiveFilter = filter;
        this.applyFilters();
    }

    public onSearchChange(): void {
        this.applyFilters();
    }

    private applyFilters(): void {
        let list = [...this.AllMembers];

        // 1. Tab filter
        switch (this.ActiveFilter) {
            case 'officers':
                list = list.filter((m) => m.RoleCategory === 'officer');
                break;
            case 'active':
                list = list.filter((m) => m.Status === 'Active' || m.Status === 'Expiring Soon');
                break;
            case 'expiring':
                list = list.filter((m) => m.Status === 'Expiring Soon');
                break;
            case 'expired':
                list = list.filter((m) => m.Status === 'Expired');
                break;
            case 'all':
            default:
                break;
        }

        // 2. Search query filter
        const q = this.SearchQuery.trim().toLowerCase();
        if (q) {
            list = list.filter(
                (m) =>
                    m.PersonName.toLowerCase().includes(q) ||
                    m.Role.toLowerCase().includes(q) ||
                    m.TermName.toLowerCase().includes(q)
            );
        }

        this.FilteredMembers = list;
        this.cdr.detectChanges();
    }

    public navigateToPerson(member: RosterMemberItem, event: MouseEvent): void {
        event.stopPropagation();
        if (!member.PersonID) return;

        const navEvent: RecordNavigationEvent = {
            Kind: 'record',
            EntityName: 'MJ_BizApps_Common: Persons',
            PrimaryKey: CompositeKey.FromKeyValuePair('ID', member.PersonID),
            OpenInNewTab: event.ctrlKey || event.metaKey
        };
        this.Navigate.emit(navEvent);
    }

    public navigateToMembership(member: RosterMemberItem, event: MouseEvent): void {
        event.stopPropagation();
        const navEvent: RecordNavigationEvent = {
            Kind: 'record',
            EntityName: 'Committees: Committee Memberships',
            PrimaryKey: CompositeKey.FromKeyValuePair('ID', member.ID),
            OpenInNewTab: event.ctrlKey || event.metaKey
        };
        this.Navigate.emit(navEvent);
    }
}
