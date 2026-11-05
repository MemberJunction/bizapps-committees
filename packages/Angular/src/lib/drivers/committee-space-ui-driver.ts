import { RegisterClass } from '@memberjunction/global';
import {
    BaseSpaceTypeUIDriver,
    overlayDescriptors,
    type BeforeInviteEvent,
    type SpaceDetailsFormDescriptor,
    type SpaceHeaderChipDescriptor,
    type SpaceTabDescriptor,
    type SpaceUIContext,
} from '@mj-biz-apps/collaboration-ng-widgets';

/**
 * C4 SpaceType UI Driver for `committee` (`CommitteeSpaceUIDriver`).
 * Contributes the Motions & Ballots and Roster & Terms tabs, header chips,
 * and the `Committees: Committees` IsA extension details form.
 */
@RegisterClass(BaseSpaceTypeUIDriver, 'CommitteeSpaceUIDriver')
export class CommitteeSpaceUIDriver extends BaseSpaceTypeUIDriver {
    public override GetTabs(_ctx: SpaceUIContext, defaultTabs: SpaceTabDescriptor[]): SpaceTabDescriptor[] {
        return overlayDescriptors(defaultTabs, [
            {
                key: 'motions-ballots',
                label: 'Motions & Ballots',
                icon: 'fa-solid fa-gavel',
                sortKey: 35,
            },
            {
                key: 'roster',
                label: 'Roster & Terms',
                icon: 'fa-solid fa-users',
                sortKey: 55,
            },
        ]);
    }

    public override GetHeaderChips(ctx: SpaceUIContext, defaultChips: SpaceHeaderChipDescriptor[]): SpaceHeaderChipDescriptor[] {
        const closed = Boolean(ctx.space?.ClosedAt);
        return overlayDescriptors(defaultChips, [
            {
                key: 'committee-status',
                label: closed ? 'Dissolved' : 'Active Committee',
                icon: closed ? 'fa-solid fa-ban' : 'fa-solid fa-landmark',
                variant: closed ? 'warn' : 'ok',
                sortKey: 10,
            },
        ]);
    }

    public override GetDetailsForm(_ctx: SpaceUIContext, _defaultForm?: SpaceDetailsFormDescriptor): SpaceDetailsFormDescriptor | undefined {
        return {
            entityName: 'Committees: Committees',
        };
    }

    public override GetVocabulary(_ctx: SpaceUIContext, _defaultVocabulary?: string): string {
        return 'Committee';
    }
}

/**
 * C4 SpaceType UI Driver for `committee-term` (`TermSpaceUIDriver`).
 * Contributes the Roster & Seats tab, `Committees: Terms` details form,
 * and blocks manual participant invites in favor of `SyncSeats`.
 */
@RegisterClass(BaseSpaceTypeUIDriver, 'TermSpaceUIDriver')
export class TermSpaceUIDriver extends BaseSpaceTypeUIDriver {
    public override GetTabs(_ctx: SpaceUIContext, defaultTabs: SpaceTabDescriptor[]): SpaceTabDescriptor[] {
        return overlayDescriptors(defaultTabs, [
            {
                key: 'roster',
                label: 'Roster & Seats',
                icon: 'fa-solid fa-id-badge',
                sortKey: 35,
            },
        ]);
    }

    public override GetDetailsForm(_ctx: SpaceUIContext, _defaultForm?: SpaceDetailsFormDescriptor): SpaceDetailsFormDescriptor | undefined {
        return {
            entityName: 'Committees: Terms',
        };
    }

    public override BeforeInvite(event: BeforeInviteEvent): void {
        event.cancel = true;
        event.cancelReason =
            'Term space participants are managed through committee term memberships (SyncSeats).';
    }

    public override GetVocabulary(_ctx: SpaceUIContext, _defaultVocabulary?: string): string {
        return 'Term';
    }
}

export function LoadCommitteeSpaceUIDrivers(): void {
    void CommitteeSpaceUIDriver;
    void TermSpaceUIDriver;
}
