/** Diagnostic: what does AIEngine.LanguageModels hold, and which models are credentialed? */
import { bootstrap } from './bootstrap.mjs';
import { AIEngine } from '@memberjunction/aiengine';

const { pool, user } = await bootstrap();
await AIEngine.Instance.Config(false, user);

const hasKey = (d: string | null | undefined) => !!d && !!process.env[`AI_VENDOR_API_KEY__${d}`];
const rows = AIEngine.Instance.LanguageModels
    .map(m => ({
        Name: m.Name,
        DriverClass: m.DriverClass ?? 'NULL',
        IsActive: m.IsActive,
        PowerRank: m.PowerRank,
        Credentialed: hasKey(m.DriverClass),
    }))
    .filter(r => r.Credentialed || r.Name.toLowerCase().includes('gemini'))
    .sort((a, b) => (b.PowerRank ?? 0) - (a.PowerRank ?? 0));
console.table(rows.slice(0, 12));
console.log('Gemini key present in env:', !!process.env.AI_VENDOR_API_KEY__GeminiLLM);
await pool.close();
process.exit(0);
