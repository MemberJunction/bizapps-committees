# Committees Server Test Harnesses

Live, DB-backed validation through the **real** MJ data provider and the
**real** committees entity classes — the exact code path MJAPI runs. Pattern
follows `bizapps-accounting/test-harnesses/server/`.

The Vitest suite in `packages/Core` is pure-logic only (no DB, MJ convention).
Anything that touches SQL Server lives here.

## Harnesses

| Harness | What it proves | Writes? |
|---|---|---|
| `metadata-integrity.mts` | **The CodeGen guard.** Zero view↔EntityField drift, every entity survives a real `Load()`, exactly the two pre-created apps with all 17 entities, permission rows present. Run after **every** codegen pass. | read-only |
| `governance-loop-runtime.mts` | The Phase 2 "Govern" loop end-to-end: meeting lifecycle → agenda progression → attendance → motion on the floor → roll-call votes (incl. vote change) → record result (cross-checked against `BallotService`) → minutes Draft → PendingApproval. | creates + tears down |
| `ballot-runtime.mts` | The e-ballot lifecycle: meeting-less motion, sealed ballot open, UQ/CK constraint enforcement, sealed voting, close-with-stamp, threshold math cross-check. | creates + tears down |

## Running

From the **repo root** (the harnesses read `.env` for DB settings):

```bash
npm run test:harness              # all three, in order
npm run test:harness:metadata     # codegen guard only (10s)
npm run test:harness:governance   # governance loop
npm run test:harness:ballot      # e-ballot lifecycle
```

Exit codes: `0` all passed · `1` test failures · `2` bootstrap error.

## Prerequisites

- `.env` pointing at a dev DB that has been migrated + codegen'd
- Demo data seeded (`Demos/01_…` then `Demos/02_…`) — the write harnesses
  use the demo Board of Directors / Data Interoperability Workgroup rosters
  (read-only on memberships; everything they create is torn down in `finally`)

## The full test story

1. **Unit** — `npm test` (packages/Core vitest): ballot math, motion register
   assembly, health signals. Deterministic, no DB, sub-second.
2. **Runtime** — `npm run test:harness`: this directory.
3. **Fresh-install gate** — after any codegen: `npm run test:harness:metadata`
   must pass on the DB codegen ran against. Its M1 check is the drift query
   documented at the baseline migration's CODEGEN SPLICE POINT.

## Why metadata-integrity exists (2026-07-06)

A codegen run regenerated every committee view with new denormalized name
columns but only registered fields for entities whose *tables* changed —
leaving 14 view columns unknown to metadata. Every entity `Load()` then threw
`Field X does not exist` (BaseEntity.SetMany). The root causes (AI name-field
pass racing map resolution; `Title` vs `Name` columns) are fixed — SmartField
is pinned off in `mj.config.cjs` and all entities use literal `Name` — but
this harness makes the entire failure class a 10-second check instead of a
lost day.
