# PROJECT BRIEFING: SONNY
## AI Pizza SaaS — Multi-Tenant Restaurant Platform

**Path:** `d:\projects\sonny\`
**Domain:** `*.sonny8.ai`
**Manual:** `.neo/OPERATOR_MANUAL_SONNY.md` (v2.0.0, 375 lines + 8 appendices)

---

## What Sonny Does

Sonny is an AI-powered restaurant ordering platform. Customers talk to "Sonny" (a Gemini-powered AI waitress) via chat or voice to place orders. Restaurant owners manage menus, orders, KDS (kitchen display), inventory, and staff through an admin dashboard.

**Business model:** SaaS subscriptions (Starter/Pro/Enterprise) + per-order payments via Stripe.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Next.js 16 + React 19 + TypeScript + Tailwind CSS 4 |
| Backend | Firebase Cloud Functions (94 functions, Node.js 20) |
| Database | Firestore (63+ collections, 738-line security rules) |
| Auth | Firebase Auth + custom claims + Staff PIN (scrypt) |
| AI | Google Gemini 2.0 Flash |
| Voice | OpenAI TTS + ElevenLabs TTS + Deepgram STT |
| Payments | Stripe (subscriptions + payment intents) |
| SMS | Twilio (with PROFIT SHIELD guardrails) |
| Email | SendGrid |
| Hosting | Firebase Hosting + Cloudflare Worker (subdomain proxy) |
| Monitoring | Sentry + Slack + PagerDuty |

---

## Key Architecture Decisions

### Dual Tenant Architecture
Sonny has TWO data paths that are BOTH active:
- **Legacy:** `restaurants/{restaurantId}/...` — flat subcollections
- **SaaS:** `workspaces/{wsId}/restaurants/{rId}/...` — nested under workspace

When running tasks: ALWAYS check which path the code uses. Both are valid.

### Subdomain Model
Each restaurant gets `{slug}.sonny8.ai`. A Cloudflare Worker proxies to Firebase Hosting. The `resolveSlugHttp` Cloud Function maps slugs to tenant IDs (5-minute cache).

**Header gotcha:** Firebase overwrites `X-Forwarded-Host`. Sonny uses `X-Tenant-Host` instead.

### PROFIT SHIELD
Usage tracking and cost guardrails for SMS, LLM tokens, and TTS. Prevents a single tenant from running up costs. Plan-based limits with WARNING (70%), CRITICAL (90%), and LIMIT (100%) thresholds.

### OPERATION HOTLINE
A completed 7-phase security hardening operation. 78 fixes, 857 tests, ZERO critical/high findings remaining. 66 medium/low/info tracked in backlog.

---

## Danger Zones (What Can Go Wrong)

| Zone | What | Risk |
|------|------|------|
| **Menu Data** | `menuItems`, `menuPublished`, `goldenMenus` | ⚫ NUCLEAR LOCK — no writes without human approval |
| **Golden Master Seed** | `seedTenantFromGoldenMaster.ts` | Overwrites owner-customized menus |
| **Staff PIN Seed** | `seed-staff-prod.cjs` | Overwrites existing staff PINs in production |
| **Emulator Seed** | `seed-emulator.cjs` | DANGEROUS if run against production |
| **Menu Publish** | `publishMenuForRestaurant.ts` | Delete+recreate during publish (by design) |
| **Payments** | `paymentFunctions.ts`, `subscriptionFunctions.ts` | Financial records at risk |
| **Cloudflare Worker** | `subdomain-proxy/src/index.ts` | If broken = ALL subdomains down |
| **Firestore Rules** | `firestore.rules` (738 lines) | Bad rules = cross-tenant exposure |
| **SaaS Migration** | `migrate-restaurants-to-saas.cjs` | Large-scale production migration |

### The Nuclear Lock (PH-MENU-001)

**ALL menu data is LOCKED.** No agent may write to, delete from, seed, migrate, or modify menu collections without your EXPLICIT approval. This includes: `menuItems`, `menuPublished`, `customizations`, `combos`, `categories`, `goldenMenus`.

---

## Things That Look Like Bugs But Aren't

| What You See | Why It's Intentional |
|-------------|---------------------|
| Empty menu categories | Owner hasn't added items yet |
| `ENFORCE_APP_CHECK=false` | reCAPTCHA key invalid — TODO: provision valid key |
| `sendEmailVerification` fire-and-forget | Blocking causes network failure in SDK v12 |
| `menuPublished` delete+recreate | Intentional rebuild from source on publish |
| Staff PINs `7392`/`5678` in scripts | Demo/test tenant defaults, not secrets |
| `X-Tenant-Host` instead of `X-Forwarded-Host` | Firebase overwrites the standard header |

---

## Deploy Procedures

```bash
# Single function (PREFERRED — always use this)
firebase deploy --only functions:<functionName>

# Firestore rules (instant — affects ALL clients)
firebase deploy --only firestore:rules

# Hosting (frontend)
cd frontend && npm run build && firebase deploy --only hosting

# NEVER do this without good reason:
firebase deploy --only functions  # deploys ALL functions
```

**Emulator:**
```bash
firebase emulators:start          # Ports: Auth=9099, Functions=5001, Firestore=8080, UI=4000
cd frontend && npm run dev        # Frontend dev server
```

**Tests:**
```bash
cd functions && npm test          # All backend tests (896 tests)
npm run test:rules                # Firestore security rules
```

---

## Key Numbers

| Metric | Value |
|--------|-------|
| Cloud Functions | 94 deployed |
| Firestore Collections | 63+ |
| Zod Schemas | 44 |
| Frontend Routes | 25 pages |
| Frontend Hooks | 47 |
| Test Files | 46 |
| Tests | ~896 |
| External Services | 11 |
| Completed NEO Runs | 5 (20 tasks) |
