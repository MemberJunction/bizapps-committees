import { Component, ChangeDetectionStrategy, ChangeDetectorRef, OnInit, inject } from '@angular/core';
import { Metadata, RunView } from '@memberjunction/core';
import { RegisterClass } from '@memberjunction/global';
import { BaseResourceComponent } from '@memberjunction/ng-shared';
import { ResourceData } from '@memberjunction/core-entities';
import { BallotService, INTENT_ASK_WINDOW_DAYS, RenewalIntentValue } from '@mj-biz-apps/committees-core';
import { CommitteesLookupEngine } from '@mj-biz-apps/committees-core/lookup';
import {
    mjBizAppsCommitteesAttendanceEntity, mjBizAppsCommitteesActionItemEntity,
    mjBizAppsCommitteesVoteEntity, mjBizAppsCommitteesMembershipEntity,
} from '@mj-biz-apps/committees-entities';
import { CommitteePermissionHelper } from '../shared/committee-permission-helper';

interface TermRow { ID: string; CommitteeID: string; Committee: string; EndDate: string | null; Status: string; }
interface MembershipRow { ID: string; TermID: string; PersonID: string; Role: string; RoleID: string; RenewalIntent: RenewalIntentValue; }
interface RoleRow { ID: string; IsVotingRole: boolean; }
interface MeetingRow {
    ID: string; CommitteeID: string; Committee: string; Name: string;
    StartDateTime: string; EndDateTime: string | null; LocationType: string | null;
    LocationText: string | null; VideoJoinURL: string | null; Status: string;
}
interface AgendaCountRow { ID: string; MeetingID: string; ItemType: string; }
interface ActionRow { ID: string; Name: string; Committee: string | null; DueDate: string | null; Status: string; AssignedByPerson?: string | null; }
interface BallotRow { ID: string; CommitteeID: string; Committee: string; MotionID: string; Motion: string; ClosesAt: string; IsSealed: boolean; Status: string; }
interface VoteRow { ID: string; MotionID: string; MembershipID: string; VoteValue: string; }
interface MinuteRow { ID: string; MeetingID: string | null; Meeting: string | null; ApprovalStatus: string; }
interface MotionRow { ID: string; Name: string; Result: string; YesCount: number | null; NoCount: number | null; AbstainCount: number | null; __mj_CreatedAt: string; }

/** One card in "Your committees". */
export interface MyCommittee {
    MembershipID: string;
    CommitteeID: string;
    CommitteeName: string;
    RoleName: string;
    IsVoting: boolean;
    TermEnd: Date | null;
    AttendanceRate: number | null;
    RenewalIntent: RenewalIntentValue;
    /** Term ends within the ask window → show the intent question. */
    AskIntent: boolean;
    /** UI-only: answered members re-open the question via "Change answer". */
    EditingIntent?: boolean;
}

/** One item in the "Needs you" feed. */
export interface NeedsYouItem {
    Kind: 'action' | 'ballot' | 'minutes';
    Key: string;
    Title: string;
    Detail: string;
    Urgent: boolean;
    /** ballot items carry what's needed to vote inline */
    BallotMotionID?: string;
    MyMembershipID?: string;
    Sealed?: boolean;
    /** minutes items open the review overlay */
    MeetingID?: string;
    /** action items complete inline */
    ActionItemID?: string;
}

export interface RecentDecision { When: Date; Text: string; MyVote: string; }

export function LoadMemberHome(): void { }

/**
 * Member Home ("My Committees") — UX v2 screen 06, the volunteer view.
 * One glance: next meeting, what needs you, your committees (with renewal
 * intent capture), recent decisions. Default nav item of the member app.
 */
@Component({
    standalone: false,
    selector: 'committees-member-home',
    templateUrl: './member-home.component.html',
    styleUrls: ['./member-home.component.css'],
    changeDetection: ChangeDetectionStrategy.OnPush,
})
@RegisterClass(BaseResourceComponent, 'MemberHomeComponent')
export class MemberHomeComponent extends BaseResourceComponent implements OnInit {
    IsLoading = true;
    IsActing = false;
    ErrorMessage = '';

    FirstName = '';
    NextMeeting: MeetingRow | null = null;
    NextMeetingAgendaCount = 0;
    NextMeetingVoteCount = 0;
    /** My attendance row for the next meeting (RSVP state). */
    MyRsvp: 'Expected' | 'Absent' | null = null;
    Needs: NeedsYouItem[] = [];
    Committees: MyCommittee[] = [];
    Decisions: RecentDecision[] = [];
    MinutesReviewMeetingID: string | null = null;

    private personID: string | null = null;
    private myMembershipIDs = new Set<string>();
    private myAttendanceID: string | null = null;
    private cdr = inject(ChangeDetectorRef);

    async GetResourceDisplayName(_data: ResourceData): Promise<string> { return 'My Committees'; }
    async GetResourceIconClass(_data: ResourceData): Promise<string> { return 'fa-solid fa-user'; }

    async ngOnInit(): Promise<void> {
        await this.Load();
    }

    // ── Load ────────────────────────────────────────────────────

    async Load(): Promise<void> {
        this.IsLoading = true;
        this.ErrorMessage = '';
        this.cdr.detectChanges();
        try {
            this.personID = await CommitteePermissionHelper.GetCurrentPersonID();
            this.FirstName = (new Metadata().CurrentUser?.FirstName ?? '').trim();
            if (!this.personID) {
                this.ErrorMessage = 'Your user is not linked to a Person record — ask staff to link your account.';
                this.IsLoading = false;
                this.cdr.detectChanges();
                return;
            }
            await this.loadEverything(this.personID);
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to load your committees';
        }
        this.IsLoading = false;
        this.cdr.detectChanges();
    }

    private async loadEverything(personID: string): Promise<void> {
        await CommitteesLookupEngine.Instance.Config();
        const rv = new RunView();
        const [membershipsR, termsR] = await rv.RunViews([
            { EntityName: 'Committees: Memberships', ExtraFilter: `PersonID = '${personID}' AND Status = 'Active'`, Fields: ['ID', 'TermID', 'PersonID', 'Role', 'RoleID', 'RenewalIntent'], ResultType: 'simple' },
            { EntityName: 'Committees: Terms', Fields: ['ID', 'CommitteeID', 'Committee', 'EndDate', 'Status'], ResultType: 'simple' },
        ]);
        const memberships = (membershipsR.Success ? membershipsR.Results : []) as unknown as MembershipRow[];
        const terms = (termsR.Success ? termsR.Results : []) as unknown as TermRow[];
        // Roles come from the process-wide lookup engine — no per-load query.
        const roles: RoleRow[] = CommitteesLookupEngine.Instance.Roles.map(r => ({ ID: r.ID, IsVotingRole: r.IsVotingRole }));

        this.myMembershipIDs = new Set(memberships.map(m => m.ID.toLowerCase()));
        const now = new Date();
        this.Committees = this.buildCommitteeCards(memberships, terms, roles, now);

        const committeeIDs = [...new Set(this.Committees.map(c => `'${c.CommitteeID}'`))];
        if (committeeIDs.length === 0) return;
        const committeeFilter = committeeIDs.join(',');

        const [meetingsR, actionsR, ballotsR, minutesR, myVotesR, myAttR] = await rv.RunViews([
            { EntityName: 'Committees: Meetings', ExtraFilter: `CommitteeID IN (${committeeFilter})`, Fields: ['ID', 'CommitteeID', 'Committee', 'Name', 'StartDateTime', 'EndDateTime', 'LocationType', 'LocationText', 'VideoJoinURL', 'Status'], OrderBy: 'StartDateTime ASC', ResultType: 'simple' },
            { EntityName: 'Committees: Action Items', ExtraFilter: `AssignedToPersonID = '${personID}' AND Status IN ('Open', 'InProgress')`, Fields: ['ID', 'Name', 'Committee', 'DueDate', 'Status'], ResultType: 'simple' },
            { EntityName: 'Committees: Ballots', ExtraFilter: `Status = 'Open' AND CommitteeID IN (${committeeFilter})`, ResultType: 'simple' },
            { EntityName: 'Committees: Minutes', ExtraFilter: "ApprovalStatus = 'PendingApproval'", Fields: ['ID', 'MeetingID', 'Meeting', 'ApprovalStatus'], ResultType: 'simple' },
            { EntityName: 'Committees: Votes', ExtraFilter: `MembershipID IN (${[...this.myMembershipIDs].map(id => `'${id}'`).join(',')})`, Fields: ['ID', 'MotionID', 'MembershipID', 'VoteValue'], ResultType: 'simple' },
            { EntityName: 'Committees: Attendances', ExtraFilter: `PersonID = '${personID}'`, Fields: ['ID', 'MeetingID', 'PersonID', 'AttendanceStatus'], ResultType: 'simple' },
        ]);
        const meetings = (meetingsR.Success ? meetingsR.Results : []) as unknown as MeetingRow[];
        const actions = (actionsR.Success ? actionsR.Results : []) as unknown as ActionRow[];
        const ballots = (ballotsR.Success ? ballotsR.Results : []) as unknown as BallotRow[];
        const minutes = (minutesR.Success ? minutesR.Results : []) as unknown as MinuteRow[];
        const myVotes = (myVotesR.Success ? myVotesR.Results : []) as unknown as VoteRow[];
        const myAttendance = (myAttR.Success ? myAttR.Results : []) as unknown as ({ ID: string } & { MeetingID: string; AttendanceStatus: string })[];

        this.pickNextMeeting(meetings, myAttendance, now);
        await this.loadNextMeetingAgenda();
        this.computeAttendanceRates(meetings, myAttendance);
        this.buildNeeds(actions, ballots, minutes, myVotes, meetings, now);
        await this.loadDecisions(myVotes);
    }

    /** One card per active membership, term-anchored, with the intent-ask window applied. */
    private buildCommitteeCards(memberships: MembershipRow[], terms: TermRow[], roles: RoleRow[], now: Date): MyCommittee[] {
        const termsByID = new Map(terms.map(t => [t.ID.toLowerCase(), t]));
        const votingRoles = new Set(roles.filter(r => r.IsVotingRole).map(r => r.ID.toLowerCase()));
        return memberships
            .map(m => {
                const term = termsByID.get(m.TermID.toLowerCase());
                if (!term) return null;
                const end = term.EndDate ? new Date(term.EndDate) : null;
                const daysLeft = end ? Math.ceil((end.getTime() - now.getTime()) / 86_400_000) : null;
                return {
                    MembershipID: m.ID,
                    CommitteeID: term.CommitteeID,
                    CommitteeName: term.Committee,
                    RoleName: m.Role,
                    IsVoting: votingRoles.has(m.RoleID.toLowerCase()),
                    TermEnd: end,
                    AttendanceRate: null,
                    RenewalIntent: m.RenewalIntent ?? null,
                    AskIntent: daysLeft != null && daysLeft > 0 && daysLeft <= INTENT_ASK_WINDOW_DAYS,
                } as MyCommittee;
            })
            .filter((c): c is MyCommittee => c !== null);
    }

    private pickNextMeeting(meetings: MeetingRow[], myAttendance: { ID: string; MeetingID: string; AttendanceStatus: string }[], now: Date): void {
        this.NextMeeting = meetings.find(m =>
            new Date(m.StartDateTime) >= now && (m.Status === 'Scheduled' || m.Status === 'InProgress')) ?? null;
        if (this.NextMeeting) {
            const mine = myAttendance.find(a => a.MeetingID.toLowerCase() === this.NextMeeting!.ID.toLowerCase());
            this.myAttendanceID = mine?.ID ?? null;
            this.MyRsvp = mine?.AttendanceStatus === 'Absent' ? 'Absent'
                : mine?.AttendanceStatus === 'Expected' || mine?.AttendanceStatus === 'Present' ? 'Expected'
                : null;
        }
    }

    private async loadNextMeetingAgenda(): Promise<void> {
        if (!this.NextMeeting) return;
        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'Committees: Agenda Items',
            ExtraFilter: `MeetingID = '${this.NextMeeting.ID}'`,
            Fields: ['ID', 'MeetingID', 'ItemType'],
            ResultType: 'simple',
        });
        const items = (result.Success ? result.Results : []) as unknown as AgendaCountRow[];
        this.NextMeetingAgendaCount = items.length;
        this.NextMeetingVoteCount = items.filter(i => i.ItemType === 'Vote').length;
    }

    private computeAttendanceRates(meetings: MeetingRow[], myAttendance: { MeetingID: string; AttendanceStatus: string }[], ): void {
        const completedByCommittee = new Map<string, Set<string>>();
        for (const m of meetings.filter(m => m.Status === 'Completed')) {
            const key = m.CommitteeID.toLowerCase();
            (completedByCommittee.get(key) ?? completedByCommittee.set(key, new Set()).get(key)!).add(m.ID.toLowerCase());
        }
        for (const c of this.Committees) {
            const meetingIDs = completedByCommittee.get(c.CommitteeID.toLowerCase());
            if (!meetingIDs || meetingIDs.size === 0) continue;
            const mine = myAttendance.filter(a => meetingIDs.has(a.MeetingID.toLowerCase()));
            if (mine.length === 0) continue;
            const present = mine.filter(a => a.AttendanceStatus === 'Present' || a.AttendanceStatus === 'Partial').length;
            c.AttendanceRate = present / mine.length;
        }
    }

    private buildNeeds(
        actions: ActionRow[], ballots: BallotRow[], minutes: MinuteRow[],
        myVotes: VoteRow[], meetings: MeetingRow[], now: Date
    ): void {
        const needs: NeedsYouItem[] = [];
        for (const a of actions) {
            const due = a.DueDate ? new Date(a.DueDate) : null;
            const overdue = due != null && due < now;
            const dueTxt = due ? (overdue
                ? `${Math.ceil((now.getTime() - due.getTime()) / 86_400_000)} days overdue`
                : `due ${due.toLocaleDateString([], { month: 'short', day: 'numeric', timeZone: 'UTC' })}`) : 'no due date';
            needs.push({
                Kind: 'action', Key: `a-${a.ID}`, ActionItemID: a.ID,
                Title: a.Name, Detail: `${a.Committee ?? 'Committee'} · ${dueTxt}`, Urgent: overdue,
            });
        }
        const votedMotions = new Set(myVotes.map(v => v.MotionID.toLowerCase()));
        for (const b of ballots) {
            if (votedMotions.has(b.MotionID.toLowerCase())) continue;
            const myCommittee = this.Committees.find(c => c.CommitteeID.toLowerCase() === b.CommitteeID.toLowerCase());
            if (!myCommittee?.IsVoting) continue;
            const closes = new Date(b.ClosesAt);
            needs.push({
                Kind: 'ballot', Key: `b-${b.ID}`, BallotMotionID: b.MotionID,
                MyMembershipID: myCommittee.MembershipID, Sealed: b.IsSealed,
                Title: `Vote: ${b.Motion}`,
                Detail: `${b.Committee} · e-ballot closes ${closes.toLocaleDateString([], { month: 'short', day: 'numeric' })}`,
                Urgent: (closes.getTime() - now.getTime()) < 2 * 86_400_000,
            });
        }
        const meetingCommittee = new Map(meetings.map(m => [m.ID.toLowerCase(), m.CommitteeID.toLowerCase()]));
        const myCommitteeIDs = new Set(this.Committees.map(c => c.CommitteeID.toLowerCase()));
        for (const mi of minutes) {
            if (!mi.MeetingID) continue;   // a minute not tied to a meeting can't be attributed to a committee
            const committeeID = meetingCommittee.get(mi.MeetingID.toLowerCase());
            if (!committeeID || !myCommitteeIDs.has(committeeID)) continue;
            needs.push({
                Kind: 'minutes', Key: `m-${mi.ID}`, MeetingID: mi.MeetingID,
                Title: `Read the minutes: ${mi.Meeting}`,
                Detail: 'You may vote on approving them at an upcoming meeting', Urgent: false,
            });
        }
        this.Needs = needs.sort((a, b) => Number(b.Urgent) - Number(a.Urgent));
    }

    private async loadDecisions(myVotes: VoteRow[]): Promise<void> {
        if (myVotes.length === 0) { this.Decisions = []; return; }
        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'Committees: Motions',
            ExtraFilter: `ID IN (${myVotes.map(v => `'${v.MotionID}'`).join(',')}) AND Result <> 'Pending'`,
            Fields: ['ID', 'Name', 'Result', 'YesCount', 'NoCount', 'AbstainCount', '__mj_CreatedAt'],
            OrderBy: '__mj_CreatedAt DESC',
            ResultType: 'simple',
        });
        const motions = (result.Success ? result.Results : []) as unknown as MotionRow[];
        const voteByMotion = new Map(myVotes.map(v => [v.MotionID.toLowerCase(), v.VoteValue]));
        this.Decisions = motions.slice(0, 4).map(m => ({
            When: new Date(m.__mj_CreatedAt),
            Text: `${m.Name} — ${m.Result.toLowerCase()}${m.YesCount != null ? ` ${m.YesCount}-${m.NoCount}-${m.AbstainCount}` : ''}`,
            MyVote: voteByMotion.get(m.ID.toLowerCase()) ?? '—',
        }));
    }

    // ── Derived ─────────────────────────────────────────────────

    get NeedsCount(): number { return this.Needs.length; }

    get NextMeetingDay(): string {
        return this.NextMeeting
            ? new Date(this.NextMeeting.StartDateTime).toLocaleDateString([], { weekday: 'long' })
            : '';
    }

    get JoinEnabled(): boolean {
        if (!this.NextMeeting?.VideoJoinURL) return false;
        const start = new Date(this.NextMeeting.StartDateTime).getTime();
        return Date.now() >= start - 15 * 60_000;
    }

    // ── Actions ─────────────────────────────────────────────────

    async OnRsvp(attending: boolean): Promise<void> {
        if (!this.NextMeeting || !this.personID || this.IsActing) return;
        this.IsActing = true;
        try {
            const md = new Metadata();
            const att = await md.GetEntityObject<mjBizAppsCommitteesAttendanceEntity>('Committees: Attendances');
            if (this.myAttendanceID) {
                if (!await att.Load(this.myAttendanceID)) throw new Error('Attendance not found');
            } else {
                att.MeetingID = this.NextMeeting.ID;
                att.PersonID = this.personID;
            }
            att.AttendanceStatus = attending ? 'Expected' : 'Absent';
            if (!await att.Save()) throw new Error(att.LatestResult?.Message ?? 'RSVP failed');
            this.myAttendanceID = att.ID;
            this.MyRsvp = attending ? 'Expected' : 'Absent';
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'RSVP failed';
        }
        this.IsActing = false;
        this.cdr.detectChanges();
    }

    async OnCompleteAction(item: NeedsYouItem): Promise<void> {
        if (!item.ActionItemID || this.IsActing) return;
        this.IsActing = true;
        try {
            const md = new Metadata();
            const action = await md.GetEntityObject<mjBizAppsCommitteesActionItemEntity>('Committees: Action Items');
            if (!await action.Load(item.ActionItemID)) throw new Error('Action item not found');
            action.Status = 'Completed';
            action.CompletedAt = new Date();
            if (!await action.Save()) throw new Error(action.LatestResult?.Message ?? 'Update failed');
            this.Needs = this.Needs.filter(n => n.Key !== item.Key);
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to complete';
        }
        this.IsActing = false;
        this.cdr.detectChanges();
    }

    async OnBallotVote(item: NeedsYouItem, value: 'Yes' | 'No' | 'Abstain'): Promise<void> {
        if (!item.BallotMotionID || !item.MyMembershipID || this.IsActing) return;
        this.IsActing = true;
        try {
            const md = new Metadata();
            const vote = await md.GetEntityObject<mjBizAppsCommitteesVoteEntity>('Committees: Votes');
            vote.MotionID = item.BallotMotionID;
            vote.MembershipID = item.MyMembershipID;
            vote.VoteValue = value;
            if (!await vote.Save()) throw new Error(vote.LatestResult?.Message ?? 'Vote failed');
            this.Needs = this.Needs.filter(n => n.Key !== item.Key);
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Vote failed';
        }
        this.IsActing = false;
        this.cdr.detectChanges();
    }

    OnReadMinutes(item: NeedsYouItem): void {
        this.MinutesReviewMeetingID = item.MeetingID ?? null;
        this.cdr.detectChanges();
    }

    /** The reader may have approved the minutes in the overlay — refresh the feed. */
    async OnMinutesExited(): Promise<void> {
        this.MinutesReviewMeetingID = null;
        this.cdr.detectChanges();
        await this.Load();
    }

    async OnIntent(committee: MyCommittee, value: 'Yes' | 'No' | 'Undecided'): Promise<void> {
        if (this.IsActing) return;
        this.IsActing = true;
        try {
            const md = new Metadata();
            const membership = await md.GetEntityObject<mjBizAppsCommitteesMembershipEntity>('Committees: Memberships');
            if (!await membership.Load(committee.MembershipID)) throw new Error('Membership not found');
            membership.RenewalIntent = value;
            if (!await membership.Save()) throw new Error(membership.LatestResult?.Message ?? 'Save failed');
            committee.RenewalIntent = value;
            committee.EditingIntent = false;
        } catch (err) {
            this.ErrorMessage = err instanceof Error ? err.message : 'Failed to save your answer';
        }
        this.IsActing = false;
        this.cdr.detectChanges();
    }

    IntentAnsweredText(committee: MyCommittee): string {
        switch (committee.RenewalIntent) {
            case 'Yes': return "You've said you'll serve another term.";
            case 'No': return "You've said you won't return next term.";
            default: return "You've answered: undecided for now.";
        }
    }

    /** Client-generated ICS download for the next meeting. */
    OnAddToCalendar(): void {
        const m = this.NextMeeting;
        if (!m) return;
        const dt = (d: Date) => d.toISOString().replace(/[-:]/g, '').replace(/\.\d{3}/, '');
        const start = new Date(m.StartDateTime);
        const end = m.EndDateTime ? new Date(m.EndDateTime) : new Date(start.getTime() + 3600_000);
        const ics = [
            'BEGIN:VCALENDAR', 'VERSION:2.0', 'PRODID:-//Committees//EN', 'BEGIN:VEVENT',
            `UID:${m.ID}@committees`, `DTSTART:${dt(start)}`, `DTEND:${dt(end)}`,
            `SUMMARY:${m.Name}`, `DESCRIPTION:${m.Committee}`,
            m.VideoJoinURL ? `URL:${m.VideoJoinURL}` : '',
            'END:VEVENT', 'END:VCALENDAR',
        ].filter(Boolean).join('\r\n');
        const blob = new Blob([ics], { type: 'text/calendar' });
        const a = document.createElement('a');
        a.href = URL.createObjectURL(blob);
        a.download = `${m.Name.replace(/[^\w ]/g, '')}.ics`;
        a.click();
        URL.revokeObjectURL(a.href);
    }

    OnJoin(): void {
        if (this.NextMeeting?.VideoJoinURL) window.open(this.NextMeeting.VideoJoinURL, '_blank', 'noopener');
    }

    IntentButtons(): Array<'Yes' | 'No' | 'Undecided'> { return ['Yes', 'No', 'Undecided']; }

    /** Sealed-ballot note reuses BallotService semantics for the tooltip. */
    SealNote(item: NeedsYouItem): string {
        return item.Sealed && BallotService.AreChoicesSealed({ IsSealed: true, Status: 'Open' })
            ? 'Your choice is sealed until the ballot closes'
            : '';
    }
}
