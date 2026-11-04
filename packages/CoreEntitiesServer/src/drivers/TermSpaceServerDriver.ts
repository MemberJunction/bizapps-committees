/**
 * TermSpaceServerDriver
 * Server driver for the 'committee-term' SpaceType (C4 rebuild on Collaboration).
 */
import { RegisterClass } from '@memberjunction/global';
import { type IMetadataProvider, RunView } from '@memberjunction/core';
import {
    BaseSpaceTypeServerDriver,
    type AgentContextParams,
    type AgentContextResult,
    type ChildSpaceChangeContext,
    type DriverValidationResult,
    type SpaceChangeContext,
} from '@mj-biz-apps/collaboration-core-entities-server';

const GUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

@RegisterClass(BaseSpaceTypeServerDriver, 'TermSpaceServerDriver')
@RegisterClass(BaseSpaceTypeServerDriver, 'committee-term')
export class TermSpaceServerDriver extends BaseSpaceTypeServerDriver {
    /**
     * Validates changes to a Committee Term space:
     * - A Term space must always belong to a parent Committee space (ParentID is required).
     * - A Term space always inherits membership from its parent Committee (Decision A4).
     */
    public override ValidateSpaceChange(ctx: SpaceChangeContext): DriverValidationResult {
        if (ctx.kind === 'Create' || ctx.kind === 'Move' || ctx.kind === 'Update') {
            if (!ctx.space.ParentID) {
                return {
                    ok: false,
                    message: 'A Committee Term space must have a parent Committee space (ParentID is required).',
                    field: 'ParentID',
                };
            }
            if (!ctx.space.InheritsMembership) {
                ctx.space.InheritsMembership = true;
            }
        }
        return { ok: true };
    }

    /**
     * Term spaces are leaf spaces under a Committee and may not contain child spaces.
     */
    public override ValidateChildSpaceChange(ctx: ChildSpaceChangeContext): DriverValidationResult {
        if (
            ctx.kind === 'CreateChild' ||
            ctx.kind === 'MoveChildIn' ||
            ctx.kind === 'ReopenChild'
        ) {
            return {
                ok: false,
                message: 'Committee Term spaces cannot have child spaces.',
            };
        }
        return { ok: true };
    }

    public override async BuildAgentContext(ctx: AgentContextParams): Promise<AgentContextResult> {
        let memberCount = 0;
        if (GUID_RE.test(ctx.space.ID)) {
            const view = RunView.FromMetadataProvider(ctx.provider as IMetadataProvider);
            const memRes = await view.RunView<{ ID: string }>(
                {
                    EntityName: 'Committees: Memberships',
                    ExtraFilter: `TermID = '${ctx.space.ID}' AND Status = 'Active'`,
                    Fields: ['ID'],
                    ResultType: 'simple',
                },
                ctx.actingUser
            );
            if (memRes.Success) {
                memberCount = memRes.Results?.length ?? 0;
            }
        }

        return {
            instructions: [
                `This space is the "${ctx.space.Name}" term space (${memberCount} active membership(s)).`,
            ],
            contextData: {
                termId: ctx.space.ID,
                termName: ctx.space.Name,
                committeeId: ctx.space.ParentID ?? null,
                startedAt: ctx.space.StartedAt?.toISOString() ?? null,
                plannedCloseAt: ctx.space.PlannedCloseAt?.toISOString() ?? null,
                closedAt: ctx.space.ClosedAt?.toISOString() ?? null,
                memberCount,
            },
        };
    }
}
