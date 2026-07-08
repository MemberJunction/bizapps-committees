import { UUIDsEqual } from '@memberjunction/global';
import { Component, EventEmitter, Input, Output, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { Metadata, RunView, RunViewParams, RunViewResult } from '@memberjunction/core';
import { GraphQLDataProvider } from '@memberjunction/graphql-dataprovider';
import { MJFileEntity, MJFileEntityRecordLinkEntity } from '@memberjunction/core-entities';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';

export interface DocumentDialogResult {
    Saved: boolean;
    File: MJFileEntity | null;
}

@Component({
    standalone: false,
    selector: 'document-edit-dialog',
    templateUrl: './document-edit-dialog.component.html',
    styleUrls: ['../shared/design-system.css', '../shared/slide-panel.css', './document-edit-dialog.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class DocumentEditDialogComponent implements OnInit {
    @Input() FileID: string | null = null;
    @Output() DialogClosed = new EventEmitter<DocumentDialogResult>();

    FileRecord: MJFileEntity | null = null;
    IsLoading = true;
    IsSaving = false;
    ErrorMessage = '';
    ShowDeleteConfirm = false;

    /** Two-mode UI: 'link' for external URL, 'upload' for MJ Storage */
    DocumentMode: 'link' | 'upload' = 'link';

    /** Lookup data */
    Committees: { ID: string; Name: string }[] = [];
    Meetings: { ID: string; Name: string }[] = [];
    Categories: { ID: string; Name: string }[] = [];
    ExternalProviders: { ID: string; Name: string }[] = [];
    StorageProviders: { ID: string; Name: string }[] = [];

    /** Context linking — stored separately from the file record */
    SelectedCommitteeID: string | null = null;
    SelectedMeetingID: string | null = null;

    /** File selection state (upload mode) */
    SelectedFile: File | null = null;
    IsDragging = false;

    private cdr = inject(ChangeDetectorRef);

    get IsNew(): boolean {
        return this.FileID == null;
    }

    get DialogTitle(): string {
        return this.IsNew ? 'Add Document' : 'Edit Document';
    }

    async ngOnInit(): Promise<void> {
        // Lookups must finish first — loadOrCreateFile reads ExternalProviders to
        // set the default provider (new) and to detect link-vs-upload mode (existing).
        await this.loadLookups();
        await this.loadOrCreateFile();
        this.IsLoading = false;
        this.cdr.markForCheck();
    }

    OnModeChanged(mode: 'link' | 'upload'): void {
        this.DocumentMode = mode;
        this.cdr.markForCheck();
    }

    async OnSave(): Promise<void> {
        if (!this.FileRecord) return;

        const validationError = this.validate();
        if (validationError) {
            this.ErrorMessage = validationError;
            this.cdr.markForCheck();
            return;
        }

        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.markForCheck();

        if (this.IsNew && this.DocumentMode === 'upload' && this.SelectedFile) {
            await this.saveUploadMode();
        } else {
            await this.saveLinkMode();
        }
    }

    private async saveLinkMode(): Promise<void> {
        if (!this.FileRecord) return;

        // For external URL mode on new records, set status to Uploaded (no upload lifecycle)
        if (this.IsNew) {
            this.FileRecord.Status = 'Uploaded';
        }

        const success = await this.FileRecord.Save();
        if (!success) {
            this.IsSaving = false;
            this.ErrorMessage = 'Failed to save document. Please try again.';
            this.cdr.markForCheck();
            return;
        }

        // Create context links for new records
        if (this.IsNew) {
            await this.createContextLinks();
        }

        this.IsSaving = false;
        this.DialogClosed.emit({ Saved: true, File: this.FileRecord });
    }

    private async saveUploadMode(): Promise<void> {
        if (!this.FileRecord || !this.SelectedFile) return;

        const created = await this.createFileRecordViaGraphQL();
        if (!created) return;

        const uploaded = await this.uploadFileViaProxy(created.uploadUrl);
        if (!uploaded) return;

        // Store the entity for context links
        this.FileRecord = await this.markFileUploaded(created.fileData);

        // Create context links
        await this.createContextLinks();

        this.IsSaving = false;
        this.DialogClosed.emit({ Saved: true, File: this.FileRecord });
    }

    /** Builds the CreateMJFileInput payload from the current form state (upload mode). */
    private buildCreateFileInput(): Record<string, unknown> {
        const input: Record<string, unknown> = {
            Name: this.FileRecord!.Name,
            ProviderID: this.FileRecord!.ProviderID,
            ContentType: this.SelectedFile!.type || 'application/octet-stream',
            Status: 'Pending',
        };

        if (this.FileRecord!.Description) {
            input['Description'] = this.FileRecord!.Description;
        }
        if (this.FileRecord!.CategoryID) {
            input['CategoryID'] = this.FileRecord!.CategoryID;
        }
        return input;
    }

    /** Creates the file record server-side and returns the upload URL + file data, or null on failure. */
    private async createFileRecordViaGraphQL(): Promise<{ uploadUrl: string; fileData: Record<string, unknown> } | null> {
        // Use GraphQL mutation directly to get the upload URL
        const mutation = `mutation CreateFile($input: CreateMJFileInput!) {
            CreateFile(input: $input) {
                File { ID Name Status ProviderID ProviderKey ContentType }
                UploadUrl
                NameExists
            }
        }`;

        const gqlProvider = Metadata.Provider as GraphQLDataProvider;
        const result = await gqlProvider.ExecuteGQL(mutation, { input: this.buildCreateFileInput() });
        const payload = (result as Record<string, Record<string, unknown>>)?.['CreateFile'];
        if (!payload?.['UploadUrl'] || !payload?.['File']) {
            this.IsSaving = false;
            this.ErrorMessage = 'Failed to create file record. Check server logs.';
            this.cdr.markForCheck();
            return null;
        }

        return {
            uploadUrl: payload['UploadUrl'] as string,
            fileData: payload['File'] as Record<string, unknown>
        };
    }

    /** Uploads the selected file through the server proxy. Returns false (and sets error state) on failure. */
    private async uploadFileViaProxy(uploadUrl: string): Promise<boolean> {
        // Upload via server proxy to avoid CORS issues with providers like Dropbox
        try {
            const provider = Metadata.Provider as GraphQLDataProvider;
            const apiUrl = provider.ConfigData.URL.replace(/\/graphql\/?$/, '');
            const proxyResponse = await window.fetch(`${apiUrl}/api/upload-proxy`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${provider.ConfigData.Token}`,
                    'x-upload-url': uploadUrl,
                    'x-upload-method': 'POST',
                    'Content-Type': 'application/octet-stream',
                },
                body: this.SelectedFile,
            });
            if (!proxyResponse.ok) {
                const errBody = await proxyResponse.json().catch(() => null);
                throw new Error(errBody?.error || `Upload failed with status ${proxyResponse.status}`);
            }
            return true;
        } catch (err: unknown) {
            this.IsSaving = false;
            const msg = err instanceof Error ? err.message : 'Upload failed';
            this.ErrorMessage = `Failed to upload file: ${msg}`;
            this.cdr.markForCheck();
            return false;
        }
    }

    /** Marks the server-created file record as Uploaded and returns the saved entity. */
    private async markFileUploaded(fileData: Record<string, unknown>): Promise<MJFileEntity> {
        const md = new Metadata();
        const fileEntity = await md.GetEntityObject<MJFileEntity>('MJ: Files');
        await fileEntity.LoadFromData(fileData);
        fileEntity.Status = 'Uploaded';
        await fileEntity.Save();
        return fileEntity;
    }

    async OnDelete(): Promise<void> {
        if (!this.FileRecord || this.IsNew) return;

        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.markForCheck();

        // Delete associated File Entity Record Links first (FK constraint)
        const linksDeleted = await this.deleteContextLinks();
        if (!linksDeleted) {
            this.IsSaving = false;
            this.ErrorMessage = 'Failed to delete document links. Please try again.';
            this.cdr.markForCheck();
            return;
        }

        const success = await this.FileRecord.Delete();
        this.IsSaving = false;

        if (success) {
            this.DialogClosed.emit({ Saved: true, File: null });
        } else {
            this.ErrorMessage = 'Failed to delete document. Please try again.';
            this.cdr.markForCheck();
        }
    }

    OnClose(): void {
        this.DialogClosed.emit({ Saved: false, File: null });
    }

    /** File selection via input */
    OnFileSelected(event: Event): void {
        const input = event.target as HTMLInputElement;
        if (input.files && input.files.length > 0) {
            this.setSelectedFile(input.files[0]);
        }
    }

    /** Drag and drop handlers */
    OnDragOver(event: DragEvent): void {
        event.preventDefault();
        event.stopPropagation();
        this.IsDragging = true;
        this.cdr.markForCheck();
    }

    OnDragLeave(event: DragEvent): void {
        event.preventDefault();
        event.stopPropagation();
        this.IsDragging = false;
        this.cdr.markForCheck();
    }

    OnDrop(event: DragEvent): void {
        event.preventDefault();
        event.stopPropagation();
        this.IsDragging = false;
        if (event.dataTransfer?.files && event.dataTransfer.files.length > 0) {
            this.setSelectedFile(event.dataTransfer.files[0]);
        }
    }

    OnClearFile(): void {
        this.SelectedFile = null;
        this.cdr.markForCheck();
    }

    FormatFileSize(bytes: number): string {
        if (bytes < 1024) return bytes + ' B';
        if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB';
        return (bytes / (1024 * 1024)).toFixed(1) + ' MB';
    }

    private setSelectedFile(file: File): void {
        this.SelectedFile = file;
        if (this.FileRecord) {
            if (!this.FileRecord.Name?.trim()) {
                this.FileRecord.Name = file.name.replace(/\.[^/.]+$/, '');
            }
            this.FileRecord.ContentType = file.type || null;
        }
        this.cdr.markForCheck();
    }

    private validate(): string | null {
        if (!this.FileRecord!.Name?.trim()) {
            return 'Title is required.';
        }
        if (this.DocumentMode === 'link') {
            if (!this.FileRecord!.ProviderKey?.trim()) {
                return 'Please provide a URL.';
            }
            if (!this.FileRecord!.ProviderID) {
                return 'Please select a provider.';
            }
        } else {
            if (!this.SelectedFile && this.IsNew) {
                return 'Please select a file to upload.';
            }
            if (!this.FileRecord!.ProviderID) {
                return 'Please select a storage provider.';
            }
        }
        return null;
    }

    private async loadOrCreateFile(): Promise<void> {
        const md = new Metadata();
        if (this.IsNew) {
            this.FileRecord = await md.GetEntityObject<MJFileEntity>('MJ: Files');
            // Default to the generic "External URL" provider
            const genericProvider = this.ExternalProviders.find(p => p.Name === 'External URL');
            if (genericProvider) {
                this.FileRecord.ProviderID = genericProvider.ID;
            }
        } else {
            this.FileRecord = await md.GetEntityObject<MJFileEntity>('MJ: Files');
            await this.FileRecord.Load(this.FileID!);
            // Determine mode from the provider: external-URL providers store the link
            // in ProviderKey; anything else is an uploaded file in a storage backend.
            const isExternal = this.ExternalProviders.some(p => UUIDsEqual(p.ID, this.FileRecord!.ProviderID));
            this.DocumentMode = isExternal ? 'link' : 'upload';
            // Load existing context links
            await this.loadExistingLinks();
        }
    }

    private buildLookupQueries(): RunViewParams[] {
        return [
            {
                EntityName: 'Committees: Committees',
                Fields: ['ID', 'Name'],
                ExtraFilter: "Status = 'Active'",
                OrderBy: 'Name ASC',
                ResultType: 'simple'
            },
            {
                EntityName: 'Committees: Meetings',
                Fields: ['ID', 'Name'],
                ExtraFilter: "Status NOT IN ('Cancelled')",
                OrderBy: 'StartDateTime DESC',
                MaxRows: 100,
                ResultType: 'simple'
            },
            {
                EntityName: 'MJ: File Categories',
                Fields: ['ID', 'Name'],
                OrderBy: 'Name ASC',
                ResultType: 'simple'
            },
            {
                EntityName: 'MJ: File Storage Providers',
                Fields: ['ID', 'Name'],
                ExtraFilter: "ServerDriverKey = 'ExternalURL' AND IsActive = 1",
                OrderBy: 'Name ASC',
                ResultType: 'simple'
            },
            {
                EntityName: 'MJ: File Storage Providers',
                Fields: ['ID', 'Name'],
                ExtraFilter: "ServerDriverKey != 'ExternalURL' AND IsActive = 1",
                OrderBy: 'Name ASC',
                ResultType: 'simple'
            }
        ];
    }

    /** Scopes the committee dropdown: staff sees all; officers see their committees (or all if none resolved). */
    private async applyCommitteeScope(committeesResult: RunViewResult<{ ID: string; Name: string }>): Promise<void> {
        const allCommittees = committeesResult.Success
            ? committeesResult.Results as { ID: string; Name: string }[]
            : [];

        const isStaff = await CommitteePermissionHelper.IsStaffUser();
        if (isStaff) {
            this.Committees = allCommittees;
        } else {
            const officerCommitteeIDs = await CommitteePermissionHelper.GetOfficerCommitteeIDs();
            this.Committees = officerCommitteeIDs.size > 0
                ? allCommittees.filter(c => officerCommitteeIDs.has(c.ID))
                : allCommittees;
        }
    }

    private async loadLookups(): Promise<void> {
        const rv = new RunView();
        const [committeesResult, meetingsResult, categoriesResult, externalProvidersResult, storageProvidersResult] =
            await rv.RunViews(this.buildLookupQueries());

        await this.applyCommitteeScope(committeesResult);

        if (meetingsResult.Success) {
            this.Meetings = meetingsResult.Results as { ID: string; Name: string }[];
        }
        if (categoriesResult.Success) {
            this.Categories = categoriesResult.Results as { ID: string; Name: string }[];
        }
        if (externalProvidersResult.Success) {
            this.ExternalProviders = externalProvidersResult.Results as { ID: string; Name: string }[];
        }
        if (storageProvidersResult.Success) {
            this.StorageProviders = storageProvidersResult.Results as { ID: string; Name: string }[];
        }
    }

    private async loadExistingLinks(): Promise<void> {
        const rv = new RunView();
        const result = await rv.RunView<{ EntityID: string; RecordID: string; Entity: string }>({
            EntityName: 'MJ: File Entity Record Links',
            Fields: ['EntityID', 'RecordID', 'Entity'],
            ExtraFilter: `FileID = '${this.FileID}'`,
            ResultType: 'simple'
        });
        if (result.Success) {
            for (const link of result.Results) {
                const entityName = link.Entity;
                if (entityName === 'Committees: Committees') {
                    this.SelectedCommitteeID = link.RecordID;
                } else if (entityName === 'Committees: Meetings') {
                    this.SelectedMeetingID = link.RecordID;
                }
            }
        }
    }

    private async deleteContextLinks(): Promise<boolean> {
        const rv = new RunView();
        const result = await rv.RunView<MJFileEntityRecordLinkEntity>({
            EntityName: 'MJ: File Entity Record Links',
            ExtraFilter: `FileID = '${this.FileRecord!.ID}'`,
            ResultType: 'entity_object'
        });
        if (!result.Success) return false;

        for (const link of result.Results) {
            const deleted = await link.Delete();
            if (!deleted) return false;
        }
        return true;
    }

    private async createContextLinks(): Promise<void> {
        const md = new Metadata();
        const linkPromises: Promise<boolean>[] = [];

        if (this.SelectedCommitteeID) {
            linkPromises.push(this.createLink(md, 'Committees: Committees', this.SelectedCommitteeID));
        }
        if (this.SelectedMeetingID) {
            linkPromises.push(this.createLink(md, 'Committees: Meetings', this.SelectedMeetingID));
        }

        await Promise.all(linkPromises);
    }

    private async createLink(md: Metadata, entityName: string, recordID: string): Promise<boolean> {
        const entityInfo = md.EntityByName(entityName);
        if (!entityInfo) return false;

        const link = await md.GetEntityObject<MJFileEntityRecordLinkEntity>('MJ: File Entity Record Links');
        link.NewRecord();
        link.FileID = this.FileRecord!.ID;
        link.EntityID = entityInfo.ID;
        link.RecordID = recordID;
        return link.Save();
    }
}

export function LoadDocumentEditDialog() { }
