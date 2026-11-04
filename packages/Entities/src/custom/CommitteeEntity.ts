import { BaseEntity, EntitySaveOptions, FieldValueCollection, type IMetadataProvider, RunView } from '@memberjunction/core';
import { RegisterClass } from '@memberjunction/global';
import { mjBizAppsCommitteesCommitteeEntity } from '../generated/entity_subclasses';

/**
 * Custom Committee entity (C4 IsA child of MJ_BizApps_Collaboration: Spaces):
 * - Defaults SpaceTypeID to the 'committee' SpaceType ('5FABEBE3-0207-4DB2-8B4C-8DAF0178A3C6')
 * - Defaults OwnerID to ContextCurrentUser.ID when creating a new committee
 * - Sub-committees (ParentID != null) default to InheritsMembership = false (Decision A4)
 * - Syncs Committee.Status === 'Dissolved' to Space.ClosedAt while leaving Inactive/Pending open (Decision A3)
 */
@RegisterClass(BaseEntity, 'Committees: Committees', 1)
export class CommitteeEntityCustom extends mjBizAppsCommitteesCommitteeEntity {
    public static readonly SPACE_TYPE_ID = '5FABEBE3-0207-4DB2-8B4C-8DAF0178A3C6';

    public override NewRecord(newValues?: FieldValueCollection): boolean {
        const ok = super.NewRecord(newValues);
        if (!this.SpaceTypeID) {
            this.SpaceTypeID = CommitteeEntityCustom.SPACE_TYPE_ID;
        }
        if (!this.OwnerID && this.ContextCurrentUser?.ID) {
            this.OwnerID = this.ContextCurrentUser.ID;
        }
        this.InheritsMembership = false;
        return ok;
    }

    override get Status(): mjBizAppsCommitteesCommitteeEntity['Status'] {
        return this.Get('Status');
    }

    override set Status(value: mjBizAppsCommitteesCommitteeEntity['Status']) {
        this.Set('Status', value);
    }

    override get IsPublic(): boolean {
        return this.Get('IsPublic');
    }

    override set IsPublic(value: boolean) {
        this.Set('IsPublic', value);
    }

    /** Alias mapping FormationDate to Space.StartedAt. */
    get FormationDate(): Date | null {
        return this.StartedAt;
    }

    set FormationDate(value: Date | null) {
        this.StartedAt = value;
    }

    /** Alias mapping ParentCommitteeID to Space.ParentID. */
    get ParentCommitteeID(): string | null {
        return this.ParentID;
    }

    set ParentCommitteeID(value: string | null) {
        this.ParentID = value;
    }

    public override async Save(options?: EntitySaveOptions): Promise<boolean> {
        if (!this.SpaceTypeID) {
            this.SpaceTypeID = CommitteeEntityCustom.SPACE_TYPE_ID;
        }
        if (!this.OwnerID && this.ContextCurrentUser?.ID) {
            this.OwnerID = this.ContextCurrentUser.ID;
        }
        if (this.ParentID != null) {
            this.InheritsMembership = false;
        }

        const closedField = this.ISAParentEntity?.Fields.find((f) => f.Name === 'ClosedAt');
        const dbClosedAt = closedField?.Dirty ? closedField.OldValue : this.ClosedAt;
        const wasClosed = this.IsSaved && dbClosedAt != null;

        if (wasClosed) {
            if (this.ClosedAt == null) {
                this.ClosedAt = dbClosedAt as Date;
            }
            return super.Save(options);
        }

        if (this.IsSaved) {
            await this.ensureOwnerSeat();
            if (this.Status === 'Dissolved' && this.ClosedAt == null) {
                this.ClosedAt = new Date();
            }
            return super.Save(options);
        }

        const wantsClosedOnCreate = this.Status === 'Dissolved' || this.ClosedAt != null;
        if (wantsClosedOnCreate) {
            const targetClosedAt = this.ClosedAt ?? new Date();
            this.ClosedAt = null;
            if (closedField) {
                closedField.ResetOldValue();
            }
            const savedOpen = await super.Save(options);
            if (!savedOpen) {
                return false;
            }
            await this.ensureOwnerSeat();
            this.ClosedAt = targetClosedAt;
            return super.Save(options);
        }

        const saved = await super.Save(options);
        if (saved) {
            await this.ensureOwnerSeat();
        }
        return saved;
    }

    private async ensureOwnerSeat(): Promise<void> {
        if (!this.ID || !this.OwnerID || !this.ContextCurrentUser) {
            return;
        }
        const md = this.ProviderToUse as unknown as IMetadataProvider;
        if (!md || typeof md.GetEntityObject !== 'function') {
            return;
        }
        const view = new RunView(this.RunViewProviderToUse);
        const existing = await view.RunView<{ ID: string }>(
            {
                EntityName: 'MJ_BizApps_Collaboration: Space Members',
                ExtraFilter: `SpaceID = '${this.ID}' AND UserID = '${this.OwnerID}' AND Status = 'Active'`,
                Fields: ['ID'],
                MaxRows: 1,
                ResultType: 'simple',
            },
            this.ContextCurrentUser
        );
        if (existing.Success && (existing.Results?.length ?? 0) > 0) {
            return;
        }
        const roleRes = await view.RunView<{ ID: string }>(
            {
                EntityName: 'MJ_BizApps_Collaboration: Space Role Types',
                ExtraFilter: `IsOwnerRole = 1`,
                OrderBy: 'Level DESC',
                Fields: ['ID'],
                MaxRows: 1,
                ResultType: 'simple',
            },
            this.ContextCurrentUser
        );
        const ownerRoleId = roleRes.Success ? roleRes.Results?.[0]?.ID : null;
        if (!ownerRoleId) {
            return;
        }
        const seat = await md.GetEntityObject('MJ_BizApps_Collaboration: Space Members', this.ContextCurrentUser);
        seat.NewRecord();
        seat.Set('SpaceID', this.ID);
        seat.Set('UserID', this.OwnerID);
        seat.Set('SpaceRoleTypeID', ownerRoleId);
        seat.Set('Band', 'Team');
        seat.Set('Status', 'Active');
        await seat.Save();
    }
}

export function LoadCustomCommitteeEntity() {}
