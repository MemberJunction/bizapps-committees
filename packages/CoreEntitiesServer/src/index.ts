/**
 * @mj-biz-apps/committees-core-entities-server
 *
 * Server-only business logic for the Committees OpenApp (C4 rebuild on Collaboration).
 */

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
export { SuccessionSuggestionService } from './services/SuccessionSuggestionService.js';
export { BallotReminderService } from './services/BallotReminderService.js';
export { BallotCloseService } from './services/BallotCloseService.js';
export type { BallotCloseMode, BallotCloseOutcome, BallotCloseResult, BallotProgressResult, BallotVoterProgress } from './services/BallotCloseService.js';
export type { RemindResult } from './services/BallotReminderService.js';
export type { SuccessorSuggestion, SuggestSuccessorsResult } from './services/SuccessionSuggestionService.js';
export type { MinutesDraftResult, MinutesSaveResult } from './services/MinutesService.js';

// Collaboration SpaceType Server Drivers (C4)
export { CommitteeSpaceServerDriver, COMMITTEE_MEMBERSHIP_SYNC_SOURCE } from './drivers/CommitteeSpaceServerDriver.js';
export { TermSpaceServerDriver } from './drivers/TermSpaceServerDriver.js';

// Express middleware — self-registers via @RegisterClass and contributes
// the /api/upload-proxy routes through ConfigureExpressApp.
export { UploadProxyMiddleware } from './middleware/UploadProxyMiddleware.js';

// Entity event handlers (committee notifications + membership seat sync)
export { InitCommitteeNotificationHandler } from './event-handlers/CommitteeNotificationHandler.js';
