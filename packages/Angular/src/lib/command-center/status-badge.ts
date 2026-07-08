/**
 * Shared badge descriptor for Command Center child components.
 * Tones map 1:1 to the design-system badge classes (.badge.success etc.).
 */
export type StatusBadgeTone = 'success' | 'warning' | 'error' | 'info' | 'neutral';

export interface StatusBadge {
    Tone: StatusBadgeTone;
    Label: string;
}

/**
 * Formats a date as "Apr 15" for compact badge/cell labels.
 * Renders in UTC: callers pass date-only values (term end dates) that arrive
 * as UTC midnight — local rendering would show the previous day.
 */
export function FormatShortDate(date: Date | null): string {
    if (!date) return '—';
    return new Intl.DateTimeFormat('en-US', { month: 'short', day: 'numeric', timeZone: 'UTC' }).format(date);
}
