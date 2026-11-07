export interface WorldIds {
    OrganizationID: string;
    People: Record<string, string>;
    /** MJ user IDs of the personas who can sign in (persona key → user ID); their People rows carry LinkedUserID. */
    Users: Record<string, string>;
    Roles: Record<string, string>;
    Types: Record<string, string>;
    Committees: Record<string, string>;
    Terms: Record<string, string>;
    Meetings: Record<string, string>;
}

let cached: WorldIds | null = null;

export function SetWorld(world: WorldIds): void {
    cached = world;
}

export function World(): WorldIds {
    if (!cached) {
        throw new Error('COM-WORLD is not loaded. Run the committees-world bundle first.');
    }
    return cached;
}
