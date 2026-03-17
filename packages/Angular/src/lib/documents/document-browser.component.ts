import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { Metadata, RunView } from '@memberjunction/core';
import { DocumentDialogResult } from './document-edit-dialog.component';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';

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
    CategoryFilter = 'All';
    CategoryFilterOptions: string[] = ['All'];
    SearchText = '';

    /** Dialog state */
    ShowEditDialog = false;
    EditingFileID: string | null = null;

    /** Permission state */
    IsAnyOfficer = false;

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

    OnCreateDocument(): void {
        this.EditingFileID = null;
        this.ShowEditDialog = true;
        this.cdr.markForCheck();
    }

    OnOpenDocument(url: string, event: MouseEvent): void {
        event.stopPropagation();
        window.open(url, '_blank');
    }

    OnEditDocument(fileID: string): void {
        this.EditingFileID = fileID;
        this.ShowEditDialog = true;
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
        this.IsAnyOfficer = await CommitteePermissionHelper.IsOfficerInAny();
    }

    private ApplyFilters(): void {
        let result = this.Files;
        if (this.CategoryFilter !== 'All') {
            result = result.filter(f => f['Category'] === this.CategoryFilter);
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

    private async LoadFiles(): Promise<void> {
        const rv = new RunView();
        const md = new Metadata();

        const committeeEntityNames = [
            'Committees',
            'Meetings',
            'Agenda Items',
            'Action Items'
        ];
        const entityInfos = committeeEntityNames
            .map(name => md.Entities.find(e => e.Name === name))
            .filter(e => e != null);

        if (entityInfos.length === 0) {
            this.Files = [];
            this.ApplyFilters();
            return;
        }

        const entityIDFilter = entityInfos.map(e => `'${e.ID}'`).join(', ');

        const [linksResult, categoriesResult] = await rv.RunViews([
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
            }
        ]);

        if (categoriesResult.Success) {
            this.Categories = categoriesResult.Results;
            this.CategoryFilterOptions = ['All', ...categoriesResult.Results.map(c => String(c['Name'] || ''))];
        }

        if (!linksResult.Success || linksResult.Results.length === 0) {
            this.Files = [];
            this.ApplyFilters();
            return;
        }

        const fileIDs = [...new Set(linksResult.Results.map(l => String(l['FileID'])))];
        const fileIDFilter = fileIDs.map(id => `'${id}'`).join(', ');

        const filesResult = await rv.RunView<Record<string, unknown>>({
            EntityName: 'MJ: Files',
            Fields: ['ID', 'Name', 'Description', 'Category', 'Provider', 'ContentType', 'Status', 'URL', '__mj_CreatedAt'],
            ExtraFilter: `ID IN (${fileIDFilter}) AND Status != 'Deleted'`,
            OrderBy: '__mj_CreatedAt DESC',
            MaxRows: 200,
            ResultType: 'simple'
        });

        if (filesResult.Success) {
            this.Files = filesResult.Results;
        }
        this.ApplyFilters();
    }
}

export function LoadDocumentBrowser() { }
