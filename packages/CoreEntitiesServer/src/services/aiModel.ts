import { UserInfo, LogError } from '@memberjunction/core';
import { AIEngine } from '@memberjunction/aiengine';

/**
 * Finds the best language model we can actually call: active, and its
 * DriverClass has a credential configured (MJ convention:
 * AI_VENDOR_API_KEY__<DriverClass>). Among credentialed models, Anthropic /
 * Claude models win first, then highest PowerRank. Returns null if nothing
 * is credentialed, in which case the AI engine picks its default model.
 *
 * Shared by the AI-backed services so completions land on a vendor we hold
 * credentials for instead of the engine's global default — the metadata's
 * top-ranked models may route through vendors (e.g. OpenRouter) we have no
 * key for.
 */
export function FindCredentialedModels() {
    const isAnthropic = (value: string | null | undefined): boolean => {
        const lower = (value ?? '').toLowerCase();
        return lower.includes('anthropic') || lower.includes('claude');
    };
    const hasKey = (driverClass: string | null | undefined): boolean =>
        !!driverClass && !!process.env[`AI_VENDOR_API_KEY__${driverClass}`];

    return AIEngine.Instance.LanguageModels
        .filter(m => m.IsActive && hasKey(m.DriverClass))
        .sort((a, b) => {
            const aAnthropic = Number(isAnthropic(a.Vendor) || isAnthropic(a.DriverClass) || isAnthropic(a.APIName));
            const bAnthropic = Number(isAnthropic(b.Vendor) || isAnthropic(b.DriverClass) || isAnthropic(b.APIName));
            return bAnthropic - aAnthropic || (b.PowerRank ?? 0) - (a.PowerRank ?? 0);
        });
}

/**
 * Runs a completion against the credentialed models in preference order,
 * falling through on per-model failures (e.g. a metadata model that is not
 * chat-capable). Throws the last error if every candidate fails.
 */
export async function CompletionWithFallback(prompt: string, contextUser: UserInfo): Promise<string> {
    const candidates = FindCredentialedModels().slice(0, MAX_MODEL_ATTEMPTS);
    let lastError: Error | null = null;
    for (const model of candidates) {
        try {
            const result = await AIEngine.Instance.SimpleLLMCompletion(prompt, contextUser, undefined, model);
            if (result) return result;
            lastError = new Error(`Model ${model.Name} returned an empty response`);
        } catch (err) {
            lastError = err instanceof Error ? err : new Error(String(err));
            LogError(`[aiModel] Completion via ${model.Name} failed, trying next candidate: ${lastError.message}`);
        }
    }
    throw lastError ?? new Error('No credentialed AI language models are available');
}

const MAX_MODEL_ATTEMPTS = 3;
