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

/**
 * Loads BizAppsTasks tasks with committee scope resolved, in one batched
 * query set (plus one follow-up for assignee names). Replaces the legacy
 * 'Committees: Action Items' view queries after the BizAppsTasks migration.
 */
export class CommitteeTaskService {
    public async GetTasks(scope: CommitteeTaskScope = {}, contextUser?: UserInfo): Promise<CommitteeTaskRow[]> {
        const committeesEntityID = new Metadata().EntityByName('Committees: Committees')?.ID;
        if (!committeesEntityID) throw new Error("Entity 'Committees: Committees' not found in metadata");

        const statusFilter = scope.IncludeCompleted ? '' : OPEN_STATUS_FILTER;
        const taskFilter = this.buildTaskFilter(statusFilter, scope.AssignedToPersonID);

        const rv = new RunView();
        const [tasksR, linksR, committeesR, assignmentsR] = await rv.RunViews([
            { EntityName: 'MJ_BizApps_Tasks: Tasks', ExtraFilter: taskFilter, Fields: ['ID', 'Name', 'Status', 'Priority', 'DueAt', 'Category'], OrderBy: 'DueAt ASC', ResultType: 'simple' },
            { EntityName: 'MJ_BizApps_Tasks: Task Links', ExtraFilter: `EntityID = '${committeesEntityID}'`, Fields: ['TaskID', 'RecordID'], ResultType: 'simple' },
            { EntityName: 'Committees: Committees', Fields: ['ID', 'Name'], ResultType: 'simple' },
            { EntityName: 'MJ_BizApps_Tasks: Task Assignments', ExtraFilter: taskFilter ? `TaskID IN (SELECT ID FROM __mj_BizAppsTasks.Task WHERE ${taskFilter})` : '', Fields: ['TaskID', 'AssigneeRecordID'], ResultType: 'simple' },
        ], contextUser);

        const tasks = (tasksR?.Success ? tasksR.Results : []) as unknown as TaskQueryRow[];
        const links = (linksR?.Success ? linksR.Results : []) as unknown as LinkRow[];
        const committees = (committeesR?.Success ? committeesR.Results : []) as unknown as CommitteeNameRow[];
        const assignments = (assignmentsR?.Success ? assignmentsR.Results : []) as unknown as AssignmentRow[];
        const people = await this.loadAssigneeNames(rv, assignments, contextUser);

        return CommitteeTaskService.BuildRows(tasks, links, committees, assignments, people);
    }

    private buildTaskFilter(statusFilter: string, assignedToPersonID?: string): string {
        const parts: string[] = [];
        if (statusFilter) parts.push(statusFilter);
        if (assignedToPersonID) {
            parts.push(`ID IN (SELECT TaskID FROM __mj_BizAppsTasks.TaskAssignment WHERE AssigneeRecordID = '${assignedToPersonID}')`);
        }
        return parts.join(' AND ');
    }

    private async loadAssigneeNames(rv: RunView, assignments: AssignmentRow[], contextUser?: UserInfo): Promise<PersonRow[]> {
        const personIDs = [...new Set(assignments.map(a => a.AssigneeRecordID))];
        if (personIDs.length === 0) return [];
        const result = await rv.RunView({
            EntityName: 'MJ_BizApps_Common: People',
            ExtraFilter: `ID IN (${personIDs.map(id => `'${id}'`).join(',')})`,
            Fields: ['ID', 'DisplayName'],
            ResultType: 'simple',
        }, contextUser);
        return (result.Success ? result.Results : []) as unknown as PersonRow[];
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
