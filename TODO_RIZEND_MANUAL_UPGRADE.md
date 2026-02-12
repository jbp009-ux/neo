# TODO: RIZEND Operator Manual Upgrade

**Created:** 2026-02-12
**Created by:** BECCA (manual planning — outside NEO run pipeline)
**Reference:** OPERATOR_MANUAL_SONNY.md (2,594 lines / 155KB)
**Target:** OPERATOR_MANUAL_TRAINER.md → upgrade to Sonny-level depth
**Project root:** `d:\projects\trainer-os`
**Manual path:** `d:\projects\trainer-os\.neo\OPERATOR_MANUAL_TRAINER.md`

---

## Context

RIZEND (formerly Trainer OS) has an existing Operator Manual (281 lines / 11.8KB) created by Scout during Run 001 and updated by Leafcutter in Run 001. It covers the basics but is **~7% the size** of Sonny's manual. This TODO plans the upgrade.

**NOTE:** RIZEND is currently in **Run 003 (IN PROGRESS)** — TASK-010 through TASK-012. This manual upgrade should be scheduled as a **separate run** (Run 004) or handled after Run 003 closes.

---

## Gap Analysis: What RIZEND Has vs What Sonny Has

| Section | Sonny | RIZEND | Gap |
|---------|-------|--------|-----|
| 0) What This Is | Full purpose/audience/context | **MISSING** | Add section |
| 1) Architecture | Detailed with scale targets | Basic 6-line tree | Expand: scale targets, component diagram |
| 2) Folder Map | Deep with every key file | Basic 20-line tree | Expand: Cloud Functions detail, component breakdown |
| 3) Firestore Schema | 175 lines, 7 sub-sections | Basic 20-line list | **MAJOR GAP** — needs full schema |
| 4) Danger Zones | 12+ entries + NUCLEAR LOCK | 7 generic entries | Expand with specific files/lines |
| 5) Safe Patterns | Project-specific examples | Template-level examples | Add RIZEND-specific patterns |
| 6) Red Flags | RF-01 to RF-10 with detail | 5 generic entries | Expand with project-specific flags |
| 7) Environment | 30+ vars, staging/prod/emulator | 14 vars, no deploy details | Add deploy process, all env vars |
| 8) Known Intentional Patterns | 11 documented patterns | **EMPTY** (placeholder only) | **MAJOR GAP** — needs audit |
| 9) Theme/Styling | N/A (Sonny uses different approach) | Good (brand gradients) | ✅ Already good |
| 10) Billing | N/A (inline in Sonny) | Good (Stripe tiers) | ✅ Already good |
| **Function Registry** | 65+ functions w/ File:Line, Auth, Rate Limit, R/W | **MISSING ENTIRELY** | **MAJOR GAP** — needs full registry |
| **Middleware/Guards** | Documented middleware chain | **MISSING** | Add: guards.ts, auth middleware |
| **Schema Registry** | Zod schemas documented | **MISSING** | Add: contracts/types.ts, contracts/guards.ts |
| **Cross-Collection Relationships** | Entity diagram | **MISSING** | Add: data flow diagram |
| **Data Criticality Matrix** | Per-collection backup requirements | **MISSING** | Add: which collections are CRITICAL/HIGH/MEDIUM/LOW |

---

## Tasks

### TASK A — Section 0: What This Is
**Ant Type:** 🌿 Leafcutter
**Effort:** Small
**Source:** Read CLAUDE.md + existing manual header

Add introductory section matching Sonny's format:
- What the manual is (operational knowledge, not governance)
- Who reads it (BECCA during RECON, Ants during DISCOVERY)
- History (created Run 001, updated Run 001)
- What it is NOT (governance — that's in shared/NEO-*.md)

---

### TASK B — Section 3: Complete Firestore Schema (MAJOR)
**Ant Type:** 🌿 Leafcutter
**Effort:** Large
**Source:** `firestore.rules`, `contracts/types.ts`, `functions/src/`

Expand the current 20-line collection list into Sonny-style sub-sections:

- [ ] **3a) Collection Tree** — Full path hierarchy of every Firestore collection with field names
  - Source: `contracts/types.ts` (27KB — has all interfaces)
  - Source: `firestore.rules` (57.6KB — has all collection paths)
  - Include: field types, required vs optional, tenant scoping

- [ ] **3b) Security Rules Summary** — Helper functions, rule patterns
  - Source: `firestore.rules`
  - Document: tenant isolation rules, auth helpers, public vs private

- [ ] **3c) Admin SDK-Only Collections** — Collections with no client rules
  - Source: `firestore.rules` (find collections with no `allow` rules)

- [ ] **3d) Key Document Schemas** — Field-level detail for critical docs
  - Source: `contracts/types.ts`
  - Priority: User, Business, GeneratedSession, WorkoutCompletion, Conversation, Habit

- [ ] **3e) Cross-Collection Relationships** — Entity diagram
  - How users → businesses → sessions → completions link together
  - Coach → Client relationship chain
  - Community (public_community) vs Coached data separation

- [ ] **3f) Data Criticality Matrix** — Backup requirements per collection
  - CRITICAL: users, businesses, workoutCompletions, conversations, payments
  - HIGH: generatedSessions, habits, habitLogs, bodyMeasurements, personalRecords
  - MEDIUM: coachFeedPosts, pods, memberConnections
  - LOW: carts, rateLimits, temp data

---

### TASK C — Function Registry (MAJOR)
**Ant Type:** 🌿 Leafcutter
**Effort:** Large
**Source:** `functions/src/index.ts`, all `functions/src/*/` subdirectories

Create a comprehensive function registry matching Sonny's format:

- [ ] **10a) Callable Functions (onCall)** — Every exported callable
  - For each: Function name, File:Line, Auth method, Firestore Reads, Firestore Writes
  - Organize by domain: billing, checkins, coachBrain, coachConnection, coachDiscovery, habits, led, notifications, nutrition, pods, scc

- [ ] **10b) HTTP Endpoints (onRequest)** — Any HTTP-exposed functions
  - Stripe webhook, API routes, health checks

- [ ] **10c) Triggers (onDocumentCreated, etc.)** — Firestore triggers
  - Source: `functions/src/notificationTriggers.ts` (15KB)
  - Document: trigger path, what it does, downstream effects

- [ ] **10d) Scheduled Functions (onSchedule)** — Cron-triggered functions
  - Source: `functions/src/scheduledNotifications/`

---

### TASK D — Section 8: Known Intentional Patterns
**Ant Type:** 🌿 Leafcutter
**Effort:** Medium
**Source:** Audit codebase for patterns that look wrong but are by design

Candidates to investigate:
- [ ] Dual workout data formats (flat exercises vs nested blocks) — already flagged
- [ ] `public_community` businessId for free users — looks like hardcoded tenant
- [ ] `NEXT_PUBLIC_USE_EMULATORS` flag — looks like debug left in
- [ ] `jose@beccaos.com` as SendGrid sender vs `hello@rizend.com` default — looks like a bug
- [ ] Any commented-out features waiting for launch
- [ ] Demo/placeholder data patterns
- [ ] Feature gating patterns that look like bugs

---

### TASK E — Expand Danger Zones (Section 4)
**Ant Type:** 🌿 Leafcutter
**Effort:** Medium
**Source:** `firestore.rules`, `functions/src/`, `scripts/`, Run 003 findings

Upgrade from 7 generic entries to specific file:line entries:
- [ ] `firestore.rules:664` — `clientInvitations` allow read: if true (flagged Run 003)
- [ ] Seed scripts — any scripts that write to Firestore
- [ ] Migration scripts — any data restructuring scripts
- [ ] `functions/src/billing/` — payment-related functions (financial impact)
- [ ] `contracts/guards.ts` — tenant isolation enforcement
- [ ] Delete handlers — any cascading delete patterns
- [ ] API routes that call external APIs (Anthropic, Stripe, SendGrid)

---

### TASK F — Expand Red Flags (Section 6)
**Ant Type:** 🌿 Leafcutter
**Effort:** Small
**Source:** Codebase patterns, Run 001-003 learnings

Add RIZEND-specific red flags:
- [ ] RF-06: Querying without businessId filter (tenant leak)
- [ ] RF-07: Modifying workout data without handling both flat/block formats
- [ ] RF-08: Using `useEffect`/`useState` after conditional returns (React violation — flagged Run 002)
- [ ] RF-09: Hardcoding `rizend.com` in new email templates (should use env var pattern)
- [ ] RF-10: Calling Anthropic API without rate limiting / error handling

---

### TASK G — Middleware & Guards Documentation
**Ant Type:** 🌿 Leafcutter
**Effort:** Medium
**Source:** `contracts/guards.ts` (12KB), `context/AuthContext.tsx`, `context/FeatureAccessContext.tsx`

New section documenting:
- [ ] Auth guard chain — how requests are authenticated
- [ ] Tenant isolation guards — how businessId is enforced
- [ ] Feature access gates — how tier-based access works
- [ ] React context providers — AuthContext, FeatureAccessContext
- [ ] Cloud Functions auth patterns — how server-side auth works

---

### TASK H — Schema / Type Registry
**Ant Type:** 🌿 Leafcutter
**Effort:** Medium
**Source:** `contracts/types.ts` (27KB), `frontend/src/types/` (13 files)

New section documenting:
- [ ] Core TypeScript interfaces from `contracts/types.ts`
- [ ] Type guards from `contracts/guards.ts`
- [ ] Frontend-specific types from `frontend/src/types/`
- [ ] Shared types vs frontend-only types

---

### TASK I — Environment & Deployment Expansion (Section 7)
**Ant Type:** 🌿 Leafcutter
**Effort:** Small
**Source:** `firebase.json`, `.env` files, deployment docs

Expand to match Sonny's detail:
- [ ] Local dev setup (emulator ports, commands)
- [ ] Staging environment details
- [ ] Production deployment process
- [ ] Deploy gotchas / known issues
- [ ] All environment variables (currently 14, likely more exist)
- [ ] Emulator ports (Auth, Functions, Firestore, UI)

---

## Priority Order

| Priority | Task | Why |
|----------|------|-----|
| 1 | **TASK B** — Firestore Schema | Largest gap. Every Ant needs this for safe data operations. |
| 2 | **TASK C** — Function Registry | Second largest gap. Ants need to know what functions exist before adding/modifying. |
| 3 | **TASK E** — Danger Zones | Security-critical. Run 003 already found a security hole. |
| 4 | **TASK G** — Guards & Middleware | Core to tenant safety. |
| 5 | **TASK D** — Intentional Patterns | Prevents assumption-based "fixes." |
| 6 | **TASK F** — Red Flags | Prevents common mistakes. |
| 7 | **TASK H** — Schema Registry | Type safety documentation. |
| 8 | **TASK I** — Environment | Deployment safety. |
| 9 | **TASK A** — What This Is | Cosmetic but important for structure. |

---

## Execution Options

**Option 1: Single Leafcutter Run (Recommended)**
One 🌿 Leafcutter Ant does all tasks in a single run. It reads the codebase once and builds the full manual.
- Pro: Most efficient, no context switching
- Con: Large task, may need to split if too big

**Option 2: Multi-Task Run**
BECCA creates a NEO run with multiple tasks — one per section.
- Pro: Pipeline quality (Ghost reviews each section)
- Con: Slower, more overhead for documentation work

**Option 3: Operator-Assisted**
Operator fills in sections manually using this TODO as a checklist.
- Pro: Operator knows the project best
- Con: Time-intensive

---

## Estimated Result

After completing all tasks, RIZEND's Operator Manual should grow from:
- **Current:** 281 lines / 11.8KB / 10 sections (thin)
- **Target:** ~1,500-2,000 lines / 80-100KB / 14+ sections (Sonny-level depth)

The manual will NOT be as large as Sonny's (2,594 lines) because Sonny has 65+ Cloud Functions vs RIZEND's ~25 modules, and Sonny's Firestore schema is more complex (multi-tenant subcollection tree vs flat businessId filtering).
