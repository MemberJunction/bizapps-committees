import { BaseEntity, EntitySaveOptions, FieldValueCollection } from '@memberjunction/core';
import { RegisterClass } from '@memberjunction/global';
import { mjBizAppsCommitteesTermEntity } from '../generated/entity_subclasses';

/**
 * Custom Term entity (C4 IsA child of MJ_BizApps_Collaboration: Spaces):
 * - Defaults SpaceTypeID to the 'committee-term' SpaceType ('B7CA4E22-91F3-4E04-A812-3C9F08D42E11')
 * - Defaults OwnerID to ContextCurrentUser.ID when creating a new term
 * - Sets InheritsMembership = true so term spaces inherit their parent committee's membership (Decision A4)
 */
@RegisterClass(BaseEntity, 'Committees: Terms', 1)
export class TermEntityCustom extends mjBizAppsCommitteesTermEntity {
    public static readonly SPACE_TYPE_ID = 'B7CA4E22-91F3-4E04-A812-3C9F08D42E11';

    public override NewRecord(newValues?: FieldValueCollection): boolean {
        const ok = super.NewRecord(newValues);
        if (!this.SpaceTypeID) {
            this.SpaceTypeID = TermEntityCustom.SPACE_TYPE_ID;
        }
        if (!this.OwnerID && this.ContextCurrentUser?.ID) {
            this.OwnerID = this.ContextCurrentUser.ID;
        }
        this.InheritsMembership = true;
        return ok;
    }

    /** Alias mapping CommitteeID to Space.ParentID. */
    get CommitteeID(): string {
        return this.ParentID ?? '';
    }

    set CommitteeID(value: string) {
        this.ParentID = value;
    }

    /** Alias mapping StartDate to Space.StartedAt. */
    get StartDate(): Date | null {
        return this.StartedAt;
    }

    set StartDate(value: Date | null) {
        this.StartedAt = value;
    }

    /** Alias mapping EndDate to Space.PlannedCloseAt ?? Space.ClosedAt. */
    get EndDate(): Date | null {
        return this.PlannedCloseAt ?? this.ClosedAt;
    }

    set EndDate(value: Date | null) {
        this.PlannedCloseAt = value;
    }

    /** Syncs Term.Status with Space.ClosedAt. */
    override get Status(): 'Active' | 'Completed' | 'Upcoming' {
        if (this.ClosedAt) return 'Completed';
        const stored = this.Get('Status') as 'Active' | 'Completed' | 'Upcoming' | null;
        if (stored) return stored;
        if (this.StartedAt && new Date(this.StartedAt) > new Date()) return 'Upcoming';
        return 'Active';
    }

    override set Status(value: 'Active' | 'Completed' | 'Upcoming') {
        this.Set('Status', value);
    }

    public override async Save(options?: EntitySaveOptions): Promise<boolean> {
        if (!this.SpaceTypeID) {
            this.SpaceTypeID = TermEntityCustom.SPACE_TYPE_ID;
        }
        if (!this.OwnerID && this.ContextCurrentUser?.ID) {
            this.OwnerID = this.ContextCurrentUser.ID;
        }
        this.InheritsMembership = true;

        const closedField = this.ISAParentEntity?.Fields.find((f) => f.Name === 'ClosedAt');
        const dbClosedAt = closedField?.Dirty ? closedField.OldValue : this.ClosedAt;
        const wasClosed = this.IsSaved && dbClosedAt != null;

        if (wasClosed) {
            if (this.ClosedAt == null) {
                this.ClosedAt = dbClosedAt as Date;
            }
            if (this.Get('Status') !== 'Completed') {
                this.Set('Status', 'Completed');
            }
            return super.Save(options);
        }

        if (this.IsSaved) {
            if (this.Status === 'Completed' && this.ClosedAt == null) {
                this.ClosedAt = this.PlannedCloseAt ?? new Date();
            }
            return super.Save(options);
        }

        const wantsClosedOnCreate = this.Status === 'Completed' || this.ClosedAt != null;
        if (wantsClosedOnCreate) {
            const targetClosedAt = this.ClosedAt ?? this.PlannedCloseAt ?? new Date();
            this.ClosedAt = null;
            if (closedField) {
                closedField.ResetOldValue();
            }
            const savedOpen = await super.Save(options);
            if (!savedOpen) {
                return false;
            }
            this.ClosedAt = targetClosedAt;
            return super.Save(options);
        }

        return super.Save(options);
    }
}

export function LoadCustomTermEntity() {}
