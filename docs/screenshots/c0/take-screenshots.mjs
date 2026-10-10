// Browser pass for C0 (ballot sealing): the Motions page and the close ceremony as a signed-in chair whose account holds the
// UI role only, so the Votes row filter applies to the browser while the server closes the ballot.
//
//   node docs/screenshots/c0/take-screenshots.mjs --save-staff-session     (opens a browser: sign in once as the chair)
//   node docs/screenshots/c0/take-screenshots.mjs [--theme light|dark|both] [--only <name>]
//
// Needs an Explorer (EXPLORER_URL, default http://localhost:4218) on an MJAPI whose database holds COM-WORLD, and a Playwright
// module (PLAYWRIGHT_MODULE names it when this repo has none). The chair's session is saved once by hand and reused; the file
// stays out of git. The close shots change the world (they close the Governance ballot): reload it afterwards with
// `node test-harnesses/integration.mjs committees-world`, which reopens the ballot.
import { existsSync, mkdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const { chromium } = await import(process.env.PLAYWRIGHT_MODULE ?? 'playwright');
const here = dirname(fileURLToPath(import.meta.url));
const EXPLORER = (process.env.EXPLORER_URL ?? 'http://localhost:4218').replace(/\/$/, '');
const STAFF_SESSION = join(here, 'staff-session.json');
const MOTIONS = `${EXPLORER}/app/mjcommitteemgmt/Motions`;
const MEMBER_HOME = `${EXPLORER}/app/mjcommittees/My%20Committees`;
const BALLOT_MOTION = 'Adopt revised conflict-of-interest policy';

const args = process.argv.slice(2);
const option = (name, fallback) => { const i = args.indexOf(name); return i >= 0 ? args[i + 1] : fallback; };
const themes = { light: ['light'], dark: ['dark'], both: ['light', 'dark'] }[option('--theme', 'both')];
const only = option('--only', null);

/** Fails the run when `page` doesn't show every text (or pattern) in `present`, or shows any text in `absent`. */
async function assertScreen(page, name, { present = [], absent = [] }) {
    for (const text of present) {
        await page.getByText(text, text instanceof RegExp ? {} : { exact: false }).first().waitFor({ state: 'visible', timeout: 20000 }).catch(() => {
            throw new Error(`${name}: "${text}" is not on the screen`);
        });
    }
    const body = await page.locator('body').innerText();
    for (const text of absent) if (body.includes(text)) throw new Error(`${name}: "${text}" must not be on the screen`);
}

async function openMotions(page) {
    await page.goto(MOTIONS, { waitUntil: 'load' });
    await page.getByText(BALLOT_MOTION).first().waitFor({ state: 'visible', timeout: 60000 });
    await page.waitForTimeout(800);
}

/** `once` shots run in the first theme only: they change the world. */
const SHOTS = [
    {
        name: 'c0-01-member-home-open-ballot',
        what: 'My Committees as the chair: the open Governance ballot asks for his vote',
        run: async (page) => {
            await page.goto(MEMBER_HOME, { waitUntil: 'load' });
            await assertScreen(page, 'member home', { present: [BALLOT_MOTION] });
            await page.waitForTimeout(800);
        },
    },
    {
        name: 'c0-02-ballot-participation',
        what: 'The open ballot hero: participation from BallotProgress (2 of the roster, the signed-in chair included), who voted, choices sealed; the browser holds one vote at most',
        run: async (page) => {
            await openMotions(page);
            await assertScreen(page, 'ballot hero', {
                present: [/Participation — 2 of \d+ voted/, 'Choices sealed until close', 'Marcus Lee', 'Priya Shah', 'Not yet voted', /Needs \d+ Yes/],
                absent: ['voted Yes', 'voted No', 'voted Abstain'],
            });
        },
    },
    {
        name: 'c0-03-close-dialog',
        what: 'Close early: participation and the threshold, no projected outcome (the server counts), the secret-ballot note',
        run: async (page) => {
            await openMotions(page);
            await page.getByRole('button', { name: /Close early|Close ballot/ }).first().click();
            await assertScreen(page, 'close dialog', {
                present: ['Close ballot', /\d+ Yes needed/, 'Close ballot & stamp the result', 'Secret ballot', 'Closing early'],
                absent: ['Yes so far', 'Outcome to be stamped'],
            });
        },
    },
    {
        name: 'c0-04-close-reveal',
        once: true,
        what: 'Confirm: CloseBallot tallies on the server and reveals 2-0-0 of 8 (fails a simple majority); choices stay sealed',
        run: async (page) => {
            await openMotions(page);
            await page.getByRole('button', { name: /Close early|Close ballot/ }).first().click();
            await page.getByRole('button', { name: 'Close ballot & stamp the result' }).click();
            await assertScreen(page, 'reveal', {
                present: ['Motion fails', '2 Yes', '0 No', '0 Abstain', /2 of \d+ voting members/, 'individual choices remain sealed'],
            });
        },
    },
    {
        name: 'c0-05-register-stamped',
        once: true,
        what: 'After the close: the register shows the stamped result and tally; no open ballot remains',
        run: async (page) => {
            await page.goto(MOTIONS, { waitUntil: 'load' });
            await page.getByText(BALLOT_MOTION).first().waitFor({ state: 'visible', timeout: 60000 });
            await assertScreen(page, 'register', { present: ['Failed', '2-0-0'], absent: ['Participation —'] });
            await page.waitForTimeout(800);
        },
    },
];

async function saveStaffSession() {
    const browser = await chromium.launch({ headless: false });
    const context = await browser.newContext({ viewport: { width: 1600, height: 1000 } });
    const page = await context.newPage();
    await page.goto(`${EXPLORER}/`);
    console.log('Sign in in the browser window. The session is saved when an app page is shown.');
    await page.waitForURL(/\/app\//, { timeout: 10 * 60 * 1000 });
    await page.waitForTimeout(3000);
    await context.storageState({ path: STAFF_SESSION });
    console.log(`Saved ${STAFF_SESSION}. Keep it out of git.`);
    await browser.close();
}

async function main() {
    if (args.includes('--save-staff-session')) return saveStaffSession();
    mkdirSync(here, { recursive: true });
    if (!existsSync(STAFF_SESSION)) throw new Error(`No ${STAFF_SESSION}: run --save-staff-session first.`);
    const wanted = SHOTS.filter((s) => !only || s.name === only);
    const browser = await chromium.launch(process.env.CHROMIUM_PATH ? { executablePath: process.env.CHROMIUM_PATH } : { channel: 'chromium' });
    const failures = [];
    try {
        for (const [index, theme] of themes.entries()) {
            for (const shot of wanted) {
                if (shot.once && index > 0) continue;
                const context = await browser.newContext({ viewport: { width: 1600, height: 1000 }, colorScheme: theme, storageState: STAFF_SESSION });
                await context.addInitScript((t) => { try { localStorage.setItem('mj-theme', t); } catch { /* theme falls back */ } }, theme);
                const page = await context.newPage();
                const errors = [];
                page.on('pageerror', (e) => errors.push(String(e)));
                try {
                    await shot.run(page);
                    await page.waitForTimeout(400);
                    await page.screenshot({ path: join(here, `${shot.name}-${theme}.png`) });
                    console.log(`ok   ${shot.name}-${theme}.png${errors.length ? `  page errors: ${errors.length}` : ''}`);
                } catch (error) {
                    await page.screenshot({ path: join(here, `${shot.name}-${theme}-FAILED.png`) }).catch(() => undefined);
                    failures.push(`${shot.name}-${theme}: ${error instanceof Error ? error.message : String(error)}`);
                    console.log(`FAIL ${shot.name}-${theme}: ${error instanceof Error ? error.message.split('\n')[0] : String(error)}`);
                } finally {
                    await context.close();
                }
            }
        }
    } finally {
        await browser.close();
    }
    if (failures.length) {
        console.error(`${failures.length} screenshot(s) failed their assertions:\n${failures.join('\n')}`);
        process.exit(1);
    }
}

await main();
