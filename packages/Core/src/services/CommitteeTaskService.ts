import { Metadata, RunView, UserInfo } from '@memberjunction/core';

/**
 * A BizAppsTasks task projected into committee terms. Committee scope is
 * resolved two ways and unioned, because tasks arrive by two paths:
 *  - TaskLink rows against the 'Committees: Committees' entity (set by the
 *    ActionItem data migration and by meeting/agenda flows), and
 *  - TaskCategory-per-committee (category name = committee name), the
 *    convention the task tracker's quick-add path uses.
 */
export interface CommitteeTaskRow {
    ID: string;
    Name: string;
    Status: string;
    Priority: string;
    DueAt: string | null;
    /** All committees this task belongs to (TaskLink ∪ category-name match). */
    CommitteeIDs: string[];
    /** Names for CommitteeIDs, same order (unresolvable IDs are skipped). */
    CommitteeNames: string[];
    AssigneePersonID: string | null;
    AssigneeName: string | null;
}

export interface CommitteeTaskScope {
    /** Only tasks assigned to this person (via TaskAssignment). */
    AssignedToPersonID?: string;
    /** Include Completed/Cancelled/Blocked tasks; default is Open + InProgress only. */
    IncludeCompleted?: boolean;
}

interface TaskQueryRow { ID: string; Name: string; Status: string; Priority: string; DueAt: string | null; Category: string | null; }
interface LinkRow { TaskID: string; RecordID: string; }
interface CommitteeNameRow { ID: string; Name: string; }
interface AssignmentRow { TaskID: string; AssigneeRecordID: string; }
interface PersonRow { ID: string; DisplayName: string | null; }

const OPEN_STATUS_FILTER = "Status IN ('Open', 'InProgress')";
const IN_CLAUSE_CHUNK_SIZE = 400;

/** Shape guard for caller-supplied IDs that reach ExtraFilter SQL text. */
const UUID_SHAPE = /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/;

/** A quoted UUID literal safe for a filter, or an error: every id here reaches SQL text. */
function guidLiteral(id: string, label: string): string {
    if (!UUID_SHAPE.test(id)) {
        throw new Error(`${label} '${id}' is not a valid ID.`);
    }
    return `'${id}'`;
}

/** Splits an ID array into bounded chunks safe for SQL `IN (...)` filters. */
function chunkIDs(ids: string[], size = IN_CLAUSE_CHUNK_SIZE): string[][] {
    const chunks: string[][] = [];
    for (let i = 0; i < ids.length; i += size) {
        chunks.push(ids.slice(i, i + size));
    }
    return chunks;
}

/**
 * Loads BizAppsTasks tasks with committee scope resolved using RLS-safe two-step
 * batched `RunViews` queries (zero raw SQL subqueries across views). Replaces the
 * legacy 'Committees: Action Items' view queries after the BizAppsTasks migration.
 */
export class CommitteeTaskService {
    public async GetTasks(scope: CommitteeTaskScope = {}, contextUser?: UserInfo): Promise<CommitteeTaskRow[]> {
        const committeesEntityID = new Metadata().EntityByName('Committees: Committees')?.ID;
        if (!committeesEntityID) throw new Error("Entity 'Committees: Committees' not found in metadata");

        const statusFilter = scope.IncludeCompleted ? '' : OPEN_STATUS_FILTER;
        const rv = new RunView();

        // RLS-safe two-step assignment resolution: when scoping to an assignee,
        // resolve assigned TaskIDs via a first-class RunView on Task Assignments
        // instead of a raw SQL subquery over vwTaskAssignments.
        let scopedTaskIDs: string[] | null = null;
        let preloadedAssignments: AssignmentRow[] | null = null;
        if (scope.AssignedToPersonID) {
            const personLiteral = guidLiteral(scope.AssignedToPersonID, 'AssignedToPersonID');
            const assignedRes = await rv.RunView<AssignmentRow>({
                EntityName: 'MJ_BizApps_Tasks: Task Assignments',
                ExtraFilter: `AssigneeRecordID = ${personLiteral}`,
                Fields: ['TaskID', 'AssigneeRecordID'],
                ResultType: 'simple',
            }, contextUser);
            preloadedAssignments = assignedRes.Success ? (assignedRes.Results ?? []) : [];
            scopedTaskIDs = [...new Set(preloadedAssignments.map(a => a.TaskID).filter(id => UUID_SHAPE.test(id)))];
            if (scopedTaskIDs.length === 0) {
                return [];
            }
        }

        const taskFilter = CommitteeTaskService.BuildScopedTaskFilter(statusFilter, scopedTaskIDs);
        const [tasksR, linksR, committeesR] = await rv.RunViews([
            { EntityName: 'MJ_BizApps_Tasks: Tasks', ExtraFilter: taskFilter, Fields: ['ID', 'Name', 'Status', 'Priority', 'DueAt', 'Category'], OrderBy: 'DueAt ASC', ResultType: 'simple' },
            { EntityName: 'MJ_BizApps_Tasks: Task Links', ExtraFilter: `EntityID = ${guidLiteral(committeesEntityID, 'CommitteesEntityID')}`, Fields: ['TaskID', 'RecordID'], ResultType: 'simple' },
            { EntityName: 'Committees: Committees', Fields: ['ID', 'Name'], ResultType: 'simple' },
        ], contextUser);

        const tasks = (tasksR?.Success ? tasksR.Results : []) as unknown as TaskQueryRow[];
        if (tasks.length === 0) return [];

        const links = (linksR?.Success ? linksR.Results : []) as unknown as LinkRow[];
        const committees = (committeesR?.Success ? committeesR.Results : []) as unknown as CommitteeNameRow[];
        const assignments = preloadedAssignments ?? await this.loadAssignmentsForTasks(rv, tasks.map(t => t.ID), contextUser);
        const people = await this.loadAssigneeNames(rv, assignments, contextUser);

        return CommitteeTaskService.BuildRows(tasks, links, committees, assignments, people);
    }

    /**
     * Builds an RLS-safe Tasks ExtraFilter from an optional status predicate and
     * pre-resolved TaskIDs (no raw cross-view SQL subquery).
     */
    public static BuildScopedTaskFilter(statusFilter: string, taskIDs: string[] | null): string {
        const parts: string[] = [];
        if (statusFilter) parts.push(statusFilter);
        if (taskIDs && taskIDs.length > 0) {
            const validLiterals = taskIDs.map(id => guidLiteral(id, 'TaskID'));
            parts.push(`ID IN (${validLiterals.join(',')})`);
        }
        return parts.join(' AND ');
    }

    /**
     * Builds the ExtraFilter for BizAppsTasks queries, UUID-guarding any caller-supplied
     * `assignedToPersonID` before it reaches SQL filter text.
     */
    public static BuildTaskFilter(statusFilter: string, assignedToPersonID?: string): string {
        const parts: string[] = [];
        if (statusFilter) parts.push(statusFilter);
        if (assignedToPersonID) {
            parts.push(`ID IN (SELECT TaskID FROM [__mj_BizAppsTasks].[vwTaskAssignments] WHERE AssigneeRecordID = ${guidLiteral(assignedToPersonID, 'AssignedToPersonID')})`);
        }
        return parts.join(' AND ');
    }

    private async loadAssignmentsForTasks(rv: RunView, taskIDs: string[], contextUser?: UserInfo): Promise<AssignmentRow[]> {
        const validIDs = [...new Set(taskIDs.filter(id => UUID_SHAPE.test(id)))];
        if (validIDs.length === 0) return [];
        const chunks = chunkIDs(validIDs);
        const results = await rv.RunViews(
            chunks.map(chunk => ({
                EntityName: 'MJ_BizApps_Tasks: Task Assignments',
                ExtraFilter: `TaskID IN (${chunk.map(id => `'${id}'`).join(',')})`,
                Fields: ['TaskID', 'AssigneeRecordID'],
                ResultType: 'simple' as const,
            })),
            contextUser
        );
        const rows: AssignmentRow[] = [];
        for (const res of results) {
            if (res?.Success && Array.isArray(res.Results)) {
                rows.push(...(res.Results as unknown as AssignmentRow[]));
            }
        }
        return rows;
    }

    private async loadAssigneeNames(rv: RunView, assignments: AssignmentRow[], contextUser?: UserInfo): Promise<PersonRow[]> {
        // SECURITY: AssigneeRecordID is polymorphic nvarchar; People.ID is uniqueidentifier.
        // Filter to valid UUIDs so malformed/non-UUID values can never reach SQL IN (...) text.
        const personIDs = [...new Set(assignments.map(a => a.AssigneeRecordID))]
            .filter(id => UUID_SHAPE.test(id));
        if (personIDs.length === 0) return [];
        const chunks = chunkIDs(personIDs);
        const results = await rv.RunViews(
            chunks.map(chunk => ({
                EntityName: 'MJ_BizApps_Common: People',
                ExtraFilter: `ID IN (${chunk.map(id => `'${id}'`).join(',')})`,
                Fields: ['ID', 'DisplayName'],
                ResultType: 'simple' as const,
            })),
            contextUser
        );
        const rows: PersonRow[] = [];
        for (const res of results) {
            if (res?.Success && Array.isArray(res.Results)) {
                rows.push(...(res.Results as unknown as PersonRow[]));
            }
        }
        return rows;
    }

    /** Pure shaping — deterministic and unit-testable without a database. */
    public static BuildRows(
        tasks: TaskQueryRow[], links: LinkRow[], committees: CommitteeNameRow[],
        assignments: AssignmentRow[], people: PersonRow[]
    ): CommitteeTaskRow[] {
        const committeeIDByName = new Map(committees.map(c => [c.Name, c.ID]));
        const committeeNameByID = new Map(committees.map(c => [c.ID.toLowerCase(), c.Name]));
        const linkedCommittees = new Map<string, Set<string>>();
        for (const l of links) {
            const key = l.TaskID.toLowerCase();
            (linkedCommittees.get(key) ?? linkedCommittees.set(key, new Set()).get(key)!).add(l.RecordID);
        }
        const assigneeByTask = new Map<string, string>();
        for (const a of assignments) {
            const key = a.TaskID.toLowerCase();
            if (!assigneeByTask.has(key)) assigneeByTask.set(key, a.AssigneeRecordID);
        }
        const nameByPerson = new Map(people.map(p => [p.ID.toLowerCase(), p.DisplayName]));

        return tasks.map(t => {
            const key = t.ID.toLowerCase();
            const ids = new Set(linkedCommittees.get(key) ?? []);
            const byCategory = t.Category ? committeeIDByName.get(t.Category) : undefined;
            if (byCategory && ![...ids].some(id => id.toLowerCase() === byCategory.toLowerCase())) {
                ids.add(byCategory);
            }
            const assigneeID = assigneeByTask.get(key) ?? null;
            const committeeIDs = [...ids];
            return {
                ID: t.ID,
                Name: t.Name,
                Status: t.Status,
                Priority: t.Priority,
                DueAt: t.DueAt,
                CommitteeIDs: committeeIDs,
                CommitteeNames: committeeIDs
                    .map(id => committeeNameByID.get(id.toLowerCase()))
                    .filter((n): n is string => n != null),
                AssigneePersonID: assigneeID,
                AssigneeName: assigneeID ? nameByPerson.get(assigneeID.toLowerCase()) ?? null : null,
            };
        });
    }
}
