import { Component, EventEmitter, Input, Output, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject } from '@angular/core';
import { Metadata, RunView } from '@memberjunction/core';
import { mjCommitteesMeetingEntity, mjCommitteesAttendanceEntity } from '@mj-biz-apps/committees-entities';

export interface MeetingDialogResult {
    Saved: boolean;
    Meeting: mjCommitteesMeetingEntity | null;
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
    styleUrls: ['./meeting-edit-dialog.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class MeetingEditDialogComponent implements OnInit {
    @Input() MeetingID: string | null = null;
    @Output() DialogClosed = new EventEmitter<MeetingDialogResult>();

    Meeting: mjCommitteesMeetingEntity | null = null;
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

    readonly StatusOptions: ('Draft' | 'Scheduled' | 'InProgress' | 'Completed' | 'Cancelled' | 'Postponed')[] =
        ['Draft', 'Scheduled', 'InProgress', 'Completed', 'Cancelled', 'Postponed'];

    readonly LocationTypeOptions: ('Virtual' | 'InPerson' | 'Hybrid')[] = ['Virtual', 'InPerson', 'Hybrid'];

    readonly VideoProviderOptions: ('Zoom' | 'Teams' | 'GoogleMeet' | 'Webex' | 'Other')[] =
        ['Zoom', 'Teams', 'GoogleMeet', 'Webex', 'Other'];

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
            this.LoadLookups(),
            this.LoadOrCreateMeeting()
        ]);
        if (!this.IsNew) {
            await this.LoadAttendees();
        }
        this.IsLoading = false;
        this.cdr.markForCheck();
    }

    async OnSave(): Promise<void> {
        if (!this.Meeting) return;

        const validationError = this.Validate();
        if (validationError) {
            this.ErrorMessage = validationError;
            this.cdr.markForCheck();
            return;
        }

        this.Meeting.StartDateTime = new Date(this.StartDateTimeLocal);
        this.Meeting.EndDateTime = this.EndDateTimeLocal ? new Date(this.EndDateTimeLocal) : null;

        this.IsSaving = true;
        this.ErrorMessage = '';
        this.cdr.markForCheck();

        const success = await this.Meeting.Save();
        if (!success) {
            this.IsSaving = false;
            this.ErrorMessage = 'Failed to save meeting. Please try again.';
            this.cdr.markForCheck();
            return;
        }

        // Save attendee changes
        await this.SaveAttendees();

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
        const person = this.AllPeople.find(p => p.ID === this.SelectedPersonID);
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

    private Validate(): string | null {
        if (!this.Meeting!.Title?.trim()) {
            return 'Meeting title is required.';
        }
        if (!this.Meeting!.CommitteeID) {
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

    private async LoadOrCreateMeeting(): Promise<void> {
        const md = new Metadata();
        if (this.IsNew) {
            this.Meeting = await md.GetEntityObject<mjCommitteesMeetingEntity>('Meetings');
            this.Meeting.Status = 'Scheduled';
            this.Meeting.LocationType = 'Virtual';
            const now = new Date();
            now.setHours(now.getHours() + 1, 0, 0, 0);
            this.StartDateTimeLocal = this.ToLocalDateTimeString(now);
        } else {
            this.Meeting = await md.GetEntityObject<mjCommitteesMeetingEntity>('Meetings');
            await this.Meeting.Load(this.MeetingID!);
            this.StartDateTimeLocal = this.ToLocalDateTimeString(this.Meeting.StartDateTime);
            if (this.Meeting.EndDateTime) {
                this.EndDateTimeLocal = this.ToLocalDateTimeString(this.Meeting.EndDateTime);
            }
        }
    }

    private async LoadLookups(): Promise<void> {
        const rv = new RunView();
        const [committeesResult, peopleResult] = await rv.RunViews([
            {
                EntityName: 'Committees',
                Fields: ['ID', 'Name'],
                ExtraFilter: "Status = 'Active'",
                OrderBy: 'Name ASC',
                ResultType: 'simple'
            },
            {
                EntityName: 'MJ.BizApps.Common: People',
                Fields: ['ID', 'DisplayName'],
                OrderBy: 'DisplayName ASC',
                MaxRows: 500,
                ResultType: 'simple'
            }
        ]);
        if (committeesResult.Success) {
            this.Committees = committeesResult.Results as { ID: string; Name: string }[];
        }
        if (peopleResult.Success) {
            this.AllPeople = peopleResult.Results as { ID: string; DisplayName: string }[];
        }
    }

    private async LoadAttendees(): Promise<void> {
        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'Attendances',
            Fields: ['ID', 'PersonID', 'Person', 'AttendanceStatus'],
            ExtraFilter: `MeetingID = '${this.MeetingID}'`,
            OrderBy: 'Person ASC',
            ResultType: 'simple'
        });
        if (result.Success) {
            this.Attendees = result.Results.map((r: Record<string, unknown>) => ({
                ID: r['ID'] as string,
                PersonID: r['PersonID'] as string,
                DisplayName: (r['Person'] as string) || '',
                Status: r['AttendanceStatus'] as AttendeeRow['Status'],
                IsNew: false,
                IsRemoved: false
            }));
        }
    }

    private async SaveAttendees(): Promise<void> {
        const md = new Metadata();

        // Delete removed attendees
        for (const attendee of this.Attendees.filter(a => a.IsRemoved && !a.IsNew)) {
            const entity = await md.GetEntityObject<mjCommitteesAttendanceEntity>('Attendances');
            await entity.Load(attendee.ID!);
            await entity.Delete();
        }

        // Create new attendees
        for (const attendee of this.Attendees.filter(a => a.IsNew && !a.IsRemoved)) {
            const entity = await md.GetEntityObject<mjCommitteesAttendanceEntity>('Attendances');
            entity.MeetingID = this.Meeting!.ID;
            entity.PersonID = attendee.PersonID;
            entity.AttendanceStatus = attendee.Status;
            await entity.Save();
        }
    }

    private ToLocalDateTimeString(date: Date): string {
        const d = new Date(date);
        const offset = d.getTimezoneOffset();
        const local = new Date(d.getTime() - offset * 60 * 1000);
        return local.toISOString().slice(0, 16);
    }
}

export function LoadMeetingEditDialog() { }
