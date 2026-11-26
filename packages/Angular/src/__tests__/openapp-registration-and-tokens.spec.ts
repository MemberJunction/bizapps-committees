import '@angular/compiler';
import { readdirSync, readFileSync, statSync } from 'node:fs';
import { extname, join, relative, resolve } from 'node:path';
import { describe, expect, it, vi } from 'vitest';
import { MJGlobal } from '@memberjunction/global';
import { BaseFormComponent, BaseFormPanel } from '@memberjunction/ng-base-forms';
import { BaseResourceComponent } from '@memberjunction/ng-shared';

// External peer OpenApp packages ship extensionless ESM dist imports incompatible with Node strict ESM resolution;
// stub them so Committees' real generated forms, custom panels, and resource components execute live in Vitest.
vi.mock('@mj-biz-apps/common-ng', () => ({
    AddressEditorComponent: class AddressEditorComponentStub {},
    ContactMethodListComponent: class ContactMethodListComponentStub {},
    RelationshipListComponent: class RelationshipListComponentStub {},
}));
vi.mock('@mj-biz-apps/tasks-ng', () => ({
    BizAppsTasksModule: class BizAppsTasksModuleStub {},
    LoadBizAppsTasksClient: (): void => {},
}));

// Import real generated form subclasses, custom panels, and module to trigger live @RegisterClass / @RegisterClassEx
import '../lib/generated/generated-forms.module';
import '../lib/custom/form-panels/minute-document.panel';
import '../lib/custom/form-panels/artifact-document.panel';
import { LoadCommitteesClient, LoadCommitteesModule } from '../lib/module';

const ANGULAR_ROOT = resolve(__dirname, '../..');
const REPO_ROOT = resolve(ANGULAR_ROOT, '../..');

const ALL_COMMITTEES_ENTITIES = [
    'Committees: Agenda Items',
    'Committees: Artifact Types',
    'Committees: Artifacts',
    'Committees: Attendances',
    'Committees: Ballots',
    'Committees: Comments',
    'Committees: Committees',
    'Committees: Meetings',
    'Committees: Memberships',
    'Committees: Minutes',
    'Committees: Motions',
    'Committees: Roles',
    'Committees: Terms',
    'Committees: Types',
    'Committees: Video Providers',
    'Committees: Votes',
] as const;

const SLICE2_TOKEN_ENFORCED_FILES = [
    'src/lib/minutes/minute-document-viewer.component.css',
    'src/lib/minutes/minute-document-viewer.component.html',
    'src/lib/documents/committee-artifact-preview.component.css',
    'src/lib/documents/committee-artifact-preview.component.html',
    'src/lib/minutes-review/minutes-review.component.css',
    'src/lib/minutes-review/minutes-review.component.html',
    'src/lib/meeting-detail/meeting-detail-view.component.css',
    'src/lib/meeting-detail/meeting-detail-view.component.html',
    'src/lib/committee-workspace/committee-workspace.component.css',
    'src/lib/committee-workspace/committee-workspace.component.html',
    'src/lib/dashboard/committee-dashboard.component.css',
    'src/lib/dashboard/committee-dashboard.component.html',
    'src/lib/member-home/member-home.component.css',
    'src/lib/member-home/member-home.component.html',
    'src/lib/custom/form-panels/minute-document.panel.ts',
    'src/lib/custom/form-panels/artifact-document.panel.ts',
] as const;

const SLICE2_TS_FILES = [
    'src/lib/minutes/minute-dual-read.model.ts',
    'src/lib/minutes/minute-document-viewer.component.ts',
    'src/lib/documents/committee-artifact-preview.component.ts',
    'src/lib/minutes-review/minutes-review.component.ts',
    'src/lib/meeting-detail/meeting-detail-view.component.ts',
    'src/lib/committee-workspace/committee-workspace.component.ts',
    'src/lib/dashboard/committee-dashboard.component.ts',
    'src/lib/member-home/member-home.component.ts',
    'src/lib/custom/form-panels/minute-document.panel.ts',
    'src/lib/custom/form-panels/artifact-document.panel.ts',
] as const;

function walkFiles(dir: string, allowedExts: Set<string>): string[] {
    const out: string[] = [];
    for (const entry of readdirSync(dir)) {
        if (entry === 'node_modules' || entry === 'dist' || entry === '__tests__') {
            continue;
        }
        const full = join(dir, entry);
        const st = statSync(full);
        if (st.isDirectory()) {
            out.push(...walkFiles(full, allowedExts));
        } else if (allowedExts.has(extname(full))) {
            out.push(full);
        }
    }
    return out;
}

describe('OpenApp v3 Dual Form Registration & Resource Parity', () => {
    it('registers every Committees entity in ClassFactory under BaseFormComponent and retains via startupExport', () => {
        LoadCommitteesClient();
        expect(LoadCommitteesClient).toBe(LoadCommitteesModule);

        // Verify mj-app.json points startupExport at LoadCommitteesClient
        const manifest = JSON.parse(readFileSync(join(REPO_ROOT, 'mj-app.json'), 'utf8')) as {
            packages: { client: Array<{ name: string; startupExport: string }> };
        };
        const clientPkg = manifest.packages.client.find((p) => p.name === '@mj-biz-apps/committees-ng');
        expect(clientPkg?.startupExport).toBe('LoadCommitteesClient');

        // Verify every entity listed in metadata/entities/.entities.json is registered
        const metadataEntitiesRaw = JSON.parse(
            readFileSync(join(REPO_ROOT, 'metadata/entities/.entities.json'), 'utf8')
        ) as Array<{ primaryKey: { ID: string } }>;
        const metadataEntityNames = metadataEntitiesRaw
            .map((entry) => {
                const match = /Name=(.+)$/.exec(entry.primaryKey.ID);
                return match ? match[1] : null;
            })
            .filter((name): name is string => Boolean(name));

        expect(metadataEntityNames.length).toBeGreaterThan(0);

        const allEntityNames = new Set<string>([...ALL_COMMITTEES_ENTITIES, ...metadataEntityNames]);
        for (const entityName of allEntityNames) {
            const registration = MJGlobal.Instance.ClassFactory.GetRegistration(BaseFormComponent, entityName);
            expect(registration, `Missing BaseFormComponent registration for '${entityName}'`).toBeDefined();
        }
    });

    it('registers Minute and Artifact MJ Docs BaseFormPanel slots without replacing BaseFormComponent', () => {
        const minuteFormReg = MJGlobal.Instance.ClassFactory.GetRegistration(BaseFormComponent, 'Committees: Minutes');
        const artifactFormReg = MJGlobal.Instance.ClassFactory.GetRegistration(BaseFormComponent, 'Committees: Artifacts');
        expect(minuteFormReg).toBeDefined();
        expect(artifactFormReg).toBeDefined();

        const minutePanelReg = MJGlobal.Instance.ClassFactory.GetRegistration(BaseFormPanel, 'form-panel:Minutes:mj-doc');
        const artifactPanelReg = MJGlobal.Instance.ClassFactory.GetRegistration(BaseFormPanel, 'form-panel:Artifacts:mj-doc');
        expect(minutePanelReg).toBeDefined();
        expect(artifactPanelReg).toBeDefined();
    });

    it('wires every BaseResourceComponent in DefaultNavItems or a parent template (zero architecture drift)', () => {
        const baselineSql = readFileSync(
            join(REPO_ROOT, 'migrations/B202611251200__v6.3__Committees_Baseline_Metadata_Sync.sql'),
            'utf8'
        );
        const navDriverMatches = [...baselineSql.matchAll(/"DriverClass":"([^"]+)"/g)].map((m) => m[1]);
        const wiredDrivers = new Set(
            navDriverMatches.map((name) => (name === 'ActionItemTrackerComponent' ? 'TaskTrackerComponent' : name))
        );

        // Verify all DefaultNavItems drivers are registered in ClassFactory
        for (const driver of wiredDrivers) {
            const reg = MJGlobal.Instance.ClassFactory.GetRegistration(BaseResourceComponent, driver);
            expect(reg, `DefaultNavItems DriverClass '${driver}' is not registered`).toBeDefined();
        }

        // Gather all HTML templates in packages/Angular/src/lib to check mounted selectors
        const htmlContents = walkFiles(join(ANGULAR_ROOT, 'src/lib'), new Set(['.html']))
            .map((file) => readFileSync(file, 'utf8'))
            .join('\n');

        // Every BaseResourceComponent in src/lib must be either in DefaultNavItems OR mounted in a parent template
        const tsFiles = walkFiles(join(ANGULAR_ROOT, 'src/lib'), new Set(['.ts']));
        for (const file of tsFiles) {
            const src = readFileSync(file, 'utf8');
            const regMatch = /@RegisterClass\(\s*BaseResourceComponent\s*,\s*['"]([^'"]+)['"]\s*\)/.exec(src);
            if (!regMatch) {
                continue;
            }
            const driverClass = regMatch[1];
            const selectorMatch = /selector:\s*['"]([^'"]+)['"]/.exec(src);
            const selector = selectorMatch?.[1] ?? '';
            const isInDefaultNav = wiredDrivers.has(driverClass);
            const isMountedInTemplate = selector.length > 0 && new RegExp(`<${selector}[\\s>]`).test(htmlContents);
            expect(
                isInDefaultNav || isMountedInTemplate,
                `${relative(ANGULAR_ROOT, file)} (${driverClass} / <${selector}>) is neither in DefaultNavItems nor mounted in a parent template`
            ).toBe(true);
        }
    });

    it('wraps updated top-level views in <mj-page-layout>, defers NotifyLoadStarted, and calls NotifyLoadComplete', () => {
        const checkedViews = [
            {
                ts: 'src/lib/member-home/member-home.component.ts',
                html: 'src/lib/member-home/member-home.component.html',
            },
            {
                ts: 'src/lib/dashboard/committee-dashboard.component.ts',
                html: 'src/lib/dashboard/committee-dashboard.component.html',
            },
            {
                ts: 'src/lib/committee-workspace/committee-workspace.component.ts',
                html: 'src/lib/committee-workspace/committee-workspace.component.html',
            },
        ];

        for (const view of checkedViews) {
            const ts = readFileSync(join(ANGULAR_ROOT, view.ts), 'utf8');
            const html = readFileSync(join(ANGULAR_ROOT, view.html), 'utf8');
            expect(html, `${view.html} must wrap in <mj-page-layout>`).toContain('<mj-page-layout>');
            expect(html, `${view.html} must close </mj-page-layout>`).toContain('</mj-page-layout>');
            expect(ts, `${view.ts} must use OnPush`).toContain('ChangeDetectionStrategy.OnPush');
            expect(ts, `${view.ts} must call NotifyLoadComplete()`).toContain('this.NotifyLoadComplete()');
            expect(ts, `${view.ts} must defer NotifyLoadStarted via queueMicrotask`).toContain(
                'queueMicrotask(() => this.NotifyLoadStarted())'
            );
        }
    });
});

describe('Design Token, Print Hygiene & Strict TypeScript Enforcement', () => {
    it('enforces zero raw #hex, rgb(), rgba(), hsl(), or hsla() color literals in Slice 2 Angular styles & templates', () => {
        const rawColorPattern = /#[0-9a-fA-F]{3,8}\b|\b(?:rgb|rgba|hsl|hsla)\s*\(/g;

        for (const relPath of SLICE2_TOKEN_ENFORCED_FILES) {
            const content = readFileSync(join(ANGULAR_ROOT, relPath), 'utf8');
            const matches = content.match(rawColorPattern) ?? [];
            expect(
                matches,
                `Found raw color literal(s) in ${relPath}: ${matches.join(', ')}`
            ).toEqual([]);
        }
    });

    it('enforces zero window.print() calls across packages/Angular/src', () => {
        const allFiles = walkFiles(join(ANGULAR_ROOT, 'src'), new Set(['.ts', '.html']));
        for (const file of allFiles) {
            const content = readFileSync(file, 'utf8');
            expect(content, `Forbidden window.print() in ${relative(ANGULAR_ROOT, file)}`).not.toMatch(/\bwindow\.print\s*\(/);
        }
    });

    it('enforces zero localStorage/sessionStorage and zero any/unknown casts in Slice 2 Angular TypeScript files', () => {
        for (const relPath of SLICE2_TS_FILES) {
            const content = readFileSync(join(ANGULAR_ROOT, relPath), 'utf8');
            expect(content, `Forbidden localStorage in ${relPath}`).not.toMatch(/\blocalStorage\b/);
            expect(content, `Forbidden sessionStorage in ${relPath}`).not.toMatch(/\bsessionStorage\b/);
            expect(content, `Forbidden explicit any in ${relPath}`).not.toMatch(/:\s*any\b|\bas\s+any\b|<any>/);
            expect(content, `Forbidden unknown cast in ${relPath}`).not.toMatch(/\bas\s+unknown\s+as\b/);
        }
    });
});
