import { UUIDsEqual } from '@memberjunction/global';
import { Component, EventEmitter, Input, Output, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { Metadata, RunView } from '@memberjunction/core';
import { GraphQLDataProvider } from '@memberjunction/graphql-dataprovider';
import {
    mjBizAppsTasksMeetingEntity,
    mjBizAppsTasksMeetingAttendeeEntity,
    mjBizAppsTasksMeetingAgendaItemEntity,
    mjBizAppsTasksMeetingLinkEntity,
} from '@mj-biz-apps/tasks-entities';
import { AgendaItemDialogResult } from '../agenda/agenda-item-edit-dialog.component';
import { MotionDialogResult } from '../motions/motion-edit-dialog.component';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';

export interface MeetingDialogResult {
    Saved: boolean;
    Meeting: mjBizAppsTasksMeetingEntity | null;
}

interface AttendeeRow {
    ID: string | null;
    PersonID: string;
    DisplayName: string;
    Status: 'Expected' | 'Present' | 'Absent' | 'Excused' | 'Partial';
    IsNew: boolean;
    IsRemoved: boolean;
}

@Component({
    standalone: false,
    selector: 'meeting-edit-dialog',
    templateUrl: './meeting-edit-dialog.component.html',
    styleUrls: ['../shared/design-system.css', '../shared/slide-panel.css', './meeting-edit-dialog.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class MeetingEditDialogComponent implements OnInit {
    @Input() MeetingID: string | null = null;
    @Output() DialogClosed = new EventEmitter<MeetingDialogResult>();

    Meeting: mjBizAppsTasksMeetingEntity | null = null;
    SelectedCommitteeID: string | null = null;
    LocationType: 'Virtual' | 'InPerson' | 'Hybrid' = 'Virtual';
    VideoRecordingURL: string | null = null;
    TranscriptURL: string | null = null;
    IsLoading = true;
    IsSaving = false;
    ErrorMessage = '';
    ShowCancelConfirm = false;

    /** Lookup data */
    Committees: { ID: string; Name: string }[] = [];
    AllPeople: { ID: string; DisplayName: string }[] = [];

    /** Attendees */
    Attendees: AttendeeRow[] = [];
    SelectedPersonID: string | null = null;

    /** Agenda items */
    AgendaItems: Record<string, unknown>[] = [];
    ShowAgendaDialog = false;
    EditingAgendaItemID: string | null = null;

    /** Motions */
    Motions: Record<string, unknown>[] = [];
    ShowMotionDialog = false;
    EditingMotionID: string | null = null;

    readonly StatusOptions: ('Draft' | 'Scheduled' | 'InProgress' | 'Completed' | 'Cancelled' | 'Postponed')[] =
        ['Draft', 'Scheduled', 'InProgress', 'Completed', 'Cancelled', 'Postponed'];

    readonly LocationTypeOptions: ('Virtual' | 'InPerson' | 'Hybrid')[] = ['Virtual', 'InPerson', 'Hybrid'];

    /** Default org-wide video provider loaded at init. Null if none configured. */
    DefaultProvider: { ID: string; Name: string } | null = null;
    IsProvisioningVideo = false;

    /** Bound as string for <input type="datetime-local"> */
    StartDateTimeLocal = '';
    EndDateTimeLocal = '';

    private cdr = inject(ChangeDetectorRef);

    get IsNew(): boolean {
        return this.MeetingID == null;
    }

    get DialogTitle(): string {
        return this.IsNew ? 'Schedule Meeting' : 'Edit Meeting';
    }

    get VisibleAttendees(): AttendeeRow[] {
        return this.Attendees.filter(a => !a.IsRemoved);
    }

    get AvailablePeople(): { ID: string; DisplayName: string }[] {
        const attendeePersonIDs = new Set(this.VisibleAttendees.map(a => a.PersonID));
        return this.AllPeople.filter(p => !attendeePersonIDs.has(p.ID));
    }

    async ngOnInit(): Promise<void> {
        await Promise.all([
            this.loadLookups(),
            this.loadOrCreateMeeting()
        ]);
        if (!this.IsNew) {
            await Promise.all([
                this.loadAttendees(),
                this.loadAgendaItems(),
                this.loadMotions()
            ]);
        }
        this.IsLoading = false;
        this.cdr.markForCheck();
    }

    async OnSave(): Promise<void> {
        if (!this.Meeting) return;

        const validationError = this.validate();
        if (validationError) {
            this.ErrorMessage = validationError;
            this.cdr.markForCheck();
            return;
        }

        this.Meeting.StartsAt = new Date(this.StartDateTimeLocal);
        this.Meeting.EndsAt = this.EndDateTimeLocal
            ? new Date(this.EndDateTimeLocal)
            : new Date(this.Meeting.StartsAt.getTime() + 60 * 60 * 1000);
        this.Meeting.LocationType = this.LocationType;

        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.markForCheck();

        // Auto-set VideoProviderID from the default provider for virtual/hybrid meetings
        const locationType = this.LocationType;
        if (this.DefaultProvider && (locationType === 'Virtual' || locationType === 'Hybrid')) {
            this.Meeting.VideoProviderID = this.DefaultProvider.ID;
        }

        const success = await this.Meeting.Save();
        if (!success) {
            this.IsSaving = false;
            this.ErrorMessage = 'Failed to save meeting. Please try again.';
            this.cdr.markForCheck();
            return;
        }

        if (this.SelectedCommitteeID) {
            await this.ensureCommitteeLink(this.Meeting.ID, this.SelectedCommitteeID);
        }

        // Save attendee changes
        await this.saveAttendees();

        // Provision video meeting if provider is set and no URL yet
        if (this.DefaultProvider && !this.Meeting.VideoJoinURL &&
            (locationType === 'Virtual' || locationType === 'Hybrid')) {
            await this.provisionVideoMeeting(this.Meeting.ID);
        }

        this.IsSaving = false;
        this.DialogClosed.emit({ Saved: true, Meeting: this.Meeting });
    }

    async OnCancelMeeting(): Promise<void> {
        if (!this.Meeting || this.IsNew) return;

        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.markForCheck();

        this.Meeting.Status = 'Cancelled';
        const success = await this.Meeting.Save();
        this.IsSaving = false;

        if (success) {
            this.DialogClosed.emit({ Saved: true, Meeting: this.Meeting });
        } else {
            this.ErrorMessage = 'Failed to cancel meeting. Please try again.';
            this.cdr.markForCheck();
        }
    }

    OnClose(): void {
        this.DialogClosed.emit({ Saved: false, Meeting: null });
    }

    OnAddAttendee(): void {
        if (!this.SelectedPersonID) return;
        const person = this.AllPeople.find(p => UUIDsEqual(p.ID, this.SelectedPersonID));
        if (!person) return;

        this.Attendees.push({
            ID: null,
            PersonID: person.ID,
            DisplayName: person.DisplayName,
            Status: 'Expected',
            IsNew: true,
            IsRemoved: false
        });
        this.SelectedPersonID = null;
        this.cdr.markForCheck();
    }

    OnRemoveAttendee(attendee: AttendeeRow): void {
        if (attendee.IsNew) {
            // Not yet saved — just remove from list
            this.Attendees = this.Attendees.filter(a => a !== attendee);
        } else {
            attendee.IsRemoved = true;
        }
        this.cdr.markForCheck();
    }

    /** Motion management */
    OnCreateMotion(): void {
        this.EditingMotionID = null;
        this.ShowMotionDialog = true;
        this.cdr.markForCheck();
    }

    OnEditMotion(motionID: string): void {
        this.EditingMotionID = motionID;
        this.ShowMotionDialog = true;
        this.cdr.markForCheck();
    }

    async OnMotionDialogClosed(result: MotionDialogResult): Promise<void> {
        this.ShowMotionDialog = false;
        if (result.Saved) {
            await this.loadMotions();
        }
        this.cdr.markForCheck();
    }

    GetResultClass(result: string): string {
        switch (result) {
            case 'Passed': return 'result-passed';
            case 'Failed': return 'result-failed';
            case 'Pending': return 'result-pending';
            case 'Tabled': return 'result-tabled';
            case 'Withdrawn': return 'result-withdrawn';
            default: return '';
        }
    }

    private async loadMotions(): Promise<void> {
        if (!this.MeetingID) return;
        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'Committees: Motions',
            Fields: ['ID', 'Sequence', 'Name', 'Result', 'ResultSummary', 'MovedByMembership', 'SecondedByMembership', 'YesCount', 'NoCount', 'AbstainCount'],
            ExtraFilter: `MeetingID = '${this.MeetingID}'`,
            OrderBy: 'Sequence ASC',
            ResultType: 'simple'
        });
        if (result.Success) {
            this.Motions = result.Results;
        }
    }

    /** Agenda item management */
    OnAddAgendaItem(): void {
        this.EditingAgendaItemID = null;
        this.ShowAgendaDialog = true;
        this.cdr.markForCheck();
    }

    OnEditAgendaItem(itemID: string): void {
        this.EditingAgendaItemID = itemID;
        this.ShowAgendaDialog = true;
        this.cdr.markForCheck();
    }

    async OnAgendaDialogClosed(result: AgendaItemDialogResult): Promise<void> {
        this.ShowAgendaDialog = false;
        if (result.Saved) {
            await this.loadAgendaItems();
        }
        this.cdr.markForCheck();
    }

    async OnMoveAgendaItem(itemID: string, direction: 'up' | 'down'): Promise<void> {
        const idx = this.AgendaItems.findIndex(a => a['ID'] === itemID);
        if (idx < 0) return;
        const swapIdx = direction === 'up' ? idx - 1 : idx + 1;
        if (swapIdx < 0 || swapIdx >= this.AgendaItems.length) return;

        // Swap in the local array first for instant UI feedback
        const temp = this.AgendaItems[idx];
        this.AgendaItems[idx] = this.AgendaItems[swapIdx];
        this.AgendaItems[swapIdx] = temp;

        // Reassign all sequences based on new order
        this.AgendaItems = this.AgendaItems.map((item, i) => ({ ...item, Sequence: i + 1 }));
        this.cdr.markForCheck();

        // Persist the two swapped items
        const md = new Metadata();
        const entityA = await md.GetEntityObject<mjBizAppsTasksMeetingAgendaItemEntity>('MJ_BizApps_Tasks: Meeting Agenda Items');
        const entityB = await md.GetEntityObject<mjBizAppsTasksMeetingAgendaItemEntity>('MJ_BizApps_Tasks: Meeting Agenda Items');
        await entityA.Load(this.AgendaItems[idx]['ID'] as string);
        await entityB.Load(this.AgendaItems[swapIdx]['ID'] as string);
        entityA.Sequence = this.AgendaItems[idx]['Sequence'] as number;
        entityB.Sequence = this.AgendaItems[swapIdx]['Sequence'] as number;
        await Promise.all([entityA.Save(), entityB.Save()]);
    }

    get NextAgendaSequence(): number {
        if (this.AgendaItems.length === 0) return 1;
        return Math.max(...this.AgendaItems.map(a => (a['Sequence'] as number) || 0)) + 1;
    }

    GetItemTypeIcon(type: string): string {
        switch (type) {
            case 'Information': return 'fa-solid fa-circle-info';
            case 'Discussion': return 'fa-solid fa-comments';
            case 'Action': return 'fa-solid fa-bolt';
            case 'Vote': return 'fa-solid fa-check-to-slot';
            case 'Report': return 'fa-solid fa-chart-bar';
            default: return 'fa-solid fa-ellipsis';
        }
    }

    private async loadAgendaItems(): Promise<void> {
        if (!this.MeetingID) return;
        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'MJ_BizApps_Tasks: Meeting Agenda Items',
            Fields: ['ID', 'Sequence', 'Name', 'Type', 'DurationMinutes', 'Status', 'PresenterPerson', 'PresenterPersonID'],
            ExtraFilter: `MeetingID = '${this.MeetingID}'`,
            OrderBy: 'Sequence ASC',
            ResultType: 'simple'
        });
        if (result.Success) {
            this.AgendaItems = (result.Results as Record<string, unknown>[]).map(r => ({
                ...r,
                ItemType: r['Type'] || 'Discussion',
                Presenter: r['PresenterPerson']
            }));
        }
    }

    private validate(): string | null {
        if (!this.Meeting!.Name?.trim()) {
            return 'Meeting title is required.';
        }
        if (!this.SelectedCommitteeID) {
            return 'Please select a committee.';
        }
        if (!this.StartDateTimeLocal) {
            return 'Start date/time is required.';
        }
        if (this.EndDateTimeLocal && this.EndDateTimeLocal <= this.StartDateTimeLocal) {
            return 'End time must be after start time.';
        }
        return null;
    }

    private async loadOrCreateMeeting(): Promise<void> {
        const md = new Metadata();
        if (this.IsNew) {
            this.Meeting = await md.GetEntityObject<mjBizAppsTasksMeetingEntity>('MJ_BizApps_Tasks: Meetings');
            this.Meeting.Status = 'Scheduled';
            this.LocationType = 'Virtual';
            const now = new Date();
            now.setHours(now.getHours() + 1, 0, 0, 0);
            this.StartDateTimeLocal = this.toLocalDateTimeString(now);
        } else {
            this.Meeting = await md.GetEntityObject<mjBizAppsTasksMeetingEntity>('MJ_BizApps_Tasks: Meetings');
            await this.Meeting.Load(this.MeetingID!);
            this.StartDateTimeLocal = this.toLocalDateTimeString(this.Meeting.StartsAt);
            if (this.Meeting.EndsAt) {
                this.EndDateTimeLocal = this.toLocalDateTimeString(this.Meeting.EndsAt);
            }
            this.LocationType = this.Meeting.VideoProvider && this.Meeting.VideoProvider !== 'None'
                ? (this.Meeting.Location ? 'Hybrid' : 'Virtual')
                : 'InPerson';
            this.TranscriptURL = this.Meeting.TranscriptFile;
            const rv = new RunView();
            const spaceEntityId = md.EntityByName('MJ_BizApps_Collaboration: Spaces')?.ID;
            if (spaceEntityId) {
                const links = await rv.RunView<{ RecordID: string }>({
                    EntityName: 'MJ_BizApps_Tasks: Meeting Links',
                    ExtraFilter: `MeetingID = '${this.MeetingID}' AND EntityID = '${spaceEntityId}'`,
                    Fields: ['RecordID'],
                    MaxRows: 1,
                    ResultType: 'simple'
                });
                if (links.Success && links.Results?.length) {
                    this.SelectedCommitteeID = links.Results[0].RecordID;
                }
            }
        }
    }

    private async ensureCommitteeLink(meetingID: string, committeeID: string): Promise<void> {
        const md = new Metadata();
        const spaceEntityId = md.EntityByName('MJ_BizApps_Collaboration: Spaces')?.ID;
        if (!spaceEntityId) return;
        const rv = new RunView();
        const existing = await rv.RunView<{ ID: string; RecordID: string }>({
            EntityName: 'MJ_BizApps_Tasks: Meeting Links',
            ExtraFilter: `MeetingID = '${meetingID}' AND EntityID = '${spaceEntityId}'`,
            Fields: ['ID', 'RecordID'],
            ResultType: 'simple'
        });
        if (existing.Success && existing.Results?.some(r => UUIDsEqual(r.RecordID, committeeID))) {
            return;
        }
        const link = await md.GetEntityObject<mjBizAppsTasksMeetingLinkEntity>('MJ_BizApps_Tasks: Meeting Links');
        link.NewRecord();
        link.MeetingID = meetingID;
        link.EntityID = spaceEntityId;
        link.RecordID = committeeID;
        await link.Save();
    }

    private async loadLookups(): Promise<void> {
        const rv = new RunView();
        const [committeesResult, peopleResult] = await rv.RunViews([
            {
                EntityName: 'Committees: Committees',
                Fields: ['ID', 'Name'],
                ExtraFilter: "Status = 'Active'",
                OrderBy: 'Name ASC',
                ResultType: 'simple'
            },
            {
                EntityName: 'MJ_BizApps_Common: People',
                Fields: ['ID', 'DisplayName'],
                OrderBy: 'DisplayName ASC',
                MaxRows: 500,
                ResultType: 'simple'
            }
        ]);

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

        if (peopleResult.Success) {
            this.AllPeople = peopleResult.Results as { ID: string; DisplayName: string }[];
        }
    }


    private async loadAttendees(): Promise<void> {
        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'MJ_BizApps_Tasks: Meeting Attendees',
            Fields: ['ID', 'PersonID', 'Person', 'DisplayName', 'ResponseStatus', 'AttendanceStatus'],
            ExtraFilter: `MeetingID = '${this.MeetingID}'`,
            OrderBy: 'Person ASC',
            ResultType: 'simple'
        });
        if (result.Success) {
            this.Attendees = result.Results.map((r: Record<string, unknown>) => ({
                ID: r['ID'] as string,
                PersonID: r['PersonID'] as string,
                DisplayName: (r['Person'] as string) || (r['DisplayName'] as string) || '',
                Status: (r['AttendanceStatus'] === 'Unknown' ? 'Expected' : r['AttendanceStatus']) as AttendeeRow['Status'],
                IsNew: false,
                IsRemoved: false
            }));
        }
    }

    private async saveAttendees(): Promise<void> {
        const md = new Metadata();

        // Delete removed attendees
        for (const attendee of this.Attendees.filter(a => a.IsRemoved && !a.IsNew)) {
            const entity = await md.GetEntityObject<mjBizAppsTasksMeetingAttendeeEntity>('MJ_BizApps_Tasks: Meeting Attendees');
            await entity.Load(attendee.ID!);
            await entity.Delete();
        }

        // Create new attendees
        for (const attendee of this.Attendees.filter(a => a.IsNew && !a.IsRemoved)) {
            const entity = await md.GetEntityObject<mjBizAppsTasksMeetingAttendeeEntity>('MJ_BizApps_Tasks: Meeting Attendees');
            entity.MeetingID = this.Meeting!.ID;
            entity.PersonID = attendee.PersonID;
            entity.DisplayName = attendee.DisplayName;
            entity.ResponseStatus = attendee.Status === 'Absent' ? 'Declined' : 'None';
            entity.AttendanceStatus = attendee.Status === 'Present'
                ? 'Present'
                : attendee.Status === 'Absent'
                ? 'Absent'
                : attendee.Status === 'Excused'
                ? 'Excused'
                : 'Unknown';
            await entity.Save();
        }
    }

    private async provisionVideoMeeting(meetingID: string): Promise<void> {
        const gqlProvider = Metadata.Provider as GraphQLDataProvider;
        const mutation = `mutation ProvisionVideo($MeetingID: String!) {
            ProvisionVideoMeeting(MeetingID: $MeetingID) {
                Success ErrorMessage JoinURL ProviderMeetingID
            }
        }`;
        try {
            const result = await gqlProvider.ExecuteGQL(mutation, { MeetingID: meetingID });
            const payload = (result as Record<string, Record<string, unknown>>)?.['ProvisionVideoMeeting'];
            if (payload?.['Success'] && payload['JoinURL']) {
                this.Meeting!.VideoJoinURL = payload['JoinURL'] as string;
                this.Meeting!.VideoMeetingID = payload['ProviderMeetingID'] as string | null;
            }
        } catch (err) {
            console.error('[MeetingEditDialog] Video provisioning failed:', err);
        }
    }

    private toLocalDateTimeString(date: Date): string {
        const d = new Date(date);
        const offset = d.getTimezoneOffset();
        const local = new Date(d.getTime() - offset * 60 * 1000);
        return local.toISOString().slice(0, 16);
    }
}

export function LoadMeetingEditDialog() { }
