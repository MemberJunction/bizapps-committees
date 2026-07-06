import { BaseEntity, ValidationResult, ValidationErrorInfo, ValidationErrorType } from '@memberjunction/core';
import { RegisterClass } from '@memberjunction/global';
import { mjBizAppsCommitteesMeetingEntity } from '../generated/entity_subclasses';

/**
 * Custom Meeting entity.
 *
 * Validation rules:
 * - EndDateTime, if set, must be after StartDateTime
 * - Virtual/Hybrid meetings should have a VideoProviderID or VideoJoinURL
 *
 * Note: Auto-provisioning of VideoJoinURL via the video provider API is handled
 * server-side by VideoProviderService / ProvisionVideoMeeting GraphQL mutation,
 * not in this client-safe entity class.
 */
@RegisterClass(BaseEntity, 'Meetings', 1)
export class MeetingEntityCustom extends mjBizAppsCommitteesMeetingEntity {

    public override Validate(): ValidationResult {
        const result = super.Validate();

        this.validateEndDateAfterStart(result);

        result.Success = result.Success && result.Errors.length === 0;
        return result;
    }

    private validateEndDateAfterStart(result: ValidationResult): void {
        if (this.EndDateTime && this.StartDateTime && this.EndDateTime <= this.StartDateTime) {
            result.Errors.push(new ValidationErrorInfo(
                'EndDateTime',
                'End date/time must be after start date/time.',
                this.EndDateTime,
                ValidationErrorType.Failure
            ));
        }
    }
}

export function LoadCustomMeetingEntity(): void {}
