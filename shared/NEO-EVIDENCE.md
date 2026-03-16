# NEO-EVIDENCE v1.9.0
## Evidence Contract — No Claims Without Proof

**Purpose:** Evidence requirements, rejected patterns, validation rules, pheromone system, evidence budget, hive mind context, surgical protocol evidence, feature protection evidence, budget ledger, command proof, nearest truth rule, SaaS safety evidence (tenant isolation, audit trail, data classification, environment)
**Scope:** Loaded by ALL NEO roles (Ant, Ghost, Inspector)

---

## 1) Core Evidence Doctrine (FROZEN)

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   No output is "real" unless evidence exists.                   │
│                                                                 │
│   Evidence = file paths + line numbers + diffs + test output    │
│                                                                 │
│   Claims without evidence are REJECTED.                         │
│   Placeholder paths are REJECTED.                               │
│   Generic recommendations are REJECTED.                         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2) Required Evidence by Finding Type

| Finding Type | Required Evidence |
|--------------|-------------------|
| Code change | file_path + line_number + before/after diff |
| Bug fix | file_path + line_number + error description + fix diff |
| Test result | test name + pass/fail + output |
| Build status | command + exit code + output snippet |
| Lint/type check | command + result + error count |
| Security issue | file_path + line_number + description + fix |
| Backup proof | timestamp + location + scope + restore method + verification |
| Dry-run result | environment + input dataset + output comparison + pass/fail |
| Data op classification | file + change type + data op type + backup required + write semantics |
| Understanding proof | current behavior + design intent + hidden constraints + blast radius |
| Feature impact | feature name + impact level (NONE/REDUCED/RELOCATED/REMOVAL) + override token if removal |
| Feature inventory | feature name + files before/after + exports before/after + delta + status |
| Non-existence claim | feature/code name + grep commands run + search scope + result count (must be 0) |
| Budget ledger | resource type + budget + used + remaining + status (✅/⚠️/🛑) |
| Command proof | actual grep/glob command + verbatim output + interpretation |
| Discovery strategy | one question + first file + search plan + answer with evidence reference |
| Truthy diffs | 7-step checklist (all PASS or failure identified + STOP) |
| Tenant isolation scan | tenant boundary + unscoped query count + collection group check + verdict |
| Secret scan | grep patterns run + findings (type only, never value) + location |
| Data classification | field/collection + tier (T1-T4) + PII flag + handling rule |
| Environment declaration | TARGET_ENVIRONMENT (EMULATOR/STAGING/PRODUCTION) + dry-run evidence if prod |
| Destructive op log | operation + target + before state + after state + reversible flag |
| Restore test | test environment + records backed up + records restored + sample verified + result |
| NUCLEAR incident report | task + trigger + file + evidence + blast radius + immediate risk + recommended action |

---

## 3) Rejected Patterns (INVALID EVIDENCE)

### 3.1 Placeholder Paths — REJECTED

These are template/fake paths and MUST be rejected:

```
/project/root/...
path/to/...
.../
<file_path>
[file_path]
your_project/...
example_/...
sample_/...
todo_/...
placeholder/...
```

### 3.2 Generic Recommendations — REJECTED

These are too vague and MUST be rejected:

```
"fix this"
"update this"
"change this"
"modify as needed"
"implement appropriate..."
"add necessary..."
"TODO"
"..."
```

### 3.3 Fabricated Evidence — REJECTED

Test output that doesn't match actual runs. Diffs that don't match actual files.

---

## 4) Evidence Scoring

| Score | Grade | Action |
|-------|-------|--------|
| 90-100% | EXCELLENT | Fast-track approval |
| 70-89% | PASS | Standard approval |
| 50-69% | MARGINAL | Flag for review |
| 0-49% | FAIL | REJECTED, must resubmit |

### Scoring Dimensions

| Dimension | Weight | Criteria |
|-----------|--------|----------|
| Path Validity | 30% | All file paths exist and are verifiable |
| Specificity | 25% | Line numbers, function names, specific locations |
| Completeness | 20% | All required fields present |
| Verification | 15% | Each claim has corresponding proof |
| No Placeholders | 10% | Zero placeholder or generic patterns |

---

## 5) Evidence Checklist

### For Ant (before submitting report)
- [ ] All file paths are real (can be verified with `ls` or `cat`)
- [ ] All code findings have line numbers
- [ ] All changes have before/after diffs
- [ ] All test results have actual output
- [ ] All recommendations are specific (>20 characters, not generic)
- [ ] Evidence section has verifiable paths
- [ ] No placeholder text anywhere
- [ ] Understanding proof completed for all changes (LAW 1 — see NEO-SURGICAL.md)
- [ ] Data operation classification present in FOOTPRINT (if data ops involved)
- [ ] Backup proof documented (if data ops involved)
- [ ] Dry-run evidence present (if destructive ops: DELETE/MIGRATION/SEED/PUT)
- [ ] Feature Impact table present in FOOTPRINT (all affected features listed)
- [ ] Feature Inventory table present in VERIFY (before/after counts for all features in scope)
- [ ] No feature count decreased without `🔑 FEATURE REMOVAL OVERRIDE`
- [ ] Non-existence claims backed by grep evidence (if any "doesn't exist" assertions made)
- [ ] Discovery Strategy present (ONE QUESTION stated before reading code)
- [ ] Budget Ledger present at end of DISCOVERY (files/lines/greps tracked with real numbers)
- [ ] Command Proof in Hive Mind Briefing (actual grep commands + output, not "I checked")
- [ ] Truthy Diffs checklist present in PATCH output (7/7 or failure + STOP)
- [ ] Discovery Strategy question answered in DISCOVERY output with evidence
- [ ] Source conflicts reported if found (Nearest Truth Rule — Section 14)
- [ ] No silent resolution of conflicting sources (code vs manual vs reports)
- [ ] Tenant Isolation Scan performed in DISCOVERY (if multi-tenant project)
- [ ] Secret scan performed in DISCOVERY (grep for secret patterns)
- [ ] Data Classification table present (if task involves data operations)
- [ ] TARGET_ENVIRONMENT declared in FOOTPRINT
- [ ] If PRODUCTION + destructive: 🔑 PRODUCTION CONFIRMED obtained
- [ ] If PRODUCTION + destructive: dry-run evidence from emulator/staging provided
- [ ] Destructive Operation Log present (if any destructive operations performed)
- [ ] Restore Test Proof present (if DATA_DELETE or MIGRATION)
- [ ] No T1/T2 (PII) data pasted in reports (use anonymized data or doc IDs)
- [ ] No secret values in reports (report type and location only)

### For Ghost (before approving)
- [ ] All evidence paths verified as real files
- [ ] No placeholder paths detected
- [ ] No generic recommendations detected
- [ ] All claims have corresponding proof
- [ ] Evidence score >= 70%
- [ ] Diffs match actual file states
- [ ] Understanding proof verified (LAW 1 checks present in DISCOVERY)
- [ ] Backup proof verified (if data ops — timestamped, restorable, location documented)
- [ ] No assumption-based changes detected (anti-assumption rules A-01 → A-08)
- [ ] Write semantics justified (PUT/DELETE operations have explicit rationale)
- [ ] Feature Impact table reviewed — impact levels match actual changes
- [ ] Feature Inventory counts verified — deltas match actual file state
- [ ] Non-existence claims independently verified (Ghost MUST grep independently — see Section 13.5)
- [ ] No scope contraction detected (features removed that weren't in task scope)
- [ ] Discovery Strategy present and question answered with evidence
- [ ] Budget Ledger numbers match actual citations in DISCOVERY (spot-check file count)
- [ ] Command Proof spot-checked (2 grep claims from Hive Mind Briefing verified plausible)
- [ ] Truthy Diffs 7/7 present in PATCH output — cross-check FOOTPRINT match + ghost files
- [ ] Operator Manual currency checked (if exists, flag if > 5 runs stale)
- [ ] Source conflicts reported (if Ant found conflicting info between code/manual/reports — Section 14)
- [ ] No silent resolution: Ant did not silently pick one source over another without reporting conflict
- [ ] Tenant Isolation Scan present (if multi-tenant) — verify Ant actually grepped for unscoped queries
- [ ] Secret scan present — verify Ant ran grep for secret patterns
- [ ] TARGET_ENVIRONMENT declared in FOOTPRINT — reject if missing (S-35)
- [ ] If PRODUCTION: verify 🔑 PRODUCTION CONFIRMED obtained for destructive ops
- [ ] If PRODUCTION: verify dry-run evidence from emulator/staging exists
- [ ] Data Classification table present and tiers correct (if data ops)
- [ ] Destructive Operation Log present and complete (if destructive ops)
- [ ] Restore Test Proof present (if DATA_DELETE or MIGRATION) — not just "verified: YES"
- [ ] No PII (T1/T2) leaked in report (check for real emails, names, phone numbers)
- [ ] No secrets leaked in report (check for API keys, tokens, passwords)
- [ ] NUCLEAR = HALT verified — if Ant detected NUCLEAR, did they HALT? (V-13 check)

### For Inspector (during audit)
- [ ] Evidence format follows NEO-EVIDENCE standards
- [ ] All required evidence types present
- [ ] Evidence naming follows convention
- [ ] No fabricated or template evidence

---

## 6) Evidence Categories

### Code Evidence
| Type | Required Format |
|------|-----------------|
| File change | Before/after diff with line numbers |
| New file | Full file content with path |
| Deleted file | Confirmation + reason |
| Refactor | Before/after comparison |

### Test Evidence
| Type | Required Format |
|------|-----------------|
| Unit test | Test name + output + pass/fail |
| Integration test | Test name + output + pass/fail |
| E2E test | Test name + screenshot/log + pass/fail |
| Manual verification | Steps + expected + actual |

### Build Evidence
| Type | Required Format |
|------|-----------------|
| Build | Command + output (success/fail) |
| Lint | Command + output (error/warning count) |
| Type check | Command + output (error count) |

---

## 7) Evidence Storage (in deployed projects)

```
<project>/.neo/
├── outbox/
│   ├── ants/
│   │   └── ANT_REPORT_<TASK_ID>.md          ← Ant report (evidence section)
│   ├── ghost/
│   │   └── GHOST_REVIEW_<TASK_ID>.md        ← Ghost review (validation results)
│   └── inspector/
│       └── INSPECTOR_REPORT_<TASK_ID>.md    ← Inspector audit
├── audit/
│   ├── evidence/
│   │   ├── <TASK_ID>_diff_<file>.patch
│   │   ├── <TASK_ID>_test_output.txt
│   │   ├── <TASK_ID>_build_output.txt
│   │   └── <TASK_ID>_screenshot.png
│   └── gate-logs/
│       └── GATE_LOG_<TASK_ID>.md            ← Token trail (archived)
└── runtime/                                  ← Active task state
```

---

## 8) Pheromone System

**Pheromones** are structured warning markers emitted by Ants during task execution. They signal risks, concerns, and boundary crossings to Ghost and Inspector.

### 8.1 Pheromone Format

```
PHEROMONE: <SEVERITY> | <CATEGORY> | <TARGET> | <MESSAGE>
```

**Example:**
```
PHEROMONE: ⚫ NUCLEAR | ISOLATION | src/api/tenants.ts:42 | Cross-tenant query without tenant filter
PHEROMONE: 🔴 HIGH | SECURITY | src/auth/login.ts:15 | Hardcoded fallback password in auth flow
PHEROMONE: 🟠 MEDIUM | VALIDATION | src/forms/order.ts:88 | No input sanitization on user comment field
PHEROMONE: 🟡 LOW | PERFORMANCE | src/hooks/useMenu.ts:30 | N+1 query pattern in data fetch loop
```

### 8.2 Pheromone Severity Levels

| Severity | Color | Meaning | Ant Action | Ghost Action |
|----------|-------|---------|------------|--------------|
| ⚫ **NUCLEAR** | Black | Tenant isolation breach, credential exposure | STOP IMMEDIATELY, emit pheromone, wait | REJECT if missing |
| 🔴 **HIGH** | Red | Security risk, data integrity concern | STOP, flag to operator | Verify mitigation |
| 🟠 **MEDIUM** | Orange | Validation gap, edge case risk | Document, continue with caution | Note in review |
| 🟡 **LOW** | Yellow | Performance, code quality, minor concern | Document in report | Acknowledge |
| 🟢 **INFO** | Green | Observation, no action needed | Document in report | Note |

### 8.3 Pheromone Rules

| Rule | Description |
|------|-------------|
| Mandatory emission | Ant MUST emit pheromone for ANY risk/concern found |
| Missing pheromone | If risk exists but pheromone is missing = task INCOMPLETE |
| Ghost validates | Ghost checks that all risks have corresponding pheromones |
| No suppression | Cannot suppress or hide pheromones to pass review |
| Append-only | Pheromones are logged, never deleted |

---

## 9) Tenant Isolation Pheromones

When working in multi-tenant contexts, these **specific pheromones** are required:

| Pheromone | Severity | Trigger | Example |
|-----------|----------|---------|---------|
| `TENANT_BOUNDARY` | ⚫ NUCLEAR | Code crosses tenant boundary without filter | Query reads all tenants' data |
| `CROSS_TENANT_QUERY` | ⚫ NUCLEAR | Database query accesses another tenant's data | `db.collection('orders').get()` without tenantId |
| `TENANT_CONTEXT` | 🔴 HIGH | Tenant context missing or ambiguous | Function doesn't receive tenantId parameter |
| `SHARED_COMPONENT` | 🟠 MEDIUM | Shared component handles multi-tenant data | Shared cache, shared queue, shared state |

### 9.1 Tenant Isolation Rules

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   ANY code that touches tenant-specific data MUST:              │
│                                                                 │
│   1. Verify tenant context is present                           │
│   2. Filter by tenant ID                                        │
│   3. NEVER query across tenants without explicit justification  │
│   4. Emit appropriate pheromone if boundary is crossed          │
│                                                                 │
│   Missing tenant context = STOP + TENANT_CONTEXT pheromone      │
│   Cross-tenant query = STOP + ⚫ NUCLEAR pheromone              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 10) Evidence Budget (Hard Caps)

The **Anti-Drowning Protocol** prevents infinite research loops. Each state has a hard evidence budget.

### 10.1 Budget Per State

| State | Max Files Read | Max Lines Shown | Max Greps | Max Tests |
|-------|---------------|-----------------|-----------|-----------|
| **DISCOVERY** | 5 | 200 | 10 | — |
| **FOOTPRINT** | 3 | 150 | 5 | — |
| **PATCH** | *(as needed)* | *(as needed)* | — | — |
| **VERIFY** | — | 500 (output) | — | 10 |
| **REPORT** | *(reference only)* | *(reference only)* | — | — |

### 10.2 Budget Rules

| Rule | Description |
|------|-------------|
| Hard cap | Exceeding ANY budget line = STOP |
| Ask first | If budget is insufficient, request `🔑 DISCOVERY EXPANSION APPROVED` |
| No silent expansion | Cannot quietly read more files — must ask |
| Triage first | Read the MOST relevant file first, not everything |
| Nearest truth | Start from the error/issue location, expand outward |
| One question rule | Ask ONE focused question per STOP, not a list |

### 10.3 Two-Pass Workflow

```
PASS 1 (within budget): Read → Understand → Form hypothesis
PASS 2 (if needed):     Request expansion → Read more → Confirm/revise
```

**If PASS 1 is sufficient, do NOT request PASS 2.**

---

## 11) Quick Reference

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  NEO-EVIDENCE v1.9.0 — QUICK REFERENCE                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  DOCTRINE: No claims without proof. Period.                                 │
│                                                                             │
│  REQUIRED PER FINDING:                                                      │
│  • file_path (real, not placeholder)                                        │
│  • line_number (for code)                                                   │
│  • diff (before/after for changes)                                          │
│  • test output (for verification)                                           │
│                                                                             │
│  PHEROMONES (risk markers):                                                 │
│  ⚫ NUCLEAR — tenant breach, credential exposure → STOP, no override       │
│  🔴 HIGH — security risk → STOP, flag operator                             │
│  🟠 MEDIUM — validation gap → document, caution                            │
│  🟡 LOW — performance, quality → document                                  │
│  🟢 INFO — observation → note                                              │
│                                                                             │
│  EVIDENCE BUDGET (Anti-Drowning):                                           │
│  DISCOVERY: 5 files / 200 lines / 10 greps                                 │
│  FOOTPRINT: 3 files / 150 lines / 5 greps                                  │
│  VERIFY:    500 lines output / 10 tests                                     │
│  Exceeding = STOP → ask 🔑 DISCOVERY EXPANSION APPROVED                    │
│                                                                             │
│  REJECTED PATTERNS:                                                         │
│  • /project/root/... (placeholder)                                          │
│  • "fix this" (generic)                                                     │
│  • Fabricated test output                                                   │
│                                                                             │
│  SCORING: >= 70% to pass. < 50% = auto reject.                             │
│                                                                             │
│  SURGICAL PROTOCOL EVIDENCE (NEO-SURGICAL.md):                             │
│  LAW 1: Understanding proof (behavior, intent, constraints, blast radius)  │
│  LAW 2: Backup proof (timestamp, location, scope, restore, verified)       │
│  LAW 3: Dry-run evidence (for DELETE/MIGRATION/SEED/PUT)                   │
│  Ghost checks: No assumption patterns, write semantics justified           │
│                                                                             │
│  FEATURE PROTECTION EVIDENCE (NEO-SURGICAL.md Section 6b):                │
│  Ant provides: Feature Impact (FOOTPRINT) + Feature Inventory (VERIFY)    │
│  Ghost MUST: independently verify non-existence claims (grep + git log)   │
│  Ghost MUST: cross-check feature file/export counts independently         │
│  Ghost MUST: detect scope contraction ("consolidated"/"simplified")        │
│  Negative delta without 🔑 FEATURE REMOVAL OVERRIDE = REJECT             │
│                                                                             │
│  COLONY OS PROOF-FORCING EVIDENCE (v1.5.0):                              │
│  Discovery Strategy: ONE QUESTION + first file + search plan + answer     │
│  Budget Ledger: files/lines/greps tracked — real numbers, not claims      │
│  Command Proof: actual grep commands + output in Hive Mind Briefing       │
│  Truthy Diffs: 7-step pre-commit checklist in PATCH output                │
│  Ghost spot-checks: 2 grep claims + budget numbers + FOOTPRINT match      │
│                                                                             │
│  NEAREST TRUTH RULE (v1.6.0 — Section 14):                               │
│  Code > Config > Manual > Reports > External Docs                         │
│  If sources conflict: REPORT the conflict, do NOT silently pick a side    │
│  The Stale Manual Trap: code says feature exists → manual says removed    │
│  → Code outranks Manual. REPORT conflict. Do NOT delete.                  │
│                                                                             │
│  SAAS SAFETY EVIDENCE (v1.7.0 — Section 15):                             │
│  🏢 Tenant Isolation Scan in DISCOVERY (multi-tenant projects)            │
│  🌍 TARGET_ENVIRONMENT in FOOTPRINT (S-35 if missing)                    │
│  🔒 Secret scan in DISCOVERY (grep for secret patterns)                  │
│  🔴 Data Classification: T1 Restricted → T4 Public                       │
│  💥 Destructive Op Log + Restore Test Proof (audit trail)                │
│  ⚫ NUCLEAR = HALT → INCIDENT REPORT → 🔑 NUCLEAR RESOLVED             │
│  No PII in reports. No secrets in reports. Anonymize or use doc IDs.     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 12) Hive Mind Evidence Requirements

> **Full specification:** See `shared/NEO-HIVE.md` (index formats + query patterns) and `roles/NEO-ANT.md` DISCOVERY step 0 (Hive Mind Check procedure).
> **Key rule:** Hive Mind Check greps do NOT count against the DISCOVERY evidence budget. Index reads are pre-DISCOVERY and exempt.
> **Ghost validation:** Spot-check at least 2 claims against actual `.neo/index/` files.

---

## 13) Surgical Protocol Evidence (NEO-SURGICAL.md)

> **Full specification:** See `shared/NEO-SURGICAL.md` — 3 Laws (Understanding, Backup, Verify), Anti-Assumption Rules (A-01→A-03), Feature Protection (Section 6b), and Scope Contraction Detection (Section 8).
> **Key sections:** LAW 1 Understanding Proof, LAW 2 Backup Proof, Dry-Run Evidence, Non-Existence Verification, Feature Inventory cross-check, Scope Contraction euphemism patterns.
> **Ghost validation:** Verify Understanding Proof exists before any data change. Cross-check Feature Inventory counts independently. Flag scope contraction euphemisms ("consolidated", "simplified", "refactored").

---

## 14) Nearest Truth Rule (Source Priority Hierarchy)

When an Ant encounters conflicting information from different sources, it MUST follow this priority hierarchy to determine which source is "nearest truth":

### 14.1 Source Priority (FROZEN)

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   NEAREST TRUTH — SOURCE PRIORITY HIERARCHY                                 ║
║                                                                              ║
║   When sources conflict, trust the source CLOSEST TO REALITY:               ║
║                                                                              ║
║   PRIORITY 1 ▶ CODE (actual running code, what the system DOES)             ║
║   PRIORITY 2 ▶ CONFIG / RULES (env files, Firestore rules, package.json)    ║
║   PRIORITY 3 ▶ OPERATOR MANUAL (project documentation in .neo/)            ║
║   PRIORITY 4 ▶ HIVE MIND REPORTS (prior Ant reports, Ghost reviews)        ║
║   PRIORITY 5 ▶ EXTERNAL DOCS (library docs, Stack Overflow, tutorials)     ║
║                                                                              ║
║   Code > Config > Manual > Reports > External                               ║
║                                                                              ║
║   THE CARDINAL RULE:                                                         ║
║   If sources conflict → REPORT THE CONFLICT. Do NOT silently pick a side.   ║
║   The operator decides which source is authoritative.                        ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

### 14.2 Conflict Resolution Protocol

When an Ant finds conflicting information:

```
1. IDENTIFY: Name the conflicting sources explicitly
   → "Code says X (src/auth/login.ts:42) but Operator Manual says Y (Section 4.2)"

2. CITE BOTH: Quote the relevant evidence from each source
   → Code evidence: <exact line/function>
   → Other source evidence: <exact quote/section>

3. STATE PRIORITY: Name which source is higher priority per the hierarchy
   → "Per Nearest Truth Rule, Code (P1) outranks Manual (P3)"

4. REPORT — DO NOT RESOLVE: Present the conflict to operator
   → "⚠️ SOURCE CONFLICT: Code vs Manual — operator decision required"
   → The Ant does NOT silently follow one source over the other

5. WAIT: Operator decides which source is authoritative for THIS task
```

### 14.3 Common Conflict Scenarios

| Conflict | Example | Correct Action |
|----------|---------|----------------|
| Code ≠ Manual | Manual says "voice is disabled" but code has active voice files | REPORT — code is running, manual may be stale |
| Manual ≠ Report | Operator Manual says "use PATCH" but prior Ant report used PUT | REPORT — manual outranks prior report |
| Code ≠ Config | Code reads from collection A but config points to collection B | REPORT — likely a bug, present both |
| Report ≠ Report | Two prior Ant reports give different approaches | REPORT — present both, let operator choose |
| Code ≠ External docs | Code uses deprecated API but it works | DO NOT "fix" — working code outranks external docs |

### 14.4 The Stale Manual Trap

```
⚠️ THE STALE MANUAL TRAP — This is how the Sonny feature deletion happened.

An Ant read a stale Operator Manual that described a feature as "removed"
when the feature was actually live in the codebase with 10+ active files.
The Ant treated the manual as ground truth and deleted the feature.

NEAREST TRUTH RULE prevents this:
→ Code (10 active files, running in production) = PRIORITY 1
→ Operator Manual (may be 7 runs stale) = PRIORITY 3
→ Code outranks Manual. The feature EXISTS because the code says so.
→ If manual contradicts code: REPORT THE CONFLICT. Do not delete.
```

---

## 15) SaaS Safety Evidence (NEO-SURGICAL.md Sections 11-15)

> **Full specification:** See `shared/NEO-SURGICAL.md` Sections 11-15 — Tenant Isolation, Environment Gate, Destructive Operations Registry, Secret Handling, PII Classification.
> **Key gates:** Tenant Isolation Scan (DISCOVERY), TARGET_ENVIRONMENT (FOOTPRINT), 🔑 PRODUCTION CONFIRMED (operator), ⚫ NUCLEAR INCIDENT REPORT (breach).
> **Ghost validation:** Reject if TARGET_ENVIRONMENT missing (S-35). Verify secret scan in DISCOVERY. Reject if PII/secrets appear in report text.

---
