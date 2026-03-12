import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { RunView } from '@memberjunction/core';

@RegisterClass(BaseResourceComponent, 'DocumentBrowserComponent')
@Component({
    standalone: false,
    selector: 'committees-documents',
    templateUrl: './document-browser.component.html',
    styleUrls: ['./document-browser.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class DocumentBrowserComponent extends BaseResourceComponent implements OnInit {
    Artifacts: Record<string, unknown>[] = [];
    FilteredArtifacts: Record<string, unknown>[] = [];
    ArtifactTypes: Record<string, unknown>[] = [];
    IsLoading = true;
    TypeFilter = 'All';
    TypeFilterOptions: string[] = ['All'];
    SearchText = '';

    private cdr = inject(ChangeDetectorRef);

    async ngOnInit(): Promise<void> {
        this.NotifyLoadStarted();
        await this.LoadArtifacts();
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

    OnTypeFilterChanged(type: string): void {
        this.TypeFilter = type;
        this.ApplyFilters();
    }

    GetArtifactIcon(typeName: string): string {
        switch (typeName) {
            case 'Agenda': return 'fa-solid fa-list-ol';
            case 'Minutes': return 'fa-solid fa-file-lines';
            case 'Resolution': return 'fa-solid fa-gavel';
            case 'Report': return 'fa-solid fa-chart-bar';
            case 'Policy': return 'fa-solid fa-scale-balanced';
            case 'Proposal': return 'fa-solid fa-lightbulb';
            case 'Budget': return 'fa-solid fa-coins';
            case 'Presentation': return 'fa-solid fa-presentation-screen';
            case 'Correspondence': return 'fa-solid fa-envelope';
            default: return 'fa-solid fa-file';
        }
    }

    private ApplyFilters(): void {
        let result = this.Artifacts;
        if (this.TypeFilter !== 'All') {
            result = result.filter(a => a['ArtifactType'] === this.TypeFilter);
        }
        if (this.SearchText.trim()) {
            const term = this.SearchText.toLowerCase();
            result = result.filter(a =>
                (a['Title'] as string || '').toLowerCase().includes(term) ||
                (a['Description'] as string || '').toLowerCase().includes(term)
            );
        }
        this.FilteredArtifacts = result;
        this.cdr.markForCheck();
    }

    private async LoadArtifacts(): Promise<void> {
        const rv = new RunView();
        const [artifacts, types] = await rv.RunViews([
            {
                EntityName: 'Artifacts',
                ExtraFilter: '',
                Fields: ['ID', 'Title', 'Description', 'ArtifactType', 'Committee', 'Meeting', 'FileURL', 'Status'],
                OrderBy: '__mj_CreatedAt DESC',
                MaxRows: 100,
                ResultType: 'simple'
            },
            {
                EntityName: 'Artifact Types',
                ExtraFilter: '',
                Fields: ['ID', 'Name'],
                OrderBy: 'Name ASC',
                ResultType: 'simple'
            }
        ]);

        if (artifacts.Success) {
            this.Artifacts = artifacts.Results;
        }
        if (types.Success) {
            this.ArtifactTypes = types.Results;
            this.TypeFilterOptions = ['All', ...types.Results.map(t => String(t['Name'] || ''))];
        }
        this.ApplyFilters();
    }
}

export function LoadDocumentBrowser() { }
