/**
 * Committees Server Bootstrap
 * Import this package and call LoadCommitteesServer() to register
 * all Committees entity classes, actions, and services with MJ.
 */
import { resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

// Re-export the core services for consumers
export { CommitteeService } from '@committees/core';
export { MeetingService } from '@committees/core';
export { MembershipService } from '@committees/core';
export { ActionItemService } from '@committees/core';

// Import generated packages to trigger @RegisterClass decorators
import 'mj_generatedentities';
import 'mj_generatedactions';

// Import core services to trigger any class registrations
import '@committees/core';

const __dirname = fileURLToPath(new URL('.', import.meta.url));

/**
 * Resolver paths for TypeGraphQL schema building.
 * Pass these to createMJServer({ resolverPaths }) along with other resolver paths.
 */
export const RESOLVER_PATHS: string[] = [
    // Custom resolvers will go here as they're added
    // resolve(__dirname, 'resolvers/*.{js,ts}'),
];

/**
 * Bootstrap function — call this from MJAPI's index.ts to register
 * all Committees classes and services.
 */
export function LoadCommitteesServer(): void {
    // The imports above trigger class registration.
    // This function exists as an explicit call site for clarity
    // and to prevent tree-shaking from removing the imports.
    console.log('[Committees] Server loaded');
}
