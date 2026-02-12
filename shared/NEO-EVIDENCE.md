# NEO-EVIDENCE v1.3.0
## Evidence Contract — No Claims Without Proof

**Purpose:** Evidence requirements, rejected patterns, validation rules, pheromone system, evidence budget, hive mind context, surgical protocol evidence
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
│  NEO-EVIDENCE v1.3.0 — QUICK REFERENCE                                     │
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
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 12) Hive Mind Evidence Requirements

When an Ant performs a Hive Mind Check (see `NEO-HIVE.md`), the following evidence is required in Section 10: HIVE CONTEXT of the Ant report:

### Required Hive Evidence

| Evidence | Format | Required? |
|----------|--------|-----------|
| Previous tasks on target files | Task IDs from MASTER_INDEX grep output | YES |
| File modification history | Summary from FILE_OWNERSHIP | YES |
| Active pheromones on target files | Pheromone IDs + details from PHEROMONE_REGISTRY | YES (if any) |
| High-traffic flag | "N previous tasks" per file | YES (if > 5) |
| NUCLEAR clearance | Operator clearance logged | YES (if NUCLEAR active) |
| First-run note | "First run — no hive data" | YES (if index empty) |

### Ghost Validation

Ghost MUST verify hive context claims by:
1. Spot-checking at least 2 claims against actual `.neo/index/` files
2. Confirming NUCLEAR pheromones were acknowledged (if applicable)
3. Confirming high-traffic files were flagged (if applicable)

### Evidence Budget Note

Hive Mind Check greps do NOT count against the DISCOVERY evidence budget (Section 10). Index reads are pre-DISCOVERY and are exempt from the anti-drowning protocol.

---

## 13) Surgical Protocol Evidence (NEO-SURGICAL.md)

When tasks involve data operations, the following additional evidence is required.

### 13.1 Understanding Proof (LAW 1)

Before ANY code or data change, the Ant MUST document evidence of understanding:

| Check | Evidence Required |
|-------|-------------------|
| Current behavior | Code paths read + test output showing current state |
| Design intent | Comments, commit history, or operator confirmation |
| Hidden constraints | Guardrails identified in code |
| Blast radius | Affected tenants / data scope at scale |

**If ANY check cannot be evidenced: STOP. Do NOT proceed.**

### 13.2 Backup Proof (LAW 2)

Required when FOOTPRINT contains `DATA_WRITE`, `DATA_DELETE`, `MIGRATION`, `SEED`, or `CONFIG_WRITE`:

| Field | Required Format |
|-------|----------------|
| Timestamp | ISO 8601 |
| Location | Actual path or export location (not placeholder) |
| Scope | What was backed up (collections, files, configs) |
| Restore method | Exact commands/steps to restore |
| Restore verified | YES/NO + how verified |
| Size / record count | Number of records or file size |

**Backup proof is presented to operator BEFORE `🔑 BACKUP APPROVED` token.**

### 13.3 Dry-Run Evidence (Destructive Ops)

Required for `DATA_DELETE`, `MIGRATION`, `SEED`, and any `PUT` (replace) semantics:

| Field | Required Format |
|-------|----------------|
| Environment | Where dry-run was executed (emulator, staging, test tenant) |
| Input dataset | What data existed before |
| Output dataset | What data looked like after |
| Comparison | Expected vs actual (including preserved records) |
| Tenant isolation | Confirmed intact / not applicable |

**Dry-run evidence appears in the Ant's VERIFY section.**

### 13.4 Anti-Assumption Evidence

Ghost checks for assumption patterns — signs that an Ant "fixed" something without understanding it:

| Pattern | Indicates | Ghost Action |
|---------|-----------|-------------|
| "Rebuilt" or "recreated" data | Possible assumption-based destruction | Flag, verify intent was confirmed |
| `setDoc()` without `{ merge: true }` | PUT semantics — may overwrite | Verify justification in FOOTPRINT |
| Missing Understanding Proof | Ant skipped LAW 1 | REJECT |
| "Fixed broken data" without investigation | Anti-Assumption Rule A-01/A-02 violation | REJECT |
| New seed/demo data in report | Possible A-03 violation | Verify original intent was confirmed |

---

## Changelog

### [1.3.0] 2026-02-10
- Section 2: New finding types — backup proof, dry-run result, data op classification, understanding proof
- Section 5: Ant checklist gains 4 surgical checks (understanding, data ops, backup, dry-run)
- Section 5: Ghost checklist gains 4 surgical checks (understanding, backup, anti-assumption, write semantics)
- Section 13: Surgical Protocol Evidence — LAW 1 understanding proof, LAW 2 backup proof, dry-run evidence, anti-assumption detection
- Quick Reference updated with surgical evidence summary
- Cross-reference: All surgical rules defined in `NEO-SURGICAL.md` v1.0.0
- ALL additions are MANUAL ONLY — no automation

### [1.2.0] 2026-02-10
- Section 12: Hive Mind Evidence Requirements — required evidence for Section 10: HIVE CONTEXT
- Hive context claims: previous tasks, file history, active pheromones, high-traffic flags, NUCLEAR clearance
- Ghost validation rules for hive context (spot-check 2 claims)
- Evidence budget exemption for hive mind greps (pre-DISCOVERY)
- ALL additions are MANUAL ONLY — no automation

### [1.1.0] 2026-02-09
- Section 8: Pheromone System — structured warning markers with 5 severity levels
- Section 9: Tenant Isolation Pheromones — TENANT_BOUNDARY, CROSS_TENANT_QUERY (⚫ NUCLEAR), TENANT_CONTEXT (🔴 HIGH), SHARED_COMPONENT (🟠 MEDIUM)
- Section 10: Evidence Budget (Anti-Drowning Protocol) — hard caps per state, two-pass workflow, one-question rule
- Updated Quick Reference with pheromone levels and evidence budget
- ALL additions are MANUAL ONLY — no automation

### [1.0.0] 2026-02-09
- Initial release
- Adapted from IAMBecca IAMBECCA-EVIDENCE.md v1.1.0
- Core evidence doctrine (frozen)
- Rejected patterns (placeholder paths, generic text, fabricated evidence)
- Evidence scoring rubric (5 dimensions)
- Role-specific checklists (Ant, Ghost, Inspector)
- Evidence categories and storage structure
