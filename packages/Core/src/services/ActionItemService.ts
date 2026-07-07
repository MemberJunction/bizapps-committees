import { Metadata, RunView, UserInfo } from '@memberjunction/core';
import { mjBizAppsCommitteesActionItemEntity } from '@mj-biz-apps/committees-entities';

/**
 * Lightweight read-only view of an action item for cross-committee lists.
 */
export interface ActionItemSummary {
    ID: string;
    CommitteeID: string;
    CommitteeName: string;
    Name: string;
    Description: string | null;
    DueDate: Date | null;
    Priority: string;
    Status: string;
    AssignedToPersonID: string;
    AssignedToPerson: string | null;
}

/**
 * Service class for action item operations: listing items per person,
 * finding overdue items, and completing items.
 */
export class ActionItemService {
    /**
     * Returns all action items assigned to a person across all committees,
     * ordered by due date. Uses a read-only simple query.
     */
    public async GetActionItemsForPerson(
        personID: string,
        contextUser: UserInfo
    ): Promise<ActionItemSummary[]> {
        const rv = new RunView();
        const result = await rv.RunView<ActionItemSummaryRow>({
            EntityName: 'Committees: Action Items',
            ExtraFilter: `AssignedToPersonID='${personID}' AND Status IN ('Open', 'InProgress')`,
            Fields: ACTION_ITEM_SUMMARY_FIELDS,
            OrderBy: 'DueDate ASC, Priority',
            ResultType: 'simple',
        }, contextUser);

        if (!result.Success) {
            throw new Error(`Failed to load action items for person ${personID}: ${result.ErrorMessage}`);
        }

        return (result.Results ?? []).map(r => this.mapToActionItemSummary(r));
    }

    /**
     * Returns action items that are past their due date. Optionally filters
     * to a specific committee; pass null to get overdue items across all committees.
     */
    public async GetOverdueActionItems(
        committeeID: string | null,
        contextUser: UserInfo
    ): Promise<ActionItemSummary[]> {
        const now = new Date().toISOString().split('T')[0]; // YYYY-MM-DD for date comparison
        const filter = this.buildOverdueFilter(committeeID, now);

        const rv = new RunView();
        const result = await rv.RunView<ActionItemSummaryRow>({
            EntityName: 'Committees: Action Items',
            ExtraFilter: filter,
            Fields: ACTION_ITEM_SUMMARY_FIELDS,
            OrderBy: 'DueDate ASC, Priority',
            ResultType: 'simple',
        }, contextUser);

        if (!result.Success) {
            throw new Error(`Failed to load overdue action items: ${result.ErrorMessage}`);
        }

        return (result.Results ?? []).map(r => this.mapToActionItemSummary(r));
    }

    /**
     * Marks an action item as Completed, recording the completion timestamp
     * and any notes about how it was resolved.
     */
    public async CompleteActionItem(
        actionItemID: string,
        completionNotes: string,
        contextUser: UserInfo
    ): Promise<mjBizAppsCommitteesActionItemEntity> {
        const actionItem = await this.loadActionItem(actionItemID, contextUser);

        actionItem.Status = 'Completed';
        actionItem.CompletedAt = new Date();
        actionItem.CompletionNotes = completionNotes;

        const saved = await actionItem.Save();
        if (!saved) {
            throw new Error(`Failed to complete action item ${actionItemID}`);
        }

        return actionItem;
    }

    /** Loads a single action item entity by ID for mutation. */
    private async loadActionItem(
        actionItemID: string,
        contextUser: UserInfo
    ): Promise<mjBizAppsCommitteesActionItemEntity> {
        const md = new Metadata();
        const actionItem = await md.GetEntityObject<mjBizAppsCommitteesActionItemEntity>('Committees: Action Items', contextUser);
        const loaded = await actionItem.Load(actionItemID);
        if (!loaded) {
            throw new Error(`Action item not found: ${actionItemID}`);
        }
        return actionItem;
    }

    /** Builds the SQL filter for overdue items, optionally scoped to a committee. */
    private buildOverdueFilter(committeeID: string | null, todayDate: string): string {
        const baseFilter = `DueDate < '${todayDate}' AND Status IN ('Open', 'InProgress')`;
        if (committeeID != null) {
            return `${baseFilter} AND CommitteeID='${committeeID}'`;
        }
        return baseFilter;
    }

    /** Maps a raw row to an ActionItemSummary. */
    private mapToActionItemSummary(row: ActionItemSummaryRow): ActionItemSummary {
        return {
            ID: row.ID,
            CommitteeID: row.CommitteeID,
            CommitteeName: row.Committee,
            Name: row.Name,
            Description: row.Description,
            DueDate: row.DueDate,
            Priority: row.Priority,
            Status: row.Status,
            AssignedToPersonID: row.AssignedToPersonID,
            AssignedToPerson: row.AssignedToPerson,
        };
    }
}

/** Fields used for read-only action item summary queries. */
const ACTION_ITEM_SUMMARY_FIELDS = [
    'ID',
    'CommitteeID',
    'Committee',
    'Name',
    'Description',
    'DueDate',
    'Priority',
    'Status',
    'AssignedToPersonID',
    'AssignedToPerson',
];

/** Shape of a raw action item row returned by the simple RunView query. */
interface ActionItemSummaryRow {
    ID: string;
    CommitteeID: string;
    Committee: string;
    Name: string;
    Description: string | null;
    DueDate: Date | null;
    Priority: string;
    Status: string;
    AssignedToPersonID: string;
    AssignedToPerson: string | null;
}
