import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { RegisterClass , UUIDsEqual } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { EntityInfo, Metadata, RunView } from '@memberjunction/core';
import { DocumentDialogResult } from './document-edit-dialog.component';
import { DocumentPreviewClosedEvent } from './document-preview-panel.component';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';

type DateRangeFilter = 'all' | '7d' | '30d' | '90d' | 'year';

interface CommitteeOption {
    ID: string;
    Name: string;
}

type LinkRow = { FileID: string; EntityID: string; RecordID: string };
interface BatchResult { Success: boolean; Results: Record<string, unknown>[]; }
interface LinkableEntities {
    committee: EntityInfo | undefined;
    meeting: EntityInfo | undefined;
    agenda: EntityInfo | undefined;
    action: EntityInfo | undefined;
}
interface LinkBatch {
    linksResult: BatchResult; categoriesResult: BatchResult; committeesResult: BatchResult;
    meetingsResult: BatchResult; agendasResult: BatchResult; actionItemsResult: BatchResult;
}
interface CommitteeLinkMaps {
    meetingToCommittee: Map<string, string>;
    agendaToCommittee: Map<string, string>;
    actionToCommittee: Map<string, string>;
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
            this.loadFiles(),
            this.loadPermissions()
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
        this.applyFilters();
    }

    OnCategoryFilterChanged(category: string): void {
        this.CategoryFilter = category;
        this.applyFilters();
    }

    OnCommitteeFilterChanged(committeeID: string): void {
        this.CommitteeFilter = committeeID;
        this.applyFilters();
    }

    OnDateRangeChanged(range: DateRangeFilter): void {
        this.DateRangeFilter = range;
        this.applyFilters();
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
            await this.loadFiles();
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

    private async loadPermissions(): Promise<void> {
        const [isStaff, isOfficer] = await Promise.all([
            CommitteePermissionHelper.IsStaffUser(),
            CommitteePermissionHelper.IsOfficerInAny()
        ]);
        this.IsStaff = isStaff;
        this.CanManageDocuments = isStaff || isOfficer;
    }

    private applyFilters(): void {
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

        const cutoff = this.getDateRangeCutoff();
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
    private getDateRangeCutoff(): number | null {
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

    private async loadFiles(): Promise<void> {
        const rv = new RunView();
        const md = new Metadata();

        // Resolve scoping up front so we can filter committees/files appropriately.
        const isStaff = await CommitteePermissionHelper.IsStaffUser();
        const memberCommitteeIDs = isStaff
            ? null  // null = no scoping (staff sees all)
            : await CommitteePermissionHelper.GetMemberCommitteeIDs();

        const entities = this.resolveLinkableEntities(md);
        const entityInfos = [entities.committee, entities.meeting, entities.agenda, entities.action].filter(e => e != null);
        // Non-staff users with no memberships see no documents.
        if (entityInfos.length === 0 || (memberCommitteeIDs && memberCommitteeIDs.size === 0)) {
            this.Files = [];
            this.Committees = [];
            this.applyFilters();
            return;
        }

        const batch = await this.loadLinkBatch(rv, entityInfos.map(e => e!.ID));
        this.applyCategories(batch.categoriesResult);
        this.applyCommittees(batch.committeesResult, memberCommitteeIDs);

        const maps = this.buildCommitteeLinkMaps(batch);
        if (!batch.linksResult.Success || batch.linksResult.Results.length === 0) {
            this.Files = [];
            this.applyFilters();
            return;
        }
        const fileToCommittees = this.resolveFileCommittees(batch.linksResult.Results as LinkRow[], entities, maps);
        const visibleFileIDs = this.scopeVisibleFiles(batch.linksResult.Results as LinkRow[], fileToCommittees, memberCommitteeIDs);
        if (visibleFileIDs.length === 0) {
            this.Files = [];
            this.applyFilters();
            return;
        }
        await this.loadAndMapFiles(rv, visibleFileIDs, fileToCommittees, memberCommitteeIDs);
        this.applyFilters();
    }

    private resolveLinkableEntities(md: Metadata): LinkableEntities {
        return {
            committee: md.EntityByName('Committees: Committees'),
            meeting: md.EntityByName('Committees: Meetings'),
            agenda: md.EntityByName('Committees: Agenda Items'),
            action: md.EntityByName('Committees: Action Items'),
        };
    }

    private async loadLinkBatch(rv: RunView, entityIDs: string[]): Promise<LinkBatch> {
        const entityIDFilter = entityIDs.map(id => `'${id}'`).join(', ');
        const [linksResult, categoriesResult, committeesResult, meetingsResult, agendasResult, actionItemsResult] = await rv.RunViews([
            { EntityName: 'MJ: File Entity Record Links', Fields: ['FileID', 'EntityID', 'RecordID'], ExtraFilter: `EntityID IN (${entityIDFilter})`, ResultType: 'simple' },
            { EntityName: 'MJ: File Categories', Fields: ['ID', 'Name'], OrderBy: 'Name ASC', ResultType: 'simple' },
            { EntityName: 'Committees: Committees', Fields: ['ID', 'Name'], ExtraFilter: '', OrderBy: 'Name ASC', ResultType: 'simple' },
            { EntityName: 'Committees: Meetings', Fields: ['ID', 'CommitteeID'], ResultType: 'simple' },
            { EntityName: 'Committees: Agenda Items', Fields: ['ID', 'MeetingID'], ResultType: 'simple' },
            { EntityName: 'Committees: Action Items', Fields: ['ID', 'CommitteeID'], ResultType: 'simple' },
        ]);
        return {
            linksResult, categoriesResult, committeesResult, meetingsResult, agendasResult, actionItemsResult,
        } as unknown as LinkBatch;
    }

    private applyCategories(categoriesResult: LinkBatch['categoriesResult']): void {
        if (!categoriesResult.Success) return;
        this.Categories = categoriesResult.Results;
        this.CategoryFilterOptions = ['All', ...categoriesResult.Results.map(c => String(c['Name'] || ''))];
    }

    private applyCommittees(committeesResult: LinkBatch['committeesResult'], memberCommitteeIDs: Set<string> | null): void {
        if (!committeesResult.Success) return;
        const allCommittees = (committeesResult.Results as { ID: string; Name: string }[])
            .map(c => ({ ID: c.ID, Name: c.Name }));
        // Members/officers see only committees they belong to; staff sees all.
        this.Committees = memberCommitteeIDs
            ? allCommittees.filter(c => memberCommitteeIDs.has(c.ID))
            : allCommittees;
    }

    /** Lookup maps for resolving indirect committee links (meeting/agenda/action → committee). */
    private buildCommitteeLinkMaps(batch: LinkBatch): CommitteeLinkMaps {
        const meetingToCommittee = new Map<string, string>();
        if (batch.meetingsResult.Success) {
            for (const m of batch.meetingsResult.Results as { ID: string; CommitteeID: string }[]) {
                meetingToCommittee.set(m.ID, m.CommitteeID);
            }
        }
        const agendaToCommittee = new Map<string, string>();
        if (batch.agendasResult.Success) {
            for (const a of batch.agendasResult.Results as { ID: string; MeetingID: string }[]) {
                const cid = meetingToCommittee.get(a.MeetingID);
                if (cid) agendaToCommittee.set(a.ID, cid);
            }
        }
        const actionToCommittee = new Map<string, string>();
        if (batch.actionItemsResult.Success) {
            for (const ai of batch.actionItemsResult.Results as { ID: string; CommitteeID: string }[]) {
                if (ai.CommitteeID) actionToCommittee.set(ai.ID, ai.CommitteeID);
            }
        }
        return { meetingToCommittee, agendaToCommittee, actionToCommittee };
    }

    /** For each file, resolve all linked committees (direct and indirect). */
    private resolveFileCommittees(links: LinkRow[], entities: LinkableEntities, maps: CommitteeLinkMaps): Map<string, Set<string>> {
        const fileToCommittees = new Map<string, Set<string>>();
        for (const link of links) {
            let committeeID: string | undefined;
            if (UUIDsEqual(link.EntityID, entities.committee?.ID ?? null)) {
                committeeID = link.RecordID;
            } else if (UUIDsEqual(link.EntityID, entities.meeting?.ID ?? null)) {
                committeeID = maps.meetingToCommittee.get(link.RecordID);
            } else if (UUIDsEqual(link.EntityID, entities.agenda?.ID ?? null)) {
                committeeID = maps.agendaToCommittee.get(link.RecordID);
            } else if (UUIDsEqual(link.EntityID, entities.action?.ID ?? null)) {
                committeeID = maps.actionToCommittee.get(link.RecordID);
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
        return fileToCommittees;
    }

    /** Scope to user's committees: only files linked to at least one of them. */
    private scopeVisibleFiles(links: LinkRow[], fileToCommittees: Map<string, Set<string>>, memberCommitteeIDs: Set<string> | null): string[] {
        const allFileIDs = [...new Set(links.map(l => String(l.FileID)))];
        if (!memberCommitteeIDs) return allFileIDs;
        return allFileIDs.filter(fid => {
            const fileCommittees = fileToCommittees.get(fid);
            if (!fileCommittees) return false;
            for (const cid of fileCommittees) {
                if (memberCommitteeIDs.has(cid)) return true;
            }
            return false;
        });
    }

    private async loadAndMapFiles(
        rv: RunView, visibleFileIDs: string[],
        fileToCommittees: Map<string, Set<string>>, memberCommitteeIDs: Set<string> | null
    ): Promise<void> {
        const committeeNameByID = new Map<string, string>();
        for (const c of this.Committees) {
            committeeNameByID.set(c.ID, c.Name);
        }
        const fileIDFilter = visibleFileIDs.map(id => `'${id}'`).join(', ');
        const filesResult = await rv.RunView<Record<string, unknown>>({
            EntityName: 'MJ: Files',
            Fields: ['ID', 'Name', 'Description', 'Category', 'Provider', 'ContentType', 'Status', 'ProviderKey', '__mj_CreatedAt'],
            ExtraFilter: `ID IN (${fileIDFilter}) AND Status != 'Deleted'`,
            OrderBy: '__mj_CreatedAt DESC',
            MaxRows: 200,
            ResultType: 'simple'
        });
        if (!filesResult.Success) return;
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
            return { ...f, CommitteeIDs: visibleCommitteeIDs, CommitteeNames: committeeNames };
        });
    }
}

export function LoadDocumentBrowser() { }
