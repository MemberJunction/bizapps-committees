//***********************************************************
// Angular
//***********************************************************
import { NgModule, APP_INITIALIZER } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { FormsModule } from '@angular/forms';
import { ReactiveFormsModule } from '@angular/forms';
import { provideHttpClient, withInterceptorsFromDi } from '@angular/common/http';

//***********************************************************
// MJ - Consolidated Module Bundles
//***********************************************************
import {
  MJExplorerModulesBundle,
  SharedService
} from '@memberjunction/ng-explorer-modules';
import { AuthServicesModule, RedirectComponent, MJAuthBase } from '@memberjunction/ng-auth-services';
import { MJExplorerAppModule } from '@memberjunction/ng-explorer-app';

//***********************************************************
// BizAppsCommon Client Bootstrap
//***********************************************************
import { LoadBizAppsCommonClient } from '@mj-biz-apps/common-ng';
LoadBizAppsCommonClient();

//***********************************************************
// Committees Client Bootstrap (chains the BizAppsTasks client bootstrap;
// tasks entity subclasses now register via the npm packages + manifest)
//***********************************************************
import { CommitteesModule, GeneratedFormsModule, LoadCommitteesClient } from '@mj-biz-apps/committees-ng';
LoadCommitteesClient();

// Import pre-built MJ class registrations manifest (covers all @memberjunction/* packages)
import {CLASS_REGISTRATIONS} from '@memberjunction/ng-bootstrap';

// Import supplemental manifest for user-defined classes (generated at prestart with --exclude-packages @memberjunction)
import {CLASS_REGISTRATIONS as LOCAL_CLASSES} from './generated/class-registrations-manifest';

// static code path builder
const combinedClasses = [...CLASS_REGISTRATIONS, ...LOCAL_CLASSES];

//***********************************************************
// Force the ai-core-plus "*EntityExtended" subclasses to win the ClassFactory
// lookup. @memberjunction/core-entities is evaluated multiple times in the
// bundled module graph, which re-registers the BASE entity classes and
// auto-increments their priority above the Extended subclasses — so the engine
// would otherwise resolve the base class (no Prompts/etc.). Explicitly
// re-register each Extended class at a high, fixed priority so it always wins.
//***********************************************************
import { MJGlobal } from '@memberjunction/global';
import { BaseEntity } from '@memberjunction/core';
import {
  MJAIAgentEntityExtended,
  MJAIAgentRunEntityExtended,
  MJAIAgentRunStepEntityExtended,
  MJAIModelEntityExtended,
  MJAIPromptCategoryEntityExtended,
  MJAIPromptEntityExtended,
  MJAIPromptRunEntityExtended,
} from '@memberjunction/ai-core-plus';
(() => {
  const cf = MJGlobal.Instance.ClassFactory;
  // All 7 ai-core-plus Extended entities. Each adds collection properties
  // (e.g. Prompts, Actions, Notes, ModelVendors) that BaseAIEngine .push()es
  // into — if the base class wins the ClassFactory lookup, those arrays are
  // undefined and the engine throws "Cannot read properties of undefined (reading 'push')".
  const EXTENDED: Array<[Function, string]> = [
    [MJAIAgentEntityExtended, 'MJ: AI Agents'],
    [MJAIAgentRunEntityExtended, 'MJ: AI Agent Runs'],
    [MJAIAgentRunStepEntityExtended, 'MJ: AI Agent Run Steps'],
    [MJAIModelEntityExtended, 'MJ: AI Models'],
    [MJAIPromptCategoryEntityExtended, 'MJ: AI Prompt Categories'],
    [MJAIPromptEntityExtended, 'MJ: AI Prompts'],
    [MJAIPromptRunEntityExtended, 'MJ: AI Prompt Runs'],
  ];
  for (const [cls, key] of EXTENDED) {
    cf.Register(BaseEntity, cls, key, 10000);
  }
})();

//***********************************************************
//MSAL
//***********************************************************
import { MsalGuardConfiguration } from '@azure/msal-angular';
import { InteractionType } from '@azure/msal-browser';

//***********************************************************
// Project stuff
//***********************************************************
import { AppComponent } from './app.component';
import { environment } from '../environments/environment';
/**
 * Set your default interaction type for MSALGuard here. If you have any
 * additional scopes you want the user to consent upon login, add them here as well.
 */
export function MSALGuardConfigFactory(): MsalGuardConfiguration {
  return {
    interactionType: InteractionType.Redirect,
  };
}

/**
 * Initialize auth provider before Angular routing starts
 * This ensures MSAL can process OAuth redirect responses before Angular's router
 * consumes the URL hash
 */
export function initializeAuth(authService: MJAuthBase): () => Promise<void> {
  return () => authService.initialize();
}

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    // Angular Core Modules
    BrowserModule,
    BrowserAnimationsModule,
    FormsModule,
    ReactiveFormsModule,

    // MJ Consolidated Bundle (includes all MJ + Kendo modules)
    MJExplorerModulesBundle,

    // Auth (needs forRoot configuration)
    AuthServicesModule.forRoot(environment),

    // Explorer App Shell (includes login UI, validation, and mj-shell wrapper)
    MJExplorerAppModule.forRoot(environment),

    // App-specific modules
    GeneratedFormsModule,

    // Committees governance UI
    CommitteesModule
  ],
  providers: [
    SharedService,
    provideHttpClient(withInterceptorsFromDi()),
    {
      // Force the class-registration imports to be retained at runtime so the
      // bundler cannot tree-shake the @RegisterClass side-effect modules
      // (e.g. MJAIPromptCategoryEntityExtended). Referencing combinedClasses
      // in a real runtime code path keeps the imports alive.
      provide: APP_INITIALIZER,
      useFactory: () => () => { if (combinedClasses.length < 0) console.log(combinedClasses); },
      multi: true
    },
    {
      provide: APP_INITIALIZER,
      useFactory: initializeAuth,
      deps: [MJAuthBase],
      multi: true
    }
  ],
  bootstrap: [AppComponent, RedirectComponent],
})
export class AppModule {}
