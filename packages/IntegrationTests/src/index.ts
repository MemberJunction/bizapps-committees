/**
 * @mj-biz-apps/committees-integration-tests
 *
 * Importing this module registers bundles on IntegrationCheckRegistry.
 *
 * BUNDLES
 *   committees-world   CW1–CW6   commit COM-WORLD (people, committees, terms, meetings, ballot, sign-in personas)
 *   ballot-sealing     BS1–BS8   the Votes row filter, CloseBallot/BallotProgress as the personas, the entity registrations
 *
 * COM-WORLD COMMITS. Re-run to refresh relative dates. ballot-sealing creates its own motions and ballots and removes them.
 */
import {
    LoadGeneratedEntities,
    LoadCustomMeetingEntity,
} from '@mj-biz-apps/committees-entities';
import { LoadCommitteesServer } from '@mj-biz-apps/committees-server';

LoadGeneratedEntities();
LoadCustomMeetingEntity();
LoadCommitteesServer();

import './checks/world.checks.js';
import './checks/ballot-sealing.checks.js';

export { CommitteesWorldChecks } from './checks/world.checks.js';
export { BallotSealingChecks } from './checks/ballot-sealing.checks.js';
export * from './fixture.js';
export * from './world/world.js';
export * from './world/load-world.js';
