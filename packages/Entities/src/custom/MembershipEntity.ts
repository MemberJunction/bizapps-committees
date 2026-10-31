import { BaseEntity, IRunViewProvider, ValidationResult, ValidationErrorInfo, ValidationErrorType, RunView } from '@memberjunction/core';
import { RegisterClass } from '@memberjunction/global';
import { mjBizAppsCommitteesMembershipEntity } from '../generated/entity_subclasses';

// Local copy of the UUID shape check. The Server package keeps its own UUID_RE in
// CommitteeAuthorization, but Entities must not depend on Server, so the regex is
// duplicated here rather than imported.
const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/**
 * Custom Membership entity with business rule validation:
 * - No duplicate active memberships (same person + same term)
 * - End date must be after start date
 * - Status='Active' requires a Role to be assigned
 * - Auto-sets EndDate when Status changes to 'Ended'
 *
 * Registered with auto-incremented priority above the generated class.
 */
@RegisterClass(BaseEntity, 'Committees: Memberships')
export class MembershipEntityCustom extends mjBizAppsCommitteesMembershipEntity {

    // Override Status setter to auto-set EndDate when membership is ended.
    // Get/Set here mirror the generated accessor implementation — using the
    // typed property inside its own override would recurse.
    override get Status(): mjBizAppsCommitteesMembershipEntity['Status'] {
        return this.Get('Status');
    }
    override set Status(value: mjBizAppsCommitteesMembershipEntity['Status']) {
        this.Set('Status', value);
        if (value === 'Ended' && !this.EndDate) {
            this.EndDate = new Date();
        }
    }

    public override Validate(): ValidationResult {
        const result = super.Validate();

        this.ValidateEndDateAfterStartDate(result);
        this.ValidateRoleRequiredForActive(result);

        result.Success = result.Success && (result.Errors.length === 0);
        return result;
    }

    public override async ValidateAsync(): Promise<ValidationResult> {
        const result = await super.ValidateAsync();

        await this.ValidateNoDuplicateActiveMembership(result);

        result.Success = result.Success && (result.Errors.length === 0);
        return result;
    }

    /**
     * Validates that EndDate, if provided, is after StartDate.
     */
    private ValidateEndDateAfterStartDate(result: ValidationResult): void {
        if (this.EndDate && this.StartDate && this.EndDate < this.StartDate) {
            result.Errors.push(new ValidationErrorInfo(
                'EndDate',
                'End date must be after start date.',
                this.EndDate,
                ValidationErrorType.Failure
            ));
        }
    }

    /**
     * Validates that Active memberships always have a Role assigned.
     */
    private ValidateRoleRequiredForActive(result: ValidationResult): void {
        if (this.Status === 'Active' && !this.RoleID) {
            result.Errors.push(new ValidationErrorInfo(
                'RoleID',
                'A role must be assigned before setting membership to Active.',
                this.RoleID,
                ValidationErrorType.Failure
            ));
        }
    }

    /**
     * Validates that no other Active membership exists for the same person + term.
     * Skipped on updates where PersonID and TermID have not changed.
     */
    private async ValidateNoDuplicateActiveMembership(result: ValidationResult): Promise<void> {
        if (this.Status !== 'Active' || !this.PersonID || !this.TermID) {
            return;
        }

        // SECURITY: PersonID, TermID and ID are client-settable and are interpolated
        // into a server-side ExtraFilter below, before any database type validation
        // runs. Only values shaped like plain UUIDs may reach the filter — anything
        // else is rejected here and the duplicate check is skipped.
        if (!UUID_RE.test(this.PersonID) || !UUID_RE.test(this.TermID) || !UUID_RE.test(this.ID)) {
            result.Errors.push(new ValidationErrorInfo(
                'PersonID',
                'PersonID/TermID must be a valid identifier.',
                this.PersonID,
                ValidationErrorType.Failure
            ));
            return;
        }

        // This entity owns a provider — route the query through it and carry the
        // entity's user context (MJ rule: never reach for the global provider here).
        // The concrete provider implements both interfaces; the cast bridges the
        // disjoint IEntityDataProvider/IRunViewProvider declarations.
        const rv = new RunView(this.ProviderToUse as unknown as IRunViewProvider);
        const dupeCheck = await rv.RunView<mjBizAppsCommitteesMembershipEntity>({
            EntityName: 'Committees: Memberships',
            ExtraFilter: `PersonID='${this.PersonID}' AND TermID='${this.TermID}' AND Status='Active' AND ID<>'${this.ID}'`,
            ResultType: 'simple',
        }, this.ContextCurrentUser);

        if (dupeCheck.Success && dupeCheck.Results.length > 0) {
            result.Errors.push(new ValidationErrorInfo(
                'PersonID',
                'This person already has an active membership for the selected term.',
                this.PersonID,
                ValidationErrorType.Failure
            ));
        }
    }
}

export function LoadCustomMembershipEntity() { }
