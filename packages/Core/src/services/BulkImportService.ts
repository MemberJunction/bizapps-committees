import { Metadata, RunView, UserInfo, LogError, LogStatus } from '@memberjunction/core';
import { UUIDsEqual } from '@memberjunction/global';
import { AgentRunner } from '@memberjunction/ai-agents';
import { AIEngine } from '@memberjunction/aiengine';
import { MJAIAgentEntityExtended } from '@memberjunction/ai-core-plus';
import {
    mjCommitteesCommitteeEntity,
    mjCommitteesTermEntity,
    mjCommitteesMembershipEntity,
    mjCommitteesTypeEntity,
    mjCommitteesRoleEntity,
} from '@mj-biz-apps/committees-entities';
import { mjBizAppsCommonPersonEntity } from '@mj-biz-apps/common-entities';

// =============================================================================
// Public types — also used by the resolver to shape GraphQL inputs/outputs.
// =============================================================================

export interface ImportProblem {
    field: string;
    severity: 'error' | 'warning';
    message: string;
    suggestedValue?: string | number | null;
}

export interface ImportCommitteeRow {
    Name: string;
    Description?: string | null;
    CommitteeType: string;
    _problems?: ImportProblem[];
}

export interface ImportTermRow {
    CommitteeRef: string;
    Year: number | null;
    StartDate: string | null;
    EndDate: string | null;
    _problems?: ImportProblem[];
}

export interface ImportPersonRow {
    FirstName: string;
    LastName: string;
    Email: string;
    _problems?: ImportProblem[];
}

export interface ImportMembershipRow {
    CommitteeRef: string;
    PersonRef: string;
    Role: string;
    Status: string;
    _problems?: ImportProblem[];
}

export interface ImportPlan {
    committees: ImportCommitteeRow[];
    terms: ImportTermRow[];
    people: ImportPersonRow[];
    memberships: ImportMembershipRow[];
}

export interface AnalyzeResult {
    Success: boolean;
    ErrorMessage?: string;
    Plan?: ImportPlan;
}

export interface ImportRowError {
    Entity: 'Committee' | 'Term' | 'Person' | 'Membership';
    Identifier: string;
    Message: string;
}

export interface ConfirmResult {
    Success: boolean;
    ErrorMessage?: string;
    CommitteesCreated: number;
    TermsCreated: number;
    PeopleCreated: number;
    MembershipsCreated: number;
    Errors: ImportRowError[];
}

const AGENT_NAME = 'Committee Importer';

// =============================================================================
// Service
// =============================================================================

/**
 * Drives the bulk-import flow: invokes the Committee Importer AI agent against
 * an uploaded spreadsheet artifact to extract a structured `ImportPlan`, then
 * creates entity records (committees, terms, people, memberships) on confirm.
 *
 * Per-row failures are collected into `Errors` rather than aborting the whole
 * import — partial success is the intended behavior.
 */
export class BulkImportService {
    /**
     * Reads a spreadsheet via the Committee Importer agent and returns the
     * parsed ImportPlan. The agent uses MJ's built-in ExcelToolLibrary to
     * navigate the workbook, so this method is shape-agnostic.
     */
    public async AnalyzeSpreadsheet(
        fileBase64: string,
        fileName: string,
        mimeType: string,
        contextUser: UserInfo
    ): Promise<AnalyzeResult> {
        try {
            const agent = await this.loadImporterAgent(contextUser);
            if (!agent) {
                return { Success: false, ErrorMessage: `Agent "${AGENT_NAME}" not found. Push metadata first.` };
            }

            const inputArtifacts = [{
                name: fileName,
                typeName: this.inferArtifactTypeName(mimeType),
                content: Buffer.from(fileBase64, 'base64'),
                mimeType,
            }];

            const runner = new AgentRunner();
            const result = await runner.RunAgent({
                agent,
                conversationMessages: [
                    {
                        role: 'user',
                        content: `Extract the committee data from the attached spreadsheet "${fileName}" and return the ImportPlan JSON.`,
                    },
                ],
                contextUser,
                data: { __inputArtifacts: inputArtifacts },
            });

            if (!result.success) {
                const message = result.agentRun?.ErrorMessage ?? 'Agent execution failed';
                return { Success: false, ErrorMessage: message };
            }

            const plan = this.coerceToPlan(result.payload);
            if (!plan) {
                return { Success: false, ErrorMessage: 'Agent returned an invalid ImportPlan shape.' };
            }

            return { Success: true, Plan: plan };
        } catch (error) {
            const message = error instanceof Error ? error.message : String(error);
            LogError(`[BulkImportService] AnalyzeSpreadsheet failed: ${message}`);
            return { Success: false, ErrorMessage: message };
        }
    }

    /**
     * Creates database records for an ImportPlan in dependency order:
     * Committees → Terms → People → Memberships. Per-row failures are
     * collected; the rest of the plan still imports.
     */
    public async ConfirmImport(plan: ImportPlan, contextUser: UserInfo): Promise<ConfirmResult> {
        const errors: ImportRowError[] = [];
        const committeeIDs = new Map<string, string>();   // Name → CommitteeID
        const termIDs = new Map<string, string>();         // CommitteeRef → TermID (latest term per committee from this import)
        const personIDs = new Map<string, string>();      // email-lower → PersonID
        const counts = { committees: 0, terms: 0, people: 0, memberships: 0 };

        try {
            const typeMap = await this.loadCommitteeTypeMap(contextUser);
            const roleMap = await this.loadRoleMap(contextUser);

            await this.createCommittees(plan.committees, typeMap, committeeIDs, errors, counts, contextUser);
            await this.createTerms(plan.terms, committeeIDs, termIDs, errors, counts, contextUser);
            await this.createPeople(plan.people, personIDs, errors, counts, contextUser);
            await this.createMemberships(plan.memberships, termIDs, personIDs, roleMap, errors, counts, contextUser);

            return {
                Success: true,
                CommitteesCreated: counts.committees,
                TermsCreated: counts.terms,
                PeopleCreated: counts.people,
                MembershipsCreated: counts.memberships,
                Errors: errors,
            };
        } catch (error) {
            const message = error instanceof Error ? error.message : String(error);
            LogError(`[BulkImportService] ConfirmImport failed: ${message}`);
            return {
                Success: false,
                ErrorMessage: message,
                CommitteesCreated: counts.committees,
                TermsCreated: counts.terms,
                PeopleCreated: counts.people,
                MembershipsCreated: counts.memberships,
                Errors: errors,
            };
        }
    }

    // -------------------------------------------------------------------------
    // Agent loading + payload coercion
    // -------------------------------------------------------------------------

    private async loadImporterAgent(contextUser: UserInfo): Promise<MJAIAgentEntityExtended | null> {
        // Use AIEngine's in-memory cache (canonical MJ pattern). The cache also holds
        // the AgentTypes that AgentRunner uses to resolve the DriverClass. Both the
        // agent and its type must be present in the cache; if either is missing
        // (likely because the cache was loaded before metadata-sync added them, or
        // because a startup load failed silently), force a refresh.
        await AIEngine.Instance.Config(false, contextUser);

        const cacheHit = (): { agent?: MJAIAgentEntityExtended; typeKnown: boolean } => {
            const agent = AIEngine.Instance.Agents.find(a => a.Name === AGENT_NAME);
            const typeKnown = !!agent && AIEngine.Instance.AgentTypes.some(t => UUIDsEqual(t.ID, agent.TypeID));
            return { agent: agent as MJAIAgentEntityExtended | undefined, typeKnown };
        };

        let result = cacheHit();
        if (!result.agent || !result.typeKnown) {
            await AIEngine.Instance.Config(true, contextUser);
            result = cacheHit();
        }

        if (!result.agent) {
            LogError(`[BulkImportService] Agent "${AGENT_NAME}" not found in AIEngine after refresh`);
            return null;
        }
        if (!result.typeKnown) {
            LogError(`[BulkImportService] Agent type ${result.agent.TypeID} for "${AGENT_NAME}" missing from AIEngine cache after refresh — DB may have failed to load AgentTypes`);
            return null;
        }
        return result.agent;
    }

    private inferArtifactTypeName(mimeType: string): string {
        if (mimeType.includes('spreadsheet') || mimeType.includes('excel') || mimeType.includes('ms-excel')) {
            return 'Excel';
        }
        if (mimeType.startsWith('text/csv') || mimeType === 'text/plain') {
            return 'Text';
        }
        return 'Excel';
    }

    /**
     * Validates the agent's payload as a well-formed ImportPlan and returns it.
     * The agent may return a JSON string or a parsed object; we accept either.
     */
    private coerceToPlan(payload: unknown): ImportPlan | null {
        const obj = this.normalizePayload(payload);
        if (!obj || typeof obj !== 'object') return null;

        const plan = obj as Partial<ImportPlan>;
        if (!Array.isArray(plan.committees) || !Array.isArray(plan.terms)
            || !Array.isArray(plan.people) || !Array.isArray(plan.memberships)) {
            return null;
        }

        return {
            committees: plan.committees,
            terms: plan.terms,
            people: plan.people,
            memberships: plan.memberships,
        };
    }

    private normalizePayload(payload: unknown): unknown {
        if (typeof payload === 'string') {
            try { return JSON.parse(payload); } catch { return null; }
        }
        return payload;
    }

    // -------------------------------------------------------------------------
    // Lookup map loading
    // -------------------------------------------------------------------------

    private async loadCommitteeTypeMap(contextUser: UserInfo): Promise<Map<string, string>> {
        const rv = new RunView();
        const result = await rv.RunView<mjCommitteesTypeEntity>({
            EntityName: 'Committees: Types',
            ResultType: 'simple',
        }, contextUser);

        const map = new Map<string, string>();
        if (result.Success && result.Results) {
            for (const t of result.Results as unknown as { ID: string; Name: string }[]) {
                map.set(t.Name.toLowerCase(), t.ID);
            }
        }
        return map;
    }

    private async loadRoleMap(contextUser: UserInfo): Promise<Map<string, string>> {
        const rv = new RunView();
        const result = await rv.RunView<mjCommitteesRoleEntity>({
            EntityName: 'Committees: Roles',
            ResultType: 'simple',
        }, contextUser);

        const map = new Map<string, string>();
        if (result.Success && result.Results) {
            for (const r of result.Results as unknown as { ID: string; Name: string }[]) {
                map.set(r.Name.toLowerCase(), r.ID);
            }
        }
        return map;
    }

    // -------------------------------------------------------------------------
    // Per-entity creation helpers
    // -------------------------------------------------------------------------

    private async createCommittees(
        rows: ImportCommitteeRow[],
        typeMap: Map<string, string>,
        committeeIDs: Map<string, string>,
        errors: ImportRowError[],
        counts: { committees: number },
        contextUser: UserInfo
    ): Promise<void> {
        const md = new Metadata();
        for (const row of rows) {
            try {
                if (!row.Name) {
                    errors.push({ Entity: 'Committee', Identifier: '(unnamed)', Message: 'Missing Name' });
                    continue;
                }
                const typeID = typeMap.get(row.CommitteeType?.toLowerCase() ?? '');
                if (!typeID) {
                    errors.push({ Entity: 'Committee', Identifier: row.Name, Message: `Unknown CommitteeType "${row.CommitteeType}"` });
                    continue;
                }

                const entity = await md.GetEntityObject<mjCommitteesCommitteeEntity>('Committees: Committees', contextUser);
                entity.Name = row.Name;
                entity.Description = row.Description ?? null;
                entity.TypeID = typeID;
                entity.Status = 'Active';

                const saved = await entity.Save();
                if (!saved) {
                    errors.push({ Entity: 'Committee', Identifier: row.Name, Message: entity.LatestResult?.Message ?? 'Save failed' });
                    continue;
                }
                committeeIDs.set(row.Name, entity.ID);
                counts.committees++;
            } catch (error) {
                const message = error instanceof Error ? error.message : String(error);
                errors.push({ Entity: 'Committee', Identifier: row.Name ?? '(unknown)', Message: message });
            }
        }
    }

    private async createTerms(
        rows: ImportTermRow[],
        committeeIDs: Map<string, string>,
        termIDs: Map<string, string>,
        errors: ImportRowError[],
        counts: { terms: number },
        contextUser: UserInfo
    ): Promise<void> {
        const md = new Metadata();
        for (const row of rows) {
            try {
                const committeeID = committeeIDs.get(row.CommitteeRef);
                if (!committeeID) {
                    errors.push({ Entity: 'Term', Identifier: `${row.CommitteeRef}/${row.Year ?? '?'}`, Message: `Unknown committee "${row.CommitteeRef}"` });
                    continue;
                }
                const startDate = this.parseDate(row.StartDate);
                if (!startDate) {
                    errors.push({ Entity: 'Term', Identifier: `${row.CommitteeRef}/${row.Year ?? '?'}`, Message: `Invalid StartDate "${row.StartDate}"` });
                    continue;
                }
                const endDate = row.EndDate ? this.parseDate(row.EndDate) : null;

                const entity = await md.GetEntityObject<mjCommitteesTermEntity>('Committees: Terms', contextUser);
                entity.CommitteeID = committeeID;
                entity.Name = row.Year ? String(row.Year) : `${startDate.getFullYear()}`;
                entity.StartDate = startDate;
                entity.EndDate = endDate;
                entity.Status = this.deriveTermStatus(startDate, endDate);

                const saved = await entity.Save();
                if (!saved) {
                    errors.push({ Entity: 'Term', Identifier: `${row.CommitteeRef}/${entity.Name}`, Message: entity.LatestResult?.Message ?? 'Save failed' });
                    continue;
                }
                termIDs.set(row.CommitteeRef, entity.ID);
                counts.terms++;
            } catch (error) {
                const message = error instanceof Error ? error.message : String(error);
                errors.push({ Entity: 'Term', Identifier: `${row.CommitteeRef}/${row.Year ?? '?'}`, Message: message });
            }
        }
    }

    private async createPeople(
        rows: ImportPersonRow[],
        personIDs: Map<string, string>,
        errors: ImportRowError[],
        counts: { people: number },
        contextUser: UserInfo
    ): Promise<void> {
        const md = new Metadata();
        for (const row of rows) {
            try {
                if (!row.Email) {
                    errors.push({ Entity: 'Person', Identifier: `${row.FirstName ?? ''} ${row.LastName ?? ''}`.trim(), Message: 'Missing Email' });
                    continue;
                }
                const emailKey = row.Email.toLowerCase();
                const existingID = await this.findExistingPersonID(row.Email, contextUser);
                if (existingID) {
                    personIDs.set(emailKey, existingID);
                    continue;
                }

                const entity = await md.GetEntityObject<mjBizAppsCommonPersonEntity>('MJ_BizApps_Common: People', contextUser);
                entity.FirstName = row.FirstName ?? '';
                entity.LastName = row.LastName ?? '';
                entity.Email = row.Email;

                const saved = await entity.Save();
                if (!saved) {
                    errors.push({ Entity: 'Person', Identifier: row.Email, Message: entity.LatestResult?.Message ?? 'Save failed' });
                    continue;
                }
                personIDs.set(emailKey, entity.ID);
                counts.people++;
            } catch (error) {
                const message = error instanceof Error ? error.message : String(error);
                errors.push({ Entity: 'Person', Identifier: row.Email ?? '(unknown)', Message: message });
            }
        }
    }

    private async createMemberships(
        rows: ImportMembershipRow[],
        termIDs: Map<string, string>,
        personIDs: Map<string, string>,
        roleMap: Map<string, string>,
        errors: ImportRowError[],
        counts: { memberships: number },
        contextUser: UserInfo
    ): Promise<void> {
        const md = new Metadata();
        for (const row of rows) {
            try {
                const termID = termIDs.get(row.CommitteeRef);
                if (!termID) {
                    errors.push({ Entity: 'Membership', Identifier: `${row.PersonRef} → ${row.CommitteeRef}`, Message: `No term created for committee "${row.CommitteeRef}"` });
                    continue;
                }
                const personID = personIDs.get(row.PersonRef.toLowerCase());
                if (!personID) {
                    errors.push({ Entity: 'Membership', Identifier: `${row.PersonRef} → ${row.CommitteeRef}`, Message: `Person "${row.PersonRef}" was not created` });
                    continue;
                }
                const roleID = roleMap.get(row.Role?.toLowerCase() ?? '');
                if (!roleID) {
                    errors.push({ Entity: 'Membership', Identifier: `${row.PersonRef} → ${row.CommitteeRef}`, Message: `Unknown role "${row.Role}"` });
                    continue;
                }

                const entity = await md.GetEntityObject<mjCommitteesMembershipEntity>('Committees: Memberships', contextUser);
                entity.PersonID = personID;
                entity.RoleID = roleID;
                entity.TermID = termID;
                entity.StartDate = new Date();
                entity.Status = this.normalizeMembershipStatus(row.Status);

                const saved = await entity.Save();
                if (!saved) {
                    errors.push({ Entity: 'Membership', Identifier: `${row.PersonRef} → ${row.CommitteeRef}`, Message: entity.LatestResult?.Message ?? 'Save failed' });
                    continue;
                }
                counts.memberships++;
            } catch (error) {
                const message = error instanceof Error ? error.message : String(error);
                errors.push({ Entity: 'Membership', Identifier: `${row.PersonRef} → ${row.CommitteeRef}`, Message: message });
            }
        }
    }

    // -------------------------------------------------------------------------
    // Validation / coercion helpers
    // -------------------------------------------------------------------------

    private parseDate(value: string | null | undefined): Date | null {
        if (!value) return null;
        const date = new Date(value);
        return Number.isNaN(date.getTime()) ? null : date;
    }

    private deriveTermStatus(start: Date, end: Date | null): 'Active' | 'Completed' | 'Upcoming' {
        const now = Date.now();
        if (end && end.getTime() < now) return 'Completed';
        if (start.getTime() > now) return 'Upcoming';
        return 'Active';
    }

    private normalizeMembershipStatus(value: string | null | undefined): 'Active' | 'Ended' | 'Pending' | 'Suspended' {
        const v = (value ?? 'Active').toLowerCase();
        if (v === 'ended' || v === 'inactive' || v === 'completed') return 'Ended';
        if (v === 'pending') return 'Pending';
        if (v === 'suspended') return 'Suspended';
        return 'Active';
    }

    private async findExistingPersonID(email: string, contextUser: UserInfo): Promise<string | null> {
        const rv = new RunView();
        const result = await rv.RunView({
            EntityName: 'MJ_BizApps_Common: People',
            ExtraFilter: `Email='${email.replace(/'/g, "''")}'`,
            Fields: ['ID'],
            MaxRows: 1,
            ResultType: 'simple',
        }, contextUser);

        if (result.Success && result.Results && result.Results.length > 0) {
            return (result.Results[0] as { ID: string }).ID;
        }
        return null;
    }
}

LogStatus(`[BulkImportService] module loaded`);
