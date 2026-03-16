# NEO-HIVEMIND-GLOBAL v1.2.0
## Cross-Project Shared Knowledge

**Version:** 1.2.0
**Date:** 2026-02-25
**Purpose:** Shared learnings across ALL projects in the NEO ecosystem. Prevents the same mistake from happening in multiple colonies.
**Writer:** BECCA (during CLOSE) — append-only with deprecation lifecycle.

---

## How This File Works

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   This file is the CROSS-PROJECT MEMORY.                                    ║
║                                                                              ║
║   WHO WRITES: BECCA — during CLOSE, after indexing project-local hive       ║
║   WHO READS: Ants — during DISCOVERY step 0 (Hive Mind Check)              ║
║   RULE: Append-only. Entries can be DEPRECATED but never deleted.           ║
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
| GP-008 | 2026-02-17 | Sonny | CLOUDFLARE WORKER | Worker `fetch()` to custom domain hits the origin A record, NOT Firebase Hosting. Must rewrite Host to `{project}.web.app` for Firebase to accept the request. Using the custom domain as Host returns 404. | 🔴 HIGH |
| GP-009 | 2026-02-17 | Sonny | STRIPE PORTAL | `billingPortal.configurations.create` rejects metered/usage-based prices in `subscription_update.products`. Only include per-unit licensed recurring prices. | 🟠 MEDIUM |
| GP-010 | 2026-02-17 | Both | EMAIL DOMAIN | ALL products (sonny8.ai, rizend.com) send email from `@beccaos.com`. Do NOT change sender domain per product — it breaks SPF/DKIM and Twilio registration. | 🔴 HIGH |

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
| 2026-02-16 | Sonny Run 019 | Code validated ≠ code deployed. Pipeline validation (Ant→Ghost→Inspector) does NOT deploy code. Always deploy after validation passes, or the production site runs stale code while you think the fix is live. |
| 2026-02-16 | Sonny Run 019 | Firebase custom claims REST API requires the project-scoped path `/v1/projects/{PROJECT_ID}/accounts:update`. The non-scoped `/v1/accounts:update` silently accepts but claims never appear in JWT tokens. |
| 2026-02-17 | Sonny | Firebase Hosting does NOT serve traffic for custom domains unless the domain is registered OR you proxy through Cloudflare Worker to the `*.web.app` hostname. The Worker must rewrite Host to `{project}.web.app`, not the custom domain. |
| 2026-02-17 | Sonny | Stripe Customer Portal `subscription_update.products` requires per-unit licensed prices only. Metered/usage prices must be filtered out or the API returns 400. Filter: `billing_scheme === 'per_unit' && type === 'recurring' && recurring.usage_type === 'licensed'`. |
| 2026-02-17 | Both | Twilio A2P 10DLC: one brand + one campaign covers ALL products under the same business (BECCA OS LLC). No need for separate campaigns per product domain. New EINs (< 1 week old) fail automated brand verification — request TCR Appeal ($11). |

---

## Maintenance Rules

1. **BECCA writes during CLOSE** — after project-local hive indexing, before sign-off
2. **Append-only with deprecation** — entries are never deleted, but can be marked DEPRECATED
3. **Cross-project relevance test** — only add if the pattern could affect OTHER projects
4. **Project-specific stays local** — if it only matters for one project, it goes in that project's pheromone registry
5. **neo-refresh.ps1 syncs** — this file is copied to every project during refresh
6. **ID format** — Pheromones: `GP-NNN`, Anti-patterns: `UA-NN`, Safe patterns: `US-NN`

---

## Entry Lifecycle & Deprecation

Every entry in this file follows a lifecycle:

```
ACTIVE → STALE → DEPRECATED → (stays in file, clearly marked)
```

### Staleness Detection (BECCA RECON — Structured Protocol)

During RECON Index Health Check, BECCA checks global hivemind entries for staleness using this structured protocol:

#### Step 1: Scan Pheromone References (GP-NNN)

For each pheromone entry, run these EXACT commands across ALL governed projects:

```bash
# For each project (e.g., Sonny, RIZEND):
grep -r "GP-001" d:\projects\sonny\.neo\outbox\ants\
grep -r "GP-001" d:\projects\trainer-os\.neo\outbox\ants\

# Count references from last 5 runs:
# If total references = 0 across all projects → STALE CANDIDATE
```

Present results in structured table:

```markdown
| ID | Last Referenced | Run Count | Projects | Status |
|----|----------------|-----------|----------|--------|
| GP-001 | Run 019 (Sonny) | 3 refs in last 5 | Sonny | ACTIVE |
| GP-004 | Never | 0 refs in last 5 | — | STALE CANDIDATE |
```

#### Step 2: Scan Anti-Patterns and Safe Patterns (UA-NN, US-NN)

For each anti-pattern/safe pattern, verify the technology is still in use:

```bash
# Example: UA-07 references eval() in RIZEND
grep -r "eval(" d:\projects\trainer-os\src\
# If no results → technology not in use → STALE CANDIDATE

# Example: US-02 references firebase deploy
grep -r "firebase deploy" d:\projects\sonny\
# If results found → still relevant → ACTIVE
```

#### Step 3: Scan Cross-Colony Lessons

For each lesson, check if the underlying framework/library has changed:
- Check package.json for major version changes since lesson was written
- Check if the specific API/behavior mentioned in the lesson still exists
- If framework changed significantly → STALE CANDIDATE

### Deprecation Rules

| Condition | Action |
|-----------|--------|
| Entry unreferenced for 5+ runs AND still technically valid | Keep ACTIVE — it's still true, just not frequently encountered |
| Entry unreferenced for 5+ runs AND underlying code/tech changed | Mark DEPRECATED |
| Entry contradicted by newer evidence | Mark DEPRECATED + add successor entry |
| Entry applies to project that's been decommissioned | Mark DEPRECATED |

### Deprecation Format

When marking an entry as deprecated, append to the entry:

```
| GP-004 | 2026-02-11 | Sonny | HASH MIGRATION | ~~(original text)~~ **DEPRECATED (2026-MM-DD): <reason>. Superseded by GP-NNN / no longer applicable.** | ~~🔴 HIGH~~ |
```

For lessons table:
```
| ~~2026-02-10~~ | ~~Sonny~~ | ~~(original lesson)~~ **DEPRECATED (2026-MM-DD): <reason>** |
```

### BECCA RECON Output (Staleness Section)

```markdown
## GLOBAL HIVEMIND HEALTH
═══════════════════════════════════════════════════════════════

| Category | Total | Active | Stale Candidates | Deprecated |
|----------|-------|--------|-----------------|------------|
| Pheromones (GP) | <N> | <N> | <N> | <N> |
| Anti-Patterns (UA) | <N> | <N> | <N> | <N> |
| Safe Patterns (US) | <N> | <N> | <N> | <N> |
| Lessons | <N> | <N> | <N> | <N> |
| **TOTAL** | <N> | <N> | <N> | <N> |

Stale candidates requiring operator decision:
| ID | Reason | Recommendation |
|----|--------|---------------|
| GP-004 | 0 refs in 5 runs, tech unchanged | Keep ACTIVE |
| UA-07 | eval() no longer used in RIZEND | DEPRECATE |

NUCLEAR entries (⚫): <N> — exempt from auto-deprecation
═══════════════════════════════════════════════════════════════
```

If stale candidates exist, BECCA flags them for the operator during RECON — the operator decides whether to deprecate or keep active.

### Rules

- **NUCLEAR pheromones (⚫) are NEVER deprecated automatically** — only the operator can deprecate a NUCLEAR entry
- **Deprecated entries stay in the file** — they provide historical context for why decisions were made
- **Ants skip deprecated entries** — during DISCOVERY, only read ACTIVE entries
- **Deprecation is reversible** — if a deprecated pattern resurfaces, BECCA can reactivate it

---
