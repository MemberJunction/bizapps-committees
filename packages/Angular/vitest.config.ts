import { createRequire } from 'node:module';
import { defineConfig } from 'vitest/config';

const require = createRequire(import.meta.url);

// Pin Angular framework packages to a single module instance across Vitest.
// In multi-repo pnpm workspaces (such as CI's `mj-next-workspace` where `@memberjunction/ng-shared`
// resolves from sibling `MJ/` with a different peer-dependency hash for `@angular/core`),
// unaliased imports load two separate `@angular/core` instances with distinct `_currentInjector`
// singletons, causing `runInInjectionContext` + `BaseResourceComponent`'s `inject(NavigationService)`
// to throw NG0203.
const SINGLETON_ANGULAR_PACKAGES = [
  '@angular/core',
  '@angular/common',
  '@angular/compiler',
  '@angular/forms',
  '@angular/platform-browser',
  '@angular/router',
] as const;

function buildExactAliases(packages: readonly string[]): Array<{ find: RegExp; replacement: string }> {
  return packages.map((pkg) => ({
    find: new RegExp(`^${pkg.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}$`),
    replacement: require.resolve(pkg),
  }));
}

export default defineConfig({
  resolve: {
    alias: buildExactAliases(SINGLETON_ANGULAR_PACKAGES),
    dedupe: [...SINGLETON_ANGULAR_PACKAGES, 'rxjs'],
  },
  test: {
    environment: 'node',
    include: ['src/**/__tests__/**/*.{test,spec}.ts'],
    server: {
      deps: {
        inline: [/@memberjunction\/ng-/, /\/MJ\/packages\/Angular\//],
      },
    },
  },
});
