/**
 * MemberJunction API Server — thin host for the Committees open app.
 * All initialization logic is in @memberjunction/server-bootstrap; all app
 * code (resolvers, drivers, middleware, event handlers) lives in the
 * published @mj-biz-apps/* packages.
 */
import { createMJServer } from '@memberjunction/server-bootstrap';

// Pre-built MJ class registrations manifest (covers all @memberjunction/* packages)
import '@memberjunction/server-bootstrap/mj-class-registrations';

// Supplemental manifest for app classes (generated at prestart with --exclude-packages @memberjunction)
import './generated/class-registrations-manifest.js';

// BizAppsCommon server bootstrap — registers common entity classes and resolvers
import { LoadBizAppsCommonServer, RESOLVER_PATHS as COMMON_RESOLVER_PATHS } from '@mj-biz-apps/common-server';
LoadBizAppsCommonServer();

// BizAppsTasks server bootstrap — registers tasks entity classes, services, and resolvers
import { LoadBizAppsTasksServer, RESOLVER_PATHS as TASKS_RESOLVER_PATHS } from '@mj-biz-apps/tasks-server';
LoadBizAppsTasksServer();

// Committees server bootstrap — registers entity classes, services, drivers, and middleware
import { LoadCommitteesServer, RESOLVER_PATHS as COMMITTEES_RESOLVER_PATHS } from '@mj-biz-apps/committees-server';
LoadCommitteesServer();

const resolverPaths = [...COMMON_RESOLVER_PATHS, ...TASKS_RESOLVER_PATHS, ...COMMITTEES_RESOLVER_PATHS];

createMJServer({ resolverPaths }).catch(console.error);
