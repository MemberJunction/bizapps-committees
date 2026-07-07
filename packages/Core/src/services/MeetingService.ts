import { Metadata, RunView, UserInfo } from '@memberjunction/core';
import {
    mjBizAppsCommitteesMeetingEntity,
    mjBizAppsCommitteesAgendaItemEntity,
    mjBizAppsCommitteesAttendanceEntity,
    mjBizAppsCommitteesMembershipEntity,
} from '@mj-biz-apps/committees-entities';

/**
 * Input data required to create a new meeting for a committee.
 */
export interface CreateMeetingInput {
    Name: string;
    Description?: string;
    StartDateTime: Date;
    EndDateTime?: Date;
    TimeZone?: string;
    LocationType?: 'Virtual' | 'InPerson' | 'Hybrid';
    LocationText?: string;
    VideoProvider?: string;
    VideoJoinURL?: string;
}

/**
 * Full meeting details including the meeting record, ordered agenda items,
 * and attendance records.
 */
export interface MeetingDetails {
    Meeting: mjBizAppsCommitteesMeetingEntity;
    AgendaItems: mjBizAppsCommitteesAgendaItemEntity[];
    Attendances: mjBizAppsCommitteesAttendanceEntity[];
}

/**
 * Service class for meeting operations: loading meeting details,
 * creating meetings with auto-generated attendance, and updating attendance status.
 */
export class MeetingService {
    /**
     * Loads a meeting along with its agenda items (ordered by Sequence) and
     * attendance records in a single batched query.
     */
    public async GetMeetingWithAgenda(
        meetingID: string,
        contextUser: UserInfo
    ): Promise<MeetingDetails> {
        const meeting = await this.loadMeeting(meetingID, contextUser);
        const [agendaItems, attendances] = await this.loadMeetingRelatedData(meetingID, contextUser);

        return {
            Meeting: meeting,
            AgendaItems: agendaItems,
            Attendances: attendances,
        };
    }

    /**
     * Creates a new meeting for a committee and auto-creates Attendance records
     * (status: Expected) for all active committee members.
     */
    public async CreateMeetingForCommittee(
        committeeID: string,
        meetingData: CreateMeetingInput,
        contextUser: UserInfo
    ): Promise<mjBizAppsCommitteesMeetingEntity> {
        const meeting = await this.createMeetingRecord(committeeID, meetingData, contextUser);
        const activeMembers = await this.loadActiveMembers(committeeID, contextUser);
        await this.createAttendanceRecords(meeting.ID, activeMembers, contextUser);

        return meeting;
    }

    /**
     * Updates the attendance status for a specific person at a specific meeting.
     */
    public async UpdateAttendance(
        meetingID: string,
        personID: string,
        status: 'Absent' | 'Excused' | 'Expected' | 'Partial' | 'Present',
        contextUser: UserInfo
    ): Promise<mjBizAppsCommitteesAttendanceEntity> {
        const attendance = await this.findAttendanceRecord(meetingID, personID, contextUser);
        attendance.AttendanceStatus = status;

        const saved = await attendance.Save();
        if (!saved) {
            throw new Error(`Failed to update attendance for person ${personID} at meeting ${meetingID}`);
        }

        return attendance;
    }

    /** Loads a single meeting entity by ID. */
    private async loadMeeting(meetingID: string, contextUser: UserInfo): Promise<mjBizAppsCommitteesMeetingEntity> {
        const md = new Metadata();
        const meeting = await md.GetEntityObject<mjBizAppsCommitteesMeetingEntity>('Committees: Meetings', contextUser);
        const loaded = await meeting.Load(meetingID);
        if (!loaded) {
            throw new Error(`Meeting not found: ${meetingID}`);
        }
        return meeting;
    }

    /**
     * Batch-loads agenda items and attendance records for a meeting using
     * RunViews (plural).
     */
    private async loadMeetingRelatedData(
        meetingID: string,
        contextUser: UserInfo
    ): Promise<[mjBizAppsCommitteesAgendaItemEntity[], mjBizAppsCommitteesAttendanceEntity[]]> {
        const rv = new RunView();

        const [agendaResult, attendanceResult] = await rv.RunViews([
            {
                EntityName: 'Committees: Agenda Items',
                ExtraFilter: `MeetingID='${meetingID}'`,
                OrderBy: 'Sequence ASC',
                ResultType: 'entity_object',
            },
            {
                EntityName: 'Committees: Attendances',
                ExtraFilter: `MeetingID='${meetingID}'`,
                OrderBy: 'Person',
                ResultType: 'entity_object',
            },
        ], contextUser);

        return [
            agendaResult.Success ? (agendaResult.Results ?? []) as mjBizAppsCommitteesAgendaItemEntity[] : [],
            attendanceResult.Success ? (attendanceResult.Results ?? []) as mjBizAppsCommitteesAttendanceEntity[] : [],
        ];
    }

    /** Creates the meeting entity record from the provided input data. */
    private async createMeetingRecord(
        committeeID: string,
        meetingData: CreateMeetingInput,
        contextUser: UserInfo
    ): Promise<mjBizAppsCommitteesMeetingEntity> {
        const md = new Metadata();
        const meeting = await md.GetEntityObject<mjBizAppsCommitteesMeetingEntity>('Committees: Meetings', contextUser);
        meeting.NewRecord();

        meeting.CommitteeID = committeeID;
        meeting.Name = meetingData.Name;
        meeting.StartDateTime = meetingData.StartDateTime;
        meeting.Status = 'Scheduled';

        if (meetingData.Description != null) {
            meeting.Description = meetingData.Description;
        }
        if (meetingData.EndDateTime != null) {
            meeting.EndDateTime = meetingData.EndDateTime;
        }
        if (meetingData.TimeZone != null) {
            meeting.TimeZone = meetingData.TimeZone;
        }
        if (meetingData.LocationType != null) {
            meeting.LocationType = meetingData.LocationType;
        }
        if (meetingData.LocationText != null) {
            meeting.LocationText = meetingData.LocationText;
        }
        if (meetingData.VideoProvider != null) {
            meeting.VideoProvider = meetingData.VideoProvider;
        }
        if (meetingData.VideoJoinURL != null) {
            meeting.VideoJoinURL = meetingData.VideoJoinURL;
        }

        const saved = await meeting.Save();
        if (!saved) {
            throw new Error(`Failed to create meeting for committee ${committeeID}`);
        }

        return meeting;
    }

    /** Loads active members for a committee using a read-only simple query. */
    private async loadActiveMembers(
        committeeID: string,
        contextUser: UserInfo
    ): Promise<{ PersonID: string }[]> {
        const rv = new RunView();
        const result = await rv.RunView<{ PersonID: string }>({
            EntityName: 'Committees: Memberships',
            ExtraFilter: `CommitteeID='${committeeID}' AND Status='Active'`,
            Fields: ['PersonID'],
            ResultType: 'simple',
        }, contextUser);

        if (!result.Success) {
            throw new Error(`Failed to load active members for committee ${committeeID}: ${result.ErrorMessage}`);
        }

        return result.Results ?? [];
    }

    /** Creates Attendance records with status Expected for each active member. */
    private async createAttendanceRecords(
        meetingID: string,
        members: { PersonID: string }[],
        contextUser: UserInfo
    ): Promise<void> {
        const md = new Metadata();
        const savePromises: Promise<boolean>[] = [];

        for (const member of members) {
            const attendance = await md.GetEntityObject<mjBizAppsCommitteesAttendanceEntity>('Committees: Attendances', contextUser);
            attendance.NewRecord();
            attendance.MeetingID = meetingID;
            attendance.PersonID = member.PersonID;
            attendance.AttendanceStatus = 'Expected';
            savePromises.push(attendance.Save());
        }

        const results = await Promise.all(savePromises);
        const failedCount = results.filter(r => !r).length;
        if (failedCount > 0) {
            throw new Error(`Failed to create ${failedCount} attendance record(s) for meeting ${meetingID}`);
        }
    }

    /** Finds an existing attendance record for a person at a meeting. */
    private async findAttendanceRecord(
        meetingID: string,
        personID: string,
        contextUser: UserInfo
    ): Promise<mjBizAppsCommitteesAttendanceEntity> {
        const rv = new RunView();
        const result = await rv.RunView<mjBizAppsCommitteesAttendanceEntity>({
            EntityName: 'Committees: Attendances',
            ExtraFilter: `MeetingID='${meetingID}' AND PersonID='${personID}'`,
            ResultType: 'entity_object',
            MaxRows: 1,
        }, contextUser);

        if (!result.Success || !result.Results || result.Results.length === 0) {
            throw new Error(`Attendance record not found for person ${personID} at meeting ${meetingID}`);
        }

        return result.Results[0];
    }
}
