/**
 * @mj-biz-apps/committees-integration-tests
 *
 * Importing this module registers bundles on IntegrationCheckRegistry.
 *
 * BUNDLES
 *   committees-world            CW1–CW11  commit COM-WORLD (people, committees, terms, meetings, minutes, artifacts, ballot, personas)
 *   ballot-sealing              BS1–BS8   the Votes row filter, CloseBallot/BallotProgress as the personas, the entity registrations
 *   minute-artifact-dual-read   DR1–DR6   MJ Docs dual-read, ApprovedArtifactVersionID pinning, opt-in bridging, artifact classification
 *   pg-parity-and-boundary      PB1–PB6   adversarial validation boundaries, Category C relational notes, SQL Server <-> PG parity, RLS
 *
 * COM-WORLD COMMITS. Re-run to refresh relative dates. ballot-sealing, minute-artifact-dual-read, and pg-parity-and-boundary clean up any temporary rows they create.
 */
import {
    LoadGeneratedEntities,
    LoadCustomMeetingEntity,
    LoadCustomMinuteEntity,
} from '@mj-biz-apps/committees-entities';
import { LoadCommitteesServer } from '@mj-biz-apps/committees-server';

LoadGeneratedEntities();
LoadCustomMeetingEntity();
LoadCustomMinuteEntity();
LoadCommitteesServer();

import './checks/world.checks.js';
import './checks/ballot-sealing.checks.js';
import './checks/minute-artifact-dual-read.check.js';
import './checks/pg-parity-and-boundary.check.js';

export { CommitteesWorldChecks } from './checks/world.checks.js';
export { BallotSealingChecks } from './checks/ballot-sealing.checks.js';
export { MinuteArtifactDualReadChecks } from './checks/minute-artifact-dual-read.check.js';
export { PgParityAndBoundaryChecks } from './checks/pg-parity-and-boundary.check.js';
export * from './fixture.js';
export * from './world/world.js';
export * from './world/load-world.js';
