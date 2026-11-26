import {
    BaseEntity,
    IEntityDataProvider,
    IMetadataProvider,
    IRunViewProvider,
    Metadata,
    RunView,
    ValidationErrorInfo,
    ValidationErrorType,
    ValidationResult,
} from '@memberjunction/core';
import { RegisterClass } from '@memberjunction/global';
import { mjBizAppsCommitteesMinuteEntity } from '../generated/entity_subclasses';

const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

interface ArtifactVersionOwnershipRow {
    ID: string;
    ArtifactID: string;
}

function isMetadataProvider(
    provider: IEntityDataProvider | null | undefined
): provider is IEntityDataProvider & IMetadataProvider {
    return provider != null && 'Entities' in provider && 'GetEntityObject' in provider;
}

function isRunViewProvider(
    provider: IEntityDataProvider | null | undefined
): provider is IEntityDataProvider & IRunViewProvider {
    return provider != null && 'RunView' in provider && typeof provider.RunView === 'function';
}

/**
 * Custom Minute entity enforcing MJ Docs artifact-version referential consistency:
 * - ApprovedArtifactVersionID cannot be set when MJArtifactID is null.
 * - When set, MJArtifactID and ApprovedArtifactVersionID must be valid UUIDs.
 * - ApprovedArtifactVersionID must belong to the linked MJArtifactID.
 */
@RegisterClass(BaseEntity, 'Committees: Minutes')
export class MinuteEntityCustom extends mjBizAppsCommitteesMinuteEntity {
    public override Validate(): ValidationResult {
        const result = super.Validate();

        this.validateArtifactPinningSync(result);

        result.Success = result.Success && result.Errors.length === 0;
        return result;
    }

    public override async ValidateAsync(): Promise<ValidationResult> {
        const result = await super.ValidateAsync();

        await this.validateApprovedVersionOwnership(result);

        result.Success = result.Success && result.Errors.length === 0;
        return result;
    }

    private validateArtifactPinningSync(result: ValidationResult): void {
        const artifactId = this.MJArtifactID?.trim() || null;
        const versionId = this.ApprovedArtifactVersionID?.trim() || null;

        if (versionId && !artifactId) {
            result.Errors.push(
                new ValidationErrorInfo(
                    'ApprovedArtifactVersionID',
                    'ApprovedArtifactVersionID cannot be set when MJArtifactID is null.',
                    this.ApprovedArtifactVersionID,
                    ValidationErrorType.Failure
                )
            );
        }

        if (artifactId && !UUID_RE.test(artifactId)) {
            result.Errors.push(
                new ValidationErrorInfo(
                    'MJArtifactID',
                    'MJArtifactID must be a valid UUID.',
                    this.MJArtifactID,
                    ValidationErrorType.Failure
                )
            );
        }

        if (versionId && !UUID_RE.test(versionId)) {
            result.Errors.push(
                new ValidationErrorInfo(
                    'ApprovedArtifactVersionID',
                    'ApprovedArtifactVersionID must be a valid UUID.',
                    this.ApprovedArtifactVersionID,
                    ValidationErrorType.Failure
                )
            );
        }
    }

    private async validateApprovedVersionOwnership(result: ValidationResult): Promise<void> {
        const artifactId = this.MJArtifactID?.trim() || null;
        const versionId = this.ApprovedArtifactVersionID?.trim() || null;

        if (!artifactId || !versionId || !UUID_RE.test(artifactId) || !UUID_RE.test(versionId)) {
            return;
        }

        const rv = this.resolveRunView();
        const check = await rv.RunView<ArtifactVersionOwnershipRow>(
            {
                EntityName: 'MJ: Artifact Versions',
                ExtraFilter: `ID='${versionId}'`,
                Fields: ['ID', 'ArtifactID'],
                MaxRows: 1,
                ResultType: 'simple',
            },
            this.ContextCurrentUser
        );

        if (!check.Success) {
            result.Errors.push(
                new ValidationErrorInfo(
                    'ApprovedArtifactVersionID',
                    `Failed to verify ApprovedArtifactVersionID ownership: ${check.ErrorMessage ?? 'unknown error'}.`,
                    this.ApprovedArtifactVersionID,
                    ValidationErrorType.Failure
                )
            );
            return;
        }

        const version = check.Results[0];
        if (!version) {
            result.Errors.push(
                new ValidationErrorInfo(
                    'ApprovedArtifactVersionID',
                    'ApprovedArtifactVersionID references an artifact version that does not exist or is inaccessible.',
                    this.ApprovedArtifactVersionID,
                    ValidationErrorType.Failure
                )
            );
            return;
        }

        if (version.ArtifactID.toLowerCase() !== artifactId.toLowerCase()) {
            result.Errors.push(
                new ValidationErrorInfo(
                    'ApprovedArtifactVersionID',
                    'ApprovedArtifactVersionID must belong to the linked MJArtifactID.',
                    this.ApprovedArtifactVersionID,
                    ValidationErrorType.Failure
                )
            );
        }
    }

    private resolveRunView(): RunView {
        if (isMetadataProvider(this.ProviderToUse)) {
            return RunView.FromMetadataProvider(this.ProviderToUse);
        }
        if (isRunViewProvider(this.ProviderToUse)) {
            return new RunView(this.ProviderToUse);
        }
        return RunView.FromMetadataProvider(Metadata.Provider);
    }
}

export function LoadCustomMinuteEntity(): void {}
