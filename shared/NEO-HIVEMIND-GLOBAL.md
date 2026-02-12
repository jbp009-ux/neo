# NEO-HIVEMIND-GLOBAL v1.0.0
## Cross-Project Shared Knowledge

**Version:** 1.0.0
**Date:** 2026-02-12
**Purpose:** Shared learnings across ALL projects in the NEO ecosystem. Prevents the same mistake from happening in multiple colonies.
**Writer:** BECCA (during CLOSE) — append-only. No deletions.

---

## How This File Works

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   This file is the CROSS-PROJECT MEMORY.                                    ║
║                                                                              ║
║   WHO WRITES: BECCA — during CLOSE, after indexing project-local hive       ║
║   WHO READS: Ants — during DISCOVERY step 0 (Hive Mind Check)              ║
║   RULE: Append-only. Never edit or delete existing entries.                 ║
║   SYNC: neo-refresh.ps1 copies this to every project's .neo/shared/        ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## Cross-Project Pheromones

Pheromones that apply to ALL projects, not just the project where they were discovered.

| ID | Date | Source Project | Category | Pattern | Severity |
|----|------|---------------|----------|---------|----------|
| GP-001 | 2026-02-11 | Sonny | MENU DATA | Menu collections are destructively rebuilt during publish (delete+recreate). NEVER assume menu data is safe to modify — always check for Nuclear Lock. | ⚫ NUCLEAR |
| GP-002 | 2026-02-11 | Sonny | TENANT ISOLATION | Collection group queries without tenant filter expose ALL tenants' data. ALWAYS scope queries to `{tenantPath}/collection`. | ⚫ NUCLEAR |
| GP-003 | 2026-02-12 | RIZEND | TENANT ISOLATION | `businessId` field is the tenant boundary. Every Firestore query MUST include `businessId` filter or be within `businesses/{bid}/` subcollection. | ⚫ NUCLEAR |
| GP-004 | 2026-02-11 | Sonny | HASH MIGRATION | Changing hash algorithm or parameters (scrypt, bcrypt, etc.) invalidates ALL existing hashed values. Requires full reseed + redeploy. Never treat as "safe refactor." | 🔴 HIGH |
| GP-005 | 2026-02-12 | RIZEND | JWT CLAIMS | Custom claims are cached in JWT. After `setCustomClaims()` changes, users must re-authenticate. This is Firebase behavior, not a bug — do NOT "fix" it. | 🔴 HIGH |
| GP-006 | 2026-02-11 | Sonny | FIREBASE HEADERS | Firebase Hosting overwrites `X-Forwarded-Host`. Use custom headers (e.g., `X-Tenant-Host`) for subdomain/tenant resolution. | 🟠 MEDIUM |
| GP-007 | 2026-02-11 | Sonny | EMAIL VERIFICATION | `sendEmailVerification` must be fire-and-forget. Making it blocking causes `auth/network-request-failed` in Firebase SDK v12+. | 🟠 MEDIUM |

**Format for new entries:**
```
| GP-<NNN> | <YYYY-MM-DD> | <Project> | <Category> | <Pattern description> | <Severity> |
```

---

## Universal Anti-Patterns

Patterns that are WRONG in every project. If an Ant sees these, STOP.

| # | Anti-Pattern | Why It's Wrong | First Seen |
|---|-------------|---------------|-----------|
| UA-01 | `setDoc()` without `{ merge: true }` on existing documents | Replaces entire document (PUT semantics) — destroys unmentioned fields | Sonny HOTLINE PH2 |
| UA-02 | `firebase deploy --only functions` (all functions) | Deploys stale code from all files, not just the one you changed | Sonny, RIZEND |
| UA-03 | Hardcoding tenant IDs in queries | Works in dev, breaks in production with real tenants | Sonny, RIZEND |
| UA-04 | Running seed scripts without verifying target environment | Emulator-only scripts against production = catastrophic data loss | Sonny DZ-03 |
| UA-05 | Direct writes to lookup/index collections | Bypasses validation logic (slugs, codes, indexes should go through callable functions) | Sonny RF-07 |
| UA-06 | Storing plaintext secrets in Firestore documents | Credentials must be in environment variables or Secret Manager, never in database | Both projects |
| UA-07 | Using `eval()` or dynamic code execution for user-facing expressions | Security vulnerability. Use pattern matching or safe parsers | RIZEND (evaluateTriggers) |

---

## Universal Safe Patterns

Patterns that are CORRECT in every project. Default to these.

| # | Pattern | Why It's Safe | Applies To |
|---|---------|-------------|-----------|
| US-01 | `updateDoc()` for field changes (PATCH semantics) | Only modifies specified fields, preserves everything else | All Firestore projects |
| US-02 | `firebase deploy --only functions:<name>` | Targeted deploy — only touches the function you changed | All Firebase projects |
| US-03 | Scope every query to tenant path | Prevents cross-tenant data leaks regardless of rules | All multi-tenant projects |
| US-04 | Verify webhook signatures before processing | Prevents spoofed webhook attacks | All Stripe/payment projects |
| US-05 | Use Zod schemas for all callable function inputs | Type-safe validation at the boundary | All Cloud Functions |
| US-06 | Append-only for audit/movement collections | Immutable audit trail — no updates or deletes | All projects with audit logs |
| US-07 | `--dry-run` before any production migration script | Catches issues before they cause damage | All projects with migrations |

---

## Cross-Colony Lessons

Lessons learned that apply beyond a single project.

| Date | Source | Lesson |
|------|--------|--------|
| 2026-02-10 | Sonny HOTLINE | Firestore rules deploy is instant and affects ALL connected clients immediately. Always test rules in emulator first. |
| 2026-02-10 | Sonny HOTLINE | Rate limiting should be Firestore-backed (not just in-memory) to survive Cloud Function cold starts. |
| 2026-02-11 | Sonny | App Check with invalid reCAPTCHA key causes silent failures. Make App Check opt-in until key is provisioned. |
| 2026-02-12 | RIZEND | Operator Manual should be split into core + appendices. Loading 2,500+ lines for every Ant task wastes ~85% of tokens. |
| 2026-02-12 | RIZEND | Negative Knowledge tables (what the project does NOT use) prevent Ants from suggesting wrong tools/patterns. |

---

## Maintenance Rules

1. **BECCA writes during CLOSE** — after project-local hive indexing, before sign-off
2. **Append-only** — never edit or delete existing entries
3. **Cross-project relevance test** — only add if the pattern could affect OTHER projects
4. **Project-specific stays local** — if it only matters for one project, it goes in that project's pheromone registry
5. **neo-refresh.ps1 syncs** — this file is copied to every project during refresh
6. **ID format** — Pheromones: `GP-NNN`, Anti-patterns: `UA-NN`, Safe patterns: `US-NN`
