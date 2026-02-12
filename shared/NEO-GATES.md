# NEO-GATES v1.5.0
## State Machine, Transitions & Approval Tokens

**Purpose:** Defines the NEO pipeline state machine, gate tokens, STOP rules, permission hierarchy, and enforcement doctrine
**Scope:** Loaded by ALL NEO roles (Ant, Ghost, Inspector)

---

## 1) State Machine

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│   NEO MANUAL PIPELINE v1.0.0                                                │
│                                                                             │
│   ┌──────────────┐                                                          │
│   │    START     │ ← Operator provides task packet                          │
│   └──────┬───────┘                                                          │
│          │                                                                  │
│          ▼                                                                  │
│   ┌──────────────┐                                                          │
│   │     LAB      │ ← Optional: 🎨 Color Expert Ant only — experimentation  │
│   │  (optional)  │   No gate. Lab findings feed into DISCOVERY.             │
│   └──────┬───────┘                                                          │
│          │ (no gate — automatic transition)                                 │
│          ▼                                                                  │
│   ┌──────────────┐                                                          │
│   │  DISCOVERY   │ ← Ant reads code, understands current state              │
│   └──────┬───────┘                                                          │
│          │ (operator acknowledges findings)                                 │
│          ▼                                                                  │
│   ┌──────────────┐                                                          │
│   │  FOOTPRINT   │ ← Ant proposes changes + data op classification          │
│   └──────┬───────┘                                                          │
│          │ 🔑 FOOTPRINT APPROVED                                            │
│          ▼                                                                  │
│   ┌──────────────┐                                                          │
│   │   BACKUP     │ ← Conditional: only if DATA_WRITE/DELETE/MIGRATION/SEED  │
│   │  (optional)  │   Ant creates backup, documents proof, gets approval     │
│   └──────┬───────┘                                                          │
│          │ 🔑 BACKUP APPROVED (or skipped for CODE_ONLY / READ_ONLY)        │
│          ▼                                                                  │
│   ┌──────────────┐                                                          │
│   │    PATCH     │ ← Ant applies changes                                    │
│   └──────┬───────┘                                                          │
│          │ 🔑 PATCH APPROVED                                                │
│          ▼                                                                  │
│   ┌──────────────┐                                                          │
│   │   VERIFY     │ ← Ant runs tests, validates                              │
│   └──────┬───────┘                                                          │
│          │ 🔑 VERIFY APPROVED                                               │
│          ▼                                                                  │
│   ┌──────────────┐                                                          │
│   │   REPORT     │ ← Ant writes structured report                           │
│   └──────┬───────┘                                                          │
│          │ 🔑 REPORT APPROVED                                               │
│          ▼                                                                  │
│   ╔══════════════════════════════════════════════════════════════════════╗  │
│   ║                    QUALITY GATE (Non-Negotiable)                     ║  │
│   ╠══════════════════════════════════════════════════════════════════════╣  │
│   ║                                                                      ║  │
│   ║  1. GHOST REVIEW    ← Ghost validates evidence & quality             ║  │
│   ║         │                                                            ║  │
│   ║         ├── 🔑 GHOST APPROVED → continue                            ║  │
│   ║         └── 🔑 GHOST REJECTED → back to Ant                         ║  │
│   ║                                                                      ║  │
│   ║  2. INSPECTOR AUDIT (optional)  ← Inspector checks compliance       ║  │
│   ║         │                                                            ║  │
│   ║         ├── 🔑 INSPECTOR PASS → continue                            ║  │
│   ║         └── 🔑 INSPECTOR FAIL → operator decides                    ║  │
│   ║                                                                      ║  │
│   ╚══════════════════════════════════════════════════════════════════════╝  │
│          │                                                                  │
│          ▼                                                                  │
│   ┌──────────────┐                                                          │
│   │   COMPLETE   │ ← 🔑 TASK COMPLETE                                      │
│   └──────────────┘                                                          │
│                                                                             │
│   Exception:                                                                │
│   • HALTED (requires human intervention)                                    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2) State Ownership

| State | Owner | Actions |
|-------|-------|---------|
| LAB | Ant (🎨 Color Expert only) | Experiment in DevTools/validation surface, produce Lab Proof Pack (optional state, no gate) |
| DISCOVERY | Ant | Read code, understand current state, document findings |
| FOOTPRINT | Ant | Propose changes, data op classification, risk assessment, rollback plan |
| BACKUP | Ant | Create backup, document proof, verify restore (conditional — see NEO-SURGICAL.md) |
| PATCH | Ant | Apply approved changes, show diffs |
| VERIFY | Ant | Run tests, validate, capture evidence |
| REPORT | Ant | Write structured report with all evidence |
| REVIEW | Ghost | Validate evidence, check DoD, quality gate |
| INSPECT | Inspector | Audit for standards compliance, drift detection |
| COMPLETE | Operator | Task is finished, all gates passed |
| HALTED | Operator | Intervention required, pipeline paused |

---

## 3) Approval Token Pattern (FROZEN)

Every gate requires exactly ONE approval token from the operator.

### 3.1 Token Format

```
🔑 <ACTION>: <scope/reason>
```

### 3.2 Valid Tokens

| Token | Issued By | Unlocks |
|-------|-----------|---------|
| `🔑 FOOTPRINT APPROVED` | Operator | PATCH state |
| `🔑 FOOTPRINT APPROVED WITH CHANGES: <changes>` | Operator | PATCH state (with modifications) |
| `🔑 BACKUP APPROVED` | Operator | PATCH state (when data operations present) |
| `🔑 PATCH APPROVED` | Operator | VERIFY state |
| `🔑 VERIFY APPROVED` | Operator | REPORT state |
| `🔑 REPORT APPROVED` | Operator | Ghost REVIEW |
| `🔑 GHOST APPROVED` | Ghost (via operator) | Inspector or COMPLETE |
| `🔑 GHOST REJECTED: <reason>` | Ghost (via operator) | Back to Ant |
| `🔑 INSPECTOR PASS` | Inspector (via operator) | COMPLETE |
| `🔑 INSPECTOR FAIL: <reason>` | Inspector (via operator) | Operator decides |
| `🔑 TASK COMPLETE` | Operator | Pipeline ends |
| `🔑 REJECTED: <reason>` | Any role | Step must be revised |

### 3.3 Token Rules

| Rule | Description |
|------|-------------|
| Prefix required | Must start with `🔑` emoji |
| Human-issued only | Only the operator can issue tokens |
| One per gate | Exactly one token per gate transition |
| No self-approval | An Ant cannot approve its own gate |
| No skipping | Cannot skip gates (e.g., DISCOVERY → PATCH is INVALID) |

---

## 4) Invalid Transitions (BLOCKED)

| Attempt | Rejection |
|---------|-----------|
| Skip FOOTPRINT | `🔑 REJECTED: FOOTPRINT gate is mandatory` |
| Skip BACKUP (when data ops present) | `🔑 REJECTED: BACKUP gate required for data operations (LAW 2)` |
| Skip VERIFY | `🔑 REJECTED: VERIFY gate is mandatory` |
| Skip Ghost REVIEW | `🔑 REJECTED: Ghost review is mandatory` |
| Ant self-approves | `🔑 REJECTED: self-approval not allowed` |
| Proceed without token | `🔑 REJECTED: approval token required` |
| Transition from HALTED | Requires explicit operator restart |

---

## 5) STOP Conditions (Comprehensive)

### 5.1 Global STOP Triggers

| # | Trigger | Action | Severity |
|---|---------|--------|----------|
| S-01 | Missing required input | STOP, request from operator | BLOCKER |
| S-02 | Tests fail after PATCH | STOP, present evidence, offer rollback | HIGH |
| S-03 | Scope creep detected | STOP, log new work as separate task | HIGH |
| S-04 | Security concern found | STOP, flag to operator | HIGH |
| S-05 | Unrecoverable error | Transition to HALTED | BLOCKER |
| S-06 | Evidence validation fails | Ghost issues REJECTED | HIGH |
| S-07 | Cross-tenant query detected | STOP, emit ⚫ NUCLEAR pheromone | ⚫ NUCLEAR |
| S-08 | Tenant isolation breach | STOP, emit ⚫ NUCLEAR pheromone | ⚫ NUCLEAR |
| S-09 | Permission escalation attempted | STOP, flag unauthorized elevation | HIGH |
| S-10 | Environment mismatch | STOP, verify correct env before continuing | HIGH |
| S-11 | Race condition risk identified | STOP, document concurrent access risk | MEDIUM |
| S-12 | Hardcoded secrets found | STOP, flag credential exposure | ⚫ NUCLEAR |
| S-13 | Critical surface edit without override | STOP, request CRITICAL SURFACE OVERRIDE | HIGH |
| S-14 | Evidence budget exceeded | STOP, request DISCOVERY EXPANSION APPROVED | MEDIUM |
| S-15 | Build breaks after PATCH | STOP, present build output, offer rollback | HIGH |
| S-16 | Dependency vulnerability found | STOP, flag for security review | MEDIUM |
| S-17 | Data deletion operation proposed | STOP, require explicit confirmation | HIGH |
| S-18 | *(reserved)* | | |
| S-19 | Data looks "incomplete" or "wrong" | STOP — investigate intent, do NOT fix on assumption (LAW 1) | HIGH |
| S-20 | Urge to "recreate" or "rebuild" data | STOP — this is the #1 failure mode. Investigate first (LAW 1) | HIGH |
| S-21 | Seed/demo function found in live path | STOP — flag demo/live mixing as RED FLAG (LAW 3) | HIGH |
| S-22 | Batch update/overwrite without PATCH semantics | STOP — justify why PATCH is insufficient (LAW 3) | HIGH |
| S-23 | Backup not created before data operation | STOP — LAW 2 violation, create backup first | BLOCKER |
| S-24 | PUT semantics used without justification | STOP — default is PATCH (merge), justify replacement (LAW 3) | MEDIUM |
| S-25 | File path outside PROJECT LOCK root | STOP — request `🔑 CROSS-PROJECT READ` if read needed, WRITE is NEVER allowed | BLOCKER |
| S-26 | Checkpoint not created before DISCOVERY | STOP — CHECKPOINT FIRST is mandatory for every Ant (no exceptions) | BLOCKER |
| S-27 | Target file outside task SCOPE BOUNDARY | STOP — request scope expansion from operator before proceeding | HIGH |
| S-28 | Working on wrong project's files | STOP — PROJECT LOCK violation. Verify project root immediately | BLOCKER |

### 5.2 HALTED State

When a task enters HALTED:
1. No further progress of any kind
2. Operator must explicitly restart or abort
3. Options: resume, rollback, or abandon
4. **HALTED requires explicit 🔑 CONTINUE or 🔑 GO to resume**

---

## 6) Gate Log (Audit Trail)

Every task MUST maintain a gate log tracking all tokens:

```markdown
## GATE LOG

| Gate | Token | Issued By | Timestamp |
|------|-------|-----------|-----------|
| FOOTPRINT | 🔑 FOOTPRINT APPROVED | Operator | <ISO> |
| BACKUP | 🔑 BACKUP APPROVED | Operator | <ISO> |
| PATCH | 🔑 PATCH APPROVED | Operator | <ISO> |
| VERIFY | 🔑 VERIFY APPROVED | Operator | <ISO> |
| REPORT | 🔑 REPORT APPROVED | Operator | <ISO> |
| GHOST | 🔑 GHOST APPROVED | Ghost/Operator | <ISO> |
| INSPECTOR | 🔑 INSPECTOR PASS | Inspector/Operator | <ISO> |
```

**This gate log is included in the Ant's final report and enables audit of the full token trail.**

---

## 8) Risk-Based Gate Behavior

Gate behavior varies based on the task's **Ant Type risk level**. See `roles/NEO-ANT.md` for the full 12-type taxonomy.

### 8.1 Risk Levels

| Level | Color | Ant Types | Additional Gate Requirements |
|-------|-------|-----------|------------------------------|
| 🔴 **HIGH** | Red | 🔥 Fire Ant, 💵 Financial Ant, 🎨 Color Expert Ant | Extra scrutiny at every gate (see 8.2) |
| 🟠 **MEDIUM** | Orange | 🛡️ Soldier Ant | Validation testing at VERIFY (see 8.3) |
| 🟡 **STANDARD** | Yellow | 🛠️ Carpenter, 🧰 Toolbox, 📊 Harvester | Normal gate workflow |
| 🟢 **LOW** | Green | 📈 Analyst, 🚁 Scout, 🌿 Leafcutter, 👔 Board, 🤝 Advisor, 📞 Support | Normal gate workflow |

### 8.2 HIGH Risk Gate Requirements (🔴)

| Gate | Additional Requirement |
|------|----------------------|
| FOOTPRINT | Must include security/payment **impact assessment** — what could go wrong, blast radius, data exposure risk |
| PATCH | Operator should review diffs **line-by-line** — no rubber-stamping |
| VERIFY | Must include **domain-specific tests** (auth flow tests, payment flow tests, permission tests) |
| GHOST REVIEW | Ghost must verify **risk mitigations are adequate** — Section 4b risk checks mandatory |

### 8.3 MEDIUM Risk Gate Requirements (🟠)

| Gate | Additional Requirement |
|------|----------------------|
| FOOTPRINT | Must include **edge-case plan** for validation scenarios |
| VERIFY | Must include **edge-case validation tests** (empty input, boundary values, bypass attempts) |
| GHOST REVIEW | Ghost must check for **bypass scenarios** — Section 4b risk checks mandatory |

### 8.4 STANDARD / LOW Risk Gate Requirements (🟡🟢)

Normal gate workflow. No additional requirements beyond the standard process.

---

## 9) ⚫ NUCLEAR Severity (FROZEN)

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ⚫ NUCLEAR — THE BLACK DOT                                                 ║
║                                                                              ║
║   Severity ABOVE CRITICAL. NO override available.                            ║
║   Task is BLOCKED until operator completes security review.                  ║
║                                                                              ║
║   NUCLEAR = tenant isolation breach, cross-tenant data access,               ║
║   security boundary violation, credential exposure.                          ║
║                                                                              ║
║   When NUCLEAR is detected:                                                  ║
║   1. STOP IMMEDIATELY — no further execution                                 ║
║   2. Emit ⚫ NUCLEAR pheromone (see NEO-EVIDENCE.md)                        ║
║   3. Operator MUST resolve before ANY pipeline progress                      ║
║   4. There is NO token that bypasses NUCLEAR                                 ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

### 9.1 NUCLEAR Triggers

| Trigger | Category | Example |
|---------|----------|---------|
| Cross-tenant data access | DATA | Query reads tenant B's data from tenant A context |
| Tenant isolation breach | ISOLATION | Shared state leaks between tenants |
| Credential exposure | SECURITY | API keys, tokens, secrets in code or logs |
| Security boundary bypass | AUTH | Auth/permission check bypassed or removed |
| Data deletion without safeguard | DATA | Bulk delete without confirmation or backup |
| Production environment contamination | INFRA | Test data in prod, prod data in test |

### 9.2 NUCLEAR Response Protocol

```
1. STOP — All work ceases immediately
2. DOCUMENT — Record exactly what was found (file, line, evidence)
3. EMIT — Log ⚫ NUCLEAR pheromone in report
4. WAIT — Only operator can resolve
5. NO WORKAROUND — There is no "read-only exception" for NUCLEAR
```

---

## 10) STOP MEANS STOP Doctrine (FROZEN)

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   STOP MEANS STOP                                                            ║
║                                                                              ║
║   When a STOP condition is triggered:                                        ║
║   • "Acknowledge and continue" = NON-COMPLIANT                               ║
║   • "I see the issue but will proceed" = NON-COMPLIANT                       ║
║   • "Noted, moving on" = NON-COMPLIANT                                       ║
║                                                                              ║
║   The ONLY way past a STOP:                                                  ║
║   • 🔑 CONTINUE — Operator explicitly clears the STOP                       ║
║   • 🔑 GO — Operator explicitly clears the STOP                             ║
║   • 🔑 <GATE> APPROVED — Operator approves the specific gate                ║
║                                                                              ║
║   There is NO "read-only exception."                                         ║
║   There is NO implicit approval.                                             ║
║   Silence ≠ approval. Acknowledgment ≠ approval.                            ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## 11) Permission Hierarchy (FROZEN)

Every Ant starts at **Level 0**. Escalation requires explicit operator tokens.

| Level | Name | Allowed Actions | Requires Token |
|-------|------|-----------------|----------------|
| **L0** | THINK ONLY | Read task packet, plan approach, ask questions | *(start state)* |
| **L1** | READ + VERIFY | Read files, run tests, run lint/type checks, capture evidence | `🔑 DISCOVERY APPROVED` |
| **L2** | WRITE + CHANGE | Edit files, create files, apply patches, commit | `🔑 FOOTPRINT APPROVED` then `🔑 PATCH APPROVED` |
| **L3** | FORBIDDEN | Force-push, delete branches, deploy to prod, modify security rules | **NEVER — no token exists** |

### 11.1 Permission Rules

| Rule | Description |
|------|-------------|
| Start at L0 | Every new task begins at THINK ONLY |
| No skip | Cannot jump from L0 to L2. Must escalate through L1 |
| Token per level | Each escalation requires its own operator token |
| Revocation | Operator can revoke permissions at any time with `🔑 STOP` |
| L3 is absolute | No token, no override, no exception bypasses L3 |

---

## 12) Critical Surfaces

**Critical surfaces** are files/areas that require extra authorization before modification. Editing a critical surface without a `🔑 CRITICAL SURFACE OVERRIDE` token is a **violation**.

### 12.1 Critical Surface Categories (Operator Defines Per Project)

| Category | Examples | Why Critical |
|----------|----------|-------------|
| **Auth / Security** | Auth rules, permission configs, session handling | Access control |
| **Data Layer** | Database schemas, migration files, ORM configs | Data integrity |
| **Deploy / Infra** | CI/CD configs, deploy scripts, Docker files | Production safety |
| **Environment** | .env files, secrets configs, API key stores | Credential safety |
| **Tenant Isolation** | Multi-tenant boundary files, data partitioning | Tenant safety |

### 12.2 Critical Surface Override Protocol

```
1. Ant identifies a critical surface in FOOTPRINT
2. Ant flags it: "⚠️ CRITICAL SURFACE: <file path>"
3. Operator reviews and issues: 🔑 CRITICAL SURFACE OVERRIDE: <file path>
4. Override is SINGLE-USE — one file, one task
5. Override does NOT carry to other files or tasks
```

### 12.3 Critical Surface Rules

| Rule | Description |
|------|-------------|
| Single file | Override covers exactly ONE file |
| Single task | Override is valid for current task only |
| Must be flagged | Ant MUST flag critical surfaces in FOOTPRINT |
| No silent edits | Editing a critical surface without override = VIOLATION |
| Ghost verifies | Ghost checks that overrides were obtained for all critical surface edits |

---

## 13) Guardian Control Words (Complete Token Vocabulary)

All tokens require the 🔑 prefix. All tokens are **human-issued only**.

### 13.1 Pipeline Gate Tokens

| Token | Issued By | Unlocks | Notes |
|-------|-----------|---------|-------|
| `🔑 DISCOVERY APPROVED` | Operator | L1 permissions (read + verify) | New in v1.2.0 |
| `🔑 DISCOVERY EXPANSION APPROVED` | Operator | Extended DISCOVERY budget | When Ant needs more reads |
| `🔑 FOOTPRINT APPROVED` | Operator | PATCH state | |
| `🔑 FOOTPRINT APPROVED WITH CHANGES: <changes>` | Operator | PATCH state (modified) | |
| `🔑 BACKUP APPROVED` | Operator | PATCH state (data ops) | Conditional — see NEO-SURGICAL.md |
| `🔑 PATCH APPROVED` | Operator | VERIFY state | |
| `🔑 VERIFY APPROVED` | Operator | REPORT state | |
| `🔑 REPORT APPROVED` | Operator | Ghost REVIEW | |
| `🔑 GHOST APPROVED` | Ghost/Operator | Inspector or COMPLETE | |
| `🔑 GHOST REJECTED: <reason>` | Ghost/Operator | Back to Ant | |
| `🔑 INSPECTOR PASS` | Inspector/Operator | COMPLETE | |
| `🔑 INSPECTOR FAIL: <reason>` | Inspector/Operator | Operator decides | |
| `🔑 TASK COMPLETE` | Operator | Pipeline ends | |

### 13.2 Override Tokens

| Token | Issued By | Purpose |
|-------|-----------|---------|
| `🔑 CRITICAL SURFACE OVERRIDE: <file>` | Operator | Allow editing a critical surface |
| `🔑 WIPE OVERRIDE: <collection>` | Operator | Allow collection overwrite (see NEO-SURGICAL.md Section 6) |
| `🔑 BRANCH_PROTECTION_BYPASS APPROVED` | Operator | Allow pushing to protected branch |
| `🔑 CONTINUE` | Operator | Clear a STOP condition |
| `🔑 GO` | Operator | Clear a STOP condition (alias) |
| `🔑 ROLLBACK` | Operator | Revert changes to pre-patch state |
| `🔑 STOP` | Operator | Halt all pipeline activity |

### 13.3 Rejection Tokens

| Token | Issued By | Effect |
|-------|-----------|--------|
| `🔑 REJECTED: <reason>` | Any role | Step must be revised |
| `🔑 GHOST REJECTED: <reason>` | Ghost | Back to Ant |
| `🔑 GHOST CHANGES REQUESTED: <list>` | Ghost | Back to Ant for specific fixes |
| `🔑 INSPECTOR FAIL: <reason>` | Inspector | Operator decides |

---

## 14) Violations Warning Box (FROZEN)

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ⚠️  VIOLATIONS — Any of these = AUTOMATIC REJECTION                       ║
║                                                                              ║
║   V-01  GATE SKIPPING                                                        ║
║         Attempting to skip a gate (e.g., DISCOVERY → PATCH)                  ║
║                                                                              ║
║   V-02  BUDGET CONTINUE                                                      ║
║         Exceeding evidence budget without 🔑 DISCOVERY EXPANSION APPROVED    ║
║                                                                              ║
║   V-03  READ-ONLY EXCEPTION                                                  ║
║         Claiming "this is read-only so I can continue past STOP"             ║
║                                                                              ║
║   V-04  TOKEN FABRICATION                                                    ║
║         Self-issuing a 🔑 token (e.g., Ant approving own gate)              ║
║                                                                              ║
║   V-05  MULTI-GATE MESSAGE                                                   ║
║         Approving more than one gate in a single message                     ║
║                                                                              ║
║   V-06  ACKNOWLEDGE AND CONTINUE                                             ║
║         Treating "I see the issue" as clearance to proceed                   ║
║                                                                              ║
║   V-07  WRONG PREFIX                                                         ║
║         Using approval language without the 🔑 prefix                       ║
║                                                                              ║
║   V-08  CRITICAL SURFACE EDIT WITHOUT OVERRIDE                               ║
║         Editing a critical surface file without CRITICAL SURFACE OVERRIDE    ║
║                                                                              ║
║   V-09  BACKUP SKIP                                                          ║
║         Data operation (WRITE/DELETE/MIGRATION/SEED) without backup          ║
║                                                                              ║
║   V-10  PROJECT LOCK VIOLATION                                               ║
║         Reading or writing files outside the locked project root             ║
║         WRITE outside lock = AUTOMATIC REJECTION + COMPLIANCE FAIL           ║
║                                                                              ║
║   RESPONSE: Ghost flags. Inspector audits. Operator arbitrates.              ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## 7) Quick Reference

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  NEO-GATES v1.5.0 — QUICK REFERENCE                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  PIPELINE:                                                                  │
│  [LAB] → DISCOVERY → FOOTPRINT → [BACKUP] → PATCH → VERIFY → REPORT →    │
│  GHOST → [INSPECTOR] → COMPLETE                                            │
│                                                                             │
│  LAB state is OPTIONAL — only for 🎨 Color Expert Ant. No gate.            │
│  BACKUP gate is CONDITIONAL — only when data ops present.                   │
│  CODE_ONLY / READ_ONLY tasks skip BACKUP and go straight to PATCH.         │
│                                                                             │
│  GATES (all human-issued):                                                  │
│  🔑 DISCOVERY APPROVED     → unlocks L1 (read + verify)                    │
│  🔑 FOOTPRINT APPROVED     → unlocks BACKUP or PATCH                       │
│  🔑 BACKUP APPROVED        → unlocks PATCH (data ops only)                 │
│  🔑 PATCH APPROVED         → unlocks VERIFY                                │
│  🔑 VERIFY APPROVED        → unlocks REPORT                                │
│  🔑 REPORT APPROVED        → unlocks Ghost REVIEW                          │
│  🔑 GHOST APPROVED         → unlocks Inspector or COMPLETE                 │
│  🔑 INSPECTOR PASS         → unlocks COMPLETE                              │
│  🔑 TASK COMPLETE           → pipeline ends                                 │
│                                                                             │
│  OVERRIDES:                                                                 │
│  🔑 CRITICAL SURFACE OVERRIDE: <file>                                      │
│  🔑 WIPE OVERRIDE: <collection>                                            │
│  🔑 DISCOVERY EXPANSION APPROVED                                           │
│  🔑 CONTINUE / GO / ROLLBACK / STOP                                        │
│                                                                             │
│  ⚫ NUCLEAR (ABOVE CRITICAL):                                               │
│  Tenant isolation breach, cross-tenant data, credential exposure            │
│  NO override. NO token. Task BLOCKED until security review.                 │
│                                                                             │
│  PERMISSION HIERARCHY:                                                      │
│  L0 THINK ONLY → L1 READ+VERIFY → L2 WRITE+CHANGE → L3 FORBIDDEN          │
│                                                                             │
│  STOP MEANS STOP:                                                           │
│  "Acknowledge and continue" = NON-COMPLIANT                                 │
│  Only 🔑 CONTINUE or 🔑 GO clears a STOP                                  │
│                                                                             │
│  VIOLATIONS (auto-reject):                                                  │
│  V-01 Gate skipping    V-02 Budget continue    V-03 Read-only exception     │
│  V-04 Token fabrication V-05 Multi-gate msg    V-06 Acknowledge+continue    │
│  V-07 Wrong prefix     V-08 Critical surface   V-09 Backup skip             │
│  V-10 Project lock violation (file outside locked root)                     │
│                                                                             │
│  RISK-BASED GATES:                                                          │
│  🔴 HIGH (🔥💵):  Impact assessment + domain tests + line-by-line review   │
│  🟠 MEDIUM (🛡️):  Edge-case plan + validation tests                       │
│  🟡🟢 STD/LOW:    Normal gate workflow                                     │
│                                                                             │
│  SURGICAL PROTOCOL (NEO-SURGICAL.md):                                       │
│  LAW 1 NO-GUESS — prove understanding before changing anything              │
│  LAW 2 BACKUP — backup required before data ops (BACKUP gate)              │
│  LAW 3 SURGICAL — minimum delta, PATCH default, no rebuilds                │
│  S-19→S-24: assumption, rebuild, seed/live, PUT stops                      │
│  S-25→S-28: project lock, checkpoint, scope boundary, wrong project        │
│                                                                             │
│  PROJECT LOCK (NEO-BECCA.md):                                               │
│  BECCA locks project root during RECON — ALL work stays within that path    │
│  V-10 = file access outside locked root → AUTOMATIC REJECTION               │
│  🔑 CROSS-PROJECT READ for read exceptions — WRITE is NEVER allowed        │
│                                                                             │
│  CHECKPOINT FIRST (NEO-ANT.md):                                             │
│  Every Ant creates git checkpoint before ANY work — no exceptions           │
│  S-25 outside lock | S-26 no checkpoint | S-27 outside scope | S-28 wrong  │
│                                                                             │
│  RULES:                                                                     │
│  • No self-approval                                                         │
│  • No skipping gates                                                        │
│  • No auto-approvals                                                        │
│  • Default is STOP and wait                                                 │
│  • Silence ≠ approval                                                       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Changelog

### [1.5.0] 2026-02-11
- PROJECT LOCK enforcement: S-25 (outside lock), S-26 (no checkpoint), S-27 (outside scope), S-28 (wrong project)
- V-10 PROJECT LOCK VIOLATION: file access outside locked project root — auto-reject + compliance fail
- Quick Reference: PROJECT LOCK + CHECKPOINT FIRST sections added
- Quick Reference: S-25→S-28 range added, V-10 added to violations list
- Cross-reference: PROJECT LOCK defined in NEO-BECCA.md v1.7.0, CHECKPOINT defined in NEO-ANT.md v1.9.0
- ALL additions are MANUAL ONLY — no automation

### [1.4.0] 2026-02-11
- LAB state added to pipeline (optional, before DISCOVERY, 🎨 Color Expert Ant only)
- LAB has NO gate — it's experimentation, not committed work
- LAB output (Lab Proof Pack) feeds into DISCOVERY as evidence
- State Ownership table: LAB row added
- Pipeline diagram updated with LAB
- Section 8.1 Risk Levels: Color Expert Ant added to 🔴 HIGH
- Quick Reference updated with LAB state and Color Expert
- ALL additions are MANUAL ONLY — no automation

### [1.3.0] 2026-02-10
- Section 1: BACKUP state added to pipeline (conditional, between FOOTPRINT and PATCH)
- Section 2: BACKUP state ownership (Ant, create+document+verify backup)
- Section 3.2: `🔑 BACKUP APPROVED` token added
- Section 4: Skip BACKUP invalid transition (when data ops present)
- Section 5: STOP conditions S-19 → S-24 added (surgical protocol)
- Section 6: BACKUP row added to gate log
- Section 13.1: `🔑 BACKUP APPROVED` in pipeline tokens
- Section 13.2: `🔑 WIPE OVERRIDE: <collection>` in override tokens
- Section 14: V-09 BACKUP SKIP violation added
- Quick Reference updated with BACKUP gate, WIPE OVERRIDE, surgical protocol summary
- Cross-reference: All surgical rules defined in `NEO-SURGICAL.md` v1.0.0
- ALL additions are MANUAL ONLY — no automation

### [1.2.0] 2026-02-09
- Section 9: ⚫ NUCLEAR Severity (FROZEN) — above CRITICAL, no override, task BLOCKED
- Section 10: STOP MEANS STOP Doctrine (FROZEN) — acknowledge+continue = NON-COMPLIANT
- Section 11: Permission Hierarchy (L0-L3) — THINK ONLY → READ+VERIFY → WRITE+CHANGE → FORBIDDEN
- Section 12: Critical Surfaces — protected files require CRITICAL SURFACE OVERRIDE token
- Section 13: Guardian Control Words — complete token vocabulary (pipeline + override + rejection)
- Section 14: Violations Warning Box (FROZEN) — 8 named violations that auto-reject
- Section 5 expanded: 17 STOP conditions (up from 6) with severity ratings including ⚫ NUCLEAR
- New tokens: DISCOVERY APPROVED, DISCOVERY EXPANSION APPROVED, CRITICAL SURFACE OVERRIDE, CONTINUE, GO, ROLLBACK
- Quick Reference updated with all new systems
- ALL additions are MANUAL ONLY — no automation

### [1.1.0] 2026-02-09
- Added Section 8: Risk-Based Gate Behavior
- 4 risk levels (HIGH, MEDIUM, STANDARD, LOW) tied to 12 Ant Types
- HIGH risk gates require impact assessment, line-by-line review, domain tests
- MEDIUM risk gates require edge-case plan and validation tests
- Ghost review validates risk-specific requirements (Section 4b)
- Updated Quick Reference with risk-based gate summary

### [1.0.0] 2026-02-09
- Initial release
- Adapted from IAMBecca IAMBECCA-GATES.md v1.7.0
- Simplified to 3-role pipeline (Ant, Ghost, Inspector)
- 7 gate tokens, all human-issued
- Removed automation mode — manual-only
- Gate log for audit trail
- HALTED state for human intervention
