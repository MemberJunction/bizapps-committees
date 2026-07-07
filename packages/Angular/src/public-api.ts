// Import entity package to trigger @RegisterClass decorators for entity
// subclasses (incl. the custom MeetingEntity / MembershipEntity).
import '@mj-biz-apps/committees-entities';

// Generated form components (triggers @RegisterClass for form components).
// Re-exported so consumers can import GeneratedFormsModule from this package.
export * from './lib/generated/generated-forms.module';

export * from './lib/module';
export * from './lib/dashboard/committee-dashboard.component';
export * from './lib/committee-list/committee-list.component';
export * from './lib/committee-list/committee-edit-dialog.component';
export * from './lib/meeting-list/meeting-list.component';
export * from './lib/meeting-list/meeting-edit-dialog.component';
export * from './lib/action-items/action-item-tracker.component';
export * from './lib/action-items/action-item-edit-dialog.component';
export * from './lib/documents/document-browser.component';
export * from './lib/documents/document-edit-dialog.component';
export * from './lib/documents/document-preview-panel.component';
export * from './lib/shared/person-picker.component';
export * from './lib/shared/committee-permission-helper';
export * from './lib/comments/comment-thread.component';
export * from './lib/agenda/agenda-item-edit-dialog.component';
export * from './lib/motions/motion-edit-dialog.component';
export * from './lib/meeting-live/meeting-live-view.component';
export * from './lib/terms/term-edit-dialog.component';
export * from './lib/membership/membership-list.component';
export * from './lib/membership/membership-panel.component';
export * from './lib/membership/membership-edit-dialog.component';
export * from './lib/membership/person-detail-panel.component';
export * from './lib/minutes/generate-minutes-panel.component';
export * from './lib/meeting-detail/meeting-detail-view.component';
export * from './lib/management-committee-list/management-committee-list.component';
export * from './lib/management-membership-list/management-membership-list.component';
export * from './lib/bulk-import/bulk-import-panel.component';
export * from './lib/command-center/command-center.component';
export * from './lib/committee-workspace/committee-workspace.component';
export * from './lib/motions-ballots/motions-ballots.component';
export * from './lib/motions-ballots/e-ballot-dialog.component';
export * from './lib/live-meeting/live-meeting.component';
export * from './lib/minutes-review/minutes-review.component';
export * from './lib/people-terms/people-terms.component';
export * from './lib/people-terms/succession-suggestions.component';
export * from './lib/people-terms/term-renewal-wizard.component';
export * from './lib/motions-ballots/ballot-close-dialog.component';
export * from './lib/member-home/member-home.component';
