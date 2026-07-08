/**
 * Committee Notification Handler
 *
 * Subscribes to MJGlobal entity events and creates in-app notifications
 * (MJ: User Notifications) for key committee events:
 *
 * - Meeting scheduled → notify all active committee members
 * - Action item created → notify the assigned person
 * - Comment created → notify parent comment author (replies) and @mentioned people
 */
import {
    BaseEntity,
    BaseEntityEvent,
    LogError,
    LogStatus,
    Metadata,
    RunView,
    UserInfo,
} from '@memberjunction/core';
import { MJUserNotificationEntity } from '@memberjunction/core-entities';
import {
    mjBizAppsCommitteesMeetingEntity,
    mjBizAppsCommitteesActionItemEntity,
    mjBizAppsCommitteesCommentEntity,
} from '@mj-biz-apps/committees-entities';
import { MJEventType, MJGlobal, MJEvent , UUIDsEqual } from '@memberjunction/global';
import { Subscription } from 'rxjs';

/** Entity names we listen for */
const MEETINGS_ENTITY = 'Committees: Meetings';
const ACTION_ITEMS_ENTITY = 'Committees: Action Items';
const COMMENTS_ENTITY = 'Committees: Comments';


/**
 * Initializes the global event subscription for committee notifications.
 * Call once at server startup (from LoadCommitteesServer).
 */
export function InitCommitteeNotificationHandler(): void {
    const storeKey = '___Committees___NotificationHandler___Subscription';
    const store = MJGlobal.Instance.GetGlobalObjectStore();

    // Guard against double-subscription (bundler duplication / hot-reload)
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

// ---------------------------------------------------------------------------
// Event Router
// ---------------------------------------------------------------------------

function handleEntityEvent(event: BaseEntityEvent): void {
    if (event.type !== 'save' || !event.baseEntity) {
        return;
    }

    const entityName = event.baseEntity.EntityInfo.Name;

    switch (entityName) {
        case MEETINGS_ENTITY:
            handleMeetingSave(event).catch(logHandlerError('MeetingSave'));
            break;
        case ACTION_ITEMS_ENTITY:
            handleActionItemSave(event).catch(logHandlerError('ActionItemSave'));
            break;
        case COMMENTS_ENTITY:
            handleCommentSave(event).catch(logHandlerError('CommentSave'));
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
// Meeting Notifications
// ---------------------------------------------------------------------------

/**
 * When a NEW meeting is created with Status=Scheduled, notify all
 * active committee members who have a linked MJ User.
 *
 * Note: We only notify on create (not update) because BaseEntity's
 * finalizeSave() resets dirty flags before the 'save' event fires,
 * making field-level change detection impossible from this event.
 */
async function handleMeetingSave(event: BaseEntityEvent): Promise<void> {
    // Only notify on create, not every update
    if (event.saveSubType !== 'create') {
        return;
    }

    const meeting = event.baseEntity! as mjBizAppsCommitteesMeetingEntity;
    const status = meeting.Status;

    // Only notify when meeting is actively scheduled
    if (status !== 'Scheduled') {
        return;
    }

    const contextUser = meeting.ContextCurrentUser;
    if (!contextUser) {
        return;
    }

    const committeeID = meeting.CommitteeID;
    const title = meeting.Name;
    const startDateTime = meeting.StartDateTime;
    const committeeName = meeting.Committee ?? '';

    // Get all active members of this committee who have a linked User
    const userIDs = await getCommitteeMemberUserIDs(committeeID, contextUser);
    if (userIDs.length === 0) {
        return;
    }

    const dateStr = formatDate(startDateTime);
    const notifTitle = `Meeting Scheduled: ${title}`;
    const notifMessage = `A meeting "${title}" has been scheduled for ${dateStr} in ${committeeName}.`;

    await createNotificationsForUsers(userIDs, notifTitle, notifMessage, contextUser);
    LogStatus(`[Committees] Sent meeting notification to ${userIDs.length} member(s) for "${title}"`);
}

// ---------------------------------------------------------------------------
// Action Item Notifications
// ---------------------------------------------------------------------------

/**
 * When a NEW action item is created, notify the assigned person.
 *
 * Note: We only notify on create (not update) because BaseEntity's
 * finalizeSave() resets dirty flags before the 'save' event fires,
 * making reassignment detection impossible from this event.
 */
async function handleActionItemSave(event: BaseEntityEvent): Promise<void> {
    // Only notify on create, not every update
    if (event.saveSubType !== 'create') {
        return;
    }

    const actionItem = event.baseEntity! as mjBizAppsCommitteesActionItemEntity;
    const contextUser = actionItem.ContextCurrentUser;
    if (!contextUser) {
        return;
    }

    const assignedToPersonID = actionItem.AssignedToPersonID;
    if (!assignedToPersonID) {
        return;
    }

    const userID = await getPersonLinkedUserID(assignedToPersonID, contextUser);
    if (!userID) {
        return; // Person doesn't have a linked MJ user
    }

    const title = actionItem.Name;
    const committeeName = actionItem.Committee ?? '';
    const priority = actionItem.Priority;
    const dueDate = actionItem.DueDate;

    const dueDateStr = dueDate ? ` (due ${formatDate(dueDate)})` : '';
    const verb = event.saveSubType === 'create' ? 'assigned to you' : 'reassigned to you';
    const notifTitle = `Action Item: ${title}`;
    const notifMessage = `"${title}" has been ${verb} in ${committeeName}. Priority: ${priority}${dueDateStr}.`;

    await createNotificationsForUsers([userID], notifTitle, notifMessage, contextUser);
    LogStatus(`[Committees] Sent action-item notification for "${title}"`);
}

// ---------------------------------------------------------------------------
// Comment Notifications
// ---------------------------------------------------------------------------

/**
 * When a NEW comment is created, notify:
 * 1. The author of the parent comment (if this is a reply)
 * 2. Any @mentioned people (via MentionedPersonIDs JSON array)
 *
 * Skips notifying the comment author themselves.
 */
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

    // 1. Notify parent comment author on replies
    const parentCommentID = comment.ParentCommentID;
    if (parentCommentID) {
        const parentAuthorPersonID = await getCommentAuthorPersonID(parentCommentID, contextUser);
        if (parentAuthorPersonID && !UUIDsEqual(parentAuthorPersonID, authorPersonID)) {
            const userID = await getPersonLinkedUserID(parentAuthorPersonID, contextUser);
            if (userID) userIDsToNotify.add(userID);
        }
    }

    // 2. Notify @mentioned people (one batched lookup — RunView is expensive)
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

/**
 * Gets the PersonID of the author of a given comment.
 */
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

/**
 * Safely parses the MentionedPersonIDs JSON array.
 */
const GUID_PATTERN = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function parseMentionedPersonIDs(json: string): string[] {
    try {
        const parsed: unknown = JSON.parse(json);
        if (Array.isArray(parsed)) {
            // Client-authored payload: only well-formed GUIDs may reach a SQL filter.
            return parsed.filter((id): id is string => typeof id === 'string' && GUID_PATTERN.test(id));
        }
    } catch {
        // Invalid JSON — ignore
    }
    return [];
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/**
 * Returns the MJ UserIDs for all active members of a committee.
 * Two-step: get PersonIDs from Memberships, then resolve LinkedUserIDs from People.
 */
async function getCommitteeMemberUserIDs(committeeID: string, contextUser: UserInfo): Promise<string[]> {
    const rv = new RunView();

    // Step 1: Get all active member PersonIDs
    const memberships = await rv.RunView<{ PersonID: string }>({
        EntityName: 'Committees: Memberships',
        ExtraFilter: `CommitteeID='${committeeID}' AND Status='Active'`,
        Fields: ['ID', 'PersonID'],
        ResultType: 'simple',
    }, contextUser);

    if (!memberships.Success || memberships.Results.length === 0) {
        if (!memberships.Success) {
            LogError(`[Committees] Failed to load memberships for committee ${committeeID}: ${memberships.ErrorMessage}`);
        }
        return [];
    }

    const personIDs = memberships.Results.map(m => m.PersonID);

    // Step 2: Resolve PersonIDs → LinkedUserIDs
    const inClause = personIDs.map(id => `'${id}'`).join(',');
    const people = await rv.RunView<{ ID: string; LinkedUserID: string | null }>({
        EntityName: 'MJ_BizApps_Common: People',
        ExtraFilter: `ID IN (${inClause}) AND LinkedUserID IS NOT NULL`,
        Fields: ['ID', 'LinkedUserID'],
        ResultType: 'simple',
    }, contextUser);

    if (!people.Success) {
        LogError(`[Committees] Failed to resolve people for committee ${committeeID}: ${people.ErrorMessage}`);
        return [];
    }

    return people.Results
        .map(p => p.LinkedUserID)
        .filter((id): id is string => id != null);
}

/**
 * Resolves many PersonIDs to their linked MJ UserIDs in a single query.
 * Inputs must already be GUID-validated (parseMentionedPersonIDs).
 */
async function getLinkedUserIDsForPeople(personIDs: string[], contextUser: UserInfo): Promise<string[]> {
    if (personIDs.length === 0) return [];
    const rv = new RunView();
    const result = await rv.RunView<{ ID: string; LinkedUserID: string | null }>({
        EntityName: 'MJ_BizApps_Common: People',
        ExtraFilter: `ID IN (${personIDs.map(id => `'${id}'`).join(',')})`,
        Fields: ['ID', 'LinkedUserID'],
        ResultType: 'simple',
    }, contextUser);
    if (!result.Success) return [];
    return result.Results.map(p => p.LinkedUserID).filter((id): id is string => id != null);
}

/**
 * Resolves a PersonID to their linked MJ UserID (if any).
 */
async function getPersonLinkedUserID(personID: string, contextUser: UserInfo): Promise<string | null> {
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

/**
 * Creates an in-app notification for each UserID in the list.
 */
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

/**
 * Formats a Date to a readable string like "Mar 12, 2026 at 2:00 PM"
 */
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
