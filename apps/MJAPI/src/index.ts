/**
 * MemberJunction API Server (MJ 3.0 Minimal Architecture)
 * All initialization logic is in @memberjunction/server-bootstrap
 */
import { createMJServer } from '@memberjunction/server-bootstrap';
import { fileURLToPath } from 'node:url';
import { resolve } from 'node:path';

// Import generated packages to trigger class registration
import '@mj-biz-apps/common-entities';
import '@mj-biz-apps/committees-entities';
import '@mj-biz-apps/committees-actions';

// BizAppsCommon server bootstrap — registers common entity classes and resolvers
import { LoadBizAppsCommonServer, RESOLVER_PATHS as commonResolverPaths } from '@mj-biz-apps/common-server';
LoadBizAppsCommonServer();

// Committees server bootstrap — registers entity classes and services
import { LoadCommitteesServer, RESOLVER_PATHS as committeesResolverPaths } from '@mj-biz-apps/committees-server';
LoadCommitteesServer();

// Import pre-built MJ class registrations manifest (covers all @memberjunction/* packages)
import '@memberjunction/server-bootstrap/mj-class-registrations';


// Import supplemental manifest for user-defined classes (generated at prestart with --exclude-packages @memberjunction)
import './generated/class-registrations-manifest.js';

// Import middleware (registers via @RegisterClass for server-bootstrap discovery)
import './middleware/UploadProxyMiddleware.js';

// Optional: Import communication providers if needed
// import '@memberjunction/communication-sendgrid';
// import '@memberjunction/communication-teams';

// Optional: Import custom auth/user creation logic
// See: /docs/examples/custom-user-creation/README.md
// import './custom/customUserCreation';

// Resolve resolver paths relative to this file
const __dirname = fileURLToPath(new URL('.', import.meta.url));
const resolverPaths = [resolve(__dirname, 'generated/generated.{js,ts}'), ...commonResolverPaths, ...committeesResolverPaths];

// Start the server. UploadProxyMiddleware registers itself via @RegisterClass
// and contributes the /api/upload-proxy routes through ConfigureExpressApp.
createMJServer({ resolverPaths }).catch(console.error);