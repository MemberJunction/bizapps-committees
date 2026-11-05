/**
 * Committee Notification & Membership Seat Sync Handler
 *
 * Subscribes to MJGlobal entity events and:
 * - Meeting linked to a committee (MJ_BizApps_Tasks: Meeting Links) -> notify all active committee members
 * - Comment created (Committees: Comments) -> notify parent comment author (replies) and @mentioned people
 * - Membership created/updated (Committees: Memberships) -> sync SpaceMember seats via CommitteeSpaceServerDriver
 */
import {
    BaseEntity,
    BaseEntityEvent,
    type IMetadataProvider,
    LogError,
    LogStatus,
    Metadata,
    RunView,
    UserInfo,
} from '@memberjunction/core';
import { MJUserNotificationEntity } from '@memberjunction/core-entities';
import { ResolveUserIDForPerson } from '@mj-biz-apps/common-entities';
import { mjBizAppsTasksMeetingEntity, mjBizAppsTasksMeetingLinkEntity } from '@mj-biz-apps/tasks-entities';
import {
    mjBizAppsCommitteesCommentEntity,
    mjBizAppsCommitteesMembershipEntity,
} from '@mj-biz-apps/committees-entities';
import { MJEventType, MJGlobal, MJEvent, UUIDsEqual } from '@memberjunction/global';
import { Subscription } from 'rxjs';
import { CommitteeSpaceServerDriver } from '../drivers/CommitteeSpaceServerDriver.js';

const MEETING_LINKS_ENTITY = 'MJ_BizApps_Tasks: Meeting Links';
const COMMENTS_ENTITY = 'Committees: Comments';
const MEMBERSHIPS_ENTITY = 'Committees: Memberships';
const COMMITTEES_ENTITY_ID = 'A5DA88A1-AA21-4A3F-B1C4-42652FB440CE';

export function InitCommitteeNotificationHandler(): void {
    const storeKey = '___Committees___NotificationHandler___Subscription';
    const store = MJGlobal.Instance.GetGlobalObjectStore();

    if (store[storeKey]) {
        return;
    }

    const subscription: Subscription = MJGlobal.Instance.GetEventListener(true).subscribe(
        (event: MJEvent) => {
            if (
                event.event === MJEventType.ComponentEvent &&
                event.eventCode === BaseEntity.BaseEventCode
            ) {
                const entityEvent = event.args as BaseEntityEvent;
                handleEntityEvent(entityEvent);
            }
        }
    );

    store[storeKey] = subscription;
    LogStatus('[Committees] Notification handler initialized');
}

function handleEntityEvent(event: BaseEntityEvent): void {
    if (event.type !== 'save' || !event.baseEntity) {
        return;
    }

    const entityName = event.baseEntity.EntityInfo.Name;

    switch (entityName) {
        case MEETING_LINKS_ENTITY:
            handleMeetingLinkSave(event).catch(logHandlerError('MeetingLinkSave'));
            break;
        case COMMENTS_ENTITY:
            handleCommentSave(event).catch(logHandlerError('CommentSave'));
            break;
        case MEMBERSHIPS_ENTITY:
            handleMembershipSave(event).catch(logHandlerError('MembershipSave'));
            break;
    }
}

function logHandlerError(handler: string): (err: unknown) => void {
    return (err: unknown) => {
        const msg = err instanceof Error ? err.message : String(err);
        LogError(`[Committees] ${handler} notification error: ${msg}`);
    };
}

// ---------------------------------------------------------------------------
// Membership -> SpaceMember Seat Sync
// ---------------------------------------------------------------------------

async function handleMembershipSave(event: BaseEntityEvent): Promise<void> {
    const membership = event.baseEntity! as mjBizAppsCommitteesMembershipEntity;
    const contextUser = membership.ContextCurrentUser;
    if (!contextUser || !membership.TermID) {
        return;
    }

    const provider = (membership.ProviderToUse ?? Metadata.Provider) as unknown as IMetadataProvider;
    const rv = RunView.FromMetadataProvider(provider);
    const termRes = await rv.RunView<{ ParentID: string | null }>(
        {
            EntityName: 'Committees: Terms',
            ExtraFilter: `ID = '${membership.TermID}'`,
            Fields: ['ParentID'],
            MaxRows: 1,
            ResultType: 'simple',
        },
        contextUser
    );
    const committeeID = termRes.Success ? termRes.Results?.[0]?.ParentID ?? null : null;
    if (!committeeID) {
        return;
    }

    const driver = new CommitteeSpaceServerDriver();
    await driver.SyncCommitteeSeats(committeeID, contextUser, provider);
}

// ---------------------------------------------------------------------------
// Meeting Notifications (via MJ_BizApps_Tasks: Meeting Links)
// ---------------------------------------------------------------------------

async function handleMeetingLinkSave(event: BaseEntityEvent): Promise<void> {
    if (event.saveSubType !== 'create') {
        return;
    }

    const link = event.baseEntity! as mjBizAppsTasksMeetingLinkEntity;
    if (!UUIDsEqual(link.EntityID, COMMITTEES_ENTITY_ID)) {
        return;
    }

    const contextUser = link.ContextCurrentUser;
    if (!contextUser) {
        return;
    }

    const md = new Metadata();
    const meeting = await md.GetEntityObject<mjBizAppsTasksMeetingEntity>('MJ_BizApps_Tasks: Meetings', contextUser);
    if (!(await meeting.Load(link.MeetingID)) || meeting.Status !== 'Scheduled') {
        return;
    }

    const committeeID = link.RecordID;
    const rv = new RunView();
    const comRes = await rv.RunView<{ Name: string }>(
        {
            EntityName: 'Committees: Committees',
            ExtraFilter: `ID = '${committeeID}'`,
            Fields: ['Name'],
            MaxRows: 1,
            ResultType: 'simple',
        },
        contextUser
    );
    const committeeName = comRes.Success ? comRes.Results?.[0]?.Name ?? '' : '';

    const userIDs = await getCommitteeMemberUserIDs(committeeID, contextUser);
    if (userIDs.length === 0) {
        return;
    }

    const dateStr = formatDate(meeting.StartsAt);
    const notifTitle = `Meeting Scheduled: ${meeting.Name}`;
    const notifMessage = `A meeting "${meeting.Name}" has been scheduled for ${dateStr} in ${committeeName}.`;

    await createNotificationsForUsers(userIDs, notifTitle, notifMessage, contextUser);
    LogStatus(`[Committees] Sent meeting notification to ${userIDs.length} member(s) for "${meeting.Name}"`);
}

// ---------------------------------------------------------------------------
// Comment Notifications
// ---------------------------------------------------------------------------

async function handleCommentSave(event: BaseEntityEvent): Promise<void> {
    if (event.saveSubType !== 'create') {
        return;
    }

    const comment = event.baseEntity! as mjBizAppsCommitteesCommentEntity;
    const contextUser = comment.ContextCurrentUser;
    if (!contextUser) {
        return;
    }

    const authorPersonID = comment.PersonID;
    const commentText = comment.CommentText;
    const committeeName = comment.Committee ?? '';
    const preview = commentText.length > 80 ? commentText.substring(0, 80) + '...' : commentText;

    const userIDsToNotify = new Set<string>();

    const parentCommentID = comment.ParentCommentID;
    if (parentCommentID) {
        const parentAuthorPersonID = await getCommentAuthorPersonID(parentCommentID, contextUser);
        if (parentAuthorPersonID && !UUIDsEqual(parentAuthorPersonID, authorPersonID)) {
            const userID = await getPersonLinkedUserID(parentAuthorPersonID, contextUser);
            if (userID) userIDsToNotify.add(userID);
        }
    }

    const mentionedJSON = comment.MentionedPersonIDs;
    if (mentionedJSON) {
        const mentionedIDs = parseMentionedPersonIDs(mentionedJSON).filter(id => !UUIDsEqual(id, authorPersonID));
        for (const userID of await getLinkedUserIDsForPeople(mentionedIDs, contextUser)) {
            userIDsToNotify.add(userID);
        }
    }

    if (userIDsToNotify.size === 0) {
        return;
    }

    const authorName = comment.Person || 'Someone';
    const notifTitle = `New comment in ${committeeName}`;
    const notifMessage = `${authorName} commented: "${preview}"`;

    await createNotificationsForUsers([...userIDsToNotify], notifTitle, notifMessage, contextUser);
    LogStatus(`[Committees] Sent comment notification to ${userIDsToNotify.size} user(s)`);
}

async function getCommentAuthorPersonID(commentID: string, contextUser: UserInfo): Promise<string | null> {
    const rv = new RunView();
    const result = await rv.RunView<{ PersonID: string }>({
        EntityName: 'Committees: Comments',
        ExtraFilter: `ID='${commentID}'`,
        Fields: ['ID', 'PersonID'],
        ResultType: 'simple',
        MaxRows: 1,
    }, contextUser);

    if (!result.Success || result.Results.length === 0) {
        return null;
    }
    return result.Results[0].PersonID;
}

const GUID_PATTERN = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function parseMentionedPersonIDs(json: string): string[] {
    try {
        const parsed: unknown = JSON.parse(json);
        if (Array.isArray(parsed)) {
            return parsed.filter((id): id is string => typeof id === 'string' && GUID_PATTERN.test(id));
        }
    } catch {
        // Invalid JSON — ignore
    }
    return [];
}

async function getCommitteeMemberUserIDs(committeeID: string, contextUser: UserInfo): Promise<string[]> {
    const rv = new RunView();
    const terms = await rv.RunView<{ ID: string }>({
        EntityName: 'Committees: Terms',
        ExtraFilter: `ParentID='${committeeID}' AND ClosedAt IS NULL`,
        Fields: ['ID'],
        ResultType: 'simple',
    }, contextUser);
    const termIDs = (terms.Success ? terms.Results ?? [] : []).map(t => t.ID);
    if (termIDs.length === 0) {
        return [];
    }

    const memberships = await rv.RunView<{ PersonID: string }>({
        EntityName: 'Committees: Memberships',
        ExtraFilter: `TermID IN (${termIDs.map(id => `'${id}'`).join(',')}) AND Status='Active'`,
        Fields: ['ID', 'PersonID'],
        ResultType: 'simple',
    }, contextUser);

    if (!memberships.Success || memberships.Results.length === 0) {
        return [];
    }

    const personIDs = memberships.Results.map(m => m.PersonID);
    return getLinkedUserIDsForPeople(personIDs, contextUser);
}

async function getLinkedUserIDsForPeople(personIDs: string[], contextUser: UserInfo): Promise<string[]> {
    if (personIDs.length === 0) return [];
    const resolved: string[] = [];
    for (const pid of personIDs) {
        const uid = await getPersonLinkedUserID(pid, contextUser);
        if (uid) resolved.push(uid);
    }
    return [...new Set(resolved)];
}

async function getPersonLinkedUserID(personID: string, contextUser: UserInfo): Promise<string | null> {
    try {
        const resolved = await ResolveUserIDForPerson(personID, Metadata.Provider, contextUser);
        if (resolved) return resolved;
    } catch {
        // Fallback to People view below
    }
    const rv = new RunView();
    const result = await rv.RunView<{ ID: string; LinkedUserID: string | null }>({
        EntityName: 'MJ_BizApps_Common: People',
        ExtraFilter: `ID='${personID}'`,
        Fields: ['ID', 'LinkedUserID'],
        ResultType: 'simple',
    }, contextUser);

    if (!result.Success || result.Results.length === 0) {
        return null;
    }

    return result.Results[0].LinkedUserID ?? null;
}

async function createNotificationsForUsers(
    userIDs: string[],
    title: string,
    message: string,
    contextUser: UserInfo
): Promise<void> {
    const md = new Metadata();

    const saves = userIDs.map(async (userID) => {
        const notification = await md.GetEntityObject<MJUserNotificationEntity>(
            'MJ: User Notifications',
            contextUser
        );
        notification.UserID = userID;
        notification.Title = title;
        notification.Message = message;
        notification.Unread = true;

        const saved = await notification.Save();
        if (!saved) {
            LogError(`[Committees] Failed to save notification for user ${userID}: ${notification.LatestResult?.CompleteMessage}`);
        }
    });

    await Promise.all(saves);
}

function formatDate(date: Date): string {
    if (!(date instanceof Date) || isNaN(date.getTime())) {
        return 'TBD';
    }
    return date.toLocaleDateString('en-US', {
        month: 'short',
        day: 'numeric',
        year: 'numeric',
        hour: 'numeric',
        minute: '2-digit',
    });
}
