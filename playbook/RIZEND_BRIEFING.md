# PROJECT BRIEFING: RIZEND
## AI Fitness Coaching — Multi-Tenant SaaS Platform

**Path:** `d:\projects\trainer-os\`
**Domain:** `rizend.com`
**Brand:** Rizend — "Rise Together"
**Manual:** `.neo/OPERATOR_MANUAL_TRAINER.md` (v3.0.0, 339 lines + 5 appendices)

---

## What Rizend Does

Rizend is an AI-powered fitness coaching platform. Coaches create workout programs, clients do workouts and self-evaluations, coaches review and adjust. The platform handles everything from workout generation to nutrition tracking to community features.

**Business model:** SaaS subscriptions (Free, Pro, Business, Concierge, Studio tiers) via Stripe.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Next.js 14 (App Router) + React 18 + TypeScript + Tailwind CSS |
| Backend | Firebase Cloud Functions (155+ functions, Node.js) |
| Database | Firestore (80+ collections, 1,440-line security rules) |
| Auth | Firebase Auth + JWT custom claims (`businessId`, `role`) |
| AI | Anthropic SDK (workout generation) |
| Email | SendGrid |
| Payments | Stripe (5 subscription tiers) |
| Hosting | Frontend: Cloudflare Pages / Backend: Cloud Functions |

---

## Key Architecture Decisions

### Tenant Model
Flat `businessId` field on EVERY Firestore document. JWT custom claims for zero-read security rule checks. Free community users share a virtual tenant `businessId: 'public_community'`.

### Tier System
Two modes: `public` (free users, community features) and `coached` (real businessId, full coaching). Feature gating via `FeatureAccessContext` React context.

### Core Loop
Program → Do Workout → Self-Eval → Coach Eval → Adjust → Repeat

### Shared Contracts
`contracts/types.ts` (1,224 lines) and `contracts/guards.ts` (402 lines) are the single source of truth for ALL data models and server-side guard functions.

---

## Danger Zones (What Can Go Wrong)

| Zone | What | Risk |
|------|------|------|
| **businessId Isolation** | Every document must have `businessId` | Missing = cross-tenant leak |
| **Custom Claims** | `setUserClaims` Cloud Function | Wrong claims = wrong access |
| **Firestore Rules** | `firestore.rules` (1,440 lines) | Bad rules = security breach |
| **Cross-Coach Sharing** | `canCrossCoachShare()` guard | 5-check gate, complex logic |
| **evaluateTriggers** | Self-eval expression parser | Uses regex, NOT eval() |
| **Coach Brain** | `computeCoachBrainFlags()` | Rules-based, 7 flag types |
| **SCC Attribution** | `validateAttributionLock()` | Immutable once locked |

---

## Things That Look Like Bugs But Aren't

| What You See | Why It's Intentional |
|-------------|---------------------|
| Claims not updating after `setUserClaims` | Firebase caches JWT — user must re-auth |
| `public_community` businessId | Virtual tenant for free users |
| `evaluateTriggers` using regex, not eval | Security — eval() is dangerous |
| No REST endpoints (mostly) | Firestore SDK + onCall functions by design |
| Coach Brain flags computed in batch | Scheduled function, not realtime |

---

## Auth & Permissions

| Role | Can Do |
|------|--------|
| **Coach** | Read/write own business data + client records |
| **Client (coached)** | Read own data + assigned workouts. Write completions, checkins, meals. |
| **Client (public)** | Community content + own data only |
| **System Admin** | Store + ads management (`systemRole: 'admin'`) |

**Tenant isolation is ABSOLUTE.** Coach in Business A cannot read Business B data, even with the same role.

---

## Deploy Procedures

```bash
# Cloud Functions (targeted)
firebase deploy --only functions:<functionName>

# Firestore rules
firebase deploy --only firestore:rules

# Firestore indexes
firebase deploy --only firestore:indexes

# Frontend deploys automatically via Cloudflare Pages (git push)
```

**Emulator:**
```bash
firebase emulators:start          # Ports: Auth=9099, Functions=5001, Firestore=8080, UI=4000
cd frontend && npm run dev        # Frontend dev server
```

---

## Billing Tiers

| Tier | Monthly Key | Annual Key |
|------|-------------|-----------|
| Free | N/A | N/A |
| Pro | `STRIPE_PRO_PRICE_ID` | `STRIPE_PRO_ANNUAL_PRICE_ID` |
| Business | `STRIPE_BUSINESS_PRICE_ID` | `STRIPE_BUSINESS_ANNUAL_PRICE_ID` |
| Concierge | `STRIPE_CONCIERGE_PRICE_ID` | `STRIPE_CONCIERGE_ANNUAL_PRICE_ID` |
| Studio | `STRIPE_STUDIO_PRICE_ID` | `STRIPE_STUDIO_ANNUAL_PRICE_ID` |

---

## Brand & Theme

**Primary gradient:** Purple → Cyan → Lime (`#8c52ff → #00d9ff → #d7fa00`)

Tailwind utilities: `bg-gradient-rizend`, `text-gradient-rizend`, `glow-rizend`

---

## Key Numbers

| Metric | Value |
|--------|-------|
| Cloud Functions | 155+ |
| Firestore Collections | 80+ |
| Security Rules | 1,440 lines |
| Contracts (types.ts) | 1,224 lines |
| Guards (guards.ts) | 402 lines |
| Frontend Routes | 32+ (client + coach + owner) |
| Completed NEO Runs | 3 (13 tasks) |
