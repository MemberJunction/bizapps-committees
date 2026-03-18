/**
 * Committees Server Bootstrap
 * Import this package and call LoadCommitteesServer() to register
 * all Committees entity classes, actions, and services with MJ.
 */
import { resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

// Re-export the core services for consumers
export { CommitteeService } from '@mj-biz-apps/committees-core';
export { MeetingService } from '@mj-biz-apps/committees-core';
export { MembershipService } from '@mj-biz-apps/committees-core';
export { ActionItemService } from '@mj-biz-apps/committees-core';

// Import generated packages to trigger @RegisterClass decorators
import '@mj-biz-apps/committees-entities';
import '@mj-biz-apps/committees-actions';

// Import core services to trigger any class registrations
import '@mj-biz-apps/committees-core';

// Event handlers
import { InitCommitteeNotificationHandler } from './event-handlers/CommitteeNotificationHandler.js';

const __dirname = fileURLToPath(new URL('.', import.meta.url));

/**
 * Resolver paths for TypeGraphQL schema building.
 * Pass these to createMJServer({ resolverPaths }) along with other resolver paths.
 */
export const RESOLVER_PATHS: string[] = [
    resolve(__dirname, 'resolvers/*.js'),
];

/**
 * Bootstrap function — call this from MJAPI's index.ts to register
 * all Committees classes and services.
 */
export function LoadCommitteesServer(): void {
    // The imports above trigger class registration.
    // This function exists as an explicit call site for clarity
    // and to prevent tree-shaking from removing the imports.

    // Wire up entity event handlers for notifications
    InitCommitteeNotificationHandler();

    console.log('[Committees] Server loaded');
}
