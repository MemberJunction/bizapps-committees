/**
 * Committees Server Bootstrap
 * Import this package and call LoadCommitteesServer() to register
 * all Committees entity classes, actions, and services with MJ.
 */
import { resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

// Import generated packages to trigger @RegisterClass decorators
import '@mj-biz-apps/committees-entities';
import '@mj-biz-apps/committees-actions';

// Import core services to trigger any class registrations
import '@mj-biz-apps/committees-core';

// Video provider drivers — named exports so the class-registration manifest
// generator can import them; importing also fires their @RegisterClass decorators
export { ZoomVideoProvider } from './drivers/ZoomVideoProvider.js';
export { TeamsVideoProvider } from './drivers/TeamsVideoProvider.js';
export { GoogleMeetVideoProvider } from './drivers/GoogleMeetVideoProvider.js';

// Express middleware — self-registers via @RegisterClass and contributes
// the /api/upload-proxy routes through ConfigureExpressApp
export { UploadProxyMiddleware } from './middleware/UploadProxyMiddleware.js';

// Event handlers
import { InitCommitteeNotificationHandler } from './event-handlers/CommitteeNotificationHandler.js';

const __dirname = fileURLToPath(new URL('.', import.meta.url));

/**
 * Resolver paths for TypeGraphQL schema building.
 * Includes both the CodeGen-generated entity resolvers and the hand-written
 * custom resolvers. Pass these to createMJServer({ resolverPaths }) along
 * with other resolver paths.
 */
export const RESOLVER_PATHS: string[] = [
    resolve(__dirname, 'generated/*.js'),
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
