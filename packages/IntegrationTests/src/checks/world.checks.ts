/**
 * committees-world — commit COM-WORLD and prove it is a living governance book.
 *
 * COMMITS. Re-run updates dates so the Command Center and Member Home stay current.
 */
import {
    Assert,
    IntegrationCheckRegistry,
    type IntegrationCheckContext,
    type NamedCheck,
} from '@memberjunction/testing-integration/registry';
import {
    E_BALLOT,
    E_COMMITTEE,
    E_MEETING,
    E_MEMBERSHIP,
    E_MINUTE,
    E_MOTION,
    E_TERM,
    FindRows,
    WORLD_MARK,
} from '../fixture.js';
import { LoadWorld } from '../world/load-world.js';

export const CommitteesWorldChecks: NamedCheck[] = [
    {
        Id: 'committees-world.CW1',
        Name: 'CW1 — COM-WORLD is loaded: committees, terms, memberships, this week’s meetings',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = await LoadWorld(ctx);
            Assert(Object.keys(world.Committees).length >= 9, 'expected standing + board + abstracts + dissolved pandemic');
            Assert(!!world.People.alex && !!world.People.priya && !!world.People.elena && !!world.People.ruth, 'personas missing');

            const committees = await FindRows<{ Name: string; Description: string; Status: string }>(
                ctx,
                E_COMMITTEE,
                `Description LIKE '${WORLD_MARK}:%'`,
                ['Name', 'Description', 'Status'],
            );
            Assert(committees.length >= 9, `COM-WORLD committees: ${committees.length}`);
            Assert(committees.some((c) => c.Name === 'Board of Directors'), 'Board of Directors missing');
            Assert(committees.some((c) => c.Name === 'Abstract Review Committee' && c.Status === 'Active'), 'Abstract Review missing');
            Assert(committees.some((c) => c.Name === 'Pandemic Response Task Force' && c.Status === 'Dissolved'), 'dissolved pandemic task force missing');
        },
    },
    {
        Id: 'committees-world.CW2',
        Name: 'CW2 — every COM-WORLD term has a chair and voting members',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = await LoadWorld(ctx);
            for (const [key, termID] of Object.entries(world.Terms)) {
                const term = await FindRows<{ Status: string }>(ctx, E_TERM, `ID = '${termID}'`, ['ID', 'Status']);
                if (term[0]?.Status !== 'Active') continue;
                const seats = await FindRows<{ ID: string; Role: string; Status: string }>(
                    ctx,
                    E_MEMBERSHIP,
                    `TermID = '${termID}' AND Status = 'Active'`,
                    ['ID', 'Role', 'Status'],
                );
                Assert(seats.length >= 3, `${key} term has ${seats.length} active seats; need a working quorum`);
                Assert(
                    seats.some((s) => (s.Role ?? '').toLowerCase().includes('chair')),
                    `${key} has no Chair`,
                );
            }
        },
    },
    {
        Id: 'committees-world.CW3',
        Name: 'CW3 — this week has Finance, Audit, and Membership meetings',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = await LoadWorld(ctx);
            const meetings = await FindRows<{ Name: string; Status: string; StartDateTime: Date }>(
                ctx,
                E_MEETING,
                `ID IN ('${world.Meetings.financeThu}', '${world.Meetings.auditThu}', '${world.Meetings.membershipWed}')`,
                ['Name', 'Status', 'StartDateTime'],
            );
            Assert(meetings.length === 3, `this-week meetings: ${meetings.length}`);
            Assert(
                meetings.every((m) => m.Status === 'Scheduled'),
                'this-week meetings should still be Scheduled',
            );
        },
    },
    {
        Id: 'committees-world.CW4',
        Name: 'CW4 — Finance Q1 minutes are still Draft (the unsigned-minutes signal)',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = await LoadWorld(ctx);
            const rows = await FindRows<{ ApprovalStatus: string }>(
                ctx,
                E_MINUTE,
                `MeetingID = '${world.Meetings.financePast}'`,
                ['ApprovalStatus'],
            );
            Assert(rows.length === 1, 'Finance past meeting should have exactly one minutes record');
            Assert(rows[0].ApprovalStatus === 'Draft', `minutes status ${rows[0].ApprovalStatus}, expected Draft`);
        },
    },
    {
        Id: 'committees-world.CW5',
        Name: 'CW5 — Governance has an Open ballot (the vote Member Home should surface)',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = await LoadWorld(ctx);
            const rows = await FindRows<{ Status: string; CommitteeID: string }>(
                ctx,
                E_BALLOT,
                `CommitteeID = '${world.Committees.governance}' AND Status = 'Open'`,
                ['Status', 'CommitteeID'],
            );
            Assert(rows.length >= 1, 'Governance should have an open ballot');
        },
    },
    {
        Id: 'committees-world.CW6',
        Name: 'CW6 — Elena Voss sits on several committees',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = await LoadWorld(ctx);
            Assert(!!world.People.elena, 'Elena missing');
            const seats = await FindRows<{ TermID: string }>(
                ctx,
                E_MEMBERSHIP,
                `PersonID = '${world.People.elena}' AND Status = 'Active'`,
                ['ID', 'TermID'],
            );
            const termIDs = [...new Set(seats.map((s) => s.TermID))];
            Assert(termIDs.length >= 1, 'Elena has no active seats');
            const terms = await FindRows<{ CommitteeID: string }>(
                ctx,
                E_TERM,
                `ID IN (${termIDs.map((id) => `'${id}'`).join(',')})`,
                ['ID', 'CommitteeID'],
            );
            const committeeIDs = new Set(terms.map((t) => t.CommitteeID));
            Assert(
                committeeIDs.size >= 4,
                `Elena is on ${committeeIDs.size} committees; expected ≥4 (board + standing)`,
            );
        },
    },
    {
        Id: 'committees-world.CW7',
        Name: 'CW7 — Board of Directors: five 2-year windows, 11 directors, some overlap',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = await LoadWorld(ctx);
            const keys = Object.keys(world.Terms).filter((k) => k.startsWith('board')).sort();
            Assert(keys.length >= 5, `board terms: ${keys.length}`);
            const rosters: string[][] = [];
            for (const key of keys) {
                const seats = await FindRows<{ PersonID: string; Role: string }>(
                    ctx,
                    E_MEMBERSHIP,
                    `TermID = '${world.Terms[key]}'`,
                    ['ID', 'PersonID', 'Role'],
                );
                Assert(seats.length === 11, `${key} has ${seats.length} directors; expected 11`);
                Assert(
                    seats.some((s) => (s.Role ?? '').toLowerCase().includes('chair')),
                    `${key} has no Chair`,
                );
                rosters.push(seats.map((s) => s.PersonID));
            }
            for (let i = 1; i < rosters.length; i++) {
                const prev = new Set(rosters[i - 1]);
                const overlap = rosters[i].filter((id) => prev.has(id)).length;
                Assert(overlap > 0, `${keys[i]} shares nobody with ${keys[i - 1]}`);
                Assert(overlap < 11, `${keys[i]} is identical to ${keys[i - 1]}`);
            }
        },
    },
    {
        Id: 'committees-world.CW8',
        Name: 'CW8 — pandemic task force had two terms then dissolved',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = await LoadWorld(ctx);
            const committee = await FindRows<{ Status: string; Name: string }>(
                ctx, E_COMMITTEE, `ID = '${world.Committees.pandemic}'`, ['ID', 'Status', 'Name'],
            );
            Assert(committee[0]?.Status === 'Dissolved', `pandemic status ${committee[0]?.Status}`);
            for (const key of ['pandemic2020', 'pandemic2021'] as const) {
                const seats = await FindRows<{ Status: string }>(
                    ctx, E_MEMBERSHIP, `TermID = '${world.Terms[key]}'`, ['ID', 'Status'],
                );
                Assert(seats.length >= 5, `${key} too small`);
                Assert(seats.every((s) => s.Status === 'Ended'), `${key} seats should be Ended`);
            }
        },
    },
    {
        Id: 'committees-world.CW9',
        Name: 'CW9 — Abstract Review has a prior term and a live term with new reviewers',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = await LoadWorld(ctx);
            Assert(!!world.Committees.abstracts && !!world.People.ruth && !!world.People.mina, 'abstracts world missing');
            const live = await FindRows<{ PersonID: string; Status: string }>(
                ctx, E_MEMBERSHIP, `TermID = '${world.Terms.abstracts}' AND Status = 'Active'`, ['ID', 'PersonID', 'Status'],
            );
            const prior = await FindRows<{ PersonID: string }>(
                ctx, E_MEMBERSHIP, `TermID = '${world.Terms.abstractsPrev}'`, ['ID', 'PersonID'],
            );
            Assert(live.length >= 6, `live abstract reviewers: ${live.length}`);
            Assert(prior.length >= 4, `prior abstract reviewers: ${prior.length}`);
            const liveSet = new Set(live.map((s) => s.PersonID));
            const overlap = prior.filter((s) => liveSet.has(s.PersonID)).length;
            Assert(overlap > 0 && overlap < live.length, 'abstract review should rotate some reviewers');
        },
    },
    {
        Id: 'committees-world.CW10',
        Name: 'CW10 — meetings vary: postponed, cancelled, in-person, in-progress',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            const world = await LoadWorld(ctx);
            const rows = await FindRows<{ Status: string; LocationType: string }>(
                ctx, E_MEETING,
                `ID IN ('${world.Meetings.programPostponed}', '${world.Meetings.pubsCancelled}', '${world.Meetings.boardPast}', '${world.Meetings.financeLive}')`,
                ['ID', 'Status', 'LocationType'],
            );
            Assert(rows.some((r) => r.Status === 'Postponed'), 'postponed meeting missing');
            Assert(rows.some((r) => r.Status === 'Cancelled'), 'cancelled meeting missing');
            Assert(rows.some((r) => r.Status === 'InProgress'), 'in-progress meeting missing');
            Assert(rows.some((r) => r.LocationType === 'InPerson'), 'in-person meeting missing');
        },
    },
    {
        Id: 'committees-world.CW11',
        Name: 'CW11 — voting varies: open, passed split, unanimous, failed two-thirds, tabled, withdrawn',
        RequiresMutation: true,
        Fn: async (ctx: IntegrationCheckContext) => {
            await LoadWorld(ctx);
            const motions = await FindRows<{ Name: string; Result: string }>(
                ctx, E_MOTION,
                `Name IN ('Adopt revised conflict-of-interest policy','Approve FY27 budget amendment','Adopt double-blind scoring rubric','Engage a second external auditor this cycle','Retire the print newsletter','Move the 2027 conference to a hybrid venue')`,
                ['ID', 'Name', 'Result'],
            );
            const byName = Object.fromEntries(motions.map((m) => [m.Name, m.Result]));
            Assert(byName['Adopt revised conflict-of-interest policy'] === 'Pending', 'governance ballot still pending');
            Assert(byName['Approve FY27 budget amendment'] === 'Passed', 'finance amendment should have passed');
            Assert(byName['Adopt double-blind scoring rubric'] === 'Passed', 'abstract rubric should have passed');
            Assert(byName['Engage a second external auditor this cycle'] === 'Failed', 'audit second-auditor should have failed');
            Assert(byName['Retire the print newsletter'] === 'Withdrawn', 'publications motion withdrawn');
            Assert(byName['Move the 2027 conference to a hybrid venue'] === 'Tabled', 'program motion tabled');
        },
    },
];

for (const check of CommitteesWorldChecks) {
    IntegrationCheckRegistry.Instance.Register(check);
}

IntegrationCheckRegistry.Instance.RegisterLifecycle('committees-world', {
    Setup: async () => undefined,
    Teardown: async () => undefined,
});
