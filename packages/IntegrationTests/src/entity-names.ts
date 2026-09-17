export const E_COMMITTEE = 'Committees: Committees';
export const E_TYPE = 'Committees: Types';
export const E_ROLE = 'Committees: Roles';
export const E_TERM = 'Committees: Terms';
export const E_MEMBERSHIP = 'Committees: Memberships';
export const E_MEETING = 'Committees: Meetings';
export const E_AGENDA = 'Committees: Agenda Items';
export const E_ATTENDANCE = 'Committees: Attendances';
export const E_MOTION = 'Committees: Motions';
export const E_BALLOT = 'Committees: Ballots';
export const E_VOTE = 'Committees: Votes';
export const E_MINUTE = 'Committees: Minutes';
export const E_PERSON = 'MJ_BizApps_Common: People';
export const E_ORGANIZATION = 'MJ_BizApps_Common: Organizations';

export const WORLD_MARK = 'COM-WORLD';

/**
 * Deterministic CC0 avatars (DiceBear lorelei, Lisa Wischofsky / CC0 1.0).
 * Official HTTP API is MIT. These are generated illustrations, not scraped photographs.
 */
export function WorldAvatarURL(email: string): string {
    return `https://api.dicebear.com/9.x/lorelei/png?seed=${encodeURIComponent(email)}&size=256`;
}
