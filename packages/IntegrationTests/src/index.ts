/**
 * @mj-biz-apps/committees-integration-tests
 *
 * Importing this module registers bundles on IntegrationCheckRegistry.
 *
 * BUNDLES
 *   committees-world   CW1–CW5   commit COM-WORLD (people, committees, terms, meetings, ballot)
 *
 * COM-WORLD COMMITS. Re-run to refresh relative dates. Other bundles (when added) roll back.
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

export { CommitteesWorldChecks } from './checks/world.checks.js';
export * from './fixture.js';
export * from './world/world.js';
export * from './world/load-world.js';
