import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { Metadata, RunView } from '@memberjunction/core';
import { DocumentDialogResult } from './document-edit-dialog.component';
import { DocumentPreviewClosedEvent } from './document-preview-panel.component';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';

type DateRangeFilter = 'all' | '7d' | '30d' | '90d' | 'year';

interface CommitteeOption {
    ID: string;
    Name: string;
}

@RegisterClass(BaseResourceComponent, 'DocumentBrowserComponent')
@Component({
    standalone: false,
    selector: 'committees-documents',
    templateUrl: './document-browser.component.html',
    styleUrls: ['../shared/design-system.css', './document-browser.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class DocumentBrowserComponent extends BaseResourceComponent implements OnInit {
    Files: Record<string, unknown>[] = [];
    FilteredFiles: Record<string, unknown>[] = [];
    Categories: Record<string, unknown>[] = [];
    IsLoading = true;

    /** Filter state */
    SearchText = '';
    CategoryFilter = 'All';
    CategoryFilterOptions: string[] = ['All'];
    CommitteeFilter: string = 'all';
    Committees: CommitteeOption[] = [];
    DateRangeFilter: DateRangeFilter = 'all';

    /** Dialog state */
    ShowEditDialog = false;
    EditingFileID: string | null = null;

    /** Preview panel state */
    ShowPreviewPanel = false;
    PreviewFileID: string | null = null;

    /** Permission state */
    IsStaff = false;
    /** True when the user can upload/edit documents — staff or any officer.
     *  Documents are participation-level (chairs share materials), unlike other CRUD which is staff-only. */
    CanManageDocuments = false;

    /** Whether to show the committee filter dropdown — only useful when 2+ committees are visible. */
    get ShowCommitteeDropdown(): boolean {
        return this.Committees.length > 1;
    }

    private cdr = inject(ChangeDetectorRef);

    async ngOnInit(): Promise<void> {
        this.NotifyLoadStarted();
        await Promise.all([
            this.LoadFiles(),
            this.LoadPermissions()
        ]);
        this.IsLoading = false;
        this.NotifyLoadComplete();
        this.cdr.markForCheck();
    }

    async GetResourceDisplayName(_data: ResourceData): Promise<string> {
        return 'Documents';
    }

    async GetResourceIconClass(_data: ResourceData): Promise<string> {
        return 'fa-solid fa-folder-open';
    }

    OnSearchChanged(text: string): void {
        this.SearchText = text;
        this.ApplyFilters();
    }

    OnCategoryFilterChanged(category: string): void {
        this.CategoryFilter = category;
        this.ApplyFilters();
    }

    OnCommitteeFilterChanged(committeeID: string): void {
        this.CommitteeFilter = committeeID;
        this.ApplyFilters();
    }

    OnDateRangeChanged(range: DateRangeFilter): void {
        this.DateRangeFilter = range;
        this.ApplyFilters();
    }

    OnCreateDocument(): void {
        this.EditingFileID = null;
        this.ShowEditDialog = true;
        this.cdr.markForCheck();
    }

    OnOpenDocument(url: string, event: MouseEvent): void {
        event.stopPropagation();
        window.open(url, '_blank');
    }

    /** Card click → open the inline preview panel (anyone can view). */
    OnPreviewDocument(fileID: string): void {
        this.PreviewFileID = fileID;
        this.ShowPreviewPanel = true;
        this.cdr.markForCheck();
    }

    /** Preview panel closed. If user clicked Edit, transition to the edit dialog. */
    OnPreviewClosed(event: DocumentPreviewClosedEvent): void {
        this.ShowPreviewPanel = false;
        if (event.OpenEdit && this.CanManageDocuments && event.FileID) {
            this.EditingFileID = event.FileID;
            this.ShowEditDialog = true;
        }
        this.PreviewFileID = null;
        this.cdr.markForCheck();
    }

    async OnDialogClosed(result: DocumentDialogResult): Promise<void> {
        this.ShowEditDialog = false;
        if (result.Saved) {
            await this.LoadFiles();
        }
        this.cdr.markForCheck();
    }

    GetDocIcon(categoryName: string): string {
        switch (categoryName) {
            case 'Agenda': return 'fa-solid fa-list-ol';
            case 'Minutes': return 'fa-solid fa-file-lines';
            case 'Recording': return 'fa-solid fa-video';
            case 'Transcript': return 'fa-solid fa-closed-captioning';
            case 'Spreadsheet': return 'fa-solid fa-file-excel';
            case 'Presentation': return 'fa-solid fa-file-powerpoint';
            case 'Image': return 'fa-solid fa-file-image';
            case 'Document': return 'fa-solid fa-file-word';
            default: return 'fa-solid fa-file';
        }
    }

    private async LoadPermissions(): Promise<void> {
        const [isStaff, isOfficer] = await Promise.all([
            CommitteePermissionHelper.IsStaffUser(),
            CommitteePermissionHelper.IsOfficerInAny()
        ]);
        this.IsStaff = isStaff;
        this.CanManageDocuments = isStaff || isOfficer;
    }

    private ApplyFilters(): void {
        let result = this.Files;

        if (this.CategoryFilter !== 'All') {
            result = result.filter(f => f['Category'] === this.CategoryFilter);
        }

        if (this.CommitteeFilter !== 'all') {
            result = result.filter(f => {
                const committeeIDs = (f['CommitteeIDs'] as string[]) ?? [];
                return committeeIDs.includes(this.CommitteeFilter);
            });
        }

        const cutoff = this.GetDateRangeCutoff();
        if (cutoff) {
            result = result.filter(f => {
                const created = f['__mj_CreatedAt'] as string | Date | null;
                if (!created) return false;
                return new Date(created).getTime() >= cutoff;
            });
        }

        if (this.SearchText.trim()) {
            const term = this.SearchText.toLowerCase();
            result = result.filter(f =>
                (f['Name'] as string || '').toLowerCase().includes(term) ||
                (f['Description'] as string || '').toLowerCase().includes(term)
            );
        }

        this.FilteredFiles = result;
        this.cdr.markForCheck();
    }

    /** Returns timestamp ms for "files created on/after this", or null for "all time". */
    private GetDateRangeCutoff(): number | null {
        if (this.DateRangeFilter === 'all') return null;
        const now = new Date();
        const cutoff = new Date(now);
        switch (this.DateRangeFilter) {
            case '7d': cutoff.setDate(now.getDate() - 7); break;
            case '30d': cutoff.setDate(now.getDate() - 30); break;
            case '90d': cutoff.setDate(now.getDate() - 90); break;
            case 'year': cutoff.setMonth(0, 1); cutoff.setHours(0, 0, 0, 0); break;
        }
        return cutoff.getTime();
    }

    private async LoadFiles(): Promise<void> {
        const rv = new RunView();
        const md = new Metadata();

        // Resolve scoping up front so we can filter committees/files appropriately.
        const isStaff = await CommitteePermissionHelper.IsStaffUser();
        const memberCommitteeIDs = isStaff
            ? null  // null = no scoping (staff sees all)
            : await CommitteePermissionHelper.GetMemberCommitteeIDs();

        const committeeEntity = md.Entities.find(e => e.Name === 'Committees');
        const meetingEntity = md.Entities.find(e => e.Name === 'Meetings');
        const agendaEntity = md.Entities.find(e => e.Name === 'Agenda Items');
        const actionEntity = md.Entities.find(e => e.Name === 'Action Items');

        const entityInfos = [committeeEntity, meetingEntity, agendaEntity, actionEntity].filter(e => e != null);
        if (entityInfos.length === 0) {
            this.Files = [];
            this.Committees = [];
            this.ApplyFilters();
            return;
        }

        // Non-staff users with no memberships see no documents.
        if (memberCommitteeIDs && memberCommitteeIDs.size === 0) {
            this.Files = [];
            this.Committees = [];
            this.ApplyFilters();
            return;
        }

        const entityIDFilter = entityInfos.map(e => `'${e!.ID}'`).join(', ');

        const [linksResult, categoriesResult, committeesResult, meetingsResult, agendasResult, actionItemsResult] = await rv.RunViews([
            {
                EntityName: 'MJ: File Entity Record Links',
                Fields: ['FileID', 'EntityID', 'RecordID'],
                ExtraFilter: `EntityID IN (${entityIDFilter})`,
                ResultType: 'simple'
            },
            {
                EntityName: 'MJ: File Categories',
                Fields: ['ID', 'Name'],
                OrderBy: 'Name ASC',
                ResultType: 'simple'
            },
            {
                EntityName: 'Committees',
                Fields: ['ID', 'Name'],
                ExtraFilter: '',
                OrderBy: 'Name ASC',
                ResultType: 'simple'
            },
            {
                EntityName: 'Meetings',
                Fields: ['ID', 'CommitteeID'],
                ResultType: 'simple'
            },
            {
                EntityName: 'Agenda Items',
                Fields: ['ID', 'MeetingID'],
                ResultType: 'simple'
            },
            {
                EntityName: 'Action Items',
                Fields: ['ID', 'CommitteeID'],
                ResultType: 'simple'
            }
        ]);

        if (categoriesResult.Success) {
            this.Categories = categoriesResult.Results;
            this.CategoryFilterOptions = ['All', ...categoriesResult.Results.map(c => String(c['Name'] || ''))];
        }

        if (committeesResult.Success) {
            const allCommittees = (committeesResult.Results as { ID: string; Name: string }[])
                .map(c => ({ ID: c.ID, Name: c.Name }));
            // Members/officers see only committees they belong to; staff sees all.
            this.Committees = memberCommitteeIDs
                ? allCommittees.filter(c => memberCommitteeIDs.has(c.ID))
                : allCommittees;
        }

        // Build lookup maps for resolving indirect committee links
        const meetingToCommittee = new Map<string, string>();
        if (meetingsResult.Success) {
            for (const m of meetingsResult.Results as { ID: string; CommitteeID: string }[]) {
                meetingToCommittee.set(m.ID, m.CommitteeID);
            }
        }
        const agendaToCommittee = new Map<string, string>();
        if (agendasResult.Success) {
            for (const a of agendasResult.Results as { ID: string; MeetingID: string }[]) {
                const cid = meetingToCommittee.get(a.MeetingID);
                if (cid) agendaToCommittee.set(a.ID, cid);
            }
        }
        const actionToCommittee = new Map<string, string>();
        if (actionItemsResult.Success) {
            for (const ai of actionItemsResult.Results as { ID: string; CommitteeID: string }[]) {
                if (ai.CommitteeID) actionToCommittee.set(ai.ID, ai.CommitteeID);
            }
        }
        const committeeNameByID = new Map<string, string>();
        for (const c of this.Committees) {
            committeeNameByID.set(c.ID, c.Name);
        }

        if (!linksResult.Success || linksResult.Results.length === 0) {
            this.Files = [];
            this.ApplyFilters();
            return;
        }

        // For each file, resolve all linked committees (direct and indirect)
        const fileToCommittees = new Map<string, Set<string>>();
        for (const link of linksResult.Results as { FileID: string; EntityID: string; RecordID: string }[]) {
            let committeeID: string | undefined;
            if (link.EntityID === committeeEntity?.ID) {
                committeeID = link.RecordID;
            } else if (link.EntityID === meetingEntity?.ID) {
                committeeID = meetingToCommittee.get(link.RecordID);
            } else if (link.EntityID === agendaEntity?.ID) {
                committeeID = agendaToCommittee.get(link.RecordID);
            } else if (link.EntityID === actionEntity?.ID) {
                committeeID = actionToCommittee.get(link.RecordID);
            }

            if (committeeID) {
                let set = fileToCommittees.get(link.FileID);
                if (!set) {
                    set = new Set();
                    fileToCommittees.set(link.FileID, set);
                }
                set.add(committeeID);
            }
        }

        // Scope to user's committees: only show files linked to at least one of them.
        const allFileIDs = [...new Set(linksResult.Results.map(l => String(l['FileID'])))];
        const visibleFileIDs = memberCommitteeIDs
            ? allFileIDs.filter(fid => {
                const fileCommittees = fileToCommittees.get(fid);
                if (!fileCommittees) return false;
                for (const cid of fileCommittees) {
                    if (memberCommitteeIDs.has(cid)) return true;
                }
                return false;
            })
            : allFileIDs;

        if (visibleFileIDs.length === 0) {
            this.Files = [];
            this.ApplyFilters();
            return;
        }

        const fileIDFilter = visibleFileIDs.map(id => `'${id}'`).join(', ');

        const filesResult = await rv.RunView<Record<string, unknown>>({
            EntityName: 'MJ: Files',
            Fields: ['ID', 'Name', 'Description', 'Category', 'Provider', 'ContentType', 'Status', 'URL', '__mj_CreatedAt'],
            ExtraFilter: `ID IN (${fileIDFilter}) AND Status != 'Deleted'`,
            OrderBy: '__mj_CreatedAt DESC',
            MaxRows: 200,
            ResultType: 'simple'
        });

        if (filesResult.Success) {
            this.Files = filesResult.Results.map(f => {
                const fileID = f['ID'] as string;
                const allCommitteeIDs = [...(fileToCommittees.get(fileID) ?? new Set<string>())];
                // Non-staff: only surface committee names the user belongs to.
                const visibleCommitteeIDs = memberCommitteeIDs
                    ? allCommitteeIDs.filter(id => memberCommitteeIDs.has(id))
                    : allCommitteeIDs;
                const committeeNames = visibleCommitteeIDs
                    .map(id => committeeNameByID.get(id))
                    .filter((n): n is string => !!n);
                return {
                    ...f,
                    CommitteeIDs: visibleCommitteeIDs,
                    CommitteeNames: committeeNames
                };
            });
        }
        this.ApplyFilters();
    }
}

export function LoadDocumentBrowser() { }
