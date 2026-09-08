import { Component, EventEmitter, Input, Output, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { RunView } from '@memberjunction/core';

export interface DocumentPreviewClosedEvent {
    /** True if the user clicked "Edit" — the parent should open the edit dialog. */
    OpenEdit: boolean;
    FileID: string | null;
}

interface FilePreviewData {
    ID: string;
    Name: string;
    ProviderKey: string | null;
    Category: string | null;
    Provider: string | null;
    ContentType: string | null;
}

@Component({
    standalone: false,
    selector: 'document-preview-panel',
    templateUrl: './document-preview-panel.component.html',
    styleUrls: ['../shared/design-system.css', '../shared/slide-panel.css', './document-preview-panel.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class DocumentPreviewPanelComponent implements OnInit {
    @Input() FileID: string | null = null;

    /** Whether to show the "Edit" button (staff-only) */
    @Input() CanEdit = false;

    @Output() PanelClosed = new EventEmitter<DocumentPreviewClosedEvent>();

    File: FilePreviewData | null = null;
    IsLoading = true;
    SafeUrl: SafeResourceUrl | null = null;
    PreviewError = '';

    private cdr = inject(ChangeDetectorRef);
    private sanitizer = inject(DomSanitizer);

    get FileName(): string {
        return this.File?.Name ?? 'Document';
    }

    get FileURL(): string | null {
        // External-URL files store the document link in ProviderKey.
        return this.File?.ProviderKey ?? null;
    }

    get FileCategory(): string | null {
        return this.File?.Category ?? null;
    }

    get FileProvider(): string | null {
        return this.File?.Provider ?? null;
    }

    get CanPreview(): boolean {
        return !!this.SafeUrl && !this.PreviewError;
    }

    async ngOnInit(): Promise<void> {
        await this.loadFile();
        this.IsLoading = false;
        this.cdr.markForCheck();
    }

    OnClose(): void {
        this.PanelClosed.emit({ OpenEdit: false, FileID: this.FileID });
    }

    OnEdit(): void {
        this.PanelClosed.emit({ OpenEdit: true, FileID: this.FileID });
    }

    OnOpenInNewTab(): void {
        if (this.FileURL) {
            window.open(this.FileURL, '_blank', 'noopener');
        }
    }

    OnIframeError(): void {
        this.PreviewError = 'This file cannot be previewed in an iframe. Open it in a new tab to view.';
        this.cdr.markForCheck();
    }

    private async loadFile(): Promise<void> {
        if (!this.FileID) return;
        const rv = new RunView();
        const result = await rv.RunView<FilePreviewData>({
            EntityName: 'MJ: Files',
            ExtraFilter: `ID = '${this.FileID}'`,
            Fields: ['ID', 'Name', 'ProviderKey', 'Category', 'Provider', 'ContentType'],
            MaxRows: 1,
            ResultType: 'simple'
        });

        if (!result.Success || !result.Results || result.Results.length === 0) {
            this.PreviewError = 'Could not load file.';
            return;
        }

        this.File = result.Results[0];

        const url = this.FileURL;
        if (!url) {
            this.PreviewError = 'No URL available for this file.';
            return;
        }

        const safeUrl = this.buildSafeResourceUrl(url);
        if (safeUrl) {
            this.SafeUrl = safeUrl;
        } else {
            this.PreviewError = 'This file has an unsupported or unsafe URL and cannot be previewed.';
        }
    }

    /**
     * Only trust the URL for iframe embedding when it is an absolute https: URL.
     * ProviderKey is user-set for external-URL file records, so an unvalidated
     * value (e.g. `data:text/html,<script>…`) could execute in the iframe.
     */
    private buildSafeResourceUrl(url: string): SafeResourceUrl | null {
        try {
            const parsed = new URL(url);
            if (parsed.protocol !== 'https:') {
                return null;
            }
            return this.sanitizer.bypassSecurityTrustResourceUrl(url);
        } catch {
            return null;
        }
    }
}

export function LoadDocumentPreviewPanel() { }
