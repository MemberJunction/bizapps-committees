import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
import { AppModule } from './app/app.module';

// TEMP DIAG — verify Extended class registrations win (remove after confirming)
import { MJGlobal } from '@memberjunction/global';
import { BaseEntity } from '@memberjunction/core';
try {
  const cf = MJGlobal.Instance.ClassFactory as any;
  for (const key of ['MJ: AI Prompt Categories', 'MJ: AI Models']) {
    const all = (cf.GetAllRegistrations(BaseEntity, key) ?? []) as any[];
    console.warn(`[DIAG] ${key} regs:`, all.map(r => ({ c: r?.SubClass?.name, p: r?.Priority })));
    console.warn(`[DIAG] ${key} WINNER:`, cf.GetRegistration(BaseEntity, key)?.SubClass?.name);
  }
} catch (e) { console.error('[DIAG]', e); }
// END TEMP DIAG

async function initAndBootstrap() {
  platformBrowserDynamic().bootstrapModule(AppModule)
    .then(ref => {
      //LogStatus('Bootstrap success: ' + ref);
    })
    .catch(err => console.error(err));
}

initAndBootstrap();
