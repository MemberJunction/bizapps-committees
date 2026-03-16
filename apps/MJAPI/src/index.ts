/**
 * MemberJunction API Server (MJ 3.0 Minimal Architecture)
 * All initialization logic is in @memberjunction/server-bootstrap
 */
import { createMJServer } from '@memberjunction/server-bootstrap';
import { fileURLToPath } from 'node:url';
import { resolve } from 'node:path';

// Import generated packages to trigger class registration
import '@mj-biz-apps/committees-entities';
import '@mj-biz-apps/committees-actions';

// Committees server bootstrap — registers entity classes and services
import { LoadCommitteesServer, RESOLVER_PATHS as committeesResolverPaths } from '@mj-biz-apps/committees-server';
LoadCommitteesServer();

// Import pre-built MJ class registrations manifest (covers all @memberjunction/* packages)
import '@memberjunction/server-bootstrap/mj-class-registrations';

// Import supplemental manifest for user-defined classes (generated at prestart with --exclude-packages @memberjunction)
import './generated/class-registrations-manifest.js';

// Optional: Import communication providers if needed
// import '@memberjunction/communication-sendgrid';
// import '@memberjunction/communication-teams';

// Optional: Import custom auth/user creation logic
// See: /docs/examples/custom-user-creation/README.md
// import './custom/customUserCreation';

// Resolve resolver paths relative to this file
const __dirname = fileURLToPath(new URL('.', import.meta.url));
const resolverPaths = [resolve(__dirname, 'generated/generated.{js,ts}'), ...committeesResolverPaths];

// Start the server with upload proxy route for storage providers that don't support CORS
createMJServer({
    resolverPaths,
    // Upload proxy registered via ConfigureExpressApp (before auth + GraphQL middleware)
    ConfigureExpressApp: (app: import('express').Express) => {
        console.log('[upload-proxy] Registering /api/upload-proxy routes');

        // Handle CORS preflight for the proxy route (before auth middleware runs)
        app.options('/api/upload-proxy', (_req: import('express').Request, res: import('express').Response) => {
            res.set({
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST, PUT, OPTIONS',
                'Access-Control-Allow-Headers': 'Authorization, Content-Type, x-upload-url, x-upload-method',
                'Access-Control-Max-Age': '86400',
            });
            res.status(204).end();
        });

        const uploadHandler = async (req: import('express').Request, res: import('express').Response) => {
            // Add CORS headers to response
            res.set({
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Authorization, Content-Type, x-upload-url, x-upload-method',
            });
            const targetUrl = req.headers['x-upload-url'] as string;
            const method = (req.headers['x-upload-method'] as string) || 'POST';
            if (!targetUrl) {
                res.status(400).json({ error: 'Missing x-upload-url header' });
                return;
            }

            try {
                const chunks: Buffer[] = [];
                for await (const chunk of req) {
                    chunks.push(typeof chunk === 'string' ? Buffer.from(chunk) : chunk);
                }
                const body = Buffer.concat(chunks);
                console.log(`[upload-proxy] ${method} ${targetUrl.substring(0, 80)}... (${body.length} bytes)`);

                const response = await fetch(targetUrl, {
                    method,
                    headers: { 'Content-Type': 'application/octet-stream' },
                    body,
                });

                if (response.ok) {
                    const text = await response.text();
                    console.log(`[upload-proxy] Success: ${response.status}`);
                    res.status(200).json({ success: true, response: text });
                } else {
                    const errorText = await response.text();
                    console.error(`[upload-proxy] Failed: ${response.status} ${errorText}`);
                    res.status(response.status).json({ error: errorText });
                }
            } catch (err: unknown) {
                const message = err instanceof Error ? err.message : String(err);
                console.error(`[upload-proxy] Error: ${message}`);
                res.status(500).json({ error: message });
            }
        };
        app.put('/api/upload-proxy', uploadHandler);
        app.post('/api/upload-proxy', uploadHandler);
    },
}).catch(console.error);