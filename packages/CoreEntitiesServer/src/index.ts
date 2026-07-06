/**
 * @mj-biz-apps/committees-core-entities-server
 *
 * Server-only business logic for the Committees OpenApp. Everything here
 * depends on server-only packages (AI engine/agents, credentials → AWS SDK,
 * Express middleware) and therefore MUST NOT be reachable from the browser
 * bundle — that is why it lives here rather than in the browser-safe
 * `@mj-biz-apps/committees-core` package.
 *
 * The Committees server bootstrap (`@mj-biz-apps/committees-server`) side-effect
 * imports this package so the video-provider @RegisterClass decorators and the
 * upload-proxy middleware registration fire at startup.
 */

// AI-backed services (used by the GraphQL resolvers in committees-server)
export { BulkImportService } from './services/BulkImportService.js';
export type {
    ImportProblem,
    ImportCommitteeRow,
    ImportTermRow,
    ImportPersonRow,
    ImportMembershipRow,
    ImportPlan,
    AnalyzeResult,
    ImportRowError,
    ConfirmResult,
} from './services/BulkImportService.js';

export { MinutesService } from './services/MinutesService.js';
export type { MinutesDraftResult, MinutesSaveResult } from './services/MinutesService.js';

// Video-conferencing contract + orchestration service
export { VideoProviderBase } from './drivers/VideoProviderBase.js';
export type {
    MeetingAttendee,
    VideoMeetingInput,
    VideoMeetingResult,
    VideoProviderCredentials,
} from './drivers/VideoProviderBase.js';
export { VideoProviderService } from './services/VideoProviderService.js';
export type { ProvisionVideoMeetingResult } from './services/VideoProviderService.js';

// Video-provider drivers — named exports so the class-registration manifest
// generator can import them; importing also fires their @RegisterClass decorators.
export { ZoomVideoProvider } from './drivers/ZoomVideoProvider.js';
export { TeamsVideoProvider } from './drivers/TeamsVideoProvider.js';
export { GoogleMeetVideoProvider } from './drivers/GoogleMeetVideoProvider.js';

// Express middleware — self-registers via @RegisterClass and contributes
// the /api/upload-proxy routes through ConfigureExpressApp.
export { UploadProxyMiddleware } from './middleware/UploadProxyMiddleware.js';

// Entity event handlers (committee notifications)
export { InitCommitteeNotificationHandler } from './event-handlers/CommitteeNotificationHandler.js';
